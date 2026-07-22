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
        price           TYPE p LENGTH 8 DECIMALS 2,
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

    METHODS view_display.
    METHODS on_event.
    METHODS comparison_build.
    METHODS comparison_props_build.
    METHODS model_init.

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
                                  t_arg = VALUE #( ( `rootControl` ) ( `to` ) ( `page-comparison` ) ) ).
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


  METHOD model_init.

    " the full mock /ProductCollection (sap/ui/demo/mock/products.json); the table binding filters to Category = Laptops (onAfterRendering), as the original loads all rows and filters client-side
    " ProductPicUrl resolved to absolute OpenUI5 URLs (the sample's .formatter.url)
    t_products = VALUE #(
      ( product_id = `HT-1000` category = `Laptops` main_category = `Computer Systems` tax_tarif_code = `1` supplier_name = `Very Best Screens` weight_measure = `4.2` weight_unit = `KG`
        description = `Notebook Basic 15 with 2,80 GHz quad core, 15" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro` name = `Notebook Basic 15` date_of_sale = `2017-03-26`
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg`
        status = `Available` quantity = `10` uom = `PC` currency_code = `EUR` price = `956.00` width = `30` depth = `18` height = `3` dim_unit = `cm` )
      ( product_id = `HT-1001` category = `Laptops` main_category = `Computer Systems` tax_tarif_code = `1` supplier_name = `Very Best Screens` weight_measure = `4.5` weight_unit = `KG`
        description = `Notebook Basic 17 with 2,80 GHz quad core, 17" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro` name = `Notebook Basic 17` date_of_sale = `2017-04-17`
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1001.jpg`
        status = `Available` quantity = `20` uom = `PC` currency_code = `EUR` price = `1249.00` width = `29` depth = `17` height = `3.1` dim_unit = `cm` )
      ( product_id = `HT-1002` category = `Laptops` main_category = `Computer Systems` tax_tarif_code = `1` supplier_name = `Very Best Screens` weight_measure = `4.2` weight_unit = `KG`
        description = `Notebook Basic 18 with 2,80 GHz quad core, 18" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro` name = `Notebook Basic 18` date_of_sale = `2017-01-07`
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1002.jpg`
        status = `Available` quantity = `10` uom = `PC` currency_code = `EUR` price = `1570.00` width = `28` depth = `19` height = `2.5` dim_unit = `cm` )
      ( product_id = `HT-1003` category = `Laptops` main_category = `Computer Systems` tax_tarif_code = `1` supplier_name = `Smartcards` weight_measure = `4.2` weight_unit = `KG`
        description = `Notebook Basic 19 with 2,80 GHz quad core, 19" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro` name = `Notebook Basic 19` date_of_sale = `2017-04-09`
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1003.jpg`
        status = `Out of Stock` quantity = `15` uom = `PC` currency_code = `EUR` price = `1650.00` width = `32` depth = `21` height = `4` dim_unit = `cm` )
      ( product_id = `HT-1007` category = `Accessories` main_category = `Computer Components` tax_tarif_code = `1` supplier_name = `Technocom` weight_measure = `0.2` weight_unit = `KG`
        description = `Digital Organizer with State-of-the-Art Storage Encryption` name = `ITelO Vault` date_of_sale = `2017-05-17`
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1007.jpg`
        status = `Out of Stock` quantity = `15` uom = `PC` currency_code = `EUR` price = `299.00` width = `32` depth = `22` height = `3` dim_unit = `cm` )
      ( product_id = `HT-1010` category = `Accessories` main_category = `Computer Systems` tax_tarif_code = `1` supplier_name = `Very Best Screens` weight_measure = `4.3` weight_unit = `KG`
        description = `Notebook Professional 15 with 2,80 GHz quad core, 15" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro` name = `Notebook Professional 15` date_of_sale = `2017-02-22`
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg`
        status = `Out of Stock` quantity = `16` uom = `PC` currency_code = `EUR` price = `1999.00` width = `33` depth = `20` height = `3` dim_unit = `cm` )
      ( product_id = `HT-1011` category = `Laptops` main_category = `Computer Systems` tax_tarif_code = `1` supplier_name = `Very Best Screens` weight_measure = `4.1` weight_unit = `KG`
        description = `Notebook Professional 17 with 2,80 GHz quad core, 17" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro` name = `Notebook Professional 17` date_of_sale = `2017-01-02`
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1011.jpg`
        status = `Out of Stock` quantity = `17` uom = `PC` currency_code = `EUR` price = `2299.00` width = `33` depth = `23` height = `2` dim_unit = `cm` )
      ( product_id = `HT-1020` category = `Accessories` main_category = `Computer Components` tax_tarif_code = `1` supplier_name = `Technocom` weight_measure = `0.16` weight_unit = `KG`
        description = `Digital Organizer with State-of-the-Art Encryption for Storage and Network Communications` name = `ITelO Vault Net` date_of_sale = `2017-05-08`
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1020.jpg`
        status = `Discontinued` quantity = `14` uom = `PC` currency_code = `EUR` price = `459.00` width = `10` depth = `1.8` height = `17` dim_unit = `cm` )
      ( product_id = `HT-1021` category = `Accessories` main_category = `Computer Components` tax_tarif_code = `1` supplier_name = `Technocom` weight_measure = `0.18` weight_unit = `KG`
        description = `Digital Organizer with State-of-the-Art Encryption for Storage and Secure Stellite Link` name = `ITelO Vault SAT` date_of_sale = `2017-06-30`
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1021.jpg`
        status = `Available` quantity = `50` uom = `PC` currency_code = `EUR` price = `149.00` width = `11` depth = `1.7` height = `18` dim_unit = `cm` )
      ( product_id = `HT-1022` category = `Accessories` main_category = `Computer Components` tax_tarif_code = `1` supplier_name = `Technocom` weight_measure = `0.2` weight_unit = `KG`
        description = `32 GB Digital Assistant with high-resolution color screen` name = `Comfort Easy` date_of_sale = `2017-03-02`
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1022.jpg`
        status = `Out of Stock` quantity = `30` uom = `PC` currency_code = `EUR` price = `1679.00` width = `84` depth = `1.5` height = `14` dim_unit = `cm` )
      ( product_id = `HT-1023` category = `Accessories` main_category = `Computer Components` tax_tarif_code = `1` supplier_name = `Technocom` weight_measure = `0.8` weight_unit = `KG`
        description = `64 GB Digital Assistant with high-resolution color screen and synthesized voice output` name = `Comfort Senior` date_of_sale = `2017-02-25`
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1023.jpg`
        status = `Available` quantity = `24` uom = `PC` currency_code = `EUR` price = `512.00` width = `80` depth = `1.6` height = `13` dim_unit = `cm` )
      ( product_id = `HT-1030` category = `Flat Screen Monitors` main_category = `Computer Components` tax_tarif_code = `1` supplier_name = `Very Best Screens` weight_measure = `21` weight_unit = `KG`
        description = `Optimum Hi-Resolution max. 1920 x 1080 @ 85Hz, Dot Pitch: 0.27mm` name = `Ergo Screen E-I` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1030.jpg`
        status = `Available` quantity = `14` uom = `PC` currency_code = `EUR` price = `230.00` width = `37` depth = `12` height = `36` dim_unit = `cm` )
      ( product_id = `HT-1031` category = `Flat Screen Monitors` main_category = `Computer Components` tax_tarif_code = `1` supplier_name = `Very Best Screens` weight_measure = `21` weight_unit = `KG`
        description = `Optimum Hi-Resolution max. 1920 x 1200 @ 85Hz, Dot Pitch: 0.26mm` name = `Ergo Screen E-II` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1031.jpg`
        status = `Available` quantity = `24` uom = `PC` currency_code = `EUR` price = `285.00` width = `40.8` depth = `19` height = `43` dim_unit = `cm` )
      ( product_id = `HT-1032` category = `Flat Screen Monitors` main_category = `Computer Components` tax_tarif_code = `1` supplier_name = `Very Best Screens` weight_measure = `21` weight_unit = `KG`
        description = `Optimum Hi-Resolution max. 2560 x 1440 @ 85Hz, Dot Pitch: 0.25mm` name = `Ergo Screen E-III` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1032.jpg`
        status = `Out of Stock` quantity = `50` uom = `PC` currency_code = `EUR` price = `345.00` width = `40.8` depth = `19` height = `43` dim_unit = `cm` )
      ( product_id = `HT-1035` category = `Flat Screen Monitors` main_category = `Computer Components` tax_tarif_code = `1` supplier_name = `Very Best Screens` weight_measure = `14` weight_unit = `KG`
        description = `Optimum Hi-Resolution max. 1600 x 1200 @ 85Hz, Dot Pitch: 0.24mm` name = `Flat Basic` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1035.jpg`
        status = `Available` quantity = `23` uom = `PC` currency_code = `EUR` price = `399.00` width = `39` depth = `20` height = `41` dim_unit = `cm` )
      ( product_id = `HT-1036` category = `Flat Screen Monitors` main_category = `Computer Components` tax_tarif_code = `1` supplier_name = `Very Best Screens` weight_measure = `15` weight_unit = `KG`
        description = `Optimum Hi-Resolution max. 2048 x 1080 @ 85Hz, Dot Pitch: 0.26mm` name = `Flat Future` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1036.jpg`
        status = `Available` quantity = `22` uom = `PC` currency_code = `EUR` price = `430.00` width = `45` depth = `26` height = `46` dim_unit = `cm` )
      ( product_id = `HT-1037` category = `Flat Screen Monitors` main_category = `Computer Components` tax_tarif_code = `1` supplier_name = `Very Best Screens` weight_measure = `17` weight_unit = `KG`
        description = `Optimum Hi-Resolution max. 2016 x 1512 @ 85Hz, Dot Pitch: 0.24mm` name = `Flat XL` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1037.jpg`
        status = `Available` quantity = `23` uom = `PC` currency_code = `EUR` price = `1230.00` width = `54.5` depth = `22.1` height = `39.1` dim_unit = `cm` )
      ( product_id = `HT-1040` category = `Printers` main_category = `Printers & Scanners` tax_tarif_code = `1` supplier_name = `Alpha Printers` weight_measure = `32` weight_unit = `KG`
        description = `Print 2400 dpi image quality color documents at speeds of up to 32 ppm (color) or 36 ppm (monochrome), letter/A4. Powerful 500 MHz processor, 512MB of memory` name = `Laser Professional Eco` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1040.jpg`
        status = `Available` quantity = `21` uom = `PC` currency_code = `EUR` price = `830.00` width = `51` depth = `46` height = `30` dim_unit = `cm` )
      ( product_id = `HT-1041` category = `Printers` main_category = `Printers & Scanners` tax_tarif_code = `1` supplier_name = `Alpha Printers` weight_measure = `23` weight_unit = `KG`
        description = `Up to 22 ppm color or 24 ppm monochrome A4/letter, powerful 500 MHz processor and 128MB of memory` name = `Laser Basic` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1041.jpg`
        status = `Available` quantity = `8` uom = `PC` currency_code = `EUR` price = `490.00` width = `48` depth = `42` height = `26` dim_unit = `cm` )
      ( product_id = `HT-1042` category = `Printers` main_category = `Printers & Scanners` tax_tarif_code = `1` supplier_name = `Alpha Printers` weight_measure = `17` weight_unit = `KG`
        description = `Print up to 25 ppm letter and 24 ppm A4 color or monochrome, with Available first-page-out-time of less than 13 seconds for monochrome and less than 15 seconds for color` name = `Laser Allround` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1042.jpg`
        status = `Available` quantity = `9` uom = `PC` currency_code = `EUR` price = `349.00` width = `53` depth = `50` height = `65` dim_unit = `cm` )
      ( product_id = `HT-1050` category = `Printers` main_category = `Printers & Scanners` tax_tarif_code = `1` supplier_name = `Alpha Printers` weight_measure = `3` weight_unit = `KG`
        description = `4800 dpi x 1200 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB, Ethernet` name = `Ultra Jet Super Color` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1050.jpg`
        status = `Discontinued` quantity = `17` uom = `PC` currency_code = `EUR` price = `139.00` width = `41` depth = `41` height = `28` dim_unit = `cm` )
      ( product_id = `HT-1051` category = `Printers` main_category = `Printers & Scanners` tax_tarif_code = `1` supplier_name = `Printer for All` weight_measure = `1.9` weight_unit = `KG`
        description = `1000 dpi x 1000 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB - excellent dimensions for the small office` name = `Ultra Jet Mobile` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1051.jpg`
        status = `Discontinued` quantity = `18` uom = `PC` currency_code = `EUR` price = `99.00` width = `46` depth = `32` height = `25` dim_unit = `cm` )
      ( product_id = `HT-1052` category = `Printers` main_category = `Printers & Scanners` tax_tarif_code = `1` supplier_name = `Printer for All` weight_measure = `18` weight_unit = `KG`
        description = `4800 dpi x 1200 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB2.0, Ethernet` name = `Ultra Jet Super Highspeed` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1052.jpg`
        status = `Available` quantity = `25` uom = `PC` currency_code = `EUR` price = `170.00` width = `41` depth = `41` height = `28` dim_unit = `cm` )
      ( product_id = `HT-1055` category = `Multifunction Printers` main_category = `Printers & Scanners` tax_tarif_code = `1` supplier_name = `Printer for All` weight_measure = `6.3` weight_unit = `KG`
        description = `1000 dpi x 1000 dpi - up to 16 ppm (mono) / up to 15 ppm (color)- capacity 80 sheets - scanner (216 x 297 mm, 1200dpi x 2400dpi)` name = `Multi Print` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1055.jpg`
        status = `Available` quantity = `16` uom = `PC` currency_code = `EUR` price = `99.00` width = `55` depth = `45` height = `29` dim_unit = `cm` )
      ( product_id = `HT-1056` category = `Multifunction Printers` main_category = `Printers & Scanners` tax_tarif_code = `1` supplier_name = `Printer for All` weight_measure = `4.3` weight_unit = `KG`
        description = `1200 dpi x 1200 dpi - up to 25 ppm (mono) / up to 24 ppm (color)- capacity 80 sheets - scanner (216 x 297 mm, 2400dpi x 4800dpi, high resolution)` name = `Multi Color` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1056.jpg`
        status = `Available` quantity = `5` uom = `PC` currency_code = `EUR` price = `119.00` width = `51` depth = `41.3` height = `22` dim_unit = `cm` )
      ( product_id = `HT-1060` category = `Mice` main_category = `Computer Components` tax_tarif_code = `1` supplier_name = `Oxynum` weight_measure = `0.09` weight_unit = `KG`
        description = `Cordless Optical USB Mice, Laptop, Color: Black, Plug&Play` name = `Cordless Mouse` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1060.jpg`
        status = `Available` quantity = `25` uom = `PC` currency_code = `EUR` price = `9.00` width = `6` depth = `14.5` height = `3.5` dim_unit = `cm` )
      ( product_id = `HT-1061` category = `Mice` main_category = `Computer Components` tax_tarif_code = `1` supplier_name = `Oxynum` weight_measure = `0.09` weight_unit = `KG`
        description = `Optical USB, PS/2 Mouse, Color: Blue, 3-button-functionality (incl. Scroll wheel)` name = `Speed Mouse` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1061.jpg`
        status = `Available` quantity = `12` uom = `PC` currency_code = `EUR` price = `7.00` width = `7` depth = `15` height = `3.1` dim_unit = `cm` )
      ( product_id = `HT-1062` category = `Mice` main_category = `Computer Components` tax_tarif_code = `1` supplier_name = `Oxynum` weight_measure = `0.03` weight_unit = `KG`
        description = `Optical USB Mouse, Color: Red, 5-button-functionality(incl. Scroll wheel), Plug&Play` name = `Track Mouse` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1062.jpg`
        status = `Discontinued` quantity = `12` uom = `PC` currency_code = `EUR` price = `11.00` width = `3` depth = `7` height = `4` dim_unit = `cm` )
      ( product_id = `HT-1063` category = `Keyboards` main_category = `Computer Components` tax_tarif_code = `1` supplier_name = `Oxynum` weight_measure = `2.1` weight_unit = `KG`
        description = `Ergonomic USB Keyboard for Desktop, Plug&Play` name = `Ergonomic Keyboard` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1063.jpg`
        status = `Available` quantity = `50` uom = `PC` currency_code = `EUR` price = `14.00` width = `50` depth = `21` height = `3.5` dim_unit = `cm` )
      ( product_id = `HT-1064` category = `Keyboards` main_category = `Computer Components` tax_tarif_code = `1` supplier_name = `Oxynum` weight_measure = `1.8` weight_unit = `KG`
        description = `Corded Keyboard with special keys for Internet Usability, USB` name = `Internet Keyboard` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1064.jpg`
        status = `Out of Stock` quantity = `35` uom = `PC` currency_code = `EUR` price = `16.00` width = `52` depth = `25` height = `3` dim_unit = `cm` )
      ( product_id = `HT-1065` category = `Keyboards` main_category = `Computer Components` tax_tarif_code = `1` supplier_name = `Oxynum` weight_measure = `2.3` weight_unit = `KG`
        description = `Corded Ergonomic Keyboard with special keys for Media Usability, USB` name = `Media Keyboard` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1065.jpg`
        status = `Available` quantity = `26` uom = `PC` currency_code = `EUR` price = `26.00` width = `51.4` depth = `23` height = `4` dim_unit = `cm` )
      ( product_id = `HT-1066` category = `Mousepads` main_category = `Computer Components` tax_tarif_code = `1` supplier_name = `Oxynum` weight_measure = `80` weight_unit = `G`
        description = `Nice mouse pad with ITelO Logo` name = `Mousepad` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1066.jpg`
        status = `Available` quantity = `12` uom = `PC` currency_code = `EUR` price = `6.99` width = `15` depth = `6` height = `0.2` dim_unit = `cm` )
      ( product_id = `HT-1067` category = `Mousepads` main_category = `Computer Components` tax_tarif_code = `1` supplier_name = `Oxynum` weight_measure = `80` weight_unit = `G`
        description = `Ergonomic mouse pad with ITelO Logo` name = `Ergo Mousepad` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1067.jpg`
        status = `Out of Stock` quantity = `16` uom = `PC` currency_code = `EUR` price = `8.99` width = `15` depth = `6` height = `0.2` dim_unit = `cm` )
      ( product_id = `HT-1068` category = `Mousepads` main_category = `Computer Components` tax_tarif_code = `1` supplier_name = `Fasttech` weight_measure = `90` weight_unit = `G`
        description = `ITelO Mousepad Special Edition` name = `Designer Mousepad` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1068.jpg`
        status = `Available` quantity = `26` uom = `PC` currency_code = `EUR` price = `12.99` width = `24` depth = `24` height = `0.6` dim_unit = `cm` )
      ( product_id = `HT-1069` category = `Computer System Accessories` main_category = `Computer Systems` tax_tarif_code = `1` supplier_name = `Fasttech` weight_measure = `45` weight_unit = `G`
        description = `Universal card reader` name = `Universal card reader` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1069.jpg`
        status = `Available` quantity = `22` uom = `PC` currency_code = `EUR` price = `14.00` width = `6` depth = `6` height = `3` dim_unit = `cm` )
      ( product_id = `HT-1070` category = `Graphic Cards` main_category = `Computer Components` tax_tarif_code = `1` supplier_name = `Ultrasonic United` weight_measure = `0.255` weight_unit = `KG`
        description = `Proctra X: PCI-E GDDR5 3072MB` name = `Proctra X` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1070.jpg`
        status = `Out of Stock` quantity = `15` uom = `PC` currency_code = `EUR` price = `70.90` width = `22` depth = `35` height = `17` dim_unit = `cm` )
      ( product_id = `HT-1071` category = `Graphic Cards` main_category = `Computer Components` tax_tarif_code = `1` supplier_name = `Ultrasonic United` weight_measure = `0.3` weight_unit = `KG`
        description = `Gladiator XLN: PCI-E GDDR5 3072MB DVI Out, TV Out low-noise` name = `Gladiator MX` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1071.jpg`
        status = `Discontinued` quantity = `16` uom = `PC` currency_code = `EUR` price = `81.70` width = `22` depth = `35` height = `17` dim_unit = `cm` )
      ( product_id = `HT-1072` category = `Graphic Cards` main_category = `Computer Components` tax_tarif_code = `1` supplier_name = `Ultrasonic United` weight_measure = `0.4` weight_unit = `KG`
        description = `Hurricane GX: PCI-E 691 GFLOPS game-optimized` name = `Hurricane GX` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1072.jpg`
        status = `Available` quantity = `13` uom = `PC` currency_code = `EUR` price = `101.20` width = `22` depth = `35` height = `17` dim_unit = `cm` )
      ( product_id = `HT-1073` category = `Graphic Cards` main_category = `Computer Components` tax_tarif_code = `1` supplier_name = `Smartcards` weight_measure = `0.4` weight_unit = `KG`
        description = `Hurricane GX/LN: PCI-E 691 GFLOPS game-optimized, low-noise.` name = `Hurricane GX/LN` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1073.jpg`
        status = `Out of Stock` quantity = `5` uom = `PC` currency_code = `EUR` price = `139.99` width = `22` depth = `35` height = `17` dim_unit = `cm` )
      ( product_id = `HT-1080` category = `Scanners` main_category = `Printers & Scanners` tax_tarif_code = `1` supplier_name = `Printer for All` weight_measure = `2.3` weight_unit = `KG`
        description = `Flatbed scanner - 9.600 × 9.600 dpi - 216 x 297 mm - Hi-Speed USB - Bluetooth` name = `Photo Scan` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1080.jpg`
        status = `Out of Stock` quantity = `8` uom = `PC` currency_code = `EUR` price = `129.00` width = `34` depth = `48` height = `5` dim_unit = `cm` )
      ( product_id = `HT-1081` category = `Scanners` main_category = `Printers & Scanners` tax_tarif_code = `1` supplier_name = `Printer for All` weight_measure = `2.4` weight_unit = `KG`
        description = `Flatbed scanner - 9.600 × 9.600 dpi - 216 x 297 mm - SCSI for backward compatibility` name = `Power Scan` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1081.jpg`
        status = `Out of Stock` quantity = `11` uom = `PC` currency_code = `EUR` price = `89.00` width = `31` depth = `43` height = `7` dim_unit = `cm` )
      ( product_id = `HT-1082` category = `Scanners` main_category = `Printers & Scanners` tax_tarif_code = `1` supplier_name = `Printer for All` weight_measure = `3.2` weight_unit = `KG`
        description = `Flatbed scanner - Letter - 2400 dpi x 2400 dpi - 216 x 297 mm - add-on module` name = `Jet Scan Professional` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1082.jpg`
        status = `Out of Stock` quantity = `13` uom = `PC` currency_code = `EUR` price = `169.00` width = `33` depth = `41` height = `12` dim_unit = `cm` )
      ( product_id = `HT-1083` category = `Scanners` main_category = `Printers & Scanners` tax_tarif_code = `1` supplier_name = `Printer for All` weight_measure = `3.2` weight_unit = `KG`
        description = `Flatbed scanner - A4 - 2400 dpi x 2400 dpi - 216 x 297 mm - add-on module` name = `Jet Scan Professional` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1083.jpg`
        status = `Available` quantity = `10` uom = `PC` currency_code = `EUR` price = `189.00` width = `35` depth = `40` height = `10` dim_unit = `cm` )
      ( product_id = `HT-1085` category = `Multifunction Printers` main_category = `Printers & Scanners` tax_tarif_code = `1` supplier_name = `Alpha Printers` weight_measure = `23.2` weight_unit = `KG`
        description = `Copymaster` name = `Copymaster` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1085.jpg`
        status = `Available` quantity = `10` uom = `PC` currency_code = `EUR` price = `1499.00` width = `45` depth = `42` height = `22` dim_unit = `cm` )
      ( product_id = `HT-1090` category = `Speakers` main_category = `Computer Components` tax_tarif_code = `1` supplier_name = `Speaker Experts` weight_measure = `3` weight_unit = `KG`
        description = `PC multimedia speakers - 5 Watt (Total)` name = `Surround Sound` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1090.jpg`
        status = `Available` quantity = `20` uom = `PC` currency_code = `EUR` price = `39.00` width = `12` depth = `10` height = `16` dim_unit = `cm` )
      ( product_id = `HT-1091` category = `Speakers` main_category = `Computer Components` tax_tarif_code = `1` supplier_name = `Speaker Experts` weight_measure = `1.4` weight_unit = `KG`
        description = `PC multimedia speakers - 10 Watt (Total) - 2-way` name = `Blaster Extreme` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1091.jpg`
        status = `Available` quantity = `15` uom = `PC` currency_code = `EUR` price = `26.00` width = `13` depth = `11` height = `17.5` dim_unit = `cm` )
      ( product_id = `HT-1092` category = `Speakers` main_category = `Computer Components` tax_tarif_code = `1` supplier_name = `Speaker Experts` weight_measure = `2.1` weight_unit = `KG`
        description = `PC multimedia speakers - optimized for Blutooth/A2DP` name = `Sound Booster` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1092.jpg`
        status = `Discontinued` quantity = `50` uom = `PC` currency_code = `EUR` price = `45.00` width = `12.4` depth = `10.4` height = `18.1` dim_unit = `cm` )
      ( product_id = `HT-1095` category = `Accessories` main_category = `Computer Components` tax_tarif_code = `1` supplier_name = `Fasttech` weight_measure = `80` weight_unit = `G`
        description = `5.1 Headset, 40 Hz-20 kHz, Wireless` name = `Lovely Sound 5.1 Wireless` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1095.jpg`
        status = `Available` quantity = `12` uom = `PC` currency_code = `EUR` price = `49.00` width = `24` depth = `19` height = `23` dim_unit = `cm` )
      ( product_id = `HT-1096` category = `Accessories` main_category = `Computer Components` tax_tarif_code = `1` supplier_name = `Fasttech` weight_measure = `130` weight_unit = `G`
        description = `5.1 Headset, 40 Hz-20 kHz, 3m cable` name = `Lovely Sound 5.1` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1096.jpg`
        status = `Available` quantity = `18` uom = `PC` currency_code = `EUR` price = `39.00` width = `25` depth = `17` height = `19` dim_unit = `cm` )
      ( product_id = `HT-1097` category = `Accessories` main_category = `Computer Components` tax_tarif_code = `1` supplier_name = `Fasttech` weight_measure = `60` weight_unit = `G`
        description = `5.1 Headset, 40 Hz-20 kHz, 1m cable` name = `Lovely Sound Stereo` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1097.jpg`
        status = `Out of Stock` quantity = `21` uom = `PC` currency_code = `EUR` price = `29.00` width = `21.3` depth = `2.4` height = `19.7` dim_unit = `cm` )
      ( product_id = `HT-1100` category = `Software` main_category = `Software` tax_tarif_code = `1` supplier_name = `Technocom` weight_measure = `1.2` weight_unit = `KG`
        description = `Complete package, 1 User, Office Applications (word processing, spreadsheet, presentations)` name = `Smart Office` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1100.jpg`
        status = `Out of Stock` quantity = `25` uom = `PC` currency_code = `EUR` price = `89.90` width = `15` depth = `6.5` height = `2.1` dim_unit = `cm` )
      ( product_id = `HT-1101` category = `Software` main_category = `Software` tax_tarif_code = `1` supplier_name = `Technocom` weight_measure = `0.8` weight_unit = `KG`
        description = `Complete package, 1 User, Image editing, processing` name = `Smart Design` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1101.jpg`
        status = `Available` quantity = `26` uom = `PC` currency_code = `EUR` price = `79.90` width = `14` depth = `6.7` height = `24` dim_unit = `cm` )
      ( product_id = `HT-1102` category = `Software` main_category = `Software` tax_tarif_code = `1` supplier_name = `Technocom` weight_measure = `0.8` weight_unit = `KG`
        description = `Complete package, 1 User, Network Software Utilities, Useful Applications and Documentation` name = `Smart Network` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1102.jpg`
        status = `Available` quantity = `28` uom = `PC` currency_code = `EUR` price = `69.00` width = `16` depth = `6` height = `27` dim_unit = `cm` )
      ( product_id = `HT-1103` category = `Software` main_category = `Software` tax_tarif_code = `1` supplier_name = `Technocom` weight_measure = `0.8` weight_unit = `KG`
        description = `Complete package, 1 User, different Multimedia applications, playing music, watching DVDs, only with this Smart package` name = `Smart Multimedia` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1103.jpg`
        status = `Available` quantity = `9` uom = `PC` currency_code = `EUR` price = `77.00` width = `11` depth = `3.4` height = `22` dim_unit = `cm` )
      ( product_id = `HT-1104` category = `Software` main_category = `Software` tax_tarif_code = `1` supplier_name = `Technocom` weight_measure = `1.1` weight_unit = `KG`
        description = `Complete package, 1 User, various games for amusement, logic, action, jump&run` name = `Smart Games` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1104.jpg`
        status = `Available` quantity = `13` uom = `PC` currency_code = `EUR` price = `55.00` width = `10` depth = `3` height = `30` dim_unit = `cm` )
      ( product_id = `HT-1105` category = `Software` main_category = `Software` tax_tarif_code = `1` supplier_name = `Brainsoft` weight_measure = `0.7` weight_unit = `KG`
        description = `Complete package, 1 User, highly recommended for internet users as anti-virus protection` name = `Smart Internet Antivirus` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1105.jpg`
        status = `Available` quantity = `17` uom = `PC` currency_code = `EUR` price = `29.00` width = `16` depth = `4` height = `21` dim_unit = `cm` )
      ( product_id = `HT-1106` category = `Software` main_category = `Software` tax_tarif_code = `1` supplier_name = `Brainsoft` weight_measure = `0.9` weight_unit = `KG`
        description = `Complete package, 1 User, recommended for internet users, protect your PC against cyber-crime` name = `Smart Firewall` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1106.jpg`
        status = `Discontinued` quantity = `19` uom = `PC` currency_code = `EUR` price = `34.00` width = `17.9` depth = `4.2` height = `23.1` dim_unit = `cm` )
      ( product_id = `HT-1107` category = `Software` main_category = `Software` tax_tarif_code = `1` supplier_name = `Brainsoft` weight_measure = `0.5` weight_unit = `KG`
        description = `Complete package, 1 User, bring your money in your mind, see what you have and what you want` name = `Smart Money` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1107.jpg`
        status = `Out of Stock` quantity = `18` uom = `PC` currency_code = `EUR` price = `29.90` width = `12` depth = `1.5` height = `19` dim_unit = `cm` )
      ( product_id = `HT-1110` category = `Computer System Accessories` main_category = `Computer Systems` tax_tarif_code = `1` supplier_name = `Red Point Stores` weight_measure = `0.03` weight_unit = `KG`
        description = `Robust 3m anti-burglary protection for your laptop computer` name = `PC Lock` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1110.jpg`
        status = `Available` quantity = `14` uom = `PC` currency_code = `EUR` price = `8.90` width = `20` depth = `8` height = `4.3` dim_unit = `cm` )
      ( product_id = `HT-1111` category = `Computer System Accessories` main_category = `Computer Systems` tax_tarif_code = `1` supplier_name = `Red Point Stores` weight_measure = `0.02` weight_unit = `KG`
        description = `Robust 1m anti-burglary protection for your desktop computer` name = `Notebook Lock` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1111.jpg`
        status = `Available` quantity = `20` uom = `PC` currency_code = `EUR` price = `6.90` width = `31` depth = `9` height = `7` dim_unit = `cm` )
      ( product_id = `HT-1112` category = `Computer System Accessories` main_category = `Computer Systems` tax_tarif_code = `1` supplier_name = `Red Point Stores` weight_measure = `0.075` weight_unit = `KG`
        description = `Color webcam, color, High-Speed USB` name = `Web cam reality` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1112.jpg`
        status = `Out of Stock` quantity = `27` uom = `PC` currency_code = `EUR` price = `39.00` width = `9` depth = `8.2` height = `1.3` dim_unit = `cm` )
      ( product_id = `HT-1113` category = `Computer System Accessories` main_category = `Computer Systems` tax_tarif_code = `1` supplier_name = `Red Point Stores` weight_measure = `0.05` weight_unit = `KG`
        description = `10 separately packed screen wipes` name = `Screen clean` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1113.jpg`
        status = `Available` quantity = `17` uom = `PC` currency_code = `EUR` price = `2.30` width = `2` depth = `2` height = `0.1` dim_unit = `cm` )
      ( product_id = `HT-1114` category = `Computer System Accessories` main_category = `Computer Systems` tax_tarif_code = `1` supplier_name = `Red Point Stores` weight_measure = `1.8` weight_unit = `KG`
        description = `Notebook bag, plenty of room for stationery and writing materials` name = `Fabric bag professional` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1114.jpg`
        status = `Available` quantity = `14` uom = `PC` currency_code = `EUR` price = `31.00` width = `42` depth = `32` height = `7` dim_unit = `cm` )
      ( product_id = `HT-1115` category = `Telecommunications` main_category = `Computer Components` tax_tarif_code = `1` supplier_name = `Red Point Stores` weight_measure = `0.45` weight_unit = `KG`
        description = `Wireless DSL Router (available in blue, black and silver)` name = `Wireless DSL Router` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1115.jpg`
        status = `Available` quantity = `16` uom = `PC` currency_code = `EUR` price = `49.00` width = `19.3` depth = `18` height = `5` dim_unit = `cm` )
      ( product_id = `HT-1116` category = `Telecommunications` main_category = `Computer Components` tax_tarif_code = `1` supplier_name = `Red Point Stores` weight_measure = `0.45` weight_unit = `KG`
        description = `Wireless DSL Router / Repeater (available in blue, black and silver)` name = `Wireless DSL Router / Repeater` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1116.jpg`
        status = `Out of Stock` quantity = `12` uom = `PC` currency_code = `EUR` price = `59.00` width = `19.3` depth = `18` height = `5` dim_unit = `cm` )
      ( product_id = `HT-1117` category = `Telecommunications` main_category = `Computer Components` tax_tarif_code = `1` supplier_name = `Technocom` weight_measure = `0.45` weight_unit = `KG`
        description = `Wireless DSL Router / Repeater and Print Server (available in blue, black and silver)` name = `Wireless DSL Router / Repeater and Print Server` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1117.jpg`
        status = `Available` quantity = `12` uom = `PC` currency_code = `EUR` price = `69.00` width = `19.3` depth = `18` height = `5` dim_unit = `cm` )
      ( product_id = `HT-1118` category = `Computer System Accessories` main_category = `Computer Systems` tax_tarif_code = `1` supplier_name = `Technocom` weight_measure = `0.015` weight_unit = `KG`
        description = `USB 2.0 High-Speed 64 GB` name = `USB Stick` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1118.jpg`
        status = `Available` quantity = `14` uom = `PC` currency_code = `EUR` price = `35.00` width = `1.5` depth = `8.7` height = `1.2` dim_unit = `cm` )
      ( product_id = `HT-1119` category = `Accessories` main_category = `Computer Systems` tax_tarif_code = `1` supplier_name = `Titanium` weight_measure = `88` weight_unit = `G`
        description = `Universal Travel Adapter` name = `Travel Adapter` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1119.jpg`
        status = `Discontinued` quantity = `10` uom = `PC` currency_code = `EUR` price = `79.00` width = `2` depth = `3.1` height = `3.9` dim_unit = `cm` )
      ( product_id = `HT-1120` category = `Keyboards` main_category = `Computer Components` tax_tarif_code = `1` supplier_name = `Technocom` weight_measure = `1` weight_unit = `KG`
        description = `Cordless Bluetooth Keyboard with English keys` name = `Cordless Bluetooth Keyboard, english international` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1120.jpg`
        status = `Out of Stock` quantity = `13` uom = `PC` currency_code = `EUR` price = `29.00` width = `51.4` depth = `23` height = `4` dim_unit = `cm` )
      ( product_id = `HT-1137` category = `Flat Screen Monitors` main_category = `Computer Components` tax_tarif_code = `1` supplier_name = `Technocom` weight_measure = `18` weight_unit = `KG`
        description = `Optimum Hi-Resolution max. 2048 × 1536 @ 85Hz, Dot Pitch: 0.24mm` name = `Flat XXL` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1137.jpg`
        status = `Discontinued` quantity = `10` uom = `PC` currency_code = `EUR` price = `1430.00` width = `54` depth = `22` height = `38` dim_unit = `cm` )
      ( product_id = `HT-1138` category = `Mice` main_category = `Computer Components` tax_tarif_code = `1` supplier_name = `Technocom` weight_measure = `0.02` weight_unit = `KG`
        description = `Portable pocket Mouse with retracting cord` name = `Pocket Mouse` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1138.jpg`
        status = `Available` quantity = `20` uom = `PC` currency_code = `EUR` price = `23.00` width = `0.3` depth = `0.5` height = `1` dim_unit = `cm` )
      ( product_id = `HT-1210` category = `PCs` main_category = `Computer Systems` tax_tarif_code = `1` supplier_name = `Technocom` weight_measure = `2.3` weight_unit = `KG`
        description = `PC Power Station with 3,4 Ghz quad-core, 32 GB DDR3 SDRAM, feels like Available PC, Windows 8 Pro` name = `PC Power Station` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1210.jpg`
        status = `Available` quantity = `22` uom = `PC` currency_code = `EUR` price = `2399.00` width = `28` depth = `31` height = `43` dim_unit = `cm` )
      ( product_id = `HT-1251` category = `Laptops` main_category = `Computer Systems` tax_tarif_code = `1` supplier_name = `Ultrasonic United` weight_measure = `4.2` weight_unit = `KG`
        description = `Flexible Laptop with 2,5 GHz Quad Core, 15" HD TN, 16 GB DDR SDRAM, 256 GB SSD, Windows 10 Pro` name = `Astro Laptop 1516` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1251.jpg`
        status = `Available` quantity = `23` uom = `PC` currency_code = `EUR` price = `989.00` width = `30` depth = `18` height = `3` dim_unit = `cm` )
      ( product_id = `HT-1252` category = `Smartphones and Tablets` main_category = `Smartphones & Tablets` tax_tarif_code = `1` supplier_name = `Ultrasonic United` weight_measure = `0.75` weight_unit = `KG`
        description = `6 inch 1280x800 HD display (216 ppi), Quad-core processor, 8 GB internal storage (actual formatted capacity will be less), 3050 mAh battery (Up to 8 hours of active use), grey or black` name = `Astro Phone 6` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1252.jpg`
        status = `Available` quantity = `28` uom = `PC` currency_code = `EUR` price = `649.00` width = `8` depth = `6` height = `1.5` dim_unit = `cm` )
      ( product_id = `HT-1253` category = `Laptops` main_category = `Computer Systems` tax_tarif_code = `1` supplier_name = `Ultrasonic United` weight_measure = `4.2` weight_unit = `KG`
        description = `Flexible Laptop with 2,5 GHz Dual Core, 14" HD+ TN, 8 GB DDR SDRAM, 324 GB SSD, Windows 10 Pro` name = `Benda Laptop 1408` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1253.jpg`
        status = `Discontinued` quantity = `27` uom = `PC` currency_code = `EUR` price = `976.00` width = `30` depth = `18` height = `3` dim_unit = `cm` )
      ( product_id = `HT-1254` category = `Flat Screens` main_category = `Computer Components` tax_tarif_code = `1` supplier_name = `Ultrasonic United` weight_measure = `15` weight_unit = `KG`
        description = `Optimum Hi-Resolution Widescreen max. 1920 x 1080 @ 85Hz, Dot Pitch: 0.27mm, HDMI, Discontinued-Sub` name = `Bending Screen 21HD` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1254.jpg`
        status = `Available` quantity = `23` uom = `PC` currency_code = `EUR` price = `250.00` width = `37` depth = `12` height = `36` dim_unit = `cm` )
      ( product_id = `HT-1255` category = `Flat Screens` main_category = `Computer Components` tax_tarif_code = `1` supplier_name = `Ultrasonic United` weight_measure = `16` weight_unit = `KG`
        description = `Optimum Hi-Resolution Widescreen max. 2048 x 1080 @ 85Hz, Dot Pitch: 0.27mm, HDMI, Discontinued-Sub` name = `Broad Screen 22HD` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1255.jpg`
        status = `Discontinued` quantity = `5` uom = `PC` currency_code = `EUR` price = `270.00` width = `39` depth = `12` height = `38` dim_unit = `cm` )
      ( product_id = `HT-1256` category = `Smartphones and Tablets` main_category = `Smartphones & Tablets` tax_tarif_code = `1` supplier_name = `Ultrasonic United` weight_measure = `0.75` weight_unit = `KG`
        description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage (actual formatted capacity will be less), 4325 mAh battery (Up to 8 hours of active use), white or black` name = `Cerdik Phone 7` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1256.jpg`
        status = `Discontinued` quantity = `19` uom = `PC` currency_code = `EUR` price = `549.00` width = `9` depth = `15` height = `1.5` dim_unit = `cm` )
      ( product_id = `HT-1257` category = `Smartphones and Tablets` main_category = `Smartphones & Tablets` tax_tarif_code = `1` supplier_name = `Ultrasonic United` weight_measure = `2.8` weight_unit = `KG`
        description = `10.5-inch Multitouch HD Screen (1280 x 800), 16GB Internal Memory, Wireless N Wi-Fi; Bluetooth, GPS Enabled, 1GHz Dual-Core Processor` name = `Cepat Tablet 10.5` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1257.jpg`
        status = `Available` quantity = `17` uom = `PC` currency_code = `EUR` price = `549.00` width = `48` depth = `31` height = `4.5` dim_unit = `cm` )
      ( product_id = `HT-1258` category = `Smartphones and Tablets` main_category = `Smartphones & Tablets` tax_tarif_code = `1` supplier_name = `Ultrasonic United` weight_measure = `2.5` weight_unit = `KG`
        description = `8-inch Multitouch HD Screen (2000 x 1500) 32GB Internal Memory, Wireless N Wi-Fi, Bluetooth, GPS Enabled, 1.5 GHz Quad-Core Processor` name = `Cepat Tablet 8` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1258.jpg`
        status = `Available` quantity = `24` uom = `PC` currency_code = `EUR` price = `529.00` width = `38` depth = `21` height = `3.5` dim_unit = `cm` )
      ( product_id = `HT-1500` category = `Servers` main_category = `Computer Systems` tax_tarif_code = `1` supplier_name = `Technocom` weight_measure = `18` weight_unit = `KG`
        description = `Dual socket, quad-core processing server with 1333 MHz Front Side Bus with 10Gb connectivity` name = `Server Basic` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1500.jpg`
        status = `Available` quantity = `24` uom = `PC` currency_code = `EUR` price = `5000.00` width = `34` depth = `35` height = `23` dim_unit = `cm` )
      ( product_id = `HT-1501` category = `Servers` main_category = `Computer Systems` tax_tarif_code = `1` supplier_name = `Technocom` weight_measure = `25` weight_unit = `KG`
        description = `Dual socket, quad-core processing server with 1644 MHz Front Side Bus with 10Gb connectivity` name = `Server Professional` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1501.jpg`
        status = `Out of Stock` quantity = `26` uom = `PC` currency_code = `EUR` price = `15000.00` width = `29` depth = `30` height = `27` dim_unit = `cm` )
      ( product_id = `HT-1502` category = `Servers` main_category = `Computer Systems` tax_tarif_code = `1` supplier_name = `Technocom` weight_measure = `35` weight_unit = `KG`
        description = `Dual socket, quad-core processing server with 1644 MHz Front Side Bus with 100Gb connectivity` name = `Server Power Pro` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1502.jpg`
        status = `Available` quantity = `34` uom = `PC` currency_code = `EUR` price = `25000.00` width = `22` depth = `27.3` height = `37` dim_unit = `cm` )
      ( product_id = `HT-1600` category = `Desktop Computers` main_category = `Computer Systems` tax_tarif_code = `1` supplier_name = `Titanium` weight_measure = `4.8` weight_unit = `KG`
        description = `2,8 Ghz dual core, 4 GB DDR3 SDRAM, 500 GB Hard Disc, Graphic Card: Proctra X, Windows 8` name = `Family PC Basic` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1600.jpg`
        status = `Available` quantity = `10` uom = `PC` currency_code = `EUR` price = `600.00` width = `21.4` depth = `29` height = `38` dim_unit = `cm` )
      ( product_id = `HT-1601` category = `Desktop Computers` main_category = `Computer Systems` tax_tarif_code = `1` supplier_name = `Titanium` weight_measure = `5.3` weight_unit = `KG`
        description = `2,8 Ghz dual core, 4 GB DDR3 SDRAM, 1000 GB Hard Disc, Graphic Card: Gladiator MX, Windows 8` name = `Family PC Pro` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1601.jpg`
        status = `Available` quantity = `20` uom = `PC` currency_code = `EUR` price = `900.00` width = `25` depth = `31.7` height = `40.2` dim_unit = `cm` )
      ( product_id = `HT-1602` category = `Desktop Computers` main_category = `Computer Systems` tax_tarif_code = `1` supplier_name = `Titanium` weight_measure = `5.9` weight_unit = `KG`
        description = `3,4 Ghz quad core, 8 GB DDR3 SDRAM, 2000 GB Hard Disc, Graphic Card: Gladiator MX, Windows 8` name = `Gaming Monster` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1602.jpg`
        status = `Available` quantity = `24` uom = `PC` currency_code = `EUR` price = `1200.00` width = `26.5` depth = `34` height = `47` dim_unit = `cm` )
      ( product_id = `HT-1603` category = `Desktop Computers` main_category = `Computer Systems` tax_tarif_code = `1` supplier_name = `Titanium` weight_measure = `6.8` weight_unit = `KG`
        description = `3,4 Ghz quad core, 16 GB DDR3 SDRAM, 4000 GB Hard Disc, Graphic Card: Hurricane GX, Windows 8` name = `Gaming Monster Pro` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1603.jpg`
        status = `Discontinued` quantity = `25` uom = `PC` currency_code = `EUR` price = `1700.00` width = `27` depth = `28` height = `42` dim_unit = `cm` )
      ( product_id = `HT-2000` category = `Accessories` main_category = `TV, Video & HiFi` tax_tarif_code = `1` supplier_name = `Titanium` weight_measure = `0.79` weight_unit = `KG`
        description = `7" LCD Screen, storage battery holds up to 6 hours!` name = `7" Widescreen Portable DVD Player w MP3` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2000.jpg`
        status = `Available` quantity = `20` uom = `PC` currency_code = `EUR` price = `249.99` width = `21.4` depth = `19` height = `27.6` dim_unit = `cm` )
      ( product_id = `HT-2001` category = `Accessories` main_category = `TV, Video & HiFi` tax_tarif_code = `1` supplier_name = `Titanium` weight_measure = `0.84` weight_unit = `KG`
        description = `10" LCD Screen, storage battery holds up to 8 hours` name = `10" Portable DVD player` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2001.jpg`
        status = `Available` quantity = `21` uom = `PC` currency_code = `EUR` price = `449.99` width = `24` depth = `19.5` height = `29` dim_unit = `cm` )
      ( product_id = `HT-2002` category = `Accessories` main_category = `TV, Video & HiFi` tax_tarif_code = `1` supplier_name = `Technocom` weight_measure = `0.72` weight_unit = `KG`
        description = `9" LCD Screen, storage holds up to 8 hours, 2 speakers included` name = `Portable DVD Player with 9" LCD Monitor` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2002.jpg`
        status = `Available` quantity = `50` uom = `PC` currency_code = `EUR` price = `853.99` width = `21` depth = `16.5` height = `14` dim_unit = `cm` )
      ( product_id = `HT-2025` category = `Accessories` main_category = `Computer Systems` tax_tarif_code = `1` supplier_name = `Titanium` weight_measure = `0.65` weight_unit = `KG`
        description = `Organizer and protective case for 264 CDs and DVDs` name = `CD/DVD case: 264 sleeves` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2025.jpg`
        status = `Discontinued` quantity = `26` uom = `PC` currency_code = `EUR` price = `44.99` width = `13` depth = `13` height = `20` dim_unit = `cm` )
      ( product_id = `HT-2026` category = `Accessories` main_category = `Computer Systems` tax_tarif_code = `1` supplier_name = `Titanium` weight_measure = `0.2` weight_unit = `KG`
        description = `Quality cables for notebooks and projectors` name = `Audio/Video Cable Kit - 4m` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2026.jpg`
        status = `Available` quantity = `16` uom = `PC` currency_code = `EUR` price = `29.99` width = `21` depth = `10.2` height = `13` dim_unit = `cm` )
      ( product_id = `HT-2027` category = `Accessories` main_category = `Computer Systems` tax_tarif_code = `1` supplier_name = `Titanium` weight_measure = `0.15` weight_unit = `KG`
        description = `Removable jewel case labels, zero residues (100)` name = `Removable CD/DVD Laser Labels` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2027.jpg`
        status = `Discontinued` quantity = `25` uom = `PC` currency_code = `EUR` price = `8.99` width = `5.5` depth = `2` height = `2` dim_unit = `cm` )
      ( product_id = `HT-6100` category = `Accessories` main_category = `TV, Video & HiFi` tax_tarif_code = `1` supplier_name = `Titanium` weight_measure = `1.7` weight_unit = `KG`
        description = `720p, DLP Projector max. 8,45 Meter, 2D` name = `Beam Breaker B-1` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6100.jpg`
        status = `Out of Stock` quantity = `32` uom = `PC` currency_code = `EUR` price = `469.00` width = `30.4` depth = `23.1` height = `23` dim_unit = `cm` )
      ( product_id = `HT-6101` category = `Accessories` main_category = `TV, Video & HiFi` tax_tarif_code = `1` supplier_name = `Technocom` weight_measure = `2` weight_unit = `KG`
        description = `1080p, DLP max.9,34 Meter, 2D-ready` name = `Beam Breaker B-2` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6101.jpg`
        status = `Available` quantity = `18` uom = `PC` currency_code = `EUR` price = `679.00` width = `30.4` depth = `23.1` height = `23` dim_unit = `cm` )
      ( product_id = `HT-6102` category = `Accessories` main_category = `TV, Video & HiFi` tax_tarif_code = `1` supplier_name = `Technocom` weight_measure = `2.5` weight_unit = `KG`
        description = `1080p, DLP max. 12,3 Meter, 3D-ready` name = `Beam Breaker B-3` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6102.jpg`
        status = `Out of Stock` quantity = `16` uom = `PC` currency_code = `EUR` price = `889.00` width = `30.4` depth = `23.1` height = `23` dim_unit = `cm` )
      ( product_id = `HT-6110` category = `Accessories` main_category = `TV, Video & HiFi` tax_tarif_code = `1` supplier_name = `Fasttech` weight_measure = `2.4` weight_unit = `KG`
        description = `CD-RW, DVD+R/RW, DVD-R/RW, MPEG 2 (Video-DVD), MPEG 4, VCD, SVCD, DivX, Xvid` name = `Play Movie` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6110.jpg`
        status = `Available` quantity = `15` uom = `PC` currency_code = `EUR` price = `130.00` width = `37` depth = `24` height = `6` dim_unit = `cm` )
      ( product_id = `HT-6111` category = `Accessories` main_category = `TV, Video & HiFi` tax_tarif_code = `1` supplier_name = `Fasttech` weight_measure = `3.1` weight_unit = `KG`
        description = `160 GB HDD, CD-RW, DVD+R/RW, DVD-R/RW, MPEG 2 (Video-DVD), MPEG 4, VCD, SVCD, DivX, Xvid` name = `Record Movie` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6111.jpg`
        status = `Discontinued` quantity = `24` uom = `PC` currency_code = `EUR` price = `288.00` width = `38` depth = `26` height = `6.2` dim_unit = `cm` )
      ( product_id = `HT-6120` category = `Accessories` main_category = `TV, Video & HiFi` tax_tarif_code = `1` supplier_name = `Fasttech` weight_measure = `134` weight_unit = `G`
        description = `64 GB USB Music-on-Available-Stick` name = `ITelo MusicStick` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6120.jpg`
        status = `Available` quantity = `15` uom = `PC` currency_code = `EUR` price = `45.00` width = `1.5` depth = `6` height = `1` dim_unit = `cm` )
      ( product_id = `HT-6121` category = `Accessories` main_category = `TV, Video & HiFi` tax_tarif_code = `1` supplier_name = `Fasttech` weight_measure = `134` weight_unit = `G`
        description = `ITelo Jog-Mate 64 GB HDD and Color Display, can play movies` name = `ITelo Jog-Mate` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6121.jpg`
        status = `Available` quantity = `24` uom = `PC` currency_code = `EUR` price = `63.00` width = `5.1` depth = `8` height = `9.2` dim_unit = `cm` )
      ( product_id = `HT-6122` category = `Accessories` main_category = `TV, Video & HiFi` tax_tarif_code = `1` supplier_name = `Fasttech` weight_measure = `266` weight_unit = `G`
        description = `MP3-Player with 40 GB HDD and Color Display, can play movies` name = `Power Pro Player 40` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6122.jpg`
        status = `Available` quantity = `23` uom = `PC` currency_code = `EUR` price = `167.00` width = `5.1` depth = `8` height = `9.2` dim_unit = `cm` )
      ( product_id = `HT-6123` category = `Accessories` main_category = `TV, Video & HiFi` tax_tarif_code = `1` supplier_name = `Fasttech` weight_measure = `267` weight_unit = `G`
        description = `MP3-Player with 80 GB SSD and Color Display, can play movies` name = `Power Pro Player 80` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6123.jpg`
        status = `Available` quantity = `13` uom = `PC` currency_code = `EUR` price = `299.00` width = `4` depth = `6` height = `0.8` dim_unit = `cm` )
      ( product_id = `HT-6130` category = `Flat Screen TVs` main_category = `TV, Video & HiFi` tax_tarif_code = `1` supplier_name = `Very Best Screens` weight_measure = `2.6` weight_unit = `KG`
        description = `32-inch, 1366x768 Pixel, 16:9, HDTV ready` name = `Flat Watch HD32` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6130.jpg`
        status = `Available` quantity = `16` uom = `PC` currency_code = `EUR` price = `1459.00` width = `78` depth = `22.1` height = `55` dim_unit = `cm` )
      ( product_id = `HT-6131` category = `Flat Screen TVs` main_category = `TV, Video & HiFi` tax_tarif_code = `1` supplier_name = `Very Best Screens` weight_measure = `2.2` weight_unit = `KG`
        description = `37-inch, 1366x768 Pixel, 16:9, HDTV ready` name = `Flat Watch HD37` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6131.jpg`
        status = `Available` quantity = `14` uom = `PC` currency_code = `EUR` price = `1199.00` width = `99.1` depth = `26` height = `61` dim_unit = `cm` )
      ( product_id = `HT-6132` category = `Flat Screen TVs` main_category = `TV, Video & HiFi` tax_tarif_code = `1` supplier_name = `Very Best Screens` weight_measure = `1.8` weight_unit = `KG`
        description = `41-inch, 1366x768 Pixel, 16:9, HDTV ready` name = `Flat Watch HD41` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6132.jpg`
        status = `Discontinued` quantity = `13` uom = `PC` currency_code = `EUR` price = `899.00` width = `128` depth = `23` height = `79.1` dim_unit = `cm` )
      ( product_id = `HT-7000` category = `Accessories` main_category = `Computer Components` tax_tarif_code = `1` supplier_name = `Fasttech` weight_measure = `0.5` weight_unit = `KG`
        description = `Our new multifunctional Handheld with phone function in copper` name = `Copperberry` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7000.jpg`
        status = `Discontinued` quantity = `5` uom = `PC` currency_code = `EUR` price = `549.00` width = `8.1` depth = `13` height = `12.1` dim_unit = `cm` )
      ( product_id = `HT-7010` category = `Accessories` main_category = `Computer Components` tax_tarif_code = `1` supplier_name = `Fasttech` weight_measure = `0.5` weight_unit = `KG`
        description = `Our new multifunctional Handheld with phone function in silver` name = `Silverberry` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7010.jpg`
        status = `Discontinued` quantity = `9` uom = `PC` currency_code = `EUR` price = `549.00` width = `8.1` depth = `13` height = `12.1` dim_unit = `cm` )
      ( product_id = `HT-7020` category = `Accessories` main_category = `Computer Components` tax_tarif_code = `1` supplier_name = `Fasttech` weight_measure = `0.5` weight_unit = `KG`
        description = `Our new multifunctional Handheld with phone function in gold` name = `Goldberry` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7020.jpg`
        status = `Available` quantity = `11` uom = `PC` currency_code = `EUR` price = `549.00` width = `8.1` depth = `13` height = `12.1` dim_unit = `cm` )
      ( product_id = `HT-7030` category = `Accessories` main_category = `Computer Components` tax_tarif_code = `1` supplier_name = `Fasttech` weight_measure = `0.5` weight_unit = `KG`
        description = `Our new multifunctional Handheld with phone function in platinum` name = `Platinberry` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7030.jpg`
        status = `Available` quantity = `12` uom = `PC` currency_code = `EUR` price = `549.00` width = `8.1` depth = `13` height = `12.1` dim_unit = `cm` )
      ( product_id = `HT-8000` category = `Laptops` main_category = `Computer Systems` tax_tarif_code = `1` supplier_name = `Titanium` weight_measure = `4` weight_unit = `KG`
        description = `Notebook with 2,80 GHz dual core, 4 GB DDR3 SDRAM, 500 GB Hard Disc, Windows 8` name = `ITelO FlexTop I4000` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8000.jpg`
        status = `Available` quantity = `11` uom = `PC` currency_code = `EUR` price = `799.00` width = `31` depth = `19` height = `3.1` dim_unit = `cm` )
      ( product_id = `HT-8001` category = `Laptops` main_category = `Computer Systems` tax_tarif_code = `1` supplier_name = `Titanium` weight_measure = `4.2` weight_unit = `KG`
        description = `Notebook with 2,80 GHz dual core, 8 GB DDR3 SDRAM, 500 GB Hard Disc, Windows 8` name = `ITelO FlexTop I6300c` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8001.jpg`
        status = `Discontinued` quantity = `20` uom = `PC` currency_code = `EUR` price = `799.00` width = `32` depth = `20` height = `3.4` dim_unit = `cm` )
      ( product_id = `HT-8002` category = `Laptops` main_category = `Computer Systems` tax_tarif_code = `1` supplier_name = `Titanium` weight_measure = `3.5` weight_unit = `KG`
        description = `Notebook with 2,80 GHz quad core, 4 GB DDR3 SDRAM, 1000 GB Hard Disc, Windows 8` name = `ITelO FlexTop I9100` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8002.jpg`
        status = `Available` quantity = `20` uom = `PC` currency_code = `EUR` price = `1199.00` width = `38` depth = `21` height = `4.1` dim_unit = `cm` )
      ( product_id = `HT-8003` category = `Laptops` main_category = `Computer Systems` tax_tarif_code = `1` supplier_name = `Titanium` weight_measure = `3.8` weight_unit = `KG`
        description = `Notebook with 2,80 GHz quad core, 8 GB DDR3 SDRAM, 1000 GB Hard Disc, Windows 8` name = `ITelO FlexTop I9800` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8003.jpg`
        status = `Available` quantity = `22` uom = `PC` currency_code = `EUR` price = `1388.00` width = `48` depth = `31` height = `4.5` dim_unit = `cm` )
      ( product_id = `HT-9991` category = `Accessories` main_category = `Smartphones & Tablets` tax_tarif_code = `1` supplier_name = `Ultrasonic United` weight_measure = `0.02` weight_unit = `KG`
        description = `Button Clasp, Quality Material, 100% Leather, compatible with many smartphone models` name = `Smartphone Leather Case` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9991.jpg`
        status = `Available` quantity = `12` uom = `PC` currency_code = `EUR` price = `25.00` width = `48` depth = `31` height = `4.5` dim_unit = `cm` )
      ( product_id = `HT-9992` category = `Smartphones and Tablets` main_category = `Smartphones & Tablets` tax_tarif_code = `1` supplier_name = `Ultrasonic United` weight_measure = `0.75` weight_unit = `KG`
        description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage (actual formatted capacity will be less), 4325 mAh battery (Up to 8 hours of active use), white or black` name = `Smartphone Alpha` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9992.jpg`
        status = `Out of Stock` quantity = `13` uom = `PC` currency_code = `EUR` price = `599.00` width = `48` depth = `31` height = `4.5` dim_unit = `cm` )
      ( product_id = `HT-9993` category = `Smartphones and Tablets` main_category = `Smartphones & Tablets` tax_tarif_code = `1` supplier_name = `Ultrasonic United` weight_measure = `3.8` weight_unit = `KG`
        description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage, 4325 mAh battery (Up to 8 hours of active use)` name = `Mini Tablet` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9993.jpg`
        status = `Available` quantity = `10` uom = `PC` currency_code = `EUR` price = `833.00` width = `48` depth = `31` height = `4.5` dim_unit = `cm` )
      ( product_id = `HT-9994` category = `Accessories` main_category = `TV, Video & HiFi` tax_tarif_code = `1` supplier_name = `Ultrasonic United` weight_measure = `3.8` weight_unit = `KG`
        description = `1920x1080 Full HD, image stabilization reduces blur, 27x Optical / 32x Extended Zoom, wide angle Lens, 2.7" wide LCD display` name = `Camcorder View` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9994.jpg`
        status = `Out of Stock` quantity = `50` uom = `PC` currency_code = `EUR` price = `1388.00` width = `48` depth = `31` height = `27` dim_unit = `cm` )
      ( product_id = `HT-9995` category = `Accessories` main_category = `Smartphones & Tablets` tax_tarif_code = `1` supplier_name = `Titanium` weight_measure = `0.03` weight_unit = `KG`
        description = `Stylish tablet pouch, protects from scratches, color: black` name = `Tablet Pouch` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9995.jpg`
        status = `Available` quantity = `34` uom = `PC` currency_code = `EUR` price = `20.00` width = `25` depth = `40` height = `4.5` dim_unit = `cm` )
      ( product_id = `HT-9996` category = `Accessories` main_category = `Smartphones & Tablets` tax_tarif_code = `1` supplier_name = `Titanium` weight_measure = `0.03` weight_unit = `KG`
        description = `Stylish tablet pouch, protects from scratches, color: black` name = `Tablet Pouch` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9996.jpg`
        status = `Available` quantity = `34` uom = `PC` currency_code = `EUR` price = `20.00` width = `25` depth = `40` height = `4.5` dim_unit = `cm` )
      ( product_id = `HT-9997` category = `Smartphones and Tablets` main_category = `Smartphones & Tablets` tax_tarif_code = `1` supplier_name = `Titanium` weight_measure = `3.8` weight_unit = `KG`
        description = `6-Inch E Ink Screen, Access To e-book Store, Adjustable Font Styles and Sizes, Stores Up To 1,000 Books` name = `e-Book Reader ReadMe` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9997.jpg`
        status = `Available` quantity = `23` uom = `PC` currency_code = `EUR` price = `33.00` width = `48` depth = `31` height = `4.5` dim_unit = `cm` )
      ( product_id = `HT-9998` category = `Smartphones and Tablets` main_category = `Smartphones & Tablets` tax_tarif_code = `1` supplier_name = `Titanium` weight_measure = `0.75` weight_unit = `KG`
        description = `5 Megapixel Camera, Wi-Fi 802.11 b/g/n, Bluetooth, GPS Available-GPS support` name = `Smartphone Beta` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9998.jpg`
        status = `Available` quantity = `21` uom = `PC` currency_code = `EUR` price = `30.00` width = `48` depth = `31` height = `4.5` dim_unit = `cm` )
      ( product_id = `HT-9999` category = `Tablets` main_category = `Smartphones & Tablets` tax_tarif_code = `1` supplier_name = `Titanium` weight_measure = `3.8` weight_unit = `KG`
        description = `10.1-inch Multitouch HD Screen (1280 x 800), 16GB Internal Memory, Wireless N Wi-Fi; Bluetooth, GPS Enabled, 1GHz Dual-Core Processor` name = `Maxi Tablet` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9999.jpg`
        status = `Available` quantity = `20` uom = `PC` currency_code = `EUR` price = `749.00` width = `48` depth = `31` height = `4.5` dim_unit = `cm` )
      ( product_id = `PF-1000` category = `Accessories` main_category = `Computer Systems` tax_tarif_code = `1` supplier_name = `Titanium` weight_measure = `0.01` weight_unit = `KG`
        description = `Flyer for our product palette` name = `Flyer` date_of_sale = ``
        product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/PF-1000.jpg`
        status = `Out of Stock` quantity = `33` uom = `PC` currency_code = `EUR` price = `0.00` width = `46` depth = `30` height = `3` dim_unit = `cm` ) ).

    " explicit UI5 default of CarouselLayout.visiblePagesCount (the original's settings> model is empty until the route matches)
    pages_count = 1.

  ENDMETHOD.

ENDCLASS.
