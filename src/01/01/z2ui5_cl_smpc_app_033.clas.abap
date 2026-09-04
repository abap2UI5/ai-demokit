" @keywords link sap.m usually object identifier fir table toolbar title column text columnlistitem
" @summary Usually you use an Object Identifier in the first column of a table. But if you need an active identifier you should use an 'emphasized' link instead.
CLASS z2ui5_cl_smpc_app_033 DEFINITION PUBLIC.

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
        price           TYPE p LENGTH 14 DECIMALS 2,
        currency_code   TYPE string,
        product_pic_url TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_033 IMPLEMENTATION.

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
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->ele( `Table`
            )->a( n = `id`    v = `idProductsTable`
            )->a( n = `inset` v = `false`
            )->a( n = `items` v = |\{ path: '{ client->_bind_path( t_products ) }', sorter: \{ path: 'NAME' \} \}|

            )->ele( `headerToolbar`
                )->ele( `Toolbar`
                    )->tag( `Title`
                        )->a( n = `text`  v = `Products`
                        )->a( n = `level` v = `H2`

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
                )->ele( `Column`
                    )->a( n = `minScreenWidth` v = `Tablet`
                    )->a( n = `demandPopin`    v = `true`
                    )->a( n = `hAlign`         v = `End`

                    )->tag( `Text`
                        )->a( n = `text` v = `Weight`

                )->end(
                )->ele( `Column`
                    )->a( n = `hAlign` v = `End`

                    )->tag( `Text`
                        )->a( n = `text` v = `Price`

                )->end(
            )->end(

            )->ele( `items`
                )->ele( `ColumnListItem`
                    )->ele( `cells`
                        )->tag( `Link`
                            )->a( n = `text`       v = `{PRODUCT_ID}`
                            )->a( n = `emphasized` v = `true`
                            )->a( n = `href`       v = `{PRODUCT_PIC_URL}`
                        )->tag( `Text`
                            )->a( n = `text` v = `{SUPPLIER_NAME}`
                        )->tag( `Text`
                            )->a( n = `text` v = `{WIDTH} x {DEPTH} x {HEIGHT} {DIM_UNIT}`
                        )->tag( `ObjectNumber`
                            )->a( n = `number` v = `{WEIGHT_MEASURE}`
                            )->a( n = `unit`   v = `{WEIGHT_UNIT}`
                        )->tag( `ObjectNumber`
                            )->a( n = `number` v = |\{ parts:[\{path:'PRICE'\},\{path:'CURRENCY_CODE'\}], type:'sap.ui.model.type.Currency', formatOptions:\{showMeasure:false\} \}|
                            )->a( n = `unit`   v = `{CURRENCY_CODE}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " full mock /ProductCollection (sap/ui/demo/mock/products.json) of the original sample
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
    temp2-product_id = `HT-1002`.
    temp2-name = `Notebook Basic 18`.
    temp2-supplier_name = `Very Best Screens`.
    temp2-width = `28`.
    temp2-depth = `19`.
    temp2-height = `2.5`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `4.2`.
    temp2-weight_unit = `KG`.
    temp2-price = `1570.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1002.jpg`.
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
    temp2-product_id = `HT-1011`.
    temp2-name = `Notebook Professional 17`.
    temp2-supplier_name = `Very Best Screens`.
    temp2-width = `33`.
    temp2-depth = `23`.
    temp2-height = `2`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `4.1`.
    temp2-weight_unit = `KG`.
    temp2-price = `2299.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1011.jpg`.
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
    temp2-product_id = `HT-1021`.
    temp2-name = `ITelO Vault SAT`.
    temp2-supplier_name = `Technocom`.
    temp2-width = `11`.
    temp2-depth = `1.7`.
    temp2-height = `18`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.18`.
    temp2-weight_unit = `KG`.
    temp2-price = `149.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1021.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1022`.
    temp2-name = `Comfort Easy`.
    temp2-supplier_name = `Technocom`.
    temp2-width = `84`.
    temp2-depth = `1.5`.
    temp2-height = `14`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.2`.
    temp2-weight_unit = `KG`.
    temp2-price = `1679.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1022.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1023`.
    temp2-name = `Comfort Senior`.
    temp2-supplier_name = `Technocom`.
    temp2-width = `80`.
    temp2-depth = `1.6`.
    temp2-height = `13`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.8`.
    temp2-weight_unit = `KG`.
    temp2-price = `512.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1023.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1030`.
    temp2-name = `Ergo Screen E-I`.
    temp2-supplier_name = `Very Best Screens`.
    temp2-width = `37`.
    temp2-depth = `12`.
    temp2-height = `36`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `21`.
    temp2-weight_unit = `KG`.
    temp2-price = `230.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1030.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1031`.
    temp2-name = `Ergo Screen E-II`.
    temp2-supplier_name = `Very Best Screens`.
    temp2-width = `40.8`.
    temp2-depth = `19`.
    temp2-height = `43`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `21`.
    temp2-weight_unit = `KG`.
    temp2-price = `285.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1031.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1032`.
    temp2-name = `Ergo Screen E-III`.
    temp2-supplier_name = `Very Best Screens`.
    temp2-width = `40.8`.
    temp2-depth = `19`.
    temp2-height = `43`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `21`.
    temp2-weight_unit = `KG`.
    temp2-price = `345.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1032.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1035`.
    temp2-name = `Flat Basic`.
    temp2-supplier_name = `Very Best Screens`.
    temp2-width = `39`.
    temp2-depth = `20`.
    temp2-height = `41`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `14`.
    temp2-weight_unit = `KG`.
    temp2-price = `399.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1035.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1036`.
    temp2-name = `Flat Future`.
    temp2-supplier_name = `Very Best Screens`.
    temp2-width = `45`.
    temp2-depth = `26`.
    temp2-height = `46`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `15`.
    temp2-weight_unit = `KG`.
    temp2-price = `430.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1036.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1037`.
    temp2-name = `Flat XL`.
    temp2-supplier_name = `Very Best Screens`.
    temp2-width = `54.5`.
    temp2-depth = `22.1`.
    temp2-height = `39.1`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `17`.
    temp2-weight_unit = `KG`.
    temp2-price = `1230.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1037.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1040`.
    temp2-name = `Laser Professional Eco`.
    temp2-supplier_name = `Alpha Printers`.
    temp2-width = `51`.
    temp2-depth = `46`.
    temp2-height = `30`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `32`.
    temp2-weight_unit = `KG`.
    temp2-price = `830.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1040.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1041`.
    temp2-name = `Laser Basic`.
    temp2-supplier_name = `Alpha Printers`.
    temp2-width = `48`.
    temp2-depth = `42`.
    temp2-height = `26`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `23`.
    temp2-weight_unit = `KG`.
    temp2-price = `490.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1041.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1042`.
    temp2-name = `Laser Allround`.
    temp2-supplier_name = `Alpha Printers`.
    temp2-width = `53`.
    temp2-depth = `50`.
    temp2-height = `65`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `17`.
    temp2-weight_unit = `KG`.
    temp2-price = `349.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1042.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1050`.
    temp2-name = `Ultra Jet Super Color`.
    temp2-supplier_name = `Alpha Printers`.
    temp2-width = `41`.
    temp2-depth = `41`.
    temp2-height = `28`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `3`.
    temp2-weight_unit = `KG`.
    temp2-price = `139.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1050.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1051`.
    temp2-name = `Ultra Jet Mobile`.
    temp2-supplier_name = `Printer for All`.
    temp2-width = `46`.
    temp2-depth = `32`.
    temp2-height = `25`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `1.9`.
    temp2-weight_unit = `KG`.
    temp2-price = `99.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1051.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1052`.
    temp2-name = `Ultra Jet Super Highspeed`.
    temp2-supplier_name = `Printer for All`.
    temp2-width = `41`.
    temp2-depth = `41`.
    temp2-height = `28`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `18`.
    temp2-weight_unit = `KG`.
    temp2-price = `170.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1052.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1055`.
    temp2-name = `Multi Print`.
    temp2-supplier_name = `Printer for All`.
    temp2-width = `55`.
    temp2-depth = `45`.
    temp2-height = `29`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `6.3`.
    temp2-weight_unit = `KG`.
    temp2-price = `99.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1055.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1056`.
    temp2-name = `Multi Color`.
    temp2-supplier_name = `Printer for All`.
    temp2-width = `51`.
    temp2-depth = `41.3`.
    temp2-height = `22`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `4.3`.
    temp2-weight_unit = `KG`.
    temp2-price = `119.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1056.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1060`.
    temp2-name = `Cordless Mouse`.
    temp2-supplier_name = `Oxynum`.
    temp2-width = `6`.
    temp2-depth = `14.5`.
    temp2-height = `3.5`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.09`.
    temp2-weight_unit = `KG`.
    temp2-price = `9.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1060.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1061`.
    temp2-name = `Speed Mouse`.
    temp2-supplier_name = `Oxynum`.
    temp2-width = `7`.
    temp2-depth = `15`.
    temp2-height = `3.1`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.09`.
    temp2-weight_unit = `KG`.
    temp2-price = `7.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1061.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1062`.
    temp2-name = `Track Mouse`.
    temp2-supplier_name = `Oxynum`.
    temp2-width = `3`.
    temp2-depth = `7`.
    temp2-height = `4`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.03`.
    temp2-weight_unit = `KG`.
    temp2-price = `11.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1062.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1063`.
    temp2-name = `Ergonomic Keyboard`.
    temp2-supplier_name = `Oxynum`.
    temp2-width = `50`.
    temp2-depth = `21`.
    temp2-height = `3.5`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `2.1`.
    temp2-weight_unit = `KG`.
    temp2-price = `14.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1063.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1064`.
    temp2-name = `Internet Keyboard`.
    temp2-supplier_name = `Oxynum`.
    temp2-width = `52`.
    temp2-depth = `25`.
    temp2-height = `3`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `1.8`.
    temp2-weight_unit = `KG`.
    temp2-price = `16.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1064.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1065`.
    temp2-name = `Media Keyboard`.
    temp2-supplier_name = `Oxynum`.
    temp2-width = `51.4`.
    temp2-depth = `23`.
    temp2-height = `4`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `2.3`.
    temp2-weight_unit = `KG`.
    temp2-price = `26.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1065.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1066`.
    temp2-name = `Mousepad`.
    temp2-supplier_name = `Oxynum`.
    temp2-width = `15`.
    temp2-depth = `6`.
    temp2-height = `0.2`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `80`.
    temp2-weight_unit = `G`.
    temp2-price = `6.99`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1066.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1067`.
    temp2-name = `Ergo Mousepad`.
    temp2-supplier_name = `Oxynum`.
    temp2-width = `15`.
    temp2-depth = `6`.
    temp2-height = `0.2`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `80`.
    temp2-weight_unit = `G`.
    temp2-price = `8.99`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1067.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1068`.
    temp2-name = `Designer Mousepad`.
    temp2-supplier_name = `Fasttech`.
    temp2-width = `24`.
    temp2-depth = `24`.
    temp2-height = `0.6`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `90`.
    temp2-weight_unit = `G`.
    temp2-price = `12.99`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1068.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1069`.
    temp2-name = `Universal card reader`.
    temp2-supplier_name = `Fasttech`.
    temp2-width = `6`.
    temp2-depth = `6`.
    temp2-height = `3`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `45`.
    temp2-weight_unit = `G`.
    temp2-price = `14.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1069.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1070`.
    temp2-name = `Proctra X`.
    temp2-supplier_name = `Ultrasonic United`.
    temp2-width = `22`.
    temp2-depth = `35`.
    temp2-height = `17`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.255`.
    temp2-weight_unit = `KG`.
    temp2-price = `70.90`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1070.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1071`.
    temp2-name = `Gladiator MX`.
    temp2-supplier_name = `Ultrasonic United`.
    temp2-width = `22`.
    temp2-depth = `35`.
    temp2-height = `17`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.3`.
    temp2-weight_unit = `KG`.
    temp2-price = `81.70`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1071.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1072`.
    temp2-name = `Hurricane GX`.
    temp2-supplier_name = `Ultrasonic United`.
    temp2-width = `22`.
    temp2-depth = `35`.
    temp2-height = `17`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.4`.
    temp2-weight_unit = `KG`.
    temp2-price = `101.20`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1072.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1073`.
    temp2-name = `Hurricane GX/LN`.
    temp2-supplier_name = `Smartcards`.
    temp2-width = `22`.
    temp2-depth = `35`.
    temp2-height = `17`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.4`.
    temp2-weight_unit = `KG`.
    temp2-price = `139.99`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1073.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1080`.
    temp2-name = `Photo Scan`.
    temp2-supplier_name = `Printer for All`.
    temp2-width = `34`.
    temp2-depth = `48`.
    temp2-height = `5`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `2.3`.
    temp2-weight_unit = `KG`.
    temp2-price = `129.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1080.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1081`.
    temp2-name = `Power Scan`.
    temp2-supplier_name = `Printer for All`.
    temp2-width = `31`.
    temp2-depth = `43`.
    temp2-height = `7`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `2.4`.
    temp2-weight_unit = `KG`.
    temp2-price = `89.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1081.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1082`.
    temp2-name = `Jet Scan Professional`.
    temp2-supplier_name = `Printer for All`.
    temp2-width = `33`.
    temp2-depth = `41`.
    temp2-height = `12`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `3.2`.
    temp2-weight_unit = `KG`.
    temp2-price = `169.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1082.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1083`.
    temp2-name = `Jet Scan Professional`.
    temp2-supplier_name = `Printer for All`.
    temp2-width = `35`.
    temp2-depth = `40`.
    temp2-height = `10`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `3.2`.
    temp2-weight_unit = `KG`.
    temp2-price = `189.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1083.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1085`.
    temp2-name = `Copymaster`.
    temp2-supplier_name = `Alpha Printers`.
    temp2-width = `45`.
    temp2-depth = `42`.
    temp2-height = `22`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `23.2`.
    temp2-weight_unit = `KG`.
    temp2-price = `1499.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1085.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1090`.
    temp2-name = `Surround Sound`.
    temp2-supplier_name = `Speaker Experts`.
    temp2-width = `12`.
    temp2-depth = `10`.
    temp2-height = `16`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `3`.
    temp2-weight_unit = `KG`.
    temp2-price = `39.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1090.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1091`.
    temp2-name = `Blaster Extreme`.
    temp2-supplier_name = `Speaker Experts`.
    temp2-width = `13`.
    temp2-depth = `11`.
    temp2-height = `17.5`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `1.4`.
    temp2-weight_unit = `KG`.
    temp2-price = `26.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1091.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1092`.
    temp2-name = `Sound Booster`.
    temp2-supplier_name = `Speaker Experts`.
    temp2-width = `12.4`.
    temp2-depth = `10.4`.
    temp2-height = `18.1`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `2.1`.
    temp2-weight_unit = `KG`.
    temp2-price = `45.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1092.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1095`.
    temp2-name = `Lovely Sound 5.1 Wireless`.
    temp2-supplier_name = `Fasttech`.
    temp2-width = `24`.
    temp2-depth = `19`.
    temp2-height = `23`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `80`.
    temp2-weight_unit = `G`.
    temp2-price = `49.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1095.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1096`.
    temp2-name = `Lovely Sound 5.1`.
    temp2-supplier_name = `Fasttech`.
    temp2-width = `25`.
    temp2-depth = `17`.
    temp2-height = `19`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `130`.
    temp2-weight_unit = `G`.
    temp2-price = `39.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1096.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1097`.
    temp2-name = `Lovely Sound Stereo`.
    temp2-supplier_name = `Fasttech`.
    temp2-width = `21.3`.
    temp2-depth = `2.4`.
    temp2-height = `19.7`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `60`.
    temp2-weight_unit = `G`.
    temp2-price = `29.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1097.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1100`.
    temp2-name = `Smart Office`.
    temp2-supplier_name = `Technocom`.
    temp2-width = `15`.
    temp2-depth = `6.5`.
    temp2-height = `2.1`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `1.2`.
    temp2-weight_unit = `KG`.
    temp2-price = `89.90`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1100.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1101`.
    temp2-name = `Smart Design`.
    temp2-supplier_name = `Technocom`.
    temp2-width = `14`.
    temp2-depth = `6.7`.
    temp2-height = `24`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.8`.
    temp2-weight_unit = `KG`.
    temp2-price = `79.90`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1101.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1102`.
    temp2-name = `Smart Network`.
    temp2-supplier_name = `Technocom`.
    temp2-width = `16`.
    temp2-depth = `6`.
    temp2-height = `27`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.8`.
    temp2-weight_unit = `KG`.
    temp2-price = `69.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1102.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1103`.
    temp2-name = `Smart Multimedia`.
    temp2-supplier_name = `Technocom`.
    temp2-width = `11`.
    temp2-depth = `3.4`.
    temp2-height = `22`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.8`.
    temp2-weight_unit = `KG`.
    temp2-price = `77.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1103.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1104`.
    temp2-name = `Smart Games`.
    temp2-supplier_name = `Technocom`.
    temp2-width = `10`.
    temp2-depth = `3`.
    temp2-height = `30`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `1.1`.
    temp2-weight_unit = `KG`.
    temp2-price = `55.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1104.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1105`.
    temp2-name = `Smart Internet Antivirus`.
    temp2-supplier_name = `Brainsoft`.
    temp2-width = `16`.
    temp2-depth = `4`.
    temp2-height = `21`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.7`.
    temp2-weight_unit = `KG`.
    temp2-price = `29.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1105.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1106`.
    temp2-name = `Smart Firewall`.
    temp2-supplier_name = `Brainsoft`.
    temp2-width = `17.9`.
    temp2-depth = `4.2`.
    temp2-height = `23.1`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.9`.
    temp2-weight_unit = `KG`.
    temp2-price = `34.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1106.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1107`.
    temp2-name = `Smart Money`.
    temp2-supplier_name = `Brainsoft`.
    temp2-width = `12`.
    temp2-depth = `1.5`.
    temp2-height = `19`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.5`.
    temp2-weight_unit = `KG`.
    temp2-price = `29.90`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1107.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1110`.
    temp2-name = `PC Lock`.
    temp2-supplier_name = `Red Point Stores`.
    temp2-width = `20`.
    temp2-depth = `8`.
    temp2-height = `4.3`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.03`.
    temp2-weight_unit = `KG`.
    temp2-price = `8.90`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1110.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1111`.
    temp2-name = `Notebook Lock`.
    temp2-supplier_name = `Red Point Stores`.
    temp2-width = `31`.
    temp2-depth = `9`.
    temp2-height = `7`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.02`.
    temp2-weight_unit = `KG`.
    temp2-price = `6.90`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1111.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1112`.
    temp2-name = `Web cam reality`.
    temp2-supplier_name = `Red Point Stores`.
    temp2-width = `9`.
    temp2-depth = `8.2`.
    temp2-height = `1.3`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.075`.
    temp2-weight_unit = `KG`.
    temp2-price = `39.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1112.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1113`.
    temp2-name = `Screen clean`.
    temp2-supplier_name = `Red Point Stores`.
    temp2-width = `2`.
    temp2-depth = `2`.
    temp2-height = `0.1`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.05`.
    temp2-weight_unit = `KG`.
    temp2-price = `2.30`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1113.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1114`.
    temp2-name = `Fabric bag professional`.
    temp2-supplier_name = `Red Point Stores`.
    temp2-width = `42`.
    temp2-depth = `32`.
    temp2-height = `7`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `1.8`.
    temp2-weight_unit = `KG`.
    temp2-price = `31.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1114.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1115`.
    temp2-name = `Wireless DSL Router`.
    temp2-supplier_name = `Red Point Stores`.
    temp2-width = `19.3`.
    temp2-depth = `18`.
    temp2-height = `5`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.45`.
    temp2-weight_unit = `KG`.
    temp2-price = `49.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1115.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1116`.
    temp2-name = `Wireless DSL Router / Repeater`.
    temp2-supplier_name = `Red Point Stores`.
    temp2-width = `19.3`.
    temp2-depth = `18`.
    temp2-height = `5`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.45`.
    temp2-weight_unit = `KG`.
    temp2-price = `59.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1116.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1117`.
    temp2-name = `Wireless DSL Router / Repeater and Print Server`.
    temp2-supplier_name = `Technocom`.
    temp2-width = `19.3`.
    temp2-depth = `18`.
    temp2-height = `5`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.45`.
    temp2-weight_unit = `KG`.
    temp2-price = `69.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1117.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1118`.
    temp2-name = `USB Stick`.
    temp2-supplier_name = `Technocom`.
    temp2-width = `1.5`.
    temp2-depth = `8.7`.
    temp2-height = `1.2`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.015`.
    temp2-weight_unit = `KG`.
    temp2-price = `35.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1118.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1119`.
    temp2-name = `Travel Adapter`.
    temp2-supplier_name = `Titanium`.
    temp2-width = `2`.
    temp2-depth = `3.1`.
    temp2-height = `3.9`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `88`.
    temp2-weight_unit = `G`.
    temp2-price = `79.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1119.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1120`.
    temp2-name = `Cordless Bluetooth Keyboard, english international`.
    temp2-supplier_name = `Technocom`.
    temp2-width = `51.4`.
    temp2-depth = `23`.
    temp2-height = `4`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `1`.
    temp2-weight_unit = `KG`.
    temp2-price = `29.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1120.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1137`.
    temp2-name = `Flat XXL`.
    temp2-supplier_name = `Technocom`.
    temp2-width = `54`.
    temp2-depth = `22`.
    temp2-height = `38`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `18`.
    temp2-weight_unit = `KG`.
    temp2-price = `1430.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1137.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1138`.
    temp2-name = `Pocket Mouse`.
    temp2-supplier_name = `Technocom`.
    temp2-width = `0.3`.
    temp2-depth = `0.5`.
    temp2-height = `1`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.02`.
    temp2-weight_unit = `KG`.
    temp2-price = `23.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1138.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1210`.
    temp2-name = `PC Power Station`.
    temp2-supplier_name = `Technocom`.
    temp2-width = `28`.
    temp2-depth = `31`.
    temp2-height = `43`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `2.3`.
    temp2-weight_unit = `KG`.
    temp2-price = `2399.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1210.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1251`.
    temp2-name = `Astro Laptop 1516`.
    temp2-supplier_name = `Ultrasonic United`.
    temp2-width = `30`.
    temp2-depth = `18`.
    temp2-height = `3`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `4.2`.
    temp2-weight_unit = `KG`.
    temp2-price = `989.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1251.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1252`.
    temp2-name = `Astro Phone 6`.
    temp2-supplier_name = `Ultrasonic United`.
    temp2-width = `8`.
    temp2-depth = `6`.
    temp2-height = `1.5`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.75`.
    temp2-weight_unit = `KG`.
    temp2-price = `649.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1252.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1253`.
    temp2-name = `Benda Laptop 1408`.
    temp2-supplier_name = `Ultrasonic United`.
    temp2-width = `30`.
    temp2-depth = `18`.
    temp2-height = `3`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `4.2`.
    temp2-weight_unit = `KG`.
    temp2-price = `976.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1253.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1254`.
    temp2-name = `Bending Screen 21HD`.
    temp2-supplier_name = `Ultrasonic United`.
    temp2-width = `37`.
    temp2-depth = `12`.
    temp2-height = `36`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `15`.
    temp2-weight_unit = `KG`.
    temp2-price = `250.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1254.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1255`.
    temp2-name = `Broad Screen 22HD`.
    temp2-supplier_name = `Ultrasonic United`.
    temp2-width = `39`.
    temp2-depth = `12`.
    temp2-height = `38`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `16`.
    temp2-weight_unit = `KG`.
    temp2-price = `270.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1255.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1256`.
    temp2-name = `Cerdik Phone 7`.
    temp2-supplier_name = `Ultrasonic United`.
    temp2-width = `9`.
    temp2-depth = `15`.
    temp2-height = `1.5`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.75`.
    temp2-weight_unit = `KG`.
    temp2-price = `549.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1256.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1257`.
    temp2-name = `Cepat Tablet 10.5`.
    temp2-supplier_name = `Ultrasonic United`.
    temp2-width = `48`.
    temp2-depth = `31`.
    temp2-height = `4.5`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `2.8`.
    temp2-weight_unit = `KG`.
    temp2-price = `549.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1257.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1258`.
    temp2-name = `Cepat Tablet 8`.
    temp2-supplier_name = `Ultrasonic United`.
    temp2-width = `38`.
    temp2-depth = `21`.
    temp2-height = `3.5`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `2.5`.
    temp2-weight_unit = `KG`.
    temp2-price = `529.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1258.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1500`.
    temp2-name = `Server Basic`.
    temp2-supplier_name = `Technocom`.
    temp2-width = `34`.
    temp2-depth = `35`.
    temp2-height = `23`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `18`.
    temp2-weight_unit = `KG`.
    temp2-price = `5000.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1500.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1501`.
    temp2-name = `Server Professional`.
    temp2-supplier_name = `Technocom`.
    temp2-width = `29`.
    temp2-depth = `30`.
    temp2-height = `27`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `25`.
    temp2-weight_unit = `KG`.
    temp2-price = `15000.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1501.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1502`.
    temp2-name = `Server Power Pro`.
    temp2-supplier_name = `Technocom`.
    temp2-width = `22`.
    temp2-depth = `27.3`.
    temp2-height = `37`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `35`.
    temp2-weight_unit = `KG`.
    temp2-price = `25000.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1502.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1600`.
    temp2-name = `Family PC Basic`.
    temp2-supplier_name = `Titanium`.
    temp2-width = `21.4`.
    temp2-depth = `29`.
    temp2-height = `38`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `4.8`.
    temp2-weight_unit = `KG`.
    temp2-price = `600.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1600.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1601`.
    temp2-name = `Family PC Pro`.
    temp2-supplier_name = `Titanium`.
    temp2-width = `25`.
    temp2-depth = `31.7`.
    temp2-height = `40.2`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `5.3`.
    temp2-weight_unit = `KG`.
    temp2-price = `900.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1601.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1602`.
    temp2-name = `Gaming Monster`.
    temp2-supplier_name = `Titanium`.
    temp2-width = `26.5`.
    temp2-depth = `34`.
    temp2-height = `47`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `5.9`.
    temp2-weight_unit = `KG`.
    temp2-price = `1200.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1602.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1603`.
    temp2-name = `Gaming Monster Pro`.
    temp2-supplier_name = `Titanium`.
    temp2-width = `27`.
    temp2-depth = `28`.
    temp2-height = `42`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `6.8`.
    temp2-weight_unit = `KG`.
    temp2-price = `1700.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1603.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-2000`.
    temp2-name = `7" Widescreen Portable DVD Player w MP3`.
    temp2-supplier_name = `Titanium`.
    temp2-width = `21.4`.
    temp2-depth = `19`.
    temp2-height = `27.6`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.79`.
    temp2-weight_unit = `KG`.
    temp2-price = `249.99`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2000.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-2001`.
    temp2-name = `10" Portable DVD player`.
    temp2-supplier_name = `Titanium`.
    temp2-width = `24`.
    temp2-depth = `19.5`.
    temp2-height = `29`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.84`.
    temp2-weight_unit = `KG`.
    temp2-price = `449.99`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2001.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-2002`.
    temp2-name = `Portable DVD Player with 9" LCD Monitor`.
    temp2-supplier_name = `Technocom`.
    temp2-width = `21`.
    temp2-depth = `16.5`.
    temp2-height = `14`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.72`.
    temp2-weight_unit = `KG`.
    temp2-price = `853.99`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2002.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-2025`.
    temp2-name = `CD/DVD case: 264 sleeves`.
    temp2-supplier_name = `Titanium`.
    temp2-width = `13`.
    temp2-depth = `13`.
    temp2-height = `20`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.65`.
    temp2-weight_unit = `KG`.
    temp2-price = `44.99`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2025.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-2026`.
    temp2-name = `Audio/Video Cable Kit - 4m`.
    temp2-supplier_name = `Titanium`.
    temp2-width = `21`.
    temp2-depth = `10.2`.
    temp2-height = `13`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.2`.
    temp2-weight_unit = `KG`.
    temp2-price = `29.99`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2026.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-2027`.
    temp2-name = `Removable CD/DVD Laser Labels`.
    temp2-supplier_name = `Titanium`.
    temp2-width = `5.5`.
    temp2-depth = `2`.
    temp2-height = `2`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.15`.
    temp2-weight_unit = `KG`.
    temp2-price = `8.99`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2027.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-6100`.
    temp2-name = `Beam Breaker B-1`.
    temp2-supplier_name = `Titanium`.
    temp2-width = `30.4`.
    temp2-depth = `23.1`.
    temp2-height = `23`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `1.7`.
    temp2-weight_unit = `KG`.
    temp2-price = `469.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6100.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-6101`.
    temp2-name = `Beam Breaker B-2`.
    temp2-supplier_name = `Technocom`.
    temp2-width = `30.4`.
    temp2-depth = `23.1`.
    temp2-height = `23`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `2`.
    temp2-weight_unit = `KG`.
    temp2-price = `679.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6101.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-6102`.
    temp2-name = `Beam Breaker B-3`.
    temp2-supplier_name = `Technocom`.
    temp2-width = `30.4`.
    temp2-depth = `23.1`.
    temp2-height = `23`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `2.5`.
    temp2-weight_unit = `KG`.
    temp2-price = `889.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6102.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-6110`.
    temp2-name = `Play Movie`.
    temp2-supplier_name = `Fasttech`.
    temp2-width = `37`.
    temp2-depth = `24`.
    temp2-height = `6`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `2.4`.
    temp2-weight_unit = `KG`.
    temp2-price = `130.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6110.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-6111`.
    temp2-name = `Record Movie`.
    temp2-supplier_name = `Fasttech`.
    temp2-width = `38`.
    temp2-depth = `26`.
    temp2-height = `6.2`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `3.1`.
    temp2-weight_unit = `KG`.
    temp2-price = `288.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6111.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-6120`.
    temp2-name = `ITelo MusicStick`.
    temp2-supplier_name = `Fasttech`.
    temp2-width = `1.5`.
    temp2-depth = `6`.
    temp2-height = `1`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `134`.
    temp2-weight_unit = `G`.
    temp2-price = `45.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6120.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-6121`.
    temp2-name = `ITelo Jog-Mate`.
    temp2-supplier_name = `Fasttech`.
    temp2-width = `5.1`.
    temp2-depth = `8`.
    temp2-height = `9.2`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `134`.
    temp2-weight_unit = `G`.
    temp2-price = `63.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6121.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-6122`.
    temp2-name = `Power Pro Player 40`.
    temp2-supplier_name = `Fasttech`.
    temp2-width = `5.1`.
    temp2-depth = `8`.
    temp2-height = `9.2`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `266`.
    temp2-weight_unit = `G`.
    temp2-price = `167.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6122.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-6123`.
    temp2-name = `Power Pro Player 80`.
    temp2-supplier_name = `Fasttech`.
    temp2-width = `4`.
    temp2-depth = `6`.
    temp2-height = `0.8`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `267`.
    temp2-weight_unit = `G`.
    temp2-price = `299.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6123.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-6130`.
    temp2-name = `Flat Watch HD32`.
    temp2-supplier_name = `Very Best Screens`.
    temp2-width = `78`.
    temp2-depth = `22.1`.
    temp2-height = `55`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `2.6`.
    temp2-weight_unit = `KG`.
    temp2-price = `1459.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6130.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-6131`.
    temp2-name = `Flat Watch HD37`.
    temp2-supplier_name = `Very Best Screens`.
    temp2-width = `99.1`.
    temp2-depth = `26`.
    temp2-height = `61`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `2.2`.
    temp2-weight_unit = `KG`.
    temp2-price = `1199.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6131.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-6132`.
    temp2-name = `Flat Watch HD41`.
    temp2-supplier_name = `Very Best Screens`.
    temp2-width = `128`.
    temp2-depth = `23`.
    temp2-height = `79.1`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `1.8`.
    temp2-weight_unit = `KG`.
    temp2-price = `899.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6132.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-7000`.
    temp2-name = `Copperberry`.
    temp2-supplier_name = `Fasttech`.
    temp2-width = `8.1`.
    temp2-depth = `13`.
    temp2-height = `12.1`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.5`.
    temp2-weight_unit = `KG`.
    temp2-price = `549.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7000.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-7010`.
    temp2-name = `Silverberry`.
    temp2-supplier_name = `Fasttech`.
    temp2-width = `8.1`.
    temp2-depth = `13`.
    temp2-height = `12.1`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.5`.
    temp2-weight_unit = `KG`.
    temp2-price = `549.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7010.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-7020`.
    temp2-name = `Goldberry`.
    temp2-supplier_name = `Fasttech`.
    temp2-width = `8.1`.
    temp2-depth = `13`.
    temp2-height = `12.1`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.5`.
    temp2-weight_unit = `KG`.
    temp2-price = `549.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7020.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-7030`.
    temp2-name = `Platinberry`.
    temp2-supplier_name = `Fasttech`.
    temp2-width = `8.1`.
    temp2-depth = `13`.
    temp2-height = `12.1`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.5`.
    temp2-weight_unit = `KG`.
    temp2-price = `549.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7030.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-8000`.
    temp2-name = `ITelO FlexTop I4000`.
    temp2-supplier_name = `Titanium`.
    temp2-width = `31`.
    temp2-depth = `19`.
    temp2-height = `3.1`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `4`.
    temp2-weight_unit = `KG`.
    temp2-price = `799.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8000.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-8001`.
    temp2-name = `ITelO FlexTop I6300c`.
    temp2-supplier_name = `Titanium`.
    temp2-width = `32`.
    temp2-depth = `20`.
    temp2-height = `3.4`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `4.2`.
    temp2-weight_unit = `KG`.
    temp2-price = `799.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8001.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-8002`.
    temp2-name = `ITelO FlexTop I9100`.
    temp2-supplier_name = `Titanium`.
    temp2-width = `38`.
    temp2-depth = `21`.
    temp2-height = `4.1`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `3.5`.
    temp2-weight_unit = `KG`.
    temp2-price = `1199.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8002.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-8003`.
    temp2-name = `ITelO FlexTop I9800`.
    temp2-supplier_name = `Titanium`.
    temp2-width = `48`.
    temp2-depth = `31`.
    temp2-height = `4.5`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `3.8`.
    temp2-weight_unit = `KG`.
    temp2-price = `1388.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8003.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-9991`.
    temp2-name = `Smartphone Leather Case`.
    temp2-supplier_name = `Ultrasonic United`.
    temp2-width = `48`.
    temp2-depth = `31`.
    temp2-height = `4.5`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.02`.
    temp2-weight_unit = `KG`.
    temp2-price = `25.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9991.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-9992`.
    temp2-name = `Smartphone Alpha`.
    temp2-supplier_name = `Ultrasonic United`.
    temp2-width = `48`.
    temp2-depth = `31`.
    temp2-height = `4.5`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.75`.
    temp2-weight_unit = `KG`.
    temp2-price = `599.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9992.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-9993`.
    temp2-name = `Mini Tablet`.
    temp2-supplier_name = `Ultrasonic United`.
    temp2-width = `48`.
    temp2-depth = `31`.
    temp2-height = `4.5`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `3.8`.
    temp2-weight_unit = `KG`.
    temp2-price = `833.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9993.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-9994`.
    temp2-name = `Camcorder View`.
    temp2-supplier_name = `Ultrasonic United`.
    temp2-width = `48`.
    temp2-depth = `31`.
    temp2-height = `27`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `3.8`.
    temp2-weight_unit = `KG`.
    temp2-price = `1388.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9994.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-9995`.
    temp2-name = `Tablet Pouch`.
    temp2-supplier_name = `Titanium`.
    temp2-width = `25`.
    temp2-depth = `40`.
    temp2-height = `4.5`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.03`.
    temp2-weight_unit = `KG`.
    temp2-price = `20.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9995.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-9996`.
    temp2-name = `Tablet Pouch`.
    temp2-supplier_name = `Titanium`.
    temp2-width = `25`.
    temp2-depth = `40`.
    temp2-height = `4.5`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.03`.
    temp2-weight_unit = `KG`.
    temp2-price = `20.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9996.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-9997`.
    temp2-name = `e-Book Reader ReadMe`.
    temp2-supplier_name = `Titanium`.
    temp2-width = `48`.
    temp2-depth = `31`.
    temp2-height = `4.5`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `3.8`.
    temp2-weight_unit = `KG`.
    temp2-price = `33.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9997.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-9998`.
    temp2-name = `Smartphone Beta`.
    temp2-supplier_name = `Titanium`.
    temp2-width = `48`.
    temp2-depth = `31`.
    temp2-height = `4.5`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.75`.
    temp2-weight_unit = `KG`.
    temp2-price = `30.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9998.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-9999`.
    temp2-name = `Maxi Tablet`.
    temp2-supplier_name = `Titanium`.
    temp2-width = `48`.
    temp2-depth = `31`.
    temp2-height = `4.5`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `3.8`.
    temp2-weight_unit = `KG`.
    temp2-price = `749.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9999.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `PF-1000`.
    temp2-name = `Flyer`.
    temp2-supplier_name = `Titanium`.
    temp2-width = `46`.
    temp2-depth = `30`.
    temp2-height = `3`.
    temp2-dim_unit = `cm`.
    temp2-weight_measure = `0.01`.
    temp2-weight_unit = `KG`.
    temp2-price = `0.00`.
    temp2-currency_code = `EUR`.
    temp2-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/PF-1000.jpg`.
    INSERT temp2 INTO TABLE temp1.
    t_products = temp1.

  ENDMETHOD.

ENDCLASS.
