CLASS z2ui5_cl_smpc_app_180 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA filesize TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_180 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      filesize = 100.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:form`   v = `sap.ui.layout.form`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:core`   v = `sap.ui.core`
        )->a( n = `core:require` v = `{FileSizeType: 'sap/ui/model/type/FileSize'}`

        )->ele( n = `SimpleForm` ns = `form`
            )->a( n = `class`      v = `sapUiResponsiveMargin`
            )->a( n = `layout`     v = `ResponsiveGridLayout`
            )->a( n = `editable`   v = `true`
            )->a( n = `labelSpanL` v = `3`
            )->a( n = `labelSpanM` v = `3`
            )->a( n = `emptySpanL` v = `4`
            )->a( n = `emptySpanM` v = `4`
            )->a( n = `columnsL`   v = `1`
            )->a( n = `columnsM`   v = `1`
            )->a( n = `title`      v = `FileSize Input`

            )->ele( n = `content` ns = `form`
                )->tag( `Label`
                    )->a( n = `text` v = `FileSize`
                )->tag( `Input`
                    )->a( n = `value` v = |\{ path: '{ client->_bind( val = filesize path = abap_true ) }', type: 'FileSizeType' \}|

        )->end(

        )->ele( n = `SimpleForm` ns = `form`
            )->a( n = `class`      v = `sapUiResponsiveMargin`
            )->a( n = `layout`     v = `ResponsiveGridLayout`
            )->a( n = `labelSpanL` v = `3`
            )->a( n = `labelSpanM` v = `3`
            )->a( n = `emptySpanL` v = `4`
            )->a( n = `emptySpanM` v = `4`
            )->a( n = `columnsL`   v = `1`
            )->a( n = `columnsM`   v = `1`
            )->a( n = `title`      v = `Min Integer Digits (minimal number of non-fraction digits)`

            )->ele( n = `content` ns = `form`
                )->tag( `Label`
                    )->a( n = `text` v = `3 digits`
                )->tag( `Text`
                    )->a( n = `text` v = |\{ path: '{ client->_bind( val = filesize path = abap_true ) }', type: 'FileSizeType', formatOptions: \{ minIntegerDigits: 3 \} \}|
                )->tag( `Label`
                    )->a( n = `text` v = `5 digits`
                )->tag( `Text`
                    )->a( n = `text` v = |\{ path: '{ client->_bind( val = filesize path = abap_true ) }', type: 'FileSizeType', formatOptions: \{ minIntegerDigits: 5 \} \}|

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
            )->a( n = `title`      v = `Max Integer Digits (maximal number of non-fraction digits)`

            )->ele( n = `content` ns = `form`
                )->tag( `Label`
                    )->a( n = `text` v = `2 digits`
                )->tag( `Text`
                    )->a( n = `text` v = |\{ path: '{ client->_bind( val = filesize path = abap_true ) }', type: 'FileSizeType', formatOptions: \{ maxIntegerDigits: 2 \} \}|
                )->tag( `Label`
                    )->a( n = `text` v = `5 digits`
                )->tag( `Text`
                    )->a( n = `text` v = |\{ path: '{ client->_bind( val = filesize path = abap_true ) }', type: 'FileSizeType', formatOptions: \{ maxIntegerDigits: 5 \} \}|

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
            )->a( n = `title`      v = `Min Fraction Digits (minimal number of fraction digits)`

            )->ele( n = `content` ns = `form`
                )->tag( `Label`
                    )->a( n = `text` v = `2 digits`
                )->tag( `Text`
                    )->a( n = `text` v = |\{ path: '{ client->_bind( val = filesize path = abap_true ) }', type: 'FileSizeType', formatOptions: \{ minFractionDigits: 2 \} \}|
                )->tag( `Label`
                    )->a( n = `text` v = `5 digits`
                )->tag( `Text`
                    )->a( n = `text` v = |\{ path: '{ client->_bind( val = filesize path = abap_true ) }', type: 'FileSizeType', formatOptions: \{ minFractionDigits: 5 \} \}|

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
            )->a( n = `title`      v = `Max Fraction Digits (maximal number of fraction digits)`

            )->ele( n = `content` ns = `form`
                )->tag( `Label`
                    )->a( n = `text` v = `2 digits`
                )->tag( `Text`
                    )->a( n = `text` v = |\{ path: '{ client->_bind( val = filesize path = abap_true ) }', type: 'FileSizeType', formatOptions: \{ maxFractionDigits: 2 \} \}|
                )->tag( `Label`
                    )->a( n = `text` v = `5 digits`
                )->tag( `Text`
                    )->a( n = `text` v = |\{ path: '{ client->_bind( val = filesize path = abap_true ) }', type: 'FileSizeType', formatOptions: \{ maxFractionDigits: 5 \} \}| ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
