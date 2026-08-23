" @keywords calendardateinterval calendar date interval sap.ui.unified calendardateintervalbasic html verticallayout button horizontallayout label text
" @summary CalendarDateInterval with 14 days and single day selection
CLASS z2ui5_cl_smpc_app_177 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA selected_date TYPE string.

    " The calendar's OWN selection, as the model owns it (app 139's shape):
    " selectedDates is a bindable aggregation of sap.ui.unified.DateRange, so
    " both halves of the controller - the re-click that REMOVES the selection
    " and Select Today's removeAllSelectedDates + addSelectedDate - are model
    " writes rather than control calls
    TYPES:
      BEGIN OF ty_s_day,
        start TYPE string,
      END OF ty_s_day.
    DATA t_selected TYPE STANDARD TABLE OF ty_s_day WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_177 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      selected_date = `No Date Selected`.
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

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
        " rule behind it has to come with it. \{ \} escaped: the XMLView parser
        " reads an unescaped brace as a binding
        )->tag( n = `HTML` ns = `core`
            )->a( n = `content` v = `<style>.viewPadding\{padding:1rem\}` &&
                                    `.sap-phone .viewPadding\{padding:0rem\}` &&
                                    `.sap-phone .sapUiCal\{position:relative\}` &&
                                    `.labelMarginLeft\{margin:1rem\}</style>`
        )->ele( n = `VerticalLayout` ns = `l`
            )->ele( n = `CalendarDateInterval` ns = `u`
                )->a( n = `id`            v = `calendar`
                )->a( n = `width`         v = `320px`
                )->a( n = `selectedDates` v = client->_bind( t_selected )
                " the picked day is read out of the event as a UI5 EXPRESSION - indexed
                " access and chained calls resolve there (measured with
                " scripts/probes/event-arg-expression-probe.mjs). The LOCAL date parts
                " travel, not toISOString( ), which would shift the day east of
                " Greenwich. The length guard is defensive only: in single-selection
                " mode Month._selectDay never leaves selectedDates empty - the
                " original's deselect is its CONTROLLER removing the DateRange, and
                " that is reproduced in on_event against the bound aggregation
                )->a( n = `select` v = client->_event( val   = `CAL_SELECT`
                                                       t_arg = VALUE #(
                                                         ( `$event.oSource.getSelectedDates().length > 0 ? $event.oSource.getSelectedDates()[0].getStartDate().getFullYear() : 0` )
                                                         ( `$event.oSource.getSelectedDates().length > 0 ? $event.oSource.getSelectedDates()[0].getStartDate().getMonth() + 1 : 0` )
                                                         ( `$event.oSource.getSelectedDates().length > 0 ? $event.oSource.getSelectedDates()[0].getStartDate().getDate() : 0` ) ) )

                )->ele( n = `selectedDates` ns = `u`
                    )->tag( n = `DateRange` ns = `u`
                        " ABAP DATS through the local-parts formatter, as apps 139/220
                        " do - `new Date('yyyy-mm-dd')` is UTC midnight and would land
                        " a day early west of Greenwich
                        )->a( n = `startDate` v = |\{ path: 'START', formatter: 'Formatter.DateAbapDateToDateObject' \}|

                )->end(

                )->ele( n = `VerticalLayout` ns = `l`
                    )->tag( `Button`
                        )->a( n = `press` v = client->_event( `SELECT_TODAY` )
                        )->a( n = `text`  v = `Select Today`

                    )->ele( n = `HorizontalLayout` ns = `l`
                        )->tag( `Label`
                            )->a( n = `text`     v = `Selected Date:`
                            )->a( n = `labelFor` v = `selectedDate`
                            )->a( n = `class`    v = `labelMarginLeft`
                        )->tag( `Text`
                            )->a( n = `id`    v = `selectedDate`
                            )->a( n = `text`  v = client->_bind( selected_date )
                            )->a( n = `class` v = `labelMarginLeft` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `CAL_SELECT`.
        " handleCalendarSelect: the controller keeps the last picked day and
        " REMOVES the DateRange again when the same day is clicked twice
        " (single-selection mode never deselects by itself); _updateText then
        " prints yyyy-MM-dd or 'No Date Selected'. Both halves are reproduced
        " against the bound selectedDates aggregation
        DATA(year) = client->get_event_arg( ).
        IF year IS INITIAL OR year = `0`.
          selected_date = `No Date Selected`.
          CLEAR t_selected.
        ELSE.
          DATA(month) = |{ CONV i( client->get_event_arg( 2 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }|.
          DATA(day)   = |{ CONV i( client->get_event_arg( 3 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }|.
          DATA(picked) = |{ year }-{ month }-{ day }|.
          IF picked = selected_date.
            " the same day again - the original's removeSelectedDate branch
            selected_date = `No Date Selected`.
            CLEAR t_selected.
          ELSE.
            selected_date = picked.
            t_selected    = VALUE #( ( start = |{ year }{ month }{ day }| ) ).
          ENDIF.
        ENDIF.

      WHEN `SELECT_TODAY`.
        " handleSelectToday: removeAllSelectedDates + addSelectedDate( today ).
        " Re-stating the bound aggregation with one row IS both calls, so the
        " highlight really moves - the server date is today
        selected_date = |{ sy-datum+0(4) }-{ sy-datum+4(2) }-{ sy-datum+6(2) }|.
        t_selected    = VALUE #( ( start = |{ sy-datum }| ) ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
