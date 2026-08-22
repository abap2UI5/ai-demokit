" @keywords list sap.m listactions overflowtoolbar title toolbarspacer text slider standardlistitem listitemaction
" @summary This example demonstrates how to add custom actions to list items. Dedicated 'Delete' and 'Edit' types can be used to add predefined actions to the list items. The 'Custom' type can be used to add custom actions to the list items.
CLASS z2ui5_cl_smpc_app_498 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             name          TYPE string,
             productid     TYPE string,
             productpicurl TYPE string,
             quantity      TYPE i,
           END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

    DATA t_products   TYPE ty_t_product.
    DATA action_count TYPE i VALUE 2.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_498 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( `List`
            )->a( n = `id`              v = `list`
            )->a( n = `items`           v = client->_bind( t_products )
            )->a( n = `mode`            v = `MultiSelect`
            " onSliderChange calls list.setItemActionCount( value ) - the Slider value
            " and the count are the same two-way bound field here
            )->a( n = `itemActionCount` v = client->_bind( action_count )
            " onItemActionPress toasts the action's text (or its type) and the product
            " of the row - both travel with the event
            )->a( n = `itemActionPress` v = client->_event( val   = `ITEM_ACTION`
                                                            t_arg = VALUE #( ( `${$parameters>/action}.getText() || ${$parameters>/action}.getType()` )
                                                                             ( `${$parameters>/listItem}.getTitle()` ) ) )

            )->ele( `headerToolbar`
                )->ele( `OverflowToolbar`

                    )->tag( `Title`
                        )->a( n = `text`  v = `Products`
                        )->a( n = `level` v = `H2`
                    )->tag( `ToolbarSpacer`
                    )->tag( `Text`
                        )->a( n = `text` v = `Item Action Count: `
                    )->tag( `Slider`
                        )->a( n = `min`             v = `0`
                        )->a( n = `max`             v = `2`
                        )->a( n = `value`           v = client->_bind( action_count )
                        )->a( n = `width`           v = `150px`
                        )->a( n = `enableTickmarks` v = `true`

                )->end(
            )->end(

            )->ele( `StandardListItem`
                )->a( n = `title`       v = `{NAME}`
                )->a( n = `description` v = `{PRODUCTID}`
                )->a( n = `icon`        v = `{PRODUCTPICURL}`
                )->a( n = `counter`     v = `{QUANTITY}`
                )->a( n = `type`        v = `Navigation`

                )->tag( `ListItemAction`
                    )->a( n = `text` v = `Add to Cart`
                    )->a( n = `icon` v = `sap-icon://cart`
                )->tag( `ListItemAction`
                    )->a( n = `text` v = `Bookmark`
                    )->a( n = `icon` v = `sap-icon://bookmark`
                )->tag( `ListItemAction`
                    )->a( n = `type` v = `Edit`
                )->tag( `ListItemAction`
                    )->a( n = `type` v = `Delete` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `ITEM_ACTION`.
      client->message_toast_display( |{ client->get_event_arg( ) } action is pressed for the Product { client->get_event_arg( 2 ) }| ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " full mock /ProductCollection of ui5/mock/products.json (the bound fields)
    t_products = VALUE #(
        ( name = `Notebook Basic 15` productid = `HT-1000` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg` quantity = 10 )
        ( name = `Notebook Basic 17` productid = `HT-1001` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1001.jpg` quantity = 20 )
        ( name = `Notebook Basic 18` productid = `HT-1002` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1002.jpg` quantity = 10 )
        ( name = `Notebook Basic 19` productid = `HT-1003` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1003.jpg` quantity = 15 )
        ( name = `ITelO Vault` productid = `HT-1007` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1007.jpg` quantity = 15 )
        ( name = `Notebook Professional 15` productid = `HT-1010` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg` quantity = 16 )
        ( name = `Notebook Professional 17` productid = `HT-1011` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1011.jpg` quantity = 17 )
        ( name = `ITelO Vault Net` productid = `HT-1020` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1020.jpg` quantity = 14 )
        ( name = `ITelO Vault SAT` productid = `HT-1021` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1021.jpg` quantity = 50 )
        ( name = `Comfort Easy` productid = `HT-1022` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1022.jpg` quantity = 30 )
        ( name = `Comfort Senior` productid = `HT-1023` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1023.jpg` quantity = 24 )
        ( name = `Ergo Screen E-I` productid = `HT-1030` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1030.jpg` quantity = 14 )
        ( name = `Ergo Screen E-II` productid = `HT-1031` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1031.jpg` quantity = 24 )
        ( name = `Ergo Screen E-III` productid = `HT-1032` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1032.jpg` quantity = 50 )
        ( name = `Flat Basic` productid = `HT-1035` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1035.jpg` quantity = 23 )
        ( name = `Flat Future` productid = `HT-1036` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1036.jpg` quantity = 22 )
        ( name = `Flat XL` productid = `HT-1037` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1037.jpg` quantity = 23 )
        ( name = `Laser Professional Eco` productid = `HT-1040` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1040.jpg` quantity = 21 )
        ( name = `Laser Basic` productid = `HT-1041` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1041.jpg` quantity = 8 )
        ( name = `Laser Allround` productid = `HT-1042` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1042.jpg` quantity = 9 )
        ( name = `Ultra Jet Super Color` productid = `HT-1050` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1050.jpg` quantity = 17 )
        ( name = `Ultra Jet Mobile` productid = `HT-1051` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1051.jpg` quantity = 18 )
        ( name = `Ultra Jet Super Highspeed` productid = `HT-1052` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1052.jpg` quantity = 25 )
        ( name = `Multi Print` productid = `HT-1055` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1055.jpg` quantity = 16 )
        ( name = `Multi Color` productid = `HT-1056` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1056.jpg` quantity = 5 )
        ( name = `Cordless Mouse` productid = `HT-1060` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1060.jpg` quantity = 25 )
        ( name = `Speed Mouse` productid = `HT-1061` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1061.jpg` quantity = 12 )
        ( name = `Track Mouse` productid = `HT-1062` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1062.jpg` quantity = 12 )
        ( name = `Ergonomic Keyboard` productid = `HT-1063` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1063.jpg` quantity = 50 )
        ( name = `Internet Keyboard` productid = `HT-1064` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1064.jpg` quantity = 35 )
        ( name = `Media Keyboard` productid = `HT-1065` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1065.jpg` quantity = 26 )
        ( name = `Mousepad` productid = `HT-1066` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1066.jpg` quantity = 12 )
        ( name = `Ergo Mousepad` productid = `HT-1067` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1067.jpg` quantity = 16 )
        ( name = `Designer Mousepad` productid = `HT-1068` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1068.jpg` quantity = 26 )
        ( name = `Universal card reader` productid = `HT-1069` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1069.jpg` quantity = 22 )
        ( name = `Proctra X` productid = `HT-1070` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1070.jpg` quantity = 15 )
        ( name = `Gladiator MX` productid = `HT-1071` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1071.jpg` quantity = 16 )
        ( name = `Hurricane GX` productid = `HT-1072` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1072.jpg` quantity = 13 )
        ( name = `Hurricane GX/LN` productid = `HT-1073` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1073.jpg` quantity = 5 )
        ( name = `Photo Scan` productid = `HT-1080` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1080.jpg` quantity = 8 )
        ( name = `Power Scan` productid = `HT-1081` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1081.jpg` quantity = 11 )
        ( name = `Jet Scan Professional` productid = `HT-1082` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1082.jpg` quantity = 13 )
        ( name = `Jet Scan Professional` productid = `HT-1083` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1083.jpg` quantity = 10 )
        ( name = `Copymaster` productid = `HT-1085` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1085.jpg` quantity = 10 )
        ( name = `Surround Sound` productid = `HT-1090` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1090.jpg` quantity = 20 )
        ( name = `Blaster Extreme` productid = `HT-1091` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1091.jpg` quantity = 15 )
        ( name = `Sound Booster` productid = `HT-1092` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1092.jpg` quantity = 50 )
        ( name = `Lovely Sound 5.1 Wireless` productid = `HT-1095` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1095.jpg` quantity = 12 )
        ( name = `Lovely Sound 5.1` productid = `HT-1096` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1096.jpg` quantity = 18 )
        ( name = `Lovely Sound Stereo` productid = `HT-1097` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1097.jpg` quantity = 21 )
        ( name = `Smart Office` productid = `HT-1100` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1100.jpg` quantity = 25 )
        ( name = `Smart Design` productid = `HT-1101` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1101.jpg` quantity = 26 )
        ( name = `Smart Network` productid = `HT-1102` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1102.jpg` quantity = 28 )
        ( name = `Smart Multimedia` productid = `HT-1103` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1103.jpg` quantity = 9 )
        ( name = `Smart Games` productid = `HT-1104` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1104.jpg` quantity = 13 )
        ( name = `Smart Internet Antivirus` productid = `HT-1105` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1105.jpg` quantity = 17 )
        ( name = `Smart Firewall` productid = `HT-1106` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1106.jpg` quantity = 19 )
        ( name = `Smart Money` productid = `HT-1107` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1107.jpg` quantity = 18 )
        ( name = `PC Lock` productid = `HT-1110` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1110.jpg` quantity = 14 )
        ( name = `Notebook Lock` productid = `HT-1111` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1111.jpg` quantity = 20 )
        ( name = `Web cam reality` productid = `HT-1112` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1112.jpg` quantity = 27 )
        ( name = `Screen clean` productid = `HT-1113` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1113.jpg` quantity = 17 )
        ( name = `Fabric bag professional` productid = `HT-1114` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1114.jpg` quantity = 14 )
        ( name = `Wireless DSL Router` productid = `HT-1115` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1115.jpg` quantity = 16 )
        ( name = `Wireless DSL Router / Repeater` productid = `HT-1116` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1116.jpg` quantity = 12 )
        ( name = `Wireless DSL Router / Repeater and Print Server` productid = `HT-1117` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1117.jpg` quantity = 12 )
        ( name = `USB Stick` productid = `HT-1118` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1118.jpg` quantity = 14 )
        ( name = `Travel Adapter` productid = `HT-1119` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1119.jpg` quantity = 10 )
        ( name = `Cordless Bluetooth Keyboard, english international` productid = `HT-1120` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1120.jpg` quantity = 13 )
        ( name = `Flat XXL` productid = `HT-1137` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1137.jpg` quantity = 10 )
        ( name = `Pocket Mouse` productid = `HT-1138` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1138.jpg` quantity = 20 )
        ( name = `PC Power Station` productid = `HT-1210` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1210.jpg` quantity = 22 )
        ( name = `Astro Laptop 1516` productid = `HT-1251` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1251.jpg` quantity = 23 )
        ( name = `Astro Phone 6` productid = `HT-1252` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1252.jpg` quantity = 28 )
        ( name = `Benda Laptop 1408` productid = `HT-1253` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1253.jpg` quantity = 27 )
        ( name = `Bending Screen 21HD` productid = `HT-1254` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1254.jpg` quantity = 23 )
        ( name = `Broad Screen 22HD` productid = `HT-1255` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1255.jpg` quantity = 5 )
        ( name = `Cerdik Phone 7` productid = `HT-1256` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1256.jpg` quantity = 19 )
        ( name = `Cepat Tablet 10.5` productid = `HT-1257` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1257.jpg` quantity = 17 )
        ( name = `Cepat Tablet 8` productid = `HT-1258` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1258.jpg` quantity = 24 )
        ( name = `Server Basic` productid = `HT-1500` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1500.jpg` quantity = 24 )
        ( name = `Server Professional` productid = `HT-1501` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1501.jpg` quantity = 26 )
        ( name = `Server Power Pro` productid = `HT-1502` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1502.jpg` quantity = 34 )
        ( name = `Family PC Basic` productid = `HT-1600` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1600.jpg` quantity = 10 )
        ( name = `Family PC Pro` productid = `HT-1601` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1601.jpg` quantity = 20 )
        ( name = `Gaming Monster` productid = `HT-1602` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1602.jpg` quantity = 24 )
        ( name = `Gaming Monster Pro` productid = `HT-1603` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1603.jpg` quantity = 25 )
        ( name = `7" Widescreen Portable DVD Player w MP3` productid = `HT-2000` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2000.jpg` quantity = 20 )
        ( name = `10" Portable DVD player` productid = `HT-2001` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2001.jpg` quantity = 21 )
        ( name = `Portable DVD Player with 9" LCD Monitor` productid = `HT-2002` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2002.jpg` quantity = 50 )
        ( name = `CD/DVD case: 264 sleeves` productid = `HT-2025` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2025.jpg` quantity = 26 )
        ( name = `Audio/Video Cable Kit - 4m` productid = `HT-2026` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2026.jpg` quantity = 16 )
        ( name = `Removable CD/DVD Laser Labels` productid = `HT-2027` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2027.jpg` quantity = 25 )
        ( name = `Beam Breaker B-1` productid = `HT-6100` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6100.jpg` quantity = 32 )
        ( name = `Beam Breaker B-2` productid = `HT-6101` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6101.jpg` quantity = 18 )
        ( name = `Beam Breaker B-3` productid = `HT-6102` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6102.jpg` quantity = 16 )
        ( name = `Play Movie` productid = `HT-6110` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6110.jpg` quantity = 15 )
        ( name = `Record Movie` productid = `HT-6111` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6111.jpg` quantity = 24 )
        ( name = `ITelo MusicStick` productid = `HT-6120` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6120.jpg` quantity = 15 )
        ( name = `ITelo Jog-Mate` productid = `HT-6121` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6121.jpg` quantity = 24 )
        ( name = `Power Pro Player 40` productid = `HT-6122` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6122.jpg` quantity = 23 )
        ( name = `Power Pro Player 80` productid = `HT-6123` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6123.jpg` quantity = 13 )
        ( name = `Flat Watch HD32` productid = `HT-6130` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6130.jpg` quantity = 16 )
        ( name = `Flat Watch HD37` productid = `HT-6131` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6131.jpg` quantity = 14 )
        ( name = `Flat Watch HD41` productid = `HT-6132` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6132.jpg` quantity = 13 )
        ( name = `Copperberry` productid = `HT-7000` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7000.jpg` quantity = 5 )
        ( name = `Silverberry` productid = `HT-7010` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7010.jpg` quantity = 9 )
        ( name = `Goldberry` productid = `HT-7020` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7020.jpg` quantity = 11 )
        ( name = `Platinberry` productid = `HT-7030` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7030.jpg` quantity = 12 )
        ( name = `ITelO FlexTop I4000` productid = `HT-8000` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8000.jpg` quantity = 11 )
        ( name = `ITelO FlexTop I6300c` productid = `HT-8001` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8001.jpg` quantity = 20 )
        ( name = `ITelO FlexTop I9100` productid = `HT-8002` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8002.jpg` quantity = 20 )
        ( name = `ITelO FlexTop I9800` productid = `HT-8003` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8003.jpg` quantity = 22 )
        ( name = `Smartphone Leather Case` productid = `HT-9991` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9991.jpg` quantity = 12 )
        ( name = `Smartphone Alpha` productid = `HT-9992` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9992.jpg` quantity = 13 )
        ( name = `Mini Tablet` productid = `HT-9993` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9993.jpg` quantity = 10 )
        ( name = `Camcorder View` productid = `HT-9994` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9994.jpg` quantity = 50 )
        ( name = `Tablet Pouch` productid = `HT-9995` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9995.jpg` quantity = 34 )
        ( name = `Tablet Pouch` productid = `HT-9996` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9996.jpg` quantity = 34 )
        ( name = `e-Book Reader ReadMe` productid = `HT-9997` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9997.jpg` quantity = 23 )
        ( name = `Smartphone Beta` productid = `HT-9998` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9998.jpg` quantity = 21 )
        ( name = `Maxi Tablet` productid = `HT-9999` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9999.jpg` quantity = 20 )
        ( name = `Flyer` productid = `PF-1000` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/PF-1000.jpg` quantity = 33 ) ).

  ENDMETHOD.

ENDCLASS.
