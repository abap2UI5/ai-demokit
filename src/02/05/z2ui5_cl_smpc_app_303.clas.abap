CLASS z2ui5_cl_smpc_app_303 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA selectedkey TYPE string.

    TYPES: BEGIN OF ty_s_sub_item,
             title TYPE string,
             key   TYPE string,
           END OF ty_s_sub_item.
    TYPES: BEGIN OF ty_s_nav_item,
             title TYPE string,
             icon  TYPE string,
             key   TYPE string,
             items TYPE STANDARD TABLE OF ty_s_sub_item WITH EMPTY KEY,
           END OF ty_s_nav_item.
    DATA navigation TYPE STANDARD TABLE OF ty_s_nav_item WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_303 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
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

        )->ele( n = `ToolPage` ns = `tnt`
            )->a( n = `id` v = `toolPage`

            )->ele( n = `header` ns = `tnt`
                )->ele( n = `ToolHeader` ns = `tnt`
                    )->tag( `Image`
                        )->a( n = `height` v = `1.5rem`
                        )->a( n = `class`  v = `sapUiSmallMarginBegin`
                        )->a( n = `src`    v = `https://www.sap.com/dam/application/shared/logos/sap-logo-svg.svg`

                    )->ele( `Title`
                        )->a( n = `level`    v = `H1`
                        )->a( n = `text`     v = `Product Name`
                        )->a( n = `wrapping` v = `false`
                        )->a( n = `id`       v = `productName`

                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `priority` v = `Disappear`

                        )->end(
                    )->end(
                    )->ele( `Text`
                        )->a( n = `text`     v = `Second Тitle`
                        )->a( n = `wrapping` v = `false`
                        )->a( n = `id`       v = `secondTitle`

                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `priority` v = `Disappear`

                        )->end(
                    )->end(

                    )->tag( `ToolbarSpacer`

                    )->ele( `SearchField`
                        )->a( n = `width` v = `25rem`
                        )->a( n = `id`    v = `searchField`

                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `priority` v = `Low`
                                )->a( n = `group`    v = `1`

                        )->end(
                    )->end(

                    )->tag( `Button`
                        )->a( n = `visible` v = `false`
                        )->a( n = `icon`    v = `sap-icon://search`
                        )->a( n = `type`    v = `Transparent`
                        )->a( n = `id`      v = `searchButton`
                        )->a( n = `tooltip` v = `Search`

                    )->ele( `OverflowToolbarButton`
                        )->a( n = `icon`    v = `sap-icon://source-code`
                        )->a( n = `type`    v = `Transparent`
                        )->a( n = `tooltip` v = `Action 1`
                        )->a( n = `text`    v = `Action 1`

                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `group` v = `2`

                        )->end(
                    )->end(
                    )->ele( `OverflowToolbarButton`
                        )->a( n = `icon`    v = `sap-icon://card`
                        )->a( n = `type`    v = `Transparent`
                        )->a( n = `tooltip` v = `Action 2`
                        )->a( n = `text`    v = `Action 2`

                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `group` v = `2`

                        )->end(
                    )->end(
                    )->ele( `ToolbarSeparator`
                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `group` v = `2`

                        )->end(
                    )->end(

                    )->tag( `OverflowToolbarButton`
                        )->a( n = `icon` v = `sap-icon://action-settings`
                        )->a( n = `type` v = `Transparent`
                        )->a( n = `text` v = `Settings`

                    )->ele( `Button`
                        )->a( n = `icon`    v = `sap-icon://bell`
                        )->a( n = `type`    v = `Transparent`
                        )->a( n = `tooltip` v = `Notification`

                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `priority` v = `NeverOverflow`

                        )->end(
                    )->end(

                    )->tag( n = `ToolHeaderUtilitySeparator` ns = `tnt`

                    )->tag( `ToolbarSpacer`
                        )->a( n = `width` v = `1.125rem`

                    )->ele( `Avatar`
                        )->a( n = `src`         v = `https://sdk.openui5.org/test-resources/sap/tnt/images/Woman_avatar_01.png`
                        )->a( n = `displaySize` v = `XS`
                        )->a( n = `tooltip`     v = `Profile`

                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `priority` v = `NeverOverflow`

                        )->end(
                    )->end(
                )->end(
            )->end(

            )->ele( n = `subHeader` ns = `tnt`
                )->ele( n = `ToolHeader` ns = `tnt`
                    )->ele( `IconTabHeader`
                        )->a( n = `selectedKey` v = client->_bind( selectedkey )
                        )->a( n = `items`       v = |\{path: '{ client->_bind( val = navigation path = abap_true ) }'\}|
                        )->a( n = `select`      v = client->_event( val   = `ITEM_SELECT`
                                                                    t_arg = VALUE #( ( `${$parameters>/item}.getKey()` ) ) )
                        )->a( n = `mode`        v = `Inline`

                        )->ele( `layoutData`
                            )->tag( `OverflowToolbarLayoutData`
                                )->a( n = `priority`   v = `NeverOverflow`
                                )->a( n = `shrinkable` v = `true`

                        )->end(
                        )->ele( `items`
                            )->ele( `IconTabFilter`
                                )->a( n = `items`           v = `{ITEMS}`
                                )->a( n = `text`            v = `{TITLE}`
                                )->a( n = `key`             v = `{KEY}`
                                )->a( n = `interactionMode` v = `SelectLeavesOnly`

                                )->ele( `items`
                                    )->tag( `IconTabFilter`
                                        )->a( n = `text` v = `{TITLE}`
                                        )->a( n = `key`  v = `{KEY}`

                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(
            )->end(

            )->ele( n = `mainContents` ns = `tnt`
                )->ele( `NavContainer`
                    )->a( n = `id`          v = `pageContainer`
                    )->a( n = `initialPage` v = `page1`

                    )->ele( `pages`
                        )->ele( `ScrollContainer`
                            )->a( n = `id`         v = `page1`
                            )->a( n = `horizontal` v = `false`
                            )->a( n = `vertical`   v = `true`
                            )->a( n = `height`     v = `100%`
                            )->a( n = `class`      v = `sapUiContentPadding`

                            )->tag( `Text`
                                )->a( n = `text` v = `Home`

                        )->end(
                        )->ele( `ScrollContainer`
                            )->a( n = `id`         v = `page2`
                            )->a( n = `horizontal` v = `false`
                            )->a( n = `vertical`   v = `true`
                            )->a( n = `height`     v = `100%`
                            )->a( n = `class`      v = `sapUiContentPadding`

                            )->tag( `Text`
                                )->a( n = `text` v = `Applications`

                        )->end(
                        )->ele( `ScrollContainer`
                            )->a( n = `id`         v = `page3`
                            )->a( n = `horizontal` v = `false`
                            )->a( n = `vertical`   v = `true`
                            )->a( n = `height`     v = `100%`
                            )->a( n = `class`      v = `sapUiContentPadding`

                            )->tag( `Text`
                                )->a( n = `text` v = `Users and Groups`

                        )->end(
                        )->ele( `ScrollContainer`
                            )->a( n = `id`         v = `page4`
                            )->a( n = `horizontal` v = `false`
                            )->a( n = `vertical`   v = `true`
                            )->a( n = `height`     v = `100%`
                            )->a( n = `class`      v = `sapUiContentPadding`

                            )->tag( `Text`
                                )->a( n = `text` v = `Identity`

                        )->end(
                        )->ele( `ScrollContainer`
                            )->a( n = `id`         v = `page5`
                            )->a( n = `horizontal` v = `false`
                            )->a( n = `vertical`   v = `true`
                            )->a( n = `height`     v = `100%`
                            )->a( n = `class`      v = `sapUiContentPadding`

                            )->tag( `Text`
                                )->a( n = `text` v = `Provisioning`

                        )->end(
                        )->ele( `ScrollContainer`
                            )->a( n = `id`         v = `page6`
                            )->a( n = `horizontal` v = `false`
                            )->a( n = `vertical`   v = `true`
                            )->a( n = `height`     v = `100%`
                            )->a( n = `class`      v = `sapUiContentPadding`

                            )->tag( `Text`
                                )->a( n = `text` v = `Monitoring`

                        )->end(
                        )->ele( `ScrollContainer`
                            )->a( n = `id`         v = `page7`
                            )->a( n = `horizontal` v = `false`
                            )->a( n = `vertical`   v = `true`
                            )->a( n = `height`     v = `100%`
                            )->a( n = `class`      v = `sapUiContentPadding`

                            )->tag( `Text`
                                )->a( n = `text` v = `Resources` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `ITEM_SELECT`.
      " original onItemSelect: pageContainer.to( the selected item's key )
      client->follow_up_action( val   = client->cs_event-control_by_id
                                t_arg = VALUE #( ( `pageContainer` )
                                                 ( `to` )
                                                 ( client->get_event_arg( ) ) ) ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " model/data.json of the sample, inlined 1:1
    selectedkey = `page1`.

    navigation = VALUE #(
      ( title = `Home`         key = `page1` )
      ( title = `Applications` key = `page2` )
      ( title = `Users and Groups`
        items = VALUE #( ( title = `User 1` key = `page3` )
                         ( title = `User 2` key = `page3` )
                         ( title = `User 3` key = `page3` ) ) )
      ( title = `Identity`
        items = VALUE #( ( title = `Identity 1` key = `page4` )
                         ( title = `Identity 2` key = `page4` )
                         ( title = `Identity 3` key = `page4` ) ) )
      ( title = `Provisioning` key = `page5` )
      ( title = `Monitoring` icon = `sap-icon://unwired`
        items = VALUE #( ( title = `Monitoring 1` key = `page6` )
                         ( title = `Monitoring 2` key = `page6` ) ) )
      ( title = `Resources`
        items = VALUE #( ( title = `Resource 1` key = `page7` )
                         ( title = `Resource 2` key = `page7` )
                         ( title = `Resource 3` key = `page7` ) ) ) ).

  ENDMETHOD.

ENDCLASS.
