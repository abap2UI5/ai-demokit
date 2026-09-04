" @keywords generictile generic tile sap.m shows kpi contain html tilecontent numericcontent imagecontent newscontent
" @summary Shows KPI Tile samples that can contain header, subheader, key value, trend, scale, unit, and a footer.
CLASS z2ui5_cl_smpc_app_028 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_028 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    DATA temp2 TYPE string_table.
    DATA temp3 TYPE string_table.
    DATA temp4 TYPE string_table.
    DATA temp5 TYPE string_table.
    DATA temp6 TYPE string_table.
    DATA temp7 TYPE string_table.
    DATA temp8 TYPE string_table.
    DATA temp9 TYPE string_table.
    DATA temp10 TYPE string_table.
    DATA temp11 TYPE string_table.
    DATA temp12 TYPE string_table.
    DATA temp13 TYPE string_table.
    DATA temp14 TYPE string_table.
    DATA temp15 TYPE string_table.
    DATA temp16 TYPE string_table.
    DATA temp17 TYPE string_table.
    DATA temp18 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `MESSAGE_TOAST` INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    INSERT `The tile is pressed.` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `MESSAGE_TOAST` INTO TABLE temp2.
    INSERT `show` INTO TABLE temp2.
    INSERT `The tile is pressed.` INTO TABLE temp2.
    
    CLEAR temp3.
    INSERT `MESSAGE_TOAST` INTO TABLE temp3.
    INSERT `show` INTO TABLE temp3.
    INSERT `The tile is pressed.` INTO TABLE temp3.
    
    CLEAR temp4.
    INSERT `MESSAGE_TOAST` INTO TABLE temp4.
    INSERT `show` INTO TABLE temp4.
    INSERT `The tile is pressed.` INTO TABLE temp4.
    
    CLEAR temp5.
    INSERT `MESSAGE_TOAST` INTO TABLE temp5.
    INSERT `show` INTO TABLE temp5.
    INSERT `The tile is pressed.` INTO TABLE temp5.
    
    CLEAR temp6.
    INSERT `MESSAGE_TOAST` INTO TABLE temp6.
    INSERT `show` INTO TABLE temp6.
    INSERT `The tile is pressed.` INTO TABLE temp6.
    
    CLEAR temp7.
    INSERT `MESSAGE_TOAST` INTO TABLE temp7.
    INSERT `show` INTO TABLE temp7.
    INSERT `The tile is pressed.` INTO TABLE temp7.
    
    CLEAR temp8.
    INSERT `MESSAGE_TOAST` INTO TABLE temp8.
    INSERT `show` INTO TABLE temp8.
    INSERT `The tile is pressed.` INTO TABLE temp8.
    
    CLEAR temp9.
    INSERT `MESSAGE_TOAST` INTO TABLE temp9.
    INSERT `show` INTO TABLE temp9.
    INSERT `The tile is pressed.` INTO TABLE temp9.
    
    CLEAR temp10.
    INSERT `MESSAGE_TOAST` INTO TABLE temp10.
    INSERT `show` INTO TABLE temp10.
    INSERT `The tile is pressed.` INTO TABLE temp10.
    
    CLEAR temp11.
    INSERT `MESSAGE_TOAST` INTO TABLE temp11.
    INSERT `show` INTO TABLE temp11.
    INSERT `The tile is pressed.` INTO TABLE temp11.
    
    CLEAR temp12.
    INSERT `MESSAGE_TOAST` INTO TABLE temp12.
    INSERT `show` INTO TABLE temp12.
    INSERT `The tile is pressed.` INTO TABLE temp12.
    
    CLEAR temp13.
    INSERT `MESSAGE_TOAST` INTO TABLE temp13.
    INSERT `show` INTO TABLE temp13.
    INSERT `The tile is pressed.` INTO TABLE temp13.
    
    CLEAR temp14.
    INSERT `MESSAGE_TOAST` INTO TABLE temp14.
    INSERT `show` INTO TABLE temp14.
    INSERT `The tile is pressed.` INTO TABLE temp14.
    
    CLEAR temp15.
    INSERT `MESSAGE_TOAST` INTO TABLE temp15.
    INSERT `show` INTO TABLE temp15.
    INSERT `The tile is pressed.` INTO TABLE temp15.
    
    CLEAR temp16.
    INSERT `MESSAGE_TOAST` INTO TABLE temp16.
    INSERT `show` INTO TABLE temp16.
    INSERT `The tile is pressed.` INTO TABLE temp16.
    
    CLEAR temp17.
    INSERT `MESSAGE_TOAST` INTO TABLE temp17.
    INSERT `show` INTO TABLE temp17.
    INSERT `The tile is pressed.` INTO TABLE temp17.
    
    CLEAR temp18.
    INSERT `MESSAGE_TOAST` INTO TABLE temp18.
    INSERT `show` INTO TABLE temp18.
    INSERT `The tile is pressed.` INTO TABLE temp18.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        " the sample's style.css, injected via a core:HTML content attribute (see CAPABILITIES.md)
        )->tag( n = `HTML` ns = `core`
            " literal braces escaped \{ \} - the XMLView binding parser reads unescaped braces as a binding
            )->a( n = `content` v = `<style>.tileLayout\{float:left\}</style>`

        )->ele( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Country-Specific Profit Margin`
            )->a( n = `frameType` v = `OneByHalf`
            )->a( n = `subheader` v = `Expenses`
            )->a( n = `press`     v = client->follow_up_action( val   = client->cs_event-control_global
                                                                t_arg = temp1 )

            )->ele( `TileContent`
                )->a( n = `unit`   v = `EUR`
                )->a( n = `footer` v = `Current Quarter`

                )->tag( `NumericContent`
                    )->a( n = `scale`      v = `M`
                    )->a( n = `value`      v = `1.96`
                    )->a( n = `valueColor` v = `Error`
                    )->a( n = `indicator`  v = `Up`
                    )->a( n = `withMargin` v = `false`

            )->end(
        )->end(

        )->ele( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `US Profit Margin`
            )->a( n = `press`     v = client->follow_up_action( val   = client->cs_event-control_global
                                                                t_arg = temp2 )
            )->a( n = `frameType` v = `OneByHalf`

            )->ele( `TileContent`
                )->a( n = `unit` v = `Unit`

                )->tag( `NumericContent`
                    )->a( n = `scale`      v = `%`
                    )->a( n = `value`      v = `12`
                    )->a( n = `valueColor` v = `Critical`
                    )->a( n = `indicator`  v = `Up`
                    )->a( n = `withMargin` v = `false`

            )->end(
        )->end(

        )->ele( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Sales Fulfillment Application Title`
            )->a( n = `subheader` v = `Subtitle`
            )->a( n = `press`     v = client->follow_up_action( val   = client->cs_event-control_global
                                                                t_arg = temp3 )
            )->a( n = `frameType` v = `TwoByHalf`

            )->ele( `TileContent`
                )->a( n = `unit`   v = `EUR`
                )->a( n = `footer` v = `Current Quarter`

                )->tag( `ImageContent`
                    )->a( n = `src` v = `sap-icon://home-share`

            )->end(
        )->end(

        )->ele( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Manage Activity Master Data Type`
            )->a( n = `subheader` v = `Subtitle`
            )->a( n = `press`     v = client->follow_up_action( val   = client->cs_event-control_global
                                                                t_arg = temp4 )
            )->a( n = `frameType` v = `OneByHalf`

            )->ele( `TileContent`
                )->tag( `ImageContent`
                    )->a( n = `src` v = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/GenericTileAsLaunchTile/images/SAPLogoLargeTile_28px_height.png`

            )->end(
        )->end(

        )->ele( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Manage Activity Master Data Type With a Long Title Without an Icon`
            )->a( n = `subheader` v = `Subtitle Launch Tile`
            )->a( n = `mode`      v = `HeaderMode`
            )->a( n = `press`     v = client->follow_up_action( val   = client->cs_event-control_global
                                                                t_arg = temp5 )

            )->tag( `TileContent`
                )->a( n = `unit`   v = `EUR`
                )->a( n = `footer` v = `Current Quarter`

        )->end(

        )->ele( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Jessica D. Prince Senior Consultant`
            )->a( n = `subheader` v = `Department`
            )->a( n = `press`     v = client->follow_up_action( val   = client->cs_event-control_global
                                                                t_arg = temp6 )

            )->ele( `TileContent`
                )->tag( `ImageContent`
                    )->a( n = `src` v = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/GenericTileAsLaunchTile/images/ProfileImage_LargeGenTile.png`

            )->end(
        )->end(

        )->ele( `GenericTile`
            )->a( n = `class`           v = `sapUiTinyMarginBegin sapUiTinyMarginTop`
            )->a( n = `backgroundImage` v = `https://sdk.openui5.org/test-resources/sap/m/images/NewsImage1.png`
            )->a( n = `frameType`       v = `OneByOne`
            )->a( n = `press`           v = client->follow_up_action( val   = client->cs_event-control_global
                                                                      t_arg = temp7 )

            )->ele( `TileContent`
                )->a( n = `footer`    v = `Report Available`
                )->a( n = `frameType` v = `OneByOne`

                )->tag( `NewsContent`
                    )->a( n = `contentText` v = `Realtime Business Service Analytics`
                    )->a( n = `subheader`   v = `SAP Analytics Cloud`

            )->end(
        )->end(

        )->ele( `GenericTile`
            )->a( n = `class`           v = `sapUiTinyMarginBegin sapUiTinyMarginTop`
            )->a( n = `backgroundImage` v = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/SlideTile/images/NewsImage1.png`
            )->a( n = `frameType`       v = `TwoByOne`
            )->a( n = `press`           v = client->follow_up_action( val   = client->cs_event-control_global
                                                                      t_arg = temp8 )

            )->ele( `TileContent`
                )->a( n = `footer` v = `August 21, 2016`

                )->tag( `NewsContent`
                    )->a( n = `contentText` v = `Wind Map: Monitoring Real-Time and Forecasted Wind Conditions across the Globe`
                    )->a( n = `subheader`   v = `Today, SAP News`

            )->end(
        )->end(

        )->ele( `GenericTile`
            )->a( n = `class`       v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`      v = `Country-Specific Profit Margin`
            )->a( n = `subheader`   v = `Expenses`
            )->a( n = `press`       v = client->follow_up_action( val   = client->cs_event-control_global
                                                                  t_arg = temp9 )
            )->a( n = `systemInfo`  v = `system info`
            )->a( n = `appShortcut` v = `app shortcut`

            )->ele( `TileContent`
                )->a( n = `unit`   v = `EUR`
                )->a( n = `footer` v = `Current Quarter`

                )->tag( `NumericContent`
                    )->a( n = `scale`      v = `M`
                    )->a( n = `value`      v = `1.96`
                    )->a( n = `valueColor` v = `Error`
                    )->a( n = `indicator`  v = `Up`
                    )->a( n = `withMargin` v = `false`

            )->end(
        )->end(

        )->ele( `SlideTile`
            )->a( n = `class`          v = `sapUiTinyMarginBegin sapUiTinyMarginTop`
            )->a( n = `transitionTime` v = `250`
            )->a( n = `displayTime`    v = `2500`

            )->ele( `GenericTile`
                )->a( n = `backgroundImage` v = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/SlideTile/images/NewsImage1.png`
                )->a( n = `frameType`       v = `TwoByOne`
                )->a( n = `press`           v = client->follow_up_action( val   = client->cs_event-control_global
                                                                          t_arg = temp10 )

                )->ele( `TileContent`
                    )->a( n = `footer` v = `August 21, 2016`

                    )->tag( `NewsContent`
                        )->a( n = `contentText` v = `Wind Map: Monitoring Real-Time and Forecasted Wind Conditions across the Globe`
                        )->a( n = `subheader`   v = `Today, SAP News`

                )->end(
            )->end(

            )->ele( `GenericTile`
                )->a( n = `backgroundImage` v = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/SlideTile/images/NewsImage2.png`
                )->a( n = `frameType`       v = `TwoByOne`
                )->a( n = `state`           v = `Failed`

                )->ele( `TileContent`
                    )->a( n = `footer` v = `August 21, 2016`

                    )->tag( `NewsContent`
                        )->a( n = `contentText` v = `SAP Unveils Powerful New Player Comparision Tool Exclusively on NFL.com`
                        )->a( n = `subheader`   v = `Today, SAP News`

                )->end(
            )->end(
        )->end(

        )->ele( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Feed Tile that shows updates of the last feeds given to a specific topic:`
            )->a( n = `frameType` v = `TwoByOne`
            )->a( n = `press`     v = client->follow_up_action( val   = client->cs_event-control_global
                                                                t_arg = temp11 )

            )->ele( `TileContent`
                )->a( n = `footer` v = `New Notifications`

                )->tag( `FeedContent`
                    )->a( n = `contentText` v = `@@notify Great outcome of the Presentation today. New functionality well received.`
                    )->a( n = `subheader`   v = `About 1 minute ago in Computer Market`
                    )->a( n = `value`       v = `352`

            )->end(
        )->end(

        )->ele( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Country-Specific Profit Margin`
            )->a( n = `press`     v = client->follow_up_action( val   = client->cs_event-control_global
                                                                t_arg = temp12 )
            )->a( n = `frameType` v = `TwoByHalf`

            )->ele( `TileContent`
                )->a( n = `unit`   v = `EUR`
                )->a( n = `footer` v = `Current Quarter`

                )->tag( `NumericContent`
                    )->a( n = `scale`      v = `M`
                    )->a( n = `value`      v = `1.96`
                    )->a( n = `valueColor` v = `Error`
                    )->a( n = `indicator`  v = `Up`
                    )->a( n = `withMargin` v = `false`

            )->end(
        )->end(

        )->ele( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Cumulative Totals`
            )->a( n = `subheader` v = `Expenses`
            )->a( n = `press`     v = client->follow_up_action( val   = client->cs_event-control_global
                                                                t_arg = temp13 )
            )->a( n = `frameType` v = `OneByHalf`

            )->ele( `TileContent`
                )->a( n = `unit`   v = `Unit`
                )->a( n = `footer` v = `Footer Text`

                )->tag( `NumericContent`
                    )->a( n = `value`      v = `1762`
                    )->a( n = `icon`       v = `sap-icon://line-charts`
                    )->a( n = `withMargin` v = `false`

            )->end(
        )->end(

        )->ele( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Right click to open in new tab`
            )->a( n = `subheader` v = `Link tile`
            )->a( n = `press`     v = client->follow_up_action( val   = client->cs_event-control_global
                                                                t_arg = temp14 )
            )->a( n = `url`       v = `https://www.sap.com/`
            )->a( n = `frameType` v = `TwoByHalf`

            )->ele( `TileContent`
                )->tag( `ImageContent`
                    )->a( n = `src` v = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/GenericTileAsLaunchTile/images/SAPLogoLargeTile_28px_height.png`

            )->end(
        )->end(

        )->ele( `GenericTile`
            )->a( n = `class`  v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header` v = `US Profit Margin`
            )->a( n = `press`  v = client->follow_up_action( val   = client->cs_event-control_global
                                                             t_arg = temp15 )

            )->ele( `TileContent`
                )->a( n = `unit` v = `Unit`

                )->tag( `NumericContent`
                    )->a( n = `scale`      v = `%`
                    )->a( n = `value`      v = `12`
                    )->a( n = `valueColor` v = `Critical`
                    )->a( n = `indicator`  v = `Up`
                    )->a( n = `withMargin` v = `false`

            )->end(
        )->end(

        )->ele( `GenericTile`
            )->a( n = `class`       v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`      v = `Sales Fulfillment Application Title`
            )->a( n = `subheader`   v = `Subtitle`
            )->a( n = `press`       v = client->follow_up_action( val   = client->cs_event-control_global
                                                                  t_arg = temp16 )
            )->a( n = `systemInfo`  v = `system`
            )->a( n = `appShortcut` v = `shortcut`

            )->ele( `TileContent`
                )->a( n = `unit`   v = `EUR`
                )->a( n = `footer` v = `Current Quarter`

                )->tag( `ImageContent`
                    )->a( n = `src` v = `sap-icon://home-share`

            )->end(
        )->end(

        )->ele( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Cumulative Totals`
            )->a( n = `subheader` v = `Expenses`
            )->a( n = `press`     v = client->follow_up_action( val   = client->cs_event-control_global
                                                                t_arg = temp17 )

            )->ele( `TileContent`
                )->a( n = `unit`   v = `Unit`
                )->a( n = `footer` v = `Footer Text`

                )->tag( `NumericContent`
                    )->a( n = `value`      v = `1762`
                    )->a( n = `icon`       v = `sap-icon://line-charts`
                    )->a( n = `withMargin` v = `false`

            )->end(
        )->end(

        )->ele( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Right click to open in new tab`
            )->a( n = `subheader` v = `Link tile`
            )->a( n = `press`     v = client->follow_up_action( val   = client->cs_event-control_global
                                                                t_arg = temp18 )
            )->a( n = `url`       v = `https://www.sap.com/`
            )->a( n = `frameType` v = `TwoByOne`

            )->ele( `TileContent`
                )->tag( `ImageContent`
                    )->a( n = `src` v = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/GenericTileAsLaunchTile/images/SAPLogoLargeTile_28px_height.png`

            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
