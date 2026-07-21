CLASS z2ui5_cl_ai_app_013 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA show_cookie_details TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS dialog_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_013 IMPLEMENTATION.

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
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->open( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->leaf( `Button`
                )->a( n = `text`  v = `Open Cookie Settings Dialog`
                )->a( n = `press` v = client->_event( `OPEN_COOKIE_SETTINGS_DIALOG` )
                )->a( n = `class` v = `sapUiSmallMarginBottom` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `OPEN_COOKIE_SETTINGS_DIALOG`.
        " the original forces cookie details to be hidden on opening of the dialog
        show_cookie_details = abap_false.
        dialog_display( ).

      WHEN `SHOW_COOKIE_DETAILS`.
        show_cookie_details = abap_true.
        client->popup_model_update( ).
        " the original moves the focus to the Save Preferences action
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( `actionSavePreferences` ) ( client->cs_view-popup ) ( `focus` ) ) ).

      WHEN `ACCEPT_ALL_COOKIES`.
        " insert your accept all logic here
        client->popup_destroy( ).

      WHEN `REJECT_ALL_COOKIES`.
        " insert your reject all logic here
        client->popup_destroy( ).

      WHEN `SAVE_COOKIES`.
        " insert your save cookies logic here according to the user input
        client->popup_destroy( ).

      WHEN `CANCEL_PRESS`.
        IF show_cookie_details = abap_false.
          " the cancel action ignores all changes and closes the dialog
          client->popup_destroy( ).
        ELSE.
          " the cancel action navigates back to the preview
          show_cookie_details = abap_false.
          client->popup_model_update( ).
          client->follow_up_action( val   = client->cs_event-control_by_id
                                    t_arg = VALUE #( ( `actionSetPreferences` ) ( client->cs_view-popup ) ( `focus` ) ) ).
        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD dialog_display.

    DATA(popup) = z2ui5_cl_ai_xml=>factory( ).

    popup->open( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:f`    v = `sap.f`
        )->a( n = `xmlns:grid` v = `sap.ui.layout.cssgrid`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->open( `Dialog`
            )->a( n = `title`        v = `Cookie Settings (Sample)`
            )->a( n = `contentWidth` v = `45rem`

            )->open( `content`
                " the original's custom:DivContainer (demo-kit-internal sap.ui.documentation control) rebuilt as a VBox
                )->open( `VBox`
                    )->a( n = `class` v = `sapUiSmallMargin`

                    )->leaf( `Text`
                        )->a( n = `text`    v = `We use cookies and SAP Web Analytics to improve your experience on our site. By continuing to use this site, you consent to use our cookies.`
                        )->a( n = `visible` v = |\{= !${ client->_bind( show_cookie_details ) } \}|
                    )->leaf( `Text`
                        )->a( n = `text`    v = `We use cookies to improve your experience on our site. By continuing to use this site, you consent to use our cookies.`
                        )->a( n = `visible` v = |\{= !${ client->_bind( show_cookie_details ) } \}|

                    )->open( n = `GridList` ns = `f`
                        )->a( n = `visible` v = client->_bind( show_cookie_details )

                        )->open( n = `customLayout` ns = `f`
                            )->leaf( n = `GridBasicLayout` ns = `grid`
                                )->a( n = `gridTemplateColumns` v = `1fr`
                                )->a( n = `gridGap`             v = `1rem`

                        )->shut(
                        )->open( n = `GridListItem` ns = `f`
                            )->open( `HBox`
                                )->a( n = `justifyContent` v = `SpaceBetween`
                                )->a( n = `class`          v = `sapUiSmallMarginBeginEnd sapUiSmallMarginTop`

                                )->open( `VBox`
                                    )->leaf( `Title`
                                        )->a( n = `text` v = `Required Cookies`
                                    )->leaf( `Text`
                                        )->a( n = `text` v = `These cookies are required to enable core site functionality.`

                                )->shut(
                                )->leaf( `Switch`
                                    )->a( n = `class` v = `sapUiSmallMarginBegin`

                            )->shut(
                            )->open( `Panel`
                                )->a( n = `headerText` v = `More Info`
                                )->a( n = `expandable` v = `true`
                                )->a( n = `class`      v = `sapUiTinyMarginTop`

                                )->leaf( `Text`
                                    )->a( n = `text` v = `We use cookies to improve your experience on our site. By continuing to use this site, you consent to use our cookies.`

                            )->shut(
                        )->shut(
                        )->open( n = `GridListItem` ns = `f`
                            )->open( `HBox`
                                )->a( n = `justifyContent` v = `SpaceBetween`
                                )->a( n = `class`          v = `sapUiSmallMarginBeginEnd sapUiSmallMarginTop`

                                )->open( `VBox`
                                    )->leaf( `Title`
                                        )->a( n = `text` v = `Functional Cookies`
                                    )->leaf( `Text`
                                        )->a( n = `text` v = `These cookies are used to analyse site usage for the purpose of measuring and improving site performance.`

                                )->shut(
                                )->leaf( `Switch`
                                    )->a( n = `class` v = `sapUiSmallMarginBegin`

                            )->shut(
                            )->open( `Panel`
                                )->a( n = `headerText` v = `More Info`
                                )->a( n = `expandable` v = `true`
                                )->a( n = `class`      v = `sapUiTinyMarginTop`

                                )->leaf( `Text`
                                    )->a( n = `text`
                                             v = `This site uses SAP Web Analytics to analyze how users use this site. The information generated (including a part of your IP address and a browser ID) ` &&
                                                 `will be transmitted to and stored by SAP on its servers. Cookies are used to identify your repeat visit and your visit origin page. ` &&
                                                 `We will use this information only for the purpose of evaluating website usage and compiling reports on website activity for website operators - and finally, to improve the site. ` &&
                                                 `If you would like to opt-in for SAP Web Analytics tracking, please specify your preference using the "On"/"Off" switch above. ` &&
                                                 `By opt-in, you consent to the processing of analytics data about you in the manner and for the purposes set out above.`

                            )->shut(
                        )->shut(
                    )->shut(
                )->shut(
            )->shut(
            )->open( `buttons`
                )->open( `Button`
                    )->a( n = `text`    v = `Accept All`
                    )->a( n = `type`    v = `Emphasized`
                    )->a( n = `press`   v = client->_event( `ACCEPT_ALL_COOKIES` )
                    )->a( n = `visible` v = |\{=! ${ client->_bind( show_cookie_details ) } \}|

                    )->open( `layoutData`
                        )->leaf( `OverflowToolbarLayoutData`
                            )->a( n = `priority` v = `NeverOverflow`

                    )->shut(
                )->shut(
                )->leaf( `Button`
                    )->a( n = `text`    v = `Set Preferences`
                    )->a( n = `id`      v = `actionSetPreferences`
                    )->a( n = `type`    v = `Ghost`
                    )->a( n = `press`   v = client->_event( `SHOW_COOKIE_DETAILS` )
                    )->a( n = `visible` v = |\{= !${ client->_bind( show_cookie_details ) } \}|

                )->open( `Button`
                    )->a( n = `text`    v = `Reject All`
                    )->a( n = `press`   v = client->_event( `REJECT_ALL_COOKIES` )
                    )->a( n = `visible` v = |\{=! ${ client->_bind( show_cookie_details ) } \}|

                    )->open( `layoutData`
                        )->leaf( `OverflowToolbarLayoutData`
                            )->a( n = `priority` v = `NeverOverflow`

                    )->shut(
                )->shut(
                )->leaf( `Button`
                    )->a( n = `text`    v = `Save Preferences`
                    )->a( n = `id`      v = `actionSavePreferences`
                    )->a( n = `type`    v = `Emphasized`
                    )->a( n = `press`   v = client->_event( `SAVE_COOKIES` )
                    )->a( n = `visible` v = client->_bind( show_cookie_details )
                )->leaf( `Button`
                    )->a( n = `text`    v = `Cancel`
                    )->a( n = `press`   v = client->_event( `CANCEL_PRESS` )
                    )->a( n = `visible` v = |\{= ${ client->_bind( show_cookie_details ) } \}| ).

    client->popup_display( popup->stringify( ) ).

    " the original's afterOpen handler moves the focus to the Set Preferences action
    client->follow_up_action( val   = client->cs_event-control_by_id
                              t_arg = VALUE #( ( `actionSetPreferences` ) ( client->cs_view-popup ) ( `focus` ) ) ).

  ENDMETHOD.

ENDCLASS.
