CLASS z2ui5_cl_smpc_app_202 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        productid TYPE string,
        name      TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_202 IMPLEMENTATION.

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
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( `List`
            )->a( n = `id`         v = `ShortProductList`
            )->a( n = `headerText` v = `Products`
            )->a( n = `items`      v = |\{ path: '{ client->_bind( val = t_products path = abap_true ) }', sorter: \{ path: 'NAME' \} \}|

            )->ele( `items`
                )->tag( `StandardListItem`
                    )->a( n = `title`       v = `{NAME}`
                    )->a( n = `description` v = `{PRODUCTID}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " full mock /ProductCollection (sap/ui/demo/mock/products.json) of the original sample, sorted client-side by Name
    t_products = VALUE #(
      ( productid = `HT-1000` name = `Notebook Basic 15` )
      ( productid = `HT-1001` name = `Notebook Basic 17` )
      ( productid = `HT-1002` name = `Notebook Basic 18` )
      ( productid = `HT-1003` name = `Notebook Basic 19` )
      ( productid = `HT-1007` name = `ITelO Vault` )
      ( productid = `HT-1010` name = `Notebook Professional 15` )
      ( productid = `HT-1011` name = `Notebook Professional 17` )
      ( productid = `HT-1020` name = `ITelO Vault Net` )
      ( productid = `HT-1021` name = `ITelO Vault SAT` )
      ( productid = `HT-1022` name = `Comfort Easy` )
      ( productid = `HT-1023` name = `Comfort Senior` )
      ( productid = `HT-1030` name = `Ergo Screen E-I` )
      ( productid = `HT-1031` name = `Ergo Screen E-II` )
      ( productid = `HT-1032` name = `Ergo Screen E-III` )
      ( productid = `HT-1035` name = `Flat Basic` )
      ( productid = `HT-1036` name = `Flat Future` )
      ( productid = `HT-1037` name = `Flat XL` )
      ( productid = `HT-1040` name = `Laser Professional Eco` )
      ( productid = `HT-1041` name = `Laser Basic` )
      ( productid = `HT-1042` name = `Laser Allround` )
      ( productid = `HT-1050` name = `Ultra Jet Super Color` )
      ( productid = `HT-1051` name = `Ultra Jet Mobile` )
      ( productid = `HT-1052` name = `Ultra Jet Super Highspeed` )
      ( productid = `HT-1055` name = `Multi Print` )
      ( productid = `HT-1056` name = `Multi Color` )
      ( productid = `HT-1060` name = `Cordless Mouse` )
      ( productid = `HT-1061` name = `Speed Mouse` )
      ( productid = `HT-1062` name = `Track Mouse` )
      ( productid = `HT-1063` name = `Ergonomic Keyboard` )
      ( productid = `HT-1064` name = `Internet Keyboard` )
      ( productid = `HT-1065` name = `Media Keyboard` )
      ( productid = `HT-1066` name = `Mousepad` )
      ( productid = `HT-1067` name = `Ergo Mousepad` )
      ( productid = `HT-1068` name = `Designer Mousepad` )
      ( productid = `HT-1069` name = `Universal card reader` )
      ( productid = `HT-1070` name = `Proctra X` )
      ( productid = `HT-1071` name = `Gladiator MX` )
      ( productid = `HT-1072` name = `Hurricane GX` )
      ( productid = `HT-1073` name = `Hurricane GX/LN` )
      ( productid = `HT-1080` name = `Photo Scan` )
      ( productid = `HT-1081` name = `Power Scan` )
      ( productid = `HT-1082` name = `Jet Scan Professional` )
      ( productid = `HT-1083` name = `Jet Scan Professional` )
      ( productid = `HT-1085` name = `Copymaster` )
      ( productid = `HT-1090` name = `Surround Sound` )
      ( productid = `HT-1091` name = `Blaster Extreme` )
      ( productid = `HT-1092` name = `Sound Booster` )
      ( productid = `HT-1095` name = `Lovely Sound 5.1 Wireless` )
      ( productid = `HT-1096` name = `Lovely Sound 5.1` )
      ( productid = `HT-1097` name = `Lovely Sound Stereo` )
      ( productid = `HT-1100` name = `Smart Office` )
      ( productid = `HT-1101` name = `Smart Design` )
      ( productid = `HT-1102` name = `Smart Network` )
      ( productid = `HT-1103` name = `Smart Multimedia` )
      ( productid = `HT-1104` name = `Smart Games` )
      ( productid = `HT-1105` name = `Smart Internet Antivirus` )
      ( productid = `HT-1106` name = `Smart Firewall` )
      ( productid = `HT-1107` name = `Smart Money` )
      ( productid = `HT-1110` name = `PC Lock` )
      ( productid = `HT-1111` name = `Notebook Lock` )
      ( productid = `HT-1112` name = `Web cam reality` )
      ( productid = `HT-1113` name = `Screen clean` )
      ( productid = `HT-1114` name = `Fabric bag professional` )
      ( productid = `HT-1115` name = `Wireless DSL Router` )
      ( productid = `HT-1116` name = `Wireless DSL Router / Repeater` )
      ( productid = `HT-1117` name = `Wireless DSL Router / Repeater and Print Server` )
      ( productid = `HT-1118` name = `USB Stick` )
      ( productid = `HT-1119` name = `Travel Adapter` )
      ( productid = `HT-1120` name = `Cordless Bluetooth Keyboard, english international` )
      ( productid = `HT-1137` name = `Flat XXL` )
      ( productid = `HT-1138` name = `Pocket Mouse` )
      ( productid = `HT-1210` name = `PC Power Station` )
      ( productid = `HT-1251` name = `Astro Laptop 1516` )
      ( productid = `HT-1252` name = `Astro Phone 6` )
      ( productid = `HT-1253` name = `Benda Laptop 1408` )
      ( productid = `HT-1254` name = `Bending Screen 21HD` )
      ( productid = `HT-1255` name = `Broad Screen 22HD` )
      ( productid = `HT-1256` name = `Cerdik Phone 7` )
      ( productid = `HT-1257` name = `Cepat Tablet 10.5` )
      ( productid = `HT-1258` name = `Cepat Tablet 8` )
      ( productid = `HT-1500` name = `Server Basic` )
      ( productid = `HT-1501` name = `Server Professional` )
      ( productid = `HT-1502` name = `Server Power Pro` )
      ( productid = `HT-1600` name = `Family PC Basic` )
      ( productid = `HT-1601` name = `Family PC Pro` )
      ( productid = `HT-1602` name = `Gaming Monster` )
      ( productid = `HT-1603` name = `Gaming Monster Pro` )
      ( productid = `HT-2000` name = `7" Widescreen Portable DVD Player w MP3` )
      ( productid = `HT-2001` name = `10" Portable DVD player` )
      ( productid = `HT-2002` name = `Portable DVD Player with 9" LCD Monitor` )
      ( productid = `HT-2025` name = `CD/DVD case: 264 sleeves` )
      ( productid = `HT-2026` name = `Audio/Video Cable Kit - 4m` )
      ( productid = `HT-2027` name = `Removable CD/DVD Laser Labels` )
      ( productid = `HT-6100` name = `Beam Breaker B-1` )
      ( productid = `HT-6101` name = `Beam Breaker B-2` )
      ( productid = `HT-6102` name = `Beam Breaker B-3` )
      ( productid = `HT-6110` name = `Play Movie` )
      ( productid = `HT-6111` name = `Record Movie` )
      ( productid = `HT-6120` name = `ITelo MusicStick` )
      ( productid = `HT-6121` name = `ITelo Jog-Mate` )
      ( productid = `HT-6122` name = `Power Pro Player 40` )
      ( productid = `HT-6123` name = `Power Pro Player 80` )
      ( productid = `HT-6130` name = `Flat Watch HD32` )
      ( productid = `HT-6131` name = `Flat Watch HD37` )
      ( productid = `HT-6132` name = `Flat Watch HD41` )
      ( productid = `HT-7000` name = `Copperberry` )
      ( productid = `HT-7010` name = `Silverberry` )
      ( productid = `HT-7020` name = `Goldberry` )
      ( productid = `HT-7030` name = `Platinberry` )
      ( productid = `HT-8000` name = `ITelO FlexTop I4000` )
      ( productid = `HT-8001` name = `ITelO FlexTop I6300c` )
      ( productid = `HT-8002` name = `ITelO FlexTop I9100` )
      ( productid = `HT-8003` name = `ITelO FlexTop I9800` )
      ( productid = `HT-9991` name = `Smartphone Leather Case` )
      ( productid = `HT-9992` name = `Smartphone Alpha` )
      ( productid = `HT-9993` name = `Mini Tablet` )
      ( productid = `HT-9994` name = `Camcorder View` )
      ( productid = `HT-9995` name = `Tablet Pouch` )
      ( productid = `HT-9996` name = `Tablet Pouch` )
      ( productid = `HT-9997` name = `e-Book Reader ReadMe` )
      ( productid = `HT-9998` name = `Smartphone Beta` )
      ( productid = `HT-9999` name = `Maxi Tablet` )
      ( productid = `PF-1000` name = `Flyer` )
    ).

  ENDMETHOD.

ENDCLASS.
