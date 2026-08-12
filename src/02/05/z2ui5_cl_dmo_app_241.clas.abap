CLASS z2ui5_cl_dmo_app_241 DEFINITION PUBLIC.

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
             items      TYPE STANDARD TABLE OF ty_s_child WITH EMPTY KEY,
           END OF ty_s_nav_item.
    DATA t_nav_items TYPE STANDARD TABLE OF ty_s_nav_item WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.
    METHODS on_event.
    METHODS popup_quickcreate_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_dmo_app_241 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      expanded = abap_false.
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

        )->open( `VBox`
            )->a( n = `renderType` v = `Bare`
            )->a( n = `alignItems` v = `Start`
            )->a( n = `height`     v = `100%`

            )->open( `HBox`
                )->a( n = `renderType` v = `Bare`

                )->leaf( `Button`
                    )->a( n = `text`  v = `Toggle Collapse/Expand`
                    )->a( n = `icon`  v = `sap-icon://menu2`
                    )->a( n = `press` v = client->_event( `TOGGLE_EXPAND` )
                )->leaf( `CheckBox`
                    )->a( n = `id`       v = `preventDefaultCheckbox`
                    )->a( n = `text`     v = `Press event - PreventDefault`
                    )->a( n = `selected` v = client->_bind( prevent_default )
                    " added wire (declared): the redraw bakes check_prevent_default
                    " into every press handler to match the fresh checkbox state
                    )->a( n = `select`   v = client->_event( `PREVENT_TOGGLE` )

            )->shut(

            )->open( n = `SideNavigation` ns = `tnt`
                )->a( n = `id`          v = `sideNavigation`
                )->a( n = `selectedKey` v = `walked`
                )->a( n = `expanded`    v = client->_bind( expanded )

                " the Create button of the quick-create dialog does
                " sideNavigation.getItem().addItem( new NavigationListItem( ... ) ), so
                " the list is bound (the app-085/203 pattern) instead of statically
                " declared: creating appends a row. The rows are bound with
                " omit_initial_paths so an item that sets no icon/href keeps the
                " control's own default - SELECTABLE stays outside that list because
                " an explicit false must reach the two external links
                )->open( n = `NavigationList` ns = `tnt`
                    )->a( n = `items` v = client->_bind(
                                              val                = t_nav_items
                                              omit_initial_paths = VALUE #( ( `ICON` )
                                                                            ( `HREF` )
                                                                            ( `TARGET` ) ) )

                    )->open( n = `NavigationListItem` ns = `tnt`
                        )->a( n = `text`       v = `{TEXT}`
                        )->a( n = `icon`       v = `{ICON}`
                        )->a( n = `href`       v = `{HREF}`
                        )->a( n = `target`     v = `{TARGET}`
                        )->a( n = `selectable` v = `{SELECTABLE}`
                        )->a( n = `expanded`   v = `{EXPANDED}`
                        )->a( n = `press`      v = client->_event( val    = `ITEM_PRESS`
                                                              t_arg  = VALUE #( ( `${$parameters>/item}.getText()` ) ( `${$parameters>/ctrlKey}` ) ( `${$parameters>/shiftKey}` ) ( `${$parameters>/altKey}` ) ( `${$parameters>/metaKey}` ) )
                                                              s_ctrl = VALUE #( check_prevent_default = prevent_default ) )

                        )->open( n = `items` ns = `tnt`
                            )->leaf( n = `NavigationListItem` ns = `tnt`
                                )->a( n = `text`  v = `{TEXT}`
                                )->a( n = `press` v = client->_event( val    = `ITEM_PRESS`
                                                              t_arg  = VALUE #( ( `${$parameters>/item}.getText()` ) ( `${$parameters>/ctrlKey}` ) ( `${$parameters>/shiftKey}` ) ( `${$parameters>/altKey}` ) ( `${$parameters>/metaKey}` ) )
                                                              s_ctrl = VALUE #( check_prevent_default = prevent_default ) )

                        )->shut(
                    )->shut(
                )->shut(

                )->open( n = `fixedItem` ns = `tnt`
                    )->open( n = `NavigationList` ns = `tnt`
                        )->leaf( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `id`           v = `quickCreate`
                            )->a( n = `text`         v = `Quick Create`
                            )->a( n = `icon`         v = `sap-icon://write-new`
                            )->a( n = `design`       v = `Action`
                            )->a( n = `selectable`   v = `false`
                            )->a( n = `ariaHasPopup` v = `Dialog`
                            )->a( n = `press`        v = client->_event( `QUICK_CREATE` )
                        )->leaf( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text`       v = `External Link`
                            )->a( n = `icon`       v = `sap-icon://attachment`
                            )->a( n = `selectable` v = `false`
                            )->a( n = `href`       v = `https://sap.com`
                            )->a( n = `target`     v = `_blank`
                            )->a( n = `press`      v = client->_event( val    = `ITEM_PRESS`
                                                                       t_arg  = VALUE #( ( `${$parameters>/item}.getText()` ) ( `${$parameters>/ctrlKey}` ) ( `${$parameters>/shiftKey}` ) ( `${$parameters>/altKey}` ) ( `${$parameters>/metaKey}` ) )
                                                                       s_ctrl = VALUE #( check_prevent_default = prevent_default ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    DATA lv_ctrl  TYPE abap_bool.
    DATA lv_shift TYPE abap_bool.
    DATA lv_alt   TYPE abap_bool.
    DATA lv_meta  TYPE abap_bool.

    CASE client->get( )-event.

      WHEN `TOGGLE_EXPAND`.
        " original onCollapseExpandPress: toggles SideNavigation.expanded
        expanded = xsdbool( expanded = abap_false ).
        client->view_model_update( ).

      WHEN `PREVENT_TOGGLE`.
        " redraw so every press wire carries check_prevent_default matching the
        " fresh checkbox state (the flag is baked into the handler at render time)
        view_display( ).

      WHEN `ITEM_PRESS`.
        " original itemPress: reads the pressed item text + modifier keys and
        " toasts them; when the checkbox is set the wire's check_prevent_default
        " cancels the item's built-in default (selection / href) client-side
        DATA(lv_item) = client->get_event_arg( ).
        lv_ctrl  = client->get_event_arg( 2 ).
        lv_shift = client->get_event_arg( 3 ).
        lv_alt   = client->get_event_arg( 4 ).
        lv_meta  = client->get_event_arg( 5 ).

        DATA(lv_head) = COND string( WHEN prevent_default = abap_true
                                     THEN `Default was prevented:`
                                     ELSE `Item Pressed:` ).
        client->message_toast_display(
          |{ lv_head }\n| &&
          |Item: { lv_item }\n| &&
          |Ctrl Key: { COND string( WHEN lv_ctrl  = abap_true THEN `true` ELSE `false` ) }\n| &&
          |Shift Key: { COND string( WHEN lv_shift = abap_true THEN `true` ELSE `false` ) }\n| &&
          |Alt Key: { COND string( WHEN lv_alt   = abap_true THEN `true` ELSE `false` ) }\n| &&
          |Meta Key: { COND string( WHEN lv_meta  = abap_true THEN `true` ELSE `false` ) }| ).

      WHEN `QUICK_CREATE`.
        popup_quickcreate_display( ).

      WHEN `CREATE_ITEM`.
        " the Create button: addItem( new NavigationListItem({ text: sName ||
        " 'New Navigation Item', expanded: true, icon: sIcon || 'sap-icon://building' }) )
        " - reproduced 1:1 by appending the row the bound list renders
        INSERT VALUE #( text       = COND #( WHEN create_name IS NOT INITIAL
                                             THEN create_name
                                             ELSE `New Navigation Item` )
                        icon       = COND #( WHEN create_icon IS NOT INITIAL
                                             THEN create_icon
                                             ELSE `sap-icon://building` )
                        selectable = abap_true
                        expanded   = abap_true ) INTO TABLE t_nav_items.
        client->popup_destroy( ).
        client->view_model_update( ).

    ENDCASE.

  ENDMETHOD.


  METHOD popup_quickcreate_display.

    " original quickActionPress builds this Dialog imperatively (new Dialog({...}).open());
    " expressed as a core:FragmentDefinition shown via popup_display (see IMPROVISED deviation)
    DATA(popup) = z2ui5_cl_ai_xml=>factory( ).

    popup->open( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns`      v = `sap.m`

        )->open( `Dialog`
            )->a( n = `type`  v = `Message`
            )->a( n = `title` v = `Create Navigation List Item`

            )->open( `content`
                )->leaf( `Label`
                    )->a( n = `text`     v = `Name:`
                    )->a( n = `labelFor` v = `navigationItemName`
                )->leaf( `Input`
                    )->a( n = `id`          v = `navigationItemName`
                    )->a( n = `width`       v = `100%`
                    )->a( n = `placeholder` v = `Name`
                    )->a( n = `value`       v = client->_bind( create_name )
                )->leaf( `Label`
                    )->a( n = `text`     v = `Icon:`
                    )->a( n = `labelFor` v = `navigationItemIcon`
                )->leaf( `Input`
                    )->a( n = `id`          v = `navigationItemIcon`
                    )->a( n = `width`       v = `100%`
                    )->a( n = `placeholder` v = `sap-icon://home`
                    )->a( n = `value`       v = client->_bind( create_icon )

            )->shut(
            )->open( `beginButton`
                )->leaf( `Button`
                    )->a( n = `type`  v = `Emphasized`
                    )->a( n = `text`  v = `Create`
                    )->a( n = `press` v = client->_event( `CREATE_ITEM` )

            )->shut(
            )->open( `endButton`
                )->leaf( `Button`
                    )->a( n = `text`  v = `Cancel`
                    )->a( n = `press` v = client->_event_client( client->cs_event-popup_close ) ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " the five items the sample declares on the main NavigationList, with the
    " two children of Mileage
    t_nav_items = VALUE #(
      selectable = abap_true
      ( text = `Home`     icon = `sap-icon://home` )
      ( text = `Building` icon = `sap-icon://building` )
      ( text = `Mileage`  icon = `sap-icon://mileage`
        items = VALUE #( ( text = `Driven` ) ( text = `Walked` ) ) )
      ( text = `Link 1` icon = `sap-icon://attachment` selectable = abap_false
        href = `https://sap.com` target = `_blank` )
      ( text = `Link 2` icon = `sap-icon://attachment` selectable = abap_false
        href = `https://sap.com` target = `_blank` ) ).

  ENDMETHOD.

ENDCLASS.
