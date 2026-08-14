CLASS z2ui5_cl_smpc_app_344 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA show_side      TYPE abap_bool.
    DATA toggle_enabled TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_344 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      show_side = abap_true.          " DynamicSideContent.showSideContent default
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " sideContentPosition Begin is what this sample adds over the plain
    " DynamicSideContent one (app 138); the controller behaviours are wired the
    " same way: breakpointChanged carries its currentBreakpoint to the backend
    " and enables the Toggle button on S, the Toggle press flips the bound
    " showSideContent (the property toggle( ) writes), and the Slider resizes
    " the container's DOM node through the css control method - sap.m.Page has
    " no width property, exactly the gap the original's jQuery width( ) works
    " around. style.css is injected as a core:HTML style leaf.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns`      v = `sap.m`

        )->tag( n = `HTML` ns = `core`
            )->a( n = `content` v = `<style>.sapUiDSC.sapUiDSCExplored h1\{font-size:1.5rem\}</style>`

        )->ele( `Page`
            )->a( n = `showHeader`    v = `false`
            )->a( n = `showNavButton` v = `false`

            )->ele( `Page`
                )->a( n = `id`            v = `sideContentContainer`
                )->a( n = `showHeader`    v = `false`
                )->a( n = `showNavButton` v = `false`

                )->ele( n = `DynamicSideContent` ns = `l`
                    )->a( n = `id`                  v = `DynamicSideContent`
                    )->a( n = `class`               v = `sapUiDSCExplored sapUiContentPadding`
                    )->a( n = `sideContentFallDown` v = `BelowM`
                    )->a( n = `sideContentPosition` v = `Begin`
                    )->a( n = `containerQuery`      v = `true`
                    )->a( n = `showSideContent`     v = client->_bind( show_side )
                    )->a( n = `breakpointChanged`   v = client->_event( val   = `BP_CHANGED`
                                                                        t_arg = VALUE #( ( `${$parameters>/currentBreakpoint}` ) ) )

                    )->tag( `Title`
                        )->a( n = `level` v = `H1`
                        )->a( n = `text`  v = `Main content positioned after side content`

                    )->tag( `Text`
                    )->a( n = `text` v = `Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut ` &&
                                         `aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui ` &&
                                         `officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis ` &&
                                         `nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat ` &&
                                         `cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna ` &&
                                         `aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat ` &&
                                         `nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod ` &&
                                         `tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in ` &&
                                         `voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, ` &&
                                         `consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ` &&
                                         `Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est ` &&
                                         `laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ` &&
                                         `ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui ` &&
                                         `officia deserunt mollit anim id est laborum.`

                    )->ele( n = `sideContent` ns = `l`
                        )->tag( `Title`
                            )->a( n = `level` v = `H1`
                            )->a( n = `text`  v = `Side content positioned before main content`

                        )->tag( `Text`
                        )->a( n = `text` v = `Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut ` &&
                                             `aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa ` &&
                                             `qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, ` &&
                                             `quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint ` &&
                                             `occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et ` &&
                                             `dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum ` &&
                                             `dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, ` &&
                                             `sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in ` &&
                                             `reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum ` &&
                                             `dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea ` &&
                                             `commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia ` &&
                                             `deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud ` &&
                                             `exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat ` &&
                                             `cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.`

                    )->end(
                )->end(
            )->end(
            )->ele( `footer`
                )->ele( `Toolbar`
                    )->tag( `Button`
                        )->a( n = `text`    v = `Toggle`
                        )->a( n = `type`    v = `Accept`
                        )->a( n = `press`   v = client->_event( `TOGGLE` )
                        )->a( n = `id`      v = `toggleButton`
                        )->a( n = `enabled` v = client->_bind( toggle_enabled )

                    )->tag( `Slider`
                        )->a( n = `id`         v = `DSCWidthSlider`
                        )->a( n = `value`      v = `100`
                        )->a( n = `visible`    v = `{= !${device>/system/phone} }`
                        )->a( n = `liveChange` v = client->follow_up_action(
                                  val   = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( `sideContentContainer` )
                                                   ( `css` )
                                                   ( `width` )
                                                   ( `${$parameters>/value} + '%'` ) ) )

                    )->tag( `Text`
                        )->a( n = `id`      v = `DSCWidthHintText`
                        )->a( n = `text`    v = `Best view in full screen mode`
                        )->a( n = `visible` v = `{= !${device>/system/phone} }` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `BP_CHANGED`.
        " _updateToggleButtonState: the button is only enabled on breakpoint S
        toggle_enabled = xsdbool( client->get_event_arg( ) = `S` ).

      WHEN `TOGGLE`.
        " DynamicSideContent.toggle( ) swaps main and side content on S; the
        " bound showSideContent is the property that setter writes
        show_side = xsdbool( show_side = abap_false ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
