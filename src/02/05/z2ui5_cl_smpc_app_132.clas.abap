CLASS z2ui5_cl_smpc_app_132 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA expanded TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_132 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      expanded = abap_true.
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
                )->a( n = `selectedKey` v = `myAccounts`
                )->a( n = `expanded`    v = client->_bind( expanded )

                )->ele( n = `NavigationList` ns = `tnt`

                    )->tag( n = `NavigationListItem` ns = `tnt`
                        )->a( n = `text` v = `Dashboard`
                        )->a( n = `icon` v = `sap-icon://home`

                    " expanded reads @since 1.121 (relocated to NavigationListItemBase), selectable is @since 1.116,
                    " tag is @since 1.149 and the Indication15-20 states are @since 1.120 - all kept 1:1 (POST_171)
                    )->ele( n = `NavigationListItem` ns = `tnt`
                        )->a( n = `text`       v = `Favorites`
                        )->a( n = `icon`       v = `sap-icon://favorite`
                        )->a( n = `expanded`   v = `true`
                        )->a( n = `selectable` v = `false`
                        )->ele( n = `tag` ns = `tnt`
                            )->tag( `ObjectStatus`
                                )->a( n = `text`     v = `3 Items`
                                )->a( n = `state`    v = `Indication17`
                                )->a( n = `inverted` v = `true`

                        )->end(
                        )->tag( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `My Accounts`
                            )->a( n = `id`   v = `myAccounts`
                        )->ele( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `My Orders`
                            )->ele( n = `tag` ns = `tnt`
                                )->tag( `ObjectStatus`
                                    )->a( n = `text`     v = `5 Pending`
                                    )->a( n = `state`    v = `Indication20`
                                    )->a( n = `inverted` v = `true`

                            )->end(
                        )->end(
                        )->tag( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `My Reports`

                    )->end(

                    " NavigationListGroup is a control @since 1.121 - kept 1:1 (POST_171)
                    )->ele( n = `NavigationListGroup` ns = `tnt`
                        )->a( n = `text` v = `Business Operations`
                        )->ele( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Inventory`
                            )->a( n = `icon` v = `sap-icon://product`
                            )->ele( n = `tag` ns = `tnt`
                                )->tag( `ObjectStatus`
                                    )->a( n = `text`     v = `Low Stock`
                                    )->a( n = `state`    v = `Indication18`
                                    )->a( n = `inverted` v = `true`

                            )->end(
                        )->end(
                        )->tag( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Analytics`
                            )->a( n = `icon` v = `sap-icon://bar-chart`

                    )->end(

                    )->ele( n = `NavigationListItem` ns = `tnt`
                        )->a( n = `text` v = `API Explorer`
                        )->a( n = `icon` v = `sap-icon://explorer`
                        )->ele( n = `tag` ns = `tnt`
                            )->tag( `ObjectStatus`
                                )->a( n = `text`     v = `Beta`
                                )->a( n = `state`    v = `Indication15`
                                )->a( n = `inverted` v = `true`

                        )->end(
                    )->end(

                    )->ele( n = `NavigationListItem` ns = `tnt`
                        )->a( n = `text`     v = `Projects`
                        )->a( n = `icon`     v = `sap-icon://project-definition-triangle`
                        )->a( n = `expanded` v = `true`
                        )->ele( n = `tag` ns = `tnt`
                            )->tag( `ObjectStatus`
                                )->a( n = `text`     v = `2 Active`
                                )->a( n = `state`    v = `Indication16`
                                )->a( n = `inverted` v = `true`

                        )->end(
                        )->tag( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Project Alpha`
                        )->ele( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Project Beta`
                            )->ele( n = `tag` ns = `tnt`
                                )->tag( `ObjectStatus`
                                    )->a( n = `text`     v = `Experimental`
                                    )->a( n = `state`    v = `Indication19`
                                    )->a( n = `inverted` v = `true`

                            )->end(
                        )->end(
                    )->end(
                    )->tag( n = `NavigationListItem` ns = `tnt`
                        )->a( n = `text` v = `Documentation`
                        )->a( n = `icon` v = `sap-icon://sys-help`
                    )->tag( n = `NavigationListItem` ns = `tnt`
                        )->a( n = `text` v = `Sandbox`
                        )->a( n = `icon` v = `sap-icon://lab`
                    )->ele( n = `NavigationListItem` ns = `tnt`
                        )->a( n = `text` v = `Notifications`
                        )->a( n = `icon` v = `sap-icon://bell`
                        )->ele( n = `tag` ns = `tnt`
                            )->tag( `ObjectStatus`
                                )->a( n = `text`     v = `8 New`
                                )->a( n = `state`    v = `Indication18`
                                )->a( n = `inverted` v = `true`

                        )->end(
                    )->end(
                )->end(

                )->ele( n = `fixedItem` ns = `tnt`
                    )->ele( n = `NavigationList` ns = `tnt`
                        )->ele( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Support`
                            )->a( n = `icon` v = `sap-icon://sys-help-2`
                            )->ele( n = `tag` ns = `tnt`
                                )->tag( `ObjectStatus`
                                    )->a( n = `text`     v = `24/7`
                                    )->a( n = `state`    v = `Indication16`
                                    )->a( n = `inverted` v = `true`

                            )->end(
                        )->end(
                        )->tag( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Settings`
                            )->a( n = `icon` v = `sap-icon://action-settings` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `TOGGLE_EXPAND`.
      " original onCollapseExpandPress: toggles SideNavigation.expanded
      expanded = xsdbool( expanded = abap_false ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
