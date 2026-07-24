CLASS z2ui5_cl_ai_app_109 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_appointment,
             title      TYPE string,
             text       TYPE string,
             type       TYPE string,
             icon       TYPE string,
             start_date TYPE string,
             end_date   TYPE string,
           END OF ty_s_appointment.
    DATA t_appointments TYPE STANDARD TABLE OF ty_s_appointment WITH EMPTY KEY.
    DATA start_date TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_109 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " startDate + CalendarAppointment startDate/endDate are object-typed: the model
    " keeps ISO strings and Formatter.DateCreateObject converts them at the binding
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc`     v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core`    v = `sap.ui.core`
        )->a( n = `xmlns:unified` v = `sap.ui.unified`
        )->a( n = `xmlns`         v = `sap.m`
        )->a( n = `core:require`  v = `{Formatter: 'z2ui5/model/formatter'}`

        )->open( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->open( `OverflowToolbar`
                )->a( n = `height` v = `100%`
                )->a( n = `width`  v = `100%`

                )->leaf( `ToolbarSeparator`
                )->leaf( `Label`
                    )->a( n = `text` v = `Day selection mode : `
                )->open( `ToggleButton`
                    )->a( n = `id`      v = `MultiSelect`
                    )->a( n = `icon`    v = `sap-icon://select-appointments`
                    )->a( n = `tooltip` v = `Enable multi-day selection`
                    )->a( n = `press`   v = client->_event( `PRESS` )

                    )->open( `layoutData`
                        )->leaf( `OverflowToolbarLayoutData`
                            )->a( n = `priority` v = `NeverOverflow`

                )->shut(
                )->shut(
            )->shut(

            )->open( `SinglePlanningCalendar`
                )->a( n = `id`                  v = `SPC1`
                )->a( n = `class`               v = `sapUiSmallMarginTop`
                )->a( n = `title`               v = `My Calendar`
                )->a( n = `viewChange`          v = client->_event( `VIEW_CHANGE` )
                )->a( n = `selectedDatesChange` v = client->_event( `SELECTED_DATE` )
                )->a( n = `weekNumberPress`     v = client->_event( `WEEK` )
                )->a( n = `startDateChange`     v = client->_event( `START_DATE` )
                )->a( n = `startDate`           v = |\{ path: '{ client->_bind( val = start_date path = abap_true ) }', formatter: 'Formatter.DateCreateObject' \}|
                )->a( n = `appointments`        v = client->_bind( t_appointments )

                )->open( `views`
                    )->leaf( `SinglePlanningCalendarDayView`
                        )->a( n = `key`   v = `DayView`
                        )->a( n = `title` v = `Day`
                    )->leaf( `SinglePlanningCalendarWorkWeekView`
                        )->a( n = `key`   v = `WorkWeekView`
                        )->a( n = `title` v = `Work Week`
                    )->leaf( `SinglePlanningCalendarWeekView`
                        )->a( n = `key`   v = `WeekView`
                        )->a( n = `title` v = `Week`
                    )->leaf( `SinglePlanningCalendarMonthView`
                        )->a( n = `key`   v = `MonthView`
                        )->a( n = `title` v = `Month`

                )->shut(
                )->open( `appointments`
                    )->leaf( n = `CalendarAppointment` ns = `unified`
                        )->a( n = `title`     v = `{TITLE}`
                        )->a( n = `text`      v = `{TEXT}`
                        )->a( n = `type`      v = `{TYPE}`
                        )->a( n = `icon`      v = `{ICON}`
                        )->a( n = `startDate` v = `{ path: 'START_DATE', formatter: 'Formatter.DateCreateObject' }`
                        )->a( n = `endDate`   v = `{ path: 'END_DATE', formatter: 'Formatter.DateCreateObject' }` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `PRESS`.
        client->message_toast_display( `Day selection mode toggled` ).

      WHEN `VIEW_CHANGE`.
        client->message_toast_display( |'viewChange' event fired.| ).

      WHEN `SELECTED_DATE`.
        client->message_toast_display( |'selectedDatesChange' event fired.| ).

      WHEN `WEEK`.
        client->message_toast_display( |'weekNumberPress' event fired.| ).

      WHEN `START_DATE`.
        client->message_toast_display( |'startDateChange' event fired.| ).

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    start_date = `2018-07-09T00:00:00`.
    t_appointments = VALUE #(
      ( title = `Discussion of the plan` text = `` type = `Type01` icon = `` start_date = `2018-07-09T00:00:00` end_date = `2018-07-09T00:00:00` )
      ( title = `Meet John Miller` text = `` type = `Type05` icon = `` start_date = `2018-07-08T05:00:00` end_date = `2018-07-08T06:00:00` )
      ( title = `Lunch` text = `canteen` type = `Type05` icon = `` start_date = `2018-07-08T07:00:00` end_date = `2018-07-08T08:00:00` )
      ( title = `New Product` text = `room 105` type = `Type01` icon = `sap-icon://meeting-room` start_date = `2018-07-08T08:00:00` end_date = `2018-07-08T09:00:00` )
      ( title = `Discussion with clients for the new release dates` text = `Online meeting` type = `Type08` icon = `` start_date = `2018-07-09T09:00:00` end_date = `2018-07-09T10:00:00` )
      ( title = `Meeting with the manager` text = `` type = `Type03` icon = `` start_date = `2018-07-06T09:00:00` end_date = `2018-07-06T10:00:00` )
      ( title = `Daily standup meeting` text = `` type = `Type01` icon = `` start_date = `2018-07-07T10:00:00` end_date = `2018-07-07T10:30:00` )
      ( title = `Private meeting` text = `` type = `Type03` icon = `` start_date = `2018-07-06T11:30:00` end_date = `2018-07-06T12:00:00` )
      ( title = `Lunch` text = `` type = `Type05` icon = `` start_date = `2018-07-06T12:00:00` end_date = `2018-07-06T13:00:00` )
      ( title = `Discussion of the plan` text = `` type = `Type01` icon = `` start_date = `2018-07-16T11:00:00` end_date = `2018-07-16T12:00:00` )
      ( title = `Lunch` text = `canteen` type = `Type05` icon = `` start_date = `2018-07-16T12:00:00` end_date = `2018-07-16T13:00:00` ) ).

  ENDMETHOD.

ENDCLASS.
