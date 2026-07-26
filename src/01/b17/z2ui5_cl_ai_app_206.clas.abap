CLASS z2ui5_cl_ai_app_206 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_ai_app_206 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " the original binds the ObjectHeader to a single record {/ProductCollection/5};
    " that element binding is flattened onto the default model root (fields seeded
    " in model_init with products.json row 5) so the relative bindings resolve
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->open( `ObjectHeader`
            )->a( n = `icon`             v = `{PRODUCTPICURL}`
            )->a( n = `iconDensityAware` v = `false`
            )->a( n = `iconAlt`          v = `{NAME}`
            )->a( n = `title`            v = `{NAME}`
            )->a( n = `number`           v = |\{ parts:[\{path:'PRICE'\},\{path:'CURRENCYCODE'\}], type: 'sap.ui.model.type.Currency', formatOptions: \{showMeasure: false\} \}|
            )->a( n = `numberUnit`       v = `{CURRENCYCODE}`
            )->a( n = `class`            v = `sapUiResponsivePadding--header`

            )->open( `statuses`
                )->leaf( `ObjectStatus`
                    )->a( n = `text`  v = `In Stock`
                    )->a( n = `state` v = `Success`

            )->shut(

            )->leaf( `ObjectAttribute`
                )->a( n = `text` v = `{WEIGHTMEASURE} {WEIGHTUNIT}`
            )->leaf( `ObjectAttribute`
                )->a( n = `text` v = `{WIDTH} x {DEPTH} x {HEIGHT} {DIMUNIT}`
            )->leaf( `ObjectAttribute`
                )->a( n = `text` v = `{DESCRIPTION}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " products.json row 5 (ProductId HT-1010) — the record the original element-binds
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
