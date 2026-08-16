CLASS z2ui5_cl_smpc_app_201 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name          TYPE string,
        price         TYPE p LENGTH 14 DECIMALS 2,
        currencycode  TYPE string,
        weightmeasure TYPE string,
        weightunit    TYPE string,
        width         TYPE string,
        depth         TYPE string,
        height        TYPE string,
        dimunit       TYPE string,
      END OF ty_s_product.
    DATA s_product TYPE ty_s_product.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_201 IMPLEMENTATION.

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
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( `ObjectHeader`
            " element binding kept 1:1 - the context is the one-record structure instead of {/ProductCollection/0}
            )->a( n = `binding`    v = client->_bind( s_product )
            )->a( n = `title`      v = `{NAME}`
            )->a( n = `condensed`  v = `true`
            )->a( n = `number`     v = |\{ parts:[\{path:'PRICE'\},\{path:'CURRENCYCODE'\}], type: 'sap.ui.model.type.Currency', formatOptions: \{showMeasure: false\} \}|
            )->a( n = `numberUnit` v = `{CURRENCYCODE}`
            )->a( n = `class`      v = `sapUiResponsivePadding--header`

            )->tag( `ObjectAttribute`
                )->a( n = `text` v = `{WEIGHTMEASURE} {WEIGHTUNIT} {WIDTH} x {DEPTH} x {HEIGHT} {DIMUNIT}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " the bound record /ProductCollection/0 (Notebook Basic 15) of the shared mock data sap/ui/demo/mock/products.json
    s_product = VALUE #( name          = `Notebook Basic 15`
                         price         = '956.00'
                         currencycode  = `EUR`
                         weightmeasure = `4.2`
                         weightunit    = `KG`
                         width         = `30`
                         depth         = `18`
                         height        = `3`
                         dimunit       = `cm` ).

  ENDMETHOD.

ENDCLASS.
