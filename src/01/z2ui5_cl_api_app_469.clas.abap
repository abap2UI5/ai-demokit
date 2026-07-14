"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.m.PDFViewer - PDFViewerPopup
"! https://sdk.openui5.org/entity/sap.m.PDFViewer/sample/sap.m.sample.PDFViewerPopup
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

  " NOTES (generation):
  " - IMPROVISED: the sample's onInit gives each Image its own JSONModel and onPress
  "   opens a controller-created sap.m.PDFViewer in popup mode via JavaScript. Here the
  "   per-image Source/Preview URLs are resolved statically and the PDFViewer is embedded
  "   into a sap.m.Dialog opened on the press event instead.
  " - 1.71: the PDFViewer property isTrustedSource of the original is omitted - it is
  "   available only in UI5 releases higher than 1.71.
  " - LIVE-TEST: confirm the PDFViewer renders inside the dialog at height 100% in a
  "   running system.

  METHOD view_display.

    " images and PDF files of the original sample sap/m/demokit/sample/PDFViewerPopup
    DATA(base_url) = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/PDFViewerPopup/`.

    DATA(view) = z2ui5_cl_api_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->attr( n = `xmlns`     v = `sap.m`
        )->attr( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->attr( n = `height`    v = `100%`

        )->open( `Carousel`
            )->attr( n = `class` v = `sapUiContentPadding`
            )->attr( n = `loop`  v = `true`

            )->open( `pages`
                )->leaf( `Image`
                    )->attr( n = `id`    v = `image1`
                    )->attr( n = `src`   v = base_url && `sample1.jpg`
                    )->attr( n = `alt`   v = `Example Picture 1`
                    )->attr( n = `press` v = client->_event( val = `SHOW_PDF` t_arg = VALUE #( ( `sample1.pdf` ) ) )
                )->leaf( `Image`
                    )->attr( n = `id`    v = `image2`
                    )->attr( n = `src`   v = base_url && `sample2.jpg`
                    )->attr( n = `alt`   v = `Example Picture 2`
                    )->attr( n = `press` v = client->_event( val = `SHOW_PDF` t_arg = VALUE #( ( `sample2.pdf` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `SHOW_PDF`.
        pdf_source = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/PDFViewerPopup/` && client->get_event_arg( 1 ).
        popup_display( ).

    ENDCASE.

  ENDMETHOD.


  METHOD popup_display.

    DATA(popup) = z2ui5_cl_api_xml=>factory( ).

    popup->open( n = `FragmentDefinition` ns = `core`
        )->attr( n = `xmlns`      v = `sap.m`
        )->attr( n = `xmlns:core` v = `sap.ui.core`

        )->open( `Dialog`
            )->attr( n = `title`         v = `My Custom Title`
            )->attr( n = `contentWidth`  v = `760px`
            )->attr( n = `contentHeight` v = `600px`
            )->attr( n = `afterClose`    v = client->_event_client( client->cs_event-popup_close )

            " the original opens the PDFViewer in popup mode via JavaScript - here the PDF viewer is embedded into the dialog
            )->leaf( `PDFViewer`
                )->attr( n = `source` v = pdf_source
                )->attr( n = `height` v = `100%`

            )->open( `endButton`
                )->leaf( `Button`
                    )->attr( n = `text`  v = `Close`
                    )->attr( n = `press` v = client->_event_client( client->cs_event-popup_close ) ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
