" @keywords headercontainer header container sap.m headercontaineroh objectheader objectattribute objectstatus objectmarker numericcontent
" @summary The Header Container combined with sap.m.ObjectHeader.
CLASS z2ui5_cl_smpc_app_477 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    " the record the original binds with binding="{/ProductCollection/0}"
    DATA description  TYPE string.
    DATA name         TYPE string.
    DATA price        TYPE p LENGTH 8 DECIMALS 2.
    DATA currencycode TYPE string.
    DATA suppliername TYPE string.
  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_477 IMPLEMENTATION.

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
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( `ObjectHeader`
            )->a( n = `id`               v = `oh1`
            )->a( n = `responsive`       v = `true`
            )->a( n = `intro`            v = client->_bind( description )
            )->a( n = `title`            v = client->_bind( name )
            )->a( n = `number`           v = client->_bind( price )
            )->a( n = `numberUnit`       v = client->_bind( currencycode )
            )->a( n = `numberState`      v = `Success`
            )->a( n = `backgroundDesign` v = `Translucent`

            )->ele( `attributes`
                )->tag( `ObjectAttribute`
                    )->a( n = `title` v = `Manufacturer`
                    )->a( n = `text`  v = client->_bind( suppliername )

            )->end(
            )->ele( `statuses`
                )->tag( `ObjectStatus`
                    )->a( n = `title` v = `Approval`
                    )->a( n = `text`  v = `Pending`
                    )->a( n = `state` v = `Warning`

            )->end(
            )->ele( `markers`
                )->tag( `ObjectMarker`
                    )->a( n = `type` v = `Flagged`
                )->tag( `ObjectMarker`
                    )->a( n = `type` v = `Favorite`

            )->end(
            )->ele( `headerContainer`
                )->ele( `HeaderContainer`
                    )->a( n = `scrollStep` v = `200`
                    )->a( n = `id`         v = `headerContainer`

                    " press - MessageBox.alert("Link was clicked!")
                    )->tag( `NumericContent`
                        )->a( n = `scale`      v = `M`
                        )->a( n = `value`      v = `1.75`
                        )->a( n = `valueColor` v = `Good`
                        )->a( n = `indicator`  v = `Up`
                        )->a( n = `press`      v = client->_event( `NUMERIC_PRESS` )
                    )->tag( `NumericContent`
                        )->a( n = `scale`      v = `M`
                        )->a( n = `value`      v = `0.57`
                        )->a( n = `valueColor` v = `Error`
                        )->a( n = `indicator`  v = `Down`
                        )->a( n = `press`      v = client->_event( `NUMERIC_PRESS` )
                    )->tag( `NumericContent`
                        )->a( n = `scale`      v = `M`
                        )->a( n = `value`      v = `1.04`
                        )->a( n = `valueColor` v = `Neutral`
                        )->a( n = `indicator`  v = `Up`
                        )->a( n = `press`      v = client->_event( `NUMERIC_PRESS` )
                    )->tag( `NumericContent`
                        )->a( n = `scale`      v = `M`
                        )->a( n = `value`      v = `3.65`
                        )->a( n = `valueColor` v = `Good`
                        )->a( n = `indicator`  v = `Up`
                        )->a( n = `press`      v = client->_event( `NUMERIC_PRESS` )
                    )->tag( `NumericContent`
                        )->a( n = `scale`      v = `M`
                        )->a( n = `value`      v = `0.73`
                        )->a( n = `valueColor` v = `Error`
                        )->a( n = `indicator`  v = `Down`
                        )->a( n = `press`      v = client->_event( `NUMERIC_PRESS` )
                    )->tag( `NumericContent`
                        )->a( n = `scale`      v = `M`
                        )->a( n = `value`      v = `1.01`
                        )->a( n = `valueColor` v = `Critical`
                        )->a( n = `indicator`  v = `Down`
                        )->a( n = `press`      v = client->_event( `NUMERIC_PRESS` )
                    )->tag( `NumericContent`
                        )->a( n = `scale`      v = `M`
                        )->a( n = `value`      v = `1.42`
                        )->a( n = `valueColor` v = `Good`
                        )->a( n = `indicator`  v = `Up`
                        )->a( n = `press`      v = client->_event( `NUMERIC_PRESS` )
                    )->tag( `NumericContent`
                        )->a( n = `scale`      v = `M`
                        )->a( n = `value`      v = `0.21`
                        )->a( n = `valueColor` v = `Error`
                        )->a( n = `indicator`  v = `Down`
                        )->a( n = `press`      v = client->_event( `NUMERIC_PRESS` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `NUMERIC_PRESS`.
      " press - MessageBox.alert("Link was clicked!")
      client->message_box_display( text = `Link was clicked!` type = `alert` ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " /ProductCollection/0 of ui5/mock/products.json, the fields the view binds
    description  = `Notebook Basic 15 with 2,80 GHz quad core, 15" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`.
    name         = `Notebook Basic 15`.
    price        = '956.00'.
    currencycode = `EUR`.
    suppliername = `Very Best Screens`.

  ENDMETHOD.

ENDCLASS.
