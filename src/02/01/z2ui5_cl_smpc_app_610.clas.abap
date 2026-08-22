" @keywords singleplanningcalendar single planning calendar sap.m singleplanningcalendardnd vbox hbox label switch singleplanningcalendardayview singleplanningcalendarworkweekview
" @summary SinglePlanningCalendar with enabled drag and drop functionality, allowing to create appointments with dragging and dropping, to change the start and end date of appointments by selecting and dragging their top or bottom end, and to copy and...
CLASS z2ui5_cl_smpc_app_610 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_appointment,
             title    TYPE string,
             text     TYPE string,
             type     TYPE string,
             icon     TYPE string,
             start_at TYPE string,
             end_at   TYPE string,
           END OF ty_s_appointment.
    TYPES ty_t_appointment TYPE STANDARD TABLE OF ty_s_appointment WITH EMPTY KEY.

    DATA t_appointments TYPE ty_t_appointment.
    DATA start_date     TYPE string.

    " the original keeps these three in a settings> model; abap2UI5 keeps one
    " default model, so they are fields the Switches and the calendar share
    DATA enable_dnd    TYPE abap_bool VALUE abap_true.
    DATA enable_resize TYPE abap_bool VALUE abap_true.
    DATA enable_create TYPE abap_bool VALUE abap_true.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS appointment_drop.
    METHODS appointment_resize.
    METHODS appointment_create.
    METHODS iso_of
      IMPORTING first         TYPE i
      RETURNING VALUE(result) TYPE string.
    METHODS index_of
      IMPORTING path          TYPE string
      RETURNING VALUE(result) TYPE i.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_610 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " the calendar date properties are typed "object" and demand a real JS Date;
    " the model keeps ISO strings and Formatter.DateCreateObject converts them.
    " The drag, resize and create wires carry the interval's LOCAL date parts
    " (a UTC toISOString( ) would shift the day) - app 549 idiom
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`         v = `sap.m`
        )->a( n = `xmlns:core`    v = `sap.ui.core`
        )->a( n = `xmlns:mvc`     v = `sap.ui.core.mvc`
        )->a( n = `xmlns:unified` v = `sap.ui.unified`
        )->a( n = `core:require`  v = `{Formatter: 'z2ui5/model/formatter'}`

        )->ele( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->ele( `HBox`
                )->a( n = `wrap` v = `Wrap`

                )->ele( `VBox`
                    )->a( n = `class` v = `sapUiSmallMarginEnd`
                    )->tag( `Label`
                        )->a( n = `text`     v = `Drag and Drop`
                        )->a( n = `labelFor` v = `enableAppointmentsDragAndDrop`
                    )->tag( `Switch`
                        )->a( n = `id`    v = `enableAppointmentsDragAndDrop`
                        )->a( n = `state` v = client->_bind( enable_dnd )
                )->end(

                )->ele( `VBox`
                    )->a( n = `class` v = `sapUiSmallMarginEnd`
                    )->tag( `Label`
                        )->a( n = `text`     v = `Resize Appointments`
                        )->a( n = `labelFor` v = `enableAppointmentsResize`
                    )->tag( `Switch`
                        )->a( n = `id`    v = `enableAppointmentsResize`
                        )->a( n = `state` v = client->_bind( enable_resize )
                )->end(

                )->ele( `VBox`
                    )->tag( `Label`
                        )->a( n = `text`     v = `Create Appointments`
                        )->a( n = `labelFor` v = `enableAppointmentsCreate`
                    )->tag( `Switch`
                        )->a( n = `id`    v = `enableAppointmentsCreate`
                        )->a( n = `state` v = client->_bind( enable_create )
                )->end(
            )->end(

            )->ele( `SinglePlanningCalendar`
                )->a( n = `id`                            v = `SPC1`
                )->a( n = `class`                         v = `sapUiSmallMarginTop`
                )->a( n = `title`                         v = `My Calendar`
                )->a( n = `enableAppointmentsDragAndDrop` v = client->_bind( enable_dnd )
                )->a( n = `enableAppointmentsResize`      v = client->_bind( enable_resize )
                )->a( n = `enableAppointmentsCreate`      v = client->_bind( enable_create )
                )->a( n = `appointments`                  v = client->_bind( t_appointments )
                )->a( n = `startDate`                     v = |\{ path: '{ client->_bind( val = start_date path = abap_true ) }', formatter: 'Formatter.DateCreateObject' \}|

                )->a( n = `appointmentDrop`               v = client->_event(
                          val   = `APPT_DROP`
                          t_arg = VALUE #(
                            ( `${$parameters>/startDate}.getFullYear()` )
                            ( `${$parameters>/startDate}.getMonth() + 1` )
                            ( `${$parameters>/startDate}.getDate()` )
                            ( `${$parameters>/startDate}.getHours()` )
                            ( `${$parameters>/startDate}.getMinutes()` )
                            ( `${$parameters>/endDate}.getFullYear()` )
                            ( `${$parameters>/endDate}.getMonth() + 1` )
                            ( `${$parameters>/endDate}.getDate()` )
                            ( `${$parameters>/endDate}.getHours()` )
                            ( `${$parameters>/endDate}.getMinutes()` )
                            ( `${$parameters>/appointment}.getBindingContext().getPath()` )
                            ( `${$parameters>/copy} ? 'X' : ''` ) ) )

                )->a( n = `appointmentResize`             v = client->_event(
                          val   = `APPT_RESIZE`
                          t_arg = VALUE #(
                            ( `${$parameters>/startDate}.getFullYear()` )
                            ( `${$parameters>/startDate}.getMonth() + 1` )
                            ( `${$parameters>/startDate}.getDate()` )
                            ( `${$parameters>/startDate}.getHours()` )
                            ( `${$parameters>/startDate}.getMinutes()` )
                            ( `${$parameters>/endDate}.getFullYear()` )
                            ( `${$parameters>/endDate}.getMonth() + 1` )
                            ( `${$parameters>/endDate}.getDate()` )
                            ( `${$parameters>/endDate}.getHours()` )
                            ( `${$parameters>/endDate}.getMinutes()` )
                            ( `${$parameters>/appointment}.getBindingContext().getPath()` ) ) )

                )->a( n = `appointmentCreate`             v = client->_event(
                          val   = `APPT_CREATE_DND`
                          t_arg = VALUE #(
                            ( `${$parameters>/startDate}.getFullYear()` )
                            ( `${$parameters>/startDate}.getMonth() + 1` )
                            ( `${$parameters>/startDate}.getDate()` )
                            ( `${$parameters>/startDate}.getHours()` )
                            ( `${$parameters>/startDate}.getMinutes()` )
                            ( `${$parameters>/endDate}.getFullYear()` )
                            ( `${$parameters>/endDate}.getMonth() + 1` )
                            ( `${$parameters>/endDate}.getDate()` )
                            ( `${$parameters>/endDate}.getHours()` )
                            ( `${$parameters>/endDate}.getMinutes()` ) ) )

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
                        )->a( n = `title`     v = `{TITLE}`
                        )->a( n = `text`      v = `{TEXT}`
                        )->a( n = `type`      v = `{TYPE}`
                        )->a( n = `icon`      v = `{ICON}`
                        )->a( n = `startDate` v = `{ path: 'START_AT', formatter: 'Formatter.DateCreateObject' }`
                        )->a( n = `endDate`   v = `{ path: 'END_AT', formatter: 'Formatter.DateCreateObject' }`
                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).
      WHEN `APPT_DROP`.
        appointment_drop( ).
      WHEN `APPT_RESIZE`.
        appointment_resize( ).
      WHEN `APPT_CREATE_DND`.
        appointment_create( ).
    ENDCASE.

  ENDMETHOD.


  METHOD appointment_drop.

    " handleAppointmentDrop: a copy drag pushes a NEW row with the dragged
    " appointment's own title, icon, text and type; a move rewrites the two dates
    DATA(index)   = index_of( client->get_event_arg( 11 ) ).
    DATA(is_copy) = xsdbool( client->get_event_arg( 12 ) = `X` ).

    IF index < 1 OR index > lines( t_appointments ).
      RETURN.
    ENDIF.

    DATA(moved) = t_appointments[ index ].
    DATA(title) = moved-title.
    moved-start_at = iso_of( 1 ).
    moved-end_at   = iso_of( 6 ).

    IF is_copy = abap_true.
      INSERT moved INTO TABLE t_appointments.
    ELSE.
      t_appointments[ index ] = moved.
    ENDIF.

    client->message_toast_display(
        |Appointment with title \n'{ title }'\n has been { COND string( WHEN is_copy = abap_true THEN `create` ELSE `moved` ) }| ).

  ENDMETHOD.


  METHOD appointment_resize.

    " handleAppointmentResize: the two dates move, nothing else
    DATA(index) = index_of( client->get_event_arg( 11 ) ).

    IF index < 1 OR index > lines( t_appointments ).
      RETURN.
    ENDIF.

    DATA(resized) = t_appointments[ index ].
    resized-start_at = iso_of( 1 ).
    resized-end_at   = iso_of( 6 ).
    t_appointments[ index ] = resized.

    client->message_toast_display( |Appointment with title \n'{ resized-title }'\n has been resized| ).

  ENDMETHOD.


  METHOD appointment_create.

    " handleAppointmentCreateDnD pushes a bare 'New Appointment' over the
    " dragged interval - no text, no type, no icon
    INSERT VALUE #( title    = `New Appointment`
                    start_at = iso_of( 1 )
                    end_at   = iso_of( 6 ) ) INTO TABLE t_appointments.

    client->message_toast_display( |Appointment with title \n'New Appointment'\n has been created| ).

  ENDMETHOD.


  METHOD iso_of.

    " five consecutive event arguments (year, month, day, hour, minute) as one
    " ISO string - the parts travel LOCAL, so no timezone shifts the day
    result = |{ client->get_event_arg( first ) }| &&
             |-{ CONV i( client->get_event_arg( first + 1 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
             |-{ CONV i( client->get_event_arg( first + 2 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
             |T{ CONV i( client->get_event_arg( first + 3 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
             |:{ CONV i( client->get_event_arg( first + 4 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }:00|.

  ENDMETHOD.


  METHOD index_of.

    " the dragged appointment reaches the backend as its binding path
    " ('/T_APPOINTMENTS/3'); its last segment is the zero-based row
    SPLIT path AT `/` INTO TABLE DATA(parts).
    DELETE parts WHERE table_line IS INITIAL.
    IF parts IS INITIAL.
      RETURN.
    ENDIF.
    result = CONV i( parts[ lines( parts ) ] ) + 1.

  ENDMETHOD.


  METHOD model_init.

    " onInit's startDate and its 36 appointments, all on the 2018-07 week
    start_date = `2018-07-09T00:00:00`.

    t_appointments = VALUE #(
      ( title    = `Meet John Miller`
        text     = ``
        type     = `Type05`
        icon     = ``
        start_at = `2018-07-08T05:00:00`
        end_at   = `2018-07-08T06:00:00` )
      ( title    = `Discussion of the plan`
        text     = ``
        type     = `Type01`
        icon     = ``
        start_at = `2018-07-08T06:00:00`
        end_at   = `2018-07-08T07:09:00` )
      ( title    = `Lunch`
        text     = `canteen`
        type     = `Type05`
        icon     = ``
        start_at = `2018-07-08T07:00:00`
        end_at   = `2018-07-08T08:00:00` )
      ( title    = `New Product`
        text     = `room 105`
        type     = `Type01`
        icon     = `sap-icon://meeting-room`
        start_at = `2018-07-08T08:00:00`
        end_at   = `2018-07-08T09:00:00` )
      ( title    = `Team meeting`
        text     = `Regular`
        type     = `Type01`
        icon     = `sap-icon://home`
        start_at = `2018-07-08T09:09:00`
        end_at   = `2018-07-08T10:00:00` )
      ( title    = `Discussion with clients`
        text     = `Online meeting`
        type     = `Type08`
        icon     = `sap-icon://home`
        start_at = `2018-07-08T10:00:00`
        end_at   = `2018-07-08T11:00:00` )
      ( title    = `Discussion of the plan`
        text     = `Online meeting`
        type     = `Type01`
        icon     = `sap-icon://home`
        start_at = `2018-07-08T11:00:00`
        end_at   = `2018-07-08T12:00:00` )
      ( title    = `Discussion with clients`
        text     = ``
        type     = `Type08`
        icon     = `sap-icon://home`
        start_at = `2018-07-08T12:00:00`
        end_at   = `2018-07-08T13:09:00` )
      ( title    = `Meeting with the manager`
        text     = ``
        type     = `Type03`
        icon     = ``
        start_at = `2018-07-08T13:09:00`
        end_at   = `2018-07-08T13:09:00` )
      ( title    = `Meeting with the manager`
        text     = ``
        type     = `Type03`
        icon     = ``
        start_at = `2018-07-09T06:30:00`
        end_at   = `2018-07-09T07:00:00` )
      ( title    = `Lunch`
        text     = ``
        type     = `Type05`
        icon     = ``
        start_at = `2018-07-09T07:00:00`
        end_at   = `2018-07-09T08:00:00` )
      ( title    = `Team meeting`
        text     = `online`
        type     = `Type01`
        icon     = ``
        start_at = `2018-07-09T08:00:00`
        end_at   = `2018-07-09T09:00:00` )
      ( title    = `Discussion with clients`
        text     = ``
        type     = `Type08`
        icon     = ``
        start_at = `2018-07-09T09:00:00`
        end_at   = `2018-07-09T10:00:00` )
      ( title    = `Team meeting`
        text     = `room 5`
        type     = `Type01`
        icon     = ``
        start_at = `2018-07-09T11:00:00`
        end_at   = `2018-07-09T14:00:00` )
      ( title    = `Daily standup meeting`
        text     = ``
        type     = `Type01`
        icon     = ``
        start_at = `2018-07-09T09:00:00`
        end_at   = `2018-07-09T09:15:00` )
      ( title    = `Private meeting`
        text     = ``
        type     = `Type03`
        icon     = ``
        start_at = `2018-07-11T09:09:00`
        end_at   = `2018-07-11T09:20:00` )
      ( title    = `Private meeting`
        text     = ``
        type     = `Type03`
        icon     = ``
        start_at = `2018-07-10T06:00:00`
        end_at   = `2018-07-10T07:00:00` )
      ( title    = `Meeting with the manager`
        text     = ``
        type     = `Type03`
        icon     = ``
        start_at = `2018-07-10T15:00:00`
        end_at   = `2018-07-10T15:30:00` )
      ( title    = `Meet John Doe`
        text     = ``
        type     = `Type05`
        icon     = `sap-icon://home`
        start_at = `2018-07-11T07:00:00`
        end_at   = `2018-07-11T07:30:00` )
      ( title    = `Team meeting`
        text     = `online`
        type     = `Type01`
        icon     = ``
        start_at = `2018-07-11T08:00:00`
        end_at   = `2018-07-11T09:30:00` )
      ( title    = `Workshop`
        text     = ``
        type     = `Type05`
        icon     = ``
        start_at = `2018-07-11T08:30:00`
        end_at   = `2018-07-11T12:00:00` )
      ( title    = `Team collaboration`
        text     = ``
        type     = `Type01`
        icon     = ``
        start_at = `2018-07-12T04:00:00`
        end_at   = `2018-07-12T12:30:00` )
      ( title    = `Out of the office`
        text     = ``
        type     = `Type05`
        icon     = ``
        start_at = `2018-07-12T15:00:00`
        end_at   = `2018-07-12T19:30:00` )
      ( title    = `Working out of the building`
        text     = ``
        type     = `Type05`
        icon     = ``
        start_at = `2018-07-12T20:00:00`
        end_at   = `2018-07-12T21:30:00` )
      ( title    = `Reminder`
        text     = ``
        type     = `Type09`
        icon     = ``
        start_at = `2018-07-12T00:00:00`
        end_at   = `2018-07-13T00:00:00` )
      ( title    = `Team collaboration`
        text     = ``
        type     = `Type01`
        icon     = ``
        start_at = `2018-07-06T00:00:00`
        end_at   = `2018-07-16T00:00:00` )
      ( title    = `Workshop out of the country`
        text     = ``
        type     = `Type05`
        icon     = ``
        start_at = `2018-07-14T00:00:00`
        end_at   = `2018-07-20T00:00:00` )
      ( title    = `Payment reminder`
        text     = ``
        type     = `Type09`
        icon     = ``
        start_at = `2018-07-07T00:00:00`
        end_at   = `2018-07-08T00:00:00` )
      ( title    = `Meeting with the manager`
        text     = ``
        type     = `Type03`
        icon     = ``
        start_at = `2018-07-06T09:00:00`
        end_at   = `2018-07-06T10:00:00` )
      ( title    = `Daily standup meeting`
        text     = ``
        type     = `Type01`
        icon     = ``
        start_at = `2018-07-07T10:00:00`
        end_at   = `2018-07-07T10:30:00` )
      ( title    = `Private meeting`
        text     = ``
        type     = `Type03`
        icon     = ``
        start_at = `2018-07-06T11:30:00`
        end_at   = `2018-07-06T12:00:00` )
      ( title    = `Lunch`
        text     = ``
        type     = `Type05`
        icon     = ``
        start_at = `2018-07-06T12:00:00`
        end_at   = `2018-07-06T13:00:00` )
      ( title    = `Discussion of the plan`
        text     = ``
        type     = `Type01`
        icon     = ``
        start_at = `2018-07-16T11:00:00`
        end_at   = `2018-07-16T12:00:00` )
      ( title    = `Lunch`
        text     = `canteen`
        type     = `Type05`
        icon     = ``
        start_at = `2018-07-16T12:00:00`
        end_at   = `2018-07-16T13:00:00` )
      ( title    = `Team meeting`
        text     = `room 200`
        type     = `Type01`
        icon     = `sap-icon://meeting-room`
        start_at = `2018-07-16T16:00:00`
        end_at   = `2018-07-16T17:00:00` )
      ( title    = `Discussion with clients`
        text     = `Online meeting`
        type     = `Type08`
        icon     = `sap-icon://home`
        start_at = `2018-07-17T15:30:00`
        end_at   = `2018-07-17T16:30:00` )
    ).

  ENDMETHOD.

ENDCLASS.
