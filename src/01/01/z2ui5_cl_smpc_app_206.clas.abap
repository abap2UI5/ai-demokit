" @keywords objectheader object header sap.m objectheaderimage objectstatus objectattribute
" @summary An Object Header will also make space for an image if one is specified, via a URL for the 'icon' property. Note: This example shows the image inside ObjectHeader with the responsive property set to false.
CLASS z2ui5_cl_smpc_app_206 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA name          TYPE string.
    DATA productpicurl TYPE string.
    DATA price         TYPE p LENGTH 14 DECIMALS 2.
    DATA currencycode  TYPE string.
    DATA weightmeasure TYPE string.
    DATA weightunit    TYPE string.
    DATA width         TYPE string.
    DATA depth         TYPE string.
    DATA height        TYPE string.
    DATA dimunit       TYPE string.
    DATA description   TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_206 IMPLEMENTATION.

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

    " the original binds the ObjectHeader to a single record {/ProductCollection/5};
    " that element binding is flattened onto the default model root (fields seeded
    " in model_init with products.json row 5). The fields are bound ABSOLUTELY:
    " a relative {NAME} on a control with no binding context resolves against
    " nothing and renders empty (measured 2026-08-01, the app-207 class)
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->ele( `ObjectHeader`
            )->a( n = `icon`             v = client->_bind( productpicurl )
            )->a( n = `iconDensityAware` v = `false`
            )->a( n = `iconAlt`          v = client->_bind( name )
            )->a( n = `title`            v = client->_bind( name )
            )->a( n = `number`           v = |\{ parts:[\{path:'{ client->_bind_path( price ) }'\},| &&
                                             |\{path:'{ client->_bind_path( currencycode ) }'\}], | &&
                                             |type: 'sap.ui.model.type.Currency', formatOptions: \{showMeasure: false\} \}|
            )->a( n = `numberUnit`       v = client->_bind( currencycode )
            )->a( n = `class`            v = `sapUiResponsivePadding--header`

            )->ele( `statuses`
                )->tag( `ObjectStatus`
                    )->a( n = `text`  v = `In Stock`
                    )->a( n = `state` v = `Success`

            )->end(

            )->tag( `ObjectAttribute`
                )->a( n = `text` v = |{ client->_bind( weightmeasure ) } { client->_bind( weightunit ) }|
            )->tag( `ObjectAttribute`
                )->a( n = `text` v = |{ client->_bind( width ) } x { client->_bind( depth ) } x { client->_bind( height ) } { client->_bind( dimunit ) }|
            )->tag( `ObjectAttribute`
                )->a( n = `text` v = client->_bind( description ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " products.json row 5 (ProductId HT-1010) - the record the original element-binds
    name          = `Notebook Professional 15`.
    productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg`.
    price         = '1999.00'.
    currencycode  = `EUR`.
    weightmeasure = `4.3`.
    weightunit    = `KG`.
    width         = `33`.
    depth         = `20`.
    height        = `3`.
    dimunit       = `cm`.
    description   = `Notebook Professional 15 with 2,80 GHz quad core, 15" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro`.

  ENDMETHOD.

ENDCLASS.
