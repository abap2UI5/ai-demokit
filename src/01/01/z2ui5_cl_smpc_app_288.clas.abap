CLASS z2ui5_cl_smpc_app_288 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA source TYPE string.
    DATA title  TYPE string.
    DATA height TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    " the two paths onInit resolves with sap.ui.require.toUrl( ), pinned to the
    " OpenUI5 host per the runtime asset-URL rule; only the bound source is
    " PUBLIC, the constants are not model data
    CONSTANTS c_valid   TYPE string VALUE `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/PDFViewerEmbedded/sample.pdf`.
    CONSTANTS c_invalid TYPE string VALUE `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/PDFViewerEmbedded/sample_nonexisting.pdf`.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_288 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `height`    v = `100%`

        )->ele( `ScrollContainer`
            )->a( n = `height`     v = `100%`
            )->a( n = `width`      v = `100%`
            )->a( n = `horizontal` v = `true`
            )->a( n = `vertical`   v = `true`

            )->ele( `FlexBox`
                )->a( n = `direction`  v = `Column`
                )->a( n = `renderType` v = `Div`
                )->a( n = `class`      v = `sapUiSmallMargin`

                )->ele( `FlexBox`

                    )->tag( `Button`
                        )->a( n = `text`  v = `Correctly Displayed`
                        )->a( n = `press` v = client->_event( `PATH_CORRECT` )
                    )->tag( `Button`
                        )->a( n = `text`  v = `Loading Error`
                        )->a( n = `press` v = client->_event( `PATH_INCORRECT` )

                )->end(

                )->ele( `PDFViewer`
                    )->a( n = `source`          v = client->_bind( source )
                    )->a( n = `isTrustedSource` v = `true`
                    )->a( n = `title`           v = client->_bind( title )
                    )->a( n = `height`          v = client->_bind( height )

                    )->ele( `layoutData`
                        )->tag( `FlexItemData`
                            )->a( n = `growFactor` v = `1` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `PATH_CORRECT`.
        " onCorrectPathClick: setProperty( '/Source', validPath )
        source = c_valid.

      WHEN `PATH_INCORRECT`.
        " onIncorrectPathClick: setProperty( '/Source', invalidPath )
        source = c_invalid.

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    source = c_valid.
    title  = `My Custom Title`.
    height = `600px`.

  ENDMETHOD.

ENDCLASS.
