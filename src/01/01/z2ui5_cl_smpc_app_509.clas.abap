" @keywords input sap.m inputsuggestionsopensearch verticallayout label item
" @summary If you need to use an Open Search Provider (OSP) to supply possible values, you can do this with the Input control's suggest event, and build the suggestionItems dynamically according to the results of the Open Search call.
CLASS z2ui5_cl_smpc_app_509 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             name TYPE string,
           END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

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
    IF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

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
                )->a( n = `suggest`         v = client->_event( val   = `SUGGEST`
                                                                t_arg = VALUE #( ( `${$parameters>/suggestValue}` ) ) )

                )->ele( `suggestionItems`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `text` v = `{NAME}` ).

    client->view_display( view->stringify( ) ).
    " the original builds its suggestions imperatively (addSuggestionItem), which no
    " size limit applies to; this port binds the aggregation, so the limit has to be
    " raised - a one-character term matches over 100 of the 123 products
    client->follow_up_action( val   = client->cs_event-set_size_limit
                              t_arg = VALUE #( ( `100000` ) ( `MAIN` ) ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `SUGGEST`.

      DATA(term) = to_upper( client->get_event_arg( ) ).
      CLEAR t_suggestions.
      IF term IS NOT INITIAL.
        LOOP AT products_all( ) INTO DATA(product).
          IF to_upper( product-name ) CS term.
            APPEND product TO t_suggestions.
          ENDIF.
        ENDLOOP.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD products_all.

    " the product names the sample's mock search service answers with
    result = VALUE #(
        ( name = `Notebook Basic 15` )
        ( name = `Notebook Basic 17` )
        ( name = `Notebook Basic 18` )
        ( name = `Notebook Basic 19` )
        ( name = `ITelO Vault` )
        ( name = `Notebook Professional 15` )
        ( name = `Notebook Professional 17` )
        ( name = `ITelO Vault Net` )
        ( name = `ITelO Vault SAT` )
        ( name = `Comfort Easy` )
        ( name = `Comfort Senior` )
        ( name = `Ergo Screen E-I` )
        ( name = `Ergo Screen E-II` )
        ( name = `Ergo Screen E-III` )
        ( name = `Flat Basic` )
        ( name = `Flat Future` )
        ( name = `Flat XL` )
        ( name = `Laser Professional Eco` )
        ( name = `Laser Basic` )
        ( name = `Laser Allround` )
        ( name = `Ultra Jet Super Color` )
        ( name = `Ultra Jet Mobile` )
        ( name = `Ultra Jet Super Highspeed` )
        ( name = `Multi Print` )
        ( name = `Multi Color` )
        ( name = `Cordless Mouse` )
        ( name = `Speed Mouse` )
        ( name = `Track Mouse` )
        ( name = `Ergonomic Keyboard` )
        ( name = `Internet Keyboard` )
        ( name = `Media Keyboard` )
        ( name = `Mousepad` )
        ( name = `Ergo Mousepad` )
        ( name = `Designer Mousepad` )
        ( name = `Universal card reader` )
        ( name = `Proctra X` )
        ( name = `Gladiator MX` )
        ( name = `Hurricane GX` )
        ( name = `Hurricane GX/LN` )
        ( name = `Photo Scan` )
        ( name = `Power Scan` )
        ( name = `Jet Scan Professional` )
        ( name = `Jet Scan Professional` )
        ( name = `Copymaster` )
        ( name = `Surround Sound` )
        ( name = `Blaster Extreme` )
        ( name = `Sound Booster` )
        ( name = `Lovely Sound 5.1 Wireless` )
        ( name = `Lovely Sound 5.1` )
        ( name = `Lovely Sound Stereo` )
        ( name = `Smart Office` )
        ( name = `Smart Design` )
        ( name = `Smart Network` )
        ( name = `Smart Multimedia` )
        ( name = `Smart Games` )
        ( name = `Smart Internet Antivirus` )
        ( name = `Smart Firewall` )
        ( name = `Smart Money` )
        ( name = `PC Lock` )
        ( name = `Notebook Lock` )
        ( name = `Web cam reality` )
        ( name = `Screen clean` )
        ( name = `Fabric bag professional` )
        ( name = `Wireless DSL Router` )
        ( name = `Wireless DSL Router / Repeater` )
        ( name = `Wireless DSL Router / Repeater and Print Server` )
        ( name = `USB Stick` )
        ( name = `Travel Adapter` )
        ( name = `Cordless Bluetooth Keyboard, english international` )
        ( name = `Flat XXL` )
        ( name = `Pocket Mouse` )
        ( name = `PC Power Station` )
        ( name = `Astro Laptop 1516` )
        ( name = `Astro Phone 6` )
        ( name = `Benda Laptop 1408` )
        ( name = `Bending Screen 21HD` )
        ( name = `Broad Screen 22HD` )
        ( name = `Cerdik Phone 7` )
        ( name = `Cepat Tablet 10.5` )
        ( name = `Cepat Tablet 8` )
        ( name = `Server Basic` )
        ( name = `Server Professional` )
        ( name = `Server Power Pro` )
        ( name = `Family PC Basic` )
        ( name = `Family PC Pro` )
        ( name = `Gaming Monster` )
        ( name = `Gaming Monster Pro` )
        ( name = `7" Widescreen Portable DVD Player w MP3` )
        ( name = `10" Portable DVD player` )
        ( name = `Portable DVD Player with 9" LCD Monitor` )
        ( name = `CD/DVD case: 264 sleeves` )
        ( name = `Audio/Video Cable Kit - 4m` )
        ( name = `Removable CD/DVD Laser Labels` )
        ( name = `Beam Breaker B-1` )
        ( name = `Beam Breaker B-2` )
        ( name = `Beam Breaker B-3` )
        ( name = `Play Movie` )
        ( name = `Record Movie` )
        ( name = `ITelo MusicStick` )
        ( name = `ITelo Jog-Mate` )
        ( name = `Power Pro Player 40` )
        ( name = `Power Pro Player 80` )
        ( name = `Flat Watch HD32` )
        ( name = `Flat Watch HD37` )
        ( name = `Flat Watch HD41` )
        ( name = `Copperberry` )
        ( name = `Silverberry` )
        ( name = `Goldberry` )
        ( name = `Platinberry` )
        ( name = `ITelO FlexTop I4000` )
        ( name = `ITelO FlexTop I6300c` )
        ( name = `ITelO FlexTop I9100` )
        ( name = `ITelO FlexTop I9800` )
        ( name = `Smartphone Leather Case` )
        ( name = `Smartphone Alpha` )
        ( name = `Mini Tablet` )
        ( name = `Camcorder View` )
        ( name = `Tablet Pouch` )
        ( name = `Tablet Pouch` )
        ( name = `e-Book Reader ReadMe` )
        ( name = `Smartphone Beta` )
        ( name = `Maxi Tablet` )
        ( name = `Flyer` ) ).

  ENDMETHOD.

ENDCLASS.
