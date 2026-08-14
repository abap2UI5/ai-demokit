CLASS z2ui5_cl_smpc_app_059 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_059 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    " the six identical filler paragraphs share this literal; attribute whitespace is normalised to single spaces (see sidecar)
    DATA(lorem) = `Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam interdum lectus et tempus blandit. Sed porta ex quis tortor gravida, ut suscipit felis dignissim. Ut iaculis elit vel ligula scelerisque, et porttitor est pretium. ` &&
                  `Suspendisse purus dolor, fermentum in tortor eu, semper finibus velit. Proin vel lobortis leo, vel eleifend lorem. Etiam ac erat sollicitudin, condimentum magna ac, venenatis lacus. ` &&
                  `Pellentesque non mauris consectetur, tristique arcu id, aliquet tortor.`.

    " original demokit sdk asset paths kept 1:1 - not served by abap2UI5 (see sidecar)
    DATA(base) = `test-resources/sap/ui/documentation/sdk/images/`.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->tag( `MessageStrip`
            )->a( n = `text`  v = `Clicking on each of the images will open a LightBox, showing the real size of the image. Images will be scaled down if their size is bigger than the window size.`
            )->a( n = `class` v = `sapUiSmallMargin`

        )->ele( `List`

            )->ele( `CustomListItem`
                )->ele( `HBox`
                    )->a( n = `class` v = `sapUiSmallMargin`
                    )->ele( `Image`
                        )->a( n = `src`          v = base && `HT-6100.jpg`
                        )->a( n = `decorative`   v = `false`
                        )->a( n = `width`        v = `170px`
                        )->a( n = `densityAware` v = `false`
                        )->ele( `detailBox`
                            )->ele( `LightBox`
                                )->tag( `LightBoxItem`
                                    )->a( n = `imageSrc` v = base && `HT-6100-large.jpg`
                                    )->a( n = `alt`      v = `Beamer`
                                    )->a( n = `title`    v = `This is a beamer`
                                    )->a( n = `subtitle` v = `This is beamer's description`

                            )->end(
                        )->end(
                    )->end(
                    )->ele( `VBox`
                        )->a( n = `class` v = `sapUiSmallMarginBegin`
                        )->tag( `Title`
                            )->a( n = `text` v = `Beamer`
                        )->tag( `Text`
                            )->a( n = `text` v = lorem

                    )->end(
                )->end(
            )->end(

            )->ele( `CustomListItem`
                )->ele( `HBox`
                    )->a( n = `class` v = `sapUiSmallMargin`
                    )->ele( `Image`
                        )->a( n = `src`          v = base && `HT-6120.jpg`
                        )->a( n = `decorative`   v = `false`
                        )->a( n = `width`        v = `170px`
                        )->a( n = `densityAware` v = `false`
                        )->ele( `detailBox`
                            )->ele( `LightBox`
                                )->tag( `LightBoxItem`
                                    )->a( n = `imageSrc` v = base && `HT-6120-large.jpg`
                                    )->a( n = `alt`      v = `USB`
                                    )->a( n = `title`    v = `This is a USB`
                                    )->a( n = `subtitle` v = `This is USB's description`

                            )->end(
                        )->end(
                    )->end(
                    )->ele( `VBox`
                        )->a( n = `class` v = `sapUiSmallMarginBegin`
                        )->tag( `Title`
                            )->a( n = `text` v = `USB`
                        )->tag( `Text`
                            )->a( n = `text` v = lorem

                    )->end(
                )->end(
            )->end(

            )->ele( `CustomListItem`
                )->ele( `HBox`
                    )->a( n = `class` v = `sapUiSmallMargin`
                    )->ele( `Image`
                        )->a( n = `src`          v = base && `HT-7777.jpg`
                        )->a( n = `decorative`   v = `false`
                        )->a( n = `width`        v = `170px`
                        )->a( n = `densityAware` v = `false`
                        )->ele( `detailBox`
                            )->ele( `LightBox`
                                )->tag( `LightBoxItem`
                                    )->a( n = `imageSrc` v = base && `HT-7777-large.jpg`
                                    )->a( n = `alt`      v = `Speakers`
                                    )->a( n = `title`    v = `These are speakers`
                                    )->a( n = `subtitle` v = `This is speakers' description`

                            )->end(
                        )->end(
                    )->end(
                    )->ele( `VBox`
                        )->a( n = `class` v = `sapUiSmallMarginBegin`
                        )->tag( `Title`
                            )->a( n = `text` v = `Speakers`
                        )->tag( `Text`
                            )->a( n = `text` v = lorem

                    )->end(
                )->end(
            )->end(

            )->ele( `CustomListItem`
                )->ele( `HBox`
                    )->a( n = `class` v = `sapUiSmallMargin`
                    )->ele( `Image`
                        )->a( n = `src`          v = base && `nature/ALotOfElephants_small.jpg`
                        )->a( n = `decorative`   v = `false`
                        )->a( n = `width`        v = `170px`
                        )->a( n = `densityAware` v = `false`
                        )->ele( `detailBox`
                            )->ele( `LightBox`
                                )->tag( `LightBoxItem`
                                    )->a( n = `imageSrc` v = base && `nature/ALotOfElephants.jpg`
                                    )->a( n = `alt`      v = `Nature image`
                                    )->a( n = `title`    v = `This is a sample image`
                                    )->a( n = `subtitle` v = `This is a place for description`

                            )->end(
                        )->end(
                    )->end(
                    )->ele( `VBox`
                        )->a( n = `class` v = `sapUiSmallMarginBegin`
                        )->tag( `Title`
                            )->a( n = `text` v = `Nature image`
                        )->tag( `Text`
                            )->a( n = `text` v = lorem

                    )->end(
                )->end(
            )->end(

            )->ele( `CustomListItem`
                )->ele( `HBox`
                    )->a( n = `class` v = `sapUiSmallMargin`
                    )->ele( `Image`
                        )->a( n = `src`          v = base && `nature/flatFish.jpg`
                        )->a( n = `decorative`   v = `false`
                        )->a( n = `width`        v = `170px`
                        )->a( n = `densityAware` v = `false`
                        )->ele( `detailBox`
                            )->ele( `LightBox`
                                )->tag( `LightBoxItem`
                                    )->a( n = `imageSrc` v = base && `nature/flatFish.jpg`
                                    )->a( n = `alt`      v = `Nature image`
                                    )->a( n = `title`    v = `This is a sample image`
                                    )->a( n = `subtitle` v = `This is a place for description`

                            )->end(
                        )->end(
                    )->end(
                    )->ele( `VBox`
                        )->a( n = `class` v = `sapUiSmallMarginBegin`
                        )->tag( `Title`
                            )->a( n = `text` v = `Nature image`
                        )->tag( `Text`
                            )->a( n = `text` v = lorem

                    )->end(
                )->end(
            )->end(

            )->ele( `CustomListItem`
                )->ele( `HBox`
                    )->a( n = `class` v = `sapUiSmallMargin`
                    )->ele( `Image`
                        )->a( n = `src`          v = base && `nature/horses.jpg`
                        )->a( n = `decorative`   v = `false`
                        )->a( n = `width`        v = `170px`
                        )->a( n = `densityAware` v = `false`
                        )->ele( `detailBox`
                            )->ele( `LightBox`
                                )->tag( `LightBoxItem`
                                    )->a( n = `imageSrc` v = base && `nature/horses.jpg`
                                    )->a( n = `alt`      v = `Nature image`
                                    )->a( n = `title`    v = `This is a sample image`
                                    )->a( n = `subtitle` v = `This is a place for description`

                            )->end(
                        )->end(
                    )->end(
                    )->ele( `VBox`
                        )->a( n = `class` v = `sapUiSmallMarginBegin`
                        )->tag( `Title`
                            )->a( n = `text` v = `Nature image`
                        )->tag( `Text`
                            )->a( n = `text` v = lorem

                    )->end(
                )->end(
            )->end(

            )->ele( `CustomListItem`
                )->ele( `HBox`
                    )->a( n = `class` v = `sapUiSmallMargin`
                    )->ele( `Image`
                        )->a( n = `src`          v = base && `nature/elephant.jpg`
                        )->a( n = `decorative`   v = `false`
                        )->a( n = `width`        v = `170px`
                        )->a( n = `densityAware` v = `false`
                        )->ele( `detailBox`
                            )->ele( `LightBox`
                                )->tag( `LightBoxItem`
                                    )->a( n = `imageSrc` v = base && `nature/image_does_not_exist.jpg`
                                    )->a( n = `alt`      v = `Nature image`
                                    )->a( n = `title`    v = `This is a sample image`
                                    )->a( n = `subtitle` v = `This is a place for description`

                            )->end(
                        )->end(
                    )->end(
                    )->ele( `VBox`
                        )->a( n = `class` v = `sapUiSmallMarginBegin`
                        )->tag( `Title`
                            )->a( n = `text` v = `Unavailable image`
                        )->tag( `Text`
                            )->a( n = `text` v = `Shows an error when an image could not be loaded, or when it takes too much time to load it.`

                    )->end(
                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
