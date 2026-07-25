CLASS z2ui5_cl_ai_app_179 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA number TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_179 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      number = `123.456`.
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
        )->a( n = `core:require` v = `{FloatType: 'sap/ui/model/type/Float'}`

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
            )->a( n = `title`      v = `Number Input`

            )->open( n = `content` ns = `form`
                )->leaf( `Label`
                    )->a( n = `text` v = `Number`
                )->leaf( `Input`
                    )->a( n = `value` v = |\{ path: '{ client->_bind( val = number path = abap_true ) }', type: 'FloatType' \}|

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
            )->a( n = `title`      v = `Minimal Number of Non-Fraction Digits (minIntegerDigits)`

            )->open( n = `content` ns = `form`
                )->leaf( `Label`
                    )->a( n = `text` v = `3 digits`
                )->leaf( `Text`
                    )->a( n = `text` v = |\{ path: '{ client->_bind( val = number path = abap_true ) }', type: 'FloatType', formatOptions: \{ minIntegerDigits: 3 \} \}|
                )->leaf( `Label`
                    )->a( n = `text` v = `5 digits`
                )->leaf( `Text`
                    )->a( n = `text` v = |\{ path: '{ client->_bind( val = number path = abap_true ) }', type: 'FloatType', formatOptions: \{ minIntegerDigits: 5 \} \}|

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
            )->a( n = `title`      v = `Maximal Number of Non-Fraction Digits (maxIntegerDigits)`

            )->open( n = `content` ns = `form`
                )->leaf( `Label`
                    )->a( n = `text` v = `2 digits`
                )->leaf( `Text`
                    )->a( n = `text` v = |\{ path: '{ client->_bind( val = number path = abap_true ) }', type: 'FloatType', formatOptions: \{ maxIntegerDigits: 2 \} \}|
                )->leaf( `Label`
                    )->a( n = `text` v = `5 digits`
                )->leaf( `Text`
                    )->a( n = `text` v = |\{ path: '{ client->_bind( val = number path = abap_true ) }', type: 'FloatType', formatOptions: \{ maxIntegerDigits: 5 \} \}|

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
            )->a( n = `title`      v = `Minimal Number of Fraction Digits (minFractionDigits)`

            )->open( n = `content` ns = `form`
                )->leaf( `Label`
                    )->a( n = `text` v = `2 digits`
                )->leaf( `Text`
                    )->a( n = `text` v = |\{ path: '{ client->_bind( val = number path = abap_true ) }', type: 'FloatType', formatOptions: \{ minFractionDigits: 2 \} \}|
                )->leaf( `Label`
                    )->a( n = `text` v = `5 digits`
                )->leaf( `Text`
                    )->a( n = `text` v = |\{ path: '{ client->_bind( val = number path = abap_true ) }', type: 'FloatType', formatOptions: \{ minFractionDigits: 5 \} \}|

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
            )->a( n = `title`      v = `Maximal Number of Fraction Digits (maxFractionDigits, overruled by default by preserveDecimals)`

            )->open( n = `content` ns = `form`
                )->leaf( `Label`
                    )->a( n = `text` v = `2 digits, default preserveDecimals (true)`
                )->leaf( `Text`
                    )->a( n = `text` v = |\{ path: '{ client->_bind( val = number path = abap_true ) }', type: 'FloatType', formatOptions: \{ maxFractionDigits: 2 \} \}|
                )->leaf( `Label`
                    )->a( n = `text` v = `5 digits, default preserveDecimals (true)`
                )->leaf( `Text`
                    )->a( n = `text` v = |\{ path: '{ client->_bind( val = number path = abap_true ) }', type: 'FloatType', formatOptions: \{ maxFractionDigits: 5 \} \}|
                )->leaf( `Label`
                    )->a( n = `text` v = `2 digits, preserveDecimals=false`
                )->leaf( `Text`
                    )->a( n = `text` v = |\{ path: '{ client->_bind( val = number path = abap_true ) }', type: 'FloatType', formatOptions: \{ maxFractionDigits: 2, preserveDecimals: false \} \}|
                )->leaf( `Label`
                    )->a( n = `text` v = `5 digits, preserveDecimals=false`
                )->leaf( `Text`
                    )->a( n = `text` v = |\{ path: '{ client->_bind( val = number path = abap_true ) }', type: 'FloatType', formatOptions: \{ maxFractionDigits: 5, preserveDecimals: false \} \}| ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
