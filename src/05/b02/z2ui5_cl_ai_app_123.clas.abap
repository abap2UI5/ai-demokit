CLASS z2ui5_cl_ai_app_123 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA expanded     TYPE abap_bool.
    DATA sub3_visible TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_123 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      expanded     = abap_true.
      sub3_visible = abap_true.
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

        )->open( `OverflowToolbar`
            )->leaf( `Button`
                )->a( n = `text`  v = `Toggle Collapse/Expand`
                )->a( n = `icon`  v = `sap-icon://menu2`
                )->a( n = `press` v = client->_event( `TOGGLE_EXPAND` )
            )->leaf( `Button`
                )->a( n = `text`  v = `Show/Hide SubItem 3`
                )->a( n = `icon`  v = `sap-icon://menu2`
                )->a( n = `press` v = client->_event( `TOGGLE_SUB3` )

        )->shut(

        )->open( n = `NavigationList` ns = `tnt`
            )->a( n = `id`          v = `navigationList`
            )->a( n = `width`       v = `320px`
            )->a( n = `selectedKey` v = `subItem3`
            )->a( n = `expanded`    v = client->_bind( expanded )

            )->open( n = `NavigationListItem` ns = `tnt`
                )->a( n = `text` v = `Item 1`
                )->a( n = `key`  v = `rootItem1`
                )->a( n = `icon` v = `sap-icon://employee`

                )->leaf( n = `NavigationListItem` ns = `tnt`
                    )->a( n = `text` v = `Sub Item 1`
                )->leaf( n = `NavigationListItem` ns = `tnt`
                    )->a( n = `text` v = `Sub Item 2`
                )->leaf( n = `NavigationListItem` ns = `tnt`
                    )->a( n = `text`    v = `Sub Item 3`
                    )->a( n = `id`      v = `subItemThree`
                    )->a( n = `key`     v = `subItem3`
                    )->a( n = `visible` v = client->_bind( sub3_visible )
                )->leaf( n = `NavigationListItem` ns = `tnt`
                    )->a( n = `text` v = `Sub Item 4`
                )->leaf( n = `NavigationListItem` ns = `tnt`
                    )->a( n = `text`    v = `Invisible Sub Item 5`
                    )->a( n = `visible` v = `false`
                )->leaf( n = `NavigationListItem` ns = `tnt`
                    )->a( n = `text`    v = `Invisible Sub Item 6`
                    )->a( n = `visible` v = `false`

            )->shut(

            )->open( n = `NavigationListItem` ns = `tnt`
                )->a( n = `text`    v = `Invisible Section`
                )->a( n = `icon`    v = `sap-icon://employee`
                )->a( n = `visible` v = `false`

                )->leaf( n = `NavigationListItem` ns = `tnt`
                    )->a( n = `text` v = `Sub Item 1`
                )->leaf( n = `NavigationListItem` ns = `tnt`
                    )->a( n = `text` v = `Sub Item 2`
                )->leaf( n = `NavigationListItem` ns = `tnt`
                    )->a( n = `text` v = `Sub Item 3`
                )->leaf( n = `NavigationListItem` ns = `tnt`
                    )->a( n = `text` v = `Sub Item 4`

            )->shut(

            )->open( n = `NavigationListItem` ns = `tnt`
                )->a( n = `text` v = `Item 2`
                )->a( n = `icon` v = `sap-icon://building`

                )->leaf( n = `NavigationListItem` ns = `tnt`
                    )->a( n = `text` v = `Sub Item 1`
                )->leaf( n = `NavigationListItem` ns = `tnt`
                    )->a( n = `text` v = `Sub Item 2`
                )->leaf( n = `NavigationListItem` ns = `tnt`
                    )->a( n = `text` v = `Sub Item 3`
                )->leaf( n = `NavigationListItem` ns = `tnt`
                    )->a( n = `text` v = `Sub Item 4` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `TOGGLE_EXPAND`.
        " original onCollapseExpandPress: getExpanded() -> setExpanded(!bExpanded)
        expanded = xsdbool( expanded = abap_false ).
        client->view_model_update( ).

      WHEN `TOGGLE_SUB3`.
        " original onHideShowSubItemPress: toggles subItemThree visibility
        sub3_visible = xsdbool( sub3_visible = abap_false ).
        client->view_model_update( ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
