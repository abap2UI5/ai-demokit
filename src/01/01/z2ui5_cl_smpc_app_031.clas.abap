" @keywords image sap.m visualizes state html verticallayout grid vbox flexitemdata text hbox
" @summary Visualizes the state of the control when the mode property is set to ImageMode.Background.
CLASS z2ui5_cl_smpc_app_031 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_031 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    " fixed values of the original img JSONModel (/products/pic1, /products/pic3)
    DATA(pic1) = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7777-large.jpg`.
    DATA(pic3) = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6100-large.jpg`.

    " the original's device-dependent image size (5em phone / 10em otherwise), expressed over the framework's device> model
    DATA(size) = `{= ${device>/system/phone} ? '5em' : '10em' }`.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        " the sample's styles.css, injected via a core:HTML content attribute (see CAPABILITIES.md)
        )->tag( n = `HTML` ns = `core`
            " literal braces escaped \{ \} - the XMLView binding parser reads unescaped braces as a binding
            )->a( n = `content` v = `<style>.imageContainer\{background-color:#A9EAFF\}</style>`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->ele( n = `content` ns = `l`
                )->ele( n = `Grid` ns = `l`
                    )->a( n = `defaultSpan` v = `XL3 L3 M6 S12`

                    )->ele( n = `content` ns = `l`
                        )->ele( `VBox`
                            )->a( n = `alignItems` v = `Center`

                            )->ele( `Image`
                                )->a( n = `src`    v = pic1
                                )->a( n = `mode`   v = `Background`
                                )->a( n = `height` v = size
                                )->a( n = `width`  v = size

                                )->ele( `layoutData`
                                    )->tag( `FlexItemData`
                                        )->a( n = `growFactor` v = `1`

                                )->end(
                            )->end(
                            )->tag( `Text`
                                )->a( n = `text`  v = `Background covers the entire container`
                                )->a( n = `class` v = `sapUiSmallMarginTop`

                        )->end(
                        )->ele( `VBox`
                            )->a( n = `alignItems` v = `Center`

                            )->ele( `Image`
                                )->a( n = `src`                v = pic1
                                )->a( n = `mode`               v = `Background`
                                )->a( n = `height`             v = size
                                )->a( n = `backgroundSize`     v = `5em 5em`
                                )->a( n = `backgroundPosition` v = `center`
                                )->a( n = `width`              v = size

                                )->ele( `layoutData`
                                    )->tag( `FlexItemData`
                                        )->a( n = `growFactor` v = `1`

                                )->end(
                            )->end(
                            )->tag( `Text`
                                )->a( n = `text`  v = `Center placed background`
                                )->a( n = `class` v = `sapUiSmallMarginTop`

                        )->end(
                        )->ele( `VBox`
                            )->a( n = `alignItems` v = `Center`

                            )->ele( `Image`
                                )->a( n = `src`              v = pic1
                                )->a( n = `mode`             v = `Background`
                                )->a( n = `height`           v = size
                                )->a( n = `backgroundSize`   v = `2em 2em`
                                )->a( n = `backgroundRepeat` v = `repeat`
                                )->a( n = `width`            v = size

                                )->ele( `layoutData`
                                    )->tag( `FlexItemData`
                                        )->a( n = `growFactor` v = `1`

                                )->end(
                            )->end(
                            )->tag( `Text`
                                )->a( n = `text`  v = `Repeating background`
                                )->a( n = `class` v = `sapUiSmallMarginTop`

                        )->end(
                        )->ele( `VBox`
                            )->a( n = `alignItems` v = `Center`

                            )->ele( `HBox`
                                )->a( n = `class` v = `imageContainer`

                                )->tag( `Image`
                                    )->a( n = `src`                v = pic3
                                    )->a( n = `mode`               v = `Background`
                                    )->a( n = `height`             v = size
                                    )->a( n = `backgroundSize`     v = `contain`
                                    )->a( n = `backgroundPosition` v = `center center`
                                    )->a( n = `width`              v = `6em`

                            )->end(
                            )->tag( `Text`
                                )->a( n = `text`  v = `The background adjusts its lower dimension in order to fit in the container`
                                )->a( n = `class` v = `sapUiSmallMarginTop`

                        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
