CLASS z2ui5_cl_ai_app_135 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA amount   TYPE string.
    DATA currency TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_135 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      amount   = `123456789.123`.
      currency = `USD`.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:form`   v = `sap.ui.layout.form`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:core`   v = `sap.ui.core`
        )->a( n = `core:require` v = `{CurrencyType: 'sap/ui/model/type/Currency'}`

        )->open( n = `SimpleForm` ns = `form`
            )->a( n = `width`      v = `auto`
            )->a( n = `class`      v = `sapUiResponsiveMargin`
            )->a( n = `layout`     v = `ResponsiveGridLayout`
            )->a( n = `editable`   v = `true`
            )->a( n = `labelSpanL` v = `3`
            )->a( n = `labelSpanM` v = `3`
            )->a( n = `emptySpanL` v = `4`
            )->a( n = `emptySpanM` v = `4`
            )->a( n = `columnsL`   v = `1`
            )->a( n = `columnsM`   v = `1`
            )->a( n = `title`      v = `Input`

            )->open( n = `content` ns = `form`
                )->leaf( `Label`
                    )->a( n = `text` v = `One field`
                )->leaf( `Input`
                    )->a( n = `value` v = |\{ parts: ['{ client->_bind( val = amount path = abap_true ) }', '{ client->_bind( val = currency path = abap_true ) }'], type: 'CurrencyType' \}|
                )->leaf( `Label`
                    )->a( n = `text` v = `Two field`
                )->leaf( `Input`
                    )->a( n = `value` v = |\{ parts: ['{ client->_bind( val = amount path = abap_true ) }', '{ client->_bind( val = currency path = abap_true ) }'], type: 'CurrencyType', formatOptions: \{ showMeasure: false \} \}|
                )->leaf( `Input`
                    )->a( n = `value` v = |\{ parts: ['{ client->_bind( val = amount path = abap_true ) }', '{ client->_bind( val = currency path = abap_true ) }'], type: 'CurrencyType', formatOptions: \{ showNumber: false \} \}|

        )->shut(

        )->open( n = `SimpleForm` ns = `form`
            )->a( n = `width`      v = `auto`
            )->a( n = `class`      v = `sapUiResponsiveMargin`
            )->a( n = `layout`     v = `ResponsiveGridLayout`
            )->a( n = `labelSpanL` v = `3`
            )->a( n = `labelSpanM` v = `3`
            )->a( n = `emptySpanL` v = `4`
            )->a( n = `emptySpanM` v = `4`
            )->a( n = `columnsL`   v = `1`
            )->a( n = `columnsM`   v = `1`
            )->a( n = `title`      v = `Format options`

            )->open( n = `content` ns = `form`
                )->leaf( `Label`
                    )->a( n = `text` v = `Default`
                )->leaf( `Text`
                    )->a( n = `text` v = |\{ parts: ['{ client->_bind( val = amount path = abap_true ) }', '{ client->_bind( val = currency path = abap_true ) }'], type: 'CurrencyType' \}|
                )->leaf( `Label`
                    )->a( n = `text` v = `preserveDecimals:false`
                )->leaf( `Text`
                    )->a( n = `text` v = |\{ parts: ['{ client->_bind( val = amount path = abap_true ) }', '{ client->_bind( val = currency path = abap_true ) }'], type: 'CurrencyType', formatOptions: \{ preserveDecimals : false \} \}|
                )->leaf( `Label`
                    )->a( n = `text` v = `currencyCode:false`
                )->leaf( `Text`
                    )->a( n = `text` v = |\{ parts: ['{ client->_bind( val = amount path = abap_true ) }', '{ client->_bind( val = currency path = abap_true ) }'], type: 'CurrencyType', formatOptions: \{ currencyCode : false \} \}|
                )->leaf( `Label`
                    )->a( n = `text` v = `style:'short'`
                )->leaf( `Text`
                    )->a( n = `text` v = |\{ parts: ['{ client->_bind( val = amount path = abap_true ) }', '{ client->_bind( val = currency path = abap_true ) }'], type: 'CurrencyType', formatOptions: \{ style : 'short' \} \}|
                )->leaf( `Label`
                    )->a( n = `text` v = `style:'long'`
                )->leaf( `Text`
                    )->a( n = `text` v = |\{ parts: ['{ client->_bind( val = amount path = abap_true ) }', '{ client->_bind( val = currency path = abap_true ) }'], type: 'CurrencyType', formatOptions: \{ style : 'long' \} \}| ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
