CLASS z2ui5_cl_dmo_app_399 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_dmo_app_399 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " the controller's imageWidth is Device.system.phone ? 5em : 10em - kept a
    " branch over the framework's device> model instead of resolving it at init
    DATA(image_width) = `{= ${device>/system/phone} ? '5em' : '10em' }`.
    " fixed values of the original models: img>/products/pic1, pic3 and the
    " sample's own images/sap-logo.svg
    DATA(pic1)     = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7777-large.jpg`.
    DATA(pic3)     = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6100-large.jpg`.
    DATA(svg_logo) = `https://sdk.openui5.org/test-resources/sap/m/sample/Image/images/sap-logo.svg`.

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->open( `VBox`
            )->a( n = `class` v = `sapUiSmallMarginTopBottom sapUiLargeMarginBeginEnd`

            )->open( `HBox`
                )->a( n = `justifyContent` v = `SpaceBetween`

                )->open( `VBox`
                    )->leaf( `Text`
                        )->a( n = `text`  v = `Image:`
                        )->a( n = `class` v = `sapUiSmallMarginBottom`
                    )->leaf( `Image`
                        )->a( n = `src`   v = pic1
                        )->a( n = `width` v = image_width

                )->shut(
                )->open( `VBox`
                    )->leaf( `Text`
                        )->a( n = `id`    v = `detailsActiveImage`
                        )->a( n = `text`  v = `Active state image:`
                        )->a( n = `class` v = `sapUiSmallMarginBottom`
                    )->leaf( `Image`
                        " ariaDetails is newer than the 1.71 floor - kept for the 1:1 port (POST_171)
                        )->a( n = `ariaDetails` v = `detailsActiveImage`
                        )->a( n = `src`         v = pic3
                        )->a( n = `width`       v = image_width
                        )->a( n = `decorative`  v = `false`
                        )->a( n = `press`       v = client->follow_up_action( val   = client->cs_event-control_global
                                                                              t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `The image has been pressed` ) ) )

                )->shut(
                )->open( `VBox`
                    )->leaf( `Text`
                        )->a( n = `text`  v = `Image using SVG format:`
                        )->a( n = `class` v = `sapUiSmallMarginBottom`
                    )->leaf( `Image`
                        )->a( n = `src` v = svg_logo

                )->shut(
                )->open( `VBox`
                    )->leaf( `Text`
                        )->a( n = `text`  v = `Image displaying inline SVG:`
                        )->a( n = `class` v = `sapUiSmallMarginBottom`
                    )->leaf( `Image`
                        )->a( n = `src`  v = svg_logo
                        )->a( n = `mode` v = `InlineSvg` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
