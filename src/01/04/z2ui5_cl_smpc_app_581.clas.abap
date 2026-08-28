" @keywords gridlist grid list sap.f gridlistboxcontainerreal toolbar title gridboxlayout vbox flexitemdata label text
" @summary This is a sample for GridList item templates representing a typical tools page dashboard style.
CLASS z2ui5_cl_smpc_app_581 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS list_toolbars_add IMPORTING panel TYPE REF TO z2ui5_cl_ui5_view_builder.
    METHODS list_icons_add    IMPORTING panel TYPE REF TO z2ui5_cl_ui5_view_builder.
    METHODS list_status_add   IMPORTING panel TYPE REF TO z2ui5_cl_ui5_view_builder.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_581 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    DATA(root) = view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:grid` v = `sap.ui.layout.cssgrid`
        )->a( n = `xmlns:f`    v = `sap.f`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:t`    v = `sap.tnt` ).

    " the Reveal Grid toggle keeps its label but not its press - the sample's own
    " RevealGrid helper is a JavaScript overlay with no backend side (see sidecar)
    root->tag( `ToggleButton`
        )->a( n = `id`    v = `revealGrid`
        )->a( n = `text`  v = `Reveal Grid`
        )->a( n = `class` v = `sapUiSmallMargin` ).

    DATA(panel) = root->ele( `Panel`
        )->a( n = `width`            v = `100%`
        )->a( n = `backgroundDesign` v = `Transparent`

        )->ele( `headerToolbar`
            )->ele( `Toolbar`
                )->a( n = `height` v = `3rem`
                )->tag( `Title`
                    )->a( n = `text` v = `Recommended designs for content, used in the GridList`
            )->end(
        )->end( ).

    list_toolbars_add( panel ).
    list_icons_add( panel ).
    list_status_add( panel ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD list_toolbars_add.

    DATA(list) = panel->ele( n = `GridList` ns = `f`
        )->a( n = `id`         v = `gridList1`
        )->a( n = `headerText` v = `GridList, using GridBoxLayout - Toolbar Designs (boxWidth 15rem)`

        )->ele( n = `customLayout` ns = `f`
            )->tag( n = `GridBoxLayout` ns = `grid`
                )->a( n = `boxWidth` v = `15rem`
        )->end( ).

    " first box - the Solid toolbar carries sapContrast on top of the design
    list->ele( n = `GridListItem` ns = `f`
        )->ele( `VBox`
            )->a( n = `height`         v = `100%`
            )->a( n = `justifyContent` v = `SpaceBetween`

            )->ele( `layoutData`
                " do not shrink below the minimum size, fill the space if available
                )->tag( `FlexItemData`
                    )->a( n = `growFactor`   v = `1`
                    )->a( n = `shrinkFactor` v = `0`
            )->end(

            )->ele( `VBox`
                )->a( n = `class` v = `sapUiSmallMargin`
                )->tag( `Title`
                    )->a( n = `text`     v = `Title`
                    )->a( n = `wrapping` v = `true`
                )->tag( `Label`
                    )->a( n = `text`     v = `Subtitle`
                    )->a( n = `wrapping` v = `true`
                    )->a( n = `class`    v = `sapUiTinyMarginBottom`
                )->tag( `Text`
                    )->a( n = `text`     v = `A great description with useful information about this project. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy.`
                    )->a( n = `wrapping` v = `true`
            )->end(

            )->ele( `OverflowToolbar`
                )->a( n = `design` v = `Solid`
                )->a( n = `class`  v = `sapContrast`
                )->tag( `ToolbarSpacer`
                )->tag( `Button`
                    )->a( n = `text` v = `Edit`
                    )->a( n = `type` v = `Transparent`
                )->tag( `Button`
                    )->a( n = `icon`    v = `sap-icon://sort`
                    )->a( n = `type`    v = `Transparent`
                    )->a( n = `tooltip` v = `Sort`
                )->tag( `Button`
                    )->a( n = `icon`    v = `sap-icon://group-2`
                    )->a( n = `type`    v = `Transparent`
                    )->a( n = `tooltip` v = `Group`
            )->end(
        )->end(
    )->end( ).

    " second box - the same content with a plain Solid toolbar
    list->ele( n = `GridListItem` ns = `f`
        )->ele( `VBox`
            )->a( n = `height`         v = `100%`
            )->a( n = `justifyContent` v = `SpaceBetween`

            )->ele( `layoutData`
                )->tag( `FlexItemData`
                    )->a( n = `growFactor`   v = `1`
                    )->a( n = `shrinkFactor` v = `0`
            )->end(

            )->ele( `VBox`
                )->a( n = `class` v = `sapUiSmallMargin`
                )->tag( `Title`
                    )->a( n = `text`     v = `Title`
                    )->a( n = `wrapping` v = `true`
                )->tag( `Label`
                    )->a( n = `text`     v = `Subtitle`
                    )->a( n = `wrapping` v = `true`
                    )->a( n = `class`    v = `sapUiTinyMarginBottom`
                )->tag( `Text`
                    )->a( n = `text`     v = `A great description with useful information about this project.`
                    )->a( n = `wrapping` v = `true`
            )->end(

            )->ele( `OverflowToolbar`
                )->a( n = `design` v = `Solid`
                )->tag( `ToolbarSpacer`
                )->tag( `Button`
                    )->a( n = `text` v = `Edit`
                    )->a( n = `type` v = `Transparent`
                )->tag( `Button`
                    )->a( n = `icon`    v = `sap-icon://sort`
                    )->a( n = `type`    v = `Transparent`
                    )->a( n = `tooltip` v = `Sort`
                )->tag( `Button`
                    )->a( n = `icon`    v = `sap-icon://group-2`
                    )->a( n = `type`    v = `Transparent`
                    )->a( n = `tooltip` v = `Group`
            )->end(
        )->end(
    )->end( ).

    " third box - the wrapping texts and a Transparent toolbar
    list->ele( n = `GridListItem` ns = `f`
        )->ele( `VBox`
            )->a( n = `height`         v = `100%`
            )->a( n = `justifyContent` v = `SpaceBetween`

            )->ele( `layoutData`
                )->tag( `FlexItemData`
                    )->a( n = `growFactor`   v = `1`
                    )->a( n = `shrinkFactor` v = `0`
            )->end(

            )->ele( `VBox`
                )->a( n = `class` v = `sapUiSmallMargin`
                )->tag( `Title`
                    )->a( n = `text`     v = `Very long Box title that should wrap`
                    )->a( n = `wrapping` v = `true`
                )->tag( `Label`
                    )->a( n = `text`     v = `Very long Subtitle`
                    )->a( n = `wrapping` v = `true`
                    )->a( n = `class`    v = `sapUiTinyMarginBottom`
                )->tag( `Text`
                    )->a( n = `text`     v = `A great description with useful information about this project.`
                    )->a( n = `wrapping` v = `true`
            )->end(

            )->ele( `OverflowToolbar`
                )->a( n = `design` v = `Transparent`
                )->tag( `ToolbarSpacer`
                )->tag( `Button`
                    )->a( n = `text` v = `Edit`
                    )->a( n = `type` v = `Transparent`
                )->tag( `Button`
                    )->a( n = `icon`    v = `sap-icon://sort`
                    )->a( n = `type`    v = `Transparent`
                    )->a( n = `tooltip` v = `Sort`
                )->tag( `Button`
                    )->a( n = `icon`    v = `sap-icon://group-2`
                    )->a( n = `type`    v = `Transparent`
                    )->a( n = `tooltip` v = `Group`
            )->end(
        )->end(
    )->end( ).

  ENDMETHOD.


  METHOD list_icons_add.

    DATA(list) = panel->ele( n = `GridList` ns = `f`
        )->a( n = `id`         v = `gridList2`
        )->a( n = `headerText` v = `GridList, using GridBoxLayout - with Icons (boxWidth 22.5rem)`

        )->ele( n = `customLayout` ns = `f`
            )->tag( n = `GridBoxLayout` ns = `grid`
                )->a( n = `boxWidth` v = `22.5rem`
        )->end( ).

    list->ele( n = `GridListItem` ns = `f`
        )->ele( `VBox`
            )->a( n = `height` v = `100%`
            )->a( n = `class`  v = `sapUiSmallMargin`

            )->ele( `layoutData`
                )->tag( `FlexItemData`
                    )->a( n = `growFactor`   v = `1`
                    )->a( n = `shrinkFactor` v = `0`
            )->end(

            )->tag( n = `Icon` ns = `core`
                )->a( n = `src`   v = `sap-icon://activities`
                )->a( n = `size`  v = `2.625rem`
                )->a( n = `color` v = `Default`
                )->a( n = `class` v = `sapUiTinyMarginBottom`
            )->tag( `Title`
                )->a( n = `text`     v = `Title`
                )->a( n = `wrapping` v = `true`
            )->tag( `Text`
                )->a( n = `text`     v = `A great description with useful information about this project. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy.`
                )->a( n = `wrapping` v = `true`
        )->end(
    )->end( ).

    list->ele( n = `GridListItem` ns = `f`
        )->ele( `VBox`
            )->a( n = `height` v = `100%`
            )->a( n = `class`  v = `sapUiSmallMargin`

            )->ele( `layoutData`
                )->tag( `FlexItemData`
                    )->a( n = `growFactor`   v = `1`
                    )->a( n = `shrinkFactor` v = `0`
            )->end(

            )->tag( n = `Icon` ns = `core`
                )->a( n = `src`   v = `sap-icon://badge`
                )->a( n = `size`  v = `2.625rem`
                )->a( n = `color` v = `Default`
                )->a( n = `class` v = `sapUiTinyMarginBottom`
            )->tag( `Title`
                )->a( n = `text`     v = `Longer Title`
                )->a( n = `wrapping` v = `true`
            )->tag( `Text`
                )->a( n = `text`     v = `A great description with useful information about this project.`
                )->a( n = `wrapping` v = `true`
        )->end(
    )->end( ).

  ENDMETHOD.


  METHOD list_status_add.

    DATA(list) = panel->ele( n = `GridList` ns = `f`
        )->a( n = `id`         v = `gridList3`
        )->a( n = `headerText` v = `GridList, using GridBoxLayout - with ObjectStatus or InfoLabel (boxWidth 17.5rem)`

        )->ele( n = `customLayout` ns = `f`
            )->tag( n = `GridBoxLayout` ns = `grid`
                )->a( n = `boxWidth` v = `17.5rem`
        )->end( ).

    " first box - icon and ObjectStatus share the head line
    list->ele( n = `GridListItem` ns = `f`
        )->ele( `VBox`
            )->a( n = `height`         v = `100%`
            )->a( n = `justifyContent` v = `SpaceBetween`

            )->ele( `layoutData`
                )->tag( `FlexItemData`
                    )->a( n = `growFactor`   v = `1`
                    )->a( n = `shrinkFactor` v = `0`
            )->end(

            )->ele( `VBox`
                )->a( n = `class` v = `sapUiSmallMargin`

                )->ele( `HBox`
                    )->a( n = `justifyContent` v = `SpaceBetween`
                    )->tag( n = `Icon` ns = `core`
                        )->a( n = `src`   v = `sap-icon://org-chart`
                        )->a( n = `size`  v = `2.625rem`
                        )->a( n = `color` v = `Default`
                        )->a( n = `class` v = `sapUiTinyMarginBottom`
                    )->tag( `ObjectStatus`
                        )->a( n = `text`  v = `Positive Status`
                        )->a( n = `state` v = `Success`
                )->end(

                )->tag( `Title`
                    )->a( n = `text`     v = `Title`
                    )->a( n = `wrapping` v = `true`
                )->tag( `Label`
                    )->a( n = `text`     v = `Subtitle`
                    )->a( n = `wrapping` v = `true`
                    )->a( n = `class`    v = `sapUiTinyMarginBottom`
                )->tag( `Text`
                    )->a( n = `text`     v = `A great description with useful information about this project. Lorem ipsum dolor sit amet, consetetur sadipscing elitr`
                    )->a( n = `wrapping` v = `true`
            )->end(

            )->ele( `OverflowToolbar`
                )->a( n = `design` v = `Solid`
                )->tag( `ToolbarSpacer`
                )->tag( `Button`
                    )->a( n = `icon`    v = `sap-icon://edit`
                    )->a( n = `type`    v = `Transparent`
                    )->a( n = `tooltip` v = `Edit`
                )->tag( `Button`
                    )->a( n = `icon`    v = `sap-icon://delete`
                    )->a( n = `type`    v = `Transparent`
                    )->a( n = `tooltip` v = `Delete`
                )->tag( `Button`
                    )->a( n = `icon`    v = `sap-icon://message-information`
                    )->a( n = `type`    v = `Transparent`
                    )->a( n = `tooltip` v = `Information`
            )->end(
        )->end(
    )->end( ).

    " second box - title and InfoLabel share the head line
    list->ele( n = `GridListItem` ns = `f`
        )->ele( `VBox`
            )->a( n = `height`         v = `100%`
            )->a( n = `justifyContent` v = `SpaceBetween`

            )->ele( `layoutData`
                )->tag( `FlexItemData`
                    )->a( n = `growFactor`   v = `1`
                    )->a( n = `shrinkFactor` v = `0`
            )->end(

            )->ele( `VBox`
                )->a( n = `class` v = `sapUiSmallMargin`

                )->ele( `HBox`
                    )->a( n = `justifyContent` v = `SpaceBetween`
                    )->tag( `Title`
                        )->a( n = `text`     v = `Title`
                        )->a( n = `wrapping` v = `true`
                    )->tag( n = `InfoLabel` ns = `t`
                        )->a( n = `text`        v = `T-Shirt Size M`
                        )->a( n = `colorScheme` v = `4`
                )->end(

                )->tag( `Label`
                    )->a( n = `text`     v = `Subtitle`
                    )->a( n = `wrapping` v = `true`
                    )->a( n = `class`    v = `sapUiTinyMarginBottom`
                )->tag( `Text`
                    )->a( n = `text`     v = `A great description with useful information about this project.`
                    )->a( n = `wrapping` v = `true`
            )->end(

            )->ele( `OverflowToolbar`
                )->a( n = `design` v = `Solid`
                )->tag( `ToolbarSpacer`
                )->tag( `Button`
                    )->a( n = `icon`    v = `sap-icon://edit`
                    )->a( n = `type`    v = `Transparent`
                    )->a( n = `tooltip` v = `Edit`
                )->tag( `Button`
                    )->a( n = `icon`    v = `sap-icon://delete`
                    )->a( n = `type`    v = `Transparent`
                    )->a( n = `tooltip` v = `Delete`
                )->tag( `Button`
                    )->a( n = `icon`    v = `sap-icon://message-information`
                    )->a( n = `type`    v = `Transparent`
                    )->a( n = `tooltip` v = `Information`
            )->end(
        )->end(
    )->end( ).

  ENDMETHOD.

ENDCLASS.
