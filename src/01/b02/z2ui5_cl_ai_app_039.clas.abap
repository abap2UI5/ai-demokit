CLASS z2ui5_cl_ai_app_039 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        product_id    TYPE string,
        name          TYPE string,
        supplier_name TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_039 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`

        )->open( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->open( `MultiComboBox`
                )->a( n = `width` v = `500px`
                )->a( n = `items` v = |\{ path: '{ client->_bind( val = t_products path = abap_true ) }', sorter: \{ path: 'SUPPLIER_NAME', descending: false, group: true \} \}|

                )->leaf( n = `Item` ns = `core`
                    )->a( n = `key`  v = `{PRODUCT_ID}`
                    )->a( n = `text` v = `{NAME}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " full mock /ProductCollection (sap/ui/demo/mock/products.json) of the original sample
    t_products = VALUE #(
      ( product_id = `HT-1000` name = `Notebook Basic 15`                                  supplier_name = `Very Best Screens` )
      ( product_id = `HT-1001` name = `Notebook Basic 17`                                  supplier_name = `Very Best Screens` )
      ( product_id = `HT-1002` name = `Notebook Basic 18`                                  supplier_name = `Very Best Screens` )
      ( product_id = `HT-1003` name = `Notebook Basic 19`                                  supplier_name = `Smartcards`        )
      ( product_id = `HT-1007` name = `ITelO Vault`                                        supplier_name = `Technocom`         )
      ( product_id = `HT-1010` name = `Notebook Professional 15`                           supplier_name = `Very Best Screens` )
      ( product_id = `HT-1011` name = `Notebook Professional 17`                           supplier_name = `Very Best Screens` )
      ( product_id = `HT-1020` name = `ITelO Vault Net`                                    supplier_name = `Technocom`         )
      ( product_id = `HT-1021` name = `ITelO Vault SAT`                                    supplier_name = `Technocom`         )
      ( product_id = `HT-1022` name = `Comfort Easy`                                       supplier_name = `Technocom`         )
      ( product_id = `HT-1023` name = `Comfort Senior`                                     supplier_name = `Technocom`         )
      ( product_id = `HT-1030` name = `Ergo Screen E-I`                                    supplier_name = `Very Best Screens` )
      ( product_id = `HT-1031` name = `Ergo Screen E-II`                                   supplier_name = `Very Best Screens` )
      ( product_id = `HT-1032` name = `Ergo Screen E-III`                                  supplier_name = `Very Best Screens` )
      ( product_id = `HT-1035` name = `Flat Basic`                                         supplier_name = `Very Best Screens` )
      ( product_id = `HT-1036` name = `Flat Future`                                        supplier_name = `Very Best Screens` )
      ( product_id = `HT-1037` name = `Flat XL`                                            supplier_name = `Very Best Screens` )
      ( product_id = `HT-1040` name = `Laser Professional Eco`                             supplier_name = `Alpha Printers`    )
      ( product_id = `HT-1041` name = `Laser Basic`                                        supplier_name = `Alpha Printers`    )
      ( product_id = `HT-1042` name = `Laser Allround`                                     supplier_name = `Alpha Printers`    )
      ( product_id = `HT-1050` name = `Ultra Jet Super Color`                              supplier_name = `Alpha Printers`    )
      ( product_id = `HT-1051` name = `Ultra Jet Mobile`                                   supplier_name = `Printer for All`   )
      ( product_id = `HT-1052` name = `Ultra Jet Super Highspeed`                          supplier_name = `Printer for All`   )
      ( product_id = `HT-1055` name = `Multi Print`                                        supplier_name = `Printer for All`   )
      ( product_id = `HT-1056` name = `Multi Color`                                        supplier_name = `Printer for All`   )
      ( product_id = `HT-1060` name = `Cordless Mouse`                                     supplier_name = `Oxynum`            )
      ( product_id = `HT-1061` name = `Speed Mouse`                                        supplier_name = `Oxynum`            )
      ( product_id = `HT-1062` name = `Track Mouse`                                        supplier_name = `Oxynum`            )
      ( product_id = `HT-1063` name = `Ergonomic Keyboard`                                 supplier_name = `Oxynum`            )
      ( product_id = `HT-1064` name = `Internet Keyboard`                                  supplier_name = `Oxynum`            )
      ( product_id = `HT-1065` name = `Media Keyboard`                                     supplier_name = `Oxynum`            )
      ( product_id = `HT-1066` name = `Mousepad`                                           supplier_name = `Oxynum`            )
      ( product_id = `HT-1067` name = `Ergo Mousepad`                                      supplier_name = `Oxynum`            )
      ( product_id = `HT-1068` name = `Designer Mousepad`                                  supplier_name = `Fasttech`          )
      ( product_id = `HT-1069` name = `Universal card reader`                              supplier_name = `Fasttech`          )
      ( product_id = `HT-1070` name = `Proctra X`                                          supplier_name = `Ultrasonic United` )
      ( product_id = `HT-1071` name = `Gladiator MX`                                       supplier_name = `Ultrasonic United` )
      ( product_id = `HT-1072` name = `Hurricane GX`                                       supplier_name = `Ultrasonic United` )
      ( product_id = `HT-1073` name = `Hurricane GX/LN`                                    supplier_name = `Smartcards`        )
      ( product_id = `HT-1080` name = `Photo Scan`                                         supplier_name = `Printer for All`   )
      ( product_id = `HT-1081` name = `Power Scan`                                         supplier_name = `Printer for All`   )
      ( product_id = `HT-1082` name = `Jet Scan Professional`                              supplier_name = `Printer for All`   )
      ( product_id = `HT-1083` name = `Jet Scan Professional`                              supplier_name = `Printer for All`   )
      ( product_id = `HT-1085` name = `Copymaster`                                         supplier_name = `Alpha Printers`    )
      ( product_id = `HT-1090` name = `Surround Sound`                                     supplier_name = `Speaker Experts`   )
      ( product_id = `HT-1091` name = `Blaster Extreme`                                    supplier_name = `Speaker Experts`   )
      ( product_id = `HT-1092` name = `Sound Booster`                                      supplier_name = `Speaker Experts`   )
      ( product_id = `HT-1095` name = `Lovely Sound 5.1 Wireless`                          supplier_name = `Fasttech`          )
      ( product_id = `HT-1096` name = `Lovely Sound 5.1`                                   supplier_name = `Fasttech`          )
      ( product_id = `HT-1097` name = `Lovely Sound Stereo`                                supplier_name = `Fasttech`          )
      ( product_id = `HT-1100` name = `Smart Office`                                       supplier_name = `Technocom`         )
      ( product_id = `HT-1101` name = `Smart Design`                                       supplier_name = `Technocom`         )
      ( product_id = `HT-1102` name = `Smart Network`                                      supplier_name = `Technocom`         )
      ( product_id = `HT-1103` name = `Smart Multimedia`                                   supplier_name = `Technocom`         )
      ( product_id = `HT-1104` name = `Smart Games`                                        supplier_name = `Technocom`         )
      ( product_id = `HT-1105` name = `Smart Internet Antivirus`                           supplier_name = `Brainsoft`         )
      ( product_id = `HT-1106` name = `Smart Firewall`                                     supplier_name = `Brainsoft`         )
      ( product_id = `HT-1107` name = `Smart Money`                                        supplier_name = `Brainsoft`         )
      ( product_id = `HT-1110` name = `PC Lock`                                            supplier_name = `Red Point Stores`  )
      ( product_id = `HT-1111` name = `Notebook Lock`                                      supplier_name = `Red Point Stores`  )
      ( product_id = `HT-1112` name = `Web cam reality`                                    supplier_name = `Red Point Stores`  )
      ( product_id = `HT-1113` name = `Screen clean`                                       supplier_name = `Red Point Stores`  )
      ( product_id = `HT-1114` name = `Fabric bag professional`                            supplier_name = `Red Point Stores`  )
      ( product_id = `HT-1115` name = `Wireless DSL Router`                                supplier_name = `Red Point Stores`  )
      ( product_id = `HT-1116` name = `Wireless DSL Router / Repeater`                     supplier_name = `Red Point Stores`  )
      ( product_id = `HT-1117` name = `Wireless DSL Router / Repeater and Print Server`    supplier_name = `Technocom`         )
      ( product_id = `HT-1118` name = `USB Stick`                                          supplier_name = `Technocom`         )
      ( product_id = `HT-1119` name = `Travel Adapter`                                     supplier_name = `Titanium`          )
      ( product_id = `HT-1120` name = `Cordless Bluetooth Keyboard, english international` supplier_name = `Technocom`         )
      ( product_id = `HT-1137` name = `Flat XXL`                                           supplier_name = `Technocom`         )
      ( product_id = `HT-1138` name = `Pocket Mouse`                                       supplier_name = `Technocom`         )
      ( product_id = `HT-1210` name = `PC Power Station`                                   supplier_name = `Technocom`         )
      ( product_id = `HT-1251` name = `Astro Laptop 1516`                                  supplier_name = `Ultrasonic United` )
      ( product_id = `HT-1252` name = `Astro Phone 6`                                      supplier_name = `Ultrasonic United` )
      ( product_id = `HT-1253` name = `Benda Laptop 1408`                                  supplier_name = `Ultrasonic United` )
      ( product_id = `HT-1254` name = `Bending Screen 21HD`                                supplier_name = `Ultrasonic United` )
      ( product_id = `HT-1255` name = `Broad Screen 22HD`                                  supplier_name = `Ultrasonic United` )
      ( product_id = `HT-1256` name = `Cerdik Phone 7`                                     supplier_name = `Ultrasonic United` )
      ( product_id = `HT-1257` name = `Cepat Tablet 10.5`                                  supplier_name = `Ultrasonic United` )
      ( product_id = `HT-1258` name = `Cepat Tablet 8`                                     supplier_name = `Ultrasonic United` )
      ( product_id = `HT-1500` name = `Server Basic`                                       supplier_name = `Technocom`         )
      ( product_id = `HT-1501` name = `Server Professional`                                supplier_name = `Technocom`         )
      ( product_id = `HT-1502` name = `Server Power Pro`                                   supplier_name = `Technocom`         )
      ( product_id = `HT-1600` name = `Family PC Basic`                                    supplier_name = `Titanium`          )
      ( product_id = `HT-1601` name = `Family PC Pro`                                      supplier_name = `Titanium`          )
      ( product_id = `HT-1602` name = `Gaming Monster`                                     supplier_name = `Titanium`          )
      ( product_id = `HT-1603` name = `Gaming Monster Pro`                                 supplier_name = `Titanium`          )
      ( product_id = `HT-2000` name = `7" Widescreen Portable DVD Player w MP3`            supplier_name = `Titanium`          )
      ( product_id = `HT-2001` name = `10" Portable DVD player`                            supplier_name = `Titanium`          )
      ( product_id = `HT-2002` name = `Portable DVD Player with 9" LCD Monitor`            supplier_name = `Technocom`         )
      ( product_id = `HT-2025` name = `CD/DVD case: 264 sleeves`                           supplier_name = `Titanium`          )
      ( product_id = `HT-2026` name = `Audio/Video Cable Kit - 4m`                         supplier_name = `Titanium`          )
      ( product_id = `HT-2027` name = `Removable CD/DVD Laser Labels`                      supplier_name = `Titanium`          )
      ( product_id = `HT-6100` name = `Beam Breaker B-1`                                   supplier_name = `Titanium`          )
      ( product_id = `HT-6101` name = `Beam Breaker B-2`                                   supplier_name = `Technocom`         )
      ( product_id = `HT-6102` name = `Beam Breaker B-3`                                   supplier_name = `Technocom`         )
      ( product_id = `HT-6110` name = `Play Movie`                                         supplier_name = `Fasttech`          )
      ( product_id = `HT-6111` name = `Record Movie`                                       supplier_name = `Fasttech`          )
      ( product_id = `HT-6120` name = `ITelo MusicStick`                                   supplier_name = `Fasttech`          )
      ( product_id = `HT-6121` name = `ITelo Jog-Mate`                                     supplier_name = `Fasttech`          )
      ( product_id = `HT-6122` name = `Power Pro Player 40`                                supplier_name = `Fasttech`          )
      ( product_id = `HT-6123` name = `Power Pro Player 80`                                supplier_name = `Fasttech`          )
      ( product_id = `HT-6130` name = `Flat Watch HD32`                                    supplier_name = `Very Best Screens` )
      ( product_id = `HT-6131` name = `Flat Watch HD37`                                    supplier_name = `Very Best Screens` )
      ( product_id = `HT-6132` name = `Flat Watch HD41`                                    supplier_name = `Very Best Screens` )
      ( product_id = `HT-7000` name = `Copperberry`                                        supplier_name = `Fasttech`          )
      ( product_id = `HT-7010` name = `Silverberry`                                        supplier_name = `Fasttech`          )
      ( product_id = `HT-7020` name = `Goldberry`                                          supplier_name = `Fasttech`          )
      ( product_id = `HT-7030` name = `Platinberry`                                        supplier_name = `Fasttech`          )
      ( product_id = `HT-8000` name = `ITelO FlexTop I4000`                                supplier_name = `Titanium`          )
      ( product_id = `HT-8001` name = `ITelO FlexTop I6300c`                               supplier_name = `Titanium`          )
      ( product_id = `HT-8002` name = `ITelO FlexTop I9100`                                supplier_name = `Titanium`          )
      ( product_id = `HT-8003` name = `ITelO FlexTop I9800`                                supplier_name = `Titanium`          )
      ( product_id = `HT-9991` name = `Smartphone Leather Case`                            supplier_name = `Ultrasonic United` )
      ( product_id = `HT-9992` name = `Smartphone Alpha`                                   supplier_name = `Ultrasonic United` )
      ( product_id = `HT-9993` name = `Mini Tablet`                                        supplier_name = `Ultrasonic United` )
      ( product_id = `HT-9994` name = `Camcorder View`                                     supplier_name = `Ultrasonic United` )
      ( product_id = `HT-9995` name = `Tablet Pouch`                                       supplier_name = `Titanium`          )
      ( product_id = `HT-9996` name = `Tablet Pouch`                                       supplier_name = `Titanium`          )
      ( product_id = `HT-9997` name = `e-Book Reader ReadMe`                               supplier_name = `Titanium`          )
      ( product_id = `HT-9998` name = `Smartphone Beta`                                    supplier_name = `Titanium`          )
      ( product_id = `HT-9999` name = `Maxi Tablet`                                        supplier_name = `Titanium`          )
      ( product_id = `PF-1000` name = `Flyer`                                              supplier_name = `Titanium`          ) ).

  ENDMETHOD.

ENDCLASS.
