CLASS z2ui5_cl_smpc_app_056 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_056 IMPLEMENTATION.

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

        )->tag( `ImageContent`
            )->a( n = `class`       v = `sapUiLargeMarginTop sapUiLargeMarginBottom`
            )->a( n = `src`         v = `sap-icon://area-chart`
            )->a( n = `description` v = `Icon`
            )->a( n = `press`       v = client->follow_up_action( val   = client->cs_event-control_global
                                                                  t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `The ImageContent is pressed.` ) ) )
        )->tag( `ImageContent`
            )->a( n = `class`       v = `sapUiLargeMarginTop sapUiLargeMarginBottom`
            " original demokit test-resources image paths kept 1:1 - not served by abap2UI5 (see sidecar)
            )->a( n = `src`         v = `test-resources/sap/m/demokit/sample/ImageContent/images/ProfileImage_LargeGenTile.png`
            )->a( n = `description` v = `Profile image`
            )->a( n = `press`       v = client->follow_up_action( val   = client->cs_event-control_global
                                                                  t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `The ImageContent is pressed.` ) ) )
        )->tag( `ImageContent`
            )->a( n = `class`       v = `sapUiLargeMarginTop sapUiLargeMarginBottom`
            )->a( n = `src`         v = `test-resources/sap/m/demokit/sample/ImageContent/images/SAPLogoLargeTile_28px_height.png`
            )->a( n = `description` v = `Logo`
            )->a( n = `press`       v = client->follow_up_action( val   = client->cs_event-control_global
                                                                  t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `The ImageContent is pressed.` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
