CLASS z2ui5_cl_ai_app_034 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name     TYPE string,
        quantity TYPE i,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_034 IMPLEMENTATION.

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
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->open( `List`
            )->a( n = `headerText`  v = `Products`
            )->a( n = `headerLevel` v = `H2`
            )->a( n = `items`       v = client->_bind( t_products )

            )->leaf( `StandardListItem`
                )->a( n = `title`   v = `{NAME}`
                )->a( n = `counter` v = `{QUANTITY}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " Data taken 1:1 from the shared mock data sap/ui/demo/mock/products.json of the original sample
    t_products = VALUE #(
      ( name = `Notebook Basic 15`                                  quantity = 10 )
      ( name = `Notebook Basic 17`                                  quantity = 20 )
      ( name = `Notebook Basic 18`                                  quantity = 10 )
      ( name = `Notebook Basic 19`                                  quantity = 15 )
      ( name = `ITelO Vault`                                        quantity = 15 )
      ( name = `Notebook Professional 15`                           quantity = 16 )
      ( name = `Notebook Professional 17`                           quantity = 17 )
      ( name = `ITelO Vault Net`                                    quantity = 14 )
      ( name = `ITelO Vault SAT`                                    quantity = 50 )
      ( name = `Comfort Easy`                                       quantity = 30 )
      ( name = `Comfort Senior`                                     quantity = 24 )
      ( name = `Ergo Screen E-I`                                    quantity = 14 )
      ( name = `Ergo Screen E-II`                                   quantity = 24 )
      ( name = `Ergo Screen E-III`                                  quantity = 50 )
      ( name = `Flat Basic`                                         quantity = 23 )
      ( name = `Flat Future`                                        quantity = 22 )
      ( name = `Flat XL`                                            quantity = 23 )
      ( name = `Laser Professional Eco`                             quantity = 21 )
      ( name = `Laser Basic`                                        quantity = 8 )
      ( name = `Laser Allround`                                     quantity = 9 )
      ( name = `Ultra Jet Super Color`                              quantity = 17 )
      ( name = `Ultra Jet Mobile`                                   quantity = 18 )
      ( name = `Ultra Jet Super Highspeed`                          quantity = 25 )
      ( name = `Multi Print`                                        quantity = 16 )
      ( name = `Multi Color`                                        quantity = 5 )
      ( name = `Cordless Mouse`                                     quantity = 25 )
      ( name = `Speed Mouse`                                        quantity = 12 )
      ( name = `Track Mouse`                                        quantity = 12 )
      ( name = `Ergonomic Keyboard`                                 quantity = 50 )
      ( name = `Internet Keyboard`                                  quantity = 35 )
      ( name = `Media Keyboard`                                     quantity = 26 )
      ( name = `Mousepad`                                           quantity = 12 )
      ( name = `Ergo Mousepad`                                      quantity = 16 )
      ( name = `Designer Mousepad`                                  quantity = 26 )
      ( name = `Universal card reader`                              quantity = 22 )
      ( name = `Proctra X`                                          quantity = 15 )
      ( name = `Gladiator MX`                                       quantity = 16 )
      ( name = `Hurricane GX`                                       quantity = 13 )
      ( name = `Hurricane GX/LN`                                    quantity = 5 )
      ( name = `Photo Scan`                                         quantity = 8 )
      ( name = `Power Scan`                                         quantity = 11 )
      ( name = `Jet Scan Professional`                              quantity = 13 )
      ( name = `Jet Scan Professional`                              quantity = 10 )
      ( name = `Copymaster`                                         quantity = 10 )
      ( name = `Surround Sound`                                     quantity = 20 )
      ( name = `Blaster Extreme`                                    quantity = 15 )
      ( name = `Sound Booster`                                      quantity = 50 )
      ( name = `Lovely Sound 5.1 Wireless`                          quantity = 12 )
      ( name = `Lovely Sound 5.1`                                   quantity = 18 )
      ( name = `Lovely Sound Stereo`                                quantity = 21 )
      ( name = `Smart Office`                                       quantity = 25 )
      ( name = `Smart Design`                                       quantity = 26 )
      ( name = `Smart Network`                                      quantity = 28 )
      ( name = `Smart Multimedia`                                   quantity = 9 )
      ( name = `Smart Games`                                        quantity = 13 )
      ( name = `Smart Internet Antivirus`                           quantity = 17 )
      ( name = `Smart Firewall`                                     quantity = 19 )
      ( name = `Smart Money`                                        quantity = 18 )
      ( name = `PC Lock`                                            quantity = 14 )
      ( name = `Notebook Lock`                                      quantity = 20 )
      ( name = `Web cam reality`                                    quantity = 27 )
      ( name = `Screen clean`                                       quantity = 17 )
      ( name = `Fabric bag professional`                            quantity = 14 )
      ( name = `Wireless DSL Router`                                quantity = 16 )
      ( name = `Wireless DSL Router / Repeater`                     quantity = 12 )
      ( name = `Wireless DSL Router / Repeater and Print Server`    quantity = 12 )
      ( name = `USB Stick`                                          quantity = 14 )
      ( name = `Travel Adapter`                                     quantity = 10 )
      ( name = `Cordless Bluetooth Keyboard, english international` quantity = 13 )
      ( name = `Flat XXL`                                           quantity = 10 )
      ( name = `Pocket Mouse`                                       quantity = 20 )
      ( name = `PC Power Station`                                   quantity = 22 )
      ( name = `Astro Laptop 1516`                                  quantity = 23 )
      ( name = `Astro Phone 6`                                      quantity = 28 )
      ( name = `Benda Laptop 1408`                                  quantity = 27 )
      ( name = `Bending Screen 21HD`                                quantity = 23 )
      ( name = `Broad Screen 22HD`                                  quantity = 5 )
      ( name = `Cerdik Phone 7`                                     quantity = 19 )
      ( name = `Cepat Tablet 10.5`                                  quantity = 17 )
      ( name = `Cepat Tablet 8`                                     quantity = 24 )
      ( name = `Server Basic`                                       quantity = 24 )
      ( name = `Server Professional`                                quantity = 26 )
      ( name = `Server Power Pro`                                   quantity = 34 )
      ( name = `Family PC Basic`                                    quantity = 10 )
      ( name = `Family PC Pro`                                      quantity = 20 )
      ( name = `Gaming Monster`                                     quantity = 24 )
      ( name = `Gaming Monster Pro`                                 quantity = 25 )
      ( name = `7" Widescreen Portable DVD Player w MP3`            quantity = 20 )
      ( name = `10" Portable DVD player`                            quantity = 21 )
      ( name = `Portable DVD Player with 9" LCD Monitor`            quantity = 50 )
      ( name = `CD/DVD case: 264 sleeves`                           quantity = 26 )
      ( name = `Audio/Video Cable Kit - 4m`                         quantity = 16 )
      ( name = `Removable CD/DVD Laser Labels`                      quantity = 25 )
      ( name = `Beam Breaker B-1`                                   quantity = 32 )
      ( name = `Beam Breaker B-2`                                   quantity = 18 )
      ( name = `Beam Breaker B-3`                                   quantity = 16 )
      ( name = `Play Movie`                                         quantity = 15 )
      ( name = `Record Movie`                                       quantity = 24 )
      ( name = `ITelo MusicStick`                                   quantity = 15 )
      ( name = `ITelo Jog-Mate`                                     quantity = 24 )
      ( name = `Power Pro Player 40`                                quantity = 23 )
      ( name = `Power Pro Player 80`                                quantity = 13 )
      ( name = `Flat Watch HD32`                                    quantity = 16 )
      ( name = `Flat Watch HD37`                                    quantity = 14 )
      ( name = `Flat Watch HD41`                                    quantity = 13 )
      ( name = `Copperberry`                                        quantity = 5 )
      ( name = `Silverberry`                                        quantity = 9 )
      ( name = `Goldberry`                                          quantity = 11 )
      ( name = `Platinberry`                                        quantity = 12 )
      ( name = `ITelO FlexTop I4000`                                quantity = 11 )
      ( name = `ITelO FlexTop I6300c`                               quantity = 20 )
      ( name = `ITelO FlexTop I9100`                                quantity = 20 )
      ( name = `ITelO FlexTop I9800`                                quantity = 22 )
      ( name = `Smartphone Leather Case`                            quantity = 12 )
      ( name = `Smartphone Alpha`                                   quantity = 13 )
      ( name = `Mini Tablet`                                        quantity = 10 )
      ( name = `Camcorder View`                                     quantity = 50 )
      ( name = `Tablet Pouch`                                       quantity = 34 )
      ( name = `Tablet Pouch`                                       quantity = 34 )
      ( name = `e-Book Reader ReadMe`                               quantity = 23 )
      ( name = `Smartphone Beta`                                    quantity = 21 )
      ( name = `Maxi Tablet`                                        quantity = 20 )
      ( name = `Flyer`                                              quantity = 33 ) ).

  ENDMETHOD.

ENDCLASS.
