CLASS z2ui5_cl_api_app_469 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    " not bound - helper state kept out of PUBLIC so the round-trip model scan stays small
    DATA pdf_source TYPE string.

    METHODS view_display.
    METHODS on_event.
    METHODS popup_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_469 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    " images and PDF files of the original sample sap/m/demokit/sample/PDFViewerPopup
    DATA(base_url) = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/PDFViewerPopup/`.

    DATA(view) = z2ui5_cl_api_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `height`    v = `100%`

        )->open( `Carousel`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `loop`  v = `true`

            )->open( `pages`
                )->leaf( `Image`
                    )->a( n = `id`    v = `image1`
                    )->a( n = `src`   v = base_url && `sample1.jpg`
                    )->a( n = `alt`   v = `Example Picture 1`
                    )->a( n = `press` v = client->_event( val = `SHOW_PDF` t_arg = VALUE #( ( `sample1.pdf` ) ) )
                )->leaf( `Image`
                    )->a( n = `id`    v = `image2`
                    )->a( n = `src`   v = base_url && `sample2.jpg`
                    )->a( n = `alt`   v = `Example Picture 2`
                    )->a( n = `press` v = client->_event( val = `SHOW_PDF` t_arg = VALUE #( ( `sample2.pdf` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `SHOW_PDF`.
        pdf_source = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/PDFViewerPopup/` && client->get_event_arg( ).
        popup_display( ).

    ENDCASE.

  ENDMETHOD.


  METHOD popup_display.

    DATA(popup) = z2ui5_cl_api_xml=>factory( ).

    popup->open( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->open( `Dialog`
            )->a( n = `title`         v = `My Custom Title`
            )->a( n = `contentWidth`  v = `760px`
            )->a( n = `contentHeight` v = `600px`
            )->a( n = `afterClose`    v = client->_event_client( client->cs_event-popup_close )

            " the original opens the PDFViewer in popup mode via JavaScript - here the PDF viewer is embedded into the dialog
            )->leaf( `PDFViewer`
                )->a( n = `source`          v = pdf_source
                )->a( n = `isTrustedSource` v = `true`
                )->a( n = `height`          v = `100%`

            )->open( `endButton`
                )->leaf( `Button`
                    )->a( n = `text`  v = `Close`
                    )->a( n = `press` v = client->_event_client( client->cs_event-popup_close ) ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
