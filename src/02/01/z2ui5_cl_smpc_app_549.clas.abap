" @keywords singleplanningcalendar single planning calendar sap.m vbox overflowtoolbar label select listitem toolbarseparator togglebutton
" @summary This sample demonstrates most of the features available for the SinglePlanningCalendar control.
CLASS z2ui5_cl_smpc_app_549 DEFINITION PUBLIC.

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
             text TYPE string,
             type TYPE string,
           END OF ty_s_type.
    TYPES ty_t_type TYPE STANDARD TABLE OF ty_s_type WITH EMPTY KEY.

    DATA t_appointments TYPE ty_t_appointment.
    DATA t_types        TYPE ty_t_type.
    DATA start_date     TYPE string.

    " the original keeps these in a settings> model; abap2UI5 keeps one default
    " model, so they are fields here
    DATA sticky_mode TYPE string.
    DATA enable_dnd  TYPE abap_bool.
    DATA enable_new  TYPE abap_bool.
    DATA enable_size TYPE abap_bool.
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
    METHODS popup_legend_display.
    METHODS all_day_hours.
    METHODS type_text
      IMPORTING type          TYPE string
      RETURNING VALUE(result) TYPE string.
    METHODS iso_of
      IMPORTING first         TYPE i
      RETURNING VALUE(result) TYPE string.
    METHODS at_hour
      IMPORTING iso           TYPE string
                hour          TYPE i
      RETURNING VALUE(result) TYPE string.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_549 IMPLEMENTATION.

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

            )->ele( `OverflowToolbar`
                )->a( n = `height` v = `100%`
                )->a( n = `width`  v = `100%`

                )->tag( `Label`
                    )->a( n = `text`     v = `Select sticky mode`
                    )->a( n = `labelFor` v = `stickyModeSelect`

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

                )->tag( `ToolbarSeparator`
                )->tag( `Label`
                    )->a( n = `text` v = `Appointment Actions : `
                )->tag( `ToggleButton`
                    )->a( n = `text`    v = `Drag and Drop`
                    )->a( n = `id`      v = `enableAppointmentsDragAndDrop`
                    )->a( n = `pressed` v = client->_bind( enable_dnd )
                )->tag( `ToggleButton`
                    )->a( n = `text`    v = `Drag and Create`
                    )->a( n = `id`      v = `enableAppointmentsCreate`
                    )->a( n = `pressed` v = client->_bind( enable_new )
                )->tag( `ToggleButton`
                    )->a( n = `text`    v = `Resize`
                    )->a( n = `id`      v = `enableAppointmentsResize`
                    )->a( n = `pressed` v = client->_bind( enable_size )

            )->end(

            )->ele( `SinglePlanningCalendar`
                )->a( n = `id`                            v = `SPC1`
                )->a( n = `class`                         v = `sapUiSmallMarginTop`
                )->a( n = `title`                         v = `My Calendar`
                " handleViewChange toasts a constant text - composed on the client
                )->a( n = `viewChange`                    v = client->follow_up_action(
                          val   = client->cs_event-control_global
                          t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `'viewChange' event fired.` ) ) )
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
                )->a( n = `startDateChange`               v = client->_event( val = `START_DATE_CHANGE` arg = `${$parameters>/date}.toString()` )
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
                " handleMoreLinkPress switches to the Day view on the clicked date
                )->a( n = `moreLinkPress`                 v = client->_event(
                          val   = `MORE_LINK`
                          t_arg = VALUE #(
                            ( `${$parameters>/date}.getFullYear()` )
                            ( `${$parameters>/date}.getMonth() + 1` )
                            ( `${$parameters>/date}.getDate()` ) ) )
                )->a( n = `startDate`                     v = |\{ path: '{ client->_bind_path( start_date ) }', formatter: 'Formatter.DateCreateObject' \}|
                )->a( n = `enableAppointmentsDragAndDrop` v = client->_bind( enable_dnd )
                )->a( n = `enableAppointmentsResize`      v = client->_bind( enable_size )
                )->a( n = `enableAppointmentsCreate`      v = client->_bind( enable_new )
                )->a( n = `stickyMode`                    v = client->_bind( sticky_mode )
                )->a( n = `appointments`                  v = client->_bind( t_appointments )

                )->ele( `actions`
                    )->tag( `Button`
                        )->a( n = `id`      v = `addNewAppointment`
                        )->a( n = `text`    v = `Create`
                        )->a( n = `press`   v = client->_event( `APPT_CREATE` )
                        )->a( n = `tooltip` v = `Add new appointment`
                    )->tag( `Button`
                        )->a( n = `id`           v = `legendButton`
                        )->a( n = `icon`         v = `sap-icon://legend`
                        )->a( n = `press`        v = client->_event( `OPEN_LEGEND` )
                        )->a( n = `tooltip`      v = `Open SinglePlanningCalendar legend`
                        )->a( n = `ariaHasPopup` v = `Dialog`

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
                    )->tag( `SinglePlanningCalendarMonthView`
                        )->a( n = `key`   v = `MonthView`
                        )->a( n = `title` v = `Month`

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

    client->popover_display( xml = popup->stringify( ) by_id = `SPC1` ).

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
                    " all four pickers carry an explicit ISO valueFormat. The original
                    " never binds value at all - it sets dateValue imperatively - so the
                    " port's string binding needs the format pinned: with none, a
                    " DateTimePicker still READS the model's ISO string (DateFormat falls
                    " back to ISO) but writes a LOCALE string back ("Jul 12, 2018, 2:30:00 PM"),
                    " and a DatePicker cannot read it at all - it showed the raw
                    " "2018-07-09T09:00:00" with no date value and wrote back "7/12/18".
                    " With the format pinned both pairs read and write the same 19-character
                    " ISO string, which is what makes the ALL_DAY hour rewrite below safe
                    " (headless probe, 2026-08-26)
                    )->tag( `DateTimePicker`
                        )->a( n = `id`          v = `DTPStartDate`
                        )->a( n = `required`    v = `true`
                        )->a( n = `visible`     v = |\{= !${ client->_bind( all_day ) } \}|
                        )->a( n = `valueFormat` v = `yyyy-MM-dd'T'HH:mm:ss`
                        )->a( n = `value`       v = client->_bind( sel_start )
                    )->tag( `DatePicker`
                        )->a( n = `id`          v = `DPStartDate`
                        )->a( n = `required`    v = `true`
                        )->a( n = `visible`     v = |\{= ${ client->_bind( all_day ) } \}|
                        )->a( n = `valueFormat` v = `yyyy-MM-dd'T'HH:mm:ss`
                        )->a( n = `value`       v = client->_bind( sel_start )
                    )->tag( `Label`
                        )->a( n = `text`     v = `To`
                        )->a( n = `labelFor` v = `endDate`
                    )->tag( `DateTimePicker`
                        )->a( n = `id`          v = `DTPEndDate`
                        )->a( n = `required`    v = `true`
                        )->a( n = `visible`     v = |\{= !${ client->_bind( all_day ) } \}|
                        )->a( n = `valueFormat` v = `yyyy-MM-dd'T'HH:mm:ss`
                        )->a( n = `value`       v = client->_bind( sel_end )
                    )->tag( `DatePicker`
                        )->a( n = `id`          v = `DPEndDate`
                        )->a( n = `required`    v = `true`
                        )->a( n = `visible`     v = |\{= ${ client->_bind( all_day ) } \}|
                        )->a( n = `valueFormat` v = `yyyy-MM-dd'T'HH:mm:ss`
                        )->a( n = `value`       v = client->_bind( sel_end )
                    " handleCheckBoxSelect rewrites the hours, it does not only swap
                    " which picker pair is visible - so the select is wired
                    )->tag( `CheckBox`
                        )->a( n = `id`       v = `allDay`
                        )->a( n = `text`     v = `All-day`
                        )->a( n = `selected` v = client->_bind( all_day )
                        )->a( n = `select`   v = client->_event( `ALL_DAY` )
                    )->tag( `Label`
                        )->a( n = `text`     v = `Type`
                        )->a( n = `labelFor` v = `appType`

                    )->ele( `Select`
                        )->a( n = `id`          v = `appType`
                        )->a( n = `items`       v = client->_bind( t_types )
                        )->a( n = `selectedKey` v = client->_bind( sel_type )

                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `{TYPE}`
                            )->a( n = `text` v = `{TEXT}` ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD popup_legend_display.

    DATA(popup) = z2ui5_cl_ui5_view_builder=>factory( ).

    popup->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:u`    v = `sap.ui.unified`

        )->ele( `ResponsivePopover`
            )->a( n = `id`         v = `legendPopover`
            )->a( n = `title`      v = `Legend`
            )->a( n = `placement`  v = `Bottom`
            )->a( n = `showHeader` v = `true`

            )->ele( `PlanningCalendarLegend`
                )->a( n = `appointmentItems` v = |\{ path: '{ client->_bind_path( t_types ) }', templateShareable: true \}|

                )->ele( `appointmentItems`
                    )->tag( n = `CalendarLegendItem` ns = `u`
                        )->a( n = `text`    v = `{TEXT}`
                        )->a( n = `type`    v = `{TYPE}`
                        )->a( n = `tooltip` v = `{TEXT}` ).

    client->popover_display( xml = popup->stringify( ) by_id = `legendButton` ).

  ENDMETHOD.


  METHOD on_event.

    DATA day TYPE string.

    CASE client->get_event( ).

      WHEN `APPT_SELECT`.
        " handleAppointmentSelect opens the details popover on the picked
        " appointment, and closes it again when the appointment is deselected
        DATA(path) = client->get_event_arg( ).
        IF path IS INITIAL OR client->get_event_arg( 2 ) <> abap_true.
          client->popover_destroy( ).
        ELSE.
          SPLIT path AT `/` INTO TABLE DATA(parts).
          DELETE parts WHERE table_line IS INITIAL.
          sel_index = parts[ lines( parts ) ].
          IF sel_index >= 0 AND sel_index < lines( t_appointments ).
            DATA(appointment) = t_appointments[ sel_index + 1 ].
            sel_title   = appointment-title.
            sel_text    = appointment-text.
            sel_type    = appointment-type.
            sel_start   = appointment-start_at.
            sel_end     = appointment-end_at.
            sel_typetxt = type_text( appointment-type ).
            " an appointment that starts and ends at midnight is an all-day one
            " (CP, not substring( ): a cleared picker sends an empty value and
            " an offset read would dump on it)
            all_day     = xsdbool( sel_start CP `*T00:00:00` AND sel_end CP `*T00:00:00` ).
            popup_details_display( ).
          ENDIF.
        ENDIF.

      WHEN `EDIT`.
        " handleEditButton closes the popover and opens the dialog on the same row -
        " the original comments that the Popover HAS to be closed before the Dialog
        " opens, so the close is not optional
        client->popover_destroy( ).
        dialog_title = `Edit appointment`.
        popup_modify_display( ).

      WHEN `DELETE`.
        " handlePopoverDeleteButton removes the appointment behind the popover
        IF sel_index >= 0 AND sel_index < lines( t_appointments ).
          DELETE t_appointments INDEX sel_index + 1.
        ENDIF.
        client->popover_destroy( ).

      WHEN `APPT_CREATE` OR `HEADER_DATE`.
        " _createInitialDialogValues seeds the dialog at the default 9 - 10 hours
        " of the picked day (or of the calendar's own start date)
        " Written as IF/ELSE rather than COND: the transpiled backend HOISTS the
        " branch expressions out of a COND and evaluates them BOTH, so the two
        " get_event_arg( ) reads below ran for APPT_CREATE too - a wire that
        " carries no arguments at all - and the missing row asserted instead of
        " returning initial, so every Create press 500'd (e2e-caught 2026-08-22,
        " the same shape as app 609, which was derived from this port)
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
                          aria     = `None`
                          start_at = sel_start
                          end_at   = sel_end ) INTO TABLE t_appointments.
        ENDIF.
        client->popup_destroy( ).

      WHEN `ALL_DAY`.
        " handleCheckBoxSelect does more than swap which picker pair is visible:
        " ticking All-day sets both times to midnight (_setHoursToZero) and
        " unticking puts them back on the default hours 9 and 10
        " (_getDefaultAppointmentStartHour / _getDefaultAppointmentEndHour),
        " then copies both into the pair that has just become visible. The
        " CheckBox writes its selected state into all_day BEFORE it fires
        " select (sap.m.CheckBox.ontap), so the flag already carries the new value
        all_day_hours( ).

      WHEN `DIALOG_CANCEL`.
        client->popup_destroy( ).

      WHEN `OPEN_LEGEND`.
        popup_legend_display( ).

      WHEN `START_DATE_CHANGE`.
        client->message_toast_display(
            |'startDateChange' event fired.\n\nNew start date is { client->get_event_arg( ) }| ).

      WHEN `MORE_LINK`.
        " handleMoreLinkPress switches to the Day view on the clicked date
        start_date = |{ client->get_event_arg( ) }| &&
                     |-{ CONV i( client->get_event_arg( 2 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
                     |-{ CONV i( client->get_event_arg( 3 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }T00:00:00|.
        " the switch to the Day view is lost: SinglePlanningCalendar.selectedView
        " is an ASSOCIATION, which neither binds nor has a whitelisted setter

      WHEN `APPT_DROP`.
        DATA(drop_path) = client->get_event_arg( 11 ).
        DATA(is_copy)   = xsdbool( client->get_event_arg( 12 ) = `X` ).
        SPLIT drop_path AT `/` INTO TABLE DATA(drop_parts).
        DELETE drop_parts WHERE table_line IS INITIAL.
        DATA(drop_index) = CONV i( drop_parts[ lines( drop_parts ) ] ).
        IF drop_index >= 0 AND drop_index < lines( t_appointments ).
          DATA(dropped) = t_appointments[ drop_index + 1 ].
          DATA(drop_title) = dropped-title.
          dropped-start_at = iso_of( 1 ).
          dropped-end_at   = iso_of( 6 ).
          IF is_copy = abap_true.
            INSERT dropped INTO TABLE t_appointments.
          ELSE.
            t_appointments[ drop_index + 1 ] = dropped.
          ENDIF.
          client->message_toast_display(
              |Appointment with title \n'{ drop_title }'\n has been { COND string( WHEN is_copy = abap_true THEN `create` ELSE `moved` ) }| ).
        ENDIF.

      WHEN `APPT_RESIZE`.
        DATA(res_path) = client->get_event_arg( 11 ).
        SPLIT res_path AT `/` INTO TABLE DATA(res_parts).
        DELETE res_parts WHERE table_line IS INITIAL.
        DATA(res_index) = CONV i( res_parts[ lines( res_parts ) ] ).
        IF res_index >= 0 AND res_index < lines( t_appointments ).
          DATA(res_title) = t_appointments[ res_index + 1 ]-title.
          t_appointments[ res_index + 1 ]-start_at = iso_of( 1 ).
          t_appointments[ res_index + 1 ]-end_at   = iso_of( 6 ).
          client->message_toast_display( |Appointment with title \n'{ res_title }'\n has been resized| ).
        ENDIF.

      WHEN `APPT_CREATE_DND`.
        " type must be seeded: an unset ABAP field reaches CalendarDayType as
        " "", which is not a member - validateProperty throws and the binding
        " update takes the view down (found by the new linter rule)
        INSERT VALUE #( title    = `New Appointment`
                        type     = `Type01`
                        aria     = `None`
                        start_at = iso_of( 1 )
                        end_at   = iso_of( 6 ) ) INTO TABLE t_appointments.
        client->message_toast_display( |Appointment with title \n'New Appointment'\n has been created| ).

    ENDCASE.

  ENDMETHOD.


  METHOD all_day_hours.

    " _setHoursToZero for an all-day appointment, the sample's own default
    " hours 9 and 10 for a timed one - the rewrite handleCheckBoxSelect does
    " on top of swapping which picker pair is visible
    IF all_day = abap_true.
      sel_start = at_hour( iso = sel_start hour = 0 ).
      sel_end   = at_hour( iso = sel_end   hour = 0 ).
    ELSE.
      sel_start = at_hour( iso = sel_start hour = 9 ).
      sel_end   = at_hour( iso = sel_end   hour = 10 ).
    ENDIF.

  ENDMETHOD.


  METHOD type_text.

    " _typeFormatter: the legend text for the type key, or the key itself
    result = VALUE #( t_types[ type = type ]-text DEFAULT type ).

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


  METHOD at_hour.

    " the same ISO string with its time part rewritten to the given full hour -
    " _setHoursToZero and the two default-hour helpers of the original. The
    " pickers carry valueFormat yyyy-MM-dd'T'HH:mm:ss, so every value that
    " travels is 19 characters; a cleared picker sends an empty one and is
    " left untouched rather than turned into a date-less time
    IF strlen( iso ) < 10.
      result = iso.
      RETURN.
    ENDIF.
    result = |{ substring( val = iso len = 10 ) }T{ hour WIDTH = 2 ALIGN = RIGHT PAD = '0' }:00:00|.

  ENDMETHOD.


  METHOD model_init.

    start_date  = `2018-07-09T00:00:00`.
    sticky_mode = `None`.
    " the original seeds all three true (Page.controller.js:323) - these are the
    " behaviours the sample exists to show, and the three ToggleButtons start pressed
    enable_dnd  = abap_true.
    enable_new  = abap_true.
    enable_size = abap_true.
    all_day     = abap_false.
    sel_index   = -1.

    t_appointments = VALUE #(
      ( title = `Meet John Miller` type = `Type05` start_at = `2018-07-08T05:00:00` end_at = `2018-07-08T06:00:00` aria = `Dialog` )
      ( title = `Discussion of the plan` type = `Type01` start_at = `2018-07-08T06:00:00` end_at = `2018-07-08T07:09:00` aria = `Dialog` )
      ( title = `Lunch` text = `canteen` type = `Type05` start_at = `2018-07-08T07:00:00` end_at = `2018-07-08T08:00:00` aria = `Dialog` )
      ( title = `New Product` text = `room 105` type = `Type01` icon = `sap-icon://meeting-room` start_at = `2018-07-08T08:00:00` end_at = `2018-07-08T09:00:00` aria = `Dialog` )
      ( title = `Team meeting` text = `Regular` type = `Type01` icon = `sap-icon://home` start_at = `2018-07-08T09:09:00` end_at = `2018-07-08T10:00:00` aria = `Dialog` )
      ( title = `Discussion with clients regarding our new purpose` text = `room 234 and Online meeting` type = `Type08` icon = `sap-icon://home` start_at = `2018-07-08T10:00:00` end_at = `2018-07-08T11:30:00` aria = `Dialog` )
      ( title = `Discussion of the plan` text = `Online meeting with partners and colleagues` type = `Type01` icon = `sap-icon://home` start_at = `2018-07-08T11:30:00` end_at = `2018-07-08T13:00:00` aria = `Dialog` tentative = abap_true )
      ( title = `Discussion with clients` type = `Type08` icon = `sap-icon://home` start_at = `2018-07-08T12:30:00` end_at = `2018-07-08T13:15:00` aria = `Dialog` )
      ( title = `Meeting with the manager` type = `Type03` start_at = `2018-07-08T13:09:00` end_at = `2018-07-08T13:09:00` aria = `Dialog` )
      ( title = `Meeting with the HR` type = `Type03` start_at = `2018-07-08T14:00:00` end_at = `2018-07-08T14:15:00` aria = `Dialog` )
      ( title = `Call with customer` type = `Type08` start_at = `2018-07-08T14:15:00` end_at = `2018-07-08T14:30:00` aria = `Dialog` )
      ( title = `Prepare documentation` text = `At my desk` type = `Type03` icon = `sap-icon://meeting-room` start_at = `2018-07-08T14:10:00` end_at = `2018-07-08T15:30:00` aria = `Dialog` )
      ( title = `Meeting with the manager` type = `Type03` start_at = `2018-07-09T06:30:00` end_at = `2018-07-09T07:00:00` aria = `Dialog` )
      ( title = `Lunch` type = `Type05` start_at = `2018-07-09T07:00:00` end_at = `2018-07-09T08:00:00` aria = `Dialog` )
      ( title = `Team meeting` text = `online` type = `Type01` start_at = `2018-07-09T08:00:00` end_at = `2018-07-09T09:00:00` aria = `Dialog` )
      ( title = `Discussion with clients for the new release dates` text = `Online meeting` type = `Type08` start_at = `2018-07-09T09:00:00` end_at = `2018-07-09T10:00:00` aria = `Dialog` )
      ( title = `Team meeting` text = `room 5` type = `Type01` start_at = `2018-07-09T11:00:00` end_at = `2018-07-09T14:00:00` aria = `Dialog` )
      ( title = `Daily standup meeting` type = `Type01` start_at = `2018-07-09T09:00:00` end_at = `2018-07-09T09:15:00` aria = `Dialog` )
      ( title = `Private meeting` type = `Type03` start_at = `2018-07-11T09:09:00` end_at = `2018-07-11T09:20:00` aria = `Dialog` )
      ( title = `Private meeting` type = `Type03` start_at = `2018-07-10T06:00:00` end_at = `2018-07-10T07:00:00` aria = `Dialog` )
      ( title = `Meeting with the manager` type = `Type03` start_at = `2018-07-10T15:00:00` end_at = `2018-07-10T15:30:00` aria = `Dialog` )
      ( title = `Meet John Doe` type = `Type05` icon = `sap-icon://home` start_at = `2018-07-11T07:00:00` end_at = `2018-07-11T07:30:00` aria = `Dialog` )
      ( title = `Team meeting` text = `online` type = `Type01` start_at = `2018-07-11T08:00:00` end_at = `2018-07-11T09:30:00` aria = `Dialog` )
      ( title = `Workshop` type = `Type05` start_at = `2018-07-11T08:30:00` end_at = `2018-07-11T12:00:00` aria = `Dialog` )
      ( title = `Team collaboration` type = `Type01` start_at = `2018-07-12T04:00:00` end_at = `2018-07-12T12:30:00` aria = `Dialog` )
      ( title = `Out of the office` type = `Type05` start_at = `2018-07-12T15:00:00` end_at = `2018-07-12T19:30:00` aria = `Dialog` )
      ( title = `Working out of the building` type = `Type05` start_at = `2018-07-12T20:00:00` end_at = `2018-07-12T21:30:00` aria = `Dialog` )
      ( title = `Vacation` text = `out of office` type = `Type09` start_at = `2018-07-11T12:00:00` end_at = `2018-07-13T14:00:00` aria = `Dialog` )
      ( title = `Reminder` type = `Type09` start_at = `2018-07-12T00:00:00` end_at = `2018-07-13T00:00:00` aria = `Dialog` )
      ( title = `Team collaboration` type = `Type01` start_at = `2018-07-06T00:00:00` end_at = `2018-07-16T00:00:00` aria = `Dialog` )
      ( title = `Workshop out of the country` type = `Type05` start_at = `2018-07-14T00:00:00` end_at = `2018-07-20T00:00:00` aria = `Dialog` )
      ( title = `Payment reminder` type = `Type09` start_at = `2018-07-07T00:00:00` end_at = `2018-07-08T00:00:00` aria = `Dialog` )
      ( title = `Meeting with the manager` type = `Type03` start_at = `2018-07-06T09:00:00` end_at = `2018-07-06T10:00:00` aria = `Dialog` )
      ( title = `Daily standup meeting` type = `Type01` start_at = `2018-07-07T10:00:00` end_at = `2018-07-07T10:30:00` aria = `Dialog` )
      ( title = `Private meeting` type = `Type03` start_at = `2018-07-06T11:30:00` end_at = `2018-07-06T12:00:00` aria = `Dialog` )
      ( title = `Lunch` type = `Type05` start_at = `2018-07-06T12:00:00` end_at = `2018-07-06T13:00:00` aria = `Dialog` )
      ( title = `Discussion of the plan` type = `Type01` start_at = `2018-07-16T11:00:00` end_at = `2018-07-16T12:00:00` aria = `Dialog` )
      ( title = `Lunch` text = `canteen` type = `Type05` start_at = `2018-07-16T12:00:00` end_at = `2018-07-16T13:00:00` aria = `Dialog` )
      ( title = `Team meeting` text = `room 200` type = `Type01` icon = `sap-icon://meeting-room` start_at = `2018-07-16T16:00:00` end_at = `2018-07-16T17:00:00` aria = `Dialog` )
      ( title = `Discussion with clients` text = `Online meeting` type = `Type08` icon = `sap-icon://home` start_at = `2018-07-17T15:30:00` end_at = `2018-07-17T16:30:00` aria = `Dialog` )
    ).

    t_types = VALUE #(
      ( text = `Team Meeting`    type = `Type01` )
      ( text = `Personal`        type = `Type05` )
      ( text = `Discussions`     type = `Type08` )
      ( text = `Out of office`   type = `Type09` )
      ( text = `Private meeting` type = `Type03` )
    ).

  ENDMETHOD.

ENDCLASS.
