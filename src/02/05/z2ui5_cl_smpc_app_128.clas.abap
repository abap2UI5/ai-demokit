CLASS z2ui5_cl_smpc_app_128 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA expanded       TYPE abap_bool.
    DATA walked_visible TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_128 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      expanded       = abap_false.
      walked_visible = abap_true.
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
            )->a( n = `renderType`  v = `Bare`
            )->a( n = `alignItems`  v = `Start`
            )->a( n = `height`      v = `100%`

            )->tag( `Button`
                )->a( n = `text`  v = `Toggle Collapse/Expand`
                )->a( n = `icon`  v = `sap-icon://menu2`
                )->a( n = `press` v = client->_event( `TOGGLE_EXPAND` )
            )->tag( `Button`
                )->a( n = `text`  v = `Show/Hide "Walked"`
                )->a( n = `icon`  v = `sap-icon://menu2`
                )->a( n = `press` v = client->_event( `TOGGLE_WALKED` )

            )->ele( n = `SideNavigation` ns = `tnt`
                )->a( n = `id`          v = `sideNavigation`
                )->a( n = `selectedKey` v = `walked`
                )->a( n = `expanded`    v = client->_bind( expanded )

                )->ele( n = `NavigationList` ns = `tnt`
                    )->tag( n = `NavigationListItem` ns = `tnt`
                        )->a( n = `text` v = `Home`
                        )->a( n = `icon` v = `sap-icon://home`

                    " NavigationListGroup is a control @since 1.121 - kept 1:1 (POST_171)
                    )->ele( n = `NavigationListGroup` ns = `tnt`
                        )->a( n = `text` v = `New`
                        )->tag( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `People`
                            )->a( n = `icon` v = `sap-icon://people-connected`
                        )->ele( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Building`
                            )->a( n = `icon` v = `sap-icon://building`
                            )->tag( n = `NavigationListItem` ns = `tnt`
                                )->a( n = `text` v = `Office 01`
                            )->tag( n = `NavigationListItem` ns = `tnt`
                                )->a( n = `text` v = `Office 02`

                        )->end(
                        )->ele( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Mileage`
                            )->a( n = `icon` v = `sap-icon://mileage`
                            )->tag( n = `NavigationListItem` ns = `tnt`
                                )->a( n = `text` v = `Driven`
                            )->tag( n = `NavigationListItem` ns = `tnt`
                                )->a( n = `text`    v = `Walked`
                                )->a( n = `id`      v = `walked`
                                )->a( n = `visible` v = client->_bind( walked_visible )

                        )->end(
                    )->end(

                    )->ele( n = `NavigationListGroup` ns = `tnt`
                        )->a( n = `text` v = `Recently used`
                        )->tag( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Managing My Area`
                            )->a( n = `icon` v = `sap-icon://kpi-managing-my-area`
                        )->tag( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Flight`
                            )->a( n = `icon` v = `sap-icon://flight`
                        )->tag( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Map`
                            )->a( n = `icon` v = `sap-icon://map-2`

                    )->end(

                    )->ele( n = `NavigationListGroup` ns = `tnt`
                        )->a( n = `text`    v = `Restricted`
                        )->a( n = `enabled` v = `false`
                        )->tag( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Running`
                            )->a( n = `icon` v = `sap-icon://physical-activity`
                        )->tag( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Scissors`
                            )->a( n = `icon` v = `sap-icon://scissors`

                    )->end(

                    )->tag( n = `NavigationListItem` ns = `tnt`
                        )->a( n = `text` v = `Transport`
                        )->a( n = `icon` v = `sap-icon://passenger-train`

                )->end(

                )->ele( n = `fixedItem` ns = `tnt`
                    )->ele( n = `NavigationList` ns = `tnt`
                        )->tag( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Bar Chart`
                            )->a( n = `icon` v = `sap-icon://bar-chart`
                        " selectable is @since 1.116 - kept 1:1 (POST_171)
                        )->tag( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `selectable` v = `false`
                            )->a( n = `href`       v = `https://sap.com`
                            )->a( n = `target`     v = `_blank`
                            )->a( n = `text`       v = `External Link`
                            )->a( n = `icon`       v = `sap-icon://attachment`
                        )->tag( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `selectable` v = `false`
                            )->a( n = `href`       v = `https://sap.com`
                            )->a( n = `target`     v = `_top`
                            )->a( n = `text`       v = `External Link _top`
                            )->a( n = `icon`       v = `sap-icon://attachment`
                        )->tag( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Compare`
                            )->a( n = `icon` v = `sap-icon://compare` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `TOGGLE_EXPAND`.
        " original onCollapseExpandPress: toggles SideNavigation.expanded
        expanded = xsdbool( expanded = abap_false ).

      WHEN `TOGGLE_WALKED`.
        " original onHideShowWalkedPress: toggles the 'walked' item visibility
        walked_visible = xsdbool( walked_visible = abap_false ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
