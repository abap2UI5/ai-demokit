" @keywords table sap.m tablemultiselectmode overflowtoolbar title toolbarspacer searchfield label switch combobox button column
" @summary This example demonstrates the different multi-selection modes if the table is configured with MultiToggle mode and the sap.m.table.Title control.
CLASS z2ui5_cl_smpc_app_574 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             productid    TYPE string,
             name         TYPE string,
             suppliername TYPE string,
             width        TYPE string,
             depth        TYPE string,
             height       TYPE string,
             dimunit      TYPE string,
             selected     TYPE abap_bool,
           END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

    DATA t_products     TYPE ty_t_product.
    " the rows the search leaves visible; T_PRODUCTS stays the full set
    DATA t_rows         TYPE ty_t_product.

    " the ui> view model of the sample
    DATA total_count    TYPE i.
    DATA selected_count TYPE i.
    DATA show_total     TYPE abap_bool VALUE abap_true.
    DATA extended_view  TYPE abap_bool.
    DATA select_mode    TYPE string VALUE `Default`.
    DATA new_counter    TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS counts_refresh.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_574 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      t_rows = t_products.
      counts_refresh( ).
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
        )->a( n = `xmlns`       v = `sap.m`
        )->a( n = `xmlns:mvc`   v = `sap.ui.core.mvc`
        )->a( n = `xmlns:table` v = `sap.m.table`
        )->a( n = `xmlns:core`  v = `sap.ui.core`

        )->ele( `Table`
            )->a( n = `id`                 v = `idProductsTable`
            )->a( n = `mode`               v = `MultiSelect`
            )->a( n = `items`              v = |\{ path: '{ client->_bind( val = t_rows path = abap_true ) }', sorter: \{ path: 'NAME' \} \}|
            )->a( n = `itemActionCount`    v = `1`
            )->a( n = `rememberSelections` v = `false`
            )->a( n = `selectionChange`    v = client->_event( `ROW_SELECTION` )
            " onItemActionPress deletes the row the action was fired on; the event
            " ships the list item, so its ProductId travels with it
            )->a( n = `itemActionPress`    v = client->_event( val   = `ITEM_ACTION`
                                                               t_arg = VALUE #( ( `${$parameters>/listItem}.getBindingContext().getProperty('PRODUCTID')` ) ) )
            " onSelectionChange of the ComboBox calls setMultiSelectionMode - see
            " the sidecar; the real property is multiSelectMode and it is bindable
            )->a( n = `multiSelectMode`    v = client->_bind( select_mode )

            )->ele( `headerToolbar`
                )->ele( `OverflowToolbar`

                    )->ele( n = `Title` ns = `table`
                        )->a( n = `id`               v = `idTableTitle`
                        )->a( n = `totalCount`       v = client->_bind( total_count )
                        )->a( n = `selectedCount`    v = client->_bind( selected_count )
                        )->a( n = `showExtendedView` v = client->_bind( extended_view )

                        )->tag( `Title`
                            )->a( n = `text`  v = `Products`
                            )->a( n = `level` v = `H2`

                    )->end(
                    )->tag( `ToolbarSpacer`
                    )->tag( `SearchField`
                        )->a( n = `id`          v = `idSearchField`
                        )->a( n = `width`       v = `15rem`
                        )->a( n = `placeholder` v = `Search products...`
                        )->a( n = `search`      v = client->_event( val   = `SEARCH`
                                                                    t_arg = VALUE #( ( `${$parameters>/query}` ) ) )
                    )->tag( `Label`
                        )->a( n = `text`     v = `Extended view`
                        )->a( n = `labelFor` v = `extViewSwitch`
                    )->tag( `Switch`
                        )->a( n = `id`    v = `extViewSwitch`
                        )->a( n = `state` v = client->_bind( extended_view )
                    )->tag( `Label`
                        )->a( n = `text`     v = `Show totalCount`
                        )->a( n = `labelFor` v = `disableTotalCountSwitch`
                    )->tag( `Switch`
                        )->a( n = `id`     v = `disableTotalCountSwitch`
                        )->a( n = `state`  v = client->_bind( show_total )
                        )->a( n = `change` v = client->_event( `TOGGLE_TOTAL` )
                    )->tag( `Label`
                        )->a( n = `text`     v = `Multi selection modes`
                        )->a( n = `labelFor` v = `idComboBoxSuccess`
                    )->ele( `ComboBox`
                        )->a( n = `id`          v = `idComboBoxSuccess`
                        )->a( n = `selectedKey` v = client->_bind( select_mode )

                        )->tag( n = `Item` ns = `core`
                            )->a( n = `text` v = `Default`
                            )->a( n = `key`  v = `Default`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `text` v = `ClearAll`
                            )->a( n = `key`  v = `ClearAll`

                    )->end(
                    )->tag( `Button`
                        )->a( n = `icon`  v = `sap-icon://add`
                        )->a( n = `text`  v = `Add randomized product`
                        )->a( n = `press` v = client->_event( `ADD_ROW` )

                )->end(
            )->end(
            )->ele( `columns`
                )->ele( `Column`
                    )->a( n = `width` v = `12em`

                    )->tag( `Text`
                        )->a( n = `text` v = `Product`

                )->end(
                )->ele( `Column`
                    )->a( n = `minScreenWidth` v = `Tablet`
                    )->a( n = `demandPopin`    v = `true`

                    )->tag( `Text`
                        )->a( n = `text` v = `Supplier`

                )->end(
                )->ele( `Column`
                    )->a( n = `minScreenWidth` v = `Tablet`
                    )->a( n = `demandPopin`    v = `true`
                    )->a( n = `hAlign`         v = `End`

                    )->tag( `Text`
                        )->a( n = `text` v = `Dimensions`

                )->end(
            )->end(
            )->ele( `items`
                )->ele( `ColumnListItem`
                    )->a( n = `vAlign`   v = `Middle`
                    )->a( n = `selected` v = `{SELECTED}`

                    )->ele( `actions`
                        )->tag( `ListItemAction`
                            )->a( n = `type` v = `Delete`

                    )->end(
                    )->ele( `cells`
                        )->tag( `ObjectIdentifier`
                            )->a( n = `title` v = `{NAME}`
                            )->a( n = `text`  v = `{PRODUCTID}`
                        )->tag( `Text`
                            )->a( n = `text` v = `{SUPPLIERNAME}`
                        )->tag( `Text`
                            )->a( n = `text` v = `{WIDTH} x {DEPTH} x {HEIGHT} {DIMUNIT}`

                    )->end(
                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD counts_refresh.

    " _updateTotalCount / _updateSelectedCount read the binding and the selection;
    " the backend holds both, so it counts them here
    total_count = COND i( WHEN show_total = abap_true THEN lines( t_rows ) ELSE -1 ).
    selected_count = REDUCE i( INIT n = 0
                               FOR row IN t_rows
                               NEXT n = COND #( WHEN row-selected = abap_true THEN n + 1 ELSE n ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `ROW_SELECTION`.
        counts_refresh( ).

      WHEN `TOGGLE_TOTAL`.
        counts_refresh( ).

      WHEN `SEARCH`.
        " onSearch filters Name, SupplierName and ProductId with an OR filter
        DATA(query) = to_upper( client->get_event_arg( ) ).
        IF query IS INITIAL.
          t_rows = t_products.
        ELSE.
          CLEAR t_rows.
          LOOP AT t_products INTO DATA(product).
            IF to_upper( product-name ) CS query
                OR to_upper( product-suppliername ) CS query
                OR to_upper( product-productid ) CS query.
              APPEND product TO t_rows.
            ENDIF.
          ENDLOOP.
        ENDIF.
        counts_refresh( ).
        view_display( ).

      WHEN `ITEM_ACTION`.
        " onItemActionPress deletes the row, clears the selection and toasts
        DATA(del_id) = client->get_event_arg( ).
        DELETE t_products WHERE productid = del_id.
        DELETE t_rows WHERE productid = del_id.
        LOOP AT t_rows REFERENCE INTO DATA(lr_row).
          lr_row->selected = abap_false.
        ENDLOOP.
        counts_refresh( ).
        client->message_toast_display( `Product deleted and selection cleared.` ).
        view_display( ).

      WHEN `ADD_ROW`.
        " onAddRow appends a product with randomised values; a backend cannot
        " repeat a client-side random draw, so it counts up instead
        new_counter = new_counter + 1.
        DATA(suppliers) = VALUE string_table( ( `SupplierA` ) ( `SupplierB` ) ( `SupplierC` ) ).
        DATA(new_row) = VALUE ty_s_product(
            productid    = |PRD-{ new_counter }|
            name         = |Product { new_counter }|
            suppliername = suppliers[ ( new_counter - 1 ) MOD 3 + 1 ]
            width        = |{ 10 + new_counter MOD 50 }|
            depth        = |{ 10 + new_counter MOD 50 }|
            height       = |{ 10 + new_counter MOD 50 }|
            dimunit      = `cm` ).
        APPEND new_row TO t_products.
        APPEND new_row TO t_rows.
        counts_refresh( ).
        client->message_toast_display( |New product added: { new_row-name }| ).
        view_display( ).

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " the full mock /ProductCollection, in the mock order - the items binding
    " keeps its own sorter on NAME
    t_products = VALUE #(
      ( productid = `HT-1000` name = `Notebook Basic 15` suppliername = `Very Best Screens`
        width = `30` depth = `18` height = `3` dimunit = `cm` )
      ( productid = `HT-1001` name = `Notebook Basic 17` suppliername = `Very Best Screens`
        width = `29` depth = `17` height = `3.1` dimunit = `cm` )
      ( productid = `HT-1002` name = `Notebook Basic 18` suppliername = `Very Best Screens`
        width = `28` depth = `19` height = `2.5` dimunit = `cm` )
      ( productid = `HT-1003` name = `Notebook Basic 19` suppliername = `Smartcards`
        width = `32` depth = `21` height = `4` dimunit = `cm` )
      ( productid = `HT-1007` name = `ITelO Vault` suppliername = `Technocom`
        width = `32` depth = `22` height = `3` dimunit = `cm` )
      ( productid = `HT-1010` name = `Notebook Professional 15` suppliername = `Very Best Screens`
        width = `33` depth = `20` height = `3` dimunit = `cm` )
      ( productid = `HT-1011` name = `Notebook Professional 17` suppliername = `Very Best Screens`
        width = `33` depth = `23` height = `2` dimunit = `cm` )
      ( productid = `HT-1020` name = `ITelO Vault Net` suppliername = `Technocom`
        width = `10` depth = `1.8` height = `17` dimunit = `cm` )
      ( productid = `HT-1021` name = `ITelO Vault SAT` suppliername = `Technocom`
        width = `11` depth = `1.7` height = `18` dimunit = `cm` )
      ( productid = `HT-1022` name = `Comfort Easy` suppliername = `Technocom`
        width = `84` depth = `1.5` height = `14` dimunit = `cm` )
      ( productid = `HT-1023` name = `Comfort Senior` suppliername = `Technocom`
        width = `80` depth = `1.6` height = `13` dimunit = `cm` )
      ( productid = `HT-1030` name = `Ergo Screen E-I` suppliername = `Very Best Screens`
        width = `37` depth = `12` height = `36` dimunit = `cm` )
      ( productid = `HT-1031` name = `Ergo Screen E-II` suppliername = `Very Best Screens`
        width = `40.8` depth = `19` height = `43` dimunit = `cm` )
      ( productid = `HT-1032` name = `Ergo Screen E-III` suppliername = `Very Best Screens`
        width = `40.8` depth = `19` height = `43` dimunit = `cm` )
      ( productid = `HT-1035` name = `Flat Basic` suppliername = `Very Best Screens`
        width = `39` depth = `20` height = `41` dimunit = `cm` )
      ( productid = `HT-1036` name = `Flat Future` suppliername = `Very Best Screens`
        width = `45` depth = `26` height = `46` dimunit = `cm` )
      ( productid = `HT-1037` name = `Flat XL` suppliername = `Very Best Screens`
        width = `54.5` depth = `22.1` height = `39.1` dimunit = `cm` )
      ( productid = `HT-1040` name = `Laser Professional Eco` suppliername = `Alpha Printers`
        width = `51` depth = `46` height = `30` dimunit = `cm` )
      ( productid = `HT-1041` name = `Laser Basic` suppliername = `Alpha Printers`
        width = `48` depth = `42` height = `26` dimunit = `cm` )
      ( productid = `HT-1042` name = `Laser Allround` suppliername = `Alpha Printers`
        width = `53` depth = `50` height = `65` dimunit = `cm` )
      ( productid = `HT-1050` name = `Ultra Jet Super Color` suppliername = `Alpha Printers`
        width = `41` depth = `41` height = `28` dimunit = `cm` )
      ( productid = `HT-1051` name = `Ultra Jet Mobile` suppliername = `Printer for All`
        width = `46` depth = `32` height = `25` dimunit = `cm` )
      ( productid = `HT-1052` name = `Ultra Jet Super Highspeed` suppliername = `Printer for All`
        width = `41` depth = `41` height = `28` dimunit = `cm` )
      ( productid = `HT-1055` name = `Multi Print` suppliername = `Printer for All`
        width = `55` depth = `45` height = `29` dimunit = `cm` )
      ( productid = `HT-1056` name = `Multi Color` suppliername = `Printer for All`
        width = `51` depth = `41.3` height = `22` dimunit = `cm` )
      ( productid = `HT-1060` name = `Cordless Mouse` suppliername = `Oxynum`
        width = `6` depth = `14.5` height = `3.5` dimunit = `cm` )
      ( productid = `HT-1061` name = `Speed Mouse` suppliername = `Oxynum`
        width = `7` depth = `15` height = `3.1` dimunit = `cm` )
      ( productid = `HT-1062` name = `Track Mouse` suppliername = `Oxynum`
        width = `3` depth = `7` height = `4` dimunit = `cm` )
      ( productid = `HT-1063` name = `Ergonomic Keyboard` suppliername = `Oxynum`
        width = `50` depth = `21` height = `3.5` dimunit = `cm` )
      ( productid = `HT-1064` name = `Internet Keyboard` suppliername = `Oxynum`
        width = `52` depth = `25` height = `3` dimunit = `cm` )
      ( productid = `HT-1065` name = `Media Keyboard` suppliername = `Oxynum`
        width = `51.4` depth = `23` height = `4` dimunit = `cm` )
      ( productid = `HT-1066` name = `Mousepad` suppliername = `Oxynum`
        width = `15` depth = `6` height = `0.2` dimunit = `cm` )
      ( productid = `HT-1067` name = `Ergo Mousepad` suppliername = `Oxynum`
        width = `15` depth = `6` height = `0.2` dimunit = `cm` )
      ( productid = `HT-1068` name = `Designer Mousepad` suppliername = `Fasttech`
        width = `24` depth = `24` height = `0.6` dimunit = `cm` )
      ( productid = `HT-1069` name = `Universal card reader` suppliername = `Fasttech`
        width = `6` depth = `6` height = `3` dimunit = `cm` )
      ( productid = `HT-1070` name = `Proctra X` suppliername = `Ultrasonic United`
        width = `22` depth = `35` height = `17` dimunit = `cm` )
      ( productid = `HT-1071` name = `Gladiator MX` suppliername = `Ultrasonic United`
        width = `22` depth = `35` height = `17` dimunit = `cm` )
      ( productid = `HT-1072` name = `Hurricane GX` suppliername = `Ultrasonic United`
        width = `22` depth = `35` height = `17` dimunit = `cm` )
      ( productid = `HT-1073` name = `Hurricane GX/LN` suppliername = `Smartcards`
        width = `22` depth = `35` height = `17` dimunit = `cm` )
      ( productid = `HT-1080` name = `Photo Scan` suppliername = `Printer for All`
        width = `34` depth = `48` height = `5` dimunit = `cm` )
      ( productid = `HT-1081` name = `Power Scan` suppliername = `Printer for All`
        width = `31` depth = `43` height = `7` dimunit = `cm` )
      ( productid = `HT-1082` name = `Jet Scan Professional` suppliername = `Printer for All`
        width = `33` depth = `41` height = `12` dimunit = `cm` )
      ( productid = `HT-1083` name = `Jet Scan Professional` suppliername = `Printer for All`
        width = `35` depth = `40` height = `10` dimunit = `cm` )
      ( productid = `HT-1085` name = `Copymaster` suppliername = `Alpha Printers`
        width = `45` depth = `42` height = `22` dimunit = `cm` )
      ( productid = `HT-1090` name = `Surround Sound` suppliername = `Speaker Experts`
        width = `12` depth = `10` height = `16` dimunit = `cm` )
      ( productid = `HT-1091` name = `Blaster Extreme` suppliername = `Speaker Experts`
        width = `13` depth = `11` height = `17.5` dimunit = `cm` )
      ( productid = `HT-1092` name = `Sound Booster` suppliername = `Speaker Experts`
        width = `12.4` depth = `10.4` height = `18.1` dimunit = `cm` )
      ( productid = `HT-1095` name = `Lovely Sound 5.1 Wireless` suppliername = `Fasttech`
        width = `24` depth = `19` height = `23` dimunit = `cm` )
      ( productid = `HT-1096` name = `Lovely Sound 5.1` suppliername = `Fasttech`
        width = `25` depth = `17` height = `19` dimunit = `cm` )
      ( productid = `HT-1097` name = `Lovely Sound Stereo` suppliername = `Fasttech`
        width = `21.3` depth = `2.4` height = `19.7` dimunit = `cm` )
      ( productid = `HT-1100` name = `Smart Office` suppliername = `Technocom`
        width = `15` depth = `6.5` height = `2.1` dimunit = `cm` )
      ( productid = `HT-1101` name = `Smart Design` suppliername = `Technocom`
        width = `14` depth = `6.7` height = `24` dimunit = `cm` )
      ( productid = `HT-1102` name = `Smart Network` suppliername = `Technocom`
        width = `16` depth = `6` height = `27` dimunit = `cm` )
      ( productid = `HT-1103` name = `Smart Multimedia` suppliername = `Technocom`
        width = `11` depth = `3.4` height = `22` dimunit = `cm` )
      ( productid = `HT-1104` name = `Smart Games` suppliername = `Technocom`
        width = `10` depth = `3` height = `30` dimunit = `cm` )
      ( productid = `HT-1105` name = `Smart Internet Antivirus` suppliername = `Brainsoft`
        width = `16` depth = `4` height = `21` dimunit = `cm` )
      ( productid = `HT-1106` name = `Smart Firewall` suppliername = `Brainsoft`
        width = `17.9` depth = `4.2` height = `23.1` dimunit = `cm` )
      ( productid = `HT-1107` name = `Smart Money` suppliername = `Brainsoft`
        width = `12` depth = `1.5` height = `19` dimunit = `cm` )
      ( productid = `HT-1110` name = `PC Lock` suppliername = `Red Point Stores`
        width = `20` depth = `8` height = `4.3` dimunit = `cm` )
      ( productid = `HT-1111` name = `Notebook Lock` suppliername = `Red Point Stores`
        width = `31` depth = `9` height = `7` dimunit = `cm` )
      ( productid = `HT-1112` name = `Web cam reality` suppliername = `Red Point Stores`
        width = `9` depth = `8.2` height = `1.3` dimunit = `cm` )
      ( productid = `HT-1113` name = `Screen clean` suppliername = `Red Point Stores`
        width = `2` depth = `2` height = `0.1` dimunit = `cm` )
      ( productid = `HT-1114` name = `Fabric bag professional` suppliername = `Red Point Stores`
        width = `42` depth = `32` height = `7` dimunit = `cm` )
      ( productid = `HT-1115` name = `Wireless DSL Router` suppliername = `Red Point Stores`
        width = `19.3` depth = `18` height = `5` dimunit = `cm` )
      ( productid = `HT-1116` name = `Wireless DSL Router / Repeater` suppliername = `Red Point Stores`
        width = `19.3` depth = `18` height = `5` dimunit = `cm` )
      ( productid = `HT-1117` name = `Wireless DSL Router / Repeater and Print Server` suppliername = `Technocom`
        width = `19.3` depth = `18` height = `5` dimunit = `cm` )
      ( productid = `HT-1118` name = `USB Stick` suppliername = `Technocom`
        width = `1.5` depth = `8.7` height = `1.2` dimunit = `cm` )
      ( productid = `HT-1119` name = `Travel Adapter` suppliername = `Titanium`
        width = `2` depth = `3.1` height = `3.9` dimunit = `cm` )
      ( productid = `HT-1120` name = `Cordless Bluetooth Keyboard, english international` suppliername = `Technocom`
        width = `51.4` depth = `23` height = `4` dimunit = `cm` )
      ( productid = `HT-1137` name = `Flat XXL` suppliername = `Technocom`
        width = `54` depth = `22` height = `38` dimunit = `cm` )
      ( productid = `HT-1138` name = `Pocket Mouse` suppliername = `Technocom`
        width = `0.3` depth = `0.5` height = `1` dimunit = `cm` )
      ( productid = `HT-1210` name = `PC Power Station` suppliername = `Technocom`
        width = `28` depth = `31` height = `43` dimunit = `cm` )
      ( productid = `HT-1251` name = `Astro Laptop 1516` suppliername = `Ultrasonic United`
        width = `30` depth = `18` height = `3` dimunit = `cm` )
      ( productid = `HT-1252` name = `Astro Phone 6` suppliername = `Ultrasonic United`
        width = `8` depth = `6` height = `1.5` dimunit = `cm` )
      ( productid = `HT-1253` name = `Benda Laptop 1408` suppliername = `Ultrasonic United`
        width = `30` depth = `18` height = `3` dimunit = `cm` )
      ( productid = `HT-1254` name = `Bending Screen 21HD` suppliername = `Ultrasonic United`
        width = `37` depth = `12` height = `36` dimunit = `cm` )
      ( productid = `HT-1255` name = `Broad Screen 22HD` suppliername = `Ultrasonic United`
        width = `39` depth = `12` height = `38` dimunit = `cm` )
      ( productid = `HT-1256` name = `Cerdik Phone 7` suppliername = `Ultrasonic United`
        width = `9` depth = `15` height = `1.5` dimunit = `cm` )
      ( productid = `HT-1257` name = `Cepat Tablet 10.5` suppliername = `Ultrasonic United`
        width = `48` depth = `31` height = `4.5` dimunit = `cm` )
      ( productid = `HT-1258` name = `Cepat Tablet 8` suppliername = `Ultrasonic United`
        width = `38` depth = `21` height = `3.5` dimunit = `cm` )
      ( productid = `HT-1500` name = `Server Basic` suppliername = `Technocom`
        width = `34` depth = `35` height = `23` dimunit = `cm` )
      ( productid = `HT-1501` name = `Server Professional` suppliername = `Technocom`
        width = `29` depth = `30` height = `27` dimunit = `cm` )
      ( productid = `HT-1502` name = `Server Power Pro` suppliername = `Technocom`
        width = `22` depth = `27.3` height = `37` dimunit = `cm` )
      ( productid = `HT-1600` name = `Family PC Basic` suppliername = `Titanium`
        width = `21.4` depth = `29` height = `38` dimunit = `cm` )
      ( productid = `HT-1601` name = `Family PC Pro` suppliername = `Titanium`
        width = `25` depth = `31.7` height = `40.2` dimunit = `cm` )
      ( productid = `HT-1602` name = `Gaming Monster` suppliername = `Titanium`
        width = `26.5` depth = `34` height = `47` dimunit = `cm` )
      ( productid = `HT-1603` name = `Gaming Monster Pro` suppliername = `Titanium`
        width = `27` depth = `28` height = `42` dimunit = `cm` )
      ( productid = `HT-2000` name = `7" Widescreen Portable DVD Player w MP3` suppliername = `Titanium`
        width = `21.4` depth = `19` height = `27.6` dimunit = `cm` )
      ( productid = `HT-2001` name = `10" Portable DVD player` suppliername = `Titanium`
        width = `24` depth = `19.5` height = `29` dimunit = `cm` )
      ( productid = `HT-2002` name = `Portable DVD Player with 9" LCD Monitor` suppliername = `Technocom`
        width = `21` depth = `16.5` height = `14` dimunit = `cm` )
      ( productid = `HT-2025` name = `CD/DVD case: 264 sleeves` suppliername = `Titanium`
        width = `13` depth = `13` height = `20` dimunit = `cm` )
      ( productid = `HT-2026` name = `Audio/Video Cable Kit - 4m` suppliername = `Titanium`
        width = `21` depth = `10.2` height = `13` dimunit = `cm` )
      ( productid = `HT-2027` name = `Removable CD/DVD Laser Labels` suppliername = `Titanium`
        width = `5.5` depth = `2` height = `2` dimunit = `cm` )
      ( productid = `HT-6100` name = `Beam Breaker B-1` suppliername = `Titanium`
        width = `30.4` depth = `23.1` height = `23` dimunit = `cm` )
      ( productid = `HT-6101` name = `Beam Breaker B-2` suppliername = `Technocom`
        width = `30.4` depth = `23.1` height = `23` dimunit = `cm` )
      ( productid = `HT-6102` name = `Beam Breaker B-3` suppliername = `Technocom`
        width = `30.4` depth = `23.1` height = `23` dimunit = `cm` )
      ( productid = `HT-6110` name = `Play Movie` suppliername = `Fasttech`
        width = `37` depth = `24` height = `6` dimunit = `cm` )
      ( productid = `HT-6111` name = `Record Movie` suppliername = `Fasttech`
        width = `38` depth = `26` height = `6.2` dimunit = `cm` )
      ( productid = `HT-6120` name = `ITelo MusicStick` suppliername = `Fasttech`
        width = `1.5` depth = `6` height = `1` dimunit = `cm` )
      ( productid = `HT-6121` name = `ITelo Jog-Mate` suppliername = `Fasttech`
        width = `5.1` depth = `8` height = `9.2` dimunit = `cm` )
      ( productid = `HT-6122` name = `Power Pro Player 40` suppliername = `Fasttech`
        width = `5.1` depth = `8` height = `9.2` dimunit = `cm` )
      ( productid = `HT-6123` name = `Power Pro Player 80` suppliername = `Fasttech`
        width = `4` depth = `6` height = `0.8` dimunit = `cm` )
      ( productid = `HT-6130` name = `Flat Watch HD32` suppliername = `Very Best Screens`
        width = `78` depth = `22.1` height = `55` dimunit = `cm` )
      ( productid = `HT-6131` name = `Flat Watch HD37` suppliername = `Very Best Screens`
        width = `99.1` depth = `26` height = `61` dimunit = `cm` )
      ( productid = `HT-6132` name = `Flat Watch HD41` suppliername = `Very Best Screens`
        width = `128` depth = `23` height = `79.1` dimunit = `cm` )
      ( productid = `HT-7000` name = `Copperberry` suppliername = `Fasttech`
        width = `8.1` depth = `13` height = `12.1` dimunit = `cm` )
      ( productid = `HT-7010` name = `Silverberry` suppliername = `Fasttech`
        width = `8.1` depth = `13` height = `12.1` dimunit = `cm` )
      ( productid = `HT-7020` name = `Goldberry` suppliername = `Fasttech`
        width = `8.1` depth = `13` height = `12.1` dimunit = `cm` )
      ( productid = `HT-7030` name = `Platinberry` suppliername = `Fasttech`
        width = `8.1` depth = `13` height = `12.1` dimunit = `cm` )
      ( productid = `HT-8000` name = `ITelO FlexTop I4000` suppliername = `Titanium`
        width = `31` depth = `19` height = `3.1` dimunit = `cm` )
      ( productid = `HT-8001` name = `ITelO FlexTop I6300c` suppliername = `Titanium`
        width = `32` depth = `20` height = `3.4` dimunit = `cm` )
      ( productid = `HT-8002` name = `ITelO FlexTop I9100` suppliername = `Titanium`
        width = `38` depth = `21` height = `4.1` dimunit = `cm` )
      ( productid = `HT-8003` name = `ITelO FlexTop I9800` suppliername = `Titanium`
        width = `48` depth = `31` height = `4.5` dimunit = `cm` )
      ( productid = `HT-9991` name = `Smartphone Leather Case` suppliername = `Ultrasonic United`
        width = `48` depth = `31` height = `4.5` dimunit = `cm` )
      ( productid = `HT-9992` name = `Smartphone Alpha` suppliername = `Ultrasonic United`
        width = `48` depth = `31` height = `4.5` dimunit = `cm` )
      ( productid = `HT-9993` name = `Mini Tablet` suppliername = `Ultrasonic United`
        width = `48` depth = `31` height = `4.5` dimunit = `cm` )
      ( productid = `HT-9994` name = `Camcorder View` suppliername = `Ultrasonic United`
        width = `48` depth = `31` height = `27` dimunit = `cm` )
      ( productid = `HT-9995` name = `Tablet Pouch` suppliername = `Titanium`
        width = `25` depth = `40` height = `4.5` dimunit = `cm` )
      ( productid = `HT-9996` name = `Tablet Pouch` suppliername = `Titanium`
        width = `25` depth = `40` height = `4.5` dimunit = `cm` )
      ( productid = `HT-9997` name = `e-Book Reader ReadMe` suppliername = `Titanium`
        width = `48` depth = `31` height = `4.5` dimunit = `cm` )
      ( productid = `HT-9998` name = `Smartphone Beta` suppliername = `Titanium`
        width = `48` depth = `31` height = `4.5` dimunit = `cm` )
      ( productid = `HT-9999` name = `Maxi Tablet` suppliername = `Titanium`
        width = `48` depth = `31` height = `4.5` dimunit = `cm` )
      ( productid = `PF-1000` name = `Flyer` suppliername = `Titanium`
        width = `46` depth = `30` height = `3` dimunit = `cm` ) ).

  ENDMETHOD.

ENDCLASS.
