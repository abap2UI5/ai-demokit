CLASS z2ui5_cl_ai_app_174 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        status       TYPE string,
        statustext   TYPE string,
        name         TYPE string,
        productid    TYPE string,
        quantity     TYPE i,
        price        TYPE p LENGTH 13 DECIMALS 2,
        currencycode TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

    " The original drives three Table properties imperatively from the toolbar
    " controllers (setSelectionMode / setAlternateRowColors / the highlight
    " rowSettingsTemplate toggle). abap2UI5 is a thin frontend, so these become
    " two-way bound fields on the one default model, shared with the Select /
    " ToggleButtons - no round-trip (AGENTS section 5, app 128/007 precedent).
    DATA selection_mode       TYPE string.
    DATA show_highlights      TYPE abap_bool.
    DATA alternate_row_colors TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_174 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " sap.ui.table grid Table (RowHighlights sample). The row highlight bar
    " reads the status the backend classifies per row in model_init. The
    " toolbar Select and ToggleButtons two-way bind the selection mode, the
    " alternate row colors and the highlight-visibility flag directly.
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`         v = `sap.ui.table`
        )->a( n = `xmlns:mvc`     v = `sap.ui.core.mvc`
        )->a( n = `xmlns:unified` v = `sap.ui.unified`
        )->a( n = `xmlns:core`    v = `sap.ui.core`
        )->a( n = `xmlns:m`       v = `sap.m`
        )->a( n = `height`        v = `100%`

        )->open( n = `Page` ns = `m`
            )->a( n = `showHeader`      v = `false`
            )->a( n = `enableScrolling` v = `false`
            )->a( n = `class`           v = `sapUiContentPadding`

            )->open( n = `content` ns = `m`
                )->open( `Table`
                    )->a( n = `id`                 v = `table`
                    )->a( n = `rows`               v = client->_bind( t_products )
                    )->a( n = `selectionMode`      v = client->_bind( selection_mode )
                    )->a( n = `alternateRowColors` v = client->_bind( alternate_row_colors )
                    )->a( n = `ariaLabelledBy`     v = `title`

                    )->open( `extension`
                        )->open( n = `OverflowToolbar` ns = `m`
                            )->a( n = `style` v = `Clear`
                            )->leaf( n = `Title` ns = `m`
                                )->a( n = `id`   v = `title`
                                )->a( n = `text` v = `Products`
                            )->leaf( n = `ToolbarSpacer` ns = `m`
                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text` v = `SelectionMode:`
                            )->open( n = `Select` ns = `m`
                                )->a( n = `id`          v = `select`
                                )->a( n = `selectedKey` v = client->_bind( selection_mode )
                                )->open( n = `items` ns = `m`
                                    )->leaf( n = `Item` ns = `core`
                                        )->a( n = `key`  v = `MultiToggle`
                                        )->a( n = `text` v = `MultiToggle`
                                    )->leaf( n = `Item` ns = `core`
                                        )->a( n = `key`  v = `Single`
                                        )->a( n = `text` v = `Single`
                                    )->leaf( n = `Item` ns = `core`
                                        )->a( n = `key`  v = `None`
                                        )->a( n = `text` v = `None`

                            )->shut(
                            )->shut(
                            )->leaf( n = `ToggleButton` ns = `m`
                                )->a( n = `text`    v = `Toggle Highlights`
                                )->a( n = `pressed` v = client->_bind( show_highlights )
                            )->leaf( n = `ToggleButton` ns = `m`
                                )->a( n = `text`    v = `Toggle Alternate Row Colors`
                                )->a( n = `pressed` v = client->_bind( alternate_row_colors )

                    )->shut(
                    )->shut(

                    )->open( `rowSettingsTemplate`
                        )->leaf( `RowSettings`
                            )->a( n = `highlight`     v = |\{= ${ client->_bind( show_highlights ) } ? $\{STATUS\} : 'None' \}|
                            )->a( n = `highlightText` v = `{STATUSTEXT}`

                    )->shut(

                    )->open( `columns`
                        )->open( `Column`
                            )->a( n = `sortProperty`   v = `Status`
                            )->a( n = `filterProperty` v = `Status`
                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text` v = `Status`
                            )->open( `template`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{STATUS}`
                                    )->a( n = `wrapping` v = `false`

                        )->shut(
                        )->shut(

                        )->open( `Column`
                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text` v = `Product Name`
                            )->open( `template`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{NAME}`
                                    )->a( n = `wrapping` v = `false`

                        )->shut(
                        )->shut(

                        )->open( `Column`
                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text` v = `Product Id`
                            )->open( `template`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{PRODUCTID}`
                                    )->a( n = `wrapping` v = `false`

                        )->shut(
                        )->shut(

                        )->open( `Column`
                            )->a( n = `hAlign` v = `End`
                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text` v = `Quantity`
                            )->open( `template`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{QUANTITY}`
                                    )->a( n = `wrapping` v = `false`

                        )->shut(
                        )->shut(

                        )->open( `Column`
                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text` v = `Price`
                            )->open( `template`
                                )->leaf( n = `Currency` ns = `unified`
                                    )->a( n = `value`    v = `{PRICE}`
                                    )->a( n = `currency` v = `{CURRENCYCODE}`

                        )->shut(
                        )->shut(
                    )->shut(
                )->shut(
            )->shut(
        )->shut(
    )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " initial toolbar state - the original starts with MultiToggle selection,
    " highlights on (ToggleButton pressed=true) and alternate colors off
    selection_mode       = `MultiToggle`.
    show_highlights      = abap_true.
    alternate_row_colors = abap_false.

    " the shared 123-row demo ProductCollection (sap/ui/demo/mock/products.json)
    " inlined with the columns the sample binds (Name, ProductId, Quantity,
    " Price, CurrencyCode); Price is packed for the numeric u:Currency value
    t_products = VALUE #(
          ( name = `Notebook Basic 15` productid = `HT-1000` quantity = 10 price = `956` currencycode = `EUR` )
          ( name = `Notebook Basic 17` productid = `HT-1001` quantity = 20 price = `1249` currencycode = `EUR` )
          ( name = `Notebook Basic 18` productid = `HT-1002` quantity = 10 price = `1570` currencycode = `EUR` )
          ( name = `Notebook Basic 19` productid = `HT-1003` quantity = 15 price = `1650` currencycode = `EUR` )
          ( name = `ITelO Vault` productid = `HT-1007` quantity = 15 price = `299` currencycode = `EUR` )
          ( name = `Notebook Professional 15` productid = `HT-1010` quantity = 16 price = `1999` currencycode = `EUR` )
          ( name = `Notebook Professional 17` productid = `HT-1011` quantity = 17 price = `2299` currencycode = `EUR` )
          ( name = `ITelO Vault Net` productid = `HT-1020` quantity = 14 price = `459` currencycode = `EUR` )
          ( name = `ITelO Vault SAT` productid = `HT-1021` quantity = 50 price = `149` currencycode = `EUR` )
          ( name = `Comfort Easy` productid = `HT-1022` quantity = 30 price = `1679` currencycode = `EUR` )
          ( name = `Comfort Senior` productid = `HT-1023` quantity = 24 price = `512` currencycode = `EUR` )
          ( name = `Ergo Screen E-I` productid = `HT-1030` quantity = 14 price = `230` currencycode = `EUR` )
          ( name = `Ergo Screen E-II` productid = `HT-1031` quantity = 24 price = `285` currencycode = `EUR` )
          ( name = `Ergo Screen E-III` productid = `HT-1032` quantity = 50 price = `345` currencycode = `EUR` )
          ( name = `Flat Basic` productid = `HT-1035` quantity = 23 price = `399` currencycode = `EUR` )
          ( name = `Flat Future` productid = `HT-1036` quantity = 22 price = `430` currencycode = `EUR` )
          ( name = `Flat XL` productid = `HT-1037` quantity = 23 price = `1230` currencycode = `EUR` )
          ( name = `Laser Professional Eco` productid = `HT-1040` quantity = 21 price = `830` currencycode = `EUR` )
          ( name = `Laser Basic` productid = `HT-1041` quantity = 8 price = `490` currencycode = `EUR` )
          ( name = `Laser Allround` productid = `HT-1042` quantity = 9 price = `349` currencycode = `EUR` )
          ( name = `Ultra Jet Super Color` productid = `HT-1050` quantity = 17 price = `139` currencycode = `EUR` )
          ( name = `Ultra Jet Mobile` productid = `HT-1051` quantity = 18 price = `99` currencycode = `EUR` )
          ( name = `Ultra Jet Super Highspeed` productid = `HT-1052` quantity = 25 price = `170` currencycode = `EUR` )
          ( name = `Multi Print` productid = `HT-1055` quantity = 16 price = `99` currencycode = `EUR` )
          ( name = `Multi Color` productid = `HT-1056` quantity = 5 price = `119` currencycode = `EUR` )
          ( name = `Cordless Mouse` productid = `HT-1060` quantity = 25 price = `9` currencycode = `EUR` )
          ( name = `Speed Mouse` productid = `HT-1061` quantity = 12 price = `7` currencycode = `EUR` )
          ( name = `Track Mouse` productid = `HT-1062` quantity = 12 price = `11` currencycode = `EUR` )
          ( name = `Ergonomic Keyboard` productid = `HT-1063` quantity = 50 price = `14` currencycode = `EUR` )
          ( name = `Internet Keyboard` productid = `HT-1064` quantity = 35 price = `16` currencycode = `EUR` )
          ( name = `Media Keyboard` productid = `HT-1065` quantity = 26 price = `26` currencycode = `EUR` )
          ( name = `Mousepad` productid = `HT-1066` quantity = 12 price = `6.99` currencycode = `EUR` )
          ( name = `Ergo Mousepad` productid = `HT-1067` quantity = 16 price = `8.99` currencycode = `EUR` )
          ( name = `Designer Mousepad` productid = `HT-1068` quantity = 26 price = `12.99` currencycode = `EUR` )
          ( name = `Universal card reader` productid = `HT-1069` quantity = 22 price = `14` currencycode = `EUR` )
          ( name = `Proctra X` productid = `HT-1070` quantity = 15 price = `70.9` currencycode = `EUR` )
          ( name = `Gladiator MX` productid = `HT-1071` quantity = 16 price = `81.7` currencycode = `EUR` )
          ( name = `Hurricane GX` productid = `HT-1072` quantity = 13 price = `101.2` currencycode = `EUR` )
          ( name = `Hurricane GX/LN` productid = `HT-1073` quantity = 5 price = `139.99` currencycode = `EUR` )
          ( name = `Photo Scan` productid = `HT-1080` quantity = 8 price = `129` currencycode = `EUR` )
          ( name = `Power Scan` productid = `HT-1081` quantity = 11 price = `89` currencycode = `EUR` )
          ( name = `Jet Scan Professional` productid = `HT-1082` quantity = 13 price = `169` currencycode = `EUR` )
          ( name = `Jet Scan Professional` productid = `HT-1083` quantity = 10 price = `189` currencycode = `EUR` )
          ( name = `Copymaster` productid = `HT-1085` quantity = 10 price = `1499` currencycode = `EUR` )
          ( name = `Surround Sound` productid = `HT-1090` quantity = 20 price = `39` currencycode = `EUR` )
          ( name = `Blaster Extreme` productid = `HT-1091` quantity = 15 price = `26` currencycode = `EUR` )
          ( name = `Sound Booster` productid = `HT-1092` quantity = 50 price = `45` currencycode = `EUR` )
          ( name = `Lovely Sound 5.1 Wireless` productid = `HT-1095` quantity = 12 price = `49` currencycode = `EUR` )
          ( name = `Lovely Sound 5.1` productid = `HT-1096` quantity = 18 price = `39` currencycode = `EUR` )
          ( name = `Lovely Sound Stereo` productid = `HT-1097` quantity = 21 price = `29` currencycode = `EUR` )
          ( name = `Smart Office` productid = `HT-1100` quantity = 25 price = `89.9` currencycode = `EUR` )
          ( name = `Smart Design` productid = `HT-1101` quantity = 26 price = `79.9` currencycode = `EUR` )
          ( name = `Smart Network` productid = `HT-1102` quantity = 28 price = `69` currencycode = `EUR` )
          ( name = `Smart Multimedia` productid = `HT-1103` quantity = 9 price = `77` currencycode = `EUR` )
          ( name = `Smart Games` productid = `HT-1104` quantity = 13 price = `55` currencycode = `EUR` )
          ( name = `Smart Internet Antivirus` productid = `HT-1105` quantity = 17 price = `29` currencycode = `EUR` )
          ( name = `Smart Firewall` productid = `HT-1106` quantity = 19 price = `34` currencycode = `EUR` )
          ( name = `Smart Money` productid = `HT-1107` quantity = 18 price = `29.9` currencycode = `EUR` )
          ( name = `PC Lock` productid = `HT-1110` quantity = 14 price = `8.9` currencycode = `EUR` )
          ( name = `Notebook Lock` productid = `HT-1111` quantity = 20 price = `6.9` currencycode = `EUR` )
          ( name = `Web cam reality` productid = `HT-1112` quantity = 27 price = `39` currencycode = `EUR` )
          ( name = `Screen clean` productid = `HT-1113` quantity = 17 price = `2.3` currencycode = `EUR` )
          ( name = `Fabric bag professional` productid = `HT-1114` quantity = 14 price = `31` currencycode = `EUR` )
          ( name = `Wireless DSL Router` productid = `HT-1115` quantity = 16 price = `49` currencycode = `EUR` )
          ( name = `Wireless DSL Router / Repeater` productid = `HT-1116` quantity = 12 price = `59` currencycode = `EUR` )
          ( name = `Wireless DSL Router / Repeater and Print Server` productid = `HT-1117` quantity = 12 price = `69` currencycode = `EUR` )
          ( name = `USB Stick` productid = `HT-1118` quantity = 14 price = `35` currencycode = `EUR` )
          ( name = `Travel Adapter` productid = `HT-1119` quantity = 10 price = `79` currencycode = `EUR` )
          ( name = `Cordless Bluetooth Keyboard, english international` productid = `HT-1120` quantity = 13 price = `29` currencycode = `EUR` )
          ( name = `Flat XXL` productid = `HT-1137` quantity = 10 price = `1430` currencycode = `EUR` )
          ( name = `Pocket Mouse` productid = `HT-1138` quantity = 20 price = `23` currencycode = `EUR` )
          ( name = `PC Power Station` productid = `HT-1210` quantity = 22 price = `2399` currencycode = `EUR` )
          ( name = `Astro Laptop 1516` productid = `HT-1251` quantity = 23 price = `989` currencycode = `EUR` )
          ( name = `Astro Phone 6` productid = `HT-1252` quantity = 28 price = `649` currencycode = `EUR` )
          ( name = `Benda Laptop 1408` productid = `HT-1253` quantity = 27 price = `976` currencycode = `EUR` )
          ( name = `Bending Screen 21HD` productid = `HT-1254` quantity = 23 price = `250` currencycode = `EUR` )
          ( name = `Broad Screen 22HD` productid = `HT-1255` quantity = 5 price = `270` currencycode = `EUR` )
          ( name = `Cerdik Phone 7` productid = `HT-1256` quantity = 19 price = `549` currencycode = `EUR` )
          ( name = `Cepat Tablet 10.5` productid = `HT-1257` quantity = 17 price = `549` currencycode = `EUR` )
          ( name = `Cepat Tablet 8` productid = `HT-1258` quantity = 24 price = `529` currencycode = `EUR` )
          ( name = `Server Basic` productid = `HT-1500` quantity = 24 price = `5000` currencycode = `EUR` )
          ( name = `Server Professional` productid = `HT-1501` quantity = 26 price = `15000` currencycode = `EUR` )
          ( name = `Server Power Pro` productid = `HT-1502` quantity = 34 price = `25000` currencycode = `EUR` )
          ( name = `Family PC Basic` productid = `HT-1600` quantity = 10 price = `600` currencycode = `EUR` )
          ( name = `Family PC Pro` productid = `HT-1601` quantity = 20 price = `900` currencycode = `EUR` )
          ( name = `Gaming Monster` productid = `HT-1602` quantity = 24 price = `1200` currencycode = `EUR` )
          ( name = `Gaming Monster Pro` productid = `HT-1603` quantity = 25 price = `1700` currencycode = `EUR` )
          ( name = `7" Widescreen Portable DVD Player w MP3` productid = `HT-2000` quantity = 20 price = `249.99` currencycode = `EUR` )
          ( name = `10" Portable DVD player` productid = `HT-2001` quantity = 21 price = `449.99` currencycode = `EUR` )
          ( name = `Portable DVD Player with 9" LCD Monitor` productid = `HT-2002` quantity = 50 price = `853.99` currencycode = `EUR` )
          ( name = `CD/DVD case: 264 sleeves` productid = `HT-2025` quantity = 26 price = `44.99` currencycode = `EUR` )
          ( name = `Audio/Video Cable Kit - 4m` productid = `HT-2026` quantity = 16 price = `29.99` currencycode = `EUR` )
          ( name = `Removable CD/DVD Laser Labels` productid = `HT-2027` quantity = 25 price = `8.99` currencycode = `EUR` )
          ( name = `Beam Breaker B-1` productid = `HT-6100` quantity = 32 price = `469` currencycode = `EUR` )
          ( name = `Beam Breaker B-2` productid = `HT-6101` quantity = 18 price = `679` currencycode = `EUR` )
          ( name = `Beam Breaker B-3` productid = `HT-6102` quantity = 16 price = `889` currencycode = `EUR` )
          ( name = `Play Movie` productid = `HT-6110` quantity = 15 price = `130` currencycode = `EUR` )
          ( name = `Record Movie` productid = `HT-6111` quantity = 24 price = `288` currencycode = `EUR` )
          ( name = `ITelo MusicStick` productid = `HT-6120` quantity = 15 price = `45` currencycode = `EUR` )
          ( name = `ITelo Jog-Mate` productid = `HT-6121` quantity = 24 price = `63` currencycode = `EUR` )
          ( name = `Power Pro Player 40` productid = `HT-6122` quantity = 23 price = `167` currencycode = `EUR` )
          ( name = `Power Pro Player 80` productid = `HT-6123` quantity = 13 price = `299` currencycode = `EUR` )
          ( name = `Flat Watch HD32` productid = `HT-6130` quantity = 16 price = `1459` currencycode = `EUR` )
          ( name = `Flat Watch HD37` productid = `HT-6131` quantity = 14 price = `1199` currencycode = `EUR` )
          ( name = `Flat Watch HD41` productid = `HT-6132` quantity = 13 price = `899` currencycode = `EUR` )
          ( name = `Copperberry` productid = `HT-7000` quantity = 5 price = `549` currencycode = `EUR` )
          ( name = `Silverberry` productid = `HT-7010` quantity = 9 price = `549` currencycode = `EUR` )
          ( name = `Goldberry` productid = `HT-7020` quantity = 11 price = `549` currencycode = `EUR` )
          ( name = `Platinberry` productid = `HT-7030` quantity = 12 price = `549` currencycode = `EUR` )
          ( name = `ITelO FlexTop I4000` productid = `HT-8000` quantity = 11 price = `799` currencycode = `EUR` )
          ( name = `ITelO FlexTop I6300c` productid = `HT-8001` quantity = 20 price = `799` currencycode = `EUR` )
          ( name = `ITelO FlexTop I9100` productid = `HT-8002` quantity = 20 price = `1199` currencycode = `EUR` )
          ( name = `ITelO FlexTop I9800` productid = `HT-8003` quantity = 22 price = `1388` currencycode = `EUR` )
          ( name = `Smartphone Leather Case` productid = `HT-9991` quantity = 12 price = `25` currencycode = `EUR` )
          ( name = `Smartphone Alpha` productid = `HT-9992` quantity = 13 price = `599` currencycode = `EUR` )
          ( name = `Mini Tablet` productid = `HT-9993` quantity = 10 price = `833` currencycode = `EUR` )
          ( name = `Camcorder View` productid = `HT-9994` quantity = 50 price = `1388` currencycode = `EUR` )
          ( name = `Tablet Pouch` productid = `HT-9995` quantity = 34 price = `20` currencycode = `EUR` )
          ( name = `Tablet Pouch` productid = `HT-9996` quantity = 34 price = `20` currencycode = `EUR` )
          ( name = `e-Book Reader ReadMe` productid = `HT-9997` quantity = 23 price = `33` currencycode = `EUR` )
          ( name = `Smartphone Beta` productid = `HT-9998` quantity = 21 price = `30` currencycode = `EUR` )
          ( name = `Maxi Tablet` productid = `HT-9999` quantity = 20 price = `749` currencycode = `EUR` )
          ( name = `Flyer` productid = `PF-1000` quantity = 33 price = `0` currencycode = `EUR` )
        ).

    " classify each row exactly as the sample controller does: the first five
    " rows carry fixed highlight states, the rest are derived from the Price
    " thresholds (thin-frontend - the original computes this in the controller)
    LOOP AT t_products ASSIGNING FIELD-SYMBOL(<product>).
      CASE sy-tabix.
        WHEN 1.
          <product>-status = `Success`.
        WHEN 2.
          <product>-status = `Warning`.
        WHEN 3.
          <product>-status = `Error`.
        WHEN 4.
          <product>-status = `Information`.
        WHEN 5.
          <product>-status = `None`.
        WHEN OTHERS.
          IF <product>-price < 300.
            <product>-status     = `Success`.
            <product>-statustext = `Custom success highlight text`.
          ELSEIF <product>-price < 600.
            <product>-status     = `Warning`.
            <product>-statustext = `Custom warning highlight text`.
          ELSEIF <product>-price < 900.
            <product>-status     = `Error`.
            <product>-statustext = `Custom error highlight text`.
          ELSEIF <product>-price < 1200.
            <product>-status     = `Information`.
            <product>-statustext = `Custom information highlight text`.
          ELSEIF <product>-price < 1500.
            <product>-status     = `Indication01`.
            <product>-statustext = `Custom indication highlight text`.
          ELSE.
            <product>-status = `None`.
          ENDIF.
      ENDCASE.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
