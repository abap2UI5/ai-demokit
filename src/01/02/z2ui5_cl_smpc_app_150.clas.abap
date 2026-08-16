" @keywords codeeditor code editor sap.ui.codeeditor icontabheader icontabfilter
" @summary Example how to use CodeEditor with IconTabHeader to create a tab-based experience.
CLASS z2ui5_cl_smpc_app_150 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA selected_key TYPE string.
    DATA code_init    TYPE string.
    DATA code_a       TYPE string.
    DATA code_b       TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_150 IMPLEMENTATION.

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

    " the original's onSelectTab swaps the CodeEditor value per selected key in
    " JS (A -> example2, B -> example1, anything else empty) and onInit seeds the
    " hint text. Rebuilt on the client: selectedKey is two-way bound and the
    " editor value is the same switch as an expression binding - no round-trip
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:ce`  v = `sap.ui.codeeditor`
        )->a( n = `height`    v = `100%`

        )->ele( `IconTabHeader`
            )->a( n = `id`          v = `iconTabHeader`
            )->a( n = `selectedKey` v = client->_bind( selected_key )
            )->ele( `items`
                )->tag( `IconTabFilter`
                    )->a( n = `text` v = `A`
                    )->a( n = `key`  v = `A`
                )->tag( `IconTabFilter`
                    )->a( n = `text` v = `B`
                    )->a( n = `key`  v = `B`

            )->end(
        )->end(

        )->tag( n = `CodeEditor` ns = `ce`
            )->a( n = `id`     v = `aCodeEditor`
            )->a( n = `height` v = `300px`
            )->a( n = `type`   v = `javascript`
            )->a( n = `value`  v = |\{= ${ client->_bind( selected_key ) } === 'A' ? ${ client->_bind( code_a ) }| &&
                                    | : (${ client->_bind( selected_key ) } === 'B' ? ${ client->_bind( code_b ) }| &&
                                    | : ${ client->_bind( code_init ) }) \}| ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " the original's onInit hint plus its two example strings, verbatim - note
    " the original's own swap: tab A shows example2, tab B shows example1
    selected_key = `invalidKey`.
    code_init    = `// select tabs to see value of CodeEditor changing`.
    code_a       = |function myFunction(p1, p2) \{\n\treturn 'foo';\n\}|.
    code_b       = |function loadDoc() \{\n\treturn 'bar';\n\}|.

  ENDMETHOD.

ENDCLASS.
