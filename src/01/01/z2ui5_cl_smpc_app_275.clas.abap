" @keywords generictile generic tile sap.m generictilestates html tilecontent imagecontent numericcontent feedcontent slidetile newscontent
" @summary Shows the GenericTile while it is loading, if loading fails, and in disabled status.
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
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " the controller's only handler is MessageToast.show('The generic tile is
    " pressed.') - a constant text, so every press is the roundtrip-free
    " client toast (app 005 idiom) and the app stays init-only
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        " the sample's style.css, injected via a core:HTML content attribute
        " (app 122/124/270 precedent); the literal braces are escaped \{ \}
        )->tag( n = `HTML` ns = `core`
            )->a( n = `content` v = `<style>.tileLayout \{float: left;\}</style>`

        )->ele( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Status Loaded - no press event`
            )->a( n = `subheader` v = `Subheader`

            )->ele( `TileContent`
                )->a( n = `unit`   v = `Unit`
                )->a( n = `footer` v = `Footer`

                )->tag( `ImageContent`
                    )->a( n = `src` v = `sap-icon://line-charts`

            )->end(
        )->end(

        )->ele( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Status Loaded - with press event`
            )->a( n = `subheader` v = `Subheader`
            )->a( n = `press`     v = client->follow_up_action( val   = client->cs_event-control_global
                                                                t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `The generic tile is pressed.` ) ) )

            )->ele( `TileContent`
                )->a( n = `unit`   v = `Unit`
                )->a( n = `footer` v = `Footer`

                )->tag( `ImageContent`
                    )->a( n = `src` v = `sap-icon://home-share`

            )->end(
        )->end(

        )->ele( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Status Loading - no press event`
            )->a( n = `subheader` v = `Subheader`
            )->a( n = `state`     v = `Loading`

            )->ele( `TileContent`
                )->a( n = `unit`   v = `Unit`
                )->a( n = `footer` v = `Footer`

                )->tag( `NumericContent`
                    )->a( n = `scale`      v = `M`
                    )->a( n = `value`      v = `2.1`
                    )->a( n = `valueColor` v = `Good`
                    )->a( n = `indicator`  v = `Up`
                    )->a( n = `withMargin` v = `false`

            )->end(
        )->end(

        )->ele( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Status Loading - with press event`
            )->a( n = `subheader` v = `Subheader`
            )->a( n = `state`     v = `Loading`
            )->a( n = `press`     v = client->follow_up_action( val   = client->cs_event-control_global
                                                                t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `The generic tile is pressed.` ) ) )

            )->ele( `TileContent`
                )->a( n = `unit`   v = `Unit`
                )->a( n = `footer` v = `Footer`

                )->tag( `NumericContent`
                    )->a( n = `scale`      v = `M`
                    )->a( n = `value`      v = `1.96`
                    )->a( n = `valueColor` v = `Error`
                    )->a( n = `indicator`  v = `Down`
                    )->a( n = `withMargin` v = `false`

            )->end(
        )->end(

        )->ele( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Status Failed - no press event`
            )->a( n = `subheader` v = `Subheader`
            )->a( n = `frameType` v = `TwoByOne`
            )->a( n = `state`     v = `Failed`

            )->ele( `TileContent`
                )->a( n = `unit`   v = `Unit`
                )->a( n = `footer` v = `Footer`

                )->tag( `FeedContent`
                    )->a( n = `contentText` v = `@@notify Great outcome of the Presentation today. The new functionality and the ` &&
                                               `design was well received. Berlin, Tokyo, Rome, Budapest, New York, Munich, London`
                    )->a( n = `subheader`   v = `Subheader`
                    )->a( n = `value`       v = `9`

            )->end(
        )->end(

        )->ele( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Status Failed - with press event`
            )->a( n = `subheader` v = `Subheader`
            )->a( n = `frameType` v = `TwoByOne`
            )->a( n = `state`     v = `Failed`
            )->a( n = `press`     v = client->follow_up_action( val   = client->cs_event-control_global
                                                                t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `The generic tile is pressed.` ) ) )

            )->ele( `TileContent`
                )->a( n = `unit`   v = `Unit`
                )->a( n = `footer` v = `Footer`

                )->tag( `FeedContent`
                    )->a( n = `contentText` v = `@@notify Great outcome of the Presentation today. The new functionality and the ` &&
                                               `design was well received. Berlin, Tokyo, Rome, Budapest, New York, Munich, London`
                    )->a( n = `subheader`   v = `Subheader`
                    )->a( n = `value`       v = `9`

            )->end(
        )->end(

        )->ele( `SlideTile`
            )->a( n = `class` v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`

            )->ele( `GenericTile`
                )->a( n = `backgroundImage` v = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/GenericTileAsFeedTile/images/NewsImage1.png`
                )->a( n = `frameType`       v = `TwoByOne`
                )->a( n = `state`           v = `Loading`

                )->ele( `TileContent`
                    )->a( n = `unit`   v = `Unit`
                    )->a( n = `footer` v = `Footer`

                    )->tag( `NewsContent`
                        )->a( n = `contentText` v = `Status Loading - no press event`
                        )->a( n = `subheader`   v = `Subheader`

                )->end(
            )->end(

            )->ele( `GenericTile`
                )->a( n = `backgroundImage` v = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/GenericTileAsFeedTile/images/NewsImage2.png`
                )->a( n = `frameType`       v = `TwoByOne`
                )->a( n = `state`           v = `Loaded`
                )->a( n = `press`           v = client->follow_up_action( val   = client->cs_event-control_global
                                                                          t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `The generic tile is pressed.` ) ) )

                )->ele( `TileContent`
                    )->a( n = `unit`   v = `Unit`
                    )->a( n = `footer` v = `Footer`

                    )->tag( `NewsContent`
                        )->a( n = `contentText` v = `Status Loaded - with press event`
                        )->a( n = `subheader`   v = `Subheader`

                )->end(
            )->end(
        )->end(

        )->ele( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Status Disabled - no press event`
            )->a( n = `subheader` v = `Subheader`
            )->a( n = `state`     v = `Disabled`

            )->ele( `TileContent`
                )->a( n = `footer` v = `Footer`
                )->a( n = `unit`   v = `Unit`

                )->tag( `NumericContent`
                    )->a( n = `value`      v = `3`
                    )->a( n = `icon`       v = `sap-icon://travel-expense`
                    )->a( n = `withMargin` v = `false`

            )->end(
        )->end(

        )->ele( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Status Disabled - with press event`
            )->a( n = `subheader` v = `Subheader`
            )->a( n = `state`     v = `Disabled`
            )->a( n = `press`     v = client->follow_up_action( val   = client->cs_event-control_global
                                                                t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `The generic tile is pressed.` ) ) )

            )->ele( `TileContent`
                )->a( n = `footer` v = `Footer`
                )->a( n = `unit`   v = `Unit`

                )->tag( `NumericContent`
                    )->a( n = `value`      v = `3`
                    )->a( n = `icon`       v = `sap-icon://travel-expense`
                    )->a( n = `withMargin` v = `false`

                    ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " the sample has no model - every tile is declared with literals

  ENDMETHOD.

ENDCLASS.
