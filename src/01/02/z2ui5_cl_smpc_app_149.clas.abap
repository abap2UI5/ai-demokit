CLASS z2ui5_cl_smpc_app_149 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_149 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:w`   v = `sap.ui.integration.widgets`
        )->a( n = `class`     v = `sapUiContentPadding`

        )->ele( `VBox`
            )->tag( `Link`
                )->a( n = `text`      v = `Visit the Card Explorer`
                )->a( n = `href`      v = `test-resources/sap/ui/integration/demokit/cardExplorer/index.html`
                )->a( n = `emphasized` v = `true`
                )->a( n = `class`     v = `sapUiSmallMargin`
                )->a( n = `target`    v = `_blank`
            )->tag( `Image`
                )->a( n = `src`   v = `./resources/sap/ui/documentation/sdk/images/tools/CardExplorer.png`
                )->a( n = `alt`   v = `Card Explorer`
                )->a( n = `class` v = `sapUiSmallMargin`
                " original onImagePress: URLHelper.redirect(url, true) - 1:1 via the
                " urlhelper REDIRECT frontend action (same relative target as the Link)
                )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-urlhelper
                                                                t_arg = VALUE #( ( `REDIRECT` )
                                                                              ( |\{ URL: 'test-resources/sap/ui/integration/demokit/cardExplorer/index.html', NEW_WINDOW: true \}| ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
