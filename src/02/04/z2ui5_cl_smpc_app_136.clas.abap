" @keywords sidepanel side panel sap.f single item button vbox label switch text sidepanelitem
" @summary Demonstrates the usage of Side Panel with single action item.
CLASS z2ui5_cl_smpc_app_136 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA prevent_expand   TYPE abap_bool.
    DATA prevent_collapse TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_event.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_136 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    " (!expanded && preventCollapse) || (expanded && preventExpand) - the two
    " Switch states are two-way bound, so the expression reads what the user
    " last flipped, not what the last render happened to bake in
    DATA(veto_expr) = `(!${$parameters>/expanded} && $` && client->_bind( prevent_collapse ) &&
                      `) || (${$parameters>/expanded} && $` && client->_bind( prevent_expand ) && `)`.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:f`    v = `sap.f`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `height`     v = `100%`

        )->ele( `Page`
            )->ele( `content`
                )->ele( n = `SidePanel` ns = `f`
                    )->a( n = `id`     v = `mySidePanel`
                    " onToggle reads BOTH switch states when the event fires and vetoes
                    " that firing (preventDefault). prevent_default_expr is the same
                    " decision per firing: the direction comes out of the event itself,
                    " so one wire covers both branches of the original handler. The
                    " boolean check_prevent_default cannot: it is baked into the XML at
                    " RENDER time, the Switches carry no event, and a flipped switch
                    " therefore only reached the wire on the NEXT render - one toggle
                    " too late (corrected 2026-08-23)
                    )->a( n = `toggle` v = client->_event(
                              val    = `TOGGLE`
                              t_arg  = VALUE #( ( `${$parameters>/expanded}` ) )
                              s_ctrl = VALUE #( prevent_default_expr = veto_expr ) )

                    )->ele( n = `mainContent` ns = `f`
                        )->tag( `Button`
                            )->a( n = `text` v = `Button 1`
                        )->tag( `Button`
                            )->a( n = `text` v = `Button 2`
                        )->ele( `VBox`
                            )->a( n = `class` v = `sapUiSmallMarginTopBottom`
                            )->tag( `Label`
                                )->a( n = `text` v = `Prevent next toggle (expand) event`
                            )->tag( `Switch`
                                )->a( n = `id`    v = `preventExpand`
                                )->a( n = `state` v = client->_bind( prevent_expand )
                                )->a( n = `type`  v = `AcceptReject`
                                )->a( n = `class` v = `sapUiSmallMarginBottom`
                            )->tag( `Label`
                                )->a( n = `text` v = `Prevent next toggle (collapse) event`
                            )->tag( `Switch`
                                )->a( n = `id`    v = `preventCollapse`
                                )->a( n = `state` v = client->_bind( prevent_collapse )
                                )->a( n = `type`  v = `AcceptReject`
                                )->a( n = `class` v = `sapUiSmallMarginBottom`

                        )->end(
                        )->tag( `Text`
                            )->a( n = `text` v = `Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ` &&
                                                 `ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint ` &&
                                                 `occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum`
                        )->tag( `Text`
                            )->a( n = `text` v = `Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ` &&
                                                 `ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint ` &&
                                                 `occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum`
                        )->tag( `Text`
                            )->a( n = `text` v = `Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ` &&
                                                 `ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint ` &&
                                                 `occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum`
                        )->tag( `Text`
                            )->a( n = `text` v = `Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ` &&
                                                 `ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint ` &&
                                                 `occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum`
                        )->tag( `Text`
                            )->a( n = `text` v = `Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ` &&
                                                 `ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint ` &&
                                                 `occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum`
                        )->tag( `Text`
                            )->a( n = `text` v = `Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ` &&
                                                 `ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint ` &&
                                                 `occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum`
                        )->tag( `Text`
                            )->a( n = `text` v = `Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ` &&
                                                 `ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint ` &&
                                                 `occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum`
                        )->tag( `Text`
                            )->a( n = `text` v = `Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ` &&
                                                 `ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint ` &&
                                                 `occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum`
                        )->tag( `Text`
                            )->a( n = `text` v = `Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ` &&
                                                 `ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint ` &&
                                                 `occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum`
                        )->tag( `Text`
                            )->a( n = `text` v = `Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ` &&
                                                 `ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint ` &&
                                                 `occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum`

                    )->end(

                    )->ele( n = `items` ns = `f`
                        )->ele( n = `SidePanelItem` ns = `f`
                            )->a( n = `icon` v = `sap-icon://building`
                            )->a( n = `text` v = `Go to office`
                            )->ele( `VBox`
                                )->tag( `Text`
                                    )->a( n = `text`  v = `Static Content`
                                    )->a( n = `class` v = `sapUiSmallMarginBottom`
                                )->tag( `Text`
                                    )->a( n = `text` v = `Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.`
                                )->tag( `Switch`
                                )->tag( `Button`
                                    )->a( n = `text` v = `Press me` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `TOGGLE`.
      " the event still reaches the backend when the veto fired (the framework
      " calls preventDefault synchronously and sends the event anyway), so the
      " branch is the original's: on a vetoed direction, toast and reset that
      " switch; otherwise the control has already toggled itself and there is
      " nothing for the backend to do
      DATA(expanded) = xsdbool( client->get_event_arg( ) = abap_true ).
      IF expanded = abap_false AND prevent_collapse = abap_true.
        prevent_collapse = abap_false.
        client->message_toast_display( `I am prevented COLLAPSE event` ).
      ELSEIF expanded = abap_true AND prevent_expand = abap_true.
        prevent_expand = abap_false.
        client->message_toast_display( `I am prevented EXPAND event` ).
      ENDIF.
      " deliberately NO view_display( ): the panel's expanded state and its
      " selectedItem live in the control, not in the model, so a re-render
      " would hand back a fresh tree with the side content collapsed again -
      " the sample's whole interaction. The switch reset travels with the
      " automatic model push
    ENDIF.

  ENDMETHOD.

ENDCLASS.
