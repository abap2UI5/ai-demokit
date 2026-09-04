" @keywords toolheader tool header sap.tnt toolheadericontabheader text button overflowtoolbarlayoutdata icontabheader icontabfilter menubutton menu
" @summary ToolHeader can contain IconTabHeader. When both controls are combined, the IconTabHeader supports only inline text. No icons can be used.
CLASS z2ui5_cl_smpc_app_221 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_smpc_app_221 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:tnt` v = `sap.tnt`
        )->a( n = `height`    v = `100%`

        )->tag( `Text`
            )->a( n = `text`  v = `Simple IconTabHeader`
            )->a( n = `class` v = `sapUiTinyMarginTop sapUiSmallMarginBegin`

        )->ele( n = `ToolHeader` ns = `tnt`
            )->a( n = `class` v = `sapUiTinyMarginTop sapUiTinyMarginEnd sapUiTinyMarginBegin`

            )->ele( `Button`
                )->a( n = `icon` v = `sap-icon://home`
                " onHomePress resets the sibling IconTabHeader to 'invalidKey', i.e.
                " deselects every tab. The original finds that header by walking the
                " DOM; here each button knows it statically, and selectedKey is a
                " BINDABLE property - so the reset is a bound value, not a frontend
                " action (the recipe's "prefer a bindable property" rule)
                )->a( n = `press` v = client->_event( val = `HOME_PRESS` arg = `1` )
                )->a( n = `type` v = `Transparent`
                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `NeverOverflow`

                )->end(
            )->end(

            )->ele( `IconTabHeader`
                )->a( n = `id`               v = `iconTabHeader`
                )->a( n = `selectedKey`      v = client->_bind( selected_key1 )
                )->a( n = `backgroundDesign` v = `Transparent`
                )->a( n = `mode`             v = `Inline`
                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `priority`   v = `NeverOverflow`
                        )->a( n = `shrinkable` v = `true`

                )->end(
                )->ele( `items`
                    )->tag( `IconTabFilter`
                        )->a( n = `text` v = `Documentation`
                    )->tag( `IconTabFilter`
                        )->a( n = `text` v = `Explored`
                    )->tag( `IconTabFilter`
                        )->a( n = `text` v = `API Reference`
                    )->tag( `IconTabFilter`
                        )->a( n = `text` v = `Demo Apps`

                )->end(
            )->end(

            )->ele( `Button`
                )->a( n = `icon` v = `sap-icon://search`
                )->a( n = `type` v = `Transparent`
                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `NeverOverflow`

                )->end(
            )->end(

            )->ele( `Button`
                )->a( n = `icon` v = `sap-icon://comment`
                )->a( n = `type` v = `Transparent`
                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `NeverOverflow`

                )->end(
            )->end(

            )->ele( `MenuButton`
                )->a( n = `icon` v = `sap-icon://hint`
                )->a( n = `type` v = `Transparent`
                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `NeverOverflow`

                )->end(
                )->ele( `Menu`
                    )->tag( `MenuItem`
                        )->a( n = `text` v = `Edit`
                        )->a( n = `icon` v = `sap-icon://edit`
                    )->tag( `MenuItem`
                        )->a( n = `text` v = `Save`
                        )->a( n = `icon` v = `sap-icon://save`

                )->end(
            )->end(
        )->end(

        )->tag( `Text`
            )->a( n = `text`  v = `IconTabHeader with one interaction for the tab - opening the sub-items list`
            )->a( n = `class` v = `sapUiLargeMarginTop sapUiSmallMarginBegin`

        )->ele( n = `ToolHeader` ns = `tnt`
            )->a( n = `class` v = `sapUiTinyMargin sapUiTinyMarginTop`

            )->ele( `Button`
                )->a( n = `icon` v = `sap-icon://home`
                " onHomePress resets the sibling IconTabHeader to 'invalidKey', i.e.
                " deselects every tab. The original finds that header by walking the
                " DOM; here each button knows it statically, and selectedKey is a
                " BINDABLE property - so the reset is a bound value, not a frontend
                " action (the recipe's "prefer a bindable property" rule)
                )->a( n = `press` v = client->_event( val = `HOME_PRESS` arg = `2` )
                )->a( n = `type` v = `Transparent`
                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `NeverOverflow`

                )->end(
            )->end(

            )->ele( `IconTabHeader`
                )->a( n = `id`               v = `iconTabHeaderOneClickArea`
                )->a( n = `selectedKey`      v = client->_bind( selected_key2 )
                )->a( n = `backgroundDesign` v = `Transparent`
                )->a( n = `mode`             v = `Inline`
                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `priority`   v = `NeverOverflow`
                        )->a( n = `shrinkable` v = `true`

                )->end(
                )->ele( `items`
                    )->ele( `IconTabFilter`
                        )->a( n = `text`            v = `Users`
                        )->a( n = `interactionMode` v = `SelectLeavesOnly`
                        )->ele( `items`
                            )->tag( `IconTabFilter`
                                )->a( n = `text` v = `User 1`
                            )->tag( `IconTabFilter`
                                )->a( n = `text` v = `User 2`
                            )->tag( `IconTabFilter`
                                )->a( n = `text` v = `User 3`

                        )->end(
                    )->end(

                    )->ele( `IconTabFilter`
                        )->a( n = `text`            v = `Identity`
                        )->a( n = `interactionMode` v = `SelectLeavesOnly`
                        )->ele( `items`
                            )->tag( `IconTabFilter`
                                )->a( n = `text` v = `Identity 1`
                            )->tag( `IconTabFilter`
                                )->a( n = `text` v = `Identity 2`
                            )->tag( `IconTabFilter`
                                )->a( n = `text` v = `Identity 3`
                            )->tag( `IconTabFilter`
                                )->a( n = `text` v = `Identity 4`
                            )->tag( `IconTabFilter`
                                )->a( n = `text` v = `Identity 5`

                        )->end(
                    )->end(

                    )->ele( `IconTabFilter`
                        )->a( n = `text`            v = `Monitoring`
                        )->a( n = `interactionMode` v = `SelectLeavesOnly`
                        )->ele( `items`
                            )->tag( `IconTabFilter`
                                )->a( n = `text` v = `Monitoring 1`
                            )->tag( `IconTabFilter`
                                )->a( n = `text` v = `Monitoring 2`
                            )->tag( `IconTabFilter`
                                )->a( n = `text` v = `Monitoring 3`

                        )->end(
                    )->end(
                )->end(
            )->end(

            )->ele( `Button`
                )->a( n = `icon` v = `sap-icon://search`
                )->a( n = `type` v = `Transparent`
                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `NeverOverflow`

                )->end(
            )->end(

            )->ele( `Button`
                )->a( n = `icon` v = `sap-icon://comment`
                )->a( n = `type` v = `Transparent`
                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `NeverOverflow`

                )->end(
            )->end(

            )->ele( `MenuButton`
                )->a( n = `icon` v = `sap-icon://hint`
                )->a( n = `type` v = `Transparent`
                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `NeverOverflow`

                )->end(
                )->ele( `Menu`
                    )->tag( `MenuItem`
                        )->a( n = `text` v = `Edit`
                        )->a( n = `icon` v = `sap-icon://edit`
                    )->tag( `MenuItem`
                        )->a( n = `text` v = `Save`
                        )->a( n = `icon` v = `sap-icon://save`

                )->end(
            )->end(
        )->end(

        )->tag( `Text`
            )->a( n = `text`  v = `IconTabHeader with two interaction areas for the tab - selecting it or opening the sub-items list`
            )->a( n = `class` v = `sapUiLargeMarginTop sapUiSmallMarginBegin`

        )->ele( n = `ToolHeader` ns = `tnt`
            )->a( n = `class` v = `sapUiTinyMargin sapUiTinyMarginTop`

            )->ele( `Button`
                )->a( n = `icon` v = `sap-icon://home`
                " onHomePress resets the sibling IconTabHeader to 'invalidKey', i.e.
                " deselects every tab. The original finds that header by walking the
                " DOM; here each button knows it statically, and selectedKey is a
                " BINDABLE property - so the reset is a bound value, not a frontend
                " action (the recipe's "prefer a bindable property" rule)
                )->a( n = `press` v = client->_event( val = `HOME_PRESS` arg = `3` )
                )->a( n = `type` v = `Transparent`
                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `NeverOverflow`

                )->end(
            )->end(

            )->ele( `IconTabHeader`
                )->a( n = `id`               v = `iconTabHeaderTwoClickArea`
                )->a( n = `selectedKey`      v = client->_bind( selected_key3 )
                )->a( n = `backgroundDesign` v = `Transparent`
                )->a( n = `mode`             v = `Inline`
                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `priority`   v = `NeverOverflow`
                        )->a( n = `shrinkable` v = `true`

                )->end(
                )->ele( `items`
                    )->ele( `IconTabFilter`
                        )->a( n = `text` v = `Users`
                        )->ele( `items`
                            )->tag( `IconTabFilter`
                                )->a( n = `text` v = `User 1`
                            )->tag( `IconTabFilter`
                                )->a( n = `text` v = `User 2`
                            )->tag( `IconTabFilter`
                                )->a( n = `text` v = `User 3`

                        )->end(
                    )->end(

                    )->ele( `IconTabFilter`
                        )->a( n = `text` v = `Identity`
                        )->ele( `items`
                            )->tag( `IconTabFilter`
                                )->a( n = `text` v = `Identity 1`
                            )->tag( `IconTabFilter`
                                )->a( n = `text` v = `Identity 2`
                            )->tag( `IconTabFilter`
                                )->a( n = `text` v = `Identity 3`
                            )->tag( `IconTabFilter`
                                )->a( n = `text` v = `Identity 4`
                            )->tag( `IconTabFilter`
                                )->a( n = `text` v = `Identity 5`

                        )->end(
                    )->end(

                    )->ele( `IconTabFilter`
                        )->a( n = `text` v = `Monitoring`
                        )->ele( `items`
                            )->tag( `IconTabFilter`
                                )->a( n = `text` v = `Monitoring 1`
                            )->tag( `IconTabFilter`
                                )->a( n = `text` v = `Monitoring 2`
                            )->tag( `IconTabFilter`
                                )->a( n = `text` v = `Monitoring 3`

                        )->end(
                    )->end(
                )->end(
            )->end(

            )->ele( `Button`
                )->a( n = `icon` v = `sap-icon://search`
                )->a( n = `type` v = `Transparent`
                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `NeverOverflow`

                )->end(
            )->end(

            )->ele( `Button`
                )->a( n = `icon` v = `sap-icon://comment`
                )->a( n = `type` v = `Transparent`
                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `NeverOverflow`

                )->end(
            )->end(

            )->ele( `MenuButton`
                )->a( n = `icon` v = `sap-icon://hint`
                )->a( n = `type` v = `Transparent`
                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `NeverOverflow`

                )->end(
                )->ele( `Menu`
                    )->tag( `MenuItem`
                        )->a( n = `text` v = `Edit`
                        )->a( n = `icon` v = `sap-icon://edit`
                    )->tag( `MenuItem`
                        )->a( n = `text` v = `Save`
                        )->a( n = `icon` v = `sap-icon://save`

                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `HOME_PRESS`.
      CASE client->get_event_arg( ).
        WHEN `1`.
          selected_key1 = `invalidKey`.
        WHEN `2`.
          selected_key2 = `invalidKey`.
        WHEN OTHERS.
          selected_key3 = `invalidKey`.
      ENDCASE.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
