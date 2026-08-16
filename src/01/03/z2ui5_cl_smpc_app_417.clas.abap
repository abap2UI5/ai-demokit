" @keywords objectpageheader object header sap.uxap objectpagedynamicsidecontentbtn objectpagelayout objectpageheaderactionbutton objectpagesection objectpagesubsection
" @summary The sample shows Object Page inside a main content of DynamicSideContent. The ObjectPageHeader has property DynamicSideContentButton set to true which is used to show the side panel of DynamicSideContent.
CLASS z2ui5_cl_smpc_app_417 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA show_side        TYPE abap_bool.
    DATA open_btn_visible TYPE abap_bool.

  PROTECTED SECTION.
    DATA client     TYPE REF TO z2ui5_if_client.
    DATA breakpoint TYPE string.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_417 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      " the original view starts with showSideContent="false"; the open button
      " is visible until the side content is shown (updateToggleButtonState)
      show_side        = abap_false.
      open_btn_visible = abap_true.
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " the controller's ObjectPageModel (SharedJSONData employee.json) is never
    " bound by any control in this view, so no model is seeded; the side
    " content and the open button are driven through two-way bound properties
    " instead of the controller's imperative setters. style.css is injected as
    " a core:HTML style leaf.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns`      v = `sap.uxap`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:m`    v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->tag( n = `HTML` ns = `core`
            )->a( n = `content` v = `<style>.sapUiTheme-sap_bluecrystal .sapUiDSC \{ background-color: rgb(242, 248, 252); \}</style>`

        )->ele( n = `DynamicSideContent` ns = `l`
            )->a( n = `id`                  v = `DynamicSideContent`
            )->a( n = `class`               v = `sapUiDSCExplored`
            )->a( n = `sideContentFallDown` v = `BelowM`
            )->a( n = `sideContentPosition` v = `End`
            )->a( n = `containerQuery`      v = `true`
            )->a( n = `showSideContent`     v = client->_bind( show_side )
            )->a( n = `breakpointChanged`   v = client->_event( val   = `BP_CHANGED`
                                                                t_arg = VALUE #( ( `${$parameters>/currentBreakpoint}` ) ) )

            )->ele( n = `mainContent` ns = `l`
                )->ele( `ObjectPageLayout`
                    )->a( n = `id`                       v = `ObjectPageLayout`
                    )->a( n = `showTitleInHeaderContent` v = `true`
                    )->a( n = `upperCaseAnchorBar`       v = `false`

                    )->ele( `headerTitle`
                        )->ele( `ObjectPageHeader`
                            )->a( n = `id`                            v = `headerForTest`
                            )->a( n = `objectTitle`                   v = `Denise Smith`
                            )->a( n = `showTitleSelector`             v = `true`
                            )->a( n = `showMarkers`                   v = `true`
                            )->a( n = `markFavorite`                  v = `true`
                            )->a( n = `markFlagged`                   v = `true`
                            )->a( n = `objectSubtitle`                v = `Senior Developer`
                            )->a( n = `objectImageURI`                v = `https://sdk.openui5.org/test-resources/sap/uxap/images/imageID_273624.png`
                            )->a( n = `objectImageShape`              v = `Circle`
                            )->a( n = `isObjectTitleAlwaysVisible`    v = `false`
                            )->a( n = `isObjectSubtitleAlwaysVisible` v = `false`

                            )->ele( `sideContentButton`
                                " the controller hides this button while the side content is open
                                " (setVisible) - here that state is the bound visible flag
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`      v = `openSideContentBtn`
                                    )->a( n = `icon`    v = `sap-icon://detail-view`
                                    )->a( n = `type`    v = `Transparent`
                                    )->a( n = `press`   v = client->_event( `OPEN_SIDE_CONTENT` )
                                    )->a( n = `tooltip` v = `detail-view`
                                    )->a( n = `visible` v = client->_bind( open_btn_visible )

                            )->end(
                            )->ele( `actions`
                                )->tag( `ObjectPageHeaderActionButton`
                                    )->a( n = `text`    v = `Public Profile`
                                    )->a( n = `icon`    v = `sap-icon://edit`
                                    )->a( n = `tooltip` v = `edit`
                                )->tag( `ObjectPageHeaderActionButton`
                                    )->a( n = `text`    v = `Take Action`
                                    )->a( n = `icon`    v = `sap-icon://action`
                                    )->a( n = `tooltip` v = `action`

                            )->end(
                        )->end(
                    )->end(

                    )->ele( `headerContent`
                        )->ele( n = `VerticalLayout` ns = `l`
                            )->tag( n = `Link` ns = `m`
                                )->a( n = `text` v = `denise-smith`
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `(321) 123-4567`
                            )->tag( n = `Link` ns = `m`
                                )->a( n = `text` v = `DeniseSmith@sap.com`
                            )->ele( n = `HorizontalLayout` ns = `l`
                                )->tag( n = `Image` ns = `m`
                                    )->a( n = `height` v = `24px`
                                    )->a( n = `width`  v = `24px`
                                    )->a( n = `src`    v = `https://sdk.openui5.org/test-resources/sap/uxap/images/twitterIcon.png`
                                )->tag( n = `Image` ns = `m`
                                    )->a( n = `height` v = `24px`
                                    )->a( n = `width`  v = `24px`
                                    )->a( n = `src`    v = `https://sdk.openui5.org/test-resources/sap/uxap/images/linkedInIcon.png`

                            )->end(
                        )->end(

                        )->tag( n = `Text` ns = `m`
                            )->a( n = `width` v = `200px`
                            )->a( n = `text`  v = `Hi, I'm Denise. I am passionate about what I do and I'll go the extra mile to make the customer win.`

                        )->ele( n = `VerticalLayout` ns = `l`
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Profile completion`
                            )->tag( n = `ProgressIndicator` ns = `m`
                                )->a( n = `percentValue` v = `30`
                                )->a( n = `displayValue` v = `30%`
                                )->a( n = `showValue`    v = `true`
                                )->a( n = `state`        v = `None`

                        )->end(
                    )->end(

                    )->ele( `sections`
                        )->ele( `ObjectPageSection`
                            )->a( n = `titleUppercase` v = `false`
                            )->a( n = `title`          v = `2014 Goals Plan`

                            )->ele( `subSections`
                                )->ele( `ObjectPageSubSection`
                                    )->a( n = `titleUppercase` v = `false`

                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `width` v = `200px`
                                        )->a( n = `text`  v = `Hi, I'm Denise. I am passionate about what I do and I'll go the extra mile to make the customer win.`

                                )->end(
                            )->end(
                        )->end(

                        )->ele( `ObjectPageSection`
                            )->a( n = `titleUppercase` v = `false`
                            )->a( n = `title`          v = `Personal`

                            )->ele( `subSections`
                                )->ele( `ObjectPageSubSection`
                                    )->a( n = `title`          v = `Connect`
                                    )->a( n = `titleUppercase` v = `false`

                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `width` v = `200px`
                                        )->a( n = `text`  v = `Hi, I'm Denise. I am passionate about what I do and I'll go the extra mile to make the customer win.`

                                )->end(
                                " the original's blocks and moreBlocks aggregation tags are empty
                                " and are not written - aggregations are optional in XML
                                )->tag( `ObjectPageSubSection`
                                    )->a( n = `id`             v = `paymentSubSection`
                                    )->a( n = `title`          v = `Payment information`
                                    )->a( n = `titleUppercase` v = `false`

                            )->end(
                        )->end(
                    )->end(
                )->end(
            )->end(

            )->ele( n = `sideContent` ns = `l`
                )->ele( n = `Toolbar` ns = `m`
                    )->tag( n = `Title` ns = `m`
                        )->a( n = `text` v = `My tasks`
                    )->tag( n = `ToolbarSpacer` ns = `m`
                    )->tag( n = `Button` ns = `m`
                        )->a( n = `id`    v = `closeSideContentBtn`
                        )->a( n = `text`  v = `Close`
                        )->a( n = `type`  v = `Transparent`
                        )->a( n = `press` v = client->_event( `CLOSE_SIDE_CONTENT` )

                )->end(
                )->tag( n = `Text` ns = `m`
                    )->a( n = `text` v = ` Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco ` &&
                                     `laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non ` &&
                                     `proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna ` &&
                                     `aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum ` &&
                                     `dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur ` &&
                                     `adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo ` &&
                                     `consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia ` &&
                                     `deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, ` &&
                                     `quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. ` &&
                                     `Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor ` &&
                                     `incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in ` &&
                                     `reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. ` &&
                                     `Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco ` &&
                                     `laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non ` &&
                                     `proident, sunt in culpa qui officia deserunt mollit anim id est laborum.` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `BP_CHANGED`.
        " updateToggleButtonState: the open button shows on breakpoint S
        " or while the side content is hidden
        breakpoint = client->get_event_arg( ).
        open_btn_visible = xsdbool( breakpoint = `S` OR show_side = abap_false ).

      WHEN `OPEN_SIDE_CONTENT`.
        " handleSCBtnPress shows the side content - on S the original calls
        " toggle, otherwise the setter of the bound showSideContent property -
        " then hides its own button and moves the focus to the Close button
        show_side        = abap_true.
        open_btn_visible = abap_false.
        client->follow_up_action( val   = client->cs_event-set_focus
                                  t_arg = VALUE #( ( `closeSideContentBtn` ) ) ).

      WHEN `CLOSE_SIDE_CONTENT`.
        " handleSideContentHide hides the side content, shows the open button
        " again and moves the focus back to it
        show_side        = abap_false.
        open_btn_visible = abap_true.
        client->follow_up_action( val   = client->cs_event-set_focus
                                  t_arg = VALUE #( ( `openSideContentBtn` ) ) ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
