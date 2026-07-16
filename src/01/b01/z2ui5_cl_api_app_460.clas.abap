"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.m.ObjectHeader - ObjectHeader
"! https://sdk.openui5.org/entity/sap.m.ObjectHeader/sample/sap.m.sample.ObjectHeader
"! API USAGE AUDIT: (a) frontend_action (_event_client): YES | (b) event t_arg: YES
"! NOTES (generation):
"! - IMPROVISED: the sample binds the ObjectHeader to {/ProductCollection/0} and
"!   its title/number/attributes to model fields (with a Currency type formatter
"!   on number). The port carries no model, so those bindings are resolved to the
"!   static values of the first ProductCollection product (Notebook Basic 15).
CLASS z2ui5_cl_api_app_460 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_460 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_api_xml=>factory( ).

    " binding {/ProductCollection/0} + field bindings resolved to literals (see NOTES)
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->open( `ObjectHeader`
            )->a( n = `title`      v = `Notebook Basic 15`
            )->a( n = `number`     v = `956.00`
            )->a( n = `numberUnit` v = `EUR`
            )->a( n = `class`      v = `sapUiResponsivePadding--header`

            )->open( `statuses`
                )->leaf( `ObjectStatus`
                    )->a( n = `text`  v = `Some Damaged`
                    )->a( n = `state` v = `Error`
                )->leaf( `ObjectStatus`
                    )->a( n = `text`  v = `In Stock`
                    )->a( n = `state` v = `Success`

            )->shut(

            )->leaf( `ObjectAttribute`
                )->a( n = `text` v = `4.2 KG`
            )->leaf( `ObjectAttribute`
                )->a( n = `text` v = `30 x 18 x 3 cm`
            )->leaf( `ObjectAttribute`
                )->a( n = `text` v = `Notebook Basic 15 with 2,80 GHz quad core, 15" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`
            )->leaf( `ObjectAttribute`
                )->a( n = `text`   v = `www.sap.com`
                )->a( n = `active` v = `true`
                )->a( n = `press`  v = client->_event_client( val   = client->cs_event-open_new_tab
                                                                 t_arg = VALUE #( ( `http://www.sap.com` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
