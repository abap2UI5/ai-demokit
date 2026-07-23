CLASS z2ui5_cl_ai_app_143 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA messageslength TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_143 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:tnt`    v = `sap.tnt`
        )->a( n = `xmlns:c`      v = `sap.ui.core`
        )->a( n = `xmlns:sf`     v = `sap.ui.layout.form`
        )->a( n = `xmlns:f`      v = `sap.f`
        )->a( n = `xmlns:layout` v = `sap.ui.layout`
        )->a( n = `height`       v = `100%`

        )->open( n = `DynamicPage` ns = `f`
            )->a( n = `id` v = `dynamicPageId`

            )->open( n = `title` ns = `f`
                )->open( n = `DynamicPageTitle` ns = `f`
                    )->open( n = `heading` ns = `f`
                        )->leaf( `Title`
                            )->a( n = `text` v = `Delivery order`

                    )->shut(
                    )->open( n = `expandedContent` ns = `f`
                        )->leaf( n = `InfoLabel` ns = `tnt`
                            )->a( n = `text` v = `In transit`

                    )->shut(
                    )->open( n = `snappedContent` ns = `f`
                        )->leaf( n = `InfoLabel` ns = `tnt`
                            )->a( n = `text` v = `In transit`

                    )->shut(
                    )->open( n = `actions` ns = `f`
                        )->leaf( `Button`
                            )->a( n = `text`  v = `Edit`
                            )->a( n = `type`  v = `Emphasized`
                            )->a( n = `press` v = client->_event( `TOGGLE_PRIO` )
                        )->leaf( `Button`
                            )->a( n = `text` v = `Delete`
                            )->a( n = `type` v = `Transparent`
                        )->leaf( `Button`
                            )->a( n = `text` v = `Copy`
                            )->a( n = `type` v = `Transparent`
                        )->leaf( `Button`
                            )->a( n = `text`  v = `Toggle Footer`
                            )->a( n = `type`  v = `Transparent`
                            )->a( n = `press` v = client->_event( `TOGGLE_FOOTER` )
                        )->leaf( `Button`
                            )->a( n = `icon` v = `sap-icon://action`
                            )->a( n = `type` v = `Transparent`

                    )->shut(
                )->shut(
            )->shut(

            )->open( n = `header` ns = `f`
                )->open( n = `DynamicPageHeader` ns = `f`
                    )->a( n = `pinnable` v = `true`
                    )->open( `FlexBox`
                        )->a( n = `alignItems`     v = `Start`
                        )->a( n = `justifyContent` v = `SpaceBetween`
                        )->open( `Panel`
                            )->a( n = `backgroundDesign` v = `Transparent`
                            )->a( n = `class`            v = `sapUiNoContentPadding`
                            )->open( n = `HorizontalLayout` ns = `layout`
                                )->a( n = `allowWrapping` v = `true`
                                )->open( n = `VerticalLayout` ns = `layout`
                                    )->a( n = `class` v = `sapUiMediumMarginEnd`
                                    )->leaf( `ObjectAttribute`
                                        )->a( n = `title` v = `Location`
                                        )->a( n = `text`  v = `Warehouse A`
                                    )->leaf( `ObjectAttribute`
                                        )->a( n = `title` v = `Halway`
                                        )->a( n = `text`  v = `23L`
                                    )->leaf( `ObjectAttribute`
                                        )->a( n = `title` v = `Rack`
                                        )->a( n = `text`  v = `34`

                    )->shut(
                    )->shut(
                    )->shut(
                    )->shut(
                )->shut(
            )->shut(

            )->open( n = `content` ns = `f`
                )->open( n = `VerticalLayout` ns = `layout`
                    )->leaf( `Text`
                    )->a( n = `text` v = `Lorem ipsum dolor sit amet, consectetur adipiscing elit. In vehicula, nulla eget sagittis vulputate, sem dolor iaculis nisi, sit amet semper lectus nibh et leo. Nam ` &&
                                         `luctus ac justo aliquet dignissim. Suspendisse ex magna, volutpat vitae neque ac, iaculis blandit mauris. Vestibulum at vestibulum nisl. Suspendisse eget finibus quam, ` &&
                                         `nec maximus velit. Curabitur lacinia felis odio, quis bibendum nibh dignissim non. Nam consectetur ultricies massa, vel eleifend ligula iaculis in. Sed ac pretium mi, vel ` &&
                                         `condimentum odio. Nulla facilisi. Etiam aliquet cursus tincidunt. Vivamus ex lorem, pharetra eget urna at, blandit mollis quam.`
                    )->leaf( `Text`
                    )->a( n = `text` v = `Nunc placerat laoreet cursus. Phasellus porttitor tincidunt consequat. Integer ut elit sodales, tincidunt dolor eu, auctor massa. Aenean venenatis orci a nisi pulvinar, ` &&
                                         `pulvinar sodales sapien tempor. Curabitur metus turpis, tempor quis orci a, luctus tempus turpis. Aenean ac quam venenatis, tempor justo in, imperdiet leo. Duis quis ex ` &&
                                         `et sapien iaculis posuere eu quis eros. Duis semper hendrerit elementum.`

                )->shut(
            )->shut(

            )->open( n = `footer` ns = `f`
                )->open( `OverflowToolbar`
                    )->open( `Button`
                        )->a( n = `icon`    v = `sap-icon://message-popup`
                        )->a( n = `text`    v = client->_bind( messageslength )
                        )->a( n = `type`    v = `Emphasized`
                        )->a( n = `visible` v = |\{= !!$\{{ client->_bind( val = messageslength path = abap_true ) }\} \}|

                    )->shut(
                    )->leaf( `ToolbarSpacer`
                    )->leaf( `Button`
                        )->a( n = `type` v = `Accept`
                        )->a( n = `text` v = `Accept`
                    )->leaf( `Button`
                        )->a( n = `type` v = `Reject`
                        )->a( n = `text` v = `Reject` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
