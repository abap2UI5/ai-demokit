CLASS z2ui5_cl_dmo_app_300 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA expanded    TYPE abap_bool.
    DATA create_name TYPE string.
    DATA create_icon TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popup_quickcreate_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_dmo_app_300 IMPLEMENTATION.

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
                )->a( n = `width`       v = `20rem`
                )->a( n = `id`          v = `sideNavigation`
                )->a( n = `selectedKey` v = `home`
                )->a( n = `expanded`    v = client->_bind( expanded )

                )->open( n = `NavigationList` ns = `tnt`
                    )->leaf( n = `NavigationListItem` ns = `tnt`
                        )->a( n = `text` v = `Home`
                        )->a( n = `key`  v = `home`
                        )->a( n = `icon` v = `sap-icon://home`

                    " NavigationListGroup is a control @since 1.121 - kept 1:1 (POST_171)
                    )->open( n = `NavigationListGroup` ns = `tnt`
                        )->a( n = `text` v = `System & Administration Management`

                        )->leaf( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Business Analytics`
                            )->a( n = `icon` v = `sap-icon://bar-chart`
                        " selectable is @since 1.116 - kept 1:1 (POST_171)
                        )->leaf( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text`       v = `SAP Training Portal and Learning Management System`
                            )->a( n = `icon`       v = `sap-icon://course-book`
                            )->a( n = `href`       v = `https://sap.com`
                            )->a( n = `target`     v = `_blank`
                            )->a( n = `selectable` v = `false`

                        )->open( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `System Administration and Configuration Management`
                            )->a( n = `icon` v = `sap-icon://manager-insight`

                            )->leaf( n = `NavigationListItem` ns = `tnt`
                                )->a( n = `text` v = `User Management and Access Control Administration`
                            )->leaf( n = `NavigationListItem` ns = `tnt`
                                )->a( n = `text` v = `Audit Log and Security Monitoring Dashboard`

                        )->shut(
                        )->open( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text`       v = `Service Management and Customer Support Operations`
                            )->a( n = `icon`       v = `sap-icon://customer-and-supplier`
                            )->a( n = `expanded`   v = `false`
                            )->a( n = `selectable` v = `false`

                            )->leaf( n = `NavigationListItem` ns = `tnt`
                                )->a( n = `text` v = `Service Tickets and Customer Issue Resolution`
                            )->leaf( n = `NavigationListItem` ns = `tnt`
                                )->a( n = `text` v = `Field Service`
                            )->leaf( n = `NavigationListItem` ns = `tnt`
                                )->a( n = `text` v = `Service Contracts and Agreement Management`

                        )->shut(
                        )->open( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text`       v = `Financial Reports`
                            )->a( n = `icon`       v = `sap-icon://money-bills`
                            )->a( n = `expanded`   v = `false`
                            )->a( n = `selectable` v = `false`

                            )->leaf( n = `NavigationListItem` ns = `tnt`
                                )->a( n = `text` v = `Sales Reports`
                            )->leaf( n = `NavigationListItem` ns = `tnt`
                                )->a( n = `text` v = `Customer Analysis Reports and Behavioral Insights`

                        )->shut(

                        )->leaf( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Notifications and Alerts`
                            )->a( n = `icon` v = `sap-icon://message-information`

                    )->shut(

                    )->open( n = `NavigationListGroup` ns = `tnt`
                        )->a( n = `text` v = `Business operations`

                        )->leaf( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Resource Planning and Business Management Solutions My Area`
                            )->a( n = `icon` v = `sap-icon://business-one`
                        )->leaf( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Sales Management and Revenue Operations`
                            )->a( n = `icon` v = `sap-icon://crm-sales`
                        )->leaf( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `SAP Best Practices`
                            )->a( n = `icon` v = `sap-icon://learning-assistant`

                        )->open( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text`       v = `Customer Relationship Management`
                            )->a( n = `icon`       v = `sap-icon://account`
                            )->a( n = `selectable` v = `false`

                            )->leaf( n = `NavigationListItem` ns = `tnt`
                                )->a( n = `text` v = `Contact Information and Communication History`
                            )->leaf( n = `NavigationListItem` ns = `tnt`
                                )->a( n = `text` v = `Business Partners`
                            )->leaf( n = `NavigationListItem` ns = `tnt`
                                )->a( n = `text` v = `Strategic Relationships`

                        )->shut(
                    )->shut(
                )->shut(

                )->open( n = `fixedItem` ns = `tnt`
                    )->open( n = `NavigationList` ns = `tnt`
                        )->leaf( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `ariaHasPopup` v = `Dialog`
                            )->a( n = `id`           v = `quickCreate`
                            )->a( n = `press`        v = client->_event( `QUICK_CREATE` )
                            )->a( n = `text`         v = `Quick Create`
                            )->a( n = `icon`         v = `sap-icon://write-new`
                            )->a( n = `design`       v = `Action`
                            )->a( n = `selectable`   v = `false`
                        )->leaf( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `text` v = `Settings`
                            )->a( n = `icon` v = `sap-icon://settings`
                        )->leaf( n = `NavigationListItem` ns = `tnt`
                            )->a( n = `selectable` v = `false`
                            )->a( n = `href`       v = `https://sap.com`
                            )->a( n = `target`     v = `_blank`
                            )->a( n = `text`       v = `SAP Support`
                            )->a( n = `icon`       v = `sap-icon://attachment` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `TOGGLE_EXPAND`.
        " original onCollapseExpandPress: toggles SideNavigation.expanded
        expanded = xsdbool( expanded = abap_false ).
        client->view_model_update( ).

      WHEN `QUICK_CREATE`.
        popup_quickcreate_display( ).

      WHEN `CREATE_ITEM`.
        " the original Create button appends a NavigationListItem to the main
        " NavigationList; that aggregation mixes NavigationListItem and
        " NavigationListGroup children here, which one bound template cannot
        " express - the 24 static items stay 1:1 and Create only closes the
        " dialog (declared IMPROVISED deviation)
        client->popup_destroy( ).

    ENDCASE.

  ENDMETHOD.


  METHOD popup_quickcreate_display.

    " original quickActionPress builds this Dialog imperatively (new Dialog({...}).open());
    " expressed as a core:FragmentDefinition shown via popup_display (declared deviation)
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
