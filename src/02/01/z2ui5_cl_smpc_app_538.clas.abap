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
    TYPES ty_t_appointment TYPE STANDARD TABLE OF ty_s_appointment WITH DEFAULT KEY.
    TYPES: BEGIN OF ty_s_person,
             pic            TYPE string,
             name           TYPE string,
             role           TYPE string,
             t_appointments TYPE ty_t_appointment,

             selected       TYPE abap_bool,
           END OF ty_s_person.
    DATA t_people TYPE STANDARD TABLE OF ty_s_person WITH DEFAULT KEY.

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

    " calendar date properties are typed "object" and demand a real JS Date;
    " the model keeps ISO strings and Formatter.DateCreateObject converts them
    
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
    INSERT `${$parameters>/row} ? $event.oSource.indexOfRow(${$parameters>/row}) : -1` INTO TABLE temp2.
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
                )->a( n = `startDate`                 v = |\{ path: '{ client->_bind_path( start_date ) }', formatter: 'Formatter.DateCreateObject' \}|
                )->a( n = `rows`                      v = client->_bind( t_people )
                )->a( n = `appointmentsVisualization` v = `Filled`
                " handleAppointmentSelect: MessageBox with the appointment title, its
                " new selected state and the number of selected appointments - or, when
                " the interval selection hit no appointment, the count of them
                )->a( n = `appointmentSelect`         v = client->_event(
                          val   = `APPT_SELECT`
                          t_arg = temp1 )
                " handleIntervalSelect pushes a 'new appointment' (Type09) into the row
                " it hit, or into every selected row. The interval's start and end travel
                " as their LOCAL parts - a UTC toISOString( ) would shift the day
                )->a( n = `intervalSelect`            v = client->_event(
                          val   = `INTERVAL_SELECT`
                          t_arg = temp2 )

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
        DATA appt_title TYPE string.
          DATA temp3 TYPE string.
          DATA selected LIKE temp3.
        DATA temp4 TYPE i.
        DATA temp12 TYPE i.
        DATA temp1 TYPE i.
        DATA temp14 TYPE i.
        DATA iso_start TYPE string.
        DATA temp5 TYPE i.
        DATA temp13 TYPE i.
        DATA temp2 TYPE i.
        DATA temp15 TYPE i.
        DATA iso_end TYPE string.
        DATA temp6 TYPE ty_s_appointment.
        DATA appointment LIKE temp6.
        DATA temp7 TYPE i.
        DATA row_index LIKE temp7.
        DATA temp8 TYPE string_table.
        DATA rows LIKE temp8.
          DATA temp9 LIKE LINE OF rows.
          DATA person_sel LIKE LINE OF t_people.
              DATA temp10 LIKE LINE OF rows.
        DATA index LIKE LINE OF rows.
          DATA temp11 TYPE i.
          FIELD-SYMBOLS <person> TYPE z2ui5_cl_smpc_app_538=>ty_s_person.

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
        
        temp4 = client->get_event_arg( 2 ).
        
        temp12 = client->get_event_arg( 3 ).
        
        temp1 = client->get_event_arg( 4 ).
        
        temp14 = client->get_event_arg( 5 ).
        
        iso_start = |{ client->get_event_arg( ) }-{ temp4 WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
                          |-{ temp12 WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
                          |T{ temp1 WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
                          |:{ temp14 WIDTH = 2 ALIGN = RIGHT PAD = '0' }:00|.
        
        temp5 = client->get_event_arg( 7 ).
        
        temp13 = client->get_event_arg( 8 ).
        
        temp2 = client->get_event_arg( 9 ).
        
        temp15 = client->get_event_arg( 10 ).
        
        iso_end = |{ client->get_event_arg( 6 ) }-{ temp5 WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
                        |-{ temp13 WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
                        |T{ temp2 WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
                        |:{ temp15 WIDTH = 2 ALIGN = RIGHT PAD = '0' }:00|.
        
        CLEAR temp6.
        temp6-start_at = iso_start.
        temp6-end_at = iso_end.
        temp6-title = `new appointment`.
        temp6-type = `Type09`.
        temp6-aria = `None`.
        
        appointment = temp6.
        
        temp7 = client->get_event_arg( 11 ).
        
        row_index = temp7.
        " the selected rows are read from the model, not transported: PlanningCalendarRow
        " has a bindable `selected`, and a JS callback (getSelectedRows().map(function...))
        " is not in the UI5 expression grammar - it threw and lost the whole handler
        
        CLEAR temp8.
        
        rows = temp8.
        IF row_index >= 0.
          
          temp9 = |{ row_index }|.
          APPEND temp9 TO rows.
        ELSE.
          
          LOOP AT t_people INTO person_sel.
            IF person_sel-selected = abap_true.
              
              temp10 = |{ sy-tabix - 1 }|.
              APPEND temp10 TO rows.
            ENDIF.
          ENDLOOP.
        ENDIF.
        " the row is addressed through a field symbol, not a table expression:
        " abaplint's downport leaves an itab[ ] TARGET of INSERT/DELETE in
        " place, and the 702 parser rejects it
        
        LOOP AT rows INTO index.
          
          temp11 = index.
          
          READ TABLE t_people INDEX temp11 + 1 ASSIGNING <person>.
          IF sy-subrc = 0.
            INSERT appointment INTO TABLE <person>-t_appointments.
          ENDIF.
        ENDLOOP.

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.
    DATA temp12 LIKE t_people.
    DATA temp13 LIKE LINE OF temp12.
    DATA temp14 TYPE z2ui5_cl_smpc_app_538=>ty_t_appointment.
    DATA temp15 LIKE LINE OF temp14.
    DATA temp16 TYPE z2ui5_cl_smpc_app_538=>ty_t_appointment.
    DATA temp17 LIKE LINE OF temp16.

    start_date = `2017-01-15T08:00:00`.

    
    CLEAR temp12.
    
    temp13-pic = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/John_Miller.png`.
    temp13-name = `John Miller`.
    temp13-role = `team member`.
    
    CLEAR temp14.
    
    temp15-start_at = `2016-10-20T10:00:00`.
    temp15-end_at = `2016-12-15T12:00:00`.
    temp15-title = `Working out of the building`.
    temp15-type = `Type07`.
    temp15-pic = `sap-icon://sap-ui5`.
    temp15-tentative = abap_false.
    temp15-aria = `Dialog`.
    INSERT temp15 INTO TABLE temp14.
    temp15-start_at = `2017-01-15T08:30:00`.
    temp15-end_at = `2017-01-15T09:30:00`.
    temp15-title = `Meet Max Mustermann`.
    temp15-type = `Type02`.
    temp15-tentative = abap_false.
    temp15-aria = `Dialog`.
    INSERT temp15 INTO TABLE temp14.
    temp15-start_at = `2017-01-15T10:00:00`.
    temp15-end_at = `2017-01-15T12:00:00`.
    temp15-title = `Team meeting`.
    temp15-info = `room 1`.
    temp15-type = `Type01`.
    temp15-pic = `sap-icon://sap-ui5`.
    temp15-tentative = abap_false.
    temp15-aria = `Dialog`.
    INSERT temp15 INTO TABLE temp14.
    temp15-start_at = `2017-01-15T11:30:00`.
    temp15-end_at = `2017-01-15T13:30:00`.
    temp15-title = `Lunch`.
    temp15-info = `canteen`.
    temp15-type = `Type03`.
    temp15-tentative = abap_true.
    temp15-aria = `Dialog`.
    INSERT temp15 INTO TABLE temp14.
    temp15-start_at = `2017-01-15T13:30:00`.
    temp15-end_at = `2017-01-15T17:30:00`.
    temp15-title = `Discussion with clients`.
    temp15-info = `online meeting`.
    temp15-type = `Type02`.
    temp15-tentative = abap_false.
    temp15-aria = `Dialog`.
    INSERT temp15 INTO TABLE temp14.
    temp15-start_at = `2017-01-16T00:01:00`.
    temp15-end_at = `2017-01-16T23:59:00`.
    temp15-title = `Discussion`.
    temp15-info = `Online meeting`.
    temp15-type = `Type04`.
    temp15-tentative = abap_false.
    temp15-aria = `Dialog`.
    INSERT temp15 INTO TABLE temp14.
    temp15-start_at = `2017-01-18T08:30:00`.
    temp15-end_at = `2017-01-18T09:30:00`.
    temp15-title = `Meeting with the manager`.
    temp15-type = `Type02`.
    temp15-tentative = abap_false.
    temp15-aria = `Dialog`.
    INSERT temp15 INTO TABLE temp14.
    temp15-start_at = `2017-01-18T11:30:00`.
    temp15-end_at = `2017-01-18T13:30:00`.
    temp15-title = `Lunch`.
    temp15-info = `canteen`.
    temp15-type = `Type03`.
    temp15-tentative = abap_true.
    temp15-aria = `Dialog`.
    INSERT temp15 INTO TABLE temp14.
    temp15-start_at = `2017-01-18T01:00:00`.
    temp15-end_at = `2017-01-18T22:00:00`.
    temp15-title = `Team meeting`.
    temp15-info = `regular`.
    temp15-type = `Type01`.
    temp15-pic = `sap-icon://sap-ui5`.
    temp15-tentative = abap_false.
    temp15-aria = `Dialog`.
    INSERT temp15 INTO TABLE temp14.
    temp15-start_at = `2017-01-21T00:30:00`.
    temp15-end_at = `2017-01-21T23:30:00`.
    temp15-title = `New Product`.
    temp15-info = `room 105`.
    temp15-type = `Type03`.
    temp15-tentative = abap_true.
    temp15-aria = `Dialog`.
    INSERT temp15 INTO TABLE temp14.
    temp15-start_at = `2017-01-25T11:30:00`.
    temp15-end_at = `2017-01-25T13:30:00`.
    temp15-title = `Lunch`.
    temp15-type = `Type03`.
    temp15-tentative = abap_true.
    temp15-aria = `Dialog`.
    INSERT temp15 INTO TABLE temp14.
    temp15-start_at = `2017-01-29T10:00:00`.
    temp15-end_at = `2017-01-29T12:00:00`.
    temp15-title = `Team meeting`.
    temp15-info = `room 1`.
    temp15-type = `Type01`.
    temp15-pic = `sap-icon://sap-ui5`.
    temp15-tentative = abap_false.
    temp15-aria = `Dialog`.
    INSERT temp15 INTO TABLE temp14.
    temp15-start_at = `2017-01-30T08:30:00`.
    temp15-end_at = `2017-01-30T09:30:00`.
    temp15-title = `Meet Max Mustermann`.
    temp15-type = `Type02`.
    temp15-tentative = abap_false.
    temp15-aria = `Dialog`.
    INSERT temp15 INTO TABLE temp14.
    temp15-start_at = `2017-01-30T10:00:00`.
    temp15-end_at = `2017-01-30T12:00:00`.
    temp15-title = `Team meeting`.
    temp15-info = `room 1`.
    temp15-type = `Type01`.
    temp15-pic = `sap-icon://sap-ui5`.
    temp15-tentative = abap_false.
    temp15-aria = `Dialog`.
    INSERT temp15 INTO TABLE temp14.
    temp15-start_at = `2017-01-30T11:30:00`.
    temp15-end_at = `2017-01-30T13:30:00`.
    temp15-title = `Lunch`.
    temp15-type = `Type03`.
    temp15-tentative = abap_true.
    temp15-aria = `Dialog`.
    INSERT temp15 INTO TABLE temp14.
    temp15-start_at = `2017-01-30T13:30:00`.
    temp15-end_at = `2017-01-30T17:30:00`.
    temp15-title = `Discussion with clients`.
    temp15-type = `Type02`.
    temp15-tentative = abap_false.
    temp15-aria = `Dialog`.
    INSERT temp15 INTO TABLE temp14.
    temp15-start_at = `2017-01-31T10:00:00`.
    temp15-end_at = `2017-01-31T11:30:00`.
    temp15-title = `Discussion of the plan`.
    temp15-info = `Online meeting`.
    temp15-type = `Type04`.
    temp15-tentative = abap_false.
    temp15-aria = `Dialog`.
    INSERT temp15 INTO TABLE temp14.
    temp15-start_at = `2017-02-01T01:00:00`.
    temp15-end_at = `2017-02-02T22:00:00`.
    temp15-title = `Workshop`.
    temp15-info = `regular`.
    temp15-type = `Type07`.
    temp15-pic = `sap-icon://sap-ui5`.
    temp15-tentative = abap_false.
    temp15-aria = `Dialog`.
    INSERT temp15 INTO TABLE temp14.
    temp15-start_at = `2017-02-03T08:30:00`.
    temp15-end_at = `2017-02-13T09:30:00`.
    temp15-title = `Meeting with the manager`.
    temp15-type = `Type02`.
    temp15-tentative = abap_false.
    temp15-aria = `Dialog`.
    INSERT temp15 INTO TABLE temp14.
    temp15-start_at = `2017-02-04T10:00:00`.
    temp15-end_at = `2017-02-04T12:00:00`.
    temp15-title = `Team meeting`.
    temp15-info = `room 1`.
    temp15-type = `Type01`.
    temp15-pic = `sap-icon://sap-ui5`.
    temp15-tentative = abap_false.
    temp15-aria = `Dialog`.
    INSERT temp15 INTO TABLE temp14.
    temp15-start_at = `2017-03-30T10:00:00`.
    temp15-end_at = `2017-06-02T12:00:00`.
    temp15-title = `Working out of the building`.
    temp15-type = `Type07`.
    temp15-pic = `sap-icon://sap-ui5`.
    temp15-tentative = abap_false.
    temp15-aria = `Dialog`.
    INSERT temp15 INTO TABLE temp14.
    temp15-start_at = `2017-09-01T00:30:00`.
    temp15-end_at = `2017-11-15T23:30:00`.
    temp15-title = `Development of a new Product`.
    temp15-info = `room 207`.
    temp15-type = `Type03`.
    temp15-tentative = abap_true.
    temp15-aria = `Dialog`.
    INSERT temp15 INTO TABLE temp14.
    temp13-t_appointments = temp14.
    INSERT temp13 INTO TABLE temp12.
    temp13-pic = `sap-icon://employee`.
    temp13-name = `Max Mustermann`.
    temp13-role = `team member`.
    
    CLEAR temp16.
    
    temp17-start_at = `2016-08-15T10:00:00`.
    temp17-end_at = `2016-09-25T12:00:00`.
    temp17-title = `Team collaboration`.
    temp17-info = `room 1`.
    temp17-type = `Type01`.
    temp17-pic = `sap-icon://sap-ui5`.
    temp17-tentative = abap_false.
    temp17-aria = `Dialog`.
    INSERT temp17 INTO TABLE temp16.
    temp17-start_at = `2017-01-15T08:30:00`.
    temp17-end_at = `2017-01-15T09:30:00`.
    temp17-title = `Meet John Miller`.
    temp17-type = `Type02`.
    temp17-tentative = abap_false.
    temp17-aria = `Dialog`.
    INSERT temp17 INTO TABLE temp16.
    temp17-start_at = `2017-01-15T10:00:00`.
    temp17-end_at = `2017-01-15T12:00:00`.
    temp17-title = `Team meeting`.
    temp17-info = `room 1`.
    temp17-type = `Type01`.
    temp17-pic = `sap-icon://sap-ui5`.
    temp17-tentative = abap_false.
    temp17-aria = `Dialog`.
    INSERT temp17 INTO TABLE temp16.
    temp17-start_at = `2017-01-15T13:00:00`.
    temp17-end_at = `2017-01-15T16:00:00`.
    temp17-title = `Discussion with clients`.
    temp17-info = `online`.
    temp17-type = `Type02`.
    temp17-tentative = abap_false.
    temp17-aria = `Dialog`.
    INSERT temp17 INTO TABLE temp16.
    temp17-start_at = `2017-01-16T00:00:00`.
    temp17-end_at = `2017-01-16T23:59:00`.
    temp17-title = `Vacation`.
    temp17-info = `out of office`.
    temp17-type = `Type04`.
    temp17-tentative = abap_false.
    temp17-aria = `Dialog`.
    INSERT temp17 INTO TABLE temp16.
    temp17-start_at = `2017-01-17T01:00:00`.
    temp17-end_at = `2017-01-18T22:00:00`.
    temp17-title = `Workshop`.
    temp17-info = `regular`.
    temp17-type = `Type07`.
    temp17-pic = `sap-icon://sap-ui5`.
    temp17-tentative = abap_false.
    temp17-aria = `Dialog`.
    INSERT temp17 INTO TABLE temp16.
    temp17-start_at = `2017-01-19T08:30:00`.
    temp17-end_at = `2017-01-19T18:30:00`.
    temp17-title = `Meet John Doe`.
    temp17-type = `Type02`.
    temp17-tentative = abap_false.
    temp17-aria = `Dialog`.
    INSERT temp17 INTO TABLE temp16.
    temp17-start_at = `2017-01-19T00:01:00`.
    temp17-end_at = `2017-01-19T23:59:00`.
    temp17-title = `Team meeting`.
    temp17-info = `room 102`.
    temp17-type = `Type01`.
    temp17-pic = `sap-icon://sap-ui5`.
    temp17-tentative = abap_false.
    temp17-aria = `Dialog`.
    INSERT temp17 INTO TABLE temp16.
    temp17-start_at = `2017-01-19T07:00:00`.
    temp17-end_at = `2017-01-19T17:30:00`.
    temp17-title = `Discussion with clients`.
    temp17-type = `Type02`.
    temp17-tentative = abap_false.
    temp17-aria = `Dialog`.
    INSERT temp17 INTO TABLE temp16.
    temp17-start_at = `2017-01-20T00:00:00`.
    temp17-end_at = `2017-01-20T23:59:00`.
    temp17-title = `Vacation`.
    temp17-info = `out of office`.
    temp17-type = `Type04`.
    temp17-tentative = abap_false.
    temp17-aria = `Dialog`.
    INSERT temp17 INTO TABLE temp16.
    temp17-start_at = `2017-01-22T07:00:00`.
    temp17-end_at = `2017-01-27T17:30:00`.
    temp17-title = `Discussion with clients`.
    temp17-info = `out of office`.
    temp17-type = `Type02`.
    temp17-tentative = abap_false.
    temp17-aria = `Dialog`.
    INSERT temp17 INTO TABLE temp16.
    temp17-start_at = `2017-02-15T10:00:00`.
    temp17-end_at = `2017-03-25T12:00:00`.
    temp17-title = `Team collaboration`.
    temp17-info = `room 1`.
    temp17-type = `Type01`.
    temp17-pic = `sap-icon://sap-ui5`.
    temp17-tentative = abap_false.
    temp17-aria = `Dialog`.
    INSERT temp17 INTO TABLE temp16.
    temp17-start_at = `2017-03-13T09:00:00`.
    temp17-end_at = `2017-04-09T10:00:00`.
    temp17-title = `Reminder`.
    temp17-type = `Type06`.
    temp17-aria = `None`.
    INSERT temp17 INTO TABLE temp16.
    temp17-start_at = `2017-04-10T00:00:00`.
    temp17-end_at = `2017-06-16T23:59:00`.
    temp17-title = `Vacation`.
    temp17-info = `out of office`.
    temp17-type = `Type04`.
    temp17-tentative = abap_false.
    temp17-aria = `Dialog`.
    INSERT temp17 INTO TABLE temp16.
    temp17-start_at = `2017-08-01T00:00:00`.
    temp17-end_at = `2017-10-31T23:59:00`.
    temp17-title = `New quarter`.
    temp17-type = `Type10`.
    temp17-tentative = abap_false.
    temp17-aria = `Dialog`.
    INSERT temp17 INTO TABLE temp16.
    temp13-t_appointments = temp16.
    INSERT temp13 INTO TABLE temp12.
    t_people = temp12.

  ENDMETHOD.

ENDCLASS.
