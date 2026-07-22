CLASS z2ui5_cl_ai_app_104 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             name           TYPE string,
             product_id     TYPE string,
             description    TYPE string,
             category       TYPE string,
             main_category  TYPE string,
             supplier_name  TYPE string,
             width          TYPE string,
             depth          TYPE string,
             height         TYPE string,
             dim_unit       TYPE string,
             weight_measure TYPE string,
             weight_unit    TYPE string,
             weight_state   TYPE string,
             quantity       TYPE string,
             price          TYPE p LENGTH 8 DECIMALS 2,
             currency_code  TYPE string,
             selected       TYPE abap_bool,
           END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.
    DATA multi_select TYPE abap_bool.
    DATA draggable TYPE abap_bool.
    DATA resizable TYPE abap_bool.
    DATA remember TYPE abap_bool.
    DATA confirm_text TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS open_dialog IMPORTING multi        TYPE abap_bool DEFAULT abap_false
                                  drag         TYPE abap_bool DEFAULT abap_false
                                  resize       TYPE abap_bool DEFAULT abap_false
                                  rem          TYPE abap_bool DEFAULT abap_false
                                  confirmtext  TYPE string    DEFAULT ``
                                  responsive   TYPE abap_bool DEFAULT abap_false.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_104 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->open( n = `dependents` ns = `mvc`
            )->open( `TableSelectDialog`
                )->a( n = `id`         v = `myDialog`
                )->a( n = `noDataText` v = `No Products Found`
                )->a( n = `title`      v = `Select Product`
                )->a( n = `search`     v = client->_event_client( val   = client->cs_event-binding_call
                                                                  t_arg = VALUE #( ( `myDialog` ) ( `items` ) ( `filter` ) ( `NAME` ) ( `Contains` ) ( `${$parameters>/value}` ) ) )
                )->a( n = `confirm`    v = client->_event( `CONFIRM` )
                )->a( n = `cancel`     v = client->_event( `CONFIRM` )
                )->a( n = `multiSelect`        v = client->_bind( multi_select )
                )->a( n = `draggable`          v = client->_bind( draggable )
                )->a( n = `resizable`          v = client->_bind( resizable )
                )->a( n = `rememberSelections` v = client->_bind( remember )
                )->a( n = `confirmButtonText`  v = client->_bind( confirm_text )
                )->a( n = `items` v = |\{ path: '{ client->_bind( val = t_products path = abap_true ) }', sorter: \{ path: 'NAME', descending: false \} \}|

                )->open( `ColumnListItem`
                    )->a( n = `vAlign` v = `Middle`
                    )->open( `cells`
                        )->leaf( `ObjectIdentifier`
                            )->a( n = `title` v = `{NAME}`
                            )->a( n = `text`  v = `{PRODUCT_ID}`
                        )->leaf( `Text`
                            )->a( n = `text` v = `{SUPPLIER_NAME}`
                        )->leaf( `Text`
                            )->a( n = `text` v = `{WIDTH} x {DEPTH} x {HEIGHT} {DIM_UNIT}`
                        )->leaf( `ObjectNumber`
                            )->a( n = `number` v = `{WEIGHT_MEASURE}`
                            )->a( n = `unit`   v = `{WEIGHT_UNIT}`
                            )->a( n = `state`  v = `{WEIGHT_STATE}`
                        )->leaf( `ObjectNumber`
                            )->a( n = `number` v = |\{ parts:[\{path:'PRICE'\},\{path:'CURRENCY_CODE'\}], type: 'sap.ui.model.type.Currency', formatOptions: \{showMeasure: false\} \}|
                            )->a( n = `unit`   v = `{CURRENCY_CODE}`

                    )->shut(
                )->shut(
                )->open( `columns`
                    )->open( `Column`
                        )->a( n = `width` v = `12em`
                        )->open( `header`
                            )->leaf( `Text`
                                )->a( n = `text` v = `Product`

                    )->shut(
                    )->shut(
                    )->open( `Column`
                        )->a( n = `minScreenWidth` v = `Tablet`
                        )->a( n = `demandPopin`    v = `true`
                        )->open( `header`
                            )->leaf( `Text`
                                )->a( n = `text` v = `Supplier`

                    )->shut(
                    )->shut(
                    )->open( `Column`
                        )->a( n = `minScreenWidth` v = `Desktop`
                        )->a( n = `demandPopin`    v = `true`
                        )->a( n = `hAlign`         v = `End`
                        )->open( `header`
                            )->leaf( `Text`
                                )->a( n = `text` v = `Dimensions`

                    )->shut(
                    )->shut(
                    )->open( `Column`
                        )->a( n = `minScreenWidth` v = `Desktop`
                        )->a( n = `demandPopin`    v = `true`
                        )->a( n = `hAlign`         v = `Center`
                        )->open( `header`
                            )->leaf( `Text`
                                )->a( n = `text` v = `Weight`

                    )->shut(
                    )->shut(
                    )->open( `Column`
                        )->a( n = `hAlign` v = `End`
                        )->open( `header`
                            )->leaf( `Text`
                                )->a( n = `text` v = `Product`

                    )->shut(
                    )->shut(
                )->shut(
            )->shut(

            )->open( `TableSelectDialog`
                )->a( n = `noDataText`        v = `No Products Found`
                )->a( n = `title`             v = `Select Product`
                )->a( n = `search`            v = client->_event_client( val   = client->cs_event-binding_call
                                                                         t_arg = VALUE #( ( `valueHelpDialog` ) ( `items` ) ( `filter` ) ( `NAME` ) ( `Contains` ) ( `${$parameters>/value}` ) ) )
                )->a( n = `searchPlaceholder` v = `Search Products`
                )->a( n = `confirm`           v = client->_event( `VH_CLOSE` )
                )->a( n = `cancel`            v = client->_event( `VH_CLOSE` )
                )->a( n = `showClearButton`   v = `true`
                )->a( n = `id`                v = `valueHelpDialog`
                )->a( n = `items` v = |\{ path: '{ client->_bind( val = t_products path = abap_true ) }', sorter: \{ path: 'NAME', descending: false \} \}|

                )->open( `ColumnListItem`
                    )->a( n = `selected` v = `{SELECTED}`
                    )->open( `cells`
                        )->leaf( `ObjectIdentifier`
                            )->a( n = `title` v = `{NAME}`
                            )->a( n = `text`  v = `{PRODUCT_ID}`
                        )->leaf( `Text`
                            )->a( n = `text` v = `{SUPPLIER_NAME}`
                        )->leaf( `Text`
                            )->a( n = `text` v = `{WIDTH} x {DEPTH} x {HEIGHT} {DIM_UNIT}`
                        )->leaf( `ObjectNumber`
                            )->a( n = `number` v = `{WEIGHT_MEASURE}`
                            )->a( n = `unit`   v = `{WEIGHT_UNIT}`
                            )->a( n = `state`  v = `{WEIGHT_STATE}`
                        )->leaf( `ObjectNumber`
                            )->a( n = `number` v = |\{ parts:[\{path:'PRICE'\},\{path:'CURRENCY_CODE'\}], type: 'sap.ui.model.type.Currency', formatOptions: \{showMeasure: false\} \}|
                            )->a( n = `unit`   v = `{CURRENCY_CODE}`

                    )->shut(
                )->shut(
                )->open( `columns`
                    )->open( `Column`
                        )->a( n = `width` v = `12em`
                        )->open( `header`
                            )->leaf( `Text`
                                )->a( n = `text` v = `Product`

                    )->shut(
                    )->shut(
                    )->open( `Column`
                        )->a( n = `minScreenWidth` v = `Tablet`
                        )->a( n = `demandPopin`    v = `true`
                        )->open( `header`
                            )->leaf( `Text`
                                )->a( n = `text` v = `Supplier`

                    )->shut(
                    )->shut(
                    )->open( `Column`
                        )->a( n = `minScreenWidth` v = `Desktop`
                        )->a( n = `demandPopin`    v = `true`
                        )->a( n = `hAlign`         v = `End`
                        )->open( `header`
                            )->leaf( `Text`
                                )->a( n = `text` v = `Dimensions`

                    )->shut(
                    )->shut(
                    )->open( `Column`
                        )->a( n = `minScreenWidth` v = `Desktop`
                        )->a( n = `demandPopin`    v = `true`
                        )->a( n = `hAlign`         v = `Center`
                        )->open( `header`
                            )->leaf( `Text`
                                )->a( n = `text` v = `Weight`

                    )->shut(
                    )->shut(
                    )->open( `Column`
                        )->a( n = `hAlign` v = `End`
                        )->open( `header`
                            )->leaf( `Text`
                                )->a( n = `text` v = `Product`

                    )->shut(
                    )->shut(
                )->shut(
            )->shut(
        )->shut(

        )->open( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->leaf( `Input`
                )->a( n = `id`            v = `productInput`
                )->a( n = `type`          v = `Text`
                )->a( n = `value`         v = `Astro Phone 6`
                )->a( n = `placeholder`   v = `Enter Product ...`
                )->a( n = `showValueHelp` v = `true`
                )->a( n = `valueHelpRequest` v = client->_event( `VALUE_HELP` )
                )->a( n = `width`         v = `15rem`
                )->a( n = `class`         v = `sapUiSmallMarginBottom`

            )->open( `Button`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
                )->a( n = `text`  v = `Show Table Select Dialog`
                )->a( n = `press` v = client->_event( `OPEN_1` )

            )->shut(
            )->open( `Button`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
                )->a( n = `text`  v = `Show Table Select Dialog (Multi)`
                )->a( n = `press` v = client->_event( `OPEN_2` )
                )->open( `customData`
                    )->leaf( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `multi`
                        )->a( n = `value` v = `true`

            )->shut(
            )->shut(
            )->open( `Button`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
                )->a( n = `text`  v = `Show Table Select Dialog (draggable=true)`
                )->a( n = `press` v = client->_event( `OPEN_3` )
                )->open( `customData`
                    )->leaf( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `multi`
                        )->a( n = `value` v = `true`
                    )->leaf( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `draggable`
                        )->a( n = `value` v = `true`

            )->shut(
            )->shut(
            )->open( `Button`
                )->a( n = `text`  v = `Show Table Select Dialog (resizable=true)`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
                )->a( n = `press` v = client->_event( `OPEN_4` )
                )->open( `customData`
                    )->leaf( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `multi`
                        )->a( n = `value` v = `true`
                    )->leaf( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `resizable`
                        )->a( n = `value` v = `true`

            )->shut(
            )->shut(
            )->open( `Button`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
                )->a( n = `text`  v = `Show Table Select Dialog (Remember)`
                )->a( n = `press` v = client->_event( `OPEN_5` )
                )->open( `customData`
                    )->leaf( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `multi`
                        )->a( n = `value` v = `true`
                    )->leaf( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `remember`
                        )->a( n = `value` v = `true`

            )->shut(
            )->shut(
            )->open( `Button`
                )->a( n = `text`  v = `Show Table Select Dialog (Custom confirmation button text)`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
                )->a( n = `press` v = client->_event( `OPEN_6` )
                )->open( `customData`
                    )->leaf( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `multi`
                        )->a( n = `value` v = `true`
                    )->leaf( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `confirmButtonText`
                        )->a( n = `value` v = `Save`

            )->shut(
            )->shut(
            )->open( `Button`
                )->a( n = `text`  v = `Show Table Select Dialog with Responsive Padding`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
                )->a( n = `press` v = client->_event( `OPEN_7` )
                )->open( `customData`
                    )->leaf( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `resizable`
                        )->a( n = `value` v = `true`
                    )->leaf( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `draggable`
                        )->a( n = `value` v = `true`
                    )->leaf( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `responsivePadding`
                        )->a( n = `value` v = `true`

            )->shut(
            )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `OPEN_1`.
        open_dialog( ).

      WHEN `OPEN_2`.
        open_dialog( multi = abap_true ).

      WHEN `OPEN_3`.
        open_dialog( multi = abap_true drag = abap_true ).

      WHEN `OPEN_4`.
        open_dialog( multi = abap_true resize = abap_true ).

      WHEN `OPEN_5`.
        open_dialog( multi = abap_true rem = abap_true ).

      WHEN `OPEN_6`.
        open_dialog( multi = abap_true confirmtext = `Save` ).

      WHEN `OPEN_7`.
        open_dialog( resize = abap_true drag = abap_true responsive = abap_true ).

      WHEN `VALUE_HELP`.
        " preselect the row matching the current input value (original _configValueHelpDialog)
        LOOP AT t_products REFERENCE INTO DATA(lr).
          lr->selected = xsdbool( lr->name = `Astro Phone 6` ).
        ENDLOOP.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( `valueHelpDialog` ) ( `open` ) ) ).

      WHEN `CONFIRM`.
        client->message_toast_display( `Selection confirmed` ).

      WHEN `VH_CLOSE`.
        client->message_toast_display( `Value help closed` ).

    ENDCASE.

  ENDMETHOD.


  METHOD open_dialog.

    multi_select = multi.
    draggable    = drag.
    resizable    = resize.
    remember     = rem.
    confirm_text = confirmtext.
    client->view_model_update( ).

    IF responsive = abap_true.
      client->follow_up_action( val   = client->cs_event-control_by_id
                                t_arg = VALUE #( ( `myDialog` ) ( `addStyleClass` )
                                                 ( `sapUiResponsivePadding--header sapUiResponsivePadding--subHeader sapUiResponsivePadding--content sapUiResponsivePadding--footer` ) ) ).
    ELSE.
      client->follow_up_action( val   = client->cs_event-control_by_id
                                t_arg = VALUE #( ( `myDialog` ) ( `removeStyleClass` )
                                                 ( `sapUiResponsivePadding--header sapUiResponsivePadding--subHeader sapUiResponsivePadding--content sapUiResponsivePadding--footer` ) ) ).
    ENDIF.

    client->follow_up_action( val   = client->cs_event-control_by_id
                              t_arg = VALUE #( ( `myDialog` ) ( `open` ) ) ).

  ENDMETHOD.


  METHOD model_init.

    t_products = VALUE #(
      ( name = `Notebook Basic 15` product_id = `HT-1000` category = `Laptops` main_category = `Computer Systems` supplier_name = `Very Best Screens`
        description = `Notebook Basic 15 with 2,80 GHz quad core, 15" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`
        width = `30` depth = `18` height = `3` dim_unit = `cm` weight_measure = `4.2` weight_unit = `KG`
        quantity = `10` price = '956.00' currency_code = `EUR` )
      ( name = `Notebook Basic 17` product_id = `HT-1001` category = `Laptops` main_category = `Computer Systems` supplier_name = `Very Best Screens`
        description = `Notebook Basic 17 with 2,80 GHz quad core, 17" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`
        width = `29` depth = `17` height = `3.1` dim_unit = `cm` weight_measure = `4.5` weight_unit = `KG`
        quantity = `20` price = '1249.00' currency_code = `EUR` )
      ( name = `Notebook Basic 18` product_id = `HT-1002` category = `Laptops` main_category = `Computer Systems` supplier_name = `Very Best Screens`
        description = `Notebook Basic 18 with 2,80 GHz quad core, 18" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro`
        width = `28` depth = `19` height = `2.5` dim_unit = `cm` weight_measure = `4.2` weight_unit = `KG`
        quantity = `10` price = '1570.00' currency_code = `EUR` )
      ( name = `Notebook Basic 19` product_id = `HT-1003` category = `Laptops` main_category = `Computer Systems` supplier_name = `Smartcards`
        description = `Notebook Basic 19 with 2,80 GHz quad core, 19" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro`
        width = `32` depth = `21` height = `4` dim_unit = `cm` weight_measure = `4.2` weight_unit = `KG`
        quantity = `15` price = '1650.00' currency_code = `EUR` )
      ( name = `ITelO Vault` product_id = `HT-1007` category = `Accessories` main_category = `Computer Components` supplier_name = `Technocom`
        description = `Digital Organizer with State-of-the-Art Storage Encryption`
        width = `32` depth = `22` height = `3` dim_unit = `cm` weight_measure = `0.2` weight_unit = `KG`
        quantity = `15` price = '299.00' currency_code = `EUR` )
      ( name = `Notebook Professional 15` product_id = `HT-1010` category = `Accessories` main_category = `Computer Systems` supplier_name = `Very Best Screens`
        description = `Notebook Professional 15 with 2,80 GHz quad core, 15" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro`
        width = `33` depth = `20` height = `3` dim_unit = `cm` weight_measure = `4.3` weight_unit = `KG`
        quantity = `16` price = '1999.00' currency_code = `EUR` )
      ( name = `Notebook Professional 17` product_id = `HT-1011` category = `Laptops` main_category = `Computer Systems` supplier_name = `Very Best Screens`
        description = `Notebook Professional 17 with 2,80 GHz quad core, 17" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro`
        width = `33` depth = `23` height = `2` dim_unit = `cm` weight_measure = `4.1` weight_unit = `KG`
        quantity = `17` price = '2299.00' currency_code = `EUR` )
      ( name = `ITelO Vault Net` product_id = `HT-1020` category = `Accessories` main_category = `Computer Components` supplier_name = `Technocom`
        description = `Digital Organizer with State-of-the-Art Encryption for Storage and Network Communications`
        width = `10` depth = `1.8` height = `17` dim_unit = `cm` weight_measure = `0.16` weight_unit = `KG`
        quantity = `14` price = '459.00' currency_code = `EUR` )
      ( name = `ITelO Vault SAT` product_id = `HT-1021` category = `Accessories` main_category = `Computer Components` supplier_name = `Technocom`
        description = `Digital Organizer with State-of-the-Art Encryption for Storage and Secure Stellite Link`
        width = `11` depth = `1.7` height = `18` dim_unit = `cm` weight_measure = `0.18` weight_unit = `KG`
        quantity = `50` price = '149.00' currency_code = `EUR` )
      ( name = `Comfort Easy` product_id = `HT-1022` category = `Accessories` main_category = `Computer Components` supplier_name = `Technocom`
        description = `32 GB Digital Assistant with high-resolution color screen`
        width = `84` depth = `1.5` height = `14` dim_unit = `cm` weight_measure = `0.2` weight_unit = `KG`
        quantity = `30` price = '1679.00' currency_code = `EUR` )
      ( name = `Comfort Senior` product_id = `HT-1023` category = `Accessories` main_category = `Computer Components` supplier_name = `Technocom`
        description = `64 GB Digital Assistant with high-resolution color screen and synthesized voice output`
        width = `80` depth = `1.6` height = `13` dim_unit = `cm` weight_measure = `0.8` weight_unit = `KG`
        quantity = `24` price = '512.00' currency_code = `EUR` )
      ( name = `Ergo Screen E-I` product_id = `HT-1030` category = `Flat Screen Monitors` main_category = `Computer Components` supplier_name = `Very Best Screens`
        description = `Optimum Hi-Resolution max. 1920 x 1080 @ 85Hz, Dot Pitch: 0.27mm`
        width = `37` depth = `12` height = `36` dim_unit = `cm` weight_measure = `21` weight_unit = `KG`
        quantity = `14` price = '230.00' currency_code = `EUR` )
      ( name = `Ergo Screen E-II` product_id = `HT-1031` category = `Flat Screen Monitors` main_category = `Computer Components` supplier_name = `Very Best Screens`
        description = `Optimum Hi-Resolution max. 1920 x 1200 @ 85Hz, Dot Pitch: 0.26mm`
        width = `40.8` depth = `19` height = `43` dim_unit = `cm` weight_measure = `21` weight_unit = `KG`
        quantity = `24` price = '285.00' currency_code = `EUR` )
      ( name = `Ergo Screen E-III` product_id = `HT-1032` category = `Flat Screen Monitors` main_category = `Computer Components` supplier_name = `Very Best Screens`
        description = `Optimum Hi-Resolution max. 2560 x 1440 @ 85Hz, Dot Pitch: 0.25mm`
        width = `40.8` depth = `19` height = `43` dim_unit = `cm` weight_measure = `21` weight_unit = `KG`
        quantity = `50` price = '345.00' currency_code = `EUR` )
      ( name = `Flat Basic` product_id = `HT-1035` category = `Flat Screen Monitors` main_category = `Computer Components` supplier_name = `Very Best Screens`
        description = `Optimum Hi-Resolution max. 1600 x 1200 @ 85Hz, Dot Pitch: 0.24mm`
        width = `39` depth = `20` height = `41` dim_unit = `cm` weight_measure = `14` weight_unit = `KG`
        quantity = `23` price = '399.00' currency_code = `EUR` )
      ( name = `Flat Future` product_id = `HT-1036` category = `Flat Screen Monitors` main_category = `Computer Components` supplier_name = `Very Best Screens`
        description = `Optimum Hi-Resolution max. 2048 x 1080 @ 85Hz, Dot Pitch: 0.26mm`
        width = `45` depth = `26` height = `46` dim_unit = `cm` weight_measure = `15` weight_unit = `KG`
        quantity = `22` price = '430.00' currency_code = `EUR` )
      ( name = `Flat XL` product_id = `HT-1037` category = `Flat Screen Monitors` main_category = `Computer Components` supplier_name = `Very Best Screens`
        description = `Optimum Hi-Resolution max. 2016 x 1512 @ 85Hz, Dot Pitch: 0.24mm`
        width = `54.5` depth = `22.1` height = `39.1` dim_unit = `cm` weight_measure = `17` weight_unit = `KG`
        quantity = `23` price = '1230.00' currency_code = `EUR` )
      ( name = `Laser Professional Eco` product_id = `HT-1040` category = `Printers` main_category = `Printers & Scanners` supplier_name = `Alpha Printers`
        description = `Print 2400 dpi image quality color documents at speeds of up to 32 ppm (color) or 36 ppm (monochrome), letter/A4. Powerful 500 MHz processor, 512MB of memory`
        width = `51` depth = `46` height = `30` dim_unit = `cm` weight_measure = `32` weight_unit = `KG`
        quantity = `21` price = '830.00' currency_code = `EUR` )
      ( name = `Laser Basic` product_id = `HT-1041` category = `Printers` main_category = `Printers & Scanners` supplier_name = `Alpha Printers`
        description = `Up to 22 ppm color or 24 ppm monochrome A4/letter, powerful 500 MHz processor and 128MB of memory`
        width = `48` depth = `42` height = `26` dim_unit = `cm` weight_measure = `23` weight_unit = `KG`
        quantity = `8` price = '490.00' currency_code = `EUR` )
      ( name = `Laser Allround` product_id = `HT-1042` category = `Printers` main_category = `Printers & Scanners` supplier_name = `Alpha Printers`
        description = `Print up to 25 ppm letter and 24 ppm A4 color or monochrome, with Available first-page-out-time of less than 13 seconds for monochrome and less than 15 seconds for color`
        width = `53` depth = `50` height = `65` dim_unit = `cm` weight_measure = `17` weight_unit = `KG`
        quantity = `9` price = '349.00' currency_code = `EUR` )
      ( name = `Ultra Jet Super Color` product_id = `HT-1050` category = `Printers` main_category = `Printers & Scanners` supplier_name = `Alpha Printers`
        description = `4800 dpi x 1200 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB, Ethernet`
        width = `41` depth = `41` height = `28` dim_unit = `cm` weight_measure = `3` weight_unit = `KG`
        quantity = `17` price = '139.00' currency_code = `EUR` )
      ( name = `Ultra Jet Mobile` product_id = `HT-1051` category = `Printers` main_category = `Printers & Scanners` supplier_name = `Printer for All`
        description = `1000 dpi x 1000 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB - excellent dimensions for the small office`
        width = `46` depth = `32` height = `25` dim_unit = `cm` weight_measure = `1.9` weight_unit = `KG`
        quantity = `18` price = '99.00' currency_code = `EUR` )
      ( name = `Ultra Jet Super Highspeed` product_id = `HT-1052` category = `Printers` main_category = `Printers & Scanners` supplier_name = `Printer for All`
        description = `4800 dpi x 1200 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB2.0, Ethernet`
        width = `41` depth = `41` height = `28` dim_unit = `cm` weight_measure = `18` weight_unit = `KG`
        quantity = `25` price = '170.00' currency_code = `EUR` )
      ( name = `Multi Print` product_id = `HT-1055` category = `Multifunction Printers` main_category = `Printers & Scanners` supplier_name = `Printer for All`
        description = `1000 dpi x 1000 dpi - up to 16 ppm (mono) / up to 15 ppm (color)- capacity 80 sheets - scanner (216 x 297 mm, 1200dpi x 2400dpi)`
        width = `55` depth = `45` height = `29` dim_unit = `cm` weight_measure = `6.3` weight_unit = `KG`
        quantity = `16` price = '99.00' currency_code = `EUR` )
      ( name = `Multi Color` product_id = `HT-1056` category = `Multifunction Printers` main_category = `Printers & Scanners` supplier_name = `Printer for All`
        description = `1200 dpi x 1200 dpi - up to 25 ppm (mono) / up to 24 ppm (color)- capacity 80 sheets - scanner (216 x 297 mm, 2400dpi x 4800dpi, high resolution)`
        width = `51` depth = `41.3` height = `22` dim_unit = `cm` weight_measure = `4.3` weight_unit = `KG`
        quantity = `5` price = '119.00' currency_code = `EUR` )
      ( name = `Cordless Mouse` product_id = `HT-1060` category = `Mice` main_category = `Computer Components` supplier_name = `Oxynum`
        description = `Cordless Optical USB Mice, Laptop, Color: Black, Plug&Play`
        width = `6` depth = `14.5` height = `3.5` dim_unit = `cm` weight_measure = `0.09` weight_unit = `KG`
        quantity = `25` price = '9.00' currency_code = `EUR` )
      ( name = `Speed Mouse` product_id = `HT-1061` category = `Mice` main_category = `Computer Components` supplier_name = `Oxynum`
        description = `Optical USB, PS/2 Mouse, Color: Blue, 3-button-functionality (incl. Scroll wheel)`
        width = `7` depth = `15` height = `3.1` dim_unit = `cm` weight_measure = `0.09` weight_unit = `KG`
        quantity = `12` price = '7.00' currency_code = `EUR` )
      ( name = `Track Mouse` product_id = `HT-1062` category = `Mice` main_category = `Computer Components` supplier_name = `Oxynum`
        description = `Optical USB Mouse, Color: Red, 5-button-functionality(incl. Scroll wheel), Plug&Play`
        width = `3` depth = `7` height = `4` dim_unit = `cm` weight_measure = `0.03` weight_unit = `KG`
        quantity = `12` price = '11.00' currency_code = `EUR` )
      ( name = `Ergonomic Keyboard` product_id = `HT-1063` category = `Keyboards` main_category = `Computer Components` supplier_name = `Oxynum`
        description = `Ergonomic USB Keyboard for Desktop, Plug&Play`
        width = `50` depth = `21` height = `3.5` dim_unit = `cm` weight_measure = `2.1` weight_unit = `KG`
        quantity = `50` price = '14.00' currency_code = `EUR` )
      ( name = `Internet Keyboard` product_id = `HT-1064` category = `Keyboards` main_category = `Computer Components` supplier_name = `Oxynum`
        description = `Corded Keyboard with special keys for Internet Usability, USB`
        width = `52` depth = `25` height = `3` dim_unit = `cm` weight_measure = `1.8` weight_unit = `KG`
        quantity = `35` price = '16.00' currency_code = `EUR` )
      ( name = `Media Keyboard` product_id = `HT-1065` category = `Keyboards` main_category = `Computer Components` supplier_name = `Oxynum`
        description = `Corded Ergonomic Keyboard with special keys for Media Usability, USB`
        width = `51.4` depth = `23` height = `4` dim_unit = `cm` weight_measure = `2.3` weight_unit = `KG`
        quantity = `26` price = '26.00' currency_code = `EUR` )
      ( name = `Mousepad` product_id = `HT-1066` category = `Mousepads` main_category = `Computer Components` supplier_name = `Oxynum`
        description = `Nice mouse pad with ITelO Logo`
        width = `15` depth = `6` height = `0.2` dim_unit = `cm` weight_measure = `80` weight_unit = `G`
        quantity = `12` price = '6.99' currency_code = `EUR` )
      ( name = `Ergo Mousepad` product_id = `HT-1067` category = `Mousepads` main_category = `Computer Components` supplier_name = `Oxynum`
        description = `Ergonomic mouse pad with ITelO Logo`
        width = `15` depth = `6` height = `0.2` dim_unit = `cm` weight_measure = `80` weight_unit = `G`
        quantity = `16` price = '8.99' currency_code = `EUR` )
      ( name = `Designer Mousepad` product_id = `HT-1068` category = `Mousepads` main_category = `Computer Components` supplier_name = `Fasttech`
        description = `ITelO Mousepad Special Edition`
        width = `24` depth = `24` height = `0.6` dim_unit = `cm` weight_measure = `90` weight_unit = `G`
        quantity = `26` price = '12.99' currency_code = `EUR` )
      ( name = `Universal card reader` product_id = `HT-1069` category = `Computer System Accessories` main_category = `Computer Systems` supplier_name = `Fasttech`
        description = `Universal card reader`
        width = `6` depth = `6` height = `3` dim_unit = `cm` weight_measure = `45` weight_unit = `G`
        quantity = `22` price = '14.00' currency_code = `EUR` )
      ( name = `Proctra X` product_id = `HT-1070` category = `Graphic Cards` main_category = `Computer Components` supplier_name = `Ultrasonic United`
        description = `Proctra X: PCI-E GDDR5 3072MB`
        width = `22` depth = `35` height = `17` dim_unit = `cm` weight_measure = `0.255` weight_unit = `KG`
        quantity = `15` price = '70.90' currency_code = `EUR` )
      ( name = `Gladiator MX` product_id = `HT-1071` category = `Graphic Cards` main_category = `Computer Components` supplier_name = `Ultrasonic United`
        description = `Gladiator XLN: PCI-E GDDR5 3072MB DVI Out, TV Out low-noise`
        width = `22` depth = `35` height = `17` dim_unit = `cm` weight_measure = `0.3` weight_unit = `KG`
        quantity = `16` price = '81.70' currency_code = `EUR` )
      ( name = `Hurricane GX` product_id = `HT-1072` category = `Graphic Cards` main_category = `Computer Components` supplier_name = `Ultrasonic United`
        description = `Hurricane GX: PCI-E 691 GFLOPS game-optimized`
        width = `22` depth = `35` height = `17` dim_unit = `cm` weight_measure = `0.4` weight_unit = `KG`
        quantity = `13` price = '101.20' currency_code = `EUR` )
      ( name = `Hurricane GX/LN` product_id = `HT-1073` category = `Graphic Cards` main_category = `Computer Components` supplier_name = `Smartcards`
        description = `Hurricane GX/LN: PCI-E 691 GFLOPS game-optimized, low-noise.`
        width = `22` depth = `35` height = `17` dim_unit = `cm` weight_measure = `0.4` weight_unit = `KG`
        quantity = `5` price = '139.99' currency_code = `EUR` )
      ( name = `Photo Scan` product_id = `HT-1080` category = `Scanners` main_category = `Printers & Scanners` supplier_name = `Printer for All`
        description = `Flatbed scanner - 9.600 × 9.600 dpi - 216 x 297 mm - Hi-Speed USB - Bluetooth`
        width = `34` depth = `48` height = `5` dim_unit = `cm` weight_measure = `2.3` weight_unit = `KG`
        quantity = `8` price = '129.00' currency_code = `EUR` )
      ( name = `Power Scan` product_id = `HT-1081` category = `Scanners` main_category = `Printers & Scanners` supplier_name = `Printer for All`
        description = `Flatbed scanner - 9.600 × 9.600 dpi - 216 x 297 mm - SCSI for backward compatibility`
        width = `31` depth = `43` height = `7` dim_unit = `cm` weight_measure = `2.4` weight_unit = `KG`
        quantity = `11` price = '89.00' currency_code = `EUR` )
      ( name = `Jet Scan Professional` product_id = `HT-1082` category = `Scanners` main_category = `Printers & Scanners` supplier_name = `Printer for All`
        description = `Flatbed scanner - Letter - 2400 dpi x 2400 dpi - 216 x 297 mm - add-on module`
        width = `33` depth = `41` height = `12` dim_unit = `cm` weight_measure = `3.2` weight_unit = `KG`
        quantity = `13` price = '169.00' currency_code = `EUR` )
      ( name = `Jet Scan Professional` product_id = `HT-1083` category = `Scanners` main_category = `Printers & Scanners` supplier_name = `Printer for All`
        description = `Flatbed scanner - A4 - 2400 dpi x 2400 dpi - 216 x 297 mm - add-on module`
        width = `35` depth = `40` height = `10` dim_unit = `cm` weight_measure = `3.2` weight_unit = `KG`
        quantity = `10` price = '189.00' currency_code = `EUR` )
      ( name = `Copymaster` product_id = `HT-1085` category = `Multifunction Printers` main_category = `Printers & Scanners` supplier_name = `Alpha Printers`
        description = `Copymaster`
        width = `45` depth = `42` height = `22` dim_unit = `cm` weight_measure = `23.2` weight_unit = `KG`
        quantity = `10` price = '1499.00' currency_code = `EUR` )
      ( name = `Surround Sound` product_id = `HT-1090` category = `Speakers` main_category = `Computer Components` supplier_name = `Speaker Experts`
        description = `PC multimedia speakers - 5 Watt (Total)`
        width = `12` depth = `10` height = `16` dim_unit = `cm` weight_measure = `3` weight_unit = `KG`
        quantity = `20` price = '39.00' currency_code = `EUR` )
      ( name = `Blaster Extreme` product_id = `HT-1091` category = `Speakers` main_category = `Computer Components` supplier_name = `Speaker Experts`
        description = `PC multimedia speakers - 10 Watt (Total) - 2-way`
        width = `13` depth = `11` height = `17.5` dim_unit = `cm` weight_measure = `1.4` weight_unit = `KG`
        quantity = `15` price = '26.00' currency_code = `EUR` )
      ( name = `Sound Booster` product_id = `HT-1092` category = `Speakers` main_category = `Computer Components` supplier_name = `Speaker Experts`
        description = `PC multimedia speakers - optimized for Blutooth/A2DP`
        width = `12.4` depth = `10.4` height = `18.1` dim_unit = `cm` weight_measure = `2.1` weight_unit = `KG`
        quantity = `50` price = '45.00' currency_code = `EUR` )
      ( name = `Lovely Sound 5.1 Wireless` product_id = `HT-1095` category = `Accessories` main_category = `Computer Components` supplier_name = `Fasttech`
        description = `5.1 Headset, 40 Hz-20 kHz, Wireless`
        width = `24` depth = `19` height = `23` dim_unit = `cm` weight_measure = `80` weight_unit = `G`
        quantity = `12` price = '49.00' currency_code = `EUR` )
      ( name = `Lovely Sound 5.1` product_id = `HT-1096` category = `Accessories` main_category = `Computer Components` supplier_name = `Fasttech`
        description = `5.1 Headset, 40 Hz-20 kHz, 3m cable`
        width = `25` depth = `17` height = `19` dim_unit = `cm` weight_measure = `130` weight_unit = `G`
        quantity = `18` price = '39.00' currency_code = `EUR` )
      ( name = `Lovely Sound Stereo` product_id = `HT-1097` category = `Accessories` main_category = `Computer Components` supplier_name = `Fasttech`
        description = `5.1 Headset, 40 Hz-20 kHz, 1m cable`
        width = `21.3` depth = `2.4` height = `19.7` dim_unit = `cm` weight_measure = `60` weight_unit = `G`
        quantity = `21` price = '29.00' currency_code = `EUR` )
      ( name = `Smart Office` product_id = `HT-1100` category = `Software` main_category = `Software` supplier_name = `Technocom`
        description = `Complete package, 1 User, Office Applications (word processing, spreadsheet, presentations)`
        width = `15` depth = `6.5` height = `2.1` dim_unit = `cm` weight_measure = `1.2` weight_unit = `KG`
        quantity = `25` price = '89.90' currency_code = `EUR` )
      ( name = `Smart Design` product_id = `HT-1101` category = `Software` main_category = `Software` supplier_name = `Technocom`
        description = `Complete package, 1 User, Image editing, processing`
        width = `14` depth = `6.7` height = `24` dim_unit = `cm` weight_measure = `0.8` weight_unit = `KG`
        quantity = `26` price = '79.90' currency_code = `EUR` )
      ( name = `Smart Network` product_id = `HT-1102` category = `Software` main_category = `Software` supplier_name = `Technocom`
        description = `Complete package, 1 User, Network Software Utilities, Useful Applications and Documentation`
        width = `16` depth = `6` height = `27` dim_unit = `cm` weight_measure = `0.8` weight_unit = `KG`
        quantity = `28` price = '69.00' currency_code = `EUR` )
      ( name = `Smart Multimedia` product_id = `HT-1103` category = `Software` main_category = `Software` supplier_name = `Technocom`
        description = `Complete package, 1 User, different Multimedia applications, playing music, watching DVDs, only with this Smart package`
        width = `11` depth = `3.4` height = `22` dim_unit = `cm` weight_measure = `0.8` weight_unit = `KG`
        quantity = `9` price = '77.00' currency_code = `EUR` )
      ( name = `Smart Games` product_id = `HT-1104` category = `Software` main_category = `Software` supplier_name = `Technocom`
        description = `Complete package, 1 User, various games for amusement, logic, action, jump&run`
        width = `10` depth = `3` height = `30` dim_unit = `cm` weight_measure = `1.1` weight_unit = `KG`
        quantity = `13` price = '55.00' currency_code = `EUR` )
      ( name = `Smart Internet Antivirus` product_id = `HT-1105` category = `Software` main_category = `Software` supplier_name = `Brainsoft`
        description = `Complete package, 1 User, highly recommended for internet users as anti-virus protection`
        width = `16` depth = `4` height = `21` dim_unit = `cm` weight_measure = `0.7` weight_unit = `KG`
        quantity = `17` price = '29.00' currency_code = `EUR` )
      ( name = `Smart Firewall` product_id = `HT-1106` category = `Software` main_category = `Software` supplier_name = `Brainsoft`
        description = `Complete package, 1 User, recommended for internet users, protect your PC against cyber-crime`
        width = `17.9` depth = `4.2` height = `23.1` dim_unit = `cm` weight_measure = `0.9` weight_unit = `KG`
        quantity = `19` price = '34.00' currency_code = `EUR` )
      ( name = `Smart Money` product_id = `HT-1107` category = `Software` main_category = `Software` supplier_name = `Brainsoft`
        description = `Complete package, 1 User, bring your money in your mind, see what you have and what you want`
        width = `12` depth = `1.5` height = `19` dim_unit = `cm` weight_measure = `0.5` weight_unit = `KG`
        quantity = `18` price = '29.90' currency_code = `EUR` )
      ( name = `PC Lock` product_id = `HT-1110` category = `Computer System Accessories` main_category = `Computer Systems` supplier_name = `Red Point Stores`
        description = `Robust 3m anti-burglary protection for your laptop computer`
        width = `20` depth = `8` height = `4.3` dim_unit = `cm` weight_measure = `0.03` weight_unit = `KG`
        quantity = `14` price = '8.90' currency_code = `EUR` )
      ( name = `Notebook Lock` product_id = `HT-1111` category = `Computer System Accessories` main_category = `Computer Systems` supplier_name = `Red Point Stores`
        description = `Robust 1m anti-burglary protection for your desktop computer`
        width = `31` depth = `9` height = `7` dim_unit = `cm` weight_measure = `0.02` weight_unit = `KG`
        quantity = `20` price = '6.90' currency_code = `EUR` )
      ( name = `Web cam reality` product_id = `HT-1112` category = `Computer System Accessories` main_category = `Computer Systems` supplier_name = `Red Point Stores`
        description = `Color webcam, color, High-Speed USB`
        width = `9` depth = `8.2` height = `1.3` dim_unit = `cm` weight_measure = `0.075` weight_unit = `KG`
        quantity = `27` price = '39.00' currency_code = `EUR` )
      ( name = `Screen clean` product_id = `HT-1113` category = `Computer System Accessories` main_category = `Computer Systems` supplier_name = `Red Point Stores`
        description = `10 separately packed screen wipes`
        width = `2` depth = `2` height = `0.1` dim_unit = `cm` weight_measure = `0.05` weight_unit = `KG`
        quantity = `17` price = '2.30' currency_code = `EUR` )
      ( name = `Fabric bag professional` product_id = `HT-1114` category = `Computer System Accessories` main_category = `Computer Systems` supplier_name = `Red Point Stores`
        description = `Notebook bag, plenty of room for stationery and writing materials`
        width = `42` depth = `32` height = `7` dim_unit = `cm` weight_measure = `1.8` weight_unit = `KG`
        quantity = `14` price = '31.00' currency_code = `EUR` )
      ( name = `Wireless DSL Router` product_id = `HT-1115` category = `Telecommunications` main_category = `Computer Components` supplier_name = `Red Point Stores`
        description = `Wireless DSL Router (available in blue, black and silver)`
        width = `19.3` depth = `18` height = `5` dim_unit = `cm` weight_measure = `0.45` weight_unit = `KG`
        quantity = `16` price = '49.00' currency_code = `EUR` )
      ( name = `Wireless DSL Router / Repeater` product_id = `HT-1116` category = `Telecommunications` main_category = `Computer Components` supplier_name = `Red Point Stores`
        description = `Wireless DSL Router / Repeater (available in blue, black and silver)`
        width = `19.3` depth = `18` height = `5` dim_unit = `cm` weight_measure = `0.45` weight_unit = `KG`
        quantity = `12` price = '59.00' currency_code = `EUR` )
      ( name = `Wireless DSL Router / Repeater and Print Server` product_id = `HT-1117` category = `Telecommunications` main_category = `Computer Components` supplier_name = `Technocom`
        description = `Wireless DSL Router / Repeater and Print Server (available in blue, black and silver)`
        width = `19.3` depth = `18` height = `5` dim_unit = `cm` weight_measure = `0.45` weight_unit = `KG`
        quantity = `12` price = '69.00' currency_code = `EUR` )
      ( name = `USB Stick` product_id = `HT-1118` category = `Computer System Accessories` main_category = `Computer Systems` supplier_name = `Technocom`
        description = `USB 2.0 High-Speed 64 GB`
        width = `1.5` depth = `8.7` height = `1.2` dim_unit = `cm` weight_measure = `0.015` weight_unit = `KG`
        quantity = `14` price = '35.00' currency_code = `EUR` )
      ( name = `Travel Adapter` product_id = `HT-1119` category = `Accessories` main_category = `Computer Systems` supplier_name = `Titanium`
        description = `Universal Travel Adapter`
        width = `2` depth = `3.1` height = `3.9` dim_unit = `cm` weight_measure = `88` weight_unit = `G`
        quantity = `10` price = '79.00' currency_code = `EUR` )
      ( name = `Cordless Bluetooth Keyboard, english international` product_id = `HT-1120` category = `Keyboards` main_category = `Computer Components` supplier_name = `Technocom`
        description = `Cordless Bluetooth Keyboard with English keys`
        width = `51.4` depth = `23` height = `4` dim_unit = `cm` weight_measure = `1` weight_unit = `KG`
        quantity = `13` price = '29.00' currency_code = `EUR` )
      ( name = `Flat XXL` product_id = `HT-1137` category = `Flat Screen Monitors` main_category = `Computer Components` supplier_name = `Technocom`
        description = `Optimum Hi-Resolution max. 2048 × 1536 @ 85Hz, Dot Pitch: 0.24mm`
        width = `54` depth = `22` height = `38` dim_unit = `cm` weight_measure = `18` weight_unit = `KG`
        quantity = `10` price = '1430.00' currency_code = `EUR` )
      ( name = `Pocket Mouse` product_id = `HT-1138` category = `Mice` main_category = `Computer Components` supplier_name = `Technocom`
        description = `Portable pocket Mouse with retracting cord`
        width = `0.3` depth = `0.5` height = `1` dim_unit = `cm` weight_measure = `0.02` weight_unit = `KG`
        quantity = `20` price = '23.00' currency_code = `EUR` )
      ( name = `PC Power Station` product_id = `HT-1210` category = `PCs` main_category = `Computer Systems` supplier_name = `Technocom`
        description = `PC Power Station with 3,4 Ghz quad-core, 32 GB DDR3 SDRAM, feels like Available PC, Windows 8 Pro`
        width = `28` depth = `31` height = `43` dim_unit = `cm` weight_measure = `2.3` weight_unit = `KG`
        quantity = `22` price = '2399.00' currency_code = `EUR` )
      ( name = `Astro Laptop 1516` product_id = `HT-1251` category = `Laptops` main_category = `Computer Systems` supplier_name = `Ultrasonic United`
        description = `Flexible Laptop with 2,5 GHz Quad Core, 15" HD TN, 16 GB DDR SDRAM, 256 GB SSD, Windows 10 Pro`
        width = `30` depth = `18` height = `3` dim_unit = `cm` weight_measure = `4.2` weight_unit = `KG`
        quantity = `23` price = '989.00' currency_code = `EUR` )
      ( name = `Astro Phone 6` product_id = `HT-1252` category = `Smartphones and Tablets` main_category = `Smartphones & Tablets` supplier_name = `Ultrasonic United`
        description = `6 inch 1280x800 HD display (216 ppi), Quad-core processor, 8 GB internal storage (actual formatted capacity will be less), 3050 mAh battery (Up to 8 hours of active use), grey or black`
        width = `8` depth = `6` height = `1.5` dim_unit = `cm` weight_measure = `0.75` weight_unit = `KG`
        quantity = `28` price = '649.00' currency_code = `EUR` )
      ( name = `Benda Laptop 1408` product_id = `HT-1253` category = `Laptops` main_category = `Computer Systems` supplier_name = `Ultrasonic United`
        description = `Flexible Laptop with 2,5 GHz Dual Core, 14" HD+ TN, 8 GB DDR SDRAM, 324 GB SSD, Windows 10 Pro`
        width = `30` depth = `18` height = `3` dim_unit = `cm` weight_measure = `4.2` weight_unit = `KG`
        quantity = `27` price = '976.00' currency_code = `EUR` )
      ( name = `Bending Screen 21HD` product_id = `HT-1254` category = `Flat Screens` main_category = `Computer Components` supplier_name = `Ultrasonic United`
        description = `Optimum Hi-Resolution Widescreen max. 1920 x 1080 @ 85Hz, Dot Pitch: 0.27mm, HDMI, Discontinued-Sub`
        width = `37` depth = `12` height = `36` dim_unit = `cm` weight_measure = `15` weight_unit = `KG`
        quantity = `23` price = '250.00' currency_code = `EUR` )
      ( name = `Broad Screen 22HD` product_id = `HT-1255` category = `Flat Screens` main_category = `Computer Components` supplier_name = `Ultrasonic United`
        description = `Optimum Hi-Resolution Widescreen max. 2048 x 1080 @ 85Hz, Dot Pitch: 0.27mm, HDMI, Discontinued-Sub`
        width = `39` depth = `12` height = `38` dim_unit = `cm` weight_measure = `16` weight_unit = `KG`
        quantity = `5` price = '270.00' currency_code = `EUR` )
      ( name = `Cerdik Phone 7` product_id = `HT-1256` category = `Smartphones and Tablets` main_category = `Smartphones & Tablets` supplier_name = `Ultrasonic United`
        description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage (actual formatted capacity will be less), 4325 mAh battery (Up to 8 hours of active use), white or black`
        width = `9` depth = `15` height = `1.5` dim_unit = `cm` weight_measure = `0.75` weight_unit = `KG`
        quantity = `19` price = '549.00' currency_code = `EUR` )
      ( name = `Cepat Tablet 10.5` product_id = `HT-1257` category = `Smartphones and Tablets` main_category = `Smartphones & Tablets` supplier_name = `Ultrasonic United`
        description = `10.5-inch Multitouch HD Screen (1280 x 800), 16GB Internal Memory, Wireless N Wi-Fi; Bluetooth, GPS Enabled, 1GHz Dual-Core Processor`
        width = `48` depth = `31` height = `4.5` dim_unit = `cm` weight_measure = `2.8` weight_unit = `KG`
        quantity = `17` price = '549.00' currency_code = `EUR` )
      ( name = `Cepat Tablet 8` product_id = `HT-1258` category = `Smartphones and Tablets` main_category = `Smartphones & Tablets` supplier_name = `Ultrasonic United`
        description = `8-inch Multitouch HD Screen (2000 x 1500) 32GB Internal Memory, Wireless N Wi-Fi, Bluetooth, GPS Enabled, 1.5 GHz Quad-Core Processor`
        width = `38` depth = `21` height = `3.5` dim_unit = `cm` weight_measure = `2.5` weight_unit = `KG`
        quantity = `24` price = '529.00' currency_code = `EUR` )
      ( name = `Server Basic` product_id = `HT-1500` category = `Servers` main_category = `Computer Systems` supplier_name = `Technocom`
        description = `Dual socket, quad-core processing server with 1333 MHz Front Side Bus with 10Gb connectivity`
        width = `34` depth = `35` height = `23` dim_unit = `cm` weight_measure = `18` weight_unit = `KG`
        quantity = `24` price = '5000.00' currency_code = `EUR` )
      ( name = `Server Professional` product_id = `HT-1501` category = `Servers` main_category = `Computer Systems` supplier_name = `Technocom`
        description = `Dual socket, quad-core processing server with 1644 MHz Front Side Bus with 10Gb connectivity`
        width = `29` depth = `30` height = `27` dim_unit = `cm` weight_measure = `25` weight_unit = `KG`
        quantity = `26` price = '15000.00' currency_code = `EUR` )
      ( name = `Server Power Pro` product_id = `HT-1502` category = `Servers` main_category = `Computer Systems` supplier_name = `Technocom`
        description = `Dual socket, quad-core processing server with 1644 MHz Front Side Bus with 100Gb connectivity`
        width = `22` depth = `27.3` height = `37` dim_unit = `cm` weight_measure = `35` weight_unit = `KG`
        quantity = `34` price = '25000.00' currency_code = `EUR` )
      ( name = `Family PC Basic` product_id = `HT-1600` category = `Desktop Computers` main_category = `Computer Systems` supplier_name = `Titanium`
        description = `2,8 Ghz dual core, 4 GB DDR3 SDRAM, 500 GB Hard Disc, Graphic Card: Proctra X, Windows 8`
        width = `21.4` depth = `29` height = `38` dim_unit = `cm` weight_measure = `4.8` weight_unit = `KG`
        quantity = `10` price = '600.00' currency_code = `EUR` )
      ( name = `Family PC Pro` product_id = `HT-1601` category = `Desktop Computers` main_category = `Computer Systems` supplier_name = `Titanium`
        description = `2,8 Ghz dual core, 4 GB DDR3 SDRAM, 1000 GB Hard Disc, Graphic Card: Gladiator MX, Windows 8`
        width = `25` depth = `31.7` height = `40.2` dim_unit = `cm` weight_measure = `5.3` weight_unit = `KG`
        quantity = `20` price = '900.00' currency_code = `EUR` )
      ( name = `Gaming Monster` product_id = `HT-1602` category = `Desktop Computers` main_category = `Computer Systems` supplier_name = `Titanium`
        description = `3,4 Ghz quad core, 8 GB DDR3 SDRAM, 2000 GB Hard Disc, Graphic Card: Gladiator MX, Windows 8`
        width = `26.5` depth = `34` height = `47` dim_unit = `cm` weight_measure = `5.9` weight_unit = `KG`
        quantity = `24` price = '1200.00' currency_code = `EUR` )
      ( name = `Gaming Monster Pro` product_id = `HT-1603` category = `Desktop Computers` main_category = `Computer Systems` supplier_name = `Titanium`
        description = `3,4 Ghz quad core, 16 GB DDR3 SDRAM, 4000 GB Hard Disc, Graphic Card: Hurricane GX, Windows 8`
        width = `27` depth = `28` height = `42` dim_unit = `cm` weight_measure = `6.8` weight_unit = `KG`
        quantity = `25` price = '1700.00' currency_code = `EUR` )
      ( name = `7" Widescreen Portable DVD Player w MP3` product_id = `HT-2000` category = `Accessories` main_category = `TV, Video & HiFi` supplier_name = `Titanium`
        description = `7" LCD Screen, storage battery holds up to 6 hours!`
        width = `21.4` depth = `19` height = `27.6` dim_unit = `cm` weight_measure = `0.79` weight_unit = `KG`
        quantity = `20` price = '249.99' currency_code = `EUR` )
      ( name = `10" Portable DVD player` product_id = `HT-2001` category = `Accessories` main_category = `TV, Video & HiFi` supplier_name = `Titanium`
        description = `10" LCD Screen, storage battery holds up to 8 hours`
        width = `24` depth = `19.5` height = `29` dim_unit = `cm` weight_measure = `0.84` weight_unit = `KG`
        quantity = `21` price = '449.99' currency_code = `EUR` )
      ( name = `Portable DVD Player with 9" LCD Monitor` product_id = `HT-2002` category = `Accessories` main_category = `TV, Video & HiFi` supplier_name = `Technocom`
        description = `9" LCD Screen, storage holds up to 8 hours, 2 speakers included`
        width = `21` depth = `16.5` height = `14` dim_unit = `cm` weight_measure = `0.72` weight_unit = `KG`
        quantity = `50` price = '853.99' currency_code = `EUR` )
      ( name = `CD/DVD case: 264 sleeves` product_id = `HT-2025` category = `Accessories` main_category = `Computer Systems` supplier_name = `Titanium`
        description = `Organizer and protective case for 264 CDs and DVDs`
        width = `13` depth = `13` height = `20` dim_unit = `cm` weight_measure = `0.65` weight_unit = `KG`
        quantity = `26` price = '44.99' currency_code = `EUR` )
      ( name = `Audio/Video Cable Kit - 4m` product_id = `HT-2026` category = `Accessories` main_category = `Computer Systems` supplier_name = `Titanium`
        description = `Quality cables for notebooks and projectors`
        width = `21` depth = `10.2` height = `13` dim_unit = `cm` weight_measure = `0.2` weight_unit = `KG`
        quantity = `16` price = '29.99' currency_code = `EUR` )
      ( name = `Removable CD/DVD Laser Labels` product_id = `HT-2027` category = `Accessories` main_category = `Computer Systems` supplier_name = `Titanium`
        description = `Removable jewel case labels, zero residues (100)`
        width = `5.5` depth = `2` height = `2` dim_unit = `cm` weight_measure = `0.15` weight_unit = `KG`
        quantity = `25` price = '8.99' currency_code = `EUR` )
      ( name = `Beam Breaker B-1` product_id = `HT-6100` category = `Accessories` main_category = `TV, Video & HiFi` supplier_name = `Titanium`
        description = `720p, DLP Projector max. 8,45 Meter, 2D`
        width = `30.4` depth = `23.1` height = `23` dim_unit = `cm` weight_measure = `1.7` weight_unit = `KG`
        quantity = `32` price = '469.00' currency_code = `EUR` )
      ( name = `Beam Breaker B-2` product_id = `HT-6101` category = `Accessories` main_category = `TV, Video & HiFi` supplier_name = `Technocom`
        description = `1080p, DLP max.9,34 Meter, 2D-ready`
        width = `30.4` depth = `23.1` height = `23` dim_unit = `cm` weight_measure = `2` weight_unit = `KG`
        quantity = `18` price = '679.00' currency_code = `EUR` )
      ( name = `Beam Breaker B-3` product_id = `HT-6102` category = `Accessories` main_category = `TV, Video & HiFi` supplier_name = `Technocom`
        description = `1080p, DLP max. 12,3 Meter, 3D-ready`
        width = `30.4` depth = `23.1` height = `23` dim_unit = `cm` weight_measure = `2.5` weight_unit = `KG`
        quantity = `16` price = '889.00' currency_code = `EUR` )
      ( name = `Play Movie` product_id = `HT-6110` category = `Accessories` main_category = `TV, Video & HiFi` supplier_name = `Fasttech`
        description = `CD-RW, DVD+R/RW, DVD-R/RW, MPEG 2 (Video-DVD), MPEG 4, VCD, SVCD, DivX, Xvid`
        width = `37` depth = `24` height = `6` dim_unit = `cm` weight_measure = `2.4` weight_unit = `KG`
        quantity = `15` price = '130.00' currency_code = `EUR` )
      ( name = `Record Movie` product_id = `HT-6111` category = `Accessories` main_category = `TV, Video & HiFi` supplier_name = `Fasttech`
        description = `160 GB HDD, CD-RW, DVD+R/RW, DVD-R/RW, MPEG 2 (Video-DVD), MPEG 4, VCD, SVCD, DivX, Xvid`
        width = `38` depth = `26` height = `6.2` dim_unit = `cm` weight_measure = `3.1` weight_unit = `KG`
        quantity = `24` price = '288.00' currency_code = `EUR` )
      ( name = `ITelo MusicStick` product_id = `HT-6120` category = `Accessories` main_category = `TV, Video & HiFi` supplier_name = `Fasttech`
        description = `64 GB USB Music-on-Available-Stick`
        width = `1.5` depth = `6` height = `1` dim_unit = `cm` weight_measure = `134` weight_unit = `G`
        quantity = `15` price = '45.00' currency_code = `EUR` )
      ( name = `ITelo Jog-Mate` product_id = `HT-6121` category = `Accessories` main_category = `TV, Video & HiFi` supplier_name = `Fasttech`
        description = `ITelo Jog-Mate 64 GB HDD and Color Display, can play movies`
        width = `5.1` depth = `8` height = `9.2` dim_unit = `cm` weight_measure = `134` weight_unit = `G`
        quantity = `24` price = '63.00' currency_code = `EUR` )
      ( name = `Power Pro Player 40` product_id = `HT-6122` category = `Accessories` main_category = `TV, Video & HiFi` supplier_name = `Fasttech`
        description = `MP3-Player with 40 GB HDD and Color Display, can play movies`
        width = `5.1` depth = `8` height = `9.2` dim_unit = `cm` weight_measure = `266` weight_unit = `G`
        quantity = `23` price = '167.00' currency_code = `EUR` )
      ( name = `Power Pro Player 80` product_id = `HT-6123` category = `Accessories` main_category = `TV, Video & HiFi` supplier_name = `Fasttech`
        description = `MP3-Player with 80 GB SSD and Color Display, can play movies`
        width = `4` depth = `6` height = `0.8` dim_unit = `cm` weight_measure = `267` weight_unit = `G`
        quantity = `13` price = '299.00' currency_code = `EUR` )
      ( name = `Flat Watch HD32` product_id = `HT-6130` category = `Flat Screen TVs` main_category = `TV, Video & HiFi` supplier_name = `Very Best Screens`
        description = `32-inch, 1366x768 Pixel, 16:9, HDTV ready`
        width = `78` depth = `22.1` height = `55` dim_unit = `cm` weight_measure = `2.6` weight_unit = `KG`
        quantity = `16` price = '1459.00' currency_code = `EUR` )
      ( name = `Flat Watch HD37` product_id = `HT-6131` category = `Flat Screen TVs` main_category = `TV, Video & HiFi` supplier_name = `Very Best Screens`
        description = `37-inch, 1366x768 Pixel, 16:9, HDTV ready`
        width = `99.1` depth = `26` height = `61` dim_unit = `cm` weight_measure = `2.2` weight_unit = `KG`
        quantity = `14` price = '1199.00' currency_code = `EUR` )
      ( name = `Flat Watch HD41` product_id = `HT-6132` category = `Flat Screen TVs` main_category = `TV, Video & HiFi` supplier_name = `Very Best Screens`
        description = `41-inch, 1366x768 Pixel, 16:9, HDTV ready`
        width = `128` depth = `23` height = `79.1` dim_unit = `cm` weight_measure = `1.8` weight_unit = `KG`
        quantity = `13` price = '899.00' currency_code = `EUR` )
      ( name = `Copperberry` product_id = `HT-7000` category = `Accessories` main_category = `Computer Components` supplier_name = `Fasttech`
        description = `Our new multifunctional Handheld with phone function in copper`
        width = `8.1` depth = `13` height = `12.1` dim_unit = `cm` weight_measure = `0.5` weight_unit = `KG`
        quantity = `5` price = '549.00' currency_code = `EUR` )
      ( name = `Silverberry` product_id = `HT-7010` category = `Accessories` main_category = `Computer Components` supplier_name = `Fasttech`
        description = `Our new multifunctional Handheld with phone function in silver`
        width = `8.1` depth = `13` height = `12.1` dim_unit = `cm` weight_measure = `0.5` weight_unit = `KG`
        quantity = `9` price = '549.00' currency_code = `EUR` )
      ( name = `Goldberry` product_id = `HT-7020` category = `Accessories` main_category = `Computer Components` supplier_name = `Fasttech`
        description = `Our new multifunctional Handheld with phone function in gold`
        width = `8.1` depth = `13` height = `12.1` dim_unit = `cm` weight_measure = `0.5` weight_unit = `KG`
        quantity = `11` price = '549.00' currency_code = `EUR` )
      ( name = `Platinberry` product_id = `HT-7030` category = `Accessories` main_category = `Computer Components` supplier_name = `Fasttech`
        description = `Our new multifunctional Handheld with phone function in platinum`
        width = `8.1` depth = `13` height = `12.1` dim_unit = `cm` weight_measure = `0.5` weight_unit = `KG`
        quantity = `12` price = '549.00' currency_code = `EUR` )
      ( name = `ITelO FlexTop I4000` product_id = `HT-8000` category = `Laptops` main_category = `Computer Systems` supplier_name = `Titanium`
        description = `Notebook with 2,80 GHz dual core, 4 GB DDR3 SDRAM, 500 GB Hard Disc, Windows 8`
        width = `31` depth = `19` height = `3.1` dim_unit = `cm` weight_measure = `4` weight_unit = `KG`
        quantity = `11` price = '799.00' currency_code = `EUR` )
      ( name = `ITelO FlexTop I6300c` product_id = `HT-8001` category = `Laptops` main_category = `Computer Systems` supplier_name = `Titanium`
        description = `Notebook with 2,80 GHz dual core, 8 GB DDR3 SDRAM, 500 GB Hard Disc, Windows 8`
        width = `32` depth = `20` height = `3.4` dim_unit = `cm` weight_measure = `4.2` weight_unit = `KG`
        quantity = `20` price = '799.00' currency_code = `EUR` )
      ( name = `ITelO FlexTop I9100` product_id = `HT-8002` category = `Laptops` main_category = `Computer Systems` supplier_name = `Titanium`
        description = `Notebook with 2,80 GHz quad core, 4 GB DDR3 SDRAM, 1000 GB Hard Disc, Windows 8`
        width = `38` depth = `21` height = `4.1` dim_unit = `cm` weight_measure = `3.5` weight_unit = `KG`
        quantity = `20` price = '1199.00' currency_code = `EUR` )
      ( name = `ITelO FlexTop I9800` product_id = `HT-8003` category = `Laptops` main_category = `Computer Systems` supplier_name = `Titanium`
        description = `Notebook with 2,80 GHz quad core, 8 GB DDR3 SDRAM, 1000 GB Hard Disc, Windows 8`
        width = `48` depth = `31` height = `4.5` dim_unit = `cm` weight_measure = `3.8` weight_unit = `KG`
        quantity = `22` price = '1388.00' currency_code = `EUR` )
      ( name = `Smartphone Leather Case` product_id = `HT-9991` category = `Accessories` main_category = `Smartphones & Tablets` supplier_name = `Ultrasonic United`
        description = `Button Clasp, Quality Material, 100% Leather, compatible with many smartphone models`
        width = `48` depth = `31` height = `4.5` dim_unit = `cm` weight_measure = `0.02` weight_unit = `KG`
        quantity = `12` price = '25.00' currency_code = `EUR` )
      ( name = `Smartphone Alpha` product_id = `HT-9992` category = `Smartphones and Tablets` main_category = `Smartphones & Tablets` supplier_name = `Ultrasonic United`
        description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage (actual formatted capacity will be less), 4325 mAh battery (Up to 8 hours of active use), white or black`
        width = `48` depth = `31` height = `4.5` dim_unit = `cm` weight_measure = `0.75` weight_unit = `KG`
        quantity = `13` price = '599.00' currency_code = `EUR` )
      ( name = `Mini Tablet` product_id = `HT-9993` category = `Smartphones and Tablets` main_category = `Smartphones & Tablets` supplier_name = `Ultrasonic United`
        description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage, 4325 mAh battery (Up to 8 hours of active use)`
        width = `48` depth = `31` height = `4.5` dim_unit = `cm` weight_measure = `3.8` weight_unit = `KG`
        quantity = `10` price = '833.00' currency_code = `EUR` )
      ( name = `Camcorder View` product_id = `HT-9994` category = `Accessories` main_category = `TV, Video & HiFi` supplier_name = `Ultrasonic United`
        description = `1920x1080 Full HD, image stabilization reduces blur, 27x Optical / 32x Extended Zoom, wide angle Lens, 2.7" wide LCD display`
        width = `48` depth = `31` height = `27` dim_unit = `cm` weight_measure = `3.8` weight_unit = `KG`
        quantity = `50` price = '1388.00' currency_code = `EUR` )
      ( name = `Tablet Pouch` product_id = `HT-9995` category = `Accessories` main_category = `Smartphones & Tablets` supplier_name = `Titanium`
        description = `Stylish tablet pouch, protects from scratches, color: black`
        width = `25` depth = `40` height = `4.5` dim_unit = `cm` weight_measure = `0.03` weight_unit = `KG`
        quantity = `34` price = '20.00' currency_code = `EUR` )
      ( name = `Tablet Pouch` product_id = `HT-9996` category = `Accessories` main_category = `Smartphones & Tablets` supplier_name = `Titanium`
        description = `Stylish tablet pouch, protects from scratches, color: black`
        width = `25` depth = `40` height = `4.5` dim_unit = `cm` weight_measure = `0.03` weight_unit = `KG`
        quantity = `34` price = '20.00' currency_code = `EUR` )
      ( name = `e-Book Reader ReadMe` product_id = `HT-9997` category = `Smartphones and Tablets` main_category = `Smartphones & Tablets` supplier_name = `Titanium`
        description = `6-Inch E Ink Screen, Access To e-book Store, Adjustable Font Styles and Sizes, Stores Up To 1,000 Books`
        width = `48` depth = `31` height = `4.5` dim_unit = `cm` weight_measure = `3.8` weight_unit = `KG`
        quantity = `23` price = '33.00' currency_code = `EUR` )
      ( name = `Smartphone Beta` product_id = `HT-9998` category = `Smartphones and Tablets` main_category = `Smartphones & Tablets` supplier_name = `Titanium`
        description = `5 Megapixel Camera, Wi-Fi 802.11 b/g/n, Bluetooth, GPS Available-GPS support`
        width = `48` depth = `31` height = `4.5` dim_unit = `cm` weight_measure = `0.75` weight_unit = `KG`
        quantity = `21` price = '30.00' currency_code = `EUR` )
      ( name = `Maxi Tablet` product_id = `HT-9999` category = `Tablets` main_category = `Smartphones & Tablets` supplier_name = `Titanium`
        description = `10.1-inch Multitouch HD Screen (1280 x 800), 16GB Internal Memory, Wireless N Wi-Fi; Bluetooth, GPS Enabled, 1GHz Dual-Core Processor`
        width = `48` depth = `31` height = `4.5` dim_unit = `cm` weight_measure = `3.8` weight_unit = `KG`
        quantity = `20` price = '749.00' currency_code = `EUR` )
      ( name = `Flyer` product_id = `PF-1000` category = `Accessories` main_category = `Computer Systems` supplier_name = `Titanium`
        description = `Flyer for our product palette`
        width = `46` depth = `30` height = `3` dim_unit = `cm` weight_measure = `0.01` weight_unit = `KG`
        quantity = `33` price = '0.00' currency_code = `EUR` ) ).

    " weightState per the demo Formatter (parseFloat thresholds), computed in ABAP
    " (thin frontend): all product weights are < 1000, so Success throughout
    LOOP AT t_products REFERENCE INTO DATA(lr_product).
      DATA(weight_num) = CONV decfloat34( lr_product->weight_measure ).
      lr_product->weight_state = COND #( WHEN weight_num < 0    THEN `None`
                                         WHEN weight_num < 1000 THEN `Success`
                                         WHEN weight_num < 2000 THEN `Warning`
                                         ELSE `Error` ).
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
