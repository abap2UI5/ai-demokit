CLASS z2ui5_cl_api_app_473 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_473 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_api_xml.
    view = z2ui5_cl_api_xml=>factory( ).

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
                " the original computes 50em/100em from sap/ui/Device in the controller -
                " expressed client-side over the framework's device> model
                )->a( n = `width` v = `{= ${device>/system/phone} ? '50em' : '100em' }` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
