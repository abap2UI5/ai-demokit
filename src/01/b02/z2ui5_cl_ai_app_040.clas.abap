CLASS z2ui5_cl_ai_app_040 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        product_id TYPE string,
        name       TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_040 IMPLEMENTATION.

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
        )->a( n = `height`      v = `100%`
        )->a( n = `xmlns`       v = `sap.m`
        )->a( n = `xmlns:mvc`   v = `sap.ui.core.mvc`
        )->a( n = `xmlns:l`     v = `sap.ui.layout`
        )->a( n = `xmlns:core`  v = `sap.ui.core`
        )->a( n = `xmlns:z2ui5` v = `z2ui5.cc`

        )->open( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->leaf( `Label`
                )->a( n = `text`     v = `Enter a search term, e.g. “Notebook”, and add matching products as tokens`
                )->a( n = `width`    v = `100%`
                )->a( n = `labelFor` v = `multiInput`

            )->open( `MultiInput`
                )->a( n = `width`           v = `70%`
                )->a( n = `showClearIcon`   v = `true`
                )->a( n = `id`              v = `multiInput`
                )->a( n = `suggestionItems` v = |\{ path: '{ client->_bind( val = t_products path = abap_true ) }', sorter: \{ path: 'NAME' \} \}|
                )->a( n = `placeholder`     v = `Products...`
                )->a( n = `showValueHelp`   v = `false`

                )->leaf( n = `Item` ns = `core`
                    )->a( n = `key`  v = `{PRODUCT_ID}`
                    )->a( n = `text` v = `{NAME}`

            )->shut(
            )->leaf( `Label`
                )->a( n = `text`     v = `MultiInput with pre-selected tokens`
                )->a( n = `labelFor` v = `multiInput1`

            " the tokens the original controller pre-sets in onInit
            )->open( `MultiInput`
                )->a( n = `id`             v = `multiInput1`
                )->a( n = `showSuggestion` v = `false`
                )->a( n = `width`          v = `70%`
                )->a( n = `showValueHelp`  v = `false`

                )->open( `tokens`
                    )->leaf( `Token`
                        )->a( n = `key`  v = `0001`
                        )->a( n = `text` v = `Token 1`
                    )->leaf( `Token`
                        )->a( n = `key`  v = `0002`
                        )->a( n = `text` v = `Token 2`
                    )->leaf( `Token`
                        )->a( n = `key`  v = `0003`
                        )->a( n = `text` v = `Token 3`
                    )->leaf( `Token`
                        )->a( n = `key`  v = `0004`
                        )->a( n = `text` v = `Token 4`
                    )->leaf( `Token`
                        )->a( n = `key`  v = `0005`
                        )->a( n = `text` v = `Token 5`
                    )->leaf( `Token`
                        )->a( n = `key`  v = `0006`
                        )->a( n = `text` v = `Token 6`

                )->shut(
            )->shut(
            " original onInit addValidator on multiInput1, installed by the invisible z2ui5.cc.MultiInputExt companion
            )->leaf( n = `MultiInputExt` ns = `z2ui5`
                )->a( n = `MultiInputId` v = `multiInput1`
            )->leaf( `Label`
                )->a( n = `text`     v = `MultiInput with single long token`
                )->a( n = `labelFor` v = `multiInput2`

            )->open( `MultiInput`
                )->a( n = `id`             v = `multiInput2`
                )->a( n = `showSuggestion` v = `false`
                )->a( n = `width`          v = `300px`
                )->a( n = `showValueHelp`  v = `false`

                )->open( `tokens`
                    )->leaf( `Token`
                        )->a( n = `key`  v = `longText`
                        )->a( n = `text` v = `Very long long long long long long long text`

                )->shut(
            )->shut(
            " same validator on multiInput2, as in the original onInit
            )->leaf( n = `MultiInputExt` ns = `z2ui5`
                )->a( n = `MultiInputId` v = `multiInput2` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " full mock /ProductCollection (sap/ui/demo/mock/products.json) of the original sample
    t_products = VALUE #(
      ( product_id = `HT-1000` name = `Notebook Basic 15`                                  )
      ( product_id = `HT-1001` name = `Notebook Basic 17`                                  )
      ( product_id = `HT-1002` name = `Notebook Basic 18`                                  )
      ( product_id = `HT-1003` name = `Notebook Basic 19`                                  )
      ( product_id = `HT-1007` name = `ITelO Vault`                                        )
      ( product_id = `HT-1010` name = `Notebook Professional 15`                           )
      ( product_id = `HT-1011` name = `Notebook Professional 17`                           )
      ( product_id = `HT-1020` name = `ITelO Vault Net`                                    )
      ( product_id = `HT-1021` name = `ITelO Vault SAT`                                    )
      ( product_id = `HT-1022` name = `Comfort Easy`                                       )
      ( product_id = `HT-1023` name = `Comfort Senior`                                     )
      ( product_id = `HT-1030` name = `Ergo Screen E-I`                                    )
      ( product_id = `HT-1031` name = `Ergo Screen E-II`                                   )
      ( product_id = `HT-1032` name = `Ergo Screen E-III`                                  )
      ( product_id = `HT-1035` name = `Flat Basic`                                         )
      ( product_id = `HT-1036` name = `Flat Future`                                        )
      ( product_id = `HT-1037` name = `Flat XL`                                            )
      ( product_id = `HT-1040` name = `Laser Professional Eco`                             )
      ( product_id = `HT-1041` name = `Laser Basic`                                        )
      ( product_id = `HT-1042` name = `Laser Allround`                                     )
      ( product_id = `HT-1050` name = `Ultra Jet Super Color`                              )
      ( product_id = `HT-1051` name = `Ultra Jet Mobile`                                   )
      ( product_id = `HT-1052` name = `Ultra Jet Super Highspeed`                          )
      ( product_id = `HT-1055` name = `Multi Print`                                        )
      ( product_id = `HT-1056` name = `Multi Color`                                        )
      ( product_id = `HT-1060` name = `Cordless Mouse`                                     )
      ( product_id = `HT-1061` name = `Speed Mouse`                                        )
      ( product_id = `HT-1062` name = `Track Mouse`                                        )
      ( product_id = `HT-1063` name = `Ergonomic Keyboard`                                 )
      ( product_id = `HT-1064` name = `Internet Keyboard`                                  )
      ( product_id = `HT-1065` name = `Media Keyboard`                                     )
      ( product_id = `HT-1066` name = `Mousepad`                                           )
      ( product_id = `HT-1067` name = `Ergo Mousepad`                                      )
      ( product_id = `HT-1068` name = `Designer Mousepad`                                  )
      ( product_id = `HT-1069` name = `Universal card reader`                              )
      ( product_id = `HT-1070` name = `Proctra X`                                          )
      ( product_id = `HT-1071` name = `Gladiator MX`                                       )
      ( product_id = `HT-1072` name = `Hurricane GX`                                       )
      ( product_id = `HT-1073` name = `Hurricane GX/LN`                                    )
      ( product_id = `HT-1080` name = `Photo Scan`                                         )
      ( product_id = `HT-1081` name = `Power Scan`                                         )
      ( product_id = `HT-1082` name = `Jet Scan Professional`                              )
      ( product_id = `HT-1083` name = `Jet Scan Professional`                              )
      ( product_id = `HT-1085` name = `Copymaster`                                         )
      ( product_id = `HT-1090` name = `Surround Sound`                                     )
      ( product_id = `HT-1091` name = `Blaster Extreme`                                    )
      ( product_id = `HT-1092` name = `Sound Booster`                                      )
      ( product_id = `HT-1095` name = `Lovely Sound 5.1 Wireless`                          )
      ( product_id = `HT-1096` name = `Lovely Sound 5.1`                                   )
      ( product_id = `HT-1097` name = `Lovely Sound Stereo`                                )
      ( product_id = `HT-1100` name = `Smart Office`                                       )
      ( product_id = `HT-1101` name = `Smart Design`                                       )
      ( product_id = `HT-1102` name = `Smart Network`                                      )
      ( product_id = `HT-1103` name = `Smart Multimedia`                                   )
      ( product_id = `HT-1104` name = `Smart Games`                                        )
      ( product_id = `HT-1105` name = `Smart Internet Antivirus`                           )
      ( product_id = `HT-1106` name = `Smart Firewall`                                     )
      ( product_id = `HT-1107` name = `Smart Money`                                        )
      ( product_id = `HT-1110` name = `PC Lock`                                            )
      ( product_id = `HT-1111` name = `Notebook Lock`                                      )
      ( product_id = `HT-1112` name = `Web cam reality`                                    )
      ( product_id = `HT-1113` name = `Screen clean`                                       )
      ( product_id = `HT-1114` name = `Fabric bag professional`                            )
      ( product_id = `HT-1115` name = `Wireless DSL Router`                                )
      ( product_id = `HT-1116` name = `Wireless DSL Router / Repeater`                     )
      ( product_id = `HT-1117` name = `Wireless DSL Router / Repeater and Print Server`    )
      ( product_id = `HT-1118` name = `USB Stick`                                          )
      ( product_id = `HT-1119` name = `Travel Adapter`                                     )
      ( product_id = `HT-1120` name = `Cordless Bluetooth Keyboard, english international` )
      ( product_id = `HT-1137` name = `Flat XXL`                                           )
      ( product_id = `HT-1138` name = `Pocket Mouse`                                       )
      ( product_id = `HT-1210` name = `PC Power Station`                                   )
      ( product_id = `HT-1251` name = `Astro Laptop 1516`                                  )
      ( product_id = `HT-1252` name = `Astro Phone 6`                                      )
      ( product_id = `HT-1253` name = `Benda Laptop 1408`                                  )
      ( product_id = `HT-1254` name = `Bending Screen 21HD`                                )
      ( product_id = `HT-1255` name = `Broad Screen 22HD`                                  )
      ( product_id = `HT-1256` name = `Cerdik Phone 7`                                     )
      ( product_id = `HT-1257` name = `Cepat Tablet 10.5`                                  )
      ( product_id = `HT-1258` name = `Cepat Tablet 8`                                     )
      ( product_id = `HT-1500` name = `Server Basic`                                       )
      ( product_id = `HT-1501` name = `Server Professional`                                )
      ( product_id = `HT-1502` name = `Server Power Pro`                                   )
      ( product_id = `HT-1600` name = `Family PC Basic`                                    )
      ( product_id = `HT-1601` name = `Family PC Pro`                                      )
      ( product_id = `HT-1602` name = `Gaming Monster`                                     )
      ( product_id = `HT-1603` name = `Gaming Monster Pro`                                 )
      ( product_id = `HT-2000` name = `7" Widescreen Portable DVD Player w MP3`            )
      ( product_id = `HT-2001` name = `10" Portable DVD player`                            )
      ( product_id = `HT-2002` name = `Portable DVD Player with 9" LCD Monitor`            )
      ( product_id = `HT-2025` name = `CD/DVD case: 264 sleeves`                           )
      ( product_id = `HT-2026` name = `Audio/Video Cable Kit - 4m`                         )
      ( product_id = `HT-2027` name = `Removable CD/DVD Laser Labels`                      )
      ( product_id = `HT-6100` name = `Beam Breaker B-1`                                   )
      ( product_id = `HT-6101` name = `Beam Breaker B-2`                                   )
      ( product_id = `HT-6102` name = `Beam Breaker B-3`                                   )
      ( product_id = `HT-6110` name = `Play Movie`                                         )
      ( product_id = `HT-6111` name = `Record Movie`                                       )
      ( product_id = `HT-6120` name = `ITelo MusicStick`                                   )
      ( product_id = `HT-6121` name = `ITelo Jog-Mate`                                     )
      ( product_id = `HT-6122` name = `Power Pro Player 40`                                )
      ( product_id = `HT-6123` name = `Power Pro Player 80`                                )
      ( product_id = `HT-6130` name = `Flat Watch HD32`                                    )
      ( product_id = `HT-6131` name = `Flat Watch HD37`                                    )
      ( product_id = `HT-6132` name = `Flat Watch HD41`                                    )
      ( product_id = `HT-7000` name = `Copperberry`                                        )
      ( product_id = `HT-7010` name = `Silverberry`                                        )
      ( product_id = `HT-7020` name = `Goldberry`                                          )
      ( product_id = `HT-7030` name = `Platinberry`                                        )
      ( product_id = `HT-8000` name = `ITelO FlexTop I4000`                                )
      ( product_id = `HT-8001` name = `ITelO FlexTop I6300c`                               )
      ( product_id = `HT-8002` name = `ITelO FlexTop I9100`                                )
      ( product_id = `HT-8003` name = `ITelO FlexTop I9800`                                )
      ( product_id = `HT-9991` name = `Smartphone Leather Case`                            )
      ( product_id = `HT-9992` name = `Smartphone Alpha`                                   )
      ( product_id = `HT-9993` name = `Mini Tablet`                                        )
      ( product_id = `HT-9994` name = `Camcorder View`                                     )
      ( product_id = `HT-9995` name = `Tablet Pouch`                                       )
      ( product_id = `HT-9996` name = `Tablet Pouch`                                       )
      ( product_id = `HT-9997` name = `e-Book Reader ReadMe`                               )
      ( product_id = `HT-9998` name = `Smartphone Beta`                                    )
      ( product_id = `HT-9999` name = `Maxi Tablet`                                        )
      ( product_id = `PF-1000` name = `Flyer`                                              ) ).

  ENDMETHOD.

ENDCLASS.
