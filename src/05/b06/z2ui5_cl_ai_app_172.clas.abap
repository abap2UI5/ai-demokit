CLASS z2ui5_cl_ai_app_172 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA expanded TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_172 IMPLEMENTATION.

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

            )->leaf( `Button`
                )->a( n = `text`  v = `Toggle Collapse/Expand`
                )->a( n = `icon`  v = `sap-icon://menu2`
                )->a( n = `press` v = client->_event( `TOGGLE_EXPAND` )

            )->open( n = `SideNavigation` ns = `tnt`
                )->a( n = `id`          v = `sideNavigation`
                )->a( n = `selectedKey` v = `walked`
                )->a( n = `expanded`    v = client->_bind( expanded )
                )->a( n = `itemSelect`  v = client->_event_client( val   = client->cs_event-control_global
                                                                   t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Item selected: {0}` ) ( `${$parameters>/item}.getText()` ) ) )

                )->open( n = `NavigationList` ns = `tnt`
                    )->open( n = `NavigationListItem` ns = `tnt`
                        )->a( n = `text`       v = `Building`
                        )->a( n = `icon`       v = `sap-icon://building`
                        )->a( n = `selectable` v = `false`
                        )->leaf( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Office 01`
                        )->leaf( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Office 02`

                    )->shut(
                    )->open( n = `NavigationListItem` ns = `tnt`
                        )->a( n = `text`       v = `Mileage`
                        )->a( n = `icon`       v = `sap-icon://mileage`
                        )->a( n = `selectable` v = `false`
                        )->leaf( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Driven`
                        )->leaf( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Walked`
                            )->a( n = `id`   v = `walked`

                    )->shut(
                    )->open( n = `NavigationListItem` ns = `tnt`
                        )->a( n = `text`       v = `Transport`
                        )->a( n = `icon`       v = `sap-icon://map-2`
                        )->a( n = `selectable` v = `false`
                        )->leaf( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Flight`
                        )->leaf( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Train`
                        )->leaf( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Taxi`

                    )->shut(
                )->shut(

                )->open( n = `fixedItem` ns = `tnt`
                    )->open( n = `NavigationList` ns = `tnt`
                        )->leaf( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Bar Chart`
                            )->a( n = `icon` v = `sap-icon://bar-chart`
                        )->leaf( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `selectable` v = `false`
                            )->a( n = `href`       v = `https://sap.com`
                            )->a( n = `target`     v = `_blank`
                            )->a( n = `text`       v = `External Link`
                            )->a( n = `icon`       v = `sap-icon://attachment`
                        )->leaf( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Compare`
                            )->a( n = `icon` v = `sap-icon://compare` ).

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
