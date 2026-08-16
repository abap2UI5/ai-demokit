" @keywords menu sap.ui.unified menuselectable vbox button
" @summary Some menu items can be added to groups to allow single or multiple item selection.
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
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:u`   v = `sap.ui.unified`

        )->ele( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->ele( `Button`
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
                )->ele( `dependents`
                    )->ele( n = `Menu` ns = `u`
                        )->a( n = `id` v = `theMenu`

                        )->tag( n = `MenuItem` ns = `u`
                            )->a( n = `text` v = `New`
                            )->a( n = `icon` v = `sap-icon://create`
                        )->tag( n = `MenuItem` ns = `u`
                            )->a( n = `text` v = `Open`
                            )->a( n = `icon` v = `sap-icon://open-folder`

                        )->ele( n = `MenuItem` ns = `u`
                            )->a( n = `text` v = `Save`
                            )->a( n = `icon` v = `sap-icon://save`

                            )->ele( n = `submenu` ns = `u`
                                )->ele( n = `Menu` ns = `u`
                                    " MenuItemGroup is a control @since 1.127 - kept 1:1 (POST_171)
                                    )->ele( n = `MenuItemGroup` ns = `u`
                                        )->a( n = `itemSelectionMode` v = `SingleSelect`

                                        )->ele( n = `items` ns = `u`
                                            )->tag( n = `MenuItem` ns = `u`
                                                )->a( n = `text` v = `Save locally`
                                                )->a( n = `icon` v = `sap-icon://save`
                                            )->tag( n = `MenuItem` ns = `u`
                                                )->a( n = `text` v = `Save to cloud`
                                                )->a( n = `icon` v = `sap-icon://upload-to-cloud`
                                            )->tag( n = `MenuItem` ns = `u`
                                                )->a( n = `text` v = `Save to memory`
                                                )->a( n = `icon` v = `sap-icon://approvals`

                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(

                        )->ele( n = `MenuItemGroup` ns = `u`
                            )->a( n = `itemSelectionMode` v = `MultiSelect`

                            )->ele( n = `items` ns = `u`
                                )->tag( n = `MenuItem` ns = `u`
                                    )->a( n = `text`     v = `Bold`
                                    )->a( n = `icon`     v = `sap-icon://bold-text`
                                    )->a( n = `selected` v = `true`
                                )->tag( n = `MenuItem` ns = `u`
                                    )->a( n = `text`     v = `Italic`
                                    )->a( n = `icon`     v = `sap-icon://italic-text`
                                    )->a( n = `selected` v = `true`
                                )->tag( n = `MenuItem` ns = `u`
                                    )->a( n = `text` v = `Underline`
                                    )->a( n = `icon` v = `sap-icon://underline-text`

                            )->end(
                        )->end(

                        )->ele( n = `MenuItemGroup` ns = `u`
                            )->a( n = `itemSelectionMode` v = `SingleSelect`

                            )->ele( n = `items` ns = `u`
                                )->tag( n = `MenuItem` ns = `u`
                                    )->a( n = `text`     v = `Left Alignment`
                                    )->a( n = `icon`     v = `sap-icon://text-align-left`
                                    )->a( n = `selected` v = `true`
                                )->tag( n = `MenuItem` ns = `u`
                                    )->a( n = `text` v = `Center Alignment`
                                    )->a( n = `icon` v = `sap-icon://text-align-center`
                                )->tag( n = `MenuItem` ns = `u`
                                    )->a( n = `text` v = `Right Alignment`
                                    )->a( n = `icon` v = `sap-icon://text-align-right`

                            )->end(
                        )->end(

                        )->tag( n = `MenuItem` ns = `u`
                            )->a( n = `text` v = `Properties`
                            )->a( n = `icon` v = `sap-icon://action-settings`
                        )->tag( n = `MenuItem` ns = `u`
                            )->a( n = `text` v = `Exit`
                            )->a( n = `icon` v = `sap-icon://decline` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
