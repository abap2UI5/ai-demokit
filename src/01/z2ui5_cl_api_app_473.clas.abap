"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.m.ScrollContainer - ScrollContainer
"! https://sdk.openui5.org/entity/sap.m.ScrollContainer/sample/sap.m.sample.ScrollContainer
"! NOTES (generation):
"! - IMPROVISED: the Image src binds {img>/products/pic1} in the original, a JSON
"!   image model not available server-side; a static demo image URL is used instead.
"! - IMPROVISED: the original narrows the width to 50em on phone devices via
"!   sap/ui/Device (not available server-side); a fixed 100em is used.
CLASS z2ui5_cl_api_app_473 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA width TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS model_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_473 IMPLEMENTATION.

  METHOD model_init.

    " original uses 50em on phone devices (sap/ui/Device is not available server-side)
    width = `100em`.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_api_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `height`    v = `100%`
        )->a( n = `width`     v = `100%`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->open( `ScrollContainer`
            )->a( n = `height`    v = `100%`
            )->a( n = `width`     v = `100%`
            )->a( n = `vertical`  v = `true`
            )->a( n = `focusable` v = `true`

            )->leaf( `Image`
                )->a( n = `src`   v = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7777-large.jpg`
                )->a( n = `width` v = client->_bind_edit( width ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
