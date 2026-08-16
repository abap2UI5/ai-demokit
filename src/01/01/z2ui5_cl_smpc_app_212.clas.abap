" @keywords standardlistitem standard list item sap.m
CLASS z2ui5_cl_smpc_app_212 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_212 IMPLEMENTATION.

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
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( `List`
            )->a( n = `id`         v = `ShortProductList`
            )->a( n = `headerText` v = `Products`
            )->a( n = `items`      v = |\{ path: '{ client->_bind( val = t_products path = abap_true ) }', sorter: \{ path: 'NAME' \} \}|

            )->ele( `items`
                )->tag( `StandardListItem`
                    )->a( n = `title` v = `{NAME}`

            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " full mock /ProductCollection (sap/ui/demo/mock/products.json)
    t_products = VALUE #(
      ( name = `Notebook Basic 15`                                  )
      ( name = `Notebook Basic 17`                                  )
      ( name = `Notebook Basic 18`                                  )
      ( name = `Notebook Basic 19`                                  )
      ( name = `ITelO Vault`                                        )
      ( name = `Notebook Professional 15`                           )
      ( name = `Notebook Professional 17`                           )
      ( name = `ITelO Vault Net`                                    )
      ( name = `ITelO Vault SAT`                                    )
      ( name = `Comfort Easy`                                       )
      ( name = `Comfort Senior`                                     )
      ( name = `Ergo Screen E-I`                                    )
      ( name = `Ergo Screen E-II`                                   )
      ( name = `Ergo Screen E-III`                                  )
      ( name = `Flat Basic`                                         )
      ( name = `Flat Future`                                        )
      ( name = `Flat XL`                                            )
      ( name = `Laser Professional Eco`                             )
      ( name = `Laser Basic`                                        )
      ( name = `Laser Allround`                                     )
      ( name = `Ultra Jet Super Color`                              )
      ( name = `Ultra Jet Mobile`                                   )
      ( name = `Ultra Jet Super Highspeed`                          )
      ( name = `Multi Print`                                        )
      ( name = `Multi Color`                                        )
      ( name = `Cordless Mouse`                                     )
      ( name = `Speed Mouse`                                        )
      ( name = `Track Mouse`                                        )
      ( name = `Ergonomic Keyboard`                                 )
      ( name = `Internet Keyboard`                                  )
      ( name = `Media Keyboard`                                     )
      ( name = `Mousepad`                                           )
      ( name = `Ergo Mousepad`                                      )
      ( name = `Designer Mousepad`                                  )
      ( name = `Universal card reader`                              )
      ( name = `Proctra X`                                          )
      ( name = `Gladiator MX`                                       )
      ( name = `Hurricane GX`                                       )
      ( name = `Hurricane GX/LN`                                    )
      ( name = `Photo Scan`                                         )
      ( name = `Power Scan`                                         )
      ( name = `Jet Scan Professional`                              )
      ( name = `Jet Scan Professional`                              )
      ( name = `Copymaster`                                         )
      ( name = `Surround Sound`                                     )
      ( name = `Blaster Extreme`                                    )
      ( name = `Sound Booster`                                      )
      ( name = `Lovely Sound 5.1 Wireless`                          )
      ( name = `Lovely Sound 5.1`                                   )
      ( name = `Lovely Sound Stereo`                                )
      ( name = `Smart Office`                                       )
      ( name = `Smart Design`                                       )
      ( name = `Smart Network`                                      )
      ( name = `Smart Multimedia`                                   )
      ( name = `Smart Games`                                        )
      ( name = `Smart Internet Antivirus`                           )
      ( name = `Smart Firewall`                                     )
      ( name = `Smart Money`                                        )
      ( name = `PC Lock`                                            )
      ( name = `Notebook Lock`                                      )
      ( name = `Web cam reality`                                    )
      ( name = `Screen clean`                                       )
      ( name = `Fabric bag professional`                            )
      ( name = `Wireless DSL Router`                                )
      ( name = `Wireless DSL Router / Repeater`                     )
      ( name = `Wireless DSL Router / Repeater and Print Server`    )
      ( name = `USB Stick`                                          )
      ( name = `Travel Adapter`                                     )
      ( name = `Cordless Bluetooth Keyboard, english international` )
      ( name = `Flat XXL`                                           )
      ( name = `Pocket Mouse`                                       )
      ( name = `PC Power Station`                                   )
      ( name = `Astro Laptop 1516`                                  )
      ( name = `Astro Phone 6`                                      )
      ( name = `Benda Laptop 1408`                                  )
      ( name = `Bending Screen 21HD`                                )
      ( name = `Broad Screen 22HD`                                  )
      ( name = `Cerdik Phone 7`                                     )
      ( name = `Cepat Tablet 10.5`                                  )
      ( name = `Cepat Tablet 8`                                     )
      ( name = `Server Basic`                                       )
      ( name = `Server Professional`                                )
      ( name = `Server Power Pro`                                   )
      ( name = `Family PC Basic`                                    )
      ( name = `Family PC Pro`                                      )
      ( name = `Gaming Monster`                                     )
      ( name = `Gaming Monster Pro`                                 )
      ( name = `7" Widescreen Portable DVD Player w MP3`            )
      ( name = `10" Portable DVD player`                            )
      ( name = `Portable DVD Player with 9" LCD Monitor`            )
      ( name = `CD/DVD case: 264 sleeves`                           )
      ( name = `Audio/Video Cable Kit - 4m`                         )
      ( name = `Removable CD/DVD Laser Labels`                      )
      ( name = `Beam Breaker B-1`                                   )
      ( name = `Beam Breaker B-2`                                   )
      ( name = `Beam Breaker B-3`                                   )
      ( name = `Play Movie`                                         )
      ( name = `Record Movie`                                       )
      ( name = `ITelo MusicStick`                                   )
      ( name = `ITelo Jog-Mate`                                     )
      ( name = `Power Pro Player 40`                                )
      ( name = `Power Pro Player 80`                                )
      ( name = `Flat Watch HD32`                                    )
      ( name = `Flat Watch HD37`                                    )
      ( name = `Flat Watch HD41`                                    )
      ( name = `Copperberry`                                        )
      ( name = `Silverberry`                                        )
      ( name = `Goldberry`                                          )
      ( name = `Platinberry`                                        )
      ( name = `ITelO FlexTop I4000`                                )
      ( name = `ITelO FlexTop I6300c`                               )
      ( name = `ITelO FlexTop I9100`                                )
      ( name = `ITelO FlexTop I9800`                                )
      ( name = `Smartphone Leather Case`                            )
      ( name = `Smartphone Alpha`                                   )
      ( name = `Mini Tablet`                                        )
      ( name = `Camcorder View`                                     )
      ( name = `Tablet Pouch`                                       )
      ( name = `Tablet Pouch`                                       )
      ( name = `e-Book Reader ReadMe`                               )
      ( name = `Smartphone Beta`                                    )
      ( name = `Maxi Tablet`                                        )
      ( name = `Flyer`                                              ) ).

  ENDMETHOD.

ENDCLASS.
