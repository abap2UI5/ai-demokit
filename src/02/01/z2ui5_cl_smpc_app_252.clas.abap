" @keywords carousel sap.m carouselwithmorepages label input switch title carousellayout scrollcontainer hbox text
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
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

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
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`       v = `sap.m`
        )->a( n = `xmlns:mvc`   v = `sap.ui.core.mvc`
        )->a( n = `xmlns:f`     v = `sap.f`
        )->a( n = `xmlns:cards` v = `sap.f.cards`
        )->a( n = `xmlns:l`     v = `sap.ui.layout`
        )->a( n = `xmlns:lf`    v = `sap.ui.layout.form`
        )->a( n = `height`      v = `100%`

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
                    )->a( n = `value`           v = client->_bind( pages_count )
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
                )->a( n = `pages`          v = |\{ path: '{ client->_bind( val = t_products path = abap_true ) }' \}|

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
    client->follow_up_action( val   = client->cs_event-set_size_limit
                              t_arg = VALUE #( ( `10` ) ( `MAIN` ) ) ).

  ENDMETHOD.


  METHOD model_init.

    " onInit's device branch, resolved SERVER-SIDE from the framework's own
    " device mirror rather than hard-coded to the desktop leg (apps 012/173/302
    " precedent): desktop 4 / tablet 2 / else 1, exactly as the original seeds
    " it once in onInit
    pages_count    = COND #(
        WHEN client->get( )-s_device-system = z2ui5_if_client=>cs_device-system-desktop THEN 4
        WHEN client->get( )-s_device-system = z2ui5_if_client=>cs_device-system-tablet  THEN 2
        ELSE 1 ).
    scroll_visible = abap_false.

    " sap/ui/demo/mock/products.json - the full 123-row ProductCollection,
    " the nine bound fields per row (setSizeLimit(10) caps the rendering)
    t_products = VALUE #(
          ( name = `Notebook Basic 15` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg`
            suppliername = `Very Best Screens` maincategory = `Computer Systems` category = `Laptops`
            width = `30` height = `3` weightmeasure = `4.2` )
          ( name = `Notebook Basic 17` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1001.jpg`
            suppliername = `Very Best Screens` maincategory = `Computer Systems` category = `Laptops`
            width = `29` height = `3.1` weightmeasure = `4.5` )
          ( name = `Notebook Basic 18` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1002.jpg`
            suppliername = `Very Best Screens` maincategory = `Computer Systems` category = `Laptops`
            width = `28` height = `2.5` weightmeasure = `4.2` )
          ( name = `Notebook Basic 19` status = `Out of Stock` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1003.jpg`
            suppliername = `Smartcards` maincategory = `Computer Systems` category = `Laptops`
            width = `32` height = `4` weightmeasure = `4.2` )
          ( name = `ITelO Vault` status = `Out of Stock` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1007.jpg`
            suppliername = `Technocom` maincategory = `Computer Components` category = `Accessories`
            width = `32` height = `3` weightmeasure = `0.2` )
          ( name = `Notebook Professional 15` status = `Out of Stock` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg`
            suppliername = `Very Best Screens` maincategory = `Computer Systems` category = `Accessories`
            width = `33` height = `3` weightmeasure = `4.3` )
          ( name = `Notebook Professional 17` status = `Out of Stock` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1011.jpg`
            suppliername = `Very Best Screens` maincategory = `Computer Systems` category = `Laptops`
            width = `33` height = `2` weightmeasure = `4.1` )
          ( name = `ITelO Vault Net` status = `Discontinued` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1020.jpg`
            suppliername = `Technocom` maincategory = `Computer Components` category = `Accessories`
            width = `10` height = `17` weightmeasure = `0.16` )
          ( name = `ITelO Vault SAT` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1021.jpg`
            suppliername = `Technocom` maincategory = `Computer Components` category = `Accessories`
            width = `11` height = `18` weightmeasure = `0.18` )
          ( name = `Comfort Easy` status = `Out of Stock` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1022.jpg`
            suppliername = `Technocom` maincategory = `Computer Components` category = `Accessories`
            width = `84` height = `14` weightmeasure = `0.2` )
          ( name = `Comfort Senior` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1023.jpg`
            suppliername = `Technocom` maincategory = `Computer Components` category = `Accessories`
            width = `80` height = `13` weightmeasure = `0.8` )
          ( name = `Ergo Screen E-I` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1030.jpg`
            suppliername = `Very Best Screens` maincategory = `Computer Components` category = `Flat Screen Monitors`
            width = `37` height = `36` weightmeasure = `21` )
          ( name = `Ergo Screen E-II` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1031.jpg`
            suppliername = `Very Best Screens` maincategory = `Computer Components` category = `Flat Screen Monitors`
            width = `40.8` height = `43` weightmeasure = `21` )
          ( name = `Ergo Screen E-III` status = `Out of Stock` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1032.jpg`
            suppliername = `Very Best Screens` maincategory = `Computer Components` category = `Flat Screen Monitors`
            width = `40.8` height = `43` weightmeasure = `21` )
          ( name = `Flat Basic` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1035.jpg`
            suppliername = `Very Best Screens` maincategory = `Computer Components` category = `Flat Screen Monitors`
            width = `39` height = `41` weightmeasure = `14` )
          ( name = `Flat Future` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1036.jpg`
            suppliername = `Very Best Screens` maincategory = `Computer Components` category = `Flat Screen Monitors`
            width = `45` height = `46` weightmeasure = `15` )
          ( name = `Flat XL` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1037.jpg`
            suppliername = `Very Best Screens` maincategory = `Computer Components` category = `Flat Screen Monitors`
            width = `54.5` height = `39.1` weightmeasure = `17` )
          ( name = `Laser Professional Eco` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1040.jpg`
            suppliername = `Alpha Printers` maincategory = `Printers & Scanners` category = `Printers`
            width = `51` height = `30` weightmeasure = `32` )
          ( name = `Laser Basic` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1041.jpg`
            suppliername = `Alpha Printers` maincategory = `Printers & Scanners` category = `Printers`
            width = `48` height = `26` weightmeasure = `23` )
          ( name = `Laser Allround` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1042.jpg`
            suppliername = `Alpha Printers` maincategory = `Printers & Scanners` category = `Printers`
            width = `53` height = `65` weightmeasure = `17` )
          ( name = `Ultra Jet Super Color` status = `Discontinued` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1050.jpg`
            suppliername = `Alpha Printers` maincategory = `Printers & Scanners` category = `Printers`
            width = `41` height = `28` weightmeasure = `3` )
          ( name = `Ultra Jet Mobile` status = `Discontinued` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1051.jpg`
            suppliername = `Printer for All` maincategory = `Printers & Scanners` category = `Printers`
            width = `46` height = `25` weightmeasure = `1.9` )
          ( name = `Ultra Jet Super Highspeed` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1052.jpg`
            suppliername = `Printer for All` maincategory = `Printers & Scanners` category = `Printers`
            width = `41` height = `28` weightmeasure = `18` )
          ( name = `Multi Print` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1055.jpg`
            suppliername = `Printer for All` maincategory = `Printers & Scanners` category = `Multifunction Printers`
            width = `55` height = `29` weightmeasure = `6.3` )
          ( name = `Multi Color` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1056.jpg`
            suppliername = `Printer for All` maincategory = `Printers & Scanners` category = `Multifunction Printers`
            width = `51` height = `22` weightmeasure = `4.3` )
          ( name = `Cordless Mouse` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1060.jpg`
            suppliername = `Oxynum` maincategory = `Computer Components` category = `Mice`
            width = `6` height = `3.5` weightmeasure = `0.09` )
          ( name = `Speed Mouse` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1061.jpg`
            suppliername = `Oxynum` maincategory = `Computer Components` category = `Mice`
            width = `7` height = `3.1` weightmeasure = `0.09` )
          ( name = `Track Mouse` status = `Discontinued` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1062.jpg`
            suppliername = `Oxynum` maincategory = `Computer Components` category = `Mice`
            width = `3` height = `4` weightmeasure = `0.03` )
          ( name = `Ergonomic Keyboard` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1063.jpg`
            suppliername = `Oxynum` maincategory = `Computer Components` category = `Keyboards`
            width = `50` height = `3.5` weightmeasure = `2.1` )
          ( name = `Internet Keyboard` status = `Out of Stock` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1064.jpg`
            suppliername = `Oxynum` maincategory = `Computer Components` category = `Keyboards`
            width = `52` height = `3` weightmeasure = `1.8` )
          ( name = `Media Keyboard` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1065.jpg`
            suppliername = `Oxynum` maincategory = `Computer Components` category = `Keyboards`
            width = `51.4` height = `4` weightmeasure = `2.3` )
          ( name = `Mousepad` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1066.jpg`
            suppliername = `Oxynum` maincategory = `Computer Components` category = `Mousepads`
            width = `15` height = `0.2` weightmeasure = `80` )
          ( name = `Ergo Mousepad` status = `Out of Stock` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1067.jpg`
            suppliername = `Oxynum` maincategory = `Computer Components` category = `Mousepads`
            width = `15` height = `0.2` weightmeasure = `80` )
          ( name = `Designer Mousepad` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1068.jpg`
            suppliername = `Fasttech` maincategory = `Computer Components` category = `Mousepads`
            width = `24` height = `0.6` weightmeasure = `90` )
          ( name = `Universal card reader` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1069.jpg`
            suppliername = `Fasttech` maincategory = `Computer Systems` category = `Computer System Accessories`
            width = `6` height = `3` weightmeasure = `45` )
          ( name = `Proctra X` status = `Out of Stock` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1070.jpg`
            suppliername = `Ultrasonic United` maincategory = `Computer Components` category = `Graphic Cards`
            width = `22` height = `17` weightmeasure = `0.255` )
          ( name = `Gladiator MX` status = `Discontinued` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1071.jpg`
            suppliername = `Ultrasonic United` maincategory = `Computer Components` category = `Graphic Cards`
            width = `22` height = `17` weightmeasure = `0.3` )
          ( name = `Hurricane GX` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1072.jpg`
            suppliername = `Ultrasonic United` maincategory = `Computer Components` category = `Graphic Cards`
            width = `22` height = `17` weightmeasure = `0.4` )
          ( name = `Hurricane GX/LN` status = `Out of Stock` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1073.jpg`
            suppliername = `Smartcards` maincategory = `Computer Components` category = `Graphic Cards`
            width = `22` height = `17` weightmeasure = `0.4` )
          ( name = `Photo Scan` status = `Out of Stock` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1080.jpg`
            suppliername = `Printer for All` maincategory = `Printers & Scanners` category = `Scanners`
            width = `34` height = `5` weightmeasure = `2.3` )
          ( name = `Power Scan` status = `Out of Stock` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1081.jpg`
            suppliername = `Printer for All` maincategory = `Printers & Scanners` category = `Scanners`
            width = `31` height = `7` weightmeasure = `2.4` )
          ( name = `Jet Scan Professional` status = `Out of Stock` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1082.jpg`
            suppliername = `Printer for All` maincategory = `Printers & Scanners` category = `Scanners`
            width = `33` height = `12` weightmeasure = `3.2` )
          ( name = `Jet Scan Professional` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1083.jpg`
            suppliername = `Printer for All` maincategory = `Printers & Scanners` category = `Scanners`
            width = `35` height = `10` weightmeasure = `3.2` )
          ( name = `Copymaster` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1085.jpg`
            suppliername = `Alpha Printers` maincategory = `Printers & Scanners` category = `Multifunction Printers`
            width = `45` height = `22` weightmeasure = `23.2` )
          ( name = `Surround Sound` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1090.jpg`
            suppliername = `Speaker Experts` maincategory = `Computer Components` category = `Speakers`
            width = `12` height = `16` weightmeasure = `3` )
          ( name = `Blaster Extreme` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1091.jpg`
            suppliername = `Speaker Experts` maincategory = `Computer Components` category = `Speakers`
            width = `13` height = `17.5` weightmeasure = `1.4` )
          ( name = `Sound Booster` status = `Discontinued` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1092.jpg`
            suppliername = `Speaker Experts` maincategory = `Computer Components` category = `Speakers`
            width = `12.4` height = `18.1` weightmeasure = `2.1` )
          ( name = `Lovely Sound 5.1 Wireless` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1095.jpg`
            suppliername = `Fasttech` maincategory = `Computer Components` category = `Accessories`
            width = `24` height = `23` weightmeasure = `80` )
          ( name = `Lovely Sound 5.1` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1096.jpg`
            suppliername = `Fasttech` maincategory = `Computer Components` category = `Accessories`
            width = `25` height = `19` weightmeasure = `130` )
          ( name = `Lovely Sound Stereo` status = `Out of Stock` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1097.jpg`
            suppliername = `Fasttech` maincategory = `Computer Components` category = `Accessories`
            width = `21.3` height = `19.7` weightmeasure = `60` )
          ( name = `Smart Office` status = `Out of Stock` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1100.jpg`
            suppliername = `Technocom` maincategory = `Software` category = `Software`
            width = `15` height = `2.1` weightmeasure = `1.2` )
          ( name = `Smart Design` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1101.jpg`
            suppliername = `Technocom` maincategory = `Software` category = `Software`
            width = `14` height = `24` weightmeasure = `0.8` )
          ( name = `Smart Network` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1102.jpg`
            suppliername = `Technocom` maincategory = `Software` category = `Software`
            width = `16` height = `27` weightmeasure = `0.8` )
          ( name = `Smart Multimedia` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1103.jpg`
            suppliername = `Technocom` maincategory = `Software` category = `Software`
            width = `11` height = `22` weightmeasure = `0.8` )
          ( name = `Smart Games` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1104.jpg`
            suppliername = `Technocom` maincategory = `Software` category = `Software`
            width = `10` height = `30` weightmeasure = `1.1` )
          ( name = `Smart Internet Antivirus` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1105.jpg`
            suppliername = `Brainsoft` maincategory = `Software` category = `Software`
            width = `16` height = `21` weightmeasure = `0.7` )
          ( name = `Smart Firewall` status = `Discontinued` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1106.jpg`
            suppliername = `Brainsoft` maincategory = `Software` category = `Software`
            width = `17.9` height = `23.1` weightmeasure = `0.9` )
          ( name = `Smart Money` status = `Out of Stock` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1107.jpg`
            suppliername = `Brainsoft` maincategory = `Software` category = `Software`
            width = `12` height = `19` weightmeasure = `0.5` )
          ( name = `PC Lock` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1110.jpg`
            suppliername = `Red Point Stores` maincategory = `Computer Systems` category = `Computer System Accessories`
            width = `20` height = `4.3` weightmeasure = `0.03` )
          ( name = `Notebook Lock` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1111.jpg`
            suppliername = `Red Point Stores` maincategory = `Computer Systems` category = `Computer System Accessories`
            width = `31` height = `7` weightmeasure = `0.02` )
          ( name = `Web cam reality` status = `Out of Stock` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1112.jpg`
            suppliername = `Red Point Stores` maincategory = `Computer Systems` category = `Computer System Accessories`
            width = `9` height = `1.3` weightmeasure = `0.075` )
          ( name = `Screen clean` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1113.jpg`
            suppliername = `Red Point Stores` maincategory = `Computer Systems` category = `Computer System Accessories`
            width = `2` height = `0.1` weightmeasure = `0.05` )
          ( name = `Fabric bag professional` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1114.jpg`
            suppliername = `Red Point Stores` maincategory = `Computer Systems` category = `Computer System Accessories`
            width = `42` height = `7` weightmeasure = `1.8` )
          ( name = `Wireless DSL Router` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1115.jpg`
            suppliername = `Red Point Stores` maincategory = `Computer Components` category = `Telecommunications`
            width = `19.3` height = `5` weightmeasure = `0.45` )
          ( name = `Wireless DSL Router / Repeater` status = `Out of Stock` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1116.jpg`
            suppliername = `Red Point Stores` maincategory = `Computer Components` category = `Telecommunications`
            width = `19.3` height = `5` weightmeasure = `0.45` )
          ( name = `Wireless DSL Router / Repeater and Print Server` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1117.jpg`
            suppliername = `Technocom` maincategory = `Computer Components` category = `Telecommunications`
            width = `19.3` height = `5` weightmeasure = `0.45` )
          ( name = `USB Stick` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1118.jpg`
            suppliername = `Technocom` maincategory = `Computer Systems` category = `Computer System Accessories`
            width = `1.5` height = `1.2` weightmeasure = `0.015` )
          ( name = `Travel Adapter` status = `Discontinued` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1119.jpg`
            suppliername = `Titanium` maincategory = `Computer Systems` category = `Accessories`
            width = `2` height = `3.9` weightmeasure = `88` )
          ( name = `Cordless Bluetooth Keyboard, english international` status = `Out of Stock` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1120.jpg`
            suppliername = `Technocom` maincategory = `Computer Components` category = `Keyboards`
            width = `51.4` height = `4` weightmeasure = `1` )
          ( name = `Flat XXL` status = `Discontinued` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1137.jpg`
            suppliername = `Technocom` maincategory = `Computer Components` category = `Flat Screen Monitors`
            width = `54` height = `38` weightmeasure = `18` )
          ( name = `Pocket Mouse` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1138.jpg`
            suppliername = `Technocom` maincategory = `Computer Components` category = `Mice`
            width = `0.3` height = `1` weightmeasure = `0.02` )
          ( name = `PC Power Station` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1210.jpg`
            suppliername = `Technocom` maincategory = `Computer Systems` category = `PCs`
            width = `28` height = `43` weightmeasure = `2.3` )
          ( name = `Astro Laptop 1516` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1251.jpg`
            suppliername = `Ultrasonic United` maincategory = `Computer Systems` category = `Laptops`
            width = `30` height = `3` weightmeasure = `4.2` )
          ( name = `Astro Phone 6` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1252.jpg`
            suppliername = `Ultrasonic United` maincategory = `Smartphones & Tablets` category = `Smartphones and Tablets`
            width = `8` height = `1.5` weightmeasure = `0.75` )
          ( name = `Benda Laptop 1408` status = `Discontinued` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1253.jpg`
            suppliername = `Ultrasonic United` maincategory = `Computer Systems` category = `Laptops`
            width = `30` height = `3` weightmeasure = `4.2` )
          ( name = `Bending Screen 21HD` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1254.jpg`
            suppliername = `Ultrasonic United` maincategory = `Computer Components` category = `Flat Screens`
            width = `37` height = `36` weightmeasure = `15` )
          ( name = `Broad Screen 22HD` status = `Discontinued` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1255.jpg`
            suppliername = `Ultrasonic United` maincategory = `Computer Components` category = `Flat Screens`
            width = `39` height = `38` weightmeasure = `16` )
          ( name = `Cerdik Phone 7` status = `Discontinued` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1256.jpg`
            suppliername = `Ultrasonic United` maincategory = `Smartphones & Tablets` category = `Smartphones and Tablets`
            width = `9` height = `1.5` weightmeasure = `0.75` )
          ( name = `Cepat Tablet 10.5` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1257.jpg`
            suppliername = `Ultrasonic United` maincategory = `Smartphones & Tablets` category = `Smartphones and Tablets`
            width = `48` height = `4.5` weightmeasure = `2.8` )
          ( name = `Cepat Tablet 8` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1258.jpg`
            suppliername = `Ultrasonic United` maincategory = `Smartphones & Tablets` category = `Smartphones and Tablets`
            width = `38` height = `3.5` weightmeasure = `2.5` )
          ( name = `Server Basic` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1500.jpg`
            suppliername = `Technocom` maincategory = `Computer Systems` category = `Servers`
            width = `34` height = `23` weightmeasure = `18` )
          ( name = `Server Professional` status = `Out of Stock` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1501.jpg`
            suppliername = `Technocom` maincategory = `Computer Systems` category = `Servers`
            width = `29` height = `27` weightmeasure = `25` )
          ( name = `Server Power Pro` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1502.jpg`
            suppliername = `Technocom` maincategory = `Computer Systems` category = `Servers`
            width = `22` height = `37` weightmeasure = `35` )
          ( name = `Family PC Basic` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1600.jpg`
            suppliername = `Titanium` maincategory = `Computer Systems` category = `Desktop Computers`
            width = `21.4` height = `38` weightmeasure = `4.8` )
          ( name = `Family PC Pro` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1601.jpg`
            suppliername = `Titanium` maincategory = `Computer Systems` category = `Desktop Computers`
            width = `25` height = `40.2` weightmeasure = `5.3` )
          ( name = `Gaming Monster` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1602.jpg`
            suppliername = `Titanium` maincategory = `Computer Systems` category = `Desktop Computers`
            width = `26.5` height = `47` weightmeasure = `5.9` )
          ( name = `Gaming Monster Pro` status = `Discontinued` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1603.jpg`
            suppliername = `Titanium` maincategory = `Computer Systems` category = `Desktop Computers`
            width = `27` height = `42` weightmeasure = `6.8` )
          ( name = `7" Widescreen Portable DVD Player w MP3` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2000.jpg`
            suppliername = `Titanium` maincategory = `TV, Video & HiFi` category = `Accessories`
            width = `21.4` height = `27.6` weightmeasure = `0.79` )
          ( name = `10" Portable DVD player` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2001.jpg`
            suppliername = `Titanium` maincategory = `TV, Video & HiFi` category = `Accessories`
            width = `24` height = `29` weightmeasure = `0.84` )
          ( name = `Portable DVD Player with 9" LCD Monitor` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2002.jpg`
            suppliername = `Technocom` maincategory = `TV, Video & HiFi` category = `Accessories`
            width = `21` height = `14` weightmeasure = `0.72` )
          ( name = `CD/DVD case: 264 sleeves` status = `Discontinued` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2025.jpg`
            suppliername = `Titanium` maincategory = `Computer Systems` category = `Accessories`
            width = `13` height = `20` weightmeasure = `0.65` )
          ( name = `Audio/Video Cable Kit - 4m` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2026.jpg`
            suppliername = `Titanium` maincategory = `Computer Systems` category = `Accessories`
            width = `21` height = `13` weightmeasure = `0.2` )
          ( name = `Removable CD/DVD Laser Labels` status = `Discontinued` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2027.jpg`
            suppliername = `Titanium` maincategory = `Computer Systems` category = `Accessories`
            width = `5.5` height = `2` weightmeasure = `0.15` )
          ( name = `Beam Breaker B-1` status = `Out of Stock` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6100.jpg`
            suppliername = `Titanium` maincategory = `TV, Video & HiFi` category = `Accessories`
            width = `30.4` height = `23` weightmeasure = `1.7` )
          ( name = `Beam Breaker B-2` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6101.jpg`
            suppliername = `Technocom` maincategory = `TV, Video & HiFi` category = `Accessories`
            width = `30.4` height = `23` weightmeasure = `2` )
          ( name = `Beam Breaker B-3` status = `Out of Stock` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6102.jpg`
            suppliername = `Technocom` maincategory = `TV, Video & HiFi` category = `Accessories`
            width = `30.4` height = `23` weightmeasure = `2.5` )
          ( name = `Play Movie` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6110.jpg`
            suppliername = `Fasttech` maincategory = `TV, Video & HiFi` category = `Accessories`
            width = `37` height = `6` weightmeasure = `2.4` )
          ( name = `Record Movie` status = `Discontinued` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6111.jpg`
            suppliername = `Fasttech` maincategory = `TV, Video & HiFi` category = `Accessories`
            width = `38` height = `6.2` weightmeasure = `3.1` )
          ( name = `ITelo MusicStick` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6120.jpg`
            suppliername = `Fasttech` maincategory = `TV, Video & HiFi` category = `Accessories`
            width = `1.5` height = `1` weightmeasure = `134` )
          ( name = `ITelo Jog-Mate` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6121.jpg`
            suppliername = `Fasttech` maincategory = `TV, Video & HiFi` category = `Accessories`
            width = `5.1` height = `9.2` weightmeasure = `134` )
          ( name = `Power Pro Player 40` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6122.jpg`
            suppliername = `Fasttech` maincategory = `TV, Video & HiFi` category = `Accessories`
            width = `5.1` height = `9.2` weightmeasure = `266` )
          ( name = `Power Pro Player 80` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6123.jpg`
            suppliername = `Fasttech` maincategory = `TV, Video & HiFi` category = `Accessories`
            width = `4` height = `0.8` weightmeasure = `267` )
          ( name = `Flat Watch HD32` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6130.jpg`
            suppliername = `Very Best Screens` maincategory = `TV, Video & HiFi` category = `Flat Screen TVs`
            width = `78` height = `55` weightmeasure = `2.6` )
          ( name = `Flat Watch HD37` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6131.jpg`
            suppliername = `Very Best Screens` maincategory = `TV, Video & HiFi` category = `Flat Screen TVs`
            width = `99.1` height = `61` weightmeasure = `2.2` )
          ( name = `Flat Watch HD41` status = `Discontinued` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6132.jpg`
            suppliername = `Very Best Screens` maincategory = `TV, Video & HiFi` category = `Flat Screen TVs`
            width = `128` height = `79.1` weightmeasure = `1.8` )
          ( name = `Copperberry` status = `Discontinued` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7000.jpg`
            suppliername = `Fasttech` maincategory = `Computer Components` category = `Accessories`
            width = `8.1` height = `12.1` weightmeasure = `0.5` )
          ( name = `Silverberry` status = `Discontinued` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7010.jpg`
            suppliername = `Fasttech` maincategory = `Computer Components` category = `Accessories`
            width = `8.1` height = `12.1` weightmeasure = `0.5` )
          ( name = `Goldberry` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7020.jpg`
            suppliername = `Fasttech` maincategory = `Computer Components` category = `Accessories`
            width = `8.1` height = `12.1` weightmeasure = `0.5` )
          ( name = `Platinberry` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7030.jpg`
            suppliername = `Fasttech` maincategory = `Computer Components` category = `Accessories`
            width = `8.1` height = `12.1` weightmeasure = `0.5` )
          ( name = `ITelO FlexTop I4000` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8000.jpg`
            suppliername = `Titanium` maincategory = `Computer Systems` category = `Laptops`
            width = `31` height = `3.1` weightmeasure = `4` )
          ( name = `ITelO FlexTop I6300c` status = `Discontinued` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8001.jpg`
            suppliername = `Titanium` maincategory = `Computer Systems` category = `Laptops`
            width = `32` height = `3.4` weightmeasure = `4.2` )
          ( name = `ITelO FlexTop I9100` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8002.jpg`
            suppliername = `Titanium` maincategory = `Computer Systems` category = `Laptops`
            width = `38` height = `4.1` weightmeasure = `3.5` )
          ( name = `ITelO FlexTop I9800` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8003.jpg`
            suppliername = `Titanium` maincategory = `Computer Systems` category = `Laptops`
            width = `48` height = `4.5` weightmeasure = `3.8` )
          ( name = `Smartphone Leather Case` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9991.jpg`
            suppliername = `Ultrasonic United` maincategory = `Smartphones & Tablets` category = `Accessories`
            width = `48` height = `4.5` weightmeasure = `0.02` )
          ( name = `Smartphone Alpha` status = `Out of Stock` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9992.jpg`
            suppliername = `Ultrasonic United` maincategory = `Smartphones & Tablets` category = `Smartphones and Tablets`
            width = `48` height = `4.5` weightmeasure = `0.75` )
          ( name = `Mini Tablet` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9993.jpg`
            suppliername = `Ultrasonic United` maincategory = `Smartphones & Tablets` category = `Smartphones and Tablets`
            width = `48` height = `4.5` weightmeasure = `3.8` )
          ( name = `Camcorder View` status = `Out of Stock` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9994.jpg`
            suppliername = `Ultrasonic United` maincategory = `TV, Video & HiFi` category = `Accessories`
            width = `48` height = `27` weightmeasure = `3.8` )
          ( name = `Tablet Pouch` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9995.jpg`
            suppliername = `Titanium` maincategory = `Smartphones & Tablets` category = `Accessories`
            width = `25` height = `4.5` weightmeasure = `0.03` )
          ( name = `Tablet Pouch` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9996.jpg`
            suppliername = `Titanium` maincategory = `Smartphones & Tablets` category = `Accessories`
            width = `25` height = `4.5` weightmeasure = `0.03` )
          ( name = `e-Book Reader ReadMe` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9997.jpg`
            suppliername = `Titanium` maincategory = `Smartphones & Tablets` category = `Smartphones and Tablets`
            width = `48` height = `4.5` weightmeasure = `3.8` )
          ( name = `Smartphone Beta` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9998.jpg`
            suppliername = `Titanium` maincategory = `Smartphones & Tablets` category = `Smartphones and Tablets`
            width = `48` height = `4.5` weightmeasure = `0.75` )
          ( name = `Maxi Tablet` status = `Available` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9999.jpg`
            suppliername = `Titanium` maincategory = `Smartphones & Tablets` category = `Tablets`
            width = `48` height = `4.5` weightmeasure = `3.8` )
          ( name = `Flyer` status = `Out of Stock` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/PF-1000.jpg`
            suppliername = `Titanium` maincategory = `Computer Systems` category = `Accessories`
            width = `46` height = `3` weightmeasure = `0.01` ) ).

  ENDMETHOD.

ENDCLASS.
