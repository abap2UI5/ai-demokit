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
    TYPES ty_t_appointment TYPE STANDARD TABLE OF ty_s_appointment WITH DEFAULT KEY.
    TYPES: BEGIN OF ty_s_type,
             text TYPE string,
             type TYPE string,
           END OF ty_s_type.
    TYPES ty_t_type TYPE STANDARD TABLE OF ty_s_type WITH DEFAULT KEY.

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
    DATA temp4 TYPE string_table.
    DATA temp5 TYPE string_table.
    DATA temp6 TYPE string_table.
    DATA temp7 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " the calendar date properties are typed "object" and demand a real JS Date;
    " the model keeps ISO strings and Formatter.DateCreateObject converts them
    " the drag, resize and create wires carry the interval's LOCAL date parts
    " (a UTC toISOString( ) would shift the day)
    
    CLEAR temp1.
    INSERT `MESSAGE_TOAST` INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    INSERT `'viewChange' event fired.` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `${$parameters>/appointment} ? ${$parameters>/appointment}.getBindingContext().getPath() : ''` INTO TABLE temp2.
    INSERT `${$parameters>/appointment} ? ${$parameters>/appointment}.getSelected() : false` INTO TABLE temp2.
    
    CLEAR temp3.
    INSERT `${$parameters>/date}.getFullYear()` INTO TABLE temp3.
    INSERT `${$parameters>/date}.getMonth() + 1` INTO TABLE temp3.
    INSERT `${$parameters>/date}.getDate()` INTO TABLE temp3.
    
    CLEAR temp4.
    INSERT `${$parameters>/startDate}.getFullYear()` INTO TABLE temp4.
    INSERT `${$parameters>/startDate}.getMonth() + 1` INTO TABLE temp4.
    INSERT `${$parameters>/startDate}.getDate()` INTO TABLE temp4.
    INSERT `${$parameters>/startDate}.getHours()` INTO TABLE temp4.
    INSERT `${$parameters>/startDate}.getMinutes()` INTO TABLE temp4.
    INSERT `${$parameters>/endDate}.getFullYear()` INTO TABLE temp4.
    INSERT `${$parameters>/endDate}.getMonth() + 1` INTO TABLE temp4.
    INSERT `${$parameters>/endDate}.getDate()` INTO TABLE temp4.
    INSERT `${$parameters>/endDate}.getHours()` INTO TABLE temp4.
    INSERT `${$parameters>/endDate}.getMinutes()` INTO TABLE temp4.
    INSERT `${$parameters>/appointment}.getBindingContext().getPath()` INTO TABLE temp4.
    INSERT `${$parameters>/copy} ? 'X' : ''` INTO TABLE temp4.
    
    CLEAR temp5.
    INSERT `${$parameters>/startDate}.getFullYear()` INTO TABLE temp5.
    INSERT `${$parameters>/startDate}.getMonth() + 1` INTO TABLE temp5.
    INSERT `${$parameters>/startDate}.getDate()` INTO TABLE temp5.
    INSERT `${$parameters>/startDate}.getHours()` INTO TABLE temp5.
    INSERT `${$parameters>/startDate}.getMinutes()` INTO TABLE temp5.
    INSERT `${$parameters>/endDate}.getFullYear()` INTO TABLE temp5.
    INSERT `${$parameters>/endDate}.getMonth() + 1` INTO TABLE temp5.
    INSERT `${$parameters>/endDate}.getDate()` INTO TABLE temp5.
    INSERT `${$parameters>/endDate}.getHours()` INTO TABLE temp5.
    INSERT `${$parameters>/endDate}.getMinutes()` INTO TABLE temp5.
    INSERT `${$parameters>/appointment}.getBindingContext().getPath()` INTO TABLE temp5.
    
    CLEAR temp6.
    INSERT `${$parameters>/startDate}.getFullYear()` INTO TABLE temp6.
    INSERT `${$parameters>/startDate}.getMonth() + 1` INTO TABLE temp6.
    INSERT `${$parameters>/startDate}.getDate()` INTO TABLE temp6.
    INSERT `${$parameters>/startDate}.getHours()` INTO TABLE temp6.
    INSERT `${$parameters>/startDate}.getMinutes()` INTO TABLE temp6.
    INSERT `${$parameters>/endDate}.getFullYear()` INTO TABLE temp6.
    INSERT `${$parameters>/endDate}.getMonth() + 1` INTO TABLE temp6.
    INSERT `${$parameters>/endDate}.getDate()` INTO TABLE temp6.
    INSERT `${$parameters>/endDate}.getHours()` INTO TABLE temp6.
    INSERT `${$parameters>/endDate}.getMinutes()` INTO TABLE temp6.
    
    CLEAR temp7.
    INSERT `${$parameters>/date}.getFullYear()` INTO TABLE temp7.
    INSERT `${$parameters>/date}.getMonth() + 1` INTO TABLE temp7.
    INSERT `${$parameters>/date}.getDate()` INTO TABLE temp7.
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
                          t_arg = temp1 )
                )->a( n = `appointmentSelect`             v = client->_event(
                          val   = `APPT_SELECT`
                          t_arg = temp2 )
                )->a( n = `headerDateSelect`              v = client->_event(
                          val   = `HEADER_DATE`
                          t_arg = temp3 )
                " handleStartDateChange names the new start date in a toast
                )->a( n = `startDateChange`               v = client->_event( val = `START_DATE_CHANGE` arg = `${$parameters>/date}.toString()` )
                )->a( n = `appointmentDrop`               v = client->_event(
                          val   = `APPT_DROP`
                          t_arg = temp4 )
                )->a( n = `appointmentResize`             v = client->_event(
                          val   = `APPT_RESIZE`
                          t_arg = temp5 )
                )->a( n = `appointmentCreate`             v = client->_event(
                          val   = `APPT_CREATE_DND`
                          t_arg = temp6 )
                " handleMoreLinkPress switches to the Day view on the clicked date
                )->a( n = `moreLinkPress`                 v = client->_event(
                          val   = `MORE_LINK`
                          t_arg = temp7 )
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

    DATA popup TYPE REF TO z2ui5_cl_ui5_view_builder.
    popup = z2ui5_cl_ui5_view_builder=>factory( ).

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

    DATA popup TYPE REF TO z2ui5_cl_ui5_view_builder.
    popup = z2ui5_cl_ui5_view_builder=>factory( ).

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

    DATA popup TYPE REF TO z2ui5_cl_ui5_view_builder.
    popup = z2ui5_cl_ui5_view_builder=>factory( ).

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
        DATA path TYPE string.
          TYPES temp1 TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
DATA parts TYPE temp1.
          DATA temp3 LIKE LINE OF parts.
          DATA temp4 LIKE sy-tabix.
            DATA appointment LIKE LINE OF t_appointments.
            DATA temp6 LIKE LINE OF t_appointments.
            DATA temp8 LIKE sy-tabix.
            DATA temp33 TYPE xsdboolean.
          DATA temp5 TYPE i.
          DATA temp10 TYPE i.
          FIELD-SYMBOLS <temp6> LIKE LINE OF t_appointments.
          DATA temp7 LIKE sy-tabix.
          FIELD-SYMBOLS <temp8> LIKE LINE OF t_appointments.
          DATA temp9 LIKE sy-tabix.
          FIELD-SYMBOLS <temp10> LIKE LINE OF t_appointments.
          DATA temp11 LIKE sy-tabix.
          FIELD-SYMBOLS <temp12> LIKE LINE OF t_appointments.
          DATA temp13 LIKE sy-tabix.
          FIELD-SYMBOLS <temp14> LIKE LINE OF t_appointments.
          DATA temp15 LIKE sy-tabix.
          DATA temp16 TYPE z2ui5_cl_smpc_app_549=>ty_s_appointment.
        DATA temp17 TYPE i.
        DATA temp12 TYPE i.
        DATA drop_path TYPE string.
        DATA is_copy TYPE abap_bool.
        DATA temp34 TYPE xsdboolean.
        TYPES temp2 TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
DATA drop_parts TYPE temp2.
        DATA temp18 TYPE i.
        DATA temp14 LIKE LINE OF drop_parts.
        DATA temp19 LIKE sy-tabix.
        DATA drop_index LIKE temp18.
          DATA dropped LIKE LINE OF t_appointments.
          DATA temp23 LIKE LINE OF t_appointments.
          DATA temp25 LIKE sy-tabix.
          DATA drop_title LIKE dropped-title.
            FIELD-SYMBOLS <temp19> LIKE LINE OF t_appointments.
            DATA temp20 LIKE sy-tabix.
          DATA temp21 TYPE string.
        DATA res_path TYPE string.
        TYPES temp32 TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
DATA res_parts TYPE temp32.
        DATA temp22 TYPE i.
        DATA temp28 LIKE LINE OF res_parts.
        DATA temp29 LIKE sy-tabix.
        DATA res_index LIKE temp22.
          DATA res_title TYPE z2ui5_cl_smpc_app_549=>ty_s_appointment-title.
          DATA temp30 LIKE LINE OF t_appointments.
          DATA temp31 LIKE sy-tabix.
          FIELD-SYMBOLS <temp23> LIKE LINE OF t_appointments.
          DATA temp24 LIKE sy-tabix.
          FIELD-SYMBOLS <temp25> LIKE LINE OF t_appointments.
          DATA temp26 LIKE sy-tabix.
        DATA temp27 TYPE z2ui5_cl_smpc_app_549=>ty_s_appointment.

    CASE client->get_event( ).

      WHEN `APPT_SELECT`.
        " handleAppointmentSelect opens the details popover on the picked
        " appointment, and closes it again when the appointment is deselected
        
        path = client->get_event_arg( ).
        IF path IS INITIAL OR client->get_event_arg( 2 ) <> abap_true.
          client->popover_destroy( ).
        ELSE.
          

          SPLIT path AT `/` INTO TABLE parts.
          DELETE parts WHERE table_line IS INITIAL.
          
          
          temp4 = sy-tabix.
          READ TABLE parts INDEX lines( parts ) INTO temp3.
          sy-tabix = temp4.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          sel_index = temp3.
          IF sel_index >= 0 AND sel_index < lines( t_appointments ).
            
            
            
            temp8 = sy-tabix.
            READ TABLE t_appointments INDEX sel_index + 1 INTO temp6.
            sy-tabix = temp8.
            IF sy-subrc <> 0.
              ASSERT 1 = 0.
            ENDIF.
            appointment = temp6.
            sel_title   = appointment-title.
            sel_text    = appointment-text.
            sel_type    = appointment-type.
            sel_start   = appointment-start_at.
            sel_end     = appointment-end_at.
            sel_typetxt = type_text( appointment-type ).
            " an appointment that starts and ends at midnight is an all-day one
            " (CP, not substring( ): a cleared picker sends an empty value and
            " an offset read would dump on it)
            
            temp33 = boolc( sel_start CP `*T00:00:00` AND sel_end CP `*T00:00:00` ).
            all_day     = temp33.
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
          
          temp5 = client->get_event_arg( 2 ).
          
          temp10 = client->get_event_arg( 3 ).
          day = |{ client->get_event_arg( ) }| &&
                |-{ temp5 WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
                |-{ temp10 WIDTH = 2 ALIGN = RIGHT PAD = '0' }|.
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
          
          
          temp7 = sy-tabix.
          READ TABLE t_appointments INDEX sel_index + 1 ASSIGNING <temp6>.
          sy-tabix = temp7.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          <temp6>-title    = sel_title.
          
          
          temp9 = sy-tabix.
          READ TABLE t_appointments INDEX sel_index + 1 ASSIGNING <temp8>.
          sy-tabix = temp9.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          <temp8>-text     = sel_text.
          
          
          temp11 = sy-tabix.
          READ TABLE t_appointments INDEX sel_index + 1 ASSIGNING <temp10>.
          sy-tabix = temp11.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          <temp10>-type     = sel_type.
          
          
          temp13 = sy-tabix.
          READ TABLE t_appointments INDEX sel_index + 1 ASSIGNING <temp12>.
          sy-tabix = temp13.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          <temp12>-start_at = sel_start.
          
          
          temp15 = sy-tabix.
          READ TABLE t_appointments INDEX sel_index + 1 ASSIGNING <temp14>.
          sy-tabix = temp15.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          <temp14>-end_at   = sel_end.
        ELSE.
          
          CLEAR temp16.
          temp16-title = sel_title.
          temp16-text = sel_text.
          temp16-type = sel_type.
          temp16-aria = `None`.
          temp16-start_at = sel_start.
          temp16-end_at = sel_end.
          INSERT temp16 INTO TABLE t_appointments.
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
        
        temp17 = client->get_event_arg( 2 ).
        
        temp12 = client->get_event_arg( 3 ).
        start_date = |{ client->get_event_arg( ) }| &&
                     |-{ temp17 WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
                     |-{ temp12 WIDTH = 2 ALIGN = RIGHT PAD = '0' }T00:00:00|.
        " the switch to the Day view is lost: SinglePlanningCalendar.selectedView
        " is an ASSOCIATION, which neither binds nor has a whitelisted setter

      WHEN `APPT_DROP`.
        
        drop_path = client->get_event_arg( 11 ).
        
        
        temp34 = boolc( client->get_event_arg( 12 ) = `X` ).
        is_copy   = temp34.
        

        SPLIT drop_path AT `/` INTO TABLE drop_parts.
        DELETE drop_parts WHERE table_line IS INITIAL.
        
        
        
        temp19 = sy-tabix.
        READ TABLE drop_parts INDEX lines( drop_parts ) INTO temp14.
        sy-tabix = temp19.
        IF sy-subrc <> 0.
          ASSERT 1 = 0.
        ENDIF.
        temp18 = temp14.
        
        drop_index = temp18.
        IF drop_index >= 0 AND drop_index < lines( t_appointments ).
          
          
          
          temp25 = sy-tabix.
          READ TABLE t_appointments INDEX drop_index + 1 INTO temp23.
          sy-tabix = temp25.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          dropped = temp23.
          
          drop_title = dropped-title.
          dropped-start_at = iso_of( 1 ).
          dropped-end_at   = iso_of( 6 ).
          IF is_copy = abap_true.
            INSERT dropped INTO TABLE t_appointments.
          ELSE.
            
            
            temp20 = sy-tabix.
            READ TABLE t_appointments INDEX drop_index + 1 ASSIGNING <temp19>.
            sy-tabix = temp20.
            IF sy-subrc <> 0.
              ASSERT 1 = 0.
            ENDIF.
            <temp19> = dropped.
          ENDIF.
          
          IF is_copy = abap_true.
            temp21 = `create`.
          ELSE.
            temp21 = `moved`.
          ENDIF.
          client->message_toast_display(
              |Appointment with title \n'{ drop_title }'\n has been { temp21 }| ).
        ENDIF.

      WHEN `APPT_RESIZE`.
        
        res_path = client->get_event_arg( 11 ).
        

        SPLIT res_path AT `/` INTO TABLE res_parts.
        DELETE res_parts WHERE table_line IS INITIAL.
        
        
        
        temp29 = sy-tabix.
        READ TABLE res_parts INDEX lines( res_parts ) INTO temp28.
        sy-tabix = temp29.
        IF sy-subrc <> 0.
          ASSERT 1 = 0.
        ENDIF.
        temp22 = temp28.
        
        res_index = temp22.
        IF res_index >= 0 AND res_index < lines( t_appointments ).
          
          
          
          temp31 = sy-tabix.
          READ TABLE t_appointments INDEX res_index + 1 INTO temp30.
          sy-tabix = temp31.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          res_title = temp30-title.
          
          
          temp24 = sy-tabix.
          READ TABLE t_appointments INDEX res_index + 1 ASSIGNING <temp23>.
          sy-tabix = temp24.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          <temp23>-start_at = iso_of( 1 ).
          
          
          temp26 = sy-tabix.
          READ TABLE t_appointments INDEX res_index + 1 ASSIGNING <temp25>.
          sy-tabix = temp26.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          <temp25>-end_at   = iso_of( 6 ).
          client->message_toast_display( |Appointment with title \n'{ res_title }'\n has been resized| ).
        ENDIF.

      WHEN `APPT_CREATE_DND`.
        " type must be seeded: an unset ABAP field reaches CalendarDayType as
        " "", which is not a member - validateProperty throws and the binding
        " update takes the view down (found by the new linter rule)
        
        CLEAR temp27.
        temp27-title = `New Appointment`.
        temp27-type = `Type01`.
        temp27-aria = `None`.
        temp27-start_at = iso_of( 1 ).
        temp27-end_at = iso_of( 6 ).
        INSERT temp27 INTO TABLE t_appointments.
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
    DATA temp28 TYPE string.
    CLEAR temp28.
    result = temp28.

  ENDMETHOD.


  METHOD iso_of.

    " five consecutive event arguments (year, month, day, hour, minute) as one
    " ISO string - the parts travel LOCAL, so no timezone shifts the day
    DATA temp29 TYPE i.
    DATA temp32 TYPE i.
    DATA temp5 TYPE i.
    DATA temp6 TYPE i.
    temp29 = client->get_event_arg( first + 1 ).
    
    temp32 = client->get_event_arg( first + 2 ).
    
    temp5 = client->get_event_arg( first + 3 ).
    
    temp6 = client->get_event_arg( first + 4 ).
    result = |{ client->get_event_arg( first ) }| &&
             |-{ temp29 WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
             |-{ temp32 WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
             |T{ temp5 WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
             |:{ temp6 WIDTH = 2 ALIGN = RIGHT PAD = '0' }:00|.

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
    DATA temp30 TYPE z2ui5_cl_smpc_app_549=>ty_t_appointment.
    DATA temp31 LIKE LINE OF temp30.
    DATA temp32 TYPE z2ui5_cl_smpc_app_549=>ty_t_type.
    DATA temp33 LIKE LINE OF temp32.

    start_date  = `2018-07-09T00:00:00`.
    sticky_mode = `None`.
    " the original seeds all three true (Page.controller.js:323) - these are the
    " behaviours the sample exists to show, and the three ToggleButtons start pressed
    enable_dnd  = abap_true.
    enable_new  = abap_true.
    enable_size = abap_true.
    all_day     = abap_false.
    sel_index   = -1.

    
    CLEAR temp30.
    
    temp31-title = `Meet John Miller`.
    temp31-type = `Type05`.
    temp31-start_at = `2018-07-08T05:00:00`.
    temp31-end_at = `2018-07-08T06:00:00`.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-title = `Discussion of the plan`.
    temp31-type = `Type01`.
    temp31-start_at = `2018-07-08T06:00:00`.
    temp31-end_at = `2018-07-08T07:09:00`.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-title = `Lunch`.
    temp31-text = `canteen`.
    temp31-type = `Type05`.
    temp31-start_at = `2018-07-08T07:00:00`.
    temp31-end_at = `2018-07-08T08:00:00`.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-title = `New Product`.
    temp31-text = `room 105`.
    temp31-type = `Type01`.
    temp31-icon = `sap-icon://meeting-room`.
    temp31-start_at = `2018-07-08T08:00:00`.
    temp31-end_at = `2018-07-08T09:00:00`.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-title = `Team meeting`.
    temp31-text = `Regular`.
    temp31-type = `Type01`.
    temp31-icon = `sap-icon://home`.
    temp31-start_at = `2018-07-08T09:09:00`.
    temp31-end_at = `2018-07-08T10:00:00`.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-title = `Discussion with clients regarding our new purpose`.
    temp31-text = `room 234 and Online meeting`.
    temp31-type = `Type08`.
    temp31-icon = `sap-icon://home`.
    temp31-start_at = `2018-07-08T10:00:00`.
    temp31-end_at = `2018-07-08T11:30:00`.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-title = `Discussion of the plan`.
    temp31-text = `Online meeting with partners and colleagues`.
    temp31-type = `Type01`.
    temp31-icon = `sap-icon://home`.
    temp31-start_at = `2018-07-08T11:30:00`.
    temp31-end_at = `2018-07-08T13:00:00`.
    temp31-aria = `Dialog`.
    temp31-tentative = abap_true.
    INSERT temp31 INTO TABLE temp30.
    temp31-title = `Discussion with clients`.
    temp31-type = `Type08`.
    temp31-icon = `sap-icon://home`.
    temp31-start_at = `2018-07-08T12:30:00`.
    temp31-end_at = `2018-07-08T13:15:00`.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-title = `Meeting with the manager`.
    temp31-type = `Type03`.
    temp31-start_at = `2018-07-08T13:09:00`.
    temp31-end_at = `2018-07-08T13:09:00`.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-title = `Meeting with the HR`.
    temp31-type = `Type03`.
    temp31-start_at = `2018-07-08T14:00:00`.
    temp31-end_at = `2018-07-08T14:15:00`.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-title = `Call with customer`.
    temp31-type = `Type08`.
    temp31-start_at = `2018-07-08T14:15:00`.
    temp31-end_at = `2018-07-08T14:30:00`.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-title = `Prepare documentation`.
    temp31-text = `At my desk`.
    temp31-type = `Type03`.
    temp31-icon = `sap-icon://meeting-room`.
    temp31-start_at = `2018-07-08T14:10:00`.
    temp31-end_at = `2018-07-08T15:30:00`.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-title = `Meeting with the manager`.
    temp31-type = `Type03`.
    temp31-start_at = `2018-07-09T06:30:00`.
    temp31-end_at = `2018-07-09T07:00:00`.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-title = `Lunch`.
    temp31-type = `Type05`.
    temp31-start_at = `2018-07-09T07:00:00`.
    temp31-end_at = `2018-07-09T08:00:00`.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-title = `Team meeting`.
    temp31-text = `online`.
    temp31-type = `Type01`.
    temp31-start_at = `2018-07-09T08:00:00`.
    temp31-end_at = `2018-07-09T09:00:00`.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-title = `Discussion with clients for the new release dates`.
    temp31-text = `Online meeting`.
    temp31-type = `Type08`.
    temp31-start_at = `2018-07-09T09:00:00`.
    temp31-end_at = `2018-07-09T10:00:00`.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-title = `Team meeting`.
    temp31-text = `room 5`.
    temp31-type = `Type01`.
    temp31-start_at = `2018-07-09T11:00:00`.
    temp31-end_at = `2018-07-09T14:00:00`.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-title = `Daily standup meeting`.
    temp31-type = `Type01`.
    temp31-start_at = `2018-07-09T09:00:00`.
    temp31-end_at = `2018-07-09T09:15:00`.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-title = `Private meeting`.
    temp31-type = `Type03`.
    temp31-start_at = `2018-07-11T09:09:00`.
    temp31-end_at = `2018-07-11T09:20:00`.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-title = `Private meeting`.
    temp31-type = `Type03`.
    temp31-start_at = `2018-07-10T06:00:00`.
    temp31-end_at = `2018-07-10T07:00:00`.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-title = `Meeting with the manager`.
    temp31-type = `Type03`.
    temp31-start_at = `2018-07-10T15:00:00`.
    temp31-end_at = `2018-07-10T15:30:00`.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-title = `Meet John Doe`.
    temp31-type = `Type05`.
    temp31-icon = `sap-icon://home`.
    temp31-start_at = `2018-07-11T07:00:00`.
    temp31-end_at = `2018-07-11T07:30:00`.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-title = `Team meeting`.
    temp31-text = `online`.
    temp31-type = `Type01`.
    temp31-start_at = `2018-07-11T08:00:00`.
    temp31-end_at = `2018-07-11T09:30:00`.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-title = `Workshop`.
    temp31-type = `Type05`.
    temp31-start_at = `2018-07-11T08:30:00`.
    temp31-end_at = `2018-07-11T12:00:00`.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-title = `Team collaboration`.
    temp31-type = `Type01`.
    temp31-start_at = `2018-07-12T04:00:00`.
    temp31-end_at = `2018-07-12T12:30:00`.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-title = `Out of the office`.
    temp31-type = `Type05`.
    temp31-start_at = `2018-07-12T15:00:00`.
    temp31-end_at = `2018-07-12T19:30:00`.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-title = `Working out of the building`.
    temp31-type = `Type05`.
    temp31-start_at = `2018-07-12T20:00:00`.
    temp31-end_at = `2018-07-12T21:30:00`.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-title = `Vacation`.
    temp31-text = `out of office`.
    temp31-type = `Type09`.
    temp31-start_at = `2018-07-11T12:00:00`.
    temp31-end_at = `2018-07-13T14:00:00`.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-title = `Reminder`.
    temp31-type = `Type09`.
    temp31-start_at = `2018-07-12T00:00:00`.
    temp31-end_at = `2018-07-13T00:00:00`.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-title = `Team collaboration`.
    temp31-type = `Type01`.
    temp31-start_at = `2018-07-06T00:00:00`.
    temp31-end_at = `2018-07-16T00:00:00`.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-title = `Workshop out of the country`.
    temp31-type = `Type05`.
    temp31-start_at = `2018-07-14T00:00:00`.
    temp31-end_at = `2018-07-20T00:00:00`.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-title = `Payment reminder`.
    temp31-type = `Type09`.
    temp31-start_at = `2018-07-07T00:00:00`.
    temp31-end_at = `2018-07-08T00:00:00`.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-title = `Meeting with the manager`.
    temp31-type = `Type03`.
    temp31-start_at = `2018-07-06T09:00:00`.
    temp31-end_at = `2018-07-06T10:00:00`.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-title = `Daily standup meeting`.
    temp31-type = `Type01`.
    temp31-start_at = `2018-07-07T10:00:00`.
    temp31-end_at = `2018-07-07T10:30:00`.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-title = `Private meeting`.
    temp31-type = `Type03`.
    temp31-start_at = `2018-07-06T11:30:00`.
    temp31-end_at = `2018-07-06T12:00:00`.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-title = `Lunch`.
    temp31-type = `Type05`.
    temp31-start_at = `2018-07-06T12:00:00`.
    temp31-end_at = `2018-07-06T13:00:00`.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-title = `Discussion of the plan`.
    temp31-type = `Type01`.
    temp31-start_at = `2018-07-16T11:00:00`.
    temp31-end_at = `2018-07-16T12:00:00`.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-title = `Lunch`.
    temp31-text = `canteen`.
    temp31-type = `Type05`.
    temp31-start_at = `2018-07-16T12:00:00`.
    temp31-end_at = `2018-07-16T13:00:00`.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-title = `Team meeting`.
    temp31-text = `room 200`.
    temp31-type = `Type01`.
    temp31-icon = `sap-icon://meeting-room`.
    temp31-start_at = `2018-07-16T16:00:00`.
    temp31-end_at = `2018-07-16T17:00:00`.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    temp31-title = `Discussion with clients`.
    temp31-text = `Online meeting`.
    temp31-type = `Type08`.
    temp31-icon = `sap-icon://home`.
    temp31-start_at = `2018-07-17T15:30:00`.
    temp31-end_at = `2018-07-17T16:30:00`.
    temp31-aria = `Dialog`.
    INSERT temp31 INTO TABLE temp30.
    t_appointments = temp30.

    
    CLEAR temp32.
    
    temp33-text = `Team Meeting`.
    temp33-type = `Type01`.
    INSERT temp33 INTO TABLE temp32.
    temp33-text = `Personal`.
    temp33-type = `Type05`.
    INSERT temp33 INTO TABLE temp32.
    temp33-text = `Discussions`.
    temp33-type = `Type08`.
    INSERT temp33 INTO TABLE temp32.
    temp33-text = `Out of office`.
    temp33-type = `Type09`.
    INSERT temp33 INTO TABLE temp32.
    temp33-text = `Private meeting`.
    temp33-type = `Type03`.
    INSERT temp33 INTO TABLE temp32.
    t_types = temp32.

  ENDMETHOD.

ENDCLASS.
