" @keywords infolabel info label sap.tnt infolabelintable table toolbar title toolbarspacer combobox item column
" @summary InfoLabel used in content of Table
CLASS z2ui5_cl_smpc_app_192 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        productid    TYPE string,
        suppliername TYPE string,
        name         TYPE string,
        status       TYPE string,
        currencycode TYPE string,
        price        TYPE p LENGTH 8 DECIMALS 2,
        width        TYPE string,
        depth        TYPE string,
        height       TYPE string,
        dimunit      TYPE string,
        color_scheme TYPE i,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.
    DATA popin_layout TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_192 IMPLEMENTATION.

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
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:tnt`  v = `sap.tnt`

        " popinLayout is set imperatively by the original controller (onPopinLayoutChanged) - bound properties here
        )->ele( `Table`
            )->a( n = `id`          v = `idProductsTable`
            )->a( n = `inset`       v = `false`
            )->a( n = `items`       v = |\{ path: '{ client->_bind_path( t_products ) }', sorter: \{ path: 'NAME' \} \}|
            )->a( n = `popinLayout` v = |\{= ${ client->_bind( popin_layout ) } === 'GridLarge' \|\| ${ client->_bind( popin_layout ) } === 'GridSmall' ? ${ client->_bind( popin_layout ) } : 'Block' \}|

            )->ele( `headerToolbar`
                )->ele( `Toolbar`
                    )->tag( `Title`
                        )->a( n = `text`  v = `Products`
                        )->a( n = `level` v = `H2`
                    )->tag( `ToolbarSpacer`

                    " the original change handler's PopinLayout switch lives in the Table's popinLayout expression binding
                    )->ele( `ComboBox`
                        )->a( n = `id`          v = `idPopinLayout`
                        )->a( n = `placeholder` v = `Popin layout options`
                        )->a( n = `selectedKey` v = client->_bind( popin_layout )

                        )->ele( `items`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `text` v = `Block`
                                )->a( n = `key`  v = `Block`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `text` v = `Grid Large`
                                )->a( n = `key`  v = `GridLarge`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `text` v = `Grid Small`
                                )->a( n = `key`  v = `GridSmall`

                        )->end(
                    )->end(
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
                    )->a( n = `minScreenWidth` v = `Desktop`
                    )->a( n = `demandPopin`    v = `true`

                    )->tag( `Text`
                        )->a( n = `text` v = `Dimensions`

                )->end(
                )->ele( `Column`
                    )->a( n = `minScreenWidth` v = `Desktop`
                    )->a( n = `demandPopin`    v = `true`

                    )->tag( `Text`
                        )->a( n = `text` v = `Availability`

                )->end(
                )->ele( `Column`
                    )->tag( `Text`
                        )->a( n = `text` v = `Price`

                )->end(
            )->end(
            )->ele( `items`
                )->ele( `ColumnListItem`
                    )->ele( `cells`
                        )->tag( `ObjectIdentifier`
                            )->a( n = `title` v = `{NAME}`
                            )->a( n = `text`  v = `{PRODUCTID}`
                        )->tag( `Text`
                            )->a( n = `text` v = `{SUPPLIERNAME}`
                        )->tag( `Text`
                            )->a( n = `text` v = `{WIDTH} x {DEPTH} x {HEIGHT} {DIMUNIT}`
                        " colorScheme is derived from Status in ABAP (see the NOTE deviation), not the original frontend formatter
                        )->tag( n = `InfoLabel` ns = `tnt`
                            )->a( n = `text`        v = `{STATUS}`
                            )->a( n = `displayOnly` v = `true`
                            )->a( n = `colorScheme` v = `{COLOR_SCHEME}`
                        )->tag( `ObjectNumber`
                            )->a( n = `number` v = `{ parts:[{path:'PRICE'},{path:'CURRENCYCODE'}], type: 'sap.ui.model.type.Currency', formatOptions: {showMeasure: false} }`
                            )->a( n = `unit`   v = `{CURRENCYCODE}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " popin_layout stays EMPTY on purpose: the original's ComboBox carries no
    " selectedKey, so its placeholder is what the user sees until they pick
    " something, and the popinLayout expression already falls through to
    " 'Block' for an empty value - which is sap.m.Table's own default too
    " (app 009, the checked reference for this idiom, seeds nothing either)

    t_products = VALUE #(
      ( productid = `HT-1000` suppliername = `Very Best Screens` name = `Notebook Basic 15`
        status = `Available`           currencycode = `EUR` price = '956'  width = `30` depth = `18`  height = `3`   dimunit = `cm` )
      ( productid = `HT-1001` suppliername = `Very Best Screens` name = `Notebook Basic 17`
        status = `Sold out`            currencycode = `EUR` price = '1249' width = `29` depth = `17`  height = `3.1` dimunit = `cm` )
      ( productid = `HT-1002` suppliername = `Very Best Screens` name = `Notebook Basic 18`
        status = `Available`           currencycode = `EUR` price = '1570' width = `28` depth = `19`  height = `2.5` dimunit = `cm` )
      ( productid = `HT-1003` suppliername = `Smartcards`        name = `Notebook Basic 19`
        status = `Available`           currencycode = `EUR` price = '1650' width = `32` depth = `21`  height = `4`   dimunit = `cm` )
      ( productid = `HT-1007` suppliername = `Technocom`         name = `ITelO Vault`
        status = `Sold out`            currencycode = `EUR` price = '299'  width = `32` depth = `22`  height = `3`   dimunit = `cm` )
      ( productid = `HT-1010` suppliername = `Very Best Screens` name = `Notebook Professional 15`
        status = `No longer available` currencycode = `EUR` price = '1999' width = `33` depth = `20`  height = `3`   dimunit = `cm` )
      ( productid = `HT-1011` suppliername = `Very Best Screens` name = `Notebook Professional 17`
        status = `Sold out`            currencycode = `EUR` price = '2299' width = `33` depth = `23`  height = `2`   dimunit = `cm` )
      ( productid = `HT-1020` suppliername = `Technocom`         name = `ITelO Vault Net`
        status = `delivery expected`   currencycode = `EUR` price = '459'  width = `10` depth = `1.8` height = `17`  dimunit = `cm` )
      ( productid = `HT-1021` suppliername = `Technocom`         name = `ITelO Vault SAT`
        status = `delivery expected`   currencycode = `EUR` price = '149'  width = `11` depth = `1.7` height = `18`  dimunit = `cm` ) ).

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
