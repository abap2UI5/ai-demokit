" @keywords sidenavigation side navigation sap.tnt sidenavigationsearch toolpage toolheader button image title text toolbarspacer
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
    TYPES ty_t_sub_item TYPE STANDARD TABLE OF ty_s_sub_item WITH DEFAULT KEY.
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
    TYPES ty_t_nav_item TYPE STANDARD TABLE OF ty_s_nav_item WITH DEFAULT KEY.
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
    TYPES ty_t_fixed_item TYPE STANDARD TABLE OF ty_s_fixed_item WITH DEFAULT KEY.

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
    METHODS navigate_to
      IMPORTING key TYPE string.
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
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    DATA temp2 TYPE string_table.
    DATA temp3 TYPE string_table.
    DATA temp4 TYPE string_table.
    DATA temp5 TYPE string_table.
    DATA temp6 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `${$source>/key}` INTO TABLE temp1.
    INSERT `${$source>/selectable}` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `${$source>/key}` INTO TABLE temp2.
    INSERT `${$source>/selectable}` INTO TABLE temp2.
    
    CLEAR temp3.
    INSERT `${$source>/key}` INTO TABLE temp3.
    INSERT `${$source>/selectable}` INTO TABLE temp3.
    
    CLEAR temp4.
    INSERT `${$source>/key}` INTO TABLE temp4.
    INSERT `${$source>/selectable}` INTO TABLE temp4.
    
    CLEAR temp5.
    INSERT `${$source>/key}` INTO TABLE temp5.
    INSERT `${$source>/selectable}` INTO TABLE temp5.
    
    CLEAR temp6.
    INSERT `${$source>/key}` INTO TABLE temp6.
    INSERT `${$source>/selectable}` INTO TABLE temp6.
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
                    )->a( n = `itemSelect` v = client->_event( val = `ITEM_SELECT` arg = `${$parameters>/item}.getKey()` )

                    )->ele( n = `filterSection` ns = `tnt`
                        " value is two-way bound so the filter state survives the round-trip;
                        " liveChange transports the typed value, search the submitted query
                        )->tag( n = `SideNavigationSearchField` ns = `tnt`
                            )->a( n = `id`           v = `sideNavigationSearchField`
                            )->a( n = `ariaControls` v = `sideNavigation`
                            )->a( n = `value`        v = client->_bind( search_value )
                            )->a( n = `liveChange`   v = client->_event( val = `LIVE_CHANGE` arg = `${$parameters>/newValue}` )
                            )->a( n = `search`       v = client->_event( val = `SEARCH` arg = `${$parameters>/query}` )

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
                                                                        t_arg = temp1 )

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
                                                                                 t_arg = temp2 )

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
                                                                                     t_arg = temp3 )

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
                                                                                 t_arg = temp4 )

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
                                                                                     t_arg = temp5 )

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
                                                                             t_arg = temp6 )

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
        DATA temp1 TYPE xsdboolean.
          DATA temp3 TYPE string_table.
          DATA temp4 LIKE LINE OF temp3.

    CASE client->get_event( ).

      WHEN `MENU_TOGGLE`.
        " onMenuTogglePress: flips ToolPage.sideExpanded; collapsing also resets
        " the search field, the highlight and the filtered lists
        
        temp1 = boolc( side_expanded = abap_false ).
        side_expanded = temp1.
        IF side_expanded = abap_false.
          search_value = ``.
          apply_filter( ).
        ENDIF.

      WHEN `ITEM_SELECT`.
        " onItemSelect: navContainer.to( item key ). Kept wired 1:1 with the
        " original, but a click on an item does NOT arrive here - see
        " ITEM_PRESS below.
        navigate_to( client->get_event_arg( ) ).

      WHEN `ITEM_PRESS`.
        " The original runs BOTH handlers on one click: the SideNavigation's
        " itemSelect navigates, and the item's own press opens Quick Create.
        " One gesture delivers ONE round-trip here and the item's press wins
        " it, so the itemSelect branch above never runs - both behaviours are
        " served from here instead, which is what the user of the original
        " sees. Measured 2026-08-21: the click sends EVENT ITEM_PRESS and the
        " itemSelect wire is swallowed.
        " NavigationListItem._selectItem fires `select` unconditionally but
        " reaches the list's own _selectItem - and with it itemSelect, and with
        " it the original's navigation - only `if (this.getSelectable())`.
        " `press` fires unconditionally either way. So an item the mock marks
        " selectable:false navigates NOWHERE in the original: Customer
        " Management runs onItemPress, whose key is not quickCreate, and
        " nothing else. The port navigated it anyway until 2026-08-21, which
        " made a page unreachable upstream reachable here. Each press wire
        " carries the item's own selectable flag now, so the guard is the same
        " one the control applies.
        IF client->get_event_arg( ) = `quickCreate`.
          popup_quick_create( ).
        ELSEIF client->get_event_arg( 2 ) = abap_true.
          navigate_to( client->get_event_arg( ) ).
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
          
          CLEAR temp3.
          INSERT `navigationList` INTO TABLE temp3.
          INSERT `announceSearchMatchCount` INTO TABLE temp3.
          
          temp4 = |{ count_matches( ) }|.
          INSERT temp4 INTO TABLE temp3.
          client->follow_up_action( val   = client->cs_event-control_by_id
                                    t_arg = temp3 ).
        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD navigate_to.
      DATA temp5 TYPE string_table.

    " navContainer.to( key ) - only for a key the NavContainer actually has a
    " page for, exactly like the original's getPage check
    IF key = `home` OR key = `myAccounts` OR key = `myOrders` OR key = `CustomerManagement`.
      
      CLEAR temp5.
      INSERT `navContainer` INTO TABLE temp5.
      INSERT `to` INTO TABLE temp5.
      INSERT key INTO TABLE temp5.
      client->follow_up_action( val   = client->cs_event-control_by_id
                                t_arg = temp5 ).
    ENDIF.

  ENDMETHOD.


  METHOD popup_quick_create.

    DATA popup TYPE REF TO z2ui5_cl_ui5_view_builder.
    popup = z2ui5_cl_ui5_view_builder=>factory( ).

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
    DATA temp2 TYPE xsdboolean.
    DATA temp3 TYPE xsdboolean.
    DATA temp4 TYPE xsdboolean.
    DATA temp7 TYPE z2ui5_cl_smpc_app_407=>ty_t_fixed_item.
    DATA s_fixed LIKE LINE OF t_fixed_full.

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
    
    temp2 = boolc( `Home` CS search_value ).
    home_visible = temp2.

    " a group row is part of the filtered collection too: a matching group
    " title keeps the whole group
    IF `Business Operations` CS search_value.
      t_group1 = t_group1_full.
    ELSE.
      t_group1 = filter_items( t_group1_full ).
    ENDIF.
    
    temp3 = boolc( t_group1 IS NOT INITIAL ).
    group1_visible = temp3.

    IF `System & Administration` CS search_value.
      t_group2 = t_group2_full.
    ELSE.
      t_group2 = filter_items( t_group2_full ).
    ENDIF.
    
    temp4 = boolc( t_group2 IS NOT INITIAL ).
    group2_visible = temp4.

    
    CLEAR temp7.
    t_fixed = temp7.
    
    LOOP AT t_fixed_full INTO s_fixed.
      IF s_fixed-title CS search_value OR s_fixed-tagtext CS search_value.
        APPEND s_fixed TO t_fixed.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD filter_items.

    DATA s_item LIKE LINE OF it_items.
      DATA temp8 TYPE ty_t_sub_item.
      DATA t_children LIKE temp8.
      DATA s_child LIKE LINE OF s_item-items.
    LOOP AT it_items INTO s_item.
      IF s_item-title CS search_value OR s_item-tagtext CS search_value.
        APPEND s_item TO rt_items.
        CONTINUE.
      ENDIF.
      
      CLEAR temp8.
      
      t_children = temp8.
      
      LOOP AT s_item-items INTO s_child.
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
    DATA t_grouped LIKE t_group1_full.
    DATA s_item LIKE LINE OF t_grouped.
      DATA s_child LIKE LINE OF s_item-items.
    DATA s_fixed LIKE LINE OF t_fixed_full.

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
    
    t_grouped = t_group1_full.
    APPEND LINES OF t_group2_full TO t_grouped.
    
    LOOP AT t_grouped INTO s_item.
      IF s_item-title CS search_value.
        rv_count = rv_count + 1.
      ENDIF.
      
      LOOP AT s_item-items INTO s_child.
        IF s_child-title CS search_value.
          rv_count = rv_count + 1.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
    
    LOOP AT t_fixed_full INTO s_fixed.
      IF s_fixed-title CS search_value.
        rv_count = rv_count + 1.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD model_init.
    DATA temp9 TYPE z2ui5_cl_smpc_app_407=>ty_t_nav_item.
    DATA temp10 LIKE LINE OF temp9.
    DATA temp5 TYPE z2ui5_cl_smpc_app_407=>ty_t_sub_item.
    DATA temp6 LIKE LINE OF temp5.
    DATA temp7 TYPE z2ui5_cl_smpc_app_407=>ty_t_sub_item.
    DATA temp8 LIKE LINE OF temp7.
    DATA temp15 TYPE z2ui5_cl_smpc_app_407=>ty_t_sub_item.
    DATA temp16 LIKE LINE OF temp15.
    DATA temp17 TYPE z2ui5_cl_smpc_app_407=>ty_t_sub_item.
    DATA temp18 LIKE LINE OF temp17.
    DATA temp19 TYPE z2ui5_cl_smpc_app_407=>ty_t_sub_item.
    DATA temp20 LIKE LINE OF temp19.
    DATA temp21 TYPE z2ui5_cl_smpc_app_407=>ty_t_sub_item.
    DATA temp22 LIKE LINE OF temp21.
    DATA temp23 TYPE z2ui5_cl_smpc_app_407=>ty_t_sub_item.
    DATA temp24 LIKE LINE OF temp23.
    DATA temp11 TYPE z2ui5_cl_smpc_app_407=>ty_t_nav_item.
    DATA temp12 LIKE LINE OF temp11.
    DATA temp25 TYPE z2ui5_cl_smpc_app_407=>ty_t_sub_item.
    DATA temp26 LIKE LINE OF temp25.
    DATA temp27 TYPE z2ui5_cl_smpc_app_407=>ty_t_sub_item.
    DATA temp28 LIKE LINE OF temp27.
    DATA temp29 TYPE z2ui5_cl_smpc_app_407=>ty_t_sub_item.
    DATA temp30 LIKE LINE OF temp29.
    DATA temp13 TYPE z2ui5_cl_smpc_app_407=>ty_t_fixed_item.
    DATA temp14 LIKE LINE OF temp13.

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
    
    CLEAR temp9.
    
    temp10-enabled = abap_true.
    temp10-hasexpander = abap_true.
    temp10-title = `Favorites`.
    temp10-icon = `sap-icon://unfavorite`.
    temp10-expanded = abap_true.
    temp10-selectable = abap_false.
    temp10-ariahaspopup = `None`.
    temp10-design = `Default`.
    temp10-tagtext = `3 Items`.
    temp10-tagstate = `Indication17`.
    
    CLEAR temp5.
    
    temp6-enabled = abap_true.
    temp6-selectable = abap_true.
    temp6-ariahaspopup = `None`.
    temp6-design = `Default`.
    temp6-title = `My Accounts`.
    temp6-key = `myAccounts`.
    temp6-tagstate = `None`.
    INSERT temp6 INTO TABLE temp5.
    temp6-title = `My Orders`.
    temp6-key = `myOrders`.
    temp6-tagtext = `5 Pending`.
    temp6-tagstate = `Indication20`.
    INSERT temp6 INTO TABLE temp5.
    temp10-items = temp5.
    INSERT temp10 INTO TABLE temp9.
    temp10-title = `Customer Management`.
    temp10-icon = `sap-icon://account`.
    temp10-expanded = abap_true.
    temp10-selectable = abap_false.
    temp10-key = `CustomerManagement`.
    temp10-ariahaspopup = `None`.
    temp10-design = `Default`.
    temp10-tagstate = `None`.
    
    CLEAR temp7.
    
    temp8-enabled = abap_true.
    temp8-selectable = abap_true.
    temp8-ariahaspopup = `None`.
    temp8-design = `Default`.
    temp8-tagstate = `None`.
    temp8-title = `Contacts`.
    temp8-key = `contacts`.
    INSERT temp8 INTO TABLE temp7.
    temp8-title = `Companies`.
    temp8-key = `companies`.
    INSERT temp8 INTO TABLE temp7.
    temp8-title = `Partners`.
    temp8-key = `partners`.
    INSERT temp8 INTO TABLE temp7.
    temp10-items = temp7.
    INSERT temp10 INTO TABLE temp9.
    temp10-title = `SAP Best Practices`.
    temp10-icon = `sap-icon://learning-assistant`.
    temp10-expanded = abap_true.
    temp10-selectable = abap_false.
    temp10-key = `sapBestPractices`.
    temp10-href = `https://sap.com`.
    temp10-target = `_blank`.
    temp10-ariahaspopup = `None`.
    temp10-design = `Default`.
    temp10-tagstate = `None`.
    INSERT temp10 INTO TABLE temp9.
    temp10-title = `Sales`.
    temp10-icon = `sap-icon://crm-sales`.
    temp10-expanded = abap_true.
    temp10-selectable = abap_false.
    temp10-key = `Sales`.
    temp10-ariahaspopup = `None`.
    temp10-design = `Default`.
    temp10-tagstate = `None`.
    
    CLEAR temp15.
    
    temp16-enabled = abap_true.
    temp16-selectable = abap_true.
    temp16-ariahaspopup = `None`.
    temp16-design = `Default`.
    temp16-tagstate = `None`.
    temp16-title = `Leads`.
    temp16-key = `leads`.
    INSERT temp16 INTO TABLE temp15.
    temp16-title = `Opportunities`.
    temp16-key = `opportunities`.
    INSERT temp16 INTO TABLE temp15.
    temp16-title = `Quotes`.
    temp16-key = `quotes`.
    INSERT temp16 INTO TABLE temp15.
    temp16-title = `Orders`.
    temp16-key = `orders`.
    INSERT temp16 INTO TABLE temp15.
    temp16-title = `Invoices`.
    temp16-key = `invoices`.
    INSERT temp16 INTO TABLE temp15.
    temp10-items = temp15.
    INSERT temp10 INTO TABLE temp9.
    temp10-title = `Products`.
    temp10-icon = `sap-icon://customer-view`.
    temp10-expanded = abap_true.
    temp10-selectable = abap_true.
    temp10-key = `products`.
    temp10-ariahaspopup = `None`.
    temp10-design = `Default`.
    temp10-tagtext = `Low Stock`.
    temp10-tagstate = `Indication18`.
    
    CLEAR temp17.
    
    temp18-enabled = abap_true.
    temp18-selectable = abap_true.
    temp18-ariahaspopup = `None`.
    temp18-design = `Default`.
    temp18-tagstate = `None`.
    temp18-title = `Product Catalog`.
    temp18-key = `productCatalog`.
    INSERT temp18 INTO TABLE temp17.
    temp18-title = `Pricing`.
    temp18-key = `pricing`.
    INSERT temp18 INTO TABLE temp17.
    temp18-title = `Inventory Management`.
    temp18-key = `inventoryManagement`.
    INSERT temp18 INTO TABLE temp17.
    temp10-items = temp17.
    INSERT temp10 INTO TABLE temp9.
    temp10-title = `Marketing`.
    temp10-icon = `sap-icon://customer-view`.
    temp10-expanded = abap_true.
    temp10-selectable = abap_false.
    temp10-key = `marketing`.
    temp10-ariahaspopup = `None`.
    temp10-design = `Default`.
    temp10-tagstate = `None`.
    
    CLEAR temp19.
    
    temp20-enabled = abap_true.
    temp20-selectable = abap_true.
    temp20-ariahaspopup = `None`.
    temp20-design = `Default`.
    temp20-tagstate = `None`.
    temp20-title = `Campaigns`.
    temp20-key = `campaigns`.
    INSERT temp20 INTO TABLE temp19.
    temp20-title = `E-mail Marketing`.
    temp20-key = `emailMarketing`.
    INSERT temp20 INTO TABLE temp19.
    temp20-title = `MArketing Automation`.
    temp20-key = `marketingAutomation`.
    INSERT temp20 INTO TABLE temp19.
    temp10-items = temp19.
    INSERT temp10 INTO TABLE temp9.
    temp10-title = `Finance`.
    temp10-icon = `sap-icon://money-bills`.
    temp10-expanded = abap_true.
    temp10-selectable = abap_false.
    temp10-ariahaspopup = `None`.
    temp10-design = `Default`.
    temp10-tagstate = `None`.
    
    CLEAR temp21.
    
    temp22-enabled = abap_true.
    temp22-selectable = abap_true.
    temp22-ariahaspopup = `None`.
    temp22-design = `Default`.
    temp22-tagstate = `None`.
    temp22-title = `Accounts Receivable`.
    temp22-key = `accountsReceivable`.
    INSERT temp22 INTO TABLE temp21.
    temp22-title = `Accounts Payable`.
    temp22-key = `accountsPayable`.
    INSERT temp22 INTO TABLE temp21.
    temp22-title = `Budget Planning`.
    temp22-key = `budgetPlanning`.
    INSERT temp22 INTO TABLE temp21.
    temp22-title = `Tax Management`.
    temp22-key = `taxManagement`.
    INSERT temp22 INTO TABLE temp21.
    temp10-items = temp21.
    INSERT temp10 INTO TABLE temp9.
    temp10-title = `Year-End Financial Reports`.
    temp10-icon = `sap-icon://manager-insight`.
    temp10-expanded = abap_true.
    temp10-selectable = abap_true.
    temp10-key = `reports`.
    temp10-ariahaspopup = `None`.
    temp10-design = `Default`.
    temp10-tagstate = `None`.
    
    CLEAR temp23.
    
    temp24-enabled = abap_true.
    temp24-selectable = abap_true.
    temp24-ariahaspopup = `None`.
    temp24-design = `Default`.
    temp24-tagstate = `None`.
    temp24-title = `Sales Reports`.
    temp24-key = `salesReports`.
    INSERT temp24 INTO TABLE temp23.
    temp24-title = `Customer reports`.
    temp24-key = `customerReports`.
    INSERT temp24 INTO TABLE temp23.
    temp10-items = temp23.
    INSERT temp10 INTO TABLE temp9.
    t_group1_full = temp9.

    
    CLEAR temp11.
    
    temp12-enabled = abap_true.
    temp12-hasexpander = abap_true.
    temp12-title = `Analytics`.
    temp12-icon = `sap-icon://bar-chart`.
    temp12-expanded = abap_true.
    temp12-selectable = abap_true.
    temp12-key = `analytics`.
    temp12-ariahaspopup = `None`.
    temp12-design = `Default`.
    temp12-tagtext = `Beta`.
    temp12-tagstate = `Indication15`.
    INSERT temp12 INTO TABLE temp11.
    temp12-title = `SAP Community`.
    temp12-icon = `sap-icon://discussion-2`.
    temp12-expanded = abap_true.
    temp12-selectable = abap_false.
    temp12-key = `sapCommunity`.
    temp12-href = `https://sap.com`.
    temp12-target = `_blank`.
    temp12-ariahaspopup = `None`.
    temp12-design = `Default`.
    temp12-tagstate = `None`.
    INSERT temp12 INTO TABLE temp11.
    temp12-title = `Administration`.
    temp12-icon = `sap-icon://settings`.
    temp12-expanded = abap_false.
    temp12-selectable = abap_false.
    temp12-ariahaspopup = `None`.
    temp12-design = `Default`.
    temp12-tagstate = `None`.
    
    CLEAR temp25.
    
    temp26-enabled = abap_true.
    temp26-selectable = abap_true.
    temp26-ariahaspopup = `None`.
    temp26-design = `Default`.
    temp26-tagstate = `None`.
    temp26-title = `User Management`.
    temp26-key = `userManagement`.
    INSERT temp26 INTO TABLE temp25.
    temp26-title = `System Configuration`.
    temp26-key = `systemConfig`.
    INSERT temp26 INTO TABLE temp25.
    temp26-title = `Audit Log`.
    temp26-key = `auditLog`.
    INSERT temp26 INTO TABLE temp25.
    temp12-items = temp25.
    INSERT temp12 INTO TABLE temp11.
    temp12-title = `Service Management`.
    temp12-icon = `sap-icon://customer-and-supplier`.
    temp12-expanded = abap_false.
    temp12-selectable = abap_false.
    temp12-ariahaspopup = `None`.
    temp12-design = `Default`.
    temp12-tagstate = `None`.
    
    CLEAR temp27.
    
    temp28-enabled = abap_true.
    temp28-selectable = abap_true.
    temp28-ariahaspopup = `None`.
    temp28-design = `Default`.
    temp28-tagstate = `None`.
    temp28-title = `Service Tickets`.
    temp28-key = `serviceTickets`.
    INSERT temp28 INTO TABLE temp27.
    temp28-title = `Knowledge Base`.
    temp28-key = `knowledgeBase`.
    INSERT temp28 INTO TABLE temp27.
    temp28-title = `Service Contracts`.
    temp28-key = `serviceContracts`.
    INSERT temp28 INTO TABLE temp27.
    temp12-items = temp27.
    INSERT temp12 INTO TABLE temp11.
    temp12-title = `Notifications`.
    temp12-icon = `sap-icon://message-information`.
    temp12-expanded = abap_true.
    temp12-selectable = abap_true.
    temp12-key = `notifications`.
    temp12-ariahaspopup = `None`.
    temp12-design = `Default`.
    temp12-tagtext = `8 New`.
    temp12-tagstate = `Indication18`.
    INSERT temp12 INTO TABLE temp11.
    temp12-title = `SAP Training`.
    temp12-icon = `sap-icon://course-book`.
    temp12-expanded = abap_true.
    temp12-selectable = abap_false.
    temp12-key = `sapTraining`.
    temp12-href = `https://sap.com`.
    temp12-target = `_blank`.
    temp12-ariahaspopup = `None`.
    temp12-design = `Default`.
    temp12-tagstate = `None`.
    INSERT temp12 INTO TABLE temp11.
    temp12-title = `Integration Hub`.
    temp12-icon = `sap-icon://connected`.
    temp12-expanded = abap_false.
    temp12-selectable = abap_true.
    temp12-key = `integrationHub`.
    temp12-ariahaspopup = `None`.
    temp12-design = `Default`.
    temp12-tagstate = `None`.
    
    CLEAR temp29.
    
    temp30-enabled = abap_true.
    temp30-selectable = abap_true.
    temp30-ariahaspopup = `None`.
    temp30-design = `Default`.
    temp30-tagstate = `None`.
    temp30-title = `API Management`.
    temp30-key = `apiManagement`.
    INSERT temp30 INTO TABLE temp29.
    temp30-title = `Data Sync`.
    temp30-key = `dataSync`.
    INSERT temp30 INTO TABLE temp29.
    temp12-items = temp29.
    INSERT temp12 INTO TABLE temp11.
    t_group2_full = temp11.

    
    CLEAR temp13.
    
    temp14-title = `Quick Create`.
    temp14-icon = `sap-icon://add`.
    temp14-key = `quickCreate`.
    temp14-selectable = abap_false.
    temp14-ariahaspopup = `Dialog`.
    temp14-design = `Action`.
    temp14-tagstate = `None`.
    INSERT temp14 INTO TABLE temp13.
    temp14-title = `Product Settings`.
    temp14-icon = `sap-icon://settings`.
    temp14-key = `productSettings`.
    temp14-selectable = abap_true.
    temp14-ariahaspopup = `None`.
    temp14-design = `Default`.
    temp14-tagstate = `None`.
    INSERT temp14 INTO TABLE temp13.
    temp14-title = `SAP Support Portal`.
    temp14-icon = `sap-icon://sys-help`.
    temp14-key = `sapSupport`.
    temp14-selectable = abap_false.
    temp14-href = `https://sap.com`.
    temp14-target = `_blank`.
    temp14-ariahaspopup = `None`.
    temp14-design = `Default`.
    temp14-tagtext = `24/7`.
    temp14-tagstate = `Indication16`.
    INSERT temp14 INTO TABLE temp13.
    t_fixed_full = temp13.

    t_group1 = t_group1_full.
    t_group2 = t_group2_full.
    t_fixed  = t_fixed_full.

  ENDMETHOD.

ENDCLASS.
