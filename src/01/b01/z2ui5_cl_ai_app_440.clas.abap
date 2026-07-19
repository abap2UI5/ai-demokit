CLASS z2ui5_cl_ai_app_440 DEFINITION PUBLIC.

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
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS model_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_440 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    t_products = VALUE #(
        ( product_id      = `HT-1000`
          name            = `Notebook Basic 15`
          supplier_name   = `Very Best Screens`
          width           = `30`
          depth           = `18`
          height          = `3`
          dim_unit        = `cm`
          weight_measure  = `4.2`
          weight_unit     = `KG`
          price           = `956.00`
          currency_code   = `EUR`
          product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg` )
        ( product_id      = `HT-1001`
          name            = `Notebook Basic 17`
          supplier_name   = `Very Best Screens`
          width           = `29`
          depth           = `17`
          height          = `3.1`
          dim_unit        = `cm`
          weight_measure  = `4.5`
          weight_unit     = `KG`
          price           = `1249.00`
          currency_code   = `EUR`
          product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1001.jpg` )
        ( product_id      = `HT-1003`
          name            = `Notebook Basic 19`
          supplier_name   = `Smartcards`
          width           = `32`
          depth           = `21`
          height          = `4`
          dim_unit        = `cm`
          weight_measure  = `4.2`
          weight_unit     = `KG`
          price           = `1650.00`
          currency_code   = `EUR`
          product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1003.jpg` )
        ( product_id      = `HT-1007`
          name            = `ITelO Vault`
          supplier_name   = `Technocom`
          width           = `32`
          depth           = `22`
          height          = `3`
          dim_unit        = `cm`
          weight_measure  = `0.2`
          weight_unit     = `KG`
          price           = `299.00`
          currency_code   = `EUR`
          product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1007.jpg` )
        ( product_id      = `HT-1010`
          name            = `Notebook Professional 15`
          supplier_name   = `Very Best Screens`
          width           = `33`
          depth           = `20`
          height          = `3`
          dim_unit        = `cm`
          weight_measure  = `4.3`
          weight_unit     = `KG`
          price           = `1999.00`
          currency_code   = `EUR`
          product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg` )
        ( product_id      = `HT-1020`
          name            = `ITelO Vault Net`
          supplier_name   = `Technocom`
          width           = `10`
          depth           = `1.8`
          height          = `17`
          dim_unit        = `cm`
          weight_measure  = `0.16`
          weight_unit     = `KG`
          price           = `459.00`
          currency_code   = `EUR`
          product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1020.jpg` ) ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->open( `Table`
            )->a( n = `id`    v = `idProductsTable`
            )->a( n = `inset` v = `false`
            )->a( n = `items` v = |\{ path: '{ client->_bind( val = t_products path = abap_true ) }', sorter: \{ path: 'NAME' \} \}|

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
                            )->a( n = `number` v = |\{ parts:[\{path:'PRICE'\},\{path:'CURRENCY_CODE'\}], type:'sap.ui.model.type.Currency', formatOptions:\{showMeasure:false\} \}|
                            )->a( n = `unit`   v = `{CURRENCY_CODE}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
