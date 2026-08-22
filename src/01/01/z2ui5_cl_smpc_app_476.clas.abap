" @keywords objectheader object header sap.m objectheaderresponsivevi objectattribute objectstatus objectmarker
" @summary A responsive Object Header whose intro and title are active links to sap.com, with a Currency-typed number, one attribute, a status and two markers.
CLASS z2ui5_cl_smpc_app_476 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    " the record the original binds with binding="{/ProductCollection/0}"
    DATA price        TYPE p LENGTH 8 DECIMALS 2.
    DATA currencycode TYPE string.
    DATA suppliername TYPE string.
  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_476 IMPLEMENTATION.

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
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( `ObjectHeader`
            )->a( n = `id`                  v = `oh1`
            )->a( n = `responsive`          v = `true`
            )->a( n = `fullScreenOptimized` v = `false`
            )->a( n = `intro`               v = `Visit sap.com for more info`
            )->a( n = `introActive`         v = `true`
            )->a( n = `introHref`           v = `http://www.sap.com`
            )->a( n = `introTarget`         v = `_blank`
            )->a( n = `title`               v = `www.sap.com`
            )->a( n = `titleActive`         v = `true`
            )->a( n = `titleHref`           v = `http://www.sap.com`
            )->a( n = `titleTarget`         v = `_blank`
            )->a( n = `number`              v = |\{ parts:[\{path:'{ client->_bind( val = price path = abap_true ) }'\},| &&
                                                 |\{path:'{ client->_bind( val = currencycode path = abap_true ) }'\}],| &&
                                                 | type: 'sap.ui.model.type.Currency', formatOptions: \{showMeasure: false\} \}|
            )->a( n = `numberUnit`          v = client->_bind( currencycode )
            )->a( n = `numberState`         v = `Success`
            )->a( n = `backgroundDesign`    v = `Translucent`

            )->tag( `ObjectAttribute`
                )->a( n = `title` v = `Manufacturer`
                )->a( n = `text`  v = client->_bind( suppliername )

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
                    )->a( n = `type` v = `Favorite` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " /ProductCollection/0 of ui5/mock/products.json, the fields the view binds
    price        = '956.00'.
    currencycode = `EUR`.
    suppliername = `Very Best Screens`.

  ENDMETHOD.

ENDCLASS.
