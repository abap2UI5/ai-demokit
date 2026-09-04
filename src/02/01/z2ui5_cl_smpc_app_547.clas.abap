" @keywords planningcalendar planning calendar sap.m planningcalendarmodifyappointments vbox title button planningcalendarrow calendarappointment responsivepopover simpleform
" @summary PlanningCalendar containing sap.m.Popover with information for the appointments and sap.m.Dialog for creating a new appointment. Note: Illustrates how the PlanningCalendar can be used in combination with the sap.m.Popover and sap.m.
CLASS z2ui5_cl_smpc_app_547 DEFINITION PUBLIC.

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
             selected  TYPE abap_bool,
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

    " the details popover and the create/edit dialog, folded to fields
    DATA sel_row      TYPE i.
    DATA sel_index    TYPE i.
    DATA sel_title    TYPE string.
    DATA sel_info     TYPE string.
    DATA sel_start    TYPE string.
    DATA sel_end      TYPE string.
    DATA d_mode       TYPE string.
    DATA d_person     TYPE string.
    DATA d_interval   TYPE abap_bool.
    DATA d_title      TYPE string.
    DATA d_info       TYPE string.
    DATA d_start      TYPE string.
    DATA d_end        TYPE string.
    DATA d_start_state TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popup_details_display.
    METHODS popup_create_display.
    METHODS appointment_edit
      IMPORTING target_row TYPE i.
    METHODS iso_of
      IMPORTING first         TYPE i
      RETURNING VALUE(result) TYPE string.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_547 IMPLEMENTATION.

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

    " the calendar date properties are typed "object" and demand a real JS Date;
    " the model keeps ISO strings and Formatter.DateCreateObject converts them
    
    CLEAR temp1.
    INSERT `${$parameters>/appointment} ? ${$parameters>/appointment}.getBindingContext().getPath() : ''` INTO TABLE temp1.
    INSERT `${$parameters>/appointment} ? ${$parameters>/appointment}.getSelected() : false` INTO TABLE temp1.
    INSERT `${$parameters>/appointments} ? ${$parameters>/appointments}.length : 0` INTO TABLE temp1.
    INSERT `${$parameters>/appointments} ? ${$parameters>/appointments}[0].getType() : ''` INTO TABLE temp1.
    
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
                )->a( n = `startDate`                 v = |\{ path: '{ client->_bind_path( start_date ) }', formatter: 'Formatter.DateCreateObject' \}|
                )->a( n = `rows`                      v = client->_bind( t_people )
                )->a( n = `appointmentsVisualization` v = `Filled`
                " handleAppointmentSelect opens the details popover on a single
                " appointment, or the group popover on a collapsed group
                )->a( n = `appointmentSelect`         v = client->_event(
                          val   = `APPT_SELECT`
                          t_arg = temp1 )
                )->a( n = `showEmptyIntervalHeaders`  v = `false`
                " handleAppointmentAddWithContext opens the same dialog pre-set to
                " the selected interval
                )->a( n = `intervalSelect`            v = client->_event(
                          val   = `INTERVAL_SELECT`
                          t_arg = temp2 )

                )->ele( `toolbarContent`
                    )->tag( `Title`
                        )->a( n = `text`       v = `Title`
                        )->a( n = `titleStyle` v = `H4`
                    )->tag( `Button`
                        )->a( n = `id`      v = `addButton`
                        )->a( n = `icon`    v = `sap-icon://add`
                        )->a( n = `press`   v = client->_event( `APPT_CREATE` )
                        )->a( n = `tooltip` v = `Add`

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
                                )->a( n = `startDate`    v = `{ path: 'START_AT', formatter: 'Formatter.DateCreateObject' }`
                                )->a( n = `endDate`      v = `{ path: 'END_AT', formatter: 'Formatter.DateCreateObject' }`
                                )->a( n = `icon`         v = `{PIC}`
                                )->a( n = `title`        v = `{TITLE}`
                                )->a( n = `text`         v = `{INFO}`
                                )->a( n = `type`         v = `{TYPE}`
                                )->a( n = `tentative`    v = `{TENTATIVE}`
                                )->a( n = `selected`     v = `{SELECTED}`
                                )->a( n = `ariaHasPopup` v = `{ARIA}`

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


  METHOD popup_details_display.

    DATA popup TYPE REF TO z2ui5_cl_ui5_view_builder.
    popup = z2ui5_cl_ui5_view_builder=>factory( ).

    popup->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:f`    v = `sap.ui.layout.form`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->ele( `ResponsivePopover`
            )->a( n = `id`        v = `detailsPopover`
            )->a( n = `title`     v = client->_bind( sel_title )
            )->a( n = `class`     v = `sapUiContentPadding`
            )->a( n = `placement` v = `Auto`

            )->ele( `beginButton`
                )->tag( `Button`
                    )->a( n = `text`  v = `Edit`
                    )->a( n = `type`  v = `Emphasized`
                    )->a( n = `press` v = client->_event( `EDIT` )

            )->end(
            )->ele( `endButton`
                )->tag( `Button`
                    )->a( n = `text`  v = `Delete`
                    )->a( n = `press` v = client->_event( `DELETE` )

            )->end(

            )->ele( n = `SimpleForm` ns = `f`
                )->a( n = `editable`                v = `false`
                )->a( n = `layout`                  v = `ResponsiveGridLayout`
                )->a( n = `singleContainerFullSize` v = `false`

                )->tag( `Label`
                    )->a( n = `text`     v = `Additional information`
                    )->a( n = `labelFor` v = `moreInfoText`
                )->tag( `Text`
                    )->a( n = `id`   v = `moreInfoText`
                    )->a( n = `text` v = client->_bind( sel_info )
                )->tag( `Label`
                    )->a( n = `text`     v = `From`
                    )->a( n = `labelFor` v = `startDateText`
                )->tag( `Text`
                    )->a( n = `id`   v = `startDateText`
                    )->a( n = `text` v = client->_bind( sel_start )
                )->tag( `Label`
                    )->a( n = `text`     v = `To`
                    )->a( n = `labelFor` v = `endDateText`
                )->tag( `Text`
                    )->a( n = `id`   v = `endDateText`
                    )->a( n = `text` v = client->_bind( sel_end ) ).

    client->popover_display( xml = popup->stringify( ) by_id = `PC1` ).

  ENDMETHOD.


  METHOD popup_create_display.

    DATA popup TYPE REF TO z2ui5_cl_ui5_view_builder.
    popup = z2ui5_cl_ui5_view_builder=>factory( ).

    popup->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns`      v = `sap.m`

        )->ele( `Dialog`
            )->a( n = `id` v = `createDialog`

            )->ele( `beginButton`
                )->tag( `Button`
                    )->a( n = `text`  v = `Save`
                    )->a( n = `type`  v = `Emphasized`
                    )->a( n = `press` v = client->_event( `DIALOG_SAVE` )

            )->end(
            )->ele( `endButton`
                )->tag( `Button`
                    )->a( n = `text`  v = `Cancel`
                    )->a( n = `press` v = client->_event( `DIALOG_CANCEL` )

            )->end(

            )->ele( n = `VerticalLayout` ns = `l`
                )->a( n = `class` v = `sapUiContentPadding`
                )->a( n = `width` v = `100%`

                " handleAppointmentTypeChange only re-reads the checkbox; the flag
                " is bound two-way here, so the select wire is dropped
                )->tag( `CheckBox`
                    )->a( n = `id`       v = `isIntervalAppointment`
                    )->a( n = `text`     v = `Interval appointment`
                    )->a( n = `selected` v = client->_bind( d_interval )
                )->tag( `Label`
                    )->a( n = `text`     v = `Select person: `
                    )->a( n = `labelFor` v = `selectPerson`

                )->ele( `Select`
                    )->a( n = `id`             v = `selectPerson`
                    )->a( n = `forceSelection` v = `false`
                    )->a( n = `width`          v = `100%`
                    )->a( n = `items`          v = client->_bind( t_people )
                    )->a( n = `selectedKey`    v = client->_bind( d_person )

                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `{NAME}`
                        )->a( n = `text` v = `{NAME}`

                )->end(

                )->tag( `Label`
                    )->a( n = `text`     v = `Title: `
                    )->a( n = `labelFor` v = `inputTitle`
                )->tag( `Input`
                    )->a( n = `id`    v = `inputTitle`
                    )->a( n = `value` v = client->_bind( d_title )
                )->tag( `Label`
                    )->a( n = `text`     v = `Start date: `
                    )->a( n = `labelFor` v = `startDate`
                " handleCreateChange rejects an end date at or before the start
                )->tag( `DateTimePicker`
                    )->a( n = `id`             v = `startDate`
                    )->a( n = `displayFormat`  v = `short`
                    " the ORIGINAL binds no value at all - it works in Date objects
                    " through setDateValue/getDateValue - so the string binding is the
                    " port's own and the port owes the format. Without it the picker
                    " writes a LOCALE string back (measured: "Jan 10, 2017, 8:00:00 AM"),
                    " which breaks CREATE_CHANGE's `d_end <= d_start` string compare and
                    " lands a non-ISO value in t_appointments beside ISO neighbours
                    )->a( n = `valueFormat`    v = `yyyy-MM-dd'T'HH:mm:ss`
                    )->a( n = `required`       v = `true`
                    )->a( n = `value`          v = client->_bind( d_start )
                    )->a( n = `valueState`     v = client->_bind( d_start_state )
                    )->a( n = `valueStateText` v = `Start date should be before End date`
                    )->a( n = `change`         v = client->_event( `CREATE_CHANGE` )
                )->tag( `Label`
                    )->a( n = `text`     v = `End date: `
                    )->a( n = `labelFor` v = `endDate`
                )->tag( `DateTimePicker`
                    )->a( n = `id`            v = `endDate`
                    )->a( n = `displayFormat` v = `short`
                    " see startDate above - the compare is only meaningful while both
                    " sides stay lexicographically sortable ISO
                    )->a( n = `valueFormat`   v = `yyyy-MM-dd'T'HH:mm:ss`
                    )->a( n = `required`      v = `true`
                    )->a( n = `value`         v = client->_bind( d_end )
                    )->a( n = `change`        v = client->_event( `CREATE_CHANGE` )
                )->tag( `Label`
                    )->a( n = `text`     v = `More information: `
                    )->a( n = `labelFor` v = `inputInfo`
                )->tag( `Input`
                    )->a( n = `id`    v = `moreInfo`
                    )->a( n = `value` v = client->_bind( d_info ) ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA path TYPE string.
          DATA count TYPE string.
          DATA first_type TYPE string.
          DATA differ LIKE abap_false.
          DATA person_sel LIKE LINE OF t_people.
            DATA appt_sel LIKE LINE OF person_sel-t_appointments.
          DATA temp3 TYPE string.
          DATA parts TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
          DATA temp4 LIKE LINE OF parts.
          DATA temp5 LIKE sy-tabix.
          DATA temp6 LIKE LINE OF parts.
          DATA temp7 LIKE sy-tabix.
          DATA person TYPE z2ui5_cl_smpc_app_547=>ty_s_person.
            DATA appointment TYPE z2ui5_cl_smpc_app_547=>ty_s_appointment.
            DATA temp15 LIKE LINE OF person-t_appointments.
            DATA temp16 LIKE sy-tabix.
        DATA temp8 TYPE i.
        DATA row_index LIKE temp8.
        DATA temp9 TYPE string.
          DATA temp17 LIKE LINE OF t_people.
          DATA temp18 LIKE sy-tabix.
        DATA temp10 TYPE string.
          DATA temp19 LIKE LINE OF t_people.
          DATA temp20 LIKE sy-tabix.
        FIELD-SYMBOLS <person> TYPE z2ui5_cl_smpc_app_547=>ty_s_person.
        DATA temp11 TYPE string.
          DATA temp12 TYPE i.
          DATA temp21 LIKE sy-subrc.
            DATA temp22 LIKE sy-subrc.
          DATA target_row LIKE temp12.
            FIELD-SYMBOLS <target> TYPE z2ui5_cl_smpc_app_547=>ty_s_person.
                DATA temp13 TYPE z2ui5_cl_smpc_app_547=>ty_s_header.
                DATA temp14 TYPE z2ui5_cl_smpc_app_547=>ty_s_appointment.

    CASE client->get_event( ).

      WHEN `APPT_SELECT`.
        
        path = client->get_event_arg( ).
        IF path IS INITIAL.
          " _handleGroupAppointments: a collapsed GROUP was clicked
          
          count  = client->get_event_arg( 3 ).
          " whether the selected appointments differ in type is computed here, from
          " the bound `selected` flags - the client-side .some(function(a){...}) it
          " replaced is not in the UI5 expression grammar and threw
          
          first_type = ``.
          
          differ = abap_false.
          
          LOOP AT t_people INTO person_sel.
            
            LOOP AT person_sel-t_appointments INTO appt_sel WHERE selected = abap_true.
              IF first_type IS INITIAL.
                first_type = appt_sel-type.
              ELSEIF appt_sel-type <> first_type.
                differ = abap_true.
              ENDIF.
            ENDLOOP.
          ENDLOOP.
          
          IF differ = abap_true.
            temp3 = |{ count } Appointments of different types selected|.
          ELSE.
            temp3 = |{ count } Appointments of the same { client->get_event_arg( 4 ) } selected|.
          ENDIF.
          client->message_toast_display(
              temp3 ).
        ELSEIF client->get_event_arg( 2 ) <> abap_true.
          client->popover_destroy( ).
        ELSE.
          
          SPLIT path AT `/` INTO TABLE parts.
          DELETE parts WHERE table_line IS INITIAL.
          
          
          temp5 = sy-tabix.
          READ TABLE parts INDEX 2 INTO temp4.
          sy-tabix = temp5.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          sel_row   = temp4.
          
          
          temp7 = sy-tabix.
          READ TABLE parts INDEX lines( parts ) INTO temp6.
          sy-tabix = temp7.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          sel_index = temp6.
          
          READ TABLE t_people INDEX sel_row + 1 INTO person.
          IF sy-subrc = 0 AND sel_index >= 0 AND sel_index < lines( person-t_appointments ).
            
            
            
            temp16 = sy-tabix.
            READ TABLE person-t_appointments INDEX sel_index + 1 INTO temp15.
            sy-tabix = temp16.
            IF sy-subrc <> 0.
              ASSERT 1 = 0.
            ENDIF.
            appointment = temp15.
            sel_title = appointment-title.
            sel_info  = appointment-info.
            sel_start = appointment-start_at.
            sel_end   = appointment-end_at.
            popup_details_display( ).
          ENDIF.
        ENDIF.

      WHEN `APPT_CREATE`.
        " handleAppointmentCreate opens the dialog on the calendar's start date
        d_mode        = `create`.
        d_person      = ``.
        d_interval    = abap_false.
        d_title       = ``.
        d_info        = ``.
        d_start       = start_date.
        d_end         = start_date.
        d_start_state = `None`.
        popup_create_display( ).

      WHEN `INTERVAL_SELECT`.
        " handleAppointmentAddWithContext keeps the clicked interval and row
        d_mode        = `create_with_context`.
        
        temp8 = client->get_event_arg( 11 ).
        
        row_index = temp8.
        
        IF row_index >= 0 AND row_index < lines( t_people ).
          
          
          temp18 = sy-tabix.
          READ TABLE t_people INDEX row_index + 1 INTO temp17.
          sy-tabix = temp18.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          temp9 = temp17-name.
        ELSE.
          temp9 = ``.
        ENDIF.
        d_person      = temp9.
        d_interval    = abap_false.
        d_title       = ``.
        d_info        = ``.
        d_start       = iso_of( 1 ).
        d_end         = iso_of( 6 ).
        d_start_state = `None`.
        popup_create_display( ).

      WHEN `EDIT`.
        " handleEditButton closes the popover and opens the dialog on the row
        client->popover_destroy( ).
        d_mode        = `edit_appointment`.
        
        IF sel_row >= 0 AND sel_row < lines( t_people ).
          
          
          temp20 = sy-tabix.
          READ TABLE t_people INDEX sel_row + 1 INTO temp19.
          sy-tabix = temp20.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          temp10 = temp19-name.
        ELSE.
          temp10 = ``.
        ENDIF.
        d_person      = temp10.
        d_interval    = abap_false.
        d_title       = sel_title.
        d_info        = sel_info.
        d_start       = sel_start.
        d_end         = sel_end.
        d_start_state = `None`.
        popup_create_display( ).

      WHEN `DELETE`.
        " handleDeleteAppointment removes the appointment behind the popover
        
        READ TABLE t_people INDEX sel_row + 1 ASSIGNING <person>.
        IF sy-subrc = 0 AND sel_index >= 0 AND sel_index < lines( <person>-t_appointments ).
          DELETE <person>-t_appointments INDEX sel_index + 1.
        ENDIF.
        client->popover_destroy( ).

      WHEN `CREATE_CHANGE`.
        " _validateDateTimePicker: the end date has to be after the start date
        
        IF d_start IS NOT INITIAL AND d_end IS NOT INITIAL AND d_end <= d_start.
          temp11 = `Error`.
        ELSE.
          temp11 = `None`.
        ENDIF.
        d_start_state = temp11.

      WHEN `DIALOG_SAVE`.
        IF d_start_state <> `Error`.
          
          
          READ TABLE t_people WITH KEY name = d_person TRANSPORTING NO FIELDS.
          temp21 = sy-subrc.
          IF temp21 = 0.
            
            READ TABLE t_people WITH KEY name = d_person TRANSPORTING NO FIELDS.
            temp22 = sy-tabix.
            temp12 = temp22 - 1.
          ELSE.
            temp12 = 0.
          ENDIF.
          
          target_row = temp12.
          IF d_mode = `edit_appointment`.
            appointment_edit( target_row ).
          ELSE.
            " _addNewAppointment appends to the picked person's appointments, or
            " to their interval HEADERS when the checkbox is set
            
            READ TABLE t_people INDEX target_row + 1 ASSIGNING <target>.
            IF sy-subrc = 0.
              IF d_interval = abap_true.
                
                CLEAR temp13.
                temp13-title = d_title.
                temp13-start_at = d_start.
                temp13-end_at = d_end.
                temp13-type = `Type01`.
                INSERT temp13 INTO TABLE <target>-t_headers.
              ELSE.
                
                CLEAR temp14.
                temp14-title = d_title.
                temp14-info = d_info.
                temp14-start_at = d_start.
                temp14-end_at = d_end.
                temp14-type = `Type01`.
                temp14-aria = `Dialog`.
                INSERT temp14 INTO TABLE <target>-t_appointments.
              ENDIF.
            ENDIF.
          ENDIF.
          client->popup_destroy( ).
        ENDIF.

      WHEN `DIALOG_CANCEL`.
        client->popup_destroy( ).

    ENDCASE.

  ENDMETHOD.


  METHOD appointment_edit.

    " _editAppointment rewrites the row in place, moving it to the picked owner
    " when the Select changed
    FIELD-SYMBOLS <source> TYPE z2ui5_cl_smpc_app_547=>ty_s_person.
    DATA edited TYPE z2ui5_cl_smpc_app_547=>ty_s_appointment.
    DATA temp23 LIKE LINE OF <source>-t_appointments.
    DATA temp24 LIKE sy-tabix.
      FIELD-SYMBOLS <temp15> LIKE LINE OF <source>-t_appointments.
      DATA temp16 LIKE sy-tabix.
    FIELD-SYMBOLS <owner> TYPE z2ui5_cl_smpc_app_547=>ty_s_person.
    READ TABLE t_people INDEX sel_row + 1 ASSIGNING <source>.
    IF sy-subrc <> 0 OR sel_index < 0 OR sel_index >= lines( <source>-t_appointments ).
      RETURN.
    ENDIF.

    
    
    
    temp24 = sy-tabix.
    READ TABLE <source>-t_appointments INDEX sel_index + 1 INTO temp23.
    sy-tabix = temp24.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    edited = temp23.
    edited-title    = d_title.
    edited-info     = d_info.
    edited-start_at = d_start.
    edited-end_at   = d_end.

    IF target_row = sel_row.
      
      
      temp16 = sy-tabix.
      READ TABLE <source>-t_appointments INDEX sel_index + 1 ASSIGNING <temp15>.
      sy-tabix = temp16.
      IF sy-subrc <> 0.
        ASSERT 1 = 0.
      ENDIF.
      <temp15> = edited.
      RETURN.
    ENDIF.

    DELETE <source>-t_appointments INDEX sel_index + 1.
    
    READ TABLE t_people INDEX target_row + 1 ASSIGNING <owner>.
    IF sy-subrc = 0.
      INSERT edited INTO TABLE <owner>-t_appointments.
    ENDIF.

  ENDMETHOD.


  METHOD iso_of.

    " five consecutive event arguments (year, month, day, hour, minute) as one
    " ISO string - the parts travel LOCAL, so no timezone shifts the day
    DATA temp17 TYPE i.
    DATA temp25 TYPE i.
    DATA temp1 TYPE i.
    DATA temp2 TYPE i.
    temp17 = client->get_event_arg( first + 1 ).
    
    temp25 = client->get_event_arg( first + 2 ).
    
    temp1 = client->get_event_arg( first + 3 ).
    
    temp2 = client->get_event_arg( first + 4 ).
    result = |{ client->get_event_arg( first ) }| &&
             |-{ temp17 WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
             |-{ temp25 WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
             |T{ temp1 WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
             |:{ temp2 WIDTH = 2 ALIGN = RIGHT PAD = '0' }:00|.

  ENDMETHOD.


  METHOD model_init.
    DATA temp18 LIKE t_people.
    DATA temp19 LIKE LINE OF temp18.
    DATA temp26 TYPE z2ui5_cl_smpc_app_547=>ty_t_appointment.
    DATA temp27 LIKE LINE OF temp26.
    DATA temp28 TYPE z2ui5_cl_smpc_app_547=>ty_t_header.
    DATA temp29 LIKE LINE OF temp28.
    DATA temp30 TYPE z2ui5_cl_smpc_app_547=>ty_t_appointment.
    DATA temp31 LIKE LINE OF temp30.
    DATA temp32 TYPE z2ui5_cl_smpc_app_547=>ty_t_header.
    DATA temp33 LIKE LINE OF temp32.
    DATA temp34 TYPE z2ui5_cl_smpc_app_547=>ty_t_appointment.
    DATA temp35 LIKE LINE OF temp34.
    DATA temp36 TYPE z2ui5_cl_smpc_app_547=>ty_t_header.
    DATA temp37 LIKE LINE OF temp36.

    start_date    = `2017-01-15T08:00:00`.
    sel_row       = -1.
    sel_index     = -1.
    d_mode        = `create`.
    d_start_state = `None`.

    
    CLEAR temp18.
    
    temp19-pic = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/John_Miller.png`.
    temp19-name = `John Miller`.
    temp19-role = `team member`.
    
    CLEAR temp26.
    
    temp27-start_at = `2017-01-08T08:30:00`.
    temp27-end_at = `2017-01-08T09:30:00`.
    temp27-title = `Meet Max Mustermann`.
    temp27-type = `Type02`.
    temp27-tentative = abap_false.
    temp27-aria = `Dialog`.
    INSERT temp27 INTO TABLE temp26.
    temp27-start_at = `2017-01-11T10:00:00`.
    temp27-end_at = `2017-01-11T12:00:00`.
    temp27-title = `Team meeting`.
    temp27-info = `room 1`.
    temp27-type = `Type01`.
    temp27-pic = `sap-icon://sap-ui5`.
    temp27-tentative = abap_false.
    temp27-aria = `Dialog`.
    INSERT temp27 INTO TABLE temp26.
    temp27-start_at = `2017-01-12T11:30:00`.
    temp27-end_at = `2017-01-12T13:30:00`.
    temp27-title = `Lunch`.
    temp27-info = `canteen`.
    temp27-type = `Type03`.
    temp27-tentative = abap_true.
    temp27-aria = `Dialog`.
    INSERT temp27 INTO TABLE temp26.
    temp27-start_at = `2017-01-15T08:30:00`.
    temp27-end_at = `2017-01-15T09:30:00`.
    temp27-title = `Meet Max Mustermann`.
    temp27-type = `Type02`.
    temp27-tentative = abap_false.
    temp27-aria = `Dialog`.
    INSERT temp27 INTO TABLE temp26.
    temp27-start_at = `2017-01-15T10:00:00`.
    temp27-end_at = `2017-01-15T12:00:00`.
    temp27-title = `Team meeting`.
    temp27-info = `room 1`.
    temp27-type = `Type01`.
    temp27-pic = `sap-icon://sap-ui5`.
    temp27-tentative = abap_false.
    temp27-aria = `Dialog`.
    INSERT temp27 INTO TABLE temp26.
    temp27-start_at = `2017-01-15T11:30:00`.
    temp27-end_at = `2017-01-15T13:30:00`.
    temp27-title = `Lunch`.
    temp27-info = `canteen`.
    temp27-type = `Type03`.
    temp27-tentative = abap_true.
    temp27-aria = `Dialog`.
    INSERT temp27 INTO TABLE temp26.
    temp27-start_at = `2017-01-15T13:30:00`.
    temp27-end_at = `2017-01-15T17:30:00`.
    temp27-title = `Discussion with clients`.
    temp27-info = `online meeting`.
    temp27-type = `Type02`.
    temp27-tentative = abap_false.
    temp27-aria = `Dialog`.
    INSERT temp27 INTO TABLE temp26.
    temp27-start_at = `2017-01-16T04:00:00`.
    temp27-end_at = `2017-01-16T22:30:00`.
    temp27-title = `Discussion of the plan`.
    temp27-info = `Online meeting`.
    temp27-type = `Type04`.
    temp27-tentative = abap_false.
    temp27-aria = `Dialog`.
    INSERT temp27 INTO TABLE temp26.
    temp27-start_at = `2017-01-18T08:30:00`.
    temp27-end_at = `2017-01-18T09:30:00`.
    temp27-title = `Meeting with the manager`.
    temp27-type = `Type02`.
    temp27-tentative = abap_false.
    temp27-aria = `Dialog`.
    INSERT temp27 INTO TABLE temp26.
    temp27-start_at = `2017-01-18T11:30:00`.
    temp27-end_at = `2017-01-18T13:30:00`.
    temp27-title = `Lunch`.
    temp27-info = `canteen`.
    temp27-type = `Type03`.
    temp27-tentative = abap_true.
    temp27-aria = `Dialog`.
    INSERT temp27 INTO TABLE temp26.
    temp27-start_at = `2017-01-18T01:00:00`.
    temp27-end_at = `2017-01-18T22:00:00`.
    temp27-title = `Team meeting`.
    temp27-info = `regular`.
    temp27-type = `Type01`.
    temp27-pic = `sap-icon://sap-ui5`.
    temp27-tentative = abap_false.
    temp27-aria = `Dialog`.
    INSERT temp27 INTO TABLE temp26.
    temp27-start_at = `2017-01-21T00:30:00`.
    temp27-end_at = `2017-01-21T23:30:00`.
    temp27-title = `New Product`.
    temp27-info = `room 105`.
    temp27-type = `Type03`.
    temp27-tentative = abap_true.
    temp27-aria = `Dialog`.
    INSERT temp27 INTO TABLE temp26.
    temp27-start_at = `2017-01-25T11:30:00`.
    temp27-end_at = `2017-01-25T13:30:00`.
    temp27-title = `Lunch`.
    temp27-type = `Type01`.
    temp27-tentative = abap_true.
    temp27-aria = `Dialog`.
    INSERT temp27 INTO TABLE temp26.
    temp27-start_at = `2017-01-29T10:00:00`.
    temp27-end_at = `2017-01-29T12:00:00`.
    temp27-title = `Team meeting`.
    temp27-info = `room 1`.
    temp27-type = `Type01`.
    temp27-pic = `sap-icon://sap-ui5`.
    temp27-tentative = abap_false.
    temp27-aria = `Dialog`.
    INSERT temp27 INTO TABLE temp26.
    temp27-start_at = `2017-01-30T08:30:00`.
    temp27-end_at = `2017-01-30T09:30:00`.
    temp27-title = `Meet Max Mustermann`.
    temp27-type = `Type02`.
    temp27-tentative = abap_false.
    temp27-aria = `Dialog`.
    INSERT temp27 INTO TABLE temp26.
    temp27-start_at = `2017-01-30T10:00:00`.
    temp27-end_at = `2017-01-30T12:00:00`.
    temp27-title = `Team meeting`.
    temp27-info = `room 1`.
    temp27-type = `Type01`.
    temp27-pic = `sap-icon://sap-ui5`.
    temp27-tentative = abap_false.
    temp27-aria = `Dialog`.
    INSERT temp27 INTO TABLE temp26.
    temp27-start_at = `2017-01-30T11:30:00`.
    temp27-end_at = `2017-01-30T13:30:00`.
    temp27-title = `Lunch`.
    temp27-type = `Type03`.
    temp27-tentative = abap_true.
    temp27-aria = `Dialog`.
    INSERT temp27 INTO TABLE temp26.
    temp27-start_at = `2017-01-30T13:30:00`.
    temp27-end_at = `2017-01-30T17:30:00`.
    temp27-title = `Discussion with clients`.
    temp27-type = `Type02`.
    temp27-tentative = abap_false.
    temp27-aria = `Dialog`.
    INSERT temp27 INTO TABLE temp26.
    temp27-start_at = `2017-01-31T10:00:00`.
    temp27-end_at = `2017-01-31T11:30:00`.
    temp27-title = `Discussion of the plan`.
    temp27-info = `Online meeting`.
    temp27-type = `Type04`.
    temp27-tentative = abap_false.
    temp27-aria = `Dialog`.
    INSERT temp27 INTO TABLE temp26.
    temp27-start_at = `2017-02-03T08:30:00`.
    temp27-end_at = `2017-02-13T09:30:00`.
    temp27-title = `Meeting with the manager`.
    temp27-type = `Type02`.
    temp27-tentative = abap_false.
    temp27-aria = `Dialog`.
    INSERT temp27 INTO TABLE temp26.
    temp27-start_at = `2017-02-04T10:00:00`.
    temp27-end_at = `2017-02-04T12:00:00`.
    temp27-title = `Team meeting`.
    temp27-info = `room 1`.
    temp27-type = `Type01`.
    temp27-pic = `sap-icon://sap-ui5`.
    temp27-tentative = abap_false.
    temp27-aria = `Dialog`.
    INSERT temp27 INTO TABLE temp26.
    temp27-start_at = `2017-03-30T10:00:00`.
    temp27-end_at = `2017-06-02T12:00:00`.
    temp27-title = `Working out of the building`.
    temp27-type = `Type07`.
    temp27-pic = `sap-icon://sap-ui5`.
    temp27-tentative = abap_false.
    temp27-aria = `Dialog`.
    INSERT temp27 INTO TABLE temp26.
    temp19-t_appointments = temp26.
    
    CLEAR temp28.
    
    temp29-start_at = `2017-01-15T08:00:00`.
    temp29-end_at = `2017-01-15T10:00:00`.
    temp29-title = `Reminder`.
    temp29-type = `Type06`.
    INSERT temp29 INTO TABLE temp28.
    temp29-start_at = `2017-01-15T17:00:00`.
    temp29-end_at = `2017-01-15T19:00:00`.
    temp29-title = `Reminder`.
    temp29-type = `Type06`.
    INSERT temp29 INTO TABLE temp28.
    temp29-start_at = `2017-09-01T00:00:00`.
    temp29-end_at = `2017-11-30T23:59:00`.
    temp29-title = `New quarter`.
    temp29-type = `Type10`.
    INSERT temp29 INTO TABLE temp28.
    temp29-start_at = `2018-02-01T00:00:00`.
    temp29-end_at = `2018-04-30T23:59:00`.
    temp29-title = `New quarter`.
    temp29-type = `Type10`.
    INSERT temp29 INTO TABLE temp28.
    temp19-t_headers = temp28.
    INSERT temp19 INTO TABLE temp18.
    temp19-pic = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/Donna_Moore.jpg`.
    temp19-name = `Donna Moore`.
    temp19-role = `team member`.
    
    CLEAR temp30.
    
    temp31-start_at = `2017-01-10T18:00:00`.
    temp31-end_at = `2017-01-10T19:10:00`.
    temp31-title = `Discussion of the plan`.
    temp31-info = `Online meeting`.
    temp31-type = `Type04`.
    temp31-tentative = abap_false.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-start_at = `2017-01-09T10:00:00`.
    temp31-end_at = `2017-01-13T12:00:00`.
    temp31-title = `Workshop out of the country`.
    temp31-type = `Type07`.
    temp31-pic = `sap-icon://sap-ui5`.
    temp31-tentative = abap_false.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-start_at = `2017-01-15T08:00:00`.
    temp31-end_at = `2017-01-15T09:30:00`.
    temp31-title = `Discussion of the plan`.
    temp31-info = `Online meeting`.
    temp31-type = `Type04`.
    temp31-tentative = abap_false.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-start_at = `2017-01-15T10:00:00`.
    temp31-end_at = `2017-01-15T12:00:00`.
    temp31-title = `Team meeting`.
    temp31-info = `room 1`.
    temp31-type = `Type01`.
    temp31-pic = `sap-icon://sap-ui5`.
    temp31-tentative = abap_false.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-start_at = `2017-01-15T18:00:00`.
    temp31-end_at = `2017-01-15T19:10:00`.
    temp31-title = `Discussion of the plan`.
    temp31-info = `Online meeting`.
    temp31-type = `Type04`.
    temp31-tentative = abap_false.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-start_at = `2017-01-16T10:00:00`.
    temp31-end_at = `2017-01-31T12:00:00`.
    temp31-title = `Workshop out of the country`.
    temp31-type = `Type07`.
    temp31-pic = `sap-icon://sap-ui5`.
    temp31-tentative = abap_false.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-start_at = `2018-01-01T00:00:00`.
    temp31-end_at = `2018-03-31T23:59:00`.
    temp31-title = `New quarter`.
    temp31-type = `Type10`.
    temp31-tentative = abap_false.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-start_at = `2017-02-11T10:00:00`.
    temp31-end_at = `2017-03-20T12:00:00`.
    temp31-title = `Team collaboration`.
    temp31-info = `room 1`.
    temp31-type = `Type01`.
    temp31-pic = `sap-icon://sap-ui5`.
    temp31-tentative = abap_false.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-start_at = `2017-04-01T10:00:00`.
    temp31-end_at = `2017-05-01T12:00:00`.
    temp31-title = `Workshop out of the country`.
    temp31-type = `Type07`.
    temp31-pic = `sap-icon://sap-ui5`.
    temp31-tentative = abap_false.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-start_at = `2017-05-01T10:00:00`.
    temp31-end_at = `2017-05-31T12:00:00`.
    temp31-title = `Out of the office`.
    temp31-type = `Type08`.
    temp31-tentative = abap_false.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-start_at = `2017-08-01T00:00:00`.
    temp31-end_at = `2017-08-31T23:59:00`.
    temp31-title = `Vacation`.
    temp31-info = `out of office`.
    temp31-type = `Type04`.
    temp31-tentative = abap_false.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp19-t_appointments = temp30.
    
    CLEAR temp32.
    
    temp33-start_at = `2017-01-15T09:00:00`.
    temp33-end_at = `2017-01-15T10:00:00`.
    temp33-title = `Payment reminder`.
    temp33-type = `Type06`.
    INSERT temp33 INTO TABLE temp32.
    temp33-start_at = `2017-01-15T16:30:00`.
    temp33-end_at = `2017-01-15T18:00:00`.
    temp33-title = `Private appointment`.
    temp33-type = `Type06`.
    INSERT temp33 INTO TABLE temp32.
    temp19-t_headers = temp32.
    INSERT temp19 INTO TABLE temp18.
    temp19-pic = `sap-icon://employee`.
    temp19-name = `Max Mustermann`.
    temp19-role = `team member`.
    
    CLEAR temp34.
    
    temp35-start_at = `2017-01-15T08:30:00`.
    temp35-end_at = `2017-01-15T09:30:00`.
    temp35-title = `Meet John Miller`.
    temp35-type = `Type02`.
    temp35-tentative = abap_false.
    temp35-aria = `Dialog`.
    INSERT temp35 INTO TABLE temp34.
    temp35-start_at = `2017-01-15T10:00:00`.
    temp35-end_at = `2017-01-15T12:00:00`.
    temp35-title = `Team meeting`.
    temp35-info = `room 1`.
    temp35-type = `Type01`.
    temp35-pic = `sap-icon://sap-ui5`.
    temp35-tentative = abap_false.
    temp35-aria = `Dialog`.
    INSERT temp35 INTO TABLE temp34.
    temp35-start_at = `2017-01-15T13:00:00`.
    temp35-end_at = `2017-01-15T16:00:00`.
    temp35-title = `Discussion with clients`.
    temp35-info = `online`.
    temp35-type = `Type02`.
    temp35-tentative = abap_false.
    temp35-aria = `Dialog`.
    INSERT temp35 INTO TABLE temp34.
    temp35-start_at = `2017-01-16T00:00:00`.
    temp35-end_at = `2017-01-16T23:59:00`.
    temp35-title = `Vacation`.
    temp35-info = `out of office`.
    temp35-type = `Type08`.
    temp35-tentative = abap_false.
    temp35-aria = `Dialog`.
    INSERT temp35 INTO TABLE temp34.
    temp35-start_at = `2017-01-17T01:00:00`.
    temp35-end_at = `2017-01-18T22:00:00`.
    temp35-title = `Workshop`.
    temp35-info = `regular`.
    temp35-type = `Type08`.
    temp35-pic = `sap-icon://sap-ui5`.
    temp35-tentative = abap_false.
    temp35-aria = `Dialog`.
    INSERT temp35 INTO TABLE temp34.
    temp35-start_at = `2017-01-19T08:30:00`.
    temp35-end_at = `2017-01-19T18:30:00`.
    temp35-title = `Meet John Doe`.
    temp35-type = `Type08`.
    temp35-tentative = abap_false.
    temp35-aria = `Dialog`.
    INSERT temp35 INTO TABLE temp34.
    temp35-start_at = `2017-01-19T10:00:00`.
    temp35-end_at = `2017-01-19T16:00:00`.
    temp35-title = `Team meeting`.
    temp35-info = `room 1`.
    temp35-type = `Type08`.
    temp35-pic = `sap-icon://sap-ui5`.
    temp35-tentative = abap_false.
    temp35-aria = `Dialog`.
    INSERT temp35 INTO TABLE temp34.
    temp35-start_at = `2017-01-19T07:00:00`.
    temp35-end_at = `2017-01-19T17:30:00`.
    temp35-title = `Discussion with clients`.
    temp35-type = `Type08`.
    temp35-tentative = abap_false.
    temp35-aria = `Dialog`.
    INSERT temp35 INTO TABLE temp34.
    temp35-start_at = `2017-01-20T00:00:00`.
    temp35-end_at = `2017-01-20T23:59:00`.
    temp35-title = `Vacation`.
    temp35-info = `out of office`.
    temp35-type = `Type08`.
    temp35-tentative = abap_false.
    temp35-aria = `Dialog`.
    INSERT temp35 INTO TABLE temp34.
    temp35-start_at = `2017-01-22T07:00:00`.
    temp35-end_at = `2017-01-27T17:30:00`.
    temp35-title = `Discussion with clients`.
    temp35-info = `out of office`.
    temp35-type = `Type08`.
    temp35-tentative = abap_false.
    temp35-aria = `Dialog`.
    INSERT temp35 INTO TABLE temp34.
    temp35-start_at = `2017-03-13T09:00:00`.
    temp35-end_at = `2017-03-17T10:00:00`.
    temp35-title = `Payment week`.
    temp35-type = `Type08`.
    temp35-aria = `Dialog`.
    INSERT temp35 INTO TABLE temp34.
    temp35-start_at = `2017-04-10T00:00:00`.
    temp35-end_at = `2017-06-16T23:59:00`.
    temp35-title = `Vacation`.
    temp35-info = `out of office`.
    temp35-type = `Type04`.
    temp35-tentative = abap_false.
    temp35-aria = `Dialog`.
    INSERT temp35 INTO TABLE temp34.
    temp35-start_at = `2017-08-01T00:00:00`.
    temp35-end_at = `2017-10-31T23:59:00`.
    temp35-title = `New quarter`.
    temp35-type = `Type10`.
    temp35-tentative = abap_false.
    temp35-aria = `Dialog`.
    INSERT temp35 INTO TABLE temp34.
    temp19-t_appointments = temp34.
    
    CLEAR temp36.
    
    temp37-start_at = `2017-01-16T00:00:00`.
    temp37-end_at = `2017-01-16T23:59:00`.
    temp37-title = `Private`.
    temp37-type = `Type05`.
    INSERT temp37 INTO TABLE temp36.
    temp19-t_headers = temp36.
    INSERT temp19 INTO TABLE temp18.
    t_people = temp18.

  ENDMETHOD.

ENDCLASS.
