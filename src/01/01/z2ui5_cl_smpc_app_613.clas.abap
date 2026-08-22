" @keywords multiinput multi input sap.m multiinputgrouping token column label columnlistitem
" @summary Items in the MultiInput could be grouped by a property
CLASS z2ui5_cl_smpc_app_613 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             name         TYPE string,
             productid    TYPE string,
             suppliername TYPE string,
             price        TYPE string,
             currencycode TYPE string,
           END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

    TYPES: BEGIN OF ty_s_token,
             key  TYPE string,
             text TYPE string,
           END OF ty_s_token.
    TYPES ty_t_token TYPE STANDARD TABLE OF ty_s_token WITH EMPTY KEY.

    DATA t_products TYPE ty_t_product.
    DATA t_tokens   TYPE ty_t_token.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_613 IMPLEMENTATION.

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

    DATA(layout) = view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%` ).

    " both MultiInputs group their suggestions by SupplierName, descending -
    " the grouping sorter of the original binding-info rides along verbatim,
    " UI5 builds the group headers from it on the client
    layout->tag( `Label`
        )->a( n = `text`     v = `Multi Input with grouped suggestions`
        )->a( n = `labelFor` v = `productMIWithList`

        )->ele( `MultiInput`
            )->a( n = `id`              v = `productMIWithList`
            )->a( n = `type`            v = `Text`
            )->a( n = `placeholder`     v = `Enter Product ...`
            )->a( n = `showSuggestion`  v = `true`
            )->a( n = `showValueHelp`   v = `false`
            )->a( n = `suggestionItems` v = |\{ path: '{ client->_bind( val = t_products path = abap_true ) }', sorter: \{ path: 'SUPPLIERNAME', group: true, ascending: false \} \}|

            )->ele( `suggestionItems`
                )->tag( n = `Item` ns = `core`
                    )->a( n = `text` v = `{NAME}`
                    )->a( n = `key`  v = `{PRODUCTID}`

            )->end(
        )->end( ).

    " the tabular one carries the controller's addValidator( ): the picked row
    " becomes a Token with key = the Name cell and text = 'key(price cell)'.
    " abap2UI5 cannot register a JS validator, so suggestionItemSelected
    " transports the first cell and the same token is built in ABAP
    layout->tag( `Label`
        )->a( n = `text`     v = `Multi Input with grouped tabular suggestions`
        )->a( n = `labelFor` v = `productMIWithTable`

        )->ele( `MultiInput`
            )->a( n = `id`                           v = `productMIWithTable`
            )->a( n = `type`                         v = `Text`
            )->a( n = `placeholder`                  v = `Enter Product ...`
            )->a( n = `showSuggestion`               v = `true`
            )->a( n = `showValueHelp`                v = `false`
            )->a( n = `showTableSuggestionValueHelp` v = `false`
            )->a( n = `tokens`                       v = client->_bind( t_tokens )
            )->a( n = `suggestionRows`               v = |\{ path: '{ client->_bind( val = t_products path = abap_true ) }', sorter: \{ path: 'SUPPLIERNAME', group: true, ascending: false \} \}|
            )->a( n = `suggestionItemSelected`       v = client->_event( val   = `ADD_TOKEN`
                                                                         t_arg = VALUE #( ( `${$parameters>/selectedRow}.getCells()[0].getText()` ) ) )

            )->ele( `tokens`
                )->tag( `Token`
                    )->a( n = `key`  v = `{KEY}`
                    )->a( n = `text` v = `{TEXT}`

            )->end(

            )->ele( `suggestionColumns`
                )->ele( `Column`
                    )->a( n = `hAlign`       v = `Begin`
                    )->a( n = `popinDisplay` v = `Inline`
                    )->a( n = `demandPopin`  v = `true`
                    )->tag( `Label`
                        )->a( n = `text` v = `Name`

                )->end(
                )->ele( `Column`
                    )->a( n = `hAlign`         v = `Center`
                    )->a( n = `popinDisplay`   v = `Inline`
                    )->a( n = `demandPopin`    v = `true`
                    )->a( n = `minScreenWidth` v = `Tablet`
                    )->tag( `Label`
                        )->a( n = `text` v = `Product ID`

                )->end(
                )->ele( `Column`
                    )->a( n = `hAlign`         v = `Center`
                    )->a( n = `popinDisplay`   v = `Inline`
                    )->a( n = `demandPopin`    v = `false`
                    )->a( n = `minScreenWidth` v = `Tablet`
                    )->tag( `Label`
                        )->a( n = `text` v = `Supplier Name`

                )->end(
                )->ele( `Column`
                    )->a( n = `hAlign`       v = `End`
                    )->a( n = `popinDisplay` v = `Inline`
                    )->a( n = `demandPopin`  v = `true`
                    )->tag( `Label`
                        )->a( n = `text` v = `Price`

                )->end(
            )->end(

            )->ele( `suggestionRows`
                )->ele( `ColumnListItem`
                    )->tag( `Label`
                        )->a( n = `text` v = `{NAME}`
                    )->tag( `Label`
                        )->a( n = `text` v = `{PRODUCTID}`
                    )->tag( `Label`
                        )->a( n = `text` v = `{SUPPLIERNAME}`
                    )->tag( `Label`
                        )->a( n = `text` v = `{PRICE} {CURRENCYCODE}`

                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    " the validator: key = the row's first cell, text = 'key(price cell)'
    IF client->get_event( ) = `ADD_TOKEN`.
      DATA(name) = client->get_event_arg( ).
      READ TABLE t_products INTO DATA(product) WITH KEY name = name.
      IF sy-subrc = 0 AND NOT line_exists( t_tokens[ key = product-name ] ).
        APPEND VALUE #( key  = product-name
                        text = |{ product-name }({ product-price } { product-currencycode })| ) TO t_tokens.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " sap/ui/demo/mock/products.json /ProductCollection - the suggestion items
    " and the suggestion rows of both MultiInputs. The controller raises the
    " model's size limit to 1000000 so that all of them stay visible
    t_products = VALUE #(
      ( name = `Notebook Basic 15` productid = `HT-1000` suppliername = `Very Best Screens` price = `956` currencycode = `EUR` )
      ( name = `Notebook Basic 17` productid = `HT-1001` suppliername = `Very Best Screens` price = `1249` currencycode = `EUR` )
      ( name = `Notebook Basic 18` productid = `HT-1002` suppliername = `Very Best Screens` price = `1570` currencycode = `EUR` )
      ( name = `Notebook Basic 19` productid = `HT-1003` suppliername = `Smartcards` price = `1650` currencycode = `EUR` )
      ( name = `ITelO Vault` productid = `HT-1007` suppliername = `Technocom` price = `299` currencycode = `EUR` )
      ( name = `Notebook Professional 15` productid = `HT-1010` suppliername = `Very Best Screens` price = `1999` currencycode = `EUR` )
      ( name = `Notebook Professional 17` productid = `HT-1011` suppliername = `Very Best Screens` price = `2299` currencycode = `EUR` )
      ( name = `ITelO Vault Net` productid = `HT-1020` suppliername = `Technocom` price = `459` currencycode = `EUR` )
      ( name = `ITelO Vault SAT` productid = `HT-1021` suppliername = `Technocom` price = `149` currencycode = `EUR` )
      ( name = `Comfort Easy` productid = `HT-1022` suppliername = `Technocom` price = `1679` currencycode = `EUR` )
      ( name = `Comfort Senior` productid = `HT-1023` suppliername = `Technocom` price = `512` currencycode = `EUR` )
      ( name = `Ergo Screen E-I` productid = `HT-1030` suppliername = `Very Best Screens` price = `230` currencycode = `EUR` )
      ( name = `Ergo Screen E-II` productid = `HT-1031` suppliername = `Very Best Screens` price = `285` currencycode = `EUR` )
      ( name = `Ergo Screen E-III` productid = `HT-1032` suppliername = `Very Best Screens` price = `345` currencycode = `EUR` )
      ( name = `Flat Basic` productid = `HT-1035` suppliername = `Very Best Screens` price = `399` currencycode = `EUR` )
      ( name = `Flat Future` productid = `HT-1036` suppliername = `Very Best Screens` price = `430` currencycode = `EUR` )
      ( name = `Flat XL` productid = `HT-1037` suppliername = `Very Best Screens` price = `1230` currencycode = `EUR` )
      ( name = `Laser Professional Eco` productid = `HT-1040` suppliername = `Alpha Printers` price = `830` currencycode = `EUR` )
      ( name = `Laser Basic` productid = `HT-1041` suppliername = `Alpha Printers` price = `490` currencycode = `EUR` )
      ( name = `Laser Allround` productid = `HT-1042` suppliername = `Alpha Printers` price = `349` currencycode = `EUR` )
      ( name = `Ultra Jet Super Color` productid = `HT-1050` suppliername = `Alpha Printers` price = `139` currencycode = `EUR` )
      ( name = `Ultra Jet Mobile` productid = `HT-1051` suppliername = `Printer for All` price = `99` currencycode = `EUR` )
      ( name = `Ultra Jet Super Highspeed` productid = `HT-1052` suppliername = `Printer for All` price = `170` currencycode = `EUR` )
      ( name = `Multi Print` productid = `HT-1055` suppliername = `Printer for All` price = `99` currencycode = `EUR` )
      ( name = `Multi Color` productid = `HT-1056` suppliername = `Printer for All` price = `119` currencycode = `EUR` )
      ( name = `Cordless Mouse` productid = `HT-1060` suppliername = `Oxynum` price = `9` currencycode = `EUR` )
      ( name = `Speed Mouse` productid = `HT-1061` suppliername = `Oxynum` price = `7` currencycode = `EUR` )
      ( name = `Track Mouse` productid = `HT-1062` suppliername = `Oxynum` price = `11` currencycode = `EUR` )
      ( name = `Ergonomic Keyboard` productid = `HT-1063` suppliername = `Oxynum` price = `14` currencycode = `EUR` )
      ( name = `Internet Keyboard` productid = `HT-1064` suppliername = `Oxynum` price = `16` currencycode = `EUR` )
      ( name = `Media Keyboard` productid = `HT-1065` suppliername = `Oxynum` price = `26` currencycode = `EUR` )
      ( name = `Mousepad` productid = `HT-1066` suppliername = `Oxynum` price = `6.99` currencycode = `EUR` )
      ( name = `Ergo Mousepad` productid = `HT-1067` suppliername = `Oxynum` price = `8.99` currencycode = `EUR` )
      ( name = `Designer Mousepad` productid = `HT-1068` suppliername = `Fasttech` price = `12.99` currencycode = `EUR` )
      ( name = `Universal card reader` productid = `HT-1069` suppliername = `Fasttech` price = `14` currencycode = `EUR` )
      ( name = `Proctra X` productid = `HT-1070` suppliername = `Ultrasonic United` price = `70.9` currencycode = `EUR` )
      ( name = `Gladiator MX` productid = `HT-1071` suppliername = `Ultrasonic United` price = `81.7` currencycode = `EUR` )
      ( name = `Hurricane GX` productid = `HT-1072` suppliername = `Ultrasonic United` price = `101.2` currencycode = `EUR` )
      ( name = `Hurricane GX/LN` productid = `HT-1073` suppliername = `Smartcards` price = `139.99` currencycode = `EUR` )
      ( name = `Photo Scan` productid = `HT-1080` suppliername = `Printer for All` price = `129` currencycode = `EUR` )
      ( name = `Power Scan` productid = `HT-1081` suppliername = `Printer for All` price = `89` currencycode = `EUR` )
      ( name = `Jet Scan Professional` productid = `HT-1082` suppliername = `Printer for All` price = `169` currencycode = `EUR` )
      ( name = `Jet Scan Professional` productid = `HT-1083` suppliername = `Printer for All` price = `189` currencycode = `EUR` )
      ( name = `Copymaster` productid = `HT-1085` suppliername = `Alpha Printers` price = `1499` currencycode = `EUR` )
      ( name = `Surround Sound` productid = `HT-1090` suppliername = `Speaker Experts` price = `39` currencycode = `EUR` )
      ( name = `Blaster Extreme` productid = `HT-1091` suppliername = `Speaker Experts` price = `26` currencycode = `EUR` )
      ( name = `Sound Booster` productid = `HT-1092` suppliername = `Speaker Experts` price = `45` currencycode = `EUR` )
      ( name = `Lovely Sound 5.1 Wireless` productid = `HT-1095` suppliername = `Fasttech` price = `49` currencycode = `EUR` )
      ( name = `Lovely Sound 5.1` productid = `HT-1096` suppliername = `Fasttech` price = `39` currencycode = `EUR` )
      ( name = `Lovely Sound Stereo` productid = `HT-1097` suppliername = `Fasttech` price = `29` currencycode = `EUR` )
      ( name = `Smart Office` productid = `HT-1100` suppliername = `Technocom` price = `89.9` currencycode = `EUR` )
      ( name = `Smart Design` productid = `HT-1101` suppliername = `Technocom` price = `79.9` currencycode = `EUR` )
      ( name = `Smart Network` productid = `HT-1102` suppliername = `Technocom` price = `69` currencycode = `EUR` )
      ( name = `Smart Multimedia` productid = `HT-1103` suppliername = `Technocom` price = `77` currencycode = `EUR` )
      ( name = `Smart Games` productid = `HT-1104` suppliername = `Technocom` price = `55` currencycode = `EUR` )
      ( name = `Smart Internet Antivirus` productid = `HT-1105` suppliername = `Brainsoft` price = `29` currencycode = `EUR` )
      ( name = `Smart Firewall` productid = `HT-1106` suppliername = `Brainsoft` price = `34` currencycode = `EUR` )
      ( name = `Smart Money` productid = `HT-1107` suppliername = `Brainsoft` price = `29.9` currencycode = `EUR` )
      ( name = `PC Lock` productid = `HT-1110` suppliername = `Red Point Stores` price = `8.9` currencycode = `EUR` )
      ( name = `Notebook Lock` productid = `HT-1111` suppliername = `Red Point Stores` price = `6.9` currencycode = `EUR` )
      ( name = `Web cam reality` productid = `HT-1112` suppliername = `Red Point Stores` price = `39` currencycode = `EUR` )
      ( name = `Screen clean` productid = `HT-1113` suppliername = `Red Point Stores` price = `2.3` currencycode = `EUR` )
      ( name = `Fabric bag professional` productid = `HT-1114` suppliername = `Red Point Stores` price = `31` currencycode = `EUR` )
      ( name = `Wireless DSL Router` productid = `HT-1115` suppliername = `Red Point Stores` price = `49` currencycode = `EUR` )
      ( name = `Wireless DSL Router / Repeater` productid = `HT-1116` suppliername = `Red Point Stores` price = `59` currencycode = `EUR` )
      ( name = `Wireless DSL Router / Repeater and Print Server` productid = `HT-1117` suppliername = `Technocom` price = `69` currencycode = `EUR` )
      ( name = `USB Stick` productid = `HT-1118` suppliername = `Technocom` price = `35` currencycode = `EUR` )
      ( name = `Travel Adapter` productid = `HT-1119` suppliername = `Titanium` price = `79` currencycode = `EUR` )
      ( name = `Cordless Bluetooth Keyboard, english international` productid = `HT-1120` suppliername = `Technocom` price = `29` currencycode = `EUR` )
      ( name = `Flat XXL` productid = `HT-1137` suppliername = `Technocom` price = `1430` currencycode = `EUR` )
      ( name = `Pocket Mouse` productid = `HT-1138` suppliername = `Technocom` price = `23` currencycode = `EUR` )
      ( name = `PC Power Station` productid = `HT-1210` suppliername = `Technocom` price = `2399` currencycode = `EUR` )
      ( name = `Astro Laptop 1516` productid = `HT-1251` suppliername = `Ultrasonic United` price = `989` currencycode = `EUR` )
      ( name = `Astro Phone 6` productid = `HT-1252` suppliername = `Ultrasonic United` price = `649` currencycode = `EUR` )
      ( name = `Benda Laptop 1408` productid = `HT-1253` suppliername = `Ultrasonic United` price = `976` currencycode = `EUR` )
      ( name = `Bending Screen 21HD` productid = `HT-1254` suppliername = `Ultrasonic United` price = `250` currencycode = `EUR` )
      ( name = `Broad Screen 22HD` productid = `HT-1255` suppliername = `Ultrasonic United` price = `270` currencycode = `EUR` )
      ( name = `Cerdik Phone 7` productid = `HT-1256` suppliername = `Ultrasonic United` price = `549` currencycode = `EUR` )
      ( name = `Cepat Tablet 10.5` productid = `HT-1257` suppliername = `Ultrasonic United` price = `549` currencycode = `EUR` )
      ( name = `Cepat Tablet 8` productid = `HT-1258` suppliername = `Ultrasonic United` price = `529` currencycode = `EUR` )
      ( name = `Server Basic` productid = `HT-1500` suppliername = `Technocom` price = `5000` currencycode = `EUR` )
      ( name = `Server Professional` productid = `HT-1501` suppliername = `Technocom` price = `15000` currencycode = `EUR` )
      ( name = `Server Power Pro` productid = `HT-1502` suppliername = `Technocom` price = `25000` currencycode = `EUR` )
      ( name = `Family PC Basic` productid = `HT-1600` suppliername = `Titanium` price = `600` currencycode = `EUR` )
      ( name = `Family PC Pro` productid = `HT-1601` suppliername = `Titanium` price = `900` currencycode = `EUR` )
      ( name = `Gaming Monster` productid = `HT-1602` suppliername = `Titanium` price = `1200` currencycode = `EUR` )
      ( name = `Gaming Monster Pro` productid = `HT-1603` suppliername = `Titanium` price = `1700` currencycode = `EUR` )
      ( name = `7" Widescreen Portable DVD Player w MP3` productid = `HT-2000` suppliername = `Titanium` price = `249.99` currencycode = `EUR` )
      ( name = `10" Portable DVD player` productid = `HT-2001` suppliername = `Titanium` price = `449.99` currencycode = `EUR` )
      ( name = `Portable DVD Player with 9" LCD Monitor` productid = `HT-2002` suppliername = `Technocom` price = `853.99` currencycode = `EUR` )
      ( name = `CD/DVD case: 264 sleeves` productid = `HT-2025` suppliername = `Titanium` price = `44.99` currencycode = `EUR` )
      ( name = `Audio/Video Cable Kit - 4m` productid = `HT-2026` suppliername = `Titanium` price = `29.99` currencycode = `EUR` )
      ( name = `Removable CD/DVD Laser Labels` productid = `HT-2027` suppliername = `Titanium` price = `8.99` currencycode = `EUR` )
      ( name = `Beam Breaker B-1` productid = `HT-6100` suppliername = `Titanium` price = `469` currencycode = `EUR` )
      ( name = `Beam Breaker B-2` productid = `HT-6101` suppliername = `Technocom` price = `679` currencycode = `EUR` )
      ( name = `Beam Breaker B-3` productid = `HT-6102` suppliername = `Technocom` price = `889` currencycode = `EUR` )
      ( name = `Play Movie` productid = `HT-6110` suppliername = `Fasttech` price = `130` currencycode = `EUR` )
      ( name = `Record Movie` productid = `HT-6111` suppliername = `Fasttech` price = `288` currencycode = `EUR` )
      ( name = `ITelo MusicStick` productid = `HT-6120` suppliername = `Fasttech` price = `45` currencycode = `EUR` )
      ( name = `ITelo Jog-Mate` productid = `HT-6121` suppliername = `Fasttech` price = `63` currencycode = `EUR` )
      ( name = `Power Pro Player 40` productid = `HT-6122` suppliername = `Fasttech` price = `167` currencycode = `EUR` )
      ( name = `Power Pro Player 80` productid = `HT-6123` suppliername = `Fasttech` price = `299` currencycode = `EUR` )
      ( name = `Flat Watch HD32` productid = `HT-6130` suppliername = `Very Best Screens` price = `1459` currencycode = `EUR` )
      ( name = `Flat Watch HD37` productid = `HT-6131` suppliername = `Very Best Screens` price = `1199` currencycode = `EUR` )
      ( name = `Flat Watch HD41` productid = `HT-6132` suppliername = `Very Best Screens` price = `899` currencycode = `EUR` )
      ( name = `Copperberry` productid = `HT-7000` suppliername = `Fasttech` price = `549` currencycode = `EUR` )
      ( name = `Silverberry` productid = `HT-7010` suppliername = `Fasttech` price = `549` currencycode = `EUR` )
      ( name = `Goldberry` productid = `HT-7020` suppliername = `Fasttech` price = `549` currencycode = `EUR` )
      ( name = `Platinberry` productid = `HT-7030` suppliername = `Fasttech` price = `549` currencycode = `EUR` )
      ( name = `ITelO FlexTop I4000` productid = `HT-8000` suppliername = `Titanium` price = `799` currencycode = `EUR` )
      ( name = `ITelO FlexTop I6300c` productid = `HT-8001` suppliername = `Titanium` price = `799` currencycode = `EUR` )
      ( name = `ITelO FlexTop I9100` productid = `HT-8002` suppliername = `Titanium` price = `1199` currencycode = `EUR` )
      ( name = `ITelO FlexTop I9800` productid = `HT-8003` suppliername = `Titanium` price = `1388` currencycode = `EUR` )
      ( name = `Smartphone Leather Case` productid = `HT-9991` suppliername = `Ultrasonic United` price = `25` currencycode = `EUR` )
      ( name = `Smartphone Alpha` productid = `HT-9992` suppliername = `Ultrasonic United` price = `599` currencycode = `EUR` )
      ( name = `Mini Tablet` productid = `HT-9993` suppliername = `Ultrasonic United` price = `833` currencycode = `EUR` )
      ( name = `Camcorder View` productid = `HT-9994` suppliername = `Ultrasonic United` price = `1388` currencycode = `EUR` )
      ( name = `Tablet Pouch` productid = `HT-9995` suppliername = `Titanium` price = `20` currencycode = `EUR` )
      ( name = `Tablet Pouch` productid = `HT-9996` suppliername = `Titanium` price = `20` currencycode = `EUR` )
      ( name = `e-Book Reader ReadMe` productid = `HT-9997` suppliername = `Titanium` price = `33` currencycode = `EUR` )
      ( name = `Smartphone Beta` productid = `HT-9998` suppliername = `Titanium` price = `30` currencycode = `EUR` )
      ( name = `Maxi Tablet` productid = `HT-9999` suppliername = `Titanium` price = `749` currencycode = `EUR` )
      ( name = `Flyer` productid = `PF-1000` suppliername = `Titanium` price = `0` currencycode = `EUR` )
    ).

  ENDMETHOD.

ENDCLASS.
