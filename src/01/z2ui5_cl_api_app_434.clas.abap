"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.m.Image - ImageModeBackground
"! https://sdk.openui5.org/entity/sap.m.Image/sample/sap.m.sample.ImageModeBackground
CLASS z2ui5_cl_api_app_434 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_434 IMPLEMENTATION.

  " NOTES (generation):
  " - IMPROVISED: the original binds src/mode/height/width to a JSONModel
  "   (img>/products, /imageMode, /imageHeight, /imageWidth); the fixed sample
  "   values are inlined here as literals (mode Background, the HT-7777 / HT-6100
  "   demo images).
  " - IMPROVISED: image height/width are device dependent in the original
  "   (5em on a phone) - fixed to 10em here.
  " - IMPROVISED: the custom CSS class imageContainer (light blue background) of
  "   the box4 HBox is dropped - its stylesheet is not available in abap2UI5.

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
        )->attr( n = `xmlns`     v = `sap.m`
        )->attr( n = `xmlns:l`   v = `sap.ui.layout`
        )->attr( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->open( n = `VerticalLayout` ns = `l`
            )->attr( n = `class` v = `sapUiContentPadding`
            )->attr( n = `width` v = `100%`

            )->open( n = `content` ns = `l`
                )->open( n = `Grid` ns = `l`
                    )->attr( n = `defaultSpan` v = `XL3 L3 M6 S12`

                    )->open( n = `content` ns = `l`
                        )->open( `VBox`
                            )->attr( n = `alignItems` v = `Center`

                            " image size is device dependent in the original (5em on a phone) - fixed to 10em here
                            )->open( `Image`
                                )->attr( n = `src`    v = pic1
                                )->attr( n = `mode`   v = `Background`
                                )->attr( n = `height` v = `10em`
                                )->attr( n = `width`  v = `10em`

                                )->open( `layoutData`
                                    )->leaf( `FlexItemData`
                                        )->attr( n = `growFactor` v = `1`
                                )->shut(
                            )->shut(
                            )->leaf( `Text`
                                )->attr( n = `text`  v = `Background covers the entire container`
                                )->attr( n = `class` v = `sapUiSmallMarginTop`

                        )->shut(
                        )->open( `VBox`
                            )->attr( n = `alignItems` v = `Center`

                            )->open( `Image`
                                )->attr( n = `src`                v = pic1
                                )->attr( n = `mode`               v = `Background`
                                )->attr( n = `height`             v = `10em`
                                )->attr( n = `backgroundSize`     v = `5em 5em`
                                )->attr( n = `backgroundPosition` v = `center`
                                )->attr( n = `width`              v = `10em`

                                )->open( `layoutData`
                                    )->leaf( `FlexItemData`
                                        )->attr( n = `growFactor` v = `1`
                                )->shut(
                            )->shut(
                            )->leaf( `Text`
                                )->attr( n = `text`  v = `Center placed background`
                                )->attr( n = `class` v = `sapUiSmallMarginTop`

                        )->shut(
                        )->open( `VBox`
                            )->attr( n = `alignItems` v = `Center`

                            )->open( `Image`
                                )->attr( n = `src`              v = pic1
                                )->attr( n = `mode`             v = `Background`
                                )->attr( n = `height`           v = `10em`
                                )->attr( n = `backgroundSize`   v = `2em 2em`
                                )->attr( n = `backgroundRepeat` v = `repeat`
                                )->attr( n = `width`            v = `10em`

                                )->open( `layoutData`
                                    )->leaf( `FlexItemData`
                                        )->attr( n = `growFactor` v = `1`
                                )->shut(
                            )->shut(
                            )->leaf( `Text`
                                )->attr( n = `text`  v = `Repeating background`
                                )->attr( n = `class` v = `sapUiSmallMarginTop`

                        )->shut(
                        )->open( `VBox`
                            )->attr( n = `alignItems` v = `Center`

                            " custom CSS class imageContainer (light blue background) of the HBox omitted - stylesheet not available in abap2UI5
                            )->open( `HBox`
                                )->leaf( `Image`
                                    )->attr( n = `src`                v = pic3
                                    )->attr( n = `mode`               v = `Background`
                                    )->attr( n = `height`             v = `10em`
                                    )->attr( n = `backgroundSize`     v = `contain`
                                    )->attr( n = `backgroundPosition` v = `center center`
                                    )->attr( n = `width`              v = `6em`

                            )->shut(
                            )->leaf( `Text`
                                )->attr( n = `text`  v = `The background adjusts its lower dimension in order to fit in the container`
                                )->attr( n = `class` v = `sapUiSmallMarginTop`

                        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
