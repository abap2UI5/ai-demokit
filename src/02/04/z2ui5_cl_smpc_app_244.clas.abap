" @keywords dynamicpage dynamic sap.f dynamicpageresponsiveavatar dynamicpagetitle breadcrumbs link hbox title objectmarker text flexbox
" @summary Dynamic Page demonstrating the breakpointChange event to adjust Avatar sizes responsively based on breakpoints.
CLASS z2ui5_cl_smpc_app_244 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_smpc_app_244 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      show_footer = abap_true.
      avatar_size = `XL`.
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

    " sap.f.DynamicPage with a responsive Avatar. showFooter is two-way bound to
    " a model flag ({/SHOW_FOOTER}, default true) and Toggle Footer flips it -
    " the faithful abap2UI5 form of the controller's imperative setShowFooter.
    " The Home/Examples/Avatar presses raise client-composed MessageToasts.
    " breakpointChange (the sample's point) is wired as a view attribute (the
    " original attaches it in onInit) and drives both Avatars' bound displaySize.
    " test-resources image URLs point at the sdk.openui5.org host (offline rule).
    
    CLEAR temp1.
    INSERT `${$parameters>/currentRange}` INTO TABLE temp1.
    INSERT `${$parameters>/currentWidth}` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `MESSAGE_TOAST` INTO TABLE temp2.
    INSERT `show` INTO TABLE temp2.
    INSERT `Home pressed` INTO TABLE temp2.
    
    CLEAR temp3.
    INSERT `MESSAGE_TOAST` INTO TABLE temp3.
    INSERT `show` INTO TABLE temp3.
    INSERT `Examples pressed` INTO TABLE temp3.
    
    CLEAR temp4.
    INSERT `MESSAGE_TOAST` INTO TABLE temp4.
    INSERT `show` INTO TABLE temp4.
    INSERT `Avatar pressed` INTO TABLE temp4.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:f`      v = `sap.f`
        )->a( n = `xmlns:layout` v = `sap.ui.layout`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `height`       v = `100%`

        )->ele( n = `DynamicPage` ns = `f`
            )->a( n = `id`         v = `dynamicPageId`
            )->a( n = `showFooter` v = client->_bind( show_footer )
            " added wire (declared): the controller attaches this in onInit
            )->a( n = `breakpointChange` v = client->_event( val   = `BREAKPOINT_CHANGE`
                                                             t_arg = temp1 )

            )->ele( n = `title` ns = `f`
                )->ele( n = `DynamicPageTitle` ns = `f`

                    )->ele( n = `breadcrumbs` ns = `f`
                        )->ele( `Breadcrumbs`
                            )->a( n = `currentLocationText` v = `Responsive Avatar Demo`
                            )->tag( `Link`
                                )->a( n = `text`  v = `Home`
                                )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp2 )
                            )->tag( `Link`
                                )->a( n = `text`  v = `Examples`
                                )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp3 )

                        )->end(
                    )->end(

                    )->ele( n = `heading` ns = `f`
                        )->ele( `HBox`
                            )->tag( `Title`
                                )->a( n = `text`     v = `Denise Smith`
                                )->a( n = `wrapping` v = `true`
                            )->tag( `ObjectMarker`
                                )->a( n = `type`  v = `Favorite`
                                )->a( n = `class` v = `sapUiTinyMarginBegin`

                        )->end(
                    )->end(

                    )->ele( n = `expandedContent` ns = `f`
                        )->tag( `Text`
                            )->a( n = `text` v = `Senior UI Developer`

                    )->end(

                    )->ele( n = `snappedContent` ns = `f`
                        )->ele( `FlexBox`
                            )->a( n = `fitContainer` v = `true`
                            )->a( n = `alignItems`   v = `Center`
                            )->tag( `Avatar`
                                )->a( n = `id`          v = `snappedAvatar`
                                )->a( n = `displaySize` v = client->_bind( avatar_size )
                                )->a( n = `src`         v = `https://sdk.openui5.org/test-resources/sap/uxap/images/imageID_275314.png`
                                )->a( n = `class` v = `sapUiTinyMarginEnd`
                            )->tag( `Text`
                                )->a( n = `text` v = `Senior UI Developer`

                        )->end(
                    )->end(

                    )->ele( n = `actions` ns = `f`
                        )->ele( `OverflowToolbarButton`
                            )->a( n = `icon`    v = `sap-icon://edit`
                            )->a( n = `text`    v = `Edit`
                            )->a( n = `type`    v = `Emphasized`
                            )->a( n = `tooltip` v = `Edit`
                            )->ele( `layoutData`
                                )->tag( `OverflowToolbarLayoutData`
                                    )->a( n = `priority` v = `NeverOverflow`

                            )->end(
                        )->end(
                        )->tag( `Button`
                            )->a( n = `text`  v = `Toggle Footer`
                            )->a( n = `press` v = client->_event( `TOGGLE_FOOTER` )

                    )->end(
                )->end(
            )->end(

            )->ele( n = `header` ns = `f`
                )->ele( n = `DynamicPageHeader` ns = `f`
                    )->a( n = `pinnable` v = `true`

                    )->ele( `FlexBox`
                        )->a( n = `wrap`  v = `Wrap`
                        )->a( n = `class` v = `sapUiSmallMarginBottom`

                        )->tag( `Avatar`
                            )->a( n = `id`          v = `headerAvatar`
                            )->a( n = `displaySize` v = client->_bind( avatar_size )
                            )->a( n = `class`       v = `sapUiSmallMarginEnd`
                            )->a( n = `src`         v = `https://sdk.openui5.org/test-resources/sap/uxap/images/imageID_275314.png`
                            )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp4 )

                        )->ele( n = `VerticalLayout` ns = `layout`
                            )->a( n = `class` v = `sapUiSmallMarginBeginEnd`
                            )->tag( `Link`
                                )->a( n = `text` v = `+33 6 4512 5158`
                            )->tag( `Link`
                                )->a( n = `text` v = `DeniseSmith@sap.com`

                        )->end(

                        )->ele( n = `VerticalLayout` ns = `layout`
                            )->a( n = `class` v = `sapUiSmallMarginBeginEnd`
                            )->tag( `Label`
                                )->a( n = `text` v = `San Jose, USA`
                            )->tag( `Label`
                                )->a( n = `text` v = `Resize the browser to see the Avatar adapt`

                        )->end(
                    )->end(

                    )->tag( `MessageStrip`
                        )->a( n = `text`     v = `The Avatar size changes automatically based on screen size: Phone (M), Tablet (L), Desktop/DesktopExtraLarge (XL). This is handled using the breakpointChange event.`
                        )->a( n = `type`     v = `Information`
                        )->a( n = `showIcon` v = `true`
                        )->a( n = `class`    v = `sapUiTinyMarginTopBottom`

                )->end(
            )->end(

            )->ele( n = `content` ns = `f`
                )->ele( `VBox`
                    )->a( n = `class` v = `sapUiContentPadding`

                    )->tag( `Title`
                        )->a( n = `text`       v = `About`
                        )->a( n = `titleStyle` v = `H2`
                        )->a( n = `class`      v = `sapUiMediumMarginBottom`

                    )->ele( n = `VerticalLayout` ns = `layout`
                        )->a( n = `class` v = `sapUiSmallMarginBottom`
                        )->tag( `Title`
                            )->a( n = `text`  v = `Responsive Avatar Example`
                            )->a( n = `level` v = `H3`
                        )->tag( `Text`
                            )->a( n = `text` v = `This sample demonstrates how to use the breakpointChange event to make Avatar sizes responsive.`
                        )->tag( `Text`
                            )->a( n = `text` v = `The DynamicPage fires the breakpointChange event whenever its width changes and crosses a breakpoint.`
                        )->tag( `Text`
                            )->a( n = `text` v = `The application can handle this event to adjust UI elements like Avatar sizes accordingly.`
                        )->tag( `Text`
                            )->a( n = `class` v = `sapUiSmallMarginTop`
                            )->a( n = `text`  v = `Breakpoints:`
                        )->tag( `Text`
                            )->a( n = `text` v = `- Phone: less than 600px ? Avatar size M (4rem)`
                        )->tag( `Text`
                            )->a( n = `text` v = `- Tablet: 600px - 1024px ? Avatar size L (5rem)`
                        )->tag( `Text`
                            )->a( n = `text` v = `- Desktop: 1024px - 1439px ? Avatar size XL (7rem)`
                        )->tag( `Text`
                            )->a( n = `text` v = `- DesktopExtraLarge: 1440px and above ? Avatar size XL (7rem)`

                    )->end(

                    )->tag( `Title`
                        )->a( n = `text`       v = `Implementation`
                        )->a( n = `titleStyle` v = `H2`
                        )->a( n = `class`      v = `sapUiMediumMarginTopBottom`

                    )->ele( n = `VerticalLayout` ns = `layout`
                        )->a( n = `class` v = `sapUiSmallMarginBottom`
                        )->tag( `Title`
                            )->a( n = `text`  v = `How it Works`
                            )->a( n = `level` v = `H3`
                        )->tag( `Text`
                            )->a( n = `text` v = `1. Attach to the breakpointChange event in the controller's onInit method`
                        )->tag( `Text`
                            )->a( n = `text` v = `2. In the event handler, get the currentRange parameter (Phone/Tablet/Desktop/DesktopExtraLarge)`
                        )->tag( `Text`
                            )->a( n = `text` v = `3. Map the range to appropriate Avatar sizes using a switch statement`
                        )->tag( `Text`
                            )->a( n = `text` v = `4. Update the Avatar's displaySize property`
                        )->tag( `Text`
                            )->a( n = `class` v = `sapUiSmallMarginTop`
                            )->a( n = `text`  v = `The event provides two parameters:`
                        )->tag( `Text`
                            )->a( n = `text` v = `- currentRange: The media range name (Phone, Tablet, Desktop, or DesktopExtraLarge)`
                        )->tag( `Text`
                            )->a( n = `text` v = `- currentWidth: The current width of the control in pixels`

                    )->end(

                    )->tag( `Title`
                        )->a( n = `text`       v = `Additional Content`
                        )->a( n = `titleStyle` v = `H2`
                        )->a( n = `class`      v = `sapUiMediumMarginTopBottom`

                    )->ele( n = `VerticalLayout` ns = `layout`
                        )->tag( `Title`
                            )->a( n = `text`  v = `Benefits`
                            )->a( n = `level` v = `H3`
                        )->tag( `Text`
                            )->a( n = `text` v = `- Full application control over responsive behavior`
                        )->tag( `Text`
                            )->a( n = `text` v = `- Simple event-based API`
                        )->tag( `Text`
                            )->a( n = `text` v = `- Can be used for any responsive UI adjustments, not just Avatars`
                        )->tag( `Text`
                            )->a( n = `text` v = `- Works seamlessly with FlexibleColumnLayout and other container controls`

                    )->end(
                )->end(
            )->end(

            )->ele( n = `footer` ns = `f`
                )->ele( `OverflowToolbar`
                    )->tag( `ToolbarSpacer`
                    )->tag( `Button`
                        )->a( n = `type` v = `Accept`
                        )->a( n = `text` v = `Accept`
                    )->tag( `Button`
                        )->a( n = `type` v = `Reject`
                        )->a( n = `text` v = `Reject`

                )->end(
            )->end(
        )->end(
    )->end( ).

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
        " and toast 'Media Range: <range> (<width>px)'
        
        lv_range = client->get_event_arg( ).
        
        lv_width = client->get_event_arg( 2 ).
        
        CASE lv_range.
          WHEN `Phone`.
            temp3 = `M`.
          WHEN `Tablet`.
            temp3 = `L`.
          WHEN OTHERS.
            temp3 = `XL`.
        ENDCASE.
        avatar_size = temp3.
        client->message_toast_display( |Media Range: { lv_range } ({ lv_width }px)| ).
    ENDCASE.

  ENDMETHOD.

ENDCLASS.
