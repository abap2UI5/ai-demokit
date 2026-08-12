CLASS z2ui5_cl_dmo_app_398 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_dmo_app_398 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " fixed values of the original img JSONModel (img>/products/pic1..pic3, screw)
    DATA(base) = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/`.

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `height`    v = `100%`

        )->open( `Title`
            )->a( n = `id`    v = `carouselTitle`
            )->a( n = `class` v = `sapUiSmallMarginTop`
            )->a( n = `text`  v = `Image Gallery Carousel`

        )->shut(

        )->open( `Carousel`
            )->a( n = `ariaLabelledBy` v = `carouselTitle`
            )->a( n = `class`          v = `sapUiContentPadding`
            )->a( n = `loop`           v = `true`

            )->leaf( `Image`
                )->a( n = `src` v = base && `HT-7777-large.jpg`
                )->a( n = `alt` v = `Example picture of speakers`
            )->leaf( `Image`
                )->a( n = `src` v = base && `HT-6120-large.jpg`
                )->a( n = `alt` v = `Example picture of USB flash drive`
            )->leaf( `Image`
                )->a( n = `src` v = base && `HT-6100-large.jpg`
                )->a( n = `alt` v = `Example picture of spotlight`
            )->leaf( `Image`
                )->a( n = `src` v = base && `screw.jpg`
                )->a( n = `alt` v = `Example picture of screw` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
