" @keywords planningcalendar planning calendar sap.m single-row day planner vbox title togglebutton planningcalendarrow calendarappointment
" @summary PlanningCalendar with only one row without row header. On click on an interval a new appointment is created.
CLASS z2ui5_cl_smpc_app_108 DEFINITION PUBLIC.

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
    TYPES ty_t_appointment TYPE STANDARD TABLE OF ty_s_appointment WITH DEFAULT KEY.
    TYPES: BEGIN OF ty_s_header,
             start_at TYPE string,
             end_at   TYPE string,
             title    TYPE string,
             type     TYPE string,
           END OF ty_s_header.
    TYPES ty_t_header TYPE STANDARD TABLE OF ty_s_header WITH DEFAULT KEY.
    TYPES: BEGIN OF ty_s_person,
             t_appointments TYPE ty_t_appointment,
             t_headers      TYPE ty_t_header,
           END OF ty_s_person.
    DATA t_people TYPE STANDARD TABLE OF ty_s_person WITH DEFAULT KEY.
    DATA start_date TYPE string.
    DATA show_day_names TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_108 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    DATA temp2 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " calendar date properties (startDate/endDate) are typed "object" and demand a
    " real JS Date; the model keeps ISO strings and Formatter.DateCreateObject from
    " the curated module converts them at the point of use (needs UI5 >= 1.74)
    
    CLEAR temp1.
    INSERT `${$parameters>/appointment} ? ${$parameters>/appointment}.getTitle() : ''` INTO TABLE temp1.
    INSERT `${$parameters>/appointment} ? ${$parameters>/appointment}.getSelected() : false` INTO TABLE temp1.
    INSERT `$event.oSource.getSelectedAppointments().length` INTO TABLE temp1.
    INSERT `${$parameters>/appointments} ? ${$parameters>/appointments}.length : 0` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `${$parameters>/startDate}.getFullYear()` INTO TABLE temp2.
    INSERT `${$parameters>/startDate}.getMonth() + 1` INTO TABLE temp2.
    INSERT `${$parameters>/startDate}.getDate()` INTO TABLE temp2.
    INSERT `${$parameters>/startDate}.getHours()` INTO TABLE temp2.
    INSERT `${$parameters>/startDate}.getMinutes()` INTO TABLE temp2.
    INSERT `${$parameters>/endDate}.getFullYear()` INTO TABLE temp2.
    INSERT `${$parameters>/endDate}.getMonth() + 1` INTO TABLE temp2.
    INSERT `${$parameters>/endDate}.getDate()` INTO TABLE temp2.
    INSERT `${$parameters>/endDate}.getHours()` INTO TABLE temp2.
    INSERT `${$parameters>/endDate}.getMinutes()` INTO TABLE temp2.
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
                " toggleDayNamesLine flips PC1.showDayNamesLine - a bindable property
                " (@since 1.50), so the ToggleButton and the calendar share the field
                )->a( n = `showDayNamesLine`          v = client->_bind( show_day_names )
                )->a( n = `showRowHeaders`            v = `false`
                )->a( n = `startDate`                 v = |\{ path: '{ client->_bind_path( start_date ) }', formatter: 'Formatter.DateCreateObject' \}|
                )->a( n = `viewKey`                   v = `Day`
                )->a( n = `rows`                      v = client->_bind( t_people )
                )->a( n = `appointmentsVisualization` v = `Filled`
                " handleAppointmentSelect: MessageBox with the appointment title, its
                " new selected state and the number of selected appointments - or, when
                " the interval selection hit no appointment, the count of them. Every
                " value is client-readable, so it travels and ABAP composes both
                " branches (the message is modal anyway, so the round-trip is free)
                )->a( n = `appointmentSelect`         v = client->_event(
                          val   = `APPT_SELECT`
                          t_arg = temp1 )
                " handleIntervalSelect pushes a new appointment ('new appointment',
                " Type09) over the selected interval into the model - reproduced by
                " appending that row, with the interval's start/end carried as their
                " LOCAL parts (a UTC toISOString( ) would shift the day)
                )->a( n = `intervalSelect`            v = client->_event(
                          val   = `INTERVAL_SELECT`
                          t_arg = temp2 )
                )->a( n = `showEmptyIntervalHeaders`  v = `false`

                )->ele( `toolbarContent`
                    )->tag( `Title`
                        )->a( n = `text`       v = `Title`
                        )->a( n = `titleStyle` v = `H4`
                    )->tag( `ToggleButton`
                        )->a( n = `icon`    v = `sap-icon://decrease-line-height`
                        )->a( n = `tooltip` v = `Toggle Day Names Line`
                        )->a( n = `pressed` v = client->_bind( show_day_names )

                )->end(
                )->ele( `rows`
                    )->ele( `PlanningCalendarRow`
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
                                )->a( n = `title`     v = `{TITLE}`
                                )->a( n = `type`      v = `{TYPE}`

                        )->end(
                    )->end(
                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA appt_title TYPE string.
          DATA temp3 TYPE string.
          DATA selected LIKE temp3.
        DATA temp4 TYPE i.
        DATA temp7 TYPE i.
        DATA temp1 TYPE i.
        DATA temp9 TYPE i.
        DATA iso_start TYPE string.
        DATA temp5 TYPE i.
        DATA temp8 TYPE i.
        DATA temp2 TYPE i.
        DATA temp10 TYPE i.
        DATA iso_end TYPE string.
        FIELD-SYMBOLS <person> TYPE z2ui5_cl_smpc_app_108=>ty_s_person.
          DATA temp6 TYPE z2ui5_cl_smpc_app_108=>ty_s_appointment.

    CASE client->get_event( ).

      WHEN `APPT_SELECT`.
        
        appt_title = client->get_event_arg( ).
        IF appt_title IS NOT INITIAL.
          
          IF client->get_event_arg( 2 ) = abap_true.
            temp3 = `selected`.
          ELSE.
            temp3 = `deselected`.
          ENDIF.
          
          selected = temp3.
          client->message_box_display(
              text = |'{ appt_title }' { selected }. \n Selected appointments: { client->get_event_arg( 3 ) }|
              type = `show` ).
        ELSE.
          client->message_box_display( text = |{ client->get_event_arg( 4 ) } Appointments selected|
                                       type = `show` ).
        ENDIF.

      WHEN `INTERVAL_SELECT`.
        " the pushed appointment: start/end of the selected interval, title
        " 'new appointment', type Type09 - on the first person, as in the original
        
        temp4 = client->get_event_arg( 2 ).
        
        temp7 = client->get_event_arg( 3 ).
        
        temp1 = client->get_event_arg( 4 ).
        
        temp9 = client->get_event_arg( 5 ).
        
        iso_start = |{ client->get_event_arg( ) }-{ temp4 WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
                          |-{ temp7 WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
                          |T{ temp1 WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
                          |:{ temp9 WIDTH = 2 ALIGN = RIGHT PAD = '0' }:00|.
        
        temp5 = client->get_event_arg( 7 ).
        
        temp8 = client->get_event_arg( 8 ).
        
        temp2 = client->get_event_arg( 9 ).
        
        temp10 = client->get_event_arg( 10 ).
        
        iso_end = |{ client->get_event_arg( 6 ) }-{ temp5 WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
                        |-{ temp8 WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
                        |T{ temp2 WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
                        |:{ temp10 WIDTH = 2 ALIGN = RIGHT PAD = '0' }:00|.
        " the row is addressed through a field symbol, not a table expression:
        " abaplint's downport leaves an itab[ ] TARGET of INSERT/DELETE in
        " place, and the 702 parser rejects it
        
        READ TABLE t_people INDEX 1 ASSIGNING <person>.
        IF sy-subrc = 0.
          
          CLEAR temp6.
          temp6-start_at = iso_start.
          temp6-end_at = iso_end.
          temp6-title = `new appointment`.
          temp6-type = `Type09`.
          temp6-aria = `None`.
          INSERT temp6 INTO TABLE <person>-t_appointments.
        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.
    DATA temp7 LIKE t_people.
    DATA temp8 LIKE LINE OF temp7.
    DATA temp9 TYPE z2ui5_cl_smpc_app_108=>ty_t_appointment.
    DATA temp10 LIKE LINE OF temp9.
    DATA temp11 TYPE z2ui5_cl_smpc_app_108=>ty_t_header.
    DATA temp12 LIKE LINE OF temp11.

    start_date = `2017-01-08T08:00:00`.
    
    CLEAR temp7.
    
    
    CLEAR temp9.
    
    temp10-start_at = `2016-11-15T10:00:00`.
    temp10-end_at = `2016-12-25T12:00:00`.
    temp10-title = `Team collaboration`.
    temp10-info = `room 1`.
    temp10-type = `Type01`.
    temp10-pic = `sap-icon://sap-ui5`.
    temp10-tentative = abap_false.
    temp10-aria = `Dialog`.
    INSERT temp10 INTO TABLE temp9.
    temp10-start_at = `2016-10-13T09:00:00`.
    temp10-end_at = `2016-02-09T10:00:00`.
    temp10-title = `Reminder`.
    temp10-info = ``.
    temp10-type = `Type06`.
    temp10-pic = ``.
    temp10-tentative = abap_false.
    temp10-aria = `None`.
    INSERT temp10 INTO TABLE temp9.
    temp10-start_at = `2016-08-10T00:00:00`.
    temp10-end_at = `2016-10-16T23:59:00`.
    temp10-title = `Vacation`.
    temp10-info = `out of office`.
    temp10-type = `Type04`.
    temp10-pic = ``.
    temp10-tentative = abap_false.
    temp10-aria = `Dialog`.
    INSERT temp10 INTO TABLE temp9.
    temp10-start_at = `2016-08-01T00:00:00`.
    temp10-end_at = `2016-10-31T23:59:00`.
    temp10-title = `New quarter`.
    temp10-info = ``.
    temp10-type = `Type10`.
    temp10-pic = ``.
    temp10-tentative = abap_false.
    temp10-aria = `Dialog`.
    INSERT temp10 INTO TABLE temp9.
    temp10-start_at = `2017-01-03T00:01:00`.
    temp10-end_at = `2017-01-04T23:59:00`.
    temp10-title = `Workshop`.
    temp10-info = `regular`.
    temp10-type = `Type07`.
    temp10-pic = `sap-icon://sap-ui5`.
    temp10-tentative = abap_false.
    temp10-aria = `Dialog`.
    INSERT temp10 INTO TABLE temp9.
    temp10-start_at = `2017-01-05T08:30:00`.
    temp10-end_at = `2017-01-05T09:30:00`.
    temp10-title = `Meet Donna Moore`.
    temp10-info = ``.
    temp10-type = `Type02`.
    temp10-pic = ``.
    temp10-tentative = abap_false.
    temp10-aria = `Dialog`.
    INSERT temp10 INTO TABLE temp9.
    temp10-start_at = `2017-01-08T10:00:00`.
    temp10-end_at = `2017-01-08T12:00:00`.
    temp10-title = `Team meeting`.
    temp10-info = `room 1`.
    temp10-type = `Type01`.
    temp10-pic = `sap-icon://sap-ui5`.
    temp10-tentative = abap_false.
    temp10-aria = `Dialog`.
    INSERT temp10 INTO TABLE temp9.
    temp10-start_at = `2017-01-09T00:00:00`.
    temp10-end_at = `2017-01-09T23:59:00`.
    temp10-title = `Vacation`.
    temp10-info = `out of office`.
    temp10-type = `Type02`.
    temp10-pic = ``.
    temp10-tentative = abap_false.
    temp10-aria = `Dialog`.
    INSERT temp10 INTO TABLE temp9.
    temp10-start_at = `2017-01-11T00:00:00`.
    temp10-end_at = `2017-01-12T23:59:00`.
    temp10-title = `Education`.
    temp10-info = ``.
    temp10-type = `Type03`.
    temp10-pic = ``.
    temp10-tentative = abap_false.
    temp10-aria = `Dialog`.
    INSERT temp10 INTO TABLE temp9.
    temp10-start_at = `2017-01-16T00:30:00`.
    temp10-end_at = `2017-01-16T23:30:00`.
    temp10-title = `New Product`.
    temp10-info = `room 105`.
    temp10-type = `Type04`.
    temp10-pic = ``.
    temp10-tentative = abap_true.
    temp10-aria = `Dialog`.
    INSERT temp10 INTO TABLE temp9.
    temp10-start_at = `2017-01-18T11:30:00`.
    temp10-end_at = `2017-01-18T13:30:00`.
    temp10-title = `Lunch`.
    temp10-info = `canteen`.
    temp10-type = `Type03`.
    temp10-pic = ``.
    temp10-tentative = abap_true.
    temp10-aria = `Dialog`.
    INSERT temp10 INTO TABLE temp9.
    temp10-start_at = `2017-01-20T11:30:00`.
    temp10-end_at = `2017-01-20T13:30:00`.
    temp10-title = `Lunch`.
    temp10-info = `canteen`.
    temp10-type = `Type03`.
    temp10-pic = ``.
    temp10-tentative = abap_true.
    temp10-aria = `Dialog`.
    INSERT temp10 INTO TABLE temp9.
    temp10-start_at = `2017-01-18T00:01:00`.
    temp10-end_at = `2017-01-19T23:59:00`.
    temp10-title = `Working out of the building`.
    temp10-info = ``.
    temp10-type = `Type07`.
    temp10-pic = `sap-icon://sap-ui5`.
    temp10-tentative = abap_false.
    temp10-aria = `Dialog`.
    INSERT temp10 INTO TABLE temp9.
    temp10-start_at = `2017-01-23T08:00:00`.
    temp10-end_at = `2017-01-24T18:30:00`.
    temp10-title = `Discussion of the plan`.
    temp10-info = `Online meeting`.
    temp10-type = `Type04`.
    temp10-pic = ``.
    temp10-tentative = abap_false.
    temp10-aria = `Dialog`.
    INSERT temp10 INTO TABLE temp9.
    temp10-start_at = `2017-01-25T00:01:00`.
    temp10-end_at = `2017-01-26T23:59:00`.
    temp10-title = `Workshop`.
    temp10-info = `regular`.
    temp10-type = `Type07`.
    temp10-pic = `sap-icon://sap-ui5`.
    temp10-tentative = abap_false.
    temp10-aria = `Dialog`.
    INSERT temp10 INTO TABLE temp9.
    temp10-start_at = `2017-03-30T10:00:00`.
    temp10-end_at = `2017-06-02T12:00:00`.
    temp10-title = `Working out of the building`.
    temp10-info = ``.
    temp10-type = `Type07`.
    temp10-pic = `sap-icon://sap-ui5`.
    temp10-tentative = abap_false.
    temp10-aria = `Dialog`.
    INSERT temp10 INTO TABLE temp9.
    temp10-start_at = `2017-09-01T00:30:00`.
    temp10-end_at = `2017-11-15T23:30:00`.
    temp10-title = `Development of a new Product`.
    temp10-info = `room 207`.
    temp10-type = `Type03`.
    temp10-pic = ``.
    temp10-tentative = abap_true.
    temp10-aria = `Dialog`.
    INSERT temp10 INTO TABLE temp9.
    temp10-start_at = `2017-02-15T10:00:00`.
    temp10-end_at = `2017-03-25T12:00:00`.
    temp10-title = `Team collaboration`.
    temp10-info = `room 1`.
    temp10-type = `Type01`.
    temp10-pic = `sap-icon://sap-ui5`.
    temp10-tentative = abap_false.
    temp10-aria = `Dialog`.
    INSERT temp10 INTO TABLE temp9.
    temp10-start_at = `2017-03-13T09:00:00`.
    temp10-end_at = `2017-04-09T10:00:00`.
    temp10-title = `Reminder`.
    temp10-info = ``.
    temp10-type = `Type06`.
    temp10-pic = ``.
    temp10-tentative = abap_false.
    temp10-aria = `None`.
    INSERT temp10 INTO TABLE temp9.
    temp10-start_at = `2017-04-10T00:00:00`.
    temp10-end_at = `2017-06-16T23:59:00`.
    temp10-title = `Vacation`.
    temp10-info = `out of office`.
    temp10-type = `Type04`.
    temp10-pic = ``.
    temp10-tentative = abap_false.
    temp10-aria = `Dialog`.
    INSERT temp10 INTO TABLE temp9.
    temp10-start_at = `2017-08-01T00:00:00`.
    temp10-end_at = `2017-10-31T23:59:00`.
    temp10-title = `New quarter`.
    temp10-info = ``.
    temp10-type = `Type10`.
    temp10-pic = ``.
    temp10-tentative = abap_false.
    temp10-aria = `Dialog`.
    INSERT temp10 INTO TABLE temp9.
    temp8-t_appointments = temp9.
    
    CLEAR temp11.
    
    temp12-start_at = `2017-01-08T00:00:00`.
    temp12-end_at = `2017-01-08T23:59:00`.
    temp12-title = `National holiday`.
    temp12-type = `Type04`.
    INSERT temp12 INTO TABLE temp11.
    temp12-start_at = `2017-01-10T00:00:00`.
    temp12-end_at = `2017-01-10T23:59:00`.
    temp12-title = `Birthday`.
    temp12-type = `Type06`.
    INSERT temp12 INTO TABLE temp11.
    temp12-start_at = `2017-01-17T00:00:00`.
    temp12-end_at = `2017-01-17T23:59:00`.
    temp12-title = `Reminder`.
    temp12-type = `Type06`.
    INSERT temp12 INTO TABLE temp11.
    temp8-t_headers = temp11.
    INSERT temp8 INTO TABLE temp7.
    t_people = temp7.

  ENDMETHOD.

ENDCLASS.
