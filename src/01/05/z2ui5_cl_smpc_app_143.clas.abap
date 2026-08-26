" @keywords infolabel info label sap.tnt dynamicpage dynamicpagetitle title button dynamicpageheader flexbox panel horizontallayout
" @summary InfoLabel used as subheader in DynamicPage
CLASS z2ui5_cl_smpc_app_143 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA messageslength TYPE i.
    DATA shrink_wide    TYPE abap_bool.
    DATA show_footer    TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_143 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " the two toggles the original drives from its controller are bound instead:
    " showFooter directly, areaShrinkRatio through an expression binding over the
    " same two values the controller alternates between (the property default
    " 1:1.6:1.6 and 1.6:1:1.6). on_event flips the flags - the press wires are
    " dispatched, not decorative
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:tnt`    v = `sap.tnt`
        )->a( n = `xmlns:c`      v = `sap.ui.core`
        )->a( n = `xmlns:sf`     v = `sap.ui.layout.form`
        )->a( n = `xmlns:f`      v = `sap.f`
        )->a( n = `xmlns:layout` v = `sap.ui.layout`
        )->a( n = `height`       v = `100%`

        )->ele( n = `DynamicPage` ns = `f`
            )->a( n = `id`         v = `dynamicPageId`
            )->a( n = `showFooter` v = client->_bind( show_footer )

            )->ele( n = `title` ns = `f`
                )->ele( n = `DynamicPageTitle` ns = `f`
                    )->a( n = `areaShrinkRatio` v = |\{= ${ client->_bind( shrink_wide ) } ? '1.6:1:1.6' : '1:1.6:1.6' \}|
                    )->ele( n = `heading` ns = `f`
                        )->tag( `Title`
                            )->a( n = `text` v = `Delivery order`

                    )->end(
                    )->ele( n = `expandedContent` ns = `f`
                        )->tag( n = `InfoLabel` ns = `tnt`
                            )->a( n = `text` v = `In transit`

                    )->end(
                    )->ele( n = `snappedContent` ns = `f`
                        )->tag( n = `InfoLabel` ns = `tnt`
                            )->a( n = `text` v = `In transit`

                    )->end(
                    )->ele( n = `actions` ns = `f`
                        )->tag( `Button`
                            )->a( n = `text`  v = `Edit`
                            )->a( n = `type`  v = `Emphasized`
                            )->a( n = `press` v = client->_event( `TOGGLE_PRIO` )
                        )->tag( `Button`
                            )->a( n = `text` v = `Delete`
                            )->a( n = `type` v = `Transparent`
                        )->tag( `Button`
                            )->a( n = `text` v = `Copy`
                            )->a( n = `type` v = `Transparent`
                        )->tag( `Button`
                            )->a( n = `text`  v = `Toggle Footer`
                            )->a( n = `type`  v = `Transparent`
                            )->a( n = `press` v = client->_event( `TOGGLE_FOOTER` )
                        )->tag( `Button`
                            )->a( n = `icon` v = `sap-icon://action`
                            )->a( n = `type` v = `Transparent`

                    )->end(
                )->end(
            )->end(

            )->ele( n = `header` ns = `f`
                )->ele( n = `DynamicPageHeader` ns = `f`
                    )->a( n = `pinnable` v = `true`
                    )->ele( `FlexBox`
                        )->a( n = `alignItems`     v = `Start`
                        )->a( n = `justifyContent` v = `SpaceBetween`
                        )->ele( `Panel`
                            )->a( n = `backgroundDesign` v = `Transparent`
                            )->a( n = `class`            v = `sapUiNoContentPadding`
                            )->ele( n = `HorizontalLayout` ns = `layout`
                                )->a( n = `allowWrapping` v = `true`
                                )->ele( n = `VerticalLayout` ns = `layout`
                                    )->a( n = `class` v = `sapUiMediumMarginEnd`
                                    )->tag( `ObjectAttribute`
                                        )->a( n = `title` v = `Location`
                                        )->a( n = `text`  v = `Warehouse A`
                                    )->tag( `ObjectAttribute`
                                        )->a( n = `title` v = `Halway`
                                        )->a( n = `text`  v = `23L`
                                    )->tag( `ObjectAttribute`
                                        )->a( n = `title` v = `Rack`
                                        )->a( n = `text`  v = `34`

                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(
            )->end(

            )->ele( n = `content` ns = `f`
                )->ele( n = `VerticalLayout` ns = `layout`
                    )->tag( `Text`
                        )->a( n = `text` v = `Lorem ipsum dolor sit amet, consectetur adipiscing elit. In vehicula, nulla eget sagittis vulputate, sem dolor iaculis nisi, sit amet semper lectus nibh et leo. Nam ` &&
                                         `luctus ac justo aliquet dignissim. Suspendisse ex magna, volutpat vitae neque ac, iaculis blandit mauris. Vestibulum at vestibulum nisl. Suspendisse eget finibus quam, ` &&
                                         `nec maximus velit. Curabitur lacinia felis odio, quis bibendum nibh dignissim non. Nam consectetur ultricies massa, vel eleifend ligula iaculis in. Sed ac pretium mi, vel ` &&
                                         `condimentum odio. Nulla facilisi. Etiam aliquet cursus tincidunt. Vivamus ex lorem, pharetra eget urna at, blandit mollis quam.`
                    )->tag( `Text`
                        )->a( n = `text` v = `Nunc placerat laoreet cursus. Phasellus porttitor tincidunt consequat. Integer ut elit sodales, tincidunt dolor eu, auctor massa. Aenean venenatis orci a nisi pulvinar, ` &&
                                         `pulvinar sodales sapien tempor. Curabitur metus turpis, tempor quis orci a, luctus tempus turpis. Aenean ac quam venenatis, tempor justo in, imperdiet leo. Duis quis ex ` &&
                                         `et sapien iaculis posuere eu quis eros. Duis semper hendrerit elementum.`

                )->end(
            )->end(

            )->ele( n = `footer` ns = `f`
                )->ele( `OverflowToolbar`
                    )->ele( `Button`
                        )->a( n = `icon`    v = `sap-icon://message-popup`
                        )->a( n = `text`    v = client->_bind( messageslength )
                        )->a( n = `type`    v = `Emphasized`
                        )->a( n = `visible` v = |\{= !!$\{{ client->_bind( val = messageslength path = abap_true ) }\} \}|

                    )->end(
                    )->tag( `ToolbarSpacer`
                    )->tag( `Button`
                        )->a( n = `type` v = `Accept`
                        )->a( n = `text` v = `Accept`
                    )->tag( `Button`
                        )->a( n = `type` v = `Reject`
                        )->a( n = `text` v = `Reject` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `TOGGLE_PRIO`.
        " the original reads the current areaShrinkRatio and alternates it with
        " the property default; the flag carries the same two-state information
        shrink_wide = xsdbool( shrink_wide = abap_false ).

      WHEN `TOGGLE_FOOTER`.
        show_footer = xsdbool( show_footer = abap_false ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
