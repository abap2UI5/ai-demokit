CLASS z2ui5_cl_dmo_app_136 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA prevent_expand   TYPE abap_bool.
    DATA prevent_collapse TYPE abap_bool.
    DATA panel_expanded   TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_event.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_dmo_app_136 IMPLEMENTATION.

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
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:f`    v = `sap.f`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `height`     v = `100%`

        )->open( `Page`
            )->open( `content`
                )->open( n = `SidePanel` ns = `f`
                    )->a( n = `id`     v = `mySidePanel`
                    " onToggle vetoes the NEXT toggle when the matching switch is on
                    " (preventDefault) and resets that switch. The framework's veto flag
                    " is baked into the wire at RENDER time - which is enough here,
                    " because the direction of the next toggle is known: an expanded
                    " panel can only collapse next. So the flag is the switch that
                    " applies to that direction, and the round-trip re-bakes it
                    )->a( n = `toggle` v = client->_event( val    = `TOGGLE`
                                                           t_arg  = VALUE #( ( `${$parameters>/expanded}` ) )
                                                           s_ctrl = VALUE #( check_prevent_default =
                                                             COND #( WHEN panel_expanded = abap_true
                                                                     THEN prevent_collapse
                                                                     ELSE prevent_expand ) ) )

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
                                )->a( n = `state` v = client->_bind( prevent_expand )
                                )->a( n = `type`  v = `AcceptReject`
                                )->a( n = `class` v = `sapUiSmallMarginBottom`
                            )->leaf( `Label`
                                )->a( n = `text` v = `Prevent next toggle (collapse) event`
                            )->leaf( `Switch`
                                )->a( n = `id`    v = `preventCollapse`
                                )->a( n = `state` v = client->_bind( prevent_collapse )
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


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `TOGGLE`.
        " the event still reaches the backend when the veto fired (the framework
        " calls preventDefault synchronously and sends the event anyway), so the
        " branch is the original's: on a vetoed direction, toast and reset that
        " switch; otherwise the panel really toggled and the new state is kept
        DATA(expanded) = xsdbool( client->get_event_arg( ) = abap_true ).
        IF expanded = abap_false AND prevent_collapse = abap_true.
          prevent_collapse = abap_false.
          client->message_toast_display( `I am prevented COLLAPSE event` ).
        ELSEIF expanded = abap_true AND prevent_expand = abap_true.
          prevent_expand = abap_false.
          client->message_toast_display( `I am prevented EXPAND event` ).
        ELSE.
          panel_expanded = expanded.
        ENDIF.
        " re-render: the veto flag is baked into the wire, so it has to be
        " rebuilt from the switch states the round-trip just brought back
        view_display( ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
