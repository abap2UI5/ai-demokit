" @keywords planningcalendar planning calendar sap.m planningcalendarrecurringitem vbox title toolbarspacer button planningcalendarrow customdata recurringcalendarappointment
" @summary PlanningCalendar with recurring calendar items.
CLASS z2ui5_cl_smpc_app_548 DEFINITION PUBLIC.

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
             recurrencetype    TYPE string,
             recurrencepattern TYPE i,
             recurrenceenddate TYPE string,
             t_recurrence_day  TYPE ty_t_int,
           END OF ty_s_non_working.
    TYPES ty_t_non_working TYPE STANDARD TABLE OF ty_s_non_working WITH EMPTY KEY.
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
             t_non_working  TYPE ty_t_non_working,
             t_headers      TYPE ty_t_header,
           END OF ty_s_person.
    DATA t_people TYPE STANDARD TABLE OF ty_s_person WITH EMPTY KEY.

    TYPES: BEGIN OF ty_s_item,
             key  TYPE string,
             text TYPE string,
           END OF ty_s_item.
    DATA t_person_items TYPE STANDARD TABLE OF ty_s_item WITH EMPTY KEY.

    DATA start_date TYPE string.
    DATA view_key   TYPE string.

    " the create dialog's own model, folded to fields (see sidecar)
    DATA c_person      TYPE string.
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
    METHODS iso_of
      IMPORTING first         TYPE i
      RETURNING VALUE(result) TYPE string.
    METHODS index_of
      IMPORTING path          TYPE string
      RETURNING VALUE(result) TYPE i.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_548 IMPLEMENTATION.

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
        )->a( n = `xmlns:core`    v = `sap.ui.core`
        )->a( n = `xmlns:mvc`     v = `sap.ui.core.mvc`
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
                )->a( n = `rowHeaderPress`            v = client->_event(
                          val   = `ROW_HEADER_PRESS`
                          t_arg = VALUE #( ( `${$parameters>/row}.getId()` ) ) )
                )->a( n = `showEmptyIntervalHeaders`  v = `false`
                )->a( n = `builtInViews`              v = `Hour,Day,Week,Month,One Month`
                )->a( n = `viewKey`                   v = client->_bind( view_key )
                )->a( n = `showWeekNumbers`           v = `true`

                )->ele( `toolbarContent`
                    )->tag( `Title`
                        )->a( n = `text`       v = `Recurring Appointments`
                        )->a( n = `titleStyle` v = `H4`
                    )->tag( `ToolbarSpacer`
                    )->tag( `Button`
                        )->a( n = `text`  v = `Create Appointment`
                        )->a( n = `type`  v = `Emphasized`
                        )->a( n = `press` v = client->_event( `CREATE_APPOINTMENT` )

                )->end(

                )->ele( `rows`
                    )->ele( `PlanningCalendarRow`
                        )->a( n = `icon`                          v = `{PIC}`
                        )->a( n = `title`                         v = `{NAME}`
                        )->a( n = `text`                          v = `{ROLE}`
                        )->a( n = `enableAppointmentsCreate`      v = `true`
                        )->a( n = `enableAppointmentsDragAndDrop` v = `true`
                        )->a( n = `appointments`                  v = `{path: 'T_APPOINTMENTS', templateShareable: false}`
                        )->a( n = `intervalHeaders`               v = `{path: 'T_HEADERS', templateShareable: false}`
                        )->a( n = `nonWorkingPeriods`             v = `{path: 'T_NON_WORKING', templateShareable: false}`
                        " onAppointmentCreate opens the create dialog on the row the
                        " drag started in; onAppointmentDrop moves, copies or just
                        " reschedules by the dragged delta
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
                                    ( `${$parameters>/appointment}.getBindingContext() ? ${$parameters>/appointment}.getBindingContext().getPath() : ''` )
                                    ( `${$parameters>/calendarRow}.getBindingContext().getPath()` )
                                    ( `${$parameters>/copy} ? 'X' : ''` )
                                    ( `${$parameters>/calendarRow}.getTitle()` ) ) )

                        )->ele( `customData`
                            )->tag( n = `CustomData` ns = `core`
                                )->a( n = `key`        v = `emp-name`
                                )->a( n = `value`      v = `{NAME}`
                                )->a( n = `writeToDom` v = `true`

                        )->end(

                        )->ele( `appointments`
                            )->ele( n = `RecurringCalendarAppointment` ns = `unified`
                                )->a( n = `startDate`         v = `{ path: 'START_AT', formatter: 'Formatter.DateCreateObject' }`
                                )->a( n = `endDate`           v = `{ path: 'END_AT', formatter: 'Formatter.DateCreateObject' }`
                                )->a( n = `recurrenceType`    v = |\{= $\{RECURRENCETYPE\} \|\| null \}|
                                )->a( n = `recurrencePattern` v = `{RECURRENCEPATTERN}`
                                )->a( n = `recurrenceEndDate` v = `{ path: 'RECURRENCEENDDATE', formatter: 'Formatter.DateCreateObject' }`
                                )->a( n = `title`             v = `{TITLE}`
                                )->a( n = `type`              v = `{TYPE}`

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

                        )->ele( `nonWorkingPeriods`
                            )->ele( n = `RecurringNonWorkingPeriod` ns = `unified`
                                )->a( n = `recurrenceType`    v = |\{= $\{RECURRENCETYPE\} \|\| null \}|
                                )->a( n = `recurrenceEndDate` v = `{ path: 'RECURRENCEENDDATE', formatter: 'Formatter.DateCreateObject' }`
                                )->a( n = `recurrencePattern` v = `{RECURRENCEPATTERN}`
                                )->a( n = `date`              v = `{ path: 'DATE_AT', formatter: 'Formatter.DateCreateObject' }`

                                )->tag( n = `TimeRange` ns = `unified`
                                    )->a( n = `start`       v = `{START_AT}`
                                    )->a( n = `end`         v = `{END_AT}`
                                    )->a( n = `valueFormat` v = `{VALUEFORMAT}`

                            )->end(
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


  METHOD popup_create_display.

    DATA(popup) = z2ui5_cl_ui5_view_builder=>factory( ).

    popup->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:form` v = `sap.ui.layout.form`

        )->ele( `Dialog`
            )->a( n = `title`        v = `Create Appointment`
            )->a( n = `contentWidth` v = `500px`

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
                        )->a( n = `text`     v = `Person`
                        )->a( n = `required` v = `true`
                    " the Select's items are added in the controller from the people
                    " table; the port binds that table instead (see sidecar)
                    )->ele( `Select`
                        )->a( n = `id`          v = `personSelect`
                        )->a( n = `selectedKey` v = client->_bind( c_person )
                        )->a( n = `items`       v = client->_bind( t_person_items )

                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `{KEY}`
                            )->a( n = `text` v = `{TEXT}`

                    )->end(
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

      WHEN `ROW_HEADER_PRESS`.
        client->message_box_display( text = |rowHeaderPressed on row: { client->get_event_arg( ) }|
                                     type = `show` ).

      WHEN `CREATE_APPOINTMENT`.
        create_reset( ).
        popup_create_display( ).

      WHEN `APPT_CREATE`.
        " the drag-created appointment opens the dialog on the row it started in
        create_reset( ).
        c_start  = iso_of( 1 ).
        c_end    = iso_of( 6 ).
        c_person = |{ index_of( client->get_event_arg( 11 ) ) }|.
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
        " the new row carries the CONTROL's own default recurrence pattern:
        " setRecurrencePattern raises "recurrencePattern must be >= 1", and the
        " original keeps the default by leaving the property off a non-recurring
        " appointment - a serialized ABAP structure cannot leave a field out, so
        " the initial 0 would reach the setter and terminate the app
        DATA(new_appointment) = VALUE ty_s_appointment( start_at          = c_start
                                                        end_at            = c_end
                                                        title             = c_title
                                                        text              = c_text
                                                        type              = c_type
                                                        recurrencepattern = 1 ).
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

        READ TABLE t_people INDEX CONV i( c_person ) + 1 ASSIGNING FIELD-SYMBOL(<person>).
        IF sy-subrc = 0.
          INSERT new_appointment INTO TABLE <person>-t_appointments.
        ENDIF.
        client->popup_destroy( ).
        client->message_toast_display( |Appointment '{ c_title }' created.| ).

      WHEN `CREATE_CANCEL`.
        client->popup_destroy( ).

      WHEN `APPT_DROP`.
        " onAppointmentDrop shifts the appointment by the dragged DELTA; the new
        " start already carries it, so the port re-dates the row with the two
        " interval bounds the event hands it
        DATA(drop_start) = iso_of( 1 ).
        DATA(drop_end)   = iso_of( 6 ).
        DATA(appt_path)  = client->get_event_arg( 11 ).
        DATA(row_path)   = client->get_event_arg( 12 ).
        DATA(is_copy)    = xsdbool( client->get_event_arg( 13 ) = `X` ).
        DATA(row_title)  = client->get_event_arg( 14 ).

        IF appt_path IS INITIAL.
          client->message_toast_display( `Cannot move this appointment.` ).
        ELSE.
          SPLIT appt_path AT `/` INTO TABLE DATA(parts).
          DELETE parts WHERE table_line IS INITIAL.
          DATA(src_row)  = CONV i( parts[ 2 ] ).
          DATA(appt_idx) = CONV i( parts[ lines( parts ) ] ).
          DATA(dest_row) = index_of( row_path ).

          READ TABLE t_people INDEX src_row + 1 ASSIGNING FIELD-SYMBOL(<source>).
          IF sy-subrc = 0 AND appt_idx >= 0 AND appt_idx < lines( <source>-t_appointments ).
            DATA(moved) = <source>-t_appointments[ appt_idx + 1 ].
            moved-start_at = drop_start.
            moved-end_at   = drop_end.

            IF is_copy = abap_true.
              READ TABLE t_people INDEX dest_row + 1 ASSIGNING FIELD-SYMBOL(<copy_to>).
              IF sy-subrc = 0.
                INSERT moved INTO TABLE <copy_to>-t_appointments.
              ENDIF.
              client->message_toast_display( |Appointment copied to { row_title }.| ).
            ELSEIF src_row <> dest_row.
              DELETE <source>-t_appointments INDEX appt_idx + 1.
              READ TABLE t_people INDEX dest_row + 1 ASSIGNING FIELD-SYMBOL(<move_to>).
              IF sy-subrc = 0.
                INSERT moved INTO TABLE <move_to>-t_appointments.
              ENDIF.
              client->message_toast_display( |Appointment moved to { row_title }.| ).
            ELSE.
              <source>-t_appointments[ appt_idx + 1 ] = moved.
              client->message_toast_display( `Appointment rescheduled.` ).
            ENDIF.
          ENDIF.
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

    " the last segment of a binding path such as /T_PEOPLE/1
    SPLIT path AT `/` INTO TABLE DATA(segments).
    DELETE segments WHERE table_line IS INITIAL.
    result = COND i( WHEN segments IS NOT INITIAL THEN segments[ lines( segments ) ] ELSE 0 ).

  ENDMETHOD.


  METHOD create_reset.

    " _openCreateDialog reseeds the dialog model at the next full hour. A backend
    " has no client clock, so the seed is the SERVER's local time (see sidecar)
    DATA(now) = sy-timlo.
    c_person      = `0`.
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

    start_date = `2019-09-01T00:00:00`.
    view_key   = `Hour`.

    t_people = VALUE #(
      ( pic = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/John_Miller.png` name = `John Miller` role = `team member`
        t_appointments = VALUE #(
          ( start_at = `2019-09-02T09:00:00` end_at = `2019-09-02T09:30:00` title = `Daily Standup` type = `Type01` recurrencetype = `Daily` recurrencepattern = 1 recurrenceenddate = `2019-10-01T00:00:00` )
          ( start_at = `2019-09-04T14:00:00` end_at = `2019-09-04T15:00:00` title = `Weekly Team Meeting` type = `Type08` recurrencetype = `Weekly` recurrencepattern = 1 recurrenceenddate = `2019-10-01T00:00:00` )
        )
        t_non_working = VALUE #(
          ( date_at = `2019-09-01T00:00:00` start_at = `12:55` end_at = `13:15` valueformat = `HH:mm` recurrencetype = `Daily` recurrencepattern = 1 recurrenceenddate = `2019-10-01T00:00:00` )
          ( date_at = `2019-09-01T00:00:00` start_at = `04:30` end_at = `04:45` valueformat = `HH:mm` recurrencetype = `Daily` recurrencepattern = 1 recurrenceenddate = `2019-10-01T00:00:00` )
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
          ( start_at = `2019-09-02T10:00:00` end_at = `2019-09-02T10:30:00` title = `Bi-weekly Sync` type = `Type03` recurrencetype = `Weekly` recurrencepattern = 2 recurrenceenddate = `2019-10-01T00:00:00` )
        )
        t_non_working = VALUE #(
          ( date_at = `2019-09-01T00:00:00` start_at = `11:55` end_at = `13:15` valueformat = `HH:mm` recurrencetype = `Daily` recurrencepattern = 1 recurrenceenddate = `2019-10-01T00:00:00` )
          ( date_at = `2019-09-01T00:00:00` start_at = `03:30` end_at = `03:45` valueformat = `HH:mm` recurrencetype = `Daily` recurrencepattern = 1 recurrenceenddate = `2019-10-01T00:00:00` )
        )
        t_headers = VALUE #(
          ( start_at = `2017-01-15T09:00:00` end_at = `2017-01-15T10:00:00` title = `Payment reminder` type = `Type06` )
          ( start_at = `2017-01-15T16:30:00` end_at = `2017-01-15T18:00:00` title = `Private appointment` type = `Type06` )
        )
      )
      ( pic = `sap-icon://employee` name = `Max Mustermann` role = `team member`
        t_appointments = VALUE #(
          ( start_at = `2019-09-03T11:00:00` end_at = `2019-09-03T12:00:00` title = `Every Other Day Check-in` type = `Type07` recurrencetype = `Daily` recurrencepattern = 2 recurrenceenddate = `2019-10-01T00:00:00` )
        )
        t_non_working = VALUE #(
        )
        t_headers = VALUE #(
          ( start_at = `2017-01-16T00:00:00` end_at = `2017-01-16T23:59:00` title = `Private` type = `Type05` )
        )
      ) ).

    " _openCreateDialog fills the person Select from the people table
    t_person_items = VALUE #( FOR i = 0 WHILE i < lines( t_people )
                              ( key = |{ i }| text = t_people[ i + 1 ]-name ) ).

  ENDMETHOD.

ENDCLASS.
