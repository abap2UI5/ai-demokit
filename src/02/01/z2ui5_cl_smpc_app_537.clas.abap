CLASS z2ui5_cl_smpc_app_537 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES ty_t_int TYPE STANDARD TABLE OF i WITH EMPTY KEY.
    TYPES: BEGIN OF ty_s_appointment,
             start_at  TYPE string,
             end_at    TYPE string,
             title     TYPE string,
             info      TYPE string,
             type      TYPE string,
             pic       TYPE string,
             tentative TYPE abap_bool,
             aria      TYPE string,
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
             " nonWorkingDays / nonWorkingHours are int[] properties: a table of
             " STRINGS serializes to ['5','6'] and UI5 rejects it ("is of type
             " object, expected int[]"), so both are integer tables
             t_free_days    TYPE ty_t_int,
             t_free_hours   TYPE ty_t_int,
             t_appointments TYPE ty_t_appointment,
             t_headers      TYPE ty_t_header,
           END OF ty_s_person.
    DATA t_people TYPE STANDARD TABLE OF ty_s_person WITH EMPTY KEY.

    TYPES: BEGIN OF ty_s_special,
             start_at TYPE string,
             type     TYPE string,
           END OF ty_s_special.
    DATA t_special TYPE STANDARD TABLE OF ty_s_special WITH EMPTY KEY.

    DATA start_date  TYPE string.
    DATA view_key    TYPE string.
    DATA group_mode  TYPE string.
    DATA t_built_in  TYPE string_table.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_537 IMPLEMENTATION.

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
        )->a( n = `xmlns:mvc`     v = `sap.ui.core.mvc`
        )->a( n = `xmlns:unified` v = `sap.ui.unified`
        )->a( n = `xmlns:core`    v = `sap.ui.core`
        )->a( n = `xmlns`         v = `sap.m`
        )->a( n = `core:require`  v = `{Formatter: 'z2ui5/model/formatter'}`

        )->ele( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->ele( `PlanningCalendar`
                )->a( n = `id`                        v = `PC1`
                )->a( n = `startDate`                 v = |\{ path: '{ client->_bind( val = start_date path = abap_true ) }', formatter: 'Formatter.DateCreateObject' \}|
                " handleViewChange only recomputes the two visibilities; viewKey is
                " bindable, so the key itself is the shared field and the two
                " expressions below read it - the handler is dropped
                )->a( n = `viewKey`                   v = client->_bind( view_key )
                )->a( n = `rows`                      v = client->_bind( t_people )
                )->a( n = `appointmentsVisualization` v = `Filled`
                )->a( n = `groupAppointmentsMode`     v = client->_bind( group_mode )
                " handleNonWorkingSpecialDates toggles a NonWorking DateTypeRange
                " on the selected interval - the specialDates aggregation is bound
                )->a( n = `specialDates`              v = client->_bind( t_special )
                " handleSelectionFinish hands the MultiComboBox's selected keys to
                " setBuiltInViews - a bindable string[] property, bound here
                )->a( n = `builtInViews`              v = client->_bind( t_built_in )
                )->a( n = `appointmentSelect`         v = client->_event(
                          val   = `APPT_SELECT`
                          t_arg = VALUE #(
                            ( `${$parameters>/appointment} ? ${$parameters>/appointment}.getTitle() : ''` )
                            ( `${$parameters>/appointment} ? ${$parameters>/appointment}.getSelected() : false` )
                            ( `$event.oSource.getSelectedAppointments().length` )
                            ( `${$parameters>/appointments} ? ${$parameters>/appointments}.length : 0` ) ) )
                " handleIntervalSelect: in the nonWorking view it toggles the special
                " date, otherwise it pushes a 'new appointment' into the row it hit
                " (or into every selected row). The interval's start/end travel as
                " their LOCAL parts - a UTC toISOString( ) would shift the day
                )->a( n = `intervalSelect`            v = client->_event(
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
                )->a( n = `showEmptyIntervalHeaders`  v = `false`

                )->ele( `toolbarContent`
                    )->tag( `Title`
                        )->a( n = `text`       v = `Title`
                        )->a( n = `titleStyle` v = `H4`
                    " determineControlsVisibility: the Label belongs to the
                    " nonWorking view, the Select to the months view on desktop
                    )->tag( `Label`
                        )->a( n = `id`      v = `label`
                        )->a( n = `text`    v = `Select a date from the interval to mark/unmark it as a non-working day.`
                        )->a( n = `visible` v = |\{= ${ client->_bind( view_key ) } === 'nonWorking' \}|

                    )->ele( `Select`
                        )->a( n = `id`          v = `select`
                        )->a( n = `tooltip`     v = `Group appointments mode`
                        )->a( n = `selectedKey` v = client->_bind( group_mode )
                        )->a( n = `visible`     v = |\{= ${ client->_bind( view_key ) } === 'M' && $\{device>/system/desktop\} \}|

                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `Collapsed`
                            )->a( n = `text` v = `Collapsed`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `Expanded`
                            )->a( n = `text` v = `Expanded`

                    )->end(
                )->end(

                )->ele( `specialDates`
                    )->tag( n = `DateTypeRange` ns = `unified`
                        )->a( n = `startDate` v = `{ path: 'START_AT', formatter: 'Formatter.DateCreateObject' }`
                        )->a( n = `type`      v = `{TYPE}`

                )->end(

                )->ele( `views`
                    )->tag( `PlanningCalendarView`
                        )->a( n = `key`              v = `A`
                        )->a( n = `intervalType`     v = `Hour`
                        )->a( n = `description`      v = `hours view`
                        )->a( n = `intervalsS`       v = `2`
                        )->a( n = `intervalsM`       v = `4`
                        )->a( n = `intervalsL`       v = `6`
                        )->a( n = `showSubIntervals` v = `true`
                    )->tag( `PlanningCalendarView`
                        )->a( n = `key`              v = `D`
                        )->a( n = `intervalType`     v = `Day`
                        )->a( n = `description`      v = `days view`
                        )->a( n = `intervalsS`       v = `1`
                        )->a( n = `intervalsM`       v = `3`
                        )->a( n = `intervalsL`       v = `7`
                        )->a( n = `showSubIntervals` v = `true`
                    )->tag( `PlanningCalendarView`
                        )->a( n = `key`              v = `M`
                        )->a( n = `intervalType`     v = `Month`
                        )->a( n = `description`      v = `months view`
                        )->a( n = `intervalsS`       v = `1`
                        )->a( n = `intervalsM`       v = `2`
                        )->a( n = `intervalsL`       v = `3`
                        )->a( n = `showSubIntervals` v = `true`
                    )->tag( `PlanningCalendarView`
                        )->a( n = `key`          v = `nonWorking`
                        )->a( n = `intervalType` v = `Day`
                        )->a( n = `description`  v = `days with non-working dates`
                        )->a( n = `intervalsS`   v = `1`
                        )->a( n = `intervalsM`   v = `5`
                        )->a( n = `intervalsL`   v = `9`

                )->end(

                )->ele( `rows`
                    )->ele( `PlanningCalendarRow`
                        )->a( n = `icon`            v = `{PIC}`
                        )->a( n = `title`           v = `{NAME}`
                        )->a( n = `text`            v = `{ROLE}`
                        )->a( n = `nonWorkingDays`  v = `{T_FREE_DAYS}`
                        )->a( n = `nonWorkingHours` v = `{T_FREE_HOURS}`
                        )->a( n = `appointments`    v = `{path: 'T_APPOINTMENTS', templateShareable: false}`
                        )->a( n = `intervalHeaders` v = `{path: 'T_HEADERS', templateShareable: false}`

                        )->ele( `appointments`
                            )->tag( n = `CalendarAppointment` ns = `unified`
                                )->a( n = `startDate`    v = `{ path: 'START_AT', formatter: 'Formatter.DateCreateObject' }`
                                )->a( n = `endDate`      v = `{ path: 'END_AT', formatter: 'Formatter.DateCreateObject' }`
                                )->a( n = `icon`         v = `{PIC}`
                                )->a( n = `title`        v = `{TITLE}`
                                )->a( n = `text`         v = `{INFO}`
                                )->a( n = `type`         v = `{TYPE}`
                                )->a( n = `tentative`    v = `{TENTATIVE}`
                                )->a( n = `ariaHasPopup` v = `{ARIA}`

                        )->end(
                        )->ele( `intervalHeaders`
                            )->tag( n = `CalendarAppointment` ns = `unified`
                                )->a( n = `startDate` v = `{ path: 'START_AT', formatter: 'Formatter.DateCreateObject' }`
                                )->a( n = `endDate`   v = `{ path: 'END_AT', formatter: 'Formatter.DateCreateObject' }`
                                )->a( n = `icon`      v = `{PIC}`
                                )->a( n = `title`     v = `{TITLE}`
                                )->a( n = `type`      v = `{TYPE}`

                        )->end(
                    )->end(
                )->end(
            )->end(

            )->tag( `Label`
                )->a( n = `text` v = `Add available built-in views to the example:`

            )->ele( `MultiComboBox`
                )->a( n = `selectionFinish` v = client->_event(
                          val   = `BUILT_IN_VIEWS`
                          t_arg = VALUE #( ( `$event.oSource.getSelectedKeys().join(',')` ) ) )
                )->a( n = `width`           v = `230px`
                )->a( n = `placeholder`     v = `Choose built-in views`

                )->tag( n = `Item` ns = `core`
                    )->a( n = `key`  v = `Hour`
                    )->a( n = `text` v = `Hour`
                )->tag( n = `Item` ns = `core`
                    )->a( n = `key`  v = `Day`
                    )->a( n = `text` v = `Day`
                )->tag( n = `Item` ns = `core`
                    )->a( n = `key`  v = `Month`
                    )->a( n = `text` v = `Month`
                )->tag( n = `Item` ns = `core`
                    )->a( n = `key`  v = `Week`
                    )->a( n = `text` v = `1 week`
                )->tag( n = `Item` ns = `core`
                    )->a( n = `key`  v = `One Month`
                    )->a( n = `text` v = `1 month`

            )->end(

            )->tag( `Label`
                )->a( n = `text` v = `Add or remove custom views:`
            )->tag( `ToggleButton`
                )->a( n = `text` v = `Toggle custom views` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `APPT_SELECT`.
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

        IF view_key = `nonWorking`.
          " the special date toggles: first select marks it, the second clears it
          IF line_exists( t_special[ start_at = iso_start ] ).
            DELETE t_special WHERE start_at = iso_start.
          ELSE.
            APPEND VALUE #( start_at = iso_start type = `NonWorking` ) TO t_special.
          ENDIF.
        ELSE.
          DATA(iso_end) = |{ client->get_event_arg( 6 ) }-{ CONV i( client->get_event_arg( 7 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
                          |-{ CONV i( client->get_event_arg( 8 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
                          |T{ CONV i( client->get_event_arg( 9 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
                          |:{ CONV i( client->get_event_arg( 10 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }:00|.
          DATA(appointment) = VALUE ty_s_appointment( start_at = iso_start
                                                      end_at   = iso_end
                                                      title    = `new appointment`
                                                      type     = `Type09` ).
          DATA(row_index) = CONV i( client->get_event_arg( 11 ) ).
          DATA(rows) = VALUE ty_t_int( ).
          IF row_index >= 0.
            APPEND row_index TO rows.
          ELSEIF client->get_event_arg( 12 ) IS NOT INITIAL.
            SPLIT client->get_event_arg( 12 ) AT `,` INTO TABLE DATA(selected_rows).
            LOOP AT selected_rows INTO DATA(sel).
              APPEND CONV i( sel ) TO rows.
            ENDLOOP.
          ENDIF.
          " the row is addressed through a field symbol, not a table expression:
          " abaplint's downport leaves an itab[ ] TARGET of INSERT/DELETE in
          " place, and the 702 parser rejects it
          LOOP AT rows INTO DATA(index).
            READ TABLE t_people INDEX index + 1 ASSIGNING FIELD-SYMBOL(<person>).
            IF sy-subrc = 0.
              INSERT appointment INTO TABLE <person>-t_appointments.
            ENDIF.
          ENDLOOP.
        ENDIF.

      WHEN `BUILT_IN_VIEWS`.
        " handleSelectionFinish: the picked keys become the calendar's built-in views
        CLEAR t_built_in.
        IF client->get_event_arg( ) IS NOT INITIAL.
          SPLIT client->get_event_arg( ) AT `,` INTO TABLE t_built_in.
        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    start_date = `2017-02-08T08:00:00`.
    view_key   = `D`.
    group_mode = `Collapsed`.

    t_people = VALUE #(
      ( pic = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/John_Miller.png` name = `John Miller` role = `team member`
        t_free_days  = VALUE #( ( 5 ) ( 6 ) )
        t_free_hours = VALUE #( ( 0 ) ( 1 ) ( 2 ) ( 3 ) ( 4 ) ( 5 ) ( 6 ) ( 17 ) ( 19 ) ( 20 ) ( 21 ) ( 22 ) ( 23 ) )
        t_appointments = VALUE #(
          ( start_at = `2016-12-02T11:30:00` end_at = `2016-12-02T13:30:00` title = `Online Meeting` type = `Type03` tentative = abap_true aria = `Dialog` )
          ( start_at = `2017-01-15T13:30:00` end_at = `2017-01-29T17:30:00` title = `Discussion with clients` info = `online meeting` type = `Type02` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-02-07T00:01:00` end_at = `2017-02-07T23:59:00` title = `Vacation` type = `Type02` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-02-08T08:30:00` end_at = `2017-02-08T15:00:00` title = `Meeting` type = `Type05` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-02-08T08:00:00` end_at = `2017-02-08T17:00:00` title = `Team meeting` info = `room 106` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-02-09T07:30:00` end_at = `2017-02-09T16:30:00` title = `Meet Donna Moore` info = `regular` type = `Type08` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-02-10T00:00:00` end_at = `2017-02-11T23:29:00` title = `Private appointment` type = `Type06` tentative = abap_true aria = `Dialog` )
          ( start_at = `2017-04-17T08:30:00` end_at = `2017-04-17T15:30:00` title = `Meet Max Mustermann` type = `Type02` tentative = abap_true aria = `Dialog` )
          ( start_at = `2017-04-03T10:00:00` end_at = `2017-04-03T12:00:00` title = `Team meeting` info = `room 1` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-03-04T11:30:00` end_at = `0201-03-04T13:30:00` title = `Online Meeting` type = `Type03` tentative = abap_true aria = `Dialog` )
          ( start_at = `2017-01-15T13:30:00` end_at = `2017-01-29T17:30:00` title = `Discussion with clients` info = `online meeting` type = `Type02` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-02-07T00:01:00` end_at = `2017-02-07T23:59:00` title = `Vacation` type = `Type02` tentative = abap_false aria = `Dialog` )
        )
        t_headers = VALUE #(
          ( start_at = `2017-02-09T11:30:00` end_at = `2017-02-09T14:00:00` title = `Lunch` type = `Type03` )
        ) )
      ( pic = `sap-icon://employee` name = `Max Mustermann` role = `team member`
        t_free_days  = VALUE #( ( 0 ) ( 6 ) )
        t_free_hours = VALUE #( ( 0 ) ( 1 ) ( 2 ) ( 3 ) ( 4 ) ( 5 ) ( 6 ) ( 7 ) ( 18 ) ( 19 ) ( 20 ) ( 21 ) ( 22 ) ( 23 ) )
        t_appointments = VALUE #(
          ( start_at = `2017-01-02T11:30:00` end_at = `2017-01-02T13:30:00` title = `Online Meeting` type = `Type03` tentative = abap_true aria = `Dialog` )
          ( start_at = `2017-01-15T13:30:00` end_at = `2017-01-29T11:30:00` title = `Meeting with managers` info = `online meeting` type = `Type02` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-02-05T00:01:00` end_at = `2017-02-05T23:59:00` title = `Education` type = `Type03` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-02-08T08:00:00` end_at = `2017-02-08T17:00:00` title = `Team meeting` info = `room 106` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-02-09T10:00:00` end_at = `2017-02-09T16:30:00` title = `Meeting` info = `phone` type = `Type02` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-02-10T00:00:00` end_at = `2017-01-31T23:59:00` title = `Blocker` type = `Type04` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-02-10T07:30:00` end_at = `2017-02-10T16:30:00` title = `Meet Donna Moore` info = `regular` type = `Type08` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-02-12T00:01:00` end_at = `2017-02-12T23:59:00` title = `New Product` info = `room 105` type = `Type04` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-03-02T11:30:00` end_at = `2017-03-02T13:30:00` title = `Online Meeting` type = `Type03` tentative = abap_true aria = `Dialog` )
          ( start_at = `2017-03-15T13:30:00` end_at = `2017-03-29T17:30:00` title = `Meeting with managers` info = `online meeting` type = `Type02` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-05-02T11:30:00` end_at = `2017-05-02T13:30:00` title = `Online Meeting` type = `Type03` tentative = abap_true aria = `Dialog` )
          ( start_at = `2017-03-15T13:30:00` end_at = `2017-03-29T17:30:00` title = `Discussion with clients` info = `online meeting` type = `Type02` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-04-07T00:01:00` end_at = `2017-04-07T23:59:00` title = `Vacation` type = `Type02` tentative = abap_false aria = `Dialog` )
        )
        t_headers = VALUE #(
          ( start_at = `2017-02-14T00:00:00` end_at = `2017-02-14T23:59:00` title = `Valentine's Day` type = `Type03` )
        ) ) ).

  ENDMETHOD.

ENDCLASS.
