" @keywords singleplanningcalendar single planning calendar sap.m singleplanningcalendarcreateapp vbox button singleplanningcalendardayview singleplanningcalendarworkweekview singleplanningcalendarweekview calendarappointment
" @summary This sample demonstrates how the SinglePlanningCalendar control can be used in combination with sap.m.Dialog to create new appointments and sap.m.ResponsivePopover to edit already existing appointments.
CLASS z2ui5_cl_smpc_app_609 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_appointment,
             title     TYPE string,
             text      TYPE string,
             type      TYPE string,
             icon      TYPE string,
             start_at  TYPE string,
             end_at    TYPE string,
             aria      TYPE string,
             tentative TYPE abap_bool,
           END OF ty_s_appointment.
    TYPES ty_t_appointment TYPE STANDARD TABLE OF ty_s_appointment WITH DEFAULT KEY.
    TYPES: BEGIN OF ty_s_type,
             type TYPE string,
           END OF ty_s_type.
    TYPES ty_t_type TYPE STANDARD TABLE OF ty_s_type WITH DEFAULT KEY.

    DATA t_appointments TYPE ty_t_appointment.
    DATA t_types        TYPE ty_t_type.
    DATA start_date     TYPE string.

    " the original keeps all_day in a settings> model; abap2UI5 keeps one
    " default model, so it is a field here
    DATA all_day     TYPE abap_bool.

    " the details popover reads the selected appointment; the modify dialog edits
    " it (or creates a new one when the path is empty)
    DATA sel_index   TYPE i.
    DATA sel_title   TYPE string.
    DATA sel_text    TYPE string.
    DATA sel_type    TYPE string.
    DATA sel_start   TYPE string.
    DATA sel_end     TYPE string.
    DATA sel_typetxt TYPE string.
    DATA dialog_title TYPE string.

    " the modify dialog's date validation: _setDateValueState paints both
    " pickers and updateButtonEnabledState gates the OK button
    DATA date_state      TYPE string.
    DATA date_state_text TYPE string.
    DATA ok_enabled      TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popup_details_display.
    METHODS popup_modify_display.
    METHODS date_check.
    METHODS all_day_hours.
    METHODS at_hour
      IMPORTING iso           TYPE string
                hour          TYPE i
      RETURNING VALUE(result) TYPE string.
    METHODS type_text
      IMPORTING type          TYPE string
      RETURNING VALUE(result) TYPE string.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_609 IMPLEMENTATION.

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
    " the drag, resize and create wires carry the interval's LOCAL date parts
    " (a UTC toISOString( ) would shift the day)
    
    CLEAR temp1.
    INSERT `${$parameters>/appointment} ? ${$parameters>/appointment}.getBindingContext().getPath() : ''` INTO TABLE temp1.
    INSERT `${$parameters>/appointment} ? ${$parameters>/appointment}.getSelected() : false` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `${$parameters>/date}.getFullYear()` INTO TABLE temp2.
    INSERT `${$parameters>/date}.getMonth() + 1` INTO TABLE temp2.
    INSERT `${$parameters>/date}.getDate()` INTO TABLE temp2.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc`     v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core`    v = `sap.ui.core`
        )->a( n = `xmlns:unified` v = `sap.ui.unified`
        )->a( n = `xmlns`         v = `sap.m`
        )->a( n = `core:require`  v = `{Formatter: 'z2ui5/model/formatter'}`

        )->ele( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`
            )->ele( `SinglePlanningCalendar`
                )->a( n = `id`                            v = `SPC1`
                )->a( n = `title`                         v = `My Calendar`
                )->a( n = `appointmentSelect`             v = client->_event(
                          val   = `APPT_SELECT`
                          t_arg = temp1 )
                )->a( n = `headerDateSelect`              v = client->_event(
                          val   = `HEADER_DATE`
                          t_arg = temp2 )
                " handleStartDateChange names the new start date in a toast
                )->a( n = `startDateChange`               v = client->_event( val = `START_DATE_CHANGE` arg = `${$parameters>/date}.toString()` )
                )->a( n = `startDate`                     v = |\{ path: '{ client->_bind_path( start_date ) }', formatter: 'Formatter.DateCreateObject' \}|
                )->a( n = `appointments`                  v = client->_bind( t_appointments )

                )->ele( `actions`
                    )->tag( `Button`
                        )->a( n = `id`      v = `addNewAppointment`
                        )->a( n = `text`    v = `Create`
                        )->a( n = `press`   v = client->_event( `APPT_CREATE` )
                        )->a( n = `tooltip` v = `Add new appointment`

                )->end(

                )->ele( `views`
                    )->tag( `SinglePlanningCalendarDayView`
                        )->a( n = `key`   v = `DayView`
                        )->a( n = `title` v = `Day`
                    )->tag( `SinglePlanningCalendarWorkWeekView`
                        )->a( n = `key`   v = `WorkWeekView`
                        )->a( n = `title` v = `Work Week`
                    )->tag( `SinglePlanningCalendarWeekView`
                        )->a( n = `key`   v = `WeekView`
                        )->a( n = `title` v = `Week`

                )->end(

                )->ele( `appointments`
                    )->tag( n = `CalendarAppointment` ns = `unified`
                        )->a( n = `title`        v = `{TITLE}`
                        )->a( n = `text`         v = `{TEXT}`
                        )->a( n = `type`         v = `{TYPE}`
                        )->a( n = `icon`         v = `{ICON}`
                        )->a( n = `startDate`    v = `{ path: 'START_AT', formatter: 'Formatter.DateCreateObject' }`
                        )->a( n = `endDate`      v = `{ path: 'END_AT', formatter: 'Formatter.DateCreateObject' }`
                        )->a( n = `ariaHasPopup` v = `{ARIA}` ).

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
            )->a( n = `class`     v = `sapUiResponsivePadding--header`
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
                )->a( n = `id`                      v = `appointmentEditForm`
                )->a( n = `editable`                v = `false`
                )->a( n = `layout`                  v = `ResponsiveGridLayout`
                )->a( n = `singleContainerFullSize` v = `false`

                )->tag( `Label`
                    )->a( n = `text`     v = `Additional information`
                    )->a( n = `labelFor` v = `moreInfo`
                )->tag( `Text`
                    )->a( n = `id`   v = `moreInfoText`
                    )->a( n = `text` v = client->_bind( sel_text )
                )->tag( `Label`
                    )->a( n = `text`     v = `From`
                    )->a( n = `labelFor` v = `startDate`
                )->tag( `Text`
                    )->a( n = `text` v = client->_bind( sel_start )
                )->tag( `Label`
                    )->a( n = `text`     v = `To`
                    )->a( n = `labelFor` v = `endDate`
                )->tag( `Text`
                    )->a( n = `text` v = client->_bind( sel_end )
                )->tag( `CheckBox`
                    )->a( n = `id`       v = `allDayText`
                    )->a( n = `text`     v = `All-day`
                    )->a( n = `selected` v = client->_bind( all_day )
                    )->a( n = `enabled`  v = `false`
                )->tag( `Label`
                    )->a( n = `text`     v = `Type`
                    )->a( n = `labelFor` v = `appType`
                " _typeFormatter maps the type key to its legend text - resolved
                " in ABAP over the same supported-items table
                )->tag( `Text`
                    )->a( n = `id`   v = `appTypeText`
                    )->a( n = `text` v = client->_bind( sel_typetxt ) ).

    client->popover_display( xml = popup->stringify( ) by_id = `SPC1` ).

  ENDMETHOD.


  METHOD popup_modify_display.

    DATA popup TYPE REF TO z2ui5_cl_ui5_view_builder.
    popup = z2ui5_cl_ui5_view_builder=>factory( ).

    popup->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:f`    v = `sap.ui.layout.form`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->ele( `Dialog`
            )->a( n = `id`    v = `modifyDialog`
            )->a( n = `title` v = client->_bind( dialog_title )

            )->ele( `beginButton`
                " updateButtonEnabledState: the OK button is disabled while a
                " picker is empty or the end is not after the start
                )->tag( `Button`
                    )->a( n = `text`    v = `OK`
                    )->a( n = `type`    v = `Emphasized`
                    )->a( n = `enabled` v = client->_bind( ok_enabled )
                    )->a( n = `press`   v = client->_event( `DIALOG_OK` )

            )->end(
            )->ele( `endButton`
                )->tag( `Button`
                    )->a( n = `text`  v = `Cancel`
                    )->a( n = `press` v = client->_event( `DIALOG_CANCEL` )

            )->end(

            )->ele( n = `VerticalLayout` ns = `l`
                )->a( n = `class` v = `sapUiContentPadding`
                )->a( n = `width` v = `100%`

                )->ele( n = `SimpleForm` ns = `f`
                    )->a( n = `id`                      v = `appointmentCreateForm`
                    )->a( n = `editable`                v = `true`
                    )->a( n = `layout`                  v = `ResponsiveGridLayout`
                    )->a( n = `singleContainerFullSize` v = `false`

                    )->tag( `Label`
                        )->a( n = `text`     v = `Title`
                        )->a( n = `labelFor` v = `appTitle`
                    )->tag( `Input`
                        )->a( n = `id`    v = `appTitle`
                        )->a( n = `value` v = client->_bind( sel_title )
                    )->tag( `Label`
                        )->a( n = `text`     v = `Additional information`
                        )->a( n = `labelFor` v = `inputInfo`
                    )->tag( `Input`
                        )->a( n = `id`    v = `moreInfo`
                        )->a( n = `value` v = client->_bind( sel_text )
                    )->tag( `Label`
                        )->a( n = `text`     v = `From`
                        )->a( n = `labelFor` v = `startDate`
                    " all four pickers carry an explicit ISO valueFormat. The original
                    " never binds value at all - it sets dateValue imperatively - so the
                    " port's string binding needs the format pinned: with none, a
                    " DateTimePicker still READS the model's ISO string (DateFormat falls
                    " back to ISO) but writes a LOCALE string back ("Jul 12, 2018, 2:30:00 PM"),
                    " and a DatePicker cannot read it at all - it showed the raw
                    " "2018-07-09T09:00:00" with no date value and wrote back "7/12/18".
                    " With the format pinned both pairs read and write the same 19-character
                    " ISO string, which is what makes the ALL_DAY hour rewrite and the
                    " string comparison in date_check safe (headless probe, 2026-08-26)
                    )->tag( `DateTimePicker`
                        )->a( n = `id`             v = `DTPStartDate`
                        )->a( n = `required`       v = `true`
                        )->a( n = `visible`        v = |\{= !${ client->_bind( all_day ) } \}|
                        )->a( n = `valueFormat`    v = `yyyy-MM-dd'T'HH:mm:ss`
                        )->a( n = `value`          v = client->_bind( sel_start )
                        )->a( n = `valueState`     v = client->_bind( date_state )
                        )->a( n = `valueStateText` v = client->_bind( date_state_text )
                        )->a( n = `change`         v = client->_event( `DATE_CHECK` )
                    )->tag( `DatePicker`
                        )->a( n = `id`             v = `DPStartDate`
                        )->a( n = `required`       v = `true`
                        )->a( n = `visible`        v = |\{= ${ client->_bind( all_day ) } \}|
                        )->a( n = `valueFormat`    v = `yyyy-MM-dd'T'HH:mm:ss`
                        )->a( n = `value`          v = client->_bind( sel_start )
                        )->a( n = `valueState`     v = client->_bind( date_state )
                        )->a( n = `valueStateText` v = client->_bind( date_state_text )
                        )->a( n = `change`         v = client->_event( `DATE_CHECK` )
                    )->tag( `Label`
                        )->a( n = `text`     v = `To`
                        )->a( n = `labelFor` v = `endDate`
                    )->tag( `DateTimePicker`
                        )->a( n = `id`             v = `DTPEndDate`
                        )->a( n = `required`       v = `true`
                        )->a( n = `visible`        v = |\{= !${ client->_bind( all_day ) } \}|
                        )->a( n = `valueFormat`    v = `yyyy-MM-dd'T'HH:mm:ss`
                        )->a( n = `value`          v = client->_bind( sel_end )
                        )->a( n = `valueState`     v = client->_bind( date_state )
                        )->a( n = `valueStateText` v = client->_bind( date_state_text )
                        )->a( n = `change`         v = client->_event( `DATE_CHECK` )
                    )->tag( `DatePicker`
                        )->a( n = `id`             v = `DPEndDate`
                        )->a( n = `required`       v = `true`
                        )->a( n = `visible`        v = |\{= ${ client->_bind( all_day ) } \}|
                        )->a( n = `valueFormat`    v = `yyyy-MM-dd'T'HH:mm:ss`
                        )->a( n = `value`          v = client->_bind( sel_end )
                        )->a( n = `valueState`     v = client->_bind( date_state )
                        )->a( n = `valueStateText` v = client->_bind( date_state_text )
                        )->a( n = `change`         v = client->_event( `DATE_CHECK` )
                    " handleCheckBoxSelect rewrites the hours, it does not only swap
                    " which picker pair is visible - so the select is wired
                    )->tag( `CheckBox`
                        )->a( n = `id`       v = `allDay`
                        )->a( n = `text`     v = `All-day`
                        )->a( n = `selected` v = client->_bind( all_day )
                        )->a( n = `select`   v = client->_event( `ALL_DAY` )
                    )->tag( `Label`
                        )->a( n = `text`     v = `Type`
                        )->a( n = `labelFor` v = `appType`

                    )->ele( `Select`
                        )->a( n = `id`          v = `appType`
                        )->a( n = `items`       v = client->_bind( t_types )
                        )->a( n = `selectedKey` v = client->_bind( sel_type )

                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `{TYPE}`
                            )->a( n = `text` v = `{TYPE}` ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    DATA day TYPE string.
        DATA path TYPE string.
          TYPES temp1 TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
DATA parts TYPE temp1.
          DATA temp3 LIKE LINE OF parts.
          DATA temp4 LIKE sy-tabix.
            DATA appointment LIKE LINE OF t_appointments.
            DATA temp6 LIKE LINE OF t_appointments.
            DATA temp8 LIKE sy-tabix.
            DATA temp2 TYPE xsdboolean.
          DATA temp5 TYPE i.
          DATA temp10 TYPE i.
          FIELD-SYMBOLS <temp6> LIKE LINE OF t_appointments.
          DATA temp7 LIKE sy-tabix.
          FIELD-SYMBOLS <temp8> LIKE LINE OF t_appointments.
          DATA temp9 LIKE sy-tabix.
          FIELD-SYMBOLS <temp10> LIKE LINE OF t_appointments.
          DATA temp11 LIKE sy-tabix.
          FIELD-SYMBOLS <temp12> LIKE LINE OF t_appointments.
          DATA temp13 LIKE sy-tabix.
          FIELD-SYMBOLS <temp14> LIKE LINE OF t_appointments.
          DATA temp15 LIKE sy-tabix.
          DATA temp16 TYPE z2ui5_cl_smpc_app_609=>ty_s_appointment.

    CASE client->get_event( ).
      WHEN `APPT_SELECT`.
        " handleAppointmentSelect opens the details popover on the picked
        " appointment, and closes it again when the appointment is deselected
        
        path = client->get_event_arg( ).
        IF path IS INITIAL OR client->get_event_arg( 2 ) <> abap_true.
          client->popover_destroy( ).
        ELSE.
          

          SPLIT path AT `/` INTO TABLE parts.
          DELETE parts WHERE table_line IS INITIAL.
          
          
          temp4 = sy-tabix.
          READ TABLE parts INDEX lines( parts ) INTO temp3.
          sy-tabix = temp4.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          sel_index = temp3.
          IF sel_index >= 0 AND sel_index < lines( t_appointments ).
            
            
            
            temp8 = sy-tabix.
            READ TABLE t_appointments INDEX sel_index + 1 INTO temp6.
            sy-tabix = temp8.
            IF sy-subrc <> 0.
              ASSERT 1 = 0.
            ENDIF.
            appointment = temp6.
            sel_title   = appointment-title.
            sel_text    = appointment-text.
            sel_type    = appointment-type.
            sel_start   = appointment-start_at.
            sel_end     = appointment-end_at.
            sel_typetxt = type_text( appointment-type ).
            " an appointment that starts and ends at midnight is an all-day one
            " (CP, not substring( ): a cleared picker sends an empty value and
            " an offset read would dump on it)
            
            temp2 = boolc( sel_start CP `*T00:00:00` AND sel_end CP `*T00:00:00` ).
            all_day     = temp2.
            popup_details_display( ).
          ENDIF.
        ENDIF.
      WHEN `EDIT`.
        " handleEditButton closes the popover and opens the dialog on the same row -
        " the original comments that the Popover HAS to be closed before the Dialog
        " opens, so the close is not optional
        client->popover_destroy( ).
        dialog_title = `Edit appointment`.
        date_check( ).
        popup_modify_display( ).
      WHEN `DELETE`.
        " handlePopoverDeleteButton removes the appointment behind the popover
        IF sel_index >= 0 AND sel_index < lines( t_appointments ).
          DELETE t_appointments INDEX sel_index + 1.
        ENDIF.
        client->popover_destroy( ).
      WHEN `APPT_CREATE` OR `HEADER_DATE`.
        " _createInitialDialogValues seeds the dialog at the default 9 - 10 hours
        " of the picked day (or of the calendar's own start date)
        " Written as IF/ELSE rather than COND: the transpiled backend HOISTS the
        " branch expressions out of a COND and evaluates them BOTH, so the two
        " get_event_arg( ) reads below ran for APPT_CREATE too - a wire that
        " carries no arguments at all - and the missing row asserted instead of
        " returning initial, so every Create press 500'd (e2e-caught 2026-08-22)
        IF client->get_event( ) = `HEADER_DATE`.
          
          temp5 = client->get_event_arg( 2 ).
          
          temp10 = client->get_event_arg( 3 ).
          day = |{ client->get_event_arg( ) }| &&
                |-{ temp5 WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
                |-{ temp10 WIDTH = 2 ALIGN = RIGHT PAD = '0' }|.
        ELSE.
          day = substring( val = start_date len = 10 ).
        ENDIF.
        sel_index    = -1.
        sel_title    = ``.
        sel_text     = ``.
        sel_type     = `Type01`.
        sel_start    = |{ day }T09:00:00|.
        sel_end      = |{ day }T10:00:00|.
        all_day      = abap_false.
        dialog_title = `Create appointment`.
        date_check( ).
        popup_modify_display( ).
      WHEN `ALL_DAY`.
        " handleCheckBoxSelect does more than swap which picker pair is visible:
        " ticking All-day sets both times to midnight (_setHoursToZero) and
        " unticking puts them back on the default hours 9 and 10
        " (_getDefaultAppointmentStartHour / _getDefaultAppointmentEndHour),
        " then copies both into the pair that has just become visible. The
        " CheckBox writes its selected state into all_day BEFORE it fires
        " select (sap.m.CheckBox.ontap), so the flag already carries the new value
        all_day_hours( ).
        date_check( ).
      WHEN `DATE_CHECK`.
        " handleDateTimePickerChange / handleDatePickerChange
        date_check( ).
      WHEN `DIALOG_OK`.
        " handleDialogOkButton writes the dialog back into the picked row, or
        " pushes a new one when the dialog was opened for a create - and only
        " when neither picker is in the error state, as the original checks too
        IF ok_enabled = abap_false.
          RETURN.
        ENDIF.
        IF sel_index >= 0 AND sel_index < lines( t_appointments ).
          
          
          temp7 = sy-tabix.
          READ TABLE t_appointments INDEX sel_index + 1 ASSIGNING <temp6>.
          sy-tabix = temp7.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          <temp6>-title    = sel_title.
          
          
          temp9 = sy-tabix.
          READ TABLE t_appointments INDEX sel_index + 1 ASSIGNING <temp8>.
          sy-tabix = temp9.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          <temp8>-text     = sel_text.
          
          
          temp11 = sy-tabix.
          READ TABLE t_appointments INDEX sel_index + 1 ASSIGNING <temp10>.
          sy-tabix = temp11.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          <temp10>-type     = sel_type.
          
          
          temp13 = sy-tabix.
          READ TABLE t_appointments INDEX sel_index + 1 ASSIGNING <temp12>.
          sy-tabix = temp13.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          <temp12>-start_at = sel_start.
          
          
          temp15 = sy-tabix.
          READ TABLE t_appointments INDEX sel_index + 1 ASSIGNING <temp14>.
          sy-tabix = temp15.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          <temp14>-end_at   = sel_end.
        ELSE.
          " aria must be seeded: an unset ABAP field reaches ariaHasPopup as "",
          " which is not a sap.ui.core.aria.HasPopup member, so validateProperty
          " throws and the binding update takes the view down. The original pushes
          " ariaHasPopup: "Dialog" on the created object.
          
          CLEAR temp16.
          temp16-title = sel_title.
          temp16-text = sel_text.
          temp16-type = sel_type.
          temp16-aria = `Dialog`.
          temp16-start_at = sel_start.
          temp16-end_at = sel_end.
          INSERT temp16 INTO TABLE t_appointments.
        ENDIF.
        client->popup_destroy( ).
      WHEN `DIALOG_CANCEL`.
        client->popup_destroy( ).
      WHEN `START_DATE_CHANGE`.
        client->message_toast_display(
            |'startDateChange' event fired.\n\nNew start date is { client->get_event_arg( ) }| ).
    ENDCASE.

  ENDMETHOD.


  METHOD date_check.

    " handleDateTimePickerChange / handleDatePickerChange / _setDateValueState:
    " an end that is not after the start paints BOTH pickers Error with
    " "Start date should be before End date", and updateButtonEnabledState
    " disables the OK button for that and for an empty picker. The DatePicker
    " pair compares with < (the same all-day date is allowed), the
    " DateTimePicker pair with <= - the two branches of the original.
    " Both values are 19-character ISO strings (the pinned valueFormat), so
    " comparing them as strings orders them by time
    IF sel_start IS INITIAL OR sel_end IS INITIAL.
      date_state      = `None`.
      date_state_text = ``.
      ok_enabled      = abap_false.
    ELSEIF ( all_day = abap_true AND sel_end < sel_start ) OR ( all_day = abap_false AND sel_end <= sel_start ).
      date_state      = `Error`.
      date_state_text = `Start date should be before End date`.
      ok_enabled      = abap_false.
    ELSE.
      date_state      = `None`.
      date_state_text = ``.
      ok_enabled      = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD all_day_hours.

    " _setHoursToZero for an all-day appointment, the sample's own default
    " hours 9 and 10 for a timed one - the rewrite handleCheckBoxSelect does
    " on top of swapping which picker pair is visible
    IF all_day = abap_true.
      sel_start = at_hour( iso = sel_start hour = 0 ).
      sel_end   = at_hour( iso = sel_end   hour = 0 ).
    ELSE.
      sel_start = at_hour( iso = sel_start hour = 9 ).
      sel_end   = at_hour( iso = sel_end   hour = 10 ).
    ENDIF.

  ENDMETHOD.


  METHOD at_hour.

    " the same ISO string with its time part rewritten to the given full hour -
    " _setHoursToZero and the two default-hour helpers of the original. The
    " pickers carry valueFormat yyyy-MM-dd'T'HH:mm:ss, so every value that
    " travels is 19 characters; a cleared picker sends an empty one and is
    " left untouched rather than turned into a date-less time
    IF strlen( iso ) < 10.
      result = iso.
      RETURN.
    ENDIF.
    result = |{ substring( val = iso len = 10 ) }T{ hour WIDTH = 2 ALIGN = RIGHT PAD = '0' }:00:00|.

  ENDMETHOD.


  METHOD type_text.

    " this sample's Details fragment binds {type} directly - no formatter
    result = type.

  ENDMETHOD.


  METHOD model_init.
    DATA temp17 TYPE z2ui5_cl_smpc_app_609=>ty_t_type.
    DATA temp18 LIKE LINE OF temp17.
    DATA temp19 TYPE z2ui5_cl_smpc_app_609=>ty_t_appointment.
    DATA temp20 LIKE LINE OF temp19.

    start_date = `2018-07-09T00:00:00`.
    all_day    = abap_false.
    sel_index  = -1.

    " the sample builds `types` by walking CalendarDayType, and its Select shows
    " the KEY as the text; the enum's own members, in its own order
    
    CLEAR temp17.
    
    temp18-type = `None`.
    INSERT temp18 INTO TABLE temp17.
    temp18-type = `Type01`.
    INSERT temp18 INTO TABLE temp17.
    temp18-type = `Type02`.
    INSERT temp18 INTO TABLE temp17.
    temp18-type = `Type03`.
    INSERT temp18 INTO TABLE temp17.
    temp18-type = `Type04`.
    INSERT temp18 INTO TABLE temp17.
    temp18-type = `Type05`.
    INSERT temp18 INTO TABLE temp17.
    temp18-type = `Type06`.
    INSERT temp18 INTO TABLE temp17.
    temp18-type = `Type07`.
    INSERT temp18 INTO TABLE temp17.
    temp18-type = `Type08`.
    INSERT temp18 INTO TABLE temp17.
    temp18-type = `Type09`.
    INSERT temp18 INTO TABLE temp17.
    temp18-type = `Type10`.
    INSERT temp18 INTO TABLE temp17.
    temp18-type = `Type11`.
    INSERT temp18 INTO TABLE temp17.
    temp18-type = `Type12`.
    INSERT temp18 INTO TABLE temp17.
    temp18-type = `Type13`.
    INSERT temp18 INTO TABLE temp17.
    temp18-type = `Type14`.
    INSERT temp18 INTO TABLE temp17.
    temp18-type = `Type15`.
    INSERT temp18 INTO TABLE temp17.
    temp18-type = `Type16`.
    INSERT temp18 INTO TABLE temp17.
    temp18-type = `Type17`.
    INSERT temp18 INTO TABLE temp17.
    temp18-type = `Type18`.
    INSERT temp18 INTO TABLE temp17.
    temp18-type = `Type19`.
    INSERT temp18 INTO TABLE temp17.
    temp18-type = `Type20`.
    INSERT temp18 INTO TABLE temp17.
    t_types = temp17.

    " onInit's 35 appointments
    
    CLEAR temp19.
    
    temp20-title = `Meet John Miller`.
    temp20-text = ``.
    temp20-type = `Type05`.
    temp20-icon = ``.
    temp20-start_at = `2018-07-08T05:00:00`.
    temp20-end_at = `2018-07-08T06:00:00`.
    temp20-aria = `Dialog`.
    temp20-tentative = abap_false.
    INSERT temp20 INTO TABLE temp19.
    temp20-title = `Discussion of the plan`.
    temp20-text = ``.
    temp20-type = `Type01`.
    temp20-icon = ``.
    temp20-start_at = `2018-07-08T06:00:00`.
    temp20-end_at = `2018-07-08T07:09:00`.
    temp20-aria = `Dialog`.
    temp20-tentative = abap_false.
    INSERT temp20 INTO TABLE temp19.
    temp20-title = `Lunch`.
    temp20-text = `canteen`.
    temp20-type = `Type05`.
    temp20-icon = ``.
    temp20-start_at = `2018-07-08T07:00:00`.
    temp20-end_at = `2018-07-08T08:00:00`.
    temp20-aria = `Dialog`.
    temp20-tentative = abap_false.
    INSERT temp20 INTO TABLE temp19.
    temp20-title = `New Product`.
    temp20-text = `room 105`.
    temp20-type = `Type01`.
    temp20-icon = `sap-icon://meeting-room`.
    temp20-start_at = `2018-07-08T08:00:00`.
    temp20-end_at = `2018-07-08T09:00:00`.
    temp20-aria = `Dialog`.
    temp20-tentative = abap_false.
    INSERT temp20 INTO TABLE temp19.
    temp20-title = `Team meeting`.
    temp20-text = `Regular`.
    temp20-type = `Type01`.
    temp20-icon = `sap-icon://home`.
    temp20-start_at = `2018-07-08T09:09:00`.
    temp20-end_at = `2018-07-08T10:00:00`.
    temp20-aria = `Dialog`.
    temp20-tentative = abap_false.
    INSERT temp20 INTO TABLE temp19.
    temp20-title = `Discussion with clients`.
    temp20-text = `Online meeting`.
    temp20-type = `Type08`.
    temp20-icon = `sap-icon://home`.
    temp20-start_at = `2018-07-08T10:00:00`.
    temp20-end_at = `2018-07-08T11:00:00`.
    temp20-aria = `Dialog`.
    temp20-tentative = abap_false.
    INSERT temp20 INTO TABLE temp19.
    temp20-title = `Discussion of the plan`.
    temp20-text = `Online meeting`.
    temp20-type = `Type01`.
    temp20-icon = `sap-icon://home`.
    temp20-start_at = `2018-07-08T11:00:00`.
    temp20-end_at = `2018-07-08T12:00:00`.
    temp20-aria = `Dialog`.
    temp20-tentative = abap_true.
    INSERT temp20 INTO TABLE temp19.
    temp20-title = `Discussion with clients`.
    temp20-text = ``.
    temp20-type = `Type08`.
    temp20-icon = `sap-icon://home`.
    temp20-start_at = `2018-07-08T12:00:00`.
    temp20-end_at = `2018-07-08T13:09:00`.
    temp20-aria = `Dialog`.
    temp20-tentative = abap_false.
    INSERT temp20 INTO TABLE temp19.
    temp20-title = `Meeting with the manager`.
    temp20-text = ``.
    temp20-type = `Type03`.
    temp20-icon = ``.
    temp20-start_at = `2018-07-08T13:09:00`.
    temp20-end_at = `2018-07-08T13:09:00`.
    temp20-aria = `Dialog`.
    temp20-tentative = abap_false.
    INSERT temp20 INTO TABLE temp19.
    temp20-title = `Meeting with the manager`.
    temp20-text = ``.
    temp20-type = `Type03`.
    temp20-icon = ``.
    temp20-start_at = `2018-07-09T06:30:00`.
    temp20-end_at = `2018-07-09T07:00:00`.
    temp20-aria = `Dialog`.
    temp20-tentative = abap_false.
    INSERT temp20 INTO TABLE temp19.
    temp20-title = `Lunch`.
    temp20-text = ``.
    temp20-type = `Type05`.
    temp20-icon = ``.
    temp20-start_at = `2018-07-09T07:00:00`.
    temp20-end_at = `2018-07-09T08:00:00`.
    temp20-aria = `Dialog`.
    temp20-tentative = abap_false.
    INSERT temp20 INTO TABLE temp19.
    temp20-title = `Team meeting`.
    temp20-text = `online`.
    temp20-type = `Type01`.
    temp20-icon = ``.
    temp20-start_at = `2018-07-09T08:00:00`.
    temp20-end_at = `2018-07-09T09:00:00`.
    temp20-aria = `Dialog`.
    temp20-tentative = abap_false.
    INSERT temp20 INTO TABLE temp19.
    temp20-title = `Discussion with clients`.
    temp20-text = ``.
    temp20-type = `Type08`.
    temp20-icon = ``.
    temp20-start_at = `2018-07-09T09:00:00`.
    temp20-end_at = `2018-07-09T10:00:00`.
    temp20-aria = `Dialog`.
    temp20-tentative = abap_false.
    INSERT temp20 INTO TABLE temp19.
    temp20-title = `Team meeting`.
    temp20-text = `room 5`.
    temp20-type = `Type01`.
    temp20-icon = ``.
    temp20-start_at = `2018-07-09T11:00:00`.
    temp20-end_at = `2018-07-09T14:00:00`.
    temp20-aria = `Dialog`.
    temp20-tentative = abap_false.
    INSERT temp20 INTO TABLE temp19.
    temp20-title = `Daily standup meeting`.
    temp20-text = ``.
    temp20-type = `Type01`.
    temp20-icon = ``.
    temp20-start_at = `2018-07-09T09:00:00`.
    temp20-end_at = `2018-07-09T09:15:00`.
    temp20-aria = `Dialog`.
    temp20-tentative = abap_false.
    INSERT temp20 INTO TABLE temp19.
    temp20-title = `Private meeting`.
    temp20-text = ``.
    temp20-type = `Type03`.
    temp20-icon = ``.
    temp20-start_at = `2018-07-11T09:09:00`.
    temp20-end_at = `2018-07-11T09:20:00`.
    temp20-aria = `Dialog`.
    temp20-tentative = abap_false.
    INSERT temp20 INTO TABLE temp19.
    temp20-title = `Private meeting`.
    temp20-text = ``.
    temp20-type = `Type03`.
    temp20-icon = ``.
    temp20-start_at = `2018-07-10T06:00:00`.
    temp20-end_at = `2018-07-10T07:00:00`.
    temp20-aria = `Dialog`.
    temp20-tentative = abap_false.
    INSERT temp20 INTO TABLE temp19.
    temp20-title = `Meeting with the manager`.
    temp20-text = ``.
    temp20-type = `Type03`.
    temp20-icon = ``.
    temp20-start_at = `2018-07-10T15:00:00`.
    temp20-end_at = `2018-07-10T15:30:00`.
    temp20-aria = `Dialog`.
    temp20-tentative = abap_false.
    INSERT temp20 INTO TABLE temp19.
    temp20-title = `Meet John Doe`.
    temp20-text = ``.
    temp20-type = `Type05`.
    temp20-icon = `sap-icon://home`.
    temp20-start_at = `2018-07-11T07:00:00`.
    temp20-end_at = `2018-07-11T07:30:00`.
    temp20-aria = `Dialog`.
    temp20-tentative = abap_false.
    INSERT temp20 INTO TABLE temp19.
    temp20-title = `Team meeting`.
    temp20-text = `online`.
    temp20-type = `Type01`.
    temp20-icon = ``.
    temp20-start_at = `2018-07-11T08:00:00`.
    temp20-end_at = `2018-07-11T09:30:00`.
    temp20-aria = `Dialog`.
    temp20-tentative = abap_false.
    INSERT temp20 INTO TABLE temp19.
    temp20-title = `Workshop`.
    temp20-text = ``.
    temp20-type = `Type05`.
    temp20-icon = ``.
    temp20-start_at = `2018-07-11T08:30:00`.
    temp20-end_at = `2018-07-11T12:00:00`.
    temp20-aria = `Dialog`.
    temp20-tentative = abap_false.
    INSERT temp20 INTO TABLE temp19.
    temp20-title = `Team collaboration`.
    temp20-text = ``.
    temp20-type = `Type01`.
    temp20-icon = ``.
    temp20-start_at = `2018-07-12T04:00:00`.
    temp20-end_at = `2018-07-12T12:30:00`.
    temp20-aria = `Dialog`.
    temp20-tentative = abap_false.
    INSERT temp20 INTO TABLE temp19.
    temp20-title = `Out of the office`.
    temp20-text = ``.
    temp20-type = `Type05`.
    temp20-icon = ``.
    temp20-start_at = `2018-07-12T15:00:00`.
    temp20-end_at = `2018-07-12T19:30:00`.
    temp20-aria = `Dialog`.
    temp20-tentative = abap_false.
    INSERT temp20 INTO TABLE temp19.
    temp20-title = `Working out of the building`.
    temp20-text = ``.
    temp20-type = `Type05`.
    temp20-icon = ``.
    temp20-start_at = `2018-07-12T20:00:00`.
    temp20-end_at = `2018-07-12T21:30:00`.
    temp20-aria = `Dialog`.
    temp20-tentative = abap_false.
    INSERT temp20 INTO TABLE temp19.
    temp20-title = `Reminder`.
    temp20-text = ``.
    temp20-type = `Type09`.
    temp20-icon = ``.
    temp20-start_at = `2018-07-12T00:00:00`.
    temp20-end_at = `2018-07-13T00:00:00`.
    temp20-aria = `Dialog`.
    temp20-tentative = abap_false.
    INSERT temp20 INTO TABLE temp19.
    temp20-title = `Team collaboration`.
    temp20-text = ``.
    temp20-type = `Type01`.
    temp20-icon = ``.
    temp20-start_at = `2018-07-06T00:00:00`.
    temp20-end_at = `2018-07-16T00:00:00`.
    temp20-aria = `Dialog`.
    temp20-tentative = abap_false.
    INSERT temp20 INTO TABLE temp19.
    temp20-title = `Workshop out of the country`.
    temp20-text = ``.
    temp20-type = `Type05`.
    temp20-icon = ``.
    temp20-start_at = `2018-07-14T00:00:00`.
    temp20-end_at = `2018-07-20T00:00:00`.
    temp20-aria = `Dialog`.
    temp20-tentative = abap_false.
    INSERT temp20 INTO TABLE temp19.
    temp20-title = `Payment reminder`.
    temp20-text = ``.
    temp20-type = `Type09`.
    temp20-icon = ``.
    temp20-start_at = `2018-07-07T00:00:00`.
    temp20-end_at = `2018-07-08T00:00:00`.
    temp20-aria = `Dialog`.
    temp20-tentative = abap_false.
    INSERT temp20 INTO TABLE temp19.
    temp20-title = `Meeting with the manager`.
    temp20-text = ``.
    temp20-type = `Type03`.
    temp20-icon = ``.
    temp20-start_at = `2018-07-06T09:00:00`.
    temp20-end_at = `2018-07-06T10:00:00`.
    temp20-aria = `Dialog`.
    temp20-tentative = abap_false.
    INSERT temp20 INTO TABLE temp19.
    temp20-title = `Daily standup meeting`.
    temp20-text = ``.
    temp20-type = `Type01`.
    temp20-icon = ``.
    temp20-start_at = `2018-07-07T10:00:00`.
    temp20-end_at = `2018-07-07T10:30:00`.
    temp20-aria = `Dialog`.
    temp20-tentative = abap_false.
    INSERT temp20 INTO TABLE temp19.
    temp20-title = `Private meeting`.
    temp20-text = ``.
    temp20-type = `Type03`.
    temp20-icon = ``.
    temp20-start_at = `2018-07-06T11:30:00`.
    temp20-end_at = `2018-07-06T12:00:00`.
    temp20-aria = `Dialog`.
    temp20-tentative = abap_false.
    INSERT temp20 INTO TABLE temp19.
    temp20-title = `Lunch`.
    temp20-text = ``.
    temp20-type = `Type05`.
    temp20-icon = ``.
    temp20-start_at = `2018-07-06T12:00:00`.
    temp20-end_at = `2018-07-06T13:00:00`.
    temp20-aria = `Dialog`.
    temp20-tentative = abap_false.
    INSERT temp20 INTO TABLE temp19.
    temp20-title = `Discussion of the plan`.
    temp20-text = ``.
    temp20-type = `Type01`.
    temp20-icon = ``.
    temp20-start_at = `2018-07-16T11:00:00`.
    temp20-end_at = `2018-07-16T12:00:00`.
    temp20-aria = `Dialog`.
    temp20-tentative = abap_false.
    INSERT temp20 INTO TABLE temp19.
    temp20-title = `Lunch`.
    temp20-text = `canteen`.
    temp20-type = `Type05`.
    temp20-icon = ``.
    temp20-start_at = `2018-07-16T12:00:00`.
    temp20-end_at = `2018-07-16T13:00:00`.
    temp20-aria = `Dialog`.
    temp20-tentative = abap_false.
    INSERT temp20 INTO TABLE temp19.
    temp20-title = `Team meeting`.
    temp20-text = `room 200`.
    temp20-type = `Type01`.
    temp20-icon = `sap-icon://meeting-room`.
    temp20-start_at = `2018-07-16T16:00:00`.
    temp20-end_at = `2018-07-16T17:00:00`.
    temp20-aria = `Dialog`.
    temp20-tentative = abap_false.
    INSERT temp20 INTO TABLE temp19.
    t_appointments = temp19.

  ENDMETHOD.

ENDCLASS.
