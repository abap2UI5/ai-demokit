" @keywords planningcalendar planning calendar sap.m planningcalendarminmax vbox title planningcalendarrow calendarappointment
" @summary PlanningCalendar with min. date 2000-01-01 and max. date 2050-12-31
CLASS z2ui5_cl_smpc_app_540 DEFINITION PUBLIC.

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
             pic      TYPE string,
           END OF ty_s_header.
    TYPES ty_t_header TYPE STANDARD TABLE OF ty_s_header WITH DEFAULT KEY.
    TYPES: BEGIN OF ty_s_person,
             pic            TYPE string,
             name           TYPE string,
             role           TYPE string,
             t_appointments TYPE ty_t_appointment,
             t_headers      TYPE ty_t_header,
           END OF ty_s_person.
    DATA t_people TYPE STANDARD TABLE OF ty_s_person WITH DEFAULT KEY.

    DATA start_date TYPE string.
    DATA min_date   TYPE string.
    DATA max_date   TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_540 IMPLEMENTATION.

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
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " calendar date properties are typed "object" and demand a real JS Date;
    " the model keeps ISO strings and Formatter.DateCreateObject converts them
    
    CLEAR temp1.
    INSERT `${$parameters>/appointment} ? ${$parameters>/appointment}.getTitle() : ''` INTO TABLE temp1.
    INSERT `${$parameters>/appointment} ? ${$parameters>/appointment}.getSelected() : false` INTO TABLE temp1.
    INSERT `$event.oSource.getSelectedAppointments().length` INTO TABLE temp1.
    INSERT `${$parameters>/appointments} ? ${$parameters>/appointments}.length : 0` INTO TABLE temp1.
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
                )->a( n = `showIntervalHeaders`       v = `false`
                )->a( n = `startDate`                 v = |\{ path: '{ client->_bind_path( start_date ) }', formatter: 'Formatter.DateCreateObject' \}|
                )->a( n = `minDate`                   v = |\{ path: '{ client->_bind_path( min_date ) }', formatter: 'Formatter.DateCreateObject' \}|
                )->a( n = `maxDate`                   v = |\{ path: '{ client->_bind_path( max_date ) }', formatter: 'Formatter.DateCreateObject' \}|
                )->a( n = `rows`                      v = client->_bind( t_people )
                )->a( n = `appointmentsVisualization` v = `Filled`
                " handleAppointmentSelect: MessageBox with the appointment title, its
                " new selected state and the number of selected appointments - or, when
                " the interval selection hit no appointment, the count of them
                )->a( n = `appointmentSelect`         v = client->_event(
                          val   = `APPT_SELECT`
                          t_arg = temp1 )

                )->ele( `toolbarContent`
                    )->tag( `Title`
                        )->a( n = `text`       v = `Title`
                        )->a( n = `titleStyle` v = `H4`

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
      DATA appt_title TYPE string.
        DATA temp3 TYPE string.
        DATA selected LIKE temp3.

    IF client->get_event( ) = `APPT_SELECT`.
      
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
    ENDIF.

  ENDMETHOD.


  METHOD model_init.
    DATA temp4 LIKE t_people.
    DATA temp5 LIKE LINE OF temp4.
    DATA temp1 TYPE z2ui5_cl_smpc_app_540=>ty_t_appointment.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp3 TYPE z2ui5_cl_smpc_app_540=>ty_t_appointment.
    DATA temp6 LIKE LINE OF temp3.

    start_date = `2017-01-15T08:00:00`.
    min_date   = `2000-01-01T00:00:00`.
    max_date   = `2050-12-31T23:59:00`.

    
    CLEAR temp4.
    
    temp5-pic = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/John_Miller.png`.
    temp5-name = `John Miller`.
    temp5-role = `team member`.
    
    CLEAR temp1.
    
    temp2-start_at = `2016-10-20T10:00:00`.
    temp2-end_at = `2016-12-15T12:00:00`.
    temp2-title = `Working out of the building`.
    temp2-type = `Type07`.
    temp2-pic = `sap-icon://sap-ui5`.
    temp2-tentative = abap_false.
    temp2-aria = `Dialog`.
    INSERT temp2 INTO TABLE temp1.
    temp2-start_at = `2017-01-15T08:30:00`.
    temp2-end_at = `2017-01-15T09:30:00`.
    temp2-title = `Meeting with Max Mustermann`.
    temp2-type = `Type02`.
    temp2-tentative = abap_false.
    temp2-aria = `Dialog`.
    INSERT temp2 INTO TABLE temp1.
    temp2-start_at = `2017-01-15T10:00:00`.
    temp2-end_at = `2017-01-15T12:00:00`.
    temp2-title = `Team meeting`.
    temp2-info = `room 1`.
    temp2-type = `Type01`.
    temp2-pic = `sap-icon://sap-ui5`.
    temp2-tentative = abap_false.
    temp2-aria = `Dialog`.
    INSERT temp2 INTO TABLE temp1.
    temp2-start_at = `2017-01-15T11:30:00`.
    temp2-end_at = `2017-01-15T13:30:00`.
    temp2-title = `Lunch`.
    temp2-info = `canteen`.
    temp2-type = `Type03`.
    temp2-tentative = abap_true.
    temp2-aria = `Dialog`.
    INSERT temp2 INTO TABLE temp1.
    temp2-start_at = `2017-01-15T13:30:00`.
    temp2-end_at = `2017-01-15T17:30:00`.
    temp2-title = `Discussion with clients`.
    temp2-info = `online meeting`.
    temp2-type = `Type02`.
    temp2-tentative = abap_false.
    temp2-aria = `Dialog`.
    INSERT temp2 INTO TABLE temp1.
    temp2-start_at = `2017-01-16T00:01:00`.
    temp2-end_at = `2017-01-16T23:59:00`.
    temp2-title = `Discussion`.
    temp2-info = `Online meeting`.
    temp2-type = `Type04`.
    temp2-tentative = abap_false.
    temp2-aria = `Dialog`.
    INSERT temp2 INTO TABLE temp1.
    temp2-start_at = `2017-01-18T08:30:00`.
    temp2-end_at = `2017-01-18T09:30:00`.
    temp2-title = `Meeting with the manager`.
    temp2-type = `Type02`.
    temp2-tentative = abap_false.
    temp2-aria = `Dialog`.
    INSERT temp2 INTO TABLE temp1.
    temp2-start_at = `2017-01-18T11:00:00`.
    temp2-end_at = `2017-01-18T13:30:00`.
    temp2-title = `Lunch`.
    temp2-info = `canteen`.
    temp2-type = `Type03`.
    temp2-tentative = abap_true.
    temp2-aria = `Dialog`.
    INSERT temp2 INTO TABLE temp1.
    temp2-start_at = `2017-01-18T01:00:00`.
    temp2-end_at = `2017-01-18T22:00:00`.
    temp2-title = `Team meeting`.
    temp2-info = `regular`.
    temp2-type = `Type01`.
    temp2-pic = `sap-icon://sap-ui5`.
    temp2-tentative = abap_false.
    temp2-aria = `Dialog`.
    INSERT temp2 INTO TABLE temp1.
    temp2-start_at = `2017-01-21T00:30:00`.
    temp2-end_at = `2017-01-21T23:30:00`.
    temp2-title = `New Product`.
    temp2-info = `room 105`.
    temp2-type = `Type03`.
    temp2-tentative = abap_true.
    temp2-aria = `Dialog`.
    INSERT temp2 INTO TABLE temp1.
    temp2-start_at = `2017-01-25T11:30:00`.
    temp2-end_at = `2017-01-25T13:30:00`.
    temp2-title = `Lunch`.
    temp2-type = `Type03`.
    temp2-tentative = abap_true.
    temp2-aria = `Dialog`.
    INSERT temp2 INTO TABLE temp1.
    temp2-start_at = `2017-01-29T10:00:00`.
    temp2-end_at = `2017-01-29T12:00:00`.
    temp2-title = `Team meeting`.
    temp2-info = `room 1`.
    temp2-type = `Type01`.
    temp2-pic = `sap-icon://sap-ui5`.
    temp2-tentative = abap_false.
    temp2-aria = `Dialog`.
    INSERT temp2 INTO TABLE temp1.
    temp2-start_at = `2017-01-30T08:00:00`.
    temp2-end_at = `2017-01-30T09:30:00`.
    temp2-title = `Meet Max Mustermann`.
    temp2-type = `Type02`.
    temp2-tentative = abap_false.
    temp2-aria = `Dialog`.
    INSERT temp2 INTO TABLE temp1.
    temp2-start_at = `2017-01-30T10:00:00`.
    temp2-end_at = `2017-01-30T12:00:00`.
    temp2-title = `Team meeting`.
    temp2-info = `room 1`.
    temp2-type = `Type01`.
    temp2-pic = `sap-icon://sap-ui5`.
    temp2-tentative = abap_false.
    temp2-aria = `Dialog`.
    INSERT temp2 INTO TABLE temp1.
    temp2-start_at = `2017-01-30T11:30:00`.
    temp2-end_at = `2017-01-30T13:30:00`.
    temp2-title = `Lunch`.
    temp2-type = `Type03`.
    temp2-tentative = abap_true.
    temp2-aria = `Dialog`.
    INSERT temp2 INTO TABLE temp1.
    temp2-start_at = `2017-01-30T13:30:00`.
    temp2-end_at = `2017-01-30T17:30:00`.
    temp2-title = `Discussion with clients`.
    temp2-type = `Type02`.
    temp2-tentative = abap_false.
    temp2-aria = `Dialog`.
    INSERT temp2 INTO TABLE temp1.
    temp2-start_at = `2017-01-31T10:00:00`.
    temp2-end_at = `2017-01-31T11:30:00`.
    temp2-title = `Discussion of the plan`.
    temp2-info = `Online meeting`.
    temp2-type = `Type04`.
    temp2-tentative = abap_false.
    temp2-aria = `Dialog`.
    INSERT temp2 INTO TABLE temp1.
    temp2-start_at = `2017-02-01T01:00:00`.
    temp2-end_at = `2017-02-02T22:00:00`.
    temp2-title = `Workshop`.
    temp2-info = `regular`.
    temp2-type = `Type07`.
    temp2-pic = `sap-icon://sap-ui5`.
    temp2-tentative = abap_false.
    temp2-aria = `Dialog`.
    INSERT temp2 INTO TABLE temp1.
    temp2-start_at = `2017-02-03T08:30:00`.
    temp2-end_at = `2017-02-13T09:30:00`.
    temp2-title = `Meeting with the manager`.
    temp2-type = `Type02`.
    temp2-tentative = abap_false.
    temp2-aria = `Dialog`.
    INSERT temp2 INTO TABLE temp1.
    temp2-start_at = `2017-02-04T10:00:00`.
    temp2-end_at = `2017-02-04T12:00:00`.
    temp2-title = `Team meeting`.
    temp2-info = `room 1`.
    temp2-type = `Type01`.
    temp2-pic = `sap-icon://sap-ui5`.
    temp2-tentative = abap_false.
    temp2-aria = `Dialog`.
    INSERT temp2 INTO TABLE temp1.
    temp2-start_at = `2017-03-30T10:00:00`.
    temp2-end_at = `2017-05-31T12:00:00`.
    temp2-title = `Working out of the building`.
    temp2-type = `Type07`.
    temp2-pic = `sap-icon://sap-ui5`.
    temp2-tentative = abap_false.
    temp2-aria = `Dialog`.
    INSERT temp2 INTO TABLE temp1.
    temp2-start_at = `2017-09-01T00:30:00`.
    temp2-end_at = `2017-11-15T23:30:00`.
    temp2-title = `Development of a new Product`.
    temp2-info = `room 207`.
    temp2-type = `Type03`.
    temp2-tentative = abap_true.
    temp2-aria = `Dialog`.
    INSERT temp2 INTO TABLE temp1.
    temp5-t_appointments = temp1.
    INSERT temp5 INTO TABLE temp4.
    temp5-pic = `sap-icon://employee`.
    temp5-name = `Max Mustermann`.
    temp5-role = `team member`.
    
    CLEAR temp3.
    
    temp6-start_at = `2016-08-15T10:00:00`.
    temp6-end_at = `2016-09-25T12:00:00`.
    temp6-title = `Team collaboration`.
    temp6-info = `room 1`.
    temp6-type = `Type01`.
    temp6-pic = `sap-icon://sap-ui5`.
    temp6-tentative = abap_false.
    temp6-aria = `Dialog`.
    INSERT temp6 INTO TABLE temp3.
    temp6-start_at = `2017-01-15T08:30:00`.
    temp6-end_at = `2017-01-15T09:30:00`.
    temp6-title = `Meeting with John Miller`.
    temp6-type = `Type02`.
    temp6-tentative = abap_false.
    temp6-aria = `Dialog`.
    INSERT temp6 INTO TABLE temp3.
    temp6-start_at = `2017-01-15T10:00:00`.
    temp6-end_at = `2017-01-15T12:00:00`.
    temp6-title = `Team meeting`.
    temp6-info = `room 1`.
    temp6-type = `Type01`.
    temp6-pic = `sap-icon://sap-ui5`.
    temp6-tentative = abap_false.
    temp6-aria = `Dialog`.
    INSERT temp6 INTO TABLE temp3.
    temp6-start_at = `2017-01-15T13:00:00`.
    temp6-end_at = `2017-01-15T16:00:00`.
    temp6-title = `Discussion with clients`.
    temp6-info = `online`.
    temp6-type = `Type02`.
    temp6-tentative = abap_false.
    temp6-aria = `Dialog`.
    INSERT temp6 INTO TABLE temp3.
    temp6-start_at = `2017-01-16T00:00:00`.
    temp6-end_at = `2017-01-16T23:59:00`.
    temp6-title = `Vacation`.
    temp6-info = `out of office`.
    temp6-type = `Type04`.
    temp6-tentative = abap_false.
    temp6-aria = `Dialog`.
    INSERT temp6 INTO TABLE temp3.
    temp6-start_at = `2017-01-17T01:00:00`.
    temp6-end_at = `2017-01-18T22:00:00`.
    temp6-title = `Workshop`.
    temp6-info = `regular`.
    temp6-type = `Type07`.
    temp6-pic = `sap-icon://sap-ui5`.
    temp6-tentative = abap_false.
    temp6-aria = `Dialog`.
    INSERT temp6 INTO TABLE temp3.
    temp6-start_at = `2017-01-19T08:30:00`.
    temp6-end_at = `2017-01-19T18:30:00`.
    temp6-title = `Meet John Miller`.
    temp6-type = `Type02`.
    temp6-tentative = abap_false.
    temp6-aria = `Dialog`.
    INSERT temp6 INTO TABLE temp3.
    temp6-start_at = `2017-01-19T00:01:00`.
    temp6-end_at = `2017-01-19T23:59:00`.
    temp6-title = `Team meeting`.
    temp6-info = `room 102`.
    temp6-type = `Type01`.
    temp6-pic = `sap-icon://sap-ui5`.
    temp6-tentative = abap_false.
    temp6-aria = `Dialog`.
    INSERT temp6 INTO TABLE temp3.
    temp6-start_at = `2017-01-19T07:00:00`.
    temp6-end_at = `2017-01-19T17:30:00`.
    temp6-title = `Discussion with clients`.
    temp6-type = `Type02`.
    temp6-tentative = abap_false.
    temp6-aria = `Dialog`.
    INSERT temp6 INTO TABLE temp3.
    temp6-start_at = `2017-01-20T00:00:00`.
    temp6-end_at = `2017-01-20T23:59:00`.
    temp6-title = `Vacation`.
    temp6-info = `out of office`.
    temp6-type = `Type04`.
    temp6-tentative = abap_false.
    temp6-aria = `Dialog`.
    INSERT temp6 INTO TABLE temp3.
    temp6-start_at = `2017-01-22T07:00:00`.
    temp6-end_at = `2017-01-27T17:30:00`.
    temp6-title = `Discussion with clients`.
    temp6-info = `out of office`.
    temp6-type = `Type02`.
    temp6-tentative = abap_false.
    temp6-aria = `Dialog`.
    INSERT temp6 INTO TABLE temp3.
    temp6-start_at = `2017-02-15T10:00:00`.
    temp6-end_at = `2017-03-25T12:00:00`.
    temp6-title = `Team collaboration`.
    temp6-info = `room 1`.
    temp6-type = `Type01`.
    temp6-pic = `sap-icon://sap-ui5`.
    temp6-tentative = abap_false.
    temp6-aria = `Dialog`.
    INSERT temp6 INTO TABLE temp3.
    temp6-start_at = `2017-03-13T09:00:00`.
    temp6-end_at = `2017-04-09T10:00:00`.
    temp6-title = `Reminder`.
    temp6-type = `Type06`.
    temp6-aria = `Dialog`.
    INSERT temp6 INTO TABLE temp3.
    temp6-start_at = `2017-04-10T00:00:00`.
    temp6-end_at = `2017-06-16T23:59:00`.
    temp6-title = `Vacation`.
    temp6-info = `out of office`.
    temp6-type = `Type04`.
    temp6-tentative = abap_false.
    temp6-aria = `Dialog`.
    INSERT temp6 INTO TABLE temp3.
    temp6-start_at = `2017-08-01T00:00:00`.
    temp6-end_at = `2017-10-31T23:59:00`.
    temp6-title = `New quarter`.
    temp6-type = `Type10`.
    temp6-tentative = abap_false.
    temp6-aria = `Dialog`.
    INSERT temp6 INTO TABLE temp3.
    temp5-t_appointments = temp3.
    INSERT temp5 INTO TABLE temp4.
    t_people = temp4.

  ENDMETHOD.

ENDCLASS.
