CLASS z2ui5_cl_ai_app_056 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_056 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->leaf( `ImageContent`
            )->a( n = `class`       v = `sapUiLargeMarginTop sapUiLargeMarginBottom`
            )->a( n = `src`         v = `sap-icon://area-chart`
            )->a( n = `description` v = `Icon`
            )->a( n = `press`       v = client->_event( `PRESS` )
        )->leaf( `ImageContent`
            )->a( n = `class`       v = `sapUiLargeMarginTop sapUiLargeMarginBottom`
            )->a( n = `src`         v = `test-resources/sap/m/demokit/sample/ImageContent/images/ProfileImage_LargeGenTile.png`
            )->a( n = `description` v = `Profile image`
            )->a( n = `press`       v = client->_event( `PRESS` )
        )->leaf( `ImageContent`
            )->a( n = `class`       v = `sapUiLargeMarginTop sapUiLargeMarginBottom`
            )->a( n = `src`         v = `test-resources/sap/m/demokit/sample/ImageContent/images/SAPLogoLargeTile_28px_height.png`
            )->a( n = `description` v = `Logo`
            )->a( n = `press`       v = client->_event( `PRESS` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `PRESS`.
        client->message_toast_display( `The ImageContent is pressed.` ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
