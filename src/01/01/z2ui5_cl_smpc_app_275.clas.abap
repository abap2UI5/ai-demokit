CLASS z2ui5_cl_smpc_app_275 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_275 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " the controller's only handler is MessageToast.show('The generic tile is
    " pressed.') - a constant text, so every press is the roundtrip-free
    " client toast (app 005 idiom) and the app stays init-only
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        " the sample's style.css, injected via a core:HTML content attribute
        " (app 122/124/270 precedent); the literal braces are escaped \{ \}
        )->leaf( n = `HTML` ns = `core`
            )->a( n = `content` v = `<style>.tileLayout \{float: left;\}</style>`

        )->open( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Status Loaded - no press event`
            )->a( n = `subheader` v = `Subheader`

            )->open( `TileContent`
                )->a( n = `unit`   v = `Unit`
                )->a( n = `footer` v = `Footer`

                )->leaf( `ImageContent`
                    )->a( n = `src` v = `sap-icon://line-charts`

        )->shut(
        )->shut(

        )->open( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Status Loaded - with press event`
            )->a( n = `subheader` v = `Subheader`
            )->a( n = `press`     v = client->follow_up_action( val   = client->cs_event-control_global
                                                                t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `The generic tile is pressed.` ) ) )

            )->open( `TileContent`
                )->a( n = `unit`   v = `Unit`
                )->a( n = `footer` v = `Footer`

                )->leaf( `ImageContent`
                    )->a( n = `src` v = `sap-icon://home-share`

        )->shut(
        )->shut(

        )->open( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Status Loading - no press event`
            )->a( n = `subheader` v = `Subheader`
            )->a( n = `state`     v = `Loading`

            )->open( `TileContent`
                )->a( n = `unit`   v = `Unit`
                )->a( n = `footer` v = `Footer`

                )->leaf( `NumericContent`
                    )->a( n = `scale`      v = `M`
                    )->a( n = `value`      v = `2.1`
                    )->a( n = `valueColor` v = `Good`
                    )->a( n = `indicator`  v = `Up`
                    )->a( n = `withMargin` v = `false`

        )->shut(
        )->shut(

        )->open( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Status Loading - with press event`
            )->a( n = `subheader` v = `Subheader`
            )->a( n = `state`     v = `Loading`
            )->a( n = `press`     v = client->follow_up_action( val   = client->cs_event-control_global
                                                                t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `The generic tile is pressed.` ) ) )

            )->open( `TileContent`
                )->a( n = `unit`   v = `Unit`
                )->a( n = `footer` v = `Footer`

                )->leaf( `NumericContent`
                    )->a( n = `scale`      v = `M`
                    )->a( n = `value`      v = `1.96`
                    )->a( n = `valueColor` v = `Error`
                    )->a( n = `indicator`  v = `Down`
                    )->a( n = `withMargin` v = `false`

        )->shut(
        )->shut(

        )->open( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Status Failed - no press event`
            )->a( n = `subheader` v = `Subheader`
            )->a( n = `frameType` v = `TwoByOne`
            )->a( n = `state`     v = `Failed`

            )->open( `TileContent`
                )->a( n = `unit`   v = `Unit`
                )->a( n = `footer` v = `Footer`

                )->leaf( `FeedContent`
                    )->a( n = `contentText` v = `@@notify Great outcome of the Presentation today. The new functionality and the ` &&
                                               `design was well received. Berlin, Tokyo, Rome, Budapest, New York, Munich, London`
                    )->a( n = `subheader`   v = `Subheader`
                    )->a( n = `value`       v = `9`

        )->shut(
        )->shut(

        )->open( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Status Failed - with press event`
            )->a( n = `subheader` v = `Subheader`
            )->a( n = `frameType` v = `TwoByOne`
            )->a( n = `state`     v = `Failed`
            )->a( n = `press`     v = client->follow_up_action( val   = client->cs_event-control_global
                                                                t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `The generic tile is pressed.` ) ) )

            )->open( `TileContent`
                )->a( n = `unit`   v = `Unit`
                )->a( n = `footer` v = `Footer`

                )->leaf( `FeedContent`
                    )->a( n = `contentText` v = `@@notify Great outcome of the Presentation today. The new functionality and the ` &&
                                               `design was well received. Berlin, Tokyo, Rome, Budapest, New York, Munich, London`
                    )->a( n = `subheader`   v = `Subheader`
                    )->a( n = `value`       v = `9`

        )->shut(
        )->shut(

        )->open( `SlideTile`
            )->a( n = `class` v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`

            )->open( `GenericTile`
                )->a( n = `backgroundImage` v = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/GenericTileAsFeedTile/images/NewsImage1.png`
                )->a( n = `frameType`       v = `TwoByOne`
                )->a( n = `state`           v = `Loading`

                )->open( `TileContent`
                    )->a( n = `unit`   v = `Unit`
                    )->a( n = `footer` v = `Footer`

                    )->leaf( `NewsContent`
                        )->a( n = `contentText` v = `Status Loading - no press event`
                        )->a( n = `subheader`   v = `Subheader`

            )->shut(
            )->shut(

            )->open( `GenericTile`
                )->a( n = `backgroundImage` v = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/GenericTileAsFeedTile/images/NewsImage2.png`
                )->a( n = `frameType`       v = `TwoByOne`
                )->a( n = `state`           v = `Loaded`
                )->a( n = `press`           v = client->follow_up_action( val   = client->cs_event-control_global
                                                                          t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `The generic tile is pressed.` ) ) )

                )->open( `TileContent`
                    )->a( n = `unit`   v = `Unit`
                    )->a( n = `footer` v = `Footer`

                    )->leaf( `NewsContent`
                        )->a( n = `contentText` v = `Status Loaded - with press event`
                        )->a( n = `subheader`   v = `Subheader`

            )->shut(
            )->shut(
        )->shut(

        )->open( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Status Disabled - no press event`
            )->a( n = `subheader` v = `Subheader`
            )->a( n = `state`     v = `Disabled`

            )->open( `TileContent`
                )->a( n = `footer` v = `Footer`
                )->a( n = `unit`   v = `Unit`

                )->leaf( `NumericContent`
                    )->a( n = `value`      v = `3`
                    )->a( n = `icon`       v = `sap-icon://travel-expense`
                    )->a( n = `withMargin` v = `false`

        )->shut(
        )->shut(

        )->open( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Status Disabled - with press event`
            )->a( n = `subheader` v = `Subheader`
            )->a( n = `state`     v = `Disabled`
            )->a( n = `press`     v = client->follow_up_action( val   = client->cs_event-control_global
                                                                t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `The generic tile is pressed.` ) ) )

            )->open( `TileContent`
                )->a( n = `footer` v = `Footer`
                )->a( n = `unit`   v = `Unit`

                )->leaf( `NumericContent`
                    )->a( n = `value`      v = `3`
                    )->a( n = `icon`       v = `sap-icon://travel-expense`
                    )->a( n = `withMargin` v = `false`

                    ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " the sample has no model - every tile is declared with literals
    RETURN.

  ENDMETHOD.

ENDCLASS.
