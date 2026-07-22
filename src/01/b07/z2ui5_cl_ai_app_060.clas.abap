CLASS z2ui5_cl_ai_app_060 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_060 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->open( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->open( `Button`
                )->a( n = `id`           v = `button`
                )->a( n = `text`         v = `Open Menu`
                )->a( n = `ariaHasPopup` v = `Menu`
                " toggle the menu anchored to the pressed button, roundtrip-free
                " (1:1 with the sample's client-side isOpen()/openBy/close)
                )->a( n = `press`        v = client->_event_client( val   = client->cs_event-control_by_id
                                                                    t_arg = VALUE #( ( `theMenu` ) ( `toggleBy` ) ( `$event.oSource.sId` ) ) )

                )->open( `dependents`
                    )->open( `Menu`
                        )->a( n = `id`           v = `theMenu`
                        " compose the toast on the frontend (1:1 with the sample's
                        " MessageToast.show("Action triggered on item: " + item.getText())),
                        " roundtrip-free - {0} is filled by the client-resolved item text
                        )->a( n = `itemSelected` v = client->_event_client( val   = client->cs_event-control_global
                                                                            t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Action triggered on item: {0}` ) ( `${$parameters>/item}.getText()` ) ) )

                        )->leaf( `MenuItem`
                            )->a( n = `text` v = `Hide Existing Sites`
                        )->leaf( `MenuItem`
                            )->a( n = `text` v = `Simulate Visitor Traffic`
                        )->open( `MenuItem`
                            )->a( n = `text` v = `Create New Site`

                            )->open( `items`
                                )->leaf( `MenuItem`
                                    )->a( n = `text` v = `Official Store`
                                )->leaf( `MenuItem`
                                    )->a( n = `text` v = `Partner Store`
                                )->leaf( `MenuItem`
                                    )->a( n = `text` v = `Franchise Store`
                                )->leaf( `MenuItem`
                                    )->a( n = `text` v = `Temporary Store`
                                )->leaf( `MenuItem`
                                    )->a( n = `text` v = `Other`

                            )->shut(
                        )->shut(
                        )->leaf( `MenuItem`
                            )->a( n = `text` v = `Export Map`

                    )->shut(
                )->shut(
            )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
