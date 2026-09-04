" @keywords toolpage tool sap.tnt toolheader button overflowtoolbarlayoutdata toolbarspacer toolheaderutilityseparator sidenavigation navigationlist navigationlistitem navcontainer
" @summary A tool page layout with vertical navigation
CLASS z2ui5_cl_smpc_app_167 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_child,
        title   TYPE string,
        key     TYPE string,
        enabled TYPE abap_bool,
      END OF ty_child.
    TYPES ty_child_tt TYPE STANDARD TABLE OF ty_child WITH DEFAULT KEY.
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
    DATA navigation     TYPE STANDARD TABLE OF ty_nav WITH DEFAULT KEY.
    DATA sideexpanded   TYPE abap_bool.
    DATA toggle_tooltip TYPE string.
    DATA fixednavigation TYPE STANDARD TABLE OF ty_fixed WITH DEFAULT KEY.

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
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `MESSAGE_TOAST` INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    INSERT `Fired itemPress, item: {0}` INTO TABLE temp1.
    INSERT `${$parameters>/item}.getText()` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `pageContainer` INTO TABLE temp2.
    INSERT `to` INTO TABLE temp2.
    INSERT `${$parameters>/item}.getKey()` INTO TABLE temp2.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:tnt` v = `sap.tnt`
        )->a( n = `height`    v = `100%`

        )->ele( n = `ToolPage` ns = `tnt`
            )->a( n = `id`           v = `toolPage`
            " added attr (declared): carries onSideNavButtonPress' setSideExpanded
            )->a( n = `sideExpanded` v = client->_bind( sideexpanded )

            )->ele( n = `header` ns = `tnt`
                )->ele( n = `ToolHeader` ns = `tnt`
                    )->ele( `Button`
                        )->a( n = `id`      v = `sideNavigationToggleButton`
                        )->a( n = `icon`    v = `sap-icon://menu2`
                        )->a( n = `type`    v = `Transparent`
                        " added attr (declared): the original sets the tooltip imperatively
                        )->a( n = `tooltip` v = client->_bind( toggle_tooltip )
                        )->a( n = `press`   v = client->_event( `SIDE_TOGGLE` )
                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `priority` v = `NeverOverflow`

                        )->end(
                    )->end(
                    )->tag( `ToolbarSpacer`
                        )->a( n = `width` v = `20px`
                    )->ele( `Button`
                        )->a( n = `text` v = `File`
                        )->a( n = `type` v = `Transparent`
                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `priority` v = `Low`

                        )->end(
                    )->end(
                    )->ele( `Button`
                        )->a( n = `text` v = `Edit`
                        )->a( n = `type` v = `Transparent`
                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `priority` v = `Low`

                        )->end(
                    )->end(
                    )->ele( `Button`
                        )->a( n = `text` v = `View`
                        )->a( n = `type` v = `Transparent`
                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `priority` v = `Low`

                        )->end(
                    )->end(
                    )->ele( `Button`
                        )->a( n = `text` v = `Navigate`
                        )->a( n = `type` v = `Transparent`
                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `priority` v = `Low`

                        )->end(
                    )->end(
                    )->ele( `Button`
                        )->a( n = `text` v = `Code`
                        )->a( n = `type` v = `Transparent`
                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `priority` v = `Low`

                        )->end(
                    )->end(
                    )->ele( `Button`
                        )->a( n = `text` v = `Refactor`
                        )->a( n = `type` v = `Transparent`
                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `priority` v = `Low`

                        )->end(
                    )->end(
                    )->ele( `Button`
                        )->a( n = `text` v = `Run`
                        )->a( n = `type` v = `Transparent`
                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `priority` v = `Low`

                        )->end(
                    )->end(
                    )->ele( `Button`
                        )->a( n = `text` v = `Tools`
                        )->a( n = `type` v = `Transparent`
                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `priority` v = `Low`

                        )->end(
                    )->end(
                    )->tag( n = `ToolHeaderUtilitySeparator` ns = `tnt`
                    )->ele( `ToolbarSpacer`
                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `priority` v = `NeverOverflow`
                                )->a( n = `minWidth` v = `20px`

                        )->end(
                    )->end(
                    )->ele( `Button`
                        )->a( n = `text`         v = `Alan Smith`
                        )->a( n = `type`         v = `Transparent`
                        )->a( n = `press`        v = client->_event( val = `USER_POPOVER` arg = `$event.oSource.sId` )
                        )->a( n = `ariaHasPopup` v = `Menu`
                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `priority` v = `NeverOverflow`

                        )->end(
                    )->end(
                )->end(
            )->end(

            )->ele( n = `sideContent` ns = `tnt`
                )->ele( n = `SideNavigation` ns = `tnt`
                    )->a( n = `expanded`    v = `true`
                    )->a( n = `itemPress`   v = client->follow_up_action( val   = client->cs_event-control_global
                                                                          t_arg = temp1 )
                    )->a( n = `selectedKey` v = client->_bind( selectedkey )
                    " onItemSelect: pageContainer.to(createId(item.getKey())) - the key
                    " resolves client-side and the to() runs roundtrip-free
                    )->a( n = `itemSelect`  v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                          t_arg = temp2 )
                    )->ele( n = `NavigationList` ns = `tnt`
                        )->a( n = `items` v = client->_bind( navigation )
                        )->ele( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text`       v = `{TITLE}`
                            )->a( n = `icon`       v = `{ICON}`
                            )->a( n = `enabled`    v = `{ENABLED}`
                            )->a( n = `expanded`   v = `{EXPANDED}`
                            )->a( n = `items`      v = `{ITEMS}`
                            )->a( n = `selectable` v = `{SELECTABLE}`
                            )->a( n = `key`        v = `{KEY}`
                            )->tag( n = `NavigationListItem` ns = `tnt`
                                )->a( n = `text`    v = `{TITLE}`
                                )->a( n = `key`     v = `{KEY}`
                                )->a( n = `enabled` v = `{ENABLED}`

                        )->end(
                    )->end(
                    )->ele( n = `fixedItem` ns = `tnt`
                        )->ele( n = `NavigationList` ns = `tnt`
                            )->a( n = `items` v = client->_bind( fixednavigation )
                            )->tag( n = `NavigationListItem` ns = `tnt`
                                )->a( n = `text`         v = `{TITLE}`
                                )->a( n = `icon`         v = `{ICON}`
                                )->a( n = `ariaHasPopup` v = `{ARIAHASPOPUP}`
                                )->a( n = `design`       v = `{DESIGN}`
                                )->a( n = `press`        v = client->_event( val = `QUICK_ACTION` arg = `${$source>/design}` )
                                )->a( n = `selectable`   v = `{SELECTABLE}`

                        )->end(
                    )->end(
                )->end(
            )->end(

            )->ele( n = `mainContents` ns = `tnt`
                )->ele( `NavContainer`
                    )->a( n = `id`          v = `pageContainer`
                    )->a( n = `initialPage` v = `page2`
                    )->ele( `pages`
                        )->ele( `ScrollContainer`
                            )->a( n = `id`         v = `root1`
                            )->a( n = `horizontal` v = `false`
                            )->a( n = `vertical`   v = `true`
                            )->a( n = `height`     v = `100%`
                            )->a( n = `class`      v = `sapUiContentPadding`
                            )->tag( `Text`
                                )->a( n = `text` v = `This is the root page`

                        )->end(
                        )->ele( `ScrollContainer`
                            )->a( n = `id`         v = `page1`
                            )->a( n = `horizontal` v = `false`
                            )->a( n = `vertical`   v = `true`
                            )->a( n = `height`     v = `100%`
                            )->a( n = `class`      v = `sapUiContentPadding`
                            )->tag( `Text`
                                )->a( n = `text` v = `This is the first page`

                        )->end(
                        )->ele( `ScrollContainer`
                            )->a( n = `id`         v = `page2`
                            )->a( n = `horizontal` v = `false`
                            )->a( n = `vertical`   v = `true`
                            )->a( n = `height`     v = `100%`
                            )->a( n = `class`      v = `sapUiContentPadding`
                            )->tag( `Text`
                                )->a( n = `text` v = `Lorem ipsum dolor sit amet, consectetur adipisicing elit. (content abbreviated from the original filler text)`

                        )->end(
                        )->ele( `ScrollContainer`
                            )->a( n = `id`         v = `root2`
                            )->a( n = `horizontal` v = `false`
                            )->a( n = `vertical`   v = `true`
                            )->a( n = `height`     v = `100%`
                            )->a( n = `class`      v = `sapUiContentPadding`
                            )->tag( `Text`
                                )->a( n = `text` v = `This is the root page of the second element`

                        )->end(
                    )->end(
                )->end(
            )->end( ).

    client->view_display( view->stringify( ) ).

    " The NavContainer's position is live control state: view_display( )
    " destroys the MAIN slot and XMLView.create builds a fresh tree, so
    " pageContainer comes back on its initialPage="page2" - while selectedkey
    " is two-way bound class state that survives every round trip, and the
    " SideNavigation then highlights a page the main area is not showing.
    " itemSelect issues its to( ) roundtrip-free, so nothing else re-states it.
    " Re-issuing the SAME key is the app-000 idiom; guarded twice, because an
    " untouched key (Root Item 3 and its children carry no key at all) and the
    " key the initialPage already shows both need no action
    IF selectedkey IS NOT INITIAL AND selectedkey <> `page2`.
      
      CLEAR temp3.
      INSERT `pageContainer` INTO TABLE temp3.
      INSERT `to` INTO TABLE temp3.
      INSERT selectedkey INTO TABLE temp3.
      client->follow_up_action( val   = client->cs_event-control_by_id
                                t_arg = temp3 ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.
        DATA temp5 TYPE string.
        DATA temp1 TYPE xsdboolean.
        DATA popover TYPE REF TO z2ui5_cl_ui5_view_builder.
          DATA popup TYPE REF TO z2ui5_cl_ui5_view_builder.

    CASE client->get_event( ).

      WHEN `SIDE_TOGGLE`.
        " onSideNavButtonPress: tooltip from the PRE-toggle expanded state
        " (_setToggleButtonTooltip(bSideExpanded)), then setSideExpanded(!...)
        
        IF sideexpanded = abap_true.
          temp5 = `Large Size Navigation`.
        ELSE.
          temp5 = `Small Size Navigation`.
        ENDIF.
        toggle_tooltip = temp5.
        
        temp1 = boolc( sideexpanded = abap_false ).
        sideexpanded = temp1.

      WHEN `USER_POPOVER`.
        " handleUserNamePress: the controller-built Popover (no header, Bottom,
        " three transparent buttons), opened by the pressed user button
        
        popover = z2ui5_cl_ui5_view_builder=>factory( ).

        popover->ele( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns:core` v = `sap.ui.core`
            )->a( n = `xmlns`      v = `sap.m`

            )->ele( `Popover`
                )->a( n = `showHeader` v = `false`
                )->a( n = `placement`  v = `Bottom`
                )->a( n = `class`      v = `sapMOTAPopover sapTntToolHeaderPopover`

                )->ele( `content`
                    )->tag( `Button`
                        )->a( n = `text` v = `Feedback`
                        )->a( n = `type` v = `Transparent`
                    )->tag( `Button`
                        )->a( n = `text` v = `Help`
                        )->a( n = `type` v = `Transparent`
                    )->tag( `Button`
                        )->a( n = `text` v = `Logout`
                        )->a( n = `type` v = `Transparent` ).

        client->popover_display( xml   = popover->stringify( )
                                 by_id = client->get_event_arg( ) ).

      WHEN `QUICK_ACTION`.
        " onQuickActionPress: only a design=Action item opens the dialog
        IF client->get_event_arg( ) = `Action`.
          
          popup = z2ui5_cl_ui5_view_builder=>factory( ).

          popup->ele( n = `FragmentDefinition` ns = `core`
              )->a( n = `xmlns:core` v = `sap.ui.core`
              )->a( n = `xmlns`      v = `sap.m`

              )->ele( `Dialog`
                  )->a( n = `title` v = `Create Item`
                  )->a( n = `type`  v = `Message`

                  )->ele( `content`
                      )->tag( `Text`
                          )->a( n = `text` v = `Create New Navigation List Item`

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
        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.
    DATA temp6 LIKE navigation.
    DATA temp7 LIKE LINE OF temp6.
    DATA temp5 TYPE z2ui5_cl_smpc_app_167=>ty_child_tt.
    DATA temp10 LIKE LINE OF temp5.
    DATA temp11 TYPE z2ui5_cl_smpc_app_167=>ty_child_tt.
    DATA temp12 TYPE z2ui5_cl_smpc_app_167=>ty_child_tt.
    DATA temp13 LIKE LINE OF temp12.
    DATA temp14 TYPE z2ui5_cl_smpc_app_167=>ty_child_tt.
    DATA temp15 LIKE LINE OF temp14.
    DATA temp16 TYPE z2ui5_cl_smpc_app_167=>ty_child_tt.
    DATA temp17 LIKE LINE OF temp16.
    DATA temp18 TYPE z2ui5_cl_smpc_app_167=>ty_child_tt.
    DATA temp19 LIKE LINE OF temp18.
    DATA temp20 TYPE z2ui5_cl_smpc_app_167=>ty_child_tt.
    DATA temp21 LIKE LINE OF temp20.
    DATA temp22 TYPE z2ui5_cl_smpc_app_167=>ty_child_tt.
    DATA temp23 LIKE LINE OF temp22.
    DATA temp24 TYPE z2ui5_cl_smpc_app_167=>ty_child_tt.
    DATA temp25 LIKE LINE OF temp24.
    DATA temp26 TYPE z2ui5_cl_smpc_app_167=>ty_child_tt.
    DATA temp27 LIKE LINE OF temp26.
    DATA temp28 TYPE z2ui5_cl_smpc_app_167=>ty_child_tt.
    DATA temp29 LIKE LINE OF temp28.
    DATA temp30 TYPE z2ui5_cl_smpc_app_167=>ty_child_tt.
    DATA temp31 LIKE LINE OF temp30.
    DATA temp32 TYPE z2ui5_cl_smpc_app_167=>ty_child_tt.
    DATA temp33 LIKE LINE OF temp32.
    DATA temp34 TYPE z2ui5_cl_smpc_app_167=>ty_child_tt.
    DATA temp35 LIKE LINE OF temp34.
    DATA temp8 LIKE fixednavigation.
    DATA temp9 LIKE LINE OF temp8.

    " onInit: _setToggleButtonTooltip(!Device.system.desktop) - the desktop
    " default; the ToolPage starts with its side content expanded (UI5 default)
    sideexpanded   = abap_true.
    toggle_tooltip = `Small Size Navigation`.

    
    CLEAR temp6.
    
    temp7-title = `Root Item 1`.
    temp7-icon = `sap-icon://employee`.
    temp7-enabled = abap_true.
    temp7-expanded = abap_true.
    temp7-key = `root1`.
    temp7-selectable = abap_false.
    
    CLEAR temp5.
    
    temp10-title = `Child Item 1`.
    temp10-key = `page1`.
    temp10-enabled = abap_true.
    INSERT temp10 INTO TABLE temp5.
    temp10-title = `Child Item 2`.
    temp10-key = `page2`.
    temp10-enabled = abap_true.
    INSERT temp10 INTO TABLE temp5.
    temp7-items = temp5.
    INSERT temp7 INTO TABLE temp6.
    temp7-title = `Root Item 2`.
    temp7-icon = `sap-icon://building`.
    temp7-enabled = abap_true.
    temp7-expanded = abap_false.
    temp7-key = `root2`.
    temp7-selectable = abap_true.
    
    CLEAR temp11.
    temp7-items = temp11.
    INSERT temp7 INTO TABLE temp6.
    temp7-title = `Root Item 3`.
    temp7-icon = `sap-icon://card`.
    temp7-enabled = abap_true.
    temp7-expanded = abap_false.
    temp7-key = ``.
    temp7-selectable = abap_true.
    
    CLEAR temp12.
    
    temp13-title = `Child Item 1`.
    temp13-key = ``.
    temp13-enabled = abap_true.
    INSERT temp13 INTO TABLE temp12.
    temp13-title = `Child Item 2`.
    temp13-key = ``.
    temp13-enabled = abap_true.
    INSERT temp13 INTO TABLE temp12.
    temp13-title = `Child Item 3`.
    temp13-key = ``.
    temp13-enabled = abap_true.
    INSERT temp13 INTO TABLE temp12.
    temp13-title = `Child Item 4`.
    temp13-key = ``.
    temp13-enabled = abap_true.
    INSERT temp13 INTO TABLE temp12.
    temp13-title = `Child Item 5`.
    temp13-key = ``.
    temp13-enabled = abap_true.
    INSERT temp13 INTO TABLE temp12.
    temp13-title = `Child Item 6`.
    temp13-key = ``.
    temp13-enabled = abap_true.
    INSERT temp13 INTO TABLE temp12.
    temp13-title = `Child Item 7`.
    temp13-key = ``.
    temp13-enabled = abap_true.
    INSERT temp13 INTO TABLE temp12.
    temp13-title = `Child Item 8`.
    temp13-key = ``.
    temp13-enabled = abap_true.
    INSERT temp13 INTO TABLE temp12.
    temp13-title = `Child Item 9`.
    temp13-key = ``.
    temp13-enabled = abap_true.
    INSERT temp13 INTO TABLE temp12.
    temp13-title = `Child Item 10`.
    temp13-key = ``.
    temp13-enabled = abap_true.
    INSERT temp13 INTO TABLE temp12.
    temp13-title = `Child Item 11`.
    temp13-key = ``.
    temp13-enabled = abap_true.
    INSERT temp13 INTO TABLE temp12.
    temp13-title = `Child Item 12`.
    temp13-key = ``.
    temp13-enabled = abap_true.
    INSERT temp13 INTO TABLE temp12.
    temp13-title = `Child Item 13`.
    temp13-key = ``.
    temp13-enabled = abap_true.
    INSERT temp13 INTO TABLE temp12.
    temp13-title = `Child Item 14`.
    temp13-key = ``.
    temp13-enabled = abap_true.
    INSERT temp13 INTO TABLE temp12.
    temp13-title = `Child Item 15`.
    temp13-key = ``.
    temp13-enabled = abap_true.
    INSERT temp13 INTO TABLE temp12.
    temp13-title = `Child Item 16`.
    temp13-key = ``.
    temp13-enabled = abap_true.
    INSERT temp13 INTO TABLE temp12.
    temp13-title = `Child Item 17`.
    temp13-key = ``.
    temp13-enabled = abap_true.
    INSERT temp13 INTO TABLE temp12.
    temp13-title = `Child Item 18`.
    temp13-key = ``.
    temp13-enabled = abap_true.
    INSERT temp13 INTO TABLE temp12.
    temp13-title = `Child Item 19`.
    temp13-key = ``.
    temp13-enabled = abap_true.
    INSERT temp13 INTO TABLE temp12.
    temp13-title = `Child Item 20`.
    temp13-key = ``.
    temp13-enabled = abap_true.
    INSERT temp13 INTO TABLE temp12.
    temp13-title = `Child Item 21`.
    temp13-key = ``.
    temp13-enabled = abap_true.
    INSERT temp13 INTO TABLE temp12.
    temp13-title = `Child Item 22`.
    temp13-key = ``.
    temp13-enabled = abap_true.
    INSERT temp13 INTO TABLE temp12.
    temp13-title = `Child Item 23`.
    temp13-key = ``.
    temp13-enabled = abap_true.
    INSERT temp13 INTO TABLE temp12.
    temp13-title = `Child Item 24`.
    temp13-key = ``.
    temp13-enabled = abap_true.
    INSERT temp13 INTO TABLE temp12.
    temp13-title = `Child Item 25`.
    temp13-key = ``.
    temp13-enabled = abap_true.
    INSERT temp13 INTO TABLE temp12.
    temp13-title = `Child Item 26`.
    temp13-key = ``.
    temp13-enabled = abap_true.
    INSERT temp13 INTO TABLE temp12.
    temp13-title = `Child Item 27`.
    temp13-key = ``.
    temp13-enabled = abap_true.
    INSERT temp13 INTO TABLE temp12.
    temp13-title = `Child Item 28`.
    temp13-key = ``.
    temp13-enabled = abap_true.
    INSERT temp13 INTO TABLE temp12.
    temp13-title = `Child Item 29`.
    temp13-key = ``.
    temp13-enabled = abap_true.
    INSERT temp13 INTO TABLE temp12.
    temp13-title = `Child Item 30`.
    temp13-key = ``.
    temp13-enabled = abap_true.
    INSERT temp13 INTO TABLE temp12.
    temp13-title = `Child Item 31`.
    temp13-key = ``.
    temp13-enabled = abap_true.
    INSERT temp13 INTO TABLE temp12.
    temp13-title = `Child Item 32`.
    temp13-key = ``.
    temp13-enabled = abap_true.
    INSERT temp13 INTO TABLE temp12.
    temp13-title = `Child Item 33`.
    temp13-key = ``.
    temp13-enabled = abap_true.
    INSERT temp13 INTO TABLE temp12.
    temp13-title = `Child Item 34`.
    temp13-key = ``.
    temp13-enabled = abap_true.
    INSERT temp13 INTO TABLE temp12.
    temp13-title = `Child Item 35`.
    temp13-key = ``.
    temp13-enabled = abap_true.
    INSERT temp13 INTO TABLE temp12.
    temp13-title = `Child Item 36`.
    temp13-key = ``.
    temp13-enabled = abap_true.
    INSERT temp13 INTO TABLE temp12.
    temp13-title = `Child Item 37`.
    temp13-key = ``.
    temp13-enabled = abap_true.
    INSERT temp13 INTO TABLE temp12.
    temp13-title = `Child Item 38`.
    temp13-key = ``.
    temp13-enabled = abap_true.
    INSERT temp13 INTO TABLE temp12.
    temp7-items = temp12.
    INSERT temp7 INTO TABLE temp6.
    temp7-title = `Root Item 4`.
    temp7-icon = `sap-icon://action`.
    temp7-enabled = abap_true.
    temp7-expanded = abap_false.
    temp7-key = ``.
    temp7-selectable = abap_false.
    
    CLEAR temp14.
    
    temp15-title = `Child Item 1`.
    temp15-key = ``.
    temp15-enabled = abap_true.
    INSERT temp15 INTO TABLE temp14.
    temp15-title = `Child Item 2`.
    temp15-key = ``.
    temp15-enabled = abap_true.
    INSERT temp15 INTO TABLE temp14.
    temp15-title = `Child Item 3`.
    temp15-key = ``.
    temp15-enabled = abap_true.
    INSERT temp15 INTO TABLE temp14.
    temp7-items = temp14.
    INSERT temp7 INTO TABLE temp6.
    temp7-title = `Root Item 5`.
    temp7-icon = `sap-icon://action-settings`.
    temp7-enabled = abap_true.
    temp7-expanded = abap_false.
    temp7-key = ``.
    temp7-selectable = abap_false.
    
    CLEAR temp16.
    
    temp17-title = `Child Item 1`.
    temp17-key = ``.
    temp17-enabled = abap_true.
    INSERT temp17 INTO TABLE temp16.
    temp17-title = `Child Item 2`.
    temp17-key = ``.
    temp17-enabled = abap_true.
    INSERT temp17 INTO TABLE temp16.
    temp17-title = `Child Item 3`.
    temp17-key = ``.
    temp17-enabled = abap_true.
    INSERT temp17 INTO TABLE temp16.
    temp7-items = temp16.
    INSERT temp7 INTO TABLE temp6.
    temp7-title = `Root Item 6`.
    temp7-icon = `sap-icon://activate`.
    temp7-enabled = abap_true.
    temp7-expanded = abap_false.
    temp7-key = ``.
    temp7-selectable = abap_false.
    
    CLEAR temp18.
    
    temp19-title = `Child Item 1`.
    temp19-key = ``.
    temp19-enabled = abap_true.
    INSERT temp19 INTO TABLE temp18.
    temp19-title = `Child Item 2`.
    temp19-key = ``.
    temp19-enabled = abap_true.
    INSERT temp19 INTO TABLE temp18.
    temp19-title = `Child Item 3`.
    temp19-key = ``.
    temp19-enabled = abap_true.
    INSERT temp19 INTO TABLE temp18.
    temp7-items = temp18.
    INSERT temp7 INTO TABLE temp6.
    temp7-title = `Root Item 7`.
    temp7-icon = `sap-icon://activities`.
    temp7-enabled = abap_true.
    temp7-expanded = abap_false.
    temp7-key = ``.
    temp7-selectable = abap_false.
    
    CLEAR temp20.
    
    temp21-title = `Child Item 1`.
    temp21-key = ``.
    temp21-enabled = abap_true.
    INSERT temp21 INTO TABLE temp20.
    temp21-title = `Child Item 2`.
    temp21-key = ``.
    temp21-enabled = abap_true.
    INSERT temp21 INTO TABLE temp20.
    temp21-title = `Child Item 3`.
    temp21-key = ``.
    temp21-enabled = abap_true.
    INSERT temp21 INTO TABLE temp20.
    temp7-items = temp20.
    INSERT temp7 INTO TABLE temp6.
    temp7-title = `Root Item 8`.
    temp7-icon = `sap-icon://add`.
    temp7-enabled = abap_true.
    temp7-expanded = abap_false.
    temp7-key = ``.
    temp7-selectable = abap_false.
    
    CLEAR temp22.
    
    temp23-title = `Child Item 1`.
    temp23-key = ``.
    temp23-enabled = abap_true.
    INSERT temp23 INTO TABLE temp22.
    temp23-title = `Child Item 2`.
    temp23-key = ``.
    temp23-enabled = abap_true.
    INSERT temp23 INTO TABLE temp22.
    temp23-title = `Child Item 3`.
    temp23-key = ``.
    temp23-enabled = abap_true.
    INSERT temp23 INTO TABLE temp22.
    temp7-items = temp22.
    INSERT temp7 INTO TABLE temp6.
    temp7-title = `Root Item 9`.
    temp7-icon = `sap-icon://arobase`.
    temp7-enabled = abap_true.
    temp7-expanded = abap_false.
    temp7-key = ``.
    temp7-selectable = abap_false.
    
    CLEAR temp24.
    
    temp25-title = `Child Item 1`.
    temp25-key = ``.
    temp25-enabled = abap_true.
    INSERT temp25 INTO TABLE temp24.
    temp25-title = `Child Item 2`.
    temp25-key = ``.
    temp25-enabled = abap_true.
    INSERT temp25 INTO TABLE temp24.
    temp25-title = `Child Item 3`.
    temp25-key = ``.
    temp25-enabled = abap_true.
    INSERT temp25 INTO TABLE temp24.
    temp7-items = temp24.
    INSERT temp7 INTO TABLE temp6.
    temp7-title = `Root Item 10`.
    temp7-icon = `sap-icon://attachment`.
    temp7-enabled = abap_true.
    temp7-expanded = abap_false.
    temp7-key = ``.
    temp7-selectable = abap_false.
    
    CLEAR temp26.
    
    temp27-title = `Child Item 1`.
    temp27-key = ``.
    temp27-enabled = abap_true.
    INSERT temp27 INTO TABLE temp26.
    temp27-title = `Child Item 2`.
    temp27-key = ``.
    temp27-enabled = abap_true.
    INSERT temp27 INTO TABLE temp26.
    temp27-title = `Child Item 3`.
    temp27-key = ``.
    temp27-enabled = abap_true.
    INSERT temp27 INTO TABLE temp26.
    temp7-items = temp26.
    INSERT temp7 INTO TABLE temp6.
    temp7-title = `Root Item 11`.
    temp7-icon = `sap-icon://badge`.
    temp7-enabled = abap_true.
    temp7-expanded = abap_false.
    temp7-key = ``.
    temp7-selectable = abap_false.
    
    CLEAR temp28.
    
    temp29-title = `Child Item 1`.
    temp29-key = ``.
    temp29-enabled = abap_true.
    INSERT temp29 INTO TABLE temp28.
    temp29-title = `Child Item 2`.
    temp29-key = ``.
    temp29-enabled = abap_true.
    INSERT temp29 INTO TABLE temp28.
    temp29-title = `Child Item 3`.
    temp29-key = ``.
    temp29-enabled = abap_true.
    INSERT temp29 INTO TABLE temp28.
    temp7-items = temp28.
    INSERT temp7 INTO TABLE temp6.
    temp7-title = `Root Item 12`.
    temp7-icon = `sap-icon://basket`.
    temp7-enabled = abap_true.
    temp7-expanded = abap_false.
    temp7-key = ``.
    temp7-selectable = abap_false.
    
    CLEAR temp30.
    
    temp31-title = `Child Item 1`.
    temp31-key = ``.
    temp31-enabled = abap_true.
    INSERT temp31 INTO TABLE temp30.
    temp31-title = `Child Item 2`.
    temp31-key = ``.
    temp31-enabled = abap_true.
    INSERT temp31 INTO TABLE temp30.
    temp31-title = `Child Item 3`.
    temp31-key = ``.
    temp31-enabled = abap_true.
    INSERT temp31 INTO TABLE temp30.
    temp7-items = temp30.
    INSERT temp7 INTO TABLE temp6.
    temp7-title = `Root Item 13`.
    temp7-icon = `sap-icon://bed`.
    temp7-enabled = abap_true.
    temp7-expanded = abap_false.
    temp7-key = ``.
    temp7-selectable = abap_false.
    
    CLEAR temp32.
    
    temp33-title = `Child Item 1`.
    temp33-key = ``.
    temp33-enabled = abap_true.
    INSERT temp33 INTO TABLE temp32.
    temp33-title = `Child Item 2`.
    temp33-key = ``.
    temp33-enabled = abap_true.
    INSERT temp33 INTO TABLE temp32.
    temp33-title = `Child Item 3`.
    temp33-key = ``.
    temp33-enabled = abap_true.
    INSERT temp33 INTO TABLE temp32.
    temp7-items = temp32.
    INSERT temp7 INTO TABLE temp6.
    temp7-title = `Root Item 14`.
    temp7-icon = `sap-icon://bookmark`.
    temp7-enabled = abap_true.
    temp7-expanded = abap_false.
    temp7-key = ``.
    temp7-selectable = abap_false.
    
    CLEAR temp34.
    
    temp35-title = `Child Item 1`.
    temp35-key = ``.
    temp35-enabled = abap_true.
    INSERT temp35 INTO TABLE temp34.
    temp35-title = `Child Item 2`.
    temp35-key = ``.
    temp35-enabled = abap_true.
    INSERT temp35 INTO TABLE temp34.
    temp35-title = `Child Item 3`.
    temp35-key = ``.
    temp35-enabled = abap_true.
    INSERT temp35 INTO TABLE temp34.
    temp7-items = temp34.
    INSERT temp7 INTO TABLE temp6.
    navigation = temp6.

    " data.json omits ariaHasPopup, design AND selectable on Fixed Item 1-3;
    " each is seeded with the control's own default - selectable is TRUE
    " (NavigationListItem.selectable defaultValue: true), corrected 2026-08-21
    " after the review sweep found all three seeded false, which silently took
    " their selection behaviour away. The UI5 enum
    " defaults (None, Default) are seeded explicitly because an empty string
    " would be rejected by the enum validation (AGENTS section 5)
    
    CLEAR temp8.
    
    temp9-title = `Quick Create`.
    temp9-icon = `sap-icon://write-new`.
    temp9-ariahaspopup = `Dialog`.
    temp9-design = `Action`.
    temp9-selectable = abap_false.
    INSERT temp9 INTO TABLE temp8.
    temp9-title = `Fixed Item 1`.
    temp9-icon = `sap-icon://employee`.
    temp9-ariahaspopup = `None`.
    temp9-design = `Default`.
    temp9-selectable = abap_true.
    INSERT temp9 INTO TABLE temp8.
    temp9-title = `Fixed Item 2`.
    temp9-icon = `sap-icon://building`.
    temp9-ariahaspopup = `None`.
    temp9-design = `Default`.
    temp9-selectable = abap_true.
    INSERT temp9 INTO TABLE temp8.
    temp9-title = `Fixed Item 3`.
    temp9-icon = `sap-icon://card`.
    temp9-ariahaspopup = `None`.
    temp9-design = `Default`.
    temp9-selectable = abap_true.
    INSERT temp9 INTO TABLE temp8.
    fixednavigation = temp8.

  ENDMETHOD.

ENDCLASS.
