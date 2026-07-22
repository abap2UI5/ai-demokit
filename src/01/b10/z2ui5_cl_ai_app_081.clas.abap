CLASS z2ui5_cl_ai_app_081 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name            TYPE string,
        product_id      TYPE string,
        product_pic_url TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.
    DATA shown      TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.
    METHODS fill_all RETURNING VALUE(result) LIKE t_products.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_081 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->open( `Page`
            )->a( n = `showHeader` v = `false`

            )->open( `content`
                )->leaf( `PullToRefresh`
                    )->a( n = `id`      v = `pullToRefresh`
                    )->a( n = `refresh` v = client->_event( `REFRESH` )
                )->open( `List`
                    )->a( n = `id`    v = `list`
                    )->a( n = `items` v = client->_bind( t_products )

                    )->leaf( `StandardListItem`
                        )->a( n = `title`            v = `{NAME}`
                        )->a( n = `description`      v = `{PRODUCT_ID}`
                        )->a( n = `icon`             v = `{PRODUCT_PIC_URL}`
                        )->a( n = `iconDensityAware` v = `false`
                        )->a( n = `iconInset`        v = `false`

                )->shut(
            )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `REFRESH`.
        " _pushNewProduct: each pull-to-refresh appends the next product until the full collection is shown
        DATA(all) = fill_all( ).
        IF shown < lines( all ).
          shown = shown + 1.
        ENDIF.
        t_products = VALUE #( FOR i = 1 WHILE i <= shown ( all[ i ] ) ).
        client->view_model_update( ).
    ENDCASE.

  ENDMETHOD.


  METHOD fill_all.

    " full mock /ProductCollection (sap/ui/demo/mock/products.json); ProductPicUrl resolved to absolute OpenUI5 URLs
    result = VALUE #(
      ( name = `Notebook Basic 15`                                  product_id = `HT-1000` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg` )
      ( name = `Notebook Basic 17`                                  product_id = `HT-1001` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1001.jpg` )
      ( name = `Notebook Basic 18`                                  product_id = `HT-1002` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1002.jpg` )
      ( name = `Notebook Basic 19`                                  product_id = `HT-1003` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1003.jpg` )
      ( name = `ITelO Vault`                                        product_id = `HT-1007` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1007.jpg` )
      ( name = `Notebook Professional 15`                           product_id = `HT-1010` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg` )
      ( name = `Notebook Professional 17`                           product_id = `HT-1011` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1011.jpg` )
      ( name = `ITelO Vault Net`                                    product_id = `HT-1020` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1020.jpg` )
      ( name = `ITelO Vault SAT`                                    product_id = `HT-1021` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1021.jpg` )
      ( name = `Comfort Easy`                                       product_id = `HT-1022` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1022.jpg` )
      ( name = `Comfort Senior`                                     product_id = `HT-1023` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1023.jpg` )
      ( name = `Ergo Screen E-I`                                    product_id = `HT-1030` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1030.jpg` )
      ( name = `Ergo Screen E-II`                                   product_id = `HT-1031` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1031.jpg` )
      ( name = `Ergo Screen E-III`                                  product_id = `HT-1032` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1032.jpg` )
      ( name = `Flat Basic`                                         product_id = `HT-1035` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1035.jpg` )
      ( name = `Flat Future`                                        product_id = `HT-1036` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1036.jpg` )
      ( name = `Flat XL`                                            product_id = `HT-1037` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1037.jpg` )
      ( name = `Laser Professional Eco`                             product_id = `HT-1040` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1040.jpg` )
      ( name = `Laser Basic`                                        product_id = `HT-1041` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1041.jpg` )
      ( name = `Laser Allround`                                     product_id = `HT-1042` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1042.jpg` )
      ( name = `Ultra Jet Super Color`                              product_id = `HT-1050` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1050.jpg` )
      ( name = `Ultra Jet Mobile`                                   product_id = `HT-1051` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1051.jpg` )
      ( name = `Ultra Jet Super Highspeed`                          product_id = `HT-1052` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1052.jpg` )
      ( name = `Multi Print`                                        product_id = `HT-1055` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1055.jpg` )
      ( name = `Multi Color`                                        product_id = `HT-1056` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1056.jpg` )
      ( name = `Cordless Mouse`                                     product_id = `HT-1060` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1060.jpg` )
      ( name = `Speed Mouse`                                        product_id = `HT-1061` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1061.jpg` )
      ( name = `Track Mouse`                                        product_id = `HT-1062` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1062.jpg` )
      ( name = `Ergonomic Keyboard`                                 product_id = `HT-1063` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1063.jpg` )
      ( name = `Internet Keyboard`                                  product_id = `HT-1064` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1064.jpg` )
      ( name = `Media Keyboard`                                     product_id = `HT-1065` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1065.jpg` )
      ( name = `Mousepad`                                           product_id = `HT-1066` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1066.jpg` )
      ( name = `Ergo Mousepad`                                      product_id = `HT-1067` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1067.jpg` )
      ( name = `Designer Mousepad`                                  product_id = `HT-1068` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1068.jpg` )
      ( name = `Universal card reader`                              product_id = `HT-1069` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1069.jpg` )
      ( name = `Proctra X`                                          product_id = `HT-1070` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1070.jpg` )
      ( name = `Gladiator MX`                                       product_id = `HT-1071` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1071.jpg` )
      ( name = `Hurricane GX`                                       product_id = `HT-1072` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1072.jpg` )
      ( name = `Hurricane GX/LN`                                    product_id = `HT-1073` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1073.jpg` )
      ( name = `Photo Scan`                                         product_id = `HT-1080` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1080.jpg` )
      ( name = `Power Scan`                                         product_id = `HT-1081` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1081.jpg` )
      ( name = `Jet Scan Professional`                              product_id = `HT-1082` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1082.jpg` )
      ( name = `Jet Scan Professional`                              product_id = `HT-1083` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1083.jpg` )
      ( name = `Copymaster`                                         product_id = `HT-1085` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1085.jpg` )
      ( name = `Surround Sound`                                     product_id = `HT-1090` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1090.jpg` )
      ( name = `Blaster Extreme`                                    product_id = `HT-1091` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1091.jpg` )
      ( name = `Sound Booster`                                      product_id = `HT-1092` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1092.jpg` )
      ( name = `Lovely Sound 5.1 Wireless`                          product_id = `HT-1095` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1095.jpg` )
      ( name = `Lovely Sound 5.1`                                   product_id = `HT-1096` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1096.jpg` )
      ( name = `Lovely Sound Stereo`                                product_id = `HT-1097` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1097.jpg` )
      ( name = `Smart Office`                                       product_id = `HT-1100` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1100.jpg` )
      ( name = `Smart Design`                                       product_id = `HT-1101` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1101.jpg` )
      ( name = `Smart Network`                                      product_id = `HT-1102` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1102.jpg` )
      ( name = `Smart Multimedia`                                   product_id = `HT-1103` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1103.jpg` )
      ( name = `Smart Games`                                        product_id = `HT-1104` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1104.jpg` )
      ( name = `Smart Internet Antivirus`                           product_id = `HT-1105` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1105.jpg` )
      ( name = `Smart Firewall`                                     product_id = `HT-1106` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1106.jpg` )
      ( name = `Smart Money`                                        product_id = `HT-1107` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1107.jpg` )
      ( name = `PC Lock`                                            product_id = `HT-1110` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1110.jpg` )
      ( name = `Notebook Lock`                                      product_id = `HT-1111` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1111.jpg` )
      ( name = `Web cam reality`                                    product_id = `HT-1112` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1112.jpg` )
      ( name = `Screen clean`                                       product_id = `HT-1113` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1113.jpg` )
      ( name = `Fabric bag professional`                            product_id = `HT-1114` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1114.jpg` )
      ( name = `Wireless DSL Router`                                product_id = `HT-1115` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1115.jpg` )
      ( name = `Wireless DSL Router / Repeater`                     product_id = `HT-1116` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1116.jpg` )
      ( name = `Wireless DSL Router / Repeater and Print Server`    product_id = `HT-1117` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1117.jpg` )
      ( name = `USB Stick`                                          product_id = `HT-1118` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1118.jpg` )
      ( name = `Travel Adapter`                                     product_id = `HT-1119` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1119.jpg` )
      ( name = `Cordless Bluetooth Keyboard, english international` product_id = `HT-1120` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1120.jpg` )
      ( name = `Flat XXL`                                           product_id = `HT-1137` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1137.jpg` )
      ( name = `Pocket Mouse`                                       product_id = `HT-1138` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1138.jpg` )
      ( name = `PC Power Station`                                   product_id = `HT-1210` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1210.jpg` )
      ( name = `Astro Laptop 1516`                                  product_id = `HT-1251` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1251.jpg` )
      ( name = `Astro Phone 6`                                      product_id = `HT-1252` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1252.jpg` )
      ( name = `Benda Laptop 1408`                                  product_id = `HT-1253` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1253.jpg` )
      ( name = `Bending Screen 21HD`                                product_id = `HT-1254` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1254.jpg` )
      ( name = `Broad Screen 22HD`                                  product_id = `HT-1255` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1255.jpg` )
      ( name = `Cerdik Phone 7`                                     product_id = `HT-1256` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1256.jpg` )
      ( name = `Cepat Tablet 10.5`                                  product_id = `HT-1257` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1257.jpg` )
      ( name = `Cepat Tablet 8`                                     product_id = `HT-1258` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1258.jpg` )
      ( name = `Server Basic`                                       product_id = `HT-1500` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1500.jpg` )
      ( name = `Server Professional`                                product_id = `HT-1501` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1501.jpg` )
      ( name = `Server Power Pro`                                   product_id = `HT-1502` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1502.jpg` )
      ( name = `Family PC Basic`                                    product_id = `HT-1600` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1600.jpg` )
      ( name = `Family PC Pro`                                      product_id = `HT-1601` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1601.jpg` )
      ( name = `Gaming Monster`                                     product_id = `HT-1602` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1602.jpg` )
      ( name = `Gaming Monster Pro`                                 product_id = `HT-1603` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1603.jpg` )
      ( name = `7" Widescreen Portable DVD Player w MP3`            product_id = `HT-2000` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2000.jpg` )
      ( name = `10" Portable DVD player`                            product_id = `HT-2001` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2001.jpg` )
      ( name = `Portable DVD Player with 9" LCD Monitor`            product_id = `HT-2002` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2002.jpg` )
      ( name = `CD/DVD case: 264 sleeves`                           product_id = `HT-2025` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2025.jpg` )
      ( name = `Audio/Video Cable Kit - 4m`                         product_id = `HT-2026` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2026.jpg` )
      ( name = `Removable CD/DVD Laser Labels`                      product_id = `HT-2027` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2027.jpg` )
      ( name = `Beam Breaker B-1`                                   product_id = `HT-6100` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6100.jpg` )
      ( name = `Beam Breaker B-2`                                   product_id = `HT-6101` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6101.jpg` )
      ( name = `Beam Breaker B-3`                                   product_id = `HT-6102` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6102.jpg` )
      ( name = `Play Movie`                                         product_id = `HT-6110` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6110.jpg` )
      ( name = `Record Movie`                                       product_id = `HT-6111` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6111.jpg` )
      ( name = `ITelo MusicStick`                                   product_id = `HT-6120` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6120.jpg` )
      ( name = `ITelo Jog-Mate`                                     product_id = `HT-6121` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6121.jpg` )
      ( name = `Power Pro Player 40`                                product_id = `HT-6122` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6122.jpg` )
      ( name = `Power Pro Player 80`                                product_id = `HT-6123` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6123.jpg` )
      ( name = `Flat Watch HD32`                                    product_id = `HT-6130` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6130.jpg` )
      ( name = `Flat Watch HD37`                                    product_id = `HT-6131` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6131.jpg` )
      ( name = `Flat Watch HD41`                                    product_id = `HT-6132` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6132.jpg` )
      ( name = `Copperberry`                                        product_id = `HT-7000` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7000.jpg` )
      ( name = `Silverberry`                                        product_id = `HT-7010` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7010.jpg` )
      ( name = `Goldberry`                                          product_id = `HT-7020` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7020.jpg` )
      ( name = `Platinberry`                                        product_id = `HT-7030` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7030.jpg` )
      ( name = `ITelO FlexTop I4000`                                product_id = `HT-8000` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8000.jpg` )
      ( name = `ITelO FlexTop I6300c`                               product_id = `HT-8001` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8001.jpg` )
      ( name = `ITelO FlexTop I9100`                                product_id = `HT-8002` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8002.jpg` )
      ( name = `ITelO FlexTop I9800`                                product_id = `HT-8003` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8003.jpg` )
      ( name = `Smartphone Leather Case`                            product_id = `HT-9991` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9991.jpg` )
      ( name = `Smartphone Alpha`                                   product_id = `HT-9992` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9992.jpg` )
      ( name = `Mini Tablet`                                        product_id = `HT-9993` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9993.jpg` )
      ( name = `Camcorder View`                                     product_id = `HT-9994` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9994.jpg` )
      ( name = `Tablet Pouch`                                       product_id = `HT-9995` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9995.jpg` )
      ( name = `Tablet Pouch`                                       product_id = `HT-9996` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9996.jpg` )
      ( name = `e-Book Reader ReadMe`                               product_id = `HT-9997` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9997.jpg` )
      ( name = `Smartphone Beta`                                    product_id = `HT-9998` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9998.jpg` )
      ( name = `Maxi Tablet`                                        product_id = `HT-9999` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9999.jpg` )
      ( name = `Flyer`                                              product_id = `PF-1000` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/PF-1000.jpg` ) ).

  ENDMETHOD.


  METHOD model_init.

    " the original starts with an empty model and pushes the first product on init
    shown = 1.
    DATA(all) = fill_all( ).
    t_products = VALUE #( ( all[ 1 ] ) ).

  ENDMETHOD.
ENDCLASS.
