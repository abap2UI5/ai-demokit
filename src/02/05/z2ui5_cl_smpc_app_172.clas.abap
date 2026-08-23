" @keywords sidenavigation side navigation sap.tnt sidenavigationunselectableparents vbox button navigationlist navigationlistitem
" @summary SideNavigation with unselectable parent items.
CLASS z2ui5_cl_smpc_app_172 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA expanded TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_172 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      expanded = abap_false.
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
                )->a( n = `itemSelect`  v = client->follow_up_action( val   = client->cs_event-control_global
                                                                      t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Item selected: {0}` ) ( `${$parameters>/item}.getText()` ) ) )

                )->ele( n = `NavigationList` ns = `tnt`
                    )->ele( n = `NavigationListItem` ns = `tnt`
                        )->a( n = `text`       v = `Building`
                        )->a( n = `icon`       v = `sap-icon://building`
                        )->a( n = `selectable` v = `false`
                        )->tag( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Office 01`
                        )->tag( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Office 02`

                    )->end(
                    )->ele( n = `NavigationListItem` ns = `tnt`
                        )->a( n = `text`       v = `Mileage`
                        )->a( n = `icon`       v = `sap-icon://mileage`
                        )->a( n = `selectable` v = `false`
                        )->tag( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Driven`
                        )->tag( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Walked`
                            )->a( n = `id`   v = `walked`

                    )->end(
                    )->ele( n = `NavigationListItem` ns = `tnt`
                        )->a( n = `text`       v = `Transport`
                        )->a( n = `icon`       v = `sap-icon://map-2`
                        )->a( n = `selectable` v = `false`
                        )->tag( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Flight`
                        )->tag( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Train`
                        )->tag( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Taxi`

                    )->end(
                )->end(

                )->ele( n = `fixedItem` ns = `tnt`
                    )->ele( n = `NavigationList` ns = `tnt`
                        )->tag( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Bar Chart`
                            )->a( n = `icon` v = `sap-icon://bar-chart`
                        )->tag( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `selectable` v = `false`
                            )->a( n = `href`       v = `https://sap.com`
                            )->a( n = `target`     v = `_blank`
                            )->a( n = `text`       v = `External Link`
                            )->a( n = `icon`       v = `sap-icon://attachment`
                        )->tag( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Compare`
                            )->a( n = `icon` v = `sap-icon://compare` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `TOGGLE_EXPAND`.
      " original onCollapseExpandPress: toggles SideNavigation.expanded
      expanded = xsdbool( expanded = abap_false ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
