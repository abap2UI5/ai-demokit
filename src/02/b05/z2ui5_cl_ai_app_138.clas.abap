CLASS z2ui5_cl_ai_app_138 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA hint_visible TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_138 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      hint_visible = abap_true.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->open( `Page`
            )->a( n = `showHeader`    v = `false`
            )->a( n = `showNavButton` v = `false`

            )->open( `Page`
                )->a( n = `id`            v = `sideContentContainer`
                )->a( n = `showHeader`    v = `false`
                )->a( n = `showNavButton` v = `false`

                )->open( n = `DynamicSideContent` ns = `l`
                    )->a( n = `id`                  v = `DynamicSideContent`
                    )->a( n = `class`               v = `sapUiDSCExplored sapUiContentPadding`
                    )->a( n = `sideContentFallDown` v = `BelowM`
                    )->a( n = `containerQuery`       v = `true`
                    )->a( n = `breakpointChanged`    v = client->_event( `BP_CHANGED` )

                    )->leaf( `Title`
                        )->a( n = `level` v = `H1`
                        )->a( n = `text`  v = `Main content`
                    )->leaf( `Text`
                    )->a( n = `text` v = `Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ` &&
                                         `ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint ` &&
                                         `occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.`
                    )->open( n = `sideContent` ns = `l`
                        )->leaf( `Title`
                            )->a( n = `level` v = `H1`
                            )->a( n = `text`  v = `Side content`
                        )->leaf( `Text`
                        )->a( n = `text` v = `Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ` &&
                                             `ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint ` &&
                                             `occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.`

                    )->shut(
                )->shut(
            )->shut(
            )->open( `footer`
                )->open( `Toolbar`
                    )->leaf( `Button`
                        )->a( n = `text`  v = `Toggle`
                        )->a( n = `type`  v = `Accept`
                        )->a( n = `press` v = client->_event( `TOGGLE` )
                        )->a( n = `id`    v = `toggleButton`
                    )->leaf( `Slider`
                        )->a( n = `id`         v = `DSCWidthSlider`
                        )->a( n = `value`      v = `100`
                        )->a( n = `liveChange` v = client->_event( `SLIDER` )
                    )->leaf( `Text`
                        )->a( n = `id`      v = `DSCWidthHintText`
                        )->a( n = `text`    v = `Best view in full screen mode`
                        )->a( n = `visible` v = client->_bind( hint_visible ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
