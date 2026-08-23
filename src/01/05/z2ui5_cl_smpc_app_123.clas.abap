" @keywords navigationlist navigation list sap.tnt overflowtoolbar button navigationlistitem
" @summary Navigation List in a Page
CLASS z2ui5_cl_smpc_app_123 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_smpc_app_123 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      expanded     = abap_true.
      sub3_visible = abap_true.
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

        )->ele( `OverflowToolbar`
            )->tag( `Button`
                )->a( n = `text`  v = `Toggle Collapse/Expand`
                )->a( n = `icon`  v = `sap-icon://menu2`
                )->a( n = `press` v = client->_event( `TOGGLE_EXPAND` )
            )->tag( `Button`
                )->a( n = `text`  v = `Show/Hide SubItem 3`
                )->a( n = `icon`  v = `sap-icon://menu2`
                )->a( n = `press` v = client->_event( `TOGGLE_SUB3` )

        )->end(

        )->ele( n = `NavigationList` ns = `tnt`
            )->a( n = `id`          v = `navigationList`
            )->a( n = `width`       v = `320px`
            )->a( n = `selectedKey` v = `subItem3`
            )->a( n = `expanded`    v = client->_bind( expanded )

            )->ele( n = `NavigationListItem` ns = `tnt`
                )->a( n = `text` v = `Item 1`
                )->a( n = `key`  v = `rootItem1`
                )->a( n = `icon` v = `sap-icon://employee`

                )->tag( n = `NavigationListItem` ns = `tnt`
                    )->a( n = `text` v = `Sub Item 1`
                )->tag( n = `NavigationListItem` ns = `tnt`
                    )->a( n = `text` v = `Sub Item 2`
                )->tag( n = `NavigationListItem` ns = `tnt`
                    )->a( n = `text`    v = `Sub Item 3`
                    )->a( n = `id`      v = `subItemThree`
                    )->a( n = `key`     v = `subItem3`
                    )->a( n = `visible` v = client->_bind( sub3_visible )
                )->tag( n = `NavigationListItem` ns = `tnt`
                    )->a( n = `text` v = `Sub Item 4`
                )->tag( n = `NavigationListItem` ns = `tnt`
                    )->a( n = `text`    v = `Invisible Sub Item 5`
                    )->a( n = `visible` v = `false`
                )->tag( n = `NavigationListItem` ns = `tnt`
                    )->a( n = `text`    v = `Invisible Sub Item 6`
                    )->a( n = `visible` v = `false`

            )->end(

            )->ele( n = `NavigationListItem` ns = `tnt`
                )->a( n = `text`    v = `Invisible Section`
                )->a( n = `icon`    v = `sap-icon://employee`
                )->a( n = `visible` v = `false`

                )->tag( n = `NavigationListItem` ns = `tnt`
                    )->a( n = `text` v = `Sub Item 1`
                )->tag( n = `NavigationListItem` ns = `tnt`
                    )->a( n = `text` v = `Sub Item 2`
                )->tag( n = `NavigationListItem` ns = `tnt`
                    )->a( n = `text` v = `Sub Item 3`
                )->tag( n = `NavigationListItem` ns = `tnt`
                    )->a( n = `text` v = `Sub Item 4`

            )->end(

            )->ele( n = `NavigationListItem` ns = `tnt`
                )->a( n = `text` v = `Item 2`
                )->a( n = `icon` v = `sap-icon://building`

                )->tag( n = `NavigationListItem` ns = `tnt`
                    )->a( n = `text` v = `Sub Item 1`
                )->tag( n = `NavigationListItem` ns = `tnt`
                    )->a( n = `text` v = `Sub Item 2`
                )->tag( n = `NavigationListItem` ns = `tnt`
                    )->a( n = `text` v = `Sub Item 3`
                )->tag( n = `NavigationListItem` ns = `tnt`
                    )->a( n = `text` v = `Sub Item 4` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `TOGGLE_EXPAND`.
        " original onCollapseExpandPress: getExpanded() -> setExpanded(!bExpanded)
        expanded = xsdbool( expanded = abap_false ).

      WHEN `TOGGLE_SUB3`.
        " original onHideShowSubItemPress: toggles subItemThree visibility
        sub3_visible = xsdbool( sub3_visible = abap_false ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
