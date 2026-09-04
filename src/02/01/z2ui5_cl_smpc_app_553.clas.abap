" @keywords singleplanningcalendar single planning calendar sap.m singleplanningcalendarwithlegend dynamicsidecontent vbox togglebutton singleplanningcalendardayview singleplanningcalendarworkweekview singleplanningcalendarweekview
" @summary SinglePlanningCalendar and PlanningCalendarLegend controls used as main and side parts of an sap.ui.layout.DynamicSideContent control. The calendar also shows the daily working hours.
CLASS z2ui5_cl_smpc_app_553 DEFINITION PUBLIC.

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
             start_at      TYPE string,
             end_at        TYPE string,
             type          TYPE string,
             secondarytype TYPE string,
             color         TYPE string,
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

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_553 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
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
                            )->a( n = `type`          v = `{TYPE}`
                            )->a( n = `secondaryType` v = `{SECONDARYTYPE}`
                            )->a( n = `color`         v = `{COLOR}`

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
                    " ROOT-level aggregations - see app 555: a bare 'T_' path is
                    " RELATIVE and resolves against nothing outside a row context
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


  METHOD model_init.
    DATA temp1 TYPE z2ui5_cl_smpc_app_553=>ty_t_appointment.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp3 TYPE z2ui5_cl_smpc_app_553=>ty_t_special.
    DATA temp4 LIKE LINE OF temp3.
    DATA temp5 TYPE z2ui5_cl_smpc_app_553=>ty_t_legend.
    DATA temp6 LIKE LINE OF temp5.
    DATA temp7 TYPE z2ui5_cl_smpc_app_553=>ty_t_legend.
    DATA temp8 LIKE LINE OF temp7.

    start_date   = `2018-07-09T00:00:00`.
    legend_shown = abap_false.
    full_day     = abap_false.

    
    CLEAR temp1.
    
    temp2-title = `Meet John Miller`.
    temp2-type = `Type05`.
    temp2-start_at = `2018-07-08T05:00:00`.
    temp2-end_at = `2018-07-08T06:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Discussion of the plan`.
    temp2-type = `Type08`.
    temp2-start_at = `2018-07-08T06:00:00`.
    temp2-end_at = `2018-07-08T07:09:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Lunch`.
    temp2-text = `canteen`.
    temp2-type = `Type05`.
    temp2-start_at = `2018-07-08T07:00:00`.
    temp2-end_at = `2018-07-08T08:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `New Product`.
    temp2-text = `room 105`.
    temp2-type = `Type01`.
    temp2-icon = `sap-icon://meeting-room`.
    temp2-start_at = `2018-07-08T08:00:00`.
    temp2-end_at = `2018-07-08T09:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Team meeting`.
    temp2-text = `Regular`.
    temp2-type = `Type01`.
    temp2-icon = `sap-icon://home`.
    temp2-start_at = `2018-07-08T09:09:00`.
    temp2-end_at = `2018-07-08T10:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Discussion with clients`.
    temp2-text = `Online meeting`.
    temp2-type = `Type08`.
    temp2-icon = `sap-icon://home`.
    temp2-start_at = `2018-07-08T10:00:00`.
    temp2-end_at = `2018-07-08T11:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Discussion of the plan`.
    temp2-text = `Online meeting`.
    temp2-type = `Type08`.
    temp2-icon = `sap-icon://home`.
    temp2-start_at = `2018-07-08T11:00:00`.
    temp2-end_at = `2018-07-08T12:00:00`.
    temp2-tentative = abap_true.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Discussion with clients`.
    temp2-type = `Type08`.
    temp2-icon = `sap-icon://home`.
    temp2-start_at = `2018-07-08T12:00:00`.
    temp2-end_at = `2018-07-08T13:09:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Meeting with the manager`.
    temp2-type = `Type03`.
    temp2-start_at = `2018-07-08T13:09:00`.
    temp2-end_at = `2018-07-08T13:09:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Meeting with the manager`.
    temp2-type = `Type03`.
    temp2-start_at = `2018-07-09T06:30:00`.
    temp2-end_at = `2018-07-09T07:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Lunch`.
    temp2-type = `Type05`.
    temp2-start_at = `2018-07-09T07:00:00`.
    temp2-end_at = `2018-07-09T08:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Team meeting`.
    temp2-text = `online`.
    temp2-type = `Type01`.
    temp2-start_at = `2018-07-09T08:00:00`.
    temp2-end_at = `2018-07-09T09:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Discussion with clients`.
    temp2-type = `Type08`.
    temp2-start_at = `2018-07-09T09:00:00`.
    temp2-end_at = `2018-07-09T10:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Team meeting`.
    temp2-text = `room 5`.
    temp2-type = `Type01`.
    temp2-start_at = `2018-07-09T11:00:00`.
    temp2-end_at = `2018-07-09T14:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Daily standup meeting`.
    temp2-type = `Type01`.
    temp2-start_at = `2018-07-09T09:00:00`.
    temp2-end_at = `2018-07-09T09:15:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Private meeting`.
    temp2-type = `Type03`.
    temp2-start_at = `2018-07-11T09:09:00`.
    temp2-end_at = `2018-07-11T09:20:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Private meeting`.
    temp2-type = `Type03`.
    temp2-start_at = `2018-07-10T06:00:00`.
    temp2-end_at = `2018-07-10T07:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Meeting with the manager`.
    temp2-type = `Type03`.
    temp2-start_at = `2018-07-10T15:00:00`.
    temp2-end_at = `2018-07-10T15:30:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Meet John Doe`.
    temp2-type = `Type05`.
    temp2-icon = `sap-icon://home`.
    temp2-start_at = `2018-07-11T07:00:00`.
    temp2-end_at = `2018-07-11T07:30:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Team meeting`.
    temp2-text = `online`.
    temp2-type = `Type01`.
    temp2-start_at = `2018-07-11T08:00:00`.
    temp2-end_at = `2018-07-11T09:30:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Workshop`.
    temp2-type = `Type01`.
    temp2-start_at = `2018-07-11T08:30:00`.
    temp2-end_at = `2018-07-11T12:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Team collaboration`.
    temp2-type = `Type01`.
    temp2-start_at = `2018-07-12T04:00:00`.
    temp2-end_at = `2018-07-12T12:30:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Out of the office`.
    temp2-type = `Type05`.
    temp2-start_at = `2018-07-12T15:00:00`.
    temp2-end_at = `2018-07-12T19:30:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Working out of the building`.
    temp2-type = `Type07`.
    temp2-start_at = `2018-07-12T20:00:00`.
    temp2-end_at = `2018-07-12T21:30:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Reminder`.
    temp2-type = `Type09`.
    temp2-start_at = `2018-07-12T00:00:00`.
    temp2-end_at = `2018-07-13T00:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Team collaboration`.
    temp2-type = `Type01`.
    temp2-start_at = `2018-07-06T00:00:00`.
    temp2-end_at = `2018-07-16T00:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Workshop out of the country`.
    temp2-type = `Type05`.
    temp2-start_at = `2018-07-14T00:00:00`.
    temp2-end_at = `2018-07-20T00:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Payment reminder`.
    temp2-type = `Type09`.
    temp2-start_at = `2018-07-07T00:00:00`.
    temp2-end_at = `2018-07-08T00:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Meeting with the manager`.
    temp2-type = `Type03`.
    temp2-start_at = `2018-07-06T09:00:00`.
    temp2-end_at = `2018-07-06T10:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Daily standup meeting`.
    temp2-type = `Type01`.
    temp2-start_at = `2018-07-07T10:00:00`.
    temp2-end_at = `2018-07-07T10:30:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Private meeting`.
    temp2-type = `Type03`.
    temp2-start_at = `2018-07-06T11:30:00`.
    temp2-end_at = `2018-07-06T12:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Lunch`.
    temp2-type = `Type05`.
    temp2-start_at = `2018-07-06T12:00:00`.
    temp2-end_at = `2018-07-06T13:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Discussion of the plan`.
    temp2-type = `Type08`.
    temp2-start_at = `2018-07-16T11:00:00`.
    temp2-end_at = `2018-07-16T12:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Lunch`.
    temp2-text = `canteen`.
    temp2-type = `Type05`.
    temp2-start_at = `2018-07-16T12:00:00`.
    temp2-end_at = `2018-07-16T13:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Team meeting`.
    temp2-text = `room 200`.
    temp2-type = `Type01`.
    temp2-icon = `sap-icon://meeting-room`.
    temp2-start_at = `2018-07-16T16:00:00`.
    temp2-end_at = `2018-07-16T17:00:00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Discussion with clients`.
    temp2-text = `Online meeting`.
    temp2-type = `Type08`.
    temp2-icon = `sap-icon://home`.
    temp2-start_at = `2018-07-17T15:30:00`.
    temp2-end_at = `2018-07-17T16:30:00`.
    INSERT temp2 INTO TABLE temp1.
    t_appointments = temp1.

    " a flat ABAP row serializes EVERY field, so a special date the sample gives
    " no secondaryType would send an empty string - which overrides the
    " CalendarDayType enum DEFAULT and takes the whole view down (apps 531/532);
    " the default None is therefore seeded explicitly
    
    CLEAR temp3.
    
    temp4-start_at = `2018-07-06T00:00:00`.
    temp4-end_at = `2018-07-09T00:00:00`.
    temp4-type = `Type14`.
    temp4-secondarytype = `None`.
    INSERT temp4 INTO TABLE temp3.
    temp4-start_at = `2018-07-02T00:00:00`.
    temp4-end_at = `2018-07-02T23:59:00`.
    temp4-type = `Type08`.
    temp4-secondarytype = `None`.
    INSERT temp4 INTO TABLE temp3.
    temp4-start_at = `2018-07-11T00:00:00`.
    temp4-end_at = `2018-07-11T23:59:00`.
    temp4-type = `Type11`.
    temp4-color = `#ff69b4`.
    temp4-secondarytype = `None`.
    INSERT temp4 INTO TABLE temp3.
    temp4-start_at = `2018-07-12T00:00:00`.
    temp4-end_at = `2018-07-12T23:59:00`.
    temp4-type = `Type03`.
    temp4-color = `#add8e6`.
    temp4-secondarytype = `None`.
    INSERT temp4 INTO TABLE temp3.
    temp4-start_at = `2018-07-13T00:00:00`.
    temp4-end_at = `2018-07-13T23:59:00`.
    temp4-type = `Type09`.
    temp4-secondarytype = `None`.
    INSERT temp4 INTO TABLE temp3.
    temp4-start_at = `2018-07-14T00:00:00`.
    temp4-end_at = `2018-07-14T00:00:00`.
    temp4-type = `Type10`.
    temp4-secondarytype = `Working`.
    INSERT temp4 INTO TABLE temp3.
    temp4-start_at = `2018-07-17T00:00:00`.
    temp4-end_at = `2018-07-18T23:59:00`.
    temp4-type = `Type07`.
    temp4-secondarytype = `None`.
    INSERT temp4 INTO TABLE temp3.
    t_special_dates = temp3.

    
    CLEAR temp5.
    
    temp6-text = `Public holiday`.
    temp6-type = `Type07`.
    INSERT temp6 INTO TABLE temp5.
    temp6-text = `Team building`.
    temp6-type = `Type08`.
    INSERT temp6 INTO TABLE temp5.
    temp6-text = `Work from office 1`.
    temp6-type = `Type09`.
    INSERT temp6 INTO TABLE temp5.
    temp6-text = `Work from office 2`.
    temp6-type = `Type14`.
    INSERT temp6 INTO TABLE temp5.
    temp6-text = `Home office`.
    temp6-type = `Type03`.
    temp6-color = `#add8e6`.
    INSERT temp6 INTO TABLE temp5.
    t_legend_items = temp5.

    
    CLEAR temp7.
    
    temp8-text = `Team Meeting`.
    temp8-type = `Type01`.
    INSERT temp8 INTO TABLE temp7.
    temp8-text = `Personal`.
    temp8-type = `Type05`.
    INSERT temp8 INTO TABLE temp7.
    temp8-text = `Discussions`.
    temp8-type = `Type08`.
    INSERT temp8 INTO TABLE temp7.
    temp8-text = `Out of office`.
    temp8-type = `Type09`.
    INSERT temp8 INTO TABLE temp7.
    temp8-text = `Private meeting`.
    temp8-type = `Type03`.
    INSERT temp8 INTO TABLE temp7.
    t_legend_appt_items = temp7.

  ENDMETHOD.

ENDCLASS.
