" @keywords sidenavigation side navigation sap.tnt sidenavigationsearch button image title text toolbarspacer searchfield overflowtoolbarlayoutdata
" @summary SideNavigation with a search field in the filter section and filterable navigation items.
CLASS z2ui5_cl_smpc_app_407 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_sub_item,
             title        TYPE string,
             key          TYPE string,
             href         TYPE string,
             target       TYPE string,
             ariahaspopup TYPE string,
             design       TYPE string,
             tagtext      TYPE string,
             tagstate     TYPE string,
             enabled      TYPE abap_bool,
             selectable   TYPE abap_bool,
           END OF ty_s_sub_item.
    TYPES ty_t_sub_item TYPE STANDARD TABLE OF ty_s_sub_item WITH EMPTY KEY.
    TYPES: BEGIN OF ty_s_nav_item,
             title        TYPE string,
             icon         TYPE string,
             key          TYPE string,
             href         TYPE string,
             target       TYPE string,
             ariahaspopup TYPE string,
             design       TYPE string,
             tagtext      TYPE string,
             tagstate     TYPE string,
             enabled      TYPE abap_bool,
             expanded     TYPE abap_bool,
             hasexpander  TYPE abap_bool,
             selectable   TYPE abap_bool,
             items        TYPE ty_t_sub_item,
           END OF ty_s_nav_item.
    TYPES ty_t_nav_item TYPE STANDARD TABLE OF ty_s_nav_item WITH EMPTY KEY.
    TYPES: BEGIN OF ty_s_fixed_item,
             title        TYPE string,
             icon         TYPE string,
             key          TYPE string,
             href         TYPE string,
             target       TYPE string,
             ariahaspopup TYPE string,
             design       TYPE string,
             tagtext      TYPE string,
             tagstate     TYPE string,
             selectable   TYPE abap_bool,
           END OF ty_s_fixed_item.
    TYPES ty_t_fixed_item TYPE STANDARD TABLE OF ty_s_fixed_item WITH EMPTY KEY.

    DATA side_expanded  TYPE abap_bool.
    DATA search_value   TYPE string.
    DATA home_visible   TYPE abap_bool.
    DATA group1_visible TYPE abap_bool.
    DATA group2_visible TYPE abap_bool.
    DATA t_group1       TYPE ty_t_nav_item.
    DATA t_group2       TYPE ty_t_nav_item.
    DATA t_fixed        TYPE ty_t_fixed_item.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    " the unfiltered originals the search filters from - never bound, so
    " they stay out of the PUBLIC model scan
    DATA t_group1_full TYPE ty_t_nav_item.
    DATA t_group2_full TYPE ty_t_nav_item.
    DATA t_fixed_full  TYPE ty_t_fixed_item.

    METHODS view_display.
    METHODS on_event.
    METHODS popup_quick_create.
    METHODS apply_filter.
    METHODS filter_items
      IMPORTING it_items        TYPE ty_t_nav_item
      RETURNING VALUE(rt_items) TYPE ty_t_nav_item.
    METHODS count_matches
      RETURNING VALUE(rv_count) TYPE i.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_407 IMPLEMENTATION.

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
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:tnt` v = `sap.tnt`
        )->a( n = `height`    v = `100%`

        )->ele( n = `ToolPage` ns = `tnt`
            )->a( n = `id`           v = `toolPage`
            " onMenuTogglePress toggles ToolPage.sideExpanded imperatively; the
            " property is bindable, so it is two-way bound here (app 302)
            )->a( n = `sideExpanded` v = client->_bind( side_expanded )

            )->ele( n = `header` ns = `tnt`
                )->ele( n = `ToolHeader` ns = `tnt`
                    )->tag( `Button`
                        )->a( n = `id`      v = `menuToggleButton`
                        )->a( n = `icon`    v = `sap-icon://menu2`
                        )->a( n = `tooltip` v = `Menu`
                        )->a( n = `type`    v = `Transparent`
                        )->a( n = `press`   v = client->_event( `MENU_TOGGLE` )
                    )->tag( `Image`
                        )->a( n = `src`        v = `./images/SAP_Logo.png`
                        )->a( n = `tooltip`    v = `SAP logo`
                        )->a( n = `decorative` v = `false`
                    )->tag( `Title`
                        )->a( n = `text`     v = `Product name`
                        )->a( n = `wrapping` v = `false`
                    )->tag( `Text`
                        )->a( n = `text`     v = `Second title`
                        )->a( n = `wrapping` v = `false`
                    )->tag( `ToolbarSpacer`

                    )->ele( `SearchField`
                        )->a( n = `width` v = `16rem`
                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `priority` v = `Low`
                                )->a( n = `group`    v = `1`

                        )->end(
                    )->end(
                    )->ele( `ToolbarSpacer`
                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `priority` v = `Low`
                                )->a( n = `group`    v = `1`

                        )->end(
                    )->end(
                    )->ele( `ToolbarSeparator`
                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `group` v = `2`

                        )->end(
                    )->end(

                    )->tag( `OverflowToolbarButton`
                        )->a( n = `text` v = `Settings`
                        )->a( n = `type` v = `Transparent`
                        )->a( n = `icon` v = `sap-icon://action-settings`

                    )->ele( `Button`
                        )->a( n = `tooltip` v = `Notifications`
                        )->a( n = `type`    v = `Transparent`
                        )->a( n = `icon`    v = `sap-icon://bell`
                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `priority` v = `NeverOverflow`

                        )->end(
                    )->end(
                )->end(
            )->end(

            )->ele( n = `sideContent` ns = `tnt`
                )->ele( n = `SideNavigation` ns = `tnt`
                    )->a( n = `id`         v = `sideNavigation`
                    )->a( n = `itemSelect` v = client->_event( val   = `ITEM_SELECT`
                                                               t_arg = VALUE #( ( `${$parameters>/item}.getKey()` ) ) )

                    )->ele( n = `filterSection` ns = `tnt`
                        " value is two-way bound so the filter state survives the round-trip;
                        " liveChange transports the typed value, search the submitted query
                        )->tag( n = `SideNavigationSearchField` ns = `tnt`
                            )->a( n = `id`           v = `sideNavigationSearchField`
                            )->a( n = `ariaControls` v = `sideNavigation`
                            )->a( n = `value`        v = client->_bind( search_value )
                            )->a( n = `liveChange`   v = client->_event( val   = `LIVE_CHANGE`
                                                                         t_arg = VALUE #( ( `${$parameters>/newValue}` ) ) )
                            )->a( n = `search`       v = client->_event( val   = `SEARCH`
                                                                         t_arg = VALUE #( ( `${$parameters>/query}` ) ) )

                    )->end(
                    )->ele( n = `item` ns = `tnt`
                        )->ele( n = `NavigationList` ns = `tnt`
                            )->a( n = `id`              v = `navigationList`
                            " setHighlightedText follows the typed value in the original;
                            " the property is bindable, so it shares the search field's value
                            )->a( n = `highlightedText` v = client->_bind( search_value )

                            " navigationItemFactory resolved server-side: the /navigation rows
                            " are this static item/group/group skeleton, the group items stay
                            " model-bound and the search filters them in ABAP
                            )->tag( n = `NavigationListItem` ns = `tnt`
                                )->a( n = `text`    v = `Home`
                                )->a( n = `icon`    v = `sap-icon://home`
                                )->a( n = `key`     v = `home`
                                )->a( n = `visible` v = client->_bind( home_visible )
                                )->a( n = `press`   v = client->_event( val   = `ITEM_PRESS`
                                                                        t_arg = VALUE #( ( `${$source>/key}` ) ) )

                            )->ele( n = `NavigationListGroup` ns = `tnt`
                                )->a( n = `text`     v = `Business Operations`
                                )->a( n = `expanded` v = `true`
                                )->a( n = `visible`  v = client->_bind( group1_visible )
                                )->a( n = `items`    v = client->_bind( t_group1 )

                                )->ele( n = `NavigationListItem` ns = `tnt`
                                    )->a( n = `text`         v = `{TITLE}`
                                    )->a( n = `icon`         v = `{ICON}`
                                    )->a( n = `enabled`      v = `{ENABLED}`
                                    )->a( n = `expanded`     v = `{EXPANDED}`
                                    )->a( n = `hasExpander`  v = `{HASEXPANDER}`
                                    )->a( n = `selectable`   v = `{SELECTABLE}`
                                    )->a( n = `key`          v = `{KEY}`
                                    )->a( n = `href`         v = `{HREF}`
                                    )->a( n = `target`       v = `{TARGET}`
                                    )->a( n = `ariaHasPopup` v = `{ARIAHASPOPUP}`
                                    )->a( n = `design`       v = `{DESIGN}`
                                    )->a( n = `items`        v = `{ITEMS}`
                                    )->a( n = `press`        v = client->_event( val   = `ITEM_PRESS`
                                                                                 t_arg = VALUE #( ( `${$source>/key}` ) ) )

                                    )->ele( n = `tag` ns = `tnt`
                                        )->tag( `ObjectStatus`
                                            )->a( n = `text`     v = `{TAGTEXT}`
                                            )->a( n = `state`    v = `{TAGSTATE}`
                                            )->a( n = `inverted` v = `true`
                                            )->a( n = `visible`  v = `{= !!${TAGTEXT} }`

                                    )->end(
                                    )->ele( n = `NavigationListItem` ns = `tnt`
                                        )->a( n = `selectable`   v = `{SELECTABLE}`
                                        )->a( n = `text`         v = `{TITLE}`
                                        )->a( n = `key`          v = `{KEY}`
                                        )->a( n = `enabled`      v = `{ENABLED}`
                                        )->a( n = `href`         v = `{HREF}`
                                        )->a( n = `target`       v = `{TARGET}`
                                        )->a( n = `ariaHasPopup` v = `{ARIAHASPOPUP}`
                                        )->a( n = `design`       v = `{DESIGN}`
                                        )->a( n = `press`        v = client->_event( val   = `ITEM_PRESS`
                                                                                     t_arg = VALUE #( ( `${$source>/key}` ) ) )

                                        )->ele( n = `tag` ns = `tnt`
                                            )->tag( `ObjectStatus`
                                                )->a( n = `text`     v = `{TAGTEXT}`
                                                )->a( n = `state`    v = `{TAGSTATE}`
                                                )->a( n = `inverted` v = `true`
                                                )->a( n = `visible`  v = `{= !!${TAGTEXT} }`

                                        )->end(
                                    )->end(
                                )->end(
                            )->end(

                            )->ele( n = `NavigationListGroup` ns = `tnt`
                                )->a( n = `text`     v = `System & Administration`
                                )->a( n = `expanded` v = `true`
                                )->a( n = `visible`  v = client->_bind( group2_visible )
                                )->a( n = `items`    v = client->_bind( t_group2 )

                                )->ele( n = `NavigationListItem` ns = `tnt`
                                    )->a( n = `text`         v = `{TITLE}`
                                    )->a( n = `icon`         v = `{ICON}`
                                    )->a( n = `enabled`      v = `{ENABLED}`
                                    )->a( n = `expanded`     v = `{EXPANDED}`
                                    )->a( n = `hasExpander`  v = `{HASEXPANDER}`
                                    )->a( n = `selectable`   v = `{SELECTABLE}`
                                    )->a( n = `key`          v = `{KEY}`
                                    )->a( n = `href`         v = `{HREF}`
                                    )->a( n = `target`       v = `{TARGET}`
                                    )->a( n = `ariaHasPopup` v = `{ARIAHASPOPUP}`
                                    )->a( n = `design`       v = `{DESIGN}`
                                    )->a( n = `items`        v = `{ITEMS}`
                                    )->a( n = `press`        v = client->_event( val   = `ITEM_PRESS`
                                                                                 t_arg = VALUE #( ( `${$source>/key}` ) ) )

                                    )->ele( n = `tag` ns = `tnt`
                                        )->tag( `ObjectStatus`
                                            )->a( n = `text`     v = `{TAGTEXT}`
                                            )->a( n = `state`    v = `{TAGSTATE}`
                                            )->a( n = `inverted` v = `true`
                                            )->a( n = `visible`  v = `{= !!${TAGTEXT} }`

                                    )->end(
                                    )->ele( n = `NavigationListItem` ns = `tnt`
                                        )->a( n = `selectable`   v = `{SELECTABLE}`
                                        )->a( n = `text`         v = `{TITLE}`
                                        )->a( n = `key`          v = `{KEY}`
                                        )->a( n = `enabled`      v = `{ENABLED}`
                                        )->a( n = `href`         v = `{HREF}`
                                        )->a( n = `target`       v = `{TARGET}`
                                        )->a( n = `ariaHasPopup` v = `{ARIAHASPOPUP}`
                                        )->a( n = `design`       v = `{DESIGN}`
                                        )->a( n = `press`        v = client->_event( val   = `ITEM_PRESS`
                                                                                     t_arg = VALUE #( ( `${$source>/key}` ) ) )

                                        )->ele( n = `tag` ns = `tnt`
                                            )->tag( `ObjectStatus`
                                                )->a( n = `text`     v = `{TAGTEXT}`
                                                )->a( n = `state`    v = `{TAGSTATE}`
                                                )->a( n = `inverted` v = `true`
                                                )->a( n = `visible`  v = `{= !!${TAGTEXT} }`

                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(

                    )->ele( n = `fixedItem` ns = `tnt`
                        )->ele( n = `NavigationList` ns = `tnt`
                            )->a( n = `items` v = client->_bind( t_fixed )

                            )->ele( n = `NavigationListItem` ns = `tnt`
                                )->a( n = `text`         v = `{TITLE}`
                                )->a( n = `selectable`   v = `{SELECTABLE}`
                                )->a( n = `icon`         v = `{ICON}`
                                )->a( n = `key`          v = `{KEY}`
                                )->a( n = `href`         v = `{HREF}`
                                )->a( n = `target`       v = `{TARGET}`
                                )->a( n = `ariaHasPopup` v = `{ARIAHASPOPUP}`
                                )->a( n = `design`       v = `{DESIGN}`
                                )->a( n = `press`        v = client->_event( val   = `ITEM_PRESS`
                                                                             t_arg = VALUE #( ( `${$source>/key}` ) ) )

                                )->ele( n = `tag` ns = `tnt`
                                    )->tag( `ObjectStatus`
                                        )->a( n = `text`     v = `{TAGTEXT}`
                                        )->a( n = `state`    v = `{TAGSTATE}`
                                        )->a( n = `inverted` v = `true`
                                        )->a( n = `visible`  v = `{= !!${TAGTEXT} }`

                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(
            )->end(

            )->ele( n = `mainContents` ns = `tnt`
                )->ele( `NavContainer`
                    )->a( n = `id` v = `navContainer`

                    )->ele( `pages`
                        )->ele( `ScrollContainer`
                            )->a( n = `id`         v = `home`
                            )->a( n = `horizontal` v = `false`
                            )->a( n = `vertical`   v = `true`
                            )->a( n = `height`     v = `100%`
                            )->a( n = `class`      v = `sapUiContentPadding`

                            )->tag( `Text`
                                )->a( n = `text` v = `This is the home page`

                        )->end(
                        )->ele( `ScrollContainer`
                            )->a( n = `id`         v = `myAccounts`
                            )->a( n = `horizontal` v = `false`
                            )->a( n = `vertical`   v = `true`
                            )->a( n = `height`     v = `100%`
                            )->a( n = `class`      v = `sapUiContentPadding`

                            )->tag( `Text`
                                )->a( n = `text` v = `This is my accounts page`

                        )->end(
                        )->ele( `ScrollContainer`
                            )->a( n = `id`         v = `myOrders`
                            )->a( n = `horizontal` v = `false`
                            )->a( n = `vertical`   v = `true`
                            )->a( n = `height`     v = `100%`
                            )->a( n = `class`      v = `sapUiContentPadding`

                            )->tag( `Text`
                                )->a( n = `text` v = `This is my orders page`

                        )->end(
                        )->ele( `ScrollContainer`
                            )->a( n = `id`         v = `CustomerManagement`
                            )->a( n = `horizontal` v = `false`
                            )->a( n = `vertical`   v = `true`
                            )->a( n = `height`     v = `100%`
                            )->a( n = `class`      v = `sapUiContentPadding`

                            )->tag( `Text`
                                )->a( n = `text` v = `This is customer management page` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `MENU_TOGGLE`.
        " onMenuTogglePress: flips ToolPage.sideExpanded; collapsing also resets
        " the search field, the highlight and the filtered lists
        side_expanded = xsdbool( side_expanded = abap_false ).
        IF side_expanded = abap_false.
          search_value = ``.
          apply_filter( ).
        ENDIF.

      WHEN `ITEM_SELECT`.
        " onItemSelect: navContainer.to( item key ) - only when a page with that
        " id exists, exactly like the original's getPage check
        DATA(key) = client->get_event_arg( ).
        IF key = `home` OR key = `myAccounts` OR key = `myOrders` OR key = `CustomerManagement`.
          client->follow_up_action( val   = client->cs_event-control_by_id
                                    t_arg = VALUE #( ( `navContainer` )
                                                     ( `to` )
                                                     ( key ) ) ).
        ENDIF.

      WHEN `ITEM_PRESS`.
        " onItemPress: only the fixed 'Quick Create' item opens the dialog
        IF client->get_event_arg( ) = `quickCreate`.
          popup_quick_create( ).
        ENDIF.

      WHEN `LIVE_CHANGE`.
        " onLiveChange: filter the lists server-side and highlight the matches -
        " highlightedText is bound to the same value the filter runs on
        search_value = client->get_event_arg( ).
        apply_filter( ).

      WHEN `SEARCH`.
        " onSearch: announce the match count; nothing to announce on an empty query
        search_value = client->get_event_arg( ).
        IF search_value IS NOT INITIAL.
          client->follow_up_action( val   = client->cs_event-control_by_id
                                    t_arg = VALUE #( ( `navigationList` )
                                                     ( `announceSearchMatchCount` )
                                                     ( |{ count_matches( ) }| ) ) ).
        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD popup_quick_create.

    DATA(popup) = z2ui5_cl_ui5_view_builder=>factory( ).

    popup->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns`      v = `sap.m`

        )->ele( `Dialog`
            )->a( n = `title` v = `Create Item`
            )->a( n = `type`  v = `Message`

            )->ele( `content`
                )->tag( `Text`
                    )->a( n = `text` v = `Create New Navigation List Item.`

            )->end(
            )->ele( `beginButton`
                )->tag( `Button`
                    )->a( n = `type`  v = `Emphasized`
                    )->a( n = `text`  v = `Create`
                    )->a( n = `press` v = client->follow_up_action( client->cs_event-popup_close )

            )->end(
            )->ele( `endButton`
                )->tag( `Button`
                    )->a( n = `text`  v = `Cancel`
                    )->a( n = `press` v = client->follow_up_action( client->cs_event-popup_close ) ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD apply_filter.

    IF search_value IS INITIAL.
      home_visible   = abap_true.
      group1_visible = abap_true.
      group2_visible = abap_true.
      t_group1       = t_group1_full.
      t_group2       = t_group2_full.
      t_fixed        = t_fixed_full.
      RETURN.
    ENDIF.

    " _filterItems: an item stays when its title or tagText contains the value
    " (a matching parent keeps all its children), else when a child matches;
    " ABAP CS compares case-insensitively like the original's toLowerCase
    home_visible = xsdbool( `Home` CS search_value ).

    " a group row is part of the filtered collection too: a matching group
    " title keeps the whole group
    IF `Business Operations` CS search_value.
      t_group1 = t_group1_full.
    ELSE.
      t_group1 = filter_items( t_group1_full ).
    ENDIF.
    group1_visible = xsdbool( t_group1 IS NOT INITIAL ).

    IF `System & Administration` CS search_value.
      t_group2 = t_group2_full.
    ELSE.
      t_group2 = filter_items( t_group2_full ).
    ENDIF.
    group2_visible = xsdbool( t_group2 IS NOT INITIAL ).

    t_fixed = VALUE #( ).
    LOOP AT t_fixed_full INTO DATA(s_fixed).
      IF s_fixed-title CS search_value OR s_fixed-tagtext CS search_value.
        APPEND s_fixed TO t_fixed.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD filter_items.

    LOOP AT it_items INTO DATA(s_item).
      IF s_item-title CS search_value OR s_item-tagtext CS search_value.
        APPEND s_item TO rt_items.
        CONTINUE.
      ENDIF.
      DATA(t_children) = VALUE ty_t_sub_item( ).
      LOOP AT s_item-items INTO DATA(s_child).
        IF s_child-title CS search_value OR s_child-tagtext CS search_value.
          APPEND s_child TO t_children.
        ENDIF.
      ENDLOOP.
      IF t_children IS NOT INITIAL.
        s_item-items = t_children.
        APPEND s_item TO rt_items.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD count_matches.

    " _countItems: a recursive title-only count over the UNFILTERED
    " navigation + fixedNavigation rows - group titles count too
    IF `Home` CS search_value.
      rv_count = 1.
    ENDIF.
    IF `Business Operations` CS search_value.
      rv_count = rv_count + 1.
    ENDIF.
    IF `System & Administration` CS search_value.
      rv_count = rv_count + 1.
    ENDIF.
    DATA(t_grouped) = t_group1_full.
    APPEND LINES OF t_group2_full TO t_grouped.
    LOOP AT t_grouped INTO DATA(s_item).
      IF s_item-title CS search_value.
        rv_count = rv_count + 1.
      ENDIF.
      LOOP AT s_item-items INTO DATA(s_child).
        IF s_child-title CS search_value.
          rv_count = rv_count + 1.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
    LOOP AT t_fixed_full INTO DATA(s_fixed).
      IF s_fixed-title CS search_value.
        rv_count = rv_count + 1.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD model_init.

    " the ToolPage starts with its side content expanded (UI5 default)
    side_expanded  = abap_true.
    home_visible   = abap_true.
    group1_visible = abap_true.
    group2_visible = abap_true.

    " model/data.json inlined 1:1 - the two group rows of /navigation become
    " the two tables the static NavigationListGroups bind. ENABLED, HASEXPANDER,
    " EXPANDED, SELECTABLE, ARIAHASPOPUP, DESIGN and TAGSTATE carry the UI5
    " property default explicitly where the mock omits the key - a flat ABAP
    " row would otherwise serialize an empty value and override that default
    t_group1_full = VALUE #(
      enabled = abap_true hasexpander = abap_true
      ( title = `Favorites` icon = `sap-icon://unfavorite` expanded = abap_true selectable = abap_false
        ariahaspopup = `None` design = `Default` tagtext = `3 Items` tagstate = `Indication17`
        items = VALUE #(
          enabled = abap_true selectable = abap_true ariahaspopup = `None` design = `Default`
          ( title = `My Accounts` key = `myAccounts` tagstate = `None` )
          ( title = `My Orders` key = `myOrders` tagtext = `5 Pending` tagstate = `Indication20` ) ) )
      ( title = `Customer Management` icon = `sap-icon://account` expanded = abap_true selectable = abap_false
        key = `CustomerManagement` ariahaspopup = `None` design = `Default` tagstate = `None`
        items = VALUE #(
          enabled = abap_true selectable = abap_true ariahaspopup = `None` design = `Default` tagstate = `None`
          ( title = `Contacts` key = `contacts` )
          ( title = `Companies` key = `companies` )
          ( title = `Partners` key = `partners` ) ) )
      ( title = `SAP Best Practices` icon = `sap-icon://learning-assistant` expanded = abap_true selectable = abap_false
        key = `sapBestPractices` href = `https://sap.com` target = `_blank`
        ariahaspopup = `None` design = `Default` tagstate = `None` )
      ( title = `Sales` icon = `sap-icon://crm-sales` expanded = abap_true selectable = abap_false
        key = `Sales` ariahaspopup = `None` design = `Default` tagstate = `None`
        items = VALUE #(
          enabled = abap_true selectable = abap_true ariahaspopup = `None` design = `Default` tagstate = `None`
          ( title = `Leads` key = `leads` )
          ( title = `Opportunities` key = `opportunities` )
          ( title = `Quotes` key = `quotes` )
          ( title = `Orders` key = `orders` )
          ( title = `Invoices` key = `invoices` ) ) )
      ( title = `Products` icon = `sap-icon://customer-view` expanded = abap_true selectable = abap_true
        key = `products` ariahaspopup = `None` design = `Default` tagtext = `Low Stock` tagstate = `Indication18`
        items = VALUE #(
          enabled = abap_true selectable = abap_true ariahaspopup = `None` design = `Default` tagstate = `None`
          ( title = `Product Catalog` key = `productCatalog` )
          ( title = `Pricing` key = `pricing` )
          ( title = `Inventory Management` key = `inventoryManagement` ) ) )
      ( title = `Marketing` icon = `sap-icon://customer-view` expanded = abap_true selectable = abap_false
        key = `marketing` ariahaspopup = `None` design = `Default` tagstate = `None`
        items = VALUE #(
          enabled = abap_true selectable = abap_true ariahaspopup = `None` design = `Default` tagstate = `None`
          ( title = `Campaigns` key = `campaigns` )
          ( title = `E-mail Marketing` key = `emailMarketing` )
          ( title = `MArketing Automation` key = `marketingAutomation` ) ) )
      ( title = `Finance` icon = `sap-icon://money-bills` expanded = abap_true selectable = abap_false
        ariahaspopup = `None` design = `Default` tagstate = `None`
        items = VALUE #(
          enabled = abap_true selectable = abap_true ariahaspopup = `None` design = `Default` tagstate = `None`
          ( title = `Accounts Receivable` key = `accountsReceivable` )
          ( title = `Accounts Payable` key = `accountsPayable` )
          ( title = `Budget Planning` key = `budgetPlanning` )
          ( title = `Tax Management` key = `taxManagement` ) ) )
      ( title = `Year-End Financial Reports` icon = `sap-icon://manager-insight` expanded = abap_true selectable = abap_true
        key = `reports` ariahaspopup = `None` design = `Default` tagstate = `None`
        items = VALUE #(
          enabled = abap_true selectable = abap_true ariahaspopup = `None` design = `Default` tagstate = `None`
          ( title = `Sales Reports` key = `salesReports` )
          ( title = `Customer reports` key = `customerReports` ) ) ) ).

    t_group2_full = VALUE #(
      enabled = abap_true hasexpander = abap_true
      ( title = `Analytics` icon = `sap-icon://bar-chart` expanded = abap_true selectable = abap_true
        key = `analytics` ariahaspopup = `None` design = `Default` tagtext = `Beta` tagstate = `Indication15` )
      ( title = `SAP Community` icon = `sap-icon://discussion-2` expanded = abap_true selectable = abap_false
        key = `sapCommunity` href = `https://sap.com` target = `_blank`
        ariahaspopup = `None` design = `Default` tagstate = `None` )
      ( title = `Administration` icon = `sap-icon://settings` expanded = abap_false selectable = abap_false
        ariahaspopup = `None` design = `Default` tagstate = `None`
        items = VALUE #(
          enabled = abap_true selectable = abap_true ariahaspopup = `None` design = `Default` tagstate = `None`
          ( title = `User Management` key = `userManagement` )
          ( title = `System Configuration` key = `systemConfig` )
          ( title = `Audit Log` key = `auditLog` ) ) )
      ( title = `Service Management` icon = `sap-icon://customer-and-supplier` expanded = abap_false selectable = abap_false
        ariahaspopup = `None` design = `Default` tagstate = `None`
        items = VALUE #(
          enabled = abap_true selectable = abap_true ariahaspopup = `None` design = `Default` tagstate = `None`
          ( title = `Service Tickets` key = `serviceTickets` )
          ( title = `Knowledge Base` key = `knowledgeBase` )
          ( title = `Service Contracts` key = `serviceContracts` ) ) )
      ( title = `Notifications` icon = `sap-icon://message-information` expanded = abap_true selectable = abap_true
        key = `notifications` ariahaspopup = `None` design = `Default` tagtext = `8 New` tagstate = `Indication18` )
      ( title = `SAP Training` icon = `sap-icon://course-book` expanded = abap_true selectable = abap_false
        key = `sapTraining` href = `https://sap.com` target = `_blank`
        ariahaspopup = `None` design = `Default` tagstate = `None` )
      ( title = `Integration Hub` icon = `sap-icon://connected` expanded = abap_false selectable = abap_true
        key = `integrationHub` ariahaspopup = `None` design = `Default` tagstate = `None`
        items = VALUE #(
          enabled = abap_true selectable = abap_true ariahaspopup = `None` design = `Default` tagstate = `None`
          ( title = `API Management` key = `apiManagement` )
          ( title = `Data Sync` key = `dataSync` ) ) ) ).

    t_fixed_full = VALUE #(
      ( title = `Quick Create` icon = `sap-icon://add` key = `quickCreate` selectable = abap_false
        ariahaspopup = `Dialog` design = `Action` tagstate = `None` )
      ( title = `Product Settings` icon = `sap-icon://settings` key = `productSettings` selectable = abap_true
        ariahaspopup = `None` design = `Default` tagstate = `None` )
      ( title = `SAP Support Portal` icon = `sap-icon://sys-help` key = `sapSupport` selectable = abap_false
        href = `https://sap.com` target = `_blank`
        ariahaspopup = `None` design = `Default` tagtext = `24/7` tagstate = `Indication16` ) ).

    t_group1 = t_group1_full.
    t_group2 = t_group2_full.
    t_fixed  = t_fixed_full.

  ENDMETHOD.

ENDCLASS.
