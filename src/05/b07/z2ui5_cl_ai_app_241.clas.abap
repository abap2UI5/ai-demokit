CLASS z2ui5_cl_ai_app_241 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA expanded        TYPE abap_bool.
    DATA prevent_default TYPE abap_bool.
    DATA create_name     TYPE string.
    DATA create_icon     TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popup_quickcreate_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_241 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      expanded = abap_false.
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

            )->shut(

            )->open( n = `SideNavigation` ns = `tnt`
                )->a( n = `id`          v = `sideNavigation`
                )->a( n = `selectedKey` v = `walked`
                )->a( n = `expanded`    v = client->_bind( expanded )

                )->open( n = `NavigationList` ns = `tnt`
                    )->leaf( n = `NavigationListItem` ns = `tnt`
                        )->a( n = `text`  v = `Home`
                        )->a( n = `icon`  v = `sap-icon://home`
                        )->a( n = `press` v = client->_event( val   = `ITEM_PRESS`
                                                              t_arg = VALUE #( ( `${$parameters>/item}.getText()` ) ( `${$parameters>/ctrlKey}` ) ( `${$parameters>/shiftKey}` ) ( `${$parameters>/altKey}` ) ( `${$parameters>/metaKey}` ) ) )
                    )->leaf( n = `NavigationListItem` ns = `tnt`
                        )->a( n = `text`  v = `Building`
                        )->a( n = `icon`  v = `sap-icon://building`
                        )->a( n = `press` v = client->_event( val   = `ITEM_PRESS`
                                                              t_arg = VALUE #( ( `${$parameters>/item}.getText()` ) ( `${$parameters>/ctrlKey}` ) ( `${$parameters>/shiftKey}` ) ( `${$parameters>/altKey}` ) ( `${$parameters>/metaKey}` ) ) )

                    )->open( n = `NavigationListItem` ns = `tnt`
                        )->a( n = `text`  v = `Mileage`
                        )->a( n = `icon`  v = `sap-icon://mileage`
                        )->a( n = `press` v = client->_event( val   = `ITEM_PRESS`
                                                              t_arg = VALUE #( ( `${$parameters>/item}.getText()` ) ( `${$parameters>/ctrlKey}` ) ( `${$parameters>/shiftKey}` ) ( `${$parameters>/altKey}` ) ( `${$parameters>/metaKey}` ) ) )
                        )->leaf( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text`  v = `Driven`
                            )->a( n = `press` v = client->_event( val   = `ITEM_PRESS`
                                                                  t_arg = VALUE #( ( `${$parameters>/item}.getText()` ) ( `${$parameters>/ctrlKey}` ) ( `${$parameters>/shiftKey}` ) ( `${$parameters>/altKey}` ) ( `${$parameters>/metaKey}` ) ) )
                        )->leaf( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text`  v = `Walked`
                            )->a( n = `press` v = client->_event( val   = `ITEM_PRESS`
                                                                  t_arg = VALUE #( ( `${$parameters>/item}.getText()` ) ( `${$parameters>/ctrlKey}` ) ( `${$parameters>/shiftKey}` ) ( `${$parameters>/altKey}` ) ( `${$parameters>/metaKey}` ) ) )

                    )->shut(
                    )->leaf( n = `NavigationListItem` ns = `tnt`
                        )->a( n = `text`       v = `Link 1`
                        )->a( n = `icon`       v = `sap-icon://attachment`
                        )->a( n = `selectable` v = `false`
                        )->a( n = `href`       v = `https://sap.com`
                        )->a( n = `target`     v = `_blank`
                        )->a( n = `press`      v = client->_event( val   = `ITEM_PRESS`
                                                                   t_arg = VALUE #( ( `${$parameters>/item}.getText()` ) ( `${$parameters>/ctrlKey}` ) ( `${$parameters>/shiftKey}` ) ( `${$parameters>/altKey}` ) ( `${$parameters>/metaKey}` ) ) )
                    )->leaf( n = `NavigationListItem` ns = `tnt`
                        )->a( n = `text`       v = `Link 2`
                        )->a( n = `icon`       v = `sap-icon://attachment`
                        )->a( n = `selectable` v = `false`
                        )->a( n = `href`       v = `https://sap.com`
                        )->a( n = `target`     v = `_blank`
                        )->a( n = `press`      v = client->_event( val   = `ITEM_PRESS`
                                                                   t_arg = VALUE #( ( `${$parameters>/item}.getText()` ) ( `${$parameters>/ctrlKey}` ) ( `${$parameters>/shiftKey}` ) ( `${$parameters>/altKey}` ) ( `${$parameters>/metaKey}` ) ) )

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
                            )->a( n = `press`      v = client->_event( val   = `ITEM_PRESS`
                                                                       t_arg = VALUE #( ( `${$parameters>/item}.getText()` ) ( `${$parameters>/ctrlKey}` ) ( `${$parameters>/shiftKey}` ) ( `${$parameters>/altKey}` ) ( `${$parameters>/metaKey}` ) ) ) ).

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

      WHEN `ITEM_PRESS`.
        " original itemPress: reads the pressed item text + modifier keys and
        " toasts them; preventDefault (when the checkbox is set) cannot suppress
        " the client-side selection here - only the message text reflects it
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
        " original: the Create button adds a new NavigationListItem to the list;
        " dynamic addItem to the statically declared list is not expressible, so
        " the entered values are echoed instead of a real item being added
        DATA(lv_name) = COND string( WHEN create_name IS NOT INITIAL
                                     THEN create_name
                                     ELSE `New Navigation Item` ).
        client->popup_destroy( ).
        client->message_toast_display( |Create '{ lv_name }' - dynamic addItem is not reproduced| ).

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

ENDCLASS.
