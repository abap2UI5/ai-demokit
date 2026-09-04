" @keywords comparisonpattern comparison pattern sap.m compare items side app table toolbar title toolbarspacer
" @summary The pattern allows users to select multiple items from an sap.m.Table and display information about them in a structured way - all items are displayed next to each other for easy comparison, based on their specifics.
CLASS z2ui5_cl_smpc_app_012 DEFINITION PUBLIC.

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
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.
    TYPES:
      BEGIN OF ty_s_comp_value,
        text        TYPE string,
        description TYPE string,
        visible     TYPE abap_bool,
      END OF ty_s_comp_value.
    TYPES ty_t_comp_value TYPE STANDARD TABLE OF ty_s_comp_value WITH DEFAULT KEY.
    TYPES:
      BEGIN OF ty_s_comp_prop,
        key    TYPE string,
        values TYPE ty_t_comp_value,
      END OF ty_s_comp_prop.
    TYPES ty_t_comp_prop TYPE STANDARD TABLE OF ty_s_comp_prop WITH DEFAULT KEY.

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
    TYPES ty_t_key TYPE STANDARD TABLE OF ty_s_key WITH DEFAULT KEY.

    DATA client      TYPE REF TO z2ui5_if_client.
    DATA first_item  TYPE i.
    DATA check_page2 TYPE abap_bool.

    METHODS view_display.
    METHODS on_event.
    METHODS comparison_build.
    METHODS comparison_props_build.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_012 IMPLEMENTATION.

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
    DATA temp1 TYPE string_table.
    DATA temp3 TYPE string_table.
    DATA temp5 TYPE string_table.
      DATA temp7 TYPE string_table.
      DATA temp2 LIKE LINE OF temp7.
      DATA temp9 TYPE string_table.
      DATA temp4 LIKE LINE OF temp9.
      DATA temp11 TYPE string_table.

    " the original's router matches #/Page2 directly (a deep link, a reload):
    " the live hash rides in s_config-hash on every request, so a render whose
    " hash carries it enters the comparison - with nothing selected it stays
    " empty, exactly the original's cold #/Page2
    IF check_page2 = abap_false AND client->get( )-s_config-hash CS `/Page2`.
      comparison_build( ).
      check_page2 = abap_true.
    ENDIF.

    
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " the sample's App/Main/Comparison views merged into one view: the App hosts both pages, the router's navTo becomes a NavContainer `to` frontend action
    
    CLEAR temp1.
    INSERT `${KEY}` INTO TABLE temp1.
    INSERT `${$parameters>/expand}` INTO TABLE temp1.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`      v = `100%`
        )->a( n = `xmlns`       v = `sap.m`
        )->a( n = `xmlns:mvc`   v = `sap.ui.core.mvc`
        )->a( n = `xmlns:f`     v = `sap.f`
        )->a( n = `xmlns:cards` v = `sap.f.cards`
        )->a( n = `xmlns:l`     v = `sap.ui.layout`

        )->ele( `App`
            )->a( n = `id` v = `rootControl`

            )->ele( `Page`
                )->a( n = `title` v = `First Page`

                )->ele( `content`
                    )->ele( `Table`
                        )->a( n = `id`              v = `idProductsTable`
                        )->a( n = `selectionChange` v = client->_event( `SELECTION` )
                        )->a( n = `mode`            v = `MultiSelect`
                        )->a( n = `inset`           v = `false`
                        )->a( n = `items`           v = |\{ path: '{ client->_bind_path( t_products ) }', sorter: \{ path: 'NAME' \} \}|

                        )->ele( `headerToolbar`
                            )->ele( `Toolbar`
                                )->tag( `Title`
                                    )->a( n = `text`  v = `Laptops`
                                    )->a( n = `level` v = `H2`
                                )->tag( `ToolbarSpacer`
                                " the controller's setText/setVisible on selection replaced by bound model properties
                                )->tag( `Button`
                                    )->a( n = `id`      v = `compareBtn`
                                    )->a( n = `text`    v = client->_bind( compare_text )
                                    )->a( n = `visible` v = client->_bind( compare_visible )
                                    )->a( n = `press`   v = client->_event( `COMPARE` )

                            )->end(
                        )->end(
                        )->ele( `columns`
                            )->ele( `Column`
                                )->tag( `Text`
                                    )->a( n = `text` v = `Product`

                            )->end(
                            )->ele( `Column`
                                )->a( n = `hAlign`         v = `Center`
                                )->a( n = `width`          v = `12em`
                                )->a( n = `minScreenWidth` v = `Tablet`
                                )->a( n = `demandPopin`    v = `true`

                                )->tag( `Text`
                                    )->a( n = `text` v = `Quantity`

                            )->end(
                            )->ele( `Column`
                                )->a( n = `minScreenWidth` v = `Tablet`
                                )->a( n = `demandPopin`    v = `true`
                                )->a( n = `hAlign`         v = `Center`

                                )->tag( `Text`
                                    )->a( n = `text` v = `Weight`

                            )->end(
                            )->ele( `Column`
                                )->a( n = `hAlign` v = `End`

                                )->tag( `Text`
                                    )->a( n = `text` v = `Unit Price`

                            )->end(
                        )->end(
                        )->ele( `items`
                            " selected two-way binding added to read the multi-selection in the SELECTION handler (getSelectedContextPaths equivalent)
                            )->ele( `ColumnListItem`
                                )->a( n = `vAlign`   v = `Middle`
                                )->a( n = `type`     v = `Inactive`
                                )->a( n = `selected` v = `{SELECTED}`

                                )->ele( `cells`
                                    )->tag( `ObjectIdentifier`
                                        )->a( n = `title` v = `{NAME}`
                                        )->a( n = `text`  v = `{PRODUCT_ID}`
                                    )->tag( `Input`
                                        )->a( n = `value`       v = `{QUANTITY}`
                                        " the ORIGINAL writes type="{Text}" (Main.view.xml): it meant the
                                        " literal enum value and wrote a binding, so the property falls back
                                        " to its default. Ported verbatim rather than repaired
                                        " abap2ui5lint-disable-next-line unknown-binding-path -- the sample's own quirk
                                        )->a( n = `type`        v = `{Text}`
                                        )->a( n = `description` v = `{UOM}`
                                        )->a( n = `fieldWidth`  v = `{60%}`
                                    )->tag( `ObjectNumber`
                                        )->a( n = `number` v = `{WEIGHT_MEASURE}`
                                        )->a( n = `unit`   v = `{WEIGHT_UNIT}`
                                    )->tag( `ObjectNumber`
                                        )->a( n = `number` v = |\{ parts:[\{path:'PRICE'\},\{path:'CURRENCY_CODE'\}], type: 'sap.ui.model.type.Currency', formatOptions: \{showMeasure: false\} \}|
                                        )->a( n = `unit`   v = `{CURRENCY_CODE}`

                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(
            )->end(
            )->ele( n = `DynamicPage` ns = `f`
                )->a( n = `id`    v = `page-comparison`
                )->a( n = `class` v = `sapUiComparisonContainer`

                )->ele( n = `title` ns = `f`
                    " the original's stateChange handler (add/removeSnappedContent Carousel animation workaround) is dropped - imperative aggregation surgery
                    )->ele( n = `DynamicPageTitle` ns = `f`
                        )->a( n = `id`               v = `dynamic-page`
                        )->a( n = `backgroundDesign` v = `Transparent`

                        )->ele( n = `heading` ns = `f`
                            )->tag( `Title`
                                )->a( n = `text` v = `Second Page`

                        )->end(
                        )->ele( n = `snappedContent` ns = `f`
                            )->ele( `Carousel`
                                )->a( n = `height`                 v = `auto`
                                )->a( n = `class`                  v = `sapUiSmallMarginBottom`
                                )->a( n = `id`                     v = `carousel-snapped`
                                )->a( n = `pageChanged`            v = client->_event( val = `PAGE_CHANGED` arg = `${$parameters>/activePages/0}` )
                                )->a( n = `pageIndicatorPlacement` v = `Top`
                                )->a( n = `showPageIndicator`      v = |\{= !${ client->_bind( is_desktop ) } \}|
                                )->a( n = `pages`                  v = client->_bind( t_comp_products )

                                )->ele( `customLayout`
                                    )->tag( `CarouselLayout`
                                        )->a( n = `visiblePagesCount` v = client->_bind( pages_count )

                                )->end(
                                )->ele( n = `Card` ns = `f`
                                    )->a( n = `class` v = `sapUiTinyMarginTop`

                                    )->ele( n = `header` ns = `f`
                                        " iconSrc formatter .formatter.url flattened to absolute image URLs in the model
                                        )->tag( n = `Header` ns = `cards`
                                            )->a( n = `title`            v = `{NAME}`
                                            )->a( n = `subtitle`         v = `{STATUS}`
                                            )->a( n = `iconSrc`          v = `{PRODUCT_PIC_URL}`
                                            )->a( n = `iconDisplayShape` v = `Square`

                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(
                )->ele( n = `header` ns = `f`
                    )->ele( n = `DynamicPageHeader` ns = `f`
                        )->a( n = `backgroundDesign` v = `Transparent`

                        )->ele( `Carousel`
                            )->a( n = `height`                 v = `auto`
                            )->a( n = `class`                  v = `sapUiSmallMarginBottom`
                            )->a( n = `id`                     v = `carousel-expanded`
                            )->a( n = `pageChanged`            v = client->_event( val = `PAGE_CHANGED` arg = `${$parameters>/activePages/0}` )
                            )->a( n = `pageIndicatorPlacement` v = `Top`
                            )->a( n = `showPageIndicator`      v = |\{= !${ client->_bind( is_desktop ) } \}|
                            )->a( n = `pages`                  v = client->_bind( t_comp_products )

                            )->ele( `customLayout`
                                )->tag( `CarouselLayout`
                                    )->a( n = `visiblePagesCount` v = client->_bind( pages_count )

                            )->end(
                            )->ele( n = `Card` ns = `f`
                                )->a( n = `class` v = `sapUiTinyMarginTop`

                                )->ele( n = `header` ns = `f`
                                    )->tag( n = `Header` ns = `cards`
                                        )->a( n = `title`            v = `{NAME}`
                                        )->a( n = `subtitle`         v = `{STATUS}`
                                        )->a( n = `iconSrc`          v = `{PRODUCT_PIC_URL}`
                                        )->a( n = `iconDisplayShape` v = `Square`

                                )->end(
                                )->ele( n = `content` ns = `f`
                                    )->ele( n = `VerticalLayout` ns = `l`
                                        )->a( n = `width` v = `100%`

                                        )->ele( n = `BlockLayout` ns = `l`
                                            )->ele( n = `BlockLayoutRow` ns = `l`
                                                )->ele( n = `BlockLayoutCell` ns = `l`
                                                    )->ele( `HBox`
                                                        )->tag( `Label`
                                                            )->a( n = `text` v = `Supplier:`

                                                    )->end(
                                                    )->ele( `HBox`
                                                        )->a( n = `class` v = `sapUiSmallMarginBottom`

                                                        )->tag( `Text`
                                                            )->a( n = `text` v = `{SUPPLIER_NAME}`

                                                    )->end(
                                                    )->ele( `HBox`
                                                        )->tag( `Label`
                                                            )->a( n = `text` v = `Main Category:`

                                                    )->end(
                                                    )->ele( `HBox`
                                                        )->a( n = `class` v = `sapUiSmallMarginBottom`

                                                        )->tag( `Text`
                                                            )->a( n = `text` v = `{MAIN_CATEGORY}`

                                                    )->end(
                                                    )->ele( `HBox`
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
                                                    )->ele( `HBox`
                                                        )->tag( `Label`
                                                            )->a( n = `text` v = `Width (cm)`

                                                    )->end(
                                                    )->ele( `HBox`
                                                        )->a( n = `class` v = `sapUiSmallMarginBottom`

                                                        )->tag( `Text`
                                                            )->a( n = `text` v = `{WIDTH}`

                                                    )->end(
                                                    )->ele( `HBox`
                                                        )->tag( `Label`
                                                            )->a( n = `text` v = `Height (cm)`

                                                    )->end(
                                                    )->ele( `HBox`
                                                        )->a( n = `class` v = `sapUiSmallMarginBottom`

                                                        )->tag( `Text`
                                                            )->a( n = `text` v = `{HEIGHT}`

                                                    )->end(
                                                    )->ele( `HBox`
                                                        )->tag( `Label`
                                                            )->a( n = `text` v = `Weight (kg)`

                                                    )->end(
                                                    )->ele( `HBox`
                                                        )->a( n = `class` v = `sapUiSmallMarginBottom`

                                                        )->tag( `Text`
                                                            )->a( n = `text` v = `{WEIGHT_MEASURE}`

                                                    )->end(
                                                )->end(
                                            )->end(
                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(
                )->ele( n = `content` ns = `f`
                    )->ele( `List`
                        )->a( n = `id`               v = `listItems`
                        )->a( n = `backgroundDesign` v = `Transparent`
                        )->a( n = `class`            v = `sapUiSmallMarginBottom`
                        )->a( n = `items`            v = client->_bind( t_comp_props )

                        )->ele( `items`
                            )->ele( `CustomListItem`
                                )->a( n = `class` v = `sapUiComparisonContent`

                                )->tag( `Panel`
                                    )->a( n = `expandable` v = `true`
                                    )->a( n = `expanded`   v = `false`
                                    )->a( n = `headerText` v = `{KEY}`
                                    )->a( n = `height`     v = `2.75rem`
                                    )->a( n = `expand`     v = client->_event( val   = `PANEL_EXPANDED`
                                                                               t_arg = temp1 )

                                )->ele( `HBox`
                                    )->a( n = `class`            v = `sapUiTinyMarginTop`
                                    )->a( n = `alignItems`       v = `Start`
                                    )->a( n = `backgroundDesign` v = `Solid`
                                    )->a( n = `items`            v = |\{ path: 'VALUES', templateShareable : true \}|

                                    )->ele( `items`
                                        )->ele( `VBox`
                                            )->a( n = `class` v = `sapUiTinyMarginTopBottom sapUiComparisonItem`

                                            )->ele( `layoutData`
                                                )->tag( `FlexItemData`
                                                    )->a( n = `growFactor` v = `1`
                                                    )->a( n = `baseSize`   v = `0`

                                            )->end(
                                            )->ele( `HBox`
                                                )->tag( `FormattedText`
                                                    )->a( n = `htmlText` v = `{TEXT}`

                                            )->end(
                                            " the controller's onPanelExpanded setVisible replaced by the bound VISIBLE flag per value row
                                            )->ele( `HBox`
                                                )->a( n = `class`   v = `sapUiSmallMarginTop`
                                                )->a( n = `visible` v = `{VISIBLE}`

                                                )->tag( `Text`
                                                    )->a( n = `text` v = `{DESCRIPTION}`

                                            )->end(
                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(
            )->end(
        )->end( ).

    " the original controller's onAfterRendering binding filter: only Laptops are compared
    
    CLEAR temp3.
    INSERT `idProductsTable` INTO TABLE temp3.
    INSERT `items` INTO TABLE temp3.
    INSERT `filter` INTO TABLE temp3.
    INSERT `CATEGORY` INTO TABLE temp3.
    INSERT `EQ` INTO TABLE temp3.
    INSERT `Laptops` INTO TABLE temp3.
    client->follow_up_action( val   = client->cs_event-binding_call
                              t_arg = temp3 ).

    " the original's manifest router, app-owned: the hash stays the app's own
    " (#/Page2, no route prefix), and a hash change the app did not write -
    " browser Back/Forward, a manual edit - round-trips as HASH_CHANGED.
    " Re-asserted per render, since the registration dies with an app switch
    
    CLEAR temp5.
    INSERT `HASH_CHANGED` INTO TABLE temp5.
    client->follow_up_action( val   = client->cs_event-hash_attach_changed
                              t_arg = temp5 ).

    client->view_display( view->stringify( ) ).

    " A Carousel's active page is live control state a rebuilt view resets to
    " page 0, while first_item survives as class state AND drives the bound
    " comparison rows - so after a rebuild the two Carousels show item 0 next to
    " props for items first_item.. Re-issued positionally, the same form the
    " event branch uses (the pages are aggregation-template clones with no id
    " the backend can spell). Guarded, because page 0 is where a fresh view
    " already is. Found by the linter's control-state-lost-on-rebuild rule
    IF first_item > 0.
      
      CLEAR temp7.
      INSERT `carousel-snapped` INTO TABLE temp7.
      INSERT `setActivePage` INTO TABLE temp7.
      
      temp2 = |carousel-snapped/pages/{ first_item }|.
      INSERT temp2 INTO TABLE temp7.
      client->follow_up_action( val   = client->cs_event-control_by_id
                                t_arg = temp7 ).
      
      CLEAR temp9.
      INSERT `carousel-expanded` INTO TABLE temp9.
      INSERT `setActivePage` INTO TABLE temp9.
      
      temp4 = |carousel-expanded/pages/{ first_item }|.
      INSERT temp4 INTO TABLE temp9.
      client->follow_up_action( val   = client->cs_event-control_by_id
                                t_arg = temp9 ).
    ENDIF.

    " the NavContainer's active page is the same class of live control state:
    " a rebuilt view (a restored draft, a return from a called app) is back on
    " the first page while check_page2 survives as class state
    IF check_page2 = abap_true.
      
      CLEAR temp11.
      INSERT `rootControl` INTO TABLE temp11.
      INSERT `to` INTO TABLE temp11.
      INSERT `page-comparison` INTO TABLE temp11.
      client->follow_up_action( val   = client->cs_event-control_by_id
                                t_arg = temp11 ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.
        DATA selected_count TYPE i.
        DATA temp13 TYPE string_table.
            DATA temp15 TYPE string_table.
          DATA temp17 TYPE string_table.
        DATA page_arg TYPE string.
        DATA temp19 TYPE string_table.
        DATA temp5 LIKE LINE OF temp19.
        DATA temp21 TYPE string_table.
        DATA temp6 LIKE LINE OF temp21.
        DATA prop_key TYPE string.
        DATA expanded TYPE string.
        FIELD-SYMBOLS <s_prop> TYPE z2ui5_cl_smpc_app_012=>ty_s_comp_prop.
          FIELD-SYMBOLS <s_value> LIKE LINE OF <s_prop>-values.

    CASE client->get_event( ).

      WHEN `SELECTION`.
        
        selected_count = 0.
        LOOP AT t_products TRANSPORTING NO FIELDS WHERE selected = abap_true.
          selected_count = selected_count + 1.
        ENDLOOP.
        IF selected_count > 1.
          compare_text    = |Compare ({ selected_count })|.
          compare_visible = abap_true.
        ELSE.
          compare_visible = abap_false.
        ENDIF.

      WHEN `COMPARE`.
        comparison_build( ).
        check_page2 = abap_true.
        " the router's navTo("page2") mapped to the NavContainer `to` frontend action
        
        CLEAR temp13.
        INSERT `rootControl` INTO TABLE temp13.
        INSERT `to` INTO TABLE temp13.
        INSERT `page-comparison` INTO TABLE temp13.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = temp13 ).
        " navTo also writes the router's hash: with the hash listener
        " registered this pushes the app-owned `#/Page2` - the original's URL
        " 1:1 - as a real history entry, so browser Back has somewhere to go
        client->hash_set( `/Page2` ).

      WHEN `HASH_CHANGED`.
        " browser Back/Forward (or a manual edit) moved the app-owned hash -
        " the router's routeMatched: show the page the hash now names. The
        " hash rides in s_config-hash with this very request; the app
        " instance is untouched, so the selection survives like with the
        " original's client-side router
        IF client->get( )-s_config-hash CS `/Page2`.
          IF check_page2 = abap_false.
            comparison_build( ).
            check_page2 = abap_true.
            
            CLEAR temp15.
            INSERT `rootControl` INTO TABLE temp15.
            INSERT `to` INTO TABLE temp15.
            INSERT `page-comparison` INTO TABLE temp15.
            client->follow_up_action( val   = client->cs_event-control_by_id
                                      t_arg = temp15 ).
          ENDIF.
        ELSEIF check_page2 = abap_true.
          check_page2 = abap_false.
          " NavContainer `back` pops the page the `to` above pushed
          
          CLEAR temp17.
          INSERT `rootControl` INTO TABLE temp17.
          INSERT `back` INTO TABLE temp17.
          client->follow_up_action( val   = client->cs_event-control_by_id
                                    t_arg = temp17 ).
        ENDIF.

      WHEN `PAGE_CHANGED`.
        
        page_arg = client->get_event_arg( ).
        IF page_arg CO `0123456789`.
          first_item = page_arg.
        ELSE.
          first_item = 0.
        ENDIF.
        comparison_props_build( ).
        " _updateCarouselsActivePage: the original keeps the two Carousels in
        " step by handing each its own page AT THE SAME INDEX
        " (carousel.setActivePage( carousel.getPages()[ iFirstItem ] )). Those
        " pages are aggregation-template CLONES with no id the backend can
        " spell, so they are addressed positionally since 2026-08-06
        
        CLEAR temp19.
        INSERT `carousel-snapped` INTO TABLE temp19.
        INSERT `setActivePage` INTO TABLE temp19.
        
        temp5 = |carousel-snapped/pages/{ first_item }|.
        INSERT temp5 INTO TABLE temp19.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = temp19 ).
        
        CLEAR temp21.
        INSERT `carousel-expanded` INTO TABLE temp21.
        INSERT `setActivePage` INTO TABLE temp21.
        
        temp6 = |carousel-expanded/pages/{ first_item }|.
        INSERT temp6 INTO TABLE temp21.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = temp21 ).

      WHEN `PANEL_EXPANDED`.
        
        prop_key = client->get_event_arg( ).
        
        expanded = client->get_event_arg( 2 ).
        
        READ TABLE t_comp_props ASSIGNING <s_prop> WITH KEY key = prop_key.
        IF sy-subrc = 0.
          
          LOOP AT <s_prop>-values ASSIGNING <s_value>.
            <s_value>-visible = expanded.
          ENDLOOP.
        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD comparison_build.

    DATA temp23 TYPE z2ui5_cl_smpc_app_012=>ty_t_product.
    DATA s_product LIKE LINE OF t_products.
    DATA width TYPE z2ui5_if_client=>ty_s_get-s_device-resize-width.
    DATA temp1 TYPE xsdboolean.
    CLEAR temp23.
    t_comp_products = temp23.
    
    LOOP AT t_products INTO s_product WHERE selected = abap_true.
      APPEND s_product TO t_comp_products.
    ENDLOOP.

    " the original's ResizeHandler-driven _getPagesCount (600/1024 thresholds), computed once from the reported device width
    
    width = client->get( )-s_device-resize-width.
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
    " a cold #/Page2 (deep link, reload) has no selection: the original's
    " settings model is then empty and visiblePagesCount falls back to its
    " UI5 default 1 - a computed 0 would be an invalid CarouselLayout count
    IF pages_count < 1.
      pages_count = 1.
    ENDIF.
    
    temp1 = boolc( pages_count = 4 ).
    is_desktop = temp1.

    first_item = 0.
    comparison_props_build( ).

  ENDMETHOD.


  METHOD comparison_props_build.

    " the original iterates the first selected product's JSON keys (except ProductPicUrl); here the same keys as a fixed list
    DATA temp24 TYPE ty_t_key.
    DATA temp25 LIKE LINE OF temp24.
    DATA t_keys LIKE temp24.
    DATA from_item TYPE i.
    DATA last_item TYPE i.
    DATA temp26 TYPE z2ui5_cl_smpc_app_012=>ty_t_comp_prop.
    DATA s_key LIKE LINE OF t_keys.
      DATA temp27 TYPE ty_s_comp_prop.
      DATA s_prop LIKE temp27.
      DATA s_product LIKE LINE OF t_comp_products.
        FIELD-SYMBOLS <value> TYPE any.
          DATA temp28 TYPE z2ui5_cl_smpc_app_012=>ty_s_comp_value.
    CLEAR temp24.
    
    temp25-key = `ProductId`.
    temp25-field = `PRODUCT_ID`.
    INSERT temp25 INTO TABLE temp24.
    temp25-key = `Category`.
    temp25-field = `CATEGORY`.
    INSERT temp25 INTO TABLE temp24.
    temp25-key = `MainCategory`.
    temp25-field = `MAIN_CATEGORY`.
    INSERT temp25 INTO TABLE temp24.
    temp25-key = `TaxTarifCode`.
    temp25-field = `TAX_TARIF_CODE`.
    INSERT temp25 INTO TABLE temp24.
    temp25-key = `SupplierName`.
    temp25-field = `SUPPLIER_NAME`.
    INSERT temp25 INTO TABLE temp24.
    temp25-key = `WeightMeasure`.
    temp25-field = `WEIGHT_MEASURE`.
    INSERT temp25 INTO TABLE temp24.
    temp25-key = `WeightUnit`.
    temp25-field = `WEIGHT_UNIT`.
    INSERT temp25 INTO TABLE temp24.
    temp25-key = `Description`.
    temp25-field = `DESCRIPTION`.
    INSERT temp25 INTO TABLE temp24.
    temp25-key = `Name`.
    temp25-field = `NAME`.
    INSERT temp25 INTO TABLE temp24.
    temp25-key = `DateOfSale`.
    temp25-field = `DATE_OF_SALE`.
    INSERT temp25 INTO TABLE temp24.
    temp25-key = `Status`.
    temp25-field = `STATUS`.
    INSERT temp25 INTO TABLE temp24.
    temp25-key = `Quantity`.
    temp25-field = `QUANTITY`.
    INSERT temp25 INTO TABLE temp24.
    temp25-key = `UoM`.
    temp25-field = `UOM`.
    INSERT temp25 INTO TABLE temp24.
    temp25-key = `CurrencyCode`.
    temp25-field = `CURRENCY_CODE`.
    INSERT temp25 INTO TABLE temp24.
    temp25-key = `Price`.
    temp25-field = `PRICE`.
    INSERT temp25 INTO TABLE temp24.
    temp25-key = `Width`.
    temp25-field = `WIDTH`.
    INSERT temp25 INTO TABLE temp24.
    temp25-key = `Depth`.
    temp25-field = `DEPTH`.
    INSERT temp25 INTO TABLE temp24.
    temp25-key = `Height`.
    temp25-field = `HEIGHT`.
    INSERT temp25 INTO TABLE temp24.
    temp25-key = `DimUnit`.
    temp25-field = `DIM_UNIT`.
    INSERT temp25 INTO TABLE temp24.
    
    t_keys = temp24.

    
    from_item = first_item + 1.
    
    last_item = first_item + pages_count.
    IF last_item > lines( t_comp_products ).
      last_item = lines( t_comp_products ).
    ENDIF.

    
    CLEAR temp26.
    t_comp_props = temp26.
    " the original's cold #/Page2 renders BOTH lists empty ('no data') - its
    " Props are built per selected product, so no product means no rows, not
    " nineteen property panels with empty value lists
    IF t_comp_products IS INITIAL.
      RETURN.
    ENDIF.
    
    LOOP AT t_keys INTO s_key.
      
      CLEAR temp27.
      temp27-key = s_key-key.
      
      s_prop = temp27.
      
      LOOP AT t_comp_products FROM from_item TO last_item INTO s_product.
        
        ASSIGN COMPONENT s_key-field OF STRUCTURE s_product TO <value>.
        IF sy-subrc = 0.
          
          CLEAR temp28.
          temp28-text = |<strong>{ <value> }</strong>|.
          temp28-description = `Some description of the property here`.
          temp28-visible = abap_false.
          APPEND temp28 TO s_prop-values.
        ENDIF.
      ENDLOOP.
      APPEND s_prop TO t_comp_props.
    ENDLOOP.

  ENDMETHOD.


  METHOD model_init.

    " the full mock /ProductCollection (sap/ui/demo/mock/products.json); the table binding filters to Category = Laptops (onAfterRendering), as the original loads all rows and filters client-side
    " ProductPicUrl resolved to absolute OpenUI5 URLs (the sample's .formatter.url)
    DATA temp29 TYPE z2ui5_cl_smpc_app_012=>ty_t_product.
    DATA temp30 LIKE LINE OF temp29.
    CLEAR temp29.
    
    temp30-product_id = `HT-1000`.
    temp30-category = `Laptops`.
    temp30-main_category = `Computer Systems`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Very Best Screens`.
    temp30-weight_measure = `4.2`.
    temp30-weight_unit = `KG`.
    temp30-description = `Notebook Basic 15 with 2,80 GHz quad core, 15" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`.
    temp30-name = `Notebook Basic 15`.
    temp30-date_of_sale = `2017-03-26`.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `10`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `956.00`.
    temp30-width = `30`.
    temp30-depth = `18`.
    temp30-height = `3`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1001`.
    temp30-category = `Laptops`.
    temp30-main_category = `Computer Systems`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Very Best Screens`.
    temp30-weight_measure = `4.5`.
    temp30-weight_unit = `KG`.
    temp30-description = `Notebook Basic 17 with 2,80 GHz quad core, 17" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`.
    temp30-name = `Notebook Basic 17`.
    temp30-date_of_sale = `2017-04-17`.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1001.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `20`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `1249.00`.
    temp30-width = `29`.
    temp30-depth = `17`.
    temp30-height = `3.1`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1002`.
    temp30-category = `Laptops`.
    temp30-main_category = `Computer Systems`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Very Best Screens`.
    temp30-weight_measure = `4.2`.
    temp30-weight_unit = `KG`.
    temp30-description = `Notebook Basic 18 with 2,80 GHz quad core, 18" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro`.
    temp30-name = `Notebook Basic 18`.
    temp30-date_of_sale = `2017-01-07`.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1002.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `10`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `1570.00`.
    temp30-width = `28`.
    temp30-depth = `19`.
    temp30-height = `2.5`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1003`.
    temp30-category = `Laptops`.
    temp30-main_category = `Computer Systems`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Smartcards`.
    temp30-weight_measure = `4.2`.
    temp30-weight_unit = `KG`.
    temp30-description = `Notebook Basic 19 with 2,80 GHz quad core, 19" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro`.
    temp30-name = `Notebook Basic 19`.
    temp30-date_of_sale = `2017-04-09`.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1003.jpg`.
    temp30-status = `Out of Stock`.
    temp30-quantity = `15`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `1650.00`.
    temp30-width = `32`.
    temp30-depth = `21`.
    temp30-height = `4`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1007`.
    temp30-category = `Accessories`.
    temp30-main_category = `Computer Components`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Technocom`.
    temp30-weight_measure = `0.2`.
    temp30-weight_unit = `KG`.
    temp30-description = `Digital Organizer with State-of-the-Art Storage Encryption`.
    temp30-name = `ITelO Vault`.
    temp30-date_of_sale = `2017-05-17`.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1007.jpg`.
    temp30-status = `Out of Stock`.
    temp30-quantity = `15`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `299.00`.
    temp30-width = `32`.
    temp30-depth = `22`.
    temp30-height = `3`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1010`.
    temp30-category = `Accessories`.
    temp30-main_category = `Computer Systems`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Very Best Screens`.
    temp30-weight_measure = `4.3`.
    temp30-weight_unit = `KG`.
    temp30-description = `Notebook Professional 15 with 2,80 GHz quad core, 15" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro`.
    temp30-name = `Notebook Professional 15`.
    temp30-date_of_sale = `2017-02-22`.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg`.
    temp30-status = `Out of Stock`.
    temp30-quantity = `16`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `1999.00`.
    temp30-width = `33`.
    temp30-depth = `20`.
    temp30-height = `3`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1011`.
    temp30-category = `Laptops`.
    temp30-main_category = `Computer Systems`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Very Best Screens`.
    temp30-weight_measure = `4.1`.
    temp30-weight_unit = `KG`.
    temp30-description = `Notebook Professional 17 with 2,80 GHz quad core, 17" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro`.
    temp30-name = `Notebook Professional 17`.
    temp30-date_of_sale = `2017-01-02`.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1011.jpg`.
    temp30-status = `Out of Stock`.
    temp30-quantity = `17`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `2299.00`.
    temp30-width = `33`.
    temp30-depth = `23`.
    temp30-height = `2`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1020`.
    temp30-category = `Accessories`.
    temp30-main_category = `Computer Components`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Technocom`.
    temp30-weight_measure = `0.16`.
    temp30-weight_unit = `KG`.
    temp30-description = `Digital Organizer with State-of-the-Art Encryption for Storage and Network Communications`.
    temp30-name = `ITelO Vault Net`.
    temp30-date_of_sale = `2017-05-08`.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1020.jpg`.
    temp30-status = `Discontinued`.
    temp30-quantity = `14`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `459.00`.
    temp30-width = `10`.
    temp30-depth = `1.8`.
    temp30-height = `17`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1021`.
    temp30-category = `Accessories`.
    temp30-main_category = `Computer Components`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Technocom`.
    temp30-weight_measure = `0.18`.
    temp30-weight_unit = `KG`.
    temp30-description = `Digital Organizer with State-of-the-Art Encryption for Storage and Secure Stellite Link`.
    temp30-name = `ITelO Vault SAT`.
    temp30-date_of_sale = `2017-06-30`.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1021.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `50`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `149.00`.
    temp30-width = `11`.
    temp30-depth = `1.7`.
    temp30-height = `18`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1022`.
    temp30-category = `Accessories`.
    temp30-main_category = `Computer Components`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Technocom`.
    temp30-weight_measure = `0.2`.
    temp30-weight_unit = `KG`.
    temp30-description = `32 GB Digital Assistant with high-resolution color screen`.
    temp30-name = `Comfort Easy`.
    temp30-date_of_sale = `2017-03-02`.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1022.jpg`.
    temp30-status = `Out of Stock`.
    temp30-quantity = `30`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `1679.00`.
    temp30-width = `84`.
    temp30-depth = `1.5`.
    temp30-height = `14`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1023`.
    temp30-category = `Accessories`.
    temp30-main_category = `Computer Components`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Technocom`.
    temp30-weight_measure = `0.8`.
    temp30-weight_unit = `KG`.
    temp30-description = `64 GB Digital Assistant with high-resolution color screen and synthesized voice output`.
    temp30-name = `Comfort Senior`.
    temp30-date_of_sale = `2017-02-25`.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1023.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `24`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `512.00`.
    temp30-width = `80`.
    temp30-depth = `1.6`.
    temp30-height = `13`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1030`.
    temp30-category = `Flat Screen Monitors`.
    temp30-main_category = `Computer Components`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Very Best Screens`.
    temp30-weight_measure = `21`.
    temp30-weight_unit = `KG`.
    temp30-description = `Optimum Hi-Resolution max. 1920 x 1080 @ 85Hz, Dot Pitch: 0.27mm`.
    temp30-name = `Ergo Screen E-I`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1030.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `14`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `230.00`.
    temp30-width = `37`.
    temp30-depth = `12`.
    temp30-height = `36`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1031`.
    temp30-category = `Flat Screen Monitors`.
    temp30-main_category = `Computer Components`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Very Best Screens`.
    temp30-weight_measure = `21`.
    temp30-weight_unit = `KG`.
    temp30-description = `Optimum Hi-Resolution max. 1920 x 1200 @ 85Hz, Dot Pitch: 0.26mm`.
    temp30-name = `Ergo Screen E-II`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1031.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `24`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `285.00`.
    temp30-width = `40.8`.
    temp30-depth = `19`.
    temp30-height = `43`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1032`.
    temp30-category = `Flat Screen Monitors`.
    temp30-main_category = `Computer Components`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Very Best Screens`.
    temp30-weight_measure = `21`.
    temp30-weight_unit = `KG`.
    temp30-description = `Optimum Hi-Resolution max. 2560 x 1440 @ 85Hz, Dot Pitch: 0.25mm`.
    temp30-name = `Ergo Screen E-III`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1032.jpg`.
    temp30-status = `Out of Stock`.
    temp30-quantity = `50`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `345.00`.
    temp30-width = `40.8`.
    temp30-depth = `19`.
    temp30-height = `43`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1035`.
    temp30-category = `Flat Screen Monitors`.
    temp30-main_category = `Computer Components`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Very Best Screens`.
    temp30-weight_measure = `14`.
    temp30-weight_unit = `KG`.
    temp30-description = `Optimum Hi-Resolution max. 1600 x 1200 @ 85Hz, Dot Pitch: 0.24mm`.
    temp30-name = `Flat Basic`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1035.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `23`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `399.00`.
    temp30-width = `39`.
    temp30-depth = `20`.
    temp30-height = `41`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1036`.
    temp30-category = `Flat Screen Monitors`.
    temp30-main_category = `Computer Components`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Very Best Screens`.
    temp30-weight_measure = `15`.
    temp30-weight_unit = `KG`.
    temp30-description = `Optimum Hi-Resolution max. 2048 x 1080 @ 85Hz, Dot Pitch: 0.26mm`.
    temp30-name = `Flat Future`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1036.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `22`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `430.00`.
    temp30-width = `45`.
    temp30-depth = `26`.
    temp30-height = `46`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1037`.
    temp30-category = `Flat Screen Monitors`.
    temp30-main_category = `Computer Components`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Very Best Screens`.
    temp30-weight_measure = `17`.
    temp30-weight_unit = `KG`.
    temp30-description = `Optimum Hi-Resolution max. 2016 x 1512 @ 85Hz, Dot Pitch: 0.24mm`.
    temp30-name = `Flat XL`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1037.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `23`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `1230.00`.
    temp30-width = `54.5`.
    temp30-depth = `22.1`.
    temp30-height = `39.1`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1040`.
    temp30-category = `Printers`.
    temp30-main_category = `Printers & Scanners`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Alpha Printers`.
    temp30-weight_measure = `32`.
    temp30-weight_unit = `KG`.
    temp30-description = `Print 2400 dpi image quality color documents at speeds of up to 32 ppm (color) or 36 ppm (monochrome), letter/A4. Powerful 500 MHz processor, 512MB of memory`.
    temp30-name = `Laser Professional Eco`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1040.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `21`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `830.00`.
    temp30-width = `51`.
    temp30-depth = `46`.
    temp30-height = `30`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1041`.
    temp30-category = `Printers`.
    temp30-main_category = `Printers & Scanners`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Alpha Printers`.
    temp30-weight_measure = `23`.
    temp30-weight_unit = `KG`.
    temp30-description = `Up to 22 ppm color or 24 ppm monochrome A4/letter, powerful 500 MHz processor and 128MB of memory`.
    temp30-name = `Laser Basic`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1041.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `8`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `490.00`.
    temp30-width = `48`.
    temp30-depth = `42`.
    temp30-height = `26`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1042`.
    temp30-category = `Printers`.
    temp30-main_category = `Printers & Scanners`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Alpha Printers`.
    temp30-weight_measure = `17`.
    temp30-weight_unit = `KG`.
    temp30-description = `Print up to 25 ppm letter and 24 ppm A4 color or monochrome, with Available first-page-out-time of less than 13 seconds for monochrome and less than 15 seconds for color`.
    temp30-name = `Laser Allround`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1042.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `9`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `349.00`.
    temp30-width = `53`.
    temp30-depth = `50`.
    temp30-height = `65`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1050`.
    temp30-category = `Printers`.
    temp30-main_category = `Printers & Scanners`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Alpha Printers`.
    temp30-weight_measure = `3`.
    temp30-weight_unit = `KG`.
    temp30-description = `4800 dpi x 1200 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB, Ethernet`.
    temp30-name = `Ultra Jet Super Color`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1050.jpg`.
    temp30-status = `Discontinued`.
    temp30-quantity = `17`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `139.00`.
    temp30-width = `41`.
    temp30-depth = `41`.
    temp30-height = `28`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1051`.
    temp30-category = `Printers`.
    temp30-main_category = `Printers & Scanners`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Printer for All`.
    temp30-weight_measure = `1.9`.
    temp30-weight_unit = `KG`.
    temp30-description = `1000 dpi x 1000 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB - excellent dimensions for the small office`.
    temp30-name = `Ultra Jet Mobile`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1051.jpg`.
    temp30-status = `Discontinued`.
    temp30-quantity = `18`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `99.00`.
    temp30-width = `46`.
    temp30-depth = `32`.
    temp30-height = `25`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1052`.
    temp30-category = `Printers`.
    temp30-main_category = `Printers & Scanners`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Printer for All`.
    temp30-weight_measure = `18`.
    temp30-weight_unit = `KG`.
    temp30-description = `4800 dpi x 1200 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB2.0, Ethernet`.
    temp30-name = `Ultra Jet Super Highspeed`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1052.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `25`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `170.00`.
    temp30-width = `41`.
    temp30-depth = `41`.
    temp30-height = `28`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1055`.
    temp30-category = `Multifunction Printers`.
    temp30-main_category = `Printers & Scanners`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Printer for All`.
    temp30-weight_measure = `6.3`.
    temp30-weight_unit = `KG`.
    temp30-description = `1000 dpi x 1000 dpi - up to 16 ppm (mono) / up to 15 ppm (color)- capacity 80 sheets - scanner (216 x 297 mm, 1200dpi x 2400dpi)`.
    temp30-name = `Multi Print`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1055.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `16`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `99.00`.
    temp30-width = `55`.
    temp30-depth = `45`.
    temp30-height = `29`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1056`.
    temp30-category = `Multifunction Printers`.
    temp30-main_category = `Printers & Scanners`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Printer for All`.
    temp30-weight_measure = `4.3`.
    temp30-weight_unit = `KG`.
    temp30-description = `1200 dpi x 1200 dpi - up to 25 ppm (mono) / up to 24 ppm (color)- capacity 80 sheets - scanner (216 x 297 mm, 2400dpi x 4800dpi, high resolution)`.
    temp30-name = `Multi Color`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1056.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `5`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `119.00`.
    temp30-width = `51`.
    temp30-depth = `41.3`.
    temp30-height = `22`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1060`.
    temp30-category = `Mice`.
    temp30-main_category = `Computer Components`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Oxynum`.
    temp30-weight_measure = `0.09`.
    temp30-weight_unit = `KG`.
    temp30-description = `Cordless Optical USB Mice, Laptop, Color: Black, Plug&Play`.
    temp30-name = `Cordless Mouse`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1060.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `25`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `9.00`.
    temp30-width = `6`.
    temp30-depth = `14.5`.
    temp30-height = `3.5`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1061`.
    temp30-category = `Mice`.
    temp30-main_category = `Computer Components`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Oxynum`.
    temp30-weight_measure = `0.09`.
    temp30-weight_unit = `KG`.
    temp30-description = `Optical USB, PS/2 Mouse, Color: Blue, 3-button-functionality (incl. Scroll wheel)`.
    temp30-name = `Speed Mouse`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1061.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `12`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `7.00`.
    temp30-width = `7`.
    temp30-depth = `15`.
    temp30-height = `3.1`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1062`.
    temp30-category = `Mice`.
    temp30-main_category = `Computer Components`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Oxynum`.
    temp30-weight_measure = `0.03`.
    temp30-weight_unit = `KG`.
    temp30-description = `Optical USB Mouse, Color: Red, 5-button-functionality(incl. Scroll wheel), Plug&Play`.
    temp30-name = `Track Mouse`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1062.jpg`.
    temp30-status = `Discontinued`.
    temp30-quantity = `12`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `11.00`.
    temp30-width = `3`.
    temp30-depth = `7`.
    temp30-height = `4`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1063`.
    temp30-category = `Keyboards`.
    temp30-main_category = `Computer Components`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Oxynum`.
    temp30-weight_measure = `2.1`.
    temp30-weight_unit = `KG`.
    temp30-description = `Ergonomic USB Keyboard for Desktop, Plug&Play`.
    temp30-name = `Ergonomic Keyboard`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1063.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `50`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `14.00`.
    temp30-width = `50`.
    temp30-depth = `21`.
    temp30-height = `3.5`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1064`.
    temp30-category = `Keyboards`.
    temp30-main_category = `Computer Components`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Oxynum`.
    temp30-weight_measure = `1.8`.
    temp30-weight_unit = `KG`.
    temp30-description = `Corded Keyboard with special keys for Internet Usability, USB`.
    temp30-name = `Internet Keyboard`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1064.jpg`.
    temp30-status = `Out of Stock`.
    temp30-quantity = `35`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `16.00`.
    temp30-width = `52`.
    temp30-depth = `25`.
    temp30-height = `3`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1065`.
    temp30-category = `Keyboards`.
    temp30-main_category = `Computer Components`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Oxynum`.
    temp30-weight_measure = `2.3`.
    temp30-weight_unit = `KG`.
    temp30-description = `Corded Ergonomic Keyboard with special keys for Media Usability, USB`.
    temp30-name = `Media Keyboard`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1065.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `26`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `26.00`.
    temp30-width = `51.4`.
    temp30-depth = `23`.
    temp30-height = `4`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1066`.
    temp30-category = `Mousepads`.
    temp30-main_category = `Computer Components`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Oxynum`.
    temp30-weight_measure = `80`.
    temp30-weight_unit = `G`.
    temp30-description = `Nice mouse pad with ITelO Logo`.
    temp30-name = `Mousepad`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1066.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `12`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `6.99`.
    temp30-width = `15`.
    temp30-depth = `6`.
    temp30-height = `0.2`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1067`.
    temp30-category = `Mousepads`.
    temp30-main_category = `Computer Components`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Oxynum`.
    temp30-weight_measure = `80`.
    temp30-weight_unit = `G`.
    temp30-description = `Ergonomic mouse pad with ITelO Logo`.
    temp30-name = `Ergo Mousepad`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1067.jpg`.
    temp30-status = `Out of Stock`.
    temp30-quantity = `16`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `8.99`.
    temp30-width = `15`.
    temp30-depth = `6`.
    temp30-height = `0.2`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1068`.
    temp30-category = `Mousepads`.
    temp30-main_category = `Computer Components`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Fasttech`.
    temp30-weight_measure = `90`.
    temp30-weight_unit = `G`.
    temp30-description = `ITelO Mousepad Special Edition`.
    temp30-name = `Designer Mousepad`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1068.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `26`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `12.99`.
    temp30-width = `24`.
    temp30-depth = `24`.
    temp30-height = `0.6`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1069`.
    temp30-category = `Computer System Accessories`.
    temp30-main_category = `Computer Systems`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Fasttech`.
    temp30-weight_measure = `45`.
    temp30-weight_unit = `G`.
    temp30-description = `Universal card reader`.
    temp30-name = `Universal card reader`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1069.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `22`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `14.00`.
    temp30-width = `6`.
    temp30-depth = `6`.
    temp30-height = `3`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1070`.
    temp30-category = `Graphic Cards`.
    temp30-main_category = `Computer Components`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Ultrasonic United`.
    temp30-weight_measure = `0.255`.
    temp30-weight_unit = `KG`.
    temp30-description = `Proctra X: PCI-E GDDR5 3072MB`.
    temp30-name = `Proctra X`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1070.jpg`.
    temp30-status = `Out of Stock`.
    temp30-quantity = `15`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `70.90`.
    temp30-width = `22`.
    temp30-depth = `35`.
    temp30-height = `17`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1071`.
    temp30-category = `Graphic Cards`.
    temp30-main_category = `Computer Components`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Ultrasonic United`.
    temp30-weight_measure = `0.3`.
    temp30-weight_unit = `KG`.
    temp30-description = `Gladiator XLN: PCI-E GDDR5 3072MB DVI Out, TV Out low-noise`.
    temp30-name = `Gladiator MX`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1071.jpg`.
    temp30-status = `Discontinued`.
    temp30-quantity = `16`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `81.70`.
    temp30-width = `22`.
    temp30-depth = `35`.
    temp30-height = `17`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1072`.
    temp30-category = `Graphic Cards`.
    temp30-main_category = `Computer Components`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Ultrasonic United`.
    temp30-weight_measure = `0.4`.
    temp30-weight_unit = `KG`.
    temp30-description = `Hurricane GX: PCI-E 691 GFLOPS game-optimized`.
    temp30-name = `Hurricane GX`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1072.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `13`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `101.20`.
    temp30-width = `22`.
    temp30-depth = `35`.
    temp30-height = `17`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1073`.
    temp30-category = `Graphic Cards`.
    temp30-main_category = `Computer Components`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Smartcards`.
    temp30-weight_measure = `0.4`.
    temp30-weight_unit = `KG`.
    temp30-description = `Hurricane GX/LN: PCI-E 691 GFLOPS game-optimized, low-noise.`.
    temp30-name = `Hurricane GX/LN`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1073.jpg`.
    temp30-status = `Out of Stock`.
    temp30-quantity = `5`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `139.99`.
    temp30-width = `22`.
    temp30-depth = `35`.
    temp30-height = `17`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1080`.
    temp30-category = `Scanners`.
    temp30-main_category = `Printers & Scanners`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Printer for All`.
    temp30-weight_measure = `2.3`.
    temp30-weight_unit = `KG`.
    temp30-description = `Flatbed scanner - 9.600 × 9.600 dpi - 216 x 297 mm - Hi-Speed USB - Bluetooth`.
    temp30-name = `Photo Scan`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1080.jpg`.
    temp30-status = `Out of Stock`.
    temp30-quantity = `8`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `129.00`.
    temp30-width = `34`.
    temp30-depth = `48`.
    temp30-height = `5`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1081`.
    temp30-category = `Scanners`.
    temp30-main_category = `Printers & Scanners`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Printer for All`.
    temp30-weight_measure = `2.4`.
    temp30-weight_unit = `KG`.
    temp30-description = `Flatbed scanner - 9.600 × 9.600 dpi - 216 x 297 mm - SCSI for backward compatibility`.
    temp30-name = `Power Scan`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1081.jpg`.
    temp30-status = `Out of Stock`.
    temp30-quantity = `11`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `89.00`.
    temp30-width = `31`.
    temp30-depth = `43`.
    temp30-height = `7`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1082`.
    temp30-category = `Scanners`.
    temp30-main_category = `Printers & Scanners`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Printer for All`.
    temp30-weight_measure = `3.2`.
    temp30-weight_unit = `KG`.
    temp30-description = `Flatbed scanner - Letter - 2400 dpi x 2400 dpi - 216 x 297 mm - add-on module`.
    temp30-name = `Jet Scan Professional`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1082.jpg`.
    temp30-status = `Out of Stock`.
    temp30-quantity = `13`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `169.00`.
    temp30-width = `33`.
    temp30-depth = `41`.
    temp30-height = `12`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1083`.
    temp30-category = `Scanners`.
    temp30-main_category = `Printers & Scanners`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Printer for All`.
    temp30-weight_measure = `3.2`.
    temp30-weight_unit = `KG`.
    temp30-description = `Flatbed scanner - A4 - 2400 dpi x 2400 dpi - 216 x 297 mm - add-on module`.
    temp30-name = `Jet Scan Professional`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1083.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `10`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `189.00`.
    temp30-width = `35`.
    temp30-depth = `40`.
    temp30-height = `10`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1085`.
    temp30-category = `Multifunction Printers`.
    temp30-main_category = `Printers & Scanners`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Alpha Printers`.
    temp30-weight_measure = `23.2`.
    temp30-weight_unit = `KG`.
    temp30-description = `Copymaster`.
    temp30-name = `Copymaster`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1085.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `10`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `1499.00`.
    temp30-width = `45`.
    temp30-depth = `42`.
    temp30-height = `22`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1090`.
    temp30-category = `Speakers`.
    temp30-main_category = `Computer Components`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Speaker Experts`.
    temp30-weight_measure = `3`.
    temp30-weight_unit = `KG`.
    temp30-description = `PC multimedia speakers - 5 Watt (Total)`.
    temp30-name = `Surround Sound`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1090.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `20`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `39.00`.
    temp30-width = `12`.
    temp30-depth = `10`.
    temp30-height = `16`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1091`.
    temp30-category = `Speakers`.
    temp30-main_category = `Computer Components`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Speaker Experts`.
    temp30-weight_measure = `1.4`.
    temp30-weight_unit = `KG`.
    temp30-description = `PC multimedia speakers - 10 Watt (Total) - 2-way`.
    temp30-name = `Blaster Extreme`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1091.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `15`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `26.00`.
    temp30-width = `13`.
    temp30-depth = `11`.
    temp30-height = `17.5`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1092`.
    temp30-category = `Speakers`.
    temp30-main_category = `Computer Components`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Speaker Experts`.
    temp30-weight_measure = `2.1`.
    temp30-weight_unit = `KG`.
    temp30-description = `PC multimedia speakers - optimized for Blutooth/A2DP`.
    temp30-name = `Sound Booster`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1092.jpg`.
    temp30-status = `Discontinued`.
    temp30-quantity = `50`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `45.00`.
    temp30-width = `12.4`.
    temp30-depth = `10.4`.
    temp30-height = `18.1`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1095`.
    temp30-category = `Accessories`.
    temp30-main_category = `Computer Components`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Fasttech`.
    temp30-weight_measure = `80`.
    temp30-weight_unit = `G`.
    temp30-description = `5.1 Headset, 40 Hz-20 kHz, Wireless`.
    temp30-name = `Lovely Sound 5.1 Wireless`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1095.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `12`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `49.00`.
    temp30-width = `24`.
    temp30-depth = `19`.
    temp30-height = `23`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1096`.
    temp30-category = `Accessories`.
    temp30-main_category = `Computer Components`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Fasttech`.
    temp30-weight_measure = `130`.
    temp30-weight_unit = `G`.
    temp30-description = `5.1 Headset, 40 Hz-20 kHz, 3m cable`.
    temp30-name = `Lovely Sound 5.1`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1096.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `18`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `39.00`.
    temp30-width = `25`.
    temp30-depth = `17`.
    temp30-height = `19`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1097`.
    temp30-category = `Accessories`.
    temp30-main_category = `Computer Components`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Fasttech`.
    temp30-weight_measure = `60`.
    temp30-weight_unit = `G`.
    temp30-description = `5.1 Headset, 40 Hz-20 kHz, 1m cable`.
    temp30-name = `Lovely Sound Stereo`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1097.jpg`.
    temp30-status = `Out of Stock`.
    temp30-quantity = `21`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `29.00`.
    temp30-width = `21.3`.
    temp30-depth = `2.4`.
    temp30-height = `19.7`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1100`.
    temp30-category = `Software`.
    temp30-main_category = `Software`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Technocom`.
    temp30-weight_measure = `1.2`.
    temp30-weight_unit = `KG`.
    temp30-description = `Complete package, 1 User, Office Applications (word processing, spreadsheet, presentations)`.
    temp30-name = `Smart Office`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1100.jpg`.
    temp30-status = `Out of Stock`.
    temp30-quantity = `25`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `89.90`.
    temp30-width = `15`.
    temp30-depth = `6.5`.
    temp30-height = `2.1`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1101`.
    temp30-category = `Software`.
    temp30-main_category = `Software`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Technocom`.
    temp30-weight_measure = `0.8`.
    temp30-weight_unit = `KG`.
    temp30-description = `Complete package, 1 User, Image editing, processing`.
    temp30-name = `Smart Design`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1101.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `26`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `79.90`.
    temp30-width = `14`.
    temp30-depth = `6.7`.
    temp30-height = `24`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1102`.
    temp30-category = `Software`.
    temp30-main_category = `Software`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Technocom`.
    temp30-weight_measure = `0.8`.
    temp30-weight_unit = `KG`.
    temp30-description = `Complete package, 1 User, Network Software Utilities, Useful Applications and Documentation`.
    temp30-name = `Smart Network`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1102.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `28`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `69.00`.
    temp30-width = `16`.
    temp30-depth = `6`.
    temp30-height = `27`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1103`.
    temp30-category = `Software`.
    temp30-main_category = `Software`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Technocom`.
    temp30-weight_measure = `0.8`.
    temp30-weight_unit = `KG`.
    temp30-description = `Complete package, 1 User, different Multimedia applications, playing music, watching DVDs, only with this Smart package`.
    temp30-name = `Smart Multimedia`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1103.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `9`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `77.00`.
    temp30-width = `11`.
    temp30-depth = `3.4`.
    temp30-height = `22`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1104`.
    temp30-category = `Software`.
    temp30-main_category = `Software`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Technocom`.
    temp30-weight_measure = `1.1`.
    temp30-weight_unit = `KG`.
    temp30-description = `Complete package, 1 User, various games for amusement, logic, action, jump&run`.
    temp30-name = `Smart Games`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1104.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `13`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `55.00`.
    temp30-width = `10`.
    temp30-depth = `3`.
    temp30-height = `30`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1105`.
    temp30-category = `Software`.
    temp30-main_category = `Software`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Brainsoft`.
    temp30-weight_measure = `0.7`.
    temp30-weight_unit = `KG`.
    temp30-description = `Complete package, 1 User, highly recommended for internet users as anti-virus protection`.
    temp30-name = `Smart Internet Antivirus`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1105.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `17`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `29.00`.
    temp30-width = `16`.
    temp30-depth = `4`.
    temp30-height = `21`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1106`.
    temp30-category = `Software`.
    temp30-main_category = `Software`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Brainsoft`.
    temp30-weight_measure = `0.9`.
    temp30-weight_unit = `KG`.
    temp30-description = `Complete package, 1 User, recommended for internet users, protect your PC against cyber-crime`.
    temp30-name = `Smart Firewall`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1106.jpg`.
    temp30-status = `Discontinued`.
    temp30-quantity = `19`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `34.00`.
    temp30-width = `17.9`.
    temp30-depth = `4.2`.
    temp30-height = `23.1`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1107`.
    temp30-category = `Software`.
    temp30-main_category = `Software`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Brainsoft`.
    temp30-weight_measure = `0.5`.
    temp30-weight_unit = `KG`.
    temp30-description = `Complete package, 1 User, bring your money in your mind, see what you have and what you want`.
    temp30-name = `Smart Money`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1107.jpg`.
    temp30-status = `Out of Stock`.
    temp30-quantity = `18`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `29.90`.
    temp30-width = `12`.
    temp30-depth = `1.5`.
    temp30-height = `19`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1110`.
    temp30-category = `Computer System Accessories`.
    temp30-main_category = `Computer Systems`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Red Point Stores`.
    temp30-weight_measure = `0.03`.
    temp30-weight_unit = `KG`.
    temp30-description = `Robust 3m anti-burglary protection for your laptop computer`.
    temp30-name = `PC Lock`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1110.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `14`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `8.90`.
    temp30-width = `20`.
    temp30-depth = `8`.
    temp30-height = `4.3`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1111`.
    temp30-category = `Computer System Accessories`.
    temp30-main_category = `Computer Systems`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Red Point Stores`.
    temp30-weight_measure = `0.02`.
    temp30-weight_unit = `KG`.
    temp30-description = `Robust 1m anti-burglary protection for your desktop computer`.
    temp30-name = `Notebook Lock`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1111.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `20`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `6.90`.
    temp30-width = `31`.
    temp30-depth = `9`.
    temp30-height = `7`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1112`.
    temp30-category = `Computer System Accessories`.
    temp30-main_category = `Computer Systems`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Red Point Stores`.
    temp30-weight_measure = `0.075`.
    temp30-weight_unit = `KG`.
    temp30-description = `Color webcam, color, High-Speed USB`.
    temp30-name = `Web cam reality`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1112.jpg`.
    temp30-status = `Out of Stock`.
    temp30-quantity = `27`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `39.00`.
    temp30-width = `9`.
    temp30-depth = `8.2`.
    temp30-height = `1.3`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1113`.
    temp30-category = `Computer System Accessories`.
    temp30-main_category = `Computer Systems`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Red Point Stores`.
    temp30-weight_measure = `0.05`.
    temp30-weight_unit = `KG`.
    temp30-description = `10 separately packed screen wipes`.
    temp30-name = `Screen clean`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1113.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `17`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `2.30`.
    temp30-width = `2`.
    temp30-depth = `2`.
    temp30-height = `0.1`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1114`.
    temp30-category = `Computer System Accessories`.
    temp30-main_category = `Computer Systems`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Red Point Stores`.
    temp30-weight_measure = `1.8`.
    temp30-weight_unit = `KG`.
    temp30-description = `Notebook bag, plenty of room for stationery and writing materials`.
    temp30-name = `Fabric bag professional`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1114.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `14`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `31.00`.
    temp30-width = `42`.
    temp30-depth = `32`.
    temp30-height = `7`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1115`.
    temp30-category = `Telecommunications`.
    temp30-main_category = `Computer Components`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Red Point Stores`.
    temp30-weight_measure = `0.45`.
    temp30-weight_unit = `KG`.
    temp30-description = `Wireless DSL Router (available in blue, black and silver)`.
    temp30-name = `Wireless DSL Router`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1115.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `16`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `49.00`.
    temp30-width = `19.3`.
    temp30-depth = `18`.
    temp30-height = `5`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1116`.
    temp30-category = `Telecommunications`.
    temp30-main_category = `Computer Components`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Red Point Stores`.
    temp30-weight_measure = `0.45`.
    temp30-weight_unit = `KG`.
    temp30-description = `Wireless DSL Router / Repeater (available in blue, black and silver)`.
    temp30-name = `Wireless DSL Router / Repeater`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1116.jpg`.
    temp30-status = `Out of Stock`.
    temp30-quantity = `12`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `59.00`.
    temp30-width = `19.3`.
    temp30-depth = `18`.
    temp30-height = `5`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1117`.
    temp30-category = `Telecommunications`.
    temp30-main_category = `Computer Components`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Technocom`.
    temp30-weight_measure = `0.45`.
    temp30-weight_unit = `KG`.
    temp30-description = `Wireless DSL Router / Repeater and Print Server (available in blue, black and silver)`.
    temp30-name = `Wireless DSL Router / Repeater and Print Server`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1117.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `12`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `69.00`.
    temp30-width = `19.3`.
    temp30-depth = `18`.
    temp30-height = `5`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1118`.
    temp30-category = `Computer System Accessories`.
    temp30-main_category = `Computer Systems`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Technocom`.
    temp30-weight_measure = `0.015`.
    temp30-weight_unit = `KG`.
    temp30-description = `USB 2.0 High-Speed 64 GB`.
    temp30-name = `USB Stick`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1118.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `14`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `35.00`.
    temp30-width = `1.5`.
    temp30-depth = `8.7`.
    temp30-height = `1.2`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1119`.
    temp30-category = `Accessories`.
    temp30-main_category = `Computer Systems`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Titanium`.
    temp30-weight_measure = `88`.
    temp30-weight_unit = `G`.
    temp30-description = `Universal Travel Adapter`.
    temp30-name = `Travel Adapter`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1119.jpg`.
    temp30-status = `Discontinued`.
    temp30-quantity = `10`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `79.00`.
    temp30-width = `2`.
    temp30-depth = `3.1`.
    temp30-height = `3.9`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1120`.
    temp30-category = `Keyboards`.
    temp30-main_category = `Computer Components`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Technocom`.
    temp30-weight_measure = `1`.
    temp30-weight_unit = `KG`.
    temp30-description = `Cordless Bluetooth Keyboard with English keys`.
    temp30-name = `Cordless Bluetooth Keyboard, english international`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1120.jpg`.
    temp30-status = `Out of Stock`.
    temp30-quantity = `13`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `29.00`.
    temp30-width = `51.4`.
    temp30-depth = `23`.
    temp30-height = `4`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1137`.
    temp30-category = `Flat Screen Monitors`.
    temp30-main_category = `Computer Components`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Technocom`.
    temp30-weight_measure = `18`.
    temp30-weight_unit = `KG`.
    temp30-description = `Optimum Hi-Resolution max. 2048 × 1536 @ 85Hz, Dot Pitch: 0.24mm`.
    temp30-name = `Flat XXL`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1137.jpg`.
    temp30-status = `Discontinued`.
    temp30-quantity = `10`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `1430.00`.
    temp30-width = `54`.
    temp30-depth = `22`.
    temp30-height = `38`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1138`.
    temp30-category = `Mice`.
    temp30-main_category = `Computer Components`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Technocom`.
    temp30-weight_measure = `0.02`.
    temp30-weight_unit = `KG`.
    temp30-description = `Portable pocket Mouse with retracting cord`.
    temp30-name = `Pocket Mouse`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1138.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `20`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `23.00`.
    temp30-width = `0.3`.
    temp30-depth = `0.5`.
    temp30-height = `1`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1210`.
    temp30-category = `PCs`.
    temp30-main_category = `Computer Systems`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Technocom`.
    temp30-weight_measure = `2.3`.
    temp30-weight_unit = `KG`.
    temp30-description = `PC Power Station with 3,4 Ghz quad-core, 32 GB DDR3 SDRAM, feels like Available PC, Windows 8 Pro`.
    temp30-name = `PC Power Station`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1210.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `22`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `2399.00`.
    temp30-width = `28`.
    temp30-depth = `31`.
    temp30-height = `43`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1251`.
    temp30-category = `Laptops`.
    temp30-main_category = `Computer Systems`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Ultrasonic United`.
    temp30-weight_measure = `4.2`.
    temp30-weight_unit = `KG`.
    temp30-description = `Flexible Laptop with 2,5 GHz Quad Core, 15" HD TN, 16 GB DDR SDRAM, 256 GB SSD, Windows 10 Pro`.
    temp30-name = `Astro Laptop 1516`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1251.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `23`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `989.00`.
    temp30-width = `30`.
    temp30-depth = `18`.
    temp30-height = `3`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1252`.
    temp30-category = `Smartphones and Tablets`.
    temp30-main_category = `Smartphones & Tablets`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Ultrasonic United`.
    temp30-weight_measure = `0.75`.
    temp30-weight_unit = `KG`.
    temp30-description = `6 inch 1280x800 HD display (216 ppi), Quad-core processor, 8 GB internal storage (actual formatted capacity will be less), 3050 mAh battery (Up to 8 hours of active use), grey or black`.
    temp30-name = `Astro Phone 6`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1252.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `28`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `649.00`.
    temp30-width = `8`.
    temp30-depth = `6`.
    temp30-height = `1.5`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1253`.
    temp30-category = `Laptops`.
    temp30-main_category = `Computer Systems`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Ultrasonic United`.
    temp30-weight_measure = `4.2`.
    temp30-weight_unit = `KG`.
    temp30-description = `Flexible Laptop with 2,5 GHz Dual Core, 14" HD+ TN, 8 GB DDR SDRAM, 324 GB SSD, Windows 10 Pro`.
    temp30-name = `Benda Laptop 1408`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1253.jpg`.
    temp30-status = `Discontinued`.
    temp30-quantity = `27`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `976.00`.
    temp30-width = `30`.
    temp30-depth = `18`.
    temp30-height = `3`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1254`.
    temp30-category = `Flat Screens`.
    temp30-main_category = `Computer Components`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Ultrasonic United`.
    temp30-weight_measure = `15`.
    temp30-weight_unit = `KG`.
    temp30-description = `Optimum Hi-Resolution Widescreen max. 1920 x 1080 @ 85Hz, Dot Pitch: 0.27mm, HDMI, Discontinued-Sub`.
    temp30-name = `Bending Screen 21HD`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1254.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `23`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `250.00`.
    temp30-width = `37`.
    temp30-depth = `12`.
    temp30-height = `36`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1255`.
    temp30-category = `Flat Screens`.
    temp30-main_category = `Computer Components`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Ultrasonic United`.
    temp30-weight_measure = `16`.
    temp30-weight_unit = `KG`.
    temp30-description = `Optimum Hi-Resolution Widescreen max. 2048 x 1080 @ 85Hz, Dot Pitch: 0.27mm, HDMI, Discontinued-Sub`.
    temp30-name = `Broad Screen 22HD`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1255.jpg`.
    temp30-status = `Discontinued`.
    temp30-quantity = `5`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `270.00`.
    temp30-width = `39`.
    temp30-depth = `12`.
    temp30-height = `38`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1256`.
    temp30-category = `Smartphones and Tablets`.
    temp30-main_category = `Smartphones & Tablets`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Ultrasonic United`.
    temp30-weight_measure = `0.75`.
    temp30-weight_unit = `KG`.
    temp30-description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage (actual formatted capacity will be less), 4325 mAh battery (Up to 8 hours of active use), white or black`.
    temp30-name = `Cerdik Phone 7`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1256.jpg`.
    temp30-status = `Discontinued`.
    temp30-quantity = `19`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `549.00`.
    temp30-width = `9`.
    temp30-depth = `15`.
    temp30-height = `1.5`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1257`.
    temp30-category = `Smartphones and Tablets`.
    temp30-main_category = `Smartphones & Tablets`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Ultrasonic United`.
    temp30-weight_measure = `2.8`.
    temp30-weight_unit = `KG`.
    temp30-description = `10.5-inch Multitouch HD Screen (1280 x 800), 16GB Internal Memory, Wireless N Wi-Fi; Bluetooth, GPS Enabled, 1GHz Dual-Core Processor`.
    temp30-name = `Cepat Tablet 10.5`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1257.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `17`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `549.00`.
    temp30-width = `48`.
    temp30-depth = `31`.
    temp30-height = `4.5`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1258`.
    temp30-category = `Smartphones and Tablets`.
    temp30-main_category = `Smartphones & Tablets`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Ultrasonic United`.
    temp30-weight_measure = `2.5`.
    temp30-weight_unit = `KG`.
    temp30-description = `8-inch Multitouch HD Screen (2000 x 1500) 32GB Internal Memory, Wireless N Wi-Fi, Bluetooth, GPS Enabled, 1.5 GHz Quad-Core Processor`.
    temp30-name = `Cepat Tablet 8`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1258.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `24`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `529.00`.
    temp30-width = `38`.
    temp30-depth = `21`.
    temp30-height = `3.5`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1500`.
    temp30-category = `Servers`.
    temp30-main_category = `Computer Systems`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Technocom`.
    temp30-weight_measure = `18`.
    temp30-weight_unit = `KG`.
    temp30-description = `Dual socket, quad-core processing server with 1333 MHz Front Side Bus with 10Gb connectivity`.
    temp30-name = `Server Basic`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1500.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `24`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `5000.00`.
    temp30-width = `34`.
    temp30-depth = `35`.
    temp30-height = `23`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1501`.
    temp30-category = `Servers`.
    temp30-main_category = `Computer Systems`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Technocom`.
    temp30-weight_measure = `25`.
    temp30-weight_unit = `KG`.
    temp30-description = `Dual socket, quad-core processing server with 1644 MHz Front Side Bus with 10Gb connectivity`.
    temp30-name = `Server Professional`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1501.jpg`.
    temp30-status = `Out of Stock`.
    temp30-quantity = `26`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `15000.00`.
    temp30-width = `29`.
    temp30-depth = `30`.
    temp30-height = `27`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1502`.
    temp30-category = `Servers`.
    temp30-main_category = `Computer Systems`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Technocom`.
    temp30-weight_measure = `35`.
    temp30-weight_unit = `KG`.
    temp30-description = `Dual socket, quad-core processing server with 1644 MHz Front Side Bus with 100Gb connectivity`.
    temp30-name = `Server Power Pro`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1502.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `34`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `25000.00`.
    temp30-width = `22`.
    temp30-depth = `27.3`.
    temp30-height = `37`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1600`.
    temp30-category = `Desktop Computers`.
    temp30-main_category = `Computer Systems`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Titanium`.
    temp30-weight_measure = `4.8`.
    temp30-weight_unit = `KG`.
    temp30-description = `2,8 Ghz dual core, 4 GB DDR3 SDRAM, 500 GB Hard Disc, Graphic Card: Proctra X, Windows 8`.
    temp30-name = `Family PC Basic`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1600.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `10`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `600.00`.
    temp30-width = `21.4`.
    temp30-depth = `29`.
    temp30-height = `38`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1601`.
    temp30-category = `Desktop Computers`.
    temp30-main_category = `Computer Systems`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Titanium`.
    temp30-weight_measure = `5.3`.
    temp30-weight_unit = `KG`.
    temp30-description = `2,8 Ghz dual core, 4 GB DDR3 SDRAM, 1000 GB Hard Disc, Graphic Card: Gladiator MX, Windows 8`.
    temp30-name = `Family PC Pro`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1601.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `20`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `900.00`.
    temp30-width = `25`.
    temp30-depth = `31.7`.
    temp30-height = `40.2`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1602`.
    temp30-category = `Desktop Computers`.
    temp30-main_category = `Computer Systems`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Titanium`.
    temp30-weight_measure = `5.9`.
    temp30-weight_unit = `KG`.
    temp30-description = `3,4 Ghz quad core, 8 GB DDR3 SDRAM, 2000 GB Hard Disc, Graphic Card: Gladiator MX, Windows 8`.
    temp30-name = `Gaming Monster`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1602.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `24`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `1200.00`.
    temp30-width = `26.5`.
    temp30-depth = `34`.
    temp30-height = `47`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-1603`.
    temp30-category = `Desktop Computers`.
    temp30-main_category = `Computer Systems`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Titanium`.
    temp30-weight_measure = `6.8`.
    temp30-weight_unit = `KG`.
    temp30-description = `3,4 Ghz quad core, 16 GB DDR3 SDRAM, 4000 GB Hard Disc, Graphic Card: Hurricane GX, Windows 8`.
    temp30-name = `Gaming Monster Pro`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1603.jpg`.
    temp30-status = `Discontinued`.
    temp30-quantity = `25`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `1700.00`.
    temp30-width = `27`.
    temp30-depth = `28`.
    temp30-height = `42`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-2000`.
    temp30-category = `Accessories`.
    temp30-main_category = `TV, Video & HiFi`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Titanium`.
    temp30-weight_measure = `0.79`.
    temp30-weight_unit = `KG`.
    temp30-description = `7" LCD Screen, storage battery holds up to 6 hours!`.
    temp30-name = `7" Widescreen Portable DVD Player w MP3`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2000.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `20`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `249.99`.
    temp30-width = `21.4`.
    temp30-depth = `19`.
    temp30-height = `27.6`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-2001`.
    temp30-category = `Accessories`.
    temp30-main_category = `TV, Video & HiFi`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Titanium`.
    temp30-weight_measure = `0.84`.
    temp30-weight_unit = `KG`.
    temp30-description = `10" LCD Screen, storage battery holds up to 8 hours`.
    temp30-name = `10" Portable DVD player`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2001.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `21`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `449.99`.
    temp30-width = `24`.
    temp30-depth = `19.5`.
    temp30-height = `29`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-2002`.
    temp30-category = `Accessories`.
    temp30-main_category = `TV, Video & HiFi`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Technocom`.
    temp30-weight_measure = `0.72`.
    temp30-weight_unit = `KG`.
    temp30-description = `9" LCD Screen, storage holds up to 8 hours, 2 speakers included`.
    temp30-name = `Portable DVD Player with 9" LCD Monitor`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2002.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `50`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `853.99`.
    temp30-width = `21`.
    temp30-depth = `16.5`.
    temp30-height = `14`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-2025`.
    temp30-category = `Accessories`.
    temp30-main_category = `Computer Systems`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Titanium`.
    temp30-weight_measure = `0.65`.
    temp30-weight_unit = `KG`.
    temp30-description = `Organizer and protective case for 264 CDs and DVDs`.
    temp30-name = `CD/DVD case: 264 sleeves`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2025.jpg`.
    temp30-status = `Discontinued`.
    temp30-quantity = `26`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `44.99`.
    temp30-width = `13`.
    temp30-depth = `13`.
    temp30-height = `20`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-2026`.
    temp30-category = `Accessories`.
    temp30-main_category = `Computer Systems`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Titanium`.
    temp30-weight_measure = `0.2`.
    temp30-weight_unit = `KG`.
    temp30-description = `Quality cables for notebooks and projectors`.
    temp30-name = `Audio/Video Cable Kit - 4m`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2026.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `16`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `29.99`.
    temp30-width = `21`.
    temp30-depth = `10.2`.
    temp30-height = `13`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-2027`.
    temp30-category = `Accessories`.
    temp30-main_category = `Computer Systems`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Titanium`.
    temp30-weight_measure = `0.15`.
    temp30-weight_unit = `KG`.
    temp30-description = `Removable jewel case labels, zero residues (100)`.
    temp30-name = `Removable CD/DVD Laser Labels`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2027.jpg`.
    temp30-status = `Discontinued`.
    temp30-quantity = `25`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `8.99`.
    temp30-width = `5.5`.
    temp30-depth = `2`.
    temp30-height = `2`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-6100`.
    temp30-category = `Accessories`.
    temp30-main_category = `TV, Video & HiFi`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Titanium`.
    temp30-weight_measure = `1.7`.
    temp30-weight_unit = `KG`.
    temp30-description = `720p, DLP Projector max. 8,45 Meter, 2D`.
    temp30-name = `Beam Breaker B-1`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6100.jpg`.
    temp30-status = `Out of Stock`.
    temp30-quantity = `32`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `469.00`.
    temp30-width = `30.4`.
    temp30-depth = `23.1`.
    temp30-height = `23`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-6101`.
    temp30-category = `Accessories`.
    temp30-main_category = `TV, Video & HiFi`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Technocom`.
    temp30-weight_measure = `2`.
    temp30-weight_unit = `KG`.
    temp30-description = `1080p, DLP max.9,34 Meter, 2D-ready`.
    temp30-name = `Beam Breaker B-2`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6101.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `18`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `679.00`.
    temp30-width = `30.4`.
    temp30-depth = `23.1`.
    temp30-height = `23`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-6102`.
    temp30-category = `Accessories`.
    temp30-main_category = `TV, Video & HiFi`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Technocom`.
    temp30-weight_measure = `2.5`.
    temp30-weight_unit = `KG`.
    temp30-description = `1080p, DLP max. 12,3 Meter, 3D-ready`.
    temp30-name = `Beam Breaker B-3`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6102.jpg`.
    temp30-status = `Out of Stock`.
    temp30-quantity = `16`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `889.00`.
    temp30-width = `30.4`.
    temp30-depth = `23.1`.
    temp30-height = `23`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-6110`.
    temp30-category = `Accessories`.
    temp30-main_category = `TV, Video & HiFi`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Fasttech`.
    temp30-weight_measure = `2.4`.
    temp30-weight_unit = `KG`.
    temp30-description = `CD-RW, DVD+R/RW, DVD-R/RW, MPEG 2 (Video-DVD), MPEG 4, VCD, SVCD, DivX, Xvid`.
    temp30-name = `Play Movie`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6110.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `15`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `130.00`.
    temp30-width = `37`.
    temp30-depth = `24`.
    temp30-height = `6`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-6111`.
    temp30-category = `Accessories`.
    temp30-main_category = `TV, Video & HiFi`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Fasttech`.
    temp30-weight_measure = `3.1`.
    temp30-weight_unit = `KG`.
    temp30-description = `160 GB HDD, CD-RW, DVD+R/RW, DVD-R/RW, MPEG 2 (Video-DVD), MPEG 4, VCD, SVCD, DivX, Xvid`.
    temp30-name = `Record Movie`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6111.jpg`.
    temp30-status = `Discontinued`.
    temp30-quantity = `24`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `288.00`.
    temp30-width = `38`.
    temp30-depth = `26`.
    temp30-height = `6.2`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-6120`.
    temp30-category = `Accessories`.
    temp30-main_category = `TV, Video & HiFi`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Fasttech`.
    temp30-weight_measure = `134`.
    temp30-weight_unit = `G`.
    temp30-description = `64 GB USB Music-on-Available-Stick`.
    temp30-name = `ITelo MusicStick`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6120.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `15`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `45.00`.
    temp30-width = `1.5`.
    temp30-depth = `6`.
    temp30-height = `1`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-6121`.
    temp30-category = `Accessories`.
    temp30-main_category = `TV, Video & HiFi`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Fasttech`.
    temp30-weight_measure = `134`.
    temp30-weight_unit = `G`.
    temp30-description = `ITelo Jog-Mate 64 GB HDD and Color Display, can play movies`.
    temp30-name = `ITelo Jog-Mate`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6121.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `24`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `63.00`.
    temp30-width = `5.1`.
    temp30-depth = `8`.
    temp30-height = `9.2`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-6122`.
    temp30-category = `Accessories`.
    temp30-main_category = `TV, Video & HiFi`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Fasttech`.
    temp30-weight_measure = `266`.
    temp30-weight_unit = `G`.
    temp30-description = `MP3-Player with 40 GB HDD and Color Display, can play movies`.
    temp30-name = `Power Pro Player 40`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6122.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `23`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `167.00`.
    temp30-width = `5.1`.
    temp30-depth = `8`.
    temp30-height = `9.2`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-6123`.
    temp30-category = `Accessories`.
    temp30-main_category = `TV, Video & HiFi`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Fasttech`.
    temp30-weight_measure = `267`.
    temp30-weight_unit = `G`.
    temp30-description = `MP3-Player with 80 GB SSD and Color Display, can play movies`.
    temp30-name = `Power Pro Player 80`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6123.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `13`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `299.00`.
    temp30-width = `4`.
    temp30-depth = `6`.
    temp30-height = `0.8`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-6130`.
    temp30-category = `Flat Screen TVs`.
    temp30-main_category = `TV, Video & HiFi`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Very Best Screens`.
    temp30-weight_measure = `2.6`.
    temp30-weight_unit = `KG`.
    temp30-description = `32-inch, 1366x768 Pixel, 16:9, HDTV ready`.
    temp30-name = `Flat Watch HD32`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6130.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `16`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `1459.00`.
    temp30-width = `78`.
    temp30-depth = `22.1`.
    temp30-height = `55`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-6131`.
    temp30-category = `Flat Screen TVs`.
    temp30-main_category = `TV, Video & HiFi`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Very Best Screens`.
    temp30-weight_measure = `2.2`.
    temp30-weight_unit = `KG`.
    temp30-description = `37-inch, 1366x768 Pixel, 16:9, HDTV ready`.
    temp30-name = `Flat Watch HD37`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6131.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `14`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `1199.00`.
    temp30-width = `99.1`.
    temp30-depth = `26`.
    temp30-height = `61`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-6132`.
    temp30-category = `Flat Screen TVs`.
    temp30-main_category = `TV, Video & HiFi`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Very Best Screens`.
    temp30-weight_measure = `1.8`.
    temp30-weight_unit = `KG`.
    temp30-description = `41-inch, 1366x768 Pixel, 16:9, HDTV ready`.
    temp30-name = `Flat Watch HD41`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6132.jpg`.
    temp30-status = `Discontinued`.
    temp30-quantity = `13`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `899.00`.
    temp30-width = `128`.
    temp30-depth = `23`.
    temp30-height = `79.1`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-7000`.
    temp30-category = `Accessories`.
    temp30-main_category = `Computer Components`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Fasttech`.
    temp30-weight_measure = `0.5`.
    temp30-weight_unit = `KG`.
    temp30-description = `Our new multifunctional Handheld with phone function in copper`.
    temp30-name = `Copperberry`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7000.jpg`.
    temp30-status = `Discontinued`.
    temp30-quantity = `5`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `549.00`.
    temp30-width = `8.1`.
    temp30-depth = `13`.
    temp30-height = `12.1`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-7010`.
    temp30-category = `Accessories`.
    temp30-main_category = `Computer Components`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Fasttech`.
    temp30-weight_measure = `0.5`.
    temp30-weight_unit = `KG`.
    temp30-description = `Our new multifunctional Handheld with phone function in silver`.
    temp30-name = `Silverberry`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7010.jpg`.
    temp30-status = `Discontinued`.
    temp30-quantity = `9`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `549.00`.
    temp30-width = `8.1`.
    temp30-depth = `13`.
    temp30-height = `12.1`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-7020`.
    temp30-category = `Accessories`.
    temp30-main_category = `Computer Components`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Fasttech`.
    temp30-weight_measure = `0.5`.
    temp30-weight_unit = `KG`.
    temp30-description = `Our new multifunctional Handheld with phone function in gold`.
    temp30-name = `Goldberry`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7020.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `11`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `549.00`.
    temp30-width = `8.1`.
    temp30-depth = `13`.
    temp30-height = `12.1`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-7030`.
    temp30-category = `Accessories`.
    temp30-main_category = `Computer Components`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Fasttech`.
    temp30-weight_measure = `0.5`.
    temp30-weight_unit = `KG`.
    temp30-description = `Our new multifunctional Handheld with phone function in platinum`.
    temp30-name = `Platinberry`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7030.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `12`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `549.00`.
    temp30-width = `8.1`.
    temp30-depth = `13`.
    temp30-height = `12.1`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-8000`.
    temp30-category = `Laptops`.
    temp30-main_category = `Computer Systems`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Titanium`.
    temp30-weight_measure = `4`.
    temp30-weight_unit = `KG`.
    temp30-description = `Notebook with 2,80 GHz dual core, 4 GB DDR3 SDRAM, 500 GB Hard Disc, Windows 8`.
    temp30-name = `ITelO FlexTop I4000`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8000.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `11`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `799.00`.
    temp30-width = `31`.
    temp30-depth = `19`.
    temp30-height = `3.1`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-8001`.
    temp30-category = `Laptops`.
    temp30-main_category = `Computer Systems`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Titanium`.
    temp30-weight_measure = `4.2`.
    temp30-weight_unit = `KG`.
    temp30-description = `Notebook with 2,80 GHz dual core, 8 GB DDR3 SDRAM, 500 GB Hard Disc, Windows 8`.
    temp30-name = `ITelO FlexTop I6300c`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8001.jpg`.
    temp30-status = `Discontinued`.
    temp30-quantity = `20`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `799.00`.
    temp30-width = `32`.
    temp30-depth = `20`.
    temp30-height = `3.4`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-8002`.
    temp30-category = `Laptops`.
    temp30-main_category = `Computer Systems`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Titanium`.
    temp30-weight_measure = `3.5`.
    temp30-weight_unit = `KG`.
    temp30-description = `Notebook with 2,80 GHz quad core, 4 GB DDR3 SDRAM, 1000 GB Hard Disc, Windows 8`.
    temp30-name = `ITelO FlexTop I9100`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8002.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `20`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `1199.00`.
    temp30-width = `38`.
    temp30-depth = `21`.
    temp30-height = `4.1`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-8003`.
    temp30-category = `Laptops`.
    temp30-main_category = `Computer Systems`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Titanium`.
    temp30-weight_measure = `3.8`.
    temp30-weight_unit = `KG`.
    temp30-description = `Notebook with 2,80 GHz quad core, 8 GB DDR3 SDRAM, 1000 GB Hard Disc, Windows 8`.
    temp30-name = `ITelO FlexTop I9800`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8003.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `22`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `1388.00`.
    temp30-width = `48`.
    temp30-depth = `31`.
    temp30-height = `4.5`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-9991`.
    temp30-category = `Accessories`.
    temp30-main_category = `Smartphones & Tablets`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Ultrasonic United`.
    temp30-weight_measure = `0.02`.
    temp30-weight_unit = `KG`.
    temp30-description = `Button Clasp, Quality Material, 100% Leather, compatible with many smartphone models`.
    temp30-name = `Smartphone Leather Case`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9991.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `12`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `25.00`.
    temp30-width = `48`.
    temp30-depth = `31`.
    temp30-height = `4.5`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-9992`.
    temp30-category = `Smartphones and Tablets`.
    temp30-main_category = `Smartphones & Tablets`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Ultrasonic United`.
    temp30-weight_measure = `0.75`.
    temp30-weight_unit = `KG`.
    temp30-description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage (actual formatted capacity will be less), 4325 mAh battery (Up to 8 hours of active use), white or black`.
    temp30-name = `Smartphone Alpha`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9992.jpg`.
    temp30-status = `Out of Stock`.
    temp30-quantity = `13`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `599.00`.
    temp30-width = `48`.
    temp30-depth = `31`.
    temp30-height = `4.5`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-9993`.
    temp30-category = `Smartphones and Tablets`.
    temp30-main_category = `Smartphones & Tablets`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Ultrasonic United`.
    temp30-weight_measure = `3.8`.
    temp30-weight_unit = `KG`.
    temp30-description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage, 4325 mAh battery (Up to 8 hours of active use)`.
    temp30-name = `Mini Tablet`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9993.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `10`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `833.00`.
    temp30-width = `48`.
    temp30-depth = `31`.
    temp30-height = `4.5`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-9994`.
    temp30-category = `Accessories`.
    temp30-main_category = `TV, Video & HiFi`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Ultrasonic United`.
    temp30-weight_measure = `3.8`.
    temp30-weight_unit = `KG`.
    temp30-description = `1920x1080 Full HD, image stabilization reduces blur, 27x Optical / 32x Extended Zoom, wide angle Lens, 2.7" wide LCD display`.
    temp30-name = `Camcorder View`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9994.jpg`.
    temp30-status = `Out of Stock`.
    temp30-quantity = `50`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `1388.00`.
    temp30-width = `48`.
    temp30-depth = `31`.
    temp30-height = `27`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-9995`.
    temp30-category = `Accessories`.
    temp30-main_category = `Smartphones & Tablets`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Titanium`.
    temp30-weight_measure = `0.03`.
    temp30-weight_unit = `KG`.
    temp30-description = `Stylish tablet pouch, protects from scratches, color: black`.
    temp30-name = `Tablet Pouch`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9995.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `34`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `20.00`.
    temp30-width = `25`.
    temp30-depth = `40`.
    temp30-height = `4.5`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-9996`.
    temp30-category = `Accessories`.
    temp30-main_category = `Smartphones & Tablets`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Titanium`.
    temp30-weight_measure = `0.03`.
    temp30-weight_unit = `KG`.
    temp30-description = `Stylish tablet pouch, protects from scratches, color: black`.
    temp30-name = `Tablet Pouch`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9996.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `34`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `20.00`.
    temp30-width = `25`.
    temp30-depth = `40`.
    temp30-height = `4.5`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-9997`.
    temp30-category = `Smartphones and Tablets`.
    temp30-main_category = `Smartphones & Tablets`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Titanium`.
    temp30-weight_measure = `3.8`.
    temp30-weight_unit = `KG`.
    temp30-description = `6-Inch E Ink Screen, Access To e-book Store, Adjustable Font Styles and Sizes, Stores Up To 1,000 Books`.
    temp30-name = `e-Book Reader ReadMe`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9997.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `23`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `33.00`.
    temp30-width = `48`.
    temp30-depth = `31`.
    temp30-height = `4.5`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-9998`.
    temp30-category = `Smartphones and Tablets`.
    temp30-main_category = `Smartphones & Tablets`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Titanium`.
    temp30-weight_measure = `0.75`.
    temp30-weight_unit = `KG`.
    temp30-description = `5 Megapixel Camera, Wi-Fi 802.11 b/g/n, Bluetooth, GPS Available-GPS support`.
    temp30-name = `Smartphone Beta`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9998.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `21`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `30.00`.
    temp30-width = `48`.
    temp30-depth = `31`.
    temp30-height = `4.5`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `HT-9999`.
    temp30-category = `Tablets`.
    temp30-main_category = `Smartphones & Tablets`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Titanium`.
    temp30-weight_measure = `3.8`.
    temp30-weight_unit = `KG`.
    temp30-description = `10.1-inch Multitouch HD Screen (1280 x 800), 16GB Internal Memory, Wireless N Wi-Fi; Bluetooth, GPS Enabled, 1GHz Dual-Core Processor`.
    temp30-name = `Maxi Tablet`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9999.jpg`.
    temp30-status = `Available`.
    temp30-quantity = `20`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `749.00`.
    temp30-width = `48`.
    temp30-depth = `31`.
    temp30-height = `4.5`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    temp30-product_id = `PF-1000`.
    temp30-category = `Accessories`.
    temp30-main_category = `Computer Systems`.
    temp30-tax_tarif_code = `1`.
    temp30-supplier_name = `Titanium`.
    temp30-weight_measure = `0.01`.
    temp30-weight_unit = `KG`.
    temp30-description = `Flyer for our product palette`.
    temp30-name = `Flyer`.
    temp30-date_of_sale = ``.
    temp30-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/PF-1000.jpg`.
    temp30-status = `Out of Stock`.
    temp30-quantity = `33`.
    temp30-uom = `PC`.
    temp30-currency_code = `EUR`.
    temp30-price = `0.00`.
    temp30-width = `46`.
    temp30-depth = `30`.
    temp30-height = `3`.
    temp30-dim_unit = `cm`.
    INSERT temp30 INTO TABLE temp29.
    t_products = temp29.

    " explicit UI5 default of CarouselLayout.visiblePagesCount (the original's settings> model is empty until the route matches)
    pages_count = 1.

  ENDMETHOD.

ENDCLASS.
