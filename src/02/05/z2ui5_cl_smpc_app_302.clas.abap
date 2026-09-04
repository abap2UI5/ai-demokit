" @keywords toolpage tool sap.tnt toolpagenavigation toolheader button overflowtoolbarlayoutdata image title text toolbarspacer searchfield
" @summary A tool page layout with horizontal navigation (on desktop and tablet) and vertical navigation (on phone)
CLASS z2ui5_cl_smpc_app_302 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA selectedkey    TYPE string.
    DATA side_expanded  TYPE abap_bool.
    DATA toggle_tooltip TYPE string.

    TYPES: BEGIN OF ty_s_sub_item,
             title   TYPE string,
             key     TYPE string,
             enabled TYPE abap_bool,
           END OF ty_s_sub_item.
    TYPES: BEGIN OF ty_s_nav_item,
             title    TYPE string,
             icon     TYPE string,
             key      TYPE string,
             enabled  TYPE abap_bool,
             expanded TYPE abap_bool,
             items    TYPE STANDARD TABLE OF ty_s_sub_item WITH DEFAULT KEY,
           END OF ty_s_nav_item.
    DATA navigation TYPE STANDARD TABLE OF ty_s_nav_item WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_302 IMPLEMENTATION.

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
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:tnt` v = `sap.tnt`
        )->a( n = `height`    v = `100%`

        )->ele( n = `ToolPage` ns = `tnt`
            )->a( n = `id`           v = `toolPage`
            " onSideNavButtonPress toggles ToolPage.sideExpanded imperatively;
            " the property is bindable, so it is two-way bound here instead
            )->a( n = `sideExpanded` v = client->_bind( side_expanded )

            )->ele( n = `header` ns = `tnt`
                )->ele( n = `ToolHeader` ns = `tnt`
                    )->ele( `Button`
                        " the device> named model is served on every view slot, so the
                        " original phone branch stays a branch (CAPABILITIES.md)
                        )->a( n = `visible` v = `{= ${device>/system/phone}}`
                        )->a( n = `id`      v = `sideNavigationToggleButton`
                        )->a( n = `icon`    v = `sap-icon://menu2`
                        )->a( n = `type`    v = `Transparent`
                        )->a( n = `tooltip` v = client->_bind( toggle_tooltip )
                        )->a( n = `press`   v = client->_event( `SIDE_NAV_TOGGLE` )

                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `priority` v = `NeverOverflow`

                        )->end(
                    )->end(

                    )->tag( `Image`
                        )->a( n = `height` v = `1.5rem`
                        )->a( n = `class`  v = `sapUiSmallMarginBegin`
                        )->a( n = `src`    v = `https://www.sap.com/dam/application/shared/logos/sap-logo-svg.svg`

                    )->ele( `Title`
                        )->a( n = `level`    v = `H1`
                        )->a( n = `text`     v = `Product Name`
                        )->a( n = `wrapping` v = `false`
                        )->a( n = `id`       v = `productName`

                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `priority` v = `Disappear`

                        )->end(
                    )->end(
                    )->ele( `Text`
                        )->a( n = `text`     v = `Second Тitle`
                        )->a( n = `wrapping` v = `false`
                        )->a( n = `id`       v = `secondTitle`

                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `priority` v = `Disappear`

                        )->end(
                    )->end(

                    )->tag( `ToolbarSpacer`

                    )->ele( `SearchField`
                        )->a( n = `width` v = `25rem`
                        )->a( n = `id`    v = `searchField`

                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `priority` v = `Low`
                                )->a( n = `group`    v = `1`

                        )->end(
                    )->end(

                    )->tag( `Button`
                        )->a( n = `visible` v = `false`
                        )->a( n = `icon`    v = `sap-icon://search`
                        )->a( n = `type`    v = `Transparent`
                        )->a( n = `id`      v = `searchButton`
                        )->a( n = `tooltip` v = `Search`

                    )->ele( `OverflowToolbarButton`
                        )->a( n = `icon`    v = `sap-icon://source-code`
                        )->a( n = `type`    v = `Transparent`
                        )->a( n = `tooltip` v = `Action 1`
                        )->a( n = `text`    v = `Action 1`

                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `group` v = `2`

                        )->end(
                    )->end(
                    )->ele( `OverflowToolbarButton`
                        )->a( n = `icon`    v = `sap-icon://card`
                        )->a( n = `type`    v = `Transparent`
                        )->a( n = `tooltip` v = `Action 2`
                        )->a( n = `text`    v = `Action 2`

                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `group` v = `2`

                        )->end(
                    )->end(
                    )->ele( `ToolbarSeparator`
                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `group` v = `2`

                        )->end(
                    )->end(

                    )->tag( `OverflowToolbarButton`
                        )->a( n = `icon` v = `sap-icon://action-settings`
                        )->a( n = `type` v = `Transparent`
                        )->a( n = `text` v = `Settings`

                    )->ele( `Button`
                        )->a( n = `icon`    v = `sap-icon://bell`
                        )->a( n = `type`    v = `Transparent`
                        )->a( n = `tooltip` v = `Notification`

                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `priority` v = `NeverOverflow`

                        )->end(
                    )->end(

                    )->tag( n = `ToolHeaderUtilitySeparator` ns = `tnt`

                    )->tag( `ToolbarSpacer`
                        )->a( n = `width` v = `1.125rem`

                    )->ele( `Avatar`
                        )->a( n = `src`         v = `https://sdk.openui5.org/test-resources/sap/tnt/images/Woman_avatar_01.png`
                        )->a( n = `displaySize` v = `XS`
                        )->a( n = `tooltip`     v = `Profile`

                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `priority` v = `NeverOverflow`

                        )->end(
                    )->end(
                )->end(
            )->end(

            )->ele( n = `subHeader` ns = `tnt`
                )->ele( n = `ToolHeader` ns = `tnt`
                    )->a( n = `visible` v = `{=! ${device>/system/phone}}`

                    )->ele( `IconTabHeader`
                        )->a( n = `selectedKey` v = client->_bind( selectedkey )
                        )->a( n = `items`       v = |\{path: '{ client->_bind_path( navigation ) }'\}|
                        )->a( n = `select`      v = client->_event( val = `ITEM_SELECT` arg = `${$parameters>/item}.getKey()` )
                        )->a( n = `mode`        v = `Inline`

                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `priority`   v = `NeverOverflow`
                                )->a( n = `shrinkable` v = `true`

                        )->end(
                        )->ele( `items`
                            )->ele( `IconTabFilter`
                                )->a( n = `items`           v = `{ITEMS}`
                                )->a( n = `icon`            v = `{ICON}`
                                )->a( n = `text`            v = `{TITLE}`
                                )->a( n = `key`             v = `{KEY}`
                                )->a( n = `interactionMode` v = `SelectLeavesOnly`

                                )->ele( `items`
                                    )->tag( `IconTabFilter`
                                        )->a( n = `text`    v = `{TITLE}`
                                        )->a( n = `key`     v = `{KEY}`
                                        )->a( n = `enabled` v = `{ENABLED}`

                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(
            )->end(

            )->ele( n = `sideContent` ns = `tnt`
                )->ele( n = `SideNavigation` ns = `tnt`
                    )->a( n = `visible`     v = `{= ${device>/system/phone}}`
                    )->a( n = `expanded`    v = `true`
                    )->a( n = `selectedKey` v = client->_bind( selectedkey )
                    )->a( n = `itemSelect`  v = client->_event( val = `ITEM_SELECT` arg = `${$parameters>/item}.getKey()` )

                    )->ele( n = `NavigationList` ns = `tnt`
                        )->a( n = `items` v = |\{path: '{ client->_bind_path( navigation ) }'\}|

                        )->ele( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text`     v = `{TITLE}`
                            )->a( n = `icon`     v = `{ICON}`
                            )->a( n = `enabled`  v = `{ENABLED}`
                            )->a( n = `expanded` v = `{EXPANDED}`
                            )->a( n = `items`    v = `{ITEMS}`
                            )->a( n = `key`      v = `{KEY}`

                            )->tag( n = `NavigationListItem` ns = `tnt`
                                )->a( n = `text`    v = `{TITLE}`
                                )->a( n = `key`     v = `{KEY}`
                                )->a( n = `enabled` v = `{ENABLED}`

                        )->end(
                    )->end(
                )->end(
            )->end(

            )->ele( n = `mainContents` ns = `tnt`
                )->ele( `NavContainer`
                    )->a( n = `id`          v = `pageContainer`
                    )->a( n = `initialPage` v = `page1`

                    )->ele( `pages`
                        )->ele( `ScrollContainer`
                            )->a( n = `id`         v = `page1`
                            )->a( n = `horizontal` v = `false`
                            )->a( n = `vertical`   v = `true`
                            )->a( n = `height`     v = `100%`
                            )->a( n = `class`      v = `sapUiContentPadding`

                            )->tag( `Text`
                                )->a( n = `text` v = `Home`

                        )->end(
                        )->ele( `ScrollContainer`
                            )->a( n = `id`         v = `page2`
                            )->a( n = `horizontal` v = `false`
                            )->a( n = `vertical`   v = `true`
                            )->a( n = `height`     v = `100%`
                            )->a( n = `class`      v = `sapUiContentPadding`

                            )->tag( `Text`
                                )->a( n = `text` v = `Applications`

                        )->end(
                        )->ele( `ScrollContainer`
                            )->a( n = `id`         v = `page3`
                            )->a( n = `horizontal` v = `false`
                            )->a( n = `vertical`   v = `true`
                            )->a( n = `height`     v = `100%`
                            )->a( n = `class`      v = `sapUiContentPadding`

                            )->tag( `Text`
                                )->a( n = `text` v = `Users and Groups`

                        )->end(
                        )->ele( `ScrollContainer`
                            )->a( n = `id`         v = `page4`
                            )->a( n = `horizontal` v = `false`
                            )->a( n = `vertical`   v = `true`
                            )->a( n = `height`     v = `100%`
                            )->a( n = `class`      v = `sapUiContentPadding`

                            )->tag( `Text`
                                )->a( n = `text` v = `Identity`

                        )->end(
                        )->ele( `ScrollContainer`
                            )->a( n = `id`         v = `page5`
                            )->a( n = `horizontal` v = `false`
                            )->a( n = `vertical`   v = `true`
                            )->a( n = `height`     v = `100%`
                            )->a( n = `class`      v = `sapUiContentPadding`

                            )->tag( `Text`
                                )->a( n = `text` v = `Provisioning`

                        )->end(
                        )->ele( `ScrollContainer`
                            )->a( n = `id`         v = `page6`
                            )->a( n = `horizontal` v = `false`
                            )->a( n = `vertical`   v = `true`
                            )->a( n = `height`     v = `100%`
                            )->a( n = `class`      v = `sapUiContentPadding`

                            )->tag( `Text`
                                )->a( n = `text` v = `Monitoring`

                        )->end(
                        )->ele( `ScrollContainer`
                            )->a( n = `id`         v = `page7`
                            )->a( n = `horizontal` v = `false`
                            )->a( n = `vertical`   v = `true`
                            )->a( n = `height`     v = `100%`
                            )->a( n = `class`      v = `sapUiContentPadding`

                            )->tag( `Text`
                                )->a( n = `text` v = `Resources` ).

    client->view_display( view->stringify( ) ).

    " The NavContainer's position is live control state: view_display( )
    " destroys the MAIN slot and XMLView.create builds a fresh tree, so
    " pageContainer comes back on its initialPage="page1" - while selectedkey is
    " two-way bound class state that survives (both the IconTabHeader and the
    " phone SideNavigation bind it), and the navigation then reads a page the
    " main area is not showing. Re-issuing the SAME key the
    " ITEM_SELECT branch last sent is the app-000 idiom. Guarded twice: an
    " untouched key and the key the initialPage already shows both need no
    " action at all
    IF selectedkey IS NOT INITIAL AND selectedkey <> `page1`.
      
      CLEAR temp1.
      INSERT `pageContainer` INTO TABLE temp1.
      INSERT `to` INTO TABLE temp1.
      INSERT selectedkey INTO TABLE temp1.
      client->follow_up_action( val   = client->cs_event-control_by_id
                                t_arg = temp1 ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.
        DATA temp3 TYPE string_table.
        DATA temp5 TYPE string.
        DATA temp1 TYPE xsdboolean.

    CASE client->get_event( ).

      WHEN `ITEM_SELECT`.
        " original onItemSelect: pageContainer.to( the selected item's key )
        
        CLEAR temp3.
        INSERT `pageContainer` INTO TABLE temp3.
        INSERT `to` INTO TABLE temp3.
        INSERT client->get_event_arg( ) INTO TABLE temp3.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = temp3 ).

      WHEN `SIDE_NAV_TOGGLE`.
        " original onSideNavButtonPress: sets the toggle button's tooltip from the
        " CURRENT sideExpanded state, then flips ToolPage.sideExpanded
        
        IF side_expanded = abap_true.
          temp5 = `Large Size Navigation`.
        ELSE.
          temp5 = `Small Size Navigation`.
        ENDIF.
        toggle_tooltip = temp5.
        
        temp1 = boolc( side_expanded = abap_false ).
        side_expanded  = temp1.

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.
    DATA temp6 TYPE string.
    DATA temp7 LIKE navigation.
    DATA temp8 LIKE LINE OF temp7.
    DATA temp1 TYPE z2ui5_cl_smpc_app_302=>ty_s_nav_item-items.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp3 TYPE z2ui5_cl_smpc_app_302=>ty_s_nav_item-items.
    DATA temp4 LIKE LINE OF temp3.
    DATA temp5 TYPE z2ui5_cl_smpc_app_302=>ty_s_nav_item-items.
    DATA temp9 LIKE LINE OF temp5.
    DATA temp10 TYPE z2ui5_cl_smpc_app_302=>ty_s_nav_item-items.
    DATA temp11 LIKE LINE OF temp10.

    " model/data.json of the sample, inlined 1:1. ENABLED/EXPANDED are not in the
    " mock - the rows carry the UI5 property default (true) explicitly so the
    " flat serialization cannot override it with an empty value
    selectedkey    = `page1`.
    side_expanded  = abap_true.
    " _setToggleButtonTooltip( !Device.system.desktop ) at init, read from the
    " device data the framework mirrors server-side
    
    IF client->get( )-s_device-system = z2ui5_if_client=>cs_device-system-desktop.
      temp6 = `Small Size Navigation`.
    ELSE.
      temp6 = `Large Size Navigation`.
    ENDIF.
    toggle_tooltip = temp6.

    
    CLEAR temp7.
    
    temp8-enabled = abap_true.
    temp8-expanded = abap_true.
    temp8-title = `Home`.
    temp8-icon = `sap-icon://home`.
    temp8-key = `page1`.
    INSERT temp8 INTO TABLE temp7.
    temp8-title = `Applications`.
    temp8-icon = `sap-icon://internet-browser`.
    temp8-key = `page2`.
    INSERT temp8 INTO TABLE temp7.
    temp8-title = `Users and Groups`.
    temp8-icon = `sap-icon://family-care`.
    temp8-key = `page3`.
    
    CLEAR temp1.
    
    temp2-enabled = abap_true.
    temp2-title = `User 1`.
    temp2-key = `page3`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `User 2`.
    temp2-key = `page3`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `User 3`.
    temp2-key = `page3`.
    INSERT temp2 INTO TABLE temp1.
    temp8-items = temp1.
    INSERT temp8 INTO TABLE temp7.
    temp8-title = `Identity`.
    temp8-icon = `sap-icon://business-card`.
    temp8-key = `page4`.
    
    CLEAR temp3.
    
    temp4-enabled = abap_true.
    temp4-title = `Identity 1`.
    temp4-key = `page4`.
    INSERT temp4 INTO TABLE temp3.
    temp4-title = `Identity 2`.
    temp4-key = `page4`.
    INSERT temp4 INTO TABLE temp3.
    temp4-title = `Identity 3`.
    temp4-key = `page4`.
    INSERT temp4 INTO TABLE temp3.
    temp8-items = temp3.
    INSERT temp8 INTO TABLE temp7.
    temp8-title = `Provisioning`.
    temp8-icon = `sap-icon://generate-shortcut`.
    temp8-key = `page5`.
    INSERT temp8 INTO TABLE temp7.
    temp8-title = `Monitoring`.
    temp8-icon = `sap-icon://unwired`.
    temp8-key = `page6`.
    
    CLEAR temp5.
    
    temp9-enabled = abap_true.
    temp9-title = `Monitoring 1`.
    temp9-key = `page6`.
    INSERT temp9 INTO TABLE temp5.
    temp9-title = `Monitoring 2`.
    temp9-key = `page6`.
    INSERT temp9 INTO TABLE temp5.
    temp8-items = temp5.
    INSERT temp8 INTO TABLE temp7.
    temp8-title = `Resources`.
    temp8-icon = `sap-icon://document-text`.
    temp8-key = `page7`.
    
    CLEAR temp10.
    
    temp11-enabled = abap_true.
    temp11-title = `Resource 1`.
    temp11-key = `page7`.
    INSERT temp11 INTO TABLE temp10.
    temp11-title = `Resource 2`.
    temp11-key = `page7`.
    INSERT temp11 INTO TABLE temp10.
    temp11-title = `Resource 3`.
    temp11-key = `page7`.
    INSERT temp11 INTO TABLE temp10.
    temp8-items = temp10.
    INSERT temp8 INTO TABLE temp7.
    navigation = temp7.

  ENDMETHOD.

ENDCLASS.
