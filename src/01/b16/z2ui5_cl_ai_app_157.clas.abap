CLASS z2ui5_cl_ai_app_157 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_157 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->open( `HeaderContainer`
            )->a( n = `scrollStep`  v = `124`
            )->a( n = `scrollTime`  v = `500`
            )->a( n = `orientation` v = `Vertical`
            )->a( n = `height`      v = `400px`
            )->leaf( `NumericContent`
                )->a( n = `scale`      v = `M`
                )->a( n = `value`      v = `1.75`
                )->a( n = `valueColor` v = `Good`
                )->a( n = `indicator`  v = `Up`
                )->a( n = `press`      v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `The numeric content is pressed.` ) ) )
            )->leaf( `NumericContent`
                )->a( n = `scale`      v = `M`
                )->a( n = `value`      v = `0.57`
                )->a( n = `valueColor` v = `Error`
                )->a( n = `indicator`  v = `Down`
                )->a( n = `press`      v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `The numeric content is pressed.` ) ) )
            )->leaf( `NumericContent`
                )->a( n = `scale`      v = `M`
                )->a( n = `value`      v = `1.04`
                )->a( n = `valueColor` v = `Neutral`
                )->a( n = `indicator`  v = `Up`
                )->a( n = `press`      v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `The numeric content is pressed.` ) ) )
            )->leaf( `NumericContent`
                )->a( n = `scale`      v = `M`
                )->a( n = `value`      v = `3.65`
                )->a( n = `valueColor` v = `Good`
                )->a( n = `indicator`  v = `Up`
                )->a( n = `press`      v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `The numeric content is pressed.` ) ) )
            )->leaf( `NumericContent`
                )->a( n = `scale`      v = `M`
                )->a( n = `value`      v = `0.73`
                )->a( n = `valueColor` v = `Error`
                )->a( n = `indicator`  v = `Down`
                )->a( n = `press`      v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `The numeric content is pressed.` ) ) )
            )->leaf( `NumericContent`
                )->a( n = `scale`      v = `M`
                )->a( n = `value`      v = `1.01`
                )->a( n = `valueColor` v = `Critical`
                )->a( n = `indicator`  v = `Down`
                )->a( n = `press`      v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `The numeric content is pressed.` ) ) )
            )->leaf( `NumericContent`
                )->a( n = `scale`      v = `M`
                )->a( n = `value`      v = `1.42`
                )->a( n = `valueColor` v = `Good`
                )->a( n = `indicator`  v = `Up`
                )->a( n = `press`      v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `The numeric content is pressed.` ) ) )
            )->leaf( `NumericContent`
                )->a( n = `scale`      v = `M`
                )->a( n = `value`      v = `0.21`
                )->a( n = `valueColor` v = `Error`
                )->a( n = `indicator`  v = `Down`
                )->a( n = `press`      v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `The numeric content is pressed.` ) ) )

        )->shut(

        )->open( `HeaderContainer`
            )->a( n = `scrollStep`  v = `200`
            )->a( n = `orientation` v = `Vertical`
            )->a( n = `height`      v = `400px`
            )->open( `TileContent`
                )->a( n = `unit`   v = `EUR`
                )->a( n = `footer` v = `Current Quarter`
                )->open( `content`
                    )->leaf( `NumericContent`
                        )->a( n = `value`      v = `1.96`
                        )->a( n = `valueColor` v = `Error`
                        )->a( n = `indicator`  v = `Down`
                        )->a( n = `press`      v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `The numeric content is pressed.` ) ) )

            )->shut(
            )->shut(
            )->open( `TileContent`
                )->a( n = `footer` v = `Leave Requests`
                )->open( `content`
                    )->leaf( `NumericContent`
                        )->a( n = `value` v = `35`
                        )->a( n = `icon`  v = `sap-icon://travel-expense`

            )->shut(
            )->shut(
            )->open( `TileContent`
                )->a( n = `footer` v = `Hours since last Activity`
                )->open( `content`
                    )->leaf( `NumericContent`
                        )->a( n = `value` v = `9`
                        )->a( n = `icon`  v = `sap-icon://horizontal-bar-chart`

            )->shut(
            )->shut(
            )->open( `TileContent`
                )->a( n = `unit`   v = `EUR`
                )->a( n = `footer` v = `Current Quarter`
                )->open( `content`
                    )->leaf( `NumericContent`
                        )->a( n = `scale`      v = `M`
                        )->a( n = `value`      v = `88`
                        )->a( n = `valueColor` v = `Good`
                        )->a( n = `indicator`  v = `Up`

            )->shut(
            )->shut(
            )->open( `TileContent`
                )->a( n = `unit`   v = `Unit`
                )->a( n = `footer` v = `Footer Text`
                )->open( `content`
                    )->leaf( `NumericContent`
                        )->a( n = `value` v = `1522`
                        )->a( n = `icon`  v = `sap-icon://bubble-chart` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
