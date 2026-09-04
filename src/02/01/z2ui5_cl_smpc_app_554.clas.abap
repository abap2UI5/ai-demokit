" @keywords singleplanningcalendar single planning calendar sap.m singleplanningcalendarwithzoominzoomout dynamicsidecontent vbox togglebutton button singleplanningcalendardayview singleplanningcalendarworkweekview
" @summary SinglePlanningCalendar with enabled Zoom In and Zoom Out functionality.
CLASS z2ui5_cl_smpc_app_554 DEFINITION PUBLIC.

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
    TYPES: BEGIN OF ty_s_special,
             start_at TYPE string,
             end_at   TYPE string,
             type     TYPE string,
             color    TYPE string,
           END OF ty_s_special.
    TYPES ty_t_special TYPE STANDARD TABLE OF ty_s_special WITH DEFAULT KEY.
    TYPES: BEGIN OF ty_s_legend,
             text  TYPE string,
             type  TYPE string,
             color TYPE string,
           END OF ty_s_legend.
    TYPES ty_t_legend TYPE STANDARD TABLE OF ty_s_legend WITH DEFAULT KEY.

    DATA t_appointments      TYPE ty_t_appointment.
    DATA t_special_dates     TYPE ty_t_special.
    DATA t_legend_items      TYPE ty_t_legend.
    DATA t_legend_appt_items TYPE ty_t_legend.

    DATA start_date   TYPE string.
    DATA legend_shown TYPE abap_bool.
    DATA full_day     TYPE abap_bool.
    DATA scale_factor TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_554 IMPLEMENTATION.

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
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " the calendar date properties are typed "object" and demand a real JS Date;
    " the model keeps ISO strings and Formatter.DateCreateObject converts them
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc`     v = `sap.ui.core.mvc`
        )->a( n = `xmlns:unified` v = `sap.ui.unified`
        )->a( n = `xmlns:l`       v = `sap.ui.layout`
        )->a( n = `xmlns:core`    v = `sap.ui.core`
        )->a( n = `xmlns`         v = `sap.m`
        )->a( n = `core:require`  v = `{Formatter: 'z2ui5/model/formatter'}`

        )->ele( n = `DynamicSideContent` ns = `l`
            )->a( n = `id`                    v = `DynamicSideContent`
            )->a( n = `class`                 v = `sapUiDSCExplored sapUiContentPadding`
            )->a( n = `sideContentVisibility` v = `AlwaysShow`
            " the original keeps the legend flag in a second named model; abap2UI5
            " keeps one default model, so the flag is a field here
            )->a( n = `showSideContent`       v = client->_bind( legend_shown )
            )->a( n = `containerQuery`        v = `true`

            )->ele( `VBox`

                )->ele( `SinglePlanningCalendar`
                    )->a( n = `id`           v = `SPC1`
                    )->a( n = `class`        v = `sapUiSmallMarginTop`
                    )->a( n = `title`        v = `My Calendar`
                    )->a( n = `startHour`    v = `8`
                    )->a( n = `endHour`      v = `20`
                    " toggleFullDay flips setFullDay; the property is bindable, so
                    " the ToggleButton and the calendar share the flag
                    )->a( n = `fullDay`      v = client->_bind( full_day )
                    " zoomIn / zoomOut step setScaleFactor; the property is bindable
                    " and the two presses do the same increment in ABAP
                    )->a( n = `scaleFactor`  v = client->_bind( scale_factor )
                    )->a( n = `startDate`    v = |\{ path: '{ client->_bind_path( start_date ) }', formatter: 'Formatter.DateCreateObject' \}|
                    )->a( n = `appointments` v = client->_bind( t_appointments )
                    )->a( n = `specialDates` v = client->_bind( t_special_dates )
                    )->a( n = `legend`       v = `SinglePlanningCalendarLegend`

                    )->ele( `actions`
                        )->tag( `ToggleButton`
                            )->a( n = `text`    v = `Full Day`
                            )->a( n = `pressed` v = client->_bind( full_day )
                        )->tag( `ToggleButton`
                            )->a( n = `pressed` v = client->_bind( legend_shown )
                            )->a( n = `icon`    v = `sap-icon://legend`
                        )->tag( `Button`
                            )->a( n = `icon`  v = `sap-icon://zoom-in`
                            )->a( n = `press` v = client->_event( `ZOOM_IN` )
                        )->tag( `Button`
                            )->a( n = `icon`  v = `sap-icon://zoom-out`
                            )->a( n = `press` v = client->_event( `ZOOM_OUT` )

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

                    )->ele( `specialDates`
                        )->tag( n = `DateTypeRange` ns = `unified`
                            )->a( n = `startDate` v = `{ path: 'START_AT', formatter: 'Formatter.DateCreateObject' }`
                            )->a( n = `endDate`   v = `{ path: 'END_AT', formatter: 'Formatter.DateCreateObject' }`
                            )->a( n = `type`      v = `{TYPE}`
                            )->a( n = `color`     v = `{COLOR}`

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
            )->end(

            )->ele( n = `sideContent` ns = `l`
                )->a( n = `width` v = `200px`

                )->ele( `PlanningCalendarLegend`
                    )->a( n = `id`               v = `SinglePlanningCalendarLegend`
                    " ROOT-level aggregations - a bare 'T_' path is RELATIVE and resolves
                    " against nothing outside a row context, and an unbound table is not
                    " serialized at all (app 553 has the same two fixes)
                    )->a( n = `items`            v = |\{ path: '{ client->_bind_path( t_legend_items ) }', templateShareable: true \}|
                    )->a( n = `appointmentItems` v = |\{ path: '{ client->_bind_path( t_legend_appt_items ) }', templateShareable: true \}|
                    )->a( n = `class`            v = `sapUiSmallMarginTop`

                    )->ele( `items`
                        )->tag( n = `CalendarLegendItem` ns = `unified`
                            )->a( n = `text`    v = `{TEXT}`
                            )->a( n = `type`    v = `{TYPE}`
                            )->a( n = `color`   v = `{COLOR}`
                            )->a( n = `tooltip` v = `{TEXT}`

                    )->end(
                    )->ele( `appointmentItems`
                        )->tag( n = `CalendarLegendItem` ns = `unified`
                            )->a( n = `text`    v = `{TEXT}`
                            )->a( n = `type`    v = `{TYPE}`
                            )->a( n = `tooltip` v = `{TEXT}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `ZOOM_IN`.
        scale_factor = scale_factor + 1.

      WHEN `ZOOM_OUT`.
        scale_factor = scale_factor - 1.

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.
    DATA temp1 TYPE z2ui5_cl_smpc_app_554=>ty_t_appointment.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp3 TYPE z2ui5_cl_smpc_app_554=>ty_t_legend.
    DATA temp4 LIKE LINE OF temp3.
    DATA temp5 TYPE z2ui5_cl_smpc_app_554=>ty_t_legend.
    DATA temp6 LIKE LINE OF temp5.

    start_date   = `2018-07-24T00:00:00`.
    legend_shown = abap_false.
    full_day     = abap_false.
    " the SinglePlanningCalendar scaleFactor default
    scale_factor = 1.

    " the view binds /specialDates, which the sample's own model never fills
    CLEAR t_special_dates.

    
    CLEAR temp1.
    
    temp2-title = `Meet John Miller`.
    temp2-type = `Type05`.
    temp2-start_at = `2018-07-24T08:00:00`.
    temp2-end_at = `2018-07-24T08:05:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Discussion of the plan`.
    temp2-type = `Type08`.
    temp2-start_at = `2018-07-24T08:05:00`.
    temp2-end_at = `2018-07-24T08:10:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Lunch`.
    temp2-text = `canteen`.
    temp2-type = `Type05`.
    temp2-start_at = `2018-07-24T08:10:00`.
    temp2-end_at = `2018-07-24T08:15:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `New Product`.
    temp2-text = `room 105`.
    temp2-type = `Type01`.
    temp2-icon = `sap-icon://meeting-room`.
    temp2-start_at = `2018-07-24T08:15:00`.
    temp2-end_at = `2018-07-24T08:20:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Team meeting`.
    temp2-text = `Regular`.
    temp2-type = `Type01`.
    temp2-icon = `sap-icon://home`.
    temp2-start_at = `2018-07-24T08:20:00`.
    temp2-end_at = `2018-07-24T08:25:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Discussion with clients`.
    temp2-text = `Online meeting`.
    temp2-type = `Type08`.
    temp2-icon = `sap-icon://home`.
    temp2-start_at = `2018-07-24T08:25:00`.
    temp2-end_at = `2018-07-24T08:30:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Discussion of the plan`.
    temp2-text = `Online meeting`.
    temp2-type = `Type08`.
    temp2-icon = `sap-icon://home`.
    temp2-start_at = `2018-07-24T08:30:00`.
    temp2-end_at = `2018-07-24T08:35:00`.
    temp2-tentative = abap_true.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Discussion with clients`.
    temp2-type = `Type08`.
    temp2-icon = `sap-icon://home`.
    temp2-start_at = `2018-07-24T08:35:00`.
    temp2-end_at = `2018-07-24T08:40:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Meeting with the manager`.
    temp2-type = `Type03`.
    temp2-start_at = `2018-07-24T08:40:00`.
    temp2-end_at = `2018-07-24T08:45:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Meeting with the manager`.
    temp2-type = `Type03`.
    temp2-start_at = `2018-07-24T08:45:00`.
    temp2-end_at = `2018-07-24T08:50:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Lunch`.
    temp2-type = `Type05`.
    temp2-start_at = `2018-07-24T08:50:00`.
    temp2-end_at = `2018-07-24T08:55:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Team meeting`.
    temp2-text = `online`.
    temp2-type = `Type01`.
    temp2-start_at = `2018-07-24T08:55:00`.
    temp2-end_at = `2018-07-24T09:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Discussion with clients`.
    temp2-type = `Type08`.
    temp2-start_at = `2018-07-25T08:00:00`.
    temp2-end_at = `2018-07-25T09:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Team meeting`.
    temp2-text = `room 5`.
    temp2-type = `Type01`.
    temp2-start_at = `2018-07-26T08:00:00`.
    temp2-end_at = `2018-07-26T08:30:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Daily standup meeting`.
    temp2-type = `Type01`.
    temp2-start_at = `2018-07-26T08:30:00`.
    temp2-end_at = `2018-07-26T09:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Private meeting`.
    temp2-type = `Type03`.
    temp2-start_at = `2018-07-27T08:00:00`.
    temp2-end_at = `2018-07-27T08:20:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Team meeting`.
    temp2-text = `room 5`.
    temp2-type = `Type01`.
    temp2-start_at = `2018-07-27T08:20:00`.
    temp2-end_at = `2018-07-27T08:40:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Meeting with the manager`.
    temp2-type = `Type03`.
    temp2-start_at = `2018-07-27T08:40:00`.
    temp2-end_at = `2018-07-27T09:00:00`.
    INSERT temp2 INTO TABLE temp1.
    t_appointments = temp1.

    
    CLEAR temp3.
    
    temp4-text = `Public holiday`.
    temp4-type = `Type07`.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Team building`.
    temp4-type = `Type08`.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Work from office 1`.
    temp4-type = `Type09`.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Work from office 2`.
    temp4-type = `Type14`.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Home office`.
    temp4-type = `Type03`.
    temp4-color = `#add8e6`.
    INSERT temp4 INTO TABLE temp3.
    t_legend_items = temp3.

    
    CLEAR temp5.
    
    temp6-text = `Team Meeting`.
    temp6-type = `Type01`.
    INSERT temp6 INTO TABLE temp5.
    temp6-text = `Personal`.
    temp6-type = `Type05`.
    INSERT temp6 INTO TABLE temp5.
    temp6-text = `Discussions`.
    temp6-type = `Type08`.
    INSERT temp6 INTO TABLE temp5.
    temp6-text = `Out of office`.
    temp6-type = `Type09`.
    INSERT temp6 INTO TABLE temp5.
    temp6-text = `Private meeting`.
    temp6-type = `Type03`.
    INSERT temp6 INTO TABLE temp5.
    t_legend_appt_items = temp5.

  ENDMETHOD.

ENDCLASS.
