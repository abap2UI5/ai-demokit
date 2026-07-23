CLASS z2ui5_cl_ai_app_134 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_134 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:tnt` v = `sap.tnt`
        )->a( n = `height`    v = `100%`

        )->open( `ScrollContainer`
            )->a( n = `vertical` v = `true`
            )->a( n = `height`   v = `100%`

            )->open( n = `ToolHeader` ns = `tnt`
                )->a( n = `id`    v = `shellLikeToolHeader`
                )->a( n = `class` v = `sapUiTinyMargin`

                )->open( `Button`
                    )->a( n = `icon`    v = `sap-icon://menu2`
                    )->a( n = `type`    v = `Transparent`
                    )->a( n = `tooltip` v = `Menu`
                    )->open( `layoutData`
                        )->leaf( `OverflowToolbarLayoutData`
                            )->a( n = `priority` v = `NeverOverflow`

                )->shut(
                )->shut(
                )->open( `Image`
                    )->a( n = `src`        v = `test-resources/sap/tnt/images/SAP_Logo.png`
                    )->a( n = `decorative` v = `false`
                    )->a( n = `press`      v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Logo pressed!` ) ) )
                    )->a( n = `tooltip`    v = `SAP Logo`
                    )->a( n = `width`      v = `60px`
                    )->a( n = `height`     v = `30px`
                    )->open( `layoutData`
                        )->leaf( `OverflowToolbarLayoutData`
                            )->a( n = `priority` v = `NeverOverflow`

                )->shut(
                )->shut(
                )->open( `Title`
                    )->a( n = `text`     v = `Prоduct Name`
                    )->a( n = `wrapping` v = `false`
                    )->a( n = `id`       v = `productName`
                    )->open( `layoutData`
                        )->leaf( `OverflowToolbarLayoutData`
                            )->a( n = `priority` v = `Disappear`

                )->shut(
                )->shut(
                )->open( `Text`
                    )->a( n = `text`     v = `Second title`
                    )->a( n = `wrapping` v = `false`
                    )->a( n = `id`       v = `secondTitle`
                    )->open( `layoutData`
                        )->leaf( `OverflowToolbarLayoutData`
                            )->a( n = `priority` v = `Disappear`

                )->shut(
                )->shut(
                )->leaf( `ToolbarSpacer`
                )->open( `SearchField`
                    )->a( n = `width` v = `25rem`
                    )->a( n = `id`    v = `searchField`
                    )->open( `layoutData`
                        )->leaf( `OverflowToolbarLayoutData`
                            )->a( n = `priority` v = `Low`
                            )->a( n = `group`    v = `1`

                )->shut(
                )->shut(
                )->leaf( `Button`
                    )->a( n = `visible` v = `false`
                    )->a( n = `icon`    v = `sap-icon://search`
                    )->a( n = `type`    v = `Transparent`
                    )->a( n = `id`      v = `searchButton`
                    )->a( n = `tooltip` v = `Search`
                )->open( `OverflowToolbarButton`
                    )->a( n = `icon`    v = `sap-icon://da`
                    )->a( n = `type`    v = `Transparent`
                    )->a( n = `tooltip` v = `Joule`
                    )->a( n = `text`    v = `Joule`
                    )->open( `layoutData`
                        )->leaf( `OverflowToolbarLayoutData`
                            )->a( n = `group` v = `2`

                )->shut(
                )->shut(
                )->open( `OverflowToolbarButton`
                    )->a( n = `icon`    v = `sap-icon://source-code`
                    )->a( n = `type`    v = `Transparent`
                    )->a( n = `tooltip` v = `Action 1`
                    )->a( n = `text`    v = `Action 1`
                    )->open( `layoutData`
                        )->leaf( `OverflowToolbarLayoutData`
                            )->a( n = `group` v = `2`

                )->shut(
                )->shut(
                )->open( `OverflowToolbarButton`
                    )->a( n = `icon`    v = `sap-icon://card`
                    )->a( n = `type`    v = `Transparent`
                    )->a( n = `tooltip` v = `Action 2`
                    )->a( n = `text`    v = `Action 2`
                    )->open( `layoutData`
                        )->leaf( `OverflowToolbarLayoutData`
                            )->a( n = `group` v = `2`

                )->shut(
                )->shut(
                )->leaf( `OverflowToolbarButton`
                    )->a( n = `icon` v = `sap-icon://action-settings`
                    )->a( n = `type` v = `Transparent`
                    )->a( n = `text` v = `Settings`
                )->open( `Button`
                    )->a( n = `icon`    v = `sap-icon://bell`
                    )->a( n = `type`    v = `Transparent`
                    )->a( n = `tooltip` v = `Notification`
                    )->open( `layoutData`
                        )->leaf( `OverflowToolbarLayoutData`
                            )->a( n = `priority` v = `NeverOverflow`

                )->shut(
                )->shut(
                )->leaf( n = `ToolHeaderUtilitySeparator` ns = `tnt`
                )->leaf( `OverflowToolbarButton`
                    )->a( n = `icon`    v = `sap-icon://grid`
                    )->a( n = `type`    v = `Transparent`
                    )->a( n = `text`    v = `My Products`
                    )->a( n = `tooltip` v = `My Products`
                )->open( `Avatar`
                    )->a( n = `src`         v = `test-resources/sap/tnt/images/Woman_avatar_01.png`
                    )->a( n = `displaySize` v = `XS`
                    )->a( n = `press`       v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Avatar pressed!` ) ) )
                    )->a( n = `tooltip`     v = `Profile`
                    )->open( `layoutData`
                        )->leaf( `OverflowToolbarLayoutData`
                            )->a( n = `priority` v = `NeverOverflow`

                )->shut(
                )->shut(
            )->shut(

            )->open( n = `ToolHeader` ns = `tnt`
                )->a( n = `id`    v = `shellLikeToolHeaderOnlyMandatoryControls`
                )->a( n = `class` v = `sapUiTinyMargin sapUiLargeMarginTop`

                )->open( `Image`
                    )->a( n = `src`        v = `test-resources/sap/tnt/images/SAP_Logo.png`
                    )->a( n = `decorative` v = `false`
                    )->a( n = `press`      v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Logo pressed!` ) ) )
                    )->a( n = `tooltip`    v = `SAP Logo`
                    )->a( n = `width`      v = `60px`
                    )->a( n = `height`     v = `30px`
                    )->open( `layoutData`
                        )->leaf( `OverflowToolbarLayoutData`
                            )->a( n = `priority` v = `NeverOverflow`

                )->shut(
                )->shut(
                )->open( `Title`
                    )->a( n = `text`     v = `Prоduct Name`
                    )->a( n = `wrapping` v = `false`
                    )->open( `layoutData`
                        )->leaf( `OverflowToolbarLayoutData`
                            )->a( n = `priority` v = `Disappear`

                )->shut(
                )->shut(
                )->leaf( `ToolbarSpacer`
                )->open( `Avatar`
                    )->a( n = `src`         v = `test-resources/sap/tnt/images/Woman_avatar_01.png`
                    )->a( n = `displaySize` v = `XS`
                    )->a( n = `press`       v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Avatar pressed!` ) ) )
                    )->a( n = `tooltip`     v = `Profile`
                    )->open( `layoutData`
                        )->leaf( `OverflowToolbarLayoutData`
                            )->a( n = `priority` v = `NeverOverflow` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
