" @keywords input sap.m inputassistedtwovalues verticallayout label listitem
" @summary This example shows how to easily implement an assisted input with two-value suggestions.
CLASS z2ui5_cl_smpc_app_456 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             name         TYPE string,
             suppliername TYPE string,
           END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

    DATA t_products TYPE ty_t_product.


  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_456 IMPLEMENTATION.

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
                    )->tag( n = `ListItem` ns = `core`
                        )->a( n = `text`           v = `{NAME}`
                        )->a( n = `additionalText` v = `{SUPPLIERNAME}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " full mock /ProductCollection of ui5/mock/products.json (the bound fields)
    t_products = VALUE #(
        ( name = `Notebook Basic 15` suppliername = `Very Best Screens` )
        ( name = `Notebook Basic 17` suppliername = `Very Best Screens` )
        ( name = `Notebook Basic 18` suppliername = `Very Best Screens` )
        ( name = `Notebook Basic 19` suppliername = `Smartcards` )
        ( name = `ITelO Vault` suppliername = `Technocom` )
        ( name = `Notebook Professional 15` suppliername = `Very Best Screens` )
        ( name = `Notebook Professional 17` suppliername = `Very Best Screens` )
        ( name = `ITelO Vault Net` suppliername = `Technocom` )
        ( name = `ITelO Vault SAT` suppliername = `Technocom` )
        ( name = `Comfort Easy` suppliername = `Technocom` )
        ( name = `Comfort Senior` suppliername = `Technocom` )
        ( name = `Ergo Screen E-I` suppliername = `Very Best Screens` )
        ( name = `Ergo Screen E-II` suppliername = `Very Best Screens` )
        ( name = `Ergo Screen E-III` suppliername = `Very Best Screens` )
        ( name = `Flat Basic` suppliername = `Very Best Screens` )
        ( name = `Flat Future` suppliername = `Very Best Screens` )
        ( name = `Flat XL` suppliername = `Very Best Screens` )
        ( name = `Laser Professional Eco` suppliername = `Alpha Printers` )
        ( name = `Laser Basic` suppliername = `Alpha Printers` )
        ( name = `Laser Allround` suppliername = `Alpha Printers` )
        ( name = `Ultra Jet Super Color` suppliername = `Alpha Printers` )
        ( name = `Ultra Jet Mobile` suppliername = `Printer for All` )
        ( name = `Ultra Jet Super Highspeed` suppliername = `Printer for All` )
        ( name = `Multi Print` suppliername = `Printer for All` )
        ( name = `Multi Color` suppliername = `Printer for All` )
        ( name = `Cordless Mouse` suppliername = `Oxynum` )
        ( name = `Speed Mouse` suppliername = `Oxynum` )
        ( name = `Track Mouse` suppliername = `Oxynum` )
        ( name = `Ergonomic Keyboard` suppliername = `Oxynum` )
        ( name = `Internet Keyboard` suppliername = `Oxynum` )
        ( name = `Media Keyboard` suppliername = `Oxynum` )
        ( name = `Mousepad` suppliername = `Oxynum` )
        ( name = `Ergo Mousepad` suppliername = `Oxynum` )
        ( name = `Designer Mousepad` suppliername = `Fasttech` )
        ( name = `Universal card reader` suppliername = `Fasttech` )
        ( name = `Proctra X` suppliername = `Ultrasonic United` )
        ( name = `Gladiator MX` suppliername = `Ultrasonic United` )
        ( name = `Hurricane GX` suppliername = `Ultrasonic United` )
        ( name = `Hurricane GX/LN` suppliername = `Smartcards` )
        ( name = `Photo Scan` suppliername = `Printer for All` )
        ( name = `Power Scan` suppliername = `Printer for All` )
        ( name = `Jet Scan Professional` suppliername = `Printer for All` )
        ( name = `Jet Scan Professional` suppliername = `Printer for All` )
        ( name = `Copymaster` suppliername = `Alpha Printers` )
        ( name = `Surround Sound` suppliername = `Speaker Experts` )
        ( name = `Blaster Extreme` suppliername = `Speaker Experts` )
        ( name = `Sound Booster` suppliername = `Speaker Experts` )
        ( name = `Lovely Sound 5.1 Wireless` suppliername = `Fasttech` )
        ( name = `Lovely Sound 5.1` suppliername = `Fasttech` )
        ( name = `Lovely Sound Stereo` suppliername = `Fasttech` )
        ( name = `Smart Office` suppliername = `Technocom` )
        ( name = `Smart Design` suppliername = `Technocom` )
        ( name = `Smart Network` suppliername = `Technocom` )
        ( name = `Smart Multimedia` suppliername = `Technocom` )
        ( name = `Smart Games` suppliername = `Technocom` )
        ( name = `Smart Internet Antivirus` suppliername = `Brainsoft` )
        ( name = `Smart Firewall` suppliername = `Brainsoft` )
        ( name = `Smart Money` suppliername = `Brainsoft` )
        ( name = `PC Lock` suppliername = `Red Point Stores` )
        ( name = `Notebook Lock` suppliername = `Red Point Stores` )
        ( name = `Web cam reality` suppliername = `Red Point Stores` )
        ( name = `Screen clean` suppliername = `Red Point Stores` )
        ( name = `Fabric bag professional` suppliername = `Red Point Stores` )
        ( name = `Wireless DSL Router` suppliername = `Red Point Stores` )
        ( name = `Wireless DSL Router / Repeater` suppliername = `Red Point Stores` )
        ( name = `Wireless DSL Router / Repeater and Print Server` suppliername = `Technocom` )
        ( name = `USB Stick` suppliername = `Technocom` )
        ( name = `Travel Adapter` suppliername = `Titanium` )
        ( name = `Cordless Bluetooth Keyboard, english international` suppliername = `Technocom` )
        ( name = `Flat XXL` suppliername = `Technocom` )
        ( name = `Pocket Mouse` suppliername = `Technocom` )
        ( name = `PC Power Station` suppliername = `Technocom` )
        ( name = `Astro Laptop 1516` suppliername = `Ultrasonic United` )
        ( name = `Astro Phone 6` suppliername = `Ultrasonic United` )
        ( name = `Benda Laptop 1408` suppliername = `Ultrasonic United` )
        ( name = `Bending Screen 21HD` suppliername = `Ultrasonic United` )
        ( name = `Broad Screen 22HD` suppliername = `Ultrasonic United` )
        ( name = `Cerdik Phone 7` suppliername = `Ultrasonic United` )
        ( name = `Cepat Tablet 10.5` suppliername = `Ultrasonic United` )
        ( name = `Cepat Tablet 8` suppliername = `Ultrasonic United` )
        ( name = `Server Basic` suppliername = `Technocom` )
        ( name = `Server Professional` suppliername = `Technocom` )
        ( name = `Server Power Pro` suppliername = `Technocom` )
        ( name = `Family PC Basic` suppliername = `Titanium` )
        ( name = `Family PC Pro` suppliername = `Titanium` )
        ( name = `Gaming Monster` suppliername = `Titanium` )
        ( name = `Gaming Monster Pro` suppliername = `Titanium` )
        ( name = `7" Widescreen Portable DVD Player w MP3` suppliername = `Titanium` )
        ( name = `10" Portable DVD player` suppliername = `Titanium` )
        ( name = `Portable DVD Player with 9" LCD Monitor` suppliername = `Technocom` )
        ( name = `CD/DVD case: 264 sleeves` suppliername = `Titanium` )
        ( name = `Audio/Video Cable Kit - 4m` suppliername = `Titanium` )
        ( name = `Removable CD/DVD Laser Labels` suppliername = `Titanium` )
        ( name = `Beam Breaker B-1` suppliername = `Titanium` )
        ( name = `Beam Breaker B-2` suppliername = `Technocom` )
        ( name = `Beam Breaker B-3` suppliername = `Technocom` )
        ( name = `Play Movie` suppliername = `Fasttech` )
        ( name = `Record Movie` suppliername = `Fasttech` )
        ( name = `ITelo MusicStick` suppliername = `Fasttech` )
        ( name = `ITelo Jog-Mate` suppliername = `Fasttech` )
        ( name = `Power Pro Player 40` suppliername = `Fasttech` )
        ( name = `Power Pro Player 80` suppliername = `Fasttech` )
        ( name = `Flat Watch HD32` suppliername = `Very Best Screens` )
        ( name = `Flat Watch HD37` suppliername = `Very Best Screens` )
        ( name = `Flat Watch HD41` suppliername = `Very Best Screens` )
        ( name = `Copperberry` suppliername = `Fasttech` )
        ( name = `Silverberry` suppliername = `Fasttech` )
        ( name = `Goldberry` suppliername = `Fasttech` )
        ( name = `Platinberry` suppliername = `Fasttech` )
        ( name = `ITelO FlexTop I4000` suppliername = `Titanium` )
        ( name = `ITelO FlexTop I6300c` suppliername = `Titanium` )
        ( name = `ITelO FlexTop I9100` suppliername = `Titanium` )
        ( name = `ITelO FlexTop I9800` suppliername = `Titanium` )
        ( name = `Smartphone Leather Case` suppliername = `Ultrasonic United` )
        ( name = `Smartphone Alpha` suppliername = `Ultrasonic United` )
        ( name = `Mini Tablet` suppliername = `Ultrasonic United` )
        ( name = `Camcorder View` suppliername = `Ultrasonic United` )
        ( name = `Tablet Pouch` suppliername = `Titanium` )
        ( name = `Tablet Pouch` suppliername = `Titanium` )
        ( name = `e-Book Reader ReadMe` suppliername = `Titanium` )
        ( name = `Smartphone Beta` suppliername = `Titanium` )
        ( name = `Maxi Tablet` suppliername = `Titanium` )
        ( name = `Flyer` suppliername = `Titanium` ) ).

  ENDMETHOD.

ENDCLASS.
