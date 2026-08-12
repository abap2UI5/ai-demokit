CLASS z2ui5_cl_dmo_app_388 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_dmo_app_388 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " the controller's only handler is MessageToast.show('The GenericTile is
    " pressed.') - a constant text, so every press is the roundtrip-free
    " client toast (app 005/275 idiom) and the app stays init-only
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        " the sample's style.css, injected via a core:HTML content attribute
        " (app 275 precedent); the literal braces are escaped \{ \}
        )->leaf( n = `HTML` ns = `core`
            )->a( n = `content` v = `<style>.tileLayout \{float: left;\}</style>`

        )->open( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Feed Tile that shows updates of the last feeds given to a specific topic:`
            )->a( n = `frameType` v = `TwoByOne`
            )->a( n = `press`     v = client->_event_client( val   = client->cs_event-control_global
                                                             t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `The GenericTile is pressed.` ) ) )

            )->open( `TileContent`
                )->a( n = `footer` v = `New Notifications`

                )->leaf( `FeedContent`
                    )->a( n = `contentText` v = `@@notify Great outcome of the Presentation today. New functionality well received.`
                    )->a( n = `subheader`   v = `About 1 minute ago in Computer Market`
                    )->a( n = `value`       v = `352`

        )->shut(
        )->shut(

        )->open( `SlideTile`
            )->a( n = `class` v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`

            )->open( `tiles`
                )->open( `GenericTile`
                    " asset path kept verbatim, only host-absolutized to the OpenUI5 host
                    )->a( n = `backgroundImage` v = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/GenericTileAsFeedTile/images/NewsImage1.png`
                    )->a( n = `frameType`       v = `TwoByOne`
                    )->a( n = `press`           v = client->_event_client( val   = client->cs_event-control_global
                                                                           t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `The GenericTile is pressed.` ) ) )

                    )->open( `TileContent`
                        )->a( n = `footer` v = `August 21, 2016`

                        )->leaf( `NewsContent`
                            )->a( n = `contentText` v = `Wind Map: Monitoring Real-Time and Fore-casted Wind Conditions across the Globe`
                            )->a( n = `subheader`   v = `Today, SAP News`

                )->shut(
                )->shut(
                )->open( `GenericTile`
                    )->a( n = `backgroundImage` v = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/GenericTileAsFeedTile/images/NewsImage2.png`
                    )->a( n = `frameType`       v = `TwoByOne`
                    )->a( n = `press`           v = client->_event_client( val   = client->cs_event-control_global
                                                                           t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `The GenericTile is pressed.` ) ) )

                    )->open( `TileContent`
                        )->a( n = `footer` v = `August 21, 2016`

                        )->leaf( `NewsContent`
                            )->a( n = `contentText` v = `SAP Unveils Powerful New Player Comparision Tool Exclusively on NFL.com`
                            )->a( n = `subheader`   v = `Today, SAP News` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
