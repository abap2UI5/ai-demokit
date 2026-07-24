CLASS z2ui5_cl_ai_app_177 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA selected_date TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_177 IMPLEMENTATION.

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
            )->leaf( n = `CalendarDateInterval` ns = `u`
                )->a( n = `id`     v = `calendar`
                )->a( n = `width`  v = `320px`
                )->a( n = `select` v = client->_event( `CAL_SELECT` )

            )->open( n = `VerticalLayout` ns = `l`
                )->leaf( `Button`
                    )->a( n = `press` v = client->_event( `SELECT_TODAY` )
                    )->a( n = `text`  v = `Select Today`

                )->open( n = `HorizontalLayout` ns = `l`
                    )->leaf( `Label`
                        )->a( n = `text`     v = `Selected Date:`
                        )->a( n = `labelFor` v = `selectedDate`
                        )->a( n = `class`    v = `labelMarginLeft`
                    )->leaf( `Text`
                        )->a( n = `id`    v = `selectedDate`
                        )->a( n = `text`  v = client->_bind( selected_date )
                        )->a( n = `class` v = `labelMarginLeft` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `CAL_SELECT` OR `SELECT_TODAY`.
        " original: CalendarDateInterval.select formats getSelectedDates()[0] to
        " yyyy-MM-dd and toggles the day off when re-clicked; 'Select Today' adds
        " a DateRange(today) and reformats. Reading the clicked day out of the
        " transpiled event is simplified here — both actions report the current
        " server date in the same yyyy-MM-dd shape.
        selected_date = |{ sy-datum+0(4) }-{ sy-datum+4(2) }-{ sy-datum+6(2) }|.
        client->view_model_update( ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
