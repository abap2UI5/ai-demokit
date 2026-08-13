CLASS z2ui5_cl_smpc_app_167 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_child,
        title   TYPE string,
        key     TYPE string,
        enabled TYPE abap_bool,
      END OF ty_child.
    TYPES ty_child_tt TYPE STANDARD TABLE OF ty_child WITH EMPTY KEY.
    TYPES:
      BEGIN OF ty_nav,
        title      TYPE string,
        icon       TYPE string,
        enabled    TYPE abap_bool,
        expanded   TYPE abap_bool,
        key        TYPE string,
        selectable TYPE abap_bool,
        items      TYPE ty_child_tt,
      END OF ty_nav.
    TYPES:
      BEGIN OF ty_fixed,
        title        TYPE string,
        icon         TYPE string,
        ariahaspopup TYPE string,
        design       TYPE string,
        selectable   TYPE abap_bool,
      END OF ty_fixed.
    DATA navigation     TYPE STANDARD TABLE OF ty_nav WITH EMPTY KEY.
    DATA sideexpanded   TYPE abap_bool.
    DATA toggle_tooltip TYPE string.
    DATA fixednavigation TYPE STANDARD TABLE OF ty_fixed WITH EMPTY KEY.

    " NavigationListItem.selectable is {= ${items}.length > 3} in the original;
    " per the thin-frontend rule that logic is computed in ABAP into a flat
    " 'selectable' field and bound directly. selectedKey drives the shown page.
    DATA selectedkey TYPE string VALUE `page2`.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_167 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:tnt` v = `sap.tnt`
        )->a( n = `height`    v = `100%`

        )->open( n = `ToolPage` ns = `tnt`
            )->a( n = `id`           v = `toolPage`
            " added attr (declared): carries onSideNavButtonPress' setSideExpanded
            )->a( n = `sideExpanded` v = client->_bind( sideexpanded )

            )->open( n = `header` ns = `tnt`
                )->open( n = `ToolHeader` ns = `tnt`
                    )->open( `Button`
                        )->a( n = `id`      v = `sideNavigationToggleButton`
                        )->a( n = `icon`    v = `sap-icon://menu2`
                        )->a( n = `type`    v = `Transparent`
                        " added attr (declared): the original sets the tooltip imperatively
                        )->a( n = `tooltip` v = client->_bind( toggle_tooltip )
                        )->a( n = `press`   v = client->_event( `SIDE_TOGGLE` )
                        )->open( `layoutData`
                            )->leaf( `OverflowToolbarLayoutData` )->a( n = `priority` v = `NeverOverflow`

                        )->shut(
                    )->shut(
                    )->leaf( `ToolbarSpacer` )->a( n = `width` v = `20px`
                    )->open( `Button`
                        )->a( n = `text` v = `File`
                        )->a( n = `type` v = `Transparent`
                        )->open( `layoutData`
                            )->leaf( `OverflowToolbarLayoutData` )->a( n = `priority` v = `Low`

                        )->shut(
                    )->shut(
                    )->open( `Button`
                        )->a( n = `text` v = `Edit`
                        )->a( n = `type` v = `Transparent`
                        )->open( `layoutData`
                            )->leaf( `OverflowToolbarLayoutData` )->a( n = `priority` v = `Low`

                        )->shut(
                    )->shut(
                    )->open( `Button`
                        )->a( n = `text` v = `View`
                        )->a( n = `type` v = `Transparent`
                        )->open( `layoutData`
                            )->leaf( `OverflowToolbarLayoutData` )->a( n = `priority` v = `Low`

                        )->shut(
                    )->shut(
                    )->open( `Button`
                        )->a( n = `text` v = `Navigate`
                        )->a( n = `type` v = `Transparent`
                        )->open( `layoutData`
                            )->leaf( `OverflowToolbarLayoutData` )->a( n = `priority` v = `Low`

                        )->shut(
                    )->shut(
                    )->open( `Button`
                        )->a( n = `text` v = `Code`
                        )->a( n = `type` v = `Transparent`
                        )->open( `layoutData`
                            )->leaf( `OverflowToolbarLayoutData` )->a( n = `priority` v = `Low`

                        )->shut(
                    )->shut(
                    )->open( `Button`
                        )->a( n = `text` v = `Refactor`
                        )->a( n = `type` v = `Transparent`
                        )->open( `layoutData`
                            )->leaf( `OverflowToolbarLayoutData` )->a( n = `priority` v = `Low`

                        )->shut(
                    )->shut(
                    )->open( `Button`
                        )->a( n = `text` v = `Run`
                        )->a( n = `type` v = `Transparent`
                        )->open( `layoutData`
                            )->leaf( `OverflowToolbarLayoutData` )->a( n = `priority` v = `Low`

                        )->shut(
                    )->shut(
                    )->open( `Button`
                        )->a( n = `text` v = `Tools`
                        )->a( n = `type` v = `Transparent`
                        )->open( `layoutData`
                            )->leaf( `OverflowToolbarLayoutData` )->a( n = `priority` v = `Low`

                        )->shut(
                    )->shut(
                    )->leaf( n = `ToolHeaderUtilitySeparator` ns = `tnt`
                    )->open( `ToolbarSpacer`
                        )->open( `layoutData`
                            )->leaf( `OverflowToolbarLayoutData`
                                )->a( n = `priority` v = `NeverOverflow`
                                )->a( n = `minWidth` v = `20px`

                        )->shut(
                    )->shut(
                    )->open( `Button`
                        )->a( n = `text`         v = `Alan Smith`
                        )->a( n = `type`         v = `Transparent`
                        )->a( n = `press`        v = client->_event( val   = `USER_POPOVER`
                                                                     t_arg = VALUE #( ( `$event.oSource.sId` ) ) )
                        )->a( n = `ariaHasPopup` v = `Menu`
                        )->open( `layoutData`
                            )->leaf( `OverflowToolbarLayoutData` )->a( n = `priority` v = `NeverOverflow`

                        )->shut(
                    )->shut(
                )->shut(
            )->shut(

            )->open( n = `sideContent` ns = `tnt`
                )->open( n = `SideNavigation` ns = `tnt`
                    )->a( n = `expanded`    v = `true`
                    )->a( n = `itemPress`   v = client->follow_up_action( val   = client->cs_event-control_global
                                                                          t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Fired itemPress, item: {0}` ) ( `${$parameters>/item}.getText()` ) ) )
                    )->a( n = `selectedKey` v = client->_bind( selectedkey )
                    " onItemSelect: pageContainer.to(createId(item.getKey())) - the key
                    " resolves client-side and the to() runs roundtrip-free
                    )->a( n = `itemSelect`  v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                          t_arg = VALUE #( ( `pageContainer` ) ( `to` ) ( `${$parameters>/item}.getKey()` ) ) )
                    )->open( n = `NavigationList` ns = `tnt`
                        )->a( n = `items` v = client->_bind( navigation )
                        )->open( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text`       v = `{TITLE}`
                            )->a( n = `icon`       v = `{ICON}`
                            )->a( n = `enabled`    v = `{ENABLED}`
                            )->a( n = `expanded`   v = `{EXPANDED}`
                            )->a( n = `items`      v = `{ITEMS}`
                            )->a( n = `selectable` v = `{SELECTABLE}`
                            )->a( n = `key`        v = `{KEY}`
                            )->leaf( n = `NavigationListItem` ns = `tnt`
                                )->a( n = `text`    v = `{TITLE}`
                                )->a( n = `key`     v = `{KEY}`
                                )->a( n = `enabled` v = `{ENABLED}`

                        )->shut(
                    )->shut(
                    )->open( n = `fixedItem` ns = `tnt`
                        )->open( n = `NavigationList` ns = `tnt`
                            )->a( n = `items` v = client->_bind( fixednavigation )
                            )->leaf( n = `NavigationListItem` ns = `tnt`
                                )->a( n = `text`         v = `{TITLE}`
                                )->a( n = `icon`         v = `{ICON}`
                                )->a( n = `ariaHasPopup` v = `{ARIAHASPOPUP}`
                                )->a( n = `design`       v = `{DESIGN}`
                                )->a( n = `press`        v = client->_event( val   = `QUICK_ACTION`
                                                                             t_arg = VALUE #( ( `${$source>/design}` ) ) )
                                )->a( n = `selectable`   v = `{SELECTABLE}`

                        )->shut(
                    )->shut(
                )->shut(
            )->shut(

            )->open( n = `mainContents` ns = `tnt`
                )->open( `NavContainer`
                    )->a( n = `id`          v = `pageContainer`
                    )->a( n = `initialPage` v = `page2`
                    )->open( `pages`
                        )->open( `ScrollContainer`
                            )->a( n = `id`         v = `root1`
                            )->a( n = `horizontal` v = `false`
                            )->a( n = `vertical`   v = `true`
                            )->a( n = `height`     v = `100%`
                            )->a( n = `class`      v = `sapUiContentPadding`
                            )->leaf( `Text` )->a( n = `text` v = `This is the root page`

                        )->shut(
                        )->open( `ScrollContainer`
                            )->a( n = `id`         v = `page1`
                            )->a( n = `horizontal` v = `false`
                            )->a( n = `vertical`   v = `true`
                            )->a( n = `height`     v = `100%`
                            )->a( n = `class`      v = `sapUiContentPadding`
                            )->leaf( `Text` )->a( n = `text` v = `This is the first page`

                        )->shut(
                        )->open( `ScrollContainer`
                            )->a( n = `id`         v = `page2`
                            )->a( n = `horizontal` v = `false`
                            )->a( n = `vertical`   v = `true`
                            )->a( n = `height`     v = `100%`
                            )->a( n = `class`      v = `sapUiContentPadding`
                            )->leaf( `Text` )->a( n = `text` v = `Lorem ipsum dolor sit amet, consectetur adipisicing elit. (content abbreviated from the original filler text)`

                        )->shut(
                        )->open( `ScrollContainer`
                            )->a( n = `id`         v = `root2`
                            )->a( n = `horizontal` v = `false`
                            )->a( n = `vertical`   v = `true`
                            )->a( n = `height`     v = `100%`
                            )->a( n = `class`      v = `sapUiContentPadding`
                            )->leaf( `Text` )->a( n = `text` v = `This is the root page of the second element`

                        )->shut(
                    )->shut(
                )->shut(
            )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `SIDE_TOGGLE`.
        " onSideNavButtonPress: tooltip from the PRE-toggle expanded state
        " (_setToggleButtonTooltip(bSideExpanded)), then setSideExpanded(!...)
        toggle_tooltip = COND #( WHEN sideexpanded = abap_true
                                 THEN `Large Size Navigation`
                                 ELSE `Small Size Navigation` ).
        sideexpanded = xsdbool( sideexpanded = abap_false ).

      WHEN `USER_POPOVER`.
        " handleUserNamePress: the controller-built Popover (no header, Bottom,
        " three transparent buttons), opened by the pressed user button
        DATA(popover) = z2ui5_cl_ai_xml=>factory( ).

        popover->open( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns:core` v = `sap.ui.core`
            )->a( n = `xmlns`      v = `sap.m`

            )->open( `Popover`
                )->a( n = `showHeader` v = `false`
                )->a( n = `placement`  v = `Bottom`
                )->a( n = `class`      v = `sapMOTAPopover sapTntToolHeaderPopover`

                )->open( `content`
                    )->leaf( `Button`
                        )->a( n = `text` v = `Feedback`
                        )->a( n = `type` v = `Transparent`
                    )->leaf( `Button`
                        )->a( n = `text` v = `Help`
                        )->a( n = `type` v = `Transparent`
                    )->leaf( `Button`
                        )->a( n = `text` v = `Logout`
                        )->a( n = `type` v = `Transparent` ).

        client->popover_display( xml   = popover->stringify( )
                                 by_id = client->get_event_arg( ) ).

      WHEN `QUICK_ACTION`.
        " onQuickActionPress: only a design=Action item opens the dialog
        IF client->get_event_arg( ) = `Action`.
          DATA(popup) = z2ui5_cl_ai_xml=>factory( ).

          popup->open( n = `FragmentDefinition` ns = `core`
              )->a( n = `xmlns:core` v = `sap.ui.core`
              )->a( n = `xmlns`      v = `sap.m`

              )->open( `Dialog`
                  )->a( n = `title` v = `Create Item`
                  )->a( n = `type`  v = `Message`

                  )->open( `content`
                      )->leaf( `Text`
                          )->a( n = `text` v = `Create New Navigation List Item`

                  )->shut(
                  )->open( `beginButton`
                      )->leaf( `Button`
                          )->a( n = `type`  v = `Emphasized`
                          )->a( n = `text`  v = `Create`
                          )->a( n = `press` v = client->follow_up_action( client->cs_event-popup_close )

                  )->shut(
                  )->open( `endButton`
                      )->leaf( `Button`
                          )->a( n = `text`  v = `Cancel`
                          )->a( n = `press` v = client->follow_up_action( client->cs_event-popup_close ) ).

          client->popup_display( popup->stringify( ) ).
        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " onInit: _setToggleButtonTooltip(!Device.system.desktop) - the desktop
    " default; the ToolPage starts with its side content expanded (UI5 default)
    sideexpanded   = abap_true.
    toggle_tooltip = `Small Size Navigation`.

    navigation = VALUE #(
      ( title = `Root Item 1` icon = `sap-icon://employee` enabled = abap_true expanded = abap_true key = `root1` selectable = abap_false
        items = VALUE #(
          ( title = `Child Item 1` key = `page1` enabled = abap_true )
          ( title = `Child Item 2` key = `page2` enabled = abap_true ) ) )
      ( title = `Root Item 2` icon = `sap-icon://building` enabled = abap_true expanded = abap_false key = `root2` selectable = abap_false
        items = VALUE #( ) )
      ( title = `Root Item 3` icon = `sap-icon://card` enabled = abap_true expanded = abap_false key = `` selectable = abap_true
        items = VALUE #(
          ( title = `Child Item 1` key = `` enabled = abap_true )
          ( title = `Child Item 2` key = `` enabled = abap_true )
          ( title = `Child Item 3` key = `` enabled = abap_true )
          ( title = `Child Item 4` key = `` enabled = abap_true )
          ( title = `Child Item 5` key = `` enabled = abap_true )
          ( title = `Child Item 6` key = `` enabled = abap_true )
          ( title = `Child Item 7` key = `` enabled = abap_true )
          ( title = `Child Item 8` key = `` enabled = abap_true )
          ( title = `Child Item 9` key = `` enabled = abap_true )
          ( title = `Child Item 10` key = `` enabled = abap_true )
          ( title = `Child Item 11` key = `` enabled = abap_true )
          ( title = `Child Item 12` key = `` enabled = abap_true )
          ( title = `Child Item 13` key = `` enabled = abap_true )
          ( title = `Child Item 14` key = `` enabled = abap_true )
          ( title = `Child Item 15` key = `` enabled = abap_true )
          ( title = `Child Item 16` key = `` enabled = abap_true )
          ( title = `Child Item 17` key = `` enabled = abap_true )
          ( title = `Child Item 18` key = `` enabled = abap_true )
          ( title = `Child Item 19` key = `` enabled = abap_true )
          ( title = `Child Item 20` key = `` enabled = abap_true )
          ( title = `Child Item 21` key = `` enabled = abap_true )
          ( title = `Child Item 22` key = `` enabled = abap_true )
          ( title = `Child Item 23` key = `` enabled = abap_true )
          ( title = `Child Item 24` key = `` enabled = abap_true )
          ( title = `Child Item 25` key = `` enabled = abap_true )
          ( title = `Child Item 26` key = `` enabled = abap_true )
          ( title = `Child Item 27` key = `` enabled = abap_true )
          ( title = `Child Item 28` key = `` enabled = abap_true )
          ( title = `Child Item 29` key = `` enabled = abap_true )
          ( title = `Child Item 30` key = `` enabled = abap_true )
          ( title = `Child Item 31` key = `` enabled = abap_true )
          ( title = `Child Item 32` key = `` enabled = abap_true )
          ( title = `Child Item 33` key = `` enabled = abap_true )
          ( title = `Child Item 34` key = `` enabled = abap_true )
          ( title = `Child Item 35` key = `` enabled = abap_true )
          ( title = `Child Item 36` key = `` enabled = abap_true )
          ( title = `Child Item 37` key = `` enabled = abap_true )
          ( title = `Child Item 38` key = `` enabled = abap_true ) ) )
      ( title = `Root Item 4` icon = `sap-icon://action` enabled = abap_true expanded = abap_false key = `` selectable = abap_false
        items = VALUE #(
          ( title = `Child Item 1` key = `` enabled = abap_true )
          ( title = `Child Item 2` key = `` enabled = abap_true )
          ( title = `Child Item 3` key = `` enabled = abap_true ) ) )
      ( title = `Root Item 5` icon = `sap-icon://action-settings` enabled = abap_true expanded = abap_false key = `` selectable = abap_false
        items = VALUE #(
          ( title = `Child Item 1` key = `` enabled = abap_true )
          ( title = `Child Item 2` key = `` enabled = abap_true )
          ( title = `Child Item 3` key = `` enabled = abap_true ) ) )
      ( title = `Root Item 6` icon = `sap-icon://activate` enabled = abap_true expanded = abap_false key = `` selectable = abap_false
        items = VALUE #(
          ( title = `Child Item 1` key = `` enabled = abap_true )
          ( title = `Child Item 2` key = `` enabled = abap_true )
          ( title = `Child Item 3` key = `` enabled = abap_true ) ) )
      ( title = `Root Item 7` icon = `sap-icon://activities` enabled = abap_true expanded = abap_false key = `` selectable = abap_false
        items = VALUE #(
          ( title = `Child Item 1` key = `` enabled = abap_true )
          ( title = `Child Item 2` key = `` enabled = abap_true )
          ( title = `Child Item 3` key = `` enabled = abap_true ) ) )
      ( title = `Root Item 8` icon = `sap-icon://add` enabled = abap_true expanded = abap_false key = `` selectable = abap_false
        items = VALUE #(
          ( title = `Child Item 1` key = `` enabled = abap_true )
          ( title = `Child Item 2` key = `` enabled = abap_true )
          ( title = `Child Item 3` key = `` enabled = abap_true ) ) )
      ( title = `Root Item 9` icon = `sap-icon://arobase` enabled = abap_true expanded = abap_false key = `` selectable = abap_false
        items = VALUE #(
          ( title = `Child Item 1` key = `` enabled = abap_true )
          ( title = `Child Item 2` key = `` enabled = abap_true )
          ( title = `Child Item 3` key = `` enabled = abap_true ) ) )
      ( title = `Root Item 10` icon = `sap-icon://attachment` enabled = abap_true expanded = abap_false key = `` selectable = abap_false
        items = VALUE #(
          ( title = `Child Item 1` key = `` enabled = abap_true )
          ( title = `Child Item 2` key = `` enabled = abap_true )
          ( title = `Child Item 3` key = `` enabled = abap_true ) ) )
      ( title = `Root Item 11` icon = `sap-icon://badge` enabled = abap_true expanded = abap_false key = `` selectable = abap_false
        items = VALUE #(
          ( title = `Child Item 1` key = `` enabled = abap_true )
          ( title = `Child Item 2` key = `` enabled = abap_true )
          ( title = `Child Item 3` key = `` enabled = abap_true ) ) )
      ( title = `Root Item 12` icon = `sap-icon://basket` enabled = abap_true expanded = abap_false key = `` selectable = abap_false
        items = VALUE #(
          ( title = `Child Item 1` key = `` enabled = abap_true )
          ( title = `Child Item 2` key = `` enabled = abap_true )
          ( title = `Child Item 3` key = `` enabled = abap_true ) ) )
      ( title = `Root Item 13` icon = `sap-icon://bed` enabled = abap_true expanded = abap_false key = `` selectable = abap_false
        items = VALUE #(
          ( title = `Child Item 1` key = `` enabled = abap_true )
          ( title = `Child Item 2` key = `` enabled = abap_true )
          ( title = `Child Item 3` key = `` enabled = abap_true ) ) )
      ( title = `Root Item 14` icon = `sap-icon://bookmark` enabled = abap_true expanded = abap_false key = `` selectable = abap_false
        items = VALUE #(
          ( title = `Child Item 1` key = `` enabled = abap_true )
          ( title = `Child Item 2` key = `` enabled = abap_true )
          ( title = `Child Item 3` key = `` enabled = abap_true ) ) )
      ).

    " data.json omits ariaHasPopup and design on Fixed Item 1-3; the UI5 enum
    " defaults (None, Default) are seeded explicitly because an empty string
    " would be rejected by the enum validation (AGENTS section 5)
    fixednavigation = VALUE #(
      ( title = `Quick Create` icon = `sap-icon://write-new` ariahaspopup = `Dialog` design = `Action` selectable = abap_false )
      ( title = `Fixed Item 1` icon = `sap-icon://employee` ariahaspopup = `None` design = `Default` selectable = abap_false )
      ( title = `Fixed Item 2` icon = `sap-icon://building` ariahaspopup = `None` design = `Default` selectable = abap_false )
      ( title = `Fixed Item 3` icon = `sap-icon://card` ariahaspopup = `None` design = `Default` selectable = abap_false )
      ).

  ENDMETHOD.

ENDCLASS.
