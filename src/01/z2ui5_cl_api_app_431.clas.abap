"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.m.GenericTile - GenericTileAsKPITile
"! https://sdk.openui5.org/entity/sap.m.GenericTile/sample/sap.m.sample.GenericTileAsKPITile
"! NOTES (generation):
"! - 1.71: frameType OneByHalf / TwoByHalf dropped on several tiles - both enum
"!   values were added in UI5 1.83; OneByOne / TwoByOne (1.71) are kept.
"! - 1.71: systemInfo and appShortcut dropped - both added in UI5 1.92.
"! - 1.71: url dropped on the link tiles - added in UI5 1.76.
"! - IMPROVISED: the custom CSS class tileLayout is dropped from the class
"!   attribute - the sample's style.css (float: left) cannot be injected here.
"! - IMPROVISED: the relative test-resources image and backgroundImage paths are
"!   resolved to absolute sdk.openui5.org URLs so the tile images load standalone.
CLASS z2ui5_cl_api_app_431 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_431 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    " see the NOTES block above for the tileLayout, frameType, systemInfo,
    " appShortcut, url and image-path deviations applied throughout this view
    DATA(view) = z2ui5_cl_api_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->open( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop`
            )->a( n = `header`    v = `Country-Specific Profit Margin`
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
            )->a( n = `class`  v = `sapUiTinyMarginBegin sapUiTinyMarginTop`
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
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop`
            )->a( n = `header`    v = `Sales Fulfillment Application Title`
            )->a( n = `subheader` v = `Subtitle`
            )->a( n = `press`     v = client->_event( `PRESS` )

            )->open( `TileContent`
                )->a( n = `unit`   v = `EUR`
                )->a( n = `footer` v = `Current Quarter`

                )->leaf( `ImageContent`
                    )->a( n = `src` v = `sap-icon://home-share`

            )->shut(
        )->shut(

        )->open( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop`
            )->a( n = `header`    v = `Manage Activity Master Data Type`
            )->a( n = `subheader` v = `Subtitle`
            )->a( n = `press`     v = client->_event( `PRESS` )

            )->open( `TileContent`
                )->leaf( `ImageContent`
                    )->a( n = `src` v = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/GenericTileAsLaunchTile/images/SAPLogoLargeTile_28px_height.png`

            )->shut(
        )->shut(

        )->open( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop`
            )->a( n = `header`    v = `Manage Activity Master Data Type With a Long Title Without an Icon`
            )->a( n = `subheader` v = `Subtitle Launch Tile`
            )->a( n = `mode`      v = `HeaderMode`
            )->a( n = `press`     v = client->_event( `PRESS` )

            )->leaf( `TileContent`
                )->a( n = `unit`   v = `EUR`
                )->a( n = `footer` v = `Current Quarter`

        )->shut(

        )->open( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop`
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
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop`
            )->a( n = `header`    v = `Country-Specific Profit Margin`
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
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop`
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
            )->a( n = `class`  v = `sapUiTinyMarginBegin sapUiTinyMarginTop`
            )->a( n = `header` v = `Country-Specific Profit Margin`
            )->a( n = `press`  v = client->_event( `PRESS` )

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
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop`
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
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop`
            )->a( n = `header`    v = `Right click to open in new tab`
            )->a( n = `subheader` v = `Link tile`
            )->a( n = `press`     v = client->_event( `PRESS` )

            )->open( `TileContent`
                )->leaf( `ImageContent`
                    )->a( n = `src` v = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/GenericTileAsLaunchTile/images/SAPLogoLargeTile_28px_height.png`

            )->shut(
        )->shut(

        )->open( `GenericTile`
            )->a( n = `class`  v = `sapUiTinyMarginBegin sapUiTinyMarginTop`
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
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop`
            )->a( n = `header`    v = `Sales Fulfillment Application Title`
            )->a( n = `subheader` v = `Subtitle`
            )->a( n = `press`     v = client->_event( `PRESS` )

            )->open( `TileContent`
                )->a( n = `unit`   v = `EUR`
                )->a( n = `footer` v = `Current Quarter`

                )->leaf( `ImageContent`
                    )->a( n = `src` v = `sap-icon://home-share`

            )->shut(
        )->shut(

        )->open( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop`
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
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop`
            )->a( n = `header`    v = `Right click to open in new tab`
            )->a( n = `subheader` v = `Link tile`
            )->a( n = `frameType` v = `TwoByOne`
            )->a( n = `press`     v = client->_event( `PRESS` )

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
