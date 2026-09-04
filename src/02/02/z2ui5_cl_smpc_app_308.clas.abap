" @keywords calendar sap.ui.unified calendarspecialdayslegend html verticallayout datetyperange calendarlegend calendarlegenditem togglebutton
" @summary Calendar with special days and legend
CLASS z2ui5_cl_smpc_app_308 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_legend,
             type TYPE string,
             text TYPE string,
           END OF ty_s_legend.
    TYPES ty_t_legend TYPE STANDARD TABLE OF ty_s_legend WITH DEFAULT KEY.
    TYPES: BEGIN OF ty_s_special,
             start_date     TYPE string,
             end_date       TYPE string,
             type           TYPE string,
             secondary_type TYPE string,
             tooltip        TYPE string,
             color          TYPE string,
           END OF ty_s_special.
    TYPES ty_t_special TYPE STANDARD TABLE OF ty_s_special WITH DEFAULT KEY.

    DATA pressed    TYPE abap_bool.
    DATA t_legend1  TYPE ty_t_legend.
    DATA t_legend2  TYPE ty_t_legend.
    DATA t_special1 TYPE ty_t_special.
    DATA t_special2 TYPE ty_t_special.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS special_days_fill.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_308 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    DATA temp2 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " DateTypeRange.startDate/endDate are typed "object" and demand a real JS Date;
    " the model keeps ABAP DATS strings and Formatter.DateAbapDateToDateObject converts them at
    " the point of use (needs UI5 >= 1.74). endDate is optional, and needs no
    " guard: DateAbapDateToDateObject answers null for a non-date, where
    " DateCreateObject's new Date('') is an Invalid Date - truthy, and enough to
    " kill the whole view
    
    CLEAR temp1.
    INSERT `COLOR` INTO TABLE temp1.
    INSERT `SECONDARY_TYPE` INTO TABLE temp1.
    INSERT `TOOLTIP` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `COLOR` INTO TABLE temp2.
    INSERT `SECONDARY_TYPE` INTO TABLE temp2.
    INSERT `TOOLTIP` INTO TABLE temp2.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`      v = `sap.ui.layout`
        )->a( n = `xmlns:u`      v = `sap.ui.unified`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core`   v = `sap.ui.core`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `class`        v = `viewPadding`
        )->a( n = `core:require` v = `{Formatter: 'z2ui5/model/formatter'}`


        " the sample's own ../style.css (shared by the sap.ui.unified samples and
        " listed in this sample's manifest) - the view carries the class and the
        " rule behind it has to come with it. \{ \} escaped: the XMLView parser
        " reads an unescaped brace as a binding
        )->tag( n = `HTML` ns = `core`
            )->a( n = `content` v = `<style>.viewPadding\{padding:1rem\}` &&
                                    `.sap-phone .viewPadding\{padding:0rem\}` &&
                                    `.sap-phone .sapUiCal\{position:relative\}</style>`
        )->ele( n = `VerticalLayout` ns = `l`

            )->ele( n = `Calendar` ns = `u`
                )->a( n = `id`                v = `calendar1`
                )->a( n = `legend`            v = `legend1`
                )->a( n = `intervalSelection` v = `true`
                )->a( n = `specialDates`      v = client->_bind(
                                                      val                = t_special1
                                                      omit_initial_paths = temp1 )

                )->ele( n = `specialDates` ns = `u`
                    )->tag( n = `DateTypeRange` ns = `u`
                        )->a( n = `startDate`     v = `{ path: 'START_DATE', formatter: 'Formatter.DateAbapDateToDateObject' }`
                        " a special date with no end is a single day. That used to
                        " need a ternary guard, because an empty string through
                        " DateCreateObject is an Invalid Date that
                        " Month._checkDateEnabled throws on;
                        " DateAbapDateToDateObject answers null for a non-date, so
                        " the plain binding is enough (app 220's lesson)
                        )->a( n = `endDate`       v = |\{ path: 'END_DATE', formatter: 'Formatter.DateAbapDateToDateObject' \}|
                        )->a( n = `type`          v = `{TYPE}`
                        " An enum property REFUSES an empty string - `"" is of type
                        " string, expected sap.ui.unified.CalendarDayType` - and the
                        " template is evaluated with no row the moment the toggle
                        " CLEARS the table. Same shape as endDate above: fall back to
                        " the enum's own default rather than let `` reach the control.
                        " Found by the e2e interaction (the second press), 2026-08-16.
                        )->a( n = `secondaryType` v = `{= ${SECONDARY_TYPE} ? ${SECONDARY_TYPE} : 'None' }`
                        )->a( n = `tooltip`       v = `{TOOLTIP}`
                        )->a( n = `color`         v = `{COLOR}`

                )->end(
            )->end(

            )->ele( n = `CalendarLegend` ns = `u`
                )->a( n = `id`    v = `legend1`
                )->a( n = `items` v = client->_bind( t_legend1 )

                )->ele( n = `items` ns = `u`
                    )->tag( n = `CalendarLegendItem` ns = `u`
                        )->a( n = `type` v = `{TYPE}`
                        )->a( n = `text` v = `{TEXT}`

                )->end(
            )->end(

            )->ele( n = `Calendar` ns = `u`
                )->a( n = `id`           v = `calendar2`
                )->a( n = `legend`       v = `legend2`
                )->a( n = `specialDates` v = client->_bind(
                                                 val                = t_special2
                                                 omit_initial_paths = temp2 )

                )->ele( n = `specialDates` ns = `u`
                    )->tag( n = `DateTypeRange` ns = `u`
                        )->a( n = `startDate`     v = `{ path: 'START_DATE', formatter: 'Formatter.DateAbapDateToDateObject' }`
                        " a special date with no end is a single day. That used to
                        " need a ternary guard, because an empty string through
                        " DateCreateObject is an Invalid Date that
                        " Month._checkDateEnabled throws on;
                        " DateAbapDateToDateObject answers null for a non-date, so
                        " the plain binding is enough (app 220's lesson)
                        )->a( n = `endDate`       v = |\{ path: 'END_DATE', formatter: 'Formatter.DateAbapDateToDateObject' \}|
                        )->a( n = `type`          v = `{TYPE}`
                        " An enum property REFUSES an empty string - `"" is of type
                        " string, expected sap.ui.unified.CalendarDayType` - and the
                        " template is evaluated with no row the moment the toggle
                        " CLEARS the table. Same shape as endDate above: fall back to
                        " the enum's own default rather than let `` reach the control.
                        " Found by the e2e interaction (the second press), 2026-08-16.
                        )->a( n = `secondaryType` v = `{= ${SECONDARY_TYPE} ? ${SECONDARY_TYPE} : 'None' }`
                        )->a( n = `tooltip`       v = `{TOOLTIP}`
                        )->a( n = `color`         v = `{COLOR}`

                )->end(
            )->end(

            )->ele( n = `CalendarLegend` ns = `u`
                )->a( n = `id`            v = `legend2`
                )->a( n = `standardItems` v = `Today`
                )->a( n = `items`         v = client->_bind( t_legend2 )

                )->ele( n = `items` ns = `u`
                    )->tag( n = `CalendarLegendItem` ns = `u`
                        )->a( n = `type` v = `{TYPE}`
                        )->a( n = `text` v = `{TEXT}`

                )->end(
            )->end(

            )->tag( `ToggleButton`
                )->a( n = `text`    v = `Special Days`
                )->a( n = `pressed` v = client->_bind( pressed )
                )->a( n = `press`   v = client->_event( val = `SHOW_SPECIAL_DAYS` arg = `${$parameters>/pressed}` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `SHOW_SPECIAL_DAYS`.
      " handleShowSpecialDays: the pressed state adds the special dates and the
      " legend items to both calendars, the released state destroys them again -
      " here the four bound tables are filled and cleared instead
      pressed = client->get_event_arg( ).
      IF pressed = abap_true.
        special_days_fill( ).
      ELSE.
        CLEAR t_special1.
        CLEAR t_special2.
        CLEAR t_legend1.
        CLEAR t_legend2.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD special_days_fill.

    " the original walks a reference date through the CURRENT month with
    " setDate( n ), so every date below is day n of the current month
    " The special dates are ABAP DATS strings read through
    " Formatter.DateAbapDateToDateObject, which builds the Date from the parsed
    " parts - LOCAL midnight, which is what sap.ui.unified reads back
    " (CalendarDate.fromLocalJSDate). They were ISO date-only strings through
    " Formatter.DateCreateObject until 2026-08-21, and `new Date('yyyy-mm-dd')`
    " is UTC midnight, so west of Greenwich every marked day landed one day
    " early. Same defect and same fix as apps 220 and 017.
    DATA prefix TYPE string.
      DATA i LIKE sy-index.
      DATA type TYPE string.
      DATA text TYPE string.
      DATA day TYPE string.
      DATA temp3 TYPE z2ui5_cl_smpc_app_308=>ty_t_special.
      DATA temp4 LIKE LINE OF temp3.
      DATA temp5 TYPE z2ui5_cl_smpc_app_308=>ty_t_special.
      DATA temp6 LIKE LINE OF temp5.
      DATA temp7 TYPE z2ui5_cl_smpc_app_308=>ty_t_legend.
      DATA temp8 LIKE LINE OF temp7.
      DATA temp9 TYPE z2ui5_cl_smpc_app_308=>ty_t_legend.
      DATA temp10 LIKE LINE OF temp9.
    DATA temp11 TYPE z2ui5_cl_smpc_app_308=>ty_t_special.
    DATA temp12 LIKE LINE OF temp11.
    DATA temp13 TYPE z2ui5_cl_smpc_app_308=>ty_t_special.
    DATA temp14 LIKE LINE OF temp13.
    prefix = |{ sy-datum+0(4) }{ sy-datum+4(2) }|.

    CLEAR t_special1.
    CLEAR t_special2.
    CLEAR t_legend1.
    CLEAR t_legend2.

    DO 10 TIMES.
      
      i = sy-index.
      
      type = |Type{ i WIDTH = 2 ALIGN = RIGHT PAD = '0' }|.
      
      text = |Placeholder { i }|.
      
      day  = |{ prefix }{ i WIDTH = 2 ALIGN = RIGHT PAD = '0' }|.

      
      CLEAR temp3.
      temp3 = t_special1.
      
      temp4-start_date = day.
      temp4-type = type.
      temp4-tooltip = text.
      INSERT temp4 INTO TABLE temp3.
      t_special1 = temp3.
      
      CLEAR temp5.
      temp5 = t_special2.
      
      temp6-start_date = day.
      temp6-type = type.
      temp6-tooltip = text.
      INSERT temp6 INTO TABLE temp5.
      t_special2 = temp5.
      
      CLEAR temp7.
      temp7 = t_legend1.
      
      temp8-type = type.
      temp8-text = text.
      INSERT temp8 INTO TABLE temp7.
      t_legend1  = temp7.
      
      CLEAR temp9.
      temp9 = t_legend2.
      
      temp10-type = type.
      temp10-text = text.
      INSERT temp10 INTO TABLE temp9.
      t_legend2  = temp9.
    ENDDO.

    
    CLEAR temp11.
    temp11 = t_special1.
    
    temp12-start_date = |{ prefix }12|.
    temp12-type = `Type11`.
    temp12-color = `#ff0000`.
    INSERT temp12 INTO TABLE temp11.
    temp12-start_date = |{ prefix }13|.
    temp12-type = `Type11`.
    temp12-color = `#ff69b4`.
    INSERT temp12 INTO TABLE temp11.
    temp12-start_date = |{ prefix }11|.
    temp12-end_date = |{ prefix }21|.
    temp12-type = `NonWorking`.
    INSERT temp12 INTO TABLE temp11.
    temp12-start_date = |{ prefix }25|.
    temp12-type = `Working`.
    INSERT temp12 INTO TABLE temp11.
    t_special1 = temp11.

    
    CLEAR temp13.
    temp13 = t_special2.
    
    temp14-start_date = |{ prefix }12|.
    temp14-type = `Type11`.
    temp14-color = `#ff0000`.
    INSERT temp14 INTO TABLE temp13.
    temp14-start_date = |{ prefix }13|.
    temp14-type = `Type11`.
    temp14-color = `#add8e6`.
    INSERT temp14 INTO TABLE temp13.
    temp14-start_date = |{ prefix }22|.
    temp14-type = `Type03`.
    temp14-secondary_type = `NonWorking`.
    INSERT temp14 INTO TABLE temp13.
    temp14-start_date = |{ prefix }24|.
    temp14-type = `Working`.
    INSERT temp14 INTO TABLE temp13.
    temp14-start_date = |{ prefix }24|.
    temp14-type = `Type03`.
    INSERT temp14 INTO TABLE temp13.
    t_special2 = temp13.

  ENDMETHOD.

ENDCLASS.
