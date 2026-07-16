"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.m.Image - ImageModeBackground
"! https://sdk.openui5.org/entity/sap.m.Image/sample/sap.m.sample.ImageModeBackground
"! API USAGE AUDIT: (a) frontend_action (_event_client): NO | (b) event t_arg: NO
"! NOTES (generation):
"! - IMPROVISED: the original binds src/mode/height/width to a JSONModel
"!   (img>/products, /imageMode, /imageHeight, /imageWidth); the fixed sample
"!   values are inlined here as literals (mode Background, the HT-7777 / HT-6100
"!   demo images).
"! - IMPROVISED: image height/width are device dependent in the original
"!   (5em on a phone) - fixed to 10em here.
"! - IMPROVISED: the custom CSS class imageContainer (light blue background) of
"!   the box4 HBox is dropped - its stylesheet is not available in abap2UI5.
CLASS z2ui5_cl_api_app_434 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_434 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    " fixed values of the original img JSONModel (/products/pic1, /products/pic3)
    DATA(pic1) = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7777-large.jpg`.
    DATA(pic3) = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6100-large.jpg`.

    DATA(view) = z2ui5_cl_api_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->open( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->open( n = `content` ns = `l`
                )->open( n = `Grid` ns = `l`
                    )->a( n = `defaultSpan` v = `XL3 L3 M6 S12`

                    )->open( n = `content` ns = `l`
                        )->open( `VBox`
                            )->a( n = `alignItems` v = `Center`

                            " image size is device dependent in the original (5em on a phone) - fixed to 10em here
                            )->open( `Image`
                                )->a( n = `src`    v = pic1
                                )->a( n = `mode`   v = `Background`
                                )->a( n = `height` v = `10em`
                                )->a( n = `width`  v = `10em`

                                )->open( `layoutData`
                                    )->leaf( `FlexItemData`
                                        )->a( n = `growFactor` v = `1`
                                )->shut(
                            )->shut(
                            )->leaf( `Text`
                                )->a( n = `text`  v = `Background covers the entire container`
                                )->a( n = `class` v = `sapUiSmallMarginTop`

                        )->shut(
                        )->open( `VBox`
                            )->a( n = `alignItems` v = `Center`

                            )->open( `Image`
                                )->a( n = `src`                v = pic1
                                )->a( n = `mode`               v = `Background`
                                )->a( n = `height`             v = `10em`
                                )->a( n = `backgroundSize`     v = `5em 5em`
                                )->a( n = `backgroundPosition` v = `center`
                                )->a( n = `width`              v = `10em`

                                )->open( `layoutData`
                                    )->leaf( `FlexItemData`
                                        )->a( n = `growFactor` v = `1`
                                )->shut(
                            )->shut(
                            )->leaf( `Text`
                                )->a( n = `text`  v = `Center placed background`
                                )->a( n = `class` v = `sapUiSmallMarginTop`

                        )->shut(
                        )->open( `VBox`
                            )->a( n = `alignItems` v = `Center`

                            )->open( `Image`
                                )->a( n = `src`              v = pic1
                                )->a( n = `mode`             v = `Background`
                                )->a( n = `height`           v = `10em`
                                )->a( n = `backgroundSize`   v = `2em 2em`
                                )->a( n = `backgroundRepeat` v = `repeat`
                                )->a( n = `width`            v = `10em`

                                )->open( `layoutData`
                                    )->leaf( `FlexItemData`
                                        )->a( n = `growFactor` v = `1`
                                )->shut(
                            )->shut(
                            )->leaf( `Text`
                                )->a( n = `text`  v = `Repeating background`
                                )->a( n = `class` v = `sapUiSmallMarginTop`

                        )->shut(
                        )->open( `VBox`
                            )->a( n = `alignItems` v = `Center`

                            " custom CSS class imageContainer (light blue background) of the HBox omitted - stylesheet not available in abap2UI5
                            )->open( `HBox`
                                )->leaf( `Image`
                                    )->a( n = `src`                v = pic3
                                    )->a( n = `mode`               v = `Background`
                                    )->a( n = `height`             v = `10em`
                                    )->a( n = `backgroundSize`     v = `contain`
                                    )->a( n = `backgroundPosition` v = `center center`
                                    )->a( n = `width`              v = `6em`

                            )->shut(
                            )->leaf( `Text`
                                )->a( n = `text`  v = `The background adjusts its lower dimension in order to fit in the container`
                                )->a( n = `class` v = `sapUiSmallMarginTop`

                        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
