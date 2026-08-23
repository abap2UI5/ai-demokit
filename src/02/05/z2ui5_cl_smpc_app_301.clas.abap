" @keywords sidenavigation side navigation sap.tnt sidenavigationoverlaymode app toolpage shellbar avatar navcontainer scrollcontainer vbox
" @summary SideNavigation in a responsive popover.
CLASS z2ui5_cl_smpc_app_301 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA home_text TYPE string.
    DATA page_text TYPE string.

    " The original loads the popover fragment ONCE and keeps it as a dependent,
    " so the fragment's own selectedKey="home" applies once and the highlight
    " then follows the user. Here the fragment is rebuilt on every
    " menuButtonPressed, so a literal would reset the highlight to Home after
    " every navigation - the selected key has to live in the model instead
    " (the same two-way bound selectedKey the sibling port 303 uses).
    DATA selectedkey TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popover_sidenav_display.
    METHODS popup_quickcreate_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_301 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:tnt` v = `sap.tnt`
        )->a( n = `xmlns:f`   v = `sap.f`
        )->a( n = `height`    v = `100%`

        )->ele( `App`
            )->ele( n = `ToolPage` ns = `tnt`
                )->a( n = `id`    v = `myPage`
                )->a( n = `class` v = `sapUiResponsivePadding--header`

                )->ele( n = `header` ns = `tnt`
                    )->ele( n = `ShellBar` ns = `f`
                        )->a( n = `id`                  v = `shellBar`
                        )->a( n = `title`               v = `Product Name`
                        )->a( n = `homeIcon`            v = `https://sdk.openui5.org/resources/sap/ui/documentation/sdk/images/logo_sap.png`
                        )->a( n = `showMenuButton`      v = `true`
                        )->a( n = `showSearch`          v = `true`
                        )->a( n = `showNotifications`   v = `true`
                        )->a( n = `notificationsNumber` v = `2`
                        " onToggleSideNav opens the side-navigation popover anchored
                        " to the menu button the event carries as parameter 'button'
                        )->a( n = `menuButtonPressed`   v = client->_event( val   = `TOGGLE_SIDE_NAV`
                                                                            t_arg = VALUE #( ( `${$parameters>/button}.getId()` ) ) )

                        )->ele( n = `profile` ns = `f`
                            )->tag( `Avatar`
                                )->a( n = `initials` v = `SN`

                        )->end(
                    )->end(
                )->end(

                )->ele( n = `mainContents` ns = `tnt`
                    )->ele( `NavContainer`
                        )->a( n = `id`          v = `pageContainer`
                        )->a( n = `initialPage` v = `home`
                        )->a( n = `height`      v = `100%`

                        )->ele( `pages`
                            )->ele( `ScrollContainer`
                                )->a( n = `id`         v = `home`
                                )->a( n = `horizontal` v = `false`
                                )->a( n = `vertical`   v = `true`
                                )->a( n = `height`     v = `100%`
                                )->a( n = `width`      v = `100%`
                                )->a( n = `class`      v = `sapUiContentPadding SCROLLCONT`

                                )->ele( `VBox`
                                    )->a( n = `justifyContent` v = `Center`
                                    )->a( n = `alignItems`     v = `Center`
                                    )->a( n = `height`         v = `100%`

                                    " onItemSelect overwrites this page's Text imperatively
                                    " (setText); here the Text is two-way bound instead
                                    )->tag( `Text`
                                        )->a( n = `text` v = client->_bind( home_text )

                                )->end(
                            )->end(

                            )->ele( `ScrollContainer`
                                )->a( n = `id`         v = `page1`
                                )->a( n = `horizontal` v = `false`
                                )->a( n = `vertical`   v = `true`
                                )->a( n = `height`     v = `100%`
                                )->a( n = `width`      v = `100%`
                                )->a( n = `class`      v = `sapUiContentPadding SCROLLCONT`

                                )->ele( `VBox`
                                    )->a( n = `renderType`     v = `Bare`
                                    )->a( n = `justifyContent` v = `Center`
                                    )->a( n = `alignItems`     v = `Center`

                                    )->tag( `Text`
                                        )->a( n = `text` v = client->_bind( page_text )

                                )->end(
                            )->end(

                            )->ele( `ScrollContainer`
                                )->a( n = `id`         v = `page2`
                                )->a( n = `horizontal` v = `false`
                                )->a( n = `vertical`   v = `true`
                                )->a( n = `height`     v = `100%`
                                )->a( n = `class`      v = `sapUiContentPadding`

                                )->ele( `VBox`
                                    )->a( n = `alignItems`     v = `Center`
                                    )->a( n = `renderType`     v = `Bare`
                                    )->a( n = `justifyContent` v = `Center`

                                    )->tag( `Text`
                                        )->a( n = `text` v = client->_bind( page_text )

                                )->end(
                            )->end(

                            )->ele( `ScrollContainer`
                                )->a( n = `id`         v = `page3`
                                )->a( n = `horizontal` v = `false`
                                )->a( n = `vertical`   v = `true`
                                )->a( n = `height`     v = `100%`
                                )->a( n = `class`      v = `sapUiContentPadding`

                                )->ele( `VBox`
                                    )->a( n = `justifyContent` v = `Center`
                                    )->a( n = `alignItems`     v = `Center`
                                    )->a( n = `height`         v = `100%`

                                    )->tag( `Text`
                                        )->a( n = `text` v = client->_bind( page_text )

                                )->end(
                            )->end(

                            )->ele( `ScrollContainer`
                                )->a( n = `id`         v = `page4`
                                )->a( n = `horizontal` v = `false`
                                )->a( n = `vertical`   v = `true`
                                )->a( n = `height`     v = `100%`
                                )->a( n = `class`      v = `sapUiContentPadding`

                                )->ele( `VBox`
                                    )->a( n = `justifyContent` v = `Center`
                                    )->a( n = `alignItems`     v = `Center`
                                    )->a( n = `height`         v = `100%`

                                    )->tag( `Text`
                                        )->a( n = `text` v = client->_bind( page_text )

                                )->end(
                            )->end(

                            )->ele( `ScrollContainer`
                                )->a( n = `id`         v = `page5`
                                )->a( n = `horizontal` v = `false`
                                )->a( n = `vertical`   v = `true`
                                )->a( n = `height`     v = `100%`
                                )->a( n = `class`      v = `sapUiContentPadding`

                                )->ele( `VBox`
                                    )->a( n = `justifyContent` v = `Center`
                                    )->a( n = `alignItems`     v = `Center`
                                    )->a( n = `height`         v = `100%`

                                    )->tag( `Text`
                                        )->a( n = `text` v = client->_bind( page_text )

                                )->end(
                            )->end(

                            )->ele( `ScrollContainer`
                                )->a( n = `id`         v = `page6`
                                )->a( n = `horizontal` v = `false`
                                )->a( n = `vertical`   v = `true`
                                )->a( n = `height`     v = `100%`
                                )->a( n = `class`      v = `sapUiContentPadding`

                                )->ele( `VBox`
                                    )->a( n = `justifyContent` v = `Center`
                                    )->a( n = `alignItems`     v = `Center`
                                    )->a( n = `height`         v = `100%`

                                    )->tag( `Text`
                                        )->a( n = `text` v = client->_bind( page_text )

                                )->end(
                            )->end(

                            )->ele( `ScrollContainer`
                                )->a( n = `id`         v = `page7`
                                )->a( n = `horizontal` v = `false`
                                )->a( n = `vertical`   v = `true`
                                )->a( n = `height`     v = `100%`
                                )->a( n = `class`      v = `sapUiContentPadding`

                                )->ele( `VBox`
                                    )->a( n = `justifyContent` v = `Center`
                                    )->a( n = `alignItems`     v = `Center`
                                    )->a( n = `height`         v = `100%`

                                    )->tag( `Text`
                                        )->a( n = `text` v = client->_bind( page_text )

                                )->end(
                            )->end(

                            )->ele( `ScrollContainer`
                                )->a( n = `id`         v = `page8`
                                )->a( n = `horizontal` v = `false`
                                )->a( n = `vertical`   v = `true`
                                )->a( n = `height`     v = `100%`
                                )->a( n = `class`      v = `sapUiContentPadding`

                                )->ele( `VBox`
                                    )->a( n = `justifyContent` v = `Center`
                                    )->a( n = `alignItems`     v = `Center`
                                    )->a( n = `height`         v = `100%`

                                    )->tag( `Text`
                                        )->a( n = `text` v = client->_bind( page_text )

                                )->end(
                            )->end(

                            )->ele( `ScrollContainer`
                                )->a( n = `id`         v = `page9`
                                )->a( n = `horizontal` v = `false`
                                )->a( n = `vertical`   v = `true`
                                )->a( n = `height`     v = `100%`
                                )->a( n = `class`      v = `sapUiContentPadding`

                                )->ele( `VBox`
                                    )->a( n = `justifyContent` v = `Center`
                                    )->a( n = `alignItems`     v = `Center`
                                    )->a( n = `height`         v = `100%`

                                    )->tag( `Text`
                                        )->a( n = `text` v = client->_bind( page_text )

                                )->end(
                            )->end(

                            )->ele( `ScrollContainer`
                                )->a( n = `id`         v = `page10`
                                )->a( n = `horizontal` v = `false`
                                )->a( n = `vertical`   v = `true`
                                )->a( n = `height`     v = `100%`
                                )->a( n = `class`      v = `sapUiContentPadding`

                                )->ele( `VBox`
                                    )->a( n = `justifyContent` v = `Center`
                                    )->a( n = `alignItems`     v = `Center`
                                    )->a( n = `height`         v = `100%`

                                    )->tag( `Text`
                                        )->a( n = `text` v = client->_bind( page_text )

                                )->end(
                            )->end(

                            )->ele( `ScrollContainer`
                                )->a( n = `id`         v = `page11`
                                )->a( n = `horizontal` v = `false`
                                )->a( n = `vertical`   v = `true`
                                )->a( n = `height`     v = `100%`
                                )->a( n = `class`      v = `sapUiContentPadding`

                                )->ele( `VBox`
                                    )->a( n = `justifyContent` v = `Center`
                                    )->a( n = `alignItems`     v = `Center`
                                    )->a( n = `height`         v = `100%`

                                    )->tag( `Text`
                                        )->a( n = `text` v = client->_bind( page_text )

                                )->end(
                            )->end(

                            )->ele( `ScrollContainer`
                                )->a( n = `id`         v = `page12`
                                )->a( n = `horizontal` v = `false`
                                )->a( n = `vertical`   v = `true`
                                )->a( n = `height`     v = `100%`
                                )->a( n = `class`      v = `sapUiContentPadding`

                                )->ele( `VBox`
                                    )->a( n = `justifyContent` v = `Center`
                                    )->a( n = `alignItems`     v = `Center`
                                    )->a( n = `height`         v = `100%`

                                    )->tag( `Text`
                                        )->a( n = `text` v = client->_bind( page_text ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `TOGGLE_SIDE_NAV`.
        " original onToggleSideNav: Fragment.load( Popover.fragment.xml ) ->
        " openBy( the ShellBar menu button ) / close when already open
        popover_sidenav_display( ).

      WHEN `ITEM_SELECT`.
        " original onItemSelect: reads the item key, writes the target page's
        " Text and navigates the NavContainer there, then closes the popover
        DATA(lv_key) = client->get_event_arg( ).
        DATA(lv_selectable) = CONV abap_bool( client->get_event_arg( 2 ) ).

        IF lv_key IS NOT INITIAL AND lv_selectable = abap_true.
          " the highlight has to survive the popover being rebuilt on the next
          " open, so the key goes into the model the fragment binds
          selectedkey = lv_key.
          DATA(lv_text) = |Fired event to load page { replace( val = lv_key sub = `page` with = `` ) }|.
          IF lv_key = `home`.
            home_text = lv_text.
          ELSE.
            page_text = lv_text.
          ENDIF.
          client->follow_up_action( val   = client->cs_event-control_by_id
                                    t_arg = VALUE #( ( `pageContainer` ) ( `to` ) ( lv_key ) ) ).
        ENDIF.

        client->popover_destroy( ).

      WHEN `QUICK_CREATE`.
        " original onQuickActionPress: opens the create dialog and closes the popover
        client->popover_destroy( ).
        popup_quickcreate_display( ).

      WHEN `CREATE_ITEM`.
        " the original Create button only closes the dialog
        client->popup_destroy( ).

    ENDCASE.

  ENDMETHOD.


  METHOD popover_sidenav_display.

    " Popover.fragment.xml rebuilt 1:1 and shown anchored to the ShellBar menu
    " button - the Fragment.load + openBy equivalent
    DATA(popover) = z2ui5_cl_ui5_view_builder=>factory( ).

    popover->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:tnt`  v = `sap.tnt`

        )->ele( `ResponsivePopover`
            )->a( n = `id`                v = `respPopover`
            )->a( n = `placement`         v = `Bottom`
            )->a( n = `verticalScrolling` v = `false`
            )->a( n = `ariaLabelledBy`    v = `sn-label`
            " onToggleSideNav's setShowHeader( Device.system.phone ): a header on
            " the phone, none anywhere else. Bound rather than resolved on the
            " server, so it follows a live device change (apps 309/310 bind the
            " same branch)
            )->a( n = `showHeader`        v = `{= ${device>/system/phone}}`

            )->tag( n = `InvisibleText` ns = `core`
                )->a( n = `id`   v = `sn-label`
                )->a( n = `text` v = `Main navigation`

            )->ele( n = `SideNavigation` ns = `tnt`
                )->a( n = `id`          v = `sideNav`
                )->a( n = `width`       v = `17rem`
                )->a( n = `itemSelect`  v = client->_event( val   = `ITEM_SELECT`
                                                            t_arg = VALUE #( ( `${$parameters>/item}.getKey()` ) ( `${$parameters>/item}.getSelectable()` ) ) )
                )->a( n = `selectedKey` v = client->_bind( selectedkey )
                )->a( n = `design`      v = `Plain`

                )->ele( n = `NavigationList` ns = `tnt`
                    )->tag( n = `NavigationListItem` ns = `tnt`
                        )->a( n = `text` v = `Home`
                        )->a( n = `icon` v = `sap-icon://home`
                        )->a( n = `key`  v = `home`
                    )->tag( n = `NavigationListItem` ns = `tnt`
                        )->a( n = `text` v = `Favorites`
                        )->a( n = `icon` v = `sap-icon://favorite-list`
                        )->a( n = `key`  v = `page1`
                    )->tag( n = `NavigationListItem` ns = `tnt`
                        )->a( n = `text` v = `Recent Applications for user role`
                        )->a( n = `icon` v = `sap-icon://history`
                        )->a( n = `key`  v = `page2`

                    " NavigationListGroup is a control @since 1.121 - kept 1:1 (POST_171)
                    )->ele( n = `NavigationListGroup` ns = `tnt`
                        )->a( n = `text`     v = `Business Areas for selected user role`
                        )->a( n = `expanded` v = `false`

                        )->ele( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text`       v = `Manufacturing management`
                            )->a( n = `icon`       v = `sap-icon://wrench`
                            )->a( n = `expanded`   v = `false`
                            )->a( n = `selectable` v = `false`

                            )->tag( n = `NavigationListItem` ns = `tnt`
                                )->a( n = `text` v = `Inventory Management`
                                )->a( n = `key`  v = `page3`
                            )->tag( n = `NavigationListItem` ns = `tnt`
                                )->a( n = `text` v = `Quality Control`
                                )->a( n = `key`  v = `page4`

                        )->end(
                        )->ele( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text`     v = `Sales`
                            )->a( n = `icon`     v = `sap-icon://multiple-line-chart`
                            )->a( n = `key`      v = `page5`
                            )->a( n = `expanded` v = `true`

                            )->tag( n = `NavigationListItem` ns = `tnt`
                                )->a( n = `text` v = `Manage Sales Accounts`
                                )->a( n = `key`  v = `page6`
                            )->tag( n = `NavigationListItem` ns = `tnt`
                                )->a( n = `text` v = `Sales Order`
                                )->a( n = `key`  v = `page7`
                            )->tag( n = `NavigationListItem` ns = `tnt`
                                )->a( n = `text` v = `Sales Overview`
                                )->a( n = `key`  v = `page8`

                        )->end(

                        )->tag( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Customer Service`
                            )->a( n = `icon` v = `sap-icon://customer-and-contacts`
                            )->a( n = `key`  v = `page9`

                        )->ele( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text`     v = `Finance`
                            )->a( n = `icon`     v = `sap-icon://customer-financial-fact-sheet`
                            )->a( n = `expanded` v = `false`
                            )->a( n = `key`      v = `page10`

                            )->tag( n = `NavigationListItem` ns = `tnt`
                                )->a( n = `text` v = `Payroll Management`
                                )->a( n = `key`  v = `page11`
                            )->tag( n = `NavigationListItem` ns = `tnt`
                                )->a( n = `text` v = `Tax Management`
                                )->a( n = `key`  v = `page12`

                        )->end(

                        )->tag( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text`       v = `Employee Services`
                            )->a( n = `icon`       v = `sap-icon://employee`
                            )->a( n = `selectable` v = `false`
                            )->a( n = `href`       v = `https://www.sap.com`
                            )->a( n = `target`     v = `_blank`

                    )->end(
                )->end(

                )->ele( n = `fixedItem` ns = `tnt`
                    )->ele( n = `NavigationList` ns = `tnt`
                        )->tag( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text`         v = `Create`
                            )->a( n = `icon`         v = `sap-icon://write-new`
                            )->a( n = `selectable`   v = `false`
                            )->a( n = `design`       v = `Action`
                            )->a( n = `ariaHasPopup` v = `Dialog`
                            )->a( n = `press`        v = client->_event( `QUICK_CREATE` )
                        )->tag( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text`       v = `App Finder`
                            )->a( n = `icon`       v = `sap-icon://widgets`
                            )->a( n = `selectable` v = `false`
                            )->a( n = `href`       v = `https://sdk.openui5.org/demoapps`
                            )->a( n = `target`     v = `_blank`
                        )->tag( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text`       v = `Legal`
                            )->a( n = `icon`       v = `sap-icon://compare`
                            )->a( n = `selectable` v = `false`
                            )->a( n = `href`       v = `https://www.sap.com/about/legal/impressum.html`
                            )->a( n = `target`     v = `_blank` ).

    client->popover_display( xml   = popover->stringify( )
                             by_id = client->get_event_arg( ) ).

  ENDMETHOD.


  METHOD popup_quickcreate_display.

    " original onQuickActionPress builds this Dialog imperatively (new Dialog({...}).open());
    " expressed as a core:FragmentDefinition shown via popup_display (declared deviation)
    DATA(popup) = z2ui5_cl_ui5_view_builder=>factory( ).

    popup->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns`      v = `sap.m`

        )->ele( `Dialog`
            )->a( n = `type`  v = `Message`
            )->a( n = `title` v = `Create Item`

            )->ele( `content`
                )->tag( `Text`
                    )->a( n = `text` v = `Create New Navigation List Item`

            )->end(
            )->ele( `beginButton`
                )->tag( `Button`
                    )->a( n = `type`  v = `Emphasized`
                    )->a( n = `text`  v = `Create`
                    )->a( n = `press` v = client->_event( `CREATE_ITEM` )

            )->end(
            )->ele( `endButton`
                )->tag( `Button`
                    )->a( n = `text`  v = `Cancel`
                    )->a( n = `press` v = client->follow_up_action( client->cs_event-popup_close ) ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    home_text = `Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor ` &&
                `incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud ` &&
                `exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure ` &&
                `dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.`.

    " the fragment's selectedKey="home"
    selectedkey = `home`.

  ENDMETHOD.

ENDCLASS.
