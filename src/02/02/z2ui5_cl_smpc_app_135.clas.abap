" @keywords currency sap.ui.model.type data type simpleform label input text
" @summary Formats the number by using the parameters defined for the given currency code. Either currency symbol, currency code or none of them can be included in the final formatted string.
CLASS z2ui5_cl_smpc_app_135 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA amount   TYPE string.
    DATA currency TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_135 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      amount   = `123456789.123`.
      currency = `USD`.
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:form`   v = `sap.ui.layout.form`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:core`   v = `sap.ui.core`
        )->a( n = `core:require` v = `{CurrencyType: 'sap/ui/model/type/Currency'}`

        )->ele( n = `SimpleForm` ns = `form`
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

            )->ele( n = `content` ns = `form`
                )->tag( `Label`
                    )->a( n = `text` v = `One field`
                )->tag( `Input`
                    )->a( n = `value` v = |\{ parts: ['{ client->_bind_path( amount ) }', '{ client->_bind_path( currency ) }'], type: 'CurrencyType' \}|
                )->tag( `Label`
                    )->a( n = `text` v = `Two field`
                )->tag( `Input`
                    )->a( n = `value` v = |\{ parts: ['{ client->_bind_path( amount ) }', '{ client->_bind_path( currency ) }'], type: 'CurrencyType', formatOptions: \{ showMeasure: false \} \}|
                )->tag( `Input`
                    " POST_171: the showNumber format option is @since 1.89 - below
                    " that it is ignored and this Input shows the amount too
                    )->a( n = `value` v = |\{ parts: ['{ client->_bind_path( amount ) }', '{ client->_bind_path( currency ) }'], type: 'CurrencyType', formatOptions: \{ showNumber: false \} \}|

            )->end(
        )->end(

        )->ele( n = `SimpleForm` ns = `form`
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

            )->ele( n = `content` ns = `form`
                )->tag( `Label`
                    )->a( n = `text` v = `Default`
                )->tag( `Text`
                    )->a( n = `text` v = |\{ parts: ['{ client->_bind_path( amount ) }', '{ client->_bind_path( currency ) }'], type: 'CurrencyType' \}|
                )->tag( `Label`
                    )->a( n = `text` v = `preserveDecimals:false`
                )->tag( `Text`
                    )->a( n = `text` v = |\{ parts: ['{ client->_bind_path( amount ) }', '{ client->_bind_path( currency ) }'], type: 'CurrencyType', formatOptions: \{ preserveDecimals : false \} \}|
                )->tag( `Label`
                    )->a( n = `text` v = `currencyCode:false`
                )->tag( `Text`
                    )->a( n = `text` v = |\{ parts: ['{ client->_bind_path( amount ) }', '{ client->_bind_path( currency ) }'], type: 'CurrencyType', formatOptions: \{ currencyCode : false \} \}|
                )->tag( `Label`
                    )->a( n = `text` v = `style:'short'`
                )->tag( `Text`
                    )->a( n = `text` v = |\{ parts: ['{ client->_bind_path( amount ) }', '{ client->_bind_path( currency ) }'], type: 'CurrencyType', formatOptions: \{ style : 'short' \} \}|
                )->tag( `Label`
                    )->a( n = `text` v = `style:'long'`
                )->tag( `Text`
                    )->a( n = `text` v = |\{ parts: ['{ client->_bind_path( amount ) }', '{ client->_bind_path( currency ) }'], type: 'CurrencyType', formatOptions: \{ style : 'long' \} \}| ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
