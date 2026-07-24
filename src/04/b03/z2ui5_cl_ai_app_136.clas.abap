CLASS z2ui5_cl_ai_app_136 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_136 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:f`    v = `sap.f`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `height`     v = `100%`

        )->open( `Page`
            )->open( `content`
                )->open( n = `SidePanel` ns = `f`
                    )->a( n = `id`     v = `mySidePanel`
                    )->a( n = `toggle` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Side panel toggled` ) ) )

                    )->open( n = `mainContent` ns = `f`
                        )->leaf( `Button`
                            )->a( n = `text` v = `Button 1`
                        )->leaf( `Button`
                            )->a( n = `text` v = `Button 2`
                        )->open( `VBox`
                            )->a( n = `class` v = `sapUiSmallMarginTopBottom`
                            )->leaf( `Label`
                                )->a( n = `text` v = `Prevent next toggle (expand) event`
                            )->leaf( `Switch`
                                )->a( n = `id`    v = `preventExpand`
                                )->a( n = `type`  v = `AcceptReject`
                                )->a( n = `class` v = `sapUiSmallMarginBottom`
                            )->leaf( `Label`
                                )->a( n = `text` v = `Prevent next toggle (collapse) event`
                            )->leaf( `Switch`
                                )->a( n = `id`    v = `preventCollapse`
                                )->a( n = `type`  v = `AcceptReject`
                                )->a( n = `class` v = `sapUiSmallMarginBottom`

                        )->shut(
                        )->leaf( `Text`
                            )->a( n = `text` v = `Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ` &&
                                                 `ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint ` &&
                                                 `occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum`
                        )->leaf( `Text`
                            )->a( n = `text` v = `Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ` &&
                                                 `ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint ` &&
                                                 `occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum`
                        )->leaf( `Text`
                            )->a( n = `text` v = `Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ` &&
                                                 `ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint ` &&
                                                 `occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum`
                        )->leaf( `Text`
                            )->a( n = `text` v = `Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ` &&
                                                 `ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint ` &&
                                                 `occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum`
                        )->leaf( `Text`
                            )->a( n = `text` v = `Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ` &&
                                                 `ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint ` &&
                                                 `occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum`
                        )->leaf( `Text`
                            )->a( n = `text` v = `Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ` &&
                                                 `ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint ` &&
                                                 `occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum`
                        )->leaf( `Text`
                            )->a( n = `text` v = `Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ` &&
                                                 `ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint ` &&
                                                 `occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum`
                        )->leaf( `Text`
                            )->a( n = `text` v = `Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ` &&
                                                 `ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint ` &&
                                                 `occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum`
                        )->leaf( `Text`
                            )->a( n = `text` v = `Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ` &&
                                                 `ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint ` &&
                                                 `occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum`
                        )->leaf( `Text`
                            )->a( n = `text` v = `Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ` &&
                                                 `ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint ` &&
                                                 `occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum`

                    )->shut(

                    )->open( n = `items` ns = `f`
                        )->open( n = `SidePanelItem` ns = `f`
                            )->a( n = `icon` v = `sap-icon://building`
                            )->a( n = `text` v = `Go to office`
                            )->open( `VBox`
                                )->leaf( `Text`
                                    )->a( n = `text`  v = `Static Content`
                                    )->a( n = `class` v = `sapUiSmallMarginBottom`
                                )->leaf( `Text`
                                    )->a( n = `text` v = `Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.`
                                )->leaf( `Switch`
                                )->leaf( `Button`
                                    )->a( n = `text` v = `Press me` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
