" @keywords pdfviewer sap.m pdfviewermultiple scrollcontainer flexbox button flexitemdata
" @summary Two PDF viewer frames displayed side by side. The second frame has the property isTrustedSource set to false which opens the PDF viewer with the displayType set to Link
CLASS z2ui5_cl_smpc_app_442 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA source TYPE string.
    DATA title1 TYPE string VALUE `My Title 1`.
    DATA title2 TYPE string VALUE `My Title 2`.
    DATA height TYPE string VALUE `600px`.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    " the sample's two documents, served from the demo kit host
    CONSTANTS c_valid_path   TYPE string VALUE `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/PDFViewerMultiple/sample.pdf`.
    CONSTANTS c_invalid_path TYPE string VALUE `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/PDFViewerMultiple/sample_nonexisting.pdf`.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_442 IMPLEMENTATION.

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
                )->a( n = `class`      v = `sapUiSmallMargin`
                )->a( n = `direction`  v = `Column`
                )->a( n = `renderType` v = `Div`

                )->ele( `FlexBox`

                    " onCorrectPathClick / onIncorrectPathClick write /Source, which
                    " both PDFViewers bind - the same model write, done in ABAP
                    )->tag( `Button`
                        )->a( n = `text`  v = `Correctly Displayed`
                        )->a( n = `press` v = client->_event( `CORRECT_PATH` )
                    )->tag( `Button`
                        )->a( n = `text`  v = `Loading Error`
                        )->a( n = `press` v = client->_event( `INCORRECT_PATH` )

                )->end(

                )->ele( `FlexBox`
                    )->a( n = `direction`    v = `Row`
                    )->a( n = `fitContainer` v = `true`
                    )->a( n = `renderType`   v = `Div`

                    )->ele( `PDFViewer`
                        )->a( n = `class`           v = `sapUiSmallMarginEnd`
                        )->a( n = `source`          v = client->_bind( source )
                        )->a( n = `title`           v = client->_bind( title1 )
                        )->a( n = `height`          v = client->_bind( height )
                        )->a( n = `width`           v = `auto`
                        )->a( n = `isTrustedSource` v = `true`

                        )->ele( `layoutData`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                        )->end(
                    )->end(

                    )->ele( `PDFViewer`
                        )->a( n = `class`  v = `sapUiSmallMarginBegin`
                        )->a( n = `source` v = client->_bind( source )
                        )->a( n = `title`  v = client->_bind( title2 )
                        )->a( n = `height` v = client->_bind( height )
                        )->a( n = `width`  v = `auto`

                        )->ele( `layoutData`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `1` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `CORRECT_PATH`.
        source = c_valid_path.

      WHEN `INCORRECT_PATH`.
        source = c_invalid_path.

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " onInit seeds /Source with the valid document
    source = c_valid_path.

  ENDMETHOD.

ENDCLASS.
