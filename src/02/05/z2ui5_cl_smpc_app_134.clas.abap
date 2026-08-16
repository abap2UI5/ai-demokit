" @keywords toolheader tool header sap.tnt app shell scrollcontainer button overflowtoolbarlayoutdata image title text
" @summary ToolHeader that mimics the content of the Shell.
CLASS z2ui5_cl_smpc_app_134 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_134 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:tnt` v = `sap.tnt`
        )->a( n = `height`    v = `100%`

        )->ele( `ScrollContainer`
            )->a( n = `vertical` v = `true`
            )->a( n = `height`   v = `100%`

            )->ele( n = `ToolHeader` ns = `tnt`
                )->a( n = `id`    v = `shellLikeToolHeader`
                )->a( n = `class` v = `sapUiTinyMargin`

                )->ele( `Button`
                    )->a( n = `icon`    v = `sap-icon://menu2`
                    )->a( n = `type`    v = `Transparent`
                    )->a( n = `tooltip` v = `Menu`
                    )->ele( `layoutData`
                        )->tag( `OverflowToolbarLayoutData`
                            )->a( n = `priority` v = `NeverOverflow`

                    )->end(
                )->end(
                " image assets rewritten to the OpenUI5 host per the runtime asset-URL rule
                )->ele( `Image`
                    )->a( n = `src`        v = `https://sdk.openui5.org/test-resources/sap/tnt/images/SAP_Logo.png`
                    )->a( n = `decorative` v = `false`
                    )->a( n = `press`      v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Logo pressed!` ) ) )
                    )->a( n = `tooltip`    v = `SAP Logo`
                    )->a( n = `width`      v = `60px`
                    )->a( n = `height`     v = `30px`
                    )->ele( `layoutData`
                        )->tag( `OverflowToolbarLayoutData`
                            )->a( n = `priority` v = `NeverOverflow`

                    )->end(
                )->end(
                )->ele( `Title`
                    )->a( n = `text`     v = `Prоduct Name`
                    )->a( n = `wrapping` v = `false`
                    )->a( n = `id`       v = `productName`
                    )->ele( `layoutData`
                        )->tag( `OverflowToolbarLayoutData`
                            )->a( n = `priority` v = `Disappear`

                    )->end(
                )->end(
                )->ele( `Text`
                    )->a( n = `text`     v = `Second title`
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
                    )->a( n = `icon`    v = `sap-icon://da`
                    )->a( n = `type`    v = `Transparent`
                    )->a( n = `tooltip` v = `Joule`
                    )->a( n = `text`    v = `Joule`
                    )->ele( `layoutData`
                        )->tag( `OverflowToolbarLayoutData`
                            )->a( n = `group` v = `2`

                    )->end(
                )->end(
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
                )->tag( `OverflowToolbarButton`
                    )->a( n = `icon`    v = `sap-icon://grid`
                    )->a( n = `type`    v = `Transparent`
                    )->a( n = `text`    v = `My Products`
                    )->a( n = `tooltip` v = `My Products`
                " Avatar is a control @since 1.73 - kept 1:1 (POST_171)
                )->ele( `Avatar`
                    )->a( n = `src`         v = `https://sdk.openui5.org/test-resources/sap/tnt/images/Woman_avatar_01.png`
                    )->a( n = `displaySize` v = `XS`
                    )->a( n = `press`       v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Avatar pressed!` ) ) )
                    )->a( n = `tooltip`     v = `Profile`
                    )->ele( `layoutData`
                        )->tag( `OverflowToolbarLayoutData`
                            )->a( n = `priority` v = `NeverOverflow`

                    )->end(
                )->end(
            )->end(

            )->ele( n = `ToolHeader` ns = `tnt`
                )->a( n = `id`    v = `shellLikeToolHeaderOnlyMandatoryControls`
                )->a( n = `class` v = `sapUiTinyMargin sapUiLargeMarginTop`

                )->ele( `Image`
                    )->a( n = `src`        v = `https://sdk.openui5.org/test-resources/sap/tnt/images/SAP_Logo.png`
                    )->a( n = `decorative` v = `false`
                    )->a( n = `press`      v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Logo pressed!` ) ) )
                    )->a( n = `tooltip`    v = `SAP Logo`
                    )->a( n = `width`      v = `60px`
                    )->a( n = `height`     v = `30px`
                    )->ele( `layoutData`
                        )->tag( `OverflowToolbarLayoutData`
                            )->a( n = `priority` v = `NeverOverflow`

                    )->end(
                )->end(
                )->ele( `Title`
                    )->a( n = `text`     v = `Prоduct Name`
                    )->a( n = `wrapping` v = `false`
                    )->ele( `layoutData`
                        )->tag( `OverflowToolbarLayoutData`
                            )->a( n = `priority` v = `Disappear`

                    )->end(
                )->end(
                )->tag( `ToolbarSpacer`
                )->ele( `Avatar`
                    )->a( n = `src`         v = `https://sdk.openui5.org/test-resources/sap/tnt/images/Woman_avatar_01.png`
                    )->a( n = `displaySize` v = `XS`
                    )->a( n = `press`       v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Avatar pressed!` ) ) )
                    )->a( n = `tooltip`     v = `Profile`
                    )->ele( `layoutData`
                        )->tag( `OverflowToolbarLayoutData`
                            )->a( n = `priority` v = `NeverOverflow` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
