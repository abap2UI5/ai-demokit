CLASS z2ui5_cl_api_app_440 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        product_id      TYPE string,
        name            TYPE string,
        supplier_name   TYPE string,
        width           TYPE string,
        depth           TYPE string,
        height          TYPE string,
        dim_unit        TYPE string,
        weight_measure  TYPE string,
        weight_unit     TYPE string,
        price           TYPE string,
        currency_code   TYPE string,
        product_pic_url TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS model_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_440 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    DATA temp1 LIKE t_products.
    DATA temp2 LIKE LINE OF temp1.
    CLEAR temp1.
    
    temp2-product_id = `HT-1000`.
    temp2-name = `Notebook Basic 15`.
    temp2-supplier_name = `Very Best Screens`.
    temp2-width = `30`.
    temp2-depth = `18`.
    temp2-height = `3`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `4.2`.
    temp2-weight_unit = `KG`.
    temp2-price = `956.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1001`.
    temp2-name = `Notebook Basic 17`.
    temp2-supplier_name = `Very Best Screens`.
    temp2-width = `29`.
    temp2-depth = `17`.
    temp2-height = `3.1`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `4.5`.
    temp2-weight_unit = `KG`.
    temp2-price = `1249.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1001.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1003`.
    temp2-name = `Notebook Basic 19`.
    temp2-supplier_name = `Smartcards`.
    temp2-width = `32`.
    temp2-depth = `21`.
    temp2-height = `4`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `4.2`.
    temp2-weight_unit = `KG`.
    temp2-price = `1650.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1003.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1007`.
    temp2-name = `ITelO Vault`.
    temp2-supplier_name = `Technocom`.
    temp2-width = `32`.
    temp2-depth = `22`.
    temp2-height = `3`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.2`.
    temp2-weight_unit = `KG`.
    temp2-price = `299.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1007.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1010`.
    temp2-name = `Notebook Professional 15`.
    temp2-supplier_name = `Very Best Screens`.
    temp2-width = `33`.
    temp2-depth = `20`.
    temp2-height = `3`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `4.3`.
    temp2-weight_unit = `KG`.
    temp2-price = `1999.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1020`.
    temp2-name = `ITelO Vault Net`.
    temp2-supplier_name = `Technocom`.
    temp2-width = `10`.
    temp2-depth = `1.8`.
    temp2-height = `17`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.16`.
    temp2-weight_unit = `KG`.
    temp2-price = `459.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1020.jpg`.
    INSERT temp2 INTO TABLE temp1.
    t_products = temp1.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_api_xml.
    view = z2ui5_cl_api_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->open( `Table`
            )->a( n = `id`    v = `idProductsTable`
            )->a( n = `inset` v = `false`
            )->a( n = `items` v = |\{ path: '{ client->_bind_edit( val = t_products path = abap_true ) }', sorter: \{ path: 'NAME' \} \}|

            )->open( `headerToolbar`
                )->open( `Toolbar`
                    )->leaf( `Title`
                        )->a( n = `text`  v = `Products`
                        )->a( n = `level` v = `H2`

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
                    )->a( n = `minScreenWidth` v = `Tablet`
                    )->a( n = `demandPopin`    v = `true`
                    )->a( n = `hAlign`         v = `End`

                    )->leaf( `Text`
                        )->a( n = `text` v = `Dimensions`

                )->shut(
                )->open( `Column`
                    )->a( n = `minScreenWidth` v = `Tablet`
                    )->a( n = `demandPopin`    v = `true`
                    )->a( n = `hAlign`         v = `End`

                    )->leaf( `Text`
                        )->a( n = `text` v = `Weight`

                )->shut(
                )->open( `Column`
                    )->a( n = `hAlign` v = `End`

                    )->leaf( `Text`
                        )->a( n = `text` v = `Price`

                )->shut(
            )->shut(

            )->open( `items`
                )->open( `ColumnListItem`
                    )->open( `cells`
                        )->leaf( `Link`
                            )->a( n = `text`       v = `{PRODUCT_ID}`
                            )->a( n = `emphasized` v = `true`
                            )->a( n = `href`       v = `{PRODUCT_PIC_URL}`
                        )->leaf( `Text`
                            )->a( n = `text` v = `{SUPPLIER_NAME}`
                        )->leaf( `Text`
                            )->a( n = `text` v = `{WIDTH} x {DEPTH} x {HEIGHT} {DIM_UNIT}`
                        )->leaf( `ObjectNumber`
                            )->a( n = `number` v = `{WEIGHT_MEASURE}`
                            )->a( n = `unit`   v = `{WEIGHT_UNIT}`
                        )->leaf( `ObjectNumber`
                            )->a( n = `number` v = `{PRICE}`
                            )->a( n = `unit`   v = `{CURRENCY_CODE}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
