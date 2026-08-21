" @keywords dynamicsidecontent dynamic side content sap.ui.layout title text toolbar button slider
" @summary Attaches side content area which is next to the main content of the page on larger screens taking different ratios between the two on different screen sizes and on phone size screens the side content area falls down under the main content area.
CLASS z2ui5_cl_smpc_app_138 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA hint_visible   TYPE abap_bool.
    DATA show_side      TYPE abap_bool.
    DATA toggle_enabled TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_138 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      hint_visible = abap_true.
      " DynamicSideContent.showSideContent default
      show_side    = abap_true.
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " two of the three controller behaviours are reproduced: breakpointChanged
    " carries its currentBreakpoint parameter to the backend, which enables the
    " Toggle button on breakpoint S exactly as _updateToggleButtonState does,
    " and the Toggle press flips the bound showSideContent (the property behind
    " toggle( )). The Slider's DOM resize is roundtrip-free too since the `css`
    " control method exists: sap.m.Page has no width property, so the width goes
    " onto the container's DOM node, like the original's jQuery .width( )
    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        " the sample's own style.css - the view carries sapUiDSCExplored and the rule behind it has to come with it (apps 122/124/133)
        " \{ \} escaped: the XMLView parser reads an unescaped brace as a binding
        )->tag( n = `HTML` ns = `core`
            )->a( n = `content` v = `<style>.sapUiDSC.sapUiDSCExplored h1\{font-size:2rem\}</style>`

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
                    )->a( n = `containerQuery`      v = `true`
                    )->a( n = `showSideContent`     v = client->_bind( show_side )
                    )->a( n = `breakpointChanged`   v = client->_event( val   = `BP_CHANGED`
                                                                        t_arg = VALUE #( ( `${$parameters>/currentBreakpoint}` ) ) )

                    )->tag( `Title`
                        )->a( n = `level` v = `H1`
                        )->a( n = `text`  v = `Main content`
                    )->tag( `Text`
                        )->a( n = `text` v = `Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ` &&
                                         `ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint ` &&
                                         `occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.`
                    )->ele( n = `sideContent` ns = `l`
                        )->tag( `Title`
                            )->a( n = `level` v = `H1`
                            )->a( n = `text`  v = `Side content`
                        )->tag( `Text`
                            )->a( n = `text` v = `Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ` &&
                                             `ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint ` &&
                                             `occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.`

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
                        )->a( n = `liveChange` v = client->follow_up_action(
                                  val   = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( `sideContentContainer` )
                                                   ( `css` )
                                                   ( `width` )
                                                   ( `${$parameters>/value} + '%'` ) ) )
                    )->tag( `Text`
                        )->a( n = `id`      v = `DSCWidthHintText`
                        )->a( n = `text`    v = `Best view in full screen mode`
                        )->a( n = `visible` v = client->_bind( hint_visible ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

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
