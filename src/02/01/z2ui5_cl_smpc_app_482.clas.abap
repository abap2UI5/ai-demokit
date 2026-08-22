" @keywords standardlistitem standard list item sap.m standardlistitemnavigated
" @summary This example demonstrates the navigated property of the list item.
CLASS z2ui5_cl_smpc_app_482 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             name      TYPE string,
             productid TYPE string,
             navigated TYPE abap_bool,
           END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

    DATA t_products TYPE ty_t_product.
  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_482 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( `List`
            )->a( n = `id`         v = `ShortProductList`
            )->a( n = `headerText` v = `Products (Click on an item to set as navigated)`
            )->a( n = `items`      v = |\{ path: '{ client->_bind( val = t_products path = abap_true ) }', sorter: \{ path: 'NAME' \} \}|

            )->ele( `items`
                " isNavigated compares the pressed ProductId with the one the settings
                " model holds - the comparison is business logic, so the flag is a
                " model field the press wire sets in ABAP
                )->tag( `StandardListItem`
                    )->a( n = `type`      v = `Active`
                    )->a( n = `title`     v = `{NAME}`
                    )->a( n = `navigated` v = `{NAVIGATED}`
                    )->a( n = `press`     v = client->_event( val   = `PRESS`
                                                              t_arg = VALUE #( ( `${PRODUCTID}` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `PRESS`.

      " onPress writes the pressed row's ProductId into the settings model, which
      " the navigated formatter compares against every row
      DATA(pressed_id) = client->get_event_arg( ).
      LOOP AT t_products ASSIGNING FIELD-SYMBOL(<product>).
        <product>-navigated = xsdbool( <product>-productid = pressed_id ).
      ENDLOOP.

    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " full mock /ProductCollection of ui5/mock/products.json (the bound fields)
    t_products = VALUE #(
        ( name = `Notebook Basic 15` productid = `HT-1000` )
        ( name = `Notebook Basic 17` productid = `HT-1001` )
        ( name = `Notebook Basic 18` productid = `HT-1002` )
        ( name = `Notebook Basic 19` productid = `HT-1003` )
        ( name = `ITelO Vault` productid = `HT-1007` )
        ( name = `Notebook Professional 15` productid = `HT-1010` )
        ( name = `Notebook Professional 17` productid = `HT-1011` )
        ( name = `ITelO Vault Net` productid = `HT-1020` )
        ( name = `ITelO Vault SAT` productid = `HT-1021` )
        ( name = `Comfort Easy` productid = `HT-1022` )
        ( name = `Comfort Senior` productid = `HT-1023` )
        ( name = `Ergo Screen E-I` productid = `HT-1030` )
        ( name = `Ergo Screen E-II` productid = `HT-1031` )
        ( name = `Ergo Screen E-III` productid = `HT-1032` )
        ( name = `Flat Basic` productid = `HT-1035` )
        ( name = `Flat Future` productid = `HT-1036` )
        ( name = `Flat XL` productid = `HT-1037` )
        ( name = `Laser Professional Eco` productid = `HT-1040` )
        ( name = `Laser Basic` productid = `HT-1041` )
        ( name = `Laser Allround` productid = `HT-1042` )
        ( name = `Ultra Jet Super Color` productid = `HT-1050` )
        ( name = `Ultra Jet Mobile` productid = `HT-1051` )
        ( name = `Ultra Jet Super Highspeed` productid = `HT-1052` )
        ( name = `Multi Print` productid = `HT-1055` )
        ( name = `Multi Color` productid = `HT-1056` )
        ( name = `Cordless Mouse` productid = `HT-1060` )
        ( name = `Speed Mouse` productid = `HT-1061` )
        ( name = `Track Mouse` productid = `HT-1062` )
        ( name = `Ergonomic Keyboard` productid = `HT-1063` )
        ( name = `Internet Keyboard` productid = `HT-1064` )
        ( name = `Media Keyboard` productid = `HT-1065` )
        ( name = `Mousepad` productid = `HT-1066` )
        ( name = `Ergo Mousepad` productid = `HT-1067` )
        ( name = `Designer Mousepad` productid = `HT-1068` )
        ( name = `Universal card reader` productid = `HT-1069` )
        ( name = `Proctra X` productid = `HT-1070` )
        ( name = `Gladiator MX` productid = `HT-1071` )
        ( name = `Hurricane GX` productid = `HT-1072` )
        ( name = `Hurricane GX/LN` productid = `HT-1073` )
        ( name = `Photo Scan` productid = `HT-1080` )
        ( name = `Power Scan` productid = `HT-1081` )
        ( name = `Jet Scan Professional` productid = `HT-1082` )
        ( name = `Jet Scan Professional` productid = `HT-1083` )
        ( name = `Copymaster` productid = `HT-1085` )
        ( name = `Surround Sound` productid = `HT-1090` )
        ( name = `Blaster Extreme` productid = `HT-1091` )
        ( name = `Sound Booster` productid = `HT-1092` )
        ( name = `Lovely Sound 5.1 Wireless` productid = `HT-1095` )
        ( name = `Lovely Sound 5.1` productid = `HT-1096` )
        ( name = `Lovely Sound Stereo` productid = `HT-1097` )
        ( name = `Smart Office` productid = `HT-1100` )
        ( name = `Smart Design` productid = `HT-1101` )
        ( name = `Smart Network` productid = `HT-1102` )
        ( name = `Smart Multimedia` productid = `HT-1103` )
        ( name = `Smart Games` productid = `HT-1104` )
        ( name = `Smart Internet Antivirus` productid = `HT-1105` )
        ( name = `Smart Firewall` productid = `HT-1106` )
        ( name = `Smart Money` productid = `HT-1107` )
        ( name = `PC Lock` productid = `HT-1110` )
        ( name = `Notebook Lock` productid = `HT-1111` )
        ( name = `Web cam reality` productid = `HT-1112` )
        ( name = `Screen clean` productid = `HT-1113` )
        ( name = `Fabric bag professional` productid = `HT-1114` )
        ( name = `Wireless DSL Router` productid = `HT-1115` )
        ( name = `Wireless DSL Router / Repeater` productid = `HT-1116` )
        ( name = `Wireless DSL Router / Repeater and Print Server` productid = `HT-1117` )
        ( name = `USB Stick` productid = `HT-1118` )
        ( name = `Travel Adapter` productid = `HT-1119` )
        ( name = `Cordless Bluetooth Keyboard, english international` productid = `HT-1120` )
        ( name = `Flat XXL` productid = `HT-1137` )
        ( name = `Pocket Mouse` productid = `HT-1138` )
        ( name = `PC Power Station` productid = `HT-1210` )
        ( name = `Astro Laptop 1516` productid = `HT-1251` )
        ( name = `Astro Phone 6` productid = `HT-1252` )
        ( name = `Benda Laptop 1408` productid = `HT-1253` )
        ( name = `Bending Screen 21HD` productid = `HT-1254` )
        ( name = `Broad Screen 22HD` productid = `HT-1255` )
        ( name = `Cerdik Phone 7` productid = `HT-1256` )
        ( name = `Cepat Tablet 10.5` productid = `HT-1257` )
        ( name = `Cepat Tablet 8` productid = `HT-1258` )
        ( name = `Server Basic` productid = `HT-1500` )
        ( name = `Server Professional` productid = `HT-1501` )
        ( name = `Server Power Pro` productid = `HT-1502` )
        ( name = `Family PC Basic` productid = `HT-1600` )
        ( name = `Family PC Pro` productid = `HT-1601` )
        ( name = `Gaming Monster` productid = `HT-1602` )
        ( name = `Gaming Monster Pro` productid = `HT-1603` )
        ( name = `7" Widescreen Portable DVD Player w MP3` productid = `HT-2000` )
        ( name = `10" Portable DVD player` productid = `HT-2001` )
        ( name = `Portable DVD Player with 9" LCD Monitor` productid = `HT-2002` )
        ( name = `CD/DVD case: 264 sleeves` productid = `HT-2025` )
        ( name = `Audio/Video Cable Kit - 4m` productid = `HT-2026` )
        ( name = `Removable CD/DVD Laser Labels` productid = `HT-2027` )
        ( name = `Beam Breaker B-1` productid = `HT-6100` )
        ( name = `Beam Breaker B-2` productid = `HT-6101` )
        ( name = `Beam Breaker B-3` productid = `HT-6102` )
        ( name = `Play Movie` productid = `HT-6110` )
        ( name = `Record Movie` productid = `HT-6111` )
        ( name = `ITelo MusicStick` productid = `HT-6120` )
        ( name = `ITelo Jog-Mate` productid = `HT-6121` )
        ( name = `Power Pro Player 40` productid = `HT-6122` )
        ( name = `Power Pro Player 80` productid = `HT-6123` )
        ( name = `Flat Watch HD32` productid = `HT-6130` )
        ( name = `Flat Watch HD37` productid = `HT-6131` )
        ( name = `Flat Watch HD41` productid = `HT-6132` )
        ( name = `Copperberry` productid = `HT-7000` )
        ( name = `Silverberry` productid = `HT-7010` )
        ( name = `Goldberry` productid = `HT-7020` )
        ( name = `Platinberry` productid = `HT-7030` )
        ( name = `ITelO FlexTop I4000` productid = `HT-8000` )
        ( name = `ITelO FlexTop I6300c` productid = `HT-8001` )
        ( name = `ITelO FlexTop I9100` productid = `HT-8002` )
        ( name = `ITelO FlexTop I9800` productid = `HT-8003` )
        ( name = `Smartphone Leather Case` productid = `HT-9991` )
        ( name = `Smartphone Alpha` productid = `HT-9992` )
        ( name = `Mini Tablet` productid = `HT-9993` )
        ( name = `Camcorder View` productid = `HT-9994` )
        ( name = `Tablet Pouch` productid = `HT-9995` )
        ( name = `Tablet Pouch` productid = `HT-9996` )
        ( name = `e-Book Reader ReadMe` productid = `HT-9997` )
        ( name = `Smartphone Beta` productid = `HT-9998` )
        ( name = `Maxi Tablet` productid = `HT-9999` )
        ( name = `Flyer` productid = `PF-1000` ) ).

  ENDMETHOD.

ENDCLASS.
