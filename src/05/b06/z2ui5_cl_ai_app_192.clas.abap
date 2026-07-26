CLASS z2ui5_cl_ai_app_192 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        product_id    TYPE string,
        supplier_name TYPE string,
        name          TYPE string,
        status        TYPE string,
        currency_code TYPE string,
        price         TYPE p LENGTH 8 DECIMALS 2,
        width         TYPE string,
        depth         TYPE string,
        height        TYPE string,
        dim_unit      TYPE string,
        color_scheme  TYPE i,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.
    DATA popin_layout TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_192 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:tnt`  v = `sap.tnt`

        " popinLayout is set imperatively by the original controller (onPopinLayoutChanged) - bound properties here
        )->open( `Table`
            )->a( n = `id`          v = `idProductsTable`
            )->a( n = `inset`       v = `false`
            )->a( n = `items`       v = |\{ path: '{ client->_bind( val = t_products path = abap_true ) }', sorter: \{ path: 'NAME' \} \}|
            )->a( n = `popinLayout` v = |\{= ${ client->_bind( popin_layout ) } === 'GridLarge' \|\| ${ client->_bind( popin_layout ) } === 'GridSmall' ? ${ client->_bind( popin_layout ) } : 'Block' \}|

            )->open( `headerToolbar`
                )->open( `Toolbar`
                    )->leaf( `Title`
                        )->a( n = `text`  v = `Products`
                        )->a( n = `level` v = `H2`
                    )->leaf( `ToolbarSpacer`

                    " the original change handler's PopinLayout switch lives in the Table's popinLayout expression binding
                    )->open( `ComboBox`
                        )->a( n = `id`          v = `idPopinLayout`
                        )->a( n = `placeholder` v = `Popin layout options`
                        )->a( n = `selectedKey` v = client->_bind( popin_layout )

                        )->open( `items`
                            )->leaf( n = `Item` ns = `core`
                                )->a( n = `text` v = `Block`
                                )->a( n = `key`  v = `Block`
                            )->leaf( n = `Item` ns = `core`
                                )->a( n = `text` v = `Grid Large`
                                )->a( n = `key`  v = `GridLarge`
                            )->leaf( n = `Item` ns = `core`
                                )->a( n = `text` v = `Grid Small`
                                )->a( n = `key`  v = `GridSmall`

                        )->shut(
                    )->shut(
                )->shut(
            )->shut(
            )->open( `columns`
                )->open( `Column`
                    )->a( n = `width` v = `12em`

                    )->leaf( `Text`
                        )->a( n = `text` v = `Product`

                )->shut(
                )->open( `Column`
                    )->a( n = `minScreenWidth` v = `Tablet`
                    )->a( n = `demandPopin`    v = `true`

                    )->leaf( `Text`
                        )->a( n = `text` v = `Supplier`

                )->shut(
                )->open( `Column`
                    )->a( n = `minScreenWidth` v = `Desktop`
                    )->a( n = `demandPopin`    v = `true`

                    )->leaf( `Text`
                        )->a( n = `text` v = `Dimensions`

                )->shut(
                )->open( `Column`
                    )->a( n = `minScreenWidth` v = `Desktop`
                    )->a( n = `demandPopin`    v = `true`

                    )->leaf( `Text`
                        )->a( n = `text` v = `Availability`

                )->shut(
                )->open( `Column`
                    )->leaf( `Text`
                        )->a( n = `text` v = `Price`

                )->shut(
            )->shut(
            )->open( `items`
                )->open( `ColumnListItem`
                    )->open( `cells`
                        )->leaf( `ObjectIdentifier`
                            )->a( n = `title` v = `{NAME}`
                            )->a( n = `text`  v = `{PRODUCT_ID}`
                        )->leaf( `Text`
                            )->a( n = `text` v = `{SUPPLIER_NAME}`
                        )->leaf( `Text`
                            )->a( n = `text` v = `{WIDTH} x {DEPTH} x {HEIGHT} {DIM_UNIT}`
                        " colorScheme is derived from Status in ABAP (see the NOTE deviation), not the original frontend formatter
                        )->leaf( n = `InfoLabel` ns = `tnt`
                            )->a( n = `text`        v = `{STATUS}`
                            )->a( n = `displayOnly` v = `true`
                            )->a( n = `colorScheme` v = `{COLOR_SCHEME}`
                        )->leaf( `ObjectNumber`
                            )->a( n = `number` v = `{ parts:[{path:'PRICE'},{path:'CURRENCY_CODE'}], type: 'sap.ui.model.type.Currency', formatOptions: {showMeasure: false} }`
                            )->a( n = `unit`   v = `{CURRENCY_CODE}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    popin_layout = `Block`.

    t_products = VALUE #(
      ( product_id = `HT-1000` supplier_name = `Very Best Screens` name = `Notebook Basic 15`
        status = `Available`           currency_code = `EUR` price = '956'  width = `30` depth = `18`  height = `3`   dim_unit = `cm` )
      ( product_id = `HT-1001` supplier_name = `Very Best Screens` name = `Notebook Basic 17`
        status = `Sold out`            currency_code = `EUR` price = '1249' width = `29` depth = `17`  height = `3.1` dim_unit = `cm` )
      ( product_id = `HT-1002` supplier_name = `Very Best Screens` name = `Notebook Basic 18`
        status = `Available`           currency_code = `EUR` price = '1570' width = `28` depth = `19`  height = `2.5` dim_unit = `cm` )
      ( product_id = `HT-1003` supplier_name = `Smartcards`        name = `Notebook Basic 19`
        status = `Available`           currency_code = `EUR` price = '1650' width = `32` depth = `21`  height = `4`   dim_unit = `cm` )
      ( product_id = `HT-1007` supplier_name = `Technocom`         name = `ITelO Vault`
        status = `Sold out`            currency_code = `EUR` price = '299'  width = `32` depth = `22`  height = `3`   dim_unit = `cm` )
      ( product_id = `HT-1010` supplier_name = `Very Best Screens` name = `Notebook Professional 15`
        status = `No longer available` currency_code = `EUR` price = '1999' width = `33` depth = `20`  height = `3`   dim_unit = `cm` )
      ( product_id = `HT-1011` supplier_name = `Very Best Screens` name = `Notebook Professional 17`
        status = `Sold out`            currency_code = `EUR` price = '2299' width = `33` depth = `23`  height = `2`   dim_unit = `cm` )
      ( product_id = `HT-1020` supplier_name = `Technocom`         name = `ITelO Vault Net`
        status = `delivery expected`   currency_code = `EUR` price = '459'  width = `10` depth = `1.8` height = `17`  dim_unit = `cm` )
      ( product_id = `HT-1021` supplier_name = `Technocom`         name = `ITelO Vault SAT`
        status = `delivery expected`   currency_code = `EUR` price = '149'  width = `11` depth = `1.7` height = `18`  dim_unit = `cm` ) ).

    " availableState maps an already-classified Status to an InfoLabel colorScheme index - moved
    " from the original frontend Formatter.js to the ABAP backend (thin-frontend principle)
    LOOP AT t_products REFERENCE INTO DATA(lr_product).
      lr_product->color_scheme = SWITCH #( to_lower( lr_product->status )
                                           WHEN `available`         THEN 8
                                           WHEN `sold out`          THEN 3
                                           WHEN `delivery expected` THEN 5
                                           ELSE 9 ).
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
