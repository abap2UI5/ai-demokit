CLASS z2ui5_cl_ai_app_060 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_060 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
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
                )->a( n = `press`        v = client->_event( val   = `OPEN_MENU`
                                                             t_arg = VALUE #( ( `$event.oSource.sId` ) ) )

                )->open( `dependents`
                    )->open( `Menu`
                        )->a( n = `id`           v = `theMenu`
                        )->a( n = `itemSelected` v = client->_event( val   = `MENU_ACTION`
                                                                     t_arg = VALUE #( ( `${$parameters>/item/text}` ) ) )

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


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `OPEN_MENU`.
        " toggle: open the menu anchored to the button if closed, close it if open (1:1 with the sample's isOpen() check)
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( `theMenu` ) ( `` ) ( `toggleBy` ) ( client->get_event_arg( ) ) ) ).

      WHEN `MENU_ACTION`.
        client->message_toast_display( |Action triggered on item: { client->get_event_arg( ) }| ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
