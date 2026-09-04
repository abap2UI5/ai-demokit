" @keywords objectidentifier object identifier sap.m active title press verticallayout
" @summary The object identifier is a small building block representing an object by a title and short description. Often it is used in the first column of a table.
CLASS z2ui5_cl_smpc_app_071 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name        TYPE string,
        description TYPE string,
      END OF ty_s_product.
    DATA s_product TYPE ty_s_product.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_071 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( n = `VerticalLayout` ns = `l`
            " element binding kept 1:1 - a one-record structure /S_PRODUCT instead of {/ProductCollection/0}
            )->a( n = `binding` v = client->_bind( s_product )
            )->a( n = `class`   v = `sapUiContentPadding`
            )->a( n = `width`   v = `100%`

            )->tag( `ObjectIdentifier`
                )->a( n = `title`       v = `{NAME}`
                )->a( n = `text`        v = `{DESCRIPTION}`
                )->a( n = `titleActive` v = `true`
                )->a( n = `titlePress`  v = client->_event( `TITLE_PRESS` )

        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `TITLE_PRESS`.
      " the original's titleClicked - MessageBox.alert("Title was clicked!")
      client->message_box_display( text = `Title was clicked!` type = `alert` ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " the bound record /ProductCollection/0 (Notebook Basic 15) of ui5/mock/products.json, verbatim
    CLEAR s_product.
    s_product-name = `Notebook Basic 15`.
    s_product-description = `Notebook Basic 15 with 2,80 GHz quad core, 15" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`.

  ENDMETHOD.

ENDCLASS.
