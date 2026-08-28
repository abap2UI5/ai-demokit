" @keywords list sap.m listunread standardlistitem
" @summary With the Unread Indicator you can highlight new items making it easier for the user to discover them.
CLASS z2ui5_cl_smpc_app_480 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             name          TYPE string,
             productid     TYPE string,
             productpicurl TYPE string,
             unread        TYPE abap_bool,
           END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

    DATA t_products TYPE ty_t_product.
  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_480 IMPLEMENTATION.

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

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( `List`
            )->a( n = `headerText` v = `Products`
            )->a( n = `showUnread` v = `true`
            )->a( n = `items`      v = client->_bind( t_products )

            " Formatter.randomBoolean decides unread per row on the client; a
            " backend cannot repeat a Math.random draw, so the flag is a plain
            " model field seeded in model_init
            )->tag( `StandardListItem`
                )->a( n = `title`            v = `{NAME}`
                )->a( n = `unread`           v = `{UNREAD}`
                )->a( n = `description`      v = `{PRODUCTID}`
                )->a( n = `icon`             v = `{PRODUCTPICURL}`
                )->a( n = `iconDensityAware` v = `false`
                )->a( n = `iconInset`        v = `false` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " full mock /ProductCollection of ui5/mock/products.json (the bound fields);
    " unread alternates instead of the sample's random draw
    t_products = VALUE #(
        ( name = `Notebook Basic 15`                                  productid = `HT-1000` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg` unread = abap_true )
        ( name = `Notebook Basic 17`                                  productid = `HT-1001` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1001.jpg` unread = abap_false )
        ( name = `Notebook Basic 18`                                  productid = `HT-1002` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1002.jpg` unread = abap_true )
        ( name = `Notebook Basic 19`                                  productid = `HT-1003` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1003.jpg` unread = abap_false )
        ( name = `ITelO Vault`                                        productid = `HT-1007` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1007.jpg` unread = abap_true )
        ( name = `Notebook Professional 15`                           productid = `HT-1010` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg` unread = abap_false )
        ( name = `Notebook Professional 17`                           productid = `HT-1011` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1011.jpg` unread = abap_true )
        ( name = `ITelO Vault Net`                                    productid = `HT-1020` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1020.jpg` unread = abap_false )
        ( name = `ITelO Vault SAT`                                    productid = `HT-1021` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1021.jpg` unread = abap_true )
        ( name = `Comfort Easy`                                       productid = `HT-1022` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1022.jpg` unread = abap_false )
        ( name = `Comfort Senior`                                     productid = `HT-1023` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1023.jpg` unread = abap_true )
        ( name = `Ergo Screen E-I`                                    productid = `HT-1030` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1030.jpg` unread = abap_false )
        ( name = `Ergo Screen E-II`                                   productid = `HT-1031` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1031.jpg` unread = abap_true )
        ( name = `Ergo Screen E-III`                                  productid = `HT-1032` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1032.jpg` unread = abap_false )
        ( name = `Flat Basic`                                         productid = `HT-1035` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1035.jpg` unread = abap_true )
        ( name = `Flat Future`                                        productid = `HT-1036` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1036.jpg` unread = abap_false )
        ( name = `Flat XL`                                            productid = `HT-1037` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1037.jpg` unread = abap_true )
        ( name = `Laser Professional Eco`                             productid = `HT-1040` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1040.jpg` unread = abap_false )
        ( name = `Laser Basic`                                        productid = `HT-1041` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1041.jpg` unread = abap_true )
        ( name = `Laser Allround`                                     productid = `HT-1042` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1042.jpg` unread = abap_false )
        ( name = `Ultra Jet Super Color`                              productid = `HT-1050` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1050.jpg` unread = abap_true )
        ( name = `Ultra Jet Mobile`                                   productid = `HT-1051` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1051.jpg` unread = abap_false )
        ( name = `Ultra Jet Super Highspeed`                          productid = `HT-1052` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1052.jpg` unread = abap_true )
        ( name = `Multi Print`                                        productid = `HT-1055` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1055.jpg` unread = abap_false )
        ( name = `Multi Color`                                        productid = `HT-1056` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1056.jpg` unread = abap_true )
        ( name = `Cordless Mouse`                                     productid = `HT-1060` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1060.jpg` unread = abap_false )
        ( name = `Speed Mouse`                                        productid = `HT-1061` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1061.jpg` unread = abap_true )
        ( name = `Track Mouse`                                        productid = `HT-1062` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1062.jpg` unread = abap_false )
        ( name = `Ergonomic Keyboard`                                 productid = `HT-1063` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1063.jpg` unread = abap_true )
        ( name = `Internet Keyboard`                                  productid = `HT-1064` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1064.jpg` unread = abap_false )
        ( name = `Media Keyboard`                                     productid = `HT-1065` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1065.jpg` unread = abap_true )
        ( name = `Mousepad`                                           productid = `HT-1066` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1066.jpg` unread = abap_false )
        ( name = `Ergo Mousepad`                                      productid = `HT-1067` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1067.jpg` unread = abap_true )
        ( name = `Designer Mousepad`                                  productid = `HT-1068` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1068.jpg` unread = abap_false )
        ( name = `Universal card reader`                              productid = `HT-1069` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1069.jpg` unread = abap_true )
        ( name = `Proctra X`                                          productid = `HT-1070` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1070.jpg` unread = abap_false )
        ( name = `Gladiator MX`                                       productid = `HT-1071` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1071.jpg` unread = abap_true )
        ( name = `Hurricane GX`                                       productid = `HT-1072` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1072.jpg` unread = abap_false )
        ( name = `Hurricane GX/LN`                                    productid = `HT-1073` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1073.jpg` unread = abap_true )
        ( name = `Photo Scan`                                         productid = `HT-1080` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1080.jpg` unread = abap_false )
        ( name = `Power Scan`                                         productid = `HT-1081` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1081.jpg` unread = abap_true )
        ( name = `Jet Scan Professional`                              productid = `HT-1082` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1082.jpg` unread = abap_false )
        ( name = `Jet Scan Professional`                              productid = `HT-1083` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1083.jpg` unread = abap_true )
        ( name = `Copymaster`                                         productid = `HT-1085` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1085.jpg` unread = abap_false )
        ( name = `Surround Sound`                                     productid = `HT-1090` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1090.jpg` unread = abap_true )
        ( name = `Blaster Extreme`                                    productid = `HT-1091` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1091.jpg` unread = abap_false )
        ( name = `Sound Booster`                                      productid = `HT-1092` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1092.jpg` unread = abap_true )
        ( name = `Lovely Sound 5.1 Wireless`                          productid = `HT-1095` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1095.jpg` unread = abap_false )
        ( name = `Lovely Sound 5.1`                                   productid = `HT-1096` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1096.jpg` unread = abap_true )
        ( name = `Lovely Sound Stereo`                                productid = `HT-1097` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1097.jpg` unread = abap_false )
        ( name = `Smart Office`                                       productid = `HT-1100` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1100.jpg` unread = abap_true )
        ( name = `Smart Design`                                       productid = `HT-1101` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1101.jpg` unread = abap_false )
        ( name = `Smart Network`                                      productid = `HT-1102` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1102.jpg` unread = abap_true )
        ( name = `Smart Multimedia`                                   productid = `HT-1103` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1103.jpg` unread = abap_false )
        ( name = `Smart Games`                                        productid = `HT-1104` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1104.jpg` unread = abap_true )
        ( name = `Smart Internet Antivirus`                           productid = `HT-1105` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1105.jpg` unread = abap_false )
        ( name = `Smart Firewall`                                     productid = `HT-1106` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1106.jpg` unread = abap_true )
        ( name = `Smart Money`                                        productid = `HT-1107` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1107.jpg` unread = abap_false )
        ( name = `PC Lock`                                            productid = `HT-1110` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1110.jpg` unread = abap_true )
        ( name = `Notebook Lock`                                      productid = `HT-1111` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1111.jpg` unread = abap_false )
        ( name = `Web cam reality`                                    productid = `HT-1112` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1112.jpg` unread = abap_true )
        ( name = `Screen clean`                                       productid = `HT-1113` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1113.jpg` unread = abap_false )
        ( name = `Fabric bag professional`                            productid = `HT-1114` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1114.jpg` unread = abap_true )
        ( name = `Wireless DSL Router`                                productid = `HT-1115` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1115.jpg` unread = abap_false )
        ( name = `Wireless DSL Router / Repeater`                     productid = `HT-1116` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1116.jpg` unread = abap_true )
        ( name = `Wireless DSL Router / Repeater and Print Server`    productid = `HT-1117` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1117.jpg` unread = abap_false )
        ( name = `USB Stick`                                          productid = `HT-1118` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1118.jpg` unread = abap_true )
        ( name = `Travel Adapter`                                     productid = `HT-1119` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1119.jpg` unread = abap_false )
        ( name = `Cordless Bluetooth Keyboard, english international` productid = `HT-1120` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1120.jpg` unread = abap_true )
        ( name = `Flat XXL`                                           productid = `HT-1137` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1137.jpg` unread = abap_false )
        ( name = `Pocket Mouse`                                       productid = `HT-1138` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1138.jpg` unread = abap_true )
        ( name = `PC Power Station`                                   productid = `HT-1210` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1210.jpg` unread = abap_false )
        ( name = `Astro Laptop 1516`                                  productid = `HT-1251` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1251.jpg` unread = abap_true )
        ( name = `Astro Phone 6`                                      productid = `HT-1252` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1252.jpg` unread = abap_false )
        ( name = `Benda Laptop 1408`                                  productid = `HT-1253` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1253.jpg` unread = abap_true )
        ( name = `Bending Screen 21HD`                                productid = `HT-1254` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1254.jpg` unread = abap_false )
        ( name = `Broad Screen 22HD`                                  productid = `HT-1255` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1255.jpg` unread = abap_true )
        ( name = `Cerdik Phone 7`                                     productid = `HT-1256` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1256.jpg` unread = abap_false )
        ( name = `Cepat Tablet 10.5`                                  productid = `HT-1257` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1257.jpg` unread = abap_true )
        ( name = `Cepat Tablet 8`                                     productid = `HT-1258` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1258.jpg` unread = abap_false )
        ( name = `Server Basic`                                       productid = `HT-1500` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1500.jpg` unread = abap_true )
        ( name = `Server Professional`                                productid = `HT-1501` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1501.jpg` unread = abap_false )
        ( name = `Server Power Pro`                                   productid = `HT-1502` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1502.jpg` unread = abap_true )
        ( name = `Family PC Basic`                                    productid = `HT-1600` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1600.jpg` unread = abap_false )
        ( name = `Family PC Pro`                                      productid = `HT-1601` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1601.jpg` unread = abap_true )
        ( name = `Gaming Monster`                                     productid = `HT-1602` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1602.jpg` unread = abap_false )
        ( name = `Gaming Monster Pro`                                 productid = `HT-1603` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1603.jpg` unread = abap_true )
        ( name = `7" Widescreen Portable DVD Player w MP3`            productid = `HT-2000` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2000.jpg` unread = abap_false )
        ( name = `10" Portable DVD player`                            productid = `HT-2001` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2001.jpg` unread = abap_true )
        ( name = `Portable DVD Player with 9" LCD Monitor`            productid = `HT-2002` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2002.jpg` unread = abap_false )
        ( name = `CD/DVD case: 264 sleeves`                           productid = `HT-2025` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2025.jpg` unread = abap_true )
        ( name = `Audio/Video Cable Kit - 4m`                         productid = `HT-2026` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2026.jpg` unread = abap_false )
        ( name = `Removable CD/DVD Laser Labels`                      productid = `HT-2027` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2027.jpg` unread = abap_true )
        ( name = `Beam Breaker B-1`                                   productid = `HT-6100` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6100.jpg` unread = abap_false )
        ( name = `Beam Breaker B-2`                                   productid = `HT-6101` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6101.jpg` unread = abap_true )
        ( name = `Beam Breaker B-3`                                   productid = `HT-6102` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6102.jpg` unread = abap_false )
        ( name = `Play Movie`                                         productid = `HT-6110` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6110.jpg` unread = abap_true )
        ( name = `Record Movie`                                       productid = `HT-6111` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6111.jpg` unread = abap_false )
        ( name = `ITelo MusicStick`                                   productid = `HT-6120` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6120.jpg` unread = abap_true )
        ( name = `ITelo Jog-Mate`                                     productid = `HT-6121` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6121.jpg` unread = abap_false )
        ( name = `Power Pro Player 40`                                productid = `HT-6122` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6122.jpg` unread = abap_true )
        ( name = `Power Pro Player 80`                                productid = `HT-6123` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6123.jpg` unread = abap_false )
        ( name = `Flat Watch HD32`                                    productid = `HT-6130` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6130.jpg` unread = abap_true )
        ( name = `Flat Watch HD37`                                    productid = `HT-6131` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6131.jpg` unread = abap_false )
        ( name = `Flat Watch HD41`                                    productid = `HT-6132` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6132.jpg` unread = abap_true )
        ( name = `Copperberry`                                        productid = `HT-7000` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7000.jpg` unread = abap_false )
        ( name = `Silverberry`                                        productid = `HT-7010` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7010.jpg` unread = abap_true )
        ( name = `Goldberry`                                          productid = `HT-7020` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7020.jpg` unread = abap_false )
        ( name = `Platinberry`                                        productid = `HT-7030` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7030.jpg` unread = abap_true )
        ( name = `ITelO FlexTop I4000`                                productid = `HT-8000` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8000.jpg` unread = abap_false )
        ( name = `ITelO FlexTop I6300c`                               productid = `HT-8001` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8001.jpg` unread = abap_true )
        ( name = `ITelO FlexTop I9100`                                productid = `HT-8002` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8002.jpg` unread = abap_false )
        ( name = `ITelO FlexTop I9800`                                productid = `HT-8003` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8003.jpg` unread = abap_true )
        ( name = `Smartphone Leather Case`                            productid = `HT-9991` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9991.jpg` unread = abap_false )
        ( name = `Smartphone Alpha`                                   productid = `HT-9992` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9992.jpg` unread = abap_true )
        ( name = `Mini Tablet`                                        productid = `HT-9993` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9993.jpg` unread = abap_false )
        ( name = `Camcorder View`                                     productid = `HT-9994` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9994.jpg` unread = abap_true )
        ( name = `Tablet Pouch`                                       productid = `HT-9995` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9995.jpg` unread = abap_false )
        ( name = `Tablet Pouch`                                       productid = `HT-9996` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9996.jpg` unread = abap_true )
        ( name = `e-Book Reader ReadMe`                               productid = `HT-9997` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9997.jpg` unread = abap_false )
        ( name = `Smartphone Beta`                                    productid = `HT-9998` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9998.jpg` unread = abap_true )
        ( name = `Maxi Tablet`                                        productid = `HT-9999` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9999.jpg` unread = abap_false )
        ( name = `Flyer`                                              productid = `PF-1000` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/PF-1000.jpg` unread = abap_true ) ).

  ENDMETHOD.

ENDCLASS.
