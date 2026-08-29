" @keywords pdfviewer sap.m pdf viewer opening popup dialog. carousel image
" @summary A PDF viewer opening as a popup dialog.
CLASS z2ui5_cl_smpc_app_044 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    " original: onPress feeds the popup-mode PDFViewer via setSource
    DATA pdf_source TYPE string.

  PROTECTED SECTION.
    " images and PDF files of the original sample sap/m/demokit/sample/PDFViewerPopup
    CONSTANTS c_base_url TYPE string VALUE `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/PDFViewerPopup/`.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_044 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `height`    v = `100%`

        " original onInit's controller-created PDFViewer, declared in the view's dependents aggregation instead
        )->ele( n = `dependents` ns = `mvc`
            )->tag( `PDFViewer`
                )->a( n = `id`              v = `pdfViewer`
                )->a( n = `source`          v = client->_bind( pdf_source )
                )->a( n = `title`           v = `My Custom Title`
                )->a( n = `isTrustedSource` v = `true`

        )->end(

        )->ele( `Carousel`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `loop`  v = `true`

            )->ele( `pages`
                )->tag( `Image`
                    )->a( n = `id`    v = `image1`
                    )->a( n = `src`   v = c_base_url && `sample1.jpg`
                    )->a( n = `alt`   v = `Example Picture 1`
                    )->a( n = `press` v = client->_event( val = `SHOW_PDF` arg = `sample1.pdf` )
                )->tag( `Image`
                    )->a( n = `id`    v = `image2`
                    )->a( n = `src`   v = c_base_url && `sample2.jpg`
                    )->a( n = `alt`   v = `Example Picture 2`
                    )->a( n = `press` v = client->_event( val = `SHOW_PDF` arg = `sample2.pdf` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `SHOW_PDF`.
      " original onPress setSource + open(): update the bound source, then the whitelisted open runs after render (t_arg positional: id, method; the view defaults to cs_view-main)
      pdf_source = c_base_url && client->get_event_arg( ).
      client->follow_up_action( val   = z2ui5_if_client=>cs_event-control_by_id
                                t_arg = VALUE #( ( `pdfViewer` )
                                                 ( `open` ) ) ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
