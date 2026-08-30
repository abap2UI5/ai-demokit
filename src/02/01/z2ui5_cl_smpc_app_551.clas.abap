" @keywords singleplanningcalendar single planning calendar sap.m singleplanningcalendarsnappingheader vbox hbox label select listitem item
" @summary SinglePlanningCalendar showing the modes for snapping the header part of the calendar.
CLASS z2ui5_cl_smpc_app_551 DEFINITION PUBLIC.

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
    TYPES ty_t_appointment TYPE STANDARD TABLE OF ty_s_appointment WITH EMPTY KEY.

    DATA t_appointments TYPE ty_t_appointment.
    DATA start_date     TYPE string.
    DATA sticky_mode    TYPE string.
    DATA first_day      TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_551 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

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
                    " onChange calls setFirstDayOfWeek( Number( key ) ); the property
                    " is bindable, so the Select shares its key with the calendar
                    )->ele( `Select`
                        )->a( n = `selectedKey` v = client->_bind( first_day )

                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `-1`
                            )->a( n = `text` v = `Locale-based`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `1`
                            )->a( n = `text` v = `Monday`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `2`
                            )->a( n = `text` v = `Tuesday`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `3`
                            )->a( n = `text` v = `Wednesday`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `4`
                            )->a( n = `text` v = `Thursday`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `5`
                            )->a( n = `text` v = `Friday`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `6`
                            )->a( n = `text` v = `Saturday`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `0`
                            )->a( n = `text` v = `Sunday`

                    )->end(
                )->end(
            )->end(

            )->ele( `SinglePlanningCalendar`
                )->a( n = `id`                    v = `SPC1`
                )->a( n = `class`                 v = `sapUiSmallMarginTop`
                )->a( n = `title`                 v = `My Calendar`
                )->a( n = `startDate`             v = |\{ path: '{ client->_bind_path( start_date ) }', formatter: 'Formatter.DateCreateObject' \}|
                )->a( n = `stickyMode`            v = client->_bind( sticky_mode )
                " firstDayOfWeek is an INT property and the Select's key is a string,
                " so the expression multiplies by 1 - the Number( ) the original calls
                )->a( n = `firstDayOfWeek`        v = |\{= ${ client->_bind( first_day ) } * 1 \}|
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

    start_date  = `2018-07-09T00:00:00`.
    sticky_mode = `None`.
    first_day   = `-1`.

    t_appointments = VALUE #(
      ( title = `Meet John Miller` type = `Type05` start_at = `2018-07-08T05:00:00` end_at = `2018-07-08T06:00:00` )
      ( title = `Discussion of the plan` type = `Type01` start_at = `2018-07-08T06:00:00` end_at = `2018-07-08T07:09:00` )
      ( title = `Lunch` text = `canteen` type = `Type05` start_at = `2018-07-08T07:00:00` end_at = `2018-07-08T08:00:00` )
      ( title = `New Product` text = `room 105` type = `Type01` icon = `sap-icon://meeting-room` start_at = `2018-07-08T08:00:00` end_at = `2018-07-08T09:00:00` )
      ( title = `Team meeting` text = `Regular` type = `Type01` icon = `sap-icon://home` start_at = `2018-07-08T09:09:00` end_at = `2018-07-08T10:00:00` )
      ( title = `Discussion with clients` text = `Online meeting` type = `Type08` icon = `sap-icon://home` start_at = `2018-07-08T10:00:00` end_at = `2018-07-08T11:00:00` )
      ( title = `Discussion of the plan` text = `Online meeting` type = `Type01` icon = `sap-icon://home` start_at = `2018-07-08T11:00:00` end_at = `2018-07-08T12:00:00` tentative = abap_true )
      ( title = `Discussion with clients` type = `Type08` icon = `sap-icon://home` start_at = `2018-07-08T12:00:00` end_at = `2018-07-08T13:09:00` )
      ( title = `Meeting with the manager` type = `Type03` start_at = `2018-07-08T13:09:00` end_at = `2018-07-08T13:09:00` )
      ( title = `Meeting with the manager` type = `Type03` start_at = `2018-07-09T06:30:00` end_at = `2018-07-09T07:00:00` )
      ( title = `Lunch` type = `Type05` start_at = `2018-07-09T07:00:00` end_at = `2018-07-09T08:00:00` )
      ( title = `Team meeting` text = `online` type = `Type01` start_at = `2018-07-09T08:00:00` end_at = `2018-07-09T09:00:00` )
      ( title = `Discussion with clients` type = `Type08` start_at = `2018-07-09T09:00:00` end_at = `2018-07-09T10:00:00` )
      ( title = `Team meeting` text = `room 5` type = `Type01` start_at = `2018-07-09T11:00:00` end_at = `2018-07-09T14:00:00` )
      ( title = `Daily standup meeting` type = `Type01` start_at = `2018-07-09T09:00:00` end_at = `2018-07-09T09:15:00` )
      ( title = `Private meeting` type = `Type03` start_at = `2018-07-11T09:09:00` end_at = `2018-07-11T09:20:00` )
      ( title = `Private meeting` type = `Type03` start_at = `2018-07-10T06:00:00` end_at = `2018-07-10T07:00:00` )
      ( title = `Meeting with the manager` type = `Type03` start_at = `2018-07-10T15:00:00` end_at = `2018-07-10T15:30:00` )
      ( title = `Meet John Doe` type = `Type05` icon = `sap-icon://home` start_at = `2018-07-11T07:00:00` end_at = `2018-07-11T07:30:00` )
      ( title = `Team meeting` text = `online` type = `Type01` start_at = `2018-07-11T08:00:00` end_at = `2018-07-11T09:30:00` )
      ( title = `Workshop` type = `Type05` start_at = `2018-07-11T08:30:00` end_at = `2018-07-11T12:00:00` )
      ( title = `Team collaboration` type = `Type01` start_at = `2018-07-12T04:00:00` end_at = `2018-07-12T12:30:00` )
      ( title = `Out of the office` type = `Type05` start_at = `2018-07-12T15:00:00` end_at = `2018-07-12T19:30:00` )
      ( title = `Working out of the building` type = `Type05` start_at = `2018-07-12T20:00:00` end_at = `2018-07-12T21:30:00` )
      ( title = `Vacation` text = `out of office` type = `Type09` start_at = `2018-07-11T12:00:00` end_at = `2018-07-13T14:00:00` )
      ( title = `Reminder` type = `Type09` start_at = `2018-07-12T00:00:00` end_at = `2018-07-13T00:00:00` )
      ( title = `Team collaboration` type = `Type01` start_at = `2018-07-06T00:00:00` end_at = `2018-07-16T00:00:00` )
      ( title = `Workshop out of the country` type = `Type05` start_at = `2018-07-14T00:00:00` end_at = `2018-07-20T00:00:00` )
      ( title = `Payment reminder` type = `Type09` start_at = `2018-07-07T00:00:00` end_at = `2018-07-08T00:00:00` )
      ( title = `Meeting with the manager` type = `Type03` start_at = `2018-07-06T09:00:00` end_at = `2018-07-06T10:00:00` )
      ( title = `Daily standup meeting` type = `Type01` start_at = `2018-07-07T10:00:00` end_at = `2018-07-07T10:30:00` )
      ( title = `Private meeting` type = `Type03` start_at = `2018-07-06T11:30:00` end_at = `2018-07-06T12:00:00` )
      ( title = `Lunch` type = `Type05` start_at = `2018-07-06T12:00:00` end_at = `2018-07-06T13:00:00` )
      ( title = `Discussion of the plan` type = `Type01` start_at = `2018-07-16T11:00:00` end_at = `2018-07-16T12:00:00` )
      ( title = `Lunch` text = `canteen` type = `Type05` start_at = `2018-07-16T12:00:00` end_at = `2018-07-16T13:00:00` )
      ( title = `Team meeting` text = `room 200` type = `Type01` icon = `sap-icon://meeting-room` start_at = `2018-07-16T16:00:00` end_at = `2018-07-16T17:00:00` )
      ( title = `Discussion with clients` text = `Online meeting` type = `Type08` icon = `sap-icon://home` start_at = `2018-07-17T15:30:00` end_at = `2018-07-17T16:30:00` )
    ).

  ENDMETHOD.

ENDCLASS.
