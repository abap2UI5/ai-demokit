CLASS z2ui5_cl_smpc_app_208 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name      TYPE string,
        status    TYPE string,
        infostate TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_208 IMPLEMENTATION.

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
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->open( `List`
            )->a( n = `headerText` v = `Products`
            )->a( n = `items`      v = |\{ path: '{ client->_bind( val = t_products path = abap_true ) }', sorter: \{ path: 'NAME' \} \}|

            )->open( `items`
                )->leaf( `StandardListItem`
                    )->a( n = `title`     v = `{NAME}`
                    )->a( n = `info`      v = `{STATUS}`
                    " infoState is derived from Status in ABAP (thin frontend) - see the sidecar
                    )->a( n = `infoState` v = `{INFOSTATE}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " the shared mock /ProductCollection (ui5/mock/products.json), the two bound
    " columns Name/Status, all 123 rows kept verbatim
    t_products = VALUE #(
      ( name = `Notebook Basic 15` status = `Available` )
      ( name = `Notebook Basic 17` status = `Available` )
      ( name = `Notebook Basic 18` status = `Available` )
      ( name = `Notebook Basic 19` status = `Out of Stock` )
      ( name = `ITelO Vault` status = `Out of Stock` )
      ( name = `Notebook Professional 15` status = `Out of Stock` )
      ( name = `Notebook Professional 17` status = `Out of Stock` )
      ( name = `ITelO Vault Net` status = `Discontinued` )
      ( name = `ITelO Vault SAT` status = `Available` )
      ( name = `Comfort Easy` status = `Out of Stock` )
      ( name = `Comfort Senior` status = `Available` )
      ( name = `Ergo Screen E-I` status = `Available` )
      ( name = `Ergo Screen E-II` status = `Available` )
      ( name = `Ergo Screen E-III` status = `Out of Stock` )
      ( name = `Flat Basic` status = `Available` )
      ( name = `Flat Future` status = `Available` )
      ( name = `Flat XL` status = `Available` )
      ( name = `Laser Professional Eco` status = `Available` )
      ( name = `Laser Basic` status = `Available` )
      ( name = `Laser Allround` status = `Available` )
      ( name = `Ultra Jet Super Color` status = `Discontinued` )
      ( name = `Ultra Jet Mobile` status = `Discontinued` )
      ( name = `Ultra Jet Super Highspeed` status = `Available` )
      ( name = `Multi Print` status = `Available` )
      ( name = `Multi Color` status = `Available` )
      ( name = `Cordless Mouse` status = `Available` )
      ( name = `Speed Mouse` status = `Available` )
      ( name = `Track Mouse` status = `Discontinued` )
      ( name = `Ergonomic Keyboard` status = `Available` )
      ( name = `Internet Keyboard` status = `Out of Stock` )
      ( name = `Media Keyboard` status = `Available` )
      ( name = `Mousepad` status = `Available` )
      ( name = `Ergo Mousepad` status = `Out of Stock` )
      ( name = `Designer Mousepad` status = `Available` )
      ( name = `Universal card reader` status = `Available` )
      ( name = `Proctra X` status = `Out of Stock` )
      ( name = `Gladiator MX` status = `Discontinued` )
      ( name = `Hurricane GX` status = `Available` )
      ( name = `Hurricane GX/LN` status = `Out of Stock` )
      ( name = `Photo Scan` status = `Out of Stock` )
      ( name = `Power Scan` status = `Out of Stock` )
      ( name = `Jet Scan Professional` status = `Out of Stock` )
      ( name = `Jet Scan Professional` status = `Available` )
      ( name = `Copymaster` status = `Available` )
      ( name = `Surround Sound` status = `Available` )
      ( name = `Blaster Extreme` status = `Available` )
      ( name = `Sound Booster` status = `Discontinued` )
      ( name = `Lovely Sound 5.1 Wireless` status = `Available` )
      ( name = `Lovely Sound 5.1` status = `Available` )
      ( name = `Lovely Sound Stereo` status = `Out of Stock` )
      ( name = `Smart Office` status = `Out of Stock` )
      ( name = `Smart Design` status = `Available` )
      ( name = `Smart Network` status = `Available` )
      ( name = `Smart Multimedia` status = `Available` )
      ( name = `Smart Games` status = `Available` )
      ( name = `Smart Internet Antivirus` status = `Available` )
      ( name = `Smart Firewall` status = `Discontinued` )
      ( name = `Smart Money` status = `Out of Stock` )
      ( name = `PC Lock` status = `Available` )
      ( name = `Notebook Lock` status = `Available` )
      ( name = `Web cam reality` status = `Out of Stock` )
      ( name = `Screen clean` status = `Available` )
      ( name = `Fabric bag professional` status = `Available` )
      ( name = `Wireless DSL Router` status = `Available` )
      ( name = `Wireless DSL Router / Repeater` status = `Out of Stock` )
      ( name = `Wireless DSL Router / Repeater and Print Server` status = `Available` )
      ( name = `USB Stick` status = `Available` )
      ( name = `Travel Adapter` status = `Discontinued` )
      ( name = `Cordless Bluetooth Keyboard, english international` status = `Out of Stock` )
      ( name = `Flat XXL` status = `Discontinued` )
      ( name = `Pocket Mouse` status = `Available` )
      ( name = `PC Power Station` status = `Available` )
      ( name = `Astro Laptop 1516` status = `Available` )
      ( name = `Astro Phone 6` status = `Available` )
      ( name = `Benda Laptop 1408` status = `Discontinued` )
      ( name = `Bending Screen 21HD` status = `Available` )
      ( name = `Broad Screen 22HD` status = `Discontinued` )
      ( name = `Cerdik Phone 7` status = `Discontinued` )
      ( name = `Cepat Tablet 10.5` status = `Available` )
      ( name = `Cepat Tablet 8` status = `Available` )
      ( name = `Server Basic` status = `Available` )
      ( name = `Server Professional` status = `Out of Stock` )
      ( name = `Server Power Pro` status = `Available` )
      ( name = `Family PC Basic` status = `Available` )
      ( name = `Family PC Pro` status = `Available` )
      ( name = `Gaming Monster` status = `Available` )
      ( name = `Gaming Monster Pro` status = `Discontinued` )
      ( name = `7" Widescreen Portable DVD Player w MP3` status = `Available` )
      ( name = `10" Portable DVD player` status = `Available` )
      ( name = `Portable DVD Player with 9" LCD Monitor` status = `Available` )
      ( name = `CD/DVD case: 264 sleeves` status = `Discontinued` )
      ( name = `Audio/Video Cable Kit - 4m` status = `Available` )
      ( name = `Removable CD/DVD Laser Labels` status = `Discontinued` )
      ( name = `Beam Breaker B-1` status = `Out of Stock` )
      ( name = `Beam Breaker B-2` status = `Available` )
      ( name = `Beam Breaker B-3` status = `Out of Stock` )
      ( name = `Play Movie` status = `Available` )
      ( name = `Record Movie` status = `Discontinued` )
      ( name = `ITelo MusicStick` status = `Available` )
      ( name = `ITelo Jog-Mate` status = `Available` )
      ( name = `Power Pro Player 40` status = `Available` )
      ( name = `Power Pro Player 80` status = `Available` )
      ( name = `Flat Watch HD32` status = `Available` )
      ( name = `Flat Watch HD37` status = `Available` )
      ( name = `Flat Watch HD41` status = `Discontinued` )
      ( name = `Copperberry` status = `Discontinued` )
      ( name = `Silverberry` status = `Discontinued` )
      ( name = `Goldberry` status = `Available` )
      ( name = `Platinberry` status = `Available` )
      ( name = `ITelO FlexTop I4000` status = `Available` )
      ( name = `ITelO FlexTop I6300c` status = `Discontinued` )
      ( name = `ITelO FlexTop I9100` status = `Available` )
      ( name = `ITelO FlexTop I9800` status = `Available` )
      ( name = `Smartphone Leather Case` status = `Available` )
      ( name = `Smartphone Alpha` status = `Out of Stock` )
      ( name = `Mini Tablet` status = `Available` )
      ( name = `Camcorder View` status = `Out of Stock` )
      ( name = `Tablet Pouch` status = `Available` )
      ( name = `Tablet Pouch` status = `Available` )
      ( name = `e-Book Reader ReadMe` status = `Available` )
      ( name = `Smartphone Beta` status = `Available` )
      ( name = `Maxi Tablet` status = `Available` )
      ( name = `Flyer` status = `Out of Stock` )
    ).

    " the original's '.formatter.status' maps Status -> a ValueState in the
    " frontend; abap2UI5 is a thin frontend, so the info state is derived here
    " in the backend and bound directly (infoState="{INFOSTATE}")
    LOOP AT t_products REFERENCE INTO DATA(lr_product).
      lr_product->infostate = SWITCH #( lr_product->status
        WHEN `Available`    THEN `Success`
        WHEN `Out of Stock` THEN `Warning`
        WHEN `Discontinued` THEN `Error`
        ELSE `None` ).
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
