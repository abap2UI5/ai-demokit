CLASS z2ui5_cl_ai_app_059 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_059 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(lorem) = `Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam interdum lectus et tempus blandit. Sed porta ex quis tortor gravida, ut suscipit felis dignissim. Ut iaculis elit vel ligula scelerisque, et porttitor est pretium. ` &&
                  `Suspendisse purus dolor, fermentum in tortor eu, semper finibus velit. Proin vel lobortis leo, vel eleifend lorem. Etiam ac erat sollicitudin, condimentum magna ac, venenatis lacus. ` &&
                  `Pellentesque non mauris consectetur, tristique arcu id, aliquet tortor.`.

    DATA(base) = `test-resources/sap/ui/documentation/sdk/images/`.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->leaf( `MessageStrip`
            )->a( n = `text`  v = `Clicking on each of the images will open a LightBox, showing the real size of the image. Images will be scaled down if their size is bigger than the window size.`
            )->a( n = `class` v = `sapUiSmallMargin`

        )->open( `List`

            )->open( `CustomListItem`
                )->open( `HBox`
                    )->a( n = `class` v = `sapUiSmallMargin`
                    )->open( `Image`
                        )->a( n = `src`          v = base && `HT-6100.jpg`
                        )->a( n = `decorative`   v = `false`
                        )->a( n = `width`        v = `170px`
                        )->a( n = `densityAware` v = `false`
                        )->open( `detailBox`
                            )->open( `LightBox`
                                )->leaf( `LightBoxItem`
                                    )->a( n = `imageSrc` v = base && `HT-6100-large.jpg`
                                    )->a( n = `alt`      v = `Beamer`
                                    )->a( n = `title`    v = `This is a beamer`
                                    )->a( n = `subtitle` v = `This is beamer's description`

                            )->shut(
                        )->shut(
                    )->shut(
                    )->open( `VBox`
                        )->a( n = `class` v = `sapUiSmallMarginBegin`
                        )->leaf( `Title`
                            )->a( n = `text` v = `Beamer`
                        )->leaf( `Text`
                            )->a( n = `text` v = lorem

                    )->shut(
                )->shut(
            )->shut(

            )->open( `CustomListItem`
                )->open( `HBox`
                    )->a( n = `class` v = `sapUiSmallMargin`
                    )->open( `Image`
                        )->a( n = `src`          v = base && `HT-6120.jpg`
                        )->a( n = `decorative`   v = `false`
                        )->a( n = `width`        v = `170px`
                        )->a( n = `densityAware` v = `false`
                        )->open( `detailBox`
                            )->open( `LightBox`
                                )->leaf( `LightBoxItem`
                                    )->a( n = `imageSrc` v = base && `HT-6120-large.jpg`
                                    )->a( n = `alt`      v = `USB`
                                    )->a( n = `title`    v = `This is a USB`
                                    )->a( n = `subtitle` v = `This is USB's description`

                            )->shut(
                        )->shut(
                    )->shut(
                    )->open( `VBox`
                        )->a( n = `class` v = `sapUiSmallMarginBegin`
                        )->leaf( `Title`
                            )->a( n = `text` v = `USB`
                        )->leaf( `Text`
                            )->a( n = `text` v = lorem

                    )->shut(
                )->shut(
            )->shut(

            )->open( `CustomListItem`
                )->open( `HBox`
                    )->a( n = `class` v = `sapUiSmallMargin`
                    )->open( `Image`
                        )->a( n = `src`          v = base && `HT-7777.jpg`
                        )->a( n = `decorative`   v = `false`
                        )->a( n = `width`        v = `170px`
                        )->a( n = `densityAware` v = `false`
                        )->open( `detailBox`
                            )->open( `LightBox`
                                )->leaf( `LightBoxItem`
                                    )->a( n = `imageSrc` v = base && `HT-7777-large.jpg`
                                    )->a( n = `alt`      v = `Speakers`
                                    )->a( n = `title`    v = `These are speakers`
                                    )->a( n = `subtitle` v = `This is speakers' description`

                            )->shut(
                        )->shut(
                    )->shut(
                    )->open( `VBox`
                        )->a( n = `class` v = `sapUiSmallMarginBegin`
                        )->leaf( `Title`
                            )->a( n = `text` v = `Speakers`
                        )->leaf( `Text`
                            )->a( n = `text` v = lorem

                    )->shut(
                )->shut(
            )->shut(

            )->open( `CustomListItem`
                )->open( `HBox`
                    )->a( n = `class` v = `sapUiSmallMargin`
                    )->open( `Image`
                        )->a( n = `src`          v = base && `nature/ALotOfElephants_small.jpg`
                        )->a( n = `decorative`   v = `false`
                        )->a( n = `width`        v = `170px`
                        )->a( n = `densityAware` v = `false`
                        )->open( `detailBox`
                            )->open( `LightBox`
                                )->leaf( `LightBoxItem`
                                    )->a( n = `imageSrc` v = base && `nature/ALotOfElephants.jpg`
                                    )->a( n = `alt`      v = `Nature image`
                                    )->a( n = `title`    v = `This is a sample image`
                                    )->a( n = `subtitle` v = `This is a place for description`

                            )->shut(
                        )->shut(
                    )->shut(
                    )->open( `VBox`
                        )->a( n = `class` v = `sapUiSmallMarginBegin`
                        )->leaf( `Title`
                            )->a( n = `text` v = `Nature image`
                        )->leaf( `Text`
                            )->a( n = `text` v = lorem

                    )->shut(
                )->shut(
            )->shut(

            )->open( `CustomListItem`
                )->open( `HBox`
                    )->a( n = `class` v = `sapUiSmallMargin`
                    )->open( `Image`
                        )->a( n = `src`          v = base && `nature/flatFish.jpg`
                        )->a( n = `decorative`   v = `false`
                        )->a( n = `width`        v = `170px`
                        )->a( n = `densityAware` v = `false`
                        )->open( `detailBox`
                            )->open( `LightBox`
                                )->leaf( `LightBoxItem`
                                    )->a( n = `imageSrc` v = base && `nature/flatFish.jpg`
                                    )->a( n = `alt`      v = `Nature image`
                                    )->a( n = `title`    v = `This is a sample image`
                                    )->a( n = `subtitle` v = `This is a place for description`

                            )->shut(
                        )->shut(
                    )->shut(
                    )->open( `VBox`
                        )->a( n = `class` v = `sapUiSmallMarginBegin`
                        )->leaf( `Title`
                            )->a( n = `text` v = `Nature image`
                        )->leaf( `Text`
                            )->a( n = `text` v = lorem

                    )->shut(
                )->shut(
            )->shut(

            )->open( `CustomListItem`
                )->open( `HBox`
                    )->a( n = `class` v = `sapUiSmallMargin`
                    )->open( `Image`
                        )->a( n = `src`          v = base && `nature/horses.jpg`
                        )->a( n = `decorative`   v = `false`
                        )->a( n = `width`        v = `170px`
                        )->a( n = `densityAware` v = `false`
                        )->open( `detailBox`
                            )->open( `LightBox`
                                )->leaf( `LightBoxItem`
                                    )->a( n = `imageSrc` v = base && `nature/horses.jpg`
                                    )->a( n = `alt`      v = `Nature image`
                                    )->a( n = `title`    v = `This is a sample image`
                                    )->a( n = `subtitle` v = `This is a place for description`

                            )->shut(
                        )->shut(
                    )->shut(
                    )->open( `VBox`
                        )->a( n = `class` v = `sapUiSmallMarginBegin`
                        )->leaf( `Title`
                            )->a( n = `text` v = `Nature image`
                        )->leaf( `Text`
                            )->a( n = `text` v = lorem

                    )->shut(
                )->shut(
            )->shut(

            )->open( `CustomListItem`
                )->open( `HBox`
                    )->a( n = `class` v = `sapUiSmallMargin`
                    )->open( `Image`
                        )->a( n = `src`          v = base && `nature/elephant.jpg`
                        )->a( n = `decorative`   v = `false`
                        )->a( n = `width`        v = `170px`
                        )->a( n = `densityAware` v = `false`
                        )->open( `detailBox`
                            )->open( `LightBox`
                                )->leaf( `LightBoxItem`
                                    )->a( n = `imageSrc` v = base && `nature/image_does_not_exist.jpg`
                                    )->a( n = `alt`      v = `Nature image`
                                    )->a( n = `title`    v = `This is a sample image`
                                    )->a( n = `subtitle` v = `This is a place for description`

                            )->shut(
                        )->shut(
                    )->shut(
                    )->open( `VBox`
                        )->a( n = `class` v = `sapUiSmallMarginBegin`
                        )->leaf( `Title`
                            )->a( n = `text` v = `Unavailable image`
                        )->leaf( `Text`
                            )->a( n = `text` v = `Shows an error when an image could not be loaded, or when it takes too much time to load it.`

                    )->shut(
                )->shut(
            )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
