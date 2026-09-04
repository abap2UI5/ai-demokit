" @keywords objectpagelayout object layout sap.uxap objectpageresponsiveavatar objectpagedynamicheadertitle breadcrumbs link hbox title objectmarker flexbox
" @summary ObjectPage sample demonstrating the breakpointChange event to adjust Avatar sizes responsively based on screen size (phone: M, tablet: L, desktop/desktop_XL: XL).
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
    IF client->check_on_init( ) IS NOT INITIAL.
      show_footer = abap_false.
      " the control's own default - the original view sets no displaySize.
      " The controller's L belongs to _getAvatarSizeForRange, which only
      " onBreakpointChange calls; it is never the initial size
      avatar_size = `S`.
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    DATA temp2 TYPE string_table.
    DATA temp3 TYPE string_table.
    DATA temp4 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " sap.uxap ObjectPage with a responsive Avatar (app 244 is the sap.f
    " DynamicPage twin of this sample). showFooter is two-way bound to a model
    " flag ({/SHOW_FOOTER}, seeded false like the original default) and Toggle
    " Footer flips it - the faithful abap2UI5 form of the controller's
    " imperative setShowFooter. The breadcrumb and edit-header presses raise
    " client-composed MessageToasts. breakpointChange (the sample's point) is
    " wired as a view attribute (the original attaches it in onInit) and drives
    " both Avatars' bound displaySize. test-resources image URLs point at the
    " sdk.openui5.org host (offline rule).
    
    CLEAR temp1.
    INSERT `MESSAGE_TOAST` INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    INSERT `Edit header button pressed` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `${$parameters>/currentRange}` INTO TABLE temp2.
    INSERT `${$parameters>/currentWidth}` INTO TABLE temp2.
    
    CLEAR temp3.
    INSERT `MESSAGE_TOAST` INTO TABLE temp3.
    INSERT `show` INTO TABLE temp3.
    INSERT `Page 1 a very long link clicked` INTO TABLE temp3.
    
    CLEAR temp4.
    INSERT `MESSAGE_TOAST` INTO TABLE temp4.
    INSERT `show` INTO TABLE temp4.
    INSERT `Page 2 long link clicked` INTO TABLE temp4.
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
                                                                               t_arg = temp1 )
            )->a( n = `upperCaseAnchorBar`       v = `false`
            " added wires (declared): the footer flag the controller toggles
            " imperatively, and the breakpointChange the controller attaches
            " in onInit
            )->a( n = `showFooter`               v = client->_bind( show_footer )
            )->a( n = `breakpointChange`         v = client->_event( val   = `BREAKPOINT_CHANGE`
                                                                     t_arg = temp2 )

            )->ele( `headerTitle`
                )->ele( `ObjectPageDynamicHeaderTitle`
                    )->ele( `breadcrumbs`
                        )->ele( n = `Breadcrumbs` ns = `m`
                            )->a( n = `currentLocationText` v = `Responsive Avatar Demo`

                            )->tag( n = `Link` ns = `m`
                                )->a( n = `text`  v = `Home`
                                )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                                t_arg = temp3 )
                            )->tag( n = `Link` ns = `m`
                                )->a( n = `text`  v = `Examples`
                                )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                                t_arg = temp4 )

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
        DATA temp1 TYPE xsdboolean.
        DATA lv_range TYPE string.
        DATA lv_width TYPE string.
        DATA temp3 TYPE string.

    CASE client->get_event( ).
      WHEN `TOGGLE_FOOTER`.
        " toggleFooter: setShowFooter(!getShowFooter()) - reproduced by flipping
        " the two-way bound flag and pushing the model back to the client
        
        temp1 = boolc( show_footer = abap_false ).
        show_footer = temp1.

      WHEN `BREAKPOINT_CHANGE`.
        " onBreakpointChange: map the media range to the Avatar size (Phone M,
        " Tablet L, Desktop/DesktopExtraLarge XL), update both bound Avatars
        " and toast 'Media Range: <range> (<width>px) Avatar Size: <size>'
        
        lv_range = client->get_event_arg( ).
        
        lv_width = client->get_event_arg( 2 ).
        
        CASE lv_range.
          WHEN `Phone`.
            temp3 = `M`.
          WHEN `Tablet`.
            temp3 = `L`.
          WHEN `Desktop`.
            temp3 = `XL`.
          WHEN `DesktopExtraLarge`.
            temp3 = `XL`.
          WHEN OTHERS.
            temp3 = `L`.
        ENDCASE.
        avatar_size = temp3.
        client->message_toast_display( |Media Range: { lv_range } ({ lv_width }px)\nAvatar Size: { avatar_size }| ).
    ENDCASE.

  ENDMETHOD.

ENDCLASS.
