CLASS z2ui5_cl_ai_app_041 DEFINITION PUBLIC.

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

    METHODS model_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_041 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " the bound record /ProductCollection/0 of the shared mock data sap/ui/demo/mock/products.json
    s_product = VALUE #( name           = `Notebook Basic 15`
                         description    = `Notebook Basic 15 with 2,80 GHz quad core, 15" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`
                         weight_measure = `4.2`
                         weight_unit    = `KG`
                         width          = `30`
                         depth          = `18`
                         height         = `3`
                         dim_unit       = `cm`
                         price          = `956.00`
                         currency_code  = `EUR` ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->open( `ObjectHeader`
            " element binding kept 1:1 - the context is the one-record structure instead of {/ProductCollection/0}
            )->a( n = `binding`    v = client->_bind( s_product )
            )->a( n = `title`      v = `{NAME}`
            )->a( n = `number`     v = |\{ parts:[\{path:'PRICE'\},\{path:'CURRENCY_CODE'\}], type:'sap.ui.model.type.Currency', formatOptions:\{showMeasure:false\} \}|
            )->a( n = `numberUnit` v = `{CURRENCY_CODE}`
            )->a( n = `class`      v = `sapUiResponsivePadding--header`

            )->open( `statuses`
                )->leaf( `ObjectStatus`
                    )->a( n = `text`  v = `Some Damaged`
                    )->a( n = `state` v = `Error`
                )->leaf( `ObjectStatus`
                    )->a( n = `text`  v = `In Stock`
                    )->a( n = `state` v = `Success`

            )->shut(

            )->leaf( `ObjectAttribute`
                )->a( n = `text` v = `{WEIGHT_MEASURE} {WEIGHT_UNIT}`
            )->leaf( `ObjectAttribute`
                )->a( n = `text` v = `{WIDTH} x {DEPTH} x {HEIGHT} {DIM_UNIT}`
            )->leaf( `ObjectAttribute`
                )->a( n = `text` v = `{DESCRIPTION}`
            )->leaf( `ObjectAttribute`
                )->a( n = `text`   v = `www.sap.com`
                )->a( n = `active` v = `true`
                )->a( n = `press`  v = client->_event_client( val   = client->cs_event-open_new_tab
                                                              t_arg = VALUE #( ( `http://www.sap.com` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
