" @keywords table sap.ui.table rowaction column rowactionitem rowsettings
" @summary Shows how row actions can be used.
CLASS z2ui5_cl_smpc_app_359 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name           TYPE string,
        productid      TYPE string,
        quantity       TYPE i,
        price          TYPE p LENGTH 13 DECIMALS 2,
        currencycode   TYPE string,
        available      TYPE abap_bool,
        navigatedstate TYPE abap_bool,
      END OF ty_s_product,
      BEGIN OF ty_s_key,
        key  TYPE string,
        text TYPE string,
      END OF ty_s_key.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

    " the original's `modes>` model, folded onto the one default model
    DATA t_modes  TYPE STANDARD TABLE OF ty_s_key WITH EMPTY KEY.
    DATA mode_key TYPE string.

    " what the picked mode means for the row actions - the original builds a
    " different RowAction template per mode in JS; the port declares the UNION
    " of its items once and switches them on and off from the backend
    DATA row_action_count TYPE i.
    DATA show_navigation  TYPE abap_bool.
    DATA show_delete      TYPE abap_bool.
    DATA show_edit        TYPE abap_bool.
    DATA show_multi       TYPE abap_bool.

    " the navigated-indicator ToggleButton
    DATA show_navigated TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS mode_apply.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_359 IMPLEMENTATION.

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

    " the row-action demo. The original builds a different RowAction template
    " per mode in the controller; the port declares the union of its six items
    " once and drives their visible flags plus rowActionCount from the backend,
    " so the Select switches the row actions without any control construction.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.ui.table`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:u`   v = `sap.ui.unified`
        )->a( n = `xmlns:c`   v = `sap.ui.core`
        )->a( n = `xmlns:m`   v = `sap.m`
        )->a( n = `height`    v = `100%`

        )->ele( n = `Page` ns = `m`
            )->a( n = `showHeader`      v = `false`
            )->a( n = `enableScrolling` v = `false`
            )->a( n = `class`           v = `sapUiContentPadding`

            )->ele( n = `content` ns = `m`
                )->ele( `Table`
                    )->a( n = `id`             v = `table`
                    )->a( n = `rows`           v = client->_bind( t_products )
                    )->a( n = `rowActionCount` v = client->_bind( row_action_count )
                    )->a( n = `selectionMode`  v = `MultiToggle`
                    )->a( n = `ariaLabelledBy` v = `title`

                    )->ele( `extension`
                        )->ele( n = `OverflowToolbar` ns = `m`
                            )->a( n = `style` v = `Clear`

                            )->tag( n = `Title` ns = `m`
                                )->a( n = `id`   v = `title`
                                )->a( n = `text` v = `Products`

                            )->tag( n = `ToolbarSpacer` ns = `m`

                            )->ele( n = `Select` ns = `m`
                                )->a( n = `id`          v = `select`
                                )->a( n = `items`       v = client->_bind( t_modes )
                                )->a( n = `selectedKey` v = client->_bind( mode_key )
                                )->a( n = `change`      v = client->_event( `MODE_CHANGE` )

                                )->tag( n = `Item` ns = `c`
                                    )->a( n = `key`  v = `{KEY}`
                                    )->a( n = `text` v = `{TEXT}`

                            )->end(
                            )->tag( n = `ToggleButton` ns = `m`
                                )->a( n = `text`    v = `Toggle Navigated Indicators`
                                )->a( n = `pressed` v = client->_bind( show_navigated )

                        )->end(
                    )->end(
                    )->ele( `columns`
                        )->ele( `Column`
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Product Name`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{NAME}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Product Id`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{PRODUCTID}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `hAlign` v = `End`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Quantity`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{QUANTITY}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Price`

                            )->ele( `template`
                                )->tag( n = `Currency` ns = `u`
                                    )->a( n = `value`    v = `{PRICE}`
                                    )->a( n = `currency` v = `{CURRENCYCODE}`

                            )->end(
                        )->end(
                    )->end(
                    )->ele( `rowActionTemplate`
                        )->ele( `RowAction`
                            )->tag( `RowActionItem`
                                )->a( n = `type`    v = `Navigation`
                                )->a( n = `visible` v = |\{= ${ client->_bind( show_navigation ) } && $\{AVAILABLE\} \}|
                                )->a( n = `press`   v = client->follow_up_action(
                                          val   = client->cs_event-control_global
                                          t_arg = VALUE #( ( `MESSAGE_TOAST` )
                                                           ( `show` )
                                                           ( `Item {0} pressed for product with id {1}` )
                                                           ( `${$parameters>/item}.getText() || ${$parameters>/item}.getType()` )
                                                           ( `${$parameters>/row}.getBindingContext().getProperty('PRODUCTID')` ) ) )

                            )->tag( `RowActionItem`
                                )->a( n = `type`    v = `Delete`
                                )->a( n = `visible` v = client->_bind( show_delete )
                                )->a( n = `press`   v = client->follow_up_action(
                                          val   = client->cs_event-control_global
                                          t_arg = VALUE #( ( `MESSAGE_TOAST` )
                                                           ( `show` )
                                                           ( `Item {0} pressed for product with id {1}` )
                                                           ( `${$parameters>/item}.getText() || ${$parameters>/item}.getType()` )
                                                           ( `${$parameters>/row}.getBindingContext().getProperty('PRODUCTID')` ) ) )

                            )->tag( `RowActionItem`
                                )->a( n = `icon`    v = `sap-icon://attachment`
                                )->a( n = `text`    v = `Attachment`
                                )->a( n = `visible` v = client->_bind( show_multi )
                                )->a( n = `press`   v = client->follow_up_action(
                                          val   = client->cs_event-control_global
                                          t_arg = VALUE #( ( `MESSAGE_TOAST` )
                                                           ( `show` )
                                                           ( `Item {0} pressed for product with id {1}` )
                                                           ( `${$parameters>/item}.getText() || ${$parameters>/item}.getType()` )
                                                           ( `${$parameters>/row}.getBindingContext().getProperty('PRODUCTID')` ) ) )

                            )->tag( `RowActionItem`
                                )->a( n = `icon`    v = `sap-icon://search`
                                )->a( n = `text`    v = `Search`
                                )->a( n = `visible` v = client->_bind( show_multi )
                                )->a( n = `press`   v = client->follow_up_action(
                                          val   = client->cs_event-control_global
                                          t_arg = VALUE #( ( `MESSAGE_TOAST` )
                                                           ( `show` )
                                                           ( `Item {0} pressed for product with id {1}` )
                                                           ( `${$parameters>/item}.getText() || ${$parameters>/item}.getType()` )
                                                           ( `${$parameters>/row}.getBindingContext().getProperty('PRODUCTID')` ) ) )

                            )->tag( `RowActionItem`
                                )->a( n = `icon`    v = `sap-icon://edit`
                                )->a( n = `text`    v = `Edit`
                                )->a( n = `visible` v = client->_bind( show_edit )
                                )->a( n = `press`   v = client->follow_up_action(
                                          val   = client->cs_event-control_global
                                          t_arg = VALUE #( ( `MESSAGE_TOAST` )
                                                           ( `show` )
                                                           ( `Item {0} pressed for product with id {1}` )
                                                           ( `${$parameters>/item}.getText() || ${$parameters>/item}.getType()` )
                                                           ( `${$parameters>/row}.getBindingContext().getProperty('PRODUCTID')` ) ) )

                            )->tag( `RowActionItem`
                                )->a( n = `icon`    v = `sap-icon://line-chart`
                                )->a( n = `text`    v = `Analyze`
                                )->a( n = `visible` v = client->_bind( show_multi )
                                )->a( n = `press`   v = client->follow_up_action(
                                          val   = client->cs_event-control_global
                                          t_arg = VALUE #( ( `MESSAGE_TOAST` )
                                                           ( `show` )
                                                           ( `Item {0} pressed for product with id {1}` )
                                                           ( `${$parameters>/item}.getText() || ${$parameters>/item}.getType()` )
                                                           ( `${$parameters>/row}.getBindingContext().getProperty('PRODUCTID')` ) ) )

                        )->end(
                    )->end(
                    )->ele( `rowSettingsTemplate`
                        )->tag( `RowSettings`
                            )->a( n = `navigated` v = |\{= ${ client->_bind( show_navigated ) } && $\{NAVIGATEDSTATE\} \}|

                    )->end(
                )->end(
            )->end(
        )->end(
    )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `MODE_CHANGE`.
      " onBehaviourModeChange -> switchState: the picked mode decides the
      " row action count and which items are shown
      mode_apply( ).
    ENDIF.


  ENDMETHOD.


  METHOD mode_apply.

    " the five handlers of the controller's `modes` array, as data
    show_navigation = xsdbool( mode_key = `Navigation`
                            OR mode_key = `NavigationDelete`
                            OR mode_key = `NavigationCustom` ).
    show_delete     = xsdbool( mode_key = `NavigationDelete` ).
    show_edit       = xsdbool( mode_key = `NavigationCustom` OR mode_key = `Multi` ).
    show_multi      = xsdbool( mode_key = `Multi` ).
    row_action_count = SWITCH #( mode_key
                                   WHEN `None`       THEN 0
                                   WHEN `Navigation` THEN 1
                                   ELSE 2 ).

  ENDMETHOD.


  METHOD model_init.

    " the controller's `modes` array - key and label per row-action mode
    t_modes = VALUE #(
      ( key = `Navigation`       text = `Navigation` )
      ( key = `NavigationDelete` text = `Navigation & Delete` )
      ( key = `NavigationCustom` text = `Navigation & Custom` )
      ( key = `Multi`            text = `Multiple Actions` )
      ( key = `None`             text = `No Actions` ) ).

    " switchState("Navigation") in onInit
    mode_key = `Navigation`.
    mode_apply( ).

    " the shared 123-row demo ProductCollection (sap/ui/demo/mock/products.json)
    " with the four columns the sample binds, plus the derived Available flag
    " the Navigation item's visible binding needs. The original marks the
    " SECOND row as navigated (i === 1), which is reproduced here
    t_products = VALUE #(
      ( name = `Notebook Basic 15` productid = `HT-1000` quantity = 10 price = 956 currencycode = `EUR` available = abap_true )
      ( name = `Notebook Basic 17` productid = `HT-1001` quantity = 20 price = 1249 currencycode = `EUR` available = abap_true navigatedstate = abap_true )
      ( name = `Notebook Basic 18` productid = `HT-1002` quantity = 10 price = 1570 currencycode = `EUR` available = abap_true )
      ( name = `Notebook Basic 19` productid = `HT-1003` quantity = 15 price = 1650 currencycode = `EUR` available = abap_false )
      ( name = `ITelO Vault` productid = `HT-1007` quantity = 15 price = 299 currencycode = `EUR` available = abap_false )
      ( name = `Notebook Professional 15` productid = `HT-1010` quantity = 16 price = 1999 currencycode = `EUR` available = abap_false )
      ( name = `Notebook Professional 17` productid = `HT-1011` quantity = 17 price = 2299 currencycode = `EUR` available = abap_false )
      ( name = `ITelO Vault Net` productid = `HT-1020` quantity = 14 price = 459 currencycode = `EUR` available = abap_false )
      ( name = `ITelO Vault SAT` productid = `HT-1021` quantity = 50 price = 149 currencycode = `EUR` available = abap_true )
      ( name = `Comfort Easy` productid = `HT-1022` quantity = 30 price = 1679 currencycode = `EUR` available = abap_false )
      ( name = `Comfort Senior` productid = `HT-1023` quantity = 24 price = 512 currencycode = `EUR` available = abap_true )
      ( name = `Ergo Screen E-I` productid = `HT-1030` quantity = 14 price = 230 currencycode = `EUR` available = abap_true )
      ( name = `Ergo Screen E-II` productid = `HT-1031` quantity = 24 price = 285 currencycode = `EUR` available = abap_true )
      ( name = `Ergo Screen E-III` productid = `HT-1032` quantity = 50 price = 345 currencycode = `EUR` available = abap_false )
      ( name = `Flat Basic` productid = `HT-1035` quantity = 23 price = 399 currencycode = `EUR` available = abap_true )
      ( name = `Flat Future` productid = `HT-1036` quantity = 22 price = 430 currencycode = `EUR` available = abap_true )
      ( name = `Flat XL` productid = `HT-1037` quantity = 23 price = 1230 currencycode = `EUR` available = abap_true )
      ( name = `Laser Professional Eco` productid = `HT-1040` quantity = 21 price = 830 currencycode = `EUR` available = abap_true )
      ( name = `Laser Basic` productid = `HT-1041` quantity = 8 price = 490 currencycode = `EUR` available = abap_true )
      ( name = `Laser Allround` productid = `HT-1042` quantity = 9 price = 349 currencycode = `EUR` available = abap_true )
      ( name = `Ultra Jet Super Color` productid = `HT-1050` quantity = 17 price = 139 currencycode = `EUR` available = abap_false )
      ( name = `Ultra Jet Mobile` productid = `HT-1051` quantity = 18 price = 99 currencycode = `EUR` available = abap_false )
      ( name = `Ultra Jet Super Highspeed` productid = `HT-1052` quantity = 25 price = 170 currencycode = `EUR` available = abap_true )
      ( name = `Multi Print` productid = `HT-1055` quantity = 16 price = 99 currencycode = `EUR` available = abap_true )
      ( name = `Multi Color` productid = `HT-1056` quantity = 5 price = 119 currencycode = `EUR` available = abap_true )
      ( name = `Cordless Mouse` productid = `HT-1060` quantity = 25 price = 9 currencycode = `EUR` available = abap_true )
      ( name = `Speed Mouse` productid = `HT-1061` quantity = 12 price = 7 currencycode = `EUR` available = abap_true )
      ( name = `Track Mouse` productid = `HT-1062` quantity = 12 price = 11 currencycode = `EUR` available = abap_false )
      ( name = `Ergonomic Keyboard` productid = `HT-1063` quantity = 50 price = 14 currencycode = `EUR` available = abap_true )
      ( name = `Internet Keyboard` productid = `HT-1064` quantity = 35 price = 16 currencycode = `EUR` available = abap_false )
      ( name = `Media Keyboard` productid = `HT-1065` quantity = 26 price = 26 currencycode = `EUR` available = abap_true )
      ( name = `Mousepad` productid = `HT-1066` quantity = 12 price = `6.99` currencycode = `EUR` available = abap_true )
      ( name = `Ergo Mousepad` productid = `HT-1067` quantity = 16 price = `8.99` currencycode = `EUR` available = abap_false )
      ( name = `Designer Mousepad` productid = `HT-1068` quantity = 26 price = `12.99` currencycode = `EUR` available = abap_true )
      ( name = `Universal card reader` productid = `HT-1069` quantity = 22 price = 14 currencycode = `EUR` available = abap_true )
      ( name = `Proctra X` productid = `HT-1070` quantity = 15 price = `70.9` currencycode = `EUR` available = abap_false )
      ( name = `Gladiator MX` productid = `HT-1071` quantity = 16 price = `81.7` currencycode = `EUR` available = abap_false )
      ( name = `Hurricane GX` productid = `HT-1072` quantity = 13 price = `101.2` currencycode = `EUR` available = abap_true )
      ( name = `Hurricane GX/LN` productid = `HT-1073` quantity = 5 price = `139.99` currencycode = `EUR` available = abap_false )
      ( name = `Photo Scan` productid = `HT-1080` quantity = 8 price = 129 currencycode = `EUR` available = abap_false )
      ( name = `Power Scan` productid = `HT-1081` quantity = 11 price = 89 currencycode = `EUR` available = abap_false )
      ( name = `Jet Scan Professional` productid = `HT-1082` quantity = 13 price = 169 currencycode = `EUR` available = abap_false )
      ( name = `Jet Scan Professional` productid = `HT-1083` quantity = 10 price = 189 currencycode = `EUR` available = abap_true )
      ( name = `Copymaster` productid = `HT-1085` quantity = 10 price = 1499 currencycode = `EUR` available = abap_true )
      ( name = `Surround Sound` productid = `HT-1090` quantity = 20 price = 39 currencycode = `EUR` available = abap_true )
      ( name = `Blaster Extreme` productid = `HT-1091` quantity = 15 price = 26 currencycode = `EUR` available = abap_true )
      ( name = `Sound Booster` productid = `HT-1092` quantity = 50 price = 45 currencycode = `EUR` available = abap_false )
      ( name = `Lovely Sound 5.1 Wireless` productid = `HT-1095` quantity = 12 price = 49 currencycode = `EUR` available = abap_true )
      ( name = `Lovely Sound 5.1` productid = `HT-1096` quantity = 18 price = 39 currencycode = `EUR` available = abap_true )
      ( name = `Lovely Sound Stereo` productid = `HT-1097` quantity = 21 price = 29 currencycode = `EUR` available = abap_false )
      ( name = `Smart Office` productid = `HT-1100` quantity = 25 price = `89.9` currencycode = `EUR` available = abap_false )
      ( name = `Smart Design` productid = `HT-1101` quantity = 26 price = `79.9` currencycode = `EUR` available = abap_true )
      ( name = `Smart Network` productid = `HT-1102` quantity = 28 price = 69 currencycode = `EUR` available = abap_true )
      ( name = `Smart Multimedia` productid = `HT-1103` quantity = 9 price = 77 currencycode = `EUR` available = abap_true )
      ( name = `Smart Games` productid = `HT-1104` quantity = 13 price = 55 currencycode = `EUR` available = abap_true )
      ( name = `Smart Internet Antivirus` productid = `HT-1105` quantity = 17 price = 29 currencycode = `EUR` available = abap_true )
      ( name = `Smart Firewall` productid = `HT-1106` quantity = 19 price = 34 currencycode = `EUR` available = abap_false )
      ( name = `Smart Money` productid = `HT-1107` quantity = 18 price = `29.9` currencycode = `EUR` available = abap_false )
      ( name = `PC Lock` productid = `HT-1110` quantity = 14 price = `8.9` currencycode = `EUR` available = abap_true )
      ( name = `Notebook Lock` productid = `HT-1111` quantity = 20 price = `6.9` currencycode = `EUR` available = abap_true )
      ( name = `Web cam reality` productid = `HT-1112` quantity = 27 price = 39 currencycode = `EUR` available = abap_false )
      ( name = `Screen clean` productid = `HT-1113` quantity = 17 price = `2.3` currencycode = `EUR` available = abap_true )
      ( name = `Fabric bag professional` productid = `HT-1114` quantity = 14 price = 31 currencycode = `EUR` available = abap_true )
      ( name = `Wireless DSL Router` productid = `HT-1115` quantity = 16 price = 49 currencycode = `EUR` available = abap_true )
      ( name = `Wireless DSL Router / Repeater` productid = `HT-1116` quantity = 12 price = 59 currencycode = `EUR` available = abap_false )
      ( name = `Wireless DSL Router / Repeater and Print Server` productid = `HT-1117` quantity = 12 price = 69 currencycode = `EUR` available = abap_true )
      ( name = `USB Stick` productid = `HT-1118` quantity = 14 price = 35 currencycode = `EUR` available = abap_true )
      ( name = `Travel Adapter` productid = `HT-1119` quantity = 10 price = 79 currencycode = `EUR` available = abap_false )
      ( name = `Cordless Bluetooth Keyboard, english international` productid = `HT-1120` quantity = 13 price = 29 currencycode = `EUR` available = abap_false )
      ( name = `Flat XXL` productid = `HT-1137` quantity = 10 price = 1430 currencycode = `EUR` available = abap_false )
      ( name = `Pocket Mouse` productid = `HT-1138` quantity = 20 price = 23 currencycode = `EUR` available = abap_true )
      ( name = `PC Power Station` productid = `HT-1210` quantity = 22 price = 2399 currencycode = `EUR` available = abap_true )
      ( name = `Astro Laptop 1516` productid = `HT-1251` quantity = 23 price = 989 currencycode = `EUR` available = abap_true )
      ( name = `Astro Phone 6` productid = `HT-1252` quantity = 28 price = 649 currencycode = `EUR` available = abap_true )
      ( name = `Benda Laptop 1408` productid = `HT-1253` quantity = 27 price = 976 currencycode = `EUR` available = abap_false )
      ( name = `Bending Screen 21HD` productid = `HT-1254` quantity = 23 price = 250 currencycode = `EUR` available = abap_true )
      ( name = `Broad Screen 22HD` productid = `HT-1255` quantity = 5 price = 270 currencycode = `EUR` available = abap_false )
      ( name = `Cerdik Phone 7` productid = `HT-1256` quantity = 19 price = 549 currencycode = `EUR` available = abap_false )
      ( name = `Cepat Tablet 10.5` productid = `HT-1257` quantity = 17 price = 549 currencycode = `EUR` available = abap_true )
      ( name = `Cepat Tablet 8` productid = `HT-1258` quantity = 24 price = 529 currencycode = `EUR` available = abap_true )
      ( name = `Server Basic` productid = `HT-1500` quantity = 24 price = 5000 currencycode = `EUR` available = abap_true )
      ( name = `Server Professional` productid = `HT-1501` quantity = 26 price = 15000 currencycode = `EUR` available = abap_false )
      ( name = `Server Power Pro` productid = `HT-1502` quantity = 34 price = 25000 currencycode = `EUR` available = abap_true )
      ( name = `Family PC Basic` productid = `HT-1600` quantity = 10 price = 600 currencycode = `EUR` available = abap_true )
      ( name = `Family PC Pro` productid = `HT-1601` quantity = 20 price = 900 currencycode = `EUR` available = abap_true )
      ( name = `Gaming Monster` productid = `HT-1602` quantity = 24 price = 1200 currencycode = `EUR` available = abap_true )
      ( name = `Gaming Monster Pro` productid = `HT-1603` quantity = 25 price = 1700 currencycode = `EUR` available = abap_false )
      ( name = `7" Widescreen Portable DVD Player w MP3` productid = `HT-2000` quantity = 20 price = `249.99` currencycode = `EUR` available = abap_true )
      ( name = `10" Portable DVD player` productid = `HT-2001` quantity = 21 price = `449.99` currencycode = `EUR` available = abap_true )
      ( name = `Portable DVD Player with 9" LCD Monitor` productid = `HT-2002` quantity = 50 price = `853.99` currencycode = `EUR` available = abap_true )
      ( name = `CD/DVD case: 264 sleeves` productid = `HT-2025` quantity = 26 price = `44.99` currencycode = `EUR` available = abap_false )
      ( name = `Audio/Video Cable Kit - 4m` productid = `HT-2026` quantity = 16 price = `29.99` currencycode = `EUR` available = abap_true )
      ( name = `Removable CD/DVD Laser Labels` productid = `HT-2027` quantity = 25 price = `8.99` currencycode = `EUR` available = abap_false )
      ( name = `Beam Breaker B-1` productid = `HT-6100` quantity = 32 price = 469 currencycode = `EUR` available = abap_false )
      ( name = `Beam Breaker B-2` productid = `HT-6101` quantity = 18 price = 679 currencycode = `EUR` available = abap_true )
      ( name = `Beam Breaker B-3` productid = `HT-6102` quantity = 16 price = 889 currencycode = `EUR` available = abap_false )
      ( name = `Play Movie` productid = `HT-6110` quantity = 15 price = 130 currencycode = `EUR` available = abap_true )
      ( name = `Record Movie` productid = `HT-6111` quantity = 24 price = 288 currencycode = `EUR` available = abap_false )
      ( name = `ITelo MusicStick` productid = `HT-6120` quantity = 15 price = 45 currencycode = `EUR` available = abap_true )
      ( name = `ITelo Jog-Mate` productid = `HT-6121` quantity = 24 price = 63 currencycode = `EUR` available = abap_true )
      ( name = `Power Pro Player 40` productid = `HT-6122` quantity = 23 price = 167 currencycode = `EUR` available = abap_true )
      ( name = `Power Pro Player 80` productid = `HT-6123` quantity = 13 price = 299 currencycode = `EUR` available = abap_true )
      ( name = `Flat Watch HD32` productid = `HT-6130` quantity = 16 price = 1459 currencycode = `EUR` available = abap_true )
      ( name = `Flat Watch HD37` productid = `HT-6131` quantity = 14 price = 1199 currencycode = `EUR` available = abap_true )
      ( name = `Flat Watch HD41` productid = `HT-6132` quantity = 13 price = 899 currencycode = `EUR` available = abap_false )
      ( name = `Copperberry` productid = `HT-7000` quantity = 5 price = 549 currencycode = `EUR` available = abap_false )
      ( name = `Silverberry` productid = `HT-7010` quantity = 9 price = 549 currencycode = `EUR` available = abap_false )
      ( name = `Goldberry` productid = `HT-7020` quantity = 11 price = 549 currencycode = `EUR` available = abap_true )
      ( name = `Platinberry` productid = `HT-7030` quantity = 12 price = 549 currencycode = `EUR` available = abap_true )
      ( name = `ITelO FlexTop I4000` productid = `HT-8000` quantity = 11 price = 799 currencycode = `EUR` available = abap_true )
      ( name = `ITelO FlexTop I6300c` productid = `HT-8001` quantity = 20 price = 799 currencycode = `EUR` available = abap_false )
      ( name = `ITelO FlexTop I9100` productid = `HT-8002` quantity = 20 price = 1199 currencycode = `EUR` available = abap_true )
      ( name = `ITelO FlexTop I9800` productid = `HT-8003` quantity = 22 price = 1388 currencycode = `EUR` available = abap_true )
      ( name = `Smartphone Leather Case` productid = `HT-9991` quantity = 12 price = 25 currencycode = `EUR` available = abap_true )
      ( name = `Smartphone Alpha` productid = `HT-9992` quantity = 13 price = 599 currencycode = `EUR` available = abap_false )
      ( name = `Mini Tablet` productid = `HT-9993` quantity = 10 price = 833 currencycode = `EUR` available = abap_true )
      ( name = `Camcorder View` productid = `HT-9994` quantity = 50 price = 1388 currencycode = `EUR` available = abap_false )
      ( name = `Tablet Pouch` productid = `HT-9995` quantity = 34 price = 20 currencycode = `EUR` available = abap_true )
      ( name = `Tablet Pouch` productid = `HT-9996` quantity = 34 price = 20 currencycode = `EUR` available = abap_true )
      ( name = `e-Book Reader ReadMe` productid = `HT-9997` quantity = 23 price = 33 currencycode = `EUR` available = abap_true )
      ( name = `Smartphone Beta` productid = `HT-9998` quantity = 21 price = 30 currencycode = `EUR` available = abap_true )
      ( name = `Maxi Tablet` productid = `HT-9999` quantity = 20 price = 749 currencycode = `EUR` available = abap_true )
      ( name = `Flyer` productid = `PF-1000` quantity = 33 price = 0 currencycode = `EUR` available = abap_false )
      ).

  ENDMETHOD.

ENDCLASS.
