CLASS z2ui5_cl_ai_app_221 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA selected_key1 TYPE string VALUE `invalidKey`.
    DATA selected_key2 TYPE string VALUE `invalidKey`.
    DATA selected_key3 TYPE string VALUE `invalidKey`.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_221 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
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

        )->leaf( `Text`
            )->a( n = `text`  v = `Simple IconTabHeader`
            )->a( n = `class` v = `sapUiTinyMarginTop sapUiSmallMarginBegin`

        )->open( n = `ToolHeader` ns = `tnt`
            )->a( n = `class` v = `sapUiTinyMarginTop sapUiTinyMarginEnd sapUiTinyMarginBegin`

            )->open( `Button`
                )->a( n = `icon` v = `sap-icon://home`
                " onHomePress resets the sibling IconTabHeader to 'invalidKey', i.e.
                " deselects every tab. The original finds that header by walking the
                " DOM; here each button knows it statically, and selectedKey is a
                " BINDABLE property - so the reset is a bound value, not a frontend
                " action (AGENTS "prefer a bindable property")
                )->a( n = `press` v = client->_event( val   = `HOME_PRESS`
                                                      t_arg = VALUE #( ( `1` ) ) )
                )->a( n = `type` v = `Transparent`
                )->open( `layoutData`
                    )->leaf( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `NeverOverflow`

                )->shut(
            )->shut(

            )->open( `IconTabHeader`
                )->a( n = `id`               v = `iconTabHeader`
                )->a( n = `selectedKey`      v = client->_bind( selected_key1 )
                )->a( n = `backgroundDesign` v = `Transparent`
                )->a( n = `mode`             v = `Inline`
                )->open( `layoutData`
                    )->leaf( `OverflowToolbarLayoutData`
                        )->a( n = `priority`   v = `NeverOverflow`
                        )->a( n = `shrinkable` v = `true`

                )->shut(
                )->open( `items`
                    )->leaf( `IconTabFilter`
                        )->a( n = `text` v = `Documentation`
                    )->leaf( `IconTabFilter`
                        )->a( n = `text` v = `Explored`
                    )->leaf( `IconTabFilter`
                        )->a( n = `text` v = `API Reference`
                    )->leaf( `IconTabFilter`
                        )->a( n = `text` v = `Demo Apps`

                )->shut(
            )->shut(

            )->open( `Button`
                )->a( n = `icon` v = `sap-icon://search`
                )->a( n = `type` v = `Transparent`
                )->open( `layoutData`
                    )->leaf( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `NeverOverflow`

                )->shut(
            )->shut(

            )->open( `Button`
                )->a( n = `icon` v = `sap-icon://comment`
                )->a( n = `type` v = `Transparent`
                )->open( `layoutData`
                    )->leaf( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `NeverOverflow`

                )->shut(
            )->shut(

            )->open( `MenuButton`
                )->a( n = `icon` v = `sap-icon://hint`
                )->a( n = `type` v = `Transparent`
                )->open( `layoutData`
                    )->leaf( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `NeverOverflow`

                )->shut(
                )->open( `Menu`
                    )->leaf( `MenuItem`
                        )->a( n = `text` v = `Edit`
                        )->a( n = `icon` v = `sap-icon://edit`
                    )->leaf( `MenuItem`
                        )->a( n = `text` v = `Save`
                        )->a( n = `icon` v = `sap-icon://save`

                )->shut(
            )->shut(
        )->shut(

        )->leaf( `Text`
            )->a( n = `text`  v = `IconTabHeader with one interaction for the tab - opening the sub-items list`
            )->a( n = `class` v = `sapUiLargeMarginTop sapUiSmallMarginBegin`

        )->open( n = `ToolHeader` ns = `tnt`
            )->a( n = `class` v = `sapUiTinyMargin sapUiTinyMarginTop`

            )->open( `Button`
                )->a( n = `icon` v = `sap-icon://home`
                " onHomePress resets the sibling IconTabHeader to 'invalidKey', i.e.
                " deselects every tab. The original finds that header by walking the
                " DOM; here each button knows it statically, and selectedKey is a
                " BINDABLE property - so the reset is a bound value, not a frontend
                " action (AGENTS "prefer a bindable property")
                )->a( n = `press` v = client->_event( val   = `HOME_PRESS`
                                                      t_arg = VALUE #( ( `2` ) ) )
                )->a( n = `type` v = `Transparent`
                )->open( `layoutData`
                    )->leaf( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `NeverOverflow`

                )->shut(
            )->shut(

            )->open( `IconTabHeader`
                )->a( n = `id`               v = `iconTabHeaderOneClickArea`
                )->a( n = `selectedKey`      v = client->_bind( selected_key2 )
                )->a( n = `backgroundDesign` v = `Transparent`
                )->a( n = `mode`             v = `Inline`
                )->open( `layoutData`
                    )->leaf( `OverflowToolbarLayoutData`
                        )->a( n = `priority`   v = `NeverOverflow`
                        )->a( n = `shrinkable` v = `true`

                )->shut(
                )->open( `items`
                    )->open( `IconTabFilter`
                        )->a( n = `text`            v = `Users`
                        )->a( n = `interactionMode` v = `SelectLeavesOnly`
                        )->open( `items`
                            )->leaf( `IconTabFilter`
                                )->a( n = `text` v = `User 1`
                            )->leaf( `IconTabFilter`
                                )->a( n = `text` v = `User 2`
                            )->leaf( `IconTabFilter`
                                )->a( n = `text` v = `User 3`

                        )->shut(
                    )->shut(

                    )->open( `IconTabFilter`
                        )->a( n = `text`            v = `Identity`
                        )->a( n = `interactionMode` v = `SelectLeavesOnly`
                        )->open( `items`
                            )->leaf( `IconTabFilter`
                                )->a( n = `text` v = `Identity 1`
                            )->leaf( `IconTabFilter`
                                )->a( n = `text` v = `Identity 2`
                            )->leaf( `IconTabFilter`
                                )->a( n = `text` v = `Identity 3`
                            )->leaf( `IconTabFilter`
                                )->a( n = `text` v = `Identity 4`
                            )->leaf( `IconTabFilter`
                                )->a( n = `text` v = `Identity 5`

                        )->shut(
                    )->shut(

                    )->open( `IconTabFilter`
                        )->a( n = `text`            v = `Monitoring`
                        )->a( n = `interactionMode` v = `SelectLeavesOnly`
                        )->open( `items`
                            )->leaf( `IconTabFilter`
                                )->a( n = `text` v = `Monitoring 1`
                            )->leaf( `IconTabFilter`
                                )->a( n = `text` v = `Monitoring 2`
                            )->leaf( `IconTabFilter`
                                )->a( n = `text` v = `Monitoring 3`

                        )->shut(
                    )->shut(
                )->shut(
            )->shut(

            )->open( `Button`
                )->a( n = `icon` v = `sap-icon://search`
                )->a( n = `type` v = `Transparent`
                )->open( `layoutData`
                    )->leaf( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `NeverOverflow`

                )->shut(
            )->shut(

            )->open( `Button`
                )->a( n = `icon` v = `sap-icon://comment`
                )->a( n = `type` v = `Transparent`
                )->open( `layoutData`
                    )->leaf( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `NeverOverflow`

                )->shut(
            )->shut(

            )->open( `MenuButton`
                )->a( n = `icon` v = `sap-icon://hint`
                )->a( n = `type` v = `Transparent`
                )->open( `layoutData`
                    )->leaf( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `NeverOverflow`

                )->shut(
                )->open( `Menu`
                    )->leaf( `MenuItem`
                        )->a( n = `text` v = `Edit`
                        )->a( n = `icon` v = `sap-icon://edit`
                    )->leaf( `MenuItem`
                        )->a( n = `text` v = `Save`
                        )->a( n = `icon` v = `sap-icon://save`

                )->shut(
            )->shut(
        )->shut(

        )->leaf( `Text`
            )->a( n = `text`  v = `IconTabHeader with two interaction areas for the tab - selecting it or opening the sub-items list`
            )->a( n = `class` v = `sapUiLargeMarginTop sapUiSmallMarginBegin`

        )->open( n = `ToolHeader` ns = `tnt`
            )->a( n = `class` v = `sapUiTinyMargin sapUiTinyMarginTop`

            )->open( `Button`
                )->a( n = `icon` v = `sap-icon://home`
                " onHomePress resets the sibling IconTabHeader to 'invalidKey', i.e.
                " deselects every tab. The original finds that header by walking the
                " DOM; here each button knows it statically, and selectedKey is a
                " BINDABLE property - so the reset is a bound value, not a frontend
                " action (AGENTS "prefer a bindable property")
                )->a( n = `press` v = client->_event( val   = `HOME_PRESS`
                                                      t_arg = VALUE #( ( `3` ) ) )
                )->a( n = `type` v = `Transparent`
                )->open( `layoutData`
                    )->leaf( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `NeverOverflow`

                )->shut(
            )->shut(

            )->open( `IconTabHeader`
                )->a( n = `id`               v = `iconTabHeaderTwoClickArea`
                )->a( n = `selectedKey`      v = client->_bind( selected_key3 )
                )->a( n = `backgroundDesign` v = `Transparent`
                )->a( n = `mode`             v = `Inline`
                )->open( `layoutData`
                    )->leaf( `OverflowToolbarLayoutData`
                        )->a( n = `priority`   v = `NeverOverflow`
                        )->a( n = `shrinkable` v = `true`

                )->shut(
                )->open( `items`
                    )->open( `IconTabFilter`
                        )->a( n = `text` v = `Users`
                        )->open( `items`
                            )->leaf( `IconTabFilter`
                                )->a( n = `text` v = `User 1`
                            )->leaf( `IconTabFilter`
                                )->a( n = `text` v = `User 2`
                            )->leaf( `IconTabFilter`
                                )->a( n = `text` v = `User 3`

                        )->shut(
                    )->shut(

                    )->open( `IconTabFilter`
                        )->a( n = `text` v = `Identity`
                        )->open( `items`
                            )->leaf( `IconTabFilter`
                                )->a( n = `text` v = `Identity 1`
                            )->leaf( `IconTabFilter`
                                )->a( n = `text` v = `Identity 2`
                            )->leaf( `IconTabFilter`
                                )->a( n = `text` v = `Identity 3`
                            )->leaf( `IconTabFilter`
                                )->a( n = `text` v = `Identity 4`
                            )->leaf( `IconTabFilter`
                                )->a( n = `text` v = `Identity 5`

                        )->shut(
                    )->shut(

                    )->open( `IconTabFilter`
                        )->a( n = `text` v = `Monitoring`
                        )->open( `items`
                            )->leaf( `IconTabFilter`
                                )->a( n = `text` v = `Monitoring 1`
                            )->leaf( `IconTabFilter`
                                )->a( n = `text` v = `Monitoring 2`
                            )->leaf( `IconTabFilter`
                                )->a( n = `text` v = `Monitoring 3`

                        )->shut(
                    )->shut(
                )->shut(
            )->shut(

            )->open( `Button`
                )->a( n = `icon` v = `sap-icon://search`
                )->a( n = `type` v = `Transparent`
                )->open( `layoutData`
                    )->leaf( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `NeverOverflow`

                )->shut(
            )->shut(

            )->open( `Button`
                )->a( n = `icon` v = `sap-icon://comment`
                )->a( n = `type` v = `Transparent`
                )->open( `layoutData`
                    )->leaf( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `NeverOverflow`

                )->shut(
            )->shut(

            )->open( `MenuButton`
                )->a( n = `icon` v = `sap-icon://hint`
                )->a( n = `type` v = `Transparent`
                )->open( `layoutData`
                    )->leaf( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `NeverOverflow`

                )->shut(
                )->open( `Menu`
                    )->leaf( `MenuItem`
                        )->a( n = `text` v = `Edit`
                        )->a( n = `icon` v = `sap-icon://edit`
                    )->leaf( `MenuItem`
                        )->a( n = `text` v = `Save`
                        )->a( n = `icon` v = `sap-icon://save`

                )->shut(
            )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `HOME_PRESS`.
        CASE client->get_event_arg( ).
          WHEN `1`.
            selected_key1 = `invalidKey`.
          WHEN `2`.
            selected_key2 = `invalidKey`.
          WHEN OTHERS.
            selected_key3 = `invalidKey`.
        ENDCASE.
        client->view_model_update( ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
