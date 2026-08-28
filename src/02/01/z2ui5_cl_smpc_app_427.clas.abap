" @keywords carousel sap.m carouselemptymessages hbox panel slider title
" @summary When the carousel has no pages loaded or provided illustrated message will be shown.
CLASS z2ui5_cl_smpc_app_427 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA width_pct TYPE i VALUE 100.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_427 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `height`    v = `100%`

        )->ele( `HBox`
            )->a( n = `justifyContent` v = `Center`
            )->a( n = `renderType`     v = `Bare`
            )->a( n = `height`         v = `100%`

            )->ele( `Panel`
                )->a( n = `width`  v = `75%`
                )->a( n = `height` v = `100%`

                " onResizeCarouselContainer sets the Carousel width to value + '%' -
                " reproduced roundtrip-free: the Slider value is two-way bound and the
                " Carousel width follows it in an expression binding (liveChange dropped)
                )->tag( `Slider`
                    )->a( n = `value` v = client->_bind( width_pct )
                )->tag( `Title`
                    )->a( n = `id`   v = `carouselTitle`
                    )->a( n = `text` v = `Image Gallery`
                " the Carousel stays empty on purpose - this sample shows the placeholder
                " message an empty Carousel renders
                )->tag( `Carousel`
                    )->a( n = `class`          v = `sapUiContentPadding`
                    )->a( n = `id`             v = `carouselEmpty`
                    )->a( n = `ariaLabelledBy` v = `carouselTitle`
                    )->a( n = `height`         v = `50%`
                    )->a( n = `width`          v = |\{= ${ client->_bind( width_pct ) } + '%' \}| ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
