" @keywords table sap.ui.table rowmodes named model overflowtoolbar title column label text link segmentedbutton
" @summary Example for the different row modes
CLASS z2ui5_cl_smpc_app_164 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_row,
        name          TYPE string,
        category      TYPE string,
        productpicurl TYPE string,
        quantity      TYPE i,
        deliverydate  TYPE string,
      END OF ty_row.
    DATA productcollection TYPE STANDARD TABLE OF ty_row WITH DEFAULT KEY.

    " The original drives the row mode from a separate 'ui' JSON model
    " ({ui>/rowMode}). abap2UI5 has one default model, so the row mode lives
    " flat here and both the Table.rowMode aggregation and the footer
    " SegmentedButton.selectedKey bind the same field on the default model -
    " one model of truth, thin frontend.
    DATA rowmode TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_164 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " sap.ui.table grid Table (RowModes sample). The original splits UI state
    " into a separate 'ui' JSON model ({ui>/rowMode}); with abap2UI5's single
    " default model that field is folded into the default model and rowMode /
    " selectedKey bind it directly (the 'ui>' prefix is dropped - last path
    " segment identical, which structural-diff matches).
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.ui.table`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:u`   v = `sap.ui.unified`
        )->a( n = `xmlns:c`   v = `sap.ui.core`
        )->a( n = `xmlns:m`   v = `sap.m`
        )->a( n = `height`    v = `100%`

        )->ele( n = `Page` ns = `m`
            )->a( n = `showHeader` v = `false`
            )->a( n = `class`      v = `sapUiContentPadding`

            )->ele( n = `content` ns = `m`
                )->ele( `Table`
                    )->a( n = `id`             v = `table`
                    )->a( n = `selectionMode`  v = `MultiToggle`
                    )->a( n = `rows`           v = client->_bind( productcollection )
                    )->a( n = `rowMode`        v = client->_bind( rowmode )
                    )->a( n = `ariaLabelledBy` v = `title`

                    )->ele( `extension`
                        )->ele( n = `OverflowToolbar` ns = `m`
                            )->a( n = `style` v = `Clear`
                            )->tag( n = `Title` ns = `m`
                                )->a( n = `id`   v = `title`
                                )->a( n = `text` v = `Products`

                        )->end(
                    )->end(

                    )->ele( `columns`
                        )->ele( `Column`
                            )->a( n = `filterProperty` v = `NAME`
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Product Name`
                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{NAME}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(

                        )->ele( `Column`
                            )->a( n = `filterProperty` v = `CATEGORY`
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Category`
                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{CATEGORY}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(

                        )->ele( `Column`
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Image`
                            )->ele( `template`
                                )->tag( n = `Link` ns = `m`
                                    )->a( n = `text`   v = `Show Image`
                                    )->a( n = `href`   v = `{PRODUCTPICURL}`
                                    )->a( n = `target` v = `_blank`

                            )->end(
                        )->end(

                        )->ele( `Column`
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Quantity`
                            )->ele( `template`
                                )->tag( n = `Label` ns = `m`
                                    )->a( n = `text` v = |\{ path: 'QUANTITY', type: 'sap.ui.model.type.Integer' \}|

                            )->end(
                        )->end(

                        )->ele( `Column`
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Delivery Date`
                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = |\{ path: 'DELIVERYDATE', type: 'sap.ui.model.type.Date', formatOptions: \{ source: \{ pattern: 'timestamp' \} \} \}|
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                    )->end(

                    )->ele( `footer`
                        )->ele( n = `OverflowToolbar` ns = `m`
                            )->a( n = `id` v = `infobar`
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text`     v = `Row Mode:`
                                )->a( n = `labelFor` v = `rowMode`
                            )->ele( n = `SegmentedButton` ns = `m`
                                )->a( n = `id`          v = `rowMode`
                                )->a( n = `selectedKey` v = client->_bind( rowmode )
                                )->ele( n = `items` ns = `m`
                                    )->tag( n = `SegmentedButtonItem` ns = `m`
                                        )->a( n = `icon`    v = `sap-icon://locked`
                                        )->a( n = `key`     v = `Fixed`
                                        )->a( n = `tooltip` v = `Fixed`
                                    )->tag( n = `SegmentedButtonItem` ns = `m`
                                        )->a( n = `icon`    v = `sap-icon://restart`
                                        )->a( n = `key`     v = `Auto`
                                        )->a( n = `tooltip` v = `Auto`
                                    )->tag( n = `SegmentedButtonItem` ns = `m`
                                        )->a( n = `icon`    v = `sap-icon://resize-vertical`
                                        )->a( n = `key`     v = `Interactive`
                                        )->a( n = `tooltip` v = `Interactive` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.
    DATA temp1 LIKE productcollection.
    DATA temp2 LIKE LINE OF temp1.

    " initial row mode - the original starts in 'Fixed'
    rowmode = `Fixed`.

    " the original loads the shared 123-row demo ProductCollection
    " (sap/ui/demo/mock/products.json). DeliveryDate in the original is
    " Date.now()-derived (i mod 10 offset); a fixed base (2026-07-23) is used
    " here so the port is deterministic - a client-only display decision.
    
    CLEAR temp1.
    
    temp2-name = `Notebook Basic 15`.
    temp2-category = `Laptops`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg`.
    temp2-quantity = 10.
    temp2-deliverydate = `1784764800000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Basic 17`.
    temp2-category = `Laptops`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1001.jpg`.
    temp2-quantity = 20.
    temp2-deliverydate = `1784419200000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Basic 18`.
    temp2-category = `Laptops`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1002.jpg`.
    temp2-quantity = 10.
    temp2-deliverydate = `1784073600000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Basic 19`.
    temp2-category = `Laptops`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1003.jpg`.
    temp2-quantity = 15.
    temp2-deliverydate = `1783728000000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO Vault`.
    temp2-category = `Accessories`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1007.jpg`.
    temp2-quantity = 15.
    temp2-deliverydate = `1783382400000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Professional 15`.
    temp2-category = `Accessories`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg`.
    temp2-quantity = 16.
    temp2-deliverydate = `1783036800000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Professional 17`.
    temp2-category = `Laptops`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1011.jpg`.
    temp2-quantity = 17.
    temp2-deliverydate = `1782691200000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO Vault Net`.
    temp2-category = `Accessories`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1020.jpg`.
    temp2-quantity = 14.
    temp2-deliverydate = `1782345600000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO Vault SAT`.
    temp2-category = `Accessories`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1021.jpg`.
    temp2-quantity = 50.
    temp2-deliverydate = `1782000000000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Comfort Easy`.
    temp2-category = `Accessories`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1022.jpg`.
    temp2-quantity = 30.
    temp2-deliverydate = `1781654400000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Comfort Senior`.
    temp2-category = `Accessories`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1023.jpg`.
    temp2-quantity = 24.
    temp2-deliverydate = `1784764800000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ergo Screen E-I`.
    temp2-category = `Flat Screen Monitors`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1030.jpg`.
    temp2-quantity = 14.
    temp2-deliverydate = `1784419200000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ergo Screen E-II`.
    temp2-category = `Flat Screen Monitors`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1031.jpg`.
    temp2-quantity = 24.
    temp2-deliverydate = `1784073600000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ergo Screen E-III`.
    temp2-category = `Flat Screen Monitors`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1032.jpg`.
    temp2-quantity = 50.
    temp2-deliverydate = `1783728000000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat Basic`.
    temp2-category = `Flat Screen Monitors`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1035.jpg`.
    temp2-quantity = 23.
    temp2-deliverydate = `1783382400000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat Future`.
    temp2-category = `Flat Screen Monitors`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1036.jpg`.
    temp2-quantity = 22.
    temp2-deliverydate = `1783036800000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat XL`.
    temp2-category = `Flat Screen Monitors`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1037.jpg`.
    temp2-quantity = 23.
    temp2-deliverydate = `1782691200000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Laser Professional Eco`.
    temp2-category = `Printers`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1040.jpg`.
    temp2-quantity = 21.
    temp2-deliverydate = `1782345600000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Laser Basic`.
    temp2-category = `Printers`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1041.jpg`.
    temp2-quantity = 8.
    temp2-deliverydate = `1782000000000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Laser Allround`.
    temp2-category = `Printers`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1042.jpg`.
    temp2-quantity = 9.
    temp2-deliverydate = `1781654400000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ultra Jet Super Color`.
    temp2-category = `Printers`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1050.jpg`.
    temp2-quantity = 17.
    temp2-deliverydate = `1784764800000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ultra Jet Mobile`.
    temp2-category = `Printers`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1051.jpg`.
    temp2-quantity = 18.
    temp2-deliverydate = `1784419200000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ultra Jet Super Highspeed`.
    temp2-category = `Printers`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1052.jpg`.
    temp2-quantity = 25.
    temp2-deliverydate = `1784073600000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Multi Print`.
    temp2-category = `Multifunction Printers`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1055.jpg`.
    temp2-quantity = 16.
    temp2-deliverydate = `1783728000000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Multi Color`.
    temp2-category = `Multifunction Printers`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1056.jpg`.
    temp2-quantity = 5.
    temp2-deliverydate = `1783382400000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Cordless Mouse`.
    temp2-category = `Mice`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1060.jpg`.
    temp2-quantity = 25.
    temp2-deliverydate = `1783036800000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Speed Mouse`.
    temp2-category = `Mice`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1061.jpg`.
    temp2-quantity = 12.
    temp2-deliverydate = `1782691200000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Track Mouse`.
    temp2-category = `Mice`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1062.jpg`.
    temp2-quantity = 12.
    temp2-deliverydate = `1782345600000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ergonomic Keyboard`.
    temp2-category = `Keyboards`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1063.jpg`.
    temp2-quantity = 50.
    temp2-deliverydate = `1782000000000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Internet Keyboard`.
    temp2-category = `Keyboards`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1064.jpg`.
    temp2-quantity = 35.
    temp2-deliverydate = `1781654400000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Media Keyboard`.
    temp2-category = `Keyboards`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1065.jpg`.
    temp2-quantity = 26.
    temp2-deliverydate = `1784764800000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Mousepad`.
    temp2-category = `Mousepads`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1066.jpg`.
    temp2-quantity = 12.
    temp2-deliverydate = `1784419200000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ergo Mousepad`.
    temp2-category = `Mousepads`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1067.jpg`.
    temp2-quantity = 16.
    temp2-deliverydate = `1784073600000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Designer Mousepad`.
    temp2-category = `Mousepads`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1068.jpg`.
    temp2-quantity = 26.
    temp2-deliverydate = `1783728000000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Universal card reader`.
    temp2-category = `Computer System Accessories`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1069.jpg`.
    temp2-quantity = 22.
    temp2-deliverydate = `1783382400000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Proctra X`.
    temp2-category = `Graphic Cards`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1070.jpg`.
    temp2-quantity = 15.
    temp2-deliverydate = `1783036800000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Gladiator MX`.
    temp2-category = `Graphic Cards`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1071.jpg`.
    temp2-quantity = 16.
    temp2-deliverydate = `1782691200000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Hurricane GX`.
    temp2-category = `Graphic Cards`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1072.jpg`.
    temp2-quantity = 13.
    temp2-deliverydate = `1782345600000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Hurricane GX/LN`.
    temp2-category = `Graphic Cards`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1073.jpg`.
    temp2-quantity = 5.
    temp2-deliverydate = `1782000000000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Photo Scan`.
    temp2-category = `Scanners`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1080.jpg`.
    temp2-quantity = 8.
    temp2-deliverydate = `1781654400000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Power Scan`.
    temp2-category = `Scanners`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1081.jpg`.
    temp2-quantity = 11.
    temp2-deliverydate = `1784764800000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Jet Scan Professional`.
    temp2-category = `Scanners`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1082.jpg`.
    temp2-quantity = 13.
    temp2-deliverydate = `1784419200000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Jet Scan Professional`.
    temp2-category = `Scanners`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1083.jpg`.
    temp2-quantity = 10.
    temp2-deliverydate = `1784073600000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Copymaster`.
    temp2-category = `Multifunction Printers`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1085.jpg`.
    temp2-quantity = 10.
    temp2-deliverydate = `1783728000000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Surround Sound`.
    temp2-category = `Speakers`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1090.jpg`.
    temp2-quantity = 20.
    temp2-deliverydate = `1783382400000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Blaster Extreme`.
    temp2-category = `Speakers`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1091.jpg`.
    temp2-quantity = 15.
    temp2-deliverydate = `1783036800000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Sound Booster`.
    temp2-category = `Speakers`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1092.jpg`.
    temp2-quantity = 50.
    temp2-deliverydate = `1782691200000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Lovely Sound 5.1 Wireless`.
    temp2-category = `Accessories`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1095.jpg`.
    temp2-quantity = 12.
    temp2-deliverydate = `1782345600000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Lovely Sound 5.1`.
    temp2-category = `Accessories`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1096.jpg`.
    temp2-quantity = 18.
    temp2-deliverydate = `1782000000000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Lovely Sound Stereo`.
    temp2-category = `Accessories`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1097.jpg`.
    temp2-quantity = 21.
    temp2-deliverydate = `1781654400000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Office`.
    temp2-category = `Software`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1100.jpg`.
    temp2-quantity = 25.
    temp2-deliverydate = `1784764800000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Design`.
    temp2-category = `Software`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1101.jpg`.
    temp2-quantity = 26.
    temp2-deliverydate = `1784419200000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Network`.
    temp2-category = `Software`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1102.jpg`.
    temp2-quantity = 28.
    temp2-deliverydate = `1784073600000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Multimedia`.
    temp2-category = `Software`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1103.jpg`.
    temp2-quantity = 9.
    temp2-deliverydate = `1783728000000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Games`.
    temp2-category = `Software`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1104.jpg`.
    temp2-quantity = 13.
    temp2-deliverydate = `1783382400000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Internet Antivirus`.
    temp2-category = `Software`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1105.jpg`.
    temp2-quantity = 17.
    temp2-deliverydate = `1783036800000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Firewall`.
    temp2-category = `Software`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1106.jpg`.
    temp2-quantity = 19.
    temp2-deliverydate = `1782691200000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Money`.
    temp2-category = `Software`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1107.jpg`.
    temp2-quantity = 18.
    temp2-deliverydate = `1782345600000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `PC Lock`.
    temp2-category = `Computer System Accessories`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1110.jpg`.
    temp2-quantity = 14.
    temp2-deliverydate = `1782000000000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Lock`.
    temp2-category = `Computer System Accessories`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1111.jpg`.
    temp2-quantity = 20.
    temp2-deliverydate = `1781654400000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Web cam reality`.
    temp2-category = `Computer System Accessories`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1112.jpg`.
    temp2-quantity = 27.
    temp2-deliverydate = `1784764800000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Screen clean`.
    temp2-category = `Computer System Accessories`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1113.jpg`.
    temp2-quantity = 17.
    temp2-deliverydate = `1784419200000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Fabric bag professional`.
    temp2-category = `Computer System Accessories`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1114.jpg`.
    temp2-quantity = 14.
    temp2-deliverydate = `1784073600000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Wireless DSL Router`.
    temp2-category = `Telecommunications`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1115.jpg`.
    temp2-quantity = 16.
    temp2-deliverydate = `1783728000000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Wireless DSL Router / Repeater`.
    temp2-category = `Telecommunications`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1116.jpg`.
    temp2-quantity = 12.
    temp2-deliverydate = `1783382400000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Wireless DSL Router / Repeater and Print Server`.
    temp2-category = `Telecommunications`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1117.jpg`.
    temp2-quantity = 12.
    temp2-deliverydate = `1783036800000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `USB Stick`.
    temp2-category = `Computer System Accessories`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1118.jpg`.
    temp2-quantity = 14.
    temp2-deliverydate = `1782691200000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Travel Adapter`.
    temp2-category = `Accessories`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1119.jpg`.
    temp2-quantity = 10.
    temp2-deliverydate = `1782345600000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Cordless Bluetooth Keyboard, english international`.
    temp2-category = `Keyboards`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1120.jpg`.
    temp2-quantity = 13.
    temp2-deliverydate = `1782000000000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat XXL`.
    temp2-category = `Flat Screen Monitors`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1137.jpg`.
    temp2-quantity = 10.
    temp2-deliverydate = `1781654400000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Pocket Mouse`.
    temp2-category = `Mice`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1138.jpg`.
    temp2-quantity = 20.
    temp2-deliverydate = `1784764800000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `PC Power Station`.
    temp2-category = `PCs`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1210.jpg`.
    temp2-quantity = 22.
    temp2-deliverydate = `1784419200000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Astro Laptop 1516`.
    temp2-category = `Laptops`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1251.jpg`.
    temp2-quantity = 23.
    temp2-deliverydate = `1784073600000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Astro Phone 6`.
    temp2-category = `Smartphones and Tablets`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1252.jpg`.
    temp2-quantity = 28.
    temp2-deliverydate = `1783728000000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Benda Laptop 1408`.
    temp2-category = `Laptops`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1253.jpg`.
    temp2-quantity = 27.
    temp2-deliverydate = `1783382400000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Bending Screen 21HD`.
    temp2-category = `Flat Screens`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1254.jpg`.
    temp2-quantity = 23.
    temp2-deliverydate = `1783036800000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Broad Screen 22HD`.
    temp2-category = `Flat Screens`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1255.jpg`.
    temp2-quantity = 5.
    temp2-deliverydate = `1782691200000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Cerdik Phone 7`.
    temp2-category = `Smartphones and Tablets`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1256.jpg`.
    temp2-quantity = 19.
    temp2-deliverydate = `1782345600000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Cepat Tablet 10.5`.
    temp2-category = `Smartphones and Tablets`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1257.jpg`.
    temp2-quantity = 17.
    temp2-deliverydate = `1782000000000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Cepat Tablet 8`.
    temp2-category = `Smartphones and Tablets`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1258.jpg`.
    temp2-quantity = 24.
    temp2-deliverydate = `1781654400000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Server Basic`.
    temp2-category = `Servers`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1500.jpg`.
    temp2-quantity = 24.
    temp2-deliverydate = `1784764800000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Server Professional`.
    temp2-category = `Servers`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1501.jpg`.
    temp2-quantity = 26.
    temp2-deliverydate = `1784419200000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Server Power Pro`.
    temp2-category = `Servers`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1502.jpg`.
    temp2-quantity = 34.
    temp2-deliverydate = `1784073600000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Family PC Basic`.
    temp2-category = `Desktop Computers`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1600.jpg`.
    temp2-quantity = 10.
    temp2-deliverydate = `1783728000000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Family PC Pro`.
    temp2-category = `Desktop Computers`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1601.jpg`.
    temp2-quantity = 20.
    temp2-deliverydate = `1783382400000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Gaming Monster`.
    temp2-category = `Desktop Computers`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1602.jpg`.
    temp2-quantity = 24.
    temp2-deliverydate = `1783036800000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Gaming Monster Pro`.
    temp2-category = `Desktop Computers`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1603.jpg`.
    temp2-quantity = 25.
    temp2-deliverydate = `1782691200000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `7" Widescreen Portable DVD Player w MP3`.
    temp2-category = `Accessories`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2000.jpg`.
    temp2-quantity = 20.
    temp2-deliverydate = `1782345600000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `10" Portable DVD player`.
    temp2-category = `Accessories`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2001.jpg`.
    temp2-quantity = 21.
    temp2-deliverydate = `1782000000000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Portable DVD Player with 9" LCD Monitor`.
    temp2-category = `Accessories`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2002.jpg`.
    temp2-quantity = 50.
    temp2-deliverydate = `1781654400000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `CD/DVD case: 264 sleeves`.
    temp2-category = `Accessories`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2025.jpg`.
    temp2-quantity = 26.
    temp2-deliverydate = `1784764800000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Audio/Video Cable Kit - 4m`.
    temp2-category = `Accessories`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2026.jpg`.
    temp2-quantity = 16.
    temp2-deliverydate = `1784419200000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Removable CD/DVD Laser Labels`.
    temp2-category = `Accessories`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2027.jpg`.
    temp2-quantity = 25.
    temp2-deliverydate = `1784073600000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Beam Breaker B-1`.
    temp2-category = `Accessories`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6100.jpg`.
    temp2-quantity = 32.
    temp2-deliverydate = `1783728000000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Beam Breaker B-2`.
    temp2-category = `Accessories`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6101.jpg`.
    temp2-quantity = 18.
    temp2-deliverydate = `1783382400000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Beam Breaker B-3`.
    temp2-category = `Accessories`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6102.jpg`.
    temp2-quantity = 16.
    temp2-deliverydate = `1783036800000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Play Movie`.
    temp2-category = `Accessories`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6110.jpg`.
    temp2-quantity = 15.
    temp2-deliverydate = `1782691200000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Record Movie`.
    temp2-category = `Accessories`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6111.jpg`.
    temp2-quantity = 24.
    temp2-deliverydate = `1782345600000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelo MusicStick`.
    temp2-category = `Accessories`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6120.jpg`.
    temp2-quantity = 15.
    temp2-deliverydate = `1782000000000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelo Jog-Mate`.
    temp2-category = `Accessories`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6121.jpg`.
    temp2-quantity = 24.
    temp2-deliverydate = `1781654400000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Power Pro Player 40`.
    temp2-category = `Accessories`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6122.jpg`.
    temp2-quantity = 23.
    temp2-deliverydate = `1784764800000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Power Pro Player 80`.
    temp2-category = `Accessories`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6123.jpg`.
    temp2-quantity = 13.
    temp2-deliverydate = `1784419200000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat Watch HD32`.
    temp2-category = `Flat Screen TVs`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6130.jpg`.
    temp2-quantity = 16.
    temp2-deliverydate = `1784073600000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat Watch HD37`.
    temp2-category = `Flat Screen TVs`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6131.jpg`.
    temp2-quantity = 14.
    temp2-deliverydate = `1783728000000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat Watch HD41`.
    temp2-category = `Flat Screen TVs`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6132.jpg`.
    temp2-quantity = 13.
    temp2-deliverydate = `1783382400000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Copperberry`.
    temp2-category = `Accessories`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7000.jpg`.
    temp2-quantity = 5.
    temp2-deliverydate = `1783036800000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Silverberry`.
    temp2-category = `Accessories`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7010.jpg`.
    temp2-quantity = 9.
    temp2-deliverydate = `1782691200000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Goldberry`.
    temp2-category = `Accessories`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7020.jpg`.
    temp2-quantity = 11.
    temp2-deliverydate = `1782345600000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Platinberry`.
    temp2-category = `Accessories`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7030.jpg`.
    temp2-quantity = 12.
    temp2-deliverydate = `1782000000000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO FlexTop I4000`.
    temp2-category = `Laptops`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8000.jpg`.
    temp2-quantity = 11.
    temp2-deliverydate = `1781654400000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO FlexTop I6300c`.
    temp2-category = `Laptops`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8001.jpg`.
    temp2-quantity = 20.
    temp2-deliverydate = `1784764800000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO FlexTop I9100`.
    temp2-category = `Laptops`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8002.jpg`.
    temp2-quantity = 20.
    temp2-deliverydate = `1784419200000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO FlexTop I9800`.
    temp2-category = `Laptops`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8003.jpg`.
    temp2-quantity = 22.
    temp2-deliverydate = `1784073600000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smartphone Leather Case`.
    temp2-category = `Accessories`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9991.jpg`.
    temp2-quantity = 12.
    temp2-deliverydate = `1783728000000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smartphone Alpha`.
    temp2-category = `Smartphones and Tablets`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9992.jpg`.
    temp2-quantity = 13.
    temp2-deliverydate = `1783382400000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Mini Tablet`.
    temp2-category = `Smartphones and Tablets`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9993.jpg`.
    temp2-quantity = 10.
    temp2-deliverydate = `1783036800000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Camcorder View`.
    temp2-category = `Accessories`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9994.jpg`.
    temp2-quantity = 50.
    temp2-deliverydate = `1782691200000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Tablet Pouch`.
    temp2-category = `Accessories`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9995.jpg`.
    temp2-quantity = 34.
    temp2-deliverydate = `1782345600000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Tablet Pouch`.
    temp2-category = `Accessories`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9996.jpg`.
    temp2-quantity = 34.
    temp2-deliverydate = `1782000000000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `e-Book Reader ReadMe`.
    temp2-category = `Smartphones and Tablets`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9997.jpg`.
    temp2-quantity = 23.
    temp2-deliverydate = `1781654400000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smartphone Beta`.
    temp2-category = `Smartphones and Tablets`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9998.jpg`.
    temp2-quantity = 21.
    temp2-deliverydate = `1784764800000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Maxi Tablet`.
    temp2-category = `Tablets`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9999.jpg`.
    temp2-quantity = 20.
    temp2-deliverydate = `1784419200000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flyer`.
    temp2-category = `Accessories`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/PF-1000.jpg`.
    temp2-quantity = 33.
    temp2-deliverydate = `1784073600000`.
    INSERT temp2 INTO TABLE temp1.
    productcollection = temp1.

  ENDMETHOD.

ENDCLASS.
