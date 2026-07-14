"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.m.GenericTile - GenericTileAsKPITile
"! https://sdk.openui5.org/entity/sap.m.GenericTile/sample/sap.m.sample.GenericTileAsKPITile
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

  " NOTES (generation):
  " - 1.71: frameType OneByHalf / TwoByHalf dropped on several tiles - both enum
  "   values were added in UI5 1.83; OneByOne / TwoByOne (1.71) are kept.
  " - 1.71: systemInfo and appShortcut dropped - both added in UI5 1.92.
  " - 1.71: url dropped on the link tiles - added in UI5 1.76.
  " - IMPROVISED: the custom CSS class tileLayout is dropped from the class
  "   attribute - the sample's style.css (float: left) cannot be injected here.
  " - IMPROVISED: the relative test-resources image and backgroundImage paths are
  "   resolved to absolute sdk.openui5.org URLs so the tile images load standalone.

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
        )->attr( n = `xmlns`     v = `sap.m`
        )->attr( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->open( `GenericTile`
            )->attr( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop`
            )->attr( n = `header`    v = `Country-Specific Profit Margin`
            )->attr( n = `subheader` v = `Expenses`
            )->attr( n = `press`     v = client->_event( `PRESS` )

            )->open( `TileContent`
                )->attr( n = `unit`   v = `EUR`
                )->attr( n = `footer` v = `Current Quarter`

                )->leaf( `NumericContent`
                    )->attr( n = `scale`      v = `M`
                    )->attr( n = `value`      v = `1.96`
                    )->attr( n = `valueColor` v = `Error`
                    )->attr( n = `indicator`  v = `Up`
                    )->attr( n = `withMargin` v = `false`

            )->shut(
        )->shut(

        )->open( `GenericTile`
            )->attr( n = `class`  v = `sapUiTinyMarginBegin sapUiTinyMarginTop`
            )->attr( n = `header` v = `US Profit Margin`
            )->attr( n = `press`  v = client->_event( `PRESS` )

            )->open( `TileContent`
                )->attr( n = `unit` v = `Unit`

                )->leaf( `NumericContent`
                    )->attr( n = `scale`      v = `%`
                    )->attr( n = `value`      v = `12`
                    )->attr( n = `valueColor` v = `Critical`
                    )->attr( n = `indicator`  v = `Up`
                    )->attr( n = `withMargin` v = `false`

            )->shut(
        )->shut(

        )->open( `GenericTile`
            )->attr( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop`
            )->attr( n = `header`    v = `Sales Fulfillment Application Title`
            )->attr( n = `subheader` v = `Subtitle`
            )->attr( n = `press`     v = client->_event( `PRESS` )

            )->open( `TileContent`
                )->attr( n = `unit`   v = `EUR`
                )->attr( n = `footer` v = `Current Quarter`

                )->leaf( `ImageContent`
                    )->attr( n = `src` v = `sap-icon://home-share`

            )->shut(
        )->shut(

        )->open( `GenericTile`
            )->attr( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop`
            )->attr( n = `header`    v = `Manage Activity Master Data Type`
            )->attr( n = `subheader` v = `Subtitle`
            )->attr( n = `press`     v = client->_event( `PRESS` )

            )->open( `TileContent`
                )->leaf( `ImageContent`
                    )->attr( n = `src` v = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/GenericTileAsLaunchTile/images/SAPLogoLargeTile_28px_height.png`

            )->shut(
        )->shut(

        )->open( `GenericTile`
            )->attr( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop`
            )->attr( n = `header`    v = `Manage Activity Master Data Type With a Long Title Without an Icon`
            )->attr( n = `subheader` v = `Subtitle Launch Tile`
            )->attr( n = `mode`      v = `HeaderMode`
            )->attr( n = `press`     v = client->_event( `PRESS` )

            )->leaf( `TileContent`
                )->attr( n = `unit`   v = `EUR`
                )->attr( n = `footer` v = `Current Quarter`

        )->shut(

        )->open( `GenericTile`
            )->attr( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop`
            )->attr( n = `header`    v = `Jessica D. Prince Senior Consultant`
            )->attr( n = `subheader` v = `Department`
            )->attr( n = `press`     v = client->_event( `PRESS` )

            )->open( `TileContent`
                )->leaf( `ImageContent`
                    )->attr( n = `src` v = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/GenericTileAsLaunchTile/images/ProfileImage_LargeGenTile.png`

            )->shut(
        )->shut(

        )->open( `GenericTile`
            )->attr( n = `class`           v = `sapUiTinyMarginBegin sapUiTinyMarginTop`
            )->attr( n = `backgroundImage` v = `https://sdk.openui5.org/test-resources/sap/m/images/NewsImage1.png`
            )->attr( n = `frameType`       v = `OneByOne`
            )->attr( n = `press`           v = client->_event( `PRESS` )

            )->open( `TileContent`
                )->attr( n = `footer`    v = `Report Available`
                )->attr( n = `frameType` v = `OneByOne`

                )->leaf( `NewsContent`
                    )->attr( n = `contentText` v = `Realtime Business Service Analytics`
                    )->attr( n = `subheader`   v = `SAP Analytics Cloud`

            )->shut(
        )->shut(

        )->open( `GenericTile`
            )->attr( n = `class`           v = `sapUiTinyMarginBegin sapUiTinyMarginTop`
            )->attr( n = `backgroundImage` v = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/SlideTile/images/NewsImage1.png`
            )->attr( n = `frameType`       v = `TwoByOne`
            )->attr( n = `press`           v = client->_event( `PRESS` )

            )->open( `TileContent`
                )->attr( n = `footer` v = `August 21, 2016`

                )->leaf( `NewsContent`
                    )->attr( n = `contentText` v = `Wind Map: Monitoring Real-Time and Forecasted Wind Conditions across the Globe`
                    )->attr( n = `subheader`   v = `Today, SAP News`

            )->shut(
        )->shut(

        )->open( `GenericTile`
            )->attr( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop`
            )->attr( n = `header`    v = `Country-Specific Profit Margin`
            )->attr( n = `subheader` v = `Expenses`
            )->attr( n = `press`     v = client->_event( `PRESS` )

            )->open( `TileContent`
                )->attr( n = `unit`   v = `EUR`
                )->attr( n = `footer` v = `Current Quarter`

                )->leaf( `NumericContent`
                    )->attr( n = `scale`      v = `M`
                    )->attr( n = `value`      v = `1.96`
                    )->attr( n = `valueColor` v = `Error`
                    )->attr( n = `indicator`  v = `Up`
                    )->attr( n = `withMargin` v = `false`

            )->shut(
        )->shut(

        )->open( `SlideTile`
            )->attr( n = `class`          v = `sapUiTinyMarginBegin sapUiTinyMarginTop`
            )->attr( n = `transitionTime` v = `250`
            )->attr( n = `displayTime`    v = `2500`

            )->open( `GenericTile`
                )->attr( n = `backgroundImage` v = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/SlideTile/images/NewsImage1.png`
                )->attr( n = `frameType`       v = `TwoByOne`
                )->attr( n = `press`           v = client->_event( `PRESS` )

                )->open( `TileContent`
                    )->attr( n = `footer` v = `August 21, 2016`

                    )->leaf( `NewsContent`
                        )->attr( n = `contentText` v = `Wind Map: Monitoring Real-Time and Forecasted Wind Conditions across the Globe`
                        )->attr( n = `subheader`   v = `Today, SAP News`

                )->shut(
            )->shut(

            )->open( `GenericTile`
                )->attr( n = `backgroundImage` v = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/SlideTile/images/NewsImage2.png`
                )->attr( n = `frameType`       v = `TwoByOne`
                )->attr( n = `state`           v = `Failed`

                )->open( `TileContent`
                    )->attr( n = `footer` v = `August 21, 2016`

                    )->leaf( `NewsContent`
                        )->attr( n = `contentText` v = `SAP Unveils Powerful New Player Comparision Tool Exclusively on NFL.com`
                        )->attr( n = `subheader`   v = `Today, SAP News`

                )->shut(
            )->shut(
        )->shut(

        )->open( `GenericTile`
            )->attr( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop`
            )->attr( n = `header`    v = `Feed Tile that shows updates of the last feeds given to a specific topic:`
            )->attr( n = `frameType` v = `TwoByOne`
            )->attr( n = `press`     v = client->_event( `PRESS` )

            )->open( `TileContent`
                )->attr( n = `footer` v = `New Notifications`

                )->leaf( `FeedContent`
                    )->attr( n = `contentText` v = `@@notify Great outcome of the Presentation today. New functionality well received.`
                    )->attr( n = `subheader`   v = `About 1 minute ago in Computer Market`
                    )->attr( n = `value`       v = `352`

            )->shut(
        )->shut(

        )->open( `GenericTile`
            )->attr( n = `class`  v = `sapUiTinyMarginBegin sapUiTinyMarginTop`
            )->attr( n = `header` v = `Country-Specific Profit Margin`
            )->attr( n = `press`  v = client->_event( `PRESS` )

            )->open( `TileContent`
                )->attr( n = `unit`   v = `EUR`
                )->attr( n = `footer` v = `Current Quarter`

                )->leaf( `NumericContent`
                    )->attr( n = `scale`      v = `M`
                    )->attr( n = `value`      v = `1.96`
                    )->attr( n = `valueColor` v = `Error`
                    )->attr( n = `indicator`  v = `Up`
                    )->attr( n = `withMargin` v = `false`

            )->shut(
        )->shut(

        )->open( `GenericTile`
            )->attr( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop`
            )->attr( n = `header`    v = `Cumulative Totals`
            )->attr( n = `subheader` v = `Expenses`
            )->attr( n = `press`     v = client->_event( `PRESS` )

            )->open( `TileContent`
                )->attr( n = `unit`   v = `Unit`
                )->attr( n = `footer` v = `Footer Text`

                )->leaf( `NumericContent`
                    )->attr( n = `value`      v = `1762`
                    )->attr( n = `icon`       v = `sap-icon://line-charts`
                    )->attr( n = `withMargin` v = `false`

            )->shut(
        )->shut(

        )->open( `GenericTile`
            )->attr( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop`
            )->attr( n = `header`    v = `Right click to open in new tab`
            )->attr( n = `subheader` v = `Link tile`
            )->attr( n = `press`     v = client->_event( `PRESS` )

            )->open( `TileContent`
                )->leaf( `ImageContent`
                    )->attr( n = `src` v = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/GenericTileAsLaunchTile/images/SAPLogoLargeTile_28px_height.png`

            )->shut(
        )->shut(

        )->open( `GenericTile`
            )->attr( n = `class`  v = `sapUiTinyMarginBegin sapUiTinyMarginTop`
            )->attr( n = `header` v = `US Profit Margin`
            )->attr( n = `press`  v = client->_event( `PRESS` )

            )->open( `TileContent`
                )->attr( n = `unit` v = `Unit`

                )->leaf( `NumericContent`
                    )->attr( n = `scale`      v = `%`
                    )->attr( n = `value`      v = `12`
                    )->attr( n = `valueColor` v = `Critical`
                    )->attr( n = `indicator`  v = `Up`
                    )->attr( n = `withMargin` v = `false`

            )->shut(
        )->shut(

        )->open( `GenericTile`
            )->attr( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop`
            )->attr( n = `header`    v = `Sales Fulfillment Application Title`
            )->attr( n = `subheader` v = `Subtitle`
            )->attr( n = `press`     v = client->_event( `PRESS` )

            )->open( `TileContent`
                )->attr( n = `unit`   v = `EUR`
                )->attr( n = `footer` v = `Current Quarter`

                )->leaf( `ImageContent`
                    )->attr( n = `src` v = `sap-icon://home-share`

            )->shut(
        )->shut(

        )->open( `GenericTile`
            )->attr( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop`
            )->attr( n = `header`    v = `Cumulative Totals`
            )->attr( n = `subheader` v = `Expenses`
            )->attr( n = `press`     v = client->_event( `PRESS` )

            )->open( `TileContent`
                )->attr( n = `unit`   v = `Unit`
                )->attr( n = `footer` v = `Footer Text`

                )->leaf( `NumericContent`
                    )->attr( n = `value`      v = `1762`
                    )->attr( n = `icon`       v = `sap-icon://line-charts`
                    )->attr( n = `withMargin` v = `false`

            )->shut(
        )->shut(

        )->open( `GenericTile`
            )->attr( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop`
            )->attr( n = `header`    v = `Right click to open in new tab`
            )->attr( n = `subheader` v = `Link tile`
            )->attr( n = `frameType` v = `TwoByOne`
            )->attr( n = `press`     v = client->_event( `PRESS` )

            )->open( `TileContent`
                )->leaf( `ImageContent`
                    )->attr( n = `src` v = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/GenericTileAsLaunchTile/images/SAPLogoLargeTile_28px_height.png`

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
