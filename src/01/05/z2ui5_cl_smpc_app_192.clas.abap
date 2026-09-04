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
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.
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
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

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

    DATA temp1 LIKE t_products.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp3 LIKE LINE OF t_products.
    DATA lr_product LIKE REF TO temp3.
      DATA temp4 TYPE z2ui5_cl_smpc_app_192=>ty_s_product-color_scheme.
    CLEAR temp1.
    
    temp2-productid = `HT-1000`.
    temp2-suppliername = `Very Best Screens`.
    temp2-name = `Notebook Basic 15`.
    temp2-status = `Available`.
    temp2-currencycode = `EUR`.
    temp2-price = '956'.
    temp2-width = `30`.
    temp2-depth = `18`.
    temp2-height = `3`.
    temp2-dimunit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1001`.
    temp2-suppliername = `Very Best Screens`.
    temp2-name = `Notebook Basic 17`.
    temp2-status = `Sold out`.
    temp2-currencycode = `EUR`.
    temp2-price = '1249'.
    temp2-width = `29`.
    temp2-depth = `17`.
    temp2-height = `3.1`.
    temp2-dimunit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1002`.
    temp2-suppliername = `Very Best Screens`.
    temp2-name = `Notebook Basic 18`.
    temp2-status = `Available`.
    temp2-currencycode = `EUR`.
    temp2-price = '1570'.
    temp2-width = `28`.
    temp2-depth = `19`.
    temp2-height = `2.5`.
    temp2-dimunit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1003`.
    temp2-suppliername = `Smartcards`.
    temp2-name = `Notebook Basic 19`.
    temp2-status = `Available`.
    temp2-currencycode = `EUR`.
    temp2-price = '1650'.
    temp2-width = `32`.
    temp2-depth = `21`.
    temp2-height = `4`.
    temp2-dimunit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1007`.
    temp2-suppliername = `Technocom`.
    temp2-name = `ITelO Vault`.
    temp2-status = `Sold out`.
    temp2-currencycode = `EUR`.
    temp2-price = '299'.
    temp2-width = `32`.
    temp2-depth = `22`.
    temp2-height = `3`.
    temp2-dimunit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1010`.
    temp2-suppliername = `Very Best Screens`.
    temp2-name = `Notebook Professional 15`.
    temp2-status = `No longer available`.
    temp2-currencycode = `EUR`.
    temp2-price = '1999'.
    temp2-width = `33`.
    temp2-depth = `20`.
    temp2-height = `3`.
    temp2-dimunit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1011`.
    temp2-suppliername = `Very Best Screens`.
    temp2-name = `Notebook Professional 17`.
    temp2-status = `Sold out`.
    temp2-currencycode = `EUR`.
    temp2-price = '2299'.
    temp2-width = `33`.
    temp2-depth = `23`.
    temp2-height = `2`.
    temp2-dimunit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1020`.
    temp2-suppliername = `Technocom`.
    temp2-name = `ITelO Vault Net`.
    temp2-status = `delivery expected`.
    temp2-currencycode = `EUR`.
    temp2-price = '459'.
    temp2-width = `10`.
    temp2-depth = `1.8`.
    temp2-height = `17`.
    temp2-dimunit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1021`.
    temp2-suppliername = `Technocom`.
    temp2-name = `ITelO Vault SAT`.
    temp2-status = `delivery expected`.
    temp2-currencycode = `EUR`.
    temp2-price = '149'.
    temp2-width = `11`.
    temp2-depth = `1.7`.
    temp2-height = `18`.
    temp2-dimunit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    t_products = temp1.

    " availableState maps an already-classified Status to an InfoLabel colorScheme index - moved
    " from the original frontend Formatter.js to the ABAP backend (thin-frontend principle)
    
    
    LOOP AT t_products REFERENCE INTO lr_product.
      
      CASE to_lower( lr_product->status ).
        WHEN `available`.
          temp4 = 8.
        WHEN `sold out`.
          temp4 = 3.
        WHEN `delivery expected`.
          temp4 = 5.
        WHEN OTHERS.
          temp4 = 9.
      ENDCASE.
      lr_product->color_scheme = temp4.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
