" @keywords icontabbar icon tab bar sap.m height icontabfilter scrollcontainer list standardlistitem text
" @summary In this example, the IconTabBar height is stretched to the maximum height of the page content. Note: The height of the parent container must be defined as a fixed value.
CLASS z2ui5_cl_smpc_app_030 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name     TYPE string,
        " numeric - StandardListItem.counter is an int property; a string
        " value is rejected by UI5's strict property-type validation
        quantity TYPE i,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_030 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->ele( `IconTabBar`
            )->a( n = `id`                   v = `idIconTabBarStretchContent`
            )->a( n = `stretchContentHeight` v = `true`
            )->a( n = `backgroundDesign`     v = `Transparent`
            )->a( n = `applyContentPadding`  v = `false`
            " the sample's device model isNoPhone is a demo-kit helper; the framework's
            " device> model exposes raw sap.ui.Device, so !phone expresses the same
            )->a( n = `expanded`             v = `{= !${device>/system/phone} }`
            )->a( n = `class`                v = `sapUiResponsiveContentPadding`

            )->ele( `items`
                )->ele( `IconTabFilter`
                    )->a( n = `text` v = `Products`
                    )->a( n = `key`  v = `products`

                    )->ele( `ScrollContainer`
                        )->a( n = `height`     v = `100%`
                        )->a( n = `width`      v = `100%`
                        )->a( n = `horizontal` v = `false`
                        )->a( n = `vertical`   v = `true`

                        )->ele( `List`
                            )->a( n = `items` v = client->_bind( t_products )

                            )->tag( `StandardListItem`
                                )->a( n = `title`   v = `{NAME}`
                                )->a( n = `counter` v = `{QUANTITY}`

                        )->end(
                    )->end(
                )->end(
                )->ele( `IconTabFilter`
                    )->a( n = `text` v = `Attachments`
                    )->a( n = `key`  v = `attachments`

                    )->tag( `Text`
                        )->a( n = `text` v = `Attachments go here ...`

                )->end(
                )->ele( `IconTabFilter`
                    )->a( n = `text` v = `Notes`
                    )->a( n = `key`  v = `notes`

                    )->tag( `Text`
                        )->a( n = `text` v = `Notes go here ...`

                )->end(
                )->ele( `IconTabFilter`
                    )->a( n = `text` v = `People`
                    )->a( n = `key`  v = `people`

                    )->tag( `Text`
                        )->a( n = `text` v = `People content goes here ...` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " Data taken 1:1 from the shared mock data sap/ui/demo/mock/products.json of the original sample
    DATA temp1 LIKE t_products.
    DATA temp2 LIKE LINE OF temp1.
    CLEAR temp1.
    
    temp2-name = `Notebook Basic 15`.
    temp2-quantity = 10.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Basic 17`.
    temp2-quantity = 20.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Basic 18`.
    temp2-quantity = 10.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Basic 19`.
    temp2-quantity = 15.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO Vault`.
    temp2-quantity = 15.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Professional 15`.
    temp2-quantity = 16.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Professional 17`.
    temp2-quantity = 17.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO Vault Net`.
    temp2-quantity = 14.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO Vault SAT`.
    temp2-quantity = 50.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Comfort Easy`.
    temp2-quantity = 30.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Comfort Senior`.
    temp2-quantity = 24.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ergo Screen E-I`.
    temp2-quantity = 14.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ergo Screen E-II`.
    temp2-quantity = 24.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ergo Screen E-III`.
    temp2-quantity = 50.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat Basic`.
    temp2-quantity = 23.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat Future`.
    temp2-quantity = 22.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat XL`.
    temp2-quantity = 23.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Laser Professional Eco`.
    temp2-quantity = 21.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Laser Basic`.
    temp2-quantity = 8.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Laser Allround`.
    temp2-quantity = 9.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ultra Jet Super Color`.
    temp2-quantity = 17.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ultra Jet Mobile`.
    temp2-quantity = 18.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ultra Jet Super Highspeed`.
    temp2-quantity = 25.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Multi Print`.
    temp2-quantity = 16.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Multi Color`.
    temp2-quantity = 5.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Cordless Mouse`.
    temp2-quantity = 25.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Speed Mouse`.
    temp2-quantity = 12.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Track Mouse`.
    temp2-quantity = 12.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ergonomic Keyboard`.
    temp2-quantity = 50.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Internet Keyboard`.
    temp2-quantity = 35.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Media Keyboard`.
    temp2-quantity = 26.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Mousepad`.
    temp2-quantity = 12.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ergo Mousepad`.
    temp2-quantity = 16.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Designer Mousepad`.
    temp2-quantity = 26.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Universal card reader`.
    temp2-quantity = 22.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Proctra X`.
    temp2-quantity = 15.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Gladiator MX`.
    temp2-quantity = 16.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Hurricane GX`.
    temp2-quantity = 13.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Hurricane GX/LN`.
    temp2-quantity = 5.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Photo Scan`.
    temp2-quantity = 8.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Power Scan`.
    temp2-quantity = 11.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Jet Scan Professional`.
    temp2-quantity = 13.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Jet Scan Professional`.
    temp2-quantity = 10.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Copymaster`.
    temp2-quantity = 10.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Surround Sound`.
    temp2-quantity = 20.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Blaster Extreme`.
    temp2-quantity = 15.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Sound Booster`.
    temp2-quantity = 50.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Lovely Sound 5.1 Wireless`.
    temp2-quantity = 12.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Lovely Sound 5.1`.
    temp2-quantity = 18.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Lovely Sound Stereo`.
    temp2-quantity = 21.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Office`.
    temp2-quantity = 25.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Design`.
    temp2-quantity = 26.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Network`.
    temp2-quantity = 28.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Multimedia`.
    temp2-quantity = 9.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Games`.
    temp2-quantity = 13.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Internet Antivirus`.
    temp2-quantity = 17.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Firewall`.
    temp2-quantity = 19.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Money`.
    temp2-quantity = 18.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `PC Lock`.
    temp2-quantity = 14.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Lock`.
    temp2-quantity = 20.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Web cam reality`.
    temp2-quantity = 27.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Screen clean`.
    temp2-quantity = 17.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Fabric bag professional`.
    temp2-quantity = 14.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Wireless DSL Router`.
    temp2-quantity = 16.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Wireless DSL Router / Repeater`.
    temp2-quantity = 12.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Wireless DSL Router / Repeater and Print Server`.
    temp2-quantity = 12.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `USB Stick`.
    temp2-quantity = 14.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Travel Adapter`.
    temp2-quantity = 10.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Cordless Bluetooth Keyboard, english international`.
    temp2-quantity = 13.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat XXL`.
    temp2-quantity = 10.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Pocket Mouse`.
    temp2-quantity = 20.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `PC Power Station`.
    temp2-quantity = 22.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Astro Laptop 1516`.
    temp2-quantity = 23.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Astro Phone 6`.
    temp2-quantity = 28.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Benda Laptop 1408`.
    temp2-quantity = 27.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Bending Screen 21HD`.
    temp2-quantity = 23.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Broad Screen 22HD`.
    temp2-quantity = 5.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Cerdik Phone 7`.
    temp2-quantity = 19.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Cepat Tablet 10.5`.
    temp2-quantity = 17.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Cepat Tablet 8`.
    temp2-quantity = 24.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Server Basic`.
    temp2-quantity = 24.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Server Professional`.
    temp2-quantity = 26.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Server Power Pro`.
    temp2-quantity = 34.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Family PC Basic`.
    temp2-quantity = 10.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Family PC Pro`.
    temp2-quantity = 20.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Gaming Monster`.
    temp2-quantity = 24.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Gaming Monster Pro`.
    temp2-quantity = 25.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `7" Widescreen Portable DVD Player w MP3`.
    temp2-quantity = 20.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `10" Portable DVD player`.
    temp2-quantity = 21.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Portable DVD Player with 9" LCD Monitor`.
    temp2-quantity = 50.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `CD/DVD case: 264 sleeves`.
    temp2-quantity = 26.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Audio/Video Cable Kit - 4m`.
    temp2-quantity = 16.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Removable CD/DVD Laser Labels`.
    temp2-quantity = 25.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Beam Breaker B-1`.
    temp2-quantity = 32.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Beam Breaker B-2`.
    temp2-quantity = 18.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Beam Breaker B-3`.
    temp2-quantity = 16.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Play Movie`.
    temp2-quantity = 15.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Record Movie`.
    temp2-quantity = 24.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelo MusicStick`.
    temp2-quantity = 15.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelo Jog-Mate`.
    temp2-quantity = 24.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Power Pro Player 40`.
    temp2-quantity = 23.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Power Pro Player 80`.
    temp2-quantity = 13.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat Watch HD32`.
    temp2-quantity = 16.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat Watch HD37`.
    temp2-quantity = 14.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat Watch HD41`.
    temp2-quantity = 13.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Copperberry`.
    temp2-quantity = 5.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Silverberry`.
    temp2-quantity = 9.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Goldberry`.
    temp2-quantity = 11.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Platinberry`.
    temp2-quantity = 12.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO FlexTop I4000`.
    temp2-quantity = 11.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO FlexTop I6300c`.
    temp2-quantity = 20.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO FlexTop I9100`.
    temp2-quantity = 20.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO FlexTop I9800`.
    temp2-quantity = 22.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smartphone Leather Case`.
    temp2-quantity = 12.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smartphone Alpha`.
    temp2-quantity = 13.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Mini Tablet`.
    temp2-quantity = 10.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Camcorder View`.
    temp2-quantity = 50.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Tablet Pouch`.
    temp2-quantity = 34.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Tablet Pouch`.
    temp2-quantity = 34.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `e-Book Reader ReadMe`.
    temp2-quantity = 23.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smartphone Beta`.
    temp2-quantity = 21.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Maxi Tablet`.
    temp2-quantity = 20.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flyer`.
    temp2-quantity = 33.
    INSERT temp2 INTO TABLE temp1.
    t_products = temp1.

  ENDMETHOD.

ENDCLASS.
