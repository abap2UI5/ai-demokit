" @keywords singleplanningcalendar single planning calendar sap.m singleplanningcalendarrecurringitem vbox overflowtoolbar button toolbarseparator recurringnonworkingperiod timerange
" @summary SinglePlanningCalendar with recurring calendar items
CLASS z2ui5_cl_smpc_app_555 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    " RecurrenceRule.days is an int[]: a table of STRINGS serializes to ['1','2']
    " and UI5 rejects it, so the day tables are integer tables
    TYPES ty_t_int TYPE STANDARD TABLE OF i WITH DEFAULT KEY.
    TYPES: BEGIN OF ty_s_appointment,
             start_at          TYPE string,
             end_at            TYPE string,
             title             TYPE string,
             text              TYPE string,
             type              TYPE string,
             recurrencetype    TYPE string,
             recurrencepattern TYPE i,
             recurrenceenddate TYPE string,
             t_recurrence_day  TYPE ty_t_int,
             ruletype          TYPE string,
             ruledayofmonth    TYPE i,
             ruleweekofmonth   TYPE string,
             ruledayofweek     TYPE i,
             rulemonth         TYPE i,
           END OF ty_s_appointment.
    TYPES ty_t_appointment TYPE STANDARD TABLE OF ty_s_appointment WITH DEFAULT KEY.

    TYPES: BEGIN OF ty_s_non_working,
             date_at           TYPE string,
             start_at          TYPE string,
             end_at            TYPE string,
             valueformat       TYPE string,
             title             TYPE string,
             recurrencetype    TYPE string,
             recurrencepattern TYPE i,
             recurrenceenddate TYPE string,
             t_recurrence_day  TYPE ty_t_int,
           END OF ty_s_non_working.
    TYPES ty_t_non_working TYPE STANDARD TABLE OF ty_s_non_working WITH DEFAULT KEY.

    DATA t_appointments TYPE ty_t_appointment.
    DATA t_non_working  TYPE ty_t_non_working.
    DATA start_date     TYPE string.

    " the create dialog's own model, folded to fields (see sidecar)
    DATA c_title       TYPE string.
    DATA c_text        TYPE string.
    DATA c_type        TYPE string.
    DATA c_start       TYPE string.
    DATA c_end         TYPE string.
    DATA c_rec_type    TYPE string.
    DATA c_rec_pattern TYPE string.
    DATA c_rec_days    TYPE string_table.
    DATA c_rec_end     TYPE string.
    DATA c_rule_type   TYPE string.
    DATA c_rule_dom    TYPE string.
    DATA c_rule_wom    TYPE string.
    DATA c_rule_dow    TYPE string.
    DATA c_rule_month  TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popup_create_display.
    METHODS create_reset.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_555 IMPLEMENTATION.

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
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " the calendar date properties are typed "object" and demand a real JS Date;
    " the model keeps ISO strings and Formatter.DateCreateObject converts them
    
    CLEAR temp1.
    INSERT `MESSAGE_TOAST` INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    INSERT `'viewChange' event fired.` INTO TABLE temp1.
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

                )->tag( `Button`
                    )->a( n = `text`  v = `Create Appointment`
                    )->a( n = `icon`  v = `sap-icon://add-activity`
                    )->a( n = `press` v = client->_event( `CREATE_APPOINTMENT` )
                    )->a( n = `type`  v = `Emphasized`
                )->tag( `ToolbarSeparator`

            )->end(

            )->ele( `SinglePlanningCalendar`
                )->a( n = `id`                v = `SPC1`
                )->a( n = `class`             v = `sapUiSmallMarginTop`
                )->a( n = `title`             v = `My Calendar`
                " handleViewChange only toasts a constant text - composed on the client
                )->a( n = `viewChange`        v = client->follow_up_action(
                          val   = client->cs_event-control_global
                          t_arg = temp1 )
                )->a( n = `startDate`         v = |\{ path: '{ client->_bind_path( start_date ) }', formatter: 'Formatter.DateCreateObject' \}|
                " ROOT-level aggregations: the path has to be the model path
                " client->_bind_path( ) resolves to. A bare 'T_' is
                " RELATIVE, which is right only inside a row-bound aggregation
                " (apps 536/545 bind their rows' tables that way) - here it
                " resolved against nothing and the calendar came up with zero
                " appointments (e2e-caught 2026-08-22)
                )->a( n = `nonWorkingPeriods` v = |\{ path: '{ client->_bind_path( t_non_working ) }', templateShareable: false \}|
                )->a( n = `appointments`      v = |\{ path: '{ client->_bind_path( t_appointments ) }', templateShareable: false \}|

                )->ele( `nonWorkingPeriods`
                    )->ele( n = `RecurringNonWorkingPeriod` ns = `unified`
                        )->a( n = `date`              v = `{ path: 'DATE_AT', formatter: 'Formatter.DateCreateObject' }`
                        )->a( n = `recurrenceType`    v = |\{= $\{RECURRENCETYPE\} \|\| null \}|
                        " setRecurrencePattern raises "recurrencePattern must be >= 1" here too,
                        " and no ABAP writes a non-working row - the appointments get their 1
                        " from CREATE_SAVE, these get it from the binding (see sidecar)
                        )->a( n = `recurrencePattern` v = `{= ${RECURRENCEPATTERN} || 1 }`
                        )->a( n = `recurrenceEndDate` v = `{ path: 'RECURRENCEENDDATE', formatter: 'Formatter.DateCreateObject' }`

                        )->ele( n = `timeRange` ns = `unified`
                            )->tag( n = `TimeRange` ns = `unified`
                                )->a( n = `start`       v = `{START_AT}`
                                )->a( n = `end`         v = `{END_AT}`
                                )->a( n = `valueFormat` v = `{VALUEFORMAT}`

                        )->end(
                        )->ele( n = `recurrenceRule` ns = `unified`
                            )->tag( n = `RecurrenceRule` ns = `unified`
                                )->a( n = `days` v = `{T_RECURRENCE_DAY}`

                        )->end(
                    )->end(
                )->end(

                )->ele( `appointments`
                    )->ele( n = `RecurringCalendarAppointment` ns = `unified`
                        )->a( n = `startDate`         v = `{ path: 'START_AT', formatter: 'Formatter.DateCreateObject' }`
                        )->a( n = `endDate`           v = `{ path: 'END_AT', formatter: 'Formatter.DateCreateObject' }`
                        )->a( n = `title`             v = `{TITLE}`
                        )->a( n = `text`              v = `{TEXT}`
                        )->a( n = `type`              v = `{TYPE}`
                        )->a( n = `recurrenceType`    v = |\{= $\{RECURRENCETYPE\} \|\| null \}|
                        )->a( n = `recurrencePattern` v = `{RECURRENCEPATTERN}`
                        )->a( n = `recurrenceEndDate` v = `{ path: 'RECURRENCEENDDATE', formatter: 'Formatter.DateCreateObject' }`

                        )->ele( n = `recurrenceRule` ns = `unified`
                            )->tag( n = `RecurrenceRule` ns = `unified`
                                )->a( n = `days`        v = `{T_RECURRENCE_DAY}`
                                )->a( n = `type`        v = |\{= $\{RULETYPE\} \|\| null \}|
                                )->a( n = `dayOfMonth`  v = `{RULEDAYOFMONTH}`
                                )->a( n = `weekOfMonth` v = |\{= $\{RULEWEEKOFMONTH\} \|\| null \}|
                                )->a( n = `dayOfWeek`   v = `{RULEDAYOFWEEK}`
                                )->a( n = `month`       v = `{RULEMONTH}`

                        )->end(
                    )->end(
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
                        )->a( n = `title` v = `Month` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD popup_create_display.

    DATA popup TYPE REF TO z2ui5_cl_ui5_view_builder.
    popup = z2ui5_cl_ui5_view_builder=>factory( ).

    popup->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:form` v = `sap.ui.layout.form`

        )->ele( `Dialog`
            )->a( n = `title`        v = `Create Appointment`
            )->a( n = `contentWidth` v = `500px`

            )->ele( `customData`
                )->tag( n = `CustomData` ns = `core`
                    )->a( n = `key` v = `model`

            )->end(

            )->ele( `content`
                )->ele( n = `SimpleForm` ns = `form`
                    )->a( n = `editable`    v = `true`
                    )->a( n = `layout`      v = `ResponsiveGridLayout`
                    )->a( n = `labelSpanXL` v = `4`
                    )->a( n = `labelSpanL`  v = `4`
                    )->a( n = `labelSpanM`  v = `4`
                    )->a( n = `labelSpanS`  v = `12`
                    )->a( n = `emptySpanXL` v = `0`
                    )->a( n = `emptySpanL`  v = `0`
                    )->a( n = `emptySpanM`  v = `0`
                    )->a( n = `columnsXL`   v = `1`
                    )->a( n = `columnsL`    v = `1`
                    )->a( n = `columnsM`    v = `1`

                    )->tag( n = `Title` ns = `core`
                        )->a( n = `text` v = `General`
                    )->tag( `Label`
                        )->a( n = `text`     v = `Title`
                        )->a( n = `required` v = `true`
                    )->tag( `Input`
                        )->a( n = `value`       v = client->_bind( c_title )
                        )->a( n = `placeholder` v = `Appointment title`
                    )->tag( `Label`
                        )->a( n = `text` v = `Description`
                    )->tag( `Input`
                        )->a( n = `value`       v = client->_bind( c_text )
                        )->a( n = `placeholder` v = `Optional description`
                    )->tag( `Label`
                        )->a( n = `text` v = `Type`

                    )->ele( `Select`
                        )->a( n = `selectedKey` v = client->_bind( c_type )

                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `Type01`
                            )->a( n = `text` v = `Type 01`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `Type02`
                            )->a( n = `text` v = `Type 02`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `Type03`
                            )->a( n = `text` v = `Type 03`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `Type04`
                            )->a( n = `text` v = `Type 04`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `Type05`
                            )->a( n = `text` v = `Type 05`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `Type06`
                            )->a( n = `text` v = `Type 06`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `Type07`
                            )->a( n = `text` v = `Type 07`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `Type08`
                            )->a( n = `text` v = `Type 08`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `Type09`
                            )->a( n = `text` v = `Type 09`

                    )->end(

                    )->tag( n = `Title` ns = `core`
                        )->a( n = `text` v = `Date & Time`
                    )->tag( `Label`
                        )->a( n = `text` v = `Start`
                    )->tag( `DateTimePicker`
                        " The ORIGINAL binds this typed, with a pattern:
                        "   type: 'sap.ui.model.type.DateTime',
                        "   formatOptions: \{ pattern: 'yyyy-MM-dd HH:mm' \}
                        " The port kept the path and dropped both, so the picker wrote a
                        " LOCALE string back. Measured in de-DE: the user picks 4 March
                        " 2025, the model stores "04.03.2025, 10:15:00", and
                        " Formatter.DateCreateObject's new Date( ) reads it MONTH-first -
                        " the appointment is drawn on 3 April. valueFormat rather than the
                        " typed binding because this field seeds EMPTY on the recurrence
                        " picker, and a typed binding with a source pattern raises on the
                        " empty value a cleared picker sends (the app-549/609 reasoning)
                        )->a( n = `valueFormat`   v = `yyyy-MM-dd'T'HH:mm:ss`
                        )->a( n = `displayFormat` v = `yyyy-MM-dd HH:mm`
                        )->a( n = `value` v = client->_bind( c_start )
                    )->tag( `Label`
                        )->a( n = `text` v = `End`
                    )->tag( `DateTimePicker`
                        " see the Start picker above - same contract
                        )->a( n = `valueFormat`   v = `yyyy-MM-dd'T'HH:mm:ss`
                        )->a( n = `displayFormat` v = `yyyy-MM-dd HH:mm`
                        )->a( n = `value` v = client->_bind( c_end )

                    )->tag( n = `Title` ns = `core`
                        )->a( n = `text` v = `Recurrence (optional)`
                    )->tag( `Label`
                        )->a( n = `text` v = `Repeat`

                    )->ele( `Select`
                        )->a( n = `selectedKey` v = client->_bind( c_rec_type )
                        )->a( n = `change`      v = client->_event( `RECURRENCE_TYPE` )

                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = ``
                            )->a( n = `text` v = `Does not repeat`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `Daily`
                            )->a( n = `text` v = `Daily`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `Weekly`
                            )->a( n = `text` v = `Weekly`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `Monthly`
                            )->a( n = `text` v = `Monthly`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `Yearly`
                            )->a( n = `text` v = `Yearly`

                    )->end(

                    )->tag( `Label`
                        )->a( n = `text`    v = `Every`
                        )->a( n = `visible` v = |\{= ${ client->_bind( c_rec_type ) } !== '' \}|

                    )->ele( `HBox`
                        )->a( n = `alignItems` v = `Center`
                        )->a( n = `visible`    v = |\{= ${ client->_bind( c_rec_type ) } !== '' \}|

                        )->tag( `Input`
                            )->a( n = `value`       v = client->_bind( c_rec_pattern )
                            )->a( n = `type`        v = `Number`
                            )->a( n = `width`       v = `60px`
                            )->a( n = `placeholder` v = `1`
                        )->tag( `Text`
                            )->a( n = `text`  v = |\{= ${ client->_bind( c_rec_type ) } === 'Daily' ? 'day(s)' : | &&
                                                  |${ client->_bind( c_rec_type ) } === 'Weekly' ? 'week(s)' : | &&
                                                  |${ client->_bind( c_rec_type ) } === 'Monthly' ? 'month(s)' : 'year(s)' \}|
                            )->a( n = `class` v = `sapUiSmallMarginBegin`

                    )->end(

                    )->tag( `Label`
                        )->a( n = `text`    v = `On`
                        )->a( n = `visible` v = |\{= ${ client->_bind( c_rec_type ) } === 'Weekly' \}|

                    )->ele( `MultiComboBox`
                        )->a( n = `selectedKeys` v = client->_bind( c_rec_days )
                        )->a( n = `visible`      v = |\{= ${ client->_bind( c_rec_type ) } === 'Weekly' \}|

                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `0`
                            )->a( n = `text` v = `Sunday`
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

                    )->end(

                    )->tag( `Label`
                        )->a( n = `text`    v = `Repeat on`
                        )->a( n = `visible` v = |\{= ${ client->_bind( c_rec_type ) } === 'Monthly' \|\| ${ client->_bind( c_rec_type ) } === 'Yearly' \}|

                    )->ele( `Select`
                        )->a( n = `selectedKey` v = client->_bind( c_rule_type )
                        )->a( n = `visible`     v = |\{= ${ client->_bind( c_rec_type ) } === 'Monthly' \|\| ${ client->_bind( c_rec_type ) } === 'Yearly' \}|

                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `DayOfMonth`
                            )->a( n = `text` v = `A specific day of the month`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `DayOfWeek`
                            )->a( n = `text` v = `A specific day of the week`

                    )->end(

                    )->tag( `Label`
                        )->a( n = `text`    v = `On day`
                        )->a( n = `visible` v = |\{= (${ client->_bind( c_rec_type ) } === 'Monthly' \|\| ${ client->_bind( c_rec_type ) } === 'Yearly') && | &&
                                                 |${ client->_bind( c_rule_type ) } === 'DayOfMonth' \}|
                    )->tag( `Input`
                        )->a( n = `value`       v = client->_bind( c_rule_dom )
                        )->a( n = `type`        v = `Number`
                        )->a( n = `width`       v = `80px`
                        )->a( n = `visible`     v = |\{= (${ client->_bind( c_rec_type ) } === 'Monthly' \|\| ${ client->_bind( c_rec_type ) } === 'Yearly') && | &&
                                                     |${ client->_bind( c_rule_type ) } === 'DayOfMonth' \}|
                        )->a( n = `placeholder` v = `e.g. 15`

                    )->tag( `Label`
                        )->a( n = `text`    v = `On the`
                        )->a( n = `visible` v = |\{= (${ client->_bind( c_rec_type ) } === 'Monthly' \|\| ${ client->_bind( c_rec_type ) } === 'Yearly') && | &&
                                                 |${ client->_bind( c_rule_type ) } === 'DayOfWeek' \}|

                    )->ele( `HBox`
                        )->a( n = `alignItems` v = `Center`
                        )->a( n = `visible`    v = |\{= (${ client->_bind( c_rec_type ) } === 'Monthly' \|\| ${ client->_bind( c_rec_type ) } === 'Yearly') && | &&
                                                     |${ client->_bind( c_rule_type ) } === 'DayOfWeek' \}|

                        )->ele( `Select`
                            )->a( n = `selectedKey` v = client->_bind( c_rule_wom )

                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `First`
                                )->a( n = `text` v = `First`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `Second`
                                )->a( n = `text` v = `Second`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `Third`
                                )->a( n = `text` v = `Third`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `Fourth`
                                )->a( n = `text` v = `Fourth`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `Last`
                                )->a( n = `text` v = `Last`

                        )->end(
                        )->ele( `Select`
                            )->a( n = `selectedKey` v = client->_bind( c_rule_dow )
                            )->a( n = `class`       v = `sapUiSmallMarginBegin`

                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `0`
                                )->a( n = `text` v = `Sunday`
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

                        )->end(
                    )->end(

                    )->tag( `Label`
                        )->a( n = `text`    v = `In`
                        )->a( n = `visible` v = |\{= ${ client->_bind( c_rec_type ) } === 'Yearly' \}|

                    )->ele( `Select`
                        )->a( n = `selectedKey` v = client->_bind( c_rule_month )
                        )->a( n = `visible`     v = |\{= ${ client->_bind( c_rec_type ) } === 'Yearly' \}|

                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `0`
                            )->a( n = `text` v = `January`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `1`
                            )->a( n = `text` v = `February`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `2`
                            )->a( n = `text` v = `March`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `3`
                            )->a( n = `text` v = `April`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `4`
                            )->a( n = `text` v = `May`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `5`
                            )->a( n = `text` v = `June`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `6`
                            )->a( n = `text` v = `July`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `7`
                            )->a( n = `text` v = `August`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `8`
                            )->a( n = `text` v = `September`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `9`
                            )->a( n = `text` v = `October`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `10`
                            )->a( n = `text` v = `November`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `11`
                            )->a( n = `text` v = `December`

                    )->end(

                    )->tag( `Label`
                        )->a( n = `text`    v = `Until`
                        )->a( n = `visible` v = |\{= ${ client->_bind( c_rec_type ) } !== '' \}|
                    )->tag( `DatePicker`
                        )->a( n = `visible` v = |\{= ${ client->_bind( c_rec_type ) } !== '' \}|
                        " the original binds this typed too (sap.ui.model.type.Date,
                        " pattern 'yyyy-MM-dd'); valueFormat carries the same contract
                        " without raising on the empty value this field seeds with.
                        " The ISO datetime shape, not the original's date-only one, so
                        " recurrenceenddate matches the port's own seeded rows
                        )->a( n = `valueFormat`   v = `yyyy-MM-dd'T'HH:mm:ss`
                        )->a( n = `displayFormat` v = `yyyy-MM-dd`
                        )->a( n = `value`   v = client->_bind( c_rec_end )

                )->end(
            )->end(

            )->ele( `beginButton`
                )->tag( `Button`
                    )->a( n = `text`  v = `Create`
                    )->a( n = `type`  v = `Emphasized`
                    )->a( n = `press` v = client->_event( `CREATE_SAVE` )

            )->end(
            )->ele( `endButton`
                )->tag( `Button`
                    )->a( n = `text`  v = `Cancel`
                    )->a( n = `press` v = client->_event( `CREATE_CANCEL` ) ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA temp3 TYPE ty_s_appointment.
        DATA new_appointment LIKE temp3.
          DATA temp4 TYPE i.
          DATA temp1 TYPE i.
              DATA temp5 TYPE i.
              DATA temp2 TYPE i.
              DATA temp6 TYPE i.
            DATA temp7 TYPE i.

    CASE client->get_event( ).

      WHEN `CREATE_APPOINTMENT`.
        create_reset( ).
        popup_create_display( ).

      WHEN `RECURRENCE_TYPE`.
        " onRecurrenceTypeChange clears the parts the picked recurrence does not use
        IF c_rec_type <> `Weekly`.
          CLEAR c_rec_days.
        ENDIF.
        IF c_rec_type <> `Monthly` AND c_rec_type <> `Yearly`.
          c_rule_type = `DayOfMonth`.
          c_rule_dom  = `0`.
          c_rule_wom  = `First`.
          c_rule_dow  = `0`.
        ENDIF.
        IF c_rec_type <> `Yearly`.
          c_rule_month = `0`.
        ENDIF.

      WHEN `CREATE_SAVE`.
        " onCreateDialogSave pushes the dialog's model into the appointments.
        " The new row carries the CONTROL's own default recurrence pattern:
        " setRecurrencePattern raises "recurrencePattern must be >= 1", and the
        " original keeps the default by leaving the property off a non-recurring
        " appointment - a serialized ABAP structure cannot leave a field out, so
        " the initial 0 would reach the setter and terminate the app
        
        CLEAR temp3.
        temp3-start_at = c_start.
        temp3-end_at = c_end.
        temp3-title = c_title.
        temp3-text = c_text.
        temp3-type = c_type.
        temp3-recurrencepattern = 1.
        
        new_appointment = temp3.
        IF c_rec_type IS NOT INITIAL.
          new_appointment-recurrencetype    = c_rec_type.
          " guarded on characters AND length: c_rec_pattern comes straight from a
          " free-entry Input, so an unguarded CONV i can raise NO_NUMBER or
          " OVERFLOW; an unusable entry falls back to the sample's default
          
          temp4 = c_rec_pattern.
          
          IF c_rec_pattern CO `0123456789` AND c_rec_pattern IS NOT INITIAL AND strlen( c_rec_pattern ) <= 9.
            temp1 = temp4.
          ELSE.
            temp1 = 1.
          ENDIF.
          new_appointment-recurrencepattern = temp1.
          new_appointment-recurrenceenddate = c_rec_end.
          IF c_rec_type = `Weekly` AND c_rec_days IS NOT INITIAL.
            new_appointment-t_recurrence_day = c_rec_days.
          ENDIF.
          IF c_rec_type = `Monthly` OR c_rec_type = `Yearly`.
            new_appointment-ruletype = c_rule_type.
            IF c_rule_type = `DayOfMonth`.
              " same guard as recurrencepattern above - c_rule_dom is free entry too
              
              temp5 = c_rule_dom.
              
              IF c_rule_dom CO `0123456789` AND c_rule_dom IS NOT INITIAL AND strlen( c_rule_dom ) <= 9.
                temp2 = temp5.
              ELSE.
                temp2 = 0.
              ENDIF.
              new_appointment-ruledayofmonth = temp2.
            ELSE.
              new_appointment-ruleweekofmonth = c_rule_wom.
              
              temp6 = c_rule_dow.
              new_appointment-ruledayofweek   = temp6.
            ENDIF.
          ENDIF.
          IF c_rec_type = `Yearly`.
            
            temp7 = c_rule_month.
            new_appointment-rulemonth = temp7.
          ENDIF.
        ENDIF.

        INSERT new_appointment INTO TABLE t_appointments.
        client->popup_destroy( ).
        client->message_toast_display( |Appointment '{ c_title }' created.| ).

      WHEN `CREATE_CANCEL`.
        client->popup_destroy( ).

    ENDCASE.

  ENDMETHOD.


  METHOD create_reset.

    " onCreateAppointment reseeds the dialog model: the next full hour and the
    " hour after it. A backend has no client clock, so the seed is the sample's
    " own calendar day at the next full hour of the SERVER time (see sidecar)
    DATA now LIKE sy-timlo.
    DATA temp8 TYPE i.
    now = sy-timlo.
    c_title       = ``.
    c_text        = ``.
    c_type        = `Type01`.
    c_start       = |{ sy-datlo DATE = ISO }T{ now(2) }:00:00|.
    
    temp8 = now(2).
    c_end         = |{ sy-datlo DATE = ISO }T{ temp8 + 1 WIDTH = 2 ALIGN = RIGHT PAD = '0' }:00:00|.
    c_rec_type    = ``.
    c_rec_pattern = `1`.
    CLEAR c_rec_days.
    c_rec_end     = ``.
    c_rule_type   = `DayOfMonth`.
    c_rule_dom    = `0`.
    c_rule_wom    = `First`.
    c_rule_dow    = `0`.
    c_rule_month  = `0`.

  ENDMETHOD.


  METHOD model_init.
    DATA temp9 TYPE z2ui5_cl_smpc_app_555=>ty_t_appointment.
    DATA temp10 LIKE LINE OF temp9.
    DATA temp3 TYPE z2ui5_cl_smpc_app_555=>ty_t_int.
    DATA temp5 TYPE z2ui5_cl_smpc_app_555=>ty_t_int.
    DATA temp7 TYPE z2ui5_cl_smpc_app_555=>ty_t_int.
    DATA temp11 TYPE z2ui5_cl_smpc_app_555=>ty_t_non_working.
    DATA temp12 LIKE LINE OF temp11.
    DATA temp13 TYPE z2ui5_cl_smpc_app_555=>ty_t_int.
    DATA temp15 TYPE z2ui5_cl_smpc_app_555=>ty_t_int.
    DATA temp17 TYPE z2ui5_cl_smpc_app_555=>ty_t_int.
    DATA temp19 TYPE z2ui5_cl_smpc_app_555=>ty_t_int.
    DATA temp21 TYPE z2ui5_cl_smpc_app_555=>ty_t_int.

    start_date = `2024-01-01T00:00:00`.
    create_reset( ).

    
    CLEAR temp9.
    
    temp10-start_at = `2024-01-01T09:00:00`.
    temp10-end_at = `2024-01-01T09:15:00`.
    temp10-title = `Daily Standup (every day)`.
    temp10-text = `Should appear every single day`.
    temp10-type = `Type05`.
    temp10-recurrencetype = `Daily`.
    temp10-recurrencepattern = 1.
    temp10-recurrenceenddate = `2024-12-31T00:00:00`.
    INSERT temp10 INTO TABLE temp9.
    temp10-start_at = `2024-01-01T16:00:00`.
    temp10-end_at = `2024-01-01T16:30:00`.
    temp10-title = `Log Review (every 2 days)`.
    temp10-text = `Should appear every other day: Jan 1, 3, 5, 7...`.
    temp10-type = `Type08`.
    temp10-recurrencetype = `Daily`.
    temp10-recurrencepattern = 2.
    temp10-recurrenceenddate = `2024-12-31T00:00:00`.
    INSERT temp10 INTO TABLE temp9.
    temp10-start_at = `2024-01-01T10:00:00`.
    temp10-end_at = `2024-01-01T11:00:00`.
    temp10-title = `Team Meeting (every Mon)`.
    temp10-text = `Should appear once per week on Monday`.
    temp10-type = `Type01`.
    temp10-recurrencetype = `Weekly`.
    temp10-recurrencepattern = 1.
    temp10-recurrenceenddate = `2024-12-31T00:00:00`.
    
    CLEAR temp3.
    INSERT 1 INTO TABLE temp3.
    temp10-t_recurrence_day = temp3.
    INSERT temp10 INTO TABLE temp9.
    temp10-start_at = `2024-01-03T14:00:00`.
    temp10-end_at = `2024-01-03T15:30:00`.
    temp10-title = `Code Review (every Wed+Fri)`.
    temp10-text = `Should appear twice per week: Wednesday and Friday`.
    temp10-type = `Type02`.
    temp10-recurrencetype = `Weekly`.
    temp10-recurrencepattern = 1.
    temp10-recurrenceenddate = `2024-12-31T00:00:00`.
    
    CLEAR temp5.
    INSERT 3 INTO TABLE temp5.
    INSERT 5 INTO TABLE temp5.
    temp10-t_recurrence_day = temp5.
    INSERT temp10 INTO TABLE temp9.
    temp10-start_at = `2024-01-02T11:00:00`.
    temp10-end_at = `2024-01-02T11:30:00`.
    temp10-title = `1-on-1 (every 2nd Tue)`.
    temp10-text = `Should appear every other Tuesday: Jan 2, 16, 30...`.
    temp10-type = `Type06`.
    temp10-recurrencetype = `Weekly`.
    temp10-recurrencepattern = 2.
    temp10-recurrenceenddate = `2024-12-31T00:00:00`.
    
    CLEAR temp7.
    INSERT 2 INTO TABLE temp7.
    temp10-t_recurrence_day = temp7.
    INSERT temp10 INTO TABLE temp9.
    temp10-start_at = `2024-01-01T13:00:00`.
    temp10-end_at = `2024-01-01T14:30:00`.
    temp10-title = `Retro (1st of each month)`.
    temp10-text = `Should appear on the 1st of every month: Jan 1, Feb 1...`.
    temp10-type = `Type03`.
    temp10-recurrencetype = `Monthly`.
    temp10-recurrencepattern = 1.
    temp10-recurrenceenddate = `2026-12-31T00:00:00`.
    INSERT temp10 INTO TABLE temp9.
    temp10-start_at = `2024-01-15T09:00:00`.
    temp10-end_at = `2024-01-15T12:00:00`.
    temp10-title = `Board Review (every 3 months)`.
    temp10-text = `Should appear quarterly on 15th: Jan 15, Apr 15, Jul 15, Oct 15`.
    temp10-type = `Type07`.
    temp10-recurrencetype = `Monthly`.
    temp10-recurrencepattern = 3.
    temp10-recurrenceenddate = `2026-12-31T00:00:00`.
    INSERT temp10 INTO TABLE temp9.
    temp10-start_at = `2024-01-15T00:00:00`.
    temp10-end_at = `2024-01-15T23:59:00`.
    temp10-title = `Company Kickoff (yearly Jan 15)`.
    temp10-text = `Should appear once per year on January 15`.
    temp10-type = `Type04`.
    temp10-recurrencetype = `Yearly`.
    temp10-recurrencepattern = 1.
    temp10-recurrenceenddate = `2026-12-31T00:00:00`.
    INSERT temp10 INTO TABLE temp9.
    temp10-start_at = `2024-03-10T10:00:00`.
    temp10-end_at = `2024-03-10T11:30:00`.
    temp10-title = `Perf Review (yearly Mar 10)`.
    temp10-text = `Should appear once per year on March 10`.
    temp10-type = `Type09`.
    temp10-recurrencetype = `Yearly`.
    temp10-recurrencepattern = 1.
    temp10-recurrenceenddate = `2026-12-31T00:00:00`.
    INSERT temp10 INTO TABLE temp9.
    t_appointments = temp9.

    
    CLEAR temp11.
    
    temp12-date_at = `2024-01-01T00:00:00`.
    temp12-start_at = `00:00`.
    temp12-end_at = `08:00`.
    temp12-valueformat = `HH:mm`.
    temp12-title = `Before Work Hours`.
    temp12-recurrencetype = `Weekly`.
    temp12-recurrencepattern = 1.
    temp12-recurrenceenddate = `2024-12-31T00:00:00`.
    
    CLEAR temp13.
    INSERT 1 INTO TABLE temp13.
    INSERT 2 INTO TABLE temp13.
    INSERT 3 INTO TABLE temp13.
    INSERT 4 INTO TABLE temp13.
    INSERT 5 INTO TABLE temp13.
    temp12-t_recurrence_day = temp13.
    INSERT temp12 INTO TABLE temp11.
    temp12-date_at = `2024-01-01T00:00:00`.
    temp12-start_at = `12:00`.
    temp12-end_at = `13:00`.
    temp12-valueformat = `HH:mm`.
    temp12-title = `Lunch Break`.
    temp12-recurrencetype = `Weekly`.
    temp12-recurrencepattern = 1.
    temp12-recurrenceenddate = `2024-12-31T00:00:00`.
    
    CLEAR temp15.
    INSERT 1 INTO TABLE temp15.
    INSERT 2 INTO TABLE temp15.
    INSERT 3 INTO TABLE temp15.
    INSERT 4 INTO TABLE temp15.
    INSERT 5 INTO TABLE temp15.
    temp12-t_recurrence_day = temp15.
    INSERT temp12 INTO TABLE temp11.
    temp12-date_at = `2024-01-01T00:00:00`.
    temp12-start_at = `18:00`.
    temp12-end_at = `23:59`.
    temp12-valueformat = `HH:mm`.
    temp12-title = `After Work Hours`.
    temp12-recurrencetype = `Weekly`.
    temp12-recurrencepattern = 1.
    temp12-recurrenceenddate = `2024-12-31T00:00:00`.
    
    CLEAR temp17.
    INSERT 1 INTO TABLE temp17.
    INSERT 2 INTO TABLE temp17.
    INSERT 3 INTO TABLE temp17.
    INSERT 4 INTO TABLE temp17.
    INSERT 5 INTO TABLE temp17.
    temp12-t_recurrence_day = temp17.
    INSERT temp12 INTO TABLE temp11.
    temp12-date_at = `2024-01-06T00:00:00`.
    temp12-start_at = `00:00`.
    temp12-end_at = `23:59`.
    temp12-valueformat = `HH:mm`.
    temp12-title = `Weekend - Saturday`.
    temp12-recurrencetype = `Weekly`.
    temp12-recurrencepattern = 1.
    temp12-recurrenceenddate = `2024-12-31T00:00:00`.
    
    CLEAR temp19.
    INSERT 6 INTO TABLE temp19.
    temp12-t_recurrence_day = temp19.
    INSERT temp12 INTO TABLE temp11.
    temp12-date_at = `2024-01-07T00:00:00`.
    temp12-start_at = `00:00`.
    temp12-end_at = `23:59`.
    temp12-valueformat = `HH:mm`.
    temp12-title = `Weekend - Sunday`.
    temp12-recurrencetype = `Weekly`.
    temp12-recurrencepattern = 1.
    temp12-recurrenceenddate = `2024-12-31T00:00:00`.
    
    CLEAR temp21.
    INSERT 0 INTO TABLE temp21.
    temp12-t_recurrence_day = temp21.
    INSERT temp12 INTO TABLE temp11.
    temp12-date_at = `2024-01-01T00:00:00`.
    temp12-start_at = `02:00`.
    temp12-end_at = `02:30`.
    temp12-valueformat = `HH:mm`.
    temp12-title = `Server Backup`.
    temp12-recurrencetype = `Daily`.
    temp12-recurrencepattern = 1.
    temp12-recurrenceenddate = `2024-12-31T00:00:00`.
    INSERT temp12 INTO TABLE temp11.
    temp12-date_at = `2024-01-01T00:00:00`.
    temp12-start_at = `06:00`.
    temp12-end_at = `08:00`.
    temp12-valueformat = `HH:mm`.
    temp12-title = `Monthly Maintenance`.
    temp12-recurrencetype = `Monthly`.
    temp12-recurrencepattern = 1.
    temp12-recurrenceenddate = `2026-12-31T00:00:00`.
    INSERT temp12 INTO TABLE temp11.
    temp12-date_at = `2024-01-15T00:00:00`.
    temp12-start_at = `08:00`.
    temp12-end_at = `12:00`.
    temp12-valueformat = `HH:mm`.
    temp12-title = `Monthly Inventory`.
    temp12-recurrencetype = `Monthly`.
    temp12-recurrencepattern = 1.
    temp12-recurrenceenddate = `2026-12-31T00:00:00`.
    INSERT temp12 INTO TABLE temp11.
    temp12-date_at = `2024-01-01T00:00:00`.
    temp12-start_at = `00:00`.
    temp12-end_at = `23:59`.
    temp12-valueformat = `HH:mm`.
    temp12-title = `New Year's Day`.
    temp12-recurrencetype = `Yearly`.
    temp12-recurrencepattern = 1.
    temp12-recurrenceenddate = `2026-12-31T00:00:00`.
    INSERT temp12 INTO TABLE temp11.
    temp12-date_at = `2024-07-04T00:00:00`.
    temp12-start_at = `00:00`.
    temp12-end_at = `23:59`.
    temp12-valueformat = `HH:mm`.
    temp12-title = `Independence Day`.
    temp12-recurrencetype = `Yearly`.
    temp12-recurrencepattern = 1.
    temp12-recurrenceenddate = `2026-12-31T00:00:00`.
    INSERT temp12 INTO TABLE temp11.
    temp12-date_at = `2024-12-25T00:00:00`.
    temp12-start_at = `00:00`.
    temp12-end_at = `23:59`.
    temp12-valueformat = `HH:mm`.
    temp12-title = `Christmas Day`.
    temp12-recurrencetype = `Yearly`.
    temp12-recurrencepattern = 1.
    temp12-recurrenceenddate = `2026-12-31T00:00:00`.
    INSERT temp12 INTO TABLE temp11.
    t_non_working = temp11.

  ENDMETHOD.

ENDCLASS.
