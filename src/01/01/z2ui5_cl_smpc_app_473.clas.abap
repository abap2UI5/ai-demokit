" @keywords input sap.m inputsuggestionsdynamic verticallayout label item
" @summary With the Input control's suggest event, you can handle the suggestionItems yourself dynamically.
CLASS z2ui5_cl_smpc_app_473 DEFINITION PUBLIC.

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
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_473 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
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
                " onSuggest re-filters the suggestionItems binding with the typed term
                )->a( n = `suggest`         v = client->_event( val = `SUGGEST` arg = `${$parameters>/suggestValue}` )
                )->a( n = `suggestionItems` v = client->_bind( t_products )

                )->ele( `suggestionItems`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `text` v = `{NAME}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
      DATA term TYPE string.
      DATA temp1 TYPE string_table.

    IF client->get_event( ) = `SUGGEST`.

      " the original builds a StartsWith filter on Name (and an empty filter list
      " for an empty term) and applies it to the suggestionItems BINDING - the
      " same declarative filter, the model untouched
      
      term = client->get_event_arg( ).

      
      CLEAR temp1.
      INSERT `productInput` INTO TABLE temp1.
      INSERT `suggestionItems` INTO TABLE temp1.
      INSERT `filter` INTO TABLE temp1.
      INSERT `NAME` INTO TABLE temp1.
      INSERT `StartsWith` INTO TABLE temp1.
      INSERT term INTO TABLE temp1.
      client->follow_up_action( val   = client->cs_event-binding_call
                                t_arg = temp1 ).

    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " full mock /ProductCollection of ui5/mock/products.json (the bound field)
    DATA temp3 TYPE z2ui5_cl_smpc_app_473=>ty_t_product.
    DATA temp4 LIKE LINE OF temp3.
    CLEAR temp3.
    
    temp4-name = `Notebook Basic 15`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Basic 17`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Basic 18`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Basic 19`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO Vault`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Professional 15`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Professional 17`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO Vault Net`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO Vault SAT`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Comfort Easy`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Comfort Senior`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergo Screen E-I`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergo Screen E-II`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergo Screen E-III`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Basic`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Future`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat XL`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Laser Professional Eco`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Laser Basic`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Laser Allround`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ultra Jet Super Color`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ultra Jet Mobile`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ultra Jet Super Highspeed`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Multi Print`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Multi Color`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cordless Mouse`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Speed Mouse`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Track Mouse`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergonomic Keyboard`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Internet Keyboard`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Media Keyboard`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Mousepad`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergo Mousepad`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Designer Mousepad`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Universal card reader`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Proctra X`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Gladiator MX`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Hurricane GX`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Hurricane GX/LN`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Photo Scan`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Power Scan`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Jet Scan Professional`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Jet Scan Professional`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Copymaster`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Surround Sound`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Blaster Extreme`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Sound Booster`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Lovely Sound 5.1 Wireless`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Lovely Sound 5.1`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Lovely Sound Stereo`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Office`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Design`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Network`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Multimedia`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Games`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Internet Antivirus`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Firewall`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Money`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `PC Lock`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Lock`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Web cam reality`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Screen clean`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Fabric bag professional`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Wireless DSL Router`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Wireless DSL Router / Repeater`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Wireless DSL Router / Repeater and Print Server`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `USB Stick`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Travel Adapter`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cordless Bluetooth Keyboard, english international`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat XXL`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Pocket Mouse`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `PC Power Station`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Astro Laptop 1516`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Astro Phone 6`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Benda Laptop 1408`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Bending Screen 21HD`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Broad Screen 22HD`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cerdik Phone 7`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cepat Tablet 10.5`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cepat Tablet 8`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Server Basic`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Server Professional`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Server Power Pro`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Family PC Basic`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Family PC Pro`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Gaming Monster`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Gaming Monster Pro`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `7" Widescreen Portable DVD Player w MP3`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `10" Portable DVD player`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Portable DVD Player with 9" LCD Monitor`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `CD/DVD case: 264 sleeves`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Audio/Video Cable Kit - 4m`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Removable CD/DVD Laser Labels`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Beam Breaker B-1`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Beam Breaker B-2`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Beam Breaker B-3`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Play Movie`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Record Movie`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelo MusicStick`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelo Jog-Mate`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Power Pro Player 40`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Power Pro Player 80`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Watch HD32`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Watch HD37`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Watch HD41`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Copperberry`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Silverberry`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Goldberry`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Platinberry`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO FlexTop I4000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO FlexTop I6300c`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO FlexTop I9100`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO FlexTop I9800`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smartphone Leather Case`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smartphone Alpha`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Mini Tablet`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Camcorder View`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Tablet Pouch`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Tablet Pouch`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `e-Book Reader ReadMe`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smartphone Beta`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Maxi Tablet`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flyer`.
    INSERT temp4 INTO TABLE temp3.
    t_products = temp3.

  ENDMETHOD.

ENDCLASS.
