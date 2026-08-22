" @keywords planningcalendar planning calendar sap.m planningcalendaroneline vbox title togglebutton overflowtoolbarlayoutdata badgecustomdata select planningcalendarrow
" @summary PlanningCalendar showing appointment with only title in one line to save space. The interval headers are only shown if there are some assigned in the visible area.
CLASS z2ui5_cl_smpc_app_539 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_appointment,
             start_at  TYPE string,
             end_at    TYPE string,
             title     TYPE string,
             info      TYPE string,
             type      TYPE string,
             pic       TYPE string,
             tentative TYPE abap_bool,
           END OF ty_s_appointment.
    TYPES ty_t_appointment TYPE STANDARD TABLE OF ty_s_appointment WITH EMPTY KEY.
    TYPES: BEGIN OF ty_s_header,
             start_at TYPE string,
             end_at   TYPE string,
             title    TYPE string,
             type     TYPE string,
             pic      TYPE string,
           END OF ty_s_header.
    TYPES ty_t_header TYPE STANDARD TABLE OF ty_s_header WITH EMPTY KEY.
    TYPES: BEGIN OF ty_s_person,
             pic            TYPE string,
             name           TYPE string,
             role           TYPE string,
             t_appointments TYPE ty_t_appointment,
             t_headers      TYPE ty_t_header,
           END OF ty_s_person.
    DATA t_people TYPE STANDARD TABLE OF ty_s_person WITH EMPTY KEY.

    DATA start_date     TYPE string.
    DATA multi_select   TYPE abap_bool.
    DATA badge_value    TYPE string.
    DATA multi_tooltip  TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_539 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " calendar date properties are typed "object" and demand a real JS Date;
    " the model keeps ISO strings and Formatter.DateCreateObject converts them
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:core`    v = `sap.ui.core`
        )->a( n = `xmlns:mvc`     v = `sap.ui.core.mvc`
        )->a( n = `xmlns:unified` v = `sap.ui.unified`
        )->a( n = `xmlns`         v = `sap.m`
        )->a( n = `core:require`  v = `{Formatter: 'z2ui5/model/formatter'}`

        )->ele( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->ele( `PlanningCalendar`
                )->a( n = `id`                            v = `PC1`
                )->a( n = `stickyHeader`                  v = `true`
                )->a( n = `showIntervalHeaders`           v = `true`
                )->a( n = `showEmptyIntervalHeaders`      v = `false`
                )->a( n = `appointmentHeight`             v = `Automatic`
                )->a( n = `startDate`                     v = |\{ path: '{ client->_bind( val = start_date path = abap_true ) }', formatter: 'Formatter.DateCreateObject' \}|
                )->a( n = `rows`                          v = client->_bind( t_people )
                )->a( n = `appointmentsVisualization`     v = `Filled`
                " onPress flips setMultipleAppointmentsSelection; the property is
                " bindable, so the ToggleButton and the calendar share the flag
                )->a( n = `multipleAppointmentsSelection` v = client->_bind( multi_select )
                )->a( n = `appointmentSelect`             v = client->_event(
                          val   = `APPT_SELECT`
                          t_arg = VALUE #(
                            ( `${$parameters>/appointment} ? ${$parameters>/appointment}.getTitle() : ''` )
                            ( `${$parameters>/appointment} ? ${$parameters>/appointment}.getSelected() : false` )
                            ( `$event.oSource.getSelectedAppointments().length` )
                            ( `${$parameters>/appointments} ? ${$parameters>/appointments}.length : 0` ) ) )
                )->a( n = `intervalSelect`                v = client->_event(
                          val   = `INTERVAL_SELECT`
                          t_arg = VALUE #(
                            ( `${$parameters>/startDate}.getFullYear()` )
                            ( `${$parameters>/startDate}.getMonth() + 1` )
                            ( `${$parameters>/startDate}.getDate()` )
                            ( `${$parameters>/startDate}.getHours()` )
                            ( `${$parameters>/startDate}.getMinutes()` )
                            ( `${$parameters>/endDate}.getFullYear()` )
                            ( `${$parameters>/endDate}.getMonth() + 1` )
                            ( `${$parameters>/endDate}.getDate()` )
                            ( `${$parameters>/endDate}.getHours()` )
                            ( `${$parameters>/endDate}.getMinutes()` )
                            ( `${$parameters>/row} ? $event.oSource.indexOfRow(${$parameters>/row}) : -1` )
                            ( `$event.oSource.getSelectedRows().map(function(r){return $event.oSource.indexOfRow(r);}).join(',')` ) ) )

                )->ele( `toolbarContent`
                    )->tag( `Title`
                        )->a( n = `text`       v = `Title`
                        )->a( n = `titleStyle` v = `H4`

                    )->ele( `ToggleButton`
                        )->a( n = `id`      v = `MultiSelect`
                        )->a( n = `icon`    v = `sap-icon://select-appointments`
                        " onPress also swaps the tooltip between the two texts
                        )->a( n = `tooltip` v = client->_bind( multi_tooltip )
                        )->a( n = `pressed` v = client->_bind( multi_select )

                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `priority` v = `NeverOverflow`

                        )->end(
                        )->ele( `customData`
                            " handleAppointmentSelect writes the selected count into
                            " the badge; the value is bound instead of set
                            )->tag( `BadgeCustomData`
                                )->a( n = `key`   v = `badge`
                                )->a( n = `value` v = client->_bind( badge_value )

                        )->end(
                    )->end(

                    )->ele( `Select`
                        )->a( n = `change` v = client->_event(
                                  val   = `SORT_CHANGE`
                                  t_arg = VALUE #( ( `${$parameters>/selectedItem}.getKey()` ) ) )
                        )->a( n = `width`  v = `230px`

                        )->ele( `items`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `default`
                                )->a( n = `text` v = `Default Appointments Sort`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `custom`
                                )->a( n = `text` v = `Alphabetical Appointments Sort`

                        )->end(
                    )->end(
                )->end(

                )->ele( `rows`
                    )->ele( `PlanningCalendarRow`
                        )->a( n = `icon`            v = `{PIC}`
                        )->a( n = `title`           v = `{NAME}`
                        )->a( n = `text`            v = `{ROLE}`
                        )->a( n = `appointments`    v = `{path: 'T_APPOINTMENTS', templateShareable: false}`
                        )->a( n = `intervalHeaders` v = `{path: 'T_HEADERS', templateShareable: false}`

                        )->ele( `appointments`
                            )->tag( n = `CalendarAppointment` ns = `unified`
                                )->a( n = `startDate` v = `{ path: 'START_AT', formatter: 'Formatter.DateCreateObject' }`
                                )->a( n = `endDate`   v = `{ path: 'END_AT', formatter: 'Formatter.DateCreateObject' }`
                                )->a( n = `icon`      v = `{PIC}`
                                )->a( n = `title`     v = `{TITLE}`
                                )->a( n = `text`      v = `{INFO}`
                                )->a( n = `type`      v = `{TYPE}`
                                )->a( n = `tentative` v = `{TENTATIVE}`

                        )->end(
                        )->ele( `intervalHeaders`
                            )->tag( n = `CalendarAppointment` ns = `unified`
                                )->a( n = `startDate` v = `{ path: 'START_AT', formatter: 'Formatter.DateCreateObject' }`
                                )->a( n = `endDate`   v = `{ path: 'END_AT', formatter: 'Formatter.DateCreateObject' }`
                                )->a( n = `icon`      v = `{PIC}`
                                )->a( n = `title`     v = `{TITLE}`
                                )->a( n = `type`      v = `{TYPE}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `APPT_SELECT`.
        " the selected count also feeds the ToggleButton's badge
        badge_value = client->get_event_arg( 3 ).
        DATA(appt_title) = client->get_event_arg( ).
        IF appt_title IS NOT INITIAL.
          DATA(selected) = COND string( WHEN client->get_event_arg( 2 ) = abap_true
                                        THEN `selected`
                                        ELSE `deselected` ).
          client->message_box_display(
              text = |'{ appt_title }' { selected }. \n Selected appointments: { client->get_event_arg( 3 ) }|
              type = `show` ).
        ELSE.
          client->message_box_display( text = |{ client->get_event_arg( 4 ) } Appointments selected|
                                       type = `show` ).
        ENDIF.

      WHEN `INTERVAL_SELECT`.
        DATA(iso_start) = |{ client->get_event_arg( ) }-{ CONV i( client->get_event_arg( 2 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
                          |-{ CONV i( client->get_event_arg( 3 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
                          |T{ CONV i( client->get_event_arg( 4 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
                          |:{ CONV i( client->get_event_arg( 5 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }:00|.
        DATA(iso_end) = |{ client->get_event_arg( 6 ) }-{ CONV i( client->get_event_arg( 7 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
                        |-{ CONV i( client->get_event_arg( 8 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
                        |T{ CONV i( client->get_event_arg( 9 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
                        |:{ CONV i( client->get_event_arg( 10 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }:00|.
        DATA(appointment) = VALUE ty_s_appointment( start_at = iso_start
                                                    end_at   = iso_end
                                                    title    = `new appointment`
                                                    type     = `Type09` ).
        DATA(row_index) = CONV i( client->get_event_arg( 11 ) ).
        DATA(rows) = VALUE string_table( ).
        IF row_index >= 0.
          APPEND |{ row_index }| TO rows.
        ELSEIF client->get_event_arg( 12 ) IS NOT INITIAL.
          SPLIT client->get_event_arg( 12 ) AT `,` INTO TABLE rows.
        ENDIF.
        " the row is addressed through a field symbol, not a table expression:
        " abaplint's downport leaves an itab[ ] TARGET of INSERT/DELETE in
        " place, and the 702 parser rejects it
        LOOP AT rows INTO DATA(index).
          READ TABLE t_people INDEX CONV i( index ) + 1 ASSIGNING FIELD-SYMBOL(<person>).
          IF sy-subrc = 0.
            INSERT appointment INTO TABLE <person>-t_appointments.
          ENDIF.
        ENDLOOP.

      WHEN `SORT_CHANGE`.
        " handleSortChange hands the calendar a JS comparator; ABAP sorts the
        " rows themselves instead (see sidecar)
        IF client->get_event_arg( ) = `custom`.
          LOOP AT t_people ASSIGNING FIELD-SYMBOL(<row>).
            SORT <row>-t_appointments BY title AS TEXT.
          ENDLOOP.
        ELSE.
          model_init( ).
        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    start_date    = `2017-03-08T08:00:00`.
    multi_select  = abap_false.
    badge_value   = `0`.
    multi_tooltip = `Enable multiple appointments selection`.

    t_people = VALUE #(
      ( pic = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/John_Miller.png` name = `John Miller` role = `team member`
        t_appointments = VALUE #(
          ( start_at = `2017-03-07T18:00:00` end_at = `2017-03-07T19:10:00` title = `Discussion of the plan` info = `Online meeting` type = `Type04` tentative = abap_false )
          ( start_at = `2017-03-07T14:00:00` end_at = `2017-03-07T15:15:00` title = `Department meeting` type = `Type04` tentative = abap_false )
          ( start_at = `2017-03-03T10:00:00` end_at = `2017-03-07T12:00:00` title = `Workshop out of the country` type = `Type07` pic = `sap-icon://sap-ui5` tentative = abap_false )
          ( start_at = `2017-03-08T09:00:00` end_at = `2017-03-08T11:00:00` title = `Team meeting` info = `room 105` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false )
          ( start_at = `2017-03-08T09:30:00` end_at = `2017-03-08T11:30:00` title = `Meeting with Max` type = `Type02` pic = `sap-icon://sap-ui5` tentative = abap_false )
          ( start_at = `2017-03-08T11:00:00` end_at = `2017-03-08T13:00:00` title = `Lunch` type = `Type03` tentative = abap_true )
          ( start_at = `2017-03-08T11:00:00` end_at = `2017-03-08T13:00:00` title = `Meeting with the crew` type = `Type04` tentative = abap_false )
          ( start_at = `2017-03-09T09:00:00` end_at = `2017-03-09T16:00:00` title = `Busy` type = `Type08` tentative = abap_false )
          ( start_at = `2017-03-10T09:00:00` end_at = `2017-03-10T11:00:00` title = `Team meeting` info = `room 105` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false )
          ( start_at = `2017-03-10T09:30:00` end_at = `2017-03-10T16:30:00` title = `Meeting with Max` type = `Type02` tentative = abap_false )
          ( start_at = `2017-03-11T00:00:00` end_at = `2017-03-13T23:59:00` title = `Vacation` info = `out of office` type = `Type04` tentative = abap_false )
          ( start_at = `2017-03-16T00:30:00` end_at = `2017-03-16T23:30:00` title = `New Colleague` info = `room 115` type = `Type10` tentative = abap_true )
          ( start_at = `2017-10-11T00:00:00` end_at = `2017-11-13T23:59:00` title = `Vacation` info = `out of office` type = `Type04` tentative = abap_false )
        )
        t_headers = VALUE #(
          ( start_at = `2016-09-01T00:00:00` end_at = `2016-12-30T23:59:00` title = `New quarter` type = `Type10` )
          ( start_at = `2017-03-09T08:00:00` end_at = `2017-03-09T09:00:00` title = `UI5` type = `Type05` pic = `sap-icon://sap-ui5` )
          ( start_at = `2017-06-01T00:00:00` end_at = `2017-09-30T23:59:00` title = `New quarter` type = `Type10` )
        )
      )
      ( pic = `sap-icon://employee` name = `Max Mustermann` role = `team member`
        t_appointments = VALUE #(
          ( start_at = `2016-12-01T00:30:00` end_at = `2017-01-31T23:30:00` title = `New product release` info = `room 105` type = `Type03` tentative = abap_true )
          ( start_at = `2017-03-02T07:00:00` end_at = `2017-03-03T09:00:00` title = `Education` type = `Type05` tentative = abap_false )
          ( start_at = `2017-03-05T00:30:00` end_at = `2017-03-05T23:30:00` title = `New Product` info = `room 105` type = `Type03` tentative = abap_true )
          ( start_at = `2017-03-08T08:00:00` end_at = `2017-03-08T09:00:00` title = `Meet Donna` type = `Type06` tentative = abap_false )
          ( start_at = `2017-03-08T09:00:00` end_at = `2017-03-08T11:00:00` title = `Team meeting` info = `room 1` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false )
          ( start_at = `2017-03-09T14:00:00` end_at = `2017-03-09T15:15:00` title = `Department meeting` type = `Type04` tentative = abap_false )
          ( start_at = `2017-03-10T09:30:00` end_at = `2017-03-10T11:30:00` title = `Meeting with John` type = `Type02` tentative = abap_false )
          ( start_at = `2017-03-11T00:00:00` end_at = `2017-03-12T23:59:00` title = `Team Building` info = `out of office` type = `Type10` pic = `sap-icon://sap-ui5` tentative = abap_false )
          ( start_at = `2017-03-19T00:30:00` end_at = `2017-03-17T23:30:00` title = `New Product` info = `room 325` type = `Type07` tentative = abap_true )
          ( start_at = `2017-03-21T00:30:00` end_at = `2017-03-21T23:30:00` title = `New Product` info = `room 105` type = `Type03` tentative = abap_true )
          ( start_at = `2017-06-01T00:00:00` end_at = `2017-07-15T23:59:00` title = `Vacation` info = `out of office` type = `Type04` tentative = abap_false )
          ( start_at = `2017-12-01T00:30:00` end_at = `2018-03-03T23:30:00` title = `New product release` info = `room 105` type = `Type03` tentative = abap_true )
        )
        t_headers = VALUE #(
          ( start_at = `2017-03-08T08:00:00` end_at = `2017-03-08T10:00:00` title = `Development of UI5` type = `Type07` pic = `sap-icon://sap-ui5` )
          ( start_at = `2017-05-01T00:00:00` end_at = `2017-08-30T23:59:00` title = `New quarter` type = `Type10` )
        )
      ) ).

  ENDMETHOD.

ENDCLASS.
