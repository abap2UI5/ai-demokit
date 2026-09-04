" @keywords facetfilter facet filter sap.m facetfiltersimple vbox facetfilterlist facetfilteritem table overflowtoolbar title toolbarspacer
" @summary With the Facet Filter you can offer multiple filters ('facets') to assist the user in narrowing down the data in, say, a table. With this default 'Simple' type, each filter is displayed in a row for selection.
CLASS z2ui5_cl_smpc_app_235 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name          TYPE string,
        category      TYPE string,
        suppliername  TYPE string,
        width         TYPE string,
        depth         TYPE string,
        height        TYPE string,
        dimunit       TYPE string,
        weightmeasure TYPE string,
        weightunit    TYPE string,
        weight_state  TYPE string,
        price         TYPE p LENGTH 14 DECIMALS 2,
        currencycode  TYPE string,
      END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.
    TYPES:
      BEGIN OF ty_s_facet,
        text     TYPE string,
        count    TYPE i,
        selected TYPE abap_bool,
      END OF ty_s_facet.
    TYPES ty_t_facet TYPE STANDARD TABLE OF ty_s_facet WITH DEFAULT KEY.
    DATA t_products          TYPE ty_t_product.
    DATA t_sticky            TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
    DATA t_categories        TYPE ty_t_facet.
    DATA t_suppliers         TYPE ty_t_facet.
    DATA popin_layout        TYPE string.
    DATA info_toolbar_hidden TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    " the compound filter the LIVE items binding was last given, so a rebuilt
    " view can be handed exactly the same one again (see view_display). Empty
    " until the user has filtered once, which is the guard. PROTECTED, not
    " PUBLIC: it is bookkeeping and not model data, and only PUBLIC attributes
    " are serialized into the view model - and not PRIVATE, because the draft
    " serialization walks the attributes with a dynamic ASSIGN obj->(name)
    " that cannot reach a PRIVATE one
    DATA filter_live TYPE string.

    METHODS view_display.
    METHODS on_event.
    METHODS apply_filter.
    METHODS filter_issue.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_235 IMPLEMENTATION.

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

    " bound lists collection unrolled into two static facet filter lists; the appended demo table of sap.m.sample.Table is rebuilt inline
    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    DATA temp2 TYPE string_table.
    DATA temp3 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `${$source>/text}` INTO TABLE temp1.
    INSERT `${$parameters>/selected}` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `${$source>/text}` INTO TABLE temp2.
    INSERT `${$parameters>/selected}` INTO TABLE temp2.
    
    CLEAR temp3.
    INSERT `${$source>/text}` INTO TABLE temp3.
    INSERT `${$parameters>/selected}` INTO TABLE temp3.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->ele( `VBox`
            )->a( n = `id` v = `idVBox`

            )->ele( `FacetFilter`
                )->a( n = `id`                  v = `idFacetFilter`
                )->a( n = `type`                v = `Simple`
                )->a( n = `showPersonalization` v = `true`
                )->a( n = `showReset`           v = `true`
                )->a( n = `reset`               v = client->_event( `RESET` )
                )->a( n = `confirm`             v = client->_event( `CONFIRM` )

                " each item binds selected two-way - confirm signals the backend to read the flags and filter
                )->ele( `FacetFilterList`
                    )->a( n = `title` v = `Category`
                    )->a( n = `key`   v = `Category`
                    )->a( n = `mode`  v = `MultiSelect`
                    )->a( n = `items` v = client->_bind( t_categories )

                    )->tag( `FacetFilterItem`
                        )->a( n = `text`     v = `{TEXT}`
                        )->a( n = `key`      v = `{TEXT}`
                        )->a( n = `counter`  v = `{COUNT}`
                        )->a( n = `selected` v = `{SELECTED}`

                )->end(
                )->ele( `FacetFilterList`
                    )->a( n = `title` v = `SupplierName`
                    )->a( n = `key`   v = `SupplierName`
                    )->a( n = `mode`  v = `MultiSelect`
                    )->a( n = `items` v = client->_bind( t_suppliers )

                    )->tag( `FacetFilterItem`
                        )->a( n = `text`     v = `{TEXT}`
                        )->a( n = `key`      v = `{TEXT}`
                        )->a( n = `counter`  v = `{COUNT}`
                        )->a( n = `selected` v = `{SELECTED}`

                )->end(
            )->end(
            )->ele( `Table`
                )->a( n = `id`          v = `idProductsTable`
                )->a( n = `sticky`      v = client->_bind( t_sticky )
                )->a( n = `inset`       v = `false`
                " popinLayout mirrors the original's setPopinLayout controller switch - an empty ComboBox selection maps to the Block default
                )->a( n = `popinLayout` v = |\{= ${ client->_bind( popin_layout ) } \|\| 'Block' \}|
                )->a( n = `items`       v = |\{ path: '{ client->_bind_path( t_products ) }', sorter: \{ path: 'NAME' \} \}|

                )->ele( `headerToolbar`
                    )->ele( `OverflowToolbar`
                        )->tag( `Title`
                            )->a( n = `text`  v = `Products`
                            )->a( n = `level` v = `H2`
                        )->tag( `ToolbarSpacer`

                        )->ele( `ComboBox`
                            )->a( n = `id`          v = `idPopinLayout`
                            )->a( n = `placeholder` v = `Popin layout options`
                            " two-way selectedKey replaces the original's change handler (a pure key-to-property pass-through)
                            )->a( n = `selectedKey` v = client->_bind( popin_layout )

                            )->ele( `items`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `text` v = `Block`
                                    )->a( n = `key`  v = `Block`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `text` v = `Grid Large`
                                    )->a( n = `key`  v = `GridLarge`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `text` v = `Grid Small`
                                    )->a( n = `key`  v = `GridSmall`

                            )->end(
                        )->end(
                        " the sticky options: Table.sticky is an ARRAY property, bound here to a
                        " string table and maintained in the backend - the app-009 pattern
                        )->tag( `Label`
                            )->a( n = `text` v = `Sticky options:`
                        )->tag( `CheckBox`
                            )->a( n = `text`   v = `ColumnHeaders`
                            )->a( n = `select` v = client->_event( val   = `STICKY_SELECT`
                                                                   t_arg = temp1 )
                        )->tag( `CheckBox`
                            )->a( n = `text`   v = `HeaderToolbar`
                            )->a( n = `select` v = client->_event( val   = `STICKY_SELECT`
                                                                   t_arg = temp2 )
                        )->tag( `CheckBox`
                            )->a( n = `text`   v = `InfoToolbar`
                            )->a( n = `select` v = client->_event( val   = `STICKY_SELECT`
                                                                   t_arg = temp3 )
                        )->tag( `ToggleButton`
                            )->a( n = `id`      v = `toggleInfoToolbar`
                            )->a( n = `text`    v = `Hide/Show InfoToolbar`
                            " two-way pressed replaces the original's press handler - the infoToolbar visibility is a pure expression over it
                            )->a( n = `pressed` v = client->_bind( info_toolbar_hidden )

                    )->end(
                )->end(
                )->ele( `infoToolbar`
                    )->ele( `OverflowToolbar`
                        )->a( n = `visible` v = |\{= !${ client->_bind( info_toolbar_hidden ) } \}|

                        )->tag( `Label`
                            )->a( n = `text` v = `Wide range of available products`

                    )->end(
                )->end(
                )->ele( `columns`
                    )->ele( `Column`
                        )->a( n = `width` v = `12em`

                        )->tag( `Text`
                            )->a( n = `text` v = `Product`

                    )->end(
                    )->ele( `Column`
                        )->a( n = `minScreenWidth` v = `Tablet`
                        )->a( n = `demandPopin`    v = `true`

                        )->tag( `Text`
                            )->a( n = `text` v = `Supplier`

                    )->end(
                    )->ele( `Column`
                        )->a( n = `minScreenWidth` v = `Desktop`
                        )->a( n = `demandPopin`    v = `true`
                        )->a( n = `hAlign`         v = `End`

                        )->tag( `Text`
                            )->a( n = `text` v = `Dimensions`

                    )->end(
                    )->ele( `Column`
                        )->a( n = `minScreenWidth` v = `Desktop`
                        )->a( n = `demandPopin`    v = `true`
                        )->a( n = `hAlign`         v = `Center`

                        )->tag( `Text`
                            )->a( n = `text` v = `Weight`

                    )->end(
                    )->ele( `Column`
                        )->a( n = `hAlign` v = `End`

                        )->tag( `Text`
                            )->a( n = `text` v = `Price`

                    )->end(
                )->end(
                )->ele( `items`
                    )->ele( `ColumnListItem`
                        )->a( n = `vAlign` v = `Middle`

                        )->ele( `cells`
                            )->tag( `ObjectIdentifier`
                                )->a( n = `title` v = `{NAME}`
                                )->a( n = `text`  v = `{CATEGORY}`
                            )->tag( `Text`
                                )->a( n = `text` v = `{SUPPLIERNAME}`
                            )->tag( `Text`
                                )->a( n = `text` v = `{WIDTH} x {DEPTH} x {HEIGHT} {DIMUNIT}`
                            )->tag( `ObjectNumber`
                                )->a( n = `number` v = `{WEIGHTMEASURE}`
                                )->a( n = `unit`   v = `{WEIGHTUNIT}`
                                )->a( n = `state`  v = `{WEIGHT_STATE}`
                            )->tag( `ObjectNumber`
                                )->a( n = `number` v = |\{ parts:[\{path:'PRICE'\},\{path:'CURRENCYCODE'\}], type:'sap.ui.model.type.Currency', formatOptions:\{showMeasure:false\} \}|
                                )->a( n = `unit`   v = `{CURRENCYCODE}` ).

    client->view_display( view->stringify( ) ).

    " A rebuilt view creates a FRESH items binding whose aFilters is empty, so
    " the client-side filter is gone - while the two-way bound selected flags
    " of t_categories/t_suppliers are class state that survives. Without this
    " the FacetFilter comes back claiming a selection the table does not show.
    " check_on_navigated( ) takes exactly this path: measured on the
    " framework's own bookmark restore
    " (?app_start=<class>#/z2ui5-xapp-state=<draft>, the URL
    " cs_event-clipboard_app_state hands out) - 34 filtered rows before,
    " 123 unfiltered rows and the facet still reading Accessories after.
    " Re-issuing the SAME payload is the app-000 idiom; statement order does
    " not matter, the frontend awaits every T_SYSTEM display before it runs a
    " T_CUSTOM follow-up
    IF filter_live IS NOT INITIAL.
      filter_issue( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.
        DATA sticky_text TYPE string.
        DATA temp3 TYPE abap_bool.
        DATA sticky_on LIKE temp3.
        FIELD-SYMBOLS <category> LIKE LINE OF t_categories.
        FIELD-SYMBOLS <supplier> LIKE LINE OF t_suppliers.

    CASE client->get_event( ).

      WHEN `STICKY_SELECT`.
        " onSelect: the controller maintains an array of sap.m.Sticky keys and
        " calls oTable.setSticky( ). The array is a bound string table here (the
        " app-009 pattern, live-verified there): the CheckBox round-trips its own
        " text and the selected flag, the backend keeps the set
        
        sticky_text = client->get_event_arg( ).
        
        temp3 = client->get_event_arg( 2 ).
        
        sticky_on = temp3.
        IF sticky_on = abap_true.
          INSERT sticky_text INTO TABLE t_sticky.
        ELSE.
          DELETE t_sticky WHERE table_line = sticky_text.
        ENDIF.

      WHEN `RESET`.
        " like handleFacetFilterReset: clear the two-way bound selection flags and re-filter
        
        LOOP AT t_categories ASSIGNING <category>.
          <category>-selected = abap_false.
        ENDLOOP.
        
        LOOP AT t_suppliers ASSIGNING <supplier>.
          <supplier>-selected = abap_false.
        ENDLOOP.
        apply_filter( ).

      WHEN `CONFIRM`.
        " like handleConfirm: build the compound filter from the selected flags, then toast
        apply_filter( ).
        client->message_toast_display( `confirm event fired` ).

    ENDCASE.

  ENDMETHOD.


  METHOD apply_filter.

    DATA rows_category TYPE string.
    DATA rows_supplier TYPE string.

    " the two-way bound selected flags arrive with the event - one JSON group per facet list with selections (values are static demo texts, no escaping needed)
    DATA category LIKE LINE OF t_categories.
    DATA supplier LIKE LINE OF t_suppliers.
    LOOP AT t_categories INTO category WHERE selected = abap_true.
      IF rows_category IS NOT INITIAL.
        rows_category = rows_category && `,`.
      ENDIF.
      rows_category = rows_category && |["CATEGORY","EQ","{ category-text }"]|.
    ENDLOOP.
    
    LOOP AT t_suppliers INTO supplier WHERE selected = abap_true.
      IF rows_supplier IS NOT INITIAL.
        rows_supplier = rows_supplier && `,`.
      ENDIF.
      rows_supplier = rows_supplier && |["SUPPLIERNAME","EQ","{ supplier-text }"]|.
    ENDLOOP.

    filter_live = `[`.
    IF rows_category IS NOT INITIAL.
      filter_live = filter_live && |[{ rows_category }]|.
    ENDIF.
    IF rows_supplier IS NOT INITIAL.
      IF rows_category IS NOT INITIAL.
        filter_live = filter_live && `,`.
      ENDIF.
      filter_live = filter_live && |[{ rows_supplier }]|.
    ENDIF.
    filter_live = filter_live && `]`.

    filter_issue( ).

  ENDMETHOD.


  METHOD filter_issue.

    " like _filterModel (ORs inside a group, AND across the groups) - declarative compound filter on the items binding, model untouched.
    " Issued from apply_filter( ) and again from view_display( ), because the filter lives on the binding and not in the model
    DATA temp4 TYPE string_table.
    CLEAR temp4.
    INSERT `idProductsTable` INTO TABLE temp4.
    INSERT `items` INTO TABLE temp4.
    INSERT `filter` INTO TABLE temp4.
    INSERT filter_live INTO TABLE temp4.
    client->follow_up_action( val   = client->cs_event-binding_call
                              t_arg = temp4 ).

  ENDMETHOD.


  METHOD model_init.

    " full mock /ProductCollection (sap/ui/demo/mock/products.json) of the original sample
    DATA temp6 TYPE z2ui5_cl_smpc_app_235=>ty_t_product.
    DATA temp7 LIKE LINE OF temp6.
    DATA temp8 TYPE z2ui5_cl_smpc_app_235=>ty_t_facet.
    DATA temp9 LIKE LINE OF temp8.
    DATA temp10 TYPE z2ui5_cl_smpc_app_235=>ty_t_facet.
    DATA temp11 LIKE LINE OF temp10.
    DATA temp12 LIKE LINE OF t_products.
    DATA lr_product LIKE REF TO temp12.
      DATA weight_kg LIKE lr_product->weightmeasure.
      DATA temp13 TYPE z2ui5_cl_smpc_app_235=>ty_s_product-weight_state.
    CLEAR temp6.
    
    temp7-name = `Notebook Basic 15`.
    temp7-category = `Laptops`.
    temp7-suppliername = `Very Best Screens`.
    temp7-width = `30`.
    temp7-depth = `18`.
    temp7-height = `3`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `4.2`.
    temp7-weightunit = `KG`.
    temp7-price = `956.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Notebook Basic 17`.
    temp7-category = `Laptops`.
    temp7-suppliername = `Very Best Screens`.
    temp7-width = `29`.
    temp7-depth = `17`.
    temp7-height = `3.1`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `4.5`.
    temp7-weightunit = `KG`.
    temp7-price = `1249.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Notebook Basic 18`.
    temp7-category = `Laptops`.
    temp7-suppliername = `Very Best Screens`.
    temp7-width = `28`.
    temp7-depth = `19`.
    temp7-height = `2.5`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `4.2`.
    temp7-weightunit = `KG`.
    temp7-price = `1570.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Notebook Basic 19`.
    temp7-category = `Laptops`.
    temp7-suppliername = `Smartcards`.
    temp7-width = `32`.
    temp7-depth = `21`.
    temp7-height = `4`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `4.2`.
    temp7-weightunit = `KG`.
    temp7-price = `1650.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `ITelO Vault`.
    temp7-category = `Accessories`.
    temp7-suppliername = `Technocom`.
    temp7-width = `32`.
    temp7-depth = `22`.
    temp7-height = `3`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.2`.
    temp7-weightunit = `KG`.
    temp7-price = `299.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Notebook Professional 15`.
    temp7-category = `Accessories`.
    temp7-suppliername = `Very Best Screens`.
    temp7-width = `33`.
    temp7-depth = `20`.
    temp7-height = `3`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `4.3`.
    temp7-weightunit = `KG`.
    temp7-price = `1999.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Notebook Professional 17`.
    temp7-category = `Laptops`.
    temp7-suppliername = `Very Best Screens`.
    temp7-width = `33`.
    temp7-depth = `23`.
    temp7-height = `2`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `4.1`.
    temp7-weightunit = `KG`.
    temp7-price = `2299.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `ITelO Vault Net`.
    temp7-category = `Accessories`.
    temp7-suppliername = `Technocom`.
    temp7-width = `10`.
    temp7-depth = `1.8`.
    temp7-height = `17`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.16`.
    temp7-weightunit = `KG`.
    temp7-price = `459.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `ITelO Vault SAT`.
    temp7-category = `Accessories`.
    temp7-suppliername = `Technocom`.
    temp7-width = `11`.
    temp7-depth = `1.7`.
    temp7-height = `18`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.18`.
    temp7-weightunit = `KG`.
    temp7-price = `149.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Comfort Easy`.
    temp7-category = `Accessories`.
    temp7-suppliername = `Technocom`.
    temp7-width = `84`.
    temp7-depth = `1.5`.
    temp7-height = `14`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.2`.
    temp7-weightunit = `KG`.
    temp7-price = `1679.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Comfort Senior`.
    temp7-category = `Accessories`.
    temp7-suppliername = `Technocom`.
    temp7-width = `80`.
    temp7-depth = `1.6`.
    temp7-height = `13`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.8`.
    temp7-weightunit = `KG`.
    temp7-price = `512.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Ergo Screen E-I`.
    temp7-category = `Flat Screen Monitors`.
    temp7-suppliername = `Very Best Screens`.
    temp7-width = `37`.
    temp7-depth = `12`.
    temp7-height = `36`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `21`.
    temp7-weightunit = `KG`.
    temp7-price = `230.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Ergo Screen E-II`.
    temp7-category = `Flat Screen Monitors`.
    temp7-suppliername = `Very Best Screens`.
    temp7-width = `40.8`.
    temp7-depth = `19`.
    temp7-height = `43`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `21`.
    temp7-weightunit = `KG`.
    temp7-price = `285.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Ergo Screen E-III`.
    temp7-category = `Flat Screen Monitors`.
    temp7-suppliername = `Very Best Screens`.
    temp7-width = `40.8`.
    temp7-depth = `19`.
    temp7-height = `43`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `21`.
    temp7-weightunit = `KG`.
    temp7-price = `345.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Flat Basic`.
    temp7-category = `Flat Screen Monitors`.
    temp7-suppliername = `Very Best Screens`.
    temp7-width = `39`.
    temp7-depth = `20`.
    temp7-height = `41`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `14`.
    temp7-weightunit = `KG`.
    temp7-price = `399.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Flat Future`.
    temp7-category = `Flat Screen Monitors`.
    temp7-suppliername = `Very Best Screens`.
    temp7-width = `45`.
    temp7-depth = `26`.
    temp7-height = `46`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `15`.
    temp7-weightunit = `KG`.
    temp7-price = `430.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Flat XL`.
    temp7-category = `Flat Screen Monitors`.
    temp7-suppliername = `Very Best Screens`.
    temp7-width = `54.5`.
    temp7-depth = `22.1`.
    temp7-height = `39.1`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `17`.
    temp7-weightunit = `KG`.
    temp7-price = `1230.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Laser Professional Eco`.
    temp7-category = `Printers`.
    temp7-suppliername = `Alpha Printers`.
    temp7-width = `51`.
    temp7-depth = `46`.
    temp7-height = `30`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `32`.
    temp7-weightunit = `KG`.
    temp7-price = `830.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Laser Basic`.
    temp7-category = `Printers`.
    temp7-suppliername = `Alpha Printers`.
    temp7-width = `48`.
    temp7-depth = `42`.
    temp7-height = `26`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `23`.
    temp7-weightunit = `KG`.
    temp7-price = `490.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Laser Allround`.
    temp7-category = `Printers`.
    temp7-suppliername = `Alpha Printers`.
    temp7-width = `53`.
    temp7-depth = `50`.
    temp7-height = `65`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `17`.
    temp7-weightunit = `KG`.
    temp7-price = `349.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Ultra Jet Super Color`.
    temp7-category = `Printers`.
    temp7-suppliername = `Alpha Printers`.
    temp7-width = `41`.
    temp7-depth = `41`.
    temp7-height = `28`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `3`.
    temp7-weightunit = `KG`.
    temp7-price = `139.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Ultra Jet Mobile`.
    temp7-category = `Printers`.
    temp7-suppliername = `Printer for All`.
    temp7-width = `46`.
    temp7-depth = `32`.
    temp7-height = `25`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `1.9`.
    temp7-weightunit = `KG`.
    temp7-price = `99.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Ultra Jet Super Highspeed`.
    temp7-category = `Printers`.
    temp7-suppliername = `Printer for All`.
    temp7-width = `41`.
    temp7-depth = `41`.
    temp7-height = `28`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `18`.
    temp7-weightunit = `KG`.
    temp7-price = `170.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Multi Print`.
    temp7-category = `Multifunction Printers`.
    temp7-suppliername = `Printer for All`.
    temp7-width = `55`.
    temp7-depth = `45`.
    temp7-height = `29`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `6.3`.
    temp7-weightunit = `KG`.
    temp7-price = `99.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Multi Color`.
    temp7-category = `Multifunction Printers`.
    temp7-suppliername = `Printer for All`.
    temp7-width = `51`.
    temp7-depth = `41.3`.
    temp7-height = `22`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `4.3`.
    temp7-weightunit = `KG`.
    temp7-price = `119.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Cordless Mouse`.
    temp7-category = `Mice`.
    temp7-suppliername = `Oxynum`.
    temp7-width = `6`.
    temp7-depth = `14.5`.
    temp7-height = `3.5`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.09`.
    temp7-weightunit = `KG`.
    temp7-price = `9.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Speed Mouse`.
    temp7-category = `Mice`.
    temp7-suppliername = `Oxynum`.
    temp7-width = `7`.
    temp7-depth = `15`.
    temp7-height = `3.1`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.09`.
    temp7-weightunit = `KG`.
    temp7-price = `7.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Track Mouse`.
    temp7-category = `Mice`.
    temp7-suppliername = `Oxynum`.
    temp7-width = `3`.
    temp7-depth = `7`.
    temp7-height = `4`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.03`.
    temp7-weightunit = `KG`.
    temp7-price = `11.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Ergonomic Keyboard`.
    temp7-category = `Keyboards`.
    temp7-suppliername = `Oxynum`.
    temp7-width = `50`.
    temp7-depth = `21`.
    temp7-height = `3.5`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `2.1`.
    temp7-weightunit = `KG`.
    temp7-price = `14.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Internet Keyboard`.
    temp7-category = `Keyboards`.
    temp7-suppliername = `Oxynum`.
    temp7-width = `52`.
    temp7-depth = `25`.
    temp7-height = `3`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `1.8`.
    temp7-weightunit = `KG`.
    temp7-price = `16.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Media Keyboard`.
    temp7-category = `Keyboards`.
    temp7-suppliername = `Oxynum`.
    temp7-width = `51.4`.
    temp7-depth = `23`.
    temp7-height = `4`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `2.3`.
    temp7-weightunit = `KG`.
    temp7-price = `26.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Mousepad`.
    temp7-category = `Mousepads`.
    temp7-suppliername = `Oxynum`.
    temp7-width = `15`.
    temp7-depth = `6`.
    temp7-height = `0.2`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `80`.
    temp7-weightunit = `G`.
    temp7-price = `6.99`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Ergo Mousepad`.
    temp7-category = `Mousepads`.
    temp7-suppliername = `Oxynum`.
    temp7-width = `15`.
    temp7-depth = `6`.
    temp7-height = `0.2`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `80`.
    temp7-weightunit = `G`.
    temp7-price = `8.99`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Designer Mousepad`.
    temp7-category = `Mousepads`.
    temp7-suppliername = `Fasttech`.
    temp7-width = `24`.
    temp7-depth = `24`.
    temp7-height = `0.6`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `90`.
    temp7-weightunit = `G`.
    temp7-price = `12.99`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Universal card reader`.
    temp7-category = `Computer System Accessories`.
    temp7-suppliername = `Fasttech`.
    temp7-width = `6`.
    temp7-depth = `6`.
    temp7-height = `3`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `45`.
    temp7-weightunit = `G`.
    temp7-price = `14.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Proctra X`.
    temp7-category = `Graphic Cards`.
    temp7-suppliername = `Ultrasonic United`.
    temp7-width = `22`.
    temp7-depth = `35`.
    temp7-height = `17`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.255`.
    temp7-weightunit = `KG`.
    temp7-price = `70.90`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Gladiator MX`.
    temp7-category = `Graphic Cards`.
    temp7-suppliername = `Ultrasonic United`.
    temp7-width = `22`.
    temp7-depth = `35`.
    temp7-height = `17`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.3`.
    temp7-weightunit = `KG`.
    temp7-price = `81.70`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Hurricane GX`.
    temp7-category = `Graphic Cards`.
    temp7-suppliername = `Ultrasonic United`.
    temp7-width = `22`.
    temp7-depth = `35`.
    temp7-height = `17`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.4`.
    temp7-weightunit = `KG`.
    temp7-price = `101.20`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Hurricane GX/LN`.
    temp7-category = `Graphic Cards`.
    temp7-suppliername = `Smartcards`.
    temp7-width = `22`.
    temp7-depth = `35`.
    temp7-height = `17`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.4`.
    temp7-weightunit = `KG`.
    temp7-price = `139.99`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Photo Scan`.
    temp7-category = `Scanners`.
    temp7-suppliername = `Printer for All`.
    temp7-width = `34`.
    temp7-depth = `48`.
    temp7-height = `5`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `2.3`.
    temp7-weightunit = `KG`.
    temp7-price = `129.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Power Scan`.
    temp7-category = `Scanners`.
    temp7-suppliername = `Printer for All`.
    temp7-width = `31`.
    temp7-depth = `43`.
    temp7-height = `7`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `2.4`.
    temp7-weightunit = `KG`.
    temp7-price = `89.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Jet Scan Professional`.
    temp7-category = `Scanners`.
    temp7-suppliername = `Printer for All`.
    temp7-width = `33`.
    temp7-depth = `41`.
    temp7-height = `12`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `3.2`.
    temp7-weightunit = `KG`.
    temp7-price = `169.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Jet Scan Professional`.
    temp7-category = `Scanners`.
    temp7-suppliername = `Printer for All`.
    temp7-width = `35`.
    temp7-depth = `40`.
    temp7-height = `10`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `3.2`.
    temp7-weightunit = `KG`.
    temp7-price = `189.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Copymaster`.
    temp7-category = `Multifunction Printers`.
    temp7-suppliername = `Alpha Printers`.
    temp7-width = `45`.
    temp7-depth = `42`.
    temp7-height = `22`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `23.2`.
    temp7-weightunit = `KG`.
    temp7-price = `1499.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Surround Sound`.
    temp7-category = `Speakers`.
    temp7-suppliername = `Speaker Experts`.
    temp7-width = `12`.
    temp7-depth = `10`.
    temp7-height = `16`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `3`.
    temp7-weightunit = `KG`.
    temp7-price = `39.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Blaster Extreme`.
    temp7-category = `Speakers`.
    temp7-suppliername = `Speaker Experts`.
    temp7-width = `13`.
    temp7-depth = `11`.
    temp7-height = `17.5`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `1.4`.
    temp7-weightunit = `KG`.
    temp7-price = `26.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Sound Booster`.
    temp7-category = `Speakers`.
    temp7-suppliername = `Speaker Experts`.
    temp7-width = `12.4`.
    temp7-depth = `10.4`.
    temp7-height = `18.1`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `2.1`.
    temp7-weightunit = `KG`.
    temp7-price = `45.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Lovely Sound 5.1 Wireless`.
    temp7-category = `Accessories`.
    temp7-suppliername = `Fasttech`.
    temp7-width = `24`.
    temp7-depth = `19`.
    temp7-height = `23`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `80`.
    temp7-weightunit = `G`.
    temp7-price = `49.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Lovely Sound 5.1`.
    temp7-category = `Accessories`.
    temp7-suppliername = `Fasttech`.
    temp7-width = `25`.
    temp7-depth = `17`.
    temp7-height = `19`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `130`.
    temp7-weightunit = `G`.
    temp7-price = `39.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Lovely Sound Stereo`.
    temp7-category = `Accessories`.
    temp7-suppliername = `Fasttech`.
    temp7-width = `21.3`.
    temp7-depth = `2.4`.
    temp7-height = `19.7`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `60`.
    temp7-weightunit = `G`.
    temp7-price = `29.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Smart Office`.
    temp7-category = `Software`.
    temp7-suppliername = `Technocom`.
    temp7-width = `15`.
    temp7-depth = `6.5`.
    temp7-height = `2.1`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `1.2`.
    temp7-weightunit = `KG`.
    temp7-price = `89.90`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Smart Design`.
    temp7-category = `Software`.
    temp7-suppliername = `Technocom`.
    temp7-width = `14`.
    temp7-depth = `6.7`.
    temp7-height = `24`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.8`.
    temp7-weightunit = `KG`.
    temp7-price = `79.90`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Smart Network`.
    temp7-category = `Software`.
    temp7-suppliername = `Technocom`.
    temp7-width = `16`.
    temp7-depth = `6`.
    temp7-height = `27`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.8`.
    temp7-weightunit = `KG`.
    temp7-price = `69.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Smart Multimedia`.
    temp7-category = `Software`.
    temp7-suppliername = `Technocom`.
    temp7-width = `11`.
    temp7-depth = `3.4`.
    temp7-height = `22`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.8`.
    temp7-weightunit = `KG`.
    temp7-price = `77.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Smart Games`.
    temp7-category = `Software`.
    temp7-suppliername = `Technocom`.
    temp7-width = `10`.
    temp7-depth = `3`.
    temp7-height = `30`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `1.1`.
    temp7-weightunit = `KG`.
    temp7-price = `55.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Smart Internet Antivirus`.
    temp7-category = `Software`.
    temp7-suppliername = `Brainsoft`.
    temp7-width = `16`.
    temp7-depth = `4`.
    temp7-height = `21`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.7`.
    temp7-weightunit = `KG`.
    temp7-price = `29.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Smart Firewall`.
    temp7-category = `Software`.
    temp7-suppliername = `Brainsoft`.
    temp7-width = `17.9`.
    temp7-depth = `4.2`.
    temp7-height = `23.1`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.9`.
    temp7-weightunit = `KG`.
    temp7-price = `34.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Smart Money`.
    temp7-category = `Software`.
    temp7-suppliername = `Brainsoft`.
    temp7-width = `12`.
    temp7-depth = `1.5`.
    temp7-height = `19`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.5`.
    temp7-weightunit = `KG`.
    temp7-price = `29.90`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `PC Lock`.
    temp7-category = `Computer System Accessories`.
    temp7-suppliername = `Red Point Stores`.
    temp7-width = `20`.
    temp7-depth = `8`.
    temp7-height = `4.3`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.03`.
    temp7-weightunit = `KG`.
    temp7-price = `8.90`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Notebook Lock`.
    temp7-category = `Computer System Accessories`.
    temp7-suppliername = `Red Point Stores`.
    temp7-width = `31`.
    temp7-depth = `9`.
    temp7-height = `7`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.02`.
    temp7-weightunit = `KG`.
    temp7-price = `6.90`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Web cam reality`.
    temp7-category = `Computer System Accessories`.
    temp7-suppliername = `Red Point Stores`.
    temp7-width = `9`.
    temp7-depth = `8.2`.
    temp7-height = `1.3`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.075`.
    temp7-weightunit = `KG`.
    temp7-price = `39.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Screen clean`.
    temp7-category = `Computer System Accessories`.
    temp7-suppliername = `Red Point Stores`.
    temp7-width = `2`.
    temp7-depth = `2`.
    temp7-height = `0.1`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.05`.
    temp7-weightunit = `KG`.
    temp7-price = `2.30`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Fabric bag professional`.
    temp7-category = `Computer System Accessories`.
    temp7-suppliername = `Red Point Stores`.
    temp7-width = `42`.
    temp7-depth = `32`.
    temp7-height = `7`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `1.8`.
    temp7-weightunit = `KG`.
    temp7-price = `31.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Wireless DSL Router`.
    temp7-category = `Telecommunications`.
    temp7-suppliername = `Red Point Stores`.
    temp7-width = `19.3`.
    temp7-depth = `18`.
    temp7-height = `5`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.45`.
    temp7-weightunit = `KG`.
    temp7-price = `49.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Wireless DSL Router / Repeater`.
    temp7-category = `Telecommunications`.
    temp7-suppliername = `Red Point Stores`.
    temp7-width = `19.3`.
    temp7-depth = `18`.
    temp7-height = `5`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.45`.
    temp7-weightunit = `KG`.
    temp7-price = `59.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Wireless DSL Router / Repeater and Print Server`.
    temp7-category = `Telecommunications`.
    temp7-suppliername = `Technocom`.
    temp7-width = `19.3`.
    temp7-depth = `18`.
    temp7-height = `5`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.45`.
    temp7-weightunit = `KG`.
    temp7-price = `69.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `USB Stick`.
    temp7-category = `Computer System Accessories`.
    temp7-suppliername = `Technocom`.
    temp7-width = `1.5`.
    temp7-depth = `8.7`.
    temp7-height = `1.2`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.015`.
    temp7-weightunit = `KG`.
    temp7-price = `35.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Travel Adapter`.
    temp7-category = `Accessories`.
    temp7-suppliername = `Titanium`.
    temp7-width = `2`.
    temp7-depth = `3.1`.
    temp7-height = `3.9`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `88`.
    temp7-weightunit = `G`.
    temp7-price = `79.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Cordless Bluetooth Keyboard, english international`.
    temp7-category = `Keyboards`.
    temp7-suppliername = `Technocom`.
    temp7-width = `51.4`.
    temp7-depth = `23`.
    temp7-height = `4`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `1`.
    temp7-weightunit = `KG`.
    temp7-price = `29.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Flat XXL`.
    temp7-category = `Flat Screen Monitors`.
    temp7-suppliername = `Technocom`.
    temp7-width = `54`.
    temp7-depth = `22`.
    temp7-height = `38`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `18`.
    temp7-weightunit = `KG`.
    temp7-price = `1430.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Pocket Mouse`.
    temp7-category = `Mice`.
    temp7-suppliername = `Technocom`.
    temp7-width = `0.3`.
    temp7-depth = `0.5`.
    temp7-height = `1`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.02`.
    temp7-weightunit = `KG`.
    temp7-price = `23.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `PC Power Station`.
    temp7-category = `PCs`.
    temp7-suppliername = `Technocom`.
    temp7-width = `28`.
    temp7-depth = `31`.
    temp7-height = `43`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `2.3`.
    temp7-weightunit = `KG`.
    temp7-price = `2399.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Astro Laptop 1516`.
    temp7-category = `Laptops`.
    temp7-suppliername = `Ultrasonic United`.
    temp7-width = `30`.
    temp7-depth = `18`.
    temp7-height = `3`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `4.2`.
    temp7-weightunit = `KG`.
    temp7-price = `989.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Astro Phone 6`.
    temp7-category = `Smartphones and Tablets`.
    temp7-suppliername = `Ultrasonic United`.
    temp7-width = `8`.
    temp7-depth = `6`.
    temp7-height = `1.5`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.75`.
    temp7-weightunit = `KG`.
    temp7-price = `649.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Benda Laptop 1408`.
    temp7-category = `Laptops`.
    temp7-suppliername = `Ultrasonic United`.
    temp7-width = `30`.
    temp7-depth = `18`.
    temp7-height = `3`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `4.2`.
    temp7-weightunit = `KG`.
    temp7-price = `976.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Bending Screen 21HD`.
    temp7-category = `Flat Screens`.
    temp7-suppliername = `Ultrasonic United`.
    temp7-width = `37`.
    temp7-depth = `12`.
    temp7-height = `36`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `15`.
    temp7-weightunit = `KG`.
    temp7-price = `250.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Broad Screen 22HD`.
    temp7-category = `Flat Screens`.
    temp7-suppliername = `Ultrasonic United`.
    temp7-width = `39`.
    temp7-depth = `12`.
    temp7-height = `38`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `16`.
    temp7-weightunit = `KG`.
    temp7-price = `270.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Cerdik Phone 7`.
    temp7-category = `Smartphones and Tablets`.
    temp7-suppliername = `Ultrasonic United`.
    temp7-width = `9`.
    temp7-depth = `15`.
    temp7-height = `1.5`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.75`.
    temp7-weightunit = `KG`.
    temp7-price = `549.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Cepat Tablet 10.5`.
    temp7-category = `Smartphones and Tablets`.
    temp7-suppliername = `Ultrasonic United`.
    temp7-width = `48`.
    temp7-depth = `31`.
    temp7-height = `4.5`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `2.8`.
    temp7-weightunit = `KG`.
    temp7-price = `549.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Cepat Tablet 8`.
    temp7-category = `Smartphones and Tablets`.
    temp7-suppliername = `Ultrasonic United`.
    temp7-width = `38`.
    temp7-depth = `21`.
    temp7-height = `3.5`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `2.5`.
    temp7-weightunit = `KG`.
    temp7-price = `529.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Server Basic`.
    temp7-category = `Servers`.
    temp7-suppliername = `Technocom`.
    temp7-width = `34`.
    temp7-depth = `35`.
    temp7-height = `23`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `18`.
    temp7-weightunit = `KG`.
    temp7-price = `5000.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Server Professional`.
    temp7-category = `Servers`.
    temp7-suppliername = `Technocom`.
    temp7-width = `29`.
    temp7-depth = `30`.
    temp7-height = `27`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `25`.
    temp7-weightunit = `KG`.
    temp7-price = `15000.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Server Power Pro`.
    temp7-category = `Servers`.
    temp7-suppliername = `Technocom`.
    temp7-width = `22`.
    temp7-depth = `27.3`.
    temp7-height = `37`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `35`.
    temp7-weightunit = `KG`.
    temp7-price = `25000.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Family PC Basic`.
    temp7-category = `Desktop Computers`.
    temp7-suppliername = `Titanium`.
    temp7-width = `21.4`.
    temp7-depth = `29`.
    temp7-height = `38`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `4.8`.
    temp7-weightunit = `KG`.
    temp7-price = `600.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Family PC Pro`.
    temp7-category = `Desktop Computers`.
    temp7-suppliername = `Titanium`.
    temp7-width = `25`.
    temp7-depth = `31.7`.
    temp7-height = `40.2`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `5.3`.
    temp7-weightunit = `KG`.
    temp7-price = `900.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Gaming Monster`.
    temp7-category = `Desktop Computers`.
    temp7-suppliername = `Titanium`.
    temp7-width = `26.5`.
    temp7-depth = `34`.
    temp7-height = `47`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `5.9`.
    temp7-weightunit = `KG`.
    temp7-price = `1200.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Gaming Monster Pro`.
    temp7-category = `Desktop Computers`.
    temp7-suppliername = `Titanium`.
    temp7-width = `27`.
    temp7-depth = `28`.
    temp7-height = `42`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `6.8`.
    temp7-weightunit = `KG`.
    temp7-price = `1700.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `7" Widescreen Portable DVD Player w MP3`.
    temp7-category = `Accessories`.
    temp7-suppliername = `Titanium`.
    temp7-width = `21.4`.
    temp7-depth = `19`.
    temp7-height = `27.6`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.79`.
    temp7-weightunit = `KG`.
    temp7-price = `249.99`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `10" Portable DVD player`.
    temp7-category = `Accessories`.
    temp7-suppliername = `Titanium`.
    temp7-width = `24`.
    temp7-depth = `19.5`.
    temp7-height = `29`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.84`.
    temp7-weightunit = `KG`.
    temp7-price = `449.99`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Portable DVD Player with 9" LCD Monitor`.
    temp7-category = `Accessories`.
    temp7-suppliername = `Technocom`.
    temp7-width = `21`.
    temp7-depth = `16.5`.
    temp7-height = `14`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.72`.
    temp7-weightunit = `KG`.
    temp7-price = `853.99`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `CD/DVD case: 264 sleeves`.
    temp7-category = `Accessories`.
    temp7-suppliername = `Titanium`.
    temp7-width = `13`.
    temp7-depth = `13`.
    temp7-height = `20`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.65`.
    temp7-weightunit = `KG`.
    temp7-price = `44.99`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Audio/Video Cable Kit - 4m`.
    temp7-category = `Accessories`.
    temp7-suppliername = `Titanium`.
    temp7-width = `21`.
    temp7-depth = `10.2`.
    temp7-height = `13`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.2`.
    temp7-weightunit = `KG`.
    temp7-price = `29.99`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Removable CD/DVD Laser Labels`.
    temp7-category = `Accessories`.
    temp7-suppliername = `Titanium`.
    temp7-width = `5.5`.
    temp7-depth = `2`.
    temp7-height = `2`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.15`.
    temp7-weightunit = `KG`.
    temp7-price = `8.99`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Beam Breaker B-1`.
    temp7-category = `Accessories`.
    temp7-suppliername = `Titanium`.
    temp7-width = `30.4`.
    temp7-depth = `23.1`.
    temp7-height = `23`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `1.7`.
    temp7-weightunit = `KG`.
    temp7-price = `469.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Beam Breaker B-2`.
    temp7-category = `Accessories`.
    temp7-suppliername = `Technocom`.
    temp7-width = `30.4`.
    temp7-depth = `23.1`.
    temp7-height = `23`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `2`.
    temp7-weightunit = `KG`.
    temp7-price = `679.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Beam Breaker B-3`.
    temp7-category = `Accessories`.
    temp7-suppliername = `Technocom`.
    temp7-width = `30.4`.
    temp7-depth = `23.1`.
    temp7-height = `23`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `2.5`.
    temp7-weightunit = `KG`.
    temp7-price = `889.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Play Movie`.
    temp7-category = `Accessories`.
    temp7-suppliername = `Fasttech`.
    temp7-width = `37`.
    temp7-depth = `24`.
    temp7-height = `6`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `2.4`.
    temp7-weightunit = `KG`.
    temp7-price = `130.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Record Movie`.
    temp7-category = `Accessories`.
    temp7-suppliername = `Fasttech`.
    temp7-width = `38`.
    temp7-depth = `26`.
    temp7-height = `6.2`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `3.1`.
    temp7-weightunit = `KG`.
    temp7-price = `288.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `ITelo MusicStick`.
    temp7-category = `Accessories`.
    temp7-suppliername = `Fasttech`.
    temp7-width = `1.5`.
    temp7-depth = `6`.
    temp7-height = `1`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `134`.
    temp7-weightunit = `G`.
    temp7-price = `45.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `ITelo Jog-Mate`.
    temp7-category = `Accessories`.
    temp7-suppliername = `Fasttech`.
    temp7-width = `5.1`.
    temp7-depth = `8`.
    temp7-height = `9.2`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `134`.
    temp7-weightunit = `G`.
    temp7-price = `63.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Power Pro Player 40`.
    temp7-category = `Accessories`.
    temp7-suppliername = `Fasttech`.
    temp7-width = `5.1`.
    temp7-depth = `8`.
    temp7-height = `9.2`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `266`.
    temp7-weightunit = `G`.
    temp7-price = `167.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Power Pro Player 80`.
    temp7-category = `Accessories`.
    temp7-suppliername = `Fasttech`.
    temp7-width = `4`.
    temp7-depth = `6`.
    temp7-height = `0.8`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `267`.
    temp7-weightunit = `G`.
    temp7-price = `299.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Flat Watch HD32`.
    temp7-category = `Flat Screen TVs`.
    temp7-suppliername = `Very Best Screens`.
    temp7-width = `78`.
    temp7-depth = `22.1`.
    temp7-height = `55`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `2.6`.
    temp7-weightunit = `KG`.
    temp7-price = `1459.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Flat Watch HD37`.
    temp7-category = `Flat Screen TVs`.
    temp7-suppliername = `Very Best Screens`.
    temp7-width = `99.1`.
    temp7-depth = `26`.
    temp7-height = `61`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `2.2`.
    temp7-weightunit = `KG`.
    temp7-price = `1199.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Flat Watch HD41`.
    temp7-category = `Flat Screen TVs`.
    temp7-suppliername = `Very Best Screens`.
    temp7-width = `128`.
    temp7-depth = `23`.
    temp7-height = `79.1`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `1.8`.
    temp7-weightunit = `KG`.
    temp7-price = `899.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Copperberry`.
    temp7-category = `Accessories`.
    temp7-suppliername = `Fasttech`.
    temp7-width = `8.1`.
    temp7-depth = `13`.
    temp7-height = `12.1`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.5`.
    temp7-weightunit = `KG`.
    temp7-price = `549.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Silverberry`.
    temp7-category = `Accessories`.
    temp7-suppliername = `Fasttech`.
    temp7-width = `8.1`.
    temp7-depth = `13`.
    temp7-height = `12.1`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.5`.
    temp7-weightunit = `KG`.
    temp7-price = `549.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Goldberry`.
    temp7-category = `Accessories`.
    temp7-suppliername = `Fasttech`.
    temp7-width = `8.1`.
    temp7-depth = `13`.
    temp7-height = `12.1`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.5`.
    temp7-weightunit = `KG`.
    temp7-price = `549.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Platinberry`.
    temp7-category = `Accessories`.
    temp7-suppliername = `Fasttech`.
    temp7-width = `8.1`.
    temp7-depth = `13`.
    temp7-height = `12.1`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.5`.
    temp7-weightunit = `KG`.
    temp7-price = `549.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `ITelO FlexTop I4000`.
    temp7-category = `Laptops`.
    temp7-suppliername = `Titanium`.
    temp7-width = `31`.
    temp7-depth = `19`.
    temp7-height = `3.1`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `4`.
    temp7-weightunit = `KG`.
    temp7-price = `799.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `ITelO FlexTop I6300c`.
    temp7-category = `Laptops`.
    temp7-suppliername = `Titanium`.
    temp7-width = `32`.
    temp7-depth = `20`.
    temp7-height = `3.4`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `4.2`.
    temp7-weightunit = `KG`.
    temp7-price = `799.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `ITelO FlexTop I9100`.
    temp7-category = `Laptops`.
    temp7-suppliername = `Titanium`.
    temp7-width = `38`.
    temp7-depth = `21`.
    temp7-height = `4.1`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `3.5`.
    temp7-weightunit = `KG`.
    temp7-price = `1199.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `ITelO FlexTop I9800`.
    temp7-category = `Laptops`.
    temp7-suppliername = `Titanium`.
    temp7-width = `48`.
    temp7-depth = `31`.
    temp7-height = `4.5`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `3.8`.
    temp7-weightunit = `KG`.
    temp7-price = `1388.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Smartphone Leather Case`.
    temp7-category = `Accessories`.
    temp7-suppliername = `Ultrasonic United`.
    temp7-width = `48`.
    temp7-depth = `31`.
    temp7-height = `4.5`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.02`.
    temp7-weightunit = `KG`.
    temp7-price = `25.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Smartphone Alpha`.
    temp7-category = `Smartphones and Tablets`.
    temp7-suppliername = `Ultrasonic United`.
    temp7-width = `48`.
    temp7-depth = `31`.
    temp7-height = `4.5`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.75`.
    temp7-weightunit = `KG`.
    temp7-price = `599.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Mini Tablet`.
    temp7-category = `Smartphones and Tablets`.
    temp7-suppliername = `Ultrasonic United`.
    temp7-width = `48`.
    temp7-depth = `31`.
    temp7-height = `4.5`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `3.8`.
    temp7-weightunit = `KG`.
    temp7-price = `833.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Camcorder View`.
    temp7-category = `Accessories`.
    temp7-suppliername = `Ultrasonic United`.
    temp7-width = `48`.
    temp7-depth = `31`.
    temp7-height = `27`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `3.8`.
    temp7-weightunit = `KG`.
    temp7-price = `1388.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Tablet Pouch`.
    temp7-category = `Accessories`.
    temp7-suppliername = `Titanium`.
    temp7-width = `25`.
    temp7-depth = `40`.
    temp7-height = `4.5`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.03`.
    temp7-weightunit = `KG`.
    temp7-price = `20.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Tablet Pouch`.
    temp7-category = `Accessories`.
    temp7-suppliername = `Titanium`.
    temp7-width = `25`.
    temp7-depth = `40`.
    temp7-height = `4.5`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.03`.
    temp7-weightunit = `KG`.
    temp7-price = `20.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `e-Book Reader ReadMe`.
    temp7-category = `Smartphones and Tablets`.
    temp7-suppliername = `Titanium`.
    temp7-width = `48`.
    temp7-depth = `31`.
    temp7-height = `4.5`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `3.8`.
    temp7-weightunit = `KG`.
    temp7-price = `33.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Smartphone Beta`.
    temp7-category = `Smartphones and Tablets`.
    temp7-suppliername = `Titanium`.
    temp7-width = `48`.
    temp7-depth = `31`.
    temp7-height = `4.5`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.75`.
    temp7-weightunit = `KG`.
    temp7-price = `30.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Maxi Tablet`.
    temp7-category = `Tablets`.
    temp7-suppliername = `Titanium`.
    temp7-width = `48`.
    temp7-depth = `31`.
    temp7-height = `4.5`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `3.8`.
    temp7-weightunit = `KG`.
    temp7-price = `749.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Flyer`.
    temp7-category = `Accessories`.
    temp7-suppliername = `Titanium`.
    temp7-width = `46`.
    temp7-depth = `30`.
    temp7-height = `3`.
    temp7-dimunit = `cm`.
    temp7-weightmeasure = `0.01`.
    temp7-weightunit = `KG`.
    temp7-price = `0.00`.
    temp7-currencycode = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    t_products = temp6.

    " Facet values with the precomputed counters from the mock /ProductCollectionStats/Filters (1:1, as the original binds them)
    
    CLEAR temp8.
    
    temp9-text = `Accessories`.
    temp9-count = 34.
    INSERT temp9 INTO TABLE temp8.
    temp9-text = `Desktop Computers`.
    temp9-count = 7.
    INSERT temp9 INTO TABLE temp8.
    temp9-text = `Flat Screens`.
    temp9-count = 2.
    INSERT temp9 INTO TABLE temp8.
    temp9-text = `Keyboards`.
    temp9-count = 4.
    INSERT temp9 INTO TABLE temp8.
    temp9-text = `Laptops`.
    temp9-count = 11.
    INSERT temp9 INTO TABLE temp8.
    temp9-text = `Printers`.
    temp9-count = 9.
    INSERT temp9 INTO TABLE temp8.
    temp9-text = `Smartphones and Tablets`.
    temp9-count = 9.
    INSERT temp9 INTO TABLE temp8.
    temp9-text = `Mice`.
    temp9-count = 7.
    INSERT temp9 INTO TABLE temp8.
    temp9-text = `Computer System Accessories`.
    temp9-count = 8.
    INSERT temp9 INTO TABLE temp8.
    temp9-text = `Graphics Card`.
    temp9-count = 4.
    INSERT temp9 INTO TABLE temp8.
    temp9-text = `Scanners`.
    temp9-count = 4.
    INSERT temp9 INTO TABLE temp8.
    temp9-text = `Speakers`.
    temp9-count = 3.
    INSERT temp9 INTO TABLE temp8.
    temp9-text = `Software`.
    temp9-count = 8.
    INSERT temp9 INTO TABLE temp8.
    temp9-text = `Telekommunikation`.
    temp9-count = 3.
    INSERT temp9 INTO TABLE temp8.
    temp9-text = `Servers`.
    temp9-count = 3.
    INSERT temp9 INTO TABLE temp8.
    temp9-text = `Flat Screen TVs`.
    temp9-count = 3.
    INSERT temp9 INTO TABLE temp8.
    t_categories = temp8.
    
    CLEAR temp10.
    
    temp11-text = `Titanium`.
    temp11-count = 21.
    INSERT temp11 INTO TABLE temp10.
    temp11-text = `Technocom`.
    temp11-count = 22.
    INSERT temp11 INTO TABLE temp10.
    temp11-text = `Red Point Stores`.
    temp11-count = 7.
    INSERT temp11 INTO TABLE temp10.
    temp11-text = `Very Best Screens`.
    temp11-count = 14.
    INSERT temp11 INTO TABLE temp10.
    temp11-text = `Smartcards`.
    temp11-count = 2.
    INSERT temp11 INTO TABLE temp10.
    temp11-text = `Alpha Printers`.
    temp11-count = 5.
    INSERT temp11 INTO TABLE temp10.
    temp11-text = `Printer for All`.
    temp11-count = 8.
    INSERT temp11 INTO TABLE temp10.
    temp11-text = `Oxynum`.
    temp11-count = 8.
    INSERT temp11 INTO TABLE temp10.
    temp11-text = `Fasttech`.
    temp11-count = 15.
    INSERT temp11 INTO TABLE temp10.
    temp11-text = `Ultrasonic United`.
    temp11-count = 15.
    INSERT temp11 INTO TABLE temp10.
    temp11-text = `Speaker Experts`.
    temp11-count = 3.
    INSERT temp11 INTO TABLE temp10.
    temp11-text = `Brainsoft`.
    temp11-count = 3.
    INSERT temp11 INTO TABLE temp10.
    t_suppliers = temp10.


    " weightState is business logic (KG conversion + Success/Warning/Error
    " thresholds), not presentation - abap2UI5 is a thin frontend, so the
    " ObjectNumber state is computed here in the backend (the original does it in
    " its frontend Formatter.js, which a faithful port moves server-side).
    
    
    LOOP AT t_products REFERENCE INTO lr_product.
      
      weight_kg = lr_product->weightmeasure.
      IF lr_product->weightunit = `G`.
        weight_kg = weight_kg / 1000.
      ENDIF.
      
      IF weight_kg < 0.
        temp13 = `None`.
      ELSEIF weight_kg < 1.
        temp13 = `Success`.
      ELSEIF weight_kg < 5.
        temp13 = `Warning`.
      ELSE.
        temp13 = `Error`.
      ENDIF.
      lr_product->weight_state = temp13.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
