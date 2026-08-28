" @keywords planningcalendar planning calendar sap.m planningcalendarmodifyappointments vbox title button planningcalendarrow calendarappointment responsivepopover simpleform
" @summary PlanningCalendar containing sap.m.Popover with information for the appointments and sap.m.Dialog for creating a new appointment. Note: Illustrates how the PlanningCalendar can be used in combination with the sap.m.Popover and sap.m.
CLASS z2ui5_cl_smpc_app_547 DEFINITION PUBLIC.

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
             aria      TYPE string,
             selected  TYPE abap_bool,
           END OF ty_s_appointment.
    TYPES ty_t_appointment TYPE STANDARD TABLE OF ty_s_appointment WITH EMPTY KEY.
    TYPES: BEGIN OF ty_s_header,
             start_at TYPE string,
             end_at   TYPE string,
             title    TYPE string,
             type     TYPE string,
             pic      TYPE string,
           END OF ty_s_header.
    TYPES ty_t_header TYPE STANDARD TABLE OF ty_s_header WITH EMPTY KEY.
    TYPES: BEGIN OF ty_s_person,
             pic            TYPE string,
             name           TYPE string,
             role           TYPE string,
             t_appointments TYPE ty_t_appointment,
             t_headers      TYPE ty_t_header,
           END OF ty_s_person.
    DATA t_people TYPE STANDARD TABLE OF ty_s_person WITH EMPTY KEY.

    DATA start_date TYPE string.

    " the details popover and the create/edit dialog, folded to fields
    DATA sel_row      TYPE i.
    DATA sel_index    TYPE i.
    DATA sel_title    TYPE string.
    DATA sel_info     TYPE string.
    DATA sel_start    TYPE string.
    DATA sel_end      TYPE string.
    DATA d_mode       TYPE string.
    DATA d_person     TYPE string.
    DATA d_interval   TYPE abap_bool.
    DATA d_title      TYPE string.
    DATA d_info       TYPE string.
    DATA d_start      TYPE string.
    DATA d_end        TYPE string.
    DATA d_start_state TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popup_details_display.
    METHODS popup_create_display.
    METHODS appointment_edit
      IMPORTING target_row TYPE i.
    METHODS iso_of
      IMPORTING first         TYPE i
      RETURNING VALUE(result) TYPE string.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_547 IMPLEMENTATION.

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
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc`     v = `sap.ui.core.mvc`
        )->a( n = `xmlns:unified` v = `sap.ui.unified`
        )->a( n = `xmlns:core`    v = `sap.ui.core`
        )->a( n = `xmlns`         v = `sap.m`
        )->a( n = `core:require`  v = `{Formatter: 'z2ui5/model/formatter'}`

        )->ele( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->ele( `PlanningCalendar`
                )->a( n = `id`                        v = `PC1`
                )->a( n = `startDate`                 v = |\{ path: '{ client->_bind( val = start_date path = abap_true ) }', formatter: 'Formatter.DateCreateObject' \}|
                )->a( n = `rows`                      v = client->_bind( t_people )
                )->a( n = `appointmentsVisualization` v = `Filled`
                " handleAppointmentSelect opens the details popover on a single
                " appointment, or the group popover on a collapsed group
                )->a( n = `appointmentSelect`         v = client->_event(
                          val   = `APPT_SELECT`
                          t_arg = VALUE #(
                            ( `${$parameters>/appointment} ? ${$parameters>/appointment}.getBindingContext().getPath() : ''` )
                            ( `${$parameters>/appointment} ? ${$parameters>/appointment}.getSelected() : false` )
                            ( `${$parameters>/appointments} ? ${$parameters>/appointments}.length : 0` )
                            " the "do the types differ" test used to be a fifth arg
                            " holding a JS callback (.some(function(a){...})), which is
                            " not in the UI5 expression grammar - it threw and lost the
                            " whole handler. CalendarAppointment.selected is bindable,
                            " so ABAP reads the selected rows and compares them itself.
                            ( `${$parameters>/appointments} ? ${$parameters>/appointments}[0].getType() : ''` ) ) )
                )->a( n = `showEmptyIntervalHeaders`  v = `false`
                " handleAppointmentAddWithContext opens the same dialog pre-set to
                " the selected interval
                )->a( n = `intervalSelect`            v = client->_event(
                          val   = `INTERVAL_SELECT`
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
                            ( `${$parameters>/row} ? $event.oSource.indexOfRow(${$parameters>/row}) : -1` ) ) )

                )->ele( `toolbarContent`
                    )->tag( `Title`
                        )->a( n = `text`       v = `Title`
                        )->a( n = `titleStyle` v = `H4`
                    )->tag( `Button`
                        )->a( n = `id`      v = `addButton`
                        )->a( n = `icon`    v = `sap-icon://add`
                        )->a( n = `press`   v = client->_event( `APPT_CREATE` )
                        )->a( n = `tooltip` v = `Add`

                )->end(

                )->ele( `rows`
                    )->ele( `PlanningCalendarRow`
                        )->a( n = `icon`            v = `{PIC}`
                        )->a( n = `title`           v = `{NAME}`
                        )->a( n = `text`            v = `{ROLE}`
                        )->a( n = `appointments`    v = `{path: 'T_APPOINTMENTS', templateShareable: false}`
                        )->a( n = `intervalHeaders` v = `{path: 'T_HEADERS', templateShareable: false}`

                        )->ele( `appointments`
                            )->tag( n = `CalendarAppointment` ns = `unified`
                                )->a( n = `startDate`    v = `{ path: 'START_AT', formatter: 'Formatter.DateCreateObject' }`
                                )->a( n = `endDate`      v = `{ path: 'END_AT', formatter: 'Formatter.DateCreateObject' }`
                                )->a( n = `icon`         v = `{PIC}`
                                )->a( n = `title`        v = `{TITLE}`
                                )->a( n = `text`         v = `{INFO}`
                                )->a( n = `type`         v = `{TYPE}`
                                )->a( n = `tentative`    v = `{TENTATIVE}`
                                )->a( n = `selected`     v = `{SELECTED}`
                                )->a( n = `ariaHasPopup` v = `{ARIA}`

                        )->end(
                        )->ele( `intervalHeaders`
                            )->tag( n = `CalendarAppointment` ns = `unified`
                                )->a( n = `startDate` v = `{ path: 'START_AT', formatter: 'Formatter.DateCreateObject' }`
                                )->a( n = `endDate`   v = `{ path: 'END_AT', formatter: 'Formatter.DateCreateObject' }`
                                )->a( n = `icon`      v = `{PIC}`
                                )->a( n = `title`     v = `{TITLE}`
                                )->a( n = `type`      v = `{TYPE}` ).

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
            )->a( n = `class`     v = `sapUiContentPadding`
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
                )->a( n = `editable`                v = `false`
                )->a( n = `layout`                  v = `ResponsiveGridLayout`
                )->a( n = `singleContainerFullSize` v = `false`

                )->tag( `Label`
                    )->a( n = `text`     v = `Additional information`
                    )->a( n = `labelFor` v = `moreInfoText`
                )->tag( `Text`
                    )->a( n = `id`   v = `moreInfoText`
                    )->a( n = `text` v = client->_bind( sel_info )
                )->tag( `Label`
                    )->a( n = `text`     v = `From`
                    )->a( n = `labelFor` v = `startDateText`
                )->tag( `Text`
                    )->a( n = `id`   v = `startDateText`
                    )->a( n = `text` v = client->_bind( sel_start )
                )->tag( `Label`
                    )->a( n = `text`     v = `To`
                    )->a( n = `labelFor` v = `endDateText`
                )->tag( `Text`
                    )->a( n = `id`   v = `endDateText`
                    )->a( n = `text` v = client->_bind( sel_end ) ).

    client->popover_display( xml = popup->stringify( ) by_id = `PC1` ).

  ENDMETHOD.


  METHOD popup_create_display.

    DATA(popup) = z2ui5_cl_ui5_view_builder=>factory( ).

    popup->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns`      v = `sap.m`

        )->ele( `Dialog`
            )->a( n = `id` v = `createDialog`

            )->ele( `beginButton`
                )->tag( `Button`
                    )->a( n = `text`  v = `Save`
                    )->a( n = `type`  v = `Emphasized`
                    )->a( n = `press` v = client->_event( `DIALOG_SAVE` )

            )->end(
            )->ele( `endButton`
                )->tag( `Button`
                    )->a( n = `text`  v = `Cancel`
                    )->a( n = `press` v = client->_event( `DIALOG_CANCEL` )

            )->end(

            )->ele( n = `VerticalLayout` ns = `l`
                )->a( n = `class` v = `sapUiContentPadding`
                )->a( n = `width` v = `100%`

                " handleAppointmentTypeChange only re-reads the checkbox; the flag
                " is bound two-way here, so the select wire is dropped
                )->tag( `CheckBox`
                    )->a( n = `id`       v = `isIntervalAppointment`
                    )->a( n = `text`     v = `Interval appointment`
                    )->a( n = `selected` v = client->_bind( d_interval )
                )->tag( `Label`
                    )->a( n = `text`     v = `Select person: `
                    )->a( n = `labelFor` v = `selectPerson`

                )->ele( `Select`
                    )->a( n = `id`             v = `selectPerson`
                    )->a( n = `forceSelection` v = `false`
                    )->a( n = `width`          v = `100%`
                    )->a( n = `items`          v = client->_bind( t_people )
                    )->a( n = `selectedKey`    v = client->_bind( d_person )

                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `{NAME}`
                        )->a( n = `text` v = `{NAME}`

                )->end(

                )->tag( `Label`
                    )->a( n = `text`     v = `Title: `
                    )->a( n = `labelFor` v = `inputTitle`
                )->tag( `Input`
                    )->a( n = `id`    v = `inputTitle`
                    )->a( n = `value` v = client->_bind( d_title )
                )->tag( `Label`
                    )->a( n = `text`     v = `Start date: `
                    )->a( n = `labelFor` v = `startDate`
                " handleCreateChange rejects an end date at or before the start
                )->tag( `DateTimePicker`
                    )->a( n = `id`             v = `startDate`
                    )->a( n = `displayFormat`  v = `short`
                    " the ORIGINAL binds no value at all - it works in Date objects
                    " through setDateValue/getDateValue - so the string binding is the
                    " port's own and the port owes the format. Without it the picker
                    " writes a LOCALE string back (measured: "Jan 10, 2017, 8:00:00 AM"),
                    " which breaks CREATE_CHANGE's `d_end <= d_start` string compare and
                    " lands a non-ISO value in t_appointments beside ISO neighbours
                    )->a( n = `valueFormat`    v = `yyyy-MM-dd'T'HH:mm:ss`
                    )->a( n = `required`       v = `true`
                    )->a( n = `value`          v = client->_bind( d_start )
                    )->a( n = `valueState`     v = client->_bind( d_start_state )
                    )->a( n = `valueStateText` v = `Start date should be before End date`
                    )->a( n = `change`         v = client->_event( `CREATE_CHANGE` )
                )->tag( `Label`
                    )->a( n = `text`     v = `End date: `
                    )->a( n = `labelFor` v = `endDate`
                )->tag( `DateTimePicker`
                    )->a( n = `id`            v = `endDate`
                    )->a( n = `displayFormat` v = `short`
                    " see startDate above - the compare is only meaningful while both
                    " sides stay lexicographically sortable ISO
                    )->a( n = `valueFormat`   v = `yyyy-MM-dd'T'HH:mm:ss`
                    )->a( n = `required`      v = `true`
                    )->a( n = `value`         v = client->_bind( d_end )
                    )->a( n = `change`        v = client->_event( `CREATE_CHANGE` )
                )->tag( `Label`
                    )->a( n = `text`     v = `More information: `
                    )->a( n = `labelFor` v = `inputInfo`
                )->tag( `Input`
                    )->a( n = `id`    v = `moreInfo`
                    )->a( n = `value` v = client->_bind( d_info ) ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `APPT_SELECT`.
        DATA(path) = client->get_event_arg( ).
        IF path IS INITIAL.
          " _handleGroupAppointments: a collapsed GROUP was clicked
          DATA(count)  = client->get_event_arg( 3 ).
          " whether the selected appointments differ in type is computed here, from
          " the bound `selected` flags - the client-side .some(function(a){...}) it
          " replaced is not in the UI5 expression grammar and threw
          DATA(first_type) = ``.
          DATA(differ)     = abap_false.
          LOOP AT t_people INTO DATA(person_sel).
            LOOP AT person_sel-t_appointments INTO DATA(appt_sel) WHERE selected = abap_true.
              IF first_type IS INITIAL.
                first_type = appt_sel-type.
              ELSEIF appt_sel-type <> first_type.
                differ = abap_true.
              ENDIF.
            ENDLOOP.
          ENDLOOP.
          client->message_toast_display(
              COND string( WHEN differ = abap_true
                           THEN |{ count } Appointments of different types selected|
                           ELSE |{ count } Appointments of the same { client->get_event_arg( 4 ) } selected| ) ).
        ELSEIF client->get_event_arg( 2 ) <> abap_true.
          client->popover_destroy( ).
        ELSE.
          SPLIT path AT `/` INTO TABLE DATA(parts).
          DELETE parts WHERE table_line IS INITIAL.
          sel_row   = parts[ 2 ].
          sel_index = parts[ lines( parts ) ].
          READ TABLE t_people INDEX sel_row + 1 INTO DATA(person).
          IF sy-subrc = 0 AND sel_index >= 0 AND sel_index < lines( person-t_appointments ).
            DATA(appointment) = person-t_appointments[ sel_index + 1 ].
            sel_title = appointment-title.
            sel_info  = appointment-info.
            sel_start = appointment-start_at.
            sel_end   = appointment-end_at.
            popup_details_display( ).
          ENDIF.
        ENDIF.

      WHEN `APPT_CREATE`.
        " handleAppointmentCreate opens the dialog on the calendar's start date
        d_mode        = `create`.
        d_person      = ``.
        d_interval    = abap_false.
        d_title       = ``.
        d_info        = ``.
        d_start       = start_date.
        d_end         = start_date.
        d_start_state = `None`.
        popup_create_display( ).

      WHEN `INTERVAL_SELECT`.
        " handleAppointmentAddWithContext keeps the clicked interval and row
        d_mode        = `create_with_context`.
        DATA(row_index) = CONV i( client->get_event_arg( 11 ) ).
        d_person      = COND #( WHEN row_index >= 0 AND row_index < lines( t_people )
                                THEN t_people[ row_index + 1 ]-name
                                ELSE `` ).
        d_interval    = abap_false.
        d_title       = ``.
        d_info        = ``.
        d_start       = iso_of( 1 ).
        d_end         = iso_of( 6 ).
        d_start_state = `None`.
        popup_create_display( ).

      WHEN `EDIT`.
        " handleEditButton closes the popover and opens the dialog on the row
        client->popover_destroy( ).
        d_mode        = `edit_appointment`.
        d_person      = COND #( WHEN sel_row >= 0 AND sel_row < lines( t_people )
                                THEN t_people[ sel_row + 1 ]-name
                                ELSE `` ).
        d_interval    = abap_false.
        d_title       = sel_title.
        d_info        = sel_info.
        d_start       = sel_start.
        d_end         = sel_end.
        d_start_state = `None`.
        popup_create_display( ).

      WHEN `DELETE`.
        " handleDeleteAppointment removes the appointment behind the popover
        READ TABLE t_people INDEX sel_row + 1 ASSIGNING FIELD-SYMBOL(<person>).
        IF sy-subrc = 0 AND sel_index >= 0 AND sel_index < lines( <person>-t_appointments ).
          DELETE <person>-t_appointments INDEX sel_index + 1.
        ENDIF.
        client->popover_destroy( ).

      WHEN `CREATE_CHANGE`.
        " _validateDateTimePicker: the end date has to be after the start date
        d_start_state = COND #( WHEN d_start IS NOT INITIAL AND d_end IS NOT INITIAL AND d_end <= d_start
                                THEN `Error`
                                ELSE `None` ).

      WHEN `DIALOG_SAVE`.
        IF d_start_state <> `Error`.
          DATA(target_row) = COND i( WHEN line_exists( t_people[ name = d_person ] )
                                     THEN line_index( t_people[ name = d_person ] ) - 1
                                     ELSE 0 ).
          IF d_mode = `edit_appointment`.
            appointment_edit( target_row ).
          ELSE.
            " _addNewAppointment appends to the picked person's appointments, or
            " to their interval HEADERS when the checkbox is set
            READ TABLE t_people INDEX target_row + 1 ASSIGNING FIELD-SYMBOL(<target>).
            IF sy-subrc = 0.
              IF d_interval = abap_true.
                INSERT VALUE #( title    = d_title
                                start_at = d_start
                                end_at   = d_end
                                type     = `Type01` ) INTO TABLE <target>-t_headers.
              ELSE.
                INSERT VALUE #( title    = d_title
                                info     = d_info
                                start_at = d_start
                                end_at   = d_end
                                type     = `Type01`
                                aria     = `Dialog` ) INTO TABLE <target>-t_appointments.
              ENDIF.
            ENDIF.
          ENDIF.
          client->popup_destroy( ).
        ENDIF.

      WHEN `DIALOG_CANCEL`.
        client->popup_destroy( ).

    ENDCASE.

  ENDMETHOD.


  METHOD appointment_edit.

    " _editAppointment rewrites the row in place, moving it to the picked owner
    " when the Select changed
    READ TABLE t_people INDEX sel_row + 1 ASSIGNING FIELD-SYMBOL(<source>).
    IF sy-subrc <> 0 OR sel_index < 0 OR sel_index >= lines( <source>-t_appointments ).
      RETURN.
    ENDIF.

    DATA(edited) = <source>-t_appointments[ sel_index + 1 ].
    edited-title    = d_title.
    edited-info     = d_info.
    edited-start_at = d_start.
    edited-end_at   = d_end.

    IF target_row = sel_row.
      <source>-t_appointments[ sel_index + 1 ] = edited.
      RETURN.
    ENDIF.

    DELETE <source>-t_appointments INDEX sel_index + 1.
    READ TABLE t_people INDEX target_row + 1 ASSIGNING FIELD-SYMBOL(<owner>).
    IF sy-subrc = 0.
      INSERT edited INTO TABLE <owner>-t_appointments.
    ENDIF.

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


  METHOD model_init.

    start_date    = `2017-01-15T08:00:00`.
    sel_row       = -1.
    sel_index     = -1.
    d_mode        = `create`.
    d_start_state = `None`.

    t_people = VALUE #(
      ( pic = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/John_Miller.png` name = `John Miller` role = `team member`
        t_appointments = VALUE #(
          ( start_at = `2017-01-08T08:30:00` end_at = `2017-01-08T09:30:00` title = `Meet Max Mustermann` type = `Type02` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-11T10:00:00` end_at = `2017-01-11T12:00:00` title = `Team meeting` info = `room 1` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-12T11:30:00` end_at = `2017-01-12T13:30:00` title = `Lunch` info = `canteen` type = `Type03` tentative = abap_true aria = `Dialog` )
          ( start_at = `2017-01-15T08:30:00` end_at = `2017-01-15T09:30:00` title = `Meet Max Mustermann` type = `Type02` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-15T10:00:00` end_at = `2017-01-15T12:00:00` title = `Team meeting` info = `room 1` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-15T11:30:00` end_at = `2017-01-15T13:30:00` title = `Lunch` info = `canteen` type = `Type03` tentative = abap_true aria = `Dialog` )
          ( start_at = `2017-01-15T13:30:00` end_at = `2017-01-15T17:30:00` title = `Discussion with clients` info = `online meeting` type = `Type02` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-16T04:00:00` end_at = `2017-01-16T22:30:00` title = `Discussion of the plan` info = `Online meeting` type = `Type04` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-18T08:30:00` end_at = `2017-01-18T09:30:00` title = `Meeting with the manager` type = `Type02` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-18T11:30:00` end_at = `2017-01-18T13:30:00` title = `Lunch` info = `canteen` type = `Type03` tentative = abap_true aria = `Dialog` )
          ( start_at = `2017-01-18T01:00:00` end_at = `2017-01-18T22:00:00` title = `Team meeting` info = `regular` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-21T00:30:00` end_at = `2017-01-21T23:30:00` title = `New Product` info = `room 105` type = `Type03` tentative = abap_true aria = `Dialog` )
          ( start_at = `2017-01-25T11:30:00` end_at = `2017-01-25T13:30:00` title = `Lunch` type = `Type01` tentative = abap_true aria = `Dialog` )
          ( start_at = `2017-01-29T10:00:00` end_at = `2017-01-29T12:00:00` title = `Team meeting` info = `room 1` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-30T08:30:00` end_at = `2017-01-30T09:30:00` title = `Meet Max Mustermann` type = `Type02` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-30T10:00:00` end_at = `2017-01-30T12:00:00` title = `Team meeting` info = `room 1` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-30T11:30:00` end_at = `2017-01-30T13:30:00` title = `Lunch` type = `Type03` tentative = abap_true aria = `Dialog` )
          ( start_at = `2017-01-30T13:30:00` end_at = `2017-01-30T17:30:00` title = `Discussion with clients` type = `Type02` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-31T10:00:00` end_at = `2017-01-31T11:30:00` title = `Discussion of the plan` info = `Online meeting` type = `Type04` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-02-03T08:30:00` end_at = `2017-02-13T09:30:00` title = `Meeting with the manager` type = `Type02` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-02-04T10:00:00` end_at = `2017-02-04T12:00:00` title = `Team meeting` info = `room 1` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-03-30T10:00:00` end_at = `2017-06-02T12:00:00` title = `Working out of the building` type = `Type07` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
        )
        t_headers = VALUE #(
          ( start_at = `2017-01-15T08:00:00` end_at = `2017-01-15T10:00:00` title = `Reminder`    type = `Type06` )
          ( start_at = `2017-01-15T17:00:00` end_at = `2017-01-15T19:00:00` title = `Reminder`    type = `Type06` )
          ( start_at = `2017-09-01T00:00:00` end_at = `2017-11-30T23:59:00` title = `New quarter` type = `Type10` )
          ( start_at = `2018-02-01T00:00:00` end_at = `2018-04-30T23:59:00` title = `New quarter` type = `Type10` )
        )
      )
      ( pic = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/Donna_Moore.jpg` name = `Donna Moore` role = `team member`
        t_appointments = VALUE #(
          ( start_at = `2017-01-10T18:00:00` end_at = `2017-01-10T19:10:00` title = `Discussion of the plan` info = `Online meeting` type = `Type04` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-09T10:00:00` end_at = `2017-01-13T12:00:00` title = `Workshop out of the country` type = `Type07` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-15T08:00:00` end_at = `2017-01-15T09:30:00` title = `Discussion of the plan` info = `Online meeting` type = `Type04` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-15T10:00:00` end_at = `2017-01-15T12:00:00` title = `Team meeting` info = `room 1` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-15T18:00:00` end_at = `2017-01-15T19:10:00` title = `Discussion of the plan` info = `Online meeting` type = `Type04` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-16T10:00:00` end_at = `2017-01-31T12:00:00` title = `Workshop out of the country` type = `Type07` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2018-01-01T00:00:00` end_at = `2018-03-31T23:59:00` title = `New quarter` type = `Type10` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-02-11T10:00:00` end_at = `2017-03-20T12:00:00` title = `Team collaboration` info = `room 1` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-04-01T10:00:00` end_at = `2017-05-01T12:00:00` title = `Workshop out of the country` type = `Type07` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-05-01T10:00:00` end_at = `2017-05-31T12:00:00` title = `Out of the office` type = `Type08` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-08-01T00:00:00` end_at = `2017-08-31T23:59:00` title = `Vacation` info = `out of office` type = `Type04` tentative = abap_false aria = `Dialog` )
        )
        t_headers = VALUE #(
          ( start_at = `2017-01-15T09:00:00` end_at = `2017-01-15T10:00:00` title = `Payment reminder` type = `Type06` )
          ( start_at = `2017-01-15T16:30:00` end_at = `2017-01-15T18:00:00` title = `Private appointment` type = `Type06` )
        )
      )
      ( pic = `sap-icon://employee` name = `Max Mustermann` role = `team member`
        t_appointments = VALUE #(
          ( start_at = `2017-01-15T08:30:00` end_at = `2017-01-15T09:30:00` title = `Meet John Miller` type = `Type02` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-15T10:00:00` end_at = `2017-01-15T12:00:00` title = `Team meeting` info = `room 1` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-15T13:00:00` end_at = `2017-01-15T16:00:00` title = `Discussion with clients` info = `online` type = `Type02` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-16T00:00:00` end_at = `2017-01-16T23:59:00` title = `Vacation` info = `out of office` type = `Type08` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-17T01:00:00` end_at = `2017-01-18T22:00:00` title = `Workshop` info = `regular` type = `Type08` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-19T08:30:00` end_at = `2017-01-19T18:30:00` title = `Meet John Doe` type = `Type08` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-19T10:00:00` end_at = `2017-01-19T16:00:00` title = `Team meeting` info = `room 1` type = `Type08` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-19T07:00:00` end_at = `2017-01-19T17:30:00` title = `Discussion with clients` type = `Type08` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-20T00:00:00` end_at = `2017-01-20T23:59:00` title = `Vacation` info = `out of office` type = `Type08` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-22T07:00:00` end_at = `2017-01-27T17:30:00` title = `Discussion with clients` info = `out of office` type = `Type08` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-03-13T09:00:00` end_at = `2017-03-17T10:00:00` title = `Payment week` type = `Type08` aria = `Dialog` )
          ( start_at = `2017-04-10T00:00:00` end_at = `2017-06-16T23:59:00` title = `Vacation` info = `out of office` type = `Type04` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-08-01T00:00:00` end_at = `2017-10-31T23:59:00` title = `New quarter` type = `Type10` tentative = abap_false aria = `Dialog` )
        )
        t_headers = VALUE #(
          ( start_at = `2017-01-16T00:00:00` end_at = `2017-01-16T23:59:00` title = `Private` type = `Type05` )
        )
      ) ).

  ENDMETHOD.

ENDCLASS.
