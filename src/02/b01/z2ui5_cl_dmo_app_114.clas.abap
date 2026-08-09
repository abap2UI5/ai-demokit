CLASS z2ui5_cl_dmo_app_114 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_dmo_app_114 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " the JSON value carries literal braces, which the XMLView parser would read
    " as a binding - the original escapes them in its own view.xml (value='\{...').
    " The escape has to SURVIVE into the serialized attribute, so the braces come
    " from `backtick` literals (verbatim) while the body uses |…| templates for
    " the real newlines: inside a template \{ would collapse to a bare brace
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.ui.codeeditor`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `height`    v = `100%`

        )->leaf( `CodeEditor`
            )->a( n = `type`   v = `json`
            )->a( n = `value`  v = `\{` &&
                                    |\n\t\t"Chinese" : "你好世界",| &&
                                    |\n\t\t"Dutch" : "Hallo wereld",| &&
                                    |\n\t\t"English" : "Hello world",| &&
                                    |\n\t\t"French" : "Bonjour monde",| &&
                                    |\n\t\t"German" : "Hallo Welt",| &&
                                    |\n\t\t"Greek" : "γειά σου κόσμος",| &&
                                    |\n\t\t"Italian" : "Ciao mondo",| &&
                                    |\n\t\t"Japanese" : "こんにちは世界",| &&
                                    |\n\t\t"Korean" : "여보세요 세계",| &&
                                    |\n\t\t"Portuguese" : "Olá mundo",| &&
                                    |\n\t\t"Russian" : "Здравствуй мир",| &&
                                    |\n\t\t"Spanish" : "Hola mundo"| &&
                                    |\n\t| && `\}`
            )->a( n = `height` v = `300px` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
