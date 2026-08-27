" @keywords singleplanningcalendar single planning calendar sap.m singleplanningcalendarrecurringitem vbox overflowtoolbar button toolbarseparator recurringnonworkingperiod timerange
" @summary SinglePlanningCalendar with recurring calendar items
CLASS z2ui5_cl_smpc_app_555 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    " RecurrenceRule.days is an int[]: a table of STRINGS serializes to ['1','2']
    " and UI5 rejects it, so the day tables are integer tables
    TYPES ty_t_int TYPE STANDARD TABLE OF i WITH EMPTY KEY.
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
    TYPES ty_t_appointment TYPE STANDARD TABLE OF ty_s_appointment WITH EMPTY KEY.

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
    TYPES ty_t_non_working TYPE STANDARD TABLE OF ty_s_non_working WITH EMPTY KEY.

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
                          t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `'viewChange' event fired.` ) ) )
                )->a( n = `startDate`         v = |\{ path: '{ client->_bind( val = start_date path = abap_true ) }', formatter: 'Formatter.DateCreateObject' \}|
                " ROOT-level aggregations: the path has to be the model path
                " client->_bind( path = abap_true ) resolves to. A bare 'T_' is
                " RELATIVE, which is right only inside a row-bound aggregation
                " (apps 536/545 bind their rows' tables that way) - here it
                " resolved against nothing and the calendar came up with zero
                " appointments (e2e-caught 2026-08-22)
                )->a( n = `nonWorkingPeriods` v = |\{ path: '{ client->_bind( val = t_non_working path = abap_true ) }', templateShareable: false \}|
                )->a( n = `appointments`      v = |\{ path: '{ client->_bind( val = t_appointments path = abap_true ) }', templateShareable: false \}|

                )->ele( `nonWorkingPeriods`
                    )->ele( n = `RecurringNonWorkingPeriod` ns = `unified`
                        )->a( n = `date`              v = `{ path: 'DATE_AT', formatter: 'Formatter.DateCreateObject' }`
                        )->a( n = `recurrenceType`    v = |\{= $\{RECURRENCETYPE\} \|\| null \}|
                        )->a( n = `recurrencePattern` v = `{RECURRENCEPATTERN}`
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

    DATA(popup) = z2ui5_cl_ui5_view_builder=>factory( ).

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
        " onCreateDialogSave pushes the dialog's model into the appointments
        DATA(new_appointment) = VALUE ty_s_appointment( start_at = c_start
                                                        end_at   = c_end
                                                        title    = c_title
                                                        text     = c_text
                                                        type     = c_type ).
        IF c_rec_type IS NOT INITIAL.
          new_appointment-recurrencetype    = c_rec_type.
          " guarded on characters AND length: c_rec_pattern comes straight from a
          " free-entry Input, so an unguarded CONV i can raise NO_NUMBER or
          " OVERFLOW; an unusable entry falls back to the sample's default
          new_appointment-recurrencepattern = COND i( WHEN c_rec_pattern CO `0123456789` AND c_rec_pattern IS NOT INITIAL
                                                      AND strlen( c_rec_pattern ) <= 9
                                                      THEN CONV i( c_rec_pattern )
                                                      ELSE 1 ).
          new_appointment-recurrenceenddate = c_rec_end.
          IF c_rec_type = `Weekly` AND c_rec_days IS NOT INITIAL.
            new_appointment-t_recurrence_day = c_rec_days.
          ENDIF.
          IF c_rec_type = `Monthly` OR c_rec_type = `Yearly`.
            new_appointment-ruletype = c_rule_type.
            IF c_rule_type = `DayOfMonth`.
              " same guard as recurrencepattern above - c_rule_dom is free entry too
              new_appointment-ruledayofmonth = COND i( WHEN c_rule_dom CO `0123456789` AND c_rule_dom IS NOT INITIAL
                                                       AND strlen( c_rule_dom ) <= 9
                                                       THEN CONV i( c_rule_dom )
                                                       ELSE 0 ).
            ELSE.
              new_appointment-ruleweekofmonth = c_rule_wom.
              new_appointment-ruledayofweek   = CONV i( c_rule_dow ).
            ENDIF.
          ENDIF.
          IF c_rec_type = `Yearly`.
            new_appointment-rulemonth = CONV i( c_rule_month ).
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
    DATA(now) = sy-timlo.
    c_title       = ``.
    c_text        = ``.
    c_type        = `Type01`.
    c_start       = |{ sy-datlo DATE = ISO }T{ now(2) }:00:00|.
    c_end         = |{ sy-datlo DATE = ISO }T{ CONV i( now(2) ) + 1 WIDTH = 2 ALIGN = RIGHT PAD = '0' }:00:00|.
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

    start_date = `2024-01-01T00:00:00`.
    create_reset( ).

    t_appointments = VALUE #(
      ( start_at = `2024-01-01T09:00:00` end_at = `2024-01-01T09:15:00` title = `Daily Standup (every day)` text = `Should appear every single day` type = `Type05` recurrencetype = `Daily` recurrencepattern = 1
        recurrenceenddate = `2024-12-31T00:00:00` )
      ( start_at = `2024-01-01T16:00:00` end_at = `2024-01-01T16:30:00` title = `Log Review (every 2 days)` text = `Should appear every other day: Jan 1, 3, 5, 7...` type = `Type08` recurrencetype = `Daily` recurrencepattern = 2
        recurrenceenddate = `2024-12-31T00:00:00` )
      ( start_at = `2024-01-01T10:00:00` end_at = `2024-01-01T11:00:00` title = `Team Meeting (every Mon)` text = `Should appear once per week on Monday` type = `Type01` recurrencetype = `Weekly` recurrencepattern = 1
        recurrenceenddate = `2024-12-31T00:00:00` t_recurrence_day = VALUE #( ( 1 ) ) )
      ( start_at = `2024-01-03T14:00:00` end_at = `2024-01-03T15:30:00` title = `Code Review (every Wed+Fri)` text = `Should appear twice per week: Wednesday and Friday` type = `Type02` recurrencetype = `Weekly` recurrencepattern = 1
        recurrenceenddate = `2024-12-31T00:00:00` t_recurrence_day = VALUE #( ( 3 ) ( 5 ) ) )
      ( start_at = `2024-01-02T11:00:00` end_at = `2024-01-02T11:30:00` title = `1-on-1 (every 2nd Tue)` text = `Should appear every other Tuesday: Jan 2, 16, 30...` type = `Type06` recurrencetype = `Weekly` recurrencepattern = 2
        recurrenceenddate = `2024-12-31T00:00:00` t_recurrence_day = VALUE #( ( 2 ) ) )
      ( start_at = `2024-01-01T13:00:00` end_at = `2024-01-01T14:30:00` title = `Retro (1st of each month)` text = `Should appear on the 1st of every month: Jan 1, Feb 1...` type = `Type03` recurrencetype = `Monthly` recurrencepattern = 1
        recurrenceenddate = `2026-12-31T00:00:00` )
      ( start_at = `2024-01-15T09:00:00` end_at = `2024-01-15T12:00:00` title = `Board Review (every 3 months)` text = `Should appear quarterly on 15th: Jan 15, Apr 15, Jul 15, Oct 15` type = `Type07` recurrencetype = `Monthly`
        recurrencepattern = 3 recurrenceenddate = `2026-12-31T00:00:00` )
      ( start_at = `2024-01-15T00:00:00` end_at = `2024-01-15T23:59:00` title = `Company Kickoff (yearly Jan 15)` text = `Should appear once per year on January 15` type = `Type04` recurrencetype = `Yearly` recurrencepattern = 1
        recurrenceenddate = `2026-12-31T00:00:00` )
      ( start_at = `2024-03-10T10:00:00` end_at = `2024-03-10T11:30:00` title = `Perf Review (yearly Mar 10)` text = `Should appear once per year on March 10` type = `Type09` recurrencetype = `Yearly` recurrencepattern = 1
        recurrenceenddate = `2026-12-31T00:00:00` )
    ).

    t_non_working = VALUE #(
      ( date_at = `2024-01-01T00:00:00` start_at = `00:00` end_at = `08:00` valueformat = `HH:mm` title = `Before Work Hours` recurrencetype = `Weekly` recurrencepattern = 1 recurrenceenddate = `2024-12-31T00:00:00`
        t_recurrence_day = VALUE #( ( 1 ) ( 2 ) ( 3 ) ( 4 ) ( 5 ) ) )
      ( date_at = `2024-01-01T00:00:00` start_at = `12:00` end_at = `13:00` valueformat = `HH:mm` title = `Lunch Break` recurrencetype = `Weekly` recurrencepattern = 1 recurrenceenddate = `2024-12-31T00:00:00`
        t_recurrence_day = VALUE #( ( 1 ) ( 2 ) ( 3 ) ( 4 ) ( 5 ) ) )
      ( date_at = `2024-01-01T00:00:00` start_at = `18:00` end_at = `23:59` valueformat = `HH:mm` title = `After Work Hours` recurrencetype = `Weekly` recurrencepattern = 1 recurrenceenddate = `2024-12-31T00:00:00`
        t_recurrence_day = VALUE #( ( 1 ) ( 2 ) ( 3 ) ( 4 ) ( 5 ) ) )
      ( date_at = `2024-01-06T00:00:00` start_at = `00:00` end_at = `23:59` valueformat = `HH:mm` title = `Weekend - Saturday` recurrencetype = `Weekly` recurrencepattern = 1 recurrenceenddate = `2024-12-31T00:00:00`
        t_recurrence_day = VALUE #( ( 6 ) ) )
      ( date_at = `2024-01-07T00:00:00` start_at = `00:00` end_at = `23:59` valueformat = `HH:mm` title = `Weekend - Sunday` recurrencetype = `Weekly` recurrencepattern = 1 recurrenceenddate = `2024-12-31T00:00:00`
        t_recurrence_day = VALUE #( ( 0 ) ) )
      ( date_at = `2024-01-01T00:00:00` start_at = `02:00` end_at = `02:30` valueformat = `HH:mm` title = `Server Backup` recurrencetype = `Daily` recurrencepattern = 1 recurrenceenddate = `2024-12-31T00:00:00` )
      ( date_at = `2024-01-01T00:00:00` start_at = `06:00` end_at = `08:00` valueformat = `HH:mm` title = `Monthly Maintenance` recurrencetype = `Monthly` recurrencepattern = 1 recurrenceenddate = `2026-12-31T00:00:00` )
      ( date_at = `2024-01-15T00:00:00` start_at = `08:00` end_at = `12:00` valueformat = `HH:mm` title = `Monthly Inventory` recurrencetype = `Monthly` recurrencepattern = 1 recurrenceenddate = `2026-12-31T00:00:00` )
      ( date_at = `2024-01-01T00:00:00` start_at = `00:00` end_at = `23:59` valueformat = `HH:mm` title = `New Year's Day` recurrencetype = `Yearly` recurrencepattern = 1 recurrenceenddate = `2026-12-31T00:00:00` )
      ( date_at = `2024-07-04T00:00:00` start_at = `00:00` end_at = `23:59` valueformat = `HH:mm` title = `Independence Day` recurrencetype = `Yearly` recurrencepattern = 1 recurrenceenddate = `2026-12-31T00:00:00` )
      ( date_at = `2024-12-25T00:00:00` start_at = `00:00` end_at = `23:59` valueformat = `HH:mm` title = `Christmas Day` recurrencetype = `Yearly` recurrencepattern = 1 recurrenceenddate = `2026-12-31T00:00:00` )
    ).

  ENDMETHOD.

ENDCLASS.
