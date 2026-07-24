CLASS z2ui5_cl_ai_app_114 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_114 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " literal braces in an attribute value must be escaped, else the XMLView parser reads them as a binding
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.ui.codeeditor`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `height`    v = `100%`

        )->leaf( `CodeEditor`
            )->a( n = `type`   v = `json`
            )->a( n = `value`  v = |\{\n  "English" : "Hello world",\n  "German" : "Hallo Welt",\n  "Japanese" : "こんにちは世界",\n  "Russian" : "Здравствуй мир"\n\}|
            )->a( n = `height` v = `300px` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
