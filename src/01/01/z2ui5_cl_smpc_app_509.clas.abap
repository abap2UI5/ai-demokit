" @keywords input sap.m inputsuggestionsopensearch verticallayout label item
" @summary If you need to use an Open Search Provider (OSP) to supply possible values, you can do this with the Input control's suggest event, and build the suggestionItems dynamically according to the results of the Open Search call.
CLASS z2ui5_cl_smpc_app_509 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             name TYPE string,
           END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

    DATA t_suggestions TYPE ty_t_product.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS products_all RETURNING VALUE(result) TYPE ty_t_product.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_509 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->tag( `Label`
                )->a( n = `text`     v = `Product`
                )->a( n = `labelFor` v = `productInput`
            " onSuggest asks an OpenSearchProvider (a mock server) and replaces the
            " suggestion items with what it answers - the same search runs in ABAP and
            " fills the bound aggregation
            )->ele( `Input`
                )->a( n = `id`              v = `productInput`
                )->a( n = `placeholder`     v = `Enter product`
                )->a( n = `showSuggestion`  v = `true`
                )->a( n = `suggestionItems` v = client->_bind( t_suggestions )
                )->a( n = `suggest`         v = client->_event( val = `SUGGEST` arg = `${$parameters>/suggestValue}` )

                )->ele( `suggestionItems`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `text` v = `{NAME}` ).

    client->view_display( view->stringify( ) ).
    " the original builds its suggestions imperatively (addSuggestionItem), which no
    " size limit applies to; this port binds the aggregation, so the limit has to be
    " raised - a one-character term matches over 100 of the 123 products
    
    CLEAR temp1.
    INSERT `100000` INTO TABLE temp1.
    INSERT client->cs_view-main INTO TABLE temp1.
    client->follow_up_action( val   = client->cs_event-set_size_limit
                              t_arg = temp1 ).

  ENDMETHOD.


  METHOD on_event.
      DATA term TYPE string.
        DATA temp3 TYPE z2ui5_cl_smpc_app_509=>ty_t_product.
        DATA product LIKE LINE OF temp3.

    IF client->get_event( ) = `SUGGEST`.

      
      term = to_upper( client->get_event_arg( ) ).
      CLEAR t_suggestions.
      IF term IS NOT INITIAL.
        
        temp3 = products_all( ).
        
        LOOP AT temp3 INTO product.
          IF to_upper( product-name ) CS term.
            APPEND product TO t_suggestions.
          ENDIF.
        ENDLOOP.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD products_all.

    " the product names the sample's mock search service answers with
    DATA temp4 TYPE z2ui5_cl_smpc_app_509=>ty_t_product.
    DATA temp5 LIKE LINE OF temp4.
    CLEAR temp4.
    
    temp5-name = `Notebook Basic 15`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Notebook Basic 17`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Notebook Basic 18`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Notebook Basic 19`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `ITelO Vault`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Notebook Professional 15`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Notebook Professional 17`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `ITelO Vault Net`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `ITelO Vault SAT`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Comfort Easy`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Comfort Senior`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Ergo Screen E-I`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Ergo Screen E-II`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Ergo Screen E-III`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Flat Basic`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Flat Future`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Flat XL`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Laser Professional Eco`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Laser Basic`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Laser Allround`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Ultra Jet Super Color`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Ultra Jet Mobile`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Ultra Jet Super Highspeed`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Multi Print`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Multi Color`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Cordless Mouse`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Speed Mouse`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Track Mouse`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Ergonomic Keyboard`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Internet Keyboard`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Media Keyboard`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Mousepad`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Ergo Mousepad`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Designer Mousepad`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Universal card reader`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Proctra X`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Gladiator MX`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Hurricane GX`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Hurricane GX/LN`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Photo Scan`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Power Scan`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Jet Scan Professional`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Jet Scan Professional`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Copymaster`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Surround Sound`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Blaster Extreme`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Sound Booster`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Lovely Sound 5.1 Wireless`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Lovely Sound 5.1`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Lovely Sound Stereo`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Smart Office`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Smart Design`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Smart Network`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Smart Multimedia`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Smart Games`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Smart Internet Antivirus`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Smart Firewall`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Smart Money`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `PC Lock`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Notebook Lock`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Web cam reality`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Screen clean`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Fabric bag professional`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Wireless DSL Router`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Wireless DSL Router / Repeater`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Wireless DSL Router / Repeater and Print Server`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `USB Stick`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Travel Adapter`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Cordless Bluetooth Keyboard, english international`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Flat XXL`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Pocket Mouse`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `PC Power Station`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Astro Laptop 1516`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Astro Phone 6`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Benda Laptop 1408`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Bending Screen 21HD`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Broad Screen 22HD`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Cerdik Phone 7`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Cepat Tablet 10.5`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Cepat Tablet 8`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Server Basic`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Server Professional`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Server Power Pro`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Family PC Basic`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Family PC Pro`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Gaming Monster`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Gaming Monster Pro`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `7" Widescreen Portable DVD Player w MP3`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `10" Portable DVD player`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Portable DVD Player with 9" LCD Monitor`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `CD/DVD case: 264 sleeves`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Audio/Video Cable Kit - 4m`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Removable CD/DVD Laser Labels`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Beam Breaker B-1`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Beam Breaker B-2`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Beam Breaker B-3`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Play Movie`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Record Movie`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `ITelo MusicStick`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `ITelo Jog-Mate`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Power Pro Player 40`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Power Pro Player 80`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Flat Watch HD32`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Flat Watch HD37`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Flat Watch HD41`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Copperberry`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Silverberry`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Goldberry`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Platinberry`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `ITelO FlexTop I4000`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `ITelO FlexTop I6300c`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `ITelO FlexTop I9100`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `ITelO FlexTop I9800`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Smartphone Leather Case`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Smartphone Alpha`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Mini Tablet`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Camcorder View`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Tablet Pouch`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Tablet Pouch`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `e-Book Reader ReadMe`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Smartphone Beta`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Maxi Tablet`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Flyer`.
    INSERT temp5 INTO TABLE temp4.
    result = temp4.

  ENDMETHOD.

ENDCLASS.
