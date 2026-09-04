" @keywords tableselectdialog table select dialog sap.m product row columnlistitem objectidentifier text objectnumber column
" @summary Similar to the Select Dialog, the Table Select Dialog presents selectable items in a table-based dialog, with filter functions. You can have single select or multi select mode.
CLASS z2ui5_cl_smpc_app_104 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    " the productInput's value, bound two-way: the value help preselects the
    " row matching WHAT IS IN THE FIELD (original _configValueHelpDialog reads
    " byId('productInput').getValue()), and the close handler writes back into it
    DATA product_value TYPE string.

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
    TYPES temp1_2011651e41 TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.
DATA t_products TYPE temp1_2011651e41.
    DATA multi_select TYPE abap_bool.
    DATA draggable TYPE abap_bool.
    DATA resizable TYPE abap_bool.
    DATA remember TYPE abap_bool.
    DATA confirm_text TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS open_dialog IMPORTING multi       TYPE abap_bool DEFAULT abap_false
                                  drag        TYPE abap_bool DEFAULT abap_false
                                  resize      TYPE abap_bool DEFAULT abap_false
                                  rem         TYPE abap_bool DEFAULT abap_false
                                  confirmtext TYPE string    DEFAULT ``
                                  responsive  TYPE abap_bool DEFAULT abap_false.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_104 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    DATA temp2 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `myDialog` INTO TABLE temp1.
    INSERT `items` INTO TABLE temp1.
    INSERT `filter` INTO TABLE temp1.
    INSERT `NAME` INTO TABLE temp1.
    INSERT `Contains` INTO TABLE temp1.
    INSERT `${$parameters>/value}` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `valueHelpDialog` INTO TABLE temp2.
    INSERT `items` INTO TABLE temp2.
    INSERT `filter` INTO TABLE temp2.
    INSERT `NAME` INTO TABLE temp2.
    INSERT `Contains` INTO TABLE temp2.
    INSERT `${$parameters>/value}` INTO TABLE temp2.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->ele( n = `dependents` ns = `mvc`
            )->ele( `TableSelectDialog`
                )->a( n = `id`         v = `myDialog`
                )->a( n = `noDataText` v = `No Products Found`
                )->a( n = `title`      v = `Select Product`
                )->a( n = `search`     v = client->follow_up_action( val   = client->cs_event-binding_call
                                                                     t_arg = temp1 )
                )->a( n = `confirm`    v = client->_event( `CONFIRM` )
                )->a( n = `cancel`     v = client->_event( `CONFIRM` )
                )->a( n = `multiSelect`        v = client->_bind( multi_select )
                )->a( n = `draggable`          v = client->_bind( draggable )
                )->a( n = `resizable`          v = client->_bind( resizable )
                )->a( n = `rememberSelections` v = client->_bind( remember )
                )->a( n = `confirmButtonText`  v = client->_bind( confirm_text )
                )->a( n = `items` v = |\{ path: '{ client->_bind_path( t_products ) }', sorter: \{ path: 'NAME', descending: false \} \}|

                )->ele( `ColumnListItem`
                    )->a( n = `vAlign` v = `Middle`
                    )->ele( `cells`
                        )->tag( `ObjectIdentifier`
                            )->a( n = `title` v = `{NAME}`
                            )->a( n = `text`  v = `{PRODUCT_ID}`
                        )->tag( `Text`
                            )->a( n = `text` v = `{SUPPLIER_NAME}`
                        )->tag( `Text`
                            )->a( n = `text` v = `{WIDTH} x {DEPTH} x {HEIGHT} {DIM_UNIT}`
                        )->tag( `ObjectNumber`
                            )->a( n = `number` v = `{WEIGHT_MEASURE}`
                            )->a( n = `unit`   v = `{WEIGHT_UNIT}`
                            )->a( n = `state`  v = `{WEIGHT_STATE}`
                        )->tag( `ObjectNumber`
                            )->a( n = `number` v = |\{ parts:[\{path:'PRICE'\},\{path:'CURRENCY_CODE'\}], type: 'sap.ui.model.type.Currency', formatOptions: \{showMeasure: false\} \}|
                            )->a( n = `unit`   v = `{CURRENCY_CODE}`

                    )->end(
                )->end(
                )->ele( `columns`
                    )->ele( `Column`
                        )->a( n = `width` v = `12em`
                        )->ele( `header`
                            )->tag( `Text`
                                )->a( n = `text` v = `Product`

                        )->end(
                    )->end(
                    )->ele( `Column`
                        )->a( n = `minScreenWidth` v = `Tablet`
                        )->a( n = `demandPopin`    v = `true`
                        )->ele( `header`
                            )->tag( `Text`
                                )->a( n = `text` v = `Supplier`

                        )->end(
                    )->end(
                    )->ele( `Column`
                        )->a( n = `minScreenWidth` v = `Desktop`
                        )->a( n = `demandPopin`    v = `true`
                        )->a( n = `hAlign`         v = `End`
                        )->ele( `header`
                            )->tag( `Text`
                                )->a( n = `text` v = `Dimensions`

                        )->end(
                    )->end(
                    )->ele( `Column`
                        )->a( n = `minScreenWidth` v = `Desktop`
                        )->a( n = `demandPopin`    v = `true`
                        )->a( n = `hAlign`         v = `Center`
                        )->ele( `header`
                            )->tag( `Text`
                                )->a( n = `text` v = `Weight`

                        )->end(
                    )->end(
                    )->ele( `Column`
                        )->a( n = `hAlign` v = `End`
                        )->ele( `header`
                            )->tag( `Text`
                                )->a( n = `text` v = `Product`

                        )->end(
                    )->end(
                )->end(
            )->end(

            )->ele( `TableSelectDialog`
                )->a( n = `noDataText`        v = `No Products Found`
                )->a( n = `title`             v = `Select Product`
                )->a( n = `search`            v = client->follow_up_action( val   = client->cs_event-binding_call
                                                                            t_arg = temp2 )
                )->a( n = `searchPlaceholder` v = `Search Products`
                )->a( n = `confirm`           v = client->_event( val = `VH_CLOSE` arg = `${$parameters>/selectedItem} ? ${$parameters>/selectedItem}.getCells()[0].getTitle() : ''` )
                )->a( n = `cancel`            v = client->_event( `VH_CLOSE` )
                )->a( n = `showClearButton`   v = `true`
                )->a( n = `id`                v = `valueHelpDialog`
                )->a( n = `items` v = |\{ path: '{ client->_bind_path( t_products ) }', sorter: \{ path: 'NAME', descending: false \} \}|

                )->ele( `ColumnListItem`
                    )->a( n = `selected` v = `{SELECTED}`
                    )->ele( `cells`
                        )->tag( `ObjectIdentifier`
                            )->a( n = `title` v = `{NAME}`
                            )->a( n = `text`  v = `{PRODUCT_ID}`
                        )->tag( `Text`
                            )->a( n = `text` v = `{SUPPLIER_NAME}`
                        )->tag( `Text`
                            )->a( n = `text` v = `{WIDTH} x {DEPTH} x {HEIGHT} {DIM_UNIT}`
                        )->tag( `ObjectNumber`
                            )->a( n = `number` v = `{WEIGHT_MEASURE}`
                            )->a( n = `unit`   v = `{WEIGHT_UNIT}`
                            )->a( n = `state`  v = `{WEIGHT_STATE}`
                        )->tag( `ObjectNumber`
                            )->a( n = `number` v = |\{ parts:[\{path:'PRICE'\},\{path:'CURRENCY_CODE'\}], type: 'sap.ui.model.type.Currency', formatOptions: \{showMeasure: false\} \}|
                            )->a( n = `unit`   v = `{CURRENCY_CODE}`

                    )->end(
                )->end(
                )->ele( `columns`
                    )->ele( `Column`
                        )->a( n = `width` v = `12em`
                        )->ele( `header`
                            )->tag( `Text`
                                )->a( n = `text` v = `Product`

                        )->end(
                    )->end(
                    )->ele( `Column`
                        )->a( n = `minScreenWidth` v = `Tablet`
                        )->a( n = `demandPopin`    v = `true`
                        )->ele( `header`
                            )->tag( `Text`
                                )->a( n = `text` v = `Supplier`

                        )->end(
                    )->end(
                    )->ele( `Column`
                        )->a( n = `minScreenWidth` v = `Desktop`
                        )->a( n = `demandPopin`    v = `true`
                        )->a( n = `hAlign`         v = `End`
                        )->ele( `header`
                            )->tag( `Text`
                                )->a( n = `text` v = `Dimensions`

                        )->end(
                    )->end(
                    )->ele( `Column`
                        )->a( n = `minScreenWidth` v = `Desktop`
                        )->a( n = `demandPopin`    v = `true`
                        )->a( n = `hAlign`         v = `Center`
                        )->ele( `header`
                            )->tag( `Text`
                                )->a( n = `text` v = `Weight`

                        )->end(
                    )->end(
                    )->ele( `Column`
                        )->a( n = `hAlign` v = `End`
                        )->ele( `header`
                            )->tag( `Text`
                                )->a( n = `text` v = `Product`

                        )->end(
                    )->end(
                )->end(
            )->end(
        )->end(

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->tag( `Input`
                )->a( n = `id`            v = `productInput`
                )->a( n = `type`          v = `Text`
                )->a( n = `value`         v = client->_bind( product_value )
                )->a( n = `placeholder`   v = `Enter Product ...`
                )->a( n = `showValueHelp` v = `true`
                )->a( n = `valueHelpRequest` v = client->_event( `VALUE_HELP` )
                )->a( n = `width`         v = `15rem`
                )->a( n = `class`         v = `sapUiSmallMarginBottom`

            )->ele( `Button`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
                )->a( n = `text`  v = `Show Table Select Dialog`
                )->a( n = `press` v = client->_event( `OPEN_1` )

            )->end(
            )->ele( `Button`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
                )->a( n = `text`  v = `Show Table Select Dialog (Multi)`
                )->a( n = `press` v = client->_event( `OPEN_2` )
                )->ele( `customData`
                    )->tag( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `multi`
                        )->a( n = `value` v = `true`

                )->end(
            )->end(
            )->ele( `Button`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
                )->a( n = `text`  v = `Show Table Select Dialog (draggable=true)`
                )->a( n = `press` v = client->_event( `OPEN_3` )
                )->ele( `customData`
                    )->tag( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `multi`
                        )->a( n = `value` v = `true`
                    )->tag( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `draggable`
                        )->a( n = `value` v = `true`

                )->end(
            )->end(
            )->ele( `Button`
                )->a( n = `text`  v = `Show Table Select Dialog (resizable=true)`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
                )->a( n = `press` v = client->_event( `OPEN_4` )
                )->ele( `customData`
                    )->tag( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `multi`
                        )->a( n = `value` v = `true`
                    )->tag( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `resizable`
                        )->a( n = `value` v = `true`

                )->end(
            )->end(
            )->ele( `Button`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
                )->a( n = `text`  v = `Show Table Select Dialog (Remember)`
                )->a( n = `press` v = client->_event( `OPEN_5` )
                )->ele( `customData`
                    )->tag( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `multi`
                        )->a( n = `value` v = `true`
                    )->tag( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `remember`
                        )->a( n = `value` v = `true`

                )->end(
            )->end(
            )->ele( `Button`
                )->a( n = `text`  v = `Show Table Select Dialog (Custom confirmation button text)`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
                )->a( n = `press` v = client->_event( `OPEN_6` )
                )->ele( `customData`
                    )->tag( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `multi`
                        )->a( n = `value` v = `true`
                    )->tag( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `confirmButtonText`
                        )->a( n = `value` v = `Save`

                )->end(
            )->end(
            )->ele( `Button`
                )->a( n = `text`  v = `Show Table Select Dialog with Responsive Padding`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
                )->a( n = `press` v = client->_event( `OPEN_7` )
                )->ele( `customData`
                    )->tag( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `resizable`
                        )->a( n = `value` v = `true`
                    )->tag( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `draggable`
                        )->a( n = `value` v = `true`
                    )->tag( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `responsivePadding`
                        )->a( n = `value` v = `true`

                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA temp3 LIKE LINE OF t_products.
        DATA lr LIKE REF TO temp3.
          DATA temp1 TYPE xsdboolean.
        DATA temp4 TYPE string_table.
        DATA temp6 TYPE string_table.

    CASE client->get_event( ).

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
        
        
        LOOP AT t_products REFERENCE INTO lr.
          
          temp1 = boolc( lr->name = product_value ).
          lr->selected = temp1.
        ENDLOOP.
        
        CLEAR temp4.
        INSERT `valueHelpDialog` INTO TABLE temp4.
        INSERT `open` INTO TABLE temp4.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = temp4 ).

      WHEN `CONFIRM`.
        " handleClose resets the search filter FIRST, on confirm and on cancel
        " alike, so a reopen starts from the full list instead of the filtered
        " one (open( ) clears the search FIELD but never the binding filter)
        
        CLEAR temp6.
        INSERT `myDialog` INTO TABLE temp6.
        INSERT `items` INTO TABLE temp6.
        INSERT `filter` INTO TABLE temp6.
        client->follow_up_action( val   = client->cs_event-binding_call
                                  t_arg = temp6 ).
        client->message_toast_display( `Selection confirmed` ).

      WHEN `VH_CLOSE`.
        " handleValueHelpClose: the picked row's first cell title lands in the
        " input, and a close with no selection resets it (resetProperty)
        product_value = client->get_event_arg( ).

    ENDCASE.

  ENDMETHOD.


  METHOD open_dialog.
      DATA temp8 TYPE string_table.
      DATA temp10 TYPE string_table.
    DATA temp12 TYPE string_table.

    multi_select = multi.
    draggable    = drag.
    resizable    = resize.
    remember     = rem.
    confirm_text = confirmtext.

    IF responsive = abap_true.
      
      CLEAR temp8.
      INSERT `myDialog` INTO TABLE temp8.
      INSERT `addStyleClass` INTO TABLE temp8.
      INSERT `sapUiResponsivePadding--header sapUiResponsivePadding--subHeader sapUiResponsivePadding--content sapUiResponsivePadding--footer` INTO TABLE temp8.
      client->follow_up_action( val   = client->cs_event-control_by_id
                                t_arg = temp8 ).
    ELSE.
      
      CLEAR temp10.
      INSERT `myDialog` INTO TABLE temp10.
      INSERT `removeStyleClass` INTO TABLE temp10.
      INSERT `sapUiResponsivePadding--header sapUiResponsivePadding--subHeader sapUiResponsivePadding--content sapUiResponsivePadding--footer` INTO TABLE temp10.
      client->follow_up_action( val   = client->cs_event-control_by_id
                                t_arg = temp10 ).
    ENDIF.

    
    CLEAR temp12.
    INSERT `myDialog` INTO TABLE temp12.
    INSERT `open` INTO TABLE temp12.
    client->follow_up_action( val   = client->cs_event-control_by_id
                              t_arg = temp12 ).

  ENDMETHOD.


  METHOD model_init.
    DATA temp14 LIKE t_products.
    DATA temp15 LIKE LINE OF temp14.
    DATA temp16 LIKE LINE OF t_products.
    DATA lr_product LIKE REF TO temp16.
      DATA temp17 TYPE decfloat34.
      DATA weight_num LIKE temp17.
      DATA temp18 TYPE z2ui5_cl_smpc_app_104=>ty_s_product-weight_state.

    " the original's view seeds the input with this product
    product_value = `Astro Phone 6`.

    
    CLEAR temp14.
    
    temp15-name = `Notebook Basic 15`.
    temp15-product_id = `HT-1000`.
    temp15-category = `Laptops`.
    temp15-main_category = `Computer Systems`.
    temp15-supplier_name = `Very Best Screens`.
    temp15-description = `Notebook Basic 15 with 2,80 GHz quad core, 15" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`.
    temp15-width = `30`.
    temp15-depth = `18`.
    temp15-height = `3`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `4.2`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `10`.
    temp15-price = '956.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Notebook Basic 17`.
    temp15-product_id = `HT-1001`.
    temp15-category = `Laptops`.
    temp15-main_category = `Computer Systems`.
    temp15-supplier_name = `Very Best Screens`.
    temp15-description = `Notebook Basic 17 with 2,80 GHz quad core, 17" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`.
    temp15-width = `29`.
    temp15-depth = `17`.
    temp15-height = `3.1`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `4.5`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `20`.
    temp15-price = '1249.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Notebook Basic 18`.
    temp15-product_id = `HT-1002`.
    temp15-category = `Laptops`.
    temp15-main_category = `Computer Systems`.
    temp15-supplier_name = `Very Best Screens`.
    temp15-description = `Notebook Basic 18 with 2,80 GHz quad core, 18" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro`.
    temp15-width = `28`.
    temp15-depth = `19`.
    temp15-height = `2.5`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `4.2`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `10`.
    temp15-price = '1570.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Notebook Basic 19`.
    temp15-product_id = `HT-1003`.
    temp15-category = `Laptops`.
    temp15-main_category = `Computer Systems`.
    temp15-supplier_name = `Smartcards`.
    temp15-description = `Notebook Basic 19 with 2,80 GHz quad core, 19" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro`.
    temp15-width = `32`.
    temp15-depth = `21`.
    temp15-height = `4`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `4.2`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `15`.
    temp15-price = '1650.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `ITelO Vault`.
    temp15-product_id = `HT-1007`.
    temp15-category = `Accessories`.
    temp15-main_category = `Computer Components`.
    temp15-supplier_name = `Technocom`.
    temp15-description = `Digital Organizer with State-of-the-Art Storage Encryption`.
    temp15-width = `32`.
    temp15-depth = `22`.
    temp15-height = `3`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.2`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `15`.
    temp15-price = '299.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Notebook Professional 15`.
    temp15-product_id = `HT-1010`.
    temp15-category = `Accessories`.
    temp15-main_category = `Computer Systems`.
    temp15-supplier_name = `Very Best Screens`.
    temp15-description = `Notebook Professional 15 with 2,80 GHz quad core, 15" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro`.
    temp15-width = `33`.
    temp15-depth = `20`.
    temp15-height = `3`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `4.3`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `16`.
    temp15-price = '1999.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Notebook Professional 17`.
    temp15-product_id = `HT-1011`.
    temp15-category = `Laptops`.
    temp15-main_category = `Computer Systems`.
    temp15-supplier_name = `Very Best Screens`.
    temp15-description = `Notebook Professional 17 with 2,80 GHz quad core, 17" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro`.
    temp15-width = `33`.
    temp15-depth = `23`.
    temp15-height = `2`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `4.1`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `17`.
    temp15-price = '2299.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `ITelO Vault Net`.
    temp15-product_id = `HT-1020`.
    temp15-category = `Accessories`.
    temp15-main_category = `Computer Components`.
    temp15-supplier_name = `Technocom`.
    temp15-description = `Digital Organizer with State-of-the-Art Encryption for Storage and Network Communications`.
    temp15-width = `10`.
    temp15-depth = `1.8`.
    temp15-height = `17`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.16`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `14`.
    temp15-price = '459.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `ITelO Vault SAT`.
    temp15-product_id = `HT-1021`.
    temp15-category = `Accessories`.
    temp15-main_category = `Computer Components`.
    temp15-supplier_name = `Technocom`.
    temp15-description = `Digital Organizer with State-of-the-Art Encryption for Storage and Secure Stellite Link`.
    temp15-width = `11`.
    temp15-depth = `1.7`.
    temp15-height = `18`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.18`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `50`.
    temp15-price = '149.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Comfort Easy`.
    temp15-product_id = `HT-1022`.
    temp15-category = `Accessories`.
    temp15-main_category = `Computer Components`.
    temp15-supplier_name = `Technocom`.
    temp15-description = `32 GB Digital Assistant with high-resolution color screen`.
    temp15-width = `84`.
    temp15-depth = `1.5`.
    temp15-height = `14`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.2`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `30`.
    temp15-price = '1679.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Comfort Senior`.
    temp15-product_id = `HT-1023`.
    temp15-category = `Accessories`.
    temp15-main_category = `Computer Components`.
    temp15-supplier_name = `Technocom`.
    temp15-description = `64 GB Digital Assistant with high-resolution color screen and synthesized voice output`.
    temp15-width = `80`.
    temp15-depth = `1.6`.
    temp15-height = `13`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.8`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `24`.
    temp15-price = '512.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Ergo Screen E-I`.
    temp15-product_id = `HT-1030`.
    temp15-category = `Flat Screen Monitors`.
    temp15-main_category = `Computer Components`.
    temp15-supplier_name = `Very Best Screens`.
    temp15-description = `Optimum Hi-Resolution max. 1920 x 1080 @ 85Hz, Dot Pitch: 0.27mm`.
    temp15-width = `37`.
    temp15-depth = `12`.
    temp15-height = `36`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `21`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `14`.
    temp15-price = '230.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Ergo Screen E-II`.
    temp15-product_id = `HT-1031`.
    temp15-category = `Flat Screen Monitors`.
    temp15-main_category = `Computer Components`.
    temp15-supplier_name = `Very Best Screens`.
    temp15-description = `Optimum Hi-Resolution max. 1920 x 1200 @ 85Hz, Dot Pitch: 0.26mm`.
    temp15-width = `40.8`.
    temp15-depth = `19`.
    temp15-height = `43`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `21`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `24`.
    temp15-price = '285.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Ergo Screen E-III`.
    temp15-product_id = `HT-1032`.
    temp15-category = `Flat Screen Monitors`.
    temp15-main_category = `Computer Components`.
    temp15-supplier_name = `Very Best Screens`.
    temp15-description = `Optimum Hi-Resolution max. 2560 x 1440 @ 85Hz, Dot Pitch: 0.25mm`.
    temp15-width = `40.8`.
    temp15-depth = `19`.
    temp15-height = `43`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `21`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `50`.
    temp15-price = '345.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Flat Basic`.
    temp15-product_id = `HT-1035`.
    temp15-category = `Flat Screen Monitors`.
    temp15-main_category = `Computer Components`.
    temp15-supplier_name = `Very Best Screens`.
    temp15-description = `Optimum Hi-Resolution max. 1600 x 1200 @ 85Hz, Dot Pitch: 0.24mm`.
    temp15-width = `39`.
    temp15-depth = `20`.
    temp15-height = `41`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `14`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `23`.
    temp15-price = '399.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Flat Future`.
    temp15-product_id = `HT-1036`.
    temp15-category = `Flat Screen Monitors`.
    temp15-main_category = `Computer Components`.
    temp15-supplier_name = `Very Best Screens`.
    temp15-description = `Optimum Hi-Resolution max. 2048 x 1080 @ 85Hz, Dot Pitch: 0.26mm`.
    temp15-width = `45`.
    temp15-depth = `26`.
    temp15-height = `46`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `15`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `22`.
    temp15-price = '430.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Flat XL`.
    temp15-product_id = `HT-1037`.
    temp15-category = `Flat Screen Monitors`.
    temp15-main_category = `Computer Components`.
    temp15-supplier_name = `Very Best Screens`.
    temp15-description = `Optimum Hi-Resolution max. 2016 x 1512 @ 85Hz, Dot Pitch: 0.24mm`.
    temp15-width = `54.5`.
    temp15-depth = `22.1`.
    temp15-height = `39.1`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `17`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `23`.
    temp15-price = '1230.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Laser Professional Eco`.
    temp15-product_id = `HT-1040`.
    temp15-category = `Printers`.
    temp15-main_category = `Printers & Scanners`.
    temp15-supplier_name = `Alpha Printers`.
    temp15-description = `Print 2400 dpi image quality color documents at speeds of up to 32 ppm (color) or 36 ppm (monochrome), letter/A4. Powerful 500 MHz processor, 512MB of memory`.
    temp15-width = `51`.
    temp15-depth = `46`.
    temp15-height = `30`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `32`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `21`.
    temp15-price = '830.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Laser Basic`.
    temp15-product_id = `HT-1041`.
    temp15-category = `Printers`.
    temp15-main_category = `Printers & Scanners`.
    temp15-supplier_name = `Alpha Printers`.
    temp15-description = `Up to 22 ppm color or 24 ppm monochrome A4/letter, powerful 500 MHz processor and 128MB of memory`.
    temp15-width = `48`.
    temp15-depth = `42`.
    temp15-height = `26`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `23`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `8`.
    temp15-price = '490.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Laser Allround`.
    temp15-product_id = `HT-1042`.
    temp15-category = `Printers`.
    temp15-main_category = `Printers & Scanners`.
    temp15-supplier_name = `Alpha Printers`.
    temp15-description = `Print up to 25 ppm letter and 24 ppm A4 color or monochrome, with Available first-page-out-time of less than 13 seconds for monochrome and less than 15 seconds for color`.
    temp15-width = `53`.
    temp15-depth = `50`.
    temp15-height = `65`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `17`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `9`.
    temp15-price = '349.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Ultra Jet Super Color`.
    temp15-product_id = `HT-1050`.
    temp15-category = `Printers`.
    temp15-main_category = `Printers & Scanners`.
    temp15-supplier_name = `Alpha Printers`.
    temp15-description = `4800 dpi x 1200 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB, Ethernet`.
    temp15-width = `41`.
    temp15-depth = `41`.
    temp15-height = `28`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `3`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `17`.
    temp15-price = '139.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Ultra Jet Mobile`.
    temp15-product_id = `HT-1051`.
    temp15-category = `Printers`.
    temp15-main_category = `Printers & Scanners`.
    temp15-supplier_name = `Printer for All`.
    temp15-description = `1000 dpi x 1000 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB - excellent dimensions for the small office`.
    temp15-width = `46`.
    temp15-depth = `32`.
    temp15-height = `25`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `1.9`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `18`.
    temp15-price = '99.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Ultra Jet Super Highspeed`.
    temp15-product_id = `HT-1052`.
    temp15-category = `Printers`.
    temp15-main_category = `Printers & Scanners`.
    temp15-supplier_name = `Printer for All`.
    temp15-description = `4800 dpi x 1200 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB2.0, Ethernet`.
    temp15-width = `41`.
    temp15-depth = `41`.
    temp15-height = `28`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `18`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `25`.
    temp15-price = '170.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Multi Print`.
    temp15-product_id = `HT-1055`.
    temp15-category = `Multifunction Printers`.
    temp15-main_category = `Printers & Scanners`.
    temp15-supplier_name = `Printer for All`.
    temp15-description = `1000 dpi x 1000 dpi - up to 16 ppm (mono) / up to 15 ppm (color)- capacity 80 sheets - scanner (216 x 297 mm, 1200dpi x 2400dpi)`.
    temp15-width = `55`.
    temp15-depth = `45`.
    temp15-height = `29`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `6.3`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `16`.
    temp15-price = '99.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Multi Color`.
    temp15-product_id = `HT-1056`.
    temp15-category = `Multifunction Printers`.
    temp15-main_category = `Printers & Scanners`.
    temp15-supplier_name = `Printer for All`.
    temp15-description = `1200 dpi x 1200 dpi - up to 25 ppm (mono) / up to 24 ppm (color)- capacity 80 sheets - scanner (216 x 297 mm, 2400dpi x 4800dpi, high resolution)`.
    temp15-width = `51`.
    temp15-depth = `41.3`.
    temp15-height = `22`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `4.3`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `5`.
    temp15-price = '119.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Cordless Mouse`.
    temp15-product_id = `HT-1060`.
    temp15-category = `Mice`.
    temp15-main_category = `Computer Components`.
    temp15-supplier_name = `Oxynum`.
    temp15-description = `Cordless Optical USB Mice, Laptop, Color: Black, Plug&Play`.
    temp15-width = `6`.
    temp15-depth = `14.5`.
    temp15-height = `3.5`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.09`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `25`.
    temp15-price = '9.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Speed Mouse`.
    temp15-product_id = `HT-1061`.
    temp15-category = `Mice`.
    temp15-main_category = `Computer Components`.
    temp15-supplier_name = `Oxynum`.
    temp15-description = `Optical USB, PS/2 Mouse, Color: Blue, 3-button-functionality (incl. Scroll wheel)`.
    temp15-width = `7`.
    temp15-depth = `15`.
    temp15-height = `3.1`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.09`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `12`.
    temp15-price = '7.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Track Mouse`.
    temp15-product_id = `HT-1062`.
    temp15-category = `Mice`.
    temp15-main_category = `Computer Components`.
    temp15-supplier_name = `Oxynum`.
    temp15-description = `Optical USB Mouse, Color: Red, 5-button-functionality(incl. Scroll wheel), Plug&Play`.
    temp15-width = `3`.
    temp15-depth = `7`.
    temp15-height = `4`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.03`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `12`.
    temp15-price = '11.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Ergonomic Keyboard`.
    temp15-product_id = `HT-1063`.
    temp15-category = `Keyboards`.
    temp15-main_category = `Computer Components`.
    temp15-supplier_name = `Oxynum`.
    temp15-description = `Ergonomic USB Keyboard for Desktop, Plug&Play`.
    temp15-width = `50`.
    temp15-depth = `21`.
    temp15-height = `3.5`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `2.1`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `50`.
    temp15-price = '14.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Internet Keyboard`.
    temp15-product_id = `HT-1064`.
    temp15-category = `Keyboards`.
    temp15-main_category = `Computer Components`.
    temp15-supplier_name = `Oxynum`.
    temp15-description = `Corded Keyboard with special keys for Internet Usability, USB`.
    temp15-width = `52`.
    temp15-depth = `25`.
    temp15-height = `3`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `1.8`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `35`.
    temp15-price = '16.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Media Keyboard`.
    temp15-product_id = `HT-1065`.
    temp15-category = `Keyboards`.
    temp15-main_category = `Computer Components`.
    temp15-supplier_name = `Oxynum`.
    temp15-description = `Corded Ergonomic Keyboard with special keys for Media Usability, USB`.
    temp15-width = `51.4`.
    temp15-depth = `23`.
    temp15-height = `4`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `2.3`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `26`.
    temp15-price = '26.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Mousepad`.
    temp15-product_id = `HT-1066`.
    temp15-category = `Mousepads`.
    temp15-main_category = `Computer Components`.
    temp15-supplier_name = `Oxynum`.
    temp15-description = `Nice mouse pad with ITelO Logo`.
    temp15-width = `15`.
    temp15-depth = `6`.
    temp15-height = `0.2`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `80`.
    temp15-weight_unit = `G`.
    temp15-quantity = `12`.
    temp15-price = '6.99'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Ergo Mousepad`.
    temp15-product_id = `HT-1067`.
    temp15-category = `Mousepads`.
    temp15-main_category = `Computer Components`.
    temp15-supplier_name = `Oxynum`.
    temp15-description = `Ergonomic mouse pad with ITelO Logo`.
    temp15-width = `15`.
    temp15-depth = `6`.
    temp15-height = `0.2`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `80`.
    temp15-weight_unit = `G`.
    temp15-quantity = `16`.
    temp15-price = '8.99'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Designer Mousepad`.
    temp15-product_id = `HT-1068`.
    temp15-category = `Mousepads`.
    temp15-main_category = `Computer Components`.
    temp15-supplier_name = `Fasttech`.
    temp15-description = `ITelO Mousepad Special Edition`.
    temp15-width = `24`.
    temp15-depth = `24`.
    temp15-height = `0.6`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `90`.
    temp15-weight_unit = `G`.
    temp15-quantity = `26`.
    temp15-price = '12.99'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Universal card reader`.
    temp15-product_id = `HT-1069`.
    temp15-category = `Computer System Accessories`.
    temp15-main_category = `Computer Systems`.
    temp15-supplier_name = `Fasttech`.
    temp15-description = `Universal card reader`.
    temp15-width = `6`.
    temp15-depth = `6`.
    temp15-height = `3`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `45`.
    temp15-weight_unit = `G`.
    temp15-quantity = `22`.
    temp15-price = '14.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Proctra X`.
    temp15-product_id = `HT-1070`.
    temp15-category = `Graphic Cards`.
    temp15-main_category = `Computer Components`.
    temp15-supplier_name = `Ultrasonic United`.
    temp15-description = `Proctra X: PCI-E GDDR5 3072MB`.
    temp15-width = `22`.
    temp15-depth = `35`.
    temp15-height = `17`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.255`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `15`.
    temp15-price = '70.90'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Gladiator MX`.
    temp15-product_id = `HT-1071`.
    temp15-category = `Graphic Cards`.
    temp15-main_category = `Computer Components`.
    temp15-supplier_name = `Ultrasonic United`.
    temp15-description = `Gladiator XLN: PCI-E GDDR5 3072MB DVI Out, TV Out low-noise`.
    temp15-width = `22`.
    temp15-depth = `35`.
    temp15-height = `17`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.3`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `16`.
    temp15-price = '81.70'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Hurricane GX`.
    temp15-product_id = `HT-1072`.
    temp15-category = `Graphic Cards`.
    temp15-main_category = `Computer Components`.
    temp15-supplier_name = `Ultrasonic United`.
    temp15-description = `Hurricane GX: PCI-E 691 GFLOPS game-optimized`.
    temp15-width = `22`.
    temp15-depth = `35`.
    temp15-height = `17`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.4`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `13`.
    temp15-price = '101.20'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Hurricane GX/LN`.
    temp15-product_id = `HT-1073`.
    temp15-category = `Graphic Cards`.
    temp15-main_category = `Computer Components`.
    temp15-supplier_name = `Smartcards`.
    temp15-description = `Hurricane GX/LN: PCI-E 691 GFLOPS game-optimized, low-noise.`.
    temp15-width = `22`.
    temp15-depth = `35`.
    temp15-height = `17`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.4`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `5`.
    temp15-price = '139.99'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Photo Scan`.
    temp15-product_id = `HT-1080`.
    temp15-category = `Scanners`.
    temp15-main_category = `Printers & Scanners`.
    temp15-supplier_name = `Printer for All`.
    temp15-description = `Flatbed scanner - 9.600 × 9.600 dpi - 216 x 297 mm - Hi-Speed USB - Bluetooth`.
    temp15-width = `34`.
    temp15-depth = `48`.
    temp15-height = `5`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `2.3`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `8`.
    temp15-price = '129.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Power Scan`.
    temp15-product_id = `HT-1081`.
    temp15-category = `Scanners`.
    temp15-main_category = `Printers & Scanners`.
    temp15-supplier_name = `Printer for All`.
    temp15-description = `Flatbed scanner - 9.600 × 9.600 dpi - 216 x 297 mm - SCSI for backward compatibility`.
    temp15-width = `31`.
    temp15-depth = `43`.
    temp15-height = `7`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `2.4`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `11`.
    temp15-price = '89.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Jet Scan Professional`.
    temp15-product_id = `HT-1082`.
    temp15-category = `Scanners`.
    temp15-main_category = `Printers & Scanners`.
    temp15-supplier_name = `Printer for All`.
    temp15-description = `Flatbed scanner - Letter - 2400 dpi x 2400 dpi - 216 x 297 mm - add-on module`.
    temp15-width = `33`.
    temp15-depth = `41`.
    temp15-height = `12`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `3.2`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `13`.
    temp15-price = '169.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Jet Scan Professional`.
    temp15-product_id = `HT-1083`.
    temp15-category = `Scanners`.
    temp15-main_category = `Printers & Scanners`.
    temp15-supplier_name = `Printer for All`.
    temp15-description = `Flatbed scanner - A4 - 2400 dpi x 2400 dpi - 216 x 297 mm - add-on module`.
    temp15-width = `35`.
    temp15-depth = `40`.
    temp15-height = `10`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `3.2`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `10`.
    temp15-price = '189.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Copymaster`.
    temp15-product_id = `HT-1085`.
    temp15-category = `Multifunction Printers`.
    temp15-main_category = `Printers & Scanners`.
    temp15-supplier_name = `Alpha Printers`.
    temp15-description = `Copymaster`.
    temp15-width = `45`.
    temp15-depth = `42`.
    temp15-height = `22`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `23.2`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `10`.
    temp15-price = '1499.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Surround Sound`.
    temp15-product_id = `HT-1090`.
    temp15-category = `Speakers`.
    temp15-main_category = `Computer Components`.
    temp15-supplier_name = `Speaker Experts`.
    temp15-description = `PC multimedia speakers - 5 Watt (Total)`.
    temp15-width = `12`.
    temp15-depth = `10`.
    temp15-height = `16`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `3`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `20`.
    temp15-price = '39.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Blaster Extreme`.
    temp15-product_id = `HT-1091`.
    temp15-category = `Speakers`.
    temp15-main_category = `Computer Components`.
    temp15-supplier_name = `Speaker Experts`.
    temp15-description = `PC multimedia speakers - 10 Watt (Total) - 2-way`.
    temp15-width = `13`.
    temp15-depth = `11`.
    temp15-height = `17.5`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `1.4`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `15`.
    temp15-price = '26.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Sound Booster`.
    temp15-product_id = `HT-1092`.
    temp15-category = `Speakers`.
    temp15-main_category = `Computer Components`.
    temp15-supplier_name = `Speaker Experts`.
    temp15-description = `PC multimedia speakers - optimized for Blutooth/A2DP`.
    temp15-width = `12.4`.
    temp15-depth = `10.4`.
    temp15-height = `18.1`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `2.1`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `50`.
    temp15-price = '45.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Lovely Sound 5.1 Wireless`.
    temp15-product_id = `HT-1095`.
    temp15-category = `Accessories`.
    temp15-main_category = `Computer Components`.
    temp15-supplier_name = `Fasttech`.
    temp15-description = `5.1 Headset, 40 Hz-20 kHz, Wireless`.
    temp15-width = `24`.
    temp15-depth = `19`.
    temp15-height = `23`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `80`.
    temp15-weight_unit = `G`.
    temp15-quantity = `12`.
    temp15-price = '49.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Lovely Sound 5.1`.
    temp15-product_id = `HT-1096`.
    temp15-category = `Accessories`.
    temp15-main_category = `Computer Components`.
    temp15-supplier_name = `Fasttech`.
    temp15-description = `5.1 Headset, 40 Hz-20 kHz, 3m cable`.
    temp15-width = `25`.
    temp15-depth = `17`.
    temp15-height = `19`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `130`.
    temp15-weight_unit = `G`.
    temp15-quantity = `18`.
    temp15-price = '39.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Lovely Sound Stereo`.
    temp15-product_id = `HT-1097`.
    temp15-category = `Accessories`.
    temp15-main_category = `Computer Components`.
    temp15-supplier_name = `Fasttech`.
    temp15-description = `5.1 Headset, 40 Hz-20 kHz, 1m cable`.
    temp15-width = `21.3`.
    temp15-depth = `2.4`.
    temp15-height = `19.7`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `60`.
    temp15-weight_unit = `G`.
    temp15-quantity = `21`.
    temp15-price = '29.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Smart Office`.
    temp15-product_id = `HT-1100`.
    temp15-category = `Software`.
    temp15-main_category = `Software`.
    temp15-supplier_name = `Technocom`.
    temp15-description = `Complete package, 1 User, Office Applications (word processing, spreadsheet, presentations)`.
    temp15-width = `15`.
    temp15-depth = `6.5`.
    temp15-height = `2.1`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `1.2`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `25`.
    temp15-price = '89.90'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Smart Design`.
    temp15-product_id = `HT-1101`.
    temp15-category = `Software`.
    temp15-main_category = `Software`.
    temp15-supplier_name = `Technocom`.
    temp15-description = `Complete package, 1 User, Image editing, processing`.
    temp15-width = `14`.
    temp15-depth = `6.7`.
    temp15-height = `24`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.8`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `26`.
    temp15-price = '79.90'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Smart Network`.
    temp15-product_id = `HT-1102`.
    temp15-category = `Software`.
    temp15-main_category = `Software`.
    temp15-supplier_name = `Technocom`.
    temp15-description = `Complete package, 1 User, Network Software Utilities, Useful Applications and Documentation`.
    temp15-width = `16`.
    temp15-depth = `6`.
    temp15-height = `27`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.8`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `28`.
    temp15-price = '69.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Smart Multimedia`.
    temp15-product_id = `HT-1103`.
    temp15-category = `Software`.
    temp15-main_category = `Software`.
    temp15-supplier_name = `Technocom`.
    temp15-description = `Complete package, 1 User, different Multimedia applications, playing music, watching DVDs, only with this Smart package`.
    temp15-width = `11`.
    temp15-depth = `3.4`.
    temp15-height = `22`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.8`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `9`.
    temp15-price = '77.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Smart Games`.
    temp15-product_id = `HT-1104`.
    temp15-category = `Software`.
    temp15-main_category = `Software`.
    temp15-supplier_name = `Technocom`.
    temp15-description = `Complete package, 1 User, various games for amusement, logic, action, jump&run`.
    temp15-width = `10`.
    temp15-depth = `3`.
    temp15-height = `30`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `1.1`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `13`.
    temp15-price = '55.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Smart Internet Antivirus`.
    temp15-product_id = `HT-1105`.
    temp15-category = `Software`.
    temp15-main_category = `Software`.
    temp15-supplier_name = `Brainsoft`.
    temp15-description = `Complete package, 1 User, highly recommended for internet users as anti-virus protection`.
    temp15-width = `16`.
    temp15-depth = `4`.
    temp15-height = `21`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.7`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `17`.
    temp15-price = '29.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Smart Firewall`.
    temp15-product_id = `HT-1106`.
    temp15-category = `Software`.
    temp15-main_category = `Software`.
    temp15-supplier_name = `Brainsoft`.
    temp15-description = `Complete package, 1 User, recommended for internet users, protect your PC against cyber-crime`.
    temp15-width = `17.9`.
    temp15-depth = `4.2`.
    temp15-height = `23.1`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.9`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `19`.
    temp15-price = '34.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Smart Money`.
    temp15-product_id = `HT-1107`.
    temp15-category = `Software`.
    temp15-main_category = `Software`.
    temp15-supplier_name = `Brainsoft`.
    temp15-description = `Complete package, 1 User, bring your money in your mind, see what you have and what you want`.
    temp15-width = `12`.
    temp15-depth = `1.5`.
    temp15-height = `19`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.5`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `18`.
    temp15-price = '29.90'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `PC Lock`.
    temp15-product_id = `HT-1110`.
    temp15-category = `Computer System Accessories`.
    temp15-main_category = `Computer Systems`.
    temp15-supplier_name = `Red Point Stores`.
    temp15-description = `Robust 3m anti-burglary protection for your laptop computer`.
    temp15-width = `20`.
    temp15-depth = `8`.
    temp15-height = `4.3`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.03`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `14`.
    temp15-price = '8.90'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Notebook Lock`.
    temp15-product_id = `HT-1111`.
    temp15-category = `Computer System Accessories`.
    temp15-main_category = `Computer Systems`.
    temp15-supplier_name = `Red Point Stores`.
    temp15-description = `Robust 1m anti-burglary protection for your desktop computer`.
    temp15-width = `31`.
    temp15-depth = `9`.
    temp15-height = `7`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.02`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `20`.
    temp15-price = '6.90'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Web cam reality`.
    temp15-product_id = `HT-1112`.
    temp15-category = `Computer System Accessories`.
    temp15-main_category = `Computer Systems`.
    temp15-supplier_name = `Red Point Stores`.
    temp15-description = `Color webcam, color, High-Speed USB`.
    temp15-width = `9`.
    temp15-depth = `8.2`.
    temp15-height = `1.3`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.075`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `27`.
    temp15-price = '39.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Screen clean`.
    temp15-product_id = `HT-1113`.
    temp15-category = `Computer System Accessories`.
    temp15-main_category = `Computer Systems`.
    temp15-supplier_name = `Red Point Stores`.
    temp15-description = `10 separately packed screen wipes`.
    temp15-width = `2`.
    temp15-depth = `2`.
    temp15-height = `0.1`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.05`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `17`.
    temp15-price = '2.30'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Fabric bag professional`.
    temp15-product_id = `HT-1114`.
    temp15-category = `Computer System Accessories`.
    temp15-main_category = `Computer Systems`.
    temp15-supplier_name = `Red Point Stores`.
    temp15-description = `Notebook bag, plenty of room for stationery and writing materials`.
    temp15-width = `42`.
    temp15-depth = `32`.
    temp15-height = `7`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `1.8`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `14`.
    temp15-price = '31.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Wireless DSL Router`.
    temp15-product_id = `HT-1115`.
    temp15-category = `Telecommunications`.
    temp15-main_category = `Computer Components`.
    temp15-supplier_name = `Red Point Stores`.
    temp15-description = `Wireless DSL Router (available in blue, black and silver)`.
    temp15-width = `19.3`.
    temp15-depth = `18`.
    temp15-height = `5`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.45`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `16`.
    temp15-price = '49.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Wireless DSL Router / Repeater`.
    temp15-product_id = `HT-1116`.
    temp15-category = `Telecommunications`.
    temp15-main_category = `Computer Components`.
    temp15-supplier_name = `Red Point Stores`.
    temp15-description = `Wireless DSL Router / Repeater (available in blue, black and silver)`.
    temp15-width = `19.3`.
    temp15-depth = `18`.
    temp15-height = `5`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.45`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `12`.
    temp15-price = '59.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Wireless DSL Router / Repeater and Print Server`.
    temp15-product_id = `HT-1117`.
    temp15-category = `Telecommunications`.
    temp15-main_category = `Computer Components`.
    temp15-supplier_name = `Technocom`.
    temp15-description = `Wireless DSL Router / Repeater and Print Server (available in blue, black and silver)`.
    temp15-width = `19.3`.
    temp15-depth = `18`.
    temp15-height = `5`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.45`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `12`.
    temp15-price = '69.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `USB Stick`.
    temp15-product_id = `HT-1118`.
    temp15-category = `Computer System Accessories`.
    temp15-main_category = `Computer Systems`.
    temp15-supplier_name = `Technocom`.
    temp15-description = `USB 2.0 High-Speed 64 GB`.
    temp15-width = `1.5`.
    temp15-depth = `8.7`.
    temp15-height = `1.2`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.015`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `14`.
    temp15-price = '35.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Travel Adapter`.
    temp15-product_id = `HT-1119`.
    temp15-category = `Accessories`.
    temp15-main_category = `Computer Systems`.
    temp15-supplier_name = `Titanium`.
    temp15-description = `Universal Travel Adapter`.
    temp15-width = `2`.
    temp15-depth = `3.1`.
    temp15-height = `3.9`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `88`.
    temp15-weight_unit = `G`.
    temp15-quantity = `10`.
    temp15-price = '79.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Cordless Bluetooth Keyboard, english international`.
    temp15-product_id = `HT-1120`.
    temp15-category = `Keyboards`.
    temp15-main_category = `Computer Components`.
    temp15-supplier_name = `Technocom`.
    temp15-description = `Cordless Bluetooth Keyboard with English keys`.
    temp15-width = `51.4`.
    temp15-depth = `23`.
    temp15-height = `4`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `1`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `13`.
    temp15-price = '29.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Flat XXL`.
    temp15-product_id = `HT-1137`.
    temp15-category = `Flat Screen Monitors`.
    temp15-main_category = `Computer Components`.
    temp15-supplier_name = `Technocom`.
    temp15-description = `Optimum Hi-Resolution max. 2048 × 1536 @ 85Hz, Dot Pitch: 0.24mm`.
    temp15-width = `54`.
    temp15-depth = `22`.
    temp15-height = `38`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `18`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `10`.
    temp15-price = '1430.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Pocket Mouse`.
    temp15-product_id = `HT-1138`.
    temp15-category = `Mice`.
    temp15-main_category = `Computer Components`.
    temp15-supplier_name = `Technocom`.
    temp15-description = `Portable pocket Mouse with retracting cord`.
    temp15-width = `0.3`.
    temp15-depth = `0.5`.
    temp15-height = `1`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.02`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `20`.
    temp15-price = '23.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `PC Power Station`.
    temp15-product_id = `HT-1210`.
    temp15-category = `PCs`.
    temp15-main_category = `Computer Systems`.
    temp15-supplier_name = `Technocom`.
    temp15-description = `PC Power Station with 3,4 Ghz quad-core, 32 GB DDR3 SDRAM, feels like Available PC, Windows 8 Pro`.
    temp15-width = `28`.
    temp15-depth = `31`.
    temp15-height = `43`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `2.3`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `22`.
    temp15-price = '2399.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Astro Laptop 1516`.
    temp15-product_id = `HT-1251`.
    temp15-category = `Laptops`.
    temp15-main_category = `Computer Systems`.
    temp15-supplier_name = `Ultrasonic United`.
    temp15-description = `Flexible Laptop with 2,5 GHz Quad Core, 15" HD TN, 16 GB DDR SDRAM, 256 GB SSD, Windows 10 Pro`.
    temp15-width = `30`.
    temp15-depth = `18`.
    temp15-height = `3`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `4.2`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `23`.
    temp15-price = '989.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Astro Phone 6`.
    temp15-product_id = `HT-1252`.
    temp15-category = `Smartphones and Tablets`.
    temp15-main_category = `Smartphones & Tablets`.
    temp15-supplier_name = `Ultrasonic United`.
    temp15-description = `6 inch 1280x800 HD display (216 ppi), Quad-core processor, 8 GB internal storage (actual formatted capacity will be less), 3050 mAh battery (Up to 8 hours of active use), grey or black`.
    temp15-width = `8`.
    temp15-depth = `6`.
    temp15-height = `1.5`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.75`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `28`.
    temp15-price = '649.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Benda Laptop 1408`.
    temp15-product_id = `HT-1253`.
    temp15-category = `Laptops`.
    temp15-main_category = `Computer Systems`.
    temp15-supplier_name = `Ultrasonic United`.
    temp15-description = `Flexible Laptop with 2,5 GHz Dual Core, 14" HD+ TN, 8 GB DDR SDRAM, 324 GB SSD, Windows 10 Pro`.
    temp15-width = `30`.
    temp15-depth = `18`.
    temp15-height = `3`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `4.2`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `27`.
    temp15-price = '976.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Bending Screen 21HD`.
    temp15-product_id = `HT-1254`.
    temp15-category = `Flat Screens`.
    temp15-main_category = `Computer Components`.
    temp15-supplier_name = `Ultrasonic United`.
    temp15-description = `Optimum Hi-Resolution Widescreen max. 1920 x 1080 @ 85Hz, Dot Pitch: 0.27mm, HDMI, Discontinued-Sub`.
    temp15-width = `37`.
    temp15-depth = `12`.
    temp15-height = `36`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `15`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `23`.
    temp15-price = '250.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Broad Screen 22HD`.
    temp15-product_id = `HT-1255`.
    temp15-category = `Flat Screens`.
    temp15-main_category = `Computer Components`.
    temp15-supplier_name = `Ultrasonic United`.
    temp15-description = `Optimum Hi-Resolution Widescreen max. 2048 x 1080 @ 85Hz, Dot Pitch: 0.27mm, HDMI, Discontinued-Sub`.
    temp15-width = `39`.
    temp15-depth = `12`.
    temp15-height = `38`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `16`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `5`.
    temp15-price = '270.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Cerdik Phone 7`.
    temp15-product_id = `HT-1256`.
    temp15-category = `Smartphones and Tablets`.
    temp15-main_category = `Smartphones & Tablets`.
    temp15-supplier_name = `Ultrasonic United`.
    temp15-description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage (actual formatted capacity will be less), 4325 mAh battery (Up to 8 hours of active use), white or black`.
    temp15-width = `9`.
    temp15-depth = `15`.
    temp15-height = `1.5`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.75`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `19`.
    temp15-price = '549.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Cepat Tablet 10.5`.
    temp15-product_id = `HT-1257`.
    temp15-category = `Smartphones and Tablets`.
    temp15-main_category = `Smartphones & Tablets`.
    temp15-supplier_name = `Ultrasonic United`.
    temp15-description = `10.5-inch Multitouch HD Screen (1280 x 800), 16GB Internal Memory, Wireless N Wi-Fi; Bluetooth, GPS Enabled, 1GHz Dual-Core Processor`.
    temp15-width = `48`.
    temp15-depth = `31`.
    temp15-height = `4.5`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `2.8`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `17`.
    temp15-price = '549.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Cepat Tablet 8`.
    temp15-product_id = `HT-1258`.
    temp15-category = `Smartphones and Tablets`.
    temp15-main_category = `Smartphones & Tablets`.
    temp15-supplier_name = `Ultrasonic United`.
    temp15-description = `8-inch Multitouch HD Screen (2000 x 1500) 32GB Internal Memory, Wireless N Wi-Fi, Bluetooth, GPS Enabled, 1.5 GHz Quad-Core Processor`.
    temp15-width = `38`.
    temp15-depth = `21`.
    temp15-height = `3.5`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `2.5`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `24`.
    temp15-price = '529.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Server Basic`.
    temp15-product_id = `HT-1500`.
    temp15-category = `Servers`.
    temp15-main_category = `Computer Systems`.
    temp15-supplier_name = `Technocom`.
    temp15-description = `Dual socket, quad-core processing server with 1333 MHz Front Side Bus with 10Gb connectivity`.
    temp15-width = `34`.
    temp15-depth = `35`.
    temp15-height = `23`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `18`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `24`.
    temp15-price = '5000.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Server Professional`.
    temp15-product_id = `HT-1501`.
    temp15-category = `Servers`.
    temp15-main_category = `Computer Systems`.
    temp15-supplier_name = `Technocom`.
    temp15-description = `Dual socket, quad-core processing server with 1644 MHz Front Side Bus with 10Gb connectivity`.
    temp15-width = `29`.
    temp15-depth = `30`.
    temp15-height = `27`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `25`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `26`.
    temp15-price = '15000.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Server Power Pro`.
    temp15-product_id = `HT-1502`.
    temp15-category = `Servers`.
    temp15-main_category = `Computer Systems`.
    temp15-supplier_name = `Technocom`.
    temp15-description = `Dual socket, quad-core processing server with 1644 MHz Front Side Bus with 100Gb connectivity`.
    temp15-width = `22`.
    temp15-depth = `27.3`.
    temp15-height = `37`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `35`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `34`.
    temp15-price = '25000.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Family PC Basic`.
    temp15-product_id = `HT-1600`.
    temp15-category = `Desktop Computers`.
    temp15-main_category = `Computer Systems`.
    temp15-supplier_name = `Titanium`.
    temp15-description = `2,8 Ghz dual core, 4 GB DDR3 SDRAM, 500 GB Hard Disc, Graphic Card: Proctra X, Windows 8`.
    temp15-width = `21.4`.
    temp15-depth = `29`.
    temp15-height = `38`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `4.8`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `10`.
    temp15-price = '600.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Family PC Pro`.
    temp15-product_id = `HT-1601`.
    temp15-category = `Desktop Computers`.
    temp15-main_category = `Computer Systems`.
    temp15-supplier_name = `Titanium`.
    temp15-description = `2,8 Ghz dual core, 4 GB DDR3 SDRAM, 1000 GB Hard Disc, Graphic Card: Gladiator MX, Windows 8`.
    temp15-width = `25`.
    temp15-depth = `31.7`.
    temp15-height = `40.2`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `5.3`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `20`.
    temp15-price = '900.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Gaming Monster`.
    temp15-product_id = `HT-1602`.
    temp15-category = `Desktop Computers`.
    temp15-main_category = `Computer Systems`.
    temp15-supplier_name = `Titanium`.
    temp15-description = `3,4 Ghz quad core, 8 GB DDR3 SDRAM, 2000 GB Hard Disc, Graphic Card: Gladiator MX, Windows 8`.
    temp15-width = `26.5`.
    temp15-depth = `34`.
    temp15-height = `47`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `5.9`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `24`.
    temp15-price = '1200.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Gaming Monster Pro`.
    temp15-product_id = `HT-1603`.
    temp15-category = `Desktop Computers`.
    temp15-main_category = `Computer Systems`.
    temp15-supplier_name = `Titanium`.
    temp15-description = `3,4 Ghz quad core, 16 GB DDR3 SDRAM, 4000 GB Hard Disc, Graphic Card: Hurricane GX, Windows 8`.
    temp15-width = `27`.
    temp15-depth = `28`.
    temp15-height = `42`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `6.8`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `25`.
    temp15-price = '1700.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `7" Widescreen Portable DVD Player w MP3`.
    temp15-product_id = `HT-2000`.
    temp15-category = `Accessories`.
    temp15-main_category = `TV, Video & HiFi`.
    temp15-supplier_name = `Titanium`.
    temp15-description = `7" LCD Screen, storage battery holds up to 6 hours!`.
    temp15-width = `21.4`.
    temp15-depth = `19`.
    temp15-height = `27.6`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.79`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `20`.
    temp15-price = '249.99'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `10" Portable DVD player`.
    temp15-product_id = `HT-2001`.
    temp15-category = `Accessories`.
    temp15-main_category = `TV, Video & HiFi`.
    temp15-supplier_name = `Titanium`.
    temp15-description = `10" LCD Screen, storage battery holds up to 8 hours`.
    temp15-width = `24`.
    temp15-depth = `19.5`.
    temp15-height = `29`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.84`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `21`.
    temp15-price = '449.99'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Portable DVD Player with 9" LCD Monitor`.
    temp15-product_id = `HT-2002`.
    temp15-category = `Accessories`.
    temp15-main_category = `TV, Video & HiFi`.
    temp15-supplier_name = `Technocom`.
    temp15-description = `9" LCD Screen, storage holds up to 8 hours, 2 speakers included`.
    temp15-width = `21`.
    temp15-depth = `16.5`.
    temp15-height = `14`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.72`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `50`.
    temp15-price = '853.99'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `CD/DVD case: 264 sleeves`.
    temp15-product_id = `HT-2025`.
    temp15-category = `Accessories`.
    temp15-main_category = `Computer Systems`.
    temp15-supplier_name = `Titanium`.
    temp15-description = `Organizer and protective case for 264 CDs and DVDs`.
    temp15-width = `13`.
    temp15-depth = `13`.
    temp15-height = `20`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.65`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `26`.
    temp15-price = '44.99'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Audio/Video Cable Kit - 4m`.
    temp15-product_id = `HT-2026`.
    temp15-category = `Accessories`.
    temp15-main_category = `Computer Systems`.
    temp15-supplier_name = `Titanium`.
    temp15-description = `Quality cables for notebooks and projectors`.
    temp15-width = `21`.
    temp15-depth = `10.2`.
    temp15-height = `13`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.2`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `16`.
    temp15-price = '29.99'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Removable CD/DVD Laser Labels`.
    temp15-product_id = `HT-2027`.
    temp15-category = `Accessories`.
    temp15-main_category = `Computer Systems`.
    temp15-supplier_name = `Titanium`.
    temp15-description = `Removable jewel case labels, zero residues (100)`.
    temp15-width = `5.5`.
    temp15-depth = `2`.
    temp15-height = `2`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.15`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `25`.
    temp15-price = '8.99'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Beam Breaker B-1`.
    temp15-product_id = `HT-6100`.
    temp15-category = `Accessories`.
    temp15-main_category = `TV, Video & HiFi`.
    temp15-supplier_name = `Titanium`.
    temp15-description = `720p, DLP Projector max. 8,45 Meter, 2D`.
    temp15-width = `30.4`.
    temp15-depth = `23.1`.
    temp15-height = `23`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `1.7`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `32`.
    temp15-price = '469.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Beam Breaker B-2`.
    temp15-product_id = `HT-6101`.
    temp15-category = `Accessories`.
    temp15-main_category = `TV, Video & HiFi`.
    temp15-supplier_name = `Technocom`.
    temp15-description = `1080p, DLP max.9,34 Meter, 2D-ready`.
    temp15-width = `30.4`.
    temp15-depth = `23.1`.
    temp15-height = `23`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `2`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `18`.
    temp15-price = '679.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Beam Breaker B-3`.
    temp15-product_id = `HT-6102`.
    temp15-category = `Accessories`.
    temp15-main_category = `TV, Video & HiFi`.
    temp15-supplier_name = `Technocom`.
    temp15-description = `1080p, DLP max. 12,3 Meter, 3D-ready`.
    temp15-width = `30.4`.
    temp15-depth = `23.1`.
    temp15-height = `23`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `2.5`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `16`.
    temp15-price = '889.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Play Movie`.
    temp15-product_id = `HT-6110`.
    temp15-category = `Accessories`.
    temp15-main_category = `TV, Video & HiFi`.
    temp15-supplier_name = `Fasttech`.
    temp15-description = `CD-RW, DVD+R/RW, DVD-R/RW, MPEG 2 (Video-DVD), MPEG 4, VCD, SVCD, DivX, Xvid`.
    temp15-width = `37`.
    temp15-depth = `24`.
    temp15-height = `6`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `2.4`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `15`.
    temp15-price = '130.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Record Movie`.
    temp15-product_id = `HT-6111`.
    temp15-category = `Accessories`.
    temp15-main_category = `TV, Video & HiFi`.
    temp15-supplier_name = `Fasttech`.
    temp15-description = `160 GB HDD, CD-RW, DVD+R/RW, DVD-R/RW, MPEG 2 (Video-DVD), MPEG 4, VCD, SVCD, DivX, Xvid`.
    temp15-width = `38`.
    temp15-depth = `26`.
    temp15-height = `6.2`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `3.1`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `24`.
    temp15-price = '288.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `ITelo MusicStick`.
    temp15-product_id = `HT-6120`.
    temp15-category = `Accessories`.
    temp15-main_category = `TV, Video & HiFi`.
    temp15-supplier_name = `Fasttech`.
    temp15-description = `64 GB USB Music-on-Available-Stick`.
    temp15-width = `1.5`.
    temp15-depth = `6`.
    temp15-height = `1`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `134`.
    temp15-weight_unit = `G`.
    temp15-quantity = `15`.
    temp15-price = '45.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `ITelo Jog-Mate`.
    temp15-product_id = `HT-6121`.
    temp15-category = `Accessories`.
    temp15-main_category = `TV, Video & HiFi`.
    temp15-supplier_name = `Fasttech`.
    temp15-description = `ITelo Jog-Mate 64 GB HDD and Color Display, can play movies`.
    temp15-width = `5.1`.
    temp15-depth = `8`.
    temp15-height = `9.2`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `134`.
    temp15-weight_unit = `G`.
    temp15-quantity = `24`.
    temp15-price = '63.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Power Pro Player 40`.
    temp15-product_id = `HT-6122`.
    temp15-category = `Accessories`.
    temp15-main_category = `TV, Video & HiFi`.
    temp15-supplier_name = `Fasttech`.
    temp15-description = `MP3-Player with 40 GB HDD and Color Display, can play movies`.
    temp15-width = `5.1`.
    temp15-depth = `8`.
    temp15-height = `9.2`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `266`.
    temp15-weight_unit = `G`.
    temp15-quantity = `23`.
    temp15-price = '167.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Power Pro Player 80`.
    temp15-product_id = `HT-6123`.
    temp15-category = `Accessories`.
    temp15-main_category = `TV, Video & HiFi`.
    temp15-supplier_name = `Fasttech`.
    temp15-description = `MP3-Player with 80 GB SSD and Color Display, can play movies`.
    temp15-width = `4`.
    temp15-depth = `6`.
    temp15-height = `0.8`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `267`.
    temp15-weight_unit = `G`.
    temp15-quantity = `13`.
    temp15-price = '299.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Flat Watch HD32`.
    temp15-product_id = `HT-6130`.
    temp15-category = `Flat Screen TVs`.
    temp15-main_category = `TV, Video & HiFi`.
    temp15-supplier_name = `Very Best Screens`.
    temp15-description = `32-inch, 1366x768 Pixel, 16:9, HDTV ready`.
    temp15-width = `78`.
    temp15-depth = `22.1`.
    temp15-height = `55`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `2.6`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `16`.
    temp15-price = '1459.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Flat Watch HD37`.
    temp15-product_id = `HT-6131`.
    temp15-category = `Flat Screen TVs`.
    temp15-main_category = `TV, Video & HiFi`.
    temp15-supplier_name = `Very Best Screens`.
    temp15-description = `37-inch, 1366x768 Pixel, 16:9, HDTV ready`.
    temp15-width = `99.1`.
    temp15-depth = `26`.
    temp15-height = `61`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `2.2`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `14`.
    temp15-price = '1199.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Flat Watch HD41`.
    temp15-product_id = `HT-6132`.
    temp15-category = `Flat Screen TVs`.
    temp15-main_category = `TV, Video & HiFi`.
    temp15-supplier_name = `Very Best Screens`.
    temp15-description = `41-inch, 1366x768 Pixel, 16:9, HDTV ready`.
    temp15-width = `128`.
    temp15-depth = `23`.
    temp15-height = `79.1`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `1.8`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `13`.
    temp15-price = '899.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Copperberry`.
    temp15-product_id = `HT-7000`.
    temp15-category = `Accessories`.
    temp15-main_category = `Computer Components`.
    temp15-supplier_name = `Fasttech`.
    temp15-description = `Our new multifunctional Handheld with phone function in copper`.
    temp15-width = `8.1`.
    temp15-depth = `13`.
    temp15-height = `12.1`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.5`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `5`.
    temp15-price = '549.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Silverberry`.
    temp15-product_id = `HT-7010`.
    temp15-category = `Accessories`.
    temp15-main_category = `Computer Components`.
    temp15-supplier_name = `Fasttech`.
    temp15-description = `Our new multifunctional Handheld with phone function in silver`.
    temp15-width = `8.1`.
    temp15-depth = `13`.
    temp15-height = `12.1`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.5`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `9`.
    temp15-price = '549.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Goldberry`.
    temp15-product_id = `HT-7020`.
    temp15-category = `Accessories`.
    temp15-main_category = `Computer Components`.
    temp15-supplier_name = `Fasttech`.
    temp15-description = `Our new multifunctional Handheld with phone function in gold`.
    temp15-width = `8.1`.
    temp15-depth = `13`.
    temp15-height = `12.1`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.5`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `11`.
    temp15-price = '549.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Platinberry`.
    temp15-product_id = `HT-7030`.
    temp15-category = `Accessories`.
    temp15-main_category = `Computer Components`.
    temp15-supplier_name = `Fasttech`.
    temp15-description = `Our new multifunctional Handheld with phone function in platinum`.
    temp15-width = `8.1`.
    temp15-depth = `13`.
    temp15-height = `12.1`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.5`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `12`.
    temp15-price = '549.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `ITelO FlexTop I4000`.
    temp15-product_id = `HT-8000`.
    temp15-category = `Laptops`.
    temp15-main_category = `Computer Systems`.
    temp15-supplier_name = `Titanium`.
    temp15-description = `Notebook with 2,80 GHz dual core, 4 GB DDR3 SDRAM, 500 GB Hard Disc, Windows 8`.
    temp15-width = `31`.
    temp15-depth = `19`.
    temp15-height = `3.1`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `4`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `11`.
    temp15-price = '799.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `ITelO FlexTop I6300c`.
    temp15-product_id = `HT-8001`.
    temp15-category = `Laptops`.
    temp15-main_category = `Computer Systems`.
    temp15-supplier_name = `Titanium`.
    temp15-description = `Notebook with 2,80 GHz dual core, 8 GB DDR3 SDRAM, 500 GB Hard Disc, Windows 8`.
    temp15-width = `32`.
    temp15-depth = `20`.
    temp15-height = `3.4`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `4.2`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `20`.
    temp15-price = '799.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `ITelO FlexTop I9100`.
    temp15-product_id = `HT-8002`.
    temp15-category = `Laptops`.
    temp15-main_category = `Computer Systems`.
    temp15-supplier_name = `Titanium`.
    temp15-description = `Notebook with 2,80 GHz quad core, 4 GB DDR3 SDRAM, 1000 GB Hard Disc, Windows 8`.
    temp15-width = `38`.
    temp15-depth = `21`.
    temp15-height = `4.1`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `3.5`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `20`.
    temp15-price = '1199.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `ITelO FlexTop I9800`.
    temp15-product_id = `HT-8003`.
    temp15-category = `Laptops`.
    temp15-main_category = `Computer Systems`.
    temp15-supplier_name = `Titanium`.
    temp15-description = `Notebook with 2,80 GHz quad core, 8 GB DDR3 SDRAM, 1000 GB Hard Disc, Windows 8`.
    temp15-width = `48`.
    temp15-depth = `31`.
    temp15-height = `4.5`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `3.8`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `22`.
    temp15-price = '1388.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Smartphone Leather Case`.
    temp15-product_id = `HT-9991`.
    temp15-category = `Accessories`.
    temp15-main_category = `Smartphones & Tablets`.
    temp15-supplier_name = `Ultrasonic United`.
    temp15-description = `Button Clasp, Quality Material, 100% Leather, compatible with many smartphone models`.
    temp15-width = `48`.
    temp15-depth = `31`.
    temp15-height = `4.5`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.02`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `12`.
    temp15-price = '25.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Smartphone Alpha`.
    temp15-product_id = `HT-9992`.
    temp15-category = `Smartphones and Tablets`.
    temp15-main_category = `Smartphones & Tablets`.
    temp15-supplier_name = `Ultrasonic United`.
    temp15-description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage (actual formatted capacity will be less), 4325 mAh battery (Up to 8 hours of active use), white or black`.
    temp15-width = `48`.
    temp15-depth = `31`.
    temp15-height = `4.5`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.75`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `13`.
    temp15-price = '599.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Mini Tablet`.
    temp15-product_id = `HT-9993`.
    temp15-category = `Smartphones and Tablets`.
    temp15-main_category = `Smartphones & Tablets`.
    temp15-supplier_name = `Ultrasonic United`.
    temp15-description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage, 4325 mAh battery (Up to 8 hours of active use)`.
    temp15-width = `48`.
    temp15-depth = `31`.
    temp15-height = `4.5`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `3.8`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `10`.
    temp15-price = '833.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Camcorder View`.
    temp15-product_id = `HT-9994`.
    temp15-category = `Accessories`.
    temp15-main_category = `TV, Video & HiFi`.
    temp15-supplier_name = `Ultrasonic United`.
    temp15-description = `1920x1080 Full HD, image stabilization reduces blur, 27x Optical / 32x Extended Zoom, wide angle Lens, 2.7" wide LCD display`.
    temp15-width = `48`.
    temp15-depth = `31`.
    temp15-height = `27`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `3.8`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `50`.
    temp15-price = '1388.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Tablet Pouch`.
    temp15-product_id = `HT-9995`.
    temp15-category = `Accessories`.
    temp15-main_category = `Smartphones & Tablets`.
    temp15-supplier_name = `Titanium`.
    temp15-description = `Stylish tablet pouch, protects from scratches, color: black`.
    temp15-width = `25`.
    temp15-depth = `40`.
    temp15-height = `4.5`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.03`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `34`.
    temp15-price = '20.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Tablet Pouch`.
    temp15-product_id = `HT-9996`.
    temp15-category = `Accessories`.
    temp15-main_category = `Smartphones & Tablets`.
    temp15-supplier_name = `Titanium`.
    temp15-description = `Stylish tablet pouch, protects from scratches, color: black`.
    temp15-width = `25`.
    temp15-depth = `40`.
    temp15-height = `4.5`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.03`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `34`.
    temp15-price = '20.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `e-Book Reader ReadMe`.
    temp15-product_id = `HT-9997`.
    temp15-category = `Smartphones and Tablets`.
    temp15-main_category = `Smartphones & Tablets`.
    temp15-supplier_name = `Titanium`.
    temp15-description = `6-Inch E Ink Screen, Access To e-book Store, Adjustable Font Styles and Sizes, Stores Up To 1,000 Books`.
    temp15-width = `48`.
    temp15-depth = `31`.
    temp15-height = `4.5`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `3.8`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `23`.
    temp15-price = '33.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Smartphone Beta`.
    temp15-product_id = `HT-9998`.
    temp15-category = `Smartphones and Tablets`.
    temp15-main_category = `Smartphones & Tablets`.
    temp15-supplier_name = `Titanium`.
    temp15-description = `5 Megapixel Camera, Wi-Fi 802.11 b/g/n, Bluetooth, GPS Available-GPS support`.
    temp15-width = `48`.
    temp15-depth = `31`.
    temp15-height = `4.5`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.75`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `21`.
    temp15-price = '30.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Maxi Tablet`.
    temp15-product_id = `HT-9999`.
    temp15-category = `Tablets`.
    temp15-main_category = `Smartphones & Tablets`.
    temp15-supplier_name = `Titanium`.
    temp15-description = `10.1-inch Multitouch HD Screen (1280 x 800), 16GB Internal Memory, Wireless N Wi-Fi; Bluetooth, GPS Enabled, 1GHz Dual-Core Processor`.
    temp15-width = `48`.
    temp15-depth = `31`.
    temp15-height = `4.5`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `3.8`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `20`.
    temp15-price = '749.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-name = `Flyer`.
    temp15-product_id = `PF-1000`.
    temp15-category = `Accessories`.
    temp15-main_category = `Computer Systems`.
    temp15-supplier_name = `Titanium`.
    temp15-description = `Flyer for our product palette`.
    temp15-width = `46`.
    temp15-depth = `30`.
    temp15-height = `3`.
    temp15-dim_unit = `cm`.
    temp15-weight_measure = `0.01`.
    temp15-weight_unit = `KG`.
    temp15-quantity = `33`.
    temp15-price = '0.00'.
    temp15-currency_code = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    t_products = temp14.

    " weightState per the demo Formatter (parseFloat thresholds), computed in ABAP
    " (thin frontend): all product weights are < 1000, so Success throughout
    
    
    LOOP AT t_products REFERENCE INTO lr_product.
      
      temp17 = lr_product->weight_measure.
      
      weight_num = temp17.
      
      IF weight_num < 0.
        temp18 = `None`.
      ELSEIF weight_num < 1000.
        temp18 = `Success`.
      ELSEIF weight_num < 2000.
        temp18 = `Warning`.
      ELSE.
        temp18 = `Error`.
      ENDIF.
      lr_product->weight_state = temp18.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
