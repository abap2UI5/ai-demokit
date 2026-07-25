CLASS z2ui5_cl_ai_app_209 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA name          TYPE string.
    DATA productpicurl TYPE string.
    DATA description   TYPE string.
    DATA suppliername  TYPE string.
    DATA width         TYPE string.
    DATA depth         TYPE string.
    DATA height        TYPE string.
    DATA dimunit       TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_209 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " the original binds the ObjectHeader to a single record {/ProductCollection/0};
    " that element binding is flattened onto the default model root (fields seeded
    " in model_init with products.json row 0) so the relative bindings resolve
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `height`    v = `100%`

        )->open( `ObjectHeader`
            )->a( n = `id`               v = `oh1`
            )->a( n = `responsive`       v = `true`
            )->a( n = `icon`             v = `{PRODUCTPICURL}`
            )->a( n = `iconAlt`          v = `{NAME}`
            )->a( n = `intro`            v = `{DESCRIPTION}`
            )->a( n = `title`            v = `{NAME}`
            )->a( n = `backgroundDesign` v = `Translucent`
            )->a( n = `class`            v = `sapUiResponsivePadding--header`

            )->leaf( `ObjectAttribute`
                )->a( n = `title` v = `Manufacturer`
                )->a( n = `text`  v = `{SUPPLIERNAME}`
            )->leaf( `ObjectAttribute`
                )->a( n = `title` v = `Dimension per unit`
                )->a( n = `text`  v = `{WIDTH} x {DEPTH} x {HEIGHT} {DIMUNIT}`

            )->open( `markers`
                )->leaf( `ObjectMarker`
                    )->a( n = `type` v = `Favorite`
                )->leaf( `ObjectMarker`
                    )->a( n = `type` v = `Flagged`

            )->shut(

            )->open( `statuses`
                )->leaf( `ObjectStatus`
                    )->a( n = `title` v = `Approval`
                    )->a( n = `text`  v = `Pending`
                    )->a( n = `state` v = `Warning` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " products.json row 0 (ProductId HT-1000) — the record the original element-binds
    name          = `Notebook Basic 15`.
    productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg`.
    description   = `Notebook Basic 15 with 2,80 GHz quad core, 15" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`.
    suppliername  = `Very Best Screens`.
    width         = `30`.
    depth         = `18`.
    height        = `3`.
    dimunit       = `cm`.

  ENDMETHOD.

ENDCLASS.
