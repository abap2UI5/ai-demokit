" @keywords objectheader object header sap.m displays objectstatus objectattribute
" @summary This is a Object Header which displays the basic information about objects similar to the Object List Item. Besides a title and number you can show multiple attributes (on the left) and statuses (on the right).
CLASS z2ui5_cl_smpc_app_041 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name           TYPE string,
        description    TYPE string,
        weight_measure TYPE string,
        weight_unit    TYPE string,
        width          TYPE string,
        depth          TYPE string,
        height         TYPE string,
        dim_unit       TYPE string,
        price          TYPE p LENGTH 14 DECIMALS 2,
        currency_code  TYPE string,
      END OF ty_s_product.
    DATA s_product TYPE ty_s_product.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_041 IMPLEMENTATION.

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
    DATA temp1 TYPE string_table.
    DATA temp2 LIKE LINE OF temp1.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `REDIRECT` INTO TABLE temp1.
    
    temp2 = |\{ URL: 'http://www.sap.com', NEW_WINDOW: true \}|.
    INSERT temp2 INTO TABLE temp1.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->ele( `ObjectHeader`
            " element binding kept 1:1 - the context is the one-record structure instead of {/ProductCollection/0}
            )->a( n = `binding`    v = client->_bind( s_product )
            )->a( n = `title`      v = `{NAME}`
            )->a( n = `number`     v = |\{ parts:[\{path:'PRICE'\},\{path:'CURRENCY_CODE'\}], type:'sap.ui.model.type.Currency', formatOptions:\{showMeasure:false\} \}|
            )->a( n = `numberUnit` v = `{CURRENCY_CODE}`
            )->a( n = `class`      v = `sapUiResponsivePadding--header`

            )->ele( `statuses`
                )->tag( `ObjectStatus`
                    )->a( n = `text`  v = `Some Damaged`
                    )->a( n = `state` v = `Error`
                )->tag( `ObjectStatus`
                    )->a( n = `text`  v = `In Stock`
                    )->a( n = `state` v = `Success`

            )->end(

            )->tag( `ObjectAttribute`
                )->a( n = `text` v = `{WEIGHT_MEASURE} {WEIGHT_UNIT}`
            )->tag( `ObjectAttribute`
                )->a( n = `text` v = `{WIDTH} x {DEPTH} x {HEIGHT} {DIM_UNIT}`
            )->tag( `ObjectAttribute`
                )->a( n = `text` v = `{DESCRIPTION}`
            )->tag( `ObjectAttribute`
                )->a( n = `text`   v = `www.sap.com`
                )->a( n = `active` v = `true`
                )->a( n = `press`  v = client->follow_up_action( val   = client->cs_event-urlhelper
                                                                 t_arg = temp1 ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " the bound record /ProductCollection/0 of the shared mock data sap/ui/demo/mock/products.json
    CLEAR s_product.
    s_product-name = `Notebook Basic 15`.
    s_product-description = `Notebook Basic 15 with 2,80 GHz quad core, 15" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`.
    s_product-weight_measure = `4.2`.
    s_product-weight_unit = `KG`.
    s_product-width = `30`.
    s_product-depth = `18`.
    s_product-height = `3`.
    s_product-dim_unit = `cm`.
    s_product-price = `956.00`.
    s_product-currency_code = `EUR`.

  ENDMETHOD.

ENDCLASS.
