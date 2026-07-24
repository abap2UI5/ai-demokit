CLASS z2ui5_cl_ai_app_118 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA card_manifest TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_118 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " probe: sap.ui.integration widgets.Card renders entirely from a declarative
    " JSON manifest; here the manifest is carried as an ABAP string and bound
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:w`   v = `sap.ui.integration.widgets`
        )->a( n = `height`    v = `100%`

        )->leaf( n = `Card` ns = `w`
            )->a( n = `manifest` v = client->_bind( card_manifest )
            )->a( n = `width`    v = `320px` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    card_manifest = `{"sap.card":{"type":"List","header":{"title":"Integration Card","subtitle":"declarative manifest"},` &&
                    `"content":{"data":{"json":[{"Name":"Item 1"},{"Name":"Item 2"},{"Name":"Item 3"}]},"item":{"title":"{Name}"}}}}`.

  ENDMETHOD.

ENDCLASS.
