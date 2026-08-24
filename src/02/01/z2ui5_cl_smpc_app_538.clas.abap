" @keywords planningcalendar planning calendar sap.m planningcalendarmulti vbox title planningcalendarrow calendarappointment
" @summary PlanningCalendar with multiple row selection. No interval headers are displayed. On click on an interval a new appointment is created.
CLASS z2ui5_cl_smpc_app_538 DEFINITION PUBLIC.

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
             aria      TYPE string,
           END OF ty_s_appointment.
    TYPES ty_t_appointment TYPE STANDARD TABLE OF ty_s_appointment WITH EMPTY KEY.
    TYPES: BEGIN OF ty_s_person,
             pic            TYPE string,
             name           TYPE string,
             role           TYPE string,
             t_appointments TYPE ty_t_appointment,

             selected       TYPE abap_bool,
           END OF ty_s_person.
    DATA t_people TYPE STANDARD TABLE OF ty_s_person WITH EMPTY KEY.

    DATA start_date TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_538 IMPLEMENTATION.

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
                )->a( n = `singleSelection`           v = `false`
                )->a( n = `showIntervalHeaders`       v = `false`
                )->a( n = `startDate`                 v = |\{ path: '{ client->_bind( val = start_date path = abap_true ) }', formatter: 'Formatter.DateCreateObject' \}|
                )->a( n = `rows`                      v = client->_bind( t_people )
                )->a( n = `appointmentsVisualization` v = `Filled`
                " handleAppointmentSelect: MessageBox with the appointment title, its
                " new selected state and the number of selected appointments - or, when
                " the interval selection hit no appointment, the count of them
                )->a( n = `appointmentSelect`         v = client->_event(
                          val   = `APPT_SELECT`
                          t_arg = VALUE #(
                            ( `${$parameters>/appointment} ? ${$parameters>/appointment}.getTitle() : ''` )
                            ( `${$parameters>/appointment} ? ${$parameters>/appointment}.getSelected() : false` )
                            ( `$event.oSource.getSelectedAppointments().length` )
                            ( `${$parameters>/appointments} ? ${$parameters>/appointments}.length : 0` ) ) )
                " handleIntervalSelect pushes a 'new appointment' (Type09) into the row
                " it hit, or into every selected row. The interval's start and end travel
                " as their LOCAL parts - a UTC toISOString( ) would shift the day
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
                            ( `${$parameters>/row} ? $event.oSource.indexOfRow(${$parameters>/row}) : -1` ) ) )

                )->ele( `toolbarContent`
                    )->tag( `Title`
                        )->a( n = `text`       v = `Title`
                        )->a( n = `titleStyle` v = `H4`

                )->end(

                )->ele( `rows`
                    )->ele( `PlanningCalendarRow`
                        )->a( n = `icon`         v = `{PIC}`
                        )->a( n = `title`        v = `{NAME}`
                        )->a( n = `text`         v = `{ROLE}`
                        )->a( n = `selected`     v = `{SELECTED}`
                        )->a( n = `appointments` v = `{path: 'T_APPOINTMENTS', templateShareable: false}`

                        )->ele( `appointments`
                            )->tag( n = `CalendarAppointment` ns = `unified`
                                )->a( n = `startDate`    v = `{ path: 'START_AT', formatter: 'Formatter.DateCreateObject' }`
                                )->a( n = `endDate`      v = `{ path: 'END_AT', formatter: 'Formatter.DateCreateObject' }`
                                )->a( n = `icon`         v = `{PIC}`
                                )->a( n = `title`        v = `{TITLE}`
                                )->a( n = `text`         v = `{INFO}`
                                )->a( n = `type`         v = `{TYPE}`
                                )->a( n = `tentative`    v = `{TENTATIVE}`
                                )->a( n = `ariaHasPopup` v = `{ARIA}` ).

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
        DATA(iso_end) = |{ client->get_event_arg( 6 ) }-{ CONV i( client->get_event_arg( 7 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
                        |-{ CONV i( client->get_event_arg( 8 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
                        |T{ CONV i( client->get_event_arg( 9 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
                        |:{ CONV i( client->get_event_arg( 10 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }:00|.
        DATA(appointment) = VALUE ty_s_appointment( start_at = iso_start
                                                    end_at   = iso_end
                                                    title    = `new appointment`
                                                    type     = `Type09` ).
        DATA(row_index) = CONV i( client->get_event_arg( 11 ) ).
        " the selected rows are read from the model, not transported: PlanningCalendarRow
        " has a bindable `selected`, and a JS callback (getSelectedRows().map(function...))
        " is not in the UI5 expression grammar - it threw and lost the whole handler
        DATA(rows) = VALUE string_table( ).
        IF row_index >= 0.
          APPEND |{ row_index }| TO rows.
        ELSE.
          LOOP AT t_people INTO DATA(person_sel).
            IF person_sel-selected = abap_true.
              APPEND |{ sy-tabix - 1 }| TO rows.
            ENDIF.
          ENDLOOP.
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

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    start_date = `2017-01-15T08:00:00`.

    t_people = VALUE #(
      ( pic = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/John_Miller.png` name = `John Miller` role = `team member`
        t_appointments = VALUE #(
          ( start_at = `2016-10-20T10:00:00` end_at = `2016-12-15T12:00:00` title = `Working out of the building` type = `Type07` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-15T08:30:00` end_at = `2017-01-15T09:30:00` title = `Meet Max Mustermann` type = `Type02` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-15T10:00:00` end_at = `2017-01-15T12:00:00` title = `Team meeting` info = `room 1` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-15T11:30:00` end_at = `2017-01-15T13:30:00` title = `Lunch` info = `canteen` type = `Type03` tentative = abap_true aria = `Dialog` )
          ( start_at = `2017-01-15T13:30:00` end_at = `2017-01-15T17:30:00` title = `Discussion with clients` info = `online meeting` type = `Type02` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-16T00:01:00` end_at = `2017-01-16T23:59:00` title = `Discussion` info = `Online meeting` type = `Type04` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-18T08:30:00` end_at = `2017-01-18T09:30:00` title = `Meeting with the manager` type = `Type02` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-18T11:30:00` end_at = `2017-01-18T13:30:00` title = `Lunch` info = `canteen` type = `Type03` tentative = abap_true aria = `Dialog` )
          ( start_at = `2017-01-18T01:00:00` end_at = `2017-01-18T22:00:00` title = `Team meeting` info = `regular` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-21T00:30:00` end_at = `2017-01-21T23:30:00` title = `New Product` info = `room 105` type = `Type03` tentative = abap_true aria = `Dialog` )
          ( start_at = `2017-01-25T11:30:00` end_at = `2017-01-25T13:30:00` title = `Lunch` type = `Type03` tentative = abap_true aria = `Dialog` )
          ( start_at = `2017-01-29T10:00:00` end_at = `2017-01-29T12:00:00` title = `Team meeting` info = `room 1` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-30T08:30:00` end_at = `2017-01-30T09:30:00` title = `Meet Max Mustermann` type = `Type02` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-30T10:00:00` end_at = `2017-01-30T12:00:00` title = `Team meeting` info = `room 1` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-30T11:30:00` end_at = `2017-01-30T13:30:00` title = `Lunch` type = `Type03` tentative = abap_true aria = `Dialog` )
          ( start_at = `2017-01-30T13:30:00` end_at = `2017-01-30T17:30:00` title = `Discussion with clients` type = `Type02` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-31T10:00:00` end_at = `2017-01-31T11:30:00` title = `Discussion of the plan` info = `Online meeting` type = `Type04` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-02-01T01:00:00` end_at = `2017-02-02T22:00:00` title = `Workshop` info = `regular` type = `Type07` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-02-03T08:30:00` end_at = `2017-02-13T09:30:00` title = `Meeting with the manager` type = `Type02` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-02-04T10:00:00` end_at = `2017-02-04T12:00:00` title = `Team meeting` info = `room 1` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-03-30T10:00:00` end_at = `2017-06-02T12:00:00` title = `Working out of the building` type = `Type07` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-09-01T00:30:00` end_at = `2017-11-15T23:30:00` title = `Development of a new Product` info = `room 207` type = `Type03` tentative = abap_true aria = `Dialog` )
        )
      )
      ( pic = `sap-icon://employee` name = `Max Mustermann` role = `team member`
        t_appointments = VALUE #(
          ( start_at = `2016-08-15T10:00:00` end_at = `2016-09-25T12:00:00` title = `Team collaboration` info = `room 1` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-15T08:30:00` end_at = `2017-01-15T09:30:00` title = `Meet John Miller` type = `Type02` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-15T10:00:00` end_at = `2017-01-15T12:00:00` title = `Team meeting` info = `room 1` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-15T13:00:00` end_at = `2017-01-15T16:00:00` title = `Discussion with clients` info = `online` type = `Type02` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-16T00:00:00` end_at = `2017-01-16T23:59:00` title = `Vacation` info = `out of office` type = `Type04` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-17T01:00:00` end_at = `2017-01-18T22:00:00` title = `Workshop` info = `regular` type = `Type07` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-19T08:30:00` end_at = `2017-01-19T18:30:00` title = `Meet John Doe` type = `Type02` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-19T00:01:00` end_at = `2017-01-19T23:59:00` title = `Team meeting` info = `room 102` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-19T07:00:00` end_at = `2017-01-19T17:30:00` title = `Discussion with clients` type = `Type02` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-20T00:00:00` end_at = `2017-01-20T23:59:00` title = `Vacation` info = `out of office` type = `Type04` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-22T07:00:00` end_at = `2017-01-27T17:30:00` title = `Discussion with clients` info = `out of office` type = `Type02` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-02-15T10:00:00` end_at = `2017-03-25T12:00:00` title = `Team collaboration` info = `room 1` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-03-13T09:00:00` end_at = `2017-04-09T10:00:00` title = `Reminder` type = `Type06` )
          ( start_at = `2017-04-10T00:00:00` end_at = `2017-06-16T23:59:00` title = `Vacation` info = `out of office` type = `Type04` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-08-01T00:00:00` end_at = `2017-10-31T23:59:00` title = `New quarter` type = `Type10` tentative = abap_false aria = `Dialog` )
        )
      ) ).

  ENDMETHOD.

ENDCLASS.
