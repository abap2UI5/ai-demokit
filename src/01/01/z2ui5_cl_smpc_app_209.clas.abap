" @keywords objectheader object header sap.m objectheaderresponsivev objectattribute objectmarker objectstatus
" @summary This is a responsive Object Header without a number and with a Title, 3 Statuses/Attributes.
CLASS z2ui5_cl_smpc_app_209 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_smpc_app_209 IMPLEMENTATION.

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

    " the original binds the ObjectHeader to a single record {/ProductCollection/0};
    " that element binding is flattened onto the default model root (fields seeded
    " in model_init with products.json row 0). The fields are bound ABSOLUTELY:
    " a relative {NAME} on a control with no binding context resolves against
    " nothing and renders empty (measured 2026-08-01, the app-207 class)
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `height`    v = `100%`

        )->ele( `ObjectHeader`
            )->a( n = `id`               v = `oh1`
            )->a( n = `responsive`       v = `true`
            )->a( n = `icon`             v = client->_bind( productpicurl )
            )->a( n = `iconAlt`          v = client->_bind( name )
            )->a( n = `intro`            v = client->_bind( description )
            )->a( n = `title`            v = client->_bind( name )
            )->a( n = `backgroundDesign` v = `Translucent`
            )->a( n = `class`            v = `sapUiResponsivePadding--header`

            )->tag( `ObjectAttribute`
                )->a( n = `title` v = `Manufacturer`
                )->a( n = `text`  v = client->_bind( suppliername )
            )->tag( `ObjectAttribute`
                )->a( n = `title` v = `Dimension per unit`
                )->a( n = `text`  v = |{ client->_bind( width ) } x { client->_bind( depth ) } x { client->_bind( height ) } { client->_bind( dimunit ) }|

            )->ele( `markers`
                )->tag( `ObjectMarker`
                    )->a( n = `type` v = `Favorite`
                )->tag( `ObjectMarker`
                    )->a( n = `type` v = `Flagged`

            )->end(

            )->ele( `statuses`
                )->tag( `ObjectStatus`
                    )->a( n = `title` v = `Approval`
                    )->a( n = `text`  v = `Pending`
                    )->a( n = `state` v = `Warning` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " products.json row 0 (ProductId HT-1000) - the record the original element-binds
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
