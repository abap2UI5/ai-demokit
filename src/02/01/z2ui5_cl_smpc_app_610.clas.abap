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
    TYPES ty_t_appointment TYPE STANDARD TABLE OF ty_s_appointment WITH DEFAULT KEY.

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
    DATA temp3 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " the calendar date properties are typed "object" and demand a real JS Date;
    " the model keeps ISO strings and Formatter.DateCreateObject converts them.
    " The drag, resize and create wires carry the interval's LOCAL date parts
    " (a UTC toISOString( ) would shift the day) - app 549 idiom
    
    CLEAR temp1.
    INSERT `${$parameters>/startDate}.getFullYear()` INTO TABLE temp1.
    INSERT `${$parameters>/startDate}.getMonth() + 1` INTO TABLE temp1.
    INSERT `${$parameters>/startDate}.getDate()` INTO TABLE temp1.
    INSERT `${$parameters>/startDate}.getHours()` INTO TABLE temp1.
    INSERT `${$parameters>/startDate}.getMinutes()` INTO TABLE temp1.
    INSERT `${$parameters>/endDate}.getFullYear()` INTO TABLE temp1.
    INSERT `${$parameters>/endDate}.getMonth() + 1` INTO TABLE temp1.
    INSERT `${$parameters>/endDate}.getDate()` INTO TABLE temp1.
    INSERT `${$parameters>/endDate}.getHours()` INTO TABLE temp1.
    INSERT `${$parameters>/endDate}.getMinutes()` INTO TABLE temp1.
    INSERT `${$parameters>/appointment}.getBindingContext().getPath()` INTO TABLE temp1.
    INSERT `${$parameters>/copy} ? 'X' : ''` INTO TABLE temp1.
    
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
    INSERT `${$parameters>/appointment}.getBindingContext().getPath()` INTO TABLE temp2.
    
    CLEAR temp3.
    INSERT `${$parameters>/startDate}.getFullYear()` INTO TABLE temp3.
    INSERT `${$parameters>/startDate}.getMonth() + 1` INTO TABLE temp3.
    INSERT `${$parameters>/startDate}.getDate()` INTO TABLE temp3.
    INSERT `${$parameters>/startDate}.getHours()` INTO TABLE temp3.
    INSERT `${$parameters>/startDate}.getMinutes()` INTO TABLE temp3.
    INSERT `${$parameters>/endDate}.getFullYear()` INTO TABLE temp3.
    INSERT `${$parameters>/endDate}.getMonth() + 1` INTO TABLE temp3.
    INSERT `${$parameters>/endDate}.getDate()` INTO TABLE temp3.
    INSERT `${$parameters>/endDate}.getHours()` INTO TABLE temp3.
    INSERT `${$parameters>/endDate}.getMinutes()` INTO TABLE temp3.
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
                )->a( n = `startDate`                     v = |\{ path: '{ client->_bind_path( start_date ) }', formatter: 'Formatter.DateCreateObject' \}|

                )->a( n = `appointmentDrop`               v = client->_event(
                          val   = `APPT_DROP`
                          t_arg = temp1 )

                )->a( n = `appointmentResize`             v = client->_event(
                          val   = `APPT_RESIZE`
                          t_arg = temp2 )

                )->a( n = `appointmentCreate`             v = client->_event(
                          val   = `APPT_CREATE_DND`
                          t_arg = temp3 )

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
    DATA index TYPE i.
    DATA is_copy TYPE abap_bool.
    DATA temp1 TYPE xsdboolean.
    DATA moved LIKE LINE OF t_appointments.
    DATA temp6 LIKE LINE OF t_appointments.
    DATA temp7 LIKE sy-tabix.
    DATA title LIKE moved-title.
      FIELD-SYMBOLS <temp3> LIKE LINE OF t_appointments.
      DATA temp4 LIKE sy-tabix.
    DATA temp5 TYPE string.
    index   = index_of( client->get_event_arg( 11 ) ).
    
    
    temp1 = boolc( client->get_event_arg( 12 ) = `X` ).
    is_copy = temp1.

    IF index < 1 OR index > lines( t_appointments ).
      RETURN.
    ENDIF.

    
    
    
    temp7 = sy-tabix.
    READ TABLE t_appointments INDEX index INTO temp6.
    sy-tabix = temp7.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    moved = temp6.
    
    title = moved-title.
    moved-start_at = iso_of( 1 ).
    moved-end_at   = iso_of( 6 ).

    IF is_copy = abap_true.
      INSERT moved INTO TABLE t_appointments.
    ELSE.
      
      
      temp4 = sy-tabix.
      READ TABLE t_appointments INDEX index ASSIGNING <temp3>.
      sy-tabix = temp4.
      IF sy-subrc <> 0.
        ASSERT 1 = 0.
      ENDIF.
      <temp3> = moved.
    ENDIF.

    
    IF is_copy = abap_true.
      temp5 = `create`.
    ELSE.
      temp5 = `moved`.
    ENDIF.
    client->message_toast_display(
        |Appointment with title \n'{ title }'\n has been { temp5 }| ).

  ENDMETHOD.


  METHOD appointment_resize.

    " handleAppointmentResize: the two dates move, nothing else
    DATA index TYPE i.
    DATA resized LIKE LINE OF t_appointments.
    DATA temp8 LIKE LINE OF t_appointments.
    DATA temp9 LIKE sy-tabix.
    FIELD-SYMBOLS <temp6> LIKE LINE OF t_appointments.
    DATA temp7 LIKE sy-tabix.
    index = index_of( client->get_event_arg( 11 ) ).

    IF index < 1 OR index > lines( t_appointments ).
      RETURN.
    ENDIF.

    
    
    
    temp9 = sy-tabix.
    READ TABLE t_appointments INDEX index INTO temp8.
    sy-tabix = temp9.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    resized = temp8.
    resized-start_at = iso_of( 1 ).
    resized-end_at   = iso_of( 6 ).
    
    
    temp7 = sy-tabix.
    READ TABLE t_appointments INDEX index ASSIGNING <temp6>.
    sy-tabix = temp7.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    <temp6> = resized.

    client->message_toast_display( |Appointment with title \n'{ resized-title }'\n has been resized| ).

  ENDMETHOD.


  METHOD appointment_create.

    " handleAppointmentCreateDnD pushes a bare 'New Appointment' over the
    " dragged interval - no text, no type, no icon
    " type must be seeded: an unset ABAP field reaches CalendarDayType as "",
    " which is not a member - validateProperty throws and the view goes down.
    " The original pushes an object with no type key, which keeps the default.
    DATA temp8 TYPE z2ui5_cl_smpc_app_610=>ty_s_appointment.
    CLEAR temp8.
    temp8-title = `New Appointment`.
    temp8-type = `Type01`.
    temp8-start_at = iso_of( 1 ).
    temp8-end_at = iso_of( 6 ).
    INSERT temp8 INTO TABLE t_appointments.

    client->message_toast_display( |Appointment with title \n'New Appointment'\n has been created| ).

  ENDMETHOD.


  METHOD iso_of.

    " five consecutive event arguments (year, month, day, hour, minute) as one
    " ISO string - the parts travel LOCAL, so no timezone shifts the day
    DATA temp9 TYPE i.
    DATA temp10 TYPE i.
    DATA temp5 TYPE i.
    DATA temp1 TYPE i.
    temp9 = client->get_event_arg( first + 1 ).
    
    temp10 = client->get_event_arg( first + 2 ).
    
    temp5 = client->get_event_arg( first + 3 ).
    
    temp1 = client->get_event_arg( first + 4 ).
    result = |{ client->get_event_arg( first ) }| &&
             |-{ temp9 WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
             |-{ temp10 WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
             |T{ temp5 WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
             |:{ temp1 WIDTH = 2 ALIGN = RIGHT PAD = '0' }:00|.

  ENDMETHOD.


  METHOD index_of.

    " the dragged appointment reaches the backend as its binding path
    " ('/T_APPOINTMENTS/3'); its last segment is the zero-based row
    TYPES temp1 TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
DATA parts TYPE temp1.
    DATA temp10 TYPE i.
    DATA temp11 LIKE LINE OF parts.
    DATA temp12 LIKE sy-tabix.
    SPLIT path AT `/` INTO TABLE parts.
    DELETE parts WHERE table_line IS INITIAL.
    IF parts IS INITIAL.
      RETURN.
    ENDIF.
    
    
    
    temp12 = sy-tabix.
    READ TABLE parts INDEX lines( parts ) INTO temp11.
    sy-tabix = temp12.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    temp10 = temp11.
    result = temp10 + 1.

  ENDMETHOD.


  METHOD model_init.
    DATA temp11 TYPE z2ui5_cl_smpc_app_610=>ty_t_appointment.
    DATA temp12 LIKE LINE OF temp11.

    " onInit's startDate and its 36 appointments, all on the 2018-07 week
    start_date = `2018-07-09T00:00:00`.

    
    CLEAR temp11.
    
    temp12-title = `Meet John Miller`.
    temp12-text = ``.
    temp12-type = `Type05`.
    temp12-icon = ``.
    temp12-start_at = `2018-07-08T05:00:00`.
    temp12-end_at = `2018-07-08T06:00:00`.
    INSERT temp12 INTO TABLE temp11.
    temp12-title = `Discussion of the plan`.
    temp12-text = ``.
    temp12-type = `Type01`.
    temp12-icon = ``.
    temp12-start_at = `2018-07-08T06:00:00`.
    temp12-end_at = `2018-07-08T07:09:00`.
    INSERT temp12 INTO TABLE temp11.
    temp12-title = `Lunch`.
    temp12-text = `canteen`.
    temp12-type = `Type05`.
    temp12-icon = ``.
    temp12-start_at = `2018-07-08T07:00:00`.
    temp12-end_at = `2018-07-08T08:00:00`.
    INSERT temp12 INTO TABLE temp11.
    temp12-title = `New Product`.
    temp12-text = `room 105`.
    temp12-type = `Type01`.
    temp12-icon = `sap-icon://meeting-room`.
    temp12-start_at = `2018-07-08T08:00:00`.
    temp12-end_at = `2018-07-08T09:00:00`.
    INSERT temp12 INTO TABLE temp11.
    temp12-title = `Team meeting`.
    temp12-text = `Regular`.
    temp12-type = `Type01`.
    temp12-icon = `sap-icon://home`.
    temp12-start_at = `2018-07-08T09:09:00`.
    temp12-end_at = `2018-07-08T10:00:00`.
    INSERT temp12 INTO TABLE temp11.
    temp12-title = `Discussion with clients`.
    temp12-text = `Online meeting`.
    temp12-type = `Type08`.
    temp12-icon = `sap-icon://home`.
    temp12-start_at = `2018-07-08T10:00:00`.
    temp12-end_at = `2018-07-08T11:00:00`.
    INSERT temp12 INTO TABLE temp11.
    temp12-title = `Discussion of the plan`.
    temp12-text = `Online meeting`.
    temp12-type = `Type01`.
    temp12-icon = `sap-icon://home`.
    temp12-start_at = `2018-07-08T11:00:00`.
    temp12-end_at = `2018-07-08T12:00:00`.
    INSERT temp12 INTO TABLE temp11.
    temp12-title = `Discussion with clients`.
    temp12-text = ``.
    temp12-type = `Type08`.
    temp12-icon = `sap-icon://home`.
    temp12-start_at = `2018-07-08T12:00:00`.
    temp12-end_at = `2018-07-08T13:09:00`.
    INSERT temp12 INTO TABLE temp11.
    temp12-title = `Meeting with the manager`.
    temp12-text = ``.
    temp12-type = `Type03`.
    temp12-icon = ``.
    temp12-start_at = `2018-07-08T13:09:00`.
    temp12-end_at = `2018-07-08T13:09:00`.
    INSERT temp12 INTO TABLE temp11.
    temp12-title = `Meeting with the manager`.
    temp12-text = ``.
    temp12-type = `Type03`.
    temp12-icon = ``.
    temp12-start_at = `2018-07-09T06:30:00`.
    temp12-end_at = `2018-07-09T07:00:00`.
    INSERT temp12 INTO TABLE temp11.
    temp12-title = `Lunch`.
    temp12-text = ``.
    temp12-type = `Type05`.
    temp12-icon = ``.
    temp12-start_at = `2018-07-09T07:00:00`.
    temp12-end_at = `2018-07-09T08:00:00`.
    INSERT temp12 INTO TABLE temp11.
    temp12-title = `Team meeting`.
    temp12-text = `online`.
    temp12-type = `Type01`.
    temp12-icon = ``.
    temp12-start_at = `2018-07-09T08:00:00`.
    temp12-end_at = `2018-07-09T09:00:00`.
    INSERT temp12 INTO TABLE temp11.
    temp12-title = `Discussion with clients`.
    temp12-text = ``.
    temp12-type = `Type08`.
    temp12-icon = ``.
    temp12-start_at = `2018-07-09T09:00:00`.
    temp12-end_at = `2018-07-09T10:00:00`.
    INSERT temp12 INTO TABLE temp11.
    temp12-title = `Team meeting`.
    temp12-text = `room 5`.
    temp12-type = `Type01`.
    temp12-icon = ``.
    temp12-start_at = `2018-07-09T11:00:00`.
    temp12-end_at = `2018-07-09T14:00:00`.
    INSERT temp12 INTO TABLE temp11.
    temp12-title = `Daily standup meeting`.
    temp12-text = ``.
    temp12-type = `Type01`.
    temp12-icon = ``.
    temp12-start_at = `2018-07-09T09:00:00`.
    temp12-end_at = `2018-07-09T09:15:00`.
    INSERT temp12 INTO TABLE temp11.
    temp12-title = `Private meeting`.
    temp12-text = ``.
    temp12-type = `Type03`.
    temp12-icon = ``.
    temp12-start_at = `2018-07-11T09:09:00`.
    temp12-end_at = `2018-07-11T09:20:00`.
    INSERT temp12 INTO TABLE temp11.
    temp12-title = `Private meeting`.
    temp12-text = ``.
    temp12-type = `Type03`.
    temp12-icon = ``.
    temp12-start_at = `2018-07-10T06:00:00`.
    temp12-end_at = `2018-07-10T07:00:00`.
    INSERT temp12 INTO TABLE temp11.
    temp12-title = `Meeting with the manager`.
    temp12-text = ``.
    temp12-type = `Type03`.
    temp12-icon = ``.
    temp12-start_at = `2018-07-10T15:00:00`.
    temp12-end_at = `2018-07-10T15:30:00`.
    INSERT temp12 INTO TABLE temp11.
    temp12-title = `Meet John Doe`.
    temp12-text = ``.
    temp12-type = `Type05`.
    temp12-icon = `sap-icon://home`.
    temp12-start_at = `2018-07-11T07:00:00`.
    temp12-end_at = `2018-07-11T07:30:00`.
    INSERT temp12 INTO TABLE temp11.
    temp12-title = `Team meeting`.
    temp12-text = `online`.
    temp12-type = `Type01`.
    temp12-icon = ``.
    temp12-start_at = `2018-07-11T08:00:00`.
    temp12-end_at = `2018-07-11T09:30:00`.
    INSERT temp12 INTO TABLE temp11.
    temp12-title = `Workshop`.
    temp12-text = ``.
    temp12-type = `Type05`.
    temp12-icon = ``.
    temp12-start_at = `2018-07-11T08:30:00`.
    temp12-end_at = `2018-07-11T12:00:00`.
    INSERT temp12 INTO TABLE temp11.
    temp12-title = `Team collaboration`.
    temp12-text = ``.
    temp12-type = `Type01`.
    temp12-icon = ``.
    temp12-start_at = `2018-07-12T04:00:00`.
    temp12-end_at = `2018-07-12T12:30:00`.
    INSERT temp12 INTO TABLE temp11.
    temp12-title = `Out of the office`.
    temp12-text = ``.
    temp12-type = `Type05`.
    temp12-icon = ``.
    temp12-start_at = `2018-07-12T15:00:00`.
    temp12-end_at = `2018-07-12T19:30:00`.
    INSERT temp12 INTO TABLE temp11.
    temp12-title = `Working out of the building`.
    temp12-text = ``.
    temp12-type = `Type05`.
    temp12-icon = ``.
    temp12-start_at = `2018-07-12T20:00:00`.
    temp12-end_at = `2018-07-12T21:30:00`.
    INSERT temp12 INTO TABLE temp11.
    temp12-title = `Reminder`.
    temp12-text = ``.
    temp12-type = `Type09`.
    temp12-icon = ``.
    temp12-start_at = `2018-07-12T00:00:00`.
    temp12-end_at = `2018-07-13T00:00:00`.
    INSERT temp12 INTO TABLE temp11.
    temp12-title = `Team collaboration`.
    temp12-text = ``.
    temp12-type = `Type01`.
    temp12-icon = ``.
    temp12-start_at = `2018-07-06T00:00:00`.
    temp12-end_at = `2018-07-16T00:00:00`.
    INSERT temp12 INTO TABLE temp11.
    temp12-title = `Workshop out of the country`.
    temp12-text = ``.
    temp12-type = `Type05`.
    temp12-icon = ``.
    temp12-start_at = `2018-07-14T00:00:00`.
    temp12-end_at = `2018-07-20T00:00:00`.
    INSERT temp12 INTO TABLE temp11.
    temp12-title = `Payment reminder`.
    temp12-text = ``.
    temp12-type = `Type09`.
    temp12-icon = ``.
    temp12-start_at = `2018-07-07T00:00:00`.
    temp12-end_at = `2018-07-08T00:00:00`.
    INSERT temp12 INTO TABLE temp11.
    temp12-title = `Meeting with the manager`.
    temp12-text = ``.
    temp12-type = `Type03`.
    temp12-icon = ``.
    temp12-start_at = `2018-07-06T09:00:00`.
    temp12-end_at = `2018-07-06T10:00:00`.
    INSERT temp12 INTO TABLE temp11.
    temp12-title = `Daily standup meeting`.
    temp12-text = ``.
    temp12-type = `Type01`.
    temp12-icon = ``.
    temp12-start_at = `2018-07-07T10:00:00`.
    temp12-end_at = `2018-07-07T10:30:00`.
    INSERT temp12 INTO TABLE temp11.
    temp12-title = `Private meeting`.
    temp12-text = ``.
    temp12-type = `Type03`.
    temp12-icon = ``.
    temp12-start_at = `2018-07-06T11:30:00`.
    temp12-end_at = `2018-07-06T12:00:00`.
    INSERT temp12 INTO TABLE temp11.
    temp12-title = `Lunch`.
    temp12-text = ``.
    temp12-type = `Type05`.
    temp12-icon = ``.
    temp12-start_at = `2018-07-06T12:00:00`.
    temp12-end_at = `2018-07-06T13:00:00`.
    INSERT temp12 INTO TABLE temp11.
    temp12-title = `Discussion of the plan`.
    temp12-text = ``.
    temp12-type = `Type01`.
    temp12-icon = ``.
    temp12-start_at = `2018-07-16T11:00:00`.
    temp12-end_at = `2018-07-16T12:00:00`.
    INSERT temp12 INTO TABLE temp11.
    temp12-title = `Lunch`.
    temp12-text = `canteen`.
    temp12-type = `Type05`.
    temp12-icon = ``.
    temp12-start_at = `2018-07-16T12:00:00`.
    temp12-end_at = `2018-07-16T13:00:00`.
    INSERT temp12 INTO TABLE temp11.
    temp12-title = `Team meeting`.
    temp12-text = `room 200`.
    temp12-type = `Type01`.
    temp12-icon = `sap-icon://meeting-room`.
    temp12-start_at = `2018-07-16T16:00:00`.
    temp12-end_at = `2018-07-16T17:00:00`.
    INSERT temp12 INTO TABLE temp11.
    temp12-title = `Discussion with clients`.
    temp12-text = `Online meeting`.
    temp12-type = `Type08`.
    temp12-icon = `sap-icon://home`.
    temp12-start_at = `2018-07-17T15:30:00`.
    temp12-end_at = `2018-07-17T16:30:00`.
    INSERT temp12 INTO TABLE temp11.
    t_appointments = temp11.

  ENDMETHOD.

ENDCLASS.
