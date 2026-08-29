" @keywords cssgrid sap.ui.layout.cssgrid producthomelayout toolpage toolheader image text toolbarspacer button avatar scrollcontainer togglebutton
" @summary Example of using several grids nested in one main grid with ResponsiveColumnLayout, in order to achieve responsive home page design.
CLASS z2ui5_cl_smpc_app_350 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    " model/home.json, folded onto the one default model (the original carries
    " it as the named `home>` model). The image sources are the formatSrc
    " formatter resolved in ABAP - the thin-frontend rule
    DATA homeiconsrc      TYPE string.
    DATA user_iconsrc     TYPE string.
    DATA currentbreakpoint TYPE string.

    " /layout/groupN/columns/current - what onLayoutChangeMain computes per
    " breakpoint from the same JSON; the computation lives in ABAP here
    DATA group1_columns TYPE i.
    DATA group2_columns TYPE i.
    DATA group3_columns TYPE i.
    DATA group4_columns TYPE i.

    " the two sap.ui.integration Cards get their manifest by URL - the form
    " Card.createManifest reads a string manifest as (the original sets exactly
    " those two URLs in onInit through formatSrc)
    DATA manifest_users         TYPE string.
    DATA manifest_logonrequests TYPE string.

    " onColumnsChange widens the two cards of group 1 when the grid is wide
    DATA card_columns TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS columns_apply
      IMPORTING
        layout TYPE string.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_350 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      " Component.js init: IconPool.registerFont for the SAP-icons-TNT
      " collection, which is what makes the sap-icon://SAP-icons-TNT/... URI of
      " the Group2 tile resolvable. An abap2UI5 app has no Component of its own
      " and IconPool is a module singleton, so the ICON_POOL global target is
      " the only wire that reaches it - once per session, from the init branch
      client->follow_up_action( val   = client->cs_event-control_global
                                t_arg = VALUE #( ( `ICON_POOL` ) ( `registerFont` ) ( `SAP-icons-TNT` ) ( `sap/tnt/themes/base/fonts/` ) ) ).
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

    " the tnt:ToolPage home layout: the four Group fragments are inlined into
    " the one view (abap2UI5 serves one view per round-trip, so a fragmentName
    " has no file to resolve), the `home>` model is folded onto the default
    " one, and the two grid events (layoutChange / columnsChange) carry their
    " own parameters to the backend, where the column arithmetic the original
    " does in the controller now lives.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`         v = `sap.m`
        )->a( n = `xmlns:mvc`     v = `sap.ui.core.mvc`
        )->a( n = `xmlns:cssgrid` v = `sap.ui.layout.cssgrid`
        )->a( n = `xmlns:tnt`     v = `sap.tnt`
        )->a( n = `xmlns:core`    v = `sap.ui.core`
        )->a( n = `xmlns:f`       v = `sap.f`
        )->a( n = `xmlns:cards`   v = `sap.f.cards`
        )->a( n = `xmlns:widgets` v = `sap.ui.integration.widgets`

        )->ele( n = `ToolPage` ns = `tnt`
            )->ele( n = `header` ns = `tnt`
                )->ele( n = `ToolHeader` ns = `tnt`
                    )->tag( `Image`
                        )->a( n = `src`   v = client->_bind( homeiconsrc )
                        )->a( n = `class` v = `sapUiTinyMarginBegin`

                    )->tag( `Text`
                        )->a( n = `text`     v = `Cloud Platform Product`
                        )->a( n = `wrapping` v = `false`

                    )->tag( `ToolbarSpacer`

                    )->tag( `Button`
                        )->a( n = `icon` v = `sap-icon://search`
                        )->a( n = `type` v = `Transparent`

                    )->tag( `Button`
                        )->a( n = `icon` v = `sap-icon://bell`
                        )->a( n = `type` v = `Transparent`

                    )->tag( `Avatar`
                        )->a( n = `src`         v = client->_bind( user_iconsrc )
                        )->a( n = `displaySize` v = `XS`
                        )->a( n = `class`       v = `avatarSize`

                )->end(
            )->end(
            )->ele( n = `mainContents` ns = `tnt`
                )->ele( `ScrollContainer`
                    )->a( n = `id`         v = `scrollCont`
                    )->a( n = `horizontal` v = `false`
                    )->a( n = `vertical`   v = `true`
                    )->a( n = `height`     v = `100%`
                    )->a( n = `class`      v = `sapUiResponsiveContentPadding`

                    )->tag( `ToggleButton`
                        )->a( n = `text`  v = `Reveal Main Grid`
                        )->a( n = `class` v = `sapUiSmallMarginBottom sapUiSmallMarginEnd`

                    )->tag( `ToggleButton`
                        )->a( n = `text`  v = `Reveal Grids of Groups`
                        )->a( n = `class` v = `sapUiSmallMarginBottom`

                    )->tag( `Text`
                        )->a( n = `class` v = `sapUiSmallMarginBottom`
                        )->a( n = `text`  v = |Current breakpoint: { client->_bind( currentbreakpoint ) }|
                        )->a( n = `width` v = `100%`

                    )->ele( n = `CSSGrid` ns = `cssgrid`
                        )->a( n = `id` v = `mainGrid`

                        )->ele( n = `customLayout` ns = `cssgrid`
                            )->tag( n = `ResponsiveColumnLayout` ns = `cssgrid`
                                )->a( n = `layoutChange` v = client->_event( val = `LAYOUT_CHANGE` arg = `${$parameters>/layout}` )

                        )->end(
                        )->ele( `VBox`
                            )->a( n = `renderType` v = `Bare`

                            )->ele( `layoutData`
                                )->tag( n = `ResponsiveColumnItemLayoutData` ns = `cssgrid`
                                    )->a( n = `columns` v = client->_bind( group1_columns )

                            )->end(
                            )->tag( `Title`
                                )->a( n = `text`       v = `Recently Used`
                                )->a( n = `titleStyle` v = `H4`
                                )->a( n = `class`      v = `sapUiSmallMarginBottom sapUiLargeMarginTop`

                            )->ele( n = `GridContainer` ns = `f`
                                )->a( n = `id`            v = `group1`
                                )->a( n = `columnsChange` v = client->_event( val = `COLUMNS_CHANGE` arg = `${$parameters>/columns}` )

                                )->ele( n = `layout` ns = `f`
                                    )->tag( n = `GridContainerSettings` ns = `f`
                                        )->a( n = `rowSize`    v = `4rem`
                                        )->a( n = `columnSize` v = `4rem`

                                )->end(
                                )->ele( n = `Card` ns = `f`
                                    )->a( n = `id`     v = `applicationsCard`
                                    )->a( n = `height` v = `100%`

                                    )->ele( n = `layoutData` ns = `f`
                                        )->tag( n = `GridContainerItemLayoutData` ns = `f`
                                            )->a( n = `columns` v = `4`
                                            )->a( n = `minRows` v = `6`

                                    )->end(
                                    )->ele( n = `header` ns = `f`
                                        )->tag( n = `Header` ns = `cards`
                                            )->a( n = `title` v = `Applications`

                                    )->end(
                                    )->ele( n = `content` ns = `f`
                                        )->ele( `List`
                                            )->a( n = `showSeparators` v = `None`

                                            )->tag( `StandardListItem`
                                                )->a( n = `title`       v = `RUUM`
                                                )->a( n = `description` v = `2 Issues Detected`
                                                )->a( n = `highlight`   v = `Warning`

                                            )->tag( `StandardListItem`
                                                )->a( n = `title`       v = `My Inbox`
                                                )->a( n = `description` v = `Has 3 new Messages`

                                            )->tag( `StandardListItem`
                                                )->a( n = `title`       v = `Guided Buying`
                                                )->a( n = `description` v = `Last used: Yesterday`

                                            )->tag( `StandardListItem`
                                                )->a( n = `title`       v = `Extension App`
                                                )->a( n = `description` v = `Sample Cloud Platform Application`

                                            )->tag( `StandardListItem`
                                                )->a( n = `title`       v = `Demo Kit`
                                                )->a( n = `description` v = `Demo Instance`

                                        )->end(
                                    )->end(
                                )->end(
                                )->ele( n = `Card` ns = `widgets`
                                    )->a( n = `id`       v = `usersCard`
                                    )->a( n = `manifest` v = client->_bind( manifest_users )
                                    )->a( n = `height`   v = `100%`

                                    )->ele( n = `layoutData` ns = `widgets`
                                        " onColumnsChange writes iCardColumns onto this card's layoutData
                                        )->tag( n = `GridContainerItemLayoutData` ns = `f`
                                            )->a( n = `columns` v = client->_bind( card_columns )
                                            )->a( n = `minRows` v = `6`

                                    )->end(
                                )->end(
                                )->ele( n = `Card` ns = `f`
                                    )->a( n = `id`     v = `upfCard`
                                    )->a( n = `height` v = `100%`

                                    )->ele( n = `layoutData` ns = `f`
                                        " onColumnsChange writes iCardColumns onto this card's layoutData
                                        )->tag( n = `GridContainerItemLayoutData` ns = `f`
                                            )->a( n = `columns` v = client->_bind( card_columns )
                                            )->a( n = `minRows` v = `6`

                                    )->end(
                                    )->ele( n = `header` ns = `f`
                                        )->tag( n = `Header` ns = `cards`
                                            )->a( n = `title` v = `User Provisioning Flows`

                                    )->end(
                                    )->ele( n = `content` ns = `f`
                                        )->ele( `List`
                                            )->a( n = `showSeparators` v = `None`

                                            )->tag( `StandardListItem`
                                                )->a( n = `title`       v = `Employee Onboarding`
                                                )->a( n = `description` v = `SAP Success Factors`

                                            )->tag( `StandardListItem`
                                                )->a( n = `title`       v = `Cloud Storе Access`
                                                )->a( n = `description` v = `SAP Success Factors`

                                            )->tag( `StandardListItem`
                                                )->a( n = `title`       v = `External JAM Users`
                                                )->a( n = `description` v = `SAP Audit Log`

                                            )->tag( `StandardListItem`
                                                )->a( n = `title`       v = `Active Directory into IAS`
                                                )->a( n = `description` v = `My Inbox`

                                            )->tag( `StandardListItem`
                                                )->a( n = `title`       v = `Flow Name`
                                                )->a( n = `description` v = `SAP Success Factors`
                                                )->a( n = `highlight`   v = `Error`

                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                        )->ele( `VBox`
                            )->a( n = `renderType` v = `Bare`

                            )->ele( `layoutData`
                                )->tag( n = `ResponsiveColumnItemLayoutData` ns = `cssgrid`
                                    )->a( n = `columns` v = client->_bind( group2_columns )

                            )->end(
                            )->tag( `Title`
                                )->a( n = `text`       v = `Frequent Operations`
                                )->a( n = `titleStyle` v = `H4`
                                )->a( n = `class`      v = `sapUiSmallMarginBottom sapUiLargeMarginTop`

                            )->ele( n = `GridContainer` ns = `f`
                                )->a( n = `id` v = `group2`

                                )->ele( n = `layout` ns = `f`
                                    )->tag( n = `GridContainerSettings` ns = `f`
                                        )->a( n = `rowSize`    v = `4rem`
                                        )->a( n = `columnSize` v = `4rem`

                                )->end(
                                )->ele( n = `Card` ns = `f`
                                    )->a( n = `height` v = `100%`

                                    )->ele( n = `content` ns = `f`
                                        )->ele( `VBox`
                                            )->a( n = `alignItems`     v = `Center`
                                            )->a( n = `justifyContent` v = `Center`
                                            )->a( n = `width`          v = `100%`

                                            )->tag( `Avatar`
                                                )->a( n = `src` v = `sap-icon://SAP-icons-TNT/application-service`

                                            )->tag( `Link`
                                                )->a( n = `text` v = `Create Application`

                                        )->end(
                                    )->end(
                                    )->ele( n = `layoutData` ns = `f`
                                        )->tag( n = `GridContainerItemLayoutData` ns = `f`
                                            )->a( n = `columns` v = `2`
                                            )->a( n = `minRows` v = `2`

                                    )->end(
                                )->end(
                                )->ele( n = `Card` ns = `f`
                                    )->a( n = `height` v = `100%`

                                    )->ele( n = `content` ns = `f`
                                        )->ele( `VBox`
                                            )->a( n = `alignItems`     v = `Center`
                                            )->a( n = `justifyContent` v = `Center`
                                            )->a( n = `width`          v = `100%`

                                            )->tag( `Avatar`
                                                )->a( n = `src` v = `sap-icon://developer-settings`

                                            )->tag( `Link`
                                                )->a( n = `text` v = `Configure Tenant`

                                        )->end(
                                    )->end(
                                    )->ele( n = `layoutData` ns = `f`
                                        )->tag( n = `GridContainerItemLayoutData` ns = `f`
                                            )->a( n = `columns` v = `2`
                                            )->a( n = `minRows` v = `2`

                                    )->end(
                                )->end(
                                )->ele( n = `Card` ns = `f`
                                    )->a( n = `height` v = `100%`

                                    )->ele( n = `content` ns = `f`
                                        )->ele( `VBox`
                                            )->a( n = `alignItems`     v = `Center`
                                            )->a( n = `justifyContent` v = `Center`
                                            )->a( n = `width`          v = `100%`

                                            )->tag( `Avatar`
                                                )->a( n = `src` v = `sap-icon://customer`

                                            )->tag( `Link`
                                                )->a( n = `text` v = `Create User`

                                        )->end(
                                    )->end(
                                    )->ele( n = `layoutData` ns = `f`
                                        )->tag( n = `GridContainerItemLayoutData` ns = `f`
                                            )->a( n = `columns` v = `2`
                                            )->a( n = `minRows` v = `2`

                                    )->end(
                                )->end(
                                )->ele( n = `Card` ns = `f`
                                    )->a( n = `height` v = `100%`

                                    )->ele( n = `content` ns = `f`
                                        )->ele( `VBox`
                                            )->a( n = `alignItems`     v = `Center`
                                            )->a( n = `justifyContent` v = `Center`
                                            )->a( n = `width`          v = `100%`

                                            )->tag( `Avatar`
                                                )->a( n = `src` v = `sap-icon://feedback`

                                            )->tag( `Link`
                                                )->a( n = `text` v = `Give Feedback`

                                        )->end(
                                    )->end(
                                    )->ele( n = `layoutData` ns = `f`
                                        )->tag( n = `GridContainerItemLayoutData` ns = `f`
                                            )->a( n = `columns` v = `2`
                                            )->a( n = `minRows` v = `2`

                                    )->end(
                                )->end(
                                )->ele( n = `Card` ns = `f`
                                    )->a( n = `height` v = `100%`

                                    )->ele( n = `content` ns = `f`
                                        )->ele( `VBox`
                                            )->a( n = `alignItems`     v = `Center`
                                            )->a( n = `justifyContent` v = `Center`
                                            )->a( n = `width`          v = `100%`

                                            )->tag( `Avatar`
                                                )->a( n = `src` v = `sap-icon://family-care`

                                            )->tag( `Link`
                                                )->a( n = `text` v = `Create Flow`

                                        )->end(
                                    )->end(
                                    )->ele( n = `layoutData` ns = `f`
                                        )->tag( n = `GridContainerItemLayoutData` ns = `f`
                                            )->a( n = `columns` v = `2`
                                            )->a( n = `minRows` v = `2`

                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                        )->ele( `VBox`
                            )->a( n = `renderType` v = `Bare`

                            )->ele( `layoutData`
                                )->tag( n = `ResponsiveColumnItemLayoutData` ns = `cssgrid`
                                    )->a( n = `columns` v = client->_bind( group3_columns )

                            )->end(
                            )->tag( `Title`
                                )->a( n = `text`       v = `Usage and Logs`
                                )->a( n = `titleStyle` v = `H4`
                                )->a( n = `class`      v = `sapUiSmallMarginBottom sapUiLargeMarginTop`

                            )->ele( n = `GridContainer` ns = `f`
                                )->a( n = `id` v = `group3`

                                )->ele( n = `layout` ns = `f`
                                    )->tag( n = `GridContainerSettings` ns = `f`
                                        )->a( n = `rowSize`    v = `4rem`
                                        )->a( n = `columnSize` v = `4rem`

                                )->end(
                                )->ele( n = `Card` ns = `widgets`
                                    )->a( n = `id`       v = `logonRequestsCard`
                                    )->a( n = `manifest` v = client->_bind( manifest_logonrequests )
                                    )->a( n = `height`   v = `100%`

                                    )->ele( n = `layoutData` ns = `widgets`
                                        )->tag( n = `GridContainerItemLayoutData` ns = `f`
                                            )->a( n = `columns` v = `4`
                                            )->a( n = `minRows` v = `3`

                                    )->end(
                                )->end(
                                )->ele( n = `Card` ns = `f`
                                    )->a( n = `height` v = `100%`

                                    )->ele( n = `header` ns = `f`
                                        )->tag( n = `Header` ns = `cards`
                                            )->a( n = `title` v = `Audit Logs`

                                    )->end(
                                    )->ele( n = `content` ns = `f`
                                        )->ele( `HBox`
                                            )->a( n = `alignItems`     v = `Center`
                                            )->a( n = `justifyContent` v = `Center`
                                            )->a( n = `width`          v = `100%`

                                            )->tag( `Text`
                                                )->a( n = `text` v = `Unable to load the data.`

                                        )->end(
                                    )->end(
                                    )->ele( n = `layoutData` ns = `f`
                                        )->tag( n = `GridContainerItemLayoutData` ns = `f`
                                            )->a( n = `columns` v = `4`
                                            )->a( n = `minRows` v = `3`

                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                        )->ele( `VBox`
                            )->a( n = `renderType` v = `Bare`

                            )->ele( `layoutData`
                                )->tag( n = `ResponsiveColumnItemLayoutData` ns = `cssgrid`
                                    )->a( n = `columns` v = client->_bind( group4_columns )

                            )->end(
                            )->tag( `Title`
                                )->a( n = `text`       v = `Running Tasks`
                                )->a( n = `titleStyle` v = `H4`
                                )->a( n = `class`      v = `sapUiSmallMarginBottom sapUiLargeMarginTop`

                            )->ele( n = `GridContainer` ns = `f`
                                )->a( n = `id` v = `group4`

                                )->ele( n = `layout` ns = `f`
                                    )->tag( n = `GridContainerSettings` ns = `f`
                                        )->a( n = `rowSize`    v = `4rem`
                                        )->a( n = `columnSize` v = `4rem`

                                )->end(
                                )->ele( n = `Card` ns = `f`
                                    )->a( n = `height` v = `100%`

                                    )->ele( n = `content` ns = `f`
                                        )->ele( `VBox`
                                            )->a( n = `justifyContent` v = `Center`
                                            )->a( n = `alignItems`     v = `End`
                                            )->a( n = `width`          v = `100%`
                                            )->a( n = `class`          v = `sapUiSmallMargin`

                                            )->tag( `NumericContent`
                                                )->a( n = `value`      v = `7`
                                                )->a( n = `valueColor` v = `Error`
                                                )->a( n = `width`      v = `100%`

                                            )->tag( `Text`
                                                )->a( n = `text` v = `Failed Jobs`

                                        )->end(
                                    )->end(
                                    )->ele( n = `layoutData` ns = `f`
                                        )->tag( n = `GridContainerItemLayoutData` ns = `f`
                                            )->a( n = `columns` v = `2`
                                            )->a( n = `minRows` v = `2`

                                    )->end(
                                )->end(
                                )->ele( n = `Card` ns = `f`
                                    )->a( n = `height` v = `100%`

                                    )->ele( n = `content` ns = `f`
                                        )->ele( `VBox`
                                            )->a( n = `justifyContent` v = `Center`
                                            )->a( n = `alignItems`     v = `End`
                                            )->a( n = `width`          v = `100%`
                                            )->a( n = `class`          v = `sapUiSmallMargin`

                                            )->tag( `NumericContent`
                                                )->a( n = `value`      v = `42`
                                                )->a( n = `valueColor` v = `Neutral`
                                                )->a( n = `width`      v = `100%`

                                            )->tag( `Text`
                                                )->a( n = `text` v = `Scheduled Jobs`

                                        )->end(
                                    )->end(
                                    )->ele( n = `layoutData` ns = `f`
                                        )->tag( n = `GridContainerItemLayoutData` ns = `f`
                                            )->a( n = `columns` v = `2`
                                            )->a( n = `minRows` v = `2`

                                    )->end(
                                )->end(
                                )->ele( n = `Card` ns = `f`
                                    )->a( n = `height` v = `100%`

                                    )->ele( n = `content` ns = `f`
                                        )->ele( `VBox`
                                            )->a( n = `justifyContent` v = `Center`
                                            )->a( n = `alignItems`     v = `End`
                                            )->a( n = `width`          v = `100%`
                                            )->a( n = `class`          v = `sapUiSmallMargin`

                                            )->tag( `NumericContent`
                                                )->a( n = `value`      v = `12`
                                                )->a( n = `valueColor` v = `Good`
                                                )->a( n = `width`      v = `100%`

                                            )->tag( `Text`
                                                )->a( n = `text` v = `Running Jobs`

                                        )->end(
                                    )->end(
                                    )->ele( n = `layoutData` ns = `f`
                                        )->tag( n = `GridContainerItemLayoutData` ns = `f`
                                            )->a( n = `columns` v = `2`
                                            )->a( n = `minRows` v = `2`

                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(
            )->end(
        )->end(
    )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `LAYOUT_CHANGE`.
        " onLayoutChangeMain: remember the layout and recompute every group's
        " current column count from model/home.json's per-breakpoint table
        currentbreakpoint = client->get_event_arg( ).
        columns_apply( currentbreakpoint ).

      WHEN `COLUMNS_CHANGE`.
        " onColumnsChange: below 14 grid columns the users / user-provisioning
        " cards stay 4 columns wide, from 14 on they take 5
        card_columns = COND #( WHEN CONV i( client->get_event_arg( ) ) < 14 THEN 4 ELSE 5 ).

    ENDCASE.

  ENDMETHOD.


  METHOD columns_apply.

    " model/home.json's /layout/<group>/columns table: the value for the
    " current breakpoint, falling back to `default` - what the original's
    " onLayoutChangeMain looks up per group
    group1_columns = SWITCH #( layout
                                 WHEN `S`    THEN 4
                                 WHEN `ML`   THEN 12
                                 WHEN `L`    THEN 12
                                 WHEN `XL`   THEN 12
                                 WHEN `XXL`  THEN 14
                                 WHEN `XXXL` THEN 11
                                 ELSE 10 ).
    group2_columns = 4.
    group3_columns = SWITCH #( layout
                                 WHEN `S`    THEN 4
                                 WHEN `XXXL` THEN 4
                                 ELSE 7 ).
    group4_columns = 4.

  ENDMETHOD.


  METHOD model_init.

    " model/home.json. The two image sources go through the original's
    " formatSrc (sap.ui.require.toUrl over the sample folder), resolved here to
    " the OpenUI5 host per the asset-URL rule
    homeiconsrc  = `https://sdk.openui5.org/test-resources/sap/ui/layout/demokit/sample/ProductHomeLayout/images/SAP_Logo.png`.
    user_iconsrc = `https://sdk.openui5.org/test-resources/sap/ui/layout/demokit/sample/ProductHomeLayout/images/Donna_Moore.png`.

    " the same formatSrc call for the two card manifests, which onInit pushes
    " into the Cards - a manifest URL, which is what a string manifest means
    manifest_users         = `https://sdk.openui5.org/test-resources/sap/ui/layout/demokit/sample/ProductHomeLayout/cards/UsersCard/manifest.json`.
    manifest_logonrequests = `https://sdk.openui5.org/test-resources/sap/ui/layout/demokit/sample/ProductHomeLayout/cards/LogonRequestsCard/manifest.json`.

    " /layout/<group>/columns/current is null in the JSON and is only filled by
    " the first layoutChange; the port seeds every group with its own `default`
    " so the grid has a valid column count on the very first render
    columns_apply( `` ).
    card_columns = 4.

  ENDMETHOD.

ENDCLASS.
