" @keywords singleplanningcalendar single planning calendar sap.m day selection vbox overflowtoolbar toolbarseparator label togglebutton
" @summary SinglePlanningCalendar with multiple date selection functionality.
CLASS z2ui5_cl_smpc_app_109 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    " onPress flips the calendar's dateSelectionMode and swaps the button's
    " tooltip - both are bindable properties, so they are held here and bound
    " two-way rather than driven through a frontend action
    DATA date_selection_mode TYPE string.
    DATA multiselect_tooltip TYPE string.

    TYPES: BEGIN OF ty_s_appointment,
             title      TYPE string,
             text       TYPE string,
             type       TYPE string,
             icon       TYPE string,
             start_date TYPE string,
             end_date   TYPE string,
           END OF ty_s_appointment.
    DATA t_appointments TYPE STANDARD TABLE OF ty_s_appointment WITH DEFAULT KEY.
    DATA start_date TYPE string.

  PROTECTED SECTION.
    " one entry per DateRange the frontend marshalled out of the event's
    " selectedDates parameter - startDate arrives as an ISO LOCAL timestamp
    " (no Z), so its first ten characters are the day the user picked
    TYPES: BEGIN OF ty_s_event_range,
             startdate TYPE string,
           END OF ty_s_event_range.
    TYPES ty_t_event_range TYPE STANDARD TABLE OF ty_s_event_range WITH DEFAULT KEY.

    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS event_ranges
      IMPORTING
        val           TYPE string
      RETURNING
        VALUE(result) TYPE ty_t_event_range.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_109 IMPLEMENTATION.

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
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " startDate + CalendarAppointment startDate/endDate are object-typed: the model
    " keeps ISO strings and Formatter.DateCreateObject converts them at the binding
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc`     v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core`    v = `sap.ui.core`
        )->a( n = `xmlns:unified` v = `sap.ui.unified`
        )->a( n = `xmlns`         v = `sap.m`
        )->a( n = `core:require`  v = `{Formatter: 'z2ui5/model/formatter'}`

        )->ele( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->ele( `OverflowToolbar`
                )->a( n = `height` v = `100%`
                )->a( n = `width`  v = `100%`

                )->tag( `ToolbarSeparator`
                )->tag( `Label`
                    )->a( n = `text` v = `Day selection mode : `
                )->ele( `ToggleButton`
                    )->a( n = `id`      v = `MultiSelect`
                    )->a( n = `icon`    v = `sap-icon://select-appointments`
                    )->a( n = `tooltip` v = client->_bind( multiselect_tooltip )
                    )->a( n = `press`   v = client->_event( `PRESS` )

                    )->ele( `layoutData`
                        )->tag( `OverflowToolbarLayoutData`
                            )->a( n = `priority` v = `NeverOverflow`

                    )->end(
                )->end(
            )->end(

            )->ele( `SinglePlanningCalendar`
                )->a( n = `id`                  v = `SPC1`
                )->a( n = `class`               v = `sapUiSmallMarginTop`
                )->a( n = `title`               v = `My Calendar`
                )->a( n = `dateSelectionMode`   v = client->_bind( date_selection_mode )
                )->a( n = `viewChange`          v = client->_event( `VIEW_CHANGE` )
                " the WHOLE selectedDates parameter travels in one arg: the
                " frontend marshals each DateRange into its public properties
                " (Lib.normalizeEventArgs), which is the loop the client
                " expression grammar does not have
                )->a( n = `selectedDatesChange` v = client->_event( val = `SELECTED_DATE` arg = `${$parameters>/selectedDates}` )
                )->a( n = `weekNumberPress`     v = client->_event( val = `WEEK` arg = `${$parameters>/weekNumber}` )
                )->a( n = `startDateChange`     v = client->_event( val = `START_DATE` arg = `${$parameters>/date}` )
                )->a( n = `startDate`           v = |\{ path: '{ client->_bind_path( start_date ) }', formatter: 'Formatter.DateCreateObject' \}|
                )->a( n = `appointments`        v = client->_bind( t_appointments )

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
                    )->tag( `SinglePlanningCalendarMonthView`
                        )->a( n = `key`   v = `MonthView`
                        )->a( n = `title` v = `Month`

                )->end(
                )->ele( `appointments`
                    )->tag( n = `CalendarAppointment` ns = `unified`
                        )->a( n = `title`     v = `{TITLE}`
                        )->a( n = `text`      v = `{TEXT}`
                        )->a( n = `type`      v = `{TYPE}`
                        )->a( n = `icon`      v = `{ICON}`
                        )->a( n = `startDate` v = `{ path: 'START_DATE', formatter: 'Formatter.DateCreateObject' }`
                        )->a( n = `endDate`   v = `{ path: 'END_DATE', formatter: 'Formatter.DateCreateObject' }` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA output TYPE string.
        DATA ranges TYPE z2ui5_cl_smpc_app_109=>ty_t_event_range.
        DATA temp1 LIKE LINE OF ranges.
        DATA lr_range LIKE REF TO temp1.

    CASE client->get_event( ).

      WHEN `PRESS`.
        " onPress: SingleSelect <-> MultiSelect, and the tooltip follows the
        " pressed state exactly as the original's setTooltip does
        IF date_selection_mode = `SingleSelect`.
          date_selection_mode = `MultiSelect`.
          multiselect_tooltip = `Disable multi-day selection`.
        ELSE.
          date_selection_mode = `SingleSelect`.
          multiselect_tooltip = `Enable multi-day selection`.
        ENDIF.

      WHEN `VIEW_CHANGE`.
        client->message_toast_display( |'viewChange' event fired.| ).

      WHEN `SELECTED_DATE`.
        " handleSelectedDateChange numbers every selected range and appends its
        " start date, one per line - the array arrives marshalled, so the loop
        " the original writes in JavaScript is an ABAP loop here
        
        output = ``.
        
        ranges = event_ranges( client->get_event_arg( ) ).
        
        
        LOOP AT ranges REFERENCE INTO lr_range.
          IF strlen( lr_range->startdate ) < 10.
            CONTINUE.
          ENDIF.
          output = |{ output }{ sy-tabix }: { lr_range->startdate(10) }\n|.
        ENDLOOP.
        client->message_toast_display( |'selectedDatesChange' event fired.\n\nNew selected dates: \n{ output }| ).

      WHEN `WEEK`.
        " the original appends the pressed week number, which the event carries
        client->message_toast_display( |'weekNumberPress' event fired.\n\nweek number is { client->get_event_arg( ) }| ).

      WHEN `START_DATE`.
        " same for the new start date (the event parameter, not a control ref)
        client->message_toast_display( |'startDateChange' event fired.\n\nNew start date is { client->get_event_arg( ) }| ).

    ENDCASE.

  ENDMETHOD.


  METHOD event_ranges.

    DATA lv_json TYPE string.
    lv_json = condense( val ).
    IF lv_json IS INITIAL.
      RETURN.
    ENDIF.

    IF lv_json(1) <> `[`.
      lv_json = |[{ lv_json }]|.
    ENDIF.

    TRY.
        " a marshalled DateRange carries ALL its public properties (ID,
        " startDate, endDate), so only the one field this port models is
        " mapped - a plain to_abap( ) fails on the first extra one
        "
        " z2ui5_cl_ajson is the framework's VENDORED ajson copy and lives
        " outside the released API (src/02), so it may be renamed or
        " restructured without notice - the linter says so, and it is right.
        " There is no released JSON reader to use instead, the same reasoning
        " as apps 103 and 298; declared as a deviation in the sidecar
        " abap2ui5lint-disable-next-line non-released-api -- no released JSON reader exists; see the comment above and the sidecar deviation
        z2ui5_cl_ajson=>parse( lv_json
          )->to_abap_corresponding_only(
          )->to_abap( IMPORTING ev_container = result ).
        " abap2ui5lint-disable-next-line non-released-api -- the exception of the call above
      CATCH z2ui5_cx_ajson_error.
        CLEAR result.
    ENDTRY.

  ENDMETHOD.


  METHOD model_init.
    DATA temp2 LIKE t_appointments.
    DATA temp3 LIKE LINE OF temp2.

    " the calendar opens in single-day selection, and the button offers to
    " enable the multi-day one - the original's view defaults
    date_selection_mode = `SingleSelect`.
    multiselect_tooltip = `Enable multi-day selection`.

    start_date = `2018-07-09T00:00:00`.
    
    CLEAR temp2.
    
    temp3-title = `Discussion of the plan`.
    temp3-text = ``.
    temp3-type = `Type01`.
    temp3-icon = ``.
    temp3-start_date = `2018-07-09T00:00:00`.
    temp3-end_date = `2018-07-09T00:00:00`.
    INSERT temp3 INTO TABLE temp2.
    temp3-title = `Meet John Miller`.
    temp3-text = ``.
    temp3-type = `Type05`.
    temp3-icon = ``.
    temp3-start_date = `2018-07-08T05:00:00`.
    temp3-end_date = `2018-07-08T06:00:00`.
    INSERT temp3 INTO TABLE temp2.
    temp3-title = `Lunch`.
    temp3-text = `canteen`.
    temp3-type = `Type05`.
    temp3-icon = ``.
    temp3-start_date = `2018-07-08T07:00:00`.
    temp3-end_date = `2018-07-08T08:00:00`.
    INSERT temp3 INTO TABLE temp2.
    temp3-title = `New Product`.
    temp3-text = `room 105`.
    temp3-type = `Type01`.
    temp3-icon = `sap-icon://meeting-room`.
    temp3-start_date = `2018-07-08T08:00:00`.
    temp3-end_date = `2018-07-08T09:00:00`.
    INSERT temp3 INTO TABLE temp2.
    temp3-title = `Discussion with clients for the new release dates`.
    temp3-text = `Online meeting`.
    temp3-type = `Type08`.
    temp3-icon = ``.
    temp3-start_date = `2018-07-09T09:00:00`.
    temp3-end_date = `2018-07-09T10:00:00`.
    INSERT temp3 INTO TABLE temp2.
    temp3-title = `Meeting with the manager`.
    temp3-text = ``.
    temp3-type = `Type03`.
    temp3-icon = ``.
    temp3-start_date = `2018-07-06T09:00:00`.
    temp3-end_date = `2018-07-06T10:00:00`.
    INSERT temp3 INTO TABLE temp2.
    temp3-title = `Daily standup meeting`.
    temp3-text = ``.
    temp3-type = `Type01`.
    temp3-icon = ``.
    temp3-start_date = `2018-07-07T10:00:00`.
    temp3-end_date = `2018-07-07T10:30:00`.
    INSERT temp3 INTO TABLE temp2.
    temp3-title = `Private meeting`.
    temp3-text = ``.
    temp3-type = `Type03`.
    temp3-icon = ``.
    temp3-start_date = `2018-07-06T11:30:00`.
    temp3-end_date = `2018-07-06T12:00:00`.
    INSERT temp3 INTO TABLE temp2.
    temp3-title = `Lunch`.
    temp3-text = ``.
    temp3-type = `Type05`.
    temp3-icon = ``.
    temp3-start_date = `2018-07-06T12:00:00`.
    temp3-end_date = `2018-07-06T13:00:00`.
    INSERT temp3 INTO TABLE temp2.
    temp3-title = `Discussion of the plan`.
    temp3-text = ``.
    temp3-type = `Type01`.
    temp3-icon = ``.
    temp3-start_date = `2018-07-16T11:00:00`.
    temp3-end_date = `2018-07-16T12:00:00`.
    INSERT temp3 INTO TABLE temp2.
    temp3-title = `Lunch`.
    temp3-text = `canteen`.
    temp3-type = `Type05`.
    temp3-icon = ``.
    temp3-start_date = `2018-07-16T12:00:00`.
    temp3-end_date = `2018-07-16T13:00:00`.
    INSERT temp3 INTO TABLE temp2.
    t_appointments = temp2.

  ENDMETHOD.

ENDCLASS.
