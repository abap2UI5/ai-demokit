" @keywords searchfield search field sap.m searchfieldsuggestions label suggestionitem
" @summary Add suggestion capabilities to a basic Search Field.
CLASS z2ui5_cl_smpc_app_420 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             productid    TYPE string,
             name         TYPE string,
             price        TYPE string,
             currencycode TYPE string,
           END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_420 IMPLEMENTATION.

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
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `height`    v = `100%`

        )->ele( `Page`
            )->a( n = `showHeader` v = `false`

            )->tag( `Label`
                )->a( n = `text` v = `Suggestions Search: `
                )->a( n = `id`   v = `idSuggestionsSearch`
            )->ele( `SearchField`
                )->a( n = `id`                v = `searchField`
                )->a( n = `width`             v = `50%`
                )->a( n = `placeholder`       v = `Search for...`
                )->a( n = `enableSuggestions` v = `true`
                " onSearch: toast the selected suggestion's text, or a generic message
                " when the search fired without one - composed on the client, roundtrip-free
                )->a( n = `search`            v = client->follow_up_action( val   = client->cs_event-control_global
                                                                            t_arg = VALUE #( ( `MESSAGE_TOAST` )
                                                                                             ( `show` )
                                                                                             ( `{0}` )
                                                                                             ( `${$parameters>/suggestionItem} ? 'Search for: ' + ${$parameters>/suggestionItem}.getText() : 'Search is fired!'` ) ) )
                )->a( n = `suggest`           v = client->_event( val   = `SUGGEST`
                                                                  t_arg = VALUE #( ( `${$parameters>/suggestValue}` ) ) )
                )->a( n = `suggestionItems`   v = |\{ path: '{ client->_bind( val = t_products path = abap_true ) }', sorter: \{ path: 'NAME' \} \}|

                )->ele( `suggestionItems`
                    )->tag( `SuggestionItem`
                        )->a( n = `text`        v = `{NAME}`
                        )->a( n = `description` v = `{path:'PRICE'} {path:'CURRENCYCODE'}`
                        )->a( n = `key`         v = `{PRODUCTID}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `SUGGEST`.
      " onSuggest: OR-Contains filter on ProductId and Name (the original's two
      " case-insensitive indexOf test functions), applied to the suggestionItems
      " binding - the model stays untouched; an empty value clears the filter
      DATA(value) = client->get_event_arg( ).
      DATA(json_groups) = `[]`.
      IF value IS NOT INITIAL.
        DATA(escaped) = replace( val = value sub = `\` with = `\\` occ = 0 ).
        escaped = replace( val = escaped sub = `"` with = `\"` occ = 0 ).
        json_groups = |[[["PRODUCTID","Contains","{ escaped }"],["NAME","Contains","{ escaped }"]]]|.
      ENDIF.
      client->follow_up_action( val   = client->cs_event-binding_call
                                t_arg = VALUE #( ( `searchField` ) ( `suggestionItems` ) ( `filter` ) ( json_groups ) ) ).
      " this.oSF.suggest( ) - reopen the suggestions popover on the filtered set
      client->follow_up_action( val   = client->cs_event-control_by_id
                                t_arg = VALUE #( ( `searchField` ) ( `suggest` ) ) ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " full mock /ProductCollection (sap/ui/demo/mock/products.json) of the original sample
    t_products = VALUE #(
        ( productid = `HT-1000` name = `Notebook Basic 15` price = `956` currencycode = `EUR` )
        ( productid = `HT-1001` name = `Notebook Basic 17` price = `1249` currencycode = `EUR` )
        ( productid = `HT-1002` name = `Notebook Basic 18` price = `1570` currencycode = `EUR` )
        ( productid = `HT-1003` name = `Notebook Basic 19` price = `1650` currencycode = `EUR` )
        ( productid = `HT-1007` name = `ITelO Vault` price = `299` currencycode = `EUR` )
        ( productid = `HT-1010` name = `Notebook Professional 15` price = `1999` currencycode = `EUR` )
        ( productid = `HT-1011` name = `Notebook Professional 17` price = `2299` currencycode = `EUR` )
        ( productid = `HT-1020` name = `ITelO Vault Net` price = `459` currencycode = `EUR` )
        ( productid = `HT-1021` name = `ITelO Vault SAT` price = `149` currencycode = `EUR` )
        ( productid = `HT-1022` name = `Comfort Easy` price = `1679` currencycode = `EUR` )
        ( productid = `HT-1023` name = `Comfort Senior` price = `512` currencycode = `EUR` )
        ( productid = `HT-1030` name = `Ergo Screen E-I` price = `230` currencycode = `EUR` )
        ( productid = `HT-1031` name = `Ergo Screen E-II` price = `285` currencycode = `EUR` )
        ( productid = `HT-1032` name = `Ergo Screen E-III` price = `345` currencycode = `EUR` )
        ( productid = `HT-1035` name = `Flat Basic` price = `399` currencycode = `EUR` )
        ( productid = `HT-1036` name = `Flat Future` price = `430` currencycode = `EUR` )
        ( productid = `HT-1037` name = `Flat XL` price = `1230` currencycode = `EUR` )
        ( productid = `HT-1040` name = `Laser Professional Eco` price = `830` currencycode = `EUR` )
        ( productid = `HT-1041` name = `Laser Basic` price = `490` currencycode = `EUR` )
        ( productid = `HT-1042` name = `Laser Allround` price = `349` currencycode = `EUR` )
        ( productid = `HT-1050` name = `Ultra Jet Super Color` price = `139` currencycode = `EUR` )
        ( productid = `HT-1051` name = `Ultra Jet Mobile` price = `99` currencycode = `EUR` )
        ( productid = `HT-1052` name = `Ultra Jet Super Highspeed` price = `170` currencycode = `EUR` )
        ( productid = `HT-1055` name = `Multi Print` price = `99` currencycode = `EUR` )
        ( productid = `HT-1056` name = `Multi Color` price = `119` currencycode = `EUR` )
        ( productid = `HT-1060` name = `Cordless Mouse` price = `9` currencycode = `EUR` )
        ( productid = `HT-1061` name = `Speed Mouse` price = `7` currencycode = `EUR` )
        ( productid = `HT-1062` name = `Track Mouse` price = `11` currencycode = `EUR` )
        ( productid = `HT-1063` name = `Ergonomic Keyboard` price = `14` currencycode = `EUR` )
        ( productid = `HT-1064` name = `Internet Keyboard` price = `16` currencycode = `EUR` )
        ( productid = `HT-1065` name = `Media Keyboard` price = `26` currencycode = `EUR` )
        ( productid = `HT-1066` name = `Mousepad` price = `6.99` currencycode = `EUR` )
        ( productid = `HT-1067` name = `Ergo Mousepad` price = `8.99` currencycode = `EUR` )
        ( productid = `HT-1068` name = `Designer Mousepad` price = `12.99` currencycode = `EUR` )
        ( productid = `HT-1069` name = `Universal card reader` price = `14` currencycode = `EUR` )
        ( productid = `HT-1070` name = `Proctra X` price = `70.9` currencycode = `EUR` )
        ( productid = `HT-1071` name = `Gladiator MX` price = `81.7` currencycode = `EUR` )
        ( productid = `HT-1072` name = `Hurricane GX` price = `101.2` currencycode = `EUR` )
        ( productid = `HT-1073` name = `Hurricane GX/LN` price = `139.99` currencycode = `EUR` )
        ( productid = `HT-1080` name = `Photo Scan` price = `129` currencycode = `EUR` )
        ( productid = `HT-1081` name = `Power Scan` price = `89` currencycode = `EUR` )
        ( productid = `HT-1082` name = `Jet Scan Professional` price = `169` currencycode = `EUR` )
        ( productid = `HT-1083` name = `Jet Scan Professional` price = `189` currencycode = `EUR` )
        ( productid = `HT-1085` name = `Copymaster` price = `1499` currencycode = `EUR` )
        ( productid = `HT-1090` name = `Surround Sound` price = `39` currencycode = `EUR` )
        ( productid = `HT-1091` name = `Blaster Extreme` price = `26` currencycode = `EUR` )
        ( productid = `HT-1092` name = `Sound Booster` price = `45` currencycode = `EUR` )
        ( productid = `HT-1095` name = `Lovely Sound 5.1 Wireless` price = `49` currencycode = `EUR` )
        ( productid = `HT-1096` name = `Lovely Sound 5.1` price = `39` currencycode = `EUR` )
        ( productid = `HT-1097` name = `Lovely Sound Stereo` price = `29` currencycode = `EUR` )
        ( productid = `HT-1100` name = `Smart Office` price = `89.9` currencycode = `EUR` )
        ( productid = `HT-1101` name = `Smart Design` price = `79.9` currencycode = `EUR` )
        ( productid = `HT-1102` name = `Smart Network` price = `69` currencycode = `EUR` )
        ( productid = `HT-1103` name = `Smart Multimedia` price = `77` currencycode = `EUR` )
        ( productid = `HT-1104` name = `Smart Games` price = `55` currencycode = `EUR` )
        ( productid = `HT-1105` name = `Smart Internet Antivirus` price = `29` currencycode = `EUR` )
        ( productid = `HT-1106` name = `Smart Firewall` price = `34` currencycode = `EUR` )
        ( productid = `HT-1107` name = `Smart Money` price = `29.9` currencycode = `EUR` )
        ( productid = `HT-1110` name = `PC Lock` price = `8.9` currencycode = `EUR` )
        ( productid = `HT-1111` name = `Notebook Lock` price = `6.9` currencycode = `EUR` )
        ( productid = `HT-1112` name = `Web cam reality` price = `39` currencycode = `EUR` )
        ( productid = `HT-1113` name = `Screen clean` price = `2.3` currencycode = `EUR` )
        ( productid = `HT-1114` name = `Fabric bag professional` price = `31` currencycode = `EUR` )
        ( productid = `HT-1115` name = `Wireless DSL Router` price = `49` currencycode = `EUR` )
        ( productid = `HT-1116` name = `Wireless DSL Router / Repeater` price = `59` currencycode = `EUR` )
        ( productid = `HT-1117` name = `Wireless DSL Router / Repeater and Print Server` price = `69` currencycode = `EUR` )
        ( productid = `HT-1118` name = `USB Stick` price = `35` currencycode = `EUR` )
        ( productid = `HT-1119` name = `Travel Adapter` price = `79` currencycode = `EUR` )
        ( productid = `HT-1120` name = `Cordless Bluetooth Keyboard, english international` price = `29` currencycode = `EUR` )
        ( productid = `HT-1137` name = `Flat XXL` price = `1430` currencycode = `EUR` )
        ( productid = `HT-1138` name = `Pocket Mouse` price = `23` currencycode = `EUR` )
        ( productid = `HT-1210` name = `PC Power Station` price = `2399` currencycode = `EUR` )
        ( productid = `HT-1251` name = `Astro Laptop 1516` price = `989` currencycode = `EUR` )
        ( productid = `HT-1252` name = `Astro Phone 6` price = `649` currencycode = `EUR` )
        ( productid = `HT-1253` name = `Benda Laptop 1408` price = `976` currencycode = `EUR` )
        ( productid = `HT-1254` name = `Bending Screen 21HD` price = `250` currencycode = `EUR` )
        ( productid = `HT-1255` name = `Broad Screen 22HD` price = `270` currencycode = `EUR` )
        ( productid = `HT-1256` name = `Cerdik Phone 7` price = `549` currencycode = `EUR` )
        ( productid = `HT-1257` name = `Cepat Tablet 10.5` price = `549` currencycode = `EUR` )
        ( productid = `HT-1258` name = `Cepat Tablet 8` price = `529` currencycode = `EUR` )
        ( productid = `HT-1500` name = `Server Basic` price = `5000` currencycode = `EUR` )
        ( productid = `HT-1501` name = `Server Professional` price = `15000` currencycode = `EUR` )
        ( productid = `HT-1502` name = `Server Power Pro` price = `25000` currencycode = `EUR` )
        ( productid = `HT-1600` name = `Family PC Basic` price = `600` currencycode = `EUR` )
        ( productid = `HT-1601` name = `Family PC Pro` price = `900` currencycode = `EUR` )
        ( productid = `HT-1602` name = `Gaming Monster` price = `1200` currencycode = `EUR` )
        ( productid = `HT-1603` name = `Gaming Monster Pro` price = `1700` currencycode = `EUR` )
        ( productid = `HT-2000` name = `7" Widescreen Portable DVD Player w MP3` price = `249.99` currencycode = `EUR` )
        ( productid = `HT-2001` name = `10" Portable DVD player` price = `449.99` currencycode = `EUR` )
        ( productid = `HT-2002` name = `Portable DVD Player with 9" LCD Monitor` price = `853.99` currencycode = `EUR` )
        ( productid = `HT-2025` name = `CD/DVD case: 264 sleeves` price = `44.99` currencycode = `EUR` )
        ( productid = `HT-2026` name = `Audio/Video Cable Kit - 4m` price = `29.99` currencycode = `EUR` )
        ( productid = `HT-2027` name = `Removable CD/DVD Laser Labels` price = `8.99` currencycode = `EUR` )
        ( productid = `HT-6100` name = `Beam Breaker B-1` price = `469` currencycode = `EUR` )
        ( productid = `HT-6101` name = `Beam Breaker B-2` price = `679` currencycode = `EUR` )
        ( productid = `HT-6102` name = `Beam Breaker B-3` price = `889` currencycode = `EUR` )
        ( productid = `HT-6110` name = `Play Movie` price = `130` currencycode = `EUR` )
        ( productid = `HT-6111` name = `Record Movie` price = `288` currencycode = `EUR` )
        ( productid = `HT-6120` name = `ITelo MusicStick` price = `45` currencycode = `EUR` )
        ( productid = `HT-6121` name = `ITelo Jog-Mate` price = `63` currencycode = `EUR` )
        ( productid = `HT-6122` name = `Power Pro Player 40` price = `167` currencycode = `EUR` )
        ( productid = `HT-6123` name = `Power Pro Player 80` price = `299` currencycode = `EUR` )
        ( productid = `HT-6130` name = `Flat Watch HD32` price = `1459` currencycode = `EUR` )
        ( productid = `HT-6131` name = `Flat Watch HD37` price = `1199` currencycode = `EUR` )
        ( productid = `HT-6132` name = `Flat Watch HD41` price = `899` currencycode = `EUR` )
        ( productid = `HT-7000` name = `Copperberry` price = `549` currencycode = `EUR` )
        ( productid = `HT-7010` name = `Silverberry` price = `549` currencycode = `EUR` )
        ( productid = `HT-7020` name = `Goldberry` price = `549` currencycode = `EUR` )
        ( productid = `HT-7030` name = `Platinberry` price = `549` currencycode = `EUR` )
        ( productid = `HT-8000` name = `ITelO FlexTop I4000` price = `799` currencycode = `EUR` )
        ( productid = `HT-8001` name = `ITelO FlexTop I6300c` price = `799` currencycode = `EUR` )
        ( productid = `HT-8002` name = `ITelO FlexTop I9100` price = `1199` currencycode = `EUR` )
        ( productid = `HT-8003` name = `ITelO FlexTop I9800` price = `1388` currencycode = `EUR` )
        ( productid = `HT-9991` name = `Smartphone Leather Case` price = `25` currencycode = `EUR` )
        ( productid = `HT-9992` name = `Smartphone Alpha` price = `599` currencycode = `EUR` )
        ( productid = `HT-9993` name = `Mini Tablet` price = `833` currencycode = `EUR` )
        ( productid = `HT-9994` name = `Camcorder View` price = `1388` currencycode = `EUR` )
        ( productid = `HT-9995` name = `Tablet Pouch` price = `20` currencycode = `EUR` )
        ( productid = `HT-9996` name = `Tablet Pouch` price = `20` currencycode = `EUR` )
        ( productid = `HT-9997` name = `e-Book Reader ReadMe` price = `33` currencycode = `EUR` )
        ( productid = `HT-9998` name = `Smartphone Beta` price = `30` currencycode = `EUR` )
        ( productid = `HT-9999` name = `Maxi Tablet` price = `749` currencycode = `EUR` )
        ( productid = `PF-1000` name = `Flyer` price = `0` currencycode = `EUR` ) ).

  ENDMETHOD.

ENDCLASS.
