CLASS z2ui5_cl_ai_app_186 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_product,
        productid TYPE string,
        name      TYPE string,
        quantity  TYPE i,
      END OF ty_product.
    DATA productcollection TYPE STANDARD TABLE OF ty_product WITH EMPTY KEY.

    " The original keeps the three pane sizes in a separate 'sizes' JSON model
    " ({sizes>/pane1..3}); with abap2UI5's single default model they live flat
    " here and the SplitterLayoutData.size / the Text labels bind them directly.
    DATA pane1 TYPE string.
    DATA pane2 TYPE string.
    DATA pane3 TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_186 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " sap.ui.layout.ResponsiveSplitter. The original binds the pane sizes from a
    " separate 'sizes' JSON model ({sizes>/paneN}) and the product list/select
    " from the default model ({/ProductCollection}); abap2UI5 has one default
    " model, so the sizes are folded into it (the 'sizes>' prefix is dropped -
    " last path segment identical, which structural-diff matches). The two
    " PaneContainer 'resize' handlers only show an informational MessageToast of
    " the new pane sizes (an oldSizes/newSizes array event) and are dropped.
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `height`     v = `100%`

        )->open( n = `ResponsiveSplitter` ns = `l`
            )->a( n = `defaultPane` v = `default`

            )->open( n = `PaneContainer` ns = `l`

                )->open( n = `SplitPane` ns = `l`
                    )->a( n = `requiredParentWidth` v = `400`
                    )->a( n = `id`                  v = `default`

                    )->open( n = `layoutData` ns = `l`
                        )->leaf( n = `SplitterLayoutData` ns = `l`
                            )->a( n = `size` v = client->_bind( pane1 )

                    )->shut(

                    )->open( `Panel`
                        )->a( n = `headerText` v = `Minimum parent width 400`
                        )->a( n = `height`     v = `100%`

                        )->leaf( `Text`
                            )->a( n = `text` v = |LayoutData.size={ client->_bind( pane1 ) }|

                        )->open( `List`
                            )->a( n = `headerText` v = `Products`
                            )->a( n = `items`      v = client->_bind( productcollection )

                            )->leaf( `StandardListItem`
                                )->a( n = `title`   v = `{NAME}`
                                )->a( n = `counter` v = `{QUANTITY}`

                        )->shut(
                    )->shut(
                )->shut(

                )->open( n = `PaneContainer` ns = `l`
                    )->a( n = `orientation` v = `Vertical`

                    )->open( n = `SplitPane` ns = `l`
                        )->a( n = `requiredParentWidth` v = `600`

                        )->open( n = `layoutData` ns = `l`
                            )->leaf( n = `SplitterLayoutData` ns = `l`
                                )->a( n = `size` v = client->_bind( pane2 )

                        )->shut(

                        )->open( `Panel`
                            )->a( n = `headerText` v = `Minimum parent width 600`

                            )->open( `VBox`
                                )->leaf( `Text`
                                    )->a( n = `text` v = |LayoutData.size={ client->_bind( pane2 ) }|

                                )->open( `Select`
                                    )->a( n = `forceSelection` v = `false`
                                    )->a( n = `selectedKey`    v = `1239102`
                                    )->a( n = `items`          v = |\{ path: '{ client->_bind( val = productcollection path = abap_true ) }', sorter: \{ path: 'NAME' \} \}|

                                    )->leaf( n = `Item` ns = `core`
                                        )->a( n = `key`  v = `{PRODUCTID}`
                                        )->a( n = `text` v = `{NAME}`

                                )->shut(
                            )->shut(
                        )->shut(
                    )->shut(

                    )->open( n = `SplitPane` ns = `l`
                        )->a( n = `requiredParentWidth` v = `800`

                        )->open( n = `layoutData` ns = `l`
                            )->leaf( n = `SplitterLayoutData` ns = `l`
                                )->a( n = `size` v = client->_bind( pane3 )

                        )->shut(

                        )->open( `Page`
                            )->a( n = `title` v = `Minimum parent width 800`

                            )->leaf( `Text`
                                )->a( n = `text` v = |LayoutData.size={ client->_bind( pane3 ) }|

                            )->open( `footer`
                                )->open( `OverflowToolbar`
                                    )->a( n = `id` v = `otb3`

                                    )->leaf( `Label`
                                        )->a( n = `text` v = `Buttons:`
                                    )->leaf( `ToolbarSpacer`
                                    )->leaf( `Button`
                                        )->a( n = `text` v = `New`
                                        )->a( n = `type` v = `Transparent`
                                    )->leaf( `Button`
                                        )->a( n = `text` v = `Open`
                                        )->a( n = `type` v = `Transparent`
                                    )->leaf( `Button`
                                        )->a( n = `text` v = `Save`
                                        )->a( n = `type` v = `Transparent`
                                    )->leaf( `Button`
                                        )->a( n = `text` v = `Save as`
                                        )->a( n = `type` v = `Transparent`
                                    )->leaf( `Button`
                                        )->a( n = `text` v = `Cut`
                                        )->a( n = `type` v = `Transparent`
                                    )->leaf( `Button`
                                        )->a( n = `text` v = `Copy`
                                        )->a( n = `type` v = `Transparent`
                                    )->leaf( `Button`
                                        )->a( n = `text` v = `Paste`
                                        )->a( n = `type` v = `Transparent`
                                    )->leaf( `Button`
                                        )->a( n = `text` v = `Undo`
                                        )->a( n = `type` v = `Transparent` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " the original pane sizes model starts every pane at 'auto'
    pane1 = `auto`.
    pane2 = `auto`.
    pane3 = `auto`.

    " the shared 123-row demo ProductCollection (sap/ui/demo/mock/products.json),
    " inlined with the three columns the sample binds (ProductId, Name, Quantity)
    productcollection = VALUE #(
      ( productid = `HT-1000` name = `Notebook Basic 15` quantity = 10 )
      ( productid = `HT-1001` name = `Notebook Basic 17` quantity = 20 )
      ( productid = `HT-1002` name = `Notebook Basic 18` quantity = 10 )
      ( productid = `HT-1003` name = `Notebook Basic 19` quantity = 15 )
      ( productid = `HT-1007` name = `ITelO Vault` quantity = 15 )
      ( productid = `HT-1010` name = `Notebook Professional 15` quantity = 16 )
      ( productid = `HT-1011` name = `Notebook Professional 17` quantity = 17 )
      ( productid = `HT-1020` name = `ITelO Vault Net` quantity = 14 )
      ( productid = `HT-1021` name = `ITelO Vault SAT` quantity = 50 )
      ( productid = `HT-1022` name = `Comfort Easy` quantity = 30 )
      ( productid = `HT-1023` name = `Comfort Senior` quantity = 24 )
      ( productid = `HT-1030` name = `Ergo Screen E-I` quantity = 14 )
      ( productid = `HT-1031` name = `Ergo Screen E-II` quantity = 24 )
      ( productid = `HT-1032` name = `Ergo Screen E-III` quantity = 50 )
      ( productid = `HT-1035` name = `Flat Basic` quantity = 23 )
      ( productid = `HT-1036` name = `Flat Future` quantity = 22 )
      ( productid = `HT-1037` name = `Flat XL` quantity = 23 )
      ( productid = `HT-1040` name = `Laser Professional Eco` quantity = 21 )
      ( productid = `HT-1041` name = `Laser Basic` quantity = 8 )
      ( productid = `HT-1042` name = `Laser Allround` quantity = 9 )
      ( productid = `HT-1050` name = `Ultra Jet Super Color` quantity = 17 )
      ( productid = `HT-1051` name = `Ultra Jet Mobile` quantity = 18 )
      ( productid = `HT-1052` name = `Ultra Jet Super Highspeed` quantity = 25 )
      ( productid = `HT-1055` name = `Multi Print` quantity = 16 )
      ( productid = `HT-1056` name = `Multi Color` quantity = 5 )
      ( productid = `HT-1060` name = `Cordless Mouse` quantity = 25 )
      ( productid = `HT-1061` name = `Speed Mouse` quantity = 12 )
      ( productid = `HT-1062` name = `Track Mouse` quantity = 12 )
      ( productid = `HT-1063` name = `Ergonomic Keyboard` quantity = 50 )
      ( productid = `HT-1064` name = `Internet Keyboard` quantity = 35 )
      ( productid = `HT-1065` name = `Media Keyboard` quantity = 26 )
      ( productid = `HT-1066` name = `Mousepad` quantity = 12 )
      ( productid = `HT-1067` name = `Ergo Mousepad` quantity = 16 )
      ( productid = `HT-1068` name = `Designer Mousepad` quantity = 26 )
      ( productid = `HT-1069` name = `Universal card reader` quantity = 22 )
      ( productid = `HT-1070` name = `Proctra X` quantity = 15 )
      ( productid = `HT-1071` name = `Gladiator MX` quantity = 16 )
      ( productid = `HT-1072` name = `Hurricane GX` quantity = 13 )
      ( productid = `HT-1073` name = `Hurricane GX/LN` quantity = 5 )
      ( productid = `HT-1080` name = `Photo Scan` quantity = 8 )
      ( productid = `HT-1081` name = `Power Scan` quantity = 11 )
      ( productid = `HT-1082` name = `Jet Scan Professional` quantity = 13 )
      ( productid = `HT-1083` name = `Jet Scan Professional` quantity = 10 )
      ( productid = `HT-1085` name = `Copymaster` quantity = 10 )
      ( productid = `HT-1090` name = `Surround Sound` quantity = 20 )
      ( productid = `HT-1091` name = `Blaster Extreme` quantity = 15 )
      ( productid = `HT-1092` name = `Sound Booster` quantity = 50 )
      ( productid = `HT-1095` name = `Lovely Sound 5.1 Wireless` quantity = 12 )
      ( productid = `HT-1096` name = `Lovely Sound 5.1` quantity = 18 )
      ( productid = `HT-1097` name = `Lovely Sound Stereo` quantity = 21 )
      ( productid = `HT-1100` name = `Smart Office` quantity = 25 )
      ( productid = `HT-1101` name = `Smart Design` quantity = 26 )
      ( productid = `HT-1102` name = `Smart Network` quantity = 28 )
      ( productid = `HT-1103` name = `Smart Multimedia` quantity = 9 )
      ( productid = `HT-1104` name = `Smart Games` quantity = 13 )
      ( productid = `HT-1105` name = `Smart Internet Antivirus` quantity = 17 )
      ( productid = `HT-1106` name = `Smart Firewall` quantity = 19 )
      ( productid = `HT-1107` name = `Smart Money` quantity = 18 )
      ( productid = `HT-1110` name = `PC Lock` quantity = 14 )
      ( productid = `HT-1111` name = `Notebook Lock` quantity = 20 )
      ( productid = `HT-1112` name = `Web cam reality` quantity = 27 )
      ( productid = `HT-1113` name = `Screen clean` quantity = 17 )
      ( productid = `HT-1114` name = `Fabric bag professional` quantity = 14 )
      ( productid = `HT-1115` name = `Wireless DSL Router` quantity = 16 )
      ( productid = `HT-1116` name = `Wireless DSL Router / Repeater` quantity = 12 )
      ( productid = `HT-1117` name = `Wireless DSL Router / Repeater and Print Server` quantity = 12 )
      ( productid = `HT-1118` name = `USB Stick` quantity = 14 )
      ( productid = `HT-1119` name = `Travel Adapter` quantity = 10 )
      ( productid = `HT-1120` name = `Cordless Bluetooth Keyboard, english international` quantity = 13 )
      ( productid = `HT-1137` name = `Flat XXL` quantity = 10 )
      ( productid = `HT-1138` name = `Pocket Mouse` quantity = 20 )
      ( productid = `HT-1210` name = `PC Power Station` quantity = 22 )
      ( productid = `HT-1251` name = `Astro Laptop 1516` quantity = 23 )
      ( productid = `HT-1252` name = `Astro Phone 6` quantity = 28 )
      ( productid = `HT-1253` name = `Benda Laptop 1408` quantity = 27 )
      ( productid = `HT-1254` name = `Bending Screen 21HD` quantity = 23 )
      ( productid = `HT-1255` name = `Broad Screen 22HD` quantity = 5 )
      ( productid = `HT-1256` name = `Cerdik Phone 7` quantity = 19 )
      ( productid = `HT-1257` name = `Cepat Tablet 10.5` quantity = 17 )
      ( productid = `HT-1258` name = `Cepat Tablet 8` quantity = 24 )
      ( productid = `HT-1500` name = `Server Basic` quantity = 24 )
      ( productid = `HT-1501` name = `Server Professional` quantity = 26 )
      ( productid = `HT-1502` name = `Server Power Pro` quantity = 34 )
      ( productid = `HT-1600` name = `Family PC Basic` quantity = 10 )
      ( productid = `HT-1601` name = `Family PC Pro` quantity = 20 )
      ( productid = `HT-1602` name = `Gaming Monster` quantity = 24 )
      ( productid = `HT-1603` name = `Gaming Monster Pro` quantity = 25 )
      ( productid = `HT-2000` name = `7" Widescreen Portable DVD Player w MP3` quantity = 20 )
      ( productid = `HT-2001` name = `10" Portable DVD player` quantity = 21 )
      ( productid = `HT-2002` name = `Portable DVD Player with 9" LCD Monitor` quantity = 50 )
      ( productid = `HT-2025` name = `CD/DVD case: 264 sleeves` quantity = 26 )
      ( productid = `HT-2026` name = `Audio/Video Cable Kit - 4m` quantity = 16 )
      ( productid = `HT-2027` name = `Removable CD/DVD Laser Labels` quantity = 25 )
      ( productid = `HT-6100` name = `Beam Breaker B-1` quantity = 32 )
      ( productid = `HT-6101` name = `Beam Breaker B-2` quantity = 18 )
      ( productid = `HT-6102` name = `Beam Breaker B-3` quantity = 16 )
      ( productid = `HT-6110` name = `Play Movie` quantity = 15 )
      ( productid = `HT-6111` name = `Record Movie` quantity = 24 )
      ( productid = `HT-6120` name = `ITelo MusicStick` quantity = 15 )
      ( productid = `HT-6121` name = `ITelo Jog-Mate` quantity = 24 )
      ( productid = `HT-6122` name = `Power Pro Player 40` quantity = 23 )
      ( productid = `HT-6123` name = `Power Pro Player 80` quantity = 13 )
      ( productid = `HT-6130` name = `Flat Watch HD32` quantity = 16 )
      ( productid = `HT-6131` name = `Flat Watch HD37` quantity = 14 )
      ( productid = `HT-6132` name = `Flat Watch HD41` quantity = 13 )
      ( productid = `HT-7000` name = `Copperberry` quantity = 5 )
      ( productid = `HT-7010` name = `Silverberry` quantity = 9 )
      ( productid = `HT-7020` name = `Goldberry` quantity = 11 )
      ( productid = `HT-7030` name = `Platinberry` quantity = 12 )
      ( productid = `HT-8000` name = `ITelO FlexTop I4000` quantity = 11 )
      ( productid = `HT-8001` name = `ITelO FlexTop I6300c` quantity = 20 )
      ( productid = `HT-8002` name = `ITelO FlexTop I9100` quantity = 20 )
      ( productid = `HT-8003` name = `ITelO FlexTop I9800` quantity = 22 )
      ( productid = `HT-9991` name = `Smartphone Leather Case` quantity = 12 )
      ( productid = `HT-9992` name = `Smartphone Alpha` quantity = 13 )
      ( productid = `HT-9993` name = `Mini Tablet` quantity = 10 )
      ( productid = `HT-9994` name = `Camcorder View` quantity = 50 )
      ( productid = `HT-9995` name = `Tablet Pouch` quantity = 34 )
      ( productid = `HT-9996` name = `Tablet Pouch` quantity = 34 )
      ( productid = `HT-9997` name = `e-Book Reader ReadMe` quantity = 23 )
      ( productid = `HT-9998` name = `Smartphone Beta` quantity = 21 )
      ( productid = `HT-9999` name = `Maxi Tablet` quantity = 20 )
      ( productid = `PF-1000` name = `Flyer` quantity = 33 )
      ).

  ENDMETHOD.

ENDCLASS.
