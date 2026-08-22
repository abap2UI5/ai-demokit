" @keywords menu sap.m menuendcontent vbox button menuitem
" @summary EndContent (Button and/or Icon) can be added to some of the menu items.
CLASS z2ui5_cl_smpc_app_440 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_440 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->ele( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->ele( `Button`
                )->a( n = `id`           v = `button1`
                )->a( n = `text`         v = `Open Menu`
                )->a( n = `ariaHasPopup` v = `Menu`
                " the controller's lazy Fragment.load / isOpen / close / openBy toggle,
                " roundtrip-free and anchored to the pressed button
                )->a( n = `press`        v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                       t_arg = VALUE #( ( `endContentMenu` ) ( `toggleBy` ) ( `$event.oSource.sId` ) ) )

                )->ele( `dependents`
                    )->ele( `Menu`
                        )->a( n = `id` v = `endContentMenu`

                        )->tag( `MenuItem`
                            )->a( n = `text` v = `New`
                            )->a( n = `icon` v = `sap-icon://create`
                        )->ele( `MenuItem`
                            )->a( n = `text` v = `Open`
                            )->a( n = `icon` v = `sap-icon://open-folder`

                            )->ele( `endContent`
                                )->tag( `Button`
                                    )->a( n = `type` v = `Transparent`
                                    )->a( n = `icon` v = `sap-icon://open-folder`
                                )->tag( `Button`
                                    )->a( n = `type` v = `Transparent`
                                    )->a( n = `icon` v = `sap-icon://favorite`

                            )->end(
                        )->end(

                        )->ele( `MenuItem`
                            )->a( n = `text` v = `Save`
                            )->a( n = `icon` v = `sap-icon://save`

                            )->ele( `items`
                                )->tag( `MenuItem`
                                    )->a( n = `text` v = `Save locally`
                                    )->a( n = `icon` v = `sap-icon://save`
                                )->ele( `MenuItem`
                                    )->a( n = `text` v = `Save to cloud`
                                    )->a( n = `icon` v = `sap-icon://upload-to-cloud`

                                    )->ele( `endContent`
                                        )->tag( `Button`
                                            )->a( n = `type` v = `Transparent`
                                            )->a( n = `icon` v = `sap-icon://open-folder`
                                        )->tag( `Button`
                                            )->a( n = `type` v = `Transparent`
                                            )->a( n = `icon` v = `sap-icon://upload-to-cloud`

                                    )->end(
                                )->end(

                                )->tag( `MenuItem`
                                    )->a( n = `text` v = `Save to memory`
                                    )->a( n = `icon` v = `sap-icon://approvals` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
