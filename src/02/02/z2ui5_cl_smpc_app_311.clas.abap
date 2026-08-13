CLASS z2ui5_cl_smpc_app_311 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_311 IMPLEMENTATION.

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
        )->a( n = `xmlns:u`   v = `sap.ui.unified`

        )->open( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->open( `Button`
                )->a( n = `id`           v = `openMenu`
                )->a( n = `text`         v = `Open Menu`
                " handlePressOpenMenu does menu.open( kbd, button, BeginTop, BeginBottom, button );
                " the openBy dispatch falls back to exactly that call for a
                " sap.ui.unified.Menu, anchored on the pressed button
                )->a( n = `press`        v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                       t_arg = VALUE #( ( `theMenu` ) ( `openBy` ) ( `$event.oSource.sId` ) ) )
                )->a( n = `ariaHasPopup` v = `Menu`

                " the controller adds the loaded fragment with addDependent; the
                " dependents aggregation is the declarative equivalent (app 060/227)
                )->open( `dependents`
                    )->open( n = `Menu` ns = `u`
                        )->a( n = `id` v = `theMenu`

                        )->leaf( n = `MenuItem` ns = `u`
                            )->a( n = `text` v = `New`
                            )->a( n = `icon` v = `sap-icon://create`
                        )->leaf( n = `MenuItem` ns = `u`
                            )->a( n = `text` v = `Open`
                            )->a( n = `icon` v = `sap-icon://open-folder`

                        )->open( n = `MenuItem` ns = `u`
                            )->a( n = `text` v = `Save`
                            )->a( n = `icon` v = `sap-icon://save`

                            )->open( n = `submenu` ns = `u`
                                )->open( n = `Menu` ns = `u`
                                    " MenuItemGroup is a control @since 1.127 - kept 1:1 (POST_171)
                                    )->open( n = `MenuItemGroup` ns = `u`
                                        )->a( n = `itemSelectionMode` v = `SingleSelect`

                                        )->open( n = `items` ns = `u`
                                            )->leaf( n = `MenuItem` ns = `u`
                                                )->a( n = `text` v = `Save locally`
                                                )->a( n = `icon` v = `sap-icon://save`
                                            )->leaf( n = `MenuItem` ns = `u`
                                                )->a( n = `text` v = `Save to cloud`
                                                )->a( n = `icon` v = `sap-icon://upload-to-cloud`
                                            )->leaf( n = `MenuItem` ns = `u`
                                                )->a( n = `text` v = `Save to memory`
                                                )->a( n = `icon` v = `sap-icon://approvals`

                                        )->shut(
                                    )->shut(
                                )->shut(
                            )->shut(
                        )->shut(

                        )->open( n = `MenuItemGroup` ns = `u`
                            )->a( n = `itemSelectionMode` v = `MultiSelect`

                            )->open( n = `items` ns = `u`
                                )->leaf( n = `MenuItem` ns = `u`
                                    )->a( n = `text`     v = `Bold`
                                    )->a( n = `icon`     v = `sap-icon://bold-text`
                                    )->a( n = `selected` v = `true`
                                )->leaf( n = `MenuItem` ns = `u`
                                    )->a( n = `text`     v = `Italic`
                                    )->a( n = `icon`     v = `sap-icon://italic-text`
                                    )->a( n = `selected` v = `true`
                                )->leaf( n = `MenuItem` ns = `u`
                                    )->a( n = `text` v = `Underline`
                                    )->a( n = `icon` v = `sap-icon://underline-text`

                            )->shut(
                        )->shut(

                        )->open( n = `MenuItemGroup` ns = `u`
                            )->a( n = `itemSelectionMode` v = `SingleSelect`

                            )->open( n = `items` ns = `u`
                                )->leaf( n = `MenuItem` ns = `u`
                                    )->a( n = `text`     v = `Left Alignment`
                                    )->a( n = `icon`     v = `sap-icon://text-align-left`
                                    )->a( n = `selected` v = `true`
                                )->leaf( n = `MenuItem` ns = `u`
                                    )->a( n = `text` v = `Center Alignment`
                                    )->a( n = `icon` v = `sap-icon://text-align-center`
                                )->leaf( n = `MenuItem` ns = `u`
                                    )->a( n = `text` v = `Right Alignment`
                                    )->a( n = `icon` v = `sap-icon://text-align-right`

                            )->shut(
                        )->shut(

                        )->leaf( n = `MenuItem` ns = `u`
                            )->a( n = `text` v = `Properties`
                            )->a( n = `icon` v = `sap-icon://action-settings`
                        )->leaf( n = `MenuItem` ns = `u`
                            )->a( n = `text` v = `Exit`
                            )->a( n = `icon` v = `sap-icon://decline` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
