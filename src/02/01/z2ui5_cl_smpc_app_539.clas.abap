" @keywords planningcalendar planning calendar sap.m planningcalendaroneline vbox title togglebutton overflowtoolbarlayoutdata badgecustomdata select item
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

             selected       TYPE abap_bool,
           END OF ty_s_person.
    DATA t_people TYPE STANDARD TABLE OF ty_s_person WITH DEFAULT KEY.

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
                )->a( n = `startDate`                     v = |\{ path: '{ client->_bind_path( start_date ) }', formatter: 'Formatter.DateCreateObject' \}|
                )->a( n = `rows`                          v = client->_bind( t_people )
                )->a( n = `appointmentsVisualization`     v = `Filled`
                " onPress flips setMultipleAppointmentsSelection; the property is
                " bindable, so the ToggleButton and the calendar share the flag
                )->a( n = `multipleAppointmentsSelection` v = client->_bind( multi_select )
                )->a( n = `appointmentSelect`             v = client->_event(
                          val   = `APPT_SELECT`
                          t_arg = temp1 )
                )->a( n = `intervalSelect`                v = client->_event(
                          val   = `INTERVAL_SELECT`
                          t_arg = temp2 )

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
                        )->a( n = `change` v = client->_event( val = `SORT_CHANGE` arg = `${$parameters>/selectedItem}.getKey()` )
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
                        )->a( n = `selected`     v = `{SELECTED}`
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
          FIELD-SYMBOLS <person> TYPE z2ui5_cl_smpc_app_539=>ty_s_person.
          FIELD-SYMBOLS <row> LIKE LINE OF t_people.

    CASE client->get_event( ).

      WHEN `APPT_SELECT`.
        " the selected count also feeds the ToggleButton's badge
        badge_value = client->get_event_arg( 3 ).
        
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

      WHEN `SORT_CHANGE`.
        " handleSortChange hands the calendar a JS comparator; ABAP sorts the
        " rows themselves instead (see sidecar)
        IF client->get_event_arg( ) = `custom`.
          
          LOOP AT t_people ASSIGNING <row>.
            SORT <row>-t_appointments BY title AS TEXT.
          ENDLOOP.
        ELSE.
          model_init( ).
        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.
    DATA temp12 LIKE t_people.
    DATA temp13 LIKE LINE OF temp12.
    DATA temp14 TYPE z2ui5_cl_smpc_app_539=>ty_t_appointment.
    DATA temp15 LIKE LINE OF temp14.
    DATA temp16 TYPE z2ui5_cl_smpc_app_539=>ty_t_header.
    DATA temp17 LIKE LINE OF temp16.
    DATA temp18 TYPE z2ui5_cl_smpc_app_539=>ty_t_appointment.
    DATA temp19 LIKE LINE OF temp18.
    DATA temp20 TYPE z2ui5_cl_smpc_app_539=>ty_t_header.
    DATA temp21 LIKE LINE OF temp20.

    start_date    = `2017-03-08T08:00:00`.
    multi_select  = abap_false.
    badge_value   = `0`.
    multi_tooltip = `Enable multiple appointments selection`.

    
    CLEAR temp12.
    
    temp13-pic = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/John_Miller.png`.
    temp13-name = `John Miller`.
    temp13-role = `team member`.
    
    CLEAR temp14.
    
    temp15-start_at = `2017-03-07T18:00:00`.
    temp15-end_at = `2017-03-07T19:10:00`.
    temp15-title = `Discussion of the plan`.
    temp15-info = `Online meeting`.
    temp15-type = `Type04`.
    temp15-tentative = abap_false.
    INSERT temp15 INTO TABLE temp14.
    temp15-start_at = `2017-03-07T14:00:00`.
    temp15-end_at = `2017-03-07T15:15:00`.
    temp15-title = `Department meeting`.
    temp15-type = `Type04`.
    temp15-tentative = abap_false.
    INSERT temp15 INTO TABLE temp14.
    temp15-start_at = `2017-03-03T10:00:00`.
    temp15-end_at = `2017-03-07T12:00:00`.
    temp15-title = `Workshop out of the country`.
    temp15-type = `Type07`.
    temp15-pic = `sap-icon://sap-ui5`.
    temp15-tentative = abap_false.
    INSERT temp15 INTO TABLE temp14.
    temp15-start_at = `2017-03-08T09:00:00`.
    temp15-end_at = `2017-03-08T11:00:00`.
    temp15-title = `Team meeting`.
    temp15-info = `room 105`.
    temp15-type = `Type01`.
    temp15-pic = `sap-icon://sap-ui5`.
    temp15-tentative = abap_false.
    INSERT temp15 INTO TABLE temp14.
    temp15-start_at = `2017-03-08T09:30:00`.
    temp15-end_at = `2017-03-08T11:30:00`.
    temp15-title = `Meeting with Max`.
    temp15-type = `Type02`.
    temp15-pic = `sap-icon://sap-ui5`.
    temp15-tentative = abap_false.
    INSERT temp15 INTO TABLE temp14.
    temp15-start_at = `2017-03-08T11:00:00`.
    temp15-end_at = `2017-03-08T13:00:00`.
    temp15-title = `Lunch`.
    temp15-type = `Type03`.
    temp15-tentative = abap_true.
    INSERT temp15 INTO TABLE temp14.
    temp15-start_at = `2017-03-08T11:00:00`.
    temp15-end_at = `2017-03-08T13:00:00`.
    temp15-title = `Meeting with the crew`.
    temp15-type = `Type04`.
    temp15-tentative = abap_false.
    INSERT temp15 INTO TABLE temp14.
    temp15-start_at = `2017-03-09T09:00:00`.
    temp15-end_at = `2017-03-09T16:00:00`.
    temp15-title = `Busy`.
    temp15-type = `Type08`.
    temp15-tentative = abap_false.
    INSERT temp15 INTO TABLE temp14.
    temp15-start_at = `2017-03-10T09:00:00`.
    temp15-end_at = `2017-03-10T11:00:00`.
    temp15-title = `Team meeting`.
    temp15-info = `room 105`.
    temp15-type = `Type01`.
    temp15-pic = `sap-icon://sap-ui5`.
    temp15-tentative = abap_false.
    INSERT temp15 INTO TABLE temp14.
    temp15-start_at = `2017-03-10T09:30:00`.
    temp15-end_at = `2017-03-10T16:30:00`.
    temp15-title = `Meeting with Max`.
    temp15-type = `Type02`.
    temp15-tentative = abap_false.
    INSERT temp15 INTO TABLE temp14.
    temp15-start_at = `2017-03-11T00:00:00`.
    temp15-end_at = `2017-03-13T23:59:00`.
    temp15-title = `Vacation`.
    temp15-info = `out of office`.
    temp15-type = `Type04`.
    temp15-tentative = abap_false.
    INSERT temp15 INTO TABLE temp14.
    temp15-start_at = `2017-03-16T00:30:00`.
    temp15-end_at = `2017-03-16T23:30:00`.
    temp15-title = `New Colleague`.
    temp15-info = `room 115`.
    temp15-type = `Type10`.
    temp15-tentative = abap_true.
    INSERT temp15 INTO TABLE temp14.
    temp15-start_at = `2017-10-11T00:00:00`.
    temp15-end_at = `2017-11-13T23:59:00`.
    temp15-title = `Vacation`.
    temp15-info = `out of office`.
    temp15-type = `Type04`.
    temp15-tentative = abap_false.
    INSERT temp15 INTO TABLE temp14.
    temp13-t_appointments = temp14.
    
    CLEAR temp16.
    
    temp17-start_at = `2016-09-01T00:00:00`.
    temp17-end_at = `2016-12-30T23:59:00`.
    temp17-title = `New quarter`.
    temp17-type = `Type10`.
    INSERT temp17 INTO TABLE temp16.
    temp17-start_at = `2017-03-09T08:00:00`.
    temp17-end_at = `2017-03-09T09:00:00`.
    temp17-title = `UI5`.
    temp17-type = `Type05`.
    temp17-pic = `sap-icon://sap-ui5`.
    INSERT temp17 INTO TABLE temp16.
    temp17-start_at = `2017-06-01T00:00:00`.
    temp17-end_at = `2017-09-30T23:59:00`.
    temp17-title = `New quarter`.
    temp17-type = `Type10`.
    INSERT temp17 INTO TABLE temp16.
    temp13-t_headers = temp16.
    INSERT temp13 INTO TABLE temp12.
    temp13-pic = `sap-icon://employee`.
    temp13-name = `Max Mustermann`.
    temp13-role = `team member`.
    
    CLEAR temp18.
    
    temp19-start_at = `2016-12-01T00:30:00`.
    temp19-end_at = `2017-01-31T23:30:00`.
    temp19-title = `New product release`.
    temp19-info = `room 105`.
    temp19-type = `Type03`.
    temp19-tentative = abap_true.
    INSERT temp19 INTO TABLE temp18.
    temp19-start_at = `2017-03-02T07:00:00`.
    temp19-end_at = `2017-03-03T09:00:00`.
    temp19-title = `Education`.
    temp19-type = `Type05`.
    temp19-tentative = abap_false.
    INSERT temp19 INTO TABLE temp18.
    temp19-start_at = `2017-03-05T00:30:00`.
    temp19-end_at = `2017-03-05T23:30:00`.
    temp19-title = `New Product`.
    temp19-info = `room 105`.
    temp19-type = `Type03`.
    temp19-tentative = abap_true.
    INSERT temp19 INTO TABLE temp18.
    temp19-start_at = `2017-03-08T08:00:00`.
    temp19-end_at = `2017-03-08T09:00:00`.
    temp19-title = `Meet Donna`.
    temp19-type = `Type06`.
    temp19-tentative = abap_false.
    INSERT temp19 INTO TABLE temp18.
    temp19-start_at = `2017-03-08T09:00:00`.
    temp19-end_at = `2017-03-08T11:00:00`.
    temp19-title = `Team meeting`.
    temp19-info = `room 1`.
    temp19-type = `Type01`.
    temp19-pic = `sap-icon://sap-ui5`.
    temp19-tentative = abap_false.
    INSERT temp19 INTO TABLE temp18.
    temp19-start_at = `2017-03-09T14:00:00`.
    temp19-end_at = `2017-03-09T15:15:00`.
    temp19-title = `Department meeting`.
    temp19-type = `Type04`.
    temp19-tentative = abap_false.
    INSERT temp19 INTO TABLE temp18.
    temp19-start_at = `2017-03-10T09:30:00`.
    temp19-end_at = `2017-03-10T11:30:00`.
    temp19-title = `Meeting with John`.
    temp19-type = `Type02`.
    temp19-tentative = abap_false.
    INSERT temp19 INTO TABLE temp18.
    temp19-start_at = `2017-03-11T00:00:00`.
    temp19-end_at = `2017-03-12T23:59:00`.
    temp19-title = `Team Building`.
    temp19-info = `out of office`.
    temp19-type = `Type10`.
    temp19-pic = `sap-icon://sap-ui5`.
    temp19-tentative = abap_false.
    INSERT temp19 INTO TABLE temp18.
    temp19-start_at = `2017-03-19T00:30:00`.
    temp19-end_at = `2017-03-17T23:30:00`.
    temp19-title = `New Product`.
    temp19-info = `room 325`.
    temp19-type = `Type07`.
    temp19-tentative = abap_true.
    INSERT temp19 INTO TABLE temp18.
    temp19-start_at = `2017-03-21T00:30:00`.
    temp19-end_at = `2017-03-21T23:30:00`.
    temp19-title = `New Product`.
    temp19-info = `room 105`.
    temp19-type = `Type03`.
    temp19-tentative = abap_true.
    INSERT temp19 INTO TABLE temp18.
    temp19-start_at = `2017-06-01T00:00:00`.
    temp19-end_at = `2017-07-15T23:59:00`.
    temp19-title = `Vacation`.
    temp19-info = `out of office`.
    temp19-type = `Type04`.
    temp19-tentative = abap_false.
    INSERT temp19 INTO TABLE temp18.
    temp19-start_at = `2017-12-01T00:30:00`.
    temp19-end_at = `2018-03-03T23:30:00`.
    temp19-title = `New product release`.
    temp19-info = `room 105`.
    temp19-type = `Type03`.
    temp19-tentative = abap_true.
    INSERT temp19 INTO TABLE temp18.
    temp13-t_appointments = temp18.
    
    CLEAR temp20.
    
    temp21-start_at = `2017-03-08T08:00:00`.
    temp21-end_at = `2017-03-08T10:00:00`.
    temp21-title = `Development of UI5`.
    temp21-type = `Type07`.
    temp21-pic = `sap-icon://sap-ui5`.
    INSERT temp21 INTO TABLE temp20.
    temp21-start_at = `2017-05-01T00:00:00`.
    temp21-end_at = `2017-08-30T23:59:00`.
    temp21-title = `New quarter`.
    temp21-type = `Type10`.
    INSERT temp21 INTO TABLE temp20.
    temp13-t_headers = temp20.
    INSERT temp13 INTO TABLE temp12.
    t_people = temp12.

  ENDMETHOD.

ENDCLASS.
