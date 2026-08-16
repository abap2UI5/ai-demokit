CLASS z2ui5_cl_smpc_app_299 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA expanded    TYPE abap_bool.
    DATA create_name TYPE string.
    DATA create_icon TYPE string.

    TYPES: BEGIN OF ty_s_nav_item,
             text     TYPE string,
             icon     TYPE string,
             expanded TYPE abap_bool,
           END OF ty_s_nav_item.
    DATA t_nav_items TYPE STANDARD TABLE OF ty_s_nav_item WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popup_quickcreate_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_299 IMPLEMENTATION.

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

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:tnt` v = `sap.tnt`
        )->a( n = `height`    v = `100%`

        )->ele( `VBox`
            )->a( n = `renderType` v = `Bare`
            )->a( n = `alignItems` v = `Start`
            )->a( n = `height`     v = `100%`

            )->tag( `Button`
                )->a( n = `text`  v = `Toggle Collapse/Expand`
                )->a( n = `icon`  v = `sap-icon://menu2`
                )->a( n = `press` v = client->_event( `TOGGLE_EXPAND` )

            )->ele( n = `SideNavigation` ns = `tnt`
                )->a( n = `id`          v = `sideNavigation`
                )->a( n = `selectedKey` v = `walked`
                )->a( n = `expanded`    v = client->_bind( expanded )

                " the Create button of the quick-create dialog does
                " sideNavigation.getItem().addItem( new NavigationListItem( ... ) ), so
                " the list is a bound aggregation (the app-241 pattern) instead of four
                " static entries: creating appends a row. EXPANDED is omitted while
                " initial so an item that does not set it keeps the control default
                )->ele( n = `NavigationList` ns = `tnt`
                    )->a( n = `items` v = client->_bind(
                                              val                = t_nav_items
                                              omit_initial_paths = VALUE #( ( `EXPANDED` ) ) )

                    )->tag( n = `NavigationListItem` ns = `tnt`
                        )->a( n = `text`     v = `{TEXT}`
                        )->a( n = `icon`     v = `{ICON}`
                        )->a( n = `expanded` v = `{EXPANDED}`

                )->end(

                )->ele( n = `fixedItem` ns = `tnt`
                    )->ele( n = `NavigationList` ns = `tnt`
                        )->tag( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `ariaHasPopup` v = `Dialog`
                            )->a( n = `id`           v = `quickCreate`
                            )->a( n = `press`        v = client->_event( `QUICK_CREATE` )
                            )->a( n = `text`         v = `Quick Create`
                            )->a( n = `icon`         v = `sap-icon://write-new`
                            )->a( n = `design`       v = `Action`
                            )->a( n = `selectable`   v = `false`
                        )->tag( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `selectable` v = `false`
                            )->a( n = `href`       v = `https://sap.com`
                            )->a( n = `target`     v = `_blank`
                            )->a( n = `text`       v = `External Link`
                            )->a( n = `icon`       v = `sap-icon://attachment` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `TOGGLE_EXPAND`.
        " original onCollapseExpandPress: toggles SideNavigation.expanded
        expanded = xsdbool( expanded = abap_false ).

      WHEN `QUICK_CREATE`.
        popup_quickcreate_display( ).

      WHEN `CREATE_ITEM`.
        " the Create button: addItem( new NavigationListItem({ text: sName ||
        " 'New Navigation Item', expanded: true, icon: sIcon || 'sap-icon://building' }) )
        " - reproduced 1:1 by appending the row the bound list renders
        INSERT VALUE #( text     = COND #( WHEN create_name IS NOT INITIAL
                                           THEN create_name
                                           ELSE `New Navigation Item` )
                        icon     = COND #( WHEN create_icon IS NOT INITIAL
                                           THEN create_icon
                                           ELSE `sap-icon://building` )
                        expanded = abap_true ) INTO TABLE t_nav_items.
        client->popup_destroy( ).

    ENDCASE.

  ENDMETHOD.


  METHOD popup_quickcreate_display.

    " original quickActionPress builds this Dialog imperatively (new Dialog({...}).open());
    " expressed as a core:FragmentDefinition shown via popup_display (declared deviation)
    DATA(popup) = z2ui5_cl_ui5_view_builder=>factory( ).

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

    " the four items the sample declares on the main NavigationList
    t_nav_items = VALUE #( ( text = `Home`      icon = `sap-icon://home` )
                           ( text = `Building`  icon = `sap-icon://building` )
                           ( text = `Mileage`   icon = `sap-icon://mileage` )
                           ( text = `Transport` icon = `sap-icon://map-2` ) ).

  ENDMETHOD.

ENDCLASS.
