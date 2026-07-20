CLASS z2ui5_cl_ai_app_012 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        product_id      TYPE string,
        category        TYPE string,
        main_category   TYPE string,
        tax_tarif_code  TYPE string,
        supplier_name   TYPE string,
        weight_measure  TYPE string,
        weight_unit     TYPE string,
        description     TYPE string,
        name            TYPE string,
        date_of_sale    TYPE string,
        product_pic_url TYPE string,
        status          TYPE string,
        quantity        TYPE string,
        uom             TYPE string,
        currency_code   TYPE string,
        price           TYPE p LENGTH 8 DECIMALS 0,
        width           TYPE string,
        depth           TYPE string,
        height          TYPE string,
        dim_unit        TYPE string,
        selected        TYPE abap_bool,
      END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.
    TYPES:
      BEGIN OF ty_s_comp_value,
        text        TYPE string,
        description TYPE string,
        visible     TYPE abap_bool,
      END OF ty_s_comp_value.
    TYPES ty_t_comp_value TYPE STANDARD TABLE OF ty_s_comp_value WITH EMPTY KEY.
    TYPES:
      BEGIN OF ty_s_comp_prop,
        key    TYPE string,
        values TYPE ty_t_comp_value,
      END OF ty_s_comp_prop.
    TYPES ty_t_comp_prop TYPE STANDARD TABLE OF ty_s_comp_prop WITH EMPTY KEY.

    DATA t_products      TYPE ty_t_product.
    DATA t_comp_products TYPE ty_t_product.
    DATA t_comp_props    TYPE ty_t_comp_prop.
    DATA pages_count     TYPE i.
    DATA is_desktop      TYPE abap_bool.
    DATA compare_text    TYPE string.
    DATA compare_visible TYPE abap_bool.

  PROTECTED SECTION.
    TYPES:
      BEGIN OF ty_s_key,
        key   TYPE string,
        field TYPE string,
      END OF ty_s_key.
    TYPES ty_t_key TYPE STANDARD TABLE OF ty_s_key WITH EMPTY KEY.

    DATA client     TYPE REF TO z2ui5_if_client.
    DATA first_item TYPE i.

    METHODS model_init.
    METHODS view_display.
    METHODS on_event.
    METHODS comparison_build.
    METHODS comparison_props_build.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_012 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " the 11 Category=Laptops rows of the shared mock /ProductCollection; ProductPicUrl resolved to absolute OpenUI5 URLs (the sample's .formatter.url)
    t_products = VALUE #(
      ( product_id = `HT-1000` category = `Laptops` main_category = `Computer Systems` tax_tarif_code = `1` supplier_name = `Very Best Screens` weight_measure = `4.2` weight_unit = `KG`
        description = `Notebook Basic 15 with 2,80 GHz quad core, 15" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro` name = `Notebook Basic 15` date_of_sale = `2017-03-26`
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg`
        status = `Available` quantity = `10` uom = `PC` currency_code = `EUR` price = 956 width = `30` depth = `18` height = `3` dim_unit = `cm` )
      ( product_id = `HT-1001` category = `Laptops` main_category = `Computer Systems` tax_tarif_code = `1` supplier_name = `Very Best Screens` weight_measure = `4.5` weight_unit = `KG`
        description = `Notebook Basic 17 with 2,80 GHz quad core, 17" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro` name = `Notebook Basic 17` date_of_sale = `2017-04-17`
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1001.jpg`
        status = `Available` quantity = `20` uom = `PC` currency_code = `EUR` price = 1249 width = `29` depth = `17` height = `3.1` dim_unit = `cm` )
      ( product_id = `HT-1002` category = `Laptops` main_category = `Computer Systems` tax_tarif_code = `1` supplier_name = `Very Best Screens` weight_measure = `4.2` weight_unit = `KG`
        description = `Notebook Basic 18 with 2,80 GHz quad core, 18" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro` name = `Notebook Basic 18` date_of_sale = `2017-01-07`
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1002.jpg`
        status = `Available` quantity = `10` uom = `PC` currency_code = `EUR` price = 1570 width = `28` depth = `19` height = `2.5` dim_unit = `cm` )
      ( product_id = `HT-1003` category = `Laptops` main_category = `Computer Systems` tax_tarif_code = `1` supplier_name = `Smartcards` weight_measure = `4.2` weight_unit = `KG`
        description = `Notebook Basic 19 with 2,80 GHz quad core, 19" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro` name = `Notebook Basic 19` date_of_sale = `2017-04-09`
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1003.jpg`
        status = `Out of Stock` quantity = `15` uom = `PC` currency_code = `EUR` price = 1650 width = `32` depth = `21` height = `4` dim_unit = `cm` )
      ( product_id = `HT-1011` category = `Laptops` main_category = `Computer Systems` tax_tarif_code = `1` supplier_name = `Very Best Screens` weight_measure = `4.1` weight_unit = `KG`
        description = `Notebook Professional 17 with 2,80 GHz quad core, 17" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro` name = `Notebook Professional 17` date_of_sale = `2017-01-02`
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1011.jpg`
        status = `Out of Stock` quantity = `17` uom = `PC` currency_code = `EUR` price = 2299 width = `33` depth = `23` height = `2` dim_unit = `cm` )
      ( product_id = `HT-1251` category = `Laptops` main_category = `Computer Systems` tax_tarif_code = `1` supplier_name = `Ultrasonic United` weight_measure = `4.2` weight_unit = `KG`
        description = `Flexible Laptop with 2,5 GHz Quad Core, 15" HD TN, 16 GB DDR SDRAM, 256 GB SSD, Windows 10 Pro` name = `Astro Laptop 1516`
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1251.jpg`
        status = `Available` quantity = `23` uom = `PC` currency_code = `EUR` price = 989 width = `30` depth = `18` height = `3` dim_unit = `cm` )
      ( product_id = `HT-1253` category = `Laptops` main_category = `Computer Systems` tax_tarif_code = `1` supplier_name = `Ultrasonic United` weight_measure = `4.2` weight_unit = `KG`
        description = `Flexible Laptop with 2,5 GHz Dual Core, 14" HD+ TN, 8 GB DDR SDRAM, 324 GB SSD, Windows 10 Pro` name = `Benda Laptop 1408`
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1253.jpg`
        status = `Discontinued` quantity = `27` uom = `PC` currency_code = `EUR` price = 976 width = `30` depth = `18` height = `3` dim_unit = `cm` )
      ( product_id = `HT-8000` category = `Laptops` main_category = `Computer Systems` tax_tarif_code = `1` supplier_name = `Titanium` weight_measure = `4` weight_unit = `KG`
        description = `Notebook with 2,80 GHz dual core, 4 GB DDR3 SDRAM, 500 GB Hard Disc, Windows 8` name = `ITelO FlexTop I4000`
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8000.jpg`
        status = `Available` quantity = `11` uom = `PC` currency_code = `EUR` price = 799 width = `31` depth = `19` height = `3.1` dim_unit = `cm` )
      ( product_id = `HT-8001` category = `Laptops` main_category = `Computer Systems` tax_tarif_code = `1` supplier_name = `Titanium` weight_measure = `4.2` weight_unit = `KG`
        description = `Notebook with 2,80 GHz dual core, 8 GB DDR3 SDRAM, 500 GB Hard Disc, Windows 8` name = `ITelO FlexTop I6300c`
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8001.jpg`
        status = `Discontinued` quantity = `20` uom = `PC` currency_code = `EUR` price = 799 width = `32` depth = `20` height = `3.4` dim_unit = `cm` )
      ( product_id = `HT-8002` category = `Laptops` main_category = `Computer Systems` tax_tarif_code = `1` supplier_name = `Titanium` weight_measure = `3.5` weight_unit = `KG`
        description = `Notebook with 2,80 GHz quad core, 4 GB DDR3 SDRAM, 1000 GB Hard Disc, Windows 8` name = `ITelO FlexTop I9100`
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8002.jpg`
        status = `Available` quantity = `20` uom = `PC` currency_code = `EUR` price = 1199 width = `38` depth = `21` height = `4.1` dim_unit = `cm` )
      ( product_id = `HT-8003` category = `Laptops` main_category = `Computer Systems` tax_tarif_code = `1` supplier_name = `Titanium` weight_measure = `3.8` weight_unit = `KG`
        description = `Notebook with 2,80 GHz quad core, 8 GB DDR3 SDRAM, 1000 GB Hard Disc, Windows 8` name = `ITelO FlexTop I9800`
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8003.jpg`
        status = `Available` quantity = `22` uom = `PC` currency_code = `EUR` price = 1388 width = `48` depth = `31` height = `4.5` dim_unit = `cm` ) ).

    " explicit UI5 default of CarouselLayout.visiblePagesCount (the original's settings> model is empty until the route matches)
    pages_count = 1.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " the sample's App/Main/Comparison views merged into one view: the App hosts both pages, the router's navTo becomes a NavContainer `to` frontend action
    view->open( n = `View` ns = `mvc`
        )->a( n = `height`      v = `100%`
        )->a( n = `xmlns`       v = `sap.m`
        )->a( n = `xmlns:mvc`   v = `sap.ui.core.mvc`
        )->a( n = `xmlns:f`     v = `sap.f`
        )->a( n = `xmlns:cards` v = `sap.f.cards`
        )->a( n = `xmlns:l`     v = `sap.ui.layout`

        )->open( `App`
            )->a( n = `id` v = `rootControl`

            )->open( `Page`
                )->a( n = `title` v = `First Page`

                )->open( `content`
                    )->open( `Table`
                        )->a( n = `id`              v = `idProductsTable`
                        )->a( n = `selectionChange` v = client->_event( `SELECTION` )
                        )->a( n = `mode`            v = `MultiSelect`
                        )->a( n = `inset`           v = `false`
                        )->a( n = `items`           v = |\{ path: '{ client->_bind( val = t_products path = abap_true ) }', sorter: \{ path: 'NAME' \} \}|

                        )->open( `headerToolbar`
                            )->open( `Toolbar`
                                )->leaf( `Title`
                                    )->a( n = `text`  v = `Laptops`
                                    )->a( n = `level` v = `H2`
                                )->leaf( `ToolbarSpacer`
                                " the controller's setText/setVisible on selection replaced by bound model properties
                                )->leaf( `Button`
                                    )->a( n = `id`      v = `compareBtn`
                                    )->a( n = `text`    v = client->_bind( compare_text )
                                    )->a( n = `visible` v = client->_bind( compare_visible )
                                    )->a( n = `press`   v = client->_event( `COMPARE` )

                            )->shut(
                        )->shut(
                        )->open( `columns`
                            )->open( `Column`
                                )->leaf( `Text`
                                    )->a( n = `text` v = `Product`

                            )->shut(
                            )->open( `Column`
                                )->a( n = `hAlign`         v = `Center`
                                )->a( n = `width`          v = `12em`
                                )->a( n = `minScreenWidth` v = `Tablet`
                                )->a( n = `demandPopin`    v = `true`

                                )->leaf( `Text`
                                    )->a( n = `text` v = `Quantity`

                            )->shut(
                            )->open( `Column`
                                )->a( n = `minScreenWidth` v = `Tablet`
                                )->a( n = `demandPopin`    v = `true`
                                )->a( n = `hAlign`         v = `Center`

                                )->leaf( `Text`
                                    )->a( n = `text` v = `Weight`

                            )->shut(
                            )->open( `Column`
                                )->a( n = `hAlign` v = `End`

                                )->leaf( `Text`
                                    )->a( n = `text` v = `Unit Price`

                            )->shut(
                        )->shut(
                        )->open( `items`
                            " selected two-way binding added to read the multi-selection in the SELECTION handler (getSelectedContextPaths equivalent)
                            )->open( `ColumnListItem`
                                )->a( n = `vAlign`   v = `Middle`
                                )->a( n = `type`     v = `Inactive`
                                )->a( n = `selected` v = `{SELECTED}`

                                )->open( `cells`
                                    )->leaf( `ObjectIdentifier`
                                        )->a( n = `title` v = `{NAME}`
                                        )->a( n = `text`  v = `{PRODUCT_ID}`
                                    )->leaf( `Input`
                                        )->a( n = `value`       v = `{QUANTITY}`
                                        )->a( n = `type`        v = `{Text}`
                                        )->a( n = `description` v = `{UOM}`
                                        )->a( n = `fieldWidth`  v = `{60%}`
                                    )->leaf( `ObjectNumber`
                                        )->a( n = `number` v = `{WEIGHT_MEASURE}`
                                        )->a( n = `unit`   v = `{WEIGHT_UNIT}`
                                    )->leaf( `ObjectNumber`
                                        )->a( n = `number` v = |\{ parts:[\{path:'PRICE'\},\{path:'CURRENCY_CODE'\}], type: 'sap.ui.model.type.Currency', formatOptions: \{showMeasure: false\} \}|
                                        )->a( n = `unit`   v = `{CURRENCY_CODE}`

                                )->shut(
                            )->shut(
                        )->shut(
                    )->shut(
                )->shut(
            )->shut(
            )->open( n = `DynamicPage` ns = `f`
                )->a( n = `id`    v = `page-comparison`
                )->a( n = `class` v = `sapUiComparisonContainer`

                )->open( n = `title` ns = `f`
                    " the original's stateChange handler (add/removeSnappedContent Carousel animation workaround) is dropped - imperative aggregation surgery
                    )->open( n = `DynamicPageTitle` ns = `f`
                        )->a( n = `id`               v = `dynamic-page`
                        )->a( n = `backgroundDesign` v = `Transparent`

                        )->open( n = `heading` ns = `f`
                            )->leaf( `Title`
                                )->a( n = `text` v = `Second Page`

                        )->shut(
                        )->open( n = `snappedContent` ns = `f`
                            )->open( `Carousel`
                                )->a( n = `height`                 v = `auto`
                                )->a( n = `class`                  v = `sapUiSmallMarginBottom`
                                )->a( n = `id`                     v = `carousel-snapped`
                                )->a( n = `pageChanged`            v = client->_event( val   = `PAGE_CHANGED`
                                                                                       t_arg = VALUE #( ( `${$parameters>/activePages/0}` ) ) )
                                )->a( n = `pageIndicatorPlacement` v = `Top`
                                )->a( n = `showPageIndicator`      v = |\{= !${ client->_bind( is_desktop ) } \}|
                                )->a( n = `pages`                  v = client->_bind( t_comp_products )

                                )->open( `customLayout`
                                    )->leaf( `CarouselLayout`
                                        )->a( n = `visiblePagesCount` v = client->_bind( pages_count )

                                )->shut(
                                )->open( n = `Card` ns = `f`
                                    )->a( n = `class` v = `sapUiTinyMarginTop`

                                    )->open( n = `header` ns = `f`
                                        " iconSrc formatter .formatter.url flattened to absolute image URLs in the model
                                        )->leaf( n = `Header` ns = `cards`
                                            )->a( n = `title`            v = `{NAME}`
                                            )->a( n = `subtitle`         v = `{STATUS}`
                                            )->a( n = `iconSrc`          v = `{PRODUCT_PIC_URL}`
                                            )->a( n = `iconDisplayShape` v = `Square`

                                    )->shut(
                                )->shut(
                            )->shut(
                        )->shut(
                    )->shut(
                )->shut(
                )->open( n = `header` ns = `f`
                    )->open( n = `DynamicPageHeader` ns = `f`
                        )->a( n = `backgroundDesign` v = `Transparent`

                        )->open( `Carousel`
                            )->a( n = `height`                 v = `auto`
                            )->a( n = `class`                  v = `sapUiSmallMarginBottom`
                            )->a( n = `id`                     v = `carousel-expanded`
                            )->a( n = `pageChanged`            v = client->_event( val   = `PAGE_CHANGED`
                                                                                   t_arg = VALUE #( ( `${$parameters>/activePages/0}` ) ) )
                            )->a( n = `pageIndicatorPlacement` v = `Top`
                            )->a( n = `showPageIndicator`      v = |\{= !${ client->_bind( is_desktop ) } \}|
                            )->a( n = `pages`                  v = client->_bind( t_comp_products )

                            )->open( `customLayout`
                                )->leaf( `CarouselLayout`
                                    )->a( n = `visiblePagesCount` v = client->_bind( pages_count )

                            )->shut(
                            )->open( n = `Card` ns = `f`
                                )->a( n = `class` v = `sapUiTinyMarginTop`

                                )->open( n = `header` ns = `f`
                                    )->leaf( n = `Header` ns = `cards`
                                        )->a( n = `title`            v = `{NAME}`
                                        )->a( n = `subtitle`         v = `{STATUS}`
                                        )->a( n = `iconSrc`          v = `{PRODUCT_PIC_URL}`
                                        )->a( n = `iconDisplayShape` v = `Square`

                                )->shut(
                                )->open( n = `content` ns = `f`
                                    )->open( n = `VerticalLayout` ns = `l`
                                        )->a( n = `width` v = `100%`

                                        )->open( n = `BlockLayout` ns = `l`
                                            )->open( n = `BlockLayoutRow` ns = `l`
                                                )->open( n = `BlockLayoutCell` ns = `l`
                                                    )->open( `HBox`
                                                        )->leaf( `Label`
                                                            )->a( n = `text` v = `Supplier:`

                                                    )->shut(
                                                    )->open( `HBox`
                                                        )->a( n = `class` v = `sapUiSmallMarginBottom`

                                                        )->leaf( `Text`
                                                            )->a( n = `text` v = `{SUPPLIER_NAME}`

                                                    )->shut(
                                                    )->open( `HBox`
                                                        )->leaf( `Label`
                                                            )->a( n = `text` v = `Main Category:`

                                                    )->shut(
                                                    )->open( `HBox`
                                                        )->a( n = `class` v = `sapUiSmallMarginBottom`

                                                        )->leaf( `Text`
                                                            )->a( n = `text` v = `{MAIN_CATEGORY}`

                                                    )->shut(
                                                    )->open( `HBox`
                                                        )->leaf( `Label`
                                                            )->a( n = `text` v = `Category:`

                                                    )->shut(
                                                    )->open( `HBox`
                                                        )->a( n = `class` v = `sapUiSmallMarginBottom`

                                                        )->leaf( `Text`
                                                            )->a( n = `text` v = `{CATEGORY}`

                                                    )->shut(
                                                )->shut(
                                                )->open( n = `BlockLayoutCell` ns = `l`
                                                    )->open( `HBox`
                                                        )->leaf( `Label`
                                                            )->a( n = `text` v = `Width (cm)`

                                                    )->shut(
                                                    )->open( `HBox`
                                                        )->a( n = `class` v = `sapUiSmallMarginBottom`

                                                        )->leaf( `Text`
                                                            )->a( n = `text` v = `{WIDTH}`

                                                    )->shut(
                                                    )->open( `HBox`
                                                        )->leaf( `Label`
                                                            )->a( n = `text` v = `Height (cm)`

                                                    )->shut(
                                                    )->open( `HBox`
                                                        )->a( n = `class` v = `sapUiSmallMarginBottom`

                                                        )->leaf( `Text`
                                                            )->a( n = `text` v = `{HEIGHT}`

                                                    )->shut(
                                                    )->open( `HBox`
                                                        )->leaf( `Label`
                                                            )->a( n = `text` v = `Weight (kg)`

                                                    )->shut(
                                                    )->open( `HBox`
                                                        )->a( n = `class` v = `sapUiSmallMarginBottom`

                                                        )->leaf( `Text`
                                                            )->a( n = `text` v = `{WEIGHT_MEASURE}`

                                                    )->shut(
                                                )->shut(
                                            )->shut(
                                        )->shut(
                                    )->shut(
                                )->shut(
                            )->shut(
                        )->shut(
                    )->shut(
                )->shut(
                )->open( n = `content` ns = `f`
                    )->open( `List`
                        )->a( n = `id`               v = `listItems`
                        )->a( n = `backgroundDesign` v = `Transparent`
                        )->a( n = `class`            v = `sapUiSmallMarginBottom`
                        )->a( n = `items`            v = client->_bind( t_comp_props )

                        )->open( `items`
                            )->open( `CustomListItem`
                                )->a( n = `class` v = `sapUiComparisonContent`

                                )->leaf( `Panel`
                                    )->a( n = `expandable` v = `true`
                                    )->a( n = `expanded`   v = `false`
                                    )->a( n = `headerText` v = `{KEY}`
                                    )->a( n = `height`     v = `2.75rem`
                                    )->a( n = `expand`     v = client->_event( val   = `PANEL_EXPANDED`
                                                                               t_arg = VALUE #( ( `${KEY}` ) ( `${$parameters>/expand}` ) ) )

                                )->open( `HBox`
                                    )->a( n = `class`            v = `sapUiTinyMarginTop`
                                    )->a( n = `alignItems`       v = `Start`
                                    )->a( n = `backgroundDesign` v = `Solid`
                                    )->a( n = `items`            v = |\{ path: 'VALUES', templateShareable : true \}|

                                    )->open( `items`
                                        )->open( `VBox`
                                            )->a( n = `class` v = `sapUiTinyMarginTopBottom sapUiComparisonItem`

                                            )->open( `layoutData`
                                                )->leaf( `FlexItemData`
                                                    )->a( n = `growFactor` v = `1`
                                                    )->a( n = `baseSize`   v = `0`

                                            )->shut(
                                            )->open( `HBox`
                                                )->leaf( `FormattedText`
                                                    )->a( n = `htmlText` v = `{TEXT}`

                                            )->shut(
                                            " the controller's onPanelExpanded setVisible replaced by the bound VISIBLE flag per value row
                                            )->open( `HBox`
                                                )->a( n = `class`   v = `sapUiSmallMarginTop`
                                                )->a( n = `visible` v = `{VISIBLE}`

                                                )->leaf( `Text`
                                                    )->a( n = `text` v = `{DESCRIPTION}`

                                            )->shut(
                                        )->shut(
                                    )->shut(
                                )->shut(
                            )->shut(
                        )->shut(
                    )->shut(
                )->shut(
            )->shut(
        )->shut( ).

    " the original controller's onAfterRendering binding filter: only Laptops are compared
    client->follow_up_action( val   = client->cs_event-binding_call
                              t_arg = VALUE #( ( `idProductsTable` ) ( `items` ) ( `filter` ) ( `CATEGORY` ) ( `EQ` ) ( `Laptops` ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `SELECTION`.
        DATA(selected_count) = 0.
        LOOP AT t_products TRANSPORTING NO FIELDS WHERE selected = abap_true.
          selected_count = selected_count + 1.
        ENDLOOP.
        IF selected_count > 1.
          compare_text    = |Compare ({ selected_count })|.
          compare_visible = abap_true.
        ELSE.
          compare_visible = abap_false.
        ENDIF.
        client->view_model_update( ).

      WHEN `COMPARE`.
        comparison_build( ).
        " the router's navTo("page2") mapped to the NavContainer `to` frontend action
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( `rootControl` ) ( `` ) ( `to` ) ( `page-comparison` ) ) ).
        client->view_model_update( ).

      WHEN `PAGE_CHANGED`.
        DATA(page_arg) = client->get_event_arg( ).
        IF page_arg CO `0123456789`.
          first_item = page_arg.
        ELSE.
          first_item = 0.
        ENDIF.
        comparison_props_build( ).
        client->view_model_update( ).

      WHEN `PANEL_EXPANDED`.
        DATA(prop_key) = client->get_event_arg( ).
        DATA(expanded) = client->get_event_arg( 2 ).
        READ TABLE t_comp_props ASSIGNING FIELD-SYMBOL(<s_prop>) WITH KEY key = prop_key.
        IF sy-subrc = 0.
          LOOP AT <s_prop>-values ASSIGNING FIELD-SYMBOL(<s_value>).
            <s_value>-visible = expanded.
          ENDLOOP.
          client->view_model_update( ).
        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD comparison_build.

    t_comp_products = VALUE #( ).
    LOOP AT t_products INTO DATA(s_product) WHERE selected = abap_true.
      APPEND s_product TO t_comp_products.
    ENDLOOP.

    " the original's ResizeHandler-driven _getPagesCount (600/1024 thresholds), computed once from the reported device width
    DATA(width) = client->get( )-s_device-resize-width.
    IF width > 0 AND width <= 600.
      pages_count = 1.
    ELSEIF width > 0 AND width <= 1024.
      pages_count = 2.
    ELSE.
      pages_count = 4.
    ENDIF.
    IF pages_count > lines( t_comp_products ).
      pages_count = lines( t_comp_products ).
    ENDIF.
    IF pages_count = 4.
      is_desktop = abap_true.
    ELSE.
      is_desktop = abap_false.
    ENDIF.

    first_item = 0.
    comparison_props_build( ).

  ENDMETHOD.


  METHOD comparison_props_build.

    " the original iterates the first selected product's JSON keys (except ProductPicUrl); here the same keys as a fixed list
    DATA(t_keys) = VALUE ty_t_key(
      ( key = `ProductId` field = `PRODUCT_ID` )
      ( key = `Category` field = `CATEGORY` )
      ( key = `MainCategory` field = `MAIN_CATEGORY` )
      ( key = `TaxTarifCode` field = `TAX_TARIF_CODE` )
      ( key = `SupplierName` field = `SUPPLIER_NAME` )
      ( key = `WeightMeasure` field = `WEIGHT_MEASURE` )
      ( key = `WeightUnit` field = `WEIGHT_UNIT` )
      ( key = `Description` field = `DESCRIPTION` )
      ( key = `Name` field = `NAME` )
      ( key = `DateOfSale` field = `DATE_OF_SALE` )
      ( key = `Status` field = `STATUS` )
      ( key = `Quantity` field = `QUANTITY` )
      ( key = `UoM` field = `UOM` )
      ( key = `CurrencyCode` field = `CURRENCY_CODE` )
      ( key = `Price` field = `PRICE` )
      ( key = `Width` field = `WIDTH` )
      ( key = `Depth` field = `DEPTH` )
      ( key = `Height` field = `HEIGHT` )
      ( key = `DimUnit` field = `DIM_UNIT` ) ).

    DATA(from_item) = first_item + 1.
    DATA(last_item) = first_item + pages_count.
    IF last_item > lines( t_comp_products ).
      last_item = lines( t_comp_products ).
    ENDIF.

    t_comp_props = VALUE #( ).
    LOOP AT t_keys INTO DATA(s_key).
      DATA(s_prop) = VALUE ty_s_comp_prop( key = s_key-key ).
      LOOP AT t_comp_products FROM from_item TO last_item INTO DATA(s_product).
        ASSIGN COMPONENT s_key-field OF STRUCTURE s_product TO FIELD-SYMBOL(<value>).
        IF sy-subrc = 0.
          APPEND VALUE #( text        = |<strong>{ <value> }</strong>|
                          description = `Some description of the property here`
                          visible     = abap_false ) TO s_prop-values.
        ENDIF.
      ENDLOOP.
      APPEND s_prop TO t_comp_props.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
