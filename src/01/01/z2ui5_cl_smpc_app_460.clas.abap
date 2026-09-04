" @keywords input sap.m inputsuggestionscustomfilter verticallayout label item
" @summary The default filtering for the suggestionItems aggregation uses a 'begins with' style operator. You can override this with your own custom filter function using the Input control's setFilterFunction method.
CLASS z2ui5_cl_smpc_app_460 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             name TYPE string,
           END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

    DATA t_products TYPE ty_t_product.


  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_460 IMPLEMENTATION.

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
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->tag( `Label`
                )->a( n = `text`     v = `Product`
                )->a( n = `labelFor` v = `productInput`
            )->ele( `Input`
                )->a( n = `id`              v = `productInput`
                )->a( n = `placeholder`     v = `Enter product`
                )->a( n = `showSuggestion`  v = `true`
                )->a( n = `suggestionItems` v = client->_bind( t_products )

                )->ele( `suggestionItems`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `text` v = `{NAME}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " full mock /ProductCollection of ui5/mock/products.json (the bound fields)
    DATA temp1 TYPE z2ui5_cl_smpc_app_460=>ty_t_product.
    DATA temp2 LIKE LINE OF temp1.
    CLEAR temp1.
    
    temp2-name = `Notebook Basic 15`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Basic 17`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Basic 18`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Basic 19`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO Vault`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Professional 15`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Professional 17`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO Vault Net`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO Vault SAT`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Comfort Easy`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Comfort Senior`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ergo Screen E-I`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ergo Screen E-II`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ergo Screen E-III`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat Basic`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat Future`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat XL`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Laser Professional Eco`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Laser Basic`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Laser Allround`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ultra Jet Super Color`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ultra Jet Mobile`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ultra Jet Super Highspeed`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Multi Print`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Multi Color`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Cordless Mouse`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Speed Mouse`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Track Mouse`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ergonomic Keyboard`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Internet Keyboard`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Media Keyboard`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Mousepad`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ergo Mousepad`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Designer Mousepad`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Universal card reader`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Proctra X`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Gladiator MX`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Hurricane GX`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Hurricane GX/LN`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Photo Scan`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Power Scan`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Jet Scan Professional`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Jet Scan Professional`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Copymaster`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Surround Sound`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Blaster Extreme`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Sound Booster`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Lovely Sound 5.1 Wireless`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Lovely Sound 5.1`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Lovely Sound Stereo`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Office`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Design`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Network`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Multimedia`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Games`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Internet Antivirus`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Firewall`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Money`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `PC Lock`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Lock`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Web cam reality`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Screen clean`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Fabric bag professional`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Wireless DSL Router`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Wireless DSL Router / Repeater`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Wireless DSL Router / Repeater and Print Server`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `USB Stick`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Travel Adapter`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Cordless Bluetooth Keyboard, english international`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat XXL`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Pocket Mouse`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `PC Power Station`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Astro Laptop 1516`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Astro Phone 6`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Benda Laptop 1408`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Bending Screen 21HD`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Broad Screen 22HD`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Cerdik Phone 7`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Cepat Tablet 10.5`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Cepat Tablet 8`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Server Basic`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Server Professional`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Server Power Pro`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Family PC Basic`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Family PC Pro`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Gaming Monster`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Gaming Monster Pro`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `7" Widescreen Portable DVD Player w MP3`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `10" Portable DVD player`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Portable DVD Player with 9" LCD Monitor`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `CD/DVD case: 264 sleeves`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Audio/Video Cable Kit - 4m`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Removable CD/DVD Laser Labels`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Beam Breaker B-1`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Beam Breaker B-2`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Beam Breaker B-3`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Play Movie`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Record Movie`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelo MusicStick`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelo Jog-Mate`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Power Pro Player 40`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Power Pro Player 80`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat Watch HD32`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat Watch HD37`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat Watch HD41`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Copperberry`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Silverberry`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Goldberry`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Platinberry`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO FlexTop I4000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO FlexTop I6300c`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO FlexTop I9100`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO FlexTop I9800`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smartphone Leather Case`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smartphone Alpha`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Mini Tablet`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Camcorder View`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Tablet Pouch`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Tablet Pouch`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `e-Book Reader ReadMe`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smartphone Beta`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Maxi Tablet`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flyer`.
    INSERT temp2 INTO TABLE temp1.
    t_products = temp1.

  ENDMETHOD.

ENDCLASS.
