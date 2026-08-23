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
    TYPES ty_t_appointment TYPE STANDARD TABLE OF ty_s_appointment WITH EMPTY KEY.
    TYPES: BEGIN OF ty_s_type,
             type TYPE string,
           END OF ty_s_type.
    TYPES ty_t_type TYPE STANDARD TABLE OF ty_s_type WITH EMPTY KEY.

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

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popup_details_display.
    METHODS popup_modify_display.
    METHODS type_text
      IMPORTING type          TYPE string
      RETURNING VALUE(result) TYPE string.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_609 IMPLEMENTATION.

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
    " the model keeps ISO strings and Formatter.DateCreateObject converts them
    " the drag, resize and create wires carry the interval's LOCAL date parts
    " (a UTC toISOString( ) would shift the day)
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
                          t_arg = VALUE #(
                            ( `${$parameters>/appointment} ? ${$parameters>/appointment}.getBindingContext().getPath() : ''` )
                            ( `${$parameters>/appointment} ? ${$parameters>/appointment}.getSelected() : false` ) ) )
                )->a( n = `headerDateSelect`              v = client->_event(
                          val   = `HEADER_DATE`
                          t_arg = VALUE #(
                            ( `${$parameters>/date}.getFullYear()` )
                            ( `${$parameters>/date}.getMonth() + 1` )
                            ( `${$parameters>/date}.getDate()` ) ) )
                " handleStartDateChange names the new start date in a toast
                )->a( n = `startDateChange`               v = client->_event(
                          val   = `START_DATE_CHANGE`
                          t_arg = VALUE #( ( `${$parameters>/date}.toString()` ) ) )
                )->a( n = `startDate`                     v = |\{ path: '{ client->_bind( val = start_date path = abap_true ) }', formatter: 'Formatter.DateCreateObject' \}|
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

    DATA(popup) = z2ui5_cl_ui5_view_builder=>factory( ).

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

    client->popover_display( xml   = popup->stringify( )
                             by_id = `SPC1` ).

  ENDMETHOD.


  METHOD popup_modify_display.

    DATA(popup) = z2ui5_cl_ui5_view_builder=>factory( ).

    popup->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:f`    v = `sap.ui.layout.form`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->ele( `Dialog`
            )->a( n = `id`    v = `modifyDialog`
            )->a( n = `title` v = client->_bind( dialog_title )

            )->ele( `beginButton`
                )->tag( `Button`
                    )->a( n = `text`  v = `OK`
                    )->a( n = `type`  v = `Emphasized`
                    )->a( n = `press` v = client->_event( `DIALOG_OK` )

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
                        )->a( n = `id`        v = `appTitle`
                        )->a( n = `maxLength` v = `255`
                        )->a( n = `value`     v = client->_bind( sel_title )
                    )->tag( `Label`
                        )->a( n = `text`     v = `Additional information`
                        )->a( n = `labelFor` v = `inputInfo`
                    )->tag( `Input`
                        )->a( n = `id`        v = `moreInfo`
                        )->a( n = `maxLength` v = `255`
                        )->a( n = `value`     v = client->_bind( sel_text )
                    )->tag( `Label`
                        )->a( n = `text`     v = `From`
                        )->a( n = `labelFor` v = `startDate`
                    )->tag( `DateTimePicker`
                        )->a( n = `id`       v = `DTPStartDate`
                        )->a( n = `required` v = `true`
                        )->a( n = `visible`  v = |\{= !${ client->_bind( all_day ) } \}|
                        )->a( n = `value`    v = client->_bind( sel_start )
                    )->tag( `DatePicker`
                        )->a( n = `id`       v = `DPStartDate`
                        )->a( n = `required` v = `true`
                        )->a( n = `visible`  v = |\{= ${ client->_bind( all_day ) } \}|
                        )->a( n = `value`    v = client->_bind( sel_start )
                    )->tag( `Label`
                        )->a( n = `text`     v = `To`
                        )->a( n = `labelFor` v = `endDate`
                    )->tag( `DateTimePicker`
                        )->a( n = `id`       v = `DTPEndDate`
                        )->a( n = `required` v = `true`
                        )->a( n = `visible`  v = |\{= !${ client->_bind( all_day ) } \}|
                        )->a( n = `value`    v = client->_bind( sel_end )
                    )->tag( `DatePicker`
                        )->a( n = `id`       v = `DPEndDate`
                        )->a( n = `required` v = `true`
                        )->a( n = `visible`  v = |\{= ${ client->_bind( all_day ) } \}|
                        )->a( n = `value`    v = client->_bind( sel_end )
                    )->tag( `CheckBox`
                        )->a( n = `id`       v = `allDay`
                        )->a( n = `text`     v = `All-day`
                        )->a( n = `selected` v = client->_bind( all_day )
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

    CASE client->get_event( ).
      WHEN `APPT_SELECT`.
        " handleAppointmentSelect opens the details popover on the picked
        " appointment, and closes it again when the appointment is deselected
        DATA(path) = client->get_event_arg( ).
        IF path IS INITIAL OR client->get_event_arg( 2 ) <> abap_true.
          client->popup_destroy( ).
        ELSE.
          SPLIT path AT `/` INTO TABLE DATA(parts).
          DELETE parts WHERE table_line IS INITIAL.
          sel_index = CONV i( parts[ lines( parts ) ] ).
          IF sel_index >= 0 AND sel_index < lines( t_appointments ).
            DATA(appointment) = t_appointments[ sel_index + 1 ].
            sel_title   = appointment-title.
            sel_text    = appointment-text.
            sel_type    = appointment-type.
            sel_start   = appointment-start_at.
            sel_end     = appointment-end_at.
            sel_typetxt = type_text( appointment-type ).
            " an appointment that starts and ends at midnight is an all-day one
            all_day     = xsdbool( substring( val = sel_start off = 11 len = 8 ) = `00:00:00`
                               AND substring( val = sel_end off = 11 len = 8 ) = `00:00:00` ).
            popup_details_display( ).
          ENDIF.
        ENDIF.
      WHEN `EDIT`.
        " handleEditButton closes the popover and opens the dialog on the same row
        dialog_title = `Edit appointment`.
        popup_modify_display( ).
      WHEN `DELETE`.
        " handlePopoverDeleteButton removes the appointment behind the popover
        IF sel_index >= 0 AND sel_index < lines( t_appointments ).
          DELETE t_appointments INDEX sel_index + 1.
        ENDIF.
        client->popup_destroy( ).
      WHEN `APPT_CREATE` OR `HEADER_DATE`.
        " _createInitialDialogValues seeds the dialog at the default 9 - 10 hours
        " of the picked day (or of the calendar's own start date)
        " Written as IF/ELSE rather than COND: the transpiled backend HOISTS the
        " branch expressions out of a COND and evaluates them BOTH, so the two
        " get_event_arg( ) reads below ran for APPT_CREATE too - a wire that
        " carries no arguments at all - and the missing row asserted instead of
        " returning initial, so every Create press 500'd (e2e-caught 2026-08-22)
        IF client->get_event( ) = `HEADER_DATE`.
          day = |{ client->get_event_arg( ) }| &&
                |-{ CONV i( client->get_event_arg( 2 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
                |-{ CONV i( client->get_event_arg( 3 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }|.
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
        popup_modify_display( ).
      WHEN `DIALOG_OK`.
        " handleDialogOkButton writes the dialog back into the picked row, or
        " pushes a new one when the dialog was opened for a create
        IF sel_index >= 0 AND sel_index < lines( t_appointments ).
          t_appointments[ sel_index + 1 ]-title    = sel_title.
          t_appointments[ sel_index + 1 ]-text     = sel_text.
          t_appointments[ sel_index + 1 ]-type     = sel_type.
          t_appointments[ sel_index + 1 ]-start_at = sel_start.
          t_appointments[ sel_index + 1 ]-end_at   = sel_end.
        ELSE.
          INSERT VALUE #( title    = sel_title
                          text     = sel_text
                          type     = sel_type
                          start_at = sel_start
                          end_at   = sel_end ) INTO TABLE t_appointments.
        ENDIF.
        client->popup_destroy( ).
      WHEN `DIALOG_CANCEL`.
        client->popup_destroy( ).
      WHEN `START_DATE_CHANGE`.
        client->message_toast_display(
            |'startDateChange' event fired.\n\nNew start date is { client->get_event_arg( ) }| ).
    ENDCASE.

  ENDMETHOD.


  METHOD type_text.

    " this sample's Details fragment binds {type} directly - no formatter
    result = type.

  ENDMETHOD.


  METHOD model_init.

    start_date = `2018-07-09T00:00:00`.
    all_day    = abap_false.
    sel_index  = -1.

    " the sample builds `types` by walking CalendarDayType, and its Select shows
    " the KEY as the text; the enum's own members, in its own order
    t_types = VALUE #(
      ( type = `None` )
      ( type = `Type01` )
      ( type = `Type02` )
      ( type = `Type03` )
      ( type = `Type04` )
      ( type = `Type05` )
      ( type = `Type06` )
      ( type = `Type07` )
      ( type = `Type08` )
      ( type = `Type09` )
      ( type = `Type10` )
      ( type = `Type11` )
      ( type = `Type12` )
      ( type = `Type13` )
      ( type = `Type14` )
      ( type = `Type15` )
      ( type = `Type16` )
      ( type = `Type17` )
      ( type = `Type18` )
      ( type = `Type19` )
      ( type = `Type20` ) ).

    " onInit's 35 appointments
    t_appointments = VALUE #(
      ( title     = `Meet John Miller`
        text      = ``
        type      = `Type05`
        icon      = ``
        start_at  = `2018-07-08T05:00:00`
        end_at    = `2018-07-08T06:00:00`
        aria      = `Dialog`
        tentative = abap_false )
      ( title     = `Discussion of the plan`
        text      = ``
        type      = `Type01`
        icon      = ``
        start_at  = `2018-07-08T06:00:00`
        end_at    = `2018-07-08T07:09:00`
        aria      = `Dialog`
        tentative = abap_false )
      ( title     = `Lunch`
        text      = `canteen`
        type      = `Type05`
        icon      = ``
        start_at  = `2018-07-08T07:00:00`
        end_at    = `2018-07-08T08:00:00`
        aria      = `Dialog`
        tentative = abap_false )
      ( title     = `New Product`
        text      = `room 105`
        type      = `Type01`
        icon      = `sap-icon://meeting-room`
        start_at  = `2018-07-08T08:00:00`
        end_at    = `2018-07-08T09:00:00`
        aria      = `Dialog`
        tentative = abap_false )
      ( title     = `Team meeting`
        text      = `Regular`
        type      = `Type01`
        icon      = `sap-icon://home`
        start_at  = `2018-07-08T09:09:00`
        end_at    = `2018-07-08T10:00:00`
        aria      = `Dialog`
        tentative = abap_false )
      ( title     = `Discussion with clients`
        text      = `Online meeting`
        type      = `Type08`
        icon      = `sap-icon://home`
        start_at  = `2018-07-08T10:00:00`
        end_at    = `2018-07-08T11:00:00`
        aria      = `Dialog`
        tentative = abap_false )
      ( title     = `Discussion of the plan`
        text      = `Online meeting`
        type      = `Type01`
        icon      = `sap-icon://home`
        start_at  = `2018-07-08T11:00:00`
        end_at    = `2018-07-08T12:00:00`
        aria      = `Dialog`
        tentative = abap_true )
      ( title     = `Discussion with clients`
        text      = ``
        type      = `Type08`
        icon      = `sap-icon://home`
        start_at  = `2018-07-08T12:00:00`
        end_at    = `2018-07-08T13:09:00`
        aria      = `Dialog`
        tentative = abap_false )
      ( title     = `Meeting with the manager`
        text      = ``
        type      = `Type03`
        icon      = ``
        start_at  = `2018-07-08T13:09:00`
        end_at    = `2018-07-08T13:09:00`
        aria      = `Dialog`
        tentative = abap_false )
      ( title     = `Meeting with the manager`
        text      = ``
        type      = `Type03`
        icon      = ``
        start_at  = `2018-07-09T06:30:00`
        end_at    = `2018-07-09T07:00:00`
        aria      = `Dialog`
        tentative = abap_false )
      ( title     = `Lunch`
        text      = ``
        type      = `Type05`
        icon      = ``
        start_at  = `2018-07-09T07:00:00`
        end_at    = `2018-07-09T08:00:00`
        aria      = `Dialog`
        tentative = abap_false )
      ( title     = `Team meeting`
        text      = `online`
        type      = `Type01`
        icon      = ``
        start_at  = `2018-07-09T08:00:00`
        end_at    = `2018-07-09T09:00:00`
        aria      = `Dialog`
        tentative = abap_false )
      ( title     = `Discussion with clients`
        text      = ``
        type      = `Type08`
        icon      = ``
        start_at  = `2018-07-09T09:00:00`
        end_at    = `2018-07-09T10:00:00`
        aria      = `Dialog`
        tentative = abap_false )
      ( title     = `Team meeting`
        text      = `room 5`
        type      = `Type01`
        icon      = ``
        start_at  = `2018-07-09T11:00:00`
        end_at    = `2018-07-09T14:00:00`
        aria      = `Dialog`
        tentative = abap_false )
      ( title     = `Daily standup meeting`
        text      = ``
        type      = `Type01`
        icon      = ``
        start_at  = `2018-07-09T09:00:00`
        end_at    = `2018-07-09T09:15:00`
        aria      = `Dialog`
        tentative = abap_false )
      ( title     = `Private meeting`
        text      = ``
        type      = `Type03`
        icon      = ``
        start_at  = `2018-07-11T09:09:00`
        end_at    = `2018-07-11T09:20:00`
        aria      = `Dialog`
        tentative = abap_false )
      ( title     = `Private meeting`
        text      = ``
        type      = `Type03`
        icon      = ``
        start_at  = `2018-07-10T06:00:00`
        end_at    = `2018-07-10T07:00:00`
        aria      = `Dialog`
        tentative = abap_false )
      ( title     = `Meeting with the manager`
        text      = ``
        type      = `Type03`
        icon      = ``
        start_at  = `2018-07-10T15:00:00`
        end_at    = `2018-07-10T15:30:00`
        aria      = `Dialog`
        tentative = abap_false )
      ( title     = `Meet John Doe`
        text      = ``
        type      = `Type05`
        icon      = `sap-icon://home`
        start_at  = `2018-07-11T07:00:00`
        end_at    = `2018-07-11T07:30:00`
        aria      = `Dialog`
        tentative = abap_false )
      ( title     = `Team meeting`
        text      = `online`
        type      = `Type01`
        icon      = ``
        start_at  = `2018-07-11T08:00:00`
        end_at    = `2018-07-11T09:30:00`
        aria      = `Dialog`
        tentative = abap_false )
      ( title     = `Workshop`
        text      = ``
        type      = `Type05`
        icon      = ``
        start_at  = `2018-07-11T08:30:00`
        end_at    = `2018-07-11T12:00:00`
        aria      = `Dialog`
        tentative = abap_false )
      ( title     = `Team collaboration`
        text      = ``
        type      = `Type01`
        icon      = ``
        start_at  = `2018-07-12T04:00:00`
        end_at    = `2018-07-12T12:30:00`
        aria      = `Dialog`
        tentative = abap_false )
      ( title     = `Out of the office`
        text      = ``
        type      = `Type05`
        icon      = ``
        start_at  = `2018-07-12T15:00:00`
        end_at    = `2018-07-12T19:30:00`
        aria      = `Dialog`
        tentative = abap_false )
      ( title     = `Working out of the building`
        text      = ``
        type      = `Type05`
        icon      = ``
        start_at  = `2018-07-12T20:00:00`
        end_at    = `2018-07-12T21:30:00`
        aria      = `Dialog`
        tentative = abap_false )
      ( title     = `Reminder`
        text      = ``
        type      = `Type09`
        icon      = ``
        start_at  = `2018-07-12T00:00:00`
        end_at    = `2018-07-13T00:00:00`
        aria      = `Dialog`
        tentative = abap_false )
      ( title     = `Team collaboration`
        text      = ``
        type      = `Type01`
        icon      = ``
        start_at  = `2018-07-06T00:00:00`
        end_at    = `2018-07-16T00:00:00`
        aria      = `Dialog`
        tentative = abap_false )
      ( title     = `Workshop out of the country`
        text      = ``
        type      = `Type05`
        icon      = ``
        start_at  = `2018-07-14T00:00:00`
        end_at    = `2018-07-20T00:00:00`
        aria      = `Dialog`
        tentative = abap_false )
      ( title     = `Payment reminder`
        text      = ``
        type      = `Type09`
        icon      = ``
        start_at  = `2018-07-07T00:00:00`
        end_at    = `2018-07-08T00:00:00`
        aria      = `Dialog`
        tentative = abap_false )
      ( title     = `Meeting with the manager`
        text      = ``
        type      = `Type03`
        icon      = ``
        start_at  = `2018-07-06T09:00:00`
        end_at    = `2018-07-06T10:00:00`
        aria      = `Dialog`
        tentative = abap_false )
      ( title     = `Daily standup meeting`
        text      = ``
        type      = `Type01`
        icon      = ``
        start_at  = `2018-07-07T10:00:00`
        end_at    = `2018-07-07T10:30:00`
        aria      = `Dialog`
        tentative = abap_false )
      ( title     = `Private meeting`
        text      = ``
        type      = `Type03`
        icon      = ``
        start_at  = `2018-07-06T11:30:00`
        end_at    = `2018-07-06T12:00:00`
        aria      = `Dialog`
        tentative = abap_false )
      ( title     = `Lunch`
        text      = ``
        type      = `Type05`
        icon      = ``
        start_at  = `2018-07-06T12:00:00`
        end_at    = `2018-07-06T13:00:00`
        aria      = `Dialog`
        tentative = abap_false )
      ( title     = `Discussion of the plan`
        text      = ``
        type      = `Type01`
        icon      = ``
        start_at  = `2018-07-16T11:00:00`
        end_at    = `2018-07-16T12:00:00`
        aria      = `Dialog`
        tentative = abap_false )
      ( title     = `Lunch`
        text      = `canteen`
        type      = `Type05`
        icon      = ``
        start_at  = `2018-07-16T12:00:00`
        end_at    = `2018-07-16T13:00:00`
        aria      = `Dialog`
        tentative = abap_false )
      ( title     = `Team meeting`
        text      = `room 200`
        type      = `Type01`
        icon      = `sap-icon://meeting-room`
        start_at  = `2018-07-16T16:00:00`
        end_at    = `2018-07-16T17:00:00`
        aria      = `Dialog`
        tentative = abap_false ) ).

  ENDMETHOD.

ENDCLASS.
