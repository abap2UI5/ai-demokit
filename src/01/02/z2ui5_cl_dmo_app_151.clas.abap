CLASS z2ui5_cl_dmo_app_151 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA selected_date TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_dmo_app_151 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      selected_date = `No Date Selected`.
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:u`   v = `sap.ui.unified`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `class`     v = `viewPadding`

        )->open( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`

            )->leaf( n = `Calendar` ns = `u`
                )->a( n = `id`                    v = `calendar`
                )->a( n = `primaryCalendarType`   v = `Islamic`
                )->a( n = `secondaryCalendarType` v = `Gregorian`
                " the picked day is read out of the event as a UI5 EXPRESSION - indexed
                " access and chained calls resolve there (measured with
                " scripts/probes/event-arg-expression-probe.mjs). The LOCAL date parts
                " travel, not toISOString( ), which would shift the day east of
                " Greenwich; the length guard reproduces the deselect case
                )->a( n = `select`                v = client->_event( val   = `CAL_SELECT`
                                                                      t_arg = VALUE #(
                                                                        ( `$event.oSource.getSelectedDates().length > 0 ? $event.oSource.getSelectedDates()[0].getStartDate().getFullYear() : 0` )
                                                                        ( `$event.oSource.getSelectedDates().length > 0 ? $event.oSource.getSelectedDates()[0].getStartDate().getMonth() + 1 : 0` )
                                                                        ( `$event.oSource.getSelectedDates().length > 0 ? $event.oSource.getSelectedDates()[0].getStartDate().getDate() : 0` ) ) )

            )->open( n = `HorizontalLayout` ns = `l`
                )->a( n = `allowWrapping` v = `true`
                )->leaf( `Button`
                    )->a( n = `press` v = client->_event( `FOCUS_TODAY` )
                    )->a( n = `text`  v = `Focus Today`
                    )->a( n = `class` v = `sapUiSmallMarginEnd`
                )->leaf( `Label`
                    )->a( n = `text`  v = `Selected Date (yyyy-mm-dd):`
                    )->a( n = `class` v = `sapUiSmallMarginEnd`
                )->leaf( `Text`
                    )->a( n = `id`   v = `selectedDate`
                    )->a( n = `text` v = client->_bind( selected_date ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `CAL_SELECT`.
        " Calendar.select formats the SELECTED day as Gregorian yyyy-MM-dd (the
        " primary calendar is Islamic, the status text stays Gregorian like its
        " label). The day arrives as its three LOCAL parts; year 0 means the
        " re-click cleared the selection
        DATA(year) = client->get_event_arg( ).
        IF year IS INITIAL OR year = `0`.
          selected_date = `No Date Selected`.
        ELSE.
          selected_date = |{ year }-{ CONV i( client->get_event_arg( 2 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
                          |-{ CONV i( client->get_event_arg( 3 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }|.
        ENDIF.

      WHEN `FOCUS_TODAY`.
        " handleFocusToday only calls focusDate(today) - it changes no text in
        " the original. The port keeps writing the server date (= today), which
        " is what the button visibly does here; the calendar focus itself is not
        " moved (focusDate takes a Date OBJECT no wire can construct)
        selected_date = |{ sy-datum+0(4) }-{ sy-datum+4(2) }-{ sy-datum+6(2) }|.

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
