" @keywords singleplanningcalendar single planning calendar sap.m singleplanningcalendarwithcustomviews vbox singleplanningcalendardayview singleplanningcalendarworkweekview singleplanningcalendarweekview calendarappointment
" @summary SinglePlanningCalendar showing the provided predefined views and custom views.
CLASS z2ui5_cl_smpc_app_552 DEFINITION PUBLIC.

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

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_552 IMPLEMENTATION.

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
        )->a( n = `xmlns:unified` v = `sap.ui.unified`
        )->a( n = `xmlns:core`    v = `sap.ui.core`
        )->a( n = `xmlns`         v = `sap.m`
        )->a( n = `core:require`  v = `{Formatter: 'z2ui5/model/formatter'}`

        )->ele( `VBox`

            )->ele( `SinglePlanningCalendar`
                )->a( n = `id`           v = `SPC1`
                )->a( n = `title`        v = `My Calendar`
                )->a( n = `startDate`    v = |\{ path: '{ client->_bind( val = start_date path = abap_true ) }', formatter: 'Formatter.DateCreateObject' \}|
                )->a( n = `appointments` v = client->_bind( t_appointments )

                " onInit adds five views: three built-in ones and two JS subclasses
                " of SinglePlanningCalendarView (3 Days and 10 Days). The two custom
                " classes cannot be registered from a backend, so only the three
                " built-in views are declared here (see sidecar)
                )->ele( `views`
                    )->tag( `SinglePlanningCalendarDayView`
                        )->a( n = `key`   v = `Day`
                        )->a( n = `title` v = `Day`
                    )->tag( `SinglePlanningCalendarWorkWeekView`
                        )->a( n = `key`   v = `WorkWeek`
                        )->a( n = `title` v = `Work Week`
                    )->tag( `SinglePlanningCalendarWeekView`
                        )->a( n = `key`   v = `Week`
                        )->a( n = `title` v = `Week`

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

    start_date = `2018-07-09T00:00:00`.

    t_appointments = VALUE #(
      ( title = `Meet John Miller` type = `Type05` start_at = `2018-07-08T05:00:00` end_at = `2018-07-08T06:00:00` )
      ( title = `Discussion of the plan` type = `Type08` start_at = `2018-07-08T06:00:00` end_at = `2018-07-08T07:09:00` )
      ( title = `Lunch` text = `canteen` type = `Type05` start_at = `2018-07-08T07:00:00` end_at = `2018-07-08T08:00:00` )
      ( title = `New Product` text = `room 105` type = `Type01` icon = `sap-icon://meeting-room` start_at = `2018-07-08T08:00:00` end_at = `2018-07-08T09:00:00` )
      ( title = `Team meeting` text = `Regular` type = `Type01` icon = `sap-icon://home` start_at = `2018-07-08T09:09:00` end_at = `2018-07-08T10:00:00` )
      ( title = `Discussion with clients` text = `Online meeting` type = `Type08` icon = `sap-icon://home` start_at = `2018-07-08T10:00:00` end_at = `2018-07-08T11:00:00` )
      ( title = `Discussion of the plan` text = `Online meeting` type = `Type08` icon = `sap-icon://home` start_at = `2018-07-08T11:00:00` end_at = `2018-07-08T12:00:00` tentative = abap_true )
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
      ( title = `Workshop` type = `Type01` start_at = `2018-07-11T08:30:00` end_at = `2018-07-11T12:00:00` )
      ( title = `Team collaboration` type = `Type01` start_at = `2018-07-12T04:00:00` end_at = `2018-07-12T12:30:00` )
      ( title = `Out of the office` type = `Type05` start_at = `2018-07-12T15:00:00` end_at = `2018-07-12T19:30:00` )
      ( title = `Working out of the building` type = `Type07` start_at = `2018-07-12T20:00:00` end_at = `2018-07-12T21:30:00` )
      ( title = `Reminder` type = `Type09` start_at = `2018-07-12T00:00:00` end_at = `2018-07-13T00:00:00` )
      ( title = `Team collaboration` type = `Type01` start_at = `2018-07-06T00:00:00` end_at = `2018-07-16T00:00:00` )
      ( title = `Workshop out of the country` type = `Type05` start_at = `2018-07-14T00:00:00` end_at = `2018-07-20T00:00:00` )
      ( title = `Payment reminder` type = `Type09` start_at = `2018-07-07T00:00:00` end_at = `2018-07-08T00:00:00` )
      ( title = `Meeting with the manager` type = `Type03` start_at = `2018-07-06T09:00:00` end_at = `2018-07-06T10:00:00` )
      ( title = `Daily standup meeting` type = `Type01` start_at = `2018-07-07T10:00:00` end_at = `2018-07-07T10:30:00` )
      ( title = `Private meeting` type = `Type03` start_at = `2018-07-06T11:30:00` end_at = `2018-07-06T12:00:00` )
      ( title = `Lunch` type = `Type05` start_at = `2018-07-06T12:00:00` end_at = `2018-07-06T13:00:00` )
      ( title = `Team meeting` text = `online` type = `Type01` start_at = `2018-07-16T08:00:00` end_at = `2018-07-16T09:00:00` )
      ( title = `Discussion of the plan` type = `Type08` start_at = `2018-07-16T11:00:00` end_at = `2018-07-16T12:00:00` )
      ( title = `Lunch` text = `canteen` type = `Type05` start_at = `2018-07-16T12:00:00` end_at = `2018-07-16T13:00:00` )
      ( title = `Team meeting` text = `room 200` type = `Type01` icon = `sap-icon://meeting-room` start_at = `2018-07-16T16:00:00` end_at = `2018-07-16T17:00:00` )
      ( title = `Working out of the building` type = `Type07` start_at = `2018-07-17T06:00:00` end_at = `2018-07-17T09:30:00` )
      ( title = `Team meeting` text = `room 5` type = `Type01` start_at = `2018-07-18T11:00:00` end_at = `2018-07-18T14:00:00` )
      ( title = `Discussion with clients` text = `Online meeting` type = `Type08` icon = `sap-icon://home` start_at = `2018-07-17T15:30:00` end_at = `2018-07-17T16:30:00` )
    ).

  ENDMETHOD.

ENDCLASS.
