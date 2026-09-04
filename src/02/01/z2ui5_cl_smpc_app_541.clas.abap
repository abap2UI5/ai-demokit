" @keywords planningcalendar planning calendar sap.m planningcalendarwithlegend dynamicsidecontent vbox label select item togglebutton planningcalendarrow
" @summary PlanningCalendar inside the main part of a sap.ui.layout.DynamicSideContent and a sap.m.PlanningCalendarLegend inside the side part. The legend includes calendar and appointments sections. For each sap.m.PlanningCalendarRow in the sap.m.
CLASS z2ui5_cl_smpc_app_541 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_special,
             start_at      TYPE string,
             end_at        TYPE string,
             type          TYPE string,
             secondarytype TYPE string,
             color         TYPE string,
           END OF ty_s_special.
    TYPES ty_t_special TYPE STANDARD TABLE OF ty_s_special WITH DEFAULT KEY.
    TYPES: BEGIN OF ty_s_appointment,
             start_at  TYPE string,
             end_at    TYPE string,
             title     TYPE string,
             info      TYPE string,
             type      TYPE string,
             pic       TYPE string,
             tentative TYPE abap_bool,
             aria      TYPE string,
           END OF ty_s_appointment.
    TYPES ty_t_appointment TYPE STANDARD TABLE OF ty_s_appointment WITH DEFAULT KEY.
    TYPES: BEGIN OF ty_s_header,
             start_at TYPE string,
             end_at   TYPE string,
             title    TYPE string,
             type     TYPE string,
             pic      TYPE string,
           END OF ty_s_header.
    TYPES ty_t_header TYPE STANDARD TABLE OF ty_s_header WITH DEFAULT KEY.
    TYPES: BEGIN OF ty_s_person,
             pic            TYPE string,
             name           TYPE string,
             role           TYPE string,
             t_specials     TYPE ty_t_special,
             t_appointments TYPE ty_t_appointment,
             t_headers      TYPE ty_t_header,
           END OF ty_s_person.
    DATA t_people TYPE STANDARD TABLE OF ty_s_person WITH DEFAULT KEY.

    TYPES: BEGIN OF ty_s_legend,
             text  TYPE string,
             type  TYPE string,
             color TYPE string,
           END OF ty_s_legend.
    TYPES ty_t_legend TYPE STANDARD TABLE OF ty_s_legend WITH DEFAULT KEY.

    DATA t_special_dates     TYPE ty_t_special.
    DATA t_legend_items      TYPE ty_t_legend.
    DATA t_legend_appt_items TYPE ty_t_legend.

    DATA start_date     TYPE string.
    DATA legend_shown   TYPE abap_bool.
    DATA view_key       TYPE string.
    DATA first_day      TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_541 IMPLEMENTATION.

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

    " calendar date properties are typed "object" and demand a real JS Date;
    " the model keeps ISO strings and Formatter.DateCreateObject converts them
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:core`    v = `sap.ui.core`
        )->a( n = `xmlns:mvc`     v = `sap.ui.core.mvc`
        )->a( n = `xmlns:unified` v = `sap.ui.unified`
        )->a( n = `xmlns:l`       v = `sap.ui.layout`
        )->a( n = `xmlns`         v = `sap.m`
        )->a( n = `core:require`  v = `{Formatter: 'z2ui5/model/formatter'}`

        )->ele( n = `DynamicSideContent` ns = `l`
            )->a( n = `id`                   v = `DynamicSideContent`
            )->a( n = `class`                v = `sapUiDSCExplored sapUiContentPadding`
            )->a( n = `sideContentVisibility` v = `AlwaysShow`
            " the original keeps the legend flag in a second named model; abap2UI5
            " keeps one default model, so the flag is a field here
            )->a( n = `showSideContent`      v = client->_bind( legend_shown )
            )->a( n = `containerQuery`       v = `true`

            )->ele( `VBox`

                )->ele( `VBox`
                    )->a( n = `width` v = `180px`

                    )->tag( `Label`
                        )->a( n = `text` v = `Choose first day of week:`
                    " onChange calls setFirstDayOfWeek( Number( key ) ); the property
                    " is bindable, so the Select shares its key with the calendar
                    )->ele( `Select`
                        )->a( n = `selectedKey` v = client->_bind( first_day )

                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `-1`
                            )->a( n = `text` v = `Locale-based`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `1`
                            )->a( n = `text` v = `Monday`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `2`
                            )->a( n = `text` v = `Tuesday`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `3`
                            )->a( n = `text` v = `Wednesday`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `4`
                            )->a( n = `text` v = `Thursday`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `5`
                            )->a( n = `text` v = `Friday`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `6`
                            )->a( n = `text` v = `Saturday`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `0`
                            )->a( n = `text` v = `Sunday`

                    )->end(
                )->end(

                )->ele( `PlanningCalendar`
                    )->a( n = `id`                        v = `PC1`
                    )->a( n = `class`                     v = `sapMPlanCalSuppressAlternatingRowColors`
                    )->a( n = `startDate`                 v = |\{ path: '{ client->_bind_path( start_date ) }', formatter: 'Formatter.DateCreateObject' \}|
                    )->a( n = `rows`                      v = client->_bind( t_people )
                    )->a( n = `appointmentsVisualization` v = `Filled`
                    )->a( n = `showEmptyIntervalHeaders`  v = `false`
                    " onChange calls setFirstDayOfWeek( Number( key ) ); the property is
                    " an INT and the Select's key is a string, so the expression multiplies
                    " by 1 - the Number( ) the original calls
                    )->a( n = `firstDayOfWeek`            v = |\{= ${ client->_bind( first_day ) } * 1 \}|
                    " handleViewChange only recomputes the legend's standardItems;
                    " viewKey is bindable, so the key is the shared field and the
                    " legend reads it through an expression
                    )->a( n = `viewKey`                   v = client->_bind( view_key )
                    )->a( n = `legend`                    v = `PlanningCalendarLegend`
                    " ROOT-level aggregation - a bare 'T_' path is RELATIVE and resolves
                    " against nothing outside a row context, and an unbound table is not
                    " serialized at all (app 553 has the same two fixes)
                    )->a( n = `specialDates`              v = |\{ path: '{ client->_bind_path( t_special_dates ) }', templateShareable: false \}|

                    )->ele( `toolbarContent`
                        )->tag( `ToggleButton`
                            )->a( n = `pressed` v = client->_bind( legend_shown )
                            )->a( n = `icon`    v = `sap-icon://legend`

                    )->end(

                    )->ele( `rows`
                        )->ele( `PlanningCalendarRow`
                            )->a( n = `icon`            v = `{PIC}`
                            )->a( n = `title`           v = `{NAME}`
                            )->a( n = `text`            v = `{ROLE}`
                            )->a( n = `specialDates`    v = `{path: 'T_SPECIALS', templateShareable: false}`
                            )->a( n = `appointments`    v = `{path: 'T_APPOINTMENTS', templateShareable: false}`
                            )->a( n = `intervalHeaders` v = `{path: 'T_HEADERS', templateShareable: false}`

                            )->ele( `specialDates`
                                )->tag( n = `DateTypeRange` ns = `unified`
                                    )->a( n = `startDate`     v = `{ path: 'START_AT', formatter: 'Formatter.DateCreateObject' }`
                                    )->a( n = `endDate`       v = `{ path: 'END_AT', formatter: 'Formatter.DateCreateObject' }`
                                    )->a( n = `type`          v = `{TYPE}`
                                    )->a( n = `secondaryType` v = `{SECONDARYTYPE}`

                            )->end(
                            )->ele( `appointments`
                                )->tag( n = `CalendarAppointment` ns = `unified`
                                    )->a( n = `startDate` v = `{ path: 'START_AT', formatter: 'Formatter.DateCreateObject' }`
                                    )->a( n = `endDate`   v = `{ path: 'END_AT', formatter: 'Formatter.DateCreateObject' }`
                                    )->a( n = `icon`      v = `{PIC}`
                                    )->a( n = `title`     v = `{TITLE}`
                                    )->a( n = `text`      v = `{INFO}`
                                    )->a( n = `type`      v = `{TYPE}`
                                    )->a( n = `tentative` v = `{TENTATIVE}`

                            )->end(
                            )->ele( `intervalHeaders`
                                )->tag( n = `CalendarAppointment` ns = `unified`
                                    )->a( n = `startDate` v = `{ path: 'START_AT', formatter: 'Formatter.DateCreateObject' }`
                                    )->a( n = `endDate`   v = `{ path: 'END_AT', formatter: 'Formatter.DateCreateObject' }`
                                    )->a( n = `icon`      v = `{PIC}`
                                    )->a( n = `title`     v = `{TITLE}`
                                    )->a( n = `type`      v = `{TYPE}`

                            )->end(
                        )->end(
                    )->end(

                    )->ele( `specialDates`
                        )->tag( n = `DateTypeRange` ns = `unified`
                            )->a( n = `startDate` v = `{ path: 'START_AT', formatter: 'Formatter.DateCreateObject' }`
                            )->a( n = `endDate`   v = `{ path: 'END_AT', formatter: 'Formatter.DateCreateObject' }`
                            )->a( n = `type`      v = `{TYPE}`
                            )->a( n = `color`     v = `{COLOR}`

                    )->end(
                )->end(
            )->end(

            )->ele( n = `sideContent` ns = `l`
                )->a( n = `width` v = `200px`

                )->ele( `PlanningCalendarLegend`
                    )->a( n = `id`               v = `PlanningCalendarLegend`
                    " ROOT-level aggregations - a bare 'T_' path is RELATIVE and resolves
                    " against nothing outside a row context, and an unbound table is not
                    " serialized at all (app 553 has the same two fixes)
                    )->a( n = `items`            v = |\{ path: '{ client->_bind_path( t_legend_items ) }', templateShareable: true \}|
                    )->a( n = `appointmentItems` v = |\{ path: '{ client->_bind_path( t_legend_appt_items ) }', templateShareable: true \}|
                    " changeStandardItemsPerView swaps Selected for WorkingDay off the
                    " OneMonth view; the property is bindable, so the expression over
                    " the shared view key carries the same switch
                    )->a( n = `standardItems`    v = |\{= ${ client->_bind( view_key ) } === 'One Month' ? ['Today','Selected','NonWorkingDay'] : ['Today','WorkingDay','NonWorkingDay'] \}|

                    )->ele( `items`
                        )->tag( n = `CalendarLegendItem` ns = `unified`
                            )->a( n = `text`    v = `{TEXT}`
                            )->a( n = `type`    v = `{TYPE}`
                            )->a( n = `tooltip` v = `{TEXT}`
                            )->a( n = `color`   v = `{COLOR}`

                    )->end(
                    )->ele( `appointmentItems`
                        )->tag( n = `CalendarLegendItem` ns = `unified`
                            )->a( n = `text`    v = `{TEXT}`
                            )->a( n = `type`    v = `{TYPE}`
                            )->a( n = `tooltip` v = `{TEXT}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.
    DATA temp1 LIKE t_people.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp9 TYPE z2ui5_cl_smpc_app_541=>ty_t_special.
    DATA temp10 LIKE LINE OF temp9.
    DATA temp11 TYPE z2ui5_cl_smpc_app_541=>ty_t_appointment.
    DATA temp12 LIKE LINE OF temp11.
    DATA temp13 TYPE z2ui5_cl_smpc_app_541=>ty_t_header.
    DATA temp14 LIKE LINE OF temp13.
    DATA temp15 TYPE z2ui5_cl_smpc_app_541=>ty_t_special.
    DATA temp16 LIKE LINE OF temp15.
    DATA temp17 TYPE z2ui5_cl_smpc_app_541=>ty_t_appointment.
    DATA temp18 LIKE LINE OF temp17.
    DATA temp19 TYPE z2ui5_cl_smpc_app_541=>ty_t_header.
    DATA temp20 LIKE LINE OF temp19.
    DATA temp21 TYPE z2ui5_cl_smpc_app_541=>ty_t_special.
    DATA temp22 LIKE LINE OF temp21.
    DATA temp23 TYPE z2ui5_cl_smpc_app_541=>ty_t_appointment.
    DATA temp24 LIKE LINE OF temp23.
    DATA temp25 TYPE z2ui5_cl_smpc_app_541=>ty_t_header.
    DATA temp26 LIKE LINE OF temp25.
    DATA temp3 TYPE z2ui5_cl_smpc_app_541=>ty_t_special.
    DATA temp4 LIKE LINE OF temp3.
    DATA temp5 TYPE z2ui5_cl_smpc_app_541=>ty_t_legend.
    DATA temp6 LIKE LINE OF temp5.
    DATA temp7 TYPE z2ui5_cl_smpc_app_541=>ty_t_legend.
    DATA temp8 LIKE LINE OF temp7.

    start_date   = `2017-01-15T08:00:00`.
    legend_shown = abap_false.
    view_key     = `Hour`.
    first_day    = `-1`.

    " a flat ABAP row serializes EVERY field, so a special date the sample gives
    " no secondaryType would send an empty string - which overrides the
    " CalendarDayType enum DEFAULT and takes the whole view down (the b45
    " lesson of apps 531/532); the default None is therefore seeded explicitly
    
    CLEAR temp1.
    
    temp2-pic = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/John_Miller.png`.
    temp2-name = `John Miller`.
    temp2-role = `team member`.
    
    CLEAR temp9.
    
    temp10-start_at = `2017-01-24T00:00:00`.
    temp10-type = `NonWorking`.
    temp10-secondarytype = `None`.
    INSERT temp10 INTO TABLE temp9.
    temp10-start_at = `2017-01-22T00:00:00`.
    temp10-type = `Type10`.
    temp10-secondarytype = `Working`.
    INSERT temp10 INTO TABLE temp9.
    temp2-t_specials = temp9.
    
    CLEAR temp11.
    
    temp12-start_at = `2017-01-08T08:30:00`.
    temp12-end_at = `2017-01-08T09:30:00`.
    temp12-title = `Meet Max Mustermann`.
    temp12-type = `Type02`.
    temp12-tentative = abap_false.
    INSERT temp12 INTO TABLE temp11.
    temp12-start_at = `2017-01-11T10:00:00`.
    temp12-end_at = `2017-01-11T12:00:00`.
    temp12-title = `Team meeting`.
    temp12-info = `room 1`.
    temp12-type = `Type01`.
    temp12-pic = `sap-icon://sap-ui5`.
    temp12-tentative = abap_false.
    INSERT temp12 INTO TABLE temp11.
    temp12-start_at = `2017-01-12T11:30:00`.
    temp12-end_at = `2017-01-12T13:30:00`.
    temp12-title = `Lunch`.
    temp12-info = `canteen`.
    temp12-type = `Type03`.
    temp12-tentative = abap_true.
    INSERT temp12 INTO TABLE temp11.
    temp12-start_at = `2017-01-15T08:30:00`.
    temp12-end_at = `2017-01-15T09:30:00`.
    temp12-title = `Meet Max Mustermann`.
    temp12-type = `Type02`.
    temp12-tentative = abap_false.
    INSERT temp12 INTO TABLE temp11.
    temp12-start_at = `2017-01-15T10:00:00`.
    temp12-end_at = `2017-01-15T12:00:00`.
    temp12-title = `Team meeting`.
    temp12-info = `room 1`.
    temp12-type = `Type01`.
    temp12-pic = `sap-icon://sap-ui5`.
    temp12-tentative = abap_false.
    INSERT temp12 INTO TABLE temp11.
    temp12-start_at = `2017-01-15T11:30:00`.
    temp12-end_at = `2017-01-15T13:30:00`.
    temp12-title = `Lunch`.
    temp12-info = `canteen`.
    temp12-type = `Type03`.
    temp12-tentative = abap_true.
    INSERT temp12 INTO TABLE temp11.
    temp12-start_at = `2017-01-15T13:30:00`.
    temp12-end_at = `2017-01-15T17:30:00`.
    temp12-title = `Discussion with clients`.
    temp12-info = `online meeting`.
    temp12-type = `Type02`.
    temp12-tentative = abap_false.
    INSERT temp12 INTO TABLE temp11.
    temp12-start_at = `2017-01-16T04:00:00`.
    temp12-end_at = `2017-01-16T22:30:00`.
    temp12-title = `Discussion of the plan`.
    temp12-info = `Online meeting`.
    temp12-type = `Type04`.
    temp12-tentative = abap_false.
    INSERT temp12 INTO TABLE temp11.
    temp12-start_at = `2017-01-18T08:30:00`.
    temp12-end_at = `2017-01-18T09:30:00`.
    temp12-title = `Meeting with the manager`.
    temp12-type = `Type02`.
    temp12-tentative = abap_false.
    INSERT temp12 INTO TABLE temp11.
    temp12-start_at = `2017-01-18T11:30:00`.
    temp12-end_at = `2017-01-18T13:30:00`.
    temp12-title = `Lunch`.
    temp12-info = `canteen`.
    temp12-type = `Type03`.
    temp12-tentative = abap_true.
    INSERT temp12 INTO TABLE temp11.
    temp12-start_at = `2017-01-18T01:00:00`.
    temp12-end_at = `2017-01-18T22:00:00`.
    temp12-title = `Team meeting`.
    temp12-info = `regular`.
    temp12-type = `Type01`.
    temp12-pic = `sap-icon://sap-ui5`.
    temp12-tentative = abap_false.
    INSERT temp12 INTO TABLE temp11.
    temp12-start_at = `2017-01-21T00:30:00`.
    temp12-end_at = `2017-01-21T23:30:00`.
    temp12-title = `New Product`.
    temp12-info = `room 105`.
    temp12-type = `Type03`.
    temp12-tentative = abap_true.
    INSERT temp12 INTO TABLE temp11.
    temp12-start_at = `2017-01-25T11:30:00`.
    temp12-end_at = `2017-01-25T13:30:00`.
    temp12-title = `Lunch`.
    temp12-type = `Type03`.
    temp12-tentative = abap_true.
    INSERT temp12 INTO TABLE temp11.
    temp12-start_at = `2017-01-29T10:00:00`.
    temp12-end_at = `2017-01-29T12:00:00`.
    temp12-title = `Team meeting`.
    temp12-info = `room 1`.
    temp12-type = `Type01`.
    temp12-pic = `sap-icon://sap-ui5`.
    temp12-tentative = abap_false.
    INSERT temp12 INTO TABLE temp11.
    temp12-start_at = `2017-01-30T08:30:00`.
    temp12-end_at = `2017-01-30T09:30:00`.
    temp12-title = `Meet Max Mustermann`.
    temp12-type = `Type02`.
    temp12-tentative = abap_false.
    INSERT temp12 INTO TABLE temp11.
    temp12-start_at = `2017-01-30T10:00:00`.
    temp12-end_at = `2017-01-30T12:00:00`.
    temp12-title = `Team meeting`.
    temp12-info = `room 1`.
    temp12-type = `Type01`.
    temp12-pic = `sap-icon://sap-ui5`.
    temp12-tentative = abap_false.
    INSERT temp12 INTO TABLE temp11.
    temp12-start_at = `2017-01-30T11:30:00`.
    temp12-end_at = `2017-01-30T13:30:00`.
    temp12-title = `Lunch`.
    temp12-type = `Type03`.
    temp12-tentative = abap_true.
    INSERT temp12 INTO TABLE temp11.
    temp12-start_at = `2017-01-30T13:30:00`.
    temp12-end_at = `2017-01-30T17:30:00`.
    temp12-title = `Discussion with clients`.
    temp12-type = `Type02`.
    temp12-tentative = abap_false.
    INSERT temp12 INTO TABLE temp11.
    temp12-start_at = `2017-01-31T10:00:00`.
    temp12-end_at = `2017-01-31T11:30:00`.
    temp12-title = `Discussion of the plan`.
    temp12-info = `Online meeting`.
    temp12-type = `Type04`.
    temp12-tentative = abap_false.
    INSERT temp12 INTO TABLE temp11.
    temp12-start_at = `2017-02-03T08:30:00`.
    temp12-end_at = `2017-02-13T09:30:00`.
    temp12-title = `Meeting with the manager`.
    temp12-type = `Type02`.
    temp12-tentative = abap_false.
    INSERT temp12 INTO TABLE temp11.
    temp12-start_at = `2017-02-04T10:00:00`.
    temp12-end_at = `2017-02-04T12:00:00`.
    temp12-title = `Team meeting`.
    temp12-info = `room 1`.
    temp12-type = `Type01`.
    temp12-pic = `sap-icon://sap-ui5`.
    temp12-tentative = abap_false.
    INSERT temp12 INTO TABLE temp11.
    temp12-start_at = `2017-03-30T10:00:00`.
    temp12-end_at = `2017-06-02T12:00:00`.
    temp12-title = `Working out of the building`.
    temp12-type = `Type07`.
    temp12-pic = `sap-icon://sap-ui5`.
    temp12-tentative = abap_false.
    INSERT temp12 INTO TABLE temp11.
    temp2-t_appointments = temp11.
    
    CLEAR temp13.
    
    temp14-start_at = `2017-01-15T08:00:00`.
    temp14-end_at = `2017-01-15T10:00:00`.
    temp14-title = `Reminder`.
    temp14-type = `Type06`.
    INSERT temp14 INTO TABLE temp13.
    temp14-start_at = `2017-01-15T17:00:00`.
    temp14-end_at = `2017-01-15T19:00:00`.
    temp14-title = `Reminder`.
    temp14-type = `Type06`.
    INSERT temp14 INTO TABLE temp13.
    temp14-start_at = `2017-09-01T00:00:00`.
    temp14-end_at = `2017-11-30T23:59:00`.
    temp14-title = `New quarter`.
    temp14-type = `Type10`.
    INSERT temp14 INTO TABLE temp13.
    temp14-start_at = `2018-02-01T00:00:00`.
    temp14-end_at = `2018-04-30T23:59:00`.
    temp14-title = `New quarter`.
    temp14-type = `Type10`.
    INSERT temp14 INTO TABLE temp13.
    temp2-t_headers = temp13.
    INSERT temp2 INTO TABLE temp1.
    temp2-pic = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/Donna_Moore.jpg`.
    temp2-name = `Donna Moore`.
    temp2-role = `team member`.
    
    CLEAR temp15.
    
    temp16-start_at = `2017-01-13T00:00:00`.
    temp16-type = `NonWorking`.
    temp16-secondarytype = `None`.
    INSERT temp16 INTO TABLE temp15.
    temp2-t_specials = temp15.
    
    CLEAR temp17.
    
    temp18-start_at = `2017-01-10T18:00:00`.
    temp18-end_at = `2017-01-10T19:10:00`.
    temp18-title = `Discussion of the plan`.
    temp18-info = `Online meeting`.
    temp18-type = `Type04`.
    temp18-tentative = abap_false.
    INSERT temp18 INTO TABLE temp17.
    temp18-start_at = `2017-01-09T10:00:00`.
    temp18-end_at = `2017-01-12T12:00:00`.
    temp18-title = `Workshop out of the country`.
    temp18-type = `Type07`.
    temp18-pic = `sap-icon://sap-ui5`.
    temp18-tentative = abap_false.
    INSERT temp18 INTO TABLE temp17.
    temp18-start_at = `2017-01-15T08:00:00`.
    temp18-end_at = `2017-01-15T09:30:00`.
    temp18-title = `Discussion of the plan`.
    temp18-info = `Online meeting`.
    temp18-type = `Type04`.
    temp18-tentative = abap_false.
    INSERT temp18 INTO TABLE temp17.
    temp18-start_at = `2017-01-15T10:00:00`.
    temp18-end_at = `2017-01-15T12:00:00`.
    temp18-title = `Team meeting`.
    temp18-info = `room 1`.
    temp18-type = `Type01`.
    temp18-pic = `sap-icon://sap-ui5`.
    temp18-tentative = abap_false.
    INSERT temp18 INTO TABLE temp17.
    temp18-start_at = `2017-01-15T18:00:00`.
    temp18-end_at = `2017-01-15T19:10:00`.
    temp18-title = `Discussion of the plan`.
    temp18-info = `Online meeting`.
    temp18-type = `Type04`.
    temp18-tentative = abap_false.
    INSERT temp18 INTO TABLE temp17.
    temp18-start_at = `2017-01-16T10:00:00`.
    temp18-end_at = `2017-01-31T12:00:00`.
    temp18-title = `Workshop out of the country`.
    temp18-type = `Type07`.
    temp18-pic = `sap-icon://sap-ui5`.
    temp18-tentative = abap_false.
    INSERT temp18 INTO TABLE temp17.
    temp18-start_at = `2018-01-01T00:00:00`.
    temp18-end_at = `2018-03-31T23:59:00`.
    temp18-title = `New quarter`.
    temp18-type = `Type10`.
    temp18-tentative = abap_false.
    INSERT temp18 INTO TABLE temp17.
    temp18-start_at = `2017-02-11T10:00:00`.
    temp18-end_at = `2017-03-20T12:00:00`.
    temp18-title = `Team collaboration`.
    temp18-info = `room 1`.
    temp18-type = `Type01`.
    temp18-pic = `sap-icon://sap-ui5`.
    temp18-tentative = abap_false.
    INSERT temp18 INTO TABLE temp17.
    temp18-start_at = `2017-04-01T10:00:00`.
    temp18-end_at = `2017-05-01T12:00:00`.
    temp18-title = `Workshop out of the country`.
    temp18-type = `Type07`.
    temp18-pic = `sap-icon://sap-ui5`.
    temp18-tentative = abap_false.
    INSERT temp18 INTO TABLE temp17.
    temp18-start_at = `2017-05-01T10:00:00`.
    temp18-end_at = `2017-05-31T12:00:00`.
    temp18-title = `Out of the office`.
    temp18-type = `Type08`.
    temp18-tentative = abap_false.
    INSERT temp18 INTO TABLE temp17.
    temp18-start_at = `2017-08-01T00:00:00`.
    temp18-end_at = `2017-08-31T23:59:00`.
    temp18-title = `Vacation`.
    temp18-info = `out of office`.
    temp18-type = `Type04`.
    temp18-tentative = abap_false.
    INSERT temp18 INTO TABLE temp17.
    temp2-t_appointments = temp17.
    
    CLEAR temp19.
    
    temp20-start_at = `2017-01-15T09:00:00`.
    temp20-end_at = `2017-01-15T10:00:00`.
    temp20-title = `Payment reminder`.
    temp20-type = `Type06`.
    INSERT temp20 INTO TABLE temp19.
    temp20-start_at = `2017-01-15T16:30:00`.
    temp20-end_at = `2017-01-15T18:00:00`.
    temp20-title = `Private appointment`.
    temp20-type = `Type06`.
    INSERT temp20 INTO TABLE temp19.
    temp2-t_headers = temp19.
    INSERT temp2 INTO TABLE temp1.
    temp2-pic = `sap-icon://employee`.
    temp2-name = `Max Mustermann`.
    temp2-role = `team member`.
    
    CLEAR temp21.
    
    temp22-start_at = `2017-01-16T00:00:00`.
    temp22-end_at = `2017-01-18T00:00:00`.
    temp22-type = `NonWorking`.
    temp22-secondarytype = `None`.
    INSERT temp22 INTO TABLE temp21.
    temp2-t_specials = temp21.
    
    CLEAR temp23.
    
    temp24-start_at = `2017-01-15T08:30:00`.
    temp24-end_at = `2017-01-15T09:30:00`.
    temp24-title = `Meet John Miller`.
    temp24-type = `Type02`.
    temp24-tentative = abap_false.
    INSERT temp24 INTO TABLE temp23.
    temp24-start_at = `2017-01-15T10:00:00`.
    temp24-end_at = `2017-01-15T12:00:00`.
    temp24-title = `Team meeting`.
    temp24-info = `room 1`.
    temp24-type = `Type01`.
    temp24-pic = `sap-icon://sap-ui5`.
    temp24-tentative = abap_false.
    INSERT temp24 INTO TABLE temp23.
    temp24-start_at = `2017-01-15T13:00:00`.
    temp24-end_at = `2017-01-15T16:00:00`.
    temp24-title = `Discussion with clients`.
    temp24-info = `online`.
    temp24-type = `Type02`.
    temp24-tentative = abap_false.
    INSERT temp24 INTO TABLE temp23.
    temp24-start_at = `2017-01-16T00:00:00`.
    temp24-end_at = `2017-01-16T23:59:00`.
    temp24-title = `Vacation`.
    temp24-info = `out of office`.
    temp24-type = `Type04`.
    temp24-tentative = abap_false.
    INSERT temp24 INTO TABLE temp23.
    temp24-start_at = `2017-01-19T08:30:00`.
    temp24-end_at = `2017-01-19T18:30:00`.
    temp24-title = `Meet John Doe`.
    temp24-type = `Type02`.
    temp24-tentative = abap_false.
    INSERT temp24 INTO TABLE temp23.
    temp24-start_at = `2017-01-19T10:00:00`.
    temp24-end_at = `2017-01-19T16:00:00`.
    temp24-title = `Team meeting`.
    temp24-info = `room 1`.
    temp24-type = `Type01`.
    temp24-pic = `sap-icon://sap-ui5`.
    temp24-tentative = abap_false.
    INSERT temp24 INTO TABLE temp23.
    temp24-start_at = `2017-01-19T07:00:00`.
    temp24-end_at = `2017-01-19T17:30:00`.
    temp24-title = `Discussion with clients`.
    temp24-type = `Type02`.
    temp24-tentative = abap_false.
    INSERT temp24 INTO TABLE temp23.
    temp24-start_at = `2017-01-20T00:00:00`.
    temp24-end_at = `2017-01-20T23:59:00`.
    temp24-title = `Vacation`.
    temp24-info = `out of office`.
    temp24-type = `Type04`.
    temp24-tentative = abap_false.
    INSERT temp24 INTO TABLE temp23.
    temp24-start_at = `2017-01-22T07:00:00`.
    temp24-end_at = `2017-01-27T17:30:00`.
    temp24-title = `Discussion with clients`.
    temp24-info = `out of office`.
    temp24-type = `Type02`.
    temp24-tentative = abap_false.
    INSERT temp24 INTO TABLE temp23.
    temp24-start_at = `2017-03-13T09:00:00`.
    temp24-end_at = `2017-03-17T10:00:00`.
    temp24-title = `Payment week`.
    temp24-type = `Type06`.
    INSERT temp24 INTO TABLE temp23.
    temp24-start_at = `2017-04-10T00:00:00`.
    temp24-end_at = `2017-06-16T23:59:00`.
    temp24-title = `Vacation`.
    temp24-info = `out of office`.
    temp24-type = `Type04`.
    temp24-tentative = abap_false.
    INSERT temp24 INTO TABLE temp23.
    temp24-start_at = `2017-08-01T00:00:00`.
    temp24-end_at = `2017-10-31T23:59:00`.
    temp24-title = `New quarter`.
    temp24-type = `Type10`.
    temp24-tentative = abap_false.
    INSERT temp24 INTO TABLE temp23.
    temp2-t_appointments = temp23.
    
    CLEAR temp25.
    
    temp26-start_at = `2017-01-16T00:00:00`.
    temp26-end_at = `2017-01-16T23:59:00`.
    temp26-title = `Private`.
    temp26-type = `Type05`.
    INSERT temp26 INTO TABLE temp25.
    temp2-t_headers = temp25.
    INSERT temp2 INTO TABLE temp1.
    t_people = temp1.

    
    CLEAR temp3.
    
    temp4-start_at = `2017-01-15T00:00:00`.
    temp4-end_at = `2017-01-15T00:00:00`.
    temp4-type = `Working`.
    INSERT temp4 INTO TABLE temp3.
    temp4-start_at = `2017-01-16T00:00:00`.
    temp4-end_at = `2017-01-18T00:00:00`.
    temp4-type = `Type07`.
    INSERT temp4 INTO TABLE temp3.
    temp4-start_at = `2017-01-19T00:00:00`.
    temp4-end_at = `2017-01-19T23:59:00`.
    temp4-type = `Type08`.
    INSERT temp4 INTO TABLE temp3.
    temp4-start_at = `2017-01-21T00:00:00`.
    temp4-end_at = `2017-01-21T23:59:00`.
    temp4-type = `Type05`.
    temp4-color = `#ff69b4`.
    INSERT temp4 INTO TABLE temp3.
    temp4-start_at = `2017-01-22T00:00:00`.
    temp4-end_at = `2017-01-22T23:59:00`.
    temp4-type = `Type04`.
    temp4-color = `#add8e6`.
    INSERT temp4 INTO TABLE temp3.
    temp4-start_at = `2017-07-24T00:00:00`.
    temp4-end_at = `2017-07-24T23:59:00`.
    temp4-type = `Type09`.
    INSERT temp4 INTO TABLE temp3.
    temp4-start_at = `2017-07-25T00:00:00`.
    temp4-end_at = `2017-07-25T23:59:00`.
    temp4-type = `Type14`.
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
    temp6-type = `Type05`.
    temp6-color = `#ff69b4`.
    INSERT temp6 INTO TABLE temp5.
    temp6-text = `Work from office 2`.
    temp6-type = `Type04`.
    temp6-color = `#add8e6`.
    INSERT temp6 INTO TABLE temp5.
    t_legend_items = temp5.

    
    CLEAR temp7.
    
    temp8-text = `Reminder`.
    temp8-type = `Type06`.
    INSERT temp8 INTO TABLE temp7.
    temp8-text = `Client meeting`.
    temp8-type = `Type02`.
    INSERT temp8 INTO TABLE temp7.
    temp8-text = `Team meeting`.
    temp8-type = `Type01`.
    INSERT temp8 INTO TABLE temp7.
    temp8-text = `Planning`.
    temp8-type = `Type04`.
    INSERT temp8 INTO TABLE temp7.
    temp8-text = `Out of office`.
    temp8-type = `Type03`.
    INSERT temp8 INTO TABLE temp7.
    temp8-text = `Customer Initiative`.
    temp8-type = `Type07`.
    INSERT temp8 INTO TABLE temp7.
    t_legend_appt_items = temp7.

  ENDMETHOD.

ENDCLASS.
