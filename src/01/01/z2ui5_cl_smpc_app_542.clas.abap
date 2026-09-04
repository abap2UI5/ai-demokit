" @keywords planningcalendar planning calendar sap.m planningcalendarwithstickyheader vbox title planningcalendarrow calendarappointment label multicombobox item
" @summary PlanningCalendar with header area that remains visible (fixed on top) when the rest of the content is scrolled out of view.
CLASS z2ui5_cl_smpc_app_542 DEFINITION PUBLIC.

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
    DATA t_built_in TYPE string_table.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_542 IMPLEMENTATION.

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

    " the calendar date properties are typed "object" and demand a real JS Date;
    " the model keeps ISO strings and Formatter.DateCreateObject converts them
    
    CLEAR temp1.
    INSERT `${$parameters>/appointment} ? ${$parameters>/appointment}.getTitle() : ''` INTO TABLE temp1.
    INSERT `${$parameters>/appointment} ? ${$parameters>/appointment}.getSelected() : false` INTO TABLE temp1.
    INSERT `$event.oSource.getSelectedAppointments().length` INTO TABLE temp1.
    INSERT `${$parameters>/appointments} ? ${$parameters>/appointments}.length : 0` INTO TABLE temp1.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:core`    v = `sap.ui.core`
        )->a( n = `xmlns:mvc`     v = `sap.ui.core.mvc`
        )->a( n = `xmlns:unified` v = `sap.ui.unified`
        )->a( n = `xmlns`         v = `sap.m`
        )->a( n = `core:require`  v = `{Formatter: 'z2ui5/model/formatter'}`

        )->ele( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->ele( `PlanningCalendar`
                )->a( n = `id`                        v = `PC1`
                )->a( n = `startDate`                 v = |\{ path: '{ client->_bind_path( start_date ) }', formatter: 'Formatter.DateCreateObject' \}|
                )->a( n = `rows`                      v = client->_bind( t_people )
                )->a( n = `appointmentsVisualization` v = `Filled`
                " handleAppointmentSelect: MessageBox with the appointment title, its
                " new selected state and the number of selected appointments - or, when
                " the interval selection hit no appointment, the count of them
                )->a( n = `appointmentSelect`         v = client->_event(
                          val   = `APPT_SELECT`
                          t_arg = temp1 )
                )->a( n = `showEmptyIntervalHeaders`  v = `false`
                )->a( n = `stickyHeader`              v = `true`
                )->a( n = `showWeekNumbers`           v = `true`
                " handleSelectionFinish hands the MultiComboBox's selected keys to
                " setBuiltInViews - a bindable string[] property, bound here
                )->a( n = `builtInViews`              v = client->_bind( t_built_in )

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
                                )->a( n = `type`      v = `{TYPE}`

                        )->end(
                    )->end(
                )->end(
            )->end(

            )->tag( `Label`
                )->a( n = `text` v = `Add available built-in views to the example:`

            )->ele( `MultiComboBox`
                )->a( n = `selectionFinish` v = client->_event( val = `BUILT_IN_VIEWS` arg = `$event.oSource.getSelectedKeys().join(',')` )
                )->a( n = `width`           v = `230px`
                )->a( n = `placeholder`     v = `Choose built-in views`

                )->ele( `items`
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
                        )->a( n = `text` v = `1 month` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA appt_title TYPE string.
          DATA temp3 TYPE string.
          DATA selected LIKE temp3.

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

      WHEN `BUILT_IN_VIEWS`.
        " handleSelectionFinish: the picked keys become the calendar's built-in views
        CLEAR t_built_in.
        IF client->get_event_arg( ) IS NOT INITIAL.
          SPLIT client->get_event_arg( ) AT `,` INTO TABLE t_built_in.
        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.
    DATA temp4 LIKE t_people.
    DATA temp5 LIKE LINE OF temp4.
    DATA temp1 TYPE z2ui5_cl_smpc_app_542=>ty_t_appointment.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp3 TYPE z2ui5_cl_smpc_app_542=>ty_t_header.
    DATA temp6 LIKE LINE OF temp3.
    DATA temp7 TYPE z2ui5_cl_smpc_app_542=>ty_t_appointment.
    DATA temp8 LIKE LINE OF temp7.
    DATA temp9 TYPE z2ui5_cl_smpc_app_542=>ty_t_header.
    DATA temp10 LIKE LINE OF temp9.
    DATA temp11 TYPE z2ui5_cl_smpc_app_542=>ty_t_appointment.
    DATA temp12 LIKE LINE OF temp11.
    DATA temp13 TYPE z2ui5_cl_smpc_app_542=>ty_t_header.
    DATA temp14 LIKE LINE OF temp13.
    DATA temp15 TYPE z2ui5_cl_smpc_app_542=>ty_t_appointment.
    DATA temp16 LIKE LINE OF temp15.
    DATA temp17 TYPE z2ui5_cl_smpc_app_542=>ty_t_appointment.
    DATA temp18 LIKE LINE OF temp17.
    DATA temp19 TYPE z2ui5_cl_smpc_app_542=>ty_t_header.
    DATA temp20 LIKE LINE OF temp19.
    DATA temp21 TYPE z2ui5_cl_smpc_app_542=>ty_t_appointment.
    DATA temp22 LIKE LINE OF temp21.
    DATA temp23 TYPE z2ui5_cl_smpc_app_542=>ty_t_header.
    DATA temp24 LIKE LINE OF temp23.
    DATA temp25 TYPE z2ui5_cl_smpc_app_542=>ty_t_appointment.
    DATA temp26 LIKE LINE OF temp25.
    DATA temp27 TYPE z2ui5_cl_smpc_app_542=>ty_t_header.
    DATA temp28 LIKE LINE OF temp27.
    DATA temp29 TYPE z2ui5_cl_smpc_app_542=>ty_t_appointment.
    DATA temp30 LIKE LINE OF temp29.
    DATA temp31 TYPE z2ui5_cl_smpc_app_542=>ty_t_header.
    DATA temp32 LIKE LINE OF temp31.
    DATA temp33 TYPE z2ui5_cl_smpc_app_542=>ty_t_appointment.
    DATA temp34 LIKE LINE OF temp33.
    DATA temp35 TYPE z2ui5_cl_smpc_app_542=>ty_t_header.
    DATA temp36 LIKE LINE OF temp35.
    DATA temp37 TYPE z2ui5_cl_smpc_app_542=>ty_t_appointment.
    DATA temp38 LIKE LINE OF temp37.
    DATA temp39 TYPE z2ui5_cl_smpc_app_542=>ty_t_appointment.
    DATA temp40 LIKE LINE OF temp39.
    DATA temp41 TYPE z2ui5_cl_smpc_app_542=>ty_t_header.
    DATA temp42 LIKE LINE OF temp41.

    start_date = `2017-01-15T08:00:00`.

    
    CLEAR temp4.
    
    temp5-pic = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/John_Miller.png`.
    temp5-name = `John Miller`.
    temp5-role = `team member`.
    
    CLEAR temp1.
    
    temp2-start_at = `2017-01-08T08:30:00`.
    temp2-end_at = `2017-01-08T09:30:00`.
    temp2-title = `Meet Max Mustermann`.
    temp2-type = `Type02`.
    temp2-tentative = abap_false.
    INSERT temp2 INTO TABLE temp1.
    temp2-start_at = `2017-01-11T10:00:00`.
    temp2-end_at = `2017-01-11T12:00:00`.
    temp2-title = `Team meeting`.
    temp2-info = `room 1`.
    temp2-type = `Type01`.
    temp2-pic = `sap-icon://sap-ui5`.
    temp2-tentative = abap_false.
    INSERT temp2 INTO TABLE temp1.
    temp2-start_at = `2017-01-12T11:30:00`.
    temp2-end_at = `2017-01-12T13:30:00`.
    temp2-title = `Lunch`.
    temp2-info = `canteen`.
    temp2-type = `Type03`.
    temp2-tentative = abap_true.
    INSERT temp2 INTO TABLE temp1.
    temp2-start_at = `2017-01-15T08:30:00`.
    temp2-end_at = `2017-01-15T09:30:00`.
    temp2-title = `Meet Max Mustermann`.
    temp2-type = `Type02`.
    temp2-tentative = abap_false.
    INSERT temp2 INTO TABLE temp1.
    temp2-start_at = `2017-01-15T10:00:00`.
    temp2-end_at = `2017-01-15T12:00:00`.
    temp2-title = `Team meeting`.
    temp2-info = `room 1`.
    temp2-type = `Type01`.
    temp2-pic = `sap-icon://sap-ui5`.
    temp2-tentative = abap_false.
    INSERT temp2 INTO TABLE temp1.
    temp2-start_at = `2017-01-15T11:30:00`.
    temp2-end_at = `2017-01-15T13:30:00`.
    temp2-title = `Lunch`.
    temp2-info = `canteen`.
    temp2-type = `Type03`.
    temp2-tentative = abap_true.
    INSERT temp2 INTO TABLE temp1.
    temp2-start_at = `2017-01-15T13:30:00`.
    temp2-end_at = `2017-01-15T17:30:00`.
    temp2-title = `Discussion with clients`.
    temp2-info = `online meeting`.
    temp2-type = `Type02`.
    temp2-tentative = abap_false.
    INSERT temp2 INTO TABLE temp1.
    temp2-start_at = `2017-01-16T04:00:00`.
    temp2-end_at = `2017-01-16T22:30:00`.
    temp2-title = `Discussion of the plan`.
    temp2-info = `Online meeting`.
    temp2-type = `Type04`.
    temp2-tentative = abap_false.
    INSERT temp2 INTO TABLE temp1.
    temp2-start_at = `2017-01-18T08:30:00`.
    temp2-end_at = `2017-01-18T09:30:00`.
    temp2-title = `Meeting with the manager`.
    temp2-type = `Type02`.
    temp2-tentative = abap_false.
    INSERT temp2 INTO TABLE temp1.
    temp2-start_at = `2017-01-18T11:30:00`.
    temp2-end_at = `2017-01-18T13:30:00`.
    temp2-title = `Lunch`.
    temp2-info = `canteen`.
    temp2-type = `Type03`.
    temp2-tentative = abap_true.
    INSERT temp2 INTO TABLE temp1.
    temp2-start_at = `2017-01-18T01:00:00`.
    temp2-end_at = `2017-01-18T22:00:00`.
    temp2-title = `Team meeting`.
    temp2-info = `regular`.
    temp2-type = `Type01`.
    temp2-pic = `sap-icon://sap-ui5`.
    temp2-tentative = abap_false.
    INSERT temp2 INTO TABLE temp1.
    temp2-start_at = `2017-01-21T00:30:00`.
    temp2-end_at = `2017-01-21T23:30:00`.
    temp2-title = `New Product`.
    temp2-info = `room 105`.
    temp2-type = `Type03`.
    temp2-tentative = abap_true.
    INSERT temp2 INTO TABLE temp1.
    temp2-start_at = `2017-01-25T11:30:00`.
    temp2-end_at = `2017-01-25T13:30:00`.
    temp2-title = `Lunch`.
    temp2-type = `Type03`.
    temp2-tentative = abap_true.
    INSERT temp2 INTO TABLE temp1.
    temp2-start_at = `2017-01-29T10:00:00`.
    temp2-end_at = `2017-01-29T12:00:00`.
    temp2-title = `Team meeting`.
    temp2-info = `room 1`.
    temp2-type = `Type01`.
    temp2-pic = `sap-icon://sap-ui5`.
    temp2-tentative = abap_false.
    INSERT temp2 INTO TABLE temp1.
    temp2-start_at = `2017-01-30T08:30:00`.
    temp2-end_at = `2017-01-30T09:30:00`.
    temp2-title = `Meet Max Mustermann`.
    temp2-type = `Type02`.
    temp2-tentative = abap_false.
    INSERT temp2 INTO TABLE temp1.
    temp2-start_at = `2017-01-30T10:00:00`.
    temp2-end_at = `2017-01-30T12:00:00`.
    temp2-title = `Team meeting`.
    temp2-info = `room 1`.
    temp2-type = `Type01`.
    temp2-pic = `sap-icon://sap-ui5`.
    temp2-tentative = abap_false.
    INSERT temp2 INTO TABLE temp1.
    temp2-start_at = `2017-01-30T11:30:00`.
    temp2-end_at = `2017-01-30T13:30:00`.
    temp2-title = `Lunch`.
    temp2-type = `Type03`.
    temp2-tentative = abap_true.
    INSERT temp2 INTO TABLE temp1.
    temp2-start_at = `2017-01-30T13:30:00`.
    temp2-end_at = `2017-01-30T17:30:00`.
    temp2-title = `Discussion with clients`.
    temp2-type = `Type02`.
    temp2-tentative = abap_false.
    INSERT temp2 INTO TABLE temp1.
    temp2-start_at = `2017-01-31T10:00:00`.
    temp2-end_at = `2017-01-31T11:30:00`.
    temp2-title = `Discussion of the plan`.
    temp2-info = `Online meeting`.
    temp2-type = `Type04`.
    temp2-tentative = abap_false.
    INSERT temp2 INTO TABLE temp1.
    temp2-start_at = `2017-02-03T08:30:00`.
    temp2-end_at = `2017-02-13T09:30:00`.
    temp2-title = `Meeting with the manager`.
    temp2-type = `Type02`.
    temp2-tentative = abap_false.
    INSERT temp2 INTO TABLE temp1.
    temp2-start_at = `2017-02-04T10:00:00`.
    temp2-end_at = `2017-02-04T12:00:00`.
    temp2-title = `Team meeting`.
    temp2-info = `room 1`.
    temp2-type = `Type01`.
    temp2-pic = `sap-icon://sap-ui5`.
    temp2-tentative = abap_false.
    INSERT temp2 INTO TABLE temp1.
    temp2-start_at = `2017-03-30T10:00:00`.
    temp2-end_at = `2017-06-02T12:00:00`.
    temp2-title = `Working out of the building`.
    temp2-type = `Type07`.
    temp2-pic = `sap-icon://sap-ui5`.
    temp2-tentative = abap_false.
    INSERT temp2 INTO TABLE temp1.
    temp5-t_appointments = temp1.
    
    CLEAR temp3.
    
    temp6-start_at = `2017-01-15T08:00:00`.
    temp6-end_at = `2017-01-15T10:00:00`.
    temp6-title = `Reminder`.
    temp6-type = `Type06`.
    INSERT temp6 INTO TABLE temp3.
    temp6-start_at = `2017-01-15T17:00:00`.
    temp6-end_at = `2017-01-15T19:00:00`.
    temp6-title = `Reminder`.
    temp6-type = `Type06`.
    INSERT temp6 INTO TABLE temp3.
    temp6-start_at = `2017-09-01T00:00:00`.
    temp6-end_at = `2017-11-30T23:59:00`.
    temp6-title = `New quarter`.
    temp6-type = `Type10`.
    INSERT temp6 INTO TABLE temp3.
    temp6-start_at = `2018-02-01T00:00:00`.
    temp6-end_at = `2018-04-30T23:59:00`.
    temp6-title = `New quarter`.
    temp6-type = `Type10`.
    INSERT temp6 INTO TABLE temp3.
    temp5-t_headers = temp3.
    INSERT temp5 INTO TABLE temp4.
    temp5-pic = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/Donna_Moore.jpg`.
    temp5-name = `Donna Moore`.
    temp5-role = `team member`.
    
    CLEAR temp7.
    
    temp8-start_at = `2017-01-10T18:00:00`.
    temp8-end_at = `2017-01-10T19:10:00`.
    temp8-title = `Discussion of the plan`.
    temp8-info = `Online meeting`.
    temp8-type = `Type04`.
    temp8-tentative = abap_false.
    INSERT temp8 INTO TABLE temp7.
    temp8-start_at = `2017-01-09T10:00:00`.
    temp8-end_at = `2017-01-13T12:00:00`.
    temp8-title = `Workshop out of the country`.
    temp8-type = `Type07`.
    temp8-pic = `sap-icon://sap-ui5`.
    temp8-tentative = abap_false.
    INSERT temp8 INTO TABLE temp7.
    temp8-start_at = `2017-01-15T08:00:00`.
    temp8-end_at = `2017-01-15T09:30:00`.
    temp8-title = `Discussion of the plan`.
    temp8-info = `Online meeting`.
    temp8-type = `Type04`.
    temp8-tentative = abap_false.
    INSERT temp8 INTO TABLE temp7.
    temp8-start_at = `2017-01-15T10:00:00`.
    temp8-end_at = `2017-01-15T12:00:00`.
    temp8-title = `Team meeting`.
    temp8-info = `room 1`.
    temp8-type = `Type01`.
    temp8-pic = `sap-icon://sap-ui5`.
    temp8-tentative = abap_false.
    INSERT temp8 INTO TABLE temp7.
    temp8-start_at = `2017-01-15T18:00:00`.
    temp8-end_at = `2017-01-15T19:10:00`.
    temp8-title = `Discussion of the plan`.
    temp8-info = `Online meeting`.
    temp8-type = `Type04`.
    temp8-tentative = abap_false.
    INSERT temp8 INTO TABLE temp7.
    temp8-start_at = `2017-01-16T10:00:00`.
    temp8-end_at = `2017-01-31T12:00:00`.
    temp8-title = `Workshop out of the country`.
    temp8-type = `Type07`.
    temp8-pic = `sap-icon://sap-ui5`.
    temp8-tentative = abap_false.
    INSERT temp8 INTO TABLE temp7.
    temp8-start_at = `2018-01-01T00:00:00`.
    temp8-end_at = `2018-03-31T23:59:00`.
    temp8-title = `New quarter`.
    temp8-type = `Type10`.
    temp8-tentative = abap_false.
    INSERT temp8 INTO TABLE temp7.
    temp8-start_at = `2017-02-11T10:00:00`.
    temp8-end_at = `2017-03-20T12:00:00`.
    temp8-title = `Team collaboration`.
    temp8-info = `room 1`.
    temp8-type = `Type01`.
    temp8-pic = `sap-icon://sap-ui5`.
    temp8-tentative = abap_false.
    INSERT temp8 INTO TABLE temp7.
    temp8-start_at = `2017-04-01T10:00:00`.
    temp8-end_at = `2017-05-01T12:00:00`.
    temp8-title = `Workshop out of the country`.
    temp8-type = `Type07`.
    temp8-pic = `sap-icon://sap-ui5`.
    temp8-tentative = abap_false.
    INSERT temp8 INTO TABLE temp7.
    temp8-start_at = `2017-05-01T10:00:00`.
    temp8-end_at = `2017-05-31T12:00:00`.
    temp8-title = `Out of the office`.
    temp8-type = `Type08`.
    temp8-tentative = abap_false.
    INSERT temp8 INTO TABLE temp7.
    temp8-start_at = `2017-08-01T00:00:00`.
    temp8-end_at = `2017-08-31T23:59:00`.
    temp8-title = `Vacation`.
    temp8-info = `out of office`.
    temp8-type = `Type04`.
    temp8-tentative = abap_false.
    INSERT temp8 INTO TABLE temp7.
    temp5-t_appointments = temp7.
    
    CLEAR temp9.
    
    temp10-start_at = `2017-01-15T09:00:00`.
    temp10-end_at = `2017-01-15T10:00:00`.
    temp10-title = `Payment reminder`.
    temp10-type = `Type06`.
    INSERT temp10 INTO TABLE temp9.
    temp10-start_at = `2017-01-15T16:30:00`.
    temp10-end_at = `2017-01-15T18:00:00`.
    temp10-title = `Private appointment`.
    temp10-type = `Type06`.
    INSERT temp10 INTO TABLE temp9.
    temp5-t_headers = temp9.
    INSERT temp5 INTO TABLE temp4.
    temp5-pic = `sap-icon://employee`.
    temp5-name = `Nancy Davolio`.
    temp5-role = `team member`.
    
    CLEAR temp11.
    
    temp12-start_at = `2017-01-15T10:00:00`.
    temp12-end_at = `2017-01-15T10:30:00`.
    temp12-title = `Discussion of the plan`.
    temp12-info = `Online meeting`.
    temp12-type = `Type04`.
    temp12-tentative = abap_false.
    INSERT temp12 INTO TABLE temp11.
    temp12-start_at = `2017-01-17T10:00:00`.
    temp12-end_at = `2017-01-17T12:00:00`.
    temp12-title = `Team meeting`.
    temp12-info = `room 1`.
    temp12-type = `Type01`.
    temp12-pic = `sap-icon://sap-ui5`.
    temp12-tentative = abap_false.
    INSERT temp12 INTO TABLE temp11.
    temp12-start_at = `2017-01-15T18:00:00`.
    temp12-end_at = `2017-01-15T19:10:00`.
    temp12-title = `Discussion of the plan`.
    temp12-info = `Online meeting`.
    temp12-type = `Type04`.
    temp12-tentative = abap_false.
    INSERT temp12 INTO TABLE temp11.
    temp12-start_at = `2017-01-18T10:00:00`.
    temp12-end_at = `2017-01-31T12:00:00`.
    temp12-title = `Workshop out of the country`.
    temp12-type = `Type07`.
    temp12-pic = `sap-icon://sap-ui5`.
    temp12-tentative = abap_false.
    INSERT temp12 INTO TABLE temp11.
    temp12-start_at = `2018-01-01T00:00:00`.
    temp12-end_at = `2018-03-31T23:59:00`.
    temp12-title = `New quarter`.
    temp12-type = `Type10`.
    temp12-tentative = abap_false.
    INSERT temp12 INTO TABLE temp11.
    temp12-start_at = `2017-02-11T10:00:00`.
    temp12-end_at = `2017-03-20T12:00:00`.
    temp12-title = `Team collaboration`.
    temp12-info = `room 1`.
    temp12-type = `Type01`.
    temp12-pic = `sap-icon://sap-ui5`.
    temp12-tentative = abap_false.
    INSERT temp12 INTO TABLE temp11.
    temp12-start_at = `2017-04-01T10:00:00`.
    temp12-end_at = `2017-05-01T12:00:00`.
    temp12-title = `Workshop out of the country`.
    temp12-type = `Type07`.
    temp12-pic = `sap-icon://sap-ui5`.
    temp12-tentative = abap_false.
    INSERT temp12 INTO TABLE temp11.
    temp12-start_at = `2017-05-01T10:00:00`.
    temp12-end_at = `2017-05-31T12:00:00`.
    temp12-title = `Out of the office`.
    temp12-type = `Type08`.
    temp12-tentative = abap_false.
    INSERT temp12 INTO TABLE temp11.
    temp12-start_at = `2017-08-01T00:00:00`.
    temp12-end_at = `2017-08-31T23:59:00`.
    temp12-title = `Vacation`.
    temp12-info = `out of office`.
    temp12-type = `Type04`.
    temp12-tentative = abap_false.
    INSERT temp12 INTO TABLE temp11.
    temp5-t_appointments = temp11.
    
    CLEAR temp13.
    
    temp14-start_at = `2017-01-12T16:30:00`.
    temp14-end_at = `2017-01-12T18:00:00`.
    temp14-title = `Private appointment`.
    temp14-type = `Type06`.
    INSERT temp14 INTO TABLE temp13.
    temp5-t_headers = temp13.
    INSERT temp5 INTO TABLE temp4.
    temp5-pic = `sap-icon://employee`.
    temp5-name = `Andrew Fuller`.
    temp5-role = `team member`.
    
    CLEAR temp15.
    
    temp16-start_at = `2017-01-15T10:00:00`.
    temp16-end_at = `2017-01-15T10:30:00`.
    temp16-title = `Discussion of the plan`.
    temp16-info = `Online meeting`.
    temp16-type = `Type04`.
    temp16-tentative = abap_false.
    INSERT temp16 INTO TABLE temp15.
    temp16-start_at = `2017-01-15T18:00:00`.
    temp16-end_at = `2017-01-15T19:10:00`.
    temp16-title = `Discussion of the plan`.
    temp16-info = `Online meeting`.
    temp16-type = `Type04`.
    temp16-tentative = abap_false.
    INSERT temp16 INTO TABLE temp15.
    temp16-start_at = `2017-01-18T10:00:00`.
    temp16-end_at = `2017-01-31T12:00:00`.
    temp16-title = `Workshop out of the country`.
    temp16-type = `Type07`.
    temp16-pic = `sap-icon://sap-ui5`.
    temp16-tentative = abap_false.
    INSERT temp16 INTO TABLE temp15.
    temp16-start_at = `2017-02-11T10:00:00`.
    temp16-end_at = `2017-03-20T12:00:00`.
    temp16-title = `Team collaboration`.
    temp16-info = `room 1`.
    temp16-type = `Type01`.
    temp16-pic = `sap-icon://sap-ui5`.
    temp16-tentative = abap_false.
    INSERT temp16 INTO TABLE temp15.
    temp16-start_at = `2017-04-01T10:00:00`.
    temp16-end_at = `2017-05-01T12:00:00`.
    temp16-title = `Workshop out of the country`.
    temp16-type = `Type07`.
    temp16-pic = `sap-icon://sap-ui5`.
    temp16-tentative = abap_false.
    INSERT temp16 INTO TABLE temp15.
    temp16-start_at = `2017-05-01T10:00:00`.
    temp16-end_at = `2017-05-31T12:00:00`.
    temp16-title = `Out of the office`.
    temp16-type = `Type08`.
    temp16-tentative = abap_false.
    INSERT temp16 INTO TABLE temp15.
    temp16-start_at = `2017-08-01T00:00:00`.
    temp16-end_at = `2017-08-31T23:59:00`.
    temp16-title = `Vacation`.
    temp16-info = `out of office`.
    temp16-type = `Type04`.
    temp16-tentative = abap_false.
    INSERT temp16 INTO TABLE temp15.
    temp5-t_appointments = temp15.
    INSERT temp5 INTO TABLE temp4.
    temp5-pic = `sap-icon://employee`.
    temp5-name = `Robert King`.
    temp5-role = `team member`.
    
    CLEAR temp17.
    
    temp18-start_at = `2017-01-15T10:00:00`.
    temp18-end_at = `2017-01-15T12:00:00`.
    temp18-title = `Planning`.
    temp18-info = `Online meeting`.
    temp18-type = `Type04`.
    temp18-tentative = abap_false.
    INSERT temp18 INTO TABLE temp17.
    temp18-start_at = `2017-01-17T10:00:00`.
    temp18-end_at = `2017-01-17T12:00:00`.
    temp18-title = `Team meeting`.
    temp18-info = `room 1`.
    temp18-type = `Type01`.
    temp18-pic = `sap-icon://sap-ui5`.
    temp18-tentative = abap_false.
    INSERT temp18 INTO TABLE temp17.
    temp18-start_at = `2017-01-18T10:00:00`.
    temp18-end_at = `2017-01-31T12:00:00`.
    temp18-title = `Workshop out of the country`.
    temp18-type = `Type07`.
    temp18-pic = `sap-icon://sap-ui5`.
    temp18-tentative = abap_false.
    INSERT temp18 INTO TABLE temp17.
    temp18-start_at = `2018-01-01T00:00:00`.
    temp18-end_at = `2018-03-31T23:59:00`.
    temp18-title = `New quarter`.
    temp18-type = `Type10`.
    temp18-tentative = abap_false.
    INSERT temp18 INTO TABLE temp17.
    temp18-start_at = `2017-02-11T10:00:00`.
    temp18-end_at = `2017-03-20T12:00:00`.
    temp18-title = `Team collaboration`.
    temp18-info = `room 1`.
    temp18-type = `Type01`.
    temp18-pic = `sap-icon://sap-ui5`.
    temp18-tentative = abap_false.
    INSERT temp18 INTO TABLE temp17.
    temp18-start_at = `2017-04-01T10:00:00`.
    temp18-end_at = `2017-05-01T12:00:00`.
    temp18-title = `Workshop out of the country`.
    temp18-type = `Type07`.
    temp18-pic = `sap-icon://sap-ui5`.
    temp18-tentative = abap_false.
    INSERT temp18 INTO TABLE temp17.
    temp18-start_at = `2017-05-01T10:00:00`.
    temp18-end_at = `2017-05-31T12:00:00`.
    temp18-title = `Out of the office`.
    temp18-type = `Type08`.
    temp18-tentative = abap_false.
    INSERT temp18 INTO TABLE temp17.
    temp18-start_at = `2017-08-01T00:00:00`.
    temp18-end_at = `2017-08-31T23:59:00`.
    temp18-title = `Vacation`.
    temp18-info = `out of office`.
    temp18-type = `Type04`.
    temp18-tentative = abap_false.
    INSERT temp18 INTO TABLE temp17.
    temp5-t_appointments = temp17.
    
    CLEAR temp19.
    
    temp20-start_at = `2017-01-12T16:30:00`.
    temp20-end_at = `2017-01-12T18:00:00`.
    temp20-title = `Private appointment`.
    temp20-type = `Type06`.
    INSERT temp20 INTO TABLE temp19.
    temp5-t_headers = temp19.
    INSERT temp5 INTO TABLE temp4.
    temp5-pic = `sap-icon://employee`.
    temp5-name = `Janet Leverling`.
    temp5-role = `team member`.
    
    CLEAR temp21.
    
    temp22-start_at = `2017-01-16T09:00:00`.
    temp22-end_at = `2017-01-16T10:00:00`.
    temp22-title = `Discussion of the plan`.
    temp22-info = `Online meeting`.
    temp22-type = `Type04`.
    temp22-tentative = abap_false.
    INSERT temp22 INTO TABLE temp21.
    temp22-start_at = `2017-01-18T10:10:00`.
    temp22-end_at = `2017-01-18T10:40:00`.
    temp22-title = `Discussion of the plan`.
    temp22-info = `Online meeting`.
    temp22-type = `Type04`.
    temp22-tentative = abap_false.
    INSERT temp22 INTO TABLE temp21.
    temp22-start_at = `2017-01-15T12:00:00`.
    temp22-end_at = `2017-01-15T13:10:00`.
    temp22-title = `Discussion`.
    temp22-info = `Online meeting`.
    temp22-type = `Type04`.
    temp22-tentative = abap_true.
    INSERT temp22 INTO TABLE temp21.
    temp22-start_at = `2017-01-18T10:00:00`.
    temp22-end_at = `2017-01-31T12:00:00`.
    temp22-title = `Workshop out of the country`.
    temp22-type = `Type07`.
    temp22-pic = `sap-icon://sap-ui5`.
    temp22-tentative = abap_false.
    INSERT temp22 INTO TABLE temp21.
    temp22-start_at = `2017-04-01T10:00:00`.
    temp22-end_at = `2017-05-01T12:00:00`.
    temp22-title = `Workshop out of the country`.
    temp22-type = `Type07`.
    temp22-pic = `sap-icon://sap-ui5`.
    temp22-tentative = abap_false.
    INSERT temp22 INTO TABLE temp21.
    temp22-start_at = `2017-05-01T10:00:00`.
    temp22-end_at = `2017-05-31T12:00:00`.
    temp22-title = `Out of the office`.
    temp22-type = `Type08`.
    temp22-tentative = abap_false.
    INSERT temp22 INTO TABLE temp21.
    temp5-t_appointments = temp21.
    
    CLEAR temp23.
    
    temp24-start_at = `2017-01-15T17:00:00`.
    temp24-end_at = `2017-01-15T18:00:00`.
    temp24-title = `Private appointment`.
    temp24-type = `Type06`.
    INSERT temp24 INTO TABLE temp23.
    temp5-t_headers = temp23.
    INSERT temp5 INTO TABLE temp4.
    temp5-pic = `sap-icon://employee`.
    temp5-name = `Robert King`.
    temp5-role = `team member`.
    
    CLEAR temp25.
    
    temp26-start_at = `2017-01-15T08:30:00`.
    temp26-end_at = `2017-01-15T09:30:00`.
    temp26-title = `Meet John Miller`.
    temp26-type = `Type02`.
    temp26-tentative = abap_false.
    INSERT temp26 INTO TABLE temp25.
    temp26-start_at = `2017-01-15T10:00:00`.
    temp26-end_at = `2017-01-15T12:00:00`.
    temp26-title = `Team meeting`.
    temp26-info = `room 1`.
    temp26-type = `Type01`.
    temp26-pic = `sap-icon://sap-ui5`.
    temp26-tentative = abap_false.
    INSERT temp26 INTO TABLE temp25.
    temp26-start_at = `2017-01-15T13:00:00`.
    temp26-end_at = `2017-01-15T16:00:00`.
    temp26-title = `Discussion with clients`.
    temp26-info = `online`.
    temp26-type = `Type02`.
    temp26-tentative = abap_false.
    INSERT temp26 INTO TABLE temp25.
    temp26-start_at = `2017-01-16T00:00:00`.
    temp26-end_at = `2017-01-16T23:59:00`.
    temp26-title = `Vacation`.
    temp26-info = `out of office`.
    temp26-type = `Type04`.
    temp26-tentative = abap_false.
    INSERT temp26 INTO TABLE temp25.
    temp26-start_at = `2017-01-17T01:00:00`.
    temp26-end_at = `2017-01-18T22:00:00`.
    temp26-title = `Workshop`.
    temp26-info = `regular`.
    temp26-type = `Type07`.
    temp26-pic = `sap-icon://sap-ui5`.
    temp26-tentative = abap_false.
    INSERT temp26 INTO TABLE temp25.
    temp26-start_at = `2017-01-19T08:30:00`.
    temp26-end_at = `2017-01-19T18:30:00`.
    temp26-title = `Meet John Doe`.
    temp26-type = `Type02`.
    temp26-tentative = abap_false.
    INSERT temp26 INTO TABLE temp25.
    temp26-start_at = `2017-01-19T10:00:00`.
    temp26-end_at = `2017-01-19T16:00:00`.
    temp26-title = `Team meeting`.
    temp26-info = `room 1`.
    temp26-type = `Type01`.
    temp26-pic = `sap-icon://sap-ui5`.
    temp26-tentative = abap_false.
    INSERT temp26 INTO TABLE temp25.
    temp26-start_at = `2017-01-19T07:00:00`.
    temp26-end_at = `2017-01-19T17:30:00`.
    temp26-title = `Discussion with clients`.
    temp26-type = `Type02`.
    temp26-tentative = abap_false.
    INSERT temp26 INTO TABLE temp25.
    temp26-start_at = `2017-01-20T00:00:00`.
    temp26-end_at = `2017-01-20T23:59:00`.
    temp26-title = `Vacation`.
    temp26-info = `out of office`.
    temp26-type = `Type04`.
    temp26-tentative = abap_false.
    INSERT temp26 INTO TABLE temp25.
    temp26-start_at = `2017-01-22T07:00:00`.
    temp26-end_at = `2017-01-27T17:30:00`.
    temp26-title = `Discussion with clients`.
    temp26-info = `out of office`.
    temp26-type = `Type02`.
    temp26-tentative = abap_false.
    INSERT temp26 INTO TABLE temp25.
    temp26-start_at = `2017-03-13T09:00:00`.
    temp26-end_at = `2017-03-17T10:00:00`.
    temp26-title = `Payment week`.
    temp26-type = `Type06`.
    INSERT temp26 INTO TABLE temp25.
    temp26-start_at = `2017-04-10T00:00:00`.
    temp26-end_at = `2017-06-16T23:59:00`.
    temp26-title = `Vacation`.
    temp26-info = `out of office`.
    temp26-type = `Type04`.
    temp26-tentative = abap_false.
    INSERT temp26 INTO TABLE temp25.
    temp26-start_at = `2017-08-01T00:00:00`.
    temp26-end_at = `2017-10-31T23:59:00`.
    temp26-title = `New quarter`.
    temp26-type = `Type10`.
    temp26-tentative = abap_false.
    INSERT temp26 INTO TABLE temp25.
    temp5-t_appointments = temp25.
    
    CLEAR temp27.
    
    temp28-start_at = `2017-01-16T00:00:00`.
    temp28-end_at = `2017-01-16T23:59:00`.
    temp28-title = `Private`.
    temp28-type = `Type05`.
    INSERT temp28 INTO TABLE temp27.
    temp5-t_headers = temp27.
    INSERT temp5 INTO TABLE temp4.
    temp5-pic = `sap-icon://employee`.
    temp5-name = `Max Mustermann`.
    temp5-role = `team member`.
    
    CLEAR temp29.
    
    temp30-start_at = `2017-01-15T08:30:00`.
    temp30-end_at = `2017-01-15T09:30:00`.
    temp30-title = `Meet John Miller`.
    temp30-type = `Type02`.
    temp30-tentative = abap_false.
    INSERT temp30 INTO TABLE temp29.
    temp30-start_at = `2017-01-15T10:00:00`.
    temp30-end_at = `2017-01-15T12:00:00`.
    temp30-title = `Team meeting`.
    temp30-info = `room 1`.
    temp30-type = `Type01`.
    temp30-pic = `sap-icon://sap-ui5`.
    temp30-tentative = abap_false.
    INSERT temp30 INTO TABLE temp29.
    temp30-start_at = `2017-01-15T13:00:00`.
    temp30-end_at = `2017-01-15T16:00:00`.
    temp30-title = `Discussion with clients`.
    temp30-info = `online`.
    temp30-type = `Type02`.
    temp30-tentative = abap_false.
    INSERT temp30 INTO TABLE temp29.
    temp30-start_at = `2017-01-16T00:00:00`.
    temp30-end_at = `2017-01-16T23:59:00`.
    temp30-title = `Vacation`.
    temp30-info = `out of office`.
    temp30-type = `Type04`.
    temp30-tentative = abap_false.
    INSERT temp30 INTO TABLE temp29.
    temp30-start_at = `2017-01-17T01:00:00`.
    temp30-end_at = `2017-01-18T22:00:00`.
    temp30-title = `Workshop`.
    temp30-info = `regular`.
    temp30-type = `Type07`.
    temp30-pic = `sap-icon://sap-ui5`.
    temp30-tentative = abap_false.
    INSERT temp30 INTO TABLE temp29.
    temp30-start_at = `2017-01-19T08:30:00`.
    temp30-end_at = `2017-01-19T18:30:00`.
    temp30-title = `Meet John Doe`.
    temp30-type = `Type02`.
    temp30-tentative = abap_false.
    INSERT temp30 INTO TABLE temp29.
    temp30-start_at = `2017-01-19T10:00:00`.
    temp30-end_at = `2017-01-19T16:00:00`.
    temp30-title = `Team meeting`.
    temp30-info = `room 1`.
    temp30-type = `Type01`.
    temp30-pic = `sap-icon://sap-ui5`.
    temp30-tentative = abap_false.
    INSERT temp30 INTO TABLE temp29.
    temp30-start_at = `2017-01-19T07:00:00`.
    temp30-end_at = `2017-01-19T17:30:00`.
    temp30-title = `Discussion with clients`.
    temp30-type = `Type02`.
    temp30-tentative = abap_false.
    INSERT temp30 INTO TABLE temp29.
    temp30-start_at = `2017-01-20T00:00:00`.
    temp30-end_at = `2017-01-20T23:59:00`.
    temp30-title = `Vacation`.
    temp30-info = `out of office`.
    temp30-type = `Type04`.
    temp30-tentative = abap_false.
    INSERT temp30 INTO TABLE temp29.
    temp30-start_at = `2017-01-22T07:00:00`.
    temp30-end_at = `2017-01-27T17:30:00`.
    temp30-title = `Discussion with clients`.
    temp30-info = `out of office`.
    temp30-type = `Type02`.
    temp30-tentative = abap_false.
    INSERT temp30 INTO TABLE temp29.
    temp30-start_at = `2017-03-13T09:00:00`.
    temp30-end_at = `2017-03-17T10:00:00`.
    temp30-title = `Payment week`.
    temp30-type = `Type06`.
    INSERT temp30 INTO TABLE temp29.
    temp30-start_at = `2017-04-10T00:00:00`.
    temp30-end_at = `2017-06-16T23:59:00`.
    temp30-title = `Vacation`.
    temp30-info = `out of office`.
    temp30-type = `Type04`.
    temp30-tentative = abap_false.
    INSERT temp30 INTO TABLE temp29.
    temp30-start_at = `2017-08-01T00:00:00`.
    temp30-end_at = `2017-10-31T23:59:00`.
    temp30-title = `New quarter`.
    temp30-type = `Type10`.
    temp30-tentative = abap_false.
    INSERT temp30 INTO TABLE temp29.
    temp5-t_appointments = temp29.
    
    CLEAR temp31.
    
    temp32-start_at = `2017-01-16T00:00:00`.
    temp32-end_at = `2017-01-16T23:59:00`.
    temp32-title = `Private`.
    temp32-type = `Type05`.
    INSERT temp32 INTO TABLE temp31.
    temp5-t_headers = temp31.
    INSERT temp5 INTO TABLE temp4.
    temp5-pic = `sap-icon://employee`.
    temp5-name = `Laura Callahan`.
    temp5-role = `team member`.
    
    CLEAR temp33.
    
    temp34-start_at = `2017-01-16T09:00:00`.
    temp34-end_at = `2017-01-16T10:00:00`.
    temp34-title = `Discussion of the plan`.
    temp34-info = `Online meeting`.
    temp34-type = `Type04`.
    temp34-tentative = abap_false.
    INSERT temp34 INTO TABLE temp33.
    temp34-start_at = `2017-01-18T10:10:00`.
    temp34-end_at = `2017-01-18T10:40:00`.
    temp34-title = `Discussion of the plan`.
    temp34-info = `Online meeting`.
    temp34-type = `Type04`.
    temp34-tentative = abap_false.
    INSERT temp34 INTO TABLE temp33.
    temp34-start_at = `2017-01-15T12:00:00`.
    temp34-end_at = `2017-01-15T13:10:00`.
    temp34-title = `Discussion`.
    temp34-info = `Online meeting`.
    temp34-type = `Type04`.
    temp34-tentative = abap_true.
    INSERT temp34 INTO TABLE temp33.
    temp34-start_at = `2017-01-18T10:00:00`.
    temp34-end_at = `2017-01-31T12:00:00`.
    temp34-title = `Workshop out of the country`.
    temp34-type = `Type07`.
    temp34-pic = `sap-icon://sap-ui5`.
    temp34-tentative = abap_false.
    INSERT temp34 INTO TABLE temp33.
    temp34-start_at = `2017-04-01T10:00:00`.
    temp34-end_at = `2017-05-01T12:00:00`.
    temp34-title = `Workshop out of the country`.
    temp34-type = `Type07`.
    temp34-pic = `sap-icon://sap-ui5`.
    temp34-tentative = abap_false.
    INSERT temp34 INTO TABLE temp33.
    temp34-start_at = `2017-05-01T10:00:00`.
    temp34-end_at = `2017-05-31T12:00:00`.
    temp34-title = `Out of the office`.
    temp34-type = `Type08`.
    temp34-tentative = abap_false.
    INSERT temp34 INTO TABLE temp33.
    temp5-t_appointments = temp33.
    
    CLEAR temp35.
    
    temp36-start_at = `2017-01-15T17:00:00`.
    temp36-end_at = `2017-01-15T18:00:00`.
    temp36-title = `Private appointment`.
    temp36-type = `Type06`.
    INSERT temp36 INTO TABLE temp35.
    temp5-t_headers = temp35.
    INSERT temp5 INTO TABLE temp4.
    temp5-pic = `sap-icon://employee`.
    temp5-name = `Anne Dodsworth`.
    temp5-role = `team member`.
    
    CLEAR temp37.
    
    temp38-start_at = `2017-01-15T09:30:00`.
    temp38-end_at = `2017-01-15T10:30:00`.
    temp38-title = `Meeting`.
    temp38-type = `Type02`.
    temp38-tentative = abap_false.
    INSERT temp38 INTO TABLE temp37.
    temp38-start_at = `2017-01-15T13:30:00`.
    temp38-end_at = `2017-01-15T15:00:00`.
    temp38-title = `Team meeting`.
    temp38-info = `room 1`.
    temp38-type = `Type01`.
    temp38-pic = `sap-icon://sap-ui5`.
    temp38-tentative = abap_false.
    INSERT temp38 INTO TABLE temp37.
    temp38-start_at = `2017-01-17T00:00:00`.
    temp38-end_at = `2017-01-17T23:59:00`.
    temp38-title = `Vacation`.
    temp38-info = `out of office`.
    temp38-type = `Type04`.
    temp38-tentative = abap_false.
    INSERT temp38 INTO TABLE temp37.
    temp38-start_at = `2017-01-19T10:00:00`.
    temp38-end_at = `2017-01-19T16:00:00`.
    temp38-title = `Team meeting`.
    temp38-info = `room 1`.
    temp38-type = `Type01`.
    temp38-pic = `sap-icon://sap-ui5`.
    temp38-tentative = abap_false.
    INSERT temp38 INTO TABLE temp37.
    temp38-start_at = `2017-01-22T07:00:00`.
    temp38-end_at = `2017-01-27T17:30:00`.
    temp38-title = `Discussion with clients`.
    temp38-info = `out of office`.
    temp38-type = `Type02`.
    temp38-tentative = abap_false.
    INSERT temp38 INTO TABLE temp37.
    temp38-start_at = `2017-03-13T09:00:00`.
    temp38-end_at = `2017-03-17T10:00:00`.
    temp38-title = `Payment week`.
    temp38-type = `Type06`.
    INSERT temp38 INTO TABLE temp37.
    temp5-t_appointments = temp37.
    INSERT temp5 INTO TABLE temp4.
    temp5-pic = `sap-icon://employee`.
    temp5-name = `Michael Suyama`.
    temp5-role = `team member`.
    
    CLEAR temp39.
    
    temp40-start_at = `2017-01-15T09:00:00`.
    temp40-end_at = `2017-01-15T10:30:00`.
    temp40-title = `Meet new colleague`.
    temp40-type = `Type02`.
    temp40-tentative = abap_false.
    INSERT temp40 INTO TABLE temp39.
    temp40-start_at = `2017-01-15T10:30:00`.
    temp40-end_at = `2017-01-15T12:00:00`.
    temp40-title = `Team meeting`.
    temp40-info = `room 1`.
    temp40-type = `Type01`.
    temp40-pic = `sap-icon://sap-ui5`.
    temp40-tentative = abap_false.
    INSERT temp40 INTO TABLE temp39.
    temp40-start_at = `2017-01-15T15:00:00`.
    temp40-end_at = `2017-01-15T16:00:00`.
    temp40-title = `Discussion with clients`.
    temp40-info = `online`.
    temp40-type = `Type02`.
    temp40-tentative = abap_false.
    INSERT temp40 INTO TABLE temp39.
    temp40-start_at = `2017-01-17T00:00:00`.
    temp40-end_at = `2017-01-17T23:59:00`.
    temp40-title = `Vacation`.
    temp40-info = `out of office`.
    temp40-type = `Type04`.
    temp40-tentative = abap_false.
    INSERT temp40 INTO TABLE temp39.
    temp40-start_at = `2017-01-19T08:30:00`.
    temp40-end_at = `2017-01-19T18:30:00`.
    temp40-title = `Meet John Doe`.
    temp40-type = `Type02`.
    temp40-tentative = abap_false.
    INSERT temp40 INTO TABLE temp39.
    temp40-start_at = `2017-01-19T10:00:00`.
    temp40-end_at = `2017-01-19T16:00:00`.
    temp40-title = `Team meeting`.
    temp40-info = `room 1`.
    temp40-type = `Type01`.
    temp40-pic = `sap-icon://sap-ui5`.
    temp40-tentative = abap_false.
    INSERT temp40 INTO TABLE temp39.
    temp40-start_at = `2017-01-19T07:00:00`.
    temp40-end_at = `2017-01-19T17:30:00`.
    temp40-title = `Discussion with clients`.
    temp40-type = `Type02`.
    temp40-tentative = abap_false.
    INSERT temp40 INTO TABLE temp39.
    temp40-start_at = `2017-01-20T00:00:00`.
    temp40-end_at = `2017-01-20T23:59:00`.
    temp40-title = `Vacation`.
    temp40-info = `out of office`.
    temp40-type = `Type04`.
    temp40-tentative = abap_false.
    INSERT temp40 INTO TABLE temp39.
    temp40-start_at = `2017-01-22T07:00:00`.
    temp40-end_at = `2017-01-27T17:30:00`.
    temp40-title = `Discussion with clients`.
    temp40-info = `out of office`.
    temp40-type = `Type02`.
    temp40-tentative = abap_false.
    INSERT temp40 INTO TABLE temp39.
    temp40-start_at = `2017-03-13T09:00:00`.
    temp40-end_at = `2017-03-17T10:00:00`.
    temp40-title = `Payment week`.
    temp40-type = `Type06`.
    INSERT temp40 INTO TABLE temp39.
    temp40-start_at = `2017-04-10T00:00:00`.
    temp40-end_at = `2017-06-16T23:59:00`.
    temp40-title = `Vacation`.
    temp40-info = `out of office`.
    temp40-type = `Type04`.
    temp40-tentative = abap_false.
    INSERT temp40 INTO TABLE temp39.
    temp40-start_at = `2017-08-01T00:00:00`.
    temp40-end_at = `2017-10-31T23:59:00`.
    temp40-title = `New quarter`.
    temp40-type = `Type10`.
    temp40-tentative = abap_false.
    INSERT temp40 INTO TABLE temp39.
    temp5-t_appointments = temp39.
    
    CLEAR temp41.
    
    temp42-start_at = `2017-01-16T00:00:00`.
    temp42-end_at = `2017-01-16T23:59:00`.
    temp42-title = `Private`.
    temp42-type = `Type05`.
    INSERT temp42 INTO TABLE temp41.
    temp5-t_headers = temp41.
    INSERT temp5 INTO TABLE temp4.
    t_people = temp4.

  ENDMETHOD.

ENDCLASS.
