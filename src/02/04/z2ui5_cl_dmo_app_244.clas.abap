CLASS z2ui5_cl_dmo_app_244 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_dmo_app_244 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      show_footer = abap_true.
      avatar_size = `XL`.
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " sap.f.DynamicPage with a responsive Avatar. showFooter is two-way bound to
    " a model flag ({/SHOW_FOOTER}, default true) and Toggle Footer flips it -
    " the faithful abap2UI5 form of the controller's imperative setShowFooter.
    " The Home/Examples/Avatar presses raise client-composed MessageToasts.
    " breakpointChange (the sample's point) is wired as a view attribute (the
    " original attaches it in onInit) and drives both Avatars' bound displaySize.
    " test-resources image URLs point at the sdk.openui5.org host (offline rule).
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:f`      v = `sap.f`
        )->a( n = `xmlns:layout` v = `sap.ui.layout`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `height`       v = `100%`

        )->open( n = `DynamicPage` ns = `f`
            )->a( n = `id`         v = `dynamicPageId`
            )->a( n = `showFooter` v = client->_bind( show_footer )
            " added wire (declared): the controller attaches this in onInit
            )->a( n = `breakpointChange` v = client->_event( val   = `BREAKPOINT_CHANGE`
                                                             t_arg = VALUE #( ( `${$parameters>/currentRange}` ) ( `${$parameters>/currentWidth}` ) ) )

            )->open( n = `title` ns = `f`
                )->open( n = `DynamicPageTitle` ns = `f`

                    )->open( n = `breadcrumbs` ns = `f`
                        )->open( `Breadcrumbs`
                            )->a( n = `currentLocationText` v = `Responsive Avatar Demo`
                            )->leaf( `Link`
                                )->a( n = `text`  v = `Home`
                                )->a( n = `press` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Home pressed` ) ) )
                            )->leaf( `Link`
                                )->a( n = `text`  v = `Examples`
                                )->a( n = `press` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Examples pressed` ) ) )

                    )->shut(
                    )->shut(

                    )->open( n = `heading` ns = `f`
                        )->open( `HBox`
                            )->leaf( `Title`
                                )->a( n = `text`     v = `Denise Smith`
                                )->a( n = `wrapping` v = `true`
                            )->leaf( `ObjectMarker`
                                )->a( n = `type`  v = `Favorite`
                                )->a( n = `class` v = `sapUiTinyMarginBegin`

                    )->shut(
                    )->shut(

                    )->open( n = `expandedContent` ns = `f`
                        )->leaf( `Text`
                            )->a( n = `text` v = `Senior UI Developer`

                    )->shut(

                    )->open( n = `snappedContent` ns = `f`
                        )->open( `FlexBox`
                            )->a( n = `fitContainer` v = `true`
                            )->a( n = `alignItems`   v = `Center`
                            )->leaf( `Avatar`
                                )->a( n = `id`          v = `snappedAvatar`
                                )->a( n = `displaySize` v = client->_bind( avatar_size )
                                )->a( n = `src`         v = `https://sdk.openui5.org/test-resources/sap/uxap/images/imageID_275314.png`
                                )->a( n = `class` v = `sapUiTinyMarginEnd`
                            )->leaf( `Text`
                                )->a( n = `text` v = `Senior UI Developer`

                    )->shut(
                    )->shut(

                    )->open( n = `actions` ns = `f`
                        )->open( `OverflowToolbarButton`
                            )->a( n = `icon`    v = `sap-icon://edit`
                            )->a( n = `text`    v = `Edit`
                            )->a( n = `type`    v = `Emphasized`
                            )->a( n = `tooltip` v = `Edit`
                            )->open( `layoutData`
                                )->leaf( `OverflowToolbarLayoutData`
                                    )->a( n = `priority` v = `NeverOverflow`

                        )->shut(
                        )->shut(
                        )->leaf( `Button`
                            )->a( n = `text`  v = `Toggle Footer`
                            )->a( n = `press` v = client->_event( `TOGGLE_FOOTER` )

                    )->shut(
                    )->shut(
                )->shut(

            )->open( n = `header` ns = `f`
                )->open( n = `DynamicPageHeader` ns = `f`
                    )->a( n = `pinnable` v = `true`

                    )->open( `FlexBox`
                        )->a( n = `wrap`  v = `Wrap`
                        )->a( n = `class` v = `sapUiSmallMarginBottom`

                        )->leaf( `Avatar`
                            )->a( n = `id`          v = `headerAvatar`
                            )->a( n = `displaySize` v = client->_bind( avatar_size )
                            )->a( n = `class`       v = `sapUiSmallMarginEnd`
                            )->a( n = `src`         v = `https://sdk.openui5.org/test-resources/sap/uxap/images/imageID_275314.png`
                            )->a( n = `press` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Avatar pressed` ) ) )

                        )->open( n = `VerticalLayout` ns = `layout`
                            )->a( n = `class` v = `sapUiSmallMarginBeginEnd`
                            )->leaf( `Link`
                                )->a( n = `text` v = `+33 6 4512 5158`
                            )->leaf( `Link`
                                )->a( n = `text` v = `DeniseSmith@sap.com`

                        )->shut(

                        )->open( n = `VerticalLayout` ns = `layout`
                            )->a( n = `class` v = `sapUiSmallMarginBeginEnd`
                            )->leaf( `Label`
                                )->a( n = `text` v = `San Jose, USA`
                            )->leaf( `Label`
                                )->a( n = `text` v = `Resize the browser to see the Avatar adapt`

                    )->shut(
                    )->shut(

                    )->leaf( `MessageStrip`
                        )->a( n = `text`     v = `The Avatar size changes automatically based on screen size: Phone (M), Tablet (L), Desktop/DesktopExtraLarge (XL). This is handled using the breakpointChange event.`
                        )->a( n = `type`     v = `Information`
                        )->a( n = `showIcon` v = `true`
                        )->a( n = `class`    v = `sapUiTinyMarginTopBottom`

                )->shut(
                )->shut(

            )->open( n = `content` ns = `f`
                )->open( `VBox`
                    )->a( n = `class` v = `sapUiContentPadding`

                    )->leaf( `Title`
                        )->a( n = `text`       v = `About`
                        )->a( n = `titleStyle` v = `H2`
                        )->a( n = `class`      v = `sapUiMediumMarginBottom`

                    )->open( n = `VerticalLayout` ns = `layout`
                        )->a( n = `class` v = `sapUiSmallMarginBottom`
                        )->leaf( `Title`
                            )->a( n = `text`  v = `Responsive Avatar Example`
                            )->a( n = `level` v = `H3`
                        )->leaf( `Text`
                            )->a( n = `text` v = `This sample demonstrates how to use the breakpointChange event to make Avatar sizes responsive.`
                        )->leaf( `Text`
                            )->a( n = `text` v = `The DynamicPage fires the breakpointChange event whenever its width changes and crosses a breakpoint.`
                        )->leaf( `Text`
                            )->a( n = `text` v = `The application can handle this event to adjust UI elements like Avatar sizes accordingly.`
                        )->leaf( `Text`
                            )->a( n = `class` v = `sapUiSmallMarginTop`
                            )->a( n = `text`  v = `Breakpoints:`
                        )->leaf( `Text`
                            )->a( n = `text` v = `- Phone: less than 600px ? Avatar size M (4rem)`
                        )->leaf( `Text`
                            )->a( n = `text` v = `- Tablet: 600px - 1024px ? Avatar size L (5rem)`
                        )->leaf( `Text`
                            )->a( n = `text` v = `- Desktop: 1024px - 1439px ? Avatar size XL (7rem)`
                        )->leaf( `Text`
                            )->a( n = `text` v = `- DesktopExtraLarge: 1440px and above ? Avatar size XL (7rem)`

                    )->shut(

                    )->leaf( `Title`
                        )->a( n = `text`       v = `Implementation`
                        )->a( n = `titleStyle` v = `H2`
                        )->a( n = `class`      v = `sapUiMediumMarginTopBottom`

                    )->open( n = `VerticalLayout` ns = `layout`
                        )->a( n = `class` v = `sapUiSmallMarginBottom`
                        )->leaf( `Title`
                            )->a( n = `text`  v = `How it Works`
                            )->a( n = `level` v = `H3`
                        )->leaf( `Text`
                            )->a( n = `text` v = `1. Attach to the breakpointChange event in the controller's onInit method`
                        )->leaf( `Text`
                            )->a( n = `text` v = `2. In the event handler, get the currentRange parameter (Phone/Tablet/Desktop/DesktopExtraLarge)`
                        )->leaf( `Text`
                            )->a( n = `text` v = `3. Map the range to appropriate Avatar sizes using a switch statement`
                        )->leaf( `Text`
                            )->a( n = `text` v = `4. Update the Avatar's displaySize property`
                        )->leaf( `Text`
                            )->a( n = `class` v = `sapUiSmallMarginTop`
                            )->a( n = `text`  v = `The event provides two parameters:`
                        )->leaf( `Text`
                            )->a( n = `text` v = `- currentRange: The media range name (Phone, Tablet, Desktop, or DesktopExtraLarge)`
                        )->leaf( `Text`
                            )->a( n = `text` v = `- currentWidth: The current width of the control in pixels`

                    )->shut(

                    )->leaf( `Title`
                        )->a( n = `text`       v = `Additional Content`
                        )->a( n = `titleStyle` v = `H2`
                        )->a( n = `class`      v = `sapUiMediumMarginTopBottom`

                    )->open( n = `VerticalLayout` ns = `layout`
                        )->leaf( `Title`
                            )->a( n = `text`  v = `Benefits`
                            )->a( n = `level` v = `H3`
                        )->leaf( `Text`
                            )->a( n = `text` v = `- Full application control over responsive behavior`
                        )->leaf( `Text`
                            )->a( n = `text` v = `- Simple event-based API`
                        )->leaf( `Text`
                            )->a( n = `text` v = `- Can be used for any responsive UI adjustments, not just Avatars`
                        )->leaf( `Text`
                            )->a( n = `text` v = `- Works seamlessly with FlexibleColumnLayout and other container controls`

                    )->shut(
                    )->shut(
                )->shut(

            )->open( n = `footer` ns = `f`
                )->open( `OverflowToolbar`
                    )->leaf( `ToolbarSpacer`
                    )->leaf( `Button`
                        )->a( n = `type` v = `Accept`
                        )->a( n = `text` v = `Accept`
                    )->leaf( `Button`
                        )->a( n = `type` v = `Reject`
                        )->a( n = `text` v = `Reject`

            )->shut(
            )->shut(
        )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `TOGGLE_FOOTER`.
        " toggleFooter: setShowFooter(!getShowFooter()) - reproduced by flipping
        " the two-way bound flag and pushing the model back to the client
        show_footer = xsdbool( show_footer = abap_false ).

      WHEN `BREAKPOINT_CHANGE`.
        " onBreakpointChange: map the media range to the Avatar size (Phone M,
        " Tablet L, Desktop/DesktopExtraLarge XL), update both bound Avatars
        " and toast 'Media Range: <range> (<width>px)'
        DATA(lv_range) = client->get_event_arg( ).
        DATA(lv_width) = client->get_event_arg( 2 ).
        avatar_size = SWITCH #( lv_range
                                WHEN `Phone`  THEN `M`
                                WHEN `Tablet` THEN `L`
                                ELSE `XL` ).
        client->message_toast_display( |Media Range: { lv_range } ({ lv_width }px)| ).
    ENDCASE.

  ENDMETHOD.

ENDCLASS.
