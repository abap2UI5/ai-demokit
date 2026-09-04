" @keywords carousel sap.m carouselwithmorepages simpleform label input switch title carousellayout scrollcontainer card header
" @summary The customLayout aggregation determines how many pages are displayed in Carousel's visible area.
CLASS z2ui5_cl_smpc_app_252 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name          TYPE string,
        status        TYPE string,
        productpicurl TYPE string,
        suppliername  TYPE string,
        maincategory  TYPE string,
        category      TYPE string,
        width         TYPE string,
        height        TYPE string,
        weightmeasure TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

    DATA pages_count    TYPE i.
    DATA scroll_visible TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_252 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`       v = `sap.m`
        )->a( n = `xmlns:mvc`   v = `sap.ui.core.mvc`
        )->a( n = `xmlns:f`     v = `sap.f`
        )->a( n = `xmlns:cards` v = `sap.f.cards`
        )->a( n = `xmlns:l`     v = `sap.ui.layout`
        )->a( n = `xmlns:lf`    v = `sap.ui.layout.form`
        )->a( n = `xmlns:core`  v = `sap.ui.core`
        )->a( n = `height`      v = `100%`
        " the Input's value has to carry a TYPE, or the two-way write-back
        " stores the typed text as a STRING and CarouselLayout.visiblePagesCount
        " (an int property) throws on every keystroke - validateProperty casts
        " implicitly for string properties only. This is where the original's
        " Number( sVisiblePageCount ) went
        )->a( n = `core:require` v = `{IntegerType: 'sap/ui/model/type/Integer'}`

        )->ele( `Page`
            )->a( n = `title` v = `Carousel With customLayout aggregation Sample`
            )->a( n = `class` v = `sapUiResponsiveContentPadding`

            )->ele( n = `SimpleForm` ns = `lf`
                )->a( n = `labelSpanL` v = `6`
                )->a( n = `labelSpanM` v = `6`
                )->a( n = `editable`   v = `true`
                )->a( n = `layout`     v = `ResponsiveGridLayout`
                )->tag( `Label`
                    )->a( n = `text` v = `Number of pages to display`
                " liveChange wire dropped (declared): value is two-way bound with
                " valueLiveUpdate, CarouselLayout.visiblePagesCount binds the same
                " field - the toggles drive the carousel client-side (007/128)
                )->tag( `Input`
                    )->a( n = `type`            v = `Number`
                    )->a( n = `value`           v = |\{ path: '{ client->_bind_path( pages_count ) }', type: 'IntegerType' \}|
                    )->a( n = `valueLiveUpdate` v = `true`
                    )->a( n = `width`           v = `320px`
                )->tag( `Label`
                    )->a( n = `text` v = `Scroll mode - visible pages:`
                )->tag( `Switch`
                    )->a( n = `state`   v = client->_bind( scroll_visible )
                    )->a( n = `tooltip` v = `Toggles the scrollMode property of the carousel`

            )->end(
            )->tag( `Title`
                )->a( n = `id`    v = `carouselTitle`
                )->a( n = `class` v = `sapUiMediumMarginTop`
                )->a( n = `text`  v = `10 Matching Results`

            )->ele( `Carousel`
                )->a( n = `id`             v = `carouselSample`
                )->a( n = `ariaLabelledBy` v = `carouselTitle`
                )->a( n = `height`         v = `auto`
                )->a( n = `pages`          v = |\{ path: '{ client->_bind_path( t_products ) }' \}|

                )->ele( `customLayout`
                    )->tag( `CarouselLayout`
                        )->a( n = `visiblePagesCount` v = client->_bind( pages_count )
                        " OnScrollModeChange folded into the binding (declared)
                        )->a( n = `scrollMode`        v = |\{= ${ client->_bind( scroll_visible ) } ? 'VisiblePages' : 'SinglePage' \}|

                )->end(

                )->ele( `ScrollContainer`
                    )->a( n = `vertical`   v = `false`
                    )->a( n = `horizontal` v = `false`
                    )->a( n = `class`      v = `sapUiContentPadding`

                    )->ele( n = `Card` ns = `f`
                        )->ele( n = `header` ns = `f`
                            )->tag( n = `Header` ns = `cards`
                                )->a( n = `title`            v = `{NAME}`
                                )->a( n = `subtitle`         v = `{STATUS}`
                                )->a( n = `iconSrc`          v = `{PRODUCTPICURL}`
                                )->a( n = `iconDisplayShape` v = `Square`

                        )->end(
                        )->ele( n = `content` ns = `f`
                            )->ele( n = `VerticalLayout` ns = `l`
                                )->a( n = `class` v = `sapUiContentPadding`
                                )->a( n = `width` v = `100%`

                                )->ele( n = `BlockLayout` ns = `l`
                                    )->ele( n = `BlockLayoutRow` ns = `l`

                                        )->ele( n = `BlockLayoutCell` ns = `l`
                                            )->a( n = `title` v = `Main Information`
                                            )->a( n = `width` v = `1`

                                            )->ele( `HBox`
                                                )->a( n = `class` v = `sapUiTinyMarginBottom`
                                                )->tag( `Label`
                                                    )->a( n = `text` v = `Supplier:`

                                            )->end(
                                            )->ele( `HBox`
                                                )->a( n = `class` v = `sapUiSmallMarginBottom`
                                                )->tag( `Text`
                                                    )->a( n = `text` v = `{SUPPLIERNAME}`

                                            )->end(
                                            )->ele( `HBox`
                                                )->a( n = `class` v = `sapUiTinyMarginBottom`
                                                )->tag( `Label`
                                                    )->a( n = `text` v = `Main Category:`

                                            )->end(
                                            )->ele( `HBox`
                                                )->a( n = `class` v = `sapUiSmallMarginBottom`
                                                )->tag( `Text`
                                                    )->a( n = `text` v = `{MAINCATEGORY}`

                                            )->end(
                                            )->ele( `HBox`
                                                )->a( n = `class` v = `sapUiTinyMarginBottom`
                                                )->tag( `Label`
                                                    )->a( n = `text` v = `Category:`

                                            )->end(
                                            )->ele( `HBox`
                                                )->a( n = `class` v = `sapUiSmallMarginBottom`
                                                )->tag( `Text`
                                                    )->a( n = `text` v = `{CATEGORY}`

                                            )->end(
                                        )->end(

                                        )->ele( n = `BlockLayoutCell` ns = `l`
                                            )->a( n = `title` v = `Specifications`
                                            )->a( n = `width` v = `1`

                                            )->ele( `HBox`
                                                )->a( n = `class` v = `sapUiTinyMarginBottom`
                                                )->tag( `Label`
                                                    )->a( n = `text` v = `Width (cm)`

                                            )->end(
                                            )->ele( `HBox`
                                                )->a( n = `class` v = `sapUiSmallMarginBottom`
                                                )->tag( `Text`
                                                    )->a( n = `text` v = `{WIDTH}`

                                            )->end(
                                            )->ele( `HBox`
                                                )->a( n = `class` v = `sapUiTinyMarginBottom`
                                                )->tag( `Label`
                                                    )->a( n = `text` v = `Height (cm)`

                                            )->end(
                                            )->ele( `HBox`
                                                )->a( n = `class` v = `sapUiSmallMarginBottom`
                                                )->tag( `Text`
                                                    )->a( n = `text` v = `{HEIGHT}`

                                            )->end(
                                            )->ele( `HBox`
                                                )->a( n = `class` v = `sapUiTinyMarginBottom`
                                                )->tag( `Label`
                                                    )->a( n = `text` v = `Weight (kg)`

                                            )->end(
                                            )->ele( `HBox`
                                                )->a( n = `class` v = `sapUiSmallMarginBottom`
                                                )->tag( `Text`
                                                    )->a( n = `text` v = `{WEIGHTMEASURE}` ).

    client->view_display( view->stringify( ) ).

    " onInit: oProductsModel.setSizeLimit(10) - the model-level limit 1:1
    
    CLEAR temp1.
    INSERT `10` INTO TABLE temp1.
    INSERT client->cs_view-main INTO TABLE temp1.
    client->follow_up_action( val   = client->cs_event-set_size_limit
                              t_arg = temp1 ).

  ENDMETHOD.


  METHOD model_init.

    " onInit's device branch, resolved SERVER-SIDE from the framework's own
    " device mirror rather than hard-coded to the desktop leg (apps 012/173/302
    " precedent): desktop 4 / tablet 2 / else 1.
    " COMBI counts as desktop: the original tests Device.system.desktop first,
    " and a touchscreen laptop has desktop AND tablet true, so it takes the
    " desktop leg. The mirror collapses that pair to the single string 'combi',
    " which is why it has to be named here - checking 'tablet' alone would give
    " such a machine 2 pages where the sample gives 4
    DATA temp3 TYPE i.
    DATA temp4 LIKE t_products.
    DATA temp5 LIKE LINE OF temp4.
    IF client->get( )-s_device-system = z2ui5_if_client=>cs_device-system-desktop OR client->get( )-s_device-system = z2ui5_if_client=>cs_device-system-combi.
      temp3 = 4.
    ELSEIF client->get( )-s_device-system = z2ui5_if_client=>cs_device-system-tablet.
      temp3 = 2.
    ELSE.
      temp3 = 1.
    ENDIF.
    pages_count    = temp3.
    scroll_visible = abap_false.

    " sap/ui/demo/mock/products.json - the full 123-row ProductCollection,
    " the nine bound fields per row (setSizeLimit(10) caps the rendering)
    
    CLEAR temp4.
    
    temp5-name = `Notebook Basic 15`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg`.
    temp5-suppliername = `Very Best Screens`.
    temp5-maincategory = `Computer Systems`.
    temp5-category = `Laptops`.
    temp5-width = `30`.
    temp5-height = `3`.
    temp5-weightmeasure = `4.2`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Notebook Basic 17`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1001.jpg`.
    temp5-suppliername = `Very Best Screens`.
    temp5-maincategory = `Computer Systems`.
    temp5-category = `Laptops`.
    temp5-width = `29`.
    temp5-height = `3.1`.
    temp5-weightmeasure = `4.5`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Notebook Basic 18`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1002.jpg`.
    temp5-suppliername = `Very Best Screens`.
    temp5-maincategory = `Computer Systems`.
    temp5-category = `Laptops`.
    temp5-width = `28`.
    temp5-height = `2.5`.
    temp5-weightmeasure = `4.2`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Notebook Basic 19`.
    temp5-status = `Out of Stock`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1003.jpg`.
    temp5-suppliername = `Smartcards`.
    temp5-maincategory = `Computer Systems`.
    temp5-category = `Laptops`.
    temp5-width = `32`.
    temp5-height = `4`.
    temp5-weightmeasure = `4.2`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `ITelO Vault`.
    temp5-status = `Out of Stock`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1007.jpg`.
    temp5-suppliername = `Technocom`.
    temp5-maincategory = `Computer Components`.
    temp5-category = `Accessories`.
    temp5-width = `32`.
    temp5-height = `3`.
    temp5-weightmeasure = `0.2`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Notebook Professional 15`.
    temp5-status = `Out of Stock`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg`.
    temp5-suppliername = `Very Best Screens`.
    temp5-maincategory = `Computer Systems`.
    temp5-category = `Accessories`.
    temp5-width = `33`.
    temp5-height = `3`.
    temp5-weightmeasure = `4.3`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Notebook Professional 17`.
    temp5-status = `Out of Stock`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1011.jpg`.
    temp5-suppliername = `Very Best Screens`.
    temp5-maincategory = `Computer Systems`.
    temp5-category = `Laptops`.
    temp5-width = `33`.
    temp5-height = `2`.
    temp5-weightmeasure = `4.1`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `ITelO Vault Net`.
    temp5-status = `Discontinued`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1020.jpg`.
    temp5-suppliername = `Technocom`.
    temp5-maincategory = `Computer Components`.
    temp5-category = `Accessories`.
    temp5-width = `10`.
    temp5-height = `17`.
    temp5-weightmeasure = `0.16`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `ITelO Vault SAT`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1021.jpg`.
    temp5-suppliername = `Technocom`.
    temp5-maincategory = `Computer Components`.
    temp5-category = `Accessories`.
    temp5-width = `11`.
    temp5-height = `18`.
    temp5-weightmeasure = `0.18`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Comfort Easy`.
    temp5-status = `Out of Stock`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1022.jpg`.
    temp5-suppliername = `Technocom`.
    temp5-maincategory = `Computer Components`.
    temp5-category = `Accessories`.
    temp5-width = `84`.
    temp5-height = `14`.
    temp5-weightmeasure = `0.2`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Comfort Senior`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1023.jpg`.
    temp5-suppliername = `Technocom`.
    temp5-maincategory = `Computer Components`.
    temp5-category = `Accessories`.
    temp5-width = `80`.
    temp5-height = `13`.
    temp5-weightmeasure = `0.8`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Ergo Screen E-I`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1030.jpg`.
    temp5-suppliername = `Very Best Screens`.
    temp5-maincategory = `Computer Components`.
    temp5-category = `Flat Screen Monitors`.
    temp5-width = `37`.
    temp5-height = `36`.
    temp5-weightmeasure = `21`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Ergo Screen E-II`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1031.jpg`.
    temp5-suppliername = `Very Best Screens`.
    temp5-maincategory = `Computer Components`.
    temp5-category = `Flat Screen Monitors`.
    temp5-width = `40.8`.
    temp5-height = `43`.
    temp5-weightmeasure = `21`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Ergo Screen E-III`.
    temp5-status = `Out of Stock`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1032.jpg`.
    temp5-suppliername = `Very Best Screens`.
    temp5-maincategory = `Computer Components`.
    temp5-category = `Flat Screen Monitors`.
    temp5-width = `40.8`.
    temp5-height = `43`.
    temp5-weightmeasure = `21`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Flat Basic`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1035.jpg`.
    temp5-suppliername = `Very Best Screens`.
    temp5-maincategory = `Computer Components`.
    temp5-category = `Flat Screen Monitors`.
    temp5-width = `39`.
    temp5-height = `41`.
    temp5-weightmeasure = `14`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Flat Future`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1036.jpg`.
    temp5-suppliername = `Very Best Screens`.
    temp5-maincategory = `Computer Components`.
    temp5-category = `Flat Screen Monitors`.
    temp5-width = `45`.
    temp5-height = `46`.
    temp5-weightmeasure = `15`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Flat XL`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1037.jpg`.
    temp5-suppliername = `Very Best Screens`.
    temp5-maincategory = `Computer Components`.
    temp5-category = `Flat Screen Monitors`.
    temp5-width = `54.5`.
    temp5-height = `39.1`.
    temp5-weightmeasure = `17`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Laser Professional Eco`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1040.jpg`.
    temp5-suppliername = `Alpha Printers`.
    temp5-maincategory = `Printers & Scanners`.
    temp5-category = `Printers`.
    temp5-width = `51`.
    temp5-height = `30`.
    temp5-weightmeasure = `32`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Laser Basic`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1041.jpg`.
    temp5-suppliername = `Alpha Printers`.
    temp5-maincategory = `Printers & Scanners`.
    temp5-category = `Printers`.
    temp5-width = `48`.
    temp5-height = `26`.
    temp5-weightmeasure = `23`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Laser Allround`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1042.jpg`.
    temp5-suppliername = `Alpha Printers`.
    temp5-maincategory = `Printers & Scanners`.
    temp5-category = `Printers`.
    temp5-width = `53`.
    temp5-height = `65`.
    temp5-weightmeasure = `17`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Ultra Jet Super Color`.
    temp5-status = `Discontinued`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1050.jpg`.
    temp5-suppliername = `Alpha Printers`.
    temp5-maincategory = `Printers & Scanners`.
    temp5-category = `Printers`.
    temp5-width = `41`.
    temp5-height = `28`.
    temp5-weightmeasure = `3`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Ultra Jet Mobile`.
    temp5-status = `Discontinued`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1051.jpg`.
    temp5-suppliername = `Printer for All`.
    temp5-maincategory = `Printers & Scanners`.
    temp5-category = `Printers`.
    temp5-width = `46`.
    temp5-height = `25`.
    temp5-weightmeasure = `1.9`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Ultra Jet Super Highspeed`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1052.jpg`.
    temp5-suppliername = `Printer for All`.
    temp5-maincategory = `Printers & Scanners`.
    temp5-category = `Printers`.
    temp5-width = `41`.
    temp5-height = `28`.
    temp5-weightmeasure = `18`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Multi Print`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1055.jpg`.
    temp5-suppliername = `Printer for All`.
    temp5-maincategory = `Printers & Scanners`.
    temp5-category = `Multifunction Printers`.
    temp5-width = `55`.
    temp5-height = `29`.
    temp5-weightmeasure = `6.3`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Multi Color`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1056.jpg`.
    temp5-suppliername = `Printer for All`.
    temp5-maincategory = `Printers & Scanners`.
    temp5-category = `Multifunction Printers`.
    temp5-width = `51`.
    temp5-height = `22`.
    temp5-weightmeasure = `4.3`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Cordless Mouse`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1060.jpg`.
    temp5-suppliername = `Oxynum`.
    temp5-maincategory = `Computer Components`.
    temp5-category = `Mice`.
    temp5-width = `6`.
    temp5-height = `3.5`.
    temp5-weightmeasure = `0.09`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Speed Mouse`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1061.jpg`.
    temp5-suppliername = `Oxynum`.
    temp5-maincategory = `Computer Components`.
    temp5-category = `Mice`.
    temp5-width = `7`.
    temp5-height = `3.1`.
    temp5-weightmeasure = `0.09`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Track Mouse`.
    temp5-status = `Discontinued`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1062.jpg`.
    temp5-suppliername = `Oxynum`.
    temp5-maincategory = `Computer Components`.
    temp5-category = `Mice`.
    temp5-width = `3`.
    temp5-height = `4`.
    temp5-weightmeasure = `0.03`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Ergonomic Keyboard`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1063.jpg`.
    temp5-suppliername = `Oxynum`.
    temp5-maincategory = `Computer Components`.
    temp5-category = `Keyboards`.
    temp5-width = `50`.
    temp5-height = `3.5`.
    temp5-weightmeasure = `2.1`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Internet Keyboard`.
    temp5-status = `Out of Stock`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1064.jpg`.
    temp5-suppliername = `Oxynum`.
    temp5-maincategory = `Computer Components`.
    temp5-category = `Keyboards`.
    temp5-width = `52`.
    temp5-height = `3`.
    temp5-weightmeasure = `1.8`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Media Keyboard`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1065.jpg`.
    temp5-suppliername = `Oxynum`.
    temp5-maincategory = `Computer Components`.
    temp5-category = `Keyboards`.
    temp5-width = `51.4`.
    temp5-height = `4`.
    temp5-weightmeasure = `2.3`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Mousepad`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1066.jpg`.
    temp5-suppliername = `Oxynum`.
    temp5-maincategory = `Computer Components`.
    temp5-category = `Mousepads`.
    temp5-width = `15`.
    temp5-height = `0.2`.
    temp5-weightmeasure = `80`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Ergo Mousepad`.
    temp5-status = `Out of Stock`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1067.jpg`.
    temp5-suppliername = `Oxynum`.
    temp5-maincategory = `Computer Components`.
    temp5-category = `Mousepads`.
    temp5-width = `15`.
    temp5-height = `0.2`.
    temp5-weightmeasure = `80`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Designer Mousepad`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1068.jpg`.
    temp5-suppliername = `Fasttech`.
    temp5-maincategory = `Computer Components`.
    temp5-category = `Mousepads`.
    temp5-width = `24`.
    temp5-height = `0.6`.
    temp5-weightmeasure = `90`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Universal card reader`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1069.jpg`.
    temp5-suppliername = `Fasttech`.
    temp5-maincategory = `Computer Systems`.
    temp5-category = `Computer System Accessories`.
    temp5-width = `6`.
    temp5-height = `3`.
    temp5-weightmeasure = `45`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Proctra X`.
    temp5-status = `Out of Stock`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1070.jpg`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-maincategory = `Computer Components`.
    temp5-category = `Graphic Cards`.
    temp5-width = `22`.
    temp5-height = `17`.
    temp5-weightmeasure = `0.255`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Gladiator MX`.
    temp5-status = `Discontinued`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1071.jpg`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-maincategory = `Computer Components`.
    temp5-category = `Graphic Cards`.
    temp5-width = `22`.
    temp5-height = `17`.
    temp5-weightmeasure = `0.3`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Hurricane GX`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1072.jpg`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-maincategory = `Computer Components`.
    temp5-category = `Graphic Cards`.
    temp5-width = `22`.
    temp5-height = `17`.
    temp5-weightmeasure = `0.4`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Hurricane GX/LN`.
    temp5-status = `Out of Stock`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1073.jpg`.
    temp5-suppliername = `Smartcards`.
    temp5-maincategory = `Computer Components`.
    temp5-category = `Graphic Cards`.
    temp5-width = `22`.
    temp5-height = `17`.
    temp5-weightmeasure = `0.4`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Photo Scan`.
    temp5-status = `Out of Stock`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1080.jpg`.
    temp5-suppliername = `Printer for All`.
    temp5-maincategory = `Printers & Scanners`.
    temp5-category = `Scanners`.
    temp5-width = `34`.
    temp5-height = `5`.
    temp5-weightmeasure = `2.3`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Power Scan`.
    temp5-status = `Out of Stock`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1081.jpg`.
    temp5-suppliername = `Printer for All`.
    temp5-maincategory = `Printers & Scanners`.
    temp5-category = `Scanners`.
    temp5-width = `31`.
    temp5-height = `7`.
    temp5-weightmeasure = `2.4`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Jet Scan Professional`.
    temp5-status = `Out of Stock`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1082.jpg`.
    temp5-suppliername = `Printer for All`.
    temp5-maincategory = `Printers & Scanners`.
    temp5-category = `Scanners`.
    temp5-width = `33`.
    temp5-height = `12`.
    temp5-weightmeasure = `3.2`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Jet Scan Professional`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1083.jpg`.
    temp5-suppliername = `Printer for All`.
    temp5-maincategory = `Printers & Scanners`.
    temp5-category = `Scanners`.
    temp5-width = `35`.
    temp5-height = `10`.
    temp5-weightmeasure = `3.2`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Copymaster`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1085.jpg`.
    temp5-suppliername = `Alpha Printers`.
    temp5-maincategory = `Printers & Scanners`.
    temp5-category = `Multifunction Printers`.
    temp5-width = `45`.
    temp5-height = `22`.
    temp5-weightmeasure = `23.2`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Surround Sound`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1090.jpg`.
    temp5-suppliername = `Speaker Experts`.
    temp5-maincategory = `Computer Components`.
    temp5-category = `Speakers`.
    temp5-width = `12`.
    temp5-height = `16`.
    temp5-weightmeasure = `3`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Blaster Extreme`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1091.jpg`.
    temp5-suppliername = `Speaker Experts`.
    temp5-maincategory = `Computer Components`.
    temp5-category = `Speakers`.
    temp5-width = `13`.
    temp5-height = `17.5`.
    temp5-weightmeasure = `1.4`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Sound Booster`.
    temp5-status = `Discontinued`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1092.jpg`.
    temp5-suppliername = `Speaker Experts`.
    temp5-maincategory = `Computer Components`.
    temp5-category = `Speakers`.
    temp5-width = `12.4`.
    temp5-height = `18.1`.
    temp5-weightmeasure = `2.1`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Lovely Sound 5.1 Wireless`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1095.jpg`.
    temp5-suppliername = `Fasttech`.
    temp5-maincategory = `Computer Components`.
    temp5-category = `Accessories`.
    temp5-width = `24`.
    temp5-height = `23`.
    temp5-weightmeasure = `80`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Lovely Sound 5.1`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1096.jpg`.
    temp5-suppliername = `Fasttech`.
    temp5-maincategory = `Computer Components`.
    temp5-category = `Accessories`.
    temp5-width = `25`.
    temp5-height = `19`.
    temp5-weightmeasure = `130`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Lovely Sound Stereo`.
    temp5-status = `Out of Stock`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1097.jpg`.
    temp5-suppliername = `Fasttech`.
    temp5-maincategory = `Computer Components`.
    temp5-category = `Accessories`.
    temp5-width = `21.3`.
    temp5-height = `19.7`.
    temp5-weightmeasure = `60`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Smart Office`.
    temp5-status = `Out of Stock`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1100.jpg`.
    temp5-suppliername = `Technocom`.
    temp5-maincategory = `Software`.
    temp5-category = `Software`.
    temp5-width = `15`.
    temp5-height = `2.1`.
    temp5-weightmeasure = `1.2`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Smart Design`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1101.jpg`.
    temp5-suppliername = `Technocom`.
    temp5-maincategory = `Software`.
    temp5-category = `Software`.
    temp5-width = `14`.
    temp5-height = `24`.
    temp5-weightmeasure = `0.8`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Smart Network`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1102.jpg`.
    temp5-suppliername = `Technocom`.
    temp5-maincategory = `Software`.
    temp5-category = `Software`.
    temp5-width = `16`.
    temp5-height = `27`.
    temp5-weightmeasure = `0.8`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Smart Multimedia`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1103.jpg`.
    temp5-suppliername = `Technocom`.
    temp5-maincategory = `Software`.
    temp5-category = `Software`.
    temp5-width = `11`.
    temp5-height = `22`.
    temp5-weightmeasure = `0.8`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Smart Games`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1104.jpg`.
    temp5-suppliername = `Technocom`.
    temp5-maincategory = `Software`.
    temp5-category = `Software`.
    temp5-width = `10`.
    temp5-height = `30`.
    temp5-weightmeasure = `1.1`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Smart Internet Antivirus`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1105.jpg`.
    temp5-suppliername = `Brainsoft`.
    temp5-maincategory = `Software`.
    temp5-category = `Software`.
    temp5-width = `16`.
    temp5-height = `21`.
    temp5-weightmeasure = `0.7`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Smart Firewall`.
    temp5-status = `Discontinued`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1106.jpg`.
    temp5-suppliername = `Brainsoft`.
    temp5-maincategory = `Software`.
    temp5-category = `Software`.
    temp5-width = `17.9`.
    temp5-height = `23.1`.
    temp5-weightmeasure = `0.9`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Smart Money`.
    temp5-status = `Out of Stock`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1107.jpg`.
    temp5-suppliername = `Brainsoft`.
    temp5-maincategory = `Software`.
    temp5-category = `Software`.
    temp5-width = `12`.
    temp5-height = `19`.
    temp5-weightmeasure = `0.5`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `PC Lock`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1110.jpg`.
    temp5-suppliername = `Red Point Stores`.
    temp5-maincategory = `Computer Systems`.
    temp5-category = `Computer System Accessories`.
    temp5-width = `20`.
    temp5-height = `4.3`.
    temp5-weightmeasure = `0.03`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Notebook Lock`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1111.jpg`.
    temp5-suppliername = `Red Point Stores`.
    temp5-maincategory = `Computer Systems`.
    temp5-category = `Computer System Accessories`.
    temp5-width = `31`.
    temp5-height = `7`.
    temp5-weightmeasure = `0.02`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Web cam reality`.
    temp5-status = `Out of Stock`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1112.jpg`.
    temp5-suppliername = `Red Point Stores`.
    temp5-maincategory = `Computer Systems`.
    temp5-category = `Computer System Accessories`.
    temp5-width = `9`.
    temp5-height = `1.3`.
    temp5-weightmeasure = `0.075`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Screen clean`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1113.jpg`.
    temp5-suppliername = `Red Point Stores`.
    temp5-maincategory = `Computer Systems`.
    temp5-category = `Computer System Accessories`.
    temp5-width = `2`.
    temp5-height = `0.1`.
    temp5-weightmeasure = `0.05`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Fabric bag professional`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1114.jpg`.
    temp5-suppliername = `Red Point Stores`.
    temp5-maincategory = `Computer Systems`.
    temp5-category = `Computer System Accessories`.
    temp5-width = `42`.
    temp5-height = `7`.
    temp5-weightmeasure = `1.8`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Wireless DSL Router`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1115.jpg`.
    temp5-suppliername = `Red Point Stores`.
    temp5-maincategory = `Computer Components`.
    temp5-category = `Telecommunications`.
    temp5-width = `19.3`.
    temp5-height = `5`.
    temp5-weightmeasure = `0.45`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Wireless DSL Router / Repeater`.
    temp5-status = `Out of Stock`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1116.jpg`.
    temp5-suppliername = `Red Point Stores`.
    temp5-maincategory = `Computer Components`.
    temp5-category = `Telecommunications`.
    temp5-width = `19.3`.
    temp5-height = `5`.
    temp5-weightmeasure = `0.45`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Wireless DSL Router / Repeater and Print Server`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1117.jpg`.
    temp5-suppliername = `Technocom`.
    temp5-maincategory = `Computer Components`.
    temp5-category = `Telecommunications`.
    temp5-width = `19.3`.
    temp5-height = `5`.
    temp5-weightmeasure = `0.45`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `USB Stick`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1118.jpg`.
    temp5-suppliername = `Technocom`.
    temp5-maincategory = `Computer Systems`.
    temp5-category = `Computer System Accessories`.
    temp5-width = `1.5`.
    temp5-height = `1.2`.
    temp5-weightmeasure = `0.015`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Travel Adapter`.
    temp5-status = `Discontinued`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1119.jpg`.
    temp5-suppliername = `Titanium`.
    temp5-maincategory = `Computer Systems`.
    temp5-category = `Accessories`.
    temp5-width = `2`.
    temp5-height = `3.9`.
    temp5-weightmeasure = `88`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Cordless Bluetooth Keyboard, english international`.
    temp5-status = `Out of Stock`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1120.jpg`.
    temp5-suppliername = `Technocom`.
    temp5-maincategory = `Computer Components`.
    temp5-category = `Keyboards`.
    temp5-width = `51.4`.
    temp5-height = `4`.
    temp5-weightmeasure = `1`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Flat XXL`.
    temp5-status = `Discontinued`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1137.jpg`.
    temp5-suppliername = `Technocom`.
    temp5-maincategory = `Computer Components`.
    temp5-category = `Flat Screen Monitors`.
    temp5-width = `54`.
    temp5-height = `38`.
    temp5-weightmeasure = `18`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Pocket Mouse`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1138.jpg`.
    temp5-suppliername = `Technocom`.
    temp5-maincategory = `Computer Components`.
    temp5-category = `Mice`.
    temp5-width = `0.3`.
    temp5-height = `1`.
    temp5-weightmeasure = `0.02`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `PC Power Station`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1210.jpg`.
    temp5-suppliername = `Technocom`.
    temp5-maincategory = `Computer Systems`.
    temp5-category = `PCs`.
    temp5-width = `28`.
    temp5-height = `43`.
    temp5-weightmeasure = `2.3`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Astro Laptop 1516`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1251.jpg`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-maincategory = `Computer Systems`.
    temp5-category = `Laptops`.
    temp5-width = `30`.
    temp5-height = `3`.
    temp5-weightmeasure = `4.2`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Astro Phone 6`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1252.jpg`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-maincategory = `Smartphones & Tablets`.
    temp5-category = `Smartphones and Tablets`.
    temp5-width = `8`.
    temp5-height = `1.5`.
    temp5-weightmeasure = `0.75`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Benda Laptop 1408`.
    temp5-status = `Discontinued`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1253.jpg`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-maincategory = `Computer Systems`.
    temp5-category = `Laptops`.
    temp5-width = `30`.
    temp5-height = `3`.
    temp5-weightmeasure = `4.2`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Bending Screen 21HD`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1254.jpg`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-maincategory = `Computer Components`.
    temp5-category = `Flat Screens`.
    temp5-width = `37`.
    temp5-height = `36`.
    temp5-weightmeasure = `15`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Broad Screen 22HD`.
    temp5-status = `Discontinued`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1255.jpg`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-maincategory = `Computer Components`.
    temp5-category = `Flat Screens`.
    temp5-width = `39`.
    temp5-height = `38`.
    temp5-weightmeasure = `16`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Cerdik Phone 7`.
    temp5-status = `Discontinued`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1256.jpg`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-maincategory = `Smartphones & Tablets`.
    temp5-category = `Smartphones and Tablets`.
    temp5-width = `9`.
    temp5-height = `1.5`.
    temp5-weightmeasure = `0.75`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Cepat Tablet 10.5`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1257.jpg`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-maincategory = `Smartphones & Tablets`.
    temp5-category = `Smartphones and Tablets`.
    temp5-width = `48`.
    temp5-height = `4.5`.
    temp5-weightmeasure = `2.8`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Cepat Tablet 8`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1258.jpg`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-maincategory = `Smartphones & Tablets`.
    temp5-category = `Smartphones and Tablets`.
    temp5-width = `38`.
    temp5-height = `3.5`.
    temp5-weightmeasure = `2.5`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Server Basic`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1500.jpg`.
    temp5-suppliername = `Technocom`.
    temp5-maincategory = `Computer Systems`.
    temp5-category = `Servers`.
    temp5-width = `34`.
    temp5-height = `23`.
    temp5-weightmeasure = `18`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Server Professional`.
    temp5-status = `Out of Stock`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1501.jpg`.
    temp5-suppliername = `Technocom`.
    temp5-maincategory = `Computer Systems`.
    temp5-category = `Servers`.
    temp5-width = `29`.
    temp5-height = `27`.
    temp5-weightmeasure = `25`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Server Power Pro`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1502.jpg`.
    temp5-suppliername = `Technocom`.
    temp5-maincategory = `Computer Systems`.
    temp5-category = `Servers`.
    temp5-width = `22`.
    temp5-height = `37`.
    temp5-weightmeasure = `35`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Family PC Basic`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1600.jpg`.
    temp5-suppliername = `Titanium`.
    temp5-maincategory = `Computer Systems`.
    temp5-category = `Desktop Computers`.
    temp5-width = `21.4`.
    temp5-height = `38`.
    temp5-weightmeasure = `4.8`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Family PC Pro`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1601.jpg`.
    temp5-suppliername = `Titanium`.
    temp5-maincategory = `Computer Systems`.
    temp5-category = `Desktop Computers`.
    temp5-width = `25`.
    temp5-height = `40.2`.
    temp5-weightmeasure = `5.3`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Gaming Monster`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1602.jpg`.
    temp5-suppliername = `Titanium`.
    temp5-maincategory = `Computer Systems`.
    temp5-category = `Desktop Computers`.
    temp5-width = `26.5`.
    temp5-height = `47`.
    temp5-weightmeasure = `5.9`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Gaming Monster Pro`.
    temp5-status = `Discontinued`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1603.jpg`.
    temp5-suppliername = `Titanium`.
    temp5-maincategory = `Computer Systems`.
    temp5-category = `Desktop Computers`.
    temp5-width = `27`.
    temp5-height = `42`.
    temp5-weightmeasure = `6.8`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `7" Widescreen Portable DVD Player w MP3`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2000.jpg`.
    temp5-suppliername = `Titanium`.
    temp5-maincategory = `TV, Video & HiFi`.
    temp5-category = `Accessories`.
    temp5-width = `21.4`.
    temp5-height = `27.6`.
    temp5-weightmeasure = `0.79`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `10" Portable DVD player`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2001.jpg`.
    temp5-suppliername = `Titanium`.
    temp5-maincategory = `TV, Video & HiFi`.
    temp5-category = `Accessories`.
    temp5-width = `24`.
    temp5-height = `29`.
    temp5-weightmeasure = `0.84`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Portable DVD Player with 9" LCD Monitor`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2002.jpg`.
    temp5-suppliername = `Technocom`.
    temp5-maincategory = `TV, Video & HiFi`.
    temp5-category = `Accessories`.
    temp5-width = `21`.
    temp5-height = `14`.
    temp5-weightmeasure = `0.72`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `CD/DVD case: 264 sleeves`.
    temp5-status = `Discontinued`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2025.jpg`.
    temp5-suppliername = `Titanium`.
    temp5-maincategory = `Computer Systems`.
    temp5-category = `Accessories`.
    temp5-width = `13`.
    temp5-height = `20`.
    temp5-weightmeasure = `0.65`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Audio/Video Cable Kit - 4m`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2026.jpg`.
    temp5-suppliername = `Titanium`.
    temp5-maincategory = `Computer Systems`.
    temp5-category = `Accessories`.
    temp5-width = `21`.
    temp5-height = `13`.
    temp5-weightmeasure = `0.2`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Removable CD/DVD Laser Labels`.
    temp5-status = `Discontinued`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2027.jpg`.
    temp5-suppliername = `Titanium`.
    temp5-maincategory = `Computer Systems`.
    temp5-category = `Accessories`.
    temp5-width = `5.5`.
    temp5-height = `2`.
    temp5-weightmeasure = `0.15`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Beam Breaker B-1`.
    temp5-status = `Out of Stock`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6100.jpg`.
    temp5-suppliername = `Titanium`.
    temp5-maincategory = `TV, Video & HiFi`.
    temp5-category = `Accessories`.
    temp5-width = `30.4`.
    temp5-height = `23`.
    temp5-weightmeasure = `1.7`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Beam Breaker B-2`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6101.jpg`.
    temp5-suppliername = `Technocom`.
    temp5-maincategory = `TV, Video & HiFi`.
    temp5-category = `Accessories`.
    temp5-width = `30.4`.
    temp5-height = `23`.
    temp5-weightmeasure = `2`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Beam Breaker B-3`.
    temp5-status = `Out of Stock`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6102.jpg`.
    temp5-suppliername = `Technocom`.
    temp5-maincategory = `TV, Video & HiFi`.
    temp5-category = `Accessories`.
    temp5-width = `30.4`.
    temp5-height = `23`.
    temp5-weightmeasure = `2.5`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Play Movie`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6110.jpg`.
    temp5-suppliername = `Fasttech`.
    temp5-maincategory = `TV, Video & HiFi`.
    temp5-category = `Accessories`.
    temp5-width = `37`.
    temp5-height = `6`.
    temp5-weightmeasure = `2.4`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Record Movie`.
    temp5-status = `Discontinued`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6111.jpg`.
    temp5-suppliername = `Fasttech`.
    temp5-maincategory = `TV, Video & HiFi`.
    temp5-category = `Accessories`.
    temp5-width = `38`.
    temp5-height = `6.2`.
    temp5-weightmeasure = `3.1`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `ITelo MusicStick`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6120.jpg`.
    temp5-suppliername = `Fasttech`.
    temp5-maincategory = `TV, Video & HiFi`.
    temp5-category = `Accessories`.
    temp5-width = `1.5`.
    temp5-height = `1`.
    temp5-weightmeasure = `134`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `ITelo Jog-Mate`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6121.jpg`.
    temp5-suppliername = `Fasttech`.
    temp5-maincategory = `TV, Video & HiFi`.
    temp5-category = `Accessories`.
    temp5-width = `5.1`.
    temp5-height = `9.2`.
    temp5-weightmeasure = `134`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Power Pro Player 40`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6122.jpg`.
    temp5-suppliername = `Fasttech`.
    temp5-maincategory = `TV, Video & HiFi`.
    temp5-category = `Accessories`.
    temp5-width = `5.1`.
    temp5-height = `9.2`.
    temp5-weightmeasure = `266`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Power Pro Player 80`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6123.jpg`.
    temp5-suppliername = `Fasttech`.
    temp5-maincategory = `TV, Video & HiFi`.
    temp5-category = `Accessories`.
    temp5-width = `4`.
    temp5-height = `0.8`.
    temp5-weightmeasure = `267`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Flat Watch HD32`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6130.jpg`.
    temp5-suppliername = `Very Best Screens`.
    temp5-maincategory = `TV, Video & HiFi`.
    temp5-category = `Flat Screen TVs`.
    temp5-width = `78`.
    temp5-height = `55`.
    temp5-weightmeasure = `2.6`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Flat Watch HD37`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6131.jpg`.
    temp5-suppliername = `Very Best Screens`.
    temp5-maincategory = `TV, Video & HiFi`.
    temp5-category = `Flat Screen TVs`.
    temp5-width = `99.1`.
    temp5-height = `61`.
    temp5-weightmeasure = `2.2`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Flat Watch HD41`.
    temp5-status = `Discontinued`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6132.jpg`.
    temp5-suppliername = `Very Best Screens`.
    temp5-maincategory = `TV, Video & HiFi`.
    temp5-category = `Flat Screen TVs`.
    temp5-width = `128`.
    temp5-height = `79.1`.
    temp5-weightmeasure = `1.8`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Copperberry`.
    temp5-status = `Discontinued`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7000.jpg`.
    temp5-suppliername = `Fasttech`.
    temp5-maincategory = `Computer Components`.
    temp5-category = `Accessories`.
    temp5-width = `8.1`.
    temp5-height = `12.1`.
    temp5-weightmeasure = `0.5`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Silverberry`.
    temp5-status = `Discontinued`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7010.jpg`.
    temp5-suppliername = `Fasttech`.
    temp5-maincategory = `Computer Components`.
    temp5-category = `Accessories`.
    temp5-width = `8.1`.
    temp5-height = `12.1`.
    temp5-weightmeasure = `0.5`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Goldberry`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7020.jpg`.
    temp5-suppliername = `Fasttech`.
    temp5-maincategory = `Computer Components`.
    temp5-category = `Accessories`.
    temp5-width = `8.1`.
    temp5-height = `12.1`.
    temp5-weightmeasure = `0.5`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Platinberry`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7030.jpg`.
    temp5-suppliername = `Fasttech`.
    temp5-maincategory = `Computer Components`.
    temp5-category = `Accessories`.
    temp5-width = `8.1`.
    temp5-height = `12.1`.
    temp5-weightmeasure = `0.5`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `ITelO FlexTop I4000`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8000.jpg`.
    temp5-suppliername = `Titanium`.
    temp5-maincategory = `Computer Systems`.
    temp5-category = `Laptops`.
    temp5-width = `31`.
    temp5-height = `3.1`.
    temp5-weightmeasure = `4`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `ITelO FlexTop I6300c`.
    temp5-status = `Discontinued`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8001.jpg`.
    temp5-suppliername = `Titanium`.
    temp5-maincategory = `Computer Systems`.
    temp5-category = `Laptops`.
    temp5-width = `32`.
    temp5-height = `3.4`.
    temp5-weightmeasure = `4.2`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `ITelO FlexTop I9100`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8002.jpg`.
    temp5-suppliername = `Titanium`.
    temp5-maincategory = `Computer Systems`.
    temp5-category = `Laptops`.
    temp5-width = `38`.
    temp5-height = `4.1`.
    temp5-weightmeasure = `3.5`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `ITelO FlexTop I9800`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8003.jpg`.
    temp5-suppliername = `Titanium`.
    temp5-maincategory = `Computer Systems`.
    temp5-category = `Laptops`.
    temp5-width = `48`.
    temp5-height = `4.5`.
    temp5-weightmeasure = `3.8`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Smartphone Leather Case`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9991.jpg`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-maincategory = `Smartphones & Tablets`.
    temp5-category = `Accessories`.
    temp5-width = `48`.
    temp5-height = `4.5`.
    temp5-weightmeasure = `0.02`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Smartphone Alpha`.
    temp5-status = `Out of Stock`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9992.jpg`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-maincategory = `Smartphones & Tablets`.
    temp5-category = `Smartphones and Tablets`.
    temp5-width = `48`.
    temp5-height = `4.5`.
    temp5-weightmeasure = `0.75`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Mini Tablet`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9993.jpg`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-maincategory = `Smartphones & Tablets`.
    temp5-category = `Smartphones and Tablets`.
    temp5-width = `48`.
    temp5-height = `4.5`.
    temp5-weightmeasure = `3.8`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Camcorder View`.
    temp5-status = `Out of Stock`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9994.jpg`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-maincategory = `TV, Video & HiFi`.
    temp5-category = `Accessories`.
    temp5-width = `48`.
    temp5-height = `27`.
    temp5-weightmeasure = `3.8`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Tablet Pouch`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9995.jpg`.
    temp5-suppliername = `Titanium`.
    temp5-maincategory = `Smartphones & Tablets`.
    temp5-category = `Accessories`.
    temp5-width = `25`.
    temp5-height = `4.5`.
    temp5-weightmeasure = `0.03`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Tablet Pouch`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9996.jpg`.
    temp5-suppliername = `Titanium`.
    temp5-maincategory = `Smartphones & Tablets`.
    temp5-category = `Accessories`.
    temp5-width = `25`.
    temp5-height = `4.5`.
    temp5-weightmeasure = `0.03`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `e-Book Reader ReadMe`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9997.jpg`.
    temp5-suppliername = `Titanium`.
    temp5-maincategory = `Smartphones & Tablets`.
    temp5-category = `Smartphones and Tablets`.
    temp5-width = `48`.
    temp5-height = `4.5`.
    temp5-weightmeasure = `3.8`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Smartphone Beta`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9998.jpg`.
    temp5-suppliername = `Titanium`.
    temp5-maincategory = `Smartphones & Tablets`.
    temp5-category = `Smartphones and Tablets`.
    temp5-width = `48`.
    temp5-height = `4.5`.
    temp5-weightmeasure = `0.75`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Maxi Tablet`.
    temp5-status = `Available`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9999.jpg`.
    temp5-suppliername = `Titanium`.
    temp5-maincategory = `Smartphones & Tablets`.
    temp5-category = `Tablets`.
    temp5-width = `48`.
    temp5-height = `4.5`.
    temp5-weightmeasure = `3.8`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Flyer`.
    temp5-status = `Out of Stock`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/PF-1000.jpg`.
    temp5-suppliername = `Titanium`.
    temp5-maincategory = `Computer Systems`.
    temp5-category = `Accessories`.
    temp5-width = `46`.
    temp5-height = `3`.
    temp5-weightmeasure = `0.01`.
    INSERT temp5 INTO TABLE temp4.
    t_products = temp4.

  ENDMETHOD.

ENDCLASS.
