" @keywords table sap.m tablecontextualwidthdynamic messagestrip column text columnlistitem label
" @summary This example shows the container-based pop-in behavior. The container has dynamic width.
CLASS z2ui5_cl_smpc_app_277 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_product,
             name         TYPE string,
             suppliername TYPE string,
             status       TYPE string,
             quantity     TYPE i,
           END OF ty_product.
    DATA t_products TYPE STANDARD TABLE OF ty_product WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_277 IMPLEMENTATION.

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
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`

        " onBeforeRendering/_orientationHandler hide this strip on a PHONE in
        " portrait and show it again in landscape; that whole handler pair is
        " one expression binding on the shared device model, which UI5 keeps
        " current on every rotation - no round-trip, no controller
        )->tag( `MessageStrip`
            )->a( n = `id`              v = `idMessageStrip`
            )->a( n = `text`            v = `Move the splitter to see the container based popin behaviour with dynamic width.`
            )->a( n = `type`            v = `Success`
            )->a( n = `showIcon`        v = `true`
            )->a( n = `showCloseButton` v = `true`
            )->a( n = `class`           v = `sapUiMediumMarginBottom`
            )->a( n = `visible`         v = |\{= !$\{device>/system/phone\} \|\| $\{device>/orientation/landscape\} \}|

        )->ele( n = `ResponsiveSplitter` ns = `l`
            )->a( n = `height` v = `100%`

            )->ele( n = `PaneContainer` ns = `l`

                )->ele( n = `SplitPane` ns = `l`
                    )->a( n = `requiredParentWidth` v = `500`

                    )->ele( `Table`
                        )->a( n = `id`              v = `idProductsTableleft`
                        )->a( n = `contextualWidth` v = `Auto`
                        )->a( n = `popinLayout`     v = `GridSmall`
                        )->a( n = `headerText`      v = `Products`
                        )->a( n = `items`           v = |\{ path: '{ client->_bind( val = t_products path = abap_true ) }' \}|

                        )->ele( `columns`
                            )->ele( `Column`
                                )->ele( `header`
                                    )->tag( `Text`
                                        )->a( n = `text` v = `Product`

                                )->end(
                            )->end(

                            )->ele( `Column`
                                )->a( n = `minScreenWidth` v = `phone`
                                )->a( n = `demandPopin`    v = `true`

                                )->ele( `header`
                                    )->tag( `Text`
                                        )->a( n = `text` v = `Supplier`

                                )->end(
                            )->end(

                            )->ele( `Column`
                                )->a( n = `minScreenWidth` v = `tablet`
                                )->a( n = `demandPopin`    v = `true`
                                )->a( n = `hAlign`         v = `Center`

                                )->ele( `header`
                                    )->tag( `Text`
                                        )->a( n = `text` v = `Status`

                                )->end(
                            )->end(

                            )->ele( `Column`
                                )->a( n = `minScreenWidth` v = `Phone`
                                )->a( n = `demandPopin`    v = `true`
                                )->a( n = `hAlign`         v = `End`

                                )->ele( `header`
                                    )->tag( `Text`
                                        )->a( n = `text` v = `Quantity`

                                )->end(
                            )->end(
                        )->end(

                        )->ele( `items`
                            )->ele( `ColumnListItem`
                                )->ele( `cells`
                                    )->tag( `Label`
                                        )->a( n = `text` v = `{NAME}`
                                    )->tag( `Label`
                                        )->a( n = `text` v = `{SUPPLIERNAME}`
                                    )->tag( `Label`
                                        )->a( n = `text` v = `{STATUS}`
                                    )->tag( `Label`
                                        )->a( n = `text` v = `{QUANTITY}`

                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( n = `SplitPane` ns = `l`
                    )->a( n = `requiredParentWidth` v = `400`

                    )->ele( `Table`
                        )->a( n = `id`              v = `idProductsTableright`
                        )->a( n = `contextualWidth` v = `Auto`
                        )->a( n = `popinLayout`     v = `GridSmall`
                        )->a( n = `headerText`      v = `Products`
                        )->a( n = `items`           v = |\{ path: '{ client->_bind( val = t_products path = abap_true ) }' \}|

                        )->ele( `columns`
                            )->ele( `Column`
                                )->ele( `header`
                                    )->tag( `Text`
                                        )->a( n = `text` v = `Product`

                                )->end(
                            )->end(

                            )->ele( `Column`
                                )->a( n = `minScreenWidth` v = `phone`
                                )->a( n = `demandPopin`    v = `true`

                                )->ele( `header`
                                    )->tag( `Text`
                                        )->a( n = `text` v = `Supplier`

                                )->end(
                            )->end(

                            )->ele( `Column`
                                )->a( n = `minScreenWidth` v = `tablet`
                                )->a( n = `demandPopin`    v = `true`
                                )->a( n = `hAlign`         v = `Center`

                                )->ele( `header`
                                    )->tag( `Text`
                                        )->a( n = `text` v = `Status`

                                )->end(
                            )->end(

                            )->ele( `Column`
                                )->a( n = `minScreenWidth` v = `Phone`
                                )->a( n = `demandPopin`    v = `true`
                                )->a( n = `hAlign`         v = `End`

                                )->ele( `header`
                                    )->tag( `Text`
                                        )->a( n = `text` v = `Quantity`

                                )->end(
                            )->end(
                        )->end(

                        )->ele( `items`
                            )->ele( `ColumnListItem`
                                )->ele( `cells`
                                    )->tag( `Label`
                                        )->a( n = `text` v = `{NAME}`
                                    )->tag( `Label`
                                        )->a( n = `text` v = `{SUPPLIERNAME}`
                                    )->tag( `Label`
                                        )->a( n = `text` v = `{STATUS}`
                                    )->tag( `Label`
                                        )->a( n = `text` v = `{QUANTITY}`

                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                    ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " the shared demo products.json /ProductCollection, all 123 rows; the
    " ColumnListItem binds Name, SupplierName, Status and Quantity
    t_products = VALUE #(
      ( name = `Notebook Basic 15` suppliername = `Very Best Screens` status = `Available` quantity = 10 )
      ( name = `Notebook Basic 17` suppliername = `Very Best Screens` status = `Available` quantity = 20 )
      ( name = `Notebook Basic 18` suppliername = `Very Best Screens` status = `Available` quantity = 10 )
      ( name = `Notebook Basic 19` suppliername = `Smartcards` status = `Out of Stock` quantity = 15 )
      ( name = `ITelO Vault` suppliername = `Technocom` status = `Out of Stock` quantity = 15 )
      ( name = `Notebook Professional 15` suppliername = `Very Best Screens` status = `Out of Stock` quantity = 16 )
      ( name = `Notebook Professional 17` suppliername = `Very Best Screens` status = `Out of Stock` quantity = 17 )
      ( name = `ITelO Vault Net` suppliername = `Technocom` status = `Discontinued` quantity = 14 )
      ( name = `ITelO Vault SAT` suppliername = `Technocom` status = `Available` quantity = 50 )
      ( name = `Comfort Easy` suppliername = `Technocom` status = `Out of Stock` quantity = 30 )
      ( name = `Comfort Senior` suppliername = `Technocom` status = `Available` quantity = 24 )
      ( name = `Ergo Screen E-I` suppliername = `Very Best Screens` status = `Available` quantity = 14 )
      ( name = `Ergo Screen E-II` suppliername = `Very Best Screens` status = `Available` quantity = 24 )
      ( name = `Ergo Screen E-III` suppliername = `Very Best Screens` status = `Out of Stock` quantity = 50 )
      ( name = `Flat Basic` suppliername = `Very Best Screens` status = `Available` quantity = 23 )
      ( name = `Flat Future` suppliername = `Very Best Screens` status = `Available` quantity = 22 )
      ( name = `Flat XL` suppliername = `Very Best Screens` status = `Available` quantity = 23 )
      ( name = `Laser Professional Eco` suppliername = `Alpha Printers` status = `Available` quantity = 21 )
      ( name = `Laser Basic` suppliername = `Alpha Printers` status = `Available` quantity = 8 )
      ( name = `Laser Allround` suppliername = `Alpha Printers` status = `Available` quantity = 9 )
      ( name = `Ultra Jet Super Color` suppliername = `Alpha Printers` status = `Discontinued` quantity = 17 )
      ( name = `Ultra Jet Mobile` suppliername = `Printer for All` status = `Discontinued` quantity = 18 )
      ( name = `Ultra Jet Super Highspeed` suppliername = `Printer for All` status = `Available` quantity = 25 )
      ( name = `Multi Print` suppliername = `Printer for All` status = `Available` quantity = 16 )
      ( name = `Multi Color` suppliername = `Printer for All` status = `Available` quantity = 5 )
      ( name = `Cordless Mouse` suppliername = `Oxynum` status = `Available` quantity = 25 )
      ( name = `Speed Mouse` suppliername = `Oxynum` status = `Available` quantity = 12 )
      ( name = `Track Mouse` suppliername = `Oxynum` status = `Discontinued` quantity = 12 )
      ( name = `Ergonomic Keyboard` suppliername = `Oxynum` status = `Available` quantity = 50 )
      ( name = `Internet Keyboard` suppliername = `Oxynum` status = `Out of Stock` quantity = 35 )
      ( name = `Media Keyboard` suppliername = `Oxynum` status = `Available` quantity = 26 )
      ( name = `Mousepad` suppliername = `Oxynum` status = `Available` quantity = 12 )
      ( name = `Ergo Mousepad` suppliername = `Oxynum` status = `Out of Stock` quantity = 16 )
      ( name = `Designer Mousepad` suppliername = `Fasttech` status = `Available` quantity = 26 )
      ( name = `Universal card reader` suppliername = `Fasttech` status = `Available` quantity = 22 )
      ( name = `Proctra X` suppliername = `Ultrasonic United` status = `Out of Stock` quantity = 15 )
      ( name = `Gladiator MX` suppliername = `Ultrasonic United` status = `Discontinued` quantity = 16 )
      ( name = `Hurricane GX` suppliername = `Ultrasonic United` status = `Available` quantity = 13 )
      ( name = `Hurricane GX/LN` suppliername = `Smartcards` status = `Out of Stock` quantity = 5 )
      ( name = `Photo Scan` suppliername = `Printer for All` status = `Out of Stock` quantity = 8 )
      ( name = `Power Scan` suppliername = `Printer for All` status = `Out of Stock` quantity = 11 )
      ( name = `Jet Scan Professional` suppliername = `Printer for All` status = `Out of Stock` quantity = 13 )
      ( name = `Jet Scan Professional` suppliername = `Printer for All` status = `Available` quantity = 10 )
      ( name = `Copymaster` suppliername = `Alpha Printers` status = `Available` quantity = 10 )
      ( name = `Surround Sound` suppliername = `Speaker Experts` status = `Available` quantity = 20 )
      ( name = `Blaster Extreme` suppliername = `Speaker Experts` status = `Available` quantity = 15 )
      ( name = `Sound Booster` suppliername = `Speaker Experts` status = `Discontinued` quantity = 50 )
      ( name = `Lovely Sound 5.1 Wireless` suppliername = `Fasttech` status = `Available` quantity = 12 )
      ( name = `Lovely Sound 5.1` suppliername = `Fasttech` status = `Available` quantity = 18 )
      ( name = `Lovely Sound Stereo` suppliername = `Fasttech` status = `Out of Stock` quantity = 21 )
      ( name = `Smart Office` suppliername = `Technocom` status = `Out of Stock` quantity = 25 )
      ( name = `Smart Design` suppliername = `Technocom` status = `Available` quantity = 26 )
      ( name = `Smart Network` suppliername = `Technocom` status = `Available` quantity = 28 )
      ( name = `Smart Multimedia` suppliername = `Technocom` status = `Available` quantity = 9 )
      ( name = `Smart Games` suppliername = `Technocom` status = `Available` quantity = 13 )
      ( name = `Smart Internet Antivirus` suppliername = `Brainsoft` status = `Available` quantity = 17 )
      ( name = `Smart Firewall` suppliername = `Brainsoft` status = `Discontinued` quantity = 19 )
      ( name = `Smart Money` suppliername = `Brainsoft` status = `Out of Stock` quantity = 18 )
      ( name = `PC Lock` suppliername = `Red Point Stores` status = `Available` quantity = 14 )
      ( name = `Notebook Lock` suppliername = `Red Point Stores` status = `Available` quantity = 20 )
      ( name = `Web cam reality` suppliername = `Red Point Stores` status = `Out of Stock` quantity = 27 )
      ( name = `Screen clean` suppliername = `Red Point Stores` status = `Available` quantity = 17 )
      ( name = `Fabric bag professional` suppliername = `Red Point Stores` status = `Available` quantity = 14 )
      ( name = `Wireless DSL Router` suppliername = `Red Point Stores` status = `Available` quantity = 16 )
      ( name = `Wireless DSL Router / Repeater` suppliername = `Red Point Stores` status = `Out of Stock` quantity = 12 )
      ( name = `Wireless DSL Router / Repeater and Print Server` suppliername = `Technocom` status = `Available` quantity = 12 )
      ( name = `USB Stick` suppliername = `Technocom` status = `Available` quantity = 14 )
      ( name = `Travel Adapter` suppliername = `Titanium` status = `Discontinued` quantity = 10 )
      ( name = `Cordless Bluetooth Keyboard, english international` suppliername = `Technocom` status = `Out of Stock` quantity = 13 )
      ( name = `Flat XXL` suppliername = `Technocom` status = `Discontinued` quantity = 10 )
      ( name = `Pocket Mouse` suppliername = `Technocom` status = `Available` quantity = 20 )
      ( name = `PC Power Station` suppliername = `Technocom` status = `Available` quantity = 22 )
      ( name = `Astro Laptop 1516` suppliername = `Ultrasonic United` status = `Available` quantity = 23 )
      ( name = `Astro Phone 6` suppliername = `Ultrasonic United` status = `Available` quantity = 28 )
      ( name = `Benda Laptop 1408` suppliername = `Ultrasonic United` status = `Discontinued` quantity = 27 )
      ( name = `Bending Screen 21HD` suppliername = `Ultrasonic United` status = `Available` quantity = 23 )
      ( name = `Broad Screen 22HD` suppliername = `Ultrasonic United` status = `Discontinued` quantity = 5 )
      ( name = `Cerdik Phone 7` suppliername = `Ultrasonic United` status = `Discontinued` quantity = 19 )
      ( name = `Cepat Tablet 10.5` suppliername = `Ultrasonic United` status = `Available` quantity = 17 )
      ( name = `Cepat Tablet 8` suppliername = `Ultrasonic United` status = `Available` quantity = 24 )
      ( name = `Server Basic` suppliername = `Technocom` status = `Available` quantity = 24 )
      ( name = `Server Professional` suppliername = `Technocom` status = `Out of Stock` quantity = 26 )
      ( name = `Server Power Pro` suppliername = `Technocom` status = `Available` quantity = 34 )
      ( name = `Family PC Basic` suppliername = `Titanium` status = `Available` quantity = 10 )
      ( name = `Family PC Pro` suppliername = `Titanium` status = `Available` quantity = 20 )
      ( name = `Gaming Monster` suppliername = `Titanium` status = `Available` quantity = 24 )
      ( name = `Gaming Monster Pro` suppliername = `Titanium` status = `Discontinued` quantity = 25 )
      ( name = `7" Widescreen Portable DVD Player w MP3` suppliername = `Titanium` status = `Available` quantity = 20 )
      ( name = `10" Portable DVD player` suppliername = `Titanium` status = `Available` quantity = 21 )
      ( name = `Portable DVD Player with 9" LCD Monitor` suppliername = `Technocom` status = `Available` quantity = 50 )
      ( name = `CD/DVD case: 264 sleeves` suppliername = `Titanium` status = `Discontinued` quantity = 26 )
      ( name = `Audio/Video Cable Kit - 4m` suppliername = `Titanium` status = `Available` quantity = 16 )
      ( name = `Removable CD/DVD Laser Labels` suppliername = `Titanium` status = `Discontinued` quantity = 25 )
      ( name = `Beam Breaker B-1` suppliername = `Titanium` status = `Out of Stock` quantity = 32 )
      ( name = `Beam Breaker B-2` suppliername = `Technocom` status = `Available` quantity = 18 )
      ( name = `Beam Breaker B-3` suppliername = `Technocom` status = `Out of Stock` quantity = 16 )
      ( name = `Play Movie` suppliername = `Fasttech` status = `Available` quantity = 15 )
      ( name = `Record Movie` suppliername = `Fasttech` status = `Discontinued` quantity = 24 )
      ( name = `ITelo MusicStick` suppliername = `Fasttech` status = `Available` quantity = 15 )
      ( name = `ITelo Jog-Mate` suppliername = `Fasttech` status = `Available` quantity = 24 )
      ( name = `Power Pro Player 40` suppliername = `Fasttech` status = `Available` quantity = 23 )
      ( name = `Power Pro Player 80` suppliername = `Fasttech` status = `Available` quantity = 13 )
      ( name = `Flat Watch HD32` suppliername = `Very Best Screens` status = `Available` quantity = 16 )
      ( name = `Flat Watch HD37` suppliername = `Very Best Screens` status = `Available` quantity = 14 )
      ( name = `Flat Watch HD41` suppliername = `Very Best Screens` status = `Discontinued` quantity = 13 )
      ( name = `Copperberry` suppliername = `Fasttech` status = `Discontinued` quantity = 5 )
      ( name = `Silverberry` suppliername = `Fasttech` status = `Discontinued` quantity = 9 )
      ( name = `Goldberry` suppliername = `Fasttech` status = `Available` quantity = 11 )
      ( name = `Platinberry` suppliername = `Fasttech` status = `Available` quantity = 12 )
      ( name = `ITelO FlexTop I4000` suppliername = `Titanium` status = `Available` quantity = 11 )
      ( name = `ITelO FlexTop I6300c` suppliername = `Titanium` status = `Discontinued` quantity = 20 )
      ( name = `ITelO FlexTop I9100` suppliername = `Titanium` status = `Available` quantity = 20 )
      ( name = `ITelO FlexTop I9800` suppliername = `Titanium` status = `Available` quantity = 22 )
      ( name = `Smartphone Leather Case` suppliername = `Ultrasonic United` status = `Available` quantity = 12 )
      ( name = `Smartphone Alpha` suppliername = `Ultrasonic United` status = `Out of Stock` quantity = 13 )
      ( name = `Mini Tablet` suppliername = `Ultrasonic United` status = `Available` quantity = 10 )
      ( name = `Camcorder View` suppliername = `Ultrasonic United` status = `Out of Stock` quantity = 50 )
      ( name = `Tablet Pouch` suppliername = `Titanium` status = `Available` quantity = 34 )
      ( name = `Tablet Pouch` suppliername = `Titanium` status = `Available` quantity = 34 )
      ( name = `e-Book Reader ReadMe` suppliername = `Titanium` status = `Available` quantity = 23 )
      ( name = `Smartphone Beta` suppliername = `Titanium` status = `Available` quantity = 21 )
      ( name = `Maxi Tablet` suppliername = `Titanium` status = `Available` quantity = 20 )
      ( name = `Flyer` suppliername = `Titanium` status = `Out of Stock` quantity = 33 )
    ).

  ENDMETHOD.

ENDCLASS.
