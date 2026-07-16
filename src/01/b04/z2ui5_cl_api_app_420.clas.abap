"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.m.Carousel - CarouselWithControls
"! https://sdk.openui5.org/entity/sap.m.Carousel/sample/sap.m.sample.CarouselWithControls
"! API USAGE AUDIT: (a) frontend_action (_event_client): NO | (b) event t_arg: NO
"! CHECKED (2026-07-15): manually verified in a running system - renders and
"! scrolls like the original (see the note below on the flattened image model).
"! NOTES (generation):
"! - IMPROVISED: the three carousel images bind to a separate named model in the
"!   original (img>/products/pic1..3 from sap/ui/demo/mock/img.json); resolved
"!   here to static image URLs, as abap2UI5 serves a single default model.
CLASS z2ui5_cl_api_app_420 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name            TYPE string,
        product_id      TYPE string,
        product_pic_url TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    " not bound - the shared image base URL, kept out of PUBLIC so the round-trip model scan stays small
    DATA base_url TYPE string.

    METHODS model_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_420 IMPLEMENTATION.

  METHOD model_init.

    " Image URLs of the mock models sap/ui/demo/mock/img.json and products.json used by the original sample
    base_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/`.

    " Subset of the mock model sap/ui/demo/mock/products.json used by the original sample
    t_products = VALUE #(
      ( name = `Notebook Basic 15` product_id = `HT-1000` product_pic_url = base_url && `HT-1000.jpg` )
      ( name = `Notebook Basic 17` product_id = `HT-1001` product_pic_url = base_url && `HT-1001.jpg` )
      ( name = `Notebook Basic 18` product_id = `HT-1002` product_pic_url = base_url && `HT-1002.jpg` )
      ( name = `Notebook Basic 19` product_id = `HT-1003` product_pic_url = base_url && `HT-1003.jpg` )
      ( name = `ITelO Vault` product_id = `HT-1007` product_pic_url = base_url && `HT-1007.jpg` )
      ( name = `Notebook Professional 15` product_id = `HT-1010` product_pic_url = base_url && `HT-1010.jpg` )
      ( name = `Notebook Professional 17` product_id = `HT-1011` product_pic_url = base_url && `HT-1011.jpg` )
      ( name = `ITelO Vault Net` product_id = `HT-1020` product_pic_url = base_url && `HT-1020.jpg` )
      ( name = `ITelO Vault SAT` product_id = `HT-1021` product_pic_url = base_url && `HT-1021.jpg` )
      ( name = `Comfort Easy` product_id = `HT-1022` product_pic_url = base_url && `HT-1022.jpg` ) ).

  ENDMETHOD.


  METHOD view_display.

    DATA(lorem) = `Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.` &&
      ` At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.` &&
      ` Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.` &&
      ` Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat`.

    DATA(view) = z2ui5_cl_api_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->leaf( `Title`
            )->a( n = `id`    v = `carouselTitle`
            )->a( n = `class` v = `sapUiSmallMarginTop`
            )->a( n = `text`  v = `Carousel with Different Controls`

        )->open( `Carousel`
            )->a( n = `ariaLabelledBy` v = `carouselTitle`
            )->a( n = `class`          v = `sapUiContentPadding`

            )->open( n = `VerticalLayout` ns = `l`
                )->leaf( `Image`
                    )->a( n = `src` v = base_url && `HT-7777-large.jpg`
                    )->a( n = `alt` v = `Example picture of speakers`

            )->shut(
            )->leaf( `Image`
                )->a( n = `src` v = base_url && `HT-6120-large.jpg`
                )->a( n = `alt` v = `Example picture of USB flash drive`

            )->leaf( `Text`
                )->a( n = `class` v = `sapUiSmallMargin`
                )->a( n = `text`  v = lorem

            )->open( `ScrollContainer`
                )->a( n = `height`     v = `100%`
                )->a( n = `width`      v = `100%`
                )->a( n = `horizontal` v = `false`
                )->a( n = `vertical`   v = `true`

                )->open( `List`
                    )->a( n = `headerText` v = `Some List Content 1`
                    )->a( n = `items`      v = client->_bind_edit( t_products )

                    )->leaf( `StandardListItem`
                        )->a( n = `title`            v = `{NAME}`
                        )->a( n = `description`      v = `{PRODUCT_ID}`
                        )->a( n = `icon`             v = `{PRODUCT_PIC_URL}`
                        )->a( n = `iconDensityAware` v = `false`
                        )->a( n = `iconInset`        v = `false`

                )->shut(
            )->shut(
            )->leaf( `Image`
                )->a( n = `src` v = base_url && `HT-6100-large.jpg`
                )->a( n = `alt` v = `Example picture of spotlight` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
