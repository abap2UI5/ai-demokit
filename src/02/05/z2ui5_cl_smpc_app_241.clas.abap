" @keywords sidenavigation side navigation sap.tnt sidenavigationpressevent vbox hbox button checkbox navigationlist navigationlistitem dialog
" @summary SideNavigation with press event parameters and preventDefault.
CLASS z2ui5_cl_smpc_app_241 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA expanded        TYPE abap_bool.
    DATA prevent_default TYPE abap_bool.
    DATA create_name     TYPE string.
    DATA create_icon     TYPE string.

    TYPES: BEGIN OF ty_s_child,
             text TYPE string,
           END OF ty_s_child.
    TYPES: BEGIN OF ty_s_nav_item,
             text       TYPE string,
             icon       TYPE string,
             href       TYPE string,
             target     TYPE string,
             selectable TYPE abap_bool,
             expanded   TYPE abap_bool,
             items      TYPE STANDARD TABLE OF ty_s_child WITH DEFAULT KEY,
           END OF ty_s_nav_item.
    DATA t_nav_items TYPE STANDARD TABLE OF ty_s_nav_item WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.
    METHODS on_event.
    METHODS popup_quickcreate_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_241 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      expanded = abap_false.
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
    DATA temp3 TYPE z2ui5_if_client=>ty_s_event_control.
    DATA temp4 TYPE string_table.
    DATA temp5 TYPE z2ui5_if_client=>ty_s_event_control.
    DATA temp6 TYPE string_table.
    DATA temp7 TYPE z2ui5_if_client=>ty_s_event_control.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `ICON` INTO TABLE temp1.
    INSERT `HREF` INTO TABLE temp1.
    INSERT `TARGET` INTO TABLE temp1.
    INSERT `EXPANDED` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `${$parameters>/item}.getText()` INTO TABLE temp2.
    INSERT `${$parameters>/ctrlKey}` INTO TABLE temp2.
    INSERT `${$parameters>/shiftKey}` INTO TABLE temp2.
    INSERT `${$parameters>/altKey}` INTO TABLE temp2.
    INSERT `${$parameters>/metaKey}` INTO TABLE temp2.
    
    CLEAR temp3.
    temp3-check_prevent_default = prevent_default.
    
    CLEAR temp4.
    INSERT `${$parameters>/item}.getText()` INTO TABLE temp4.
    INSERT `${$parameters>/ctrlKey}` INTO TABLE temp4.
    INSERT `${$parameters>/shiftKey}` INTO TABLE temp4.
    INSERT `${$parameters>/altKey}` INTO TABLE temp4.
    INSERT `${$parameters>/metaKey}` INTO TABLE temp4.
    
    CLEAR temp5.
    temp5-check_prevent_default = prevent_default.
    
    CLEAR temp6.
    INSERT `${$parameters>/item}.getText()` INTO TABLE temp6.
    INSERT `${$parameters>/ctrlKey}` INTO TABLE temp6.
    INSERT `${$parameters>/shiftKey}` INTO TABLE temp6.
    INSERT `${$parameters>/altKey}` INTO TABLE temp6.
    INSERT `${$parameters>/metaKey}` INTO TABLE temp6.
    
    CLEAR temp7.
    temp7-check_prevent_default = prevent_default.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:tnt` v = `sap.tnt`
        )->a( n = `height`    v = `100%`

        )->ele( `VBox`
            )->a( n = `renderType` v = `Bare`
            )->a( n = `alignItems` v = `Start`
            )->a( n = `height`     v = `100%`

            )->ele( `HBox`
                )->a( n = `renderType` v = `Bare`

                )->tag( `Button`
                    )->a( n = `text`  v = `Toggle Collapse/Expand`
                    )->a( n = `icon`  v = `sap-icon://menu2`
                    )->a( n = `press` v = client->_event( `TOGGLE_EXPAND` )
                )->tag( `CheckBox`
                    )->a( n = `id`       v = `preventDefaultCheckbox`
                    )->a( n = `text`     v = `Press event - PreventDefault`
                    )->a( n = `selected` v = client->_bind( prevent_default )
                    " added wire (declared): the redraw bakes check_prevent_default
                    " into every press handler to match the fresh checkbox state
                    )->a( n = `select`   v = client->_event( `PREVENT_TOGGLE` )

            )->end(

            )->ele( n = `SideNavigation` ns = `tnt`
                )->a( n = `id`          v = `sideNavigation`
                )->a( n = `selectedKey` v = `walked`
                )->a( n = `expanded`    v = client->_bind( expanded )

                " the Create button of the quick-create dialog does
                " sideNavigation.getItem().addItem( new NavigationListItem( ... ) ), so
                " the list is bound (the app-085/203 pattern) instead of statically
                " declared: creating appends a row. The rows are bound with
                " omit_initial_paths so an item that sets no icon/href keeps the
                " control's own default - SELECTABLE stays outside that list because
                " an explicit false must reach the two external links. EXPANDED is
                " omitted for the opposite reason: the original declares it on NO
                " NavigationListItem, so UI5's own default (true) has to apply and
                " 'Mileage' must open showing Driven/Walked. Sending the unset
                " abap_false collapsed it. The Create dialog's explicit abap_true
                " still travels - omit_initial_paths only drops INITIAL values.
                )->ele( n = `NavigationList` ns = `tnt`
                    )->a( n = `items` v = client->_bind(
                                              val                = t_nav_items
                                              omit_initial_paths = temp1 )

                    )->ele( n = `NavigationListItem` ns = `tnt`
                        )->a( n = `text`       v = `{TEXT}`
                        )->a( n = `icon`       v = `{ICON}`
                        )->a( n = `href`       v = `{HREF}`
                        )->a( n = `target`     v = `{TARGET}`
                        )->a( n = `selectable` v = `{SELECTABLE}`
                        )->a( n = `expanded`   v = `{EXPANDED}`
                        " the NESTED aggregation needs its own binding on the row
                        " template (app 167's shape). Without it the inner element is
                        " a STATIC child cloned with every row - Mileage's two children
                        " never render, and every row grows one spurious child bearing
                        " the row's own text
                        )->a( n = `items`      v = `{ITEMS}`
                        )->a( n = `press`      v = client->_event( val    = `ITEM_PRESS`
                                                              t_arg  = temp2
                                                              s_ctrl = temp3 )

                        )->ele( n = `items` ns = `tnt`
                            )->tag( n = `NavigationListItem` ns = `tnt`
                                )->a( n = `text`  v = `{TEXT}`
                                )->a( n = `press` v = client->_event( val    = `ITEM_PRESS`
                                                              t_arg  = temp4
                                                              s_ctrl = temp5 )

                        )->end(
                    )->end(
                )->end(

                )->ele( n = `fixedItem` ns = `tnt`
                    )->ele( n = `NavigationList` ns = `tnt`
                        )->tag( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `id`           v = `quickCreate`
                            )->a( n = `text`         v = `Quick Create`
                            )->a( n = `icon`         v = `sap-icon://write-new`
                            )->a( n = `design`       v = `Action`
                            )->a( n = `selectable`   v = `false`
                            )->a( n = `ariaHasPopup` v = `Dialog`
                            )->a( n = `press`        v = client->_event( `QUICK_CREATE` )
                        )->tag( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text`       v = `External Link`
                            )->a( n = `icon`       v = `sap-icon://attachment`
                            )->a( n = `selectable` v = `false`
                            )->a( n = `href`       v = `https://sap.com`
                            )->a( n = `target`     v = `_blank`
                            )->a( n = `press`      v = client->_event( val    = `ITEM_PRESS`
                                                                       t_arg  = temp6
                                                                       s_ctrl = temp7 ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    DATA lv_ctrl  TYPE abap_bool.
    DATA lv_shift TYPE abap_bool.
    DATA lv_alt   TYPE abap_bool.
    DATA lv_meta  TYPE abap_bool.
        DATA temp1 TYPE xsdboolean.
        DATA lv_item TYPE string.
        DATA temp3 TYPE string.
        DATA lv_head LIKE temp3.
        DATA temp4 TYPE string.
        DATA temp6 TYPE string.
        DATA temp9 TYPE string.
        DATA temp10 TYPE string.
        DATA temp5 TYPE z2ui5_cl_smpc_app_241=>ty_s_nav_item.
        DATA temp7 TYPE z2ui5_cl_smpc_app_241=>ty_s_nav_item-text.
        DATA temp8 TYPE z2ui5_cl_smpc_app_241=>ty_s_nav_item-icon.

    CASE client->get_event( ).

      WHEN `TOGGLE_EXPAND`.
        " original onCollapseExpandPress: toggles SideNavigation.expanded
        
        temp1 = boolc( expanded = abap_false ).
        expanded = temp1.

      WHEN `PREVENT_TOGGLE`.
        " redraw so every press wire carries check_prevent_default matching the
        " fresh checkbox state (the flag is baked into the handler at render time)
        view_display( ).

      WHEN `ITEM_PRESS`.
        " original itemPress: reads the pressed item text + modifier keys and
        " toasts them; when the checkbox is set the wire's check_prevent_default
        " cancels the item's built-in default (selection / href) client-side
        
        lv_item = client->get_event_arg( ).
        lv_ctrl  = client->get_event_arg( 2 ).
        lv_shift = client->get_event_arg( 3 ).
        lv_alt   = client->get_event_arg( 4 ).
        lv_meta  = client->get_event_arg( 5 ).

        
        IF prevent_default = abap_true.
          temp3 = `Default was prevented:`.
        ELSE.
          temp3 = `Item Pressed:`.
        ENDIF.
        
        lv_head = temp3.
        
        IF lv_ctrl = abap_true.
          temp4 = `true`.
        ELSE.
          temp4 = `false`.
        ENDIF.
        
        IF lv_shift = abap_true.
          temp6 = `true`.
        ELSE.
          temp6 = `false`.
        ENDIF.
        
        IF lv_alt = abap_true.
          temp9 = `true`.
        ELSE.
          temp9 = `false`.
        ENDIF.
        
        IF lv_meta = abap_true.
          temp10 = `true`.
        ELSE.
          temp10 = `false`.
        ENDIF.
        client->message_toast_display(
          |{ lv_head }\n| &&
          |Item: { lv_item }\n| &&
          |Ctrl Key: { temp4 }\n| &&
          |Shift Key: { temp6 }\n| &&
          |Alt Key: { temp9 }\n| &&
          |Meta Key: { temp10 }| ).

      WHEN `QUICK_CREATE`.
        popup_quickcreate_display( ).

      WHEN `CREATE_ITEM`.
        " the Create button: addItem( new NavigationListItem({ text: sName ||
        " 'New Navigation Item', expanded: true, icon: sIcon || 'sap-icon://building' }) )
        " - reproduced 1:1 by appending the row the bound list renders
        
        CLEAR temp5.
        
        IF create_name IS NOT INITIAL.
          temp7 = create_name.
        ELSE.
          temp7 = `New Navigation Item`.
        ENDIF.
        temp5-text = temp7.
        
        IF create_icon IS NOT INITIAL.
          temp8 = create_icon.
        ELSE.
          temp8 = `sap-icon://building`.
        ENDIF.
        temp5-icon = temp8.
        temp5-selectable = abap_true.
        temp5-expanded = abap_true.
        INSERT temp5 INTO TABLE t_nav_items.
        client->popup_destroy( ).

    ENDCASE.

  ENDMETHOD.


  METHOD popup_quickcreate_display.

    " original quickActionPress builds this Dialog imperatively (new Dialog({...}).open());
    " expressed as a core:FragmentDefinition shown via popup_display (declared in the sidecar)
    DATA popup TYPE REF TO z2ui5_cl_ui5_view_builder.
    popup = z2ui5_cl_ui5_view_builder=>factory( ).

    popup->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns`      v = `sap.m`

        )->ele( `Dialog`
            )->a( n = `type`  v = `Message`
            )->a( n = `title` v = `Create Navigation List Item`

            )->ele( `content`
                )->tag( `Label`
                    )->a( n = `text`     v = `Name:`
                    )->a( n = `labelFor` v = `navigationItemName`
                )->tag( `Input`
                    )->a( n = `id`          v = `navigationItemName`
                    )->a( n = `width`       v = `100%`
                    )->a( n = `placeholder` v = `Name`
                    )->a( n = `value`       v = client->_bind( create_name )
                )->tag( `Label`
                    )->a( n = `text`     v = `Icon:`
                    )->a( n = `labelFor` v = `navigationItemIcon`
                )->tag( `Input`
                    )->a( n = `id`          v = `navigationItemIcon`
                    )->a( n = `width`       v = `100%`
                    )->a( n = `placeholder` v = `sap-icon://home`
                    )->a( n = `value`       v = client->_bind( create_icon )

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

    " the five items the sample declares on the main NavigationList, with the
    " two children of Mileage
    DATA temp6 LIKE t_nav_items.
    DATA temp7 LIKE LINE OF temp6.
    DATA temp9 TYPE z2ui5_cl_smpc_app_241=>ty_s_nav_item-items.
    DATA temp10 LIKE LINE OF temp9.
    CLEAR temp6.
    
    temp7-text = `Home`.
    temp7-icon = `sap-icon://home`.
    temp7-selectable = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-text = `Building`.
    temp7-icon = `sap-icon://building`.
    temp7-selectable = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-text = `Mileage`.
    temp7-icon = `sap-icon://mileage`.
    temp7-selectable = abap_true.
    
    CLEAR temp9.
    
    temp10-text = `Driven`.
    INSERT temp10 INTO TABLE temp9.
    temp10-text = `Walked`.
    INSERT temp10 INTO TABLE temp9.
    temp7-items = temp9.
    INSERT temp7 INTO TABLE temp6.
    temp7-text = `Link 1`.
    temp7-icon = `sap-icon://attachment`.
    temp7-selectable = abap_false.
    temp7-href = `https://sap.com`.
    temp7-target = `_blank`.
    INSERT temp7 INTO TABLE temp6.
    temp7-text = `Link 2`.
    temp7-icon = `sap-icon://attachment`.
    temp7-selectable = abap_false.
    temp7-href = `https://sap.com`.
    temp7-target = `_blank`.
    INSERT temp7 INTO TABLE temp6.
    t_nav_items = temp6.

  ENDMETHOD.

ENDCLASS.
