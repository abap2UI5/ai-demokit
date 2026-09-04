" @keywords carousel sap.m carouselwithdisplayoptions label slider panel carousellayout image radiobuttongroup radiobutton switch input
" @summary The Carousel has options for the arrows placement, page indicator placement and page indicator visibility.
CLASS z2ui5_cl_smpc_app_604 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_image,
             src TYPE string,
             alt TYPE string,
           END OF ty_s_image.
    TYPES ty_t_image TYPE STANDARD TABLE OF ty_s_image WITH DEFAULT KEY.

    " the pages the Carousel shows - rebuilt when the count changes
    DATA t_pages    TYPE ty_t_image.
    " p LENGTH 8, not i: num_images, visible_pages and min_page_width below are
    " each two-way bound to a FREE-ENTRY Input of type Number, and the
    " write-back is a bare ABAP assignment inside ajson's value_to_abap - the
    " typed text is converted with no CONV to guard. `<input type="number">`
    " accepts any valid floating-point literal, so eleven digits overflow i and
    " the round-trip dies with JSON_PARSING_ERROR - attribute 'NUM_IMAGES'
    " before on_event runs, which is what made pages_rebuild's own 1..9 guard
    " unreachable for exactly the entries it exists to reject. p keeps the JSON
    " node numeric, so the bound int properties (visiblePagesCount, minPageWidth)
    " see no change. Same type and reason as apps 180, 247 and 249
    DATA num_images TYPE p LENGTH 8 DECIMALS 0 VALUE 3.

    " every option below is a BINDABLE property of the Carousel, its
    " CarouselLayout or the Panel, so each control writes it directly
    DATA slider_value          TYPE i VALUE 100.
    DATA arrows_idx            TYPE i VALUE 0.
    DATA indicator_idx         TYPE i VALUE 0.
    DATA background_idx        TYPE i VALUE 1.
    DATA show_page_indicator   TYPE abap_bool VALUE abap_true.
    DATA ind_background_idx    TYPE i VALUE 0.
    DATA ind_border_idx        TYPE i VALUE 0.
    DATA visible_pages         TYPE p LENGTH 8 DECIMALS 0 VALUE 1.
    DATA scroll_visible_pages  TYPE abap_bool.
    DATA responsive            TYPE abap_bool.
    DATA min_page_width        TYPE p LENGTH 8 DECIMALS 0 VALUE 148.

    " the enum values the four RadioButtonGroups and the scroll-mode Switch pick;
    " the controls write their INDEX, options_apply turns it into the enum name
    DATA arrows_placement      TYPE string.
    DATA indicator_placement   TYPE string.
    DATA background_design     TYPE string.
    DATA ind_background_design TYPE string.
    DATA ind_border_design     TYPE string.
    DATA scroll_mode           TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    " PROTECTED, not PRIVATE: the app's state is serialized into the draft with
    " CALL TRANSFORMATION id, and the transpiled runtime's re-implementation of
    " it walks the attributes with a dynamic ASSIGN obj->(name), which cannot
    " reach a PRIVATE one - it asserts, and every roundtrip 500s with
    " ASSERTION_FAILED (e2e-caught 2026-08-22)
    DATA t_images TYPE ty_t_image.

    METHODS view_display.
    METHODS on_event.
    METHODS options_apply.
    METHODS pages_rebuild.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_604 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " every controller handler here is a SETTER on a bindable property, so the
    " port binds the option controls and the Carousel to the same fields and
    " keeps the whole playground in the browser (see sidecar)
    
    page = view->ele( n = `View` ns = `mvc`
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:f`   v = `sap.ui.layout.form`

        )->ele( `Page`
            )->a( n = `class` v = `sapUiContentPadding` ).

    page->ele( n = `SimpleForm` ns = `f`
        )->a( n = `labelSpanL` v = `6`
        )->a( n = `labelSpanM` v = `6`
        )->a( n = `editable`   v = `true`
        )->a( n = `layout`     v = `ResponsiveGridLayout`

        )->tag( `Label`
            )->a( n = `text` v = `Resize carousel's container`
        )->tag( `Slider`
            )->a( n = `value` v = client->_bind( slider_value )
            )->a( n = `width` v = `300px`
            )->a( n = `min`   v = `50`
            )->a( n = `step`  v = `25`
            )->a( n = `max`   v = `100`
    )->end( ).

    page->tag( `Title`
        )->a( n = `id`    v = `carouselTitle`
        )->a( n = `class` v = `sapUiMediumMarginTop`
        )->a( n = `text`  v = `Carousel with Display Options` ).

    page->ele( `HBox`
        )->a( n = `justifyContent` v = `Center`
        )->a( n = `renderType`     v = `Bare`

        )->ele( `Panel`
            )->a( n = `id`               v = `carouselContainer`
            " onResizeCarouselContainer sets width to <value>% and height to
            " floor( 650 * value / 100 )px - both are expressions over the slider
            )->a( n = `width`            v = |\{= ${ client->_bind( slider_value ) } + '%' \}|
            )->a( n = `height`           v = |\{= Math.floor(650 * ${ client->_bind( slider_value ) } / 100) + 'px' \}|
            )->a( n = `backgroundDesign` v = `Transparent`

            )->ele( `Carousel`
                )->a( n = `id`                           v = `carouselSample`
                )->a( n = `ariaLabelledBy`               v = `carouselTitle`
                )->a( n = `loop`                         v = `true`
                )->a( n = `arrowsPlacement`               v = |\{= ${ client->_bind( arrows_placement ) } \|\| null \}|
                )->a( n = `pageIndicatorPlacement`        v = |\{= ${ client->_bind( indicator_placement ) } \|\| null \}|
                )->a( n = `backgroundDesign`              v = |\{= ${ client->_bind( background_design ) } \|\| null \}|
                )->a( n = `showPageIndicator`             v = client->_bind( show_page_indicator )
                )->a( n = `pageIndicatorBackgroundDesign` v = |\{= ${ client->_bind( ind_background_design ) } \|\| null \}|
                )->a( n = `pageIndicatorBorderDesign`     v = |\{= ${ client->_bind( ind_border_design ) } \|\| null \}|
                )->a( n = `pages`                        v = client->_bind( t_pages )

                )->ele( `customLayout`
                    )->tag( `CarouselLayout`
                        )->a( n = `visiblePagesCount` v = client->_bind( visible_pages )
                        )->a( n = `scrollMode`        v = |\{= ${ client->_bind( scroll_mode ) } \|\| null \}|
                        )->a( n = `responsive`        v = client->_bind( responsive )
                        )->a( n = `minPageWidth`      v = client->_bind( min_page_width )
                )->end(

                )->ele( `pages`
                    )->tag( `Image`
                        )->a( n = `src`           v = `{SRC}`
                        )->a( n = `alt`           v = `{ALT}`
                        )->a( n = `densityAware`  v = `false`
                        )->a( n = `decorative`    v = `false`
                )->end(
            )->end(
        )->end(
    )->end( ).

    page->ele( n = `SimpleForm` ns = `f`
        )->a( n = `labelSpanL` v = `6`
        )->a( n = `labelSpanM` v = `6`
        )->a( n = `editable`   v = `true`
        )->a( n = `layout`     v = `ResponsiveGridLayout`

        )->tag( `Label`
            )->a( n = `text` v = `Carousel arrow placement`
        )->ele( `RadioButtonGroup`
            )->a( n = `columns`       v = `2`
            )->a( n = `selectedIndex` v = client->_bind( arrows_idx )
            )->a( n = `select`        v = client->_event( `OPTIONS` )
            )->tag( `RadioButton`
                )->a( n = `text`    v = `Content`
                )->a( n = `tooltip` v = `Places the arrows on the sides of the content`
            )->tag( `RadioButton`
                )->a( n = `text`    v = `PageIndicator`
                )->a( n = `tooltip` v = `Places the arrows on the sides of the page indicator`
        )->end(

        )->tag( `Label`
            )->a( n = `text` v = `Page indicator placement`
        )->ele( `RadioButtonGroup`
            )->a( n = `columns`       v = `2`
            )->a( n = `selectedIndex` v = client->_bind( indicator_idx )
            )->a( n = `select`        v = client->_event( `OPTIONS` )
            )->tag( `RadioButton`
                )->a( n = `text`    v = `Bottom`
                )->a( n = `tooltip` v = `Places the page indicator on the bottom of the carousel`
            )->tag( `RadioButton`
                )->a( n = `text`    v = `Top`
                )->a( n = `tooltip` v = `Places the page indicator on the top of the carousel`
            )->tag( `RadioButton`
                )->a( n = `text`    v = `OverContentBottom`
                )->a( n = `tooltip` v = `Places the page indicator over the carousel's content, aligned bottom`
            )->tag( `RadioButton`
                )->a( n = `text`    v = `OverContentTop`
                )->a( n = `tooltip` v = `Places the page indicator over the carousel's content, aligned top`
        )->end(

        )->tag( `Label`
            )->a( n = `text` v = `Carousel background design`
        )->ele( `RadioButtonGroup`
            )->a( n = `columns`       v = `3`
            )->a( n = `selectedIndex` v = client->_bind( background_idx )
            )->a( n = `select`        v = client->_event( `OPTIONS` )
            )->tag( `RadioButton`
                )->a( n = `text`    v = `Solid`
                )->a( n = `tooltip` v = `Chooses a Solid background for the carousel.`
            )->tag( `RadioButton`
                )->a( n = `text`    v = `Translucent`
                )->a( n = `tooltip` v = `Chooses a Translucent background for the carousel (Default).`
            )->tag( `RadioButton`
                )->a( n = `text`    v = `Transparent`
                )->a( n = `tooltip` v = `Chooses a Transparent background for the carousel.`
        )->end(

        )->tag( `Label`
            )->a( n = `text` v = `Show page indicator`
        )->tag( `Switch`
            )->a( n = `state`   v = client->_bind( show_page_indicator )
            )->a( n = `tooltip` v = `Toggles the page indicator of the carousel`

        )->tag( `Label`
            )->a( n = `text` v = `Page indicator background design`
        )->ele( `RadioButtonGroup`
            )->a( n = `columns`       v = `3`
            )->a( n = `selectedIndex` v = client->_bind( ind_background_idx )
            )->a( n = `select`        v = client->_event( `OPTIONS` )
            )->tag( `RadioButton`
                )->a( n = `text`    v = `Solid`
                )->a( n = `tooltip` v = `Chooses a Solid background for the page indicator (Default).`
            )->tag( `RadioButton`
                )->a( n = `text`    v = `Translucent`
                )->a( n = `tooltip` v = `Chooses a Translucent background for the page indicator.`
            )->tag( `RadioButton`
                )->a( n = `text`    v = `Transparent`
                )->a( n = `tooltip` v = `Chooses a Transparent background for the page indicator.`
        )->end(

        )->tag( `Label`
            )->a( n = `text` v = `Page indicator border design`
        )->ele( `RadioButtonGroup`
            )->a( n = `columns`       v = `2`
            )->a( n = `selectedIndex` v = client->_bind( ind_border_idx )
            )->a( n = `select`        v = client->_event( `OPTIONS` )
            )->tag( `RadioButton`
                )->a( n = `text`    v = `Solid`
                )->a( n = `tooltip` v = `Chooses a Solid border for the page indicator (Default).`
            )->tag( `RadioButton`
                )->a( n = `text`    v = `None`
                )->a( n = `tooltip` v = `Chooses no border for the page indicator.`
        )->end(

        )->tag( `Label`
            )->a( n = `text` v = `Number of images to display (In this example up to 9)`
        " the only option the browser cannot apply on its own: the pages
        " aggregation is bound, so the backend rebuilds the table (see sidecar)
        )->tag( `Input`
            )->a( n = `type`   v = `Number`
            )->a( n = `value`  v = client->_bind( num_images )
            )->a( n = `change` v = client->_event( `NUM_IMAGES` )
            )->a( n = `width`  v = `320px`

        )->tag( `Label`
            )->a( n = `text` v = `Number of pages to display`
        )->tag( `Input`
            )->a( n = `type`  v = `Number`
            )->a( n = `value` v = client->_bind( visible_pages )
            )->a( n = `width` v = `320px`

        )->tag( `Label`
            )->a( n = `text` v = `Scroll mode - visible pages`
        )->tag( `Switch`
            )->a( n = `state`   v = client->_bind( scroll_visible_pages )
            )->a( n = `tooltip` v = `Toggles the scrollMode property of the carousel`
            )->a( n = `change`  v = client->_event( `OPTIONS` )

        )->tag( `Label`
            )->a( n = `text` v = `Responsive number of pages`
        )->tag( `Switch`
            )->a( n = `state`   v = client->_bind( responsive )
            )->a( n = `tooltip` v = `Toggles the responsive property of the carousel`

        )->tag( `Label`
            )->a( n = `text` v = `minPageWidth for the responsive layout (px)`
        )->tag( `Input`
            )->a( n = `type`  v = `Number`
            )->a( n = `value` v = client->_bind( min_page_width )
            )->a( n = `width` v = `320px`
    )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `NUM_IMAGES`.
        " _setNumberOfImagesInCarousel: destroyPages( ) and addPage( ) once per
        " image, guarded to 1..9 - the same guard over the bound table
        pages_rebuild( ).

      WHEN `OPTIONS`.
        " the five handlers that read getSelectedButton( ).getText( ) and hand it
        " to a setter: the group writes its index, this turns it into the enum
        options_apply( ).

    ENDCASE.

  ENDMETHOD.


  METHOD options_apply.

    DATA temp1 TYPE string.
    DATA temp2 TYPE string.
    DATA temp3 TYPE string.
    DATA temp4 TYPE string.
    DATA temp5 TYPE string.
    DATA temp6 TYPE string.
    IF arrows_idx = 0.
      temp1 = `Content`.
    ELSE.
      temp1 = `PageIndicator`.
    ENDIF.
    arrows_placement      = temp1.

    
    CASE indicator_idx.
      WHEN 0.
        temp2 = `Bottom`.
      WHEN 1.
        temp2 = `Top`.
      WHEN 2.
        temp2 = `OverContentBottom`.
      WHEN OTHERS.
        temp2 = `OverContentTop`.
    ENDCASE.
    indicator_placement   = temp2.

    
    CASE background_idx.
      WHEN 0.
        temp3 = `Solid`.
      WHEN 1.
        temp3 = `Translucent`.
      WHEN OTHERS.
        temp3 = `Transparent`.
    ENDCASE.
    background_design     = temp3.

    
    CASE ind_background_idx.
      WHEN 0.
        temp4 = `Solid`.
      WHEN 1.
        temp4 = `Translucent`.
      WHEN OTHERS.
        temp4 = `Transparent`.
    ENDCASE.
    ind_background_design = temp4.

    
    IF ind_border_idx = 0.
      temp5 = `Solid`.
    ELSE.
      temp5 = `None`.
    ENDIF.
    ind_border_design     = temp5.

    
    IF scroll_visible_pages = abap_true.
      temp6 = `VisiblePages`.
    ELSE.
      temp6 = `SinglePage`.
    ENDIF.
    scroll_mode = temp6.

  ENDMETHOD.


  METHOD pages_rebuild.
    DATA image LIKE LINE OF t_images.

    IF num_images < 1 OR num_images > 9.
      RETURN.
    ENDIF.

    CLEAR t_pages.
    
    LOOP AT t_images INTO image TO num_images.
      INSERT image INTO TABLE t_pages.
    ENDLOOP.

  ENDMETHOD.


  METHOD model_init.

    " sap/ui/demo/mock/img.json /images - the nine pictures the sample offers,
    " with the alt text its addPage( ) composes ('Example picture <n>')
    DATA temp7 TYPE z2ui5_cl_smpc_app_604=>ty_t_image.
    DATA temp8 LIKE LINE OF temp7.
    CLEAR temp7.
    
    temp8-src = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/bigimgs/273303_low_jpg_srgb.jpg`.
    temp8-alt = `Example picture 1`.
    INSERT temp8 INTO TABLE temp7.
    temp8-src = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/bigimgs/273537_low_jpg_srgb.jpg`.
    temp8-alt = `Example picture 2`.
    INSERT temp8 INTO TABLE temp7.
    temp8-src = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/bigimgs/274731_high_jpg_eci_rgb.jpg`.
    temp8-alt = `Example picture 3`.
    INSERT temp8 INTO TABLE temp7.
    temp8-src = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1603.jpg`.
    temp8-alt = `Example picture 4`.
    INSERT temp8 INTO TABLE temp7.
    temp8-src = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2002.jpg`.
    temp8-alt = `Example picture 5`.
    INSERT temp8 INTO TABLE temp7.
    temp8-src = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2020.jpg`.
    temp8-alt = `Example picture 6`.
    INSERT temp8 INTO TABLE temp7.
    temp8-src = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2025.jpg`.
    temp8-alt = `Example picture 7`.
    INSERT temp8 INTO TABLE temp7.
    temp8-src = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2026.jpg`.
    temp8-alt = `Example picture 8`.
    INSERT temp8 INTO TABLE temp7.
    temp8-src = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2027.jpg`.
    temp8-alt = `Example picture 9`.
    INSERT temp8 INTO TABLE temp7.
    t_images = temp7.

    pages_rebuild( ).

    " seed the six enum names from the sample's own initial selections, so no
    " empty string ever reaches an enum property (apps 548/555)
    options_apply( ).

  ENDMETHOD.

ENDCLASS.
