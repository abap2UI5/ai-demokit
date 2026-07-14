"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.ui.model.type.Integer - TypeInteger
"! https://sdk.openui5.org/entity/sap.ui.model.type.Integer/sample/sap.ui.core.sample.TypeInteger
CLASS z2ui5_cl_api_app_508 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA number TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_508 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      number = `123`.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(path) = client->_bind_edit( val  = number
                                     path = abap_true ).

    DATA(view) = z2ui5_cl_api_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->attr( n = `xmlns`      v = `sap.m`
        )->attr( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->attr( n = `xmlns:form` v = `sap.ui.layout.form`

        )->open( n = `SimpleForm` ns = `form`
            )->attr( n = `width`      v = `auto`
            )->attr( n = `class`      v = `sapUiResponsiveMargin`
            )->attr( n = `layout`     v = `ResponsiveGridLayout`
            )->attr( n = `editable`   v = `true`
            )->attr( n = `labelSpanL` v = `3`
            )->attr( n = `labelSpanM` v = `3`
            )->attr( n = `emptySpanL` v = `4`
            )->attr( n = `emptySpanM` v = `4`
            )->attr( n = `columnsL`   v = `1`
            )->attr( n = `columnsM`   v = `1`
            )->attr( n = `title`      v = `Number Input`

            )->open( n = `content` ns = `form`
                )->leaf( `Label`
                    )->attr( n = `text` v = `Number`
                )->leaf( `Input`
                    )->attr( n = `value` v = `{ path: '` && path && `', type: 'sap.ui.model.type.Integer' }`

            )->shut(
        )->shut(
        )->open( n = `SimpleForm` ns = `form`
            )->attr( n = `width`      v = `auto`
            )->attr( n = `class`      v = `sapUiResponsiveMargin`
            )->attr( n = `layout`     v = `ResponsiveGridLayout`
            )->attr( n = `labelSpanL` v = `3`
            )->attr( n = `labelSpanM` v = `3`
            )->attr( n = `emptySpanL` v = `4`
            )->attr( n = `emptySpanM` v = `4`
            )->attr( n = `columnsL`   v = `1`
            )->attr( n = `columnsM`   v = `1`
            )->attr( n = `title`      v = `Min Integer Digits (minimal number of non-fraction digits)`

            )->open( n = `content` ns = `form`
                )->leaf( `Label`
                    )->attr( n = `text` v = `3 digits`
                )->leaf( `Text`
                    )->attr( n = `text` v = `{ path: '` && path && `', type: 'sap.ui.model.type.Integer', formatOptions: { minIntegerDigits: 3 } }`
                )->leaf( `Label`
                    )->attr( n = `text` v = `5 digits`
                )->leaf( `Text`
                    )->attr( n = `text` v = `{ path: '` && path && `', type: 'sap.ui.model.type.Integer', formatOptions: { minIntegerDigits: 5 } }`

            )->shut(
        )->shut(
        )->open( n = `SimpleForm` ns = `form`
            )->attr( n = `width`      v = `auto`
            )->attr( n = `class`      v = `sapUiResponsiveMargin`
            )->attr( n = `layout`     v = `ResponsiveGridLayout`
            )->attr( n = `labelSpanL` v = `3`
            )->attr( n = `labelSpanM` v = `3`
            )->attr( n = `emptySpanL` v = `4`
            )->attr( n = `emptySpanM` v = `4`
            )->attr( n = `columnsL`   v = `1`
            )->attr( n = `columnsM`   v = `1`
            )->attr( n = `title`      v = `Max Integer Digits (maximal number of non-fraction digits)`

            )->open( n = `content` ns = `form`
                )->leaf( `Label`
                    )->attr( n = `text` v = `2 digits`
                )->leaf( `Text`
                    )->attr( n = `text` v = `{ path: '` && path && `', type: 'sap.ui.model.type.Integer', formatOptions: { maxIntegerDigits: 2 } }`
                )->leaf( `Label`
                    )->attr( n = `text` v = `5 digits`
                )->leaf( `Text`
                    )->attr( n = `text` v = `{ path: '` && path && `', type: 'sap.ui.model.type.Integer', formatOptions: { maxIntegerDigits: 5 } }` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
