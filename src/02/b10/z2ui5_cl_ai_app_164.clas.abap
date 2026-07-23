CLASS z2ui5_cl_ai_app_164 DEFINITION PUBLIC.

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
    DATA productcollection TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.

    " Named-model field: the original drives the row mode from a separate 'ui'
    " JSON model ({ui>/rowMode}); here it lives flat in the one default model
    " and the frontend aliases that model under 'ui' (view1_js), so both the
    " Table.rowMode aggregation and the SegmentedButton.selectedKey resolve to
    " the same field - one model of truth, thin frontend.
    DATA rowmode TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_164 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " sap.ui.table grid Table (RowModes sample). Wall-break for NAMED MODELS:
    " rowMode and the footer SegmentedButton both bind {ui>/rowMode}. The 'ui'
    " model is aliased onto the default model by the frontend, so the faithful
    " {ui>/...} paths resolve against the flat 'rowmode' field. The named path
    " is derived via _bind (raw path) so it survives a rename.
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.ui.table`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:u`   v = `sap.ui.unified`
        )->a( n = `xmlns:c`   v = `sap.ui.core`
        )->a( n = `xmlns:m`   v = `sap.m`
        )->a( n = `height`    v = `100%`

        )->open( n = `Page` ns = `m`
            )->a( n = `showHeader` v = `false`
            )->a( n = `class`      v = `sapUiContentPadding`

            )->open( n = `content` ns = `m`
                )->open( `Table`
                    )->a( n = `id`             v = `table`
                    )->a( n = `selectionMode`  v = `MultiToggle`
                    )->a( n = `rows`           v = client->_bind( productcollection )
                    )->a( n = `rowMode`        v = |\{ui>{ client->_bind( val = rowmode path = abap_true ) }\}|
                    )->a( n = `ariaLabelledBy` v = `title`

                    )->open( `extension`
                        )->open( n = `OverflowToolbar` ns = `m`
                            )->a( n = `style` v = `Clear`
                            )->leaf( n = `Title` ns = `m`
                                )->a( n = `id`   v = `title`
                                )->a( n = `text` v = `Products`

                    )->shut(
                    )->shut(

                    )->open( `columns`
                        )->open( `Column`
                            )->a( n = `filterProperty` v = `Name`
                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text` v = `Product Name`
                            )->open( `template`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{NAME}`
                                    )->a( n = `wrapping` v = `false`

                        )->shut(
                        )->shut(

                        )->open( `Column`
                            )->a( n = `filterProperty` v = `Category`
                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text` v = `Category`
                            )->open( `template`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{CATEGORY}`
                                    )->a( n = `wrapping` v = `false`

                        )->shut(
                        )->shut(

                        )->open( `Column`
                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text` v = `Image`
                            )->open( `template`
                                )->leaf( n = `Link` ns = `m`
                                    )->a( n = `text`   v = `Show Image`
                                    )->a( n = `href`   v = `{PRODUCTPICURL}`
                                    )->a( n = `target` v = `_blank`

                        )->shut(
                        )->shut(

                        )->open( `Column`
                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text` v = `Quantity`
                            )->open( `template`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = |\{ path: 'QUANTITY', type: 'sap.ui.model.type.Integer' \}|

                        )->shut(
                        )->shut(

                        )->open( `Column`
                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text` v = `Delivery Date`
                            )->open( `template`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text`     v = |\{ path: 'DELIVERYDATE', type: 'sap.ui.model.type.Date', formatOptions: \{ source: \{ pattern: 'timestamp' \} \} \}|
                                    )->a( n = `wrapping` v = `false`

                        )->shut(
                        )->shut(
                    )->shut(

                    )->open( `footer`
                        )->open( n = `OverflowToolbar` ns = `m`
                            )->a( n = `id` v = `infobar`
                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text`     v = `Row Mode:`
                                )->a( n = `labelFor` v = `rowMode`
                            )->open( n = `SegmentedButton` ns = `m`
                                )->a( n = `id`          v = `rowMode`
                                )->a( n = `selectedKey` v = |\{ui>{ client->_bind( val = rowmode path = abap_true ) }\}|
                                )->open( n = `items` ns = `m`
                                    )->leaf( n = `SegmentedButtonItem` ns = `m`
                                        )->a( n = `icon`    v = `sap-icon://locked`
                                        )->a( n = `key`     v = `Fixed`
                                        )->a( n = `tooltip` v = `Fixed`
                                    )->leaf( n = `SegmentedButtonItem` ns = `m`
                                        )->a( n = `icon`    v = `sap-icon://restart`
                                        )->a( n = `key`     v = `Auto`
                                        )->a( n = `tooltip` v = `Auto`
                                    )->leaf( n = `SegmentedButtonItem` ns = `m`
                                        )->a( n = `icon`    v = `sap-icon://resize-vertical`
                                        )->a( n = `key`     v = `Interactive`
                                        )->a( n = `tooltip` v = `Interactive` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " initial row mode - the original starts in 'Fixed'
    rowmode = `Fixed`.

    " the original loads the shared 123-row demo ProductCollection
    " (sap/ui/demo/mock/products.json). DeliveryDate in the original is
    " Date.now()-derived (i mod 10 offset); a fixed base (2026-07-23) is used
    " here so the port is deterministic - a client-only display decision.
    productcollection = VALUE #(
      ( name = `Notebook Basic 15` category = `Laptops` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg` quantity = 10 deliverydate = `1784764800000` )
      ( name = `Notebook Basic 17` category = `Laptops` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1001.jpg` quantity = 20 deliverydate = `1784419200000` )
      ( name = `Notebook Basic 18` category = `Laptops` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1002.jpg` quantity = 10 deliverydate = `1784073600000` )
      ( name = `Notebook Basic 19` category = `Laptops` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1003.jpg` quantity = 15 deliverydate = `1783728000000` )
      ( name = `ITelO Vault` category = `Accessories` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1007.jpg` quantity = 15 deliverydate = `1783382400000` )
      ( name = `Notebook Professional 15` category = `Accessories` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg` quantity = 16 deliverydate = `1783036800000` )
      ( name = `Notebook Professional 17` category = `Laptops` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1011.jpg` quantity = 17 deliverydate = `1782691200000` )
      ( name = `ITelO Vault Net` category = `Accessories` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1020.jpg` quantity = 14 deliverydate = `1782345600000` )
      ( name = `ITelO Vault SAT` category = `Accessories` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1021.jpg` quantity = 50 deliverydate = `1782000000000` )
      ( name = `Comfort Easy` category = `Accessories` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1022.jpg` quantity = 30 deliverydate = `1781654400000` )
      ( name = `Comfort Senior` category = `Accessories` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1023.jpg` quantity = 24 deliverydate = `1784764800000` )
      ( name = `Ergo Screen E-I` category = `Flat Screen Monitors` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1030.jpg` quantity = 14 deliverydate = `1784419200000` )
      ( name = `Ergo Screen E-II` category = `Flat Screen Monitors` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1031.jpg` quantity = 24 deliverydate = `1784073600000` )
      ( name = `Ergo Screen E-III` category = `Flat Screen Monitors` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1032.jpg` quantity = 50 deliverydate = `1783728000000` )
      ( name = `Flat Basic` category = `Flat Screen Monitors` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1035.jpg` quantity = 23 deliverydate = `1783382400000` )
      ( name = `Flat Future` category = `Flat Screen Monitors` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1036.jpg` quantity = 22 deliverydate = `1783036800000` )
      ( name = `Flat XL` category = `Flat Screen Monitors` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1037.jpg` quantity = 23 deliverydate = `1782691200000` )
      ( name = `Laser Professional Eco` category = `Printers` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1040.jpg` quantity = 21 deliverydate = `1782345600000` )
      ( name = `Laser Basic` category = `Printers` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1041.jpg` quantity = 8 deliverydate = `1782000000000` )
      ( name = `Laser Allround` category = `Printers` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1042.jpg` quantity = 9 deliverydate = `1781654400000` )
      ( name = `Ultra Jet Super Color` category = `Printers` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1050.jpg` quantity = 17 deliverydate = `1784764800000` )
      ( name = `Ultra Jet Mobile` category = `Printers` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1051.jpg` quantity = 18 deliverydate = `1784419200000` )
      ( name = `Ultra Jet Super Highspeed` category = `Printers` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1052.jpg` quantity = 25 deliverydate = `1784073600000` )
      ( name = `Multi Print` category = `Multifunction Printers` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1055.jpg` quantity = 16 deliverydate = `1783728000000` )
      ( name = `Multi Color` category = `Multifunction Printers` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1056.jpg` quantity = 5 deliverydate = `1783382400000` )
      ( name = `Cordless Mouse` category = `Mice` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1060.jpg` quantity = 25 deliverydate = `1783036800000` )
      ( name = `Speed Mouse` category = `Mice` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1061.jpg` quantity = 12 deliverydate = `1782691200000` )
      ( name = `Track Mouse` category = `Mice` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1062.jpg` quantity = 12 deliverydate = `1782345600000` )
      ( name = `Ergonomic Keyboard` category = `Keyboards` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1063.jpg` quantity = 50 deliverydate = `1782000000000` )
      ( name = `Internet Keyboard` category = `Keyboards` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1064.jpg` quantity = 35 deliverydate = `1781654400000` )
      ( name = `Media Keyboard` category = `Keyboards` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1065.jpg` quantity = 26 deliverydate = `1784764800000` )
      ( name = `Mousepad` category = `Mousepads` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1066.jpg` quantity = 12 deliverydate = `1784419200000` )
      ( name = `Ergo Mousepad` category = `Mousepads` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1067.jpg` quantity = 16 deliverydate = `1784073600000` )
      ( name = `Designer Mousepad` category = `Mousepads` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1068.jpg` quantity = 26 deliverydate = `1783728000000` )
      ( name = `Universal card reader` category = `Computer System Accessories` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1069.jpg` quantity = 22 deliverydate = `1783382400000` )
      ( name = `Proctra X` category = `Graphic Cards` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1070.jpg` quantity = 15 deliverydate = `1783036800000` )
      ( name = `Gladiator MX` category = `Graphic Cards` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1071.jpg` quantity = 16 deliverydate = `1782691200000` )
      ( name = `Hurricane GX` category = `Graphic Cards` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1072.jpg` quantity = 13 deliverydate = `1782345600000` )
      ( name = `Hurricane GX/LN` category = `Graphic Cards` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1073.jpg` quantity = 5 deliverydate = `1782000000000` )
      ( name = `Photo Scan` category = `Scanners` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1080.jpg` quantity = 8 deliverydate = `1781654400000` )
      ( name = `Power Scan` category = `Scanners` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1081.jpg` quantity = 11 deliverydate = `1784764800000` )
      ( name = `Jet Scan Professional` category = `Scanners` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1082.jpg` quantity = 13 deliverydate = `1784419200000` )
      ( name = `Jet Scan Professional` category = `Scanners` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1083.jpg` quantity = 10 deliverydate = `1784073600000` )
      ( name = `Copymaster` category = `Multifunction Printers` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1085.jpg` quantity = 10 deliverydate = `1783728000000` )
      ( name = `Surround Sound` category = `Speakers` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1090.jpg` quantity = 20 deliverydate = `1783382400000` )
      ( name = `Blaster Extreme` category = `Speakers` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1091.jpg` quantity = 15 deliverydate = `1783036800000` )
      ( name = `Sound Booster` category = `Speakers` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1092.jpg` quantity = 50 deliverydate = `1782691200000` )
      ( name = `Smart Office` category = `Software` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1100.jpg` quantity = 25 deliverydate = `1782345600000` )
      ( name = `Smart Design` category = `Software` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1101.jpg` quantity = 26 deliverydate = `1782000000000` )
      ( name = `Smart Network` category = `Software` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1102.jpg` quantity = 28 deliverydate = `1781654400000` )
      ( name = `Smart Multimedia` category = `Software` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1103.jpg` quantity = 9 deliverydate = `1784764800000` )
      ( name = `Smart Games` category = `Software` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1104.jpg` quantity = 13 deliverydate = `1784419200000` )
      ( name = `Smart Internet Antivirus` category = `Software` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1105.jpg` quantity = 17 deliverydate = `1784073600000` )
      ( name = `Smart Firewall` category = `Software` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1106.jpg` quantity = 19 deliverydate = `1783728000000` )
      ( name = `Smart Money` category = `Software` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1107.jpg` quantity = 18 deliverydate = `1783382400000` )
      ( name = `PC Lock` category = `Computer System Accessories` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1110.jpg` quantity = 14 deliverydate = `1783036800000` )
      ( name = `Notebook Lock` category = `Computer System Accessories` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1111.jpg` quantity = 20 deliverydate = `1782691200000` )
      ( name = `Web cam reality` category = `Computer System Accessories` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1112.jpg` quantity = 27 deliverydate = `1782345600000` )
      ( name = `Screen clean` category = `Computer System Accessories` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1113.jpg` quantity = 17 deliverydate = `1782000000000` )
      ( name = `Fabric bag professional` category = `Computer System Accessories` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1114.jpg` quantity = 14 deliverydate = `1781654400000` )
      ( name = `Wireless DSL Router` category = `Telecommunications` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1115.jpg` quantity = 16 deliverydate = `1784764800000` )
      ( name = `Wireless DSL Router / Repeater` category = `Telecommunications` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1116.jpg` quantity = 12 deliverydate = `1784419200000` )
      ( name = `Wireless DSL Router / Repeater and Print Server` category = `Telecommunications` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1117.jpg` quantity = 12 deliverydate = `1784073600000` )
      ( name = `USB Stick` category = `Computer System Accessories` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1118.jpg` quantity = 14 deliverydate = `1783728000000` )
      ( name = `Cordless Bluetooth Keyboard, english international` category = `Keyboards` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1120.jpg` quantity = 13 deliverydate = `1783382400000` )
      ( name = `Flat XXL` category = `Flat Screen Monitors` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1137.jpg` quantity = 10 deliverydate = `1783036800000` )
      ( name = `Pocket Mouse` category = `Mice` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1138.jpg` quantity = 20 deliverydate = `1782691200000` )
      ( name = `PC Power Station` category = `PCs` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1210.jpg` quantity = 22 deliverydate = `1782345600000` )
      ( name = `Server Basic` category = `Servers` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1500.jpg` quantity = 24 deliverydate = `1782000000000` )
      ( name = `Server Professional` category = `Servers` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1501.jpg` quantity = 26 deliverydate = `1781654400000` )
      ( name = `Server Power Pro` category = `Servers` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1502.jpg` quantity = 34 deliverydate = `1784764800000` )
      ( name = `Flat Watch HD32` category = `Flat Screen TVs` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-6130.jpg` quantity = 16 deliverydate = `1784419200000` )
      ( name = `Flat Watch HD37` category = `Flat Screen TVs` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-6131.jpg` quantity = 14 deliverydate = `1784073600000` )
      ( name = `Flat Watch HD41` category = `Flat Screen TVs` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-6132.jpg` quantity = 13 deliverydate = `1783728000000` )
      ( name = `Platinberry` category = `Accessories` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-7030.jpg` quantity = 12 deliverydate = `1783382400000` )
      ( name = `Goldberry` category = `Accessories` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-7020.jpg` quantity = 11 deliverydate = `1783036800000` )
      ( name = `Silverberry` category = `Accessories` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-7010.jpg` quantity = 9 deliverydate = `1782691200000` )
      ( name = `Copperberry` category = `Accessories` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-7000.jpg` quantity = 5 deliverydate = `1782345600000` )
      ( name = `Lovely Sound 5.1 Wireless` category = `Accessories` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1095.jpg` quantity = 12 deliverydate = `1782000000000` )
      ( name = `Lovely Sound 5.1` category = `Accessories` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1096.jpg` quantity = 18 deliverydate = `1781654400000` )
      ( name = `Lovely Sound Stereo` category = `Accessories` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1097.jpg` quantity = 21 deliverydate = `1784764800000` )
      ( name = `Power Pro Player 80` category = `Accessories` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-6123.jpg` quantity = 13 deliverydate = `1784419200000` )
      ( name = `Power Pro Player 40` category = `Accessories` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-6122.jpg` quantity = 23 deliverydate = `1784073600000` )
      ( name = `ITelo Jog-Mate` category = `Accessories` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-6121.jpg` quantity = 24 deliverydate = `1783728000000` )
      ( name = `ITelo MusicStick` category = `Accessories` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-6120.jpg` quantity = 15 deliverydate = `1783382400000` )
      ( name = `Record Movie` category = `Accessories` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-6111.jpg` quantity = 24 deliverydate = `1783036800000` )
      ( name = `Play Movie` category = `Accessories` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-6110.jpg` quantity = 15 deliverydate = `1782691200000` )
      ( name = `Beam Breaker B-3` category = `Accessories` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-6102.jpg` quantity = 16 deliverydate = `1782345600000` )
      ( name = `Beam Breaker B-2` category = `Accessories` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-6101.jpg` quantity = 18 deliverydate = `1782000000000` )
      ( name = `Portable DVD Player with 9" LCD Monitor` category = `Accessories` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-2002.jpg` quantity = 50 deliverydate = `1781654400000` )
      ( name = `Beam Breaker B-1` category = `Accessories` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-6100.jpg` quantity = 32 deliverydate = `1784764800000` )
      ( name = `Removable CD/DVD Laser Labels` category = `Accessories` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-2027.jpg` quantity = 25 deliverydate = `1784419200000` )
      ( name = `Audio/Video Cable Kit - 4m` category = `Accessories` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-2026.jpg` quantity = 16 deliverydate = `1784073600000` )
      ( name = `CD/DVD case: 264 sleeves` category = `Accessories` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-2025.jpg` quantity = 26 deliverydate = `1783728000000` )
      ( name = `10" Portable DVD player` category = `Accessories` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-2001.jpg` quantity = 21 deliverydate = `1783382400000` )
      ( name = `7" Widescreen Portable DVD Player w MP3` category = `Accessories` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-2000.jpg` quantity = 20 deliverydate = `1783036800000` )
      ( name = `Gaming Monster Pro` category = `Desktop Computers` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1603.jpg` quantity = 25 deliverydate = `1782691200000` )
      ( name = `Gaming Monster` category = `Desktop Computers` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1602.jpg` quantity = 24 deliverydate = `1782345600000` )
      ( name = `Family PC Pro` category = `Desktop Computers` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1601.jpg` quantity = 20 deliverydate = `1782000000000` )
      ( name = `Family PC Basic` category = `Desktop Computers` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1600.jpg` quantity = 10 deliverydate = `1781654400000` )
      ( name = `Travel Adapter` category = `Accessories` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1119.jpg` quantity = 10 deliverydate = `1784764800000` )
      ( name = `ITelO FlexTop I4000` category = `Laptops` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-8000.jpg` quantity = 11 deliverydate = `1784419200000` )
      ( name = `ITelO FlexTop I6300c` category = `Laptops` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-8001.jpg` quantity = 20 deliverydate = `1784073600000` )
      ( name = `ITelO FlexTop I9100` category = `Laptops` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-8002.jpg` quantity = 20 deliverydate = `1783728000000` )
      ( name = `ITelO FlexTop I9800` category = `Laptops` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-8003.jpg` quantity = 22 deliverydate = `1783382400000` )
      ( name = `Flyer` category = `Accessories` productpicurl = `test-resources/sap/ui/documentation/sdk/images/PF-1000.jpg` quantity = 33 deliverydate = `1783036800000` )
      ( name = `Maxi Tablet` category = `Tablets` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-9999.jpg` quantity = 20 deliverydate = `1782691200000` )
      ( name = `Smartphone Beta` category = `Smartphones and Tablets` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-9998.jpg` quantity = 21 deliverydate = `1782345600000` )
      ( name = `e-Book Reader ReadMe` category = `Smartphones and Tablets` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-9997.jpg` quantity = 23 deliverydate = `1782000000000` )
      ( name = `Tablet Pouch` category = `Accessories` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-9996.jpg` quantity = 34 deliverydate = `1781654400000` )
      ( name = `Smartphone Cover` category = `Accessories` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-9995.jpg` quantity = 23 deliverydate = `1784764800000` )
      ( name = `Camcorder View` category = `Accessories` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-9994.jpg` quantity = 50 deliverydate = `1784419200000` )
      ( name = `Mini Tablet` category = `Smartphones and Tablets` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-9993.jpg` quantity = 10 deliverydate = `1784073600000` )
      ( name = `Smartphone Alpha` category = `Smartphones and Tablets` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-9992.jpg` quantity = 13 deliverydate = `1783728000000` )
      ( name = `Smartphone Leather Case` category = `Accessories` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-9991.jpg` quantity = 12 deliverydate = `1783382400000` )
      ( name = `Astro Laptop 1516` category = `Laptops` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1251.jpg` quantity = 23 deliverydate = `1783036800000` )
      ( name = `Astro Phone 6` category = `Smartphones and Tablets` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1252.jpg` quantity = 28 deliverydate = `1782691200000` )
      ( name = `Benda Laptop 1408` category = `Laptops` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1253.jpg` quantity = 27 deliverydate = `1782345600000` )
      ( name = `Bending Screen 21HD` category = `Flat Screens` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1254.jpg` quantity = 23 deliverydate = `1782000000000` )
      ( name = `Broad Screen 22HD` category = `Flat Screens` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1255.jpg` quantity = 5 deliverydate = `1781654400000` )
      ( name = `Cerdik Phone 7` category = `Smartphones and Tablets` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1256.jpg` quantity = 19 deliverydate = `1784764800000` )
      ( name = `Cepat Tablet 10.5` category = `Smartphones and Tablets` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1257.jpg` quantity = 17 deliverydate = `1784419200000` )
      ( name = `Cepat Tablet 8` category = `Smartphones and Tablets` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1258.jpg` quantity = 24 deliverydate = `1784073600000` )
      ).

  ENDMETHOD.

ENDCLASS.
