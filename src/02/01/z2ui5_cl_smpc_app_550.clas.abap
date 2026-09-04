" @keywords singleplanningcalendar single planning calendar sap.m singleplanningcalendarweeknumbering vbox hbox label select listitem item
" @summary This sample demonstrates how the SinglePlanningCalendar control can be used width different week numbering (only Week and Month views are affected)
CLASS z2ui5_cl_smpc_app_550 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_appointment,
             title     TYPE string,
             text      TYPE string,
             type      TYPE string,
             icon      TYPE string,
             start_at  TYPE string,
             end_at    TYPE string,
             tentative TYPE abap_bool,
           END OF ty_s_appointment.
    TYPES ty_t_appointment TYPE STANDARD TABLE OF ty_s_appointment WITH DEFAULT KEY.

    DATA t_appointments TYPE ty_t_appointment.
    DATA start_date     TYPE string.
    DATA sticky_mode    TYPE string.
    DATA week_number    TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_550 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " the calendar date properties are typed "object" and demand a real JS Date;
    " the model keeps ISO strings and Formatter.DateCreateObject converts them
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc`     v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core`    v = `sap.ui.core`
        )->a( n = `xmlns:unified` v = `sap.ui.unified`
        )->a( n = `xmlns`         v = `sap.m`
        )->a( n = `core:require`  v = `{Formatter: 'z2ui5/model/formatter'}`

        )->ele( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->ele( `HBox`

                )->ele( `VBox`
                    )->a( n = `class` v = `sapUiSmallMarginEnd`

                    )->tag( `Label`
                        )->a( n = `text`     v = `Select sticky mode`
                        )->a( n = `labelFor` v = `stickyModeSelect`
                    " the original keeps the sticky mode in a second named model;
                    " abap2UI5 keeps one default model, so it is a field here
                    )->ele( `Select`
                        )->a( n = `id`          v = `stickyModeSelect`
                        )->a( n = `selectedKey` v = client->_bind( sticky_mode )

                        )->tag( n = `ListItem` ns = `core`
                            )->a( n = `text` v = `None`
                            )->a( n = `key`  v = `None`
                        )->tag( n = `ListItem` ns = `core`
                            )->a( n = `text` v = `All`
                            )->a( n = `key`  v = `All`
                        )->tag( n = `ListItem` ns = `core`
                            )->a( n = `text` v = `NavBarAndColHeaders`
                            )->a( n = `key`  v = `NavBarAndColHeaders`

                    )->end(
                )->end(

                )->ele( `VBox`
                    )->a( n = `width` v = `180px`

                    )->tag( `Label`
                        )->a( n = `text` v = `Choose first day of week:`
                    " onChange calls setCalendarWeekNumbering; the property is
                    " bindable, so the Select shares its key with the calendar
                    )->ele( `Select`
                        )->a( n = `selectedKey` v = client->_bind( week_number )

                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `Default`
                            )->a( n = `text` v = `Default`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `ISO_8601`
                            )->a( n = `text` v = `ISO_8601`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `MiddleEastern`
                            )->a( n = `text` v = `Middle Eastern`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `WesternTraditional`
                            )->a( n = `text` v = `Western Traditional`

                    )->end(
                )->end(
            )->end(

            )->ele( `SinglePlanningCalendar`
                )->a( n = `id`                    v = `SPC1`
                )->a( n = `class`                 v = `sapUiSmallMarginTop`
                )->a( n = `title`                 v = `My Calendar`
                )->a( n = `startDate`             v = |\{ path: '{ client->_bind_path( start_date ) }', formatter: 'Formatter.DateCreateObject' \}|
                )->a( n = `stickyMode`            v = client->_bind( sticky_mode )
                )->a( n = `calendarWeekNumbering` v = client->_bind( week_number )
                )->a( n = `appointments`          v = client->_bind( t_appointments )

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
                        )->a( n = `startDate` v = `{ path: 'START_AT', formatter: 'Formatter.DateCreateObject' }`
                        )->a( n = `endDate`   v = `{ path: 'END_AT', formatter: 'Formatter.DateCreateObject' }` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.
    DATA temp1 TYPE z2ui5_cl_smpc_app_550=>ty_t_appointment.
    DATA temp2 LIKE LINE OF temp1.

    start_date  = `2018-07-09T00:00:00`.
    sticky_mode = `None`.
    week_number = `Default`.

    
    CLEAR temp1.
    
    temp2-title = `Meet John Miller`.
    temp2-type = `Type05`.
    temp2-start_at = `2018-07-08T05:00:00`.
    temp2-end_at = `2018-07-08T06:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Discussion of the plan`.
    temp2-type = `Type01`.
    temp2-start_at = `2018-07-08T06:00:00`.
    temp2-end_at = `2018-07-08T07:09:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Lunch`.
    temp2-text = `canteen`.
    temp2-type = `Type05`.
    temp2-start_at = `2018-07-08T07:00:00`.
    temp2-end_at = `2018-07-08T08:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `New Product`.
    temp2-text = `room 105`.
    temp2-type = `Type01`.
    temp2-icon = `sap-icon://meeting-room`.
    temp2-start_at = `2018-07-08T08:00:00`.
    temp2-end_at = `2018-07-08T09:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Team meeting`.
    temp2-text = `Regular`.
    temp2-type = `Type01`.
    temp2-icon = `sap-icon://home`.
    temp2-start_at = `2018-07-08T09:09:00`.
    temp2-end_at = `2018-07-08T10:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Discussion with clients`.
    temp2-text = `Online meeting`.
    temp2-type = `Type08`.
    temp2-icon = `sap-icon://home`.
    temp2-start_at = `2018-07-08T10:00:00`.
    temp2-end_at = `2018-07-08T11:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Discussion of the plan`.
    temp2-text = `Online meeting`.
    temp2-type = `Type01`.
    temp2-icon = `sap-icon://home`.
    temp2-start_at = `2018-07-08T11:00:00`.
    temp2-end_at = `2018-07-08T12:00:00`.
    temp2-tentative = abap_true.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Discussion with clients`.
    temp2-type = `Type08`.
    temp2-icon = `sap-icon://home`.
    temp2-start_at = `2018-07-08T12:00:00`.
    temp2-end_at = `2018-07-08T13:09:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Meeting with the manager`.
    temp2-type = `Type03`.
    temp2-start_at = `2018-07-08T13:09:00`.
    temp2-end_at = `2018-07-08T13:09:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Meeting with the manager`.
    temp2-type = `Type03`.
    temp2-start_at = `2018-07-09T06:30:00`.
    temp2-end_at = `2018-07-09T07:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Lunch`.
    temp2-type = `Type05`.
    temp2-start_at = `2018-07-09T07:00:00`.
    temp2-end_at = `2018-07-09T08:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Team meeting`.
    temp2-text = `online`.
    temp2-type = `Type01`.
    temp2-start_at = `2018-07-09T08:00:00`.
    temp2-end_at = `2018-07-09T09:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Discussion with clients`.
    temp2-type = `Type08`.
    temp2-start_at = `2018-07-09T09:00:00`.
    temp2-end_at = `2018-07-09T10:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Team meeting`.
    temp2-text = `room 5`.
    temp2-type = `Type01`.
    temp2-start_at = `2018-07-09T11:00:00`.
    temp2-end_at = `2018-07-09T14:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Daily standup meeting`.
    temp2-type = `Type01`.
    temp2-start_at = `2018-07-09T09:00:00`.
    temp2-end_at = `2018-07-09T09:15:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Private meeting`.
    temp2-type = `Type03`.
    temp2-start_at = `2018-07-11T09:09:00`.
    temp2-end_at = `2018-07-11T09:20:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Private meeting`.
    temp2-type = `Type03`.
    temp2-start_at = `2018-07-10T06:00:00`.
    temp2-end_at = `2018-07-10T07:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Meeting with the manager`.
    temp2-type = `Type03`.
    temp2-start_at = `2018-07-10T15:00:00`.
    temp2-end_at = `2018-07-10T15:30:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Meet John Doe`.
    temp2-type = `Type05`.
    temp2-icon = `sap-icon://home`.
    temp2-start_at = `2018-07-11T07:00:00`.
    temp2-end_at = `2018-07-11T07:30:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Team meeting`.
    temp2-text = `online`.
    temp2-type = `Type01`.
    temp2-start_at = `2018-07-11T08:00:00`.
    temp2-end_at = `2018-07-11T09:30:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Workshop`.
    temp2-type = `Type05`.
    temp2-start_at = `2018-07-11T08:30:00`.
    temp2-end_at = `2018-07-11T12:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Team collaboration`.
    temp2-type = `Type01`.
    temp2-start_at = `2018-07-12T04:00:00`.
    temp2-end_at = `2018-07-12T12:30:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Out of the office`.
    temp2-type = `Type05`.
    temp2-start_at = `2018-07-12T15:00:00`.
    temp2-end_at = `2018-07-12T19:30:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Working out of the building`.
    temp2-type = `Type05`.
    temp2-start_at = `2018-07-12T20:00:00`.
    temp2-end_at = `2018-07-12T21:30:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Vacation`.
    temp2-text = `out of office`.
    temp2-type = `Type09`.
    temp2-start_at = `2018-07-11T12:00:00`.
    temp2-end_at = `2018-07-13T14:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Reminder`.
    temp2-type = `Type09`.
    temp2-start_at = `2018-07-12T00:00:00`.
    temp2-end_at = `2018-07-13T00:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Team collaboration`.
    temp2-type = `Type01`.
    temp2-start_at = `2018-07-06T00:00:00`.
    temp2-end_at = `2018-07-16T00:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Workshop out of the country`.
    temp2-type = `Type05`.
    temp2-start_at = `2018-07-14T00:00:00`.
    temp2-end_at = `2018-07-20T00:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Payment reminder`.
    temp2-type = `Type09`.
    temp2-start_at = `2018-07-07T00:00:00`.
    temp2-end_at = `2018-07-08T00:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Meeting with the manager`.
    temp2-type = `Type03`.
    temp2-start_at = `2018-07-06T09:00:00`.
    temp2-end_at = `2018-07-06T10:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Daily standup meeting`.
    temp2-type = `Type01`.
    temp2-start_at = `2018-07-07T10:00:00`.
    temp2-end_at = `2018-07-07T10:30:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Private meeting`.
    temp2-type = `Type03`.
    temp2-start_at = `2018-07-06T11:30:00`.
    temp2-end_at = `2018-07-06T12:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Lunch`.
    temp2-type = `Type05`.
    temp2-start_at = `2018-07-06T12:00:00`.
    temp2-end_at = `2018-07-06T13:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Discussion of the plan`.
    temp2-type = `Type01`.
    temp2-start_at = `2018-07-16T11:00:00`.
    temp2-end_at = `2018-07-16T12:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Lunch`.
    temp2-text = `canteen`.
    temp2-type = `Type05`.
    temp2-start_at = `2018-07-16T12:00:00`.
    temp2-end_at = `2018-07-16T13:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Team meeting`.
    temp2-text = `room 200`.
    temp2-type = `Type01`.
    temp2-icon = `sap-icon://meeting-room`.
    temp2-start_at = `2018-07-16T16:00:00`.
    temp2-end_at = `2018-07-16T17:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Discussion with clients`.
    temp2-text = `Online meeting`.
    temp2-type = `Type08`.
    temp2-icon = `sap-icon://home`.
    temp2-start_at = `2018-07-17T15:30:00`.
    temp2-end_at = `2018-07-17T16:30:00`.
    INSERT temp2 INTO TABLE temp1.
    t_appointments = temp1.

  ENDMETHOD.

ENDCLASS.
