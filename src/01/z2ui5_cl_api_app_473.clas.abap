"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.m.ScrollContainer - ScrollContainer
"! https://sdk.openui5.org/entity/sap.m.ScrollContainer/sample/sap.m.sample.ScrollContainer
CLASS z2ui5_cl_api_app_473 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA width TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS data_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_473 IMPLEMENTATION.

  " NOTES (generation):
  " - IMPROVISED: the Image src binds {img>/products/pic1} in the original, a JSON
  "   image model not available server-side; a static demo image URL is used instead.
  " - IMPROVISED: the original narrows the width to 50em on phone devices via
  "   sap/ui/Device (not available server-side); a fixed 100em is used.

  METHOD data_init.

    " original uses 50em on phone devices (sap/ui/Device is not available server-side)
    width = `100em`.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_api_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->attr( n = `height`    v = `100%`
        )->attr( n = `width`     v = `100%`
        )->attr( n = `xmlns`     v = `sap.m`
        )->attr( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->open( `ScrollContainer`
            )->attr( n = `height`    v = `100%`
            )->attr( n = `width`     v = `100%`
            )->attr( n = `vertical`  v = `true`
            )->attr( n = `focusable` v = `true`

            )->leaf( `Image`
                )->attr( n = `src`   v = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7777-large.jpg`
                )->attr( n = `width` v = client->_bind( width ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      data_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
