CLASS z2ui5_cl_ai_app_401 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name           TYPE string,
        category       TYPE string,
        supplier_name  TYPE string,
        width          TYPE string,
        depth          TYPE string,
        height         TYPE string,
        dim_unit       TYPE string,
        weight_measure TYPE string,
        weight_unit    TYPE string,
        price          TYPE p LENGTH 14 DECIMALS 2,
        currency_code  TYPE string,
      END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.
    TYPES:
      BEGIN OF ty_s_facet,
        text     TYPE string,
        count    TYPE i,
        selected TYPE abap_bool,
      END OF ty_s_facet.
    TYPES ty_t_facet TYPE STANDARD TABLE OF ty_s_facet WITH EMPTY KEY.
    DATA t_products          TYPE ty_t_product.
    DATA t_categories        TYPE ty_t_facet.
    DATA t_suppliers         TYPE ty_t_facet.
    DATA popin_layout        TYPE string.
    DATA info_toolbar_hidden TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    " not bound - kept out of PUBLIC so the round-trip model scan stays small
    DATA t_products_all TYPE ty_t_product.

    METHODS model_init.
    METHODS view_display.
    METHODS on_event.
    METHODS apply_filter.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_401 IMPLEMENTATION.

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

    " Data taken from the shared mock data sap/ui/demo/mock/products.json of the original sample
    t_products = VALUE #(
        ( name = `Comfort Easy` category = `Accessories` supplier_name = `Technocom` width = `84` depth = `1.5` height = `14` dim_unit = `cm` weight_measure = `0.2` weight_unit = `KG` price = `1679.00` currency_code = `EUR` )
        ( name = `Comfort Senior` category = `Accessories` supplier_name = `Technocom` width = `80` depth = `1.6` height = `13` dim_unit = `cm` weight_measure = `0.8` weight_unit = `KG` price = `512.00` currency_code = `EUR` )
        ( name = `Ergo Screen E-I` category = `Flat Screen Monitors` supplier_name = `Very Best Screens` width = `37` depth = `12` height = `36` dim_unit = `cm` weight_measure = `21` weight_unit = `KG` price = `230.00` currency_code = `EUR` )
        ( name = `ITelO Vault` category = `Accessories` supplier_name = `Technocom` width = `32` depth = `22` height = `3` dim_unit = `cm` weight_measure = `0.2` weight_unit = `KG` price = `299.00` currency_code = `EUR` )
        ( name = `ITelO Vault Net` category = `Accessories` supplier_name = `Technocom` width = `10` depth = `1.8` height = `17` dim_unit = `cm` weight_measure = `0.16` weight_unit = `KG` price = `459.00` currency_code = `EUR` )
        ( name = `ITelO Vault SAT` category = `Accessories` supplier_name = `Technocom` width = `11` depth = `1.7` height = `18` dim_unit = `cm` weight_measure = `0.18` weight_unit = `KG` price = `149.00` currency_code = `EUR` )
        ( name = `Notebook Basic 15` category = `Laptops` supplier_name = `Very Best Screens` width = `30` depth = `18` height = `3` dim_unit = `cm` weight_measure = `4.2` weight_unit = `KG` price = `956.00` currency_code = `EUR` )
        ( name = `Notebook Basic 17` category = `Laptops` supplier_name = `Very Best Screens` width = `29` depth = `17` height = `3.1` dim_unit = `cm` weight_measure = `4.5` weight_unit = `KG` price = `1249.00` currency_code = `EUR` )
        ( name = `Notebook Basic 19` category = `Laptops` supplier_name = `Smartcards` width = `32` depth = `21` height = `4` dim_unit = `cm` weight_measure = `4.2` weight_unit = `KG` price = `1650.00` currency_code = `EUR` )
        ( name = `Notebook Professional 15` category = `Accessories` supplier_name = `Very Best Screens` width = `33` depth = `20` height = `3` dim_unit = `cm` weight_measure = `4.3` weight_unit = `KG` price = `1999.00` currency_code = `EUR` ) ).

    t_products_all = t_products.

    " Facet values with counters recomputed for the 10-row subset above
    " (the original binds the precomputed /ProductCollectionStats/Filters)
    t_categories = VALUE #(
        ( text = `Accessories` count = 6 )
        ( text = `Flat Screen Monitors` count = 1 )
        ( text = `Laptops` count = 3 ) ).
    t_suppliers = VALUE #(
        ( text = `Smartcards` count = 1 )
        ( text = `Technocom` count = 5 )
        ( text = `Very Best Screens` count = 4 ) ).

  ENDMETHOD.


  METHOD view_display.

    " bound lists collection unrolled into two static facet filter lists; the appended demo table of sap.m.sample.Table is rebuilt inline
    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        " the framework's curated formatter module, wired like the original wires './Formatter' (core:require needs UI5 >= 1.74)
        )->a( n = `core:require` v = `{Formatter: 'z2ui5/model/formatter'}`

        )->open( `VBox`
            )->a( n = `id` v = `idVBox`

            )->open( `FacetFilter`
                )->a( n = `id`                  v = `idFacetFilter`
                )->a( n = `type`                v = `Light`
                )->a( n = `showPersonalization` v = `true`
                )->a( n = `showReset`           v = `true`
                )->a( n = `reset`               v = client->_event( `RESET` )

                " each item binds selected two-way - listClose only signals the backend to read the flags
                )->open( `FacetFilterList`
                    )->a( n = `title`     v = `Category`
                    )->a( n = `key`       v = `Category`
                    )->a( n = `mode`      v = `MultiSelect`
                    )->a( n = `listClose` v = client->_event( `LIST_CLOSE` )
                    )->a( n = `items`     v = client->_bind( t_categories )

                    )->leaf( `FacetFilterItem`
                        )->a( n = `text`     v = `{TEXT}`
                        )->a( n = `key`      v = `{TEXT}`
                        )->a( n = `counter`  v = `{COUNT}`
                        )->a( n = `selected` v = `{SELECTED}`

                )->shut(
                )->open( `FacetFilterList`
                    )->a( n = `title`     v = `SupplierName`
                    )->a( n = `key`       v = `SupplierName`
                    )->a( n = `mode`      v = `MultiSelect`
                    )->a( n = `listClose` v = client->_event( `LIST_CLOSE` )
                    )->a( n = `items`     v = client->_bind( t_suppliers )

                    )->leaf( `FacetFilterItem`
                        )->a( n = `text`     v = `{TEXT}`
                        )->a( n = `key`      v = `{TEXT}`
                        )->a( n = `counter`  v = `{COUNT}`
                        )->a( n = `selected` v = `{SELECTED}`

                )->shut(
            )->shut(
            )->open( `Table`
                )->a( n = `id`          v = `idProductsTable`
                )->a( n = `inset`       v = `false`
                " popinLayout mirrors the original's setPopinLayout controller switch - an empty ComboBox selection maps to the Block default
                )->a( n = `popinLayout` v = |\{= ${ client->_bind( popin_layout ) } \|\| 'Block' \}|
                )->a( n = `items`       v = |\{ path: '{ client->_bind( val = t_products path = abap_true ) }', sorter: \{ path: 'NAME' \} \}|

                )->open( `headerToolbar`
                    )->open( `OverflowToolbar`
                        )->leaf( `Title`
                            )->a( n = `text`  v = `Products`
                            )->a( n = `level` v = `H2`
                        )->leaf( `ToolbarSpacer`

                        )->open( `ComboBox`
                            )->a( n = `id`          v = `idPopinLayout`
                            )->a( n = `placeholder` v = `Popin layout options`
                            " two-way selectedKey replaces the original's change handler (a pure key-to-property pass-through)
                            )->a( n = `selectedKey` v = client->_bind( popin_layout )

                            )->open( `items`
                                )->leaf( n = `Item` ns = `core`
                                    )->a( n = `text` v = `Block`
                                    )->a( n = `key`  v = `Block`
                                )->leaf( n = `Item` ns = `core`
                                    )->a( n = `text` v = `Grid Large`
                                    )->a( n = `key`  v = `GridLarge`
                                )->leaf( n = `Item` ns = `core`
                                    )->a( n = `text` v = `Grid Small`
                                    )->a( n = `key`  v = `GridSmall`

                            )->shut(
                        )->shut(
                        " the original's sticky Label + CheckBoxes are dropped - Table.sticky is an array property with no binding path
                        )->leaf( `ToggleButton`
                            )->a( n = `id`      v = `toggleInfoToolbar`
                            )->a( n = `text`    v = `Hide/Show InfoToolbar`
                            " two-way pressed replaces the original's press handler - the infoToolbar visibility is a pure expression over it
                            )->a( n = `pressed` v = client->_bind( info_toolbar_hidden )

                    )->shut(
                )->shut(
                )->open( `infoToolbar`
                    )->open( `OverflowToolbar`
                        )->a( n = `visible` v = |\{= !${ client->_bind( info_toolbar_hidden ) } \}|

                        )->leaf( `Label`
                            )->a( n = `text` v = `Wide range of available products`

                    )->shut(
                )->shut(
                )->open( `columns`
                    )->open( `Column`
                        )->a( n = `width` v = `12em`

                        )->leaf( `Text`
                            )->a( n = `text` v = `Product`

                    )->shut(
                    )->open( `Column`
                        )->a( n = `minScreenWidth` v = `Tablet`
                        )->a( n = `demandPopin`    v = `true`

                        )->leaf( `Text`
                            )->a( n = `text` v = `Supplier`

                    )->shut(
                    )->open( `Column`
                        )->a( n = `minScreenWidth` v = `Desktop`
                        )->a( n = `demandPopin`    v = `true`
                        )->a( n = `hAlign`         v = `End`

                        )->leaf( `Text`
                            )->a( n = `text` v = `Dimensions`

                    )->shut(
                    )->open( `Column`
                        )->a( n = `minScreenWidth` v = `Desktop`
                        )->a( n = `demandPopin`    v = `true`
                        )->a( n = `hAlign`         v = `Center`

                        )->leaf( `Text`
                            )->a( n = `text` v = `Weight`

                    )->shut(
                    )->open( `Column`
                        )->a( n = `hAlign` v = `End`

                        )->leaf( `Text`
                            )->a( n = `text` v = `Price`

                    )->shut(
                )->shut(
                )->open( `items`
                    )->open( `ColumnListItem`
                        )->a( n = `vAlign` v = `Middle`

                        )->open( `cells`
                            )->leaf( `ObjectIdentifier`
                                )->a( n = `title` v = `{NAME}`
                                )->a( n = `text`  v = `{CATEGORY}`
                            )->leaf( `Text`
                                )->a( n = `text` v = `{SUPPLIER_NAME}`
                            )->leaf( `Text`
                                )->a( n = `text` v = `{WIDTH} x {DEPTH} x {HEIGHT} {DIM_UNIT}`
                            " parts+formatter binding kept 1:1 - the curated formatter module is required into the view (core:require above)
                            )->leaf( `ObjectNumber`
                                )->a( n = `number` v = `{WEIGHT_MEASURE}`
                                )->a( n = `unit`   v = `{WEIGHT_UNIT}`
                                )->a( n = `state`  v = |\{ parts: [\{path: 'WEIGHT_MEASURE'\}, \{path: 'WEIGHT_UNIT'\}], formatter: 'Formatter.weightState' \}|
                            )->leaf( `ObjectNumber`
                                )->a( n = `number` v = |\{ parts:[\{path:'PRICE'\},\{path:'CURRENCY_CODE'\}], type:'sap.ui.model.type.Currency', formatOptions:\{showMeasure:false\} \}|
                                )->a( n = `unit`   v = `{CURRENCY_CODE}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `RESET`.
        " like handleFacetFilterReset: clear the two-way bound selection flags and re-filter
        LOOP AT t_categories ASSIGNING FIELD-SYMBOL(<category>).
          <category>-selected = abap_false.
        ENDLOOP.
        LOOP AT t_suppliers ASSIGNING FIELD-SYMBOL(<supplier>).
          <supplier>-selected = abap_false.
        ENDLOOP.
        apply_filter( ).

      WHEN `LIST_CLOSE`.
        apply_filter( ).

    ENDCASE.

  ENDMETHOD.


  METHOD apply_filter.

    DATA t_range_category TYPE RANGE OF string.
    DATA t_range_supplier TYPE RANGE OF string.

    " the two-way bound selected flags arrive with the event - one range per facet group
    LOOP AT t_categories INTO DATA(category) WHERE selected = abap_true.
      APPEND VALUE #( sign   = `I`
                      option = `EQ`
                      low    = category-text ) TO t_range_category.
    ENDLOOP.
    LOOP AT t_suppliers INTO DATA(supplier) WHERE selected = abap_true.
      APPEND VALUE #( sign   = `I`
                      option = `EQ`
                      low    = supplier-text ) TO t_range_supplier.
    ENDLOOP.

    " like _filterModel (ORs inside a group, ANDs between groups) - the nested filter exceeds the binding_call whitelist, so the model is filtered ABAP-side
    t_products = t_products_all.
    DELETE t_products WHERE category NOT IN t_range_category OR supplier_name NOT IN t_range_supplier.

    client->view_model_update( ).

  ENDMETHOD.

ENDCLASS.
