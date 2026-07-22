CLASS z2ui5_cl_ai_app_079 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name       TYPE string,
        product_id TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_079 IMPLEMENTATION.

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
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `height`    v = `100%`

        )->open( `Page`
            )->a( n = `enableScrolling` v = `true`
            )->a( n = `title`          v = `Page Header Title`
            )->a( n = `titleLevel`     v = `H2`
            )->a( n = `showFooter`     v = `false`

            )->open( `List`
                )->a( n = `items` v = client->_bind( t_products )

                )->open( `headerToolbar`
                    )->open( `Toolbar`
                        )->open( `Title`
                            )->a( n = `level` v = `H3`
                            )->leaf( `Link`
                                )->a( n = `text`   v = `Products Link`
                                )->a( n = `href`   v = `https://sap.com`
                                )->a( n = `target` v = `_blank`

                        )->shut(
                        )->leaf( `ToolbarSpacer`
                        )->leaf( `Button`
                            )->a( n = `icon`  v = `sap-icon://settings`
                            )->a( n = `press` v = client->_event( `PRESS` )

                    )->shut(
                )->shut(

                )->leaf( `StandardListItem`
                    )->a( n = `title`       v = `{NAME}`
                    )->a( n = `description` v = `{PRODUCT_ID}`

            )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `PRESS`.
        client->message_toast_display( `Header toolbar button pressed.` ).
    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " full mock /ProductCollection (sap/ui/demo/mock/products.json)
    t_products = VALUE #(
      ( name = `Notebook Basic 15`                                  product_id = `HT-1000` )
      ( name = `Notebook Basic 17`                                  product_id = `HT-1001` )
      ( name = `Notebook Basic 18`                                  product_id = `HT-1002` )
      ( name = `Notebook Basic 19`                                  product_id = `HT-1003` )
      ( name = `ITelO Vault`                                        product_id = `HT-1007` )
      ( name = `Notebook Professional 15`                           product_id = `HT-1010` )
      ( name = `Notebook Professional 17`                           product_id = `HT-1011` )
      ( name = `ITelO Vault Net`                                    product_id = `HT-1020` )
      ( name = `ITelO Vault SAT`                                    product_id = `HT-1021` )
      ( name = `Comfort Easy`                                       product_id = `HT-1022` )
      ( name = `Comfort Senior`                                     product_id = `HT-1023` )
      ( name = `Ergo Screen E-I`                                    product_id = `HT-1030` )
      ( name = `Ergo Screen E-II`                                   product_id = `HT-1031` )
      ( name = `Ergo Screen E-III`                                  product_id = `HT-1032` )
      ( name = `Flat Basic`                                         product_id = `HT-1035` )
      ( name = `Flat Future`                                        product_id = `HT-1036` )
      ( name = `Flat XL`                                            product_id = `HT-1037` )
      ( name = `Laser Professional Eco`                             product_id = `HT-1040` )
      ( name = `Laser Basic`                                        product_id = `HT-1041` )
      ( name = `Laser Allround`                                     product_id = `HT-1042` )
      ( name = `Ultra Jet Super Color`                              product_id = `HT-1050` )
      ( name = `Ultra Jet Mobile`                                   product_id = `HT-1051` )
      ( name = `Ultra Jet Super Highspeed`                          product_id = `HT-1052` )
      ( name = `Multi Print`                                        product_id = `HT-1055` )
      ( name = `Multi Color`                                        product_id = `HT-1056` )
      ( name = `Cordless Mouse`                                     product_id = `HT-1060` )
      ( name = `Speed Mouse`                                        product_id = `HT-1061` )
      ( name = `Track Mouse`                                        product_id = `HT-1062` )
      ( name = `Ergonomic Keyboard`                                 product_id = `HT-1063` )
      ( name = `Internet Keyboard`                                  product_id = `HT-1064` )
      ( name = `Media Keyboard`                                     product_id = `HT-1065` )
      ( name = `Mousepad`                                           product_id = `HT-1066` )
      ( name = `Ergo Mousepad`                                      product_id = `HT-1067` )
      ( name = `Designer Mousepad`                                  product_id = `HT-1068` )
      ( name = `Universal card reader`                              product_id = `HT-1069` )
      ( name = `Proctra X`                                          product_id = `HT-1070` )
      ( name = `Gladiator MX`                                       product_id = `HT-1071` )
      ( name = `Hurricane GX`                                       product_id = `HT-1072` )
      ( name = `Hurricane GX/LN`                                    product_id = `HT-1073` )
      ( name = `Photo Scan`                                         product_id = `HT-1080` )
      ( name = `Power Scan`                                         product_id = `HT-1081` )
      ( name = `Jet Scan Professional`                              product_id = `HT-1082` )
      ( name = `Jet Scan Professional`                              product_id = `HT-1083` )
      ( name = `Copymaster`                                         product_id = `HT-1085` )
      ( name = `Surround Sound`                                     product_id = `HT-1090` )
      ( name = `Blaster Extreme`                                    product_id = `HT-1091` )
      ( name = `Sound Booster`                                      product_id = `HT-1092` )
      ( name = `Lovely Sound 5.1 Wireless`                          product_id = `HT-1095` )
      ( name = `Lovely Sound 5.1`                                   product_id = `HT-1096` )
      ( name = `Lovely Sound Stereo`                                product_id = `HT-1097` )
      ( name = `Smart Office`                                       product_id = `HT-1100` )
      ( name = `Smart Design`                                       product_id = `HT-1101` )
      ( name = `Smart Network`                                      product_id = `HT-1102` )
      ( name = `Smart Multimedia`                                   product_id = `HT-1103` )
      ( name = `Smart Games`                                        product_id = `HT-1104` )
      ( name = `Smart Internet Antivirus`                           product_id = `HT-1105` )
      ( name = `Smart Firewall`                                     product_id = `HT-1106` )
      ( name = `Smart Money`                                        product_id = `HT-1107` )
      ( name = `PC Lock`                                            product_id = `HT-1110` )
      ( name = `Notebook Lock`                                      product_id = `HT-1111` )
      ( name = `Web cam reality`                                    product_id = `HT-1112` )
      ( name = `Screen clean`                                       product_id = `HT-1113` )
      ( name = `Fabric bag professional`                            product_id = `HT-1114` )
      ( name = `Wireless DSL Router`                                product_id = `HT-1115` )
      ( name = `Wireless DSL Router / Repeater`                     product_id = `HT-1116` )
      ( name = `Wireless DSL Router / Repeater and Print Server`    product_id = `HT-1117` )
      ( name = `USB Stick`                                          product_id = `HT-1118` )
      ( name = `Travel Adapter`                                     product_id = `HT-1119` )
      ( name = `Cordless Bluetooth Keyboard, english international` product_id = `HT-1120` )
      ( name = `Flat XXL`                                           product_id = `HT-1137` )
      ( name = `Pocket Mouse`                                       product_id = `HT-1138` )
      ( name = `PC Power Station`                                   product_id = `HT-1210` )
      ( name = `Astro Laptop 1516`                                  product_id = `HT-1251` )
      ( name = `Astro Phone 6`                                      product_id = `HT-1252` )
      ( name = `Benda Laptop 1408`                                  product_id = `HT-1253` )
      ( name = `Bending Screen 21HD`                                product_id = `HT-1254` )
      ( name = `Broad Screen 22HD`                                  product_id = `HT-1255` )
      ( name = `Cerdik Phone 7`                                     product_id = `HT-1256` )
      ( name = `Cepat Tablet 10.5`                                  product_id = `HT-1257` )
      ( name = `Cepat Tablet 8`                                     product_id = `HT-1258` )
      ( name = `Server Basic`                                       product_id = `HT-1500` )
      ( name = `Server Professional`                                product_id = `HT-1501` )
      ( name = `Server Power Pro`                                   product_id = `HT-1502` )
      ( name = `Family PC Basic`                                    product_id = `HT-1600` )
      ( name = `Family PC Pro`                                      product_id = `HT-1601` )
      ( name = `Gaming Monster`                                     product_id = `HT-1602` )
      ( name = `Gaming Monster Pro`                                 product_id = `HT-1603` )
      ( name = `7" Widescreen Portable DVD Player w MP3`            product_id = `HT-2000` )
      ( name = `10" Portable DVD player`                            product_id = `HT-2001` )
      ( name = `Portable DVD Player with 9" LCD Monitor`            product_id = `HT-2002` )
      ( name = `CD/DVD case: 264 sleeves`                           product_id = `HT-2025` )
      ( name = `Audio/Video Cable Kit - 4m`                         product_id = `HT-2026` )
      ( name = `Removable CD/DVD Laser Labels`                      product_id = `HT-2027` )
      ( name = `Beam Breaker B-1`                                   product_id = `HT-6100` )
      ( name = `Beam Breaker B-2`                                   product_id = `HT-6101` )
      ( name = `Beam Breaker B-3`                                   product_id = `HT-6102` )
      ( name = `Play Movie`                                         product_id = `HT-6110` )
      ( name = `Record Movie`                                       product_id = `HT-6111` )
      ( name = `ITelo MusicStick`                                   product_id = `HT-6120` )
      ( name = `ITelo Jog-Mate`                                     product_id = `HT-6121` )
      ( name = `Power Pro Player 40`                                product_id = `HT-6122` )
      ( name = `Power Pro Player 80`                                product_id = `HT-6123` )
      ( name = `Flat Watch HD32`                                    product_id = `HT-6130` )
      ( name = `Flat Watch HD37`                                    product_id = `HT-6131` )
      ( name = `Flat Watch HD41`                                    product_id = `HT-6132` )
      ( name = `Copperberry`                                        product_id = `HT-7000` )
      ( name = `Silverberry`                                        product_id = `HT-7010` )
      ( name = `Goldberry`                                          product_id = `HT-7020` )
      ( name = `Platinberry`                                        product_id = `HT-7030` )
      ( name = `ITelO FlexTop I4000`                                product_id = `HT-8000` )
      ( name = `ITelO FlexTop I6300c`                               product_id = `HT-8001` )
      ( name = `ITelO FlexTop I9100`                                product_id = `HT-8002` )
      ( name = `ITelO FlexTop I9800`                                product_id = `HT-8003` )
      ( name = `Smartphone Leather Case`                            product_id = `HT-9991` )
      ( name = `Smartphone Alpha`                                   product_id = `HT-9992` )
      ( name = `Mini Tablet`                                        product_id = `HT-9993` )
      ( name = `Camcorder View`                                     product_id = `HT-9994` )
      ( name = `Tablet Pouch`                                       product_id = `HT-9995` )
      ( name = `Tablet Pouch`                                       product_id = `HT-9996` )
      ( name = `e-Book Reader ReadMe`                               product_id = `HT-9997` )
      ( name = `Smartphone Beta`                                    product_id = `HT-9998` )
      ( name = `Maxi Tablet`                                        product_id = `HT-9999` )
      ( name = `Flyer`                                              product_id = `PF-1000` ) ).

  ENDMETHOD.

ENDCLASS.
