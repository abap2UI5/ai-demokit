CLASS z2ui5_cl_api_app_401 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name           TYPE string,
        category       TYPE string,
        supplier_name  TYPE string,
        dimensions     TYPE string,
        weight_measure TYPE string,
        weight_unit    TYPE string,
        weight_state   TYPE string,
        price          TYPE string,
        currency_code  TYPE string,
      END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.
    TYPES:
      BEGIN OF ty_s_facet,
        text     TYPE string,
        count    TYPE i,
        selected TYPE abap_bool,
      END OF ty_s_facet.
    TYPES ty_t_facet TYPE STANDARD TABLE OF ty_s_facet WITH DEFAULT KEY.
    DATA t_products   TYPE ty_t_product.
    DATA t_categories TYPE ty_t_facet.
    DATA t_suppliers  TYPE ty_t_facet.

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


CLASS z2ui5_cl_api_app_401 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " Data taken from the shared mock data sap/ui/demo/mock/products.json of the original sample
    DATA temp1 TYPE z2ui5_cl_api_app_401=>ty_t_product.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp3 TYPE z2ui5_cl_api_app_401=>ty_t_facet.
    DATA temp4 LIKE LINE OF temp3.
    DATA temp5 TYPE z2ui5_cl_api_app_401=>ty_t_facet.
    DATA temp6 LIKE LINE OF temp5.
    CLEAR temp1.
    
    temp2-name = `Comfort Easy`.
    temp2-category = `Accessories`.
    temp2-supplier_name = `Technocom`.
    temp2-dimensions = `84 x 1.5 x 14 cm`.
    temp2-weight_measure = `0.2`.
    temp2-weight_unit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `1679.00`.
    temp2-currency_code = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Comfort Senior`.
    temp2-category = `Accessories`.
    temp2-supplier_name = `Technocom`.
    temp2-dimensions = `80 x 1.6 x 13 cm`.
    temp2-weight_measure = `0.8`.
    temp2-weight_unit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `512.00`.
    temp2-currency_code = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ergo Screen E-I`.
    temp2-category = `Flat Screen Monitors`.
    temp2-supplier_name = `Very Best Screens`.
    temp2-dimensions = `37 x 12 x 36 cm`.
    temp2-weight_measure = `21`.
    temp2-weight_unit = `KG`.
    temp2-weight_state = `Error`.
    temp2-price = `230.00`.
    temp2-currency_code = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO Vault`.
    temp2-category = `Accessories`.
    temp2-supplier_name = `Technocom`.
    temp2-dimensions = `32 x 22 x 3 cm`.
    temp2-weight_measure = `0.2`.
    temp2-weight_unit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `299.00`.
    temp2-currency_code = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO Vault Net`.
    temp2-category = `Accessories`.
    temp2-supplier_name = `Technocom`.
    temp2-dimensions = `10 x 1.8 x 17 cm`.
    temp2-weight_measure = `0.16`.
    temp2-weight_unit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `459.00`.
    temp2-currency_code = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO Vault SAT`.
    temp2-category = `Accessories`.
    temp2-supplier_name = `Technocom`.
    temp2-dimensions = `11 x 1.7 x 18 cm`.
    temp2-weight_measure = `0.18`.
    temp2-weight_unit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `149.00`.
    temp2-currency_code = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Basic 15`.
    temp2-category = `Laptops`.
    temp2-supplier_name = `Very Best Screens`.
    temp2-dimensions = `30 x 18 x 3 cm`.
    temp2-weight_measure = `4.2`.
    temp2-weight_unit = `KG`.
    temp2-weight_state = `Warning`.
    temp2-price = `956.00`.
    temp2-currency_code = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Basic 17`.
    temp2-category = `Laptops`.
    temp2-supplier_name = `Very Best Screens`.
    temp2-dimensions = `29 x 17 x 3.1 cm`.
    temp2-weight_measure = `4.5`.
    temp2-weight_unit = `KG`.
    temp2-weight_state = `Warning`.
    temp2-price = `1249.00`.
    temp2-currency_code = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Basic 19`.
    temp2-category = `Laptops`.
    temp2-supplier_name = `Smartcards`.
    temp2-dimensions = `32 x 21 x 4 cm`.
    temp2-weight_measure = `4.2`.
    temp2-weight_unit = `KG`.
    temp2-weight_state = `Warning`.
    temp2-price = `1650.00`.
    temp2-currency_code = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Professional 15`.
    temp2-category = `Accessories`.
    temp2-supplier_name = `Very Best Screens`.
    temp2-dimensions = `33 x 20 x 3 cm`.
    temp2-weight_measure = `4.3`.
    temp2-weight_unit = `KG`.
    temp2-weight_state = `Warning`.
    temp2-price = `1999.00`.
    temp2-currency_code = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    t_products = temp1.

    SORT t_products BY name.
    t_products_all = t_products.

    " Facet values with counters recomputed for the 10-row subset above
    " (the original binds the precomputed /ProductCollectionStats/Filters)
    
    CLEAR temp3.
    
    temp4-text = `Accessories`.
    temp4-count = 6.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Flat Screen Monitors`.
    temp4-count = 1.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Laptops`.
    temp4-count = 3.
    INSERT temp4 INTO TABLE temp3.
    t_categories = temp3.
    
    CLEAR temp5.
    
    temp6-text = `Smartcards`.
    temp6-count = 1.
    INSERT temp6 INTO TABLE temp5.
    temp6-text = `Technocom`.
    temp6-count = 5.
    INSERT temp6 INTO TABLE temp5.
    temp6-text = `Very Best Screens`.
    temp6-count = 4.
    INSERT temp6 INTO TABLE temp5.
    t_suppliers = temp5.

  ENDMETHOD.


  METHOD view_display.

    " The bound lists collection of the original is unrolled into two static facet filter lists;
    " the original controller appends the demo table of sap.m.sample.Table with an adjusted first column.
    DATA view TYPE REF TO z2ui5_cl_api_xml.
    view = z2ui5_cl_api_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->open( `VBox`
            )->a( n = `id` v = `idVBox`

            )->open( `FacetFilter`
                )->a( n = `id`                  v = `idFacetFilter`
                )->a( n = `type`                v = `Light`
                )->a( n = `showPersonalization` v = `true`
                )->a( n = `showReset`           v = `true`
                )->a( n = `reset`               v = client->_event( `RESET` )

                " each item binds selected two-way - listClose only signals the
                " backend to read the flags, no event payload needed
                )->open( `FacetFilterList`
                    )->a( n = `title`     v = `Category`
                    )->a( n = `key`       v = `Category`
                    )->a( n = `mode`      v = `MultiSelect`
                    )->a( n = `listClose` v = client->_event( `LIST_CLOSE` )
                    )->a( n = `items`     v = client->_bind_edit( t_categories )

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
                    )->a( n = `items`     v = client->_bind_edit( t_suppliers )

                    )->leaf( `FacetFilterItem`
                        )->a( n = `text`     v = `{TEXT}`
                        )->a( n = `key`      v = `{TEXT}`
                        )->a( n = `counter`  v = `{COUNT}`
                        )->a( n = `selected` v = `{SELECTED}`

                )->shut(
            )->shut(
            )->open( `Table`
                )->a( n = `id`    v = `idProductsTable`
                )->a( n = `inset` v = `false`
                )->a( n = `items` v = client->_bind_edit( t_products )

                )->open( `headerToolbar`
                    )->open( `OverflowToolbar`
                        )->leaf( `Title`
                            )->a( n = `text`  v = `Products`
                            )->a( n = `level` v = `H2`
                        )->leaf( `ToolbarSpacer`

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
                                )->a( n = `text` v = `{DIMENSIONS}`
                            )->leaf( `ObjectNumber`
                                )->a( n = `number` v = `{WEIGHT_MEASURE}`
                                )->a( n = `unit`   v = `{WEIGHT_UNIT}`
                                )->a( n = `state`  v = `{WEIGHT_STATE}`
                            )->leaf( `ObjectNumber`
                                )->a( n = `number` v = `{PRICE}`
                                )->a( n = `unit`   v = `{CURRENCY_CODE}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        FIELD-SYMBOLS <category> LIKE LINE OF t_categories.
        FIELD-SYMBOLS <supplier> LIKE LINE OF t_suppliers.

    CASE client->get( )-event.

      WHEN `RESET`.
        " like handleFacetFilterReset: clear every list's selection (via the
        " two-way bound flags) and drop the table filter
        
        LOOP AT t_categories ASSIGNING <category>.
          <category>-selected = abap_false.
        ENDLOOP.
        
        LOOP AT t_suppliers ASSIGNING <supplier>.
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

    " the two-way bound selected flags arrive with the event - build one range
    " per facet group from them
    DATA category LIKE LINE OF t_categories.
      DATA temp7 LIKE LINE OF t_range_category.
    DATA supplier LIKE LINE OF t_suppliers.
      DATA temp8 LIKE LINE OF t_range_supplier.
    LOOP AT t_categories INTO category WHERE selected = abap_true.
      
      CLEAR temp7.
      temp7-sign = `I`.
      temp7-option = `EQ`.
      temp7-low = category-text.
      APPEND temp7 TO t_range_category.
    ENDLOOP.
    
    LOOP AT t_suppliers INTO supplier WHERE selected = abap_true.
      
      CLEAR temp8.
      temp8-sign = `I`.
      temp8-option = `EQ`.
      temp8-low = supplier-text.
      APPEND temp8 TO t_range_supplier.
    ENDLOOP.

    " like _filterModel: ANDs between the facet groups, ORs inside a group -
    " an empty range matches all rows, like a list without selections is skipped
    t_products = t_products_all.
    DELETE t_products WHERE category NOT IN t_range_category OR supplier_name NOT IN t_range_supplier.

    client->view_model_update( ).

  ENDMETHOD.

ENDCLASS.
