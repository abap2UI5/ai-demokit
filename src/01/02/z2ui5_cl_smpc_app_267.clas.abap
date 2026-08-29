" @keywords dynamicsidecontent dynamic side content sap.ui.layout dynamicsidecontentequalsplit html vbox title image text toolbar
" @summary The side content and the main content take 50%/50% of the container on all screen sizes except on phone screens where there is a button implemented to toggle between each other.
CLASS z2ui5_cl_smpc_app_267 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA toggle_enabled TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_267 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      " the original enables the Toggle button only on breakpoint S; the
      " breakpointChanged round-trip below keeps the flag in sync
      toggle_enabled = abap_false.
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " handleToggleClick calls DynamicSideContent.toggle() - reproduced
    " roundtrip-free with control_by_id (a public control method). The Slider's
    " liveChange sets the container width through jQuery in the original, and
    " that IS reproduced, roundtrip-free too: the `css` control method writes
    " the width onto the container Page's DOM node, since sap.m.Page has no
    " width property to bind. This comment said the opposite - no abap2UI5
    " equivalent, and a two-way bound Slider value - until 2026-08-21; it had
    " been left behind by the 2026-08-05 change that added the wire, which the
    " sidecar has described correctly ever since. The Slider keeps the
    " original's literal value=100. The img> model folds to the mock's literal
    " URLs.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        " the sample's own style.css - the view carries sapUiDSCExplored and sapUiDSCRightText and the
        " rules behind them have to come with it (apps 122/124/133/138).
        " \{ \} escaped: the XMLView parser reads an unescaped brace as a binding
        )->tag( n = `HTML` ns = `core`
            )->a( n = `content` v = `<style>.sapUiDSCRightText\{font-size:0.8rem\}.sapUiDSC.sapUiDSCExplored h1\{font-size:2rem\}</style>`

        )->ele( `Page`
            )->a( n = `showHeader`    v = `false`
            )->a( n = `showNavButton` v = `false`

            )->ele( `Page`
                )->a( n = `id`            v = `sideContentContainer`
                )->a( n = `showHeader`    v = `false`
                )->a( n = `showNavButton` v = `false`

                )->ele( n = `DynamicSideContent` ns = `l`
                    )->a( n = `id`                v = `DynamicSideContent`
                    )->a( n = `class`             v = `sapUiDSCExplored sapUiContentPadding`
                    )->a( n = `containerQuery`    v = `true`
                    )->a( n = `equalSplit`        v = `true`
                    )->a( n = `breakpointChanged` v = client->_event( val = `BREAKPOINT_CHANGED` arg = `${$parameters>/currentBreakpoint}` )

                    )->ele( `VBox`
                        )->tag( `Title`
                            )->a( n = `level` v = `H1`
                            )->a( n = `text`  v = `Main content`
                        )->tag( `Image`
                            )->a( n = `src`           v = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7777-large.jpg`
                            )->a( n = `densityAware`  v = `false`
                            )->a( n = `width`         v = `10em`
                        )->tag( `Text`
                            )->a( n = `text` v = `Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor `
                                              && `incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud `
                                              && `exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure `
                                              && `dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.`
                                              && ` Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt `
                                              && `mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, `
                                              && `sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim `
                                              && `veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo `
                                              && `consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum `
                                              && `dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt `
                                              && `in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, `
                                              && `consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore `
                                              && `magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi `
                                              && `ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in `
                                              && `voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat `
                                              && `cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.`
                                              && ` Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor `
                                              && `incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud `
                                              && `exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure `
                                              && `dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.`
                                              && ` Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt `
                                              && `mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, `
                                              && `sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim `
                                              && `veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo `
                                              && `consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum `
                                              && `dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt `
                                              && `in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, `
                                              && `consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore `
                                              && `magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi `
                                              && `ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in `
                                              && `voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat `
                                              && `cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.`

                    )->end(

                    )->ele( n = `sideContent` ns = `l`
                        )->ele( `VBox`
                            )->tag( `Title`
                                )->a( n = `level` v = `H1`
                                )->a( n = `text`  v = `Side content`
                            )->tag( `Image`
                                )->a( n = `src`          v = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6100-large.jpg`
                                )->a( n = `densityAware` v = `false`
                                )->a( n = `width`        v = `10em`
                            )->tag( `Text`
                                )->a( n = `class` v = `sapUiDSCRightText`
                                )->a( n = `text`  v = `Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor `
                                                   && `incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud `
                                                   && `exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure `
                                                   && `dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.`
                                                   && ` Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt `
                                                   && `mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, `
                                                   && `sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim `
                                                   && `veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo `
                                                   && `consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum `
                                                   && `dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt `
                                                   && `in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, `
                                                   && `consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore `
                                                   && `magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi `
                                                   && `ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in `
                                                   && `voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat `
                                                   && `cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.`
                                                   && ` Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor `
                                                   && `incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud `
                                                   && `exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure `
                                                   && `dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.`
                                                   && ` Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt `
                                                   && `mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, `
                                                   && `sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim `
                                                   && `veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo `
                                                   && `consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum `
                                                   && `dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt `
                                                   && `in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, `
                                                   && `consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore `
                                                   && `magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi `
                                                   && `ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in `
                                                   && `voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat `
                                                   && `cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.`

                        )->end(
                    )->end(
                )->end(
            )->end(

            )->ele( `footer`
                )->ele( `Toolbar`
                    )->tag( `Button`
                        )->a( n = `text`    v = `Toggle`
                        )->a( n = `type`    v = `Accept`
                        )->a( n = `id`      v = `equalSplitToggleButton`
                        )->a( n = `enabled` v = client->_bind( toggle_enabled )
                        )->a( n = `press`   v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                          t_arg = VALUE #( ( `DynamicSideContent` ) ( `toggle` ) ) )
                    )->tag( `Slider`
                        )->a( n = `id`      v = `DSCWidthSlider`
                        )->a( n = `value`   v = `100`
                        " handleSliderChange: the container is a sap.m.Page, which
                        " has no width property - the `css` control method writes
                        " the percentage onto its DOM node like the original jQuery
                        )->a( n = `liveChange` v = client->follow_up_action(
                                  val   = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( `sideContentContainer` )
                                                   ( `css` )
                                                   ( `width` )
                                                   ( `${$parameters>/value} + '%'` ) ) )
                        " onBeforeRendering: setVisible(!Device.system.phone) -
                        " the shared device> model expresses that declaratively
                        )->a( n = `visible` v = |\{= !$\{device>/system/phone\}\}|

                    ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `BREAKPOINT_CHANGED`.
      " _updateToggleButtonState: the Toggle button is enabled on the S
      " breakpoint only
      toggle_enabled = xsdbool( client->get_event_arg( ) = `S` ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
