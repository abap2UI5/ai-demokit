" @keywords objectpagelayout object layout sap.uxap objectpageresponsiveavatar objectpagedynamicheadertitle objectpagesection objectpagesubsection
CLASS z2ui5_cl_smpc_app_262 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA show_footer TYPE abap_bool.
    DATA avatar_size TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_262 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      show_footer = abap_false.
      avatar_size = `L`.
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " sap.uxap ObjectPage with a responsive Avatar (app 244 is the sap.f
    " DynamicPage twin of this sample). showFooter is two-way bound to a model
    " flag ({/SHOW_FOOTER}, seeded false like the original default) and Toggle
    " Footer flips it - the faithful abap2UI5 form of the controller's
    " imperative setShowFooter. The breadcrumb and edit-header presses raise
    " client-composed MessageToasts. breakpointChange (the sample's point) is
    " wired as a view attribute (the original attaches it in onInit) and drives
    " both Avatars' bound displaySize. test-resources image URLs point at the
    " sdk.openui5.org host (offline rule).
    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`       v = `100%`
        )->a( n = `xmlns`        v = `sap.uxap`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:m`      v = `sap.m`
        )->a( n = `xmlns:layout` v = `sap.ui.layout`

        )->ele( `ObjectPageLayout`
            )->a( n = `id`                       v = `ObjectPageLayout`
            )->a( n = `showTitleInHeaderContent` v = `true`
            )->a( n = `showEditHeaderButton`     v = `true`
            )->a( n = `editHeaderButtonPress`    v = client->follow_up_action( val   = client->cs_event-control_global
                                                                               t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Edit header button pressed` ) ) )
            )->a( n = `upperCaseAnchorBar`       v = `false`
            " added wires (declared): the footer flag the controller toggles
            " imperatively, and the breakpointChange the controller attaches
            " in onInit
            )->a( n = `showFooter`               v = client->_bind( show_footer )
            )->a( n = `breakpointChange`         v = client->_event( val   = `BREAKPOINT_CHANGE`
                                                                     t_arg = VALUE #( ( `${$parameters>/currentRange}` ) ( `${$parameters>/currentWidth}` ) ) )

            )->ele( `headerTitle`
                )->ele( `ObjectPageDynamicHeaderTitle`
                    )->ele( `breadcrumbs`
                        )->ele( n = `Breadcrumbs` ns = `m`
                            )->a( n = `currentLocationText` v = `Responsive Avatar Demo`

                            )->tag( n = `Link` ns = `m`
                                )->a( n = `text`  v = `Home`
                                )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                                t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Page 1 a very long link clicked` ) ) )
                            )->tag( n = `Link` ns = `m`
                                )->a( n = `text`  v = `Examples`
                                )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                                t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Page 2 long link clicked` ) ) )

                        )->end(
                    )->end(

                    )->ele( `expandedHeading`
                        )->ele( n = `HBox` ns = `m`
                            )->tag( n = `Title` ns = `m`
                                )->a( n = `text`     v = `Denise Smith`
                                )->a( n = `wrapping` v = `true`
                            )->tag( n = `ObjectMarker` ns = `m`
                                )->a( n = `type`  v = `Favorite`
                                )->a( n = `class` v = `sapUiTinyMarginBegin`

                        )->end(
                    )->end(

                    )->ele( `snappedHeading`
                        )->ele( n = `FlexBox` ns = `m`
                            )->a( n = `fitContainer` v = `true`
                            )->a( n = `alignItems`   v = `Center`

                            )->tag( n = `Avatar` ns = `m`
                                )->a( n = `id`          v = `snappedAvatar`
                                )->a( n = `src`         v = `https://sdk.openui5.org/test-resources/sap/uxap/images/imageID_275314.png`
                                )->a( n = `class`       v = `sapUiTinyMarginEnd`
                                )->a( n = `displaySize` v = client->_bind( avatar_size )
                            )->tag( n = `Title` ns = `m`
                                )->a( n = `text`     v = `Denise Smith`
                                )->a( n = `wrapping` v = `true`

                        )->end(
                    )->end(

                    )->ele( `expandedContent`
                        )->tag( n = `Text` ns = `m`
                            )->a( n = `text` v = `Senior UI Developer`

                    )->end(

                    )->ele( `snappedContent`
                        )->tag( n = `Text` ns = `m`
                            )->a( n = `text` v = `Senior UI Developer`

                    )->end(

                    )->ele( `actions`
                        )->ele( n = `OverflowToolbarButton` ns = `m`
                            )->a( n = `icon`    v = `sap-icon://edit`
                            )->a( n = `text`    v = `Edit`
                            )->a( n = `type`    v = `Emphasized`
                            )->a( n = `tooltip` v = `edit`

                            )->ele( n = `layoutData` ns = `m`
                                )->tag( n = `OverflowToolbarLayoutData` ns = `m`
                                    )->a( n = `priority` v = `NeverOverflow`

                            )->end(
                        )->end(

                        )->tag( n = `Button` ns = `m`
                            )->a( n = `text`  v = `Toggle Footer`
                            )->a( n = `press` v = client->_event( `TOGGLE_FOOTER` )

                    )->end(
                )->end(
            )->end(

            )->ele( `headerContent`
                )->ele( n = `FlexBox` ns = `m`
                    )->a( n = `wrap` v = `Wrap`

                    )->tag( n = `Avatar` ns = `m`
                        )->a( n = `id`          v = `headerAvatar`
                        )->a( n = `class`       v = `sapUiSmallMarginEnd`
                        )->a( n = `src`         v = `https://sdk.openui5.org/test-resources/sap/uxap/images/imageID_275314.png`
                        )->a( n = `displaySize` v = client->_bind( avatar_size )

                    )->ele( n = `VerticalLayout` ns = `layout`
                        )->a( n = `class` v = `sapUiSmallMarginBeginEnd`

                        )->tag( n = `Link` ns = `m`
                            )->a( n = `text` v = `+33 6 4512 5158`
                        )->tag( n = `Link` ns = `m`
                            )->a( n = `text` v = `DeniseSmith@sap.com`

                    )->end(

                    )->ele( n = `VerticalLayout` ns = `layout`
                        )->a( n = `class` v = `sapUiSmallMarginBeginEnd`

                        )->tag( n = `Label` ns = `m`
                            )->a( n = `text` v = `San Jose, USA`
                        )->tag( n = `Label` ns = `m`
                            )->a( n = `text` v = `Resize the browser to see the Avatar adapt`

                    )->end(
                )->end(

                )->tag( n = `MessageStrip` ns = `m`
                    )->a( n = `text`     v = `The Avatar size changes automatically based on screen size: `
                                          && `Phone (M), Tablet (L), Desktop/DesktopExtraLarge (XL). `
                                          && `This is handled using the breakpointChange event.`
                    )->a( n = `type`     v = `Information`
                    )->a( n = `showIcon` v = `true`
                    )->a( n = `class`    v = `sapUiTinyMarginTopBottom`

            )->end(

            )->ele( `sections`
                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `About`

                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->ele( `blocks`
                                )->ele( n = `VerticalLayout` ns = `layout`
                                    )->tag( n = `Title` ns = `m`
                                        )->a( n = `text`  v = `Responsive Avatar Example`
                                        )->a( n = `level` v = `H3`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `This sample demonstrates how to use the breakpointChange event to make Avatar sizes responsive.`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `The ObjectPageLayout fires the breakpointChange event whenever its width changes and crosses a breakpoint.`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `The application can handle this event to adjust UI elements like Avatar sizes accordingly.`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `class` v = `sapUiSmallMarginTop`
                                        )->a( n = `text`  v = `Breakpoints:`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `- Phone: < 600px -> Avatar size M (4rem)`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `- Tablet: 600px - 1024px -> Avatar size L (5rem)`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `- Desktop: 1024px - 1439px -> Avatar size XL (7rem)`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `- DesktopExtraLarge: >= 1440px -> Avatar size XL (7rem)`

                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `Implementation`

                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->ele( `blocks`
                                )->ele( n = `VerticalLayout` ns = `layout`
                                    )->tag( n = `Title` ns = `m`
                                        )->a( n = `text`  v = `How it Works`
                                        )->a( n = `level` v = `H3`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `1. Attach to the breakpointChange event in the controller's onInit method`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `2. In the event handler, get the currentRange parameter (Phone/Tablet/Desktop/DesktopExtraLarge)`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `3. Map the range to appropriate Avatar sizes using a switch statement`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `4. Update the Avatar's displaySize property`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `class` v = `sapUiSmallMarginTop`
                                        )->a( n = `text`  v = `The event provides two parameters:`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `- currentRange: The media range name (Phone, Tablet, Desktop, or DesktopExtraLarge)`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `- currentWidth: The current width of the control in pixels`

                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `Additional Content`

                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->ele( `blocks`
                                )->ele( n = `VerticalLayout` ns = `layout`
                                    )->tag( n = `Title` ns = `m`
                                        )->a( n = `text`  v = `Benefits`
                                        )->a( n = `level` v = `H3`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `- Full application control over responsive behavior`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `- Simple event-based API`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `- Can be used for any responsive UI adjustments, not just Avatars`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `- Works seamlessly with FlexibleColumnLayout and other container controls`

                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(
            )->end(

            )->ele( `footer`
                )->ele( n = `OverflowToolbar` ns = `m`
                    )->tag( n = `ToolbarSpacer` ns = `m`
                    )->tag( n = `Button` ns = `m`
                        )->a( n = `type` v = `Accept`
                        )->a( n = `text` v = `Accept`
                    )->tag( n = `Button` ns = `m`
                        )->a( n = `type` v = `Reject`
                        )->a( n = `text` v = `Reject`

                ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).
      WHEN `TOGGLE_FOOTER`.
        " toggleFooter: setShowFooter(!getShowFooter()) - reproduced by flipping
        " the two-way bound flag and pushing the model back to the client
        show_footer = xsdbool( show_footer = abap_false ).

      WHEN `BREAKPOINT_CHANGE`.
        " onBreakpointChange: map the media range to the Avatar size (Phone M,
        " Tablet L, Desktop/DesktopExtraLarge XL), update both bound Avatars
        " and toast 'Media Range: <range> (<width>px) Avatar Size: <size>'
        DATA(lv_range) = client->get_event_arg( ).
        DATA(lv_width) = client->get_event_arg( 2 ).
        avatar_size = SWITCH #( lv_range
                                WHEN `Phone`  THEN `M`
                                WHEN `Tablet` THEN `L`
                                WHEN `Desktop` THEN `XL`
                                WHEN `DesktopExtraLarge` THEN `XL`
                                ELSE `L` ).
        client->message_toast_display( |Media Range: { lv_range } ({ lv_width }px)\nAvatar Size: { avatar_size }| ).
    ENDCASE.

  ENDMETHOD.

ENDCLASS.
