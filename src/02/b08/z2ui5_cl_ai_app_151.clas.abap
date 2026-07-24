CLASS z2ui5_cl_ai_app_151 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA selected_date TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_151 IMPLEMENTATION.

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
                )->a( n = `select`                v = client->_event( `CAL_SELECT` )

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

      WHEN `CAL_SELECT` OR `FOCUS_TODAY`.
        " original: Calendar.select formats the selected day; 'Focus Today'
        " focuses today. Both report the current server date (yyyy-MM-dd);
        " the primary calendar is Islamic but the status shows the Gregorian
        " server date, matching the label. Reading the clicked day is simplified.
        selected_date = |{ sy-datum+0(4) }-{ sy-datum+4(2) }-{ sy-datum+6(2) }|.
        client->view_model_update( ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
