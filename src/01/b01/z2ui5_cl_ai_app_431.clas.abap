CLASS z2ui5_cl_ai_app_431 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_431 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        " the sample's style.css, injected via a core:HTML content attribute (see CAPABILITIES.md)
        )->leaf( n = `HTML` ns = `core`
            " literal braces escaped \{ \} - the XMLView binding parser reads unescaped braces as a binding
            )->a( n = `content` v = `<style>.tileLayout\{float:left\}</style>`

        )->open( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Country-Specific Profit Margin`
            )->a( n = `frameType` v = `OneByHalf`
            )->a( n = `subheader` v = `Expenses`
            )->a( n = `press`     v = client->_event( `PRESS` )

            )->open( `TileContent`
                )->a( n = `unit`   v = `EUR`
                )->a( n = `footer` v = `Current Quarter`

                )->leaf( `NumericContent`
                    )->a( n = `scale`      v = `M`
                    )->a( n = `value`      v = `1.96`
                    )->a( n = `valueColor` v = `Error`
                    )->a( n = `indicator`  v = `Up`
                    )->a( n = `withMargin` v = `false`

            )->shut(
        )->shut(

        )->open( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `US Profit Margin`
            )->a( n = `press`     v = client->_event( `PRESS` )
            )->a( n = `frameType` v = `OneByHalf`

            )->open( `TileContent`
                )->a( n = `unit` v = `Unit`

                )->leaf( `NumericContent`
                    )->a( n = `scale`      v = `%`
                    )->a( n = `value`      v = `12`
                    )->a( n = `valueColor` v = `Critical`
                    )->a( n = `indicator`  v = `Up`
                    )->a( n = `withMargin` v = `false`

            )->shut(
        )->shut(

        )->open( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Sales Fulfillment Application Title`
            )->a( n = `subheader` v = `Subtitle`
            )->a( n = `press`     v = client->_event( `PRESS` )
            )->a( n = `frameType` v = `TwoByHalf`

            )->open( `TileContent`
                )->a( n = `unit`   v = `EUR`
                )->a( n = `footer` v = `Current Quarter`

                )->leaf( `ImageContent`
                    )->a( n = `src` v = `sap-icon://home-share`

            )->shut(
        )->shut(

        )->open( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Manage Activity Master Data Type`
            )->a( n = `subheader` v = `Subtitle`
            )->a( n = `press`     v = client->_event( `PRESS` )
            )->a( n = `frameType` v = `OneByHalf`

            )->open( `TileContent`
                )->leaf( `ImageContent`
                    )->a( n = `src` v = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/GenericTileAsLaunchTile/images/SAPLogoLargeTile_28px_height.png`

            )->shut(
        )->shut(

        )->open( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Manage Activity Master Data Type With a Long Title Without an Icon`
            )->a( n = `subheader` v = `Subtitle Launch Tile`
            )->a( n = `mode`      v = `HeaderMode`
            )->a( n = `press`     v = client->_event( `PRESS` )

            )->leaf( `TileContent`
                )->a( n = `unit`   v = `EUR`
                )->a( n = `footer` v = `Current Quarter`

        )->shut(

        )->open( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Jessica D. Prince Senior Consultant`
            )->a( n = `subheader` v = `Department`
            )->a( n = `press`     v = client->_event( `PRESS` )

            )->open( `TileContent`
                )->leaf( `ImageContent`
                    )->a( n = `src` v = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/GenericTileAsLaunchTile/images/ProfileImage_LargeGenTile.png`

            )->shut(
        )->shut(

        )->open( `GenericTile`
            )->a( n = `class`           v = `sapUiTinyMarginBegin sapUiTinyMarginTop`
            )->a( n = `backgroundImage` v = `https://sdk.openui5.org/test-resources/sap/m/images/NewsImage1.png`
            )->a( n = `frameType`       v = `OneByOne`
            )->a( n = `press`           v = client->_event( `PRESS` )

            )->open( `TileContent`
                )->a( n = `footer`    v = `Report Available`
                )->a( n = `frameType` v = `OneByOne`

                )->leaf( `NewsContent`
                    )->a( n = `contentText` v = `Realtime Business Service Analytics`
                    )->a( n = `subheader`   v = `SAP Analytics Cloud`

            )->shut(
        )->shut(

        )->open( `GenericTile`
            )->a( n = `class`           v = `sapUiTinyMarginBegin sapUiTinyMarginTop`
            )->a( n = `backgroundImage` v = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/SlideTile/images/NewsImage1.png`
            )->a( n = `frameType`       v = `TwoByOne`
            )->a( n = `press`           v = client->_event( `PRESS` )

            )->open( `TileContent`
                )->a( n = `footer` v = `August 21, 2016`

                )->leaf( `NewsContent`
                    )->a( n = `contentText` v = `Wind Map: Monitoring Real-Time and Forecasted Wind Conditions across the Globe`
                    )->a( n = `subheader`   v = `Today, SAP News`

            )->shut(
        )->shut(

        )->open( `GenericTile`
            )->a( n = `class`       v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`      v = `Country-Specific Profit Margin`
            )->a( n = `subheader`   v = `Expenses`
            )->a( n = `press`       v = client->_event( `PRESS` )
            )->a( n = `systemInfo`  v = `system info`
            )->a( n = `appShortcut` v = `app shortcut`

            )->open( `TileContent`
                )->a( n = `unit`   v = `EUR`
                )->a( n = `footer` v = `Current Quarter`

                )->leaf( `NumericContent`
                    )->a( n = `scale`      v = `M`
                    )->a( n = `value`      v = `1.96`
                    )->a( n = `valueColor` v = `Error`
                    )->a( n = `indicator`  v = `Up`
                    )->a( n = `withMargin` v = `false`

            )->shut(
        )->shut(

        )->open( `SlideTile`
            )->a( n = `class`          v = `sapUiTinyMarginBegin sapUiTinyMarginTop`
            )->a( n = `transitionTime` v = `250`
            )->a( n = `displayTime`    v = `2500`

            )->open( `GenericTile`
                )->a( n = `backgroundImage` v = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/SlideTile/images/NewsImage1.png`
                )->a( n = `frameType`       v = `TwoByOne`
                )->a( n = `press`           v = client->_event( `PRESS` )

                )->open( `TileContent`
                    )->a( n = `footer` v = `August 21, 2016`

                    )->leaf( `NewsContent`
                        )->a( n = `contentText` v = `Wind Map: Monitoring Real-Time and Forecasted Wind Conditions across the Globe`
                        )->a( n = `subheader`   v = `Today, SAP News`

                )->shut(
            )->shut(

            )->open( `GenericTile`
                )->a( n = `backgroundImage` v = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/SlideTile/images/NewsImage2.png`
                )->a( n = `frameType`       v = `TwoByOne`
                )->a( n = `state`           v = `Failed`

                )->open( `TileContent`
                    )->a( n = `footer` v = `August 21, 2016`

                    )->leaf( `NewsContent`
                        )->a( n = `contentText` v = `SAP Unveils Powerful New Player Comparision Tool Exclusively on NFL.com`
                        )->a( n = `subheader`   v = `Today, SAP News`

                )->shut(
            )->shut(
        )->shut(

        )->open( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Feed Tile that shows updates of the last feeds given to a specific topic:`
            )->a( n = `frameType` v = `TwoByOne`
            )->a( n = `press`     v = client->_event( `PRESS` )

            )->open( `TileContent`
                )->a( n = `footer` v = `New Notifications`

                )->leaf( `FeedContent`
                    )->a( n = `contentText` v = `@@notify Great outcome of the Presentation today. New functionality well received.`
                    )->a( n = `subheader`   v = `About 1 minute ago in Computer Market`
                    )->a( n = `value`       v = `352`

            )->shut(
        )->shut(

        )->open( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Country-Specific Profit Margin`
            )->a( n = `press`     v = client->_event( `PRESS` )
            )->a( n = `frameType` v = `TwoByHalf`

            )->open( `TileContent`
                )->a( n = `unit`   v = `EUR`
                )->a( n = `footer` v = `Current Quarter`

                )->leaf( `NumericContent`
                    )->a( n = `scale`      v = `M`
                    )->a( n = `value`      v = `1.96`
                    )->a( n = `valueColor` v = `Error`
                    )->a( n = `indicator`  v = `Up`
                    )->a( n = `withMargin` v = `false`

            )->shut(
        )->shut(

        )->open( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Cumulative Totals`
            )->a( n = `subheader` v = `Expenses`
            )->a( n = `press`     v = client->_event( `PRESS` )
            )->a( n = `frameType` v = `OneByHalf`

            )->open( `TileContent`
                )->a( n = `unit`   v = `Unit`
                )->a( n = `footer` v = `Footer Text`

                )->leaf( `NumericContent`
                    )->a( n = `value`      v = `1762`
                    )->a( n = `icon`       v = `sap-icon://line-charts`
                    )->a( n = `withMargin` v = `false`

            )->shut(
        )->shut(

        )->open( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Right click to open in new tab`
            )->a( n = `subheader` v = `Link tile`
            )->a( n = `press`     v = client->_event( `PRESS` )
            )->a( n = `url`       v = `https://www.sap.com/`
            )->a( n = `frameType` v = `TwoByHalf`

            )->open( `TileContent`
                )->leaf( `ImageContent`
                    )->a( n = `src` v = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/GenericTileAsLaunchTile/images/SAPLogoLargeTile_28px_height.png`

            )->shut(
        )->shut(

        )->open( `GenericTile`
            )->a( n = `class`  v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header` v = `US Profit Margin`
            )->a( n = `press`  v = client->_event( `PRESS` )

            )->open( `TileContent`
                )->a( n = `unit` v = `Unit`

                )->leaf( `NumericContent`
                    )->a( n = `scale`      v = `%`
                    )->a( n = `value`      v = `12`
                    )->a( n = `valueColor` v = `Critical`
                    )->a( n = `indicator`  v = `Up`
                    )->a( n = `withMargin` v = `false`

            )->shut(
        )->shut(

        )->open( `GenericTile`
            )->a( n = `class`       v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`      v = `Sales Fulfillment Application Title`
            )->a( n = `subheader`   v = `Subtitle`
            )->a( n = `press`       v = client->_event( `PRESS` )
            )->a( n = `systemInfo`  v = `system`
            )->a( n = `appShortcut` v = `shortcut`

            )->open( `TileContent`
                )->a( n = `unit`   v = `EUR`
                )->a( n = `footer` v = `Current Quarter`

                )->leaf( `ImageContent`
                    )->a( n = `src` v = `sap-icon://home-share`

            )->shut(
        )->shut(

        )->open( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Cumulative Totals`
            )->a( n = `subheader` v = `Expenses`
            )->a( n = `press`     v = client->_event( `PRESS` )

            )->open( `TileContent`
                )->a( n = `unit`   v = `Unit`
                )->a( n = `footer` v = `Footer Text`

                )->leaf( `NumericContent`
                    )->a( n = `value`      v = `1762`
                    )->a( n = `icon`       v = `sap-icon://line-charts`
                    )->a( n = `withMargin` v = `false`

            )->shut(
        )->shut(

        )->open( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Right click to open in new tab`
            )->a( n = `subheader` v = `Link tile`
            )->a( n = `press`     v = client->_event( `PRESS` )
            )->a( n = `url`       v = `https://www.sap.com/`
            )->a( n = `frameType` v = `TwoByOne`

            )->open( `TileContent`
                )->leaf( `ImageContent`
                    )->a( n = `src` v = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/GenericTileAsLaunchTile/images/SAPLogoLargeTile_28px_height.png`

            )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `PRESS`.
        client->message_toast_display( `The tile is pressed.` ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
