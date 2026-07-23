CLASS z2ui5_cl_ai_app_132 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA expanded TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_132 IMPLEMENTATION.

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

            )->leaf( `Button`
                )->a( n = `text`  v = `Toggle Collapse/Expand`
                )->a( n = `icon`  v = `sap-icon://menu2`
                )->a( n = `press` v = client->_event( `TOGGLE_EXPAND` )

            )->open( n = `SideNavigation` ns = `tnt`
                )->a( n = `id`          v = `sideNavigation`
                )->a( n = `selectedKey` v = `myAccounts`
                )->a( n = `expanded`    v = client->_bind( expanded )

                )->open( n = `NavigationList` ns = `tnt`

                    )->leaf( n = `NavigationListItem` ns = `tnt`
                        )->a( n = `text` v = `Dashboard`
                        )->a( n = `icon` v = `sap-icon://home`

                    )->open( n = `NavigationListItem` ns = `tnt`
                        )->a( n = `text`       v = `Favorites`
                        )->a( n = `icon`       v = `sap-icon://favorite`
                        )->a( n = `expanded`   v = `true`
                        )->a( n = `selectable` v = `false`
                        )->open( n = `tag` ns = `tnt`
                            )->leaf( `ObjectStatus`
                                )->a( n = `text`     v = `3 Items`
                                )->a( n = `state`    v = `Indication17`
                                )->a( n = `inverted` v = `true`

                        )->shut(
                        )->leaf( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `My Accounts`
                            )->a( n = `id`   v = `myAccounts`
                        )->open( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `My Orders`
                            )->open( n = `tag` ns = `tnt`
                                )->leaf( `ObjectStatus`
                                    )->a( n = `text`     v = `5 Pending`
                                    )->a( n = `state`    v = `Indication20`
                                    )->a( n = `inverted` v = `true`

                        )->shut(
                        )->shut(
                        )->leaf( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `My Reports`

                    )->shut(

                    )->open( n = `NavigationListGroup` ns = `tnt`
                        )->a( n = `text` v = `Business Operations`
                        )->open( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Inventory`
                            )->a( n = `icon` v = `sap-icon://product`
                            )->open( n = `tag` ns = `tnt`
                                )->leaf( `ObjectStatus`
                                    )->a( n = `text`     v = `Low Stock`
                                    )->a( n = `state`    v = `Indication18`
                                    )->a( n = `inverted` v = `true`

                        )->shut(
                        )->shut(
                        )->leaf( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Analytics`
                            )->a( n = `icon` v = `sap-icon://bar-chart`

                    )->shut(

                    )->open( n = `NavigationListItem` ns = `tnt`
                        )->a( n = `text` v = `API Explorer`
                        )->a( n = `icon` v = `sap-icon://explorer`
                        )->open( n = `tag` ns = `tnt`
                            )->leaf( `ObjectStatus`
                                )->a( n = `text`     v = `Beta`
                                )->a( n = `state`    v = `Indication15`
                                )->a( n = `inverted` v = `true`

                    )->shut(
                    )->shut(

                    )->open( n = `NavigationListItem` ns = `tnt`
                        )->a( n = `text`     v = `Projects`
                        )->a( n = `icon`     v = `sap-icon://project-definition-triangle`
                        )->a( n = `expanded` v = `true`
                        )->open( n = `tag` ns = `tnt`
                            )->leaf( `ObjectStatus`
                                )->a( n = `text`     v = `2 Active`
                                )->a( n = `state`    v = `Indication16`
                                )->a( n = `inverted` v = `true`

                        )->shut(
                        )->leaf( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Project Alpha`
                        )->open( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Project Beta`
                            )->open( n = `tag` ns = `tnt`
                                )->leaf( `ObjectStatus`
                                    )->a( n = `text`     v = `Experimental`
                                    )->a( n = `state`    v = `Indication19`
                                    )->a( n = `inverted` v = `true`

                        )->shut(
                        )->shut(
                    )->shut(
                    )->leaf( n = `NavigationListItem` ns = `tnt`
                        )->a( n = `text` v = `Documentation`
                        )->a( n = `icon` v = `sap-icon://sys-help`
                    )->leaf( n = `NavigationListItem` ns = `tnt`
                        )->a( n = `text` v = `Sandbox`
                        )->a( n = `icon` v = `sap-icon://lab`
                    )->open( n = `NavigationListItem` ns = `tnt`
                        )->a( n = `text` v = `Notifications`
                        )->a( n = `icon` v = `sap-icon://bell`
                        )->open( n = `tag` ns = `tnt`
                            )->leaf( `ObjectStatus`
                                )->a( n = `text`     v = `8 New`
                                )->a( n = `state`    v = `Indication18`
                                )->a( n = `inverted` v = `true`

                    )->shut(
                    )->shut(
                )->shut(

                )->open( n = `fixedItem` ns = `tnt`
                    )->open( n = `NavigationList` ns = `tnt`
                        )->open( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Support`
                            )->a( n = `icon` v = `sap-icon://sys-help-2`
                            )->open( n = `tag` ns = `tnt`
                                )->leaf( `ObjectStatus`
                                    )->a( n = `text`     v = `24/7`
                                    )->a( n = `state`    v = `Indication16`
                                    )->a( n = `inverted` v = `true`

                        )->shut(
                        )->shut(
                        )->leaf( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Settings`
                            )->a( n = `icon` v = `sap-icon://action-settings` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `TOGGLE_EXPAND`.
        " original onCollapseExpandPress: toggles SideNavigation.expanded
        expanded = xsdbool( expanded = abap_false ).
        client->view_model_update( ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
