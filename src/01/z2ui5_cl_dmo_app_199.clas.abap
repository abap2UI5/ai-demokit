CLASS z2ui5_cl_dmo_app_199 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        productid    TYPE string,
        name         TYPE string,
        suppliername TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_dmo_app_199 IMPLEMENTATION.

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
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`

        )->open( `Page`
            )->a( n = `showHeader` v = `false`
            )->a( n = `class`      v = `sapUiContentPadding`

            )->open( `content`
                )->open( `ComboBox`
                    )->a( n = `items` v = |\{ path: '{ client->_bind( val = t_products path = abap_true ) }', sorter: \{ path: 'SUPPLIERNAME', descending: false, group: true \} \}|

                    )->leaf( n = `Item` ns = `core`
                        )->a( n = `key`  v = `{PRODUCTID}`
                        )->a( n = `text` v = `{NAME}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " full mock /ProductCollection (sap/ui/demo/mock/products.json) of the original sample
    t_products = VALUE #(
      ( productid  = `HT-1000` name = `Notebook Basic 15`                                  suppliername  = `Very Best Screens` )
      ( productid  = `HT-1001` name = `Notebook Basic 17`                                  suppliername  = `Very Best Screens` )
      ( productid  = `HT-1002` name = `Notebook Basic 18`                                  suppliername  = `Very Best Screens` )
      ( productid  = `HT-1003` name = `Notebook Basic 19`                                  suppliername  = `Smartcards`        )
      ( productid  = `HT-1007` name = `ITelO Vault`                                        suppliername  = `Technocom`         )
      ( productid  = `HT-1010` name = `Notebook Professional 15`                           suppliername  = `Very Best Screens` )
      ( productid  = `HT-1011` name = `Notebook Professional 17`                           suppliername  = `Very Best Screens` )
      ( productid  = `HT-1020` name = `ITelO Vault Net`                                    suppliername  = `Technocom`         )
      ( productid  = `HT-1021` name = `ITelO Vault SAT`                                    suppliername  = `Technocom`         )
      ( productid  = `HT-1022` name = `Comfort Easy`                                       suppliername  = `Technocom`         )
      ( productid  = `HT-1023` name = `Comfort Senior`                                     suppliername  = `Technocom`         )
      ( productid  = `HT-1030` name = `Ergo Screen E-I`                                    suppliername  = `Very Best Screens` )
      ( productid  = `HT-1031` name = `Ergo Screen E-II`                                   suppliername  = `Very Best Screens` )
      ( productid  = `HT-1032` name = `Ergo Screen E-III`                                  suppliername  = `Very Best Screens` )
      ( productid  = `HT-1035` name = `Flat Basic`                                         suppliername  = `Very Best Screens` )
      ( productid  = `HT-1036` name = `Flat Future`                                        suppliername  = `Very Best Screens` )
      ( productid  = `HT-1037` name = `Flat XL`                                            suppliername  = `Very Best Screens` )
      ( productid  = `HT-1040` name = `Laser Professional Eco`                             suppliername  = `Alpha Printers`    )
      ( productid  = `HT-1041` name = `Laser Basic`                                        suppliername  = `Alpha Printers`    )
      ( productid  = `HT-1042` name = `Laser Allround`                                     suppliername  = `Alpha Printers`    )
      ( productid  = `HT-1050` name = `Ultra Jet Super Color`                              suppliername  = `Alpha Printers`    )
      ( productid  = `HT-1051` name = `Ultra Jet Mobile`                                   suppliername  = `Printer for All`   )
      ( productid  = `HT-1052` name = `Ultra Jet Super Highspeed`                          suppliername  = `Printer for All`   )
      ( productid  = `HT-1055` name = `Multi Print`                                        suppliername  = `Printer for All`   )
      ( productid  = `HT-1056` name = `Multi Color`                                        suppliername  = `Printer for All`   )
      ( productid  = `HT-1060` name = `Cordless Mouse`                                     suppliername  = `Oxynum`            )
      ( productid  = `HT-1061` name = `Speed Mouse`                                        suppliername  = `Oxynum`            )
      ( productid  = `HT-1062` name = `Track Mouse`                                        suppliername  = `Oxynum`            )
      ( productid  = `HT-1063` name = `Ergonomic Keyboard`                                 suppliername  = `Oxynum`            )
      ( productid  = `HT-1064` name = `Internet Keyboard`                                  suppliername  = `Oxynum`            )
      ( productid  = `HT-1065` name = `Media Keyboard`                                     suppliername  = `Oxynum`            )
      ( productid  = `HT-1066` name = `Mousepad`                                           suppliername  = `Oxynum`            )
      ( productid  = `HT-1067` name = `Ergo Mousepad`                                      suppliername  = `Oxynum`            )
      ( productid  = `HT-1068` name = `Designer Mousepad`                                  suppliername  = `Fasttech`          )
      ( productid  = `HT-1069` name = `Universal card reader`                              suppliername  = `Fasttech`          )
      ( productid  = `HT-1070` name = `Proctra X`                                          suppliername  = `Ultrasonic United` )
      ( productid  = `HT-1071` name = `Gladiator MX`                                       suppliername  = `Ultrasonic United` )
      ( productid  = `HT-1072` name = `Hurricane GX`                                       suppliername  = `Ultrasonic United` )
      ( productid  = `HT-1073` name = `Hurricane GX/LN`                                    suppliername  = `Smartcards`        )
      ( productid  = `HT-1080` name = `Photo Scan`                                         suppliername  = `Printer for All`   )
      ( productid  = `HT-1081` name = `Power Scan`                                         suppliername  = `Printer for All`   )
      ( productid  = `HT-1082` name = `Jet Scan Professional`                              suppliername  = `Printer for All`   )
      ( productid  = `HT-1083` name = `Jet Scan Professional`                              suppliername  = `Printer for All`   )
      ( productid  = `HT-1085` name = `Copymaster`                                         suppliername  = `Alpha Printers`    )
      ( productid  = `HT-1090` name = `Surround Sound`                                     suppliername  = `Speaker Experts`   )
      ( productid  = `HT-1091` name = `Blaster Extreme`                                    suppliername  = `Speaker Experts`   )
      ( productid  = `HT-1092` name = `Sound Booster`                                      suppliername  = `Speaker Experts`   )
      ( productid  = `HT-1095` name = `Lovely Sound 5.1 Wireless`                          suppliername  = `Fasttech`          )
      ( productid  = `HT-1096` name = `Lovely Sound 5.1`                                   suppliername  = `Fasttech`          )
      ( productid  = `HT-1097` name = `Lovely Sound Stereo`                                suppliername  = `Fasttech`          )
      ( productid  = `HT-1100` name = `Smart Office`                                       suppliername  = `Technocom`         )
      ( productid  = `HT-1101` name = `Smart Design`                                       suppliername  = `Technocom`         )
      ( productid  = `HT-1102` name = `Smart Network`                                      suppliername  = `Technocom`         )
      ( productid  = `HT-1103` name = `Smart Multimedia`                                   suppliername  = `Technocom`         )
      ( productid  = `HT-1104` name = `Smart Games`                                        suppliername  = `Technocom`         )
      ( productid  = `HT-1105` name = `Smart Internet Antivirus`                           suppliername  = `Brainsoft`         )
      ( productid  = `HT-1106` name = `Smart Firewall`                                     suppliername  = `Brainsoft`         )
      ( productid  = `HT-1107` name = `Smart Money`                                        suppliername  = `Brainsoft`         )
      ( productid  = `HT-1110` name = `PC Lock`                                            suppliername  = `Red Point Stores`  )
      ( productid  = `HT-1111` name = `Notebook Lock`                                      suppliername  = `Red Point Stores`  )
      ( productid  = `HT-1112` name = `Web cam reality`                                    suppliername  = `Red Point Stores`  )
      ( productid  = `HT-1113` name = `Screen clean`                                       suppliername  = `Red Point Stores`  )
      ( productid  = `HT-1114` name = `Fabric bag professional`                            suppliername  = `Red Point Stores`  )
      ( productid  = `HT-1115` name = `Wireless DSL Router`                                suppliername  = `Red Point Stores`  )
      ( productid  = `HT-1116` name = `Wireless DSL Router / Repeater`                     suppliername  = `Red Point Stores`  )
      ( productid  = `HT-1117` name = `Wireless DSL Router / Repeater and Print Server`    suppliername  = `Technocom`         )
      ( productid  = `HT-1118` name = `USB Stick`                                          suppliername  = `Technocom`         )
      ( productid  = `HT-1119` name = `Travel Adapter`                                     suppliername  = `Titanium`          )
      ( productid  = `HT-1120` name = `Cordless Bluetooth Keyboard, english international` suppliername  = `Technocom`         )
      ( productid  = `HT-1137` name = `Flat XXL`                                           suppliername  = `Technocom`         )
      ( productid  = `HT-1138` name = `Pocket Mouse`                                       suppliername  = `Technocom`         )
      ( productid  = `HT-1210` name = `PC Power Station`                                   suppliername  = `Technocom`         )
      ( productid  = `HT-1251` name = `Astro Laptop 1516`                                  suppliername  = `Ultrasonic United` )
      ( productid  = `HT-1252` name = `Astro Phone 6`                                      suppliername  = `Ultrasonic United` )
      ( productid  = `HT-1253` name = `Benda Laptop 1408`                                  suppliername  = `Ultrasonic United` )
      ( productid  = `HT-1254` name = `Bending Screen 21HD`                                suppliername  = `Ultrasonic United` )
      ( productid  = `HT-1255` name = `Broad Screen 22HD`                                  suppliername  = `Ultrasonic United` )
      ( productid  = `HT-1256` name = `Cerdik Phone 7`                                     suppliername  = `Ultrasonic United` )
      ( productid  = `HT-1257` name = `Cepat Tablet 10.5`                                  suppliername  = `Ultrasonic United` )
      ( productid  = `HT-1258` name = `Cepat Tablet 8`                                     suppliername  = `Ultrasonic United` )
      ( productid  = `HT-1500` name = `Server Basic`                                       suppliername  = `Technocom`         )
      ( productid  = `HT-1501` name = `Server Professional`                                suppliername  = `Technocom`         )
      ( productid  = `HT-1502` name = `Server Power Pro`                                   suppliername  = `Technocom`         )
      ( productid  = `HT-1600` name = `Family PC Basic`                                    suppliername  = `Titanium`          )
      ( productid  = `HT-1601` name = `Family PC Pro`                                      suppliername  = `Titanium`          )
      ( productid  = `HT-1602` name = `Gaming Monster`                                     suppliername  = `Titanium`          )
      ( productid  = `HT-1603` name = `Gaming Monster Pro`                                 suppliername  = `Titanium`          )
      ( productid  = `HT-2000` name = `7" Widescreen Portable DVD Player w MP3`            suppliername  = `Titanium`          )
      ( productid  = `HT-2001` name = `10" Portable DVD player`                            suppliername  = `Titanium`          )
      ( productid  = `HT-2002` name = `Portable DVD Player with 9" LCD Monitor`            suppliername  = `Technocom`         )
      ( productid  = `HT-2025` name = `CD/DVD case: 264 sleeves`                           suppliername  = `Titanium`          )
      ( productid  = `HT-2026` name = `Audio/Video Cable Kit - 4m`                         suppliername  = `Titanium`          )
      ( productid  = `HT-2027` name = `Removable CD/DVD Laser Labels`                      suppliername  = `Titanium`          )
      ( productid  = `HT-6100` name = `Beam Breaker B-1`                                   suppliername  = `Titanium`          )
      ( productid  = `HT-6101` name = `Beam Breaker B-2`                                   suppliername  = `Technocom`         )
      ( productid  = `HT-6102` name = `Beam Breaker B-3`                                   suppliername  = `Technocom`         )
      ( productid  = `HT-6110` name = `Play Movie`                                         suppliername  = `Fasttech`          )
      ( productid  = `HT-6111` name = `Record Movie`                                       suppliername  = `Fasttech`          )
      ( productid  = `HT-6120` name = `ITelo MusicStick`                                   suppliername  = `Fasttech`          )
      ( productid  = `HT-6121` name = `ITelo Jog-Mate`                                     suppliername  = `Fasttech`          )
      ( productid  = `HT-6122` name = `Power Pro Player 40`                                suppliername  = `Fasttech`          )
      ( productid  = `HT-6123` name = `Power Pro Player 80`                                suppliername  = `Fasttech`          )
      ( productid  = `HT-6130` name = `Flat Watch HD32`                                    suppliername  = `Very Best Screens` )
      ( productid  = `HT-6131` name = `Flat Watch HD37`                                    suppliername  = `Very Best Screens` )
      ( productid  = `HT-6132` name = `Flat Watch HD41`                                    suppliername  = `Very Best Screens` )
      ( productid  = `HT-7000` name = `Copperberry`                                        suppliername  = `Fasttech`          )
      ( productid  = `HT-7010` name = `Silverberry`                                        suppliername  = `Fasttech`          )
      ( productid  = `HT-7020` name = `Goldberry`                                          suppliername  = `Fasttech`          )
      ( productid  = `HT-7030` name = `Platinberry`                                        suppliername  = `Fasttech`          )
      ( productid  = `HT-8000` name = `ITelO FlexTop I4000`                                suppliername  = `Titanium`          )
      ( productid  = `HT-8001` name = `ITelO FlexTop I6300c`                               suppliername  = `Titanium`          )
      ( productid  = `HT-8002` name = `ITelO FlexTop I9100`                                suppliername  = `Titanium`          )
      ( productid  = `HT-8003` name = `ITelO FlexTop I9800`                                suppliername  = `Titanium`          )
      ( productid  = `HT-9991` name = `Smartphone Leather Case`                            suppliername  = `Ultrasonic United` )
      ( productid  = `HT-9992` name = `Smartphone Alpha`                                   suppliername  = `Ultrasonic United` )
      ( productid  = `HT-9993` name = `Mini Tablet`                                        suppliername  = `Ultrasonic United` )
      ( productid  = `HT-9994` name = `Camcorder View`                                     suppliername  = `Ultrasonic United` )
      ( productid  = `HT-9995` name = `Tablet Pouch`                                       suppliername  = `Titanium`          )
      ( productid  = `HT-9996` name = `Tablet Pouch`                                       suppliername  = `Titanium`          )
      ( productid  = `HT-9997` name = `e-Book Reader ReadMe`                               suppliername  = `Titanium`          )
      ( productid  = `HT-9998` name = `Smartphone Beta`                                    suppliername  = `Titanium`          )
      ( productid  = `HT-9999` name = `Maxi Tablet`                                        suppliername  = `Titanium`          )
      ( productid  = `PF-1000` name = `Flyer`                                              suppliername  = `Titanium`          ) ).

  ENDMETHOD.

ENDCLASS.
