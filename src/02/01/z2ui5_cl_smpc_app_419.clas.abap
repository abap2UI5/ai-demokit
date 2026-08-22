" @keywords menu sap.m menuselectable vbox button menuitem menuitemgroup
" @summary Some menu items can be added to groups to allow single or multiple item selection.
CLASS z2ui5_cl_smpc_app_419 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_419 IMPLEMENTATION.

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

        )->ele( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->ele( `Button`
                )->a( n = `id`           v = `button`
                )->a( n = `text`         v = `Open Menu`
                )->a( n = `ariaHasPopup` v = `Menu`
                " toggle the menu anchored to the pressed button, roundtrip-free
                " (1:1 with the sample's client-side isOpen()/openBy/close)
                )->a( n = `press`        v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                       t_arg = VALUE #( ( `selectableMenu` ) ( `toggleBy` ) ( `$event.oSource.sId` ) ) )

                )->ele( `dependents`
                    )->ele( `Menu`
                        )->a( n = `id` v = `selectableMenu`

                        )->tag( `MenuItem`
                            )->a( n = `text` v = `New`
                            )->a( n = `icon` v = `sap-icon://create`
                        )->ele( `MenuItem`
                            )->a( n = `text` v = `Open`
                            )->a( n = `icon` v = `sap-icon://open-folder`

                            )->ele( `endContent`
                                )->tag( `Button`
                                    )->a( n = `type`    v = `Transparent`
                                    )->a( n = `icon`    v = `sap-icon://open-folder`
                                    )->a( n = `tooltip` v = `Open Folder`
                                )->tag( `Button`
                                    )->a( n = `type`    v = `Transparent`
                                    )->a( n = `icon`    v = `sap-icon://favorite`
                                    )->a( n = `tooltip` v = `Favorite`

                            )->end(
                        )->end(

                        )->ele( `MenuItem`
                            )->a( n = `text` v = `Save`
                            )->a( n = `icon` v = `sap-icon://save`

                            )->ele( `items`
                                )->ele( `MenuItemGroup`
                                    )->a( n = `itemSelectionMode` v = `SingleSelect`

                                    )->ele( `items`
                                        )->tag( `MenuItem`
                                            )->a( n = `text` v = `Save locally`
                                            )->a( n = `icon` v = `sap-icon://save`
                                        )->ele( `MenuItem`
                                            )->a( n = `text` v = `Save to cloud`
                                            )->a( n = `icon` v = `sap-icon://upload-to-cloud`

                                            )->ele( `endContent`
                                                )->tag( `Button`
                                                    )->a( n = `type`    v = `Transparent`
                                                    )->a( n = `icon`    v = `sap-icon://open-folder`
                                                    )->a( n = `tooltip` v = `Open Folder`
                                                )->tag( `Button`
                                                    )->a( n = `type`    v = `Transparent`
                                                    )->a( n = `icon`    v = `sap-icon://favorite`
                                                    )->a( n = `tooltip` v = `Favorite`

                                            )->end(
                                        )->end(

                                        )->tag( `MenuItem`
                                            )->a( n = `text` v = `Save to memory`
                                            )->a( n = `icon` v = `sap-icon://approvals`

                                    )->end(
                                )->end(
                            )->end(
                        )->end(

                        )->ele( `MenuItemGroup`
                            )->a( n = `itemSelectionMode` v = `MultiSelect`

                            )->ele( `items`
                                )->tag( `MenuItem`
                                    )->a( n = `text`     v = `Bold`
                                    )->a( n = `icon`     v = `sap-icon://bold-text`
                                    )->a( n = `selected` v = `true`
                                )->tag( `MenuItem`
                                    )->a( n = `text`     v = `Italic`
                                    )->a( n = `icon`     v = `sap-icon://italic-text`
                                    )->a( n = `selected` v = `true`
                                )->tag( `MenuItem`
                                    )->a( n = `text` v = `Underline`
                                    )->a( n = `icon` v = `sap-icon://underline-text`

                            )->end(
                        )->end(

                        )->ele( `MenuItemGroup`
                            )->a( n = `itemSelectionMode` v = `SingleSelect`

                            )->ele( `items`
                                )->tag( `MenuItem`
                                    )->a( n = `text`     v = `Left Alignment`
                                    )->a( n = `icon`     v = `sap-icon://text-align-left`
                                    )->a( n = `selected` v = `true`
                                )->tag( `MenuItem`
                                    )->a( n = `text` v = `Center Alignment`
                                    )->a( n = `icon` v = `sap-icon://text-align-center`
                                )->tag( `MenuItem`
                                    )->a( n = `text` v = `Right Alignment`
                                    )->a( n = `icon` v = `sap-icon://text-align-right`

                            )->end(
                        )->end(

                        )->tag( `MenuItem`
                            )->a( n = `text` v = `Properties`
                            )->a( n = `icon` v = `sap-icon://action-settings`
                        )->tag( `MenuItem`
                            )->a( n = `text` v = `Exit`
                            )->a( n = `icon` v = `sap-icon://decline` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
