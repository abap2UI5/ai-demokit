CLASS z2ui5_cl_smpc_app_546 DEFINITION PUBLIC.

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
    TYPES ty_t_appointment TYPE STANDARD TABLE OF ty_s_appointment WITH EMPTY KEY.
    TYPES: BEGIN OF ty_s_person,
             pic            TYPE string,
             name           TYPE string,
             role           TYPE string,
             t_appointments TYPE ty_t_appointment,
           END OF ty_s_person.
    DATA t_people TYPE STANDARD TABLE OF ty_s_person WITH EMPTY KEY.

    DATA start_date TYPE string.
    DATA role_key   TYPE string.
    DATA user_role  TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.
    METHODS iso_of
      IMPORTING first         TYPE i
      RETURNING VALUE(result) TYPE string.
    METHODS index_of
      IMPORTING path          TYPE string
                last          TYPE abap_bool DEFAULT abap_true
      RETURNING VALUE(result) TYPE i.
    METHODS overlaps
      IMPORTING row_index     TYPE i
                skip_index    TYPE i
                start_at      TYPE string
                end_at        TYPE string
      RETURNING VALUE(result) TYPE abap_bool.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_546 IMPLEMENTATION.

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

    " canModifyAppointments( name ) is a formatter over the row's name and the
    " picked role: a manager and an admin may modify every row, everyone else
    " only their own. Both values are on the client, so the three flags are one
    " expression binding rather than a formatter
    DATA(can_modify) = |\{= ${ client->_bind( user_role ) } === 'manager' \|\| | &&
                       |${ client->_bind( user_role ) } === 'admin' \|\| | &&
                       |${ client->_bind( user_role ) } === $\{NAME\} \}|.

    " the drop, resize and create wires all carry the interval's LOCAL date parts
    " (a UTC toISOString( ) would shift the day) plus the binding paths that name
    " the row and the appointment
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc`     v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core`    v = `sap.ui.core`
        )->a( n = `xmlns:unified` v = `sap.ui.unified`
        )->a( n = `xmlns`         v = `sap.m`
        )->a( n = `core:require`  v = `{Formatter: 'z2ui5/model/formatter'}`

        )->ele( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->ele( `PlanningCalendar`
                )->a( n = `id`                        v = `PC1`
                )->a( n = `startDate`                 v = |\{ path: '{ client->_bind( val = start_date path = abap_true ) }', formatter: 'Formatter.DateCreateObject' \}|
                )->a( n = `rows`                      v = client->_bind( t_people )
                )->a( n = `appointmentsVisualization` v = `Filled`

                )->ele( `toolbarContent`
                    )->tag( `Title`
                        )->a( n = `text`       v = `Title`
                        )->a( n = `titleStyle` v = `H4`
                    )->tag( `Label`
                        )->a( n = `text` v = `Logged in as`

                    )->ele( `Select`
                        )->a( n = `id`          v = `userRole`
                        )->a( n = `change`      v = client->_event( val   = `ROLE_CHANGE`
                                                                    t_arg = VALUE #( ( `${$parameters>/selectedItem}.getKey()` ) ) )
                        )->a( n = `selectedKey` v = client->_bind( role_key )
                        )->a( n = `width`       v = `230px`

                        )->ele( `items`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `admin`
                                )->a( n = `text` v = `Admin`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `manager`
                                )->a( n = `text` v = `Manager`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `donna`
                                )->a( n = `text` v = `Donna Moore`

                        )->end(
                    )->end(
                )->end(

                )->ele( `rows`
                    )->ele( `PlanningCalendarRow`
                        )->a( n = `icon`                          v = `{PIC}`
                        )->a( n = `title`                         v = `{NAME}`
                        )->a( n = `text`                          v = `{ROLE}`
                        )->a( n = `enableAppointmentsDragAndDrop` v = can_modify
                        )->a( n = `enableAppointmentsResize`      v = can_modify
                        )->a( n = `enableAppointmentsCreate`      v = can_modify
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
                                    ( `${$parameters>/calendarRow}.getBindingContext().getPath()` )
                                    ( `${$parameters>/copy} ? 'X' : ''` )
                                    ( `${$parameters>/calendarRow}.getTitle()` ) ) )
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
                                  val   = `APPT_CREATE`
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
                                    ( `${$parameters>/calendarRow}.getBindingContext().getPath()` ) ) )
                        )->a( n = `appointments`                  v = `{path: 'T_APPOINTMENTS', templateShareable: false}`

                        )->ele( `appointments`
                            )->tag( n = `CalendarAppointment` ns = `unified`
                                )->a( n = `startDate` v = `{ path: 'START_AT', formatter: 'Formatter.DateCreateObject' }`
                                )->a( n = `endDate`   v = `{ path: 'END_AT', formatter: 'Formatter.DateCreateObject' }`
                                )->a( n = `icon`      v = `{PIC}`
                                )->a( n = `title`     v = `{TITLE}`
                                )->a( n = `text`      v = `{INFO}`
                                )->a( n = `type`      v = `{TYPE}`
                                )->a( n = `tentative` v = `{TENTATIVE}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `ROLE_CHANGE`.
        " getUserRole( ) maps the Select key through the roles table
        role_key  = client->get_event_arg( ).
        user_role = SWITCH string( role_key
                                   WHEN `donna` THEN `Donna Moore`
                                   ELSE role_key ).

      WHEN `APPT_DROP`.
        DATA(drop_start) = iso_of( 1 ).
        DATA(drop_end)   = iso_of( 6 ).
        DATA(appt_path)  = client->get_event_arg( 11 ).
        DATA(row_path)   = client->get_event_arg( 12 ).
        DATA(is_copy)    = xsdbool( client->get_event_arg( 13 ) = `X` ).
        DATA(row_title)  = client->get_event_arg( 14 ).

        DATA(src_row)   = index_of( path = appt_path last = abap_false ).
        DATA(appt_idx)  = index_of( appt_path ).
        DATA(dest_row)  = index_of( row_path ).

        READ TABLE t_people INDEX src_row + 1 ASSIGNING FIELD-SYMBOL(<source>).
        IF sy-subrc = 0 AND appt_idx >= 0 AND appt_idx < lines( <source>-t_appointments ).
          DATA(moved) = <source>-t_appointments[ appt_idx + 1 ].
          DATA(title) = moved-title.
          moved-start_at = drop_start.
          moved-end_at   = drop_end.

          IF is_copy = abap_false.
            DELETE <source>-t_appointments INDEX appt_idx + 1.
          ENDIF.
          READ TABLE t_people INDEX dest_row + 1 ASSIGNING FIELD-SYMBOL(<dest>).
          IF sy-subrc = 0.
            INSERT moved INTO TABLE <dest>-t_appointments.
          ENDIF.

          client->message_toast_display(
              |{ row_title }'s 'Appointment '{ title }' now starts at \n{ drop_start }\n and end at \n{ drop_end }.| ).
        ENDIF.

      WHEN `APPT_RESIZE`.
        DATA(res_start) = iso_of( 1 ).
        DATA(res_end)   = iso_of( 6 ).
        DATA(res_path)  = client->get_event_arg( 11 ).
        DATA(res_row)   = index_of( path = res_path last = abap_false ).
        DATA(res_idx)   = index_of( res_path ).

        READ TABLE t_people INDEX res_row + 1 ASSIGNING FIELD-SYMBOL(<row>).
        IF sy-subrc = 0 AND res_idx >= 0 AND res_idx < lines( <row>-t_appointments ).
          " isAppointmentOverlap only ever refuses for the MANAGER role
          IF overlaps( row_index  = res_row
                       skip_index = res_idx
                       start_at   = res_start
                       end_at     = res_end ) = abap_true.
            client->message_toast_display( `As a manager you can not resize events if they overlap with another events` ).
          ELSE.
            DATA(res_title) = <row>-t_appointments[ res_idx + 1 ]-title.
            <row>-t_appointments[ res_idx + 1 ]-start_at = res_start.
            <row>-t_appointments[ res_idx + 1 ]-end_at   = res_end.
            client->message_toast_display(
                |Appointment '{ res_title }' now starts at \n{ res_start }\n and end at \n{ res_end }.| ).
          ENDIF.
        ENDIF.

      WHEN `APPT_CREATE`.
        DATA(new_start) = iso_of( 1 ).
        DATA(new_end)   = iso_of( 6 ).
        DATA(new_row)   = index_of( client->get_event_arg( 11 ) ).

        READ TABLE t_people INDEX new_row + 1 ASSIGNING FIELD-SYMBOL(<target>).
        IF sy-subrc = 0.
          INSERT VALUE #( title    = `New Appointment`
                          start_at = new_start
                          end_at   = new_end ) INTO TABLE <target>-t_appointments.
          client->message_toast_display(
              |New Appointment is created at \n{ new_start }\n and end at \n{ new_end }.| ).
        ENDIF.

    ENDCASE.

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

    " a binding path is /T_PEOPLE/<row>/T_APPOINTMENTS/<appointment>; `last`
    " picks the appointment index, otherwise the row index
    SPLIT path AT `/` INTO TABLE DATA(parts).
    DELETE parts WHERE table_line IS INITIAL.
    result = -1.
    IF last = abap_true.
      IF lines( parts ) >= 1.
        result = CONV i( parts[ lines( parts ) ] ).
      ENDIF.
    ELSEIF lines( parts ) >= 2.
      result = CONV i( parts[ 2 ] ).
    ENDIF.

  ENDMETHOD.


  METHOD overlaps.

    " the manager is the only role the original checks overlaps for
    IF user_role <> `manager`.
      RETURN.
    ENDIF.

    READ TABLE t_people INDEX row_index + 1 ASSIGNING FIELD-SYMBOL(<row>).
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    LOOP AT <row>-t_appointments INTO DATA(appointment).
      IF sy-tabix - 1 = skip_index.
        CONTINUE.
      ENDIF.
      IF (    appointment-start_at <= start_at AND start_at < appointment-end_at )
         OR ( appointment-start_at <  end_at   AND end_at  <= appointment-end_at )
         OR ( start_at <= appointment-start_at AND appointment-start_at < end_at ).
        result = abap_true.
        RETURN.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD model_init.

    start_date = `2017-11-13T08:00:00`.
    role_key   = `admin`.
    user_role  = `admin`.

    t_people = VALUE #(
      ( pic = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/John_Miller.png` name = `John Miller` role = `team member`
        t_appointments = VALUE #(
          ( start_at = `2017-11-13T08:00:00` end_at = `2017-11-13T09:00:00` title = `Team sync` info = `Canteen` type = `Type07` pic = `sap-icon://family-care` )
          ( start_at = `2017-11-13T09:00:00` end_at = `2017-11-13T11:00:00` title = `Morning Sync` info = `I call you` type = `Type01` pic = `sap-icon://call` )
          ( start_at = `2017-11-13T10:00:00` end_at = `2017-11-13T12:00:00` title = `Sync Bill` info = `Online` type = `Type03` )
          ( start_at = `2017-11-13T10:00:00` end_at = `2017-11-13T13:00:00` title = `Check Flights` info = `no room` type = `Type09` pic = `sap-icon://flight` )
          ( start_at = `2017-11-13T13:00:00` end_at = `2017-11-13T14:00:00` title = `Lunch` info = `canteen` type = `Type05` pic = `sap-icon://private` )
          ( start_at = `2017-11-13T18:00:00` end_at = `2017-11-13T20:00:00` title = `Discussion of the plan` info = `Online meeting` type = `Type04` )
          ( start_at = `2017-11-14T03:00:00` end_at = `2017-11-14T23:00:00` title = `Deadline` type = `Type05` )
          ( start_at = `2017-11-14T09:00:00` end_at = `2017-11-14T14:00:00` title = `Blocker` info = `room 6` type = `Type08` )
          ( start_at = `2017-11-17T09:00:00` end_at = `2017-11-17T18:00:00` title = `Boss Birthday` type = `Type02` )
          ( start_at = `2017-11-24T09:00:00` end_at = `2017-11-24T18:00:00` title = `Urgent Planning` type = `Type08` )
          ( start_at = `2017-11-20T01:00:00` end_at = `2017-11-20T23:00:00` title = `Planning` type = `Type09` )
        )
      )
      ( pic = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/Donna_Moore.jpg` name = `Donna Moore` role = `team member`
        t_appointments = VALUE #(
          ( start_at = `2017-11-13T08:00:00` end_at = `2017-11-13T09:26:00` title = `Team sync` info = `Canteen` type = `Type07` pic = `sap-icon://family-care` )
          ( start_at = `2017-11-13T10:00:00` end_at = `2017-11-13T12:00:00` title = `Sync John` info = `Online` type = `Type03` )
          ( start_at = `2017-11-13T11:00:00` end_at = `2017-11-13T12:00:00` title = `Prep for planning` info = `room 5` type = `Type01` pic = `sap-icon://family-care` )
          ( start_at = `2017-11-13T18:00:00` end_at = `2017-11-13T20:00:00` title = `Check Flights` info = `no room` type = `Type09` pic = `sap-icon://flight` )
          ( start_at = `2017-11-13T18:00:00` end_at = `2017-11-13T20:00:00` title = `Discussion of the plan` info = `Online meeting` type = `Type04` )
          ( start_at = `2017-11-20T01:00:00` end_at = `2017-11-20T23:00:00` title = `Planning` type = `Type09` )
          ( start_at = `2018-03-20T01:00:00` end_at = `2018-03-20T23:00:00` title = `Off` type = `Type08` )
        )
      ) ).

  ENDMETHOD.

ENDCLASS.
