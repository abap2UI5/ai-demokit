" @keywords calendar sap.ui.unified calendarmultiplemonth verticallayout daterange horizontallayout button label text
" @summary Calendar with more than one month
CLASS z2ui5_cl_smpc_app_304 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA selected_date TYPE string.

    " The calendar's OWN selection, as the model owns it. selectedDates is a
    " bindable aggregation of sap.ui.unified.DateRange, exactly like the
    " disabledDates app 220 binds - so the highlight is expressible after all,
    " and handleSelectToday's removeAllSelectedDates + addSelectedDate(today)
    " becomes "replace the one row". The deviation here used to say the
    " highlight could not be moved because addSelectedDate takes a DateRange
    " CONTROL no wire can construct: true of the METHOD, and beside the point,
    " since the aggregation never needed the method. Every click round-trips
    " through CAL_SELECT, so the model is the source of truth and the control's
    " own click-selection is re-stated rather than fought.
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


CLASS z2ui5_cl_smpc_app_304 IMPLEMENTATION.

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

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`

            )->ele( n = `Calendar` ns = `u`
                )->a( n = `id`     v = `calendar`
                )->a( n = `months` v = `2`
                " the picked day is read out of the event as a UI5 EXPRESSION - indexed
                " access and chained calls resolve there (app 139 idiom). The LOCAL date
                " parts travel, not toISOString( ), which would shift the day east of
                " Greenwich
                )->a( n = `selectedDates` v = client->_bind( t_selected )
                )->a( n = `select` v = client->_event( val   = `CAL_SELECT`
                                                       t_arg = VALUE #(
                                                         ( `$event.oSource.getSelectedDates().length > 0 ? $event.oSource.getSelectedDates()[0].getStartDate().getFullYear() : 0` )
                                                         ( `$event.oSource.getSelectedDates().length > 0 ? $event.oSource.getSelectedDates()[0].getStartDate().getMonth() + 1 : 0` )
                                                         ( `$event.oSource.getSelectedDates().length > 0 ? $event.oSource.getSelectedDates()[0].getStartDate().getDate() : 0` ) ) )

                )->ele( n = `selectedDates` ns = `u`
                    )->tag( n = `DateRange` ns = `u`
                        " the ABAP DATS form read through the local-parts
                        " formatter, as app 220 does - `new Date('yyyy-mm-dd')`
                        " would be UTC midnight and land a day early west of
                        " Greenwich
                        )->a( n = `startDate` v = |\{ path: 'START', formatter: 'Formatter.DateAbapDateToDateObject' \}|

                )->end(
            )->end(

            )->ele( n = `HorizontalLayout` ns = `l`
                )->a( n = `allowWrapping` v = `true`

                )->tag( `Button`
                    )->a( n = `press` v = client->_event( `SELECT_TODAY` )
                    )->a( n = `text`  v = `Select Today`
                    )->a( n = `class` v = `sapUiSmallMarginEnd`
                )->tag( `Label`
                    )->a( n = `text`  v = `Selected Date (yyyy-mm-dd):`
                    )->a( n = `class` v = `sapUiSmallMarginEnd`
                )->tag( `Text`
                    )->a( n = `id`   v = `selectedDate`
                    )->a( n = `text` v = client->_bind( selected_date ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `CAL_SELECT`.
        " _updateText: format getSelectedDates()[0] as yyyy-MM-dd. The day arrives
        " as its three LOCAL parts (see the wire in view_display)
        DATA(year) = client->get_event_arg( ).
        IF year IS INITIAL OR year = `0`.
          selected_date = `No Date Selected`.
          CLEAR t_selected.
        ELSE.
          DATA(month) = |{ CONV i( client->get_event_arg( 2 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }|.
          DATA(day)   = |{ CONV i( client->get_event_arg( 3 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }|.
          selected_date = |{ year }-{ month }-{ day }|.
          " the bound aggregation is re-stated with the day the user picked, so
          " the model and the control's own highlight cannot drift apart
          t_selected    = VALUE #( ( start = |{ year }{ month }{ day }| ) ).
        ENDIF.

      WHEN `SELECT_TODAY`.
        " handleSelectToday: removeAllSelectedDates( ) + addSelectedDate(
        " DateRange( today ) ) + reformat. Both halves are reproduced since
        " 2026-08-21 - replacing the one row of the bound selectedDates
        " aggregation IS that pair - so the highlight really moves to today.
        " Until then only the text was updated, on the claim that
        " addSelectedDate takes a DateRange CONTROL no wire can construct; that
        " is true of the METHOD and beside the point, because selectedDates is
        " a bindable aggregation (app 220 binds disabledDates, the same type).
        selected_date = |{ sy-datum+0(4) }-{ sy-datum+4(2) }-{ sy-datum+6(2) }|.
        t_selected    = VALUE #( ( start = |{ sy-datum }| ) ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
