" @keywords calendar sap.ui.unified single day html verticallayout daterange button horizontallayout label text
" @summary Calendar where the user can select a single day
CLASS z2ui5_cl_smpc_app_139 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA selected_date TYPE string.

    " The calendar's OWN selection, as the model owns it - selectedDates is a
    " bindable aggregation of sap.ui.unified.DateRange, the same type and shape
    " app 220 binds for disabledDates. See the SELECT_TODAY handler for why the
    " old "no wire can construct a DateRange" rationale missed it.
    TYPES:
      BEGIN OF ty_s_day,
        start TYPE string,
      END OF ty_s_day.
    DATA t_selected TYPE STANDARD TABLE OF ty_s_day WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_139 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      selected_date = `No Date Selected`.
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

    
    CLEAR temp1.
    INSERT `$event.oSource.getSelectedDates().length > 0 ? $event.oSource.getSelectedDates()[0].getStartDate().getFullYear() : 0` INTO TABLE temp1.
    INSERT `$event.oSource.getSelectedDates().length > 0 ? $event.oSource.getSelectedDates()[0].getStartDate().getMonth() + 1 : 0` INTO TABLE temp1.
    INSERT `$event.oSource.getSelectedDates().length > 0 ? $event.oSource.getSelectedDates()[0].getStartDate().getDate() : 0` INTO TABLE temp1.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:u`   v = `sap.ui.unified`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `class`     v = `viewPadding`

        )->a( n = `xmlns:core` v = `sap.ui.core`
        " the selectedDates formatter has to be loaded, or the XMLView parser
        " rejects the binding with "formatter function ... not found"
        )->a( n = `core:require` v = `{Formatter: 'z2ui5/model/formatter'}`

        " the sample's own ../style.css (shared by the sap.ui.unified samples and
        " listed in this sample's manifest) - the view carries the class and the
        " rule behind it has to come with it. .sapUiCal is not an author class:
        " CalendarRenderer writes it on the Calendar's own root, so the phone
        " rule of the sheet does apply to this view. \{ \} escaped: the XMLView
        " parser reads an unescaped brace as a binding
        )->tag( n = `HTML` ns = `core`
            )->a( n = `content` v = `<style>.viewPadding\{padding:1rem\}` &&
                                    `.sap-phone .viewPadding\{padding:0rem\}` &&
                                    `.sap-phone .sapUiCal\{position:relative\}` &&
                                    `.labelMarginLeft\{margin:1rem\}</style>`
        )->ele( n = `VerticalLayout` ns = `l`

            )->ele( n = `Calendar` ns = `u`
                )->a( n = `id`            v = `calendar`
                )->a( n = `selectedDates` v = client->_bind( t_selected )
                " the picked day is read out of the event as a UI5 EXPRESSION - indexed
                " access and chained calls resolve there (measured with
                " scripts/probes/event-arg-expression-probe.mjs). The LOCAL date parts
                " travel, not toISOString( ), which would shift the day east of
                " Greenwich. The length guard is defensive only - in single-selection
                " mode Month._selectDay never leaves selectedDates empty, and the
                " deselect path belongs to the sibling CalendarDateDeselection sample
                )->a( n = `select` v = client->_event( val   = `CAL_SELECT`
                                                       t_arg = temp1 )

                )->ele( n = `selectedDates` ns = `u`
                    )->tag( n = `DateRange` ns = `u`
                        " ABAP DATS through the local-parts formatter, as app 220
                        " does - `new Date('yyyy-mm-dd')` is UTC midnight and would
                        " land a day early west of Greenwich
                        )->a( n = `startDate` v = |\{ path: 'START', formatter: 'Formatter.DateAbapDateToDateObject' \}|

                )->end(
            )->end(

            )->tag( `Button`
                )->a( n = `press` v = client->_event( `SELECT_TODAY` )
                )->a( n = `text`  v = `Select Today`

            )->ele( n = `HorizontalLayout` ns = `l`
                )->tag( `Label`
                    )->a( n = `text`  v = `Selected Date (yyyy-mm-dd):`
                    )->a( n = `class` v = `labelMarginLeft`
                )->tag( `Text`
                    )->a( n = `id`    v = `selectedDate`
                    )->a( n = `text`  v = client->_bind( selected_date )
                    )->a( n = `class` v = `labelMarginLeft` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA year TYPE string.
          DATA temp3 TYPE i.
          DATA month TYPE string.
          DATA temp4 TYPE i.
          DATA day TYPE string.
          DATA temp5 LIKE t_selected.
          DATA temp6 LIKE LINE OF temp5.
        DATA temp7 LIKE t_selected.
        DATA temp8 LIKE LINE OF temp7.

    CASE client->get_event( ).

      WHEN `CAL_SELECT`.
        " _updateText: format getSelectedDates()[0] as yyyy-MM-dd. The day
        " arrives as its three LOCAL parts (see the wire in view_display);
        " year 0 means the selection was cleared by re-clicking the same day
        
        year = client->get_event_arg( ).
        IF year IS INITIAL OR year = `0`.
          selected_date = `No Date Selected`.
        ELSE.
          
          temp3 = client->get_event_arg( 2 ).
          
          month = |{ temp3 WIDTH = 2 ALIGN = RIGHT PAD = '0' }|.
          
          temp4 = client->get_event_arg( 3 ).
          
          day   = |{ temp4 WIDTH = 2 ALIGN = RIGHT PAD = '0' }|.
          selected_date = |{ year }-{ month }-{ day }|.
          " the bound aggregation is re-stated with the day the user picked, so
          " the model and the control's own highlight cannot drift apart
          
          CLEAR temp5.
          
          temp6-start = |{ year }{ month }{ day }|.
          INSERT temp6 INTO TABLE temp5.
          t_selected    = temp5.
        ENDIF.

      WHEN `SELECT_TODAY`.
        " handleSelectToday adds a DateRange( today ) and reformats. Both halves
        " are reproduced since 2026-08-21 - replacing the one row of the bound
        " selectedDates aggregation IS that add - so the highlight really moves
        " to today. Until then only the text was updated, on the claim that
        " addSelectedDate takes a DateRange CONTROL no wire can construct: true
        " of the METHOD, and beside the point, since selectedDates is a bindable
        " aggregation (app 220 binds disabledDates, the same type).
        selected_date = |{ sy-datum+0(4) }-{ sy-datum+4(2) }-{ sy-datum+6(2) }|.
        
        CLEAR temp7.
        
        temp8-start = |{ sy-datum }|.
        INSERT temp8 INTO TABLE temp7.
        t_selected    = temp7.

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
