" @keywords calendar sap.ui.unified calendarminmax html verticallayout daterange horizontallayout label text flexbox switch
" @summary Calendar with minimum date 2000-01-01 and maximum date 2050-12-31, some disabled days (in January 2016) and ability to show or hide week numbers.
CLASS z2ui5_cl_smpc_app_220 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_disabled,
             start TYPE string,
             end   TYPE string,
           END OF ty_s_disabled.
    TYPES ty_t_disabled TYPE STANDARD TABLE OF ty_s_disabled WITH DEFAULT KEY.

    DATA min_date          TYPE string.
    DATA max_date          TYPE string.
    DATA t_disabled        TYPE ty_t_disabled.
    DATA show_week_numbers TYPE abap_bool.
    DATA selected_date     TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_220 IMPLEMENTATION.

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

    " Calendar min/max/disabled dates are typed "object" and demand real JS Date
    " objects; the model keeps ABAP DATS strings and Formatter.DateAbapDateToDateObject from the
    " curated module converts them at the point of use (needs UI5 >= 1.74). The
    " original's imperative Switch handler (setShowWeekNumbers) is replaced by a
    " two-way binding shared between the Switch state and Calendar showWeekNumbers
    " (thin frontend). handleCalendarSelect formats the picked day into the Text:
    " the day is read out of the event as a UI5 EXPRESSION - indexed access and
    " chained calls resolve there (measured with
    " scripts/probes/event-arg-expression-probe.mjs) - and the long-style English
    " rendering of DateFormat.getInstance({style:'long'}) is composed in ABAP.
    
    CLEAR temp1.
    INSERT `$event.oSource.getSelectedDates().length > 0 ? $event.oSource.getSelectedDates()[0].getStartDate().getFullYear() : 0` INTO TABLE temp1.
    INSERT `$event.oSource.getSelectedDates().length > 0 ? $event.oSource.getSelectedDates()[0].getStartDate().getMonth() + 1 : 0` INTO TABLE temp1.
    INSERT `$event.oSource.getSelectedDates().length > 0 ? $event.oSource.getSelectedDates()[0].getStartDate().getDate() : 0` INTO TABLE temp1.
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
                )->a( n = `id`              v = `calendar`
                )->a( n = `minDate`         v = |\{ path: '{ client->_bind_path( min_date ) }', formatter: 'Formatter.DateAbapDateToDateObject' \}|
                )->a( n = `maxDate`         v = |\{ path: '{ client->_bind_path( max_date ) }', formatter: 'Formatter.DateAbapDateToDateObject' \}|
                )->a( n = `disabledDates`   v = client->_bind( t_disabled )
                )->a( n = `showWeekNumbers` v = client->_bind( show_week_numbers )
                )->a( n = `select`          v = client->_event( val   = `CAL_SELECT`
                                                                t_arg = temp1 )

                )->ele( n = `disabledDates` ns = `u`
                    )->tag( n = `DateRange` ns = `u`
                        )->a( n = `startDate` v = |\{ path: 'START', formatter: 'Formatter.DateAbapDateToDateObject' \}|
                        " the second range is a single day and carries no end. That used to need
                        " a ternary guard in the view, because an empty string through
                        " DateCreateObject is an Invalid Date and Month._checkDateEnabled throws on
                        " it (probe-verified, see sidecar). DateAbapDateToDateObject answers null
                        " for a non-date instead, so the plain binding is enough and the expression
                        " is gone
                        )->a( n = `endDate`   v = |\{ path: 'END', formatter: 'Formatter.DateAbapDateToDateObject' \}|

                )->end(
            )->end(
            )->ele( n = `HorizontalLayout` ns = `l`

                )->tag( `Label`
                    )->a( n = `text` v = `Selected Date:`
                )->tag( `Text`
                    )->a( n = `id`   v = `selectedDate`
                    )->a( n = `text` v = client->_bind( selected_date )

            )->end(
            )->ele( n = `HorizontalLayout` ns = `l`

                )->ele( `FlexBox`
                    )->a( n = `height`         v = `100px`
                    )->a( n = `alignItems`     v = `Center`
                    )->a( n = `justifyContent` v = `Start`

                    )->tag( `Label`
                        )->a( n = `text` v = `Toggle week numbers:`
                    )->tag( `Switch`
                        )->a( n = `state` v = client->_bind( show_week_numbers )

                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
      DATA year TYPE string.
        DATA temp3 TYPE i.
        DATA month LIKE temp3.
        DATA temp4 TYPE string.
        DATA temp1 TYPE i.

    IF client->get_event( ) = `CAL_SELECT`.
      " handleCalendarSelect: DateFormat.getInstance({style:'long'}).format(oDate)
      " - the English long form ('March 17, 2026'). The day arrives as its three
      " LOCAL parts; year 0 means the re-click cleared the selection
      
      year = client->get_event_arg( ).
      IF year IS INITIAL OR year = `0`.
        selected_date = `No Date Selected`.
      ELSE.
        
        temp3 = client->get_event_arg( 2 ).
        
        month = temp3.
        
        CASE month.
          WHEN 1.
            temp4 = `January`.
          WHEN 2.
            temp4 = `February`.
          WHEN 3.
            temp4 = `March`.
          WHEN 4.
            temp4 = `April`.
          WHEN 5.
            temp4 = `May`.
          WHEN 6.
            temp4 = `June`.
          WHEN 7.
            temp4 = `July`.
          WHEN 8.
            temp4 = `August`.
          WHEN 9.
            temp4 = `September`.
          WHEN 10.
            temp4 = `October`.
          WHEN 11.
            temp4 = `November`.
          WHEN 12.
            temp4 = `December`.
        ENDCASE.
        
        temp1 = client->get_event_arg( 3 ).
        selected_date = |{ temp4 }| &&
                        | { temp1 }, { year }|.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD model_init.
    DATA temp5 TYPE z2ui5_cl_smpc_app_220=>ty_t_disabled.
    DATA temp6 LIKE LINE OF temp5.

    " original values are UI5Date.getInstance(year, month0, day) - month is
    " 0-based, and those are LOCAL dates. They are kept in the ABAP DATS form
    " (yyyymmdd) and read with Formatter.DateAbapDateToDateObject, which builds
    " the Date from the parsed parts - i.e. local midnight - matching what
    " Calendar does at the other end (CalendarDate.fromLocalJSDate takes the
    " local parts). The ISO date-only form these used to carry is parsed as UTC
    " midnight by `new Date(s)`, so west of Greenwich every fixed date landed a
    " day early: minDate became 1999-12-31 and the disabled range Jan 3-9.
    min_date          = `20000101`.
    max_date          = `20501231`.
    show_week_numbers = abap_true.
    selected_date     = `No Date Selected`.
    
    CLEAR temp5.
    
    temp6-start = `20160104`.
    temp6-end = `20160110`.
    INSERT temp6 INTO TABLE temp5.
    temp6-start = `20160115`.
    temp6-end = ``.
    INSERT temp6 INTO TABLE temp5.
    t_disabled        = temp5.

  ENDMETHOD.

ENDCLASS.
