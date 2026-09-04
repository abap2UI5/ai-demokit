" @keywords facetfilter facet filter sap.m facetfiltercustomfilters vbox facetfilterlist facetfilteritem table overflowtoolbar title toolbarspacer
" @summary With the FacetFilter you can define custom filtering criteria to be applied when searching in the FacetFilterList instead of the default filtering criteria of the control in order to assist the user in narrowing down the data in, say, a table.
CLASS z2ui5_cl_smpc_app_557 DEFINITION PUBLIC.

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
      BEGIN OF ty_s_value,
        text     TYPE string,
        count    TYPE i,
        selected TYPE abap_bool,
      END OF ty_s_value.
    TYPES ty_t_value TYPE STANDARD TABLE OF ty_s_value WITH DEFAULT KEY.

    " one row per entry of the mock /ProductCollectionStats/Filters - the
    " FacetFilter binds its lists aggregation to this table
    TYPES:
      BEGIN OF ty_s_filter,
        type   TYPE string,
        key    TYPE string,
        values TYPE ty_t_value,
      END OF ty_s_filter.
    TYPES ty_t_filter TYPE STANDARD TABLE OF ty_s_filter WITH DEFAULT KEY.

    DATA t_products          TYPE ty_t_product.
    DATA t_sticky            TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
    " the bound lists collection, and the unsearched original behind it
    DATA t_filters           TYPE ty_t_filter.
    DATA t_filters_all       TYPE ty_t_filter.
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
    METHODS list_search IMPORTING title TYPE string
                                  term  TYPE string.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_557 IMPLEMENTATION.

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

    " the demo table of sap.m.sample.Table, which the original's onInit appends to
    " the VBox with its first cell swapped for an ObjectIdentifier, is rebuilt inline
    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    DATA temp2 TYPE z2ui5_if_client=>ty_s_event_control.
    DATA temp3 TYPE string_table.
    DATA temp4 TYPE string_table.
    DATA temp5 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `${$source>/title}` INTO TABLE temp1.
    INSERT `${$parameters>/term}` INTO TABLE temp1.
    
    CLEAR temp2.
    temp2-check_prevent_default = abap_true.
    
    CLEAR temp3.
    INSERT `${$source>/text}` INTO TABLE temp3.
    INSERT `${$parameters>/selected}` INTO TABLE temp3.
    
    CLEAR temp4.
    INSERT `${$source>/text}` INTO TABLE temp4.
    INSERT `${$parameters>/selected}` INTO TABLE temp4.
    
    CLEAR temp5.
    INSERT `${$source>/text}` INTO TABLE temp5.
    INSERT `${$parameters>/selected}` INTO TABLE temp5.
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
                )->a( n = `liveSearch`          v = `false`
                )->a( n = `showReset`           v = `true`
                )->a( n = `reset`               v = client->_event( `RESET` )
                )->a( n = `confirm`             v = client->_event( `CONFIRM` )
                )->a( n = `lists`               v = client->_bind( t_filters )

                " the list template: every facet group of the stats model becomes one
                " FacetFilterList whose items come from the group's own values table
                )->ele( `FacetFilterList`
                    )->a( n = `title`  v = `{TYPE}`
                    )->a( n = `key`    v = `{KEY}`
                    )->a( n = `mode`   v = `MultiSelect`
                    )->a( n = `items`  v = `{VALUES}`
                    " handleSearch replaces the built-in filtering with its own: it
                    " calls oEvent.preventDefault( ) FIRST and then filters the
                    " binding itself. check_prevent_default is that call - baked
                    " into this wire at render time, which is what the original
                    " does too (it vetoes on every search, not per term) - and the
                    " term round-trips so the backend narrows the group's values
                    )->a( n = `search` v = client->_event( val    = `SEARCH`
                                                           t_arg  = temp1
                                                           s_ctrl = temp2 )

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
                                                                   t_arg = temp3 )
                        )->tag( `CheckBox`
                            )->a( n = `text`   v = `HeaderToolbar`
                            )->a( n = `select` v = client->_event( val   = `STICKY_SELECT`
                                                                   t_arg = temp4 )
                        )->tag( `CheckBox`
                            )->a( n = `text`   v = `InfoToolbar`
                            )->a( n = `select` v = client->_event( val   = `STICKY_SELECT`
                                                                   t_arg = temp5 )
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
    " on t_filters/t_filters_all are class state that survives. Without this
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
        DATA temp4 LIKE LINE OF t_filters_all.
        DATA lr_group LIKE REF TO temp4.
          DATA temp5 LIKE LINE OF lr_group->values.
          DATA lr_value LIKE REF TO temp5.

    CASE client->get_event( ).

      WHEN `STICKY_SELECT`.
        " onSelect of the appended demo table: the controller maintains an array of
        " sap.m.Sticky keys and calls oTable.setSticky( ). The array is a bound string
        " table here (the app-009 pattern): the CheckBox round-trips its own text and
        " the selected flag, the backend keeps the set
        
        sticky_text = client->get_event_arg( ).
        
        temp3 = client->get_event_arg( 2 ).
        
        sticky_on = temp3.
        IF sticky_on = abap_true.
          INSERT sticky_text INTO TABLE t_sticky.
        ELSE.
          DELETE t_sticky WHERE table_line = sticky_text.
        ENDIF.

      WHEN `SEARCH`.
        " handleSearch: an empty term resets the group to its full value list, any
        " other term narrows it - the original builds the very same
        " Filter( 'text', Contains, term ) and applies it to the list's items binding
        list_search( title = client->get_event_arg( )
                     term  = client->get_event_arg( 2 ) ).

      WHEN `RESET`.
        " handleFacetFilterReset: clear every group's selection, drop the search
        " filters (Contains '') and re-filter the table with an empty filter
        
        
        LOOP AT t_filters_all REFERENCE INTO lr_group.
          
          
          LOOP AT lr_group->values REFERENCE INTO lr_value.
            lr_value->selected = abap_false.
          ENDLOOP.
        ENDLOOP.
        t_filters = t_filters_all.
        apply_filter( ).

      WHEN `CONFIRM`.
        " handleConfirm: build the compound filter from the selected flags, then toast
        apply_filter( ).
        client->message_toast_display( `confirm event fired` ).

    ENDCASE.

  ENDMETHOD.


  METHOD list_search.

    " the selection flags arrive on the bound table; they are carried over to the
    " master so that a later, wider term widens the list again without losing them
    DATA shown LIKE LINE OF t_filters.
      FIELD-SYMBOLS <master> TYPE z2ui5_cl_smpc_app_557=>ty_s_filter.
      DATA shown_value LIKE LINE OF shown-values.
        FIELD-SYMBOLS <master_value> TYPE z2ui5_cl_smpc_app_557=>ty_s_value.
    DATA temp6 LIKE LINE OF t_filters.
    DATA lr_group LIKE REF TO temp6.
      DATA temp7 TYPE ty_t_value.
      DATA kept LIKE temp7.
      DATA candidate LIKE LINE OF lr_group->values.
    LOOP AT t_filters INTO shown.
      
      READ TABLE t_filters_all WITH KEY type = shown-type ASSIGNING <master>.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.
      
      LOOP AT shown-values INTO shown_value.
        
        READ TABLE <master>-values WITH KEY text = shown_value-text ASSIGNING <master_value>.
        IF sy-subrc = 0.
          <master_value>-selected = shown_value-selected.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

    t_filters = t_filters_all.
    IF term IS INITIAL.
      RETURN.
    ENDIF.

    " Contains on a client model is case-insensitive; the original lower-cases the
    " term before building Filter( 'text', Contains, term )
    
    
    LOOP AT t_filters REFERENCE INTO lr_group WHERE type = title.
      
      CLEAR temp7.
      
      kept = temp7.
      
      LOOP AT lr_group->values INTO candidate.
        IF to_upper( candidate-text ) CS to_upper( term ).
          APPEND candidate TO kept.
        ENDIF.
      ENDLOOP.
      lr_group->values = kept.
    ENDLOOP.

  ENDMETHOD.


  METHOD apply_filter.
    DATA temp8 LIKE LINE OF t_filters.
    DATA lr_group LIKE REF TO temp8.
      DATA rows TYPE string.
      DATA column TYPE string.
      DATA value LIKE LINE OF lr_group->values.

    " _filterModel: ORs between the values of each group, ANDs between the groups -
    " expressed as a declarative compound filter on the table's items binding, the
    " model itself untouched (the original calls oTable.getBinding('items').filter)
    filter_live = `[`.

    
    
    LOOP AT t_filters REFERENCE INTO lr_group.
      
      rows = ``.
      " the original filters on the LIST TITLE (oList.getTitle()), which is the
      " stats group's type - Category / SupplierName
      
      column = to_upper( lr_group->type ).
      
      LOOP AT lr_group->values INTO value WHERE selected = abap_true.
        IF rows IS NOT INITIAL.
          rows = rows && `,`.
        ENDIF.
        rows = rows && |["{ column }","EQ","{ value-text }"]|.
      ENDLOOP.
      IF rows IS INITIAL.
        CONTINUE.
      ENDIF.
      IF filter_live <> `[`.
        filter_live = filter_live && `,`.
      ENDIF.
      filter_live = filter_live && |[{ rows }]|.
    ENDLOOP.

    filter_live = filter_live && `]`.

    filter_issue( ).

  ENDMETHOD.


  METHOD filter_issue.

    " the declarative compound filter on the table's items binding.
    " Issued from apply_filter( ) and again from view_display( ), because the filter lives on the binding and not in the model
    DATA temp9 TYPE string_table.
    CLEAR temp9.
    INSERT `idProductsTable` INTO TABLE temp9.
    INSERT `items` INTO TABLE temp9.
    INSERT `filter` INTO TABLE temp9.
    INSERT filter_live INTO TABLE temp9.
    client->follow_up_action( val   = client->cs_event-binding_call
                              t_arg = temp9 ).

  ENDMETHOD.


  METHOD model_init.

    " full mock /ProductCollection (sap/ui/demo/mock/products.json) of the original sample
    DATA temp11 TYPE z2ui5_cl_smpc_app_557=>ty_t_product.
    DATA temp12 LIKE LINE OF temp11.
    DATA temp13 TYPE z2ui5_cl_smpc_app_557=>ty_t_filter.
    DATA temp14 LIKE LINE OF temp13.
    DATA temp3 TYPE z2ui5_cl_smpc_app_557=>ty_t_value.
    DATA temp4 LIKE LINE OF temp3.
    DATA temp5 TYPE z2ui5_cl_smpc_app_557=>ty_t_value.
    DATA temp6 LIKE LINE OF temp5.
    DATA temp15 LIKE LINE OF t_products.
    DATA lr_product LIKE REF TO temp15.
      DATA weight_kg LIKE lr_product->weightmeasure.
      DATA temp16 TYPE z2ui5_cl_smpc_app_557=>ty_s_product-weight_state.
    CLEAR temp11.
    
    temp12-name = `Notebook Basic 15`.
    temp12-category = `Laptops`.
    temp12-suppliername = `Very Best Screens`.
    temp12-width = `30`.
    temp12-depth = `18`.
    temp12-height = `3`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `4.2`.
    temp12-weightunit = `KG`.
    temp12-price = `956.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Notebook Basic 17`.
    temp12-category = `Laptops`.
    temp12-suppliername = `Very Best Screens`.
    temp12-width = `29`.
    temp12-depth = `17`.
    temp12-height = `3.1`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `4.5`.
    temp12-weightunit = `KG`.
    temp12-price = `1249.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Notebook Basic 18`.
    temp12-category = `Laptops`.
    temp12-suppliername = `Very Best Screens`.
    temp12-width = `28`.
    temp12-depth = `19`.
    temp12-height = `2.5`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `4.2`.
    temp12-weightunit = `KG`.
    temp12-price = `1570.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Notebook Basic 19`.
    temp12-category = `Laptops`.
    temp12-suppliername = `Smartcards`.
    temp12-width = `32`.
    temp12-depth = `21`.
    temp12-height = `4`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `4.2`.
    temp12-weightunit = `KG`.
    temp12-price = `1650.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `ITelO Vault`.
    temp12-category = `Accessories`.
    temp12-suppliername = `Technocom`.
    temp12-width = `32`.
    temp12-depth = `22`.
    temp12-height = `3`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.2`.
    temp12-weightunit = `KG`.
    temp12-price = `299.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Notebook Professional 15`.
    temp12-category = `Accessories`.
    temp12-suppliername = `Very Best Screens`.
    temp12-width = `33`.
    temp12-depth = `20`.
    temp12-height = `3`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `4.3`.
    temp12-weightunit = `KG`.
    temp12-price = `1999.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Notebook Professional 17`.
    temp12-category = `Laptops`.
    temp12-suppliername = `Very Best Screens`.
    temp12-width = `33`.
    temp12-depth = `23`.
    temp12-height = `2`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `4.1`.
    temp12-weightunit = `KG`.
    temp12-price = `2299.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `ITelO Vault Net`.
    temp12-category = `Accessories`.
    temp12-suppliername = `Technocom`.
    temp12-width = `10`.
    temp12-depth = `1.8`.
    temp12-height = `17`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.16`.
    temp12-weightunit = `KG`.
    temp12-price = `459.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `ITelO Vault SAT`.
    temp12-category = `Accessories`.
    temp12-suppliername = `Technocom`.
    temp12-width = `11`.
    temp12-depth = `1.7`.
    temp12-height = `18`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.18`.
    temp12-weightunit = `KG`.
    temp12-price = `149.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Comfort Easy`.
    temp12-category = `Accessories`.
    temp12-suppliername = `Technocom`.
    temp12-width = `84`.
    temp12-depth = `1.5`.
    temp12-height = `14`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.2`.
    temp12-weightunit = `KG`.
    temp12-price = `1679.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Comfort Senior`.
    temp12-category = `Accessories`.
    temp12-suppliername = `Technocom`.
    temp12-width = `80`.
    temp12-depth = `1.6`.
    temp12-height = `13`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.8`.
    temp12-weightunit = `KG`.
    temp12-price = `512.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Ergo Screen E-I`.
    temp12-category = `Flat Screen Monitors`.
    temp12-suppliername = `Very Best Screens`.
    temp12-width = `37`.
    temp12-depth = `12`.
    temp12-height = `36`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `21`.
    temp12-weightunit = `KG`.
    temp12-price = `230.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Ergo Screen E-II`.
    temp12-category = `Flat Screen Monitors`.
    temp12-suppliername = `Very Best Screens`.
    temp12-width = `40.8`.
    temp12-depth = `19`.
    temp12-height = `43`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `21`.
    temp12-weightunit = `KG`.
    temp12-price = `285.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Ergo Screen E-III`.
    temp12-category = `Flat Screen Monitors`.
    temp12-suppliername = `Very Best Screens`.
    temp12-width = `40.8`.
    temp12-depth = `19`.
    temp12-height = `43`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `21`.
    temp12-weightunit = `KG`.
    temp12-price = `345.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Flat Basic`.
    temp12-category = `Flat Screen Monitors`.
    temp12-suppliername = `Very Best Screens`.
    temp12-width = `39`.
    temp12-depth = `20`.
    temp12-height = `41`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `14`.
    temp12-weightunit = `KG`.
    temp12-price = `399.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Flat Future`.
    temp12-category = `Flat Screen Monitors`.
    temp12-suppliername = `Very Best Screens`.
    temp12-width = `45`.
    temp12-depth = `26`.
    temp12-height = `46`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `15`.
    temp12-weightunit = `KG`.
    temp12-price = `430.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Flat XL`.
    temp12-category = `Flat Screen Monitors`.
    temp12-suppliername = `Very Best Screens`.
    temp12-width = `54.5`.
    temp12-depth = `22.1`.
    temp12-height = `39.1`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `17`.
    temp12-weightunit = `KG`.
    temp12-price = `1230.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Laser Professional Eco`.
    temp12-category = `Printers`.
    temp12-suppliername = `Alpha Printers`.
    temp12-width = `51`.
    temp12-depth = `46`.
    temp12-height = `30`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `32`.
    temp12-weightunit = `KG`.
    temp12-price = `830.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Laser Basic`.
    temp12-category = `Printers`.
    temp12-suppliername = `Alpha Printers`.
    temp12-width = `48`.
    temp12-depth = `42`.
    temp12-height = `26`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `23`.
    temp12-weightunit = `KG`.
    temp12-price = `490.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Laser Allround`.
    temp12-category = `Printers`.
    temp12-suppliername = `Alpha Printers`.
    temp12-width = `53`.
    temp12-depth = `50`.
    temp12-height = `65`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `17`.
    temp12-weightunit = `KG`.
    temp12-price = `349.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Ultra Jet Super Color`.
    temp12-category = `Printers`.
    temp12-suppliername = `Alpha Printers`.
    temp12-width = `41`.
    temp12-depth = `41`.
    temp12-height = `28`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `3`.
    temp12-weightunit = `KG`.
    temp12-price = `139.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Ultra Jet Mobile`.
    temp12-category = `Printers`.
    temp12-suppliername = `Printer for All`.
    temp12-width = `46`.
    temp12-depth = `32`.
    temp12-height = `25`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `1.9`.
    temp12-weightunit = `KG`.
    temp12-price = `99.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Ultra Jet Super Highspeed`.
    temp12-category = `Printers`.
    temp12-suppliername = `Printer for All`.
    temp12-width = `41`.
    temp12-depth = `41`.
    temp12-height = `28`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `18`.
    temp12-weightunit = `KG`.
    temp12-price = `170.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Multi Print`.
    temp12-category = `Multifunction Printers`.
    temp12-suppliername = `Printer for All`.
    temp12-width = `55`.
    temp12-depth = `45`.
    temp12-height = `29`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `6.3`.
    temp12-weightunit = `KG`.
    temp12-price = `99.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Multi Color`.
    temp12-category = `Multifunction Printers`.
    temp12-suppliername = `Printer for All`.
    temp12-width = `51`.
    temp12-depth = `41.3`.
    temp12-height = `22`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `4.3`.
    temp12-weightunit = `KG`.
    temp12-price = `119.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Cordless Mouse`.
    temp12-category = `Mice`.
    temp12-suppliername = `Oxynum`.
    temp12-width = `6`.
    temp12-depth = `14.5`.
    temp12-height = `3.5`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.09`.
    temp12-weightunit = `KG`.
    temp12-price = `9.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Speed Mouse`.
    temp12-category = `Mice`.
    temp12-suppliername = `Oxynum`.
    temp12-width = `7`.
    temp12-depth = `15`.
    temp12-height = `3.1`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.09`.
    temp12-weightunit = `KG`.
    temp12-price = `7.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Track Mouse`.
    temp12-category = `Mice`.
    temp12-suppliername = `Oxynum`.
    temp12-width = `3`.
    temp12-depth = `7`.
    temp12-height = `4`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.03`.
    temp12-weightunit = `KG`.
    temp12-price = `11.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Ergonomic Keyboard`.
    temp12-category = `Keyboards`.
    temp12-suppliername = `Oxynum`.
    temp12-width = `50`.
    temp12-depth = `21`.
    temp12-height = `3.5`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `2.1`.
    temp12-weightunit = `KG`.
    temp12-price = `14.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Internet Keyboard`.
    temp12-category = `Keyboards`.
    temp12-suppliername = `Oxynum`.
    temp12-width = `52`.
    temp12-depth = `25`.
    temp12-height = `3`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `1.8`.
    temp12-weightunit = `KG`.
    temp12-price = `16.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Media Keyboard`.
    temp12-category = `Keyboards`.
    temp12-suppliername = `Oxynum`.
    temp12-width = `51.4`.
    temp12-depth = `23`.
    temp12-height = `4`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `2.3`.
    temp12-weightunit = `KG`.
    temp12-price = `26.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Mousepad`.
    temp12-category = `Mousepads`.
    temp12-suppliername = `Oxynum`.
    temp12-width = `15`.
    temp12-depth = `6`.
    temp12-height = `0.2`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `80`.
    temp12-weightunit = `G`.
    temp12-price = `6.99`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Ergo Mousepad`.
    temp12-category = `Mousepads`.
    temp12-suppliername = `Oxynum`.
    temp12-width = `15`.
    temp12-depth = `6`.
    temp12-height = `0.2`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `80`.
    temp12-weightunit = `G`.
    temp12-price = `8.99`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Designer Mousepad`.
    temp12-category = `Mousepads`.
    temp12-suppliername = `Fasttech`.
    temp12-width = `24`.
    temp12-depth = `24`.
    temp12-height = `0.6`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `90`.
    temp12-weightunit = `G`.
    temp12-price = `12.99`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Universal card reader`.
    temp12-category = `Computer System Accessories`.
    temp12-suppliername = `Fasttech`.
    temp12-width = `6`.
    temp12-depth = `6`.
    temp12-height = `3`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `45`.
    temp12-weightunit = `G`.
    temp12-price = `14.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Proctra X`.
    temp12-category = `Graphic Cards`.
    temp12-suppliername = `Ultrasonic United`.
    temp12-width = `22`.
    temp12-depth = `35`.
    temp12-height = `17`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.255`.
    temp12-weightunit = `KG`.
    temp12-price = `70.90`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Gladiator MX`.
    temp12-category = `Graphic Cards`.
    temp12-suppliername = `Ultrasonic United`.
    temp12-width = `22`.
    temp12-depth = `35`.
    temp12-height = `17`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.3`.
    temp12-weightunit = `KG`.
    temp12-price = `81.70`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Hurricane GX`.
    temp12-category = `Graphic Cards`.
    temp12-suppliername = `Ultrasonic United`.
    temp12-width = `22`.
    temp12-depth = `35`.
    temp12-height = `17`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.4`.
    temp12-weightunit = `KG`.
    temp12-price = `101.20`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Hurricane GX/LN`.
    temp12-category = `Graphic Cards`.
    temp12-suppliername = `Smartcards`.
    temp12-width = `22`.
    temp12-depth = `35`.
    temp12-height = `17`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.4`.
    temp12-weightunit = `KG`.
    temp12-price = `139.99`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Photo Scan`.
    temp12-category = `Scanners`.
    temp12-suppliername = `Printer for All`.
    temp12-width = `34`.
    temp12-depth = `48`.
    temp12-height = `5`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `2.3`.
    temp12-weightunit = `KG`.
    temp12-price = `129.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Power Scan`.
    temp12-category = `Scanners`.
    temp12-suppliername = `Printer for All`.
    temp12-width = `31`.
    temp12-depth = `43`.
    temp12-height = `7`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `2.4`.
    temp12-weightunit = `KG`.
    temp12-price = `89.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Jet Scan Professional`.
    temp12-category = `Scanners`.
    temp12-suppliername = `Printer for All`.
    temp12-width = `33`.
    temp12-depth = `41`.
    temp12-height = `12`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `3.2`.
    temp12-weightunit = `KG`.
    temp12-price = `169.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Jet Scan Professional`.
    temp12-category = `Scanners`.
    temp12-suppliername = `Printer for All`.
    temp12-width = `35`.
    temp12-depth = `40`.
    temp12-height = `10`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `3.2`.
    temp12-weightunit = `KG`.
    temp12-price = `189.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Copymaster`.
    temp12-category = `Multifunction Printers`.
    temp12-suppliername = `Alpha Printers`.
    temp12-width = `45`.
    temp12-depth = `42`.
    temp12-height = `22`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `23.2`.
    temp12-weightunit = `KG`.
    temp12-price = `1499.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Surround Sound`.
    temp12-category = `Speakers`.
    temp12-suppliername = `Speaker Experts`.
    temp12-width = `12`.
    temp12-depth = `10`.
    temp12-height = `16`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `3`.
    temp12-weightunit = `KG`.
    temp12-price = `39.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Blaster Extreme`.
    temp12-category = `Speakers`.
    temp12-suppliername = `Speaker Experts`.
    temp12-width = `13`.
    temp12-depth = `11`.
    temp12-height = `17.5`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `1.4`.
    temp12-weightunit = `KG`.
    temp12-price = `26.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Sound Booster`.
    temp12-category = `Speakers`.
    temp12-suppliername = `Speaker Experts`.
    temp12-width = `12.4`.
    temp12-depth = `10.4`.
    temp12-height = `18.1`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `2.1`.
    temp12-weightunit = `KG`.
    temp12-price = `45.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Lovely Sound 5.1 Wireless`.
    temp12-category = `Accessories`.
    temp12-suppliername = `Fasttech`.
    temp12-width = `24`.
    temp12-depth = `19`.
    temp12-height = `23`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `80`.
    temp12-weightunit = `G`.
    temp12-price = `49.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Lovely Sound 5.1`.
    temp12-category = `Accessories`.
    temp12-suppliername = `Fasttech`.
    temp12-width = `25`.
    temp12-depth = `17`.
    temp12-height = `19`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `130`.
    temp12-weightunit = `G`.
    temp12-price = `39.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Lovely Sound Stereo`.
    temp12-category = `Accessories`.
    temp12-suppliername = `Fasttech`.
    temp12-width = `21.3`.
    temp12-depth = `2.4`.
    temp12-height = `19.7`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `60`.
    temp12-weightunit = `G`.
    temp12-price = `29.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Smart Office`.
    temp12-category = `Software`.
    temp12-suppliername = `Technocom`.
    temp12-width = `15`.
    temp12-depth = `6.5`.
    temp12-height = `2.1`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `1.2`.
    temp12-weightunit = `KG`.
    temp12-price = `89.90`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Smart Design`.
    temp12-category = `Software`.
    temp12-suppliername = `Technocom`.
    temp12-width = `14`.
    temp12-depth = `6.7`.
    temp12-height = `24`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.8`.
    temp12-weightunit = `KG`.
    temp12-price = `79.90`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Smart Network`.
    temp12-category = `Software`.
    temp12-suppliername = `Technocom`.
    temp12-width = `16`.
    temp12-depth = `6`.
    temp12-height = `27`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.8`.
    temp12-weightunit = `KG`.
    temp12-price = `69.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Smart Multimedia`.
    temp12-category = `Software`.
    temp12-suppliername = `Technocom`.
    temp12-width = `11`.
    temp12-depth = `3.4`.
    temp12-height = `22`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.8`.
    temp12-weightunit = `KG`.
    temp12-price = `77.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Smart Games`.
    temp12-category = `Software`.
    temp12-suppliername = `Technocom`.
    temp12-width = `10`.
    temp12-depth = `3`.
    temp12-height = `30`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `1.1`.
    temp12-weightunit = `KG`.
    temp12-price = `55.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Smart Internet Antivirus`.
    temp12-category = `Software`.
    temp12-suppliername = `Brainsoft`.
    temp12-width = `16`.
    temp12-depth = `4`.
    temp12-height = `21`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.7`.
    temp12-weightunit = `KG`.
    temp12-price = `29.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Smart Firewall`.
    temp12-category = `Software`.
    temp12-suppliername = `Brainsoft`.
    temp12-width = `17.9`.
    temp12-depth = `4.2`.
    temp12-height = `23.1`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.9`.
    temp12-weightunit = `KG`.
    temp12-price = `34.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Smart Money`.
    temp12-category = `Software`.
    temp12-suppliername = `Brainsoft`.
    temp12-width = `12`.
    temp12-depth = `1.5`.
    temp12-height = `19`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.5`.
    temp12-weightunit = `KG`.
    temp12-price = `29.90`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `PC Lock`.
    temp12-category = `Computer System Accessories`.
    temp12-suppliername = `Red Point Stores`.
    temp12-width = `20`.
    temp12-depth = `8`.
    temp12-height = `4.3`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.03`.
    temp12-weightunit = `KG`.
    temp12-price = `8.90`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Notebook Lock`.
    temp12-category = `Computer System Accessories`.
    temp12-suppliername = `Red Point Stores`.
    temp12-width = `31`.
    temp12-depth = `9`.
    temp12-height = `7`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.02`.
    temp12-weightunit = `KG`.
    temp12-price = `6.90`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Web cam reality`.
    temp12-category = `Computer System Accessories`.
    temp12-suppliername = `Red Point Stores`.
    temp12-width = `9`.
    temp12-depth = `8.2`.
    temp12-height = `1.3`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.075`.
    temp12-weightunit = `KG`.
    temp12-price = `39.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Screen clean`.
    temp12-category = `Computer System Accessories`.
    temp12-suppliername = `Red Point Stores`.
    temp12-width = `2`.
    temp12-depth = `2`.
    temp12-height = `0.1`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.05`.
    temp12-weightunit = `KG`.
    temp12-price = `2.30`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Fabric bag professional`.
    temp12-category = `Computer System Accessories`.
    temp12-suppliername = `Red Point Stores`.
    temp12-width = `42`.
    temp12-depth = `32`.
    temp12-height = `7`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `1.8`.
    temp12-weightunit = `KG`.
    temp12-price = `31.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Wireless DSL Router`.
    temp12-category = `Telecommunications`.
    temp12-suppliername = `Red Point Stores`.
    temp12-width = `19.3`.
    temp12-depth = `18`.
    temp12-height = `5`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.45`.
    temp12-weightunit = `KG`.
    temp12-price = `49.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Wireless DSL Router / Repeater`.
    temp12-category = `Telecommunications`.
    temp12-suppliername = `Red Point Stores`.
    temp12-width = `19.3`.
    temp12-depth = `18`.
    temp12-height = `5`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.45`.
    temp12-weightunit = `KG`.
    temp12-price = `59.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Wireless DSL Router / Repeater and Print Server`.
    temp12-category = `Telecommunications`.
    temp12-suppliername = `Technocom`.
    temp12-width = `19.3`.
    temp12-depth = `18`.
    temp12-height = `5`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.45`.
    temp12-weightunit = `KG`.
    temp12-price = `69.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `USB Stick`.
    temp12-category = `Computer System Accessories`.
    temp12-suppliername = `Technocom`.
    temp12-width = `1.5`.
    temp12-depth = `8.7`.
    temp12-height = `1.2`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.015`.
    temp12-weightunit = `KG`.
    temp12-price = `35.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Travel Adapter`.
    temp12-category = `Accessories`.
    temp12-suppliername = `Titanium`.
    temp12-width = `2`.
    temp12-depth = `3.1`.
    temp12-height = `3.9`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `88`.
    temp12-weightunit = `G`.
    temp12-price = `79.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Cordless Bluetooth Keyboard, english international`.
    temp12-category = `Keyboards`.
    temp12-suppliername = `Technocom`.
    temp12-width = `51.4`.
    temp12-depth = `23`.
    temp12-height = `4`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `1`.
    temp12-weightunit = `KG`.
    temp12-price = `29.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Flat XXL`.
    temp12-category = `Flat Screen Monitors`.
    temp12-suppliername = `Technocom`.
    temp12-width = `54`.
    temp12-depth = `22`.
    temp12-height = `38`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `18`.
    temp12-weightunit = `KG`.
    temp12-price = `1430.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Pocket Mouse`.
    temp12-category = `Mice`.
    temp12-suppliername = `Technocom`.
    temp12-width = `0.3`.
    temp12-depth = `0.5`.
    temp12-height = `1`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.02`.
    temp12-weightunit = `KG`.
    temp12-price = `23.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `PC Power Station`.
    temp12-category = `PCs`.
    temp12-suppliername = `Technocom`.
    temp12-width = `28`.
    temp12-depth = `31`.
    temp12-height = `43`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `2.3`.
    temp12-weightunit = `KG`.
    temp12-price = `2399.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Astro Laptop 1516`.
    temp12-category = `Laptops`.
    temp12-suppliername = `Ultrasonic United`.
    temp12-width = `30`.
    temp12-depth = `18`.
    temp12-height = `3`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `4.2`.
    temp12-weightunit = `KG`.
    temp12-price = `989.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Astro Phone 6`.
    temp12-category = `Smartphones and Tablets`.
    temp12-suppliername = `Ultrasonic United`.
    temp12-width = `8`.
    temp12-depth = `6`.
    temp12-height = `1.5`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.75`.
    temp12-weightunit = `KG`.
    temp12-price = `649.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Benda Laptop 1408`.
    temp12-category = `Laptops`.
    temp12-suppliername = `Ultrasonic United`.
    temp12-width = `30`.
    temp12-depth = `18`.
    temp12-height = `3`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `4.2`.
    temp12-weightunit = `KG`.
    temp12-price = `976.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Bending Screen 21HD`.
    temp12-category = `Flat Screens`.
    temp12-suppliername = `Ultrasonic United`.
    temp12-width = `37`.
    temp12-depth = `12`.
    temp12-height = `36`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `15`.
    temp12-weightunit = `KG`.
    temp12-price = `250.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Broad Screen 22HD`.
    temp12-category = `Flat Screens`.
    temp12-suppliername = `Ultrasonic United`.
    temp12-width = `39`.
    temp12-depth = `12`.
    temp12-height = `38`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `16`.
    temp12-weightunit = `KG`.
    temp12-price = `270.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Cerdik Phone 7`.
    temp12-category = `Smartphones and Tablets`.
    temp12-suppliername = `Ultrasonic United`.
    temp12-width = `9`.
    temp12-depth = `15`.
    temp12-height = `1.5`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.75`.
    temp12-weightunit = `KG`.
    temp12-price = `549.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Cepat Tablet 10.5`.
    temp12-category = `Smartphones and Tablets`.
    temp12-suppliername = `Ultrasonic United`.
    temp12-width = `48`.
    temp12-depth = `31`.
    temp12-height = `4.5`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `2.8`.
    temp12-weightunit = `KG`.
    temp12-price = `549.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Cepat Tablet 8`.
    temp12-category = `Smartphones and Tablets`.
    temp12-suppliername = `Ultrasonic United`.
    temp12-width = `38`.
    temp12-depth = `21`.
    temp12-height = `3.5`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `2.5`.
    temp12-weightunit = `KG`.
    temp12-price = `529.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Server Basic`.
    temp12-category = `Servers`.
    temp12-suppliername = `Technocom`.
    temp12-width = `34`.
    temp12-depth = `35`.
    temp12-height = `23`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `18`.
    temp12-weightunit = `KG`.
    temp12-price = `5000.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Server Professional`.
    temp12-category = `Servers`.
    temp12-suppliername = `Technocom`.
    temp12-width = `29`.
    temp12-depth = `30`.
    temp12-height = `27`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `25`.
    temp12-weightunit = `KG`.
    temp12-price = `15000.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Server Power Pro`.
    temp12-category = `Servers`.
    temp12-suppliername = `Technocom`.
    temp12-width = `22`.
    temp12-depth = `27.3`.
    temp12-height = `37`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `35`.
    temp12-weightunit = `KG`.
    temp12-price = `25000.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Family PC Basic`.
    temp12-category = `Desktop Computers`.
    temp12-suppliername = `Titanium`.
    temp12-width = `21.4`.
    temp12-depth = `29`.
    temp12-height = `38`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `4.8`.
    temp12-weightunit = `KG`.
    temp12-price = `600.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Family PC Pro`.
    temp12-category = `Desktop Computers`.
    temp12-suppliername = `Titanium`.
    temp12-width = `25`.
    temp12-depth = `31.7`.
    temp12-height = `40.2`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `5.3`.
    temp12-weightunit = `KG`.
    temp12-price = `900.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Gaming Monster`.
    temp12-category = `Desktop Computers`.
    temp12-suppliername = `Titanium`.
    temp12-width = `26.5`.
    temp12-depth = `34`.
    temp12-height = `47`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `5.9`.
    temp12-weightunit = `KG`.
    temp12-price = `1200.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Gaming Monster Pro`.
    temp12-category = `Desktop Computers`.
    temp12-suppliername = `Titanium`.
    temp12-width = `27`.
    temp12-depth = `28`.
    temp12-height = `42`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `6.8`.
    temp12-weightunit = `KG`.
    temp12-price = `1700.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `7" Widescreen Portable DVD Player w MP3`.
    temp12-category = `Accessories`.
    temp12-suppliername = `Titanium`.
    temp12-width = `21.4`.
    temp12-depth = `19`.
    temp12-height = `27.6`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.79`.
    temp12-weightunit = `KG`.
    temp12-price = `249.99`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `10" Portable DVD player`.
    temp12-category = `Accessories`.
    temp12-suppliername = `Titanium`.
    temp12-width = `24`.
    temp12-depth = `19.5`.
    temp12-height = `29`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.84`.
    temp12-weightunit = `KG`.
    temp12-price = `449.99`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Portable DVD Player with 9" LCD Monitor`.
    temp12-category = `Accessories`.
    temp12-suppliername = `Technocom`.
    temp12-width = `21`.
    temp12-depth = `16.5`.
    temp12-height = `14`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.72`.
    temp12-weightunit = `KG`.
    temp12-price = `853.99`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `CD/DVD case: 264 sleeves`.
    temp12-category = `Accessories`.
    temp12-suppliername = `Titanium`.
    temp12-width = `13`.
    temp12-depth = `13`.
    temp12-height = `20`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.65`.
    temp12-weightunit = `KG`.
    temp12-price = `44.99`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Audio/Video Cable Kit - 4m`.
    temp12-category = `Accessories`.
    temp12-suppliername = `Titanium`.
    temp12-width = `21`.
    temp12-depth = `10.2`.
    temp12-height = `13`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.2`.
    temp12-weightunit = `KG`.
    temp12-price = `29.99`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Removable CD/DVD Laser Labels`.
    temp12-category = `Accessories`.
    temp12-suppliername = `Titanium`.
    temp12-width = `5.5`.
    temp12-depth = `2`.
    temp12-height = `2`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.15`.
    temp12-weightunit = `KG`.
    temp12-price = `8.99`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Beam Breaker B-1`.
    temp12-category = `Accessories`.
    temp12-suppliername = `Titanium`.
    temp12-width = `30.4`.
    temp12-depth = `23.1`.
    temp12-height = `23`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `1.7`.
    temp12-weightunit = `KG`.
    temp12-price = `469.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Beam Breaker B-2`.
    temp12-category = `Accessories`.
    temp12-suppliername = `Technocom`.
    temp12-width = `30.4`.
    temp12-depth = `23.1`.
    temp12-height = `23`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `2`.
    temp12-weightunit = `KG`.
    temp12-price = `679.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Beam Breaker B-3`.
    temp12-category = `Accessories`.
    temp12-suppliername = `Technocom`.
    temp12-width = `30.4`.
    temp12-depth = `23.1`.
    temp12-height = `23`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `2.5`.
    temp12-weightunit = `KG`.
    temp12-price = `889.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Play Movie`.
    temp12-category = `Accessories`.
    temp12-suppliername = `Fasttech`.
    temp12-width = `37`.
    temp12-depth = `24`.
    temp12-height = `6`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `2.4`.
    temp12-weightunit = `KG`.
    temp12-price = `130.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Record Movie`.
    temp12-category = `Accessories`.
    temp12-suppliername = `Fasttech`.
    temp12-width = `38`.
    temp12-depth = `26`.
    temp12-height = `6.2`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `3.1`.
    temp12-weightunit = `KG`.
    temp12-price = `288.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `ITelo MusicStick`.
    temp12-category = `Accessories`.
    temp12-suppliername = `Fasttech`.
    temp12-width = `1.5`.
    temp12-depth = `6`.
    temp12-height = `1`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `134`.
    temp12-weightunit = `G`.
    temp12-price = `45.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `ITelo Jog-Mate`.
    temp12-category = `Accessories`.
    temp12-suppliername = `Fasttech`.
    temp12-width = `5.1`.
    temp12-depth = `8`.
    temp12-height = `9.2`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `134`.
    temp12-weightunit = `G`.
    temp12-price = `63.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Power Pro Player 40`.
    temp12-category = `Accessories`.
    temp12-suppliername = `Fasttech`.
    temp12-width = `5.1`.
    temp12-depth = `8`.
    temp12-height = `9.2`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `266`.
    temp12-weightunit = `G`.
    temp12-price = `167.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Power Pro Player 80`.
    temp12-category = `Accessories`.
    temp12-suppliername = `Fasttech`.
    temp12-width = `4`.
    temp12-depth = `6`.
    temp12-height = `0.8`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `267`.
    temp12-weightunit = `G`.
    temp12-price = `299.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Flat Watch HD32`.
    temp12-category = `Flat Screen TVs`.
    temp12-suppliername = `Very Best Screens`.
    temp12-width = `78`.
    temp12-depth = `22.1`.
    temp12-height = `55`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `2.6`.
    temp12-weightunit = `KG`.
    temp12-price = `1459.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Flat Watch HD37`.
    temp12-category = `Flat Screen TVs`.
    temp12-suppliername = `Very Best Screens`.
    temp12-width = `99.1`.
    temp12-depth = `26`.
    temp12-height = `61`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `2.2`.
    temp12-weightunit = `KG`.
    temp12-price = `1199.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Flat Watch HD41`.
    temp12-category = `Flat Screen TVs`.
    temp12-suppliername = `Very Best Screens`.
    temp12-width = `128`.
    temp12-depth = `23`.
    temp12-height = `79.1`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `1.8`.
    temp12-weightunit = `KG`.
    temp12-price = `899.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Copperberry`.
    temp12-category = `Accessories`.
    temp12-suppliername = `Fasttech`.
    temp12-width = `8.1`.
    temp12-depth = `13`.
    temp12-height = `12.1`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.5`.
    temp12-weightunit = `KG`.
    temp12-price = `549.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Silverberry`.
    temp12-category = `Accessories`.
    temp12-suppliername = `Fasttech`.
    temp12-width = `8.1`.
    temp12-depth = `13`.
    temp12-height = `12.1`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.5`.
    temp12-weightunit = `KG`.
    temp12-price = `549.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Goldberry`.
    temp12-category = `Accessories`.
    temp12-suppliername = `Fasttech`.
    temp12-width = `8.1`.
    temp12-depth = `13`.
    temp12-height = `12.1`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.5`.
    temp12-weightunit = `KG`.
    temp12-price = `549.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Platinberry`.
    temp12-category = `Accessories`.
    temp12-suppliername = `Fasttech`.
    temp12-width = `8.1`.
    temp12-depth = `13`.
    temp12-height = `12.1`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.5`.
    temp12-weightunit = `KG`.
    temp12-price = `549.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `ITelO FlexTop I4000`.
    temp12-category = `Laptops`.
    temp12-suppliername = `Titanium`.
    temp12-width = `31`.
    temp12-depth = `19`.
    temp12-height = `3.1`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `4`.
    temp12-weightunit = `KG`.
    temp12-price = `799.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `ITelO FlexTop I6300c`.
    temp12-category = `Laptops`.
    temp12-suppliername = `Titanium`.
    temp12-width = `32`.
    temp12-depth = `20`.
    temp12-height = `3.4`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `4.2`.
    temp12-weightunit = `KG`.
    temp12-price = `799.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `ITelO FlexTop I9100`.
    temp12-category = `Laptops`.
    temp12-suppliername = `Titanium`.
    temp12-width = `38`.
    temp12-depth = `21`.
    temp12-height = `4.1`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `3.5`.
    temp12-weightunit = `KG`.
    temp12-price = `1199.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `ITelO FlexTop I9800`.
    temp12-category = `Laptops`.
    temp12-suppliername = `Titanium`.
    temp12-width = `48`.
    temp12-depth = `31`.
    temp12-height = `4.5`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `3.8`.
    temp12-weightunit = `KG`.
    temp12-price = `1388.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Smartphone Leather Case`.
    temp12-category = `Accessories`.
    temp12-suppliername = `Ultrasonic United`.
    temp12-width = `48`.
    temp12-depth = `31`.
    temp12-height = `4.5`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.02`.
    temp12-weightunit = `KG`.
    temp12-price = `25.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Smartphone Alpha`.
    temp12-category = `Smartphones and Tablets`.
    temp12-suppliername = `Ultrasonic United`.
    temp12-width = `48`.
    temp12-depth = `31`.
    temp12-height = `4.5`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.75`.
    temp12-weightunit = `KG`.
    temp12-price = `599.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Mini Tablet`.
    temp12-category = `Smartphones and Tablets`.
    temp12-suppliername = `Ultrasonic United`.
    temp12-width = `48`.
    temp12-depth = `31`.
    temp12-height = `4.5`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `3.8`.
    temp12-weightunit = `KG`.
    temp12-price = `833.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Camcorder View`.
    temp12-category = `Accessories`.
    temp12-suppliername = `Ultrasonic United`.
    temp12-width = `48`.
    temp12-depth = `31`.
    temp12-height = `27`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `3.8`.
    temp12-weightunit = `KG`.
    temp12-price = `1388.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Tablet Pouch`.
    temp12-category = `Accessories`.
    temp12-suppliername = `Titanium`.
    temp12-width = `25`.
    temp12-depth = `40`.
    temp12-height = `4.5`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.03`.
    temp12-weightunit = `KG`.
    temp12-price = `20.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Tablet Pouch`.
    temp12-category = `Accessories`.
    temp12-suppliername = `Titanium`.
    temp12-width = `25`.
    temp12-depth = `40`.
    temp12-height = `4.5`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.03`.
    temp12-weightunit = `KG`.
    temp12-price = `20.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `e-Book Reader ReadMe`.
    temp12-category = `Smartphones and Tablets`.
    temp12-suppliername = `Titanium`.
    temp12-width = `48`.
    temp12-depth = `31`.
    temp12-height = `4.5`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `3.8`.
    temp12-weightunit = `KG`.
    temp12-price = `33.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Smartphone Beta`.
    temp12-category = `Smartphones and Tablets`.
    temp12-suppliername = `Titanium`.
    temp12-width = `48`.
    temp12-depth = `31`.
    temp12-height = `4.5`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.75`.
    temp12-weightunit = `KG`.
    temp12-price = `30.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Maxi Tablet`.
    temp12-category = `Tablets`.
    temp12-suppliername = `Titanium`.
    temp12-width = `48`.
    temp12-depth = `31`.
    temp12-height = `4.5`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `3.8`.
    temp12-weightunit = `KG`.
    temp12-price = `749.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Flyer`.
    temp12-category = `Accessories`.
    temp12-suppliername = `Titanium`.
    temp12-width = `46`.
    temp12-depth = `30`.
    temp12-height = `3`.
    temp12-dimunit = `cm`.
    temp12-weightmeasure = `0.01`.
    temp12-weightunit = `KG`.
    temp12-price = `0.00`.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    t_products = temp11.

    " the mock /ProductCollectionStats/Filters, 1:1 - two groups, their values with
    " the precomputed counters. The stats entries carry no key field at all, so the
    " original's key="{key}" resolves undefined; the port leaves KEY empty for the
    " lists and binds the item key to the value text
    
    CLEAR temp13.
    
    temp14-type = `Category`.
    
    CLEAR temp3.
    
    temp4-text = `Accessories`.
    temp4-count = 34.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Desktop Computers`.
    temp4-count = 7.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Flat Screens`.
    temp4-count = 2.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Keyboards`.
    temp4-count = 4.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Laptops`.
    temp4-count = 11.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Printers`.
    temp4-count = 9.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Smartphones and Tablets`.
    temp4-count = 9.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Mice`.
    temp4-count = 7.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Computer System Accessories`.
    temp4-count = 8.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Graphics Card`.
    temp4-count = 4.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Scanners`.
    temp4-count = 4.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Speakers`.
    temp4-count = 3.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Software`.
    temp4-count = 8.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Telekommunikation`.
    temp4-count = 3.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Servers`.
    temp4-count = 3.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Flat Screen TVs`.
    temp4-count = 3.
    INSERT temp4 INTO TABLE temp3.
    temp14-values = temp3.
    INSERT temp14 INTO TABLE temp13.
    temp14-type = `SupplierName`.
    
    CLEAR temp5.
    
    temp6-text = `Titanium`.
    temp6-count = 21.
    INSERT temp6 INTO TABLE temp5.
    temp6-text = `Technocom`.
    temp6-count = 22.
    INSERT temp6 INTO TABLE temp5.
    temp6-text = `Red Point Stores`.
    temp6-count = 7.
    INSERT temp6 INTO TABLE temp5.
    temp6-text = `Very Best Screens`.
    temp6-count = 14.
    INSERT temp6 INTO TABLE temp5.
    temp6-text = `Smartcards`.
    temp6-count = 2.
    INSERT temp6 INTO TABLE temp5.
    temp6-text = `Alpha Printers`.
    temp6-count = 5.
    INSERT temp6 INTO TABLE temp5.
    temp6-text = `Printer for All`.
    temp6-count = 8.
    INSERT temp6 INTO TABLE temp5.
    temp6-text = `Oxynum`.
    temp6-count = 8.
    INSERT temp6 INTO TABLE temp5.
    temp6-text = `Fasttech`.
    temp6-count = 15.
    INSERT temp6 INTO TABLE temp5.
    temp6-text = `Ultrasonic United`.
    temp6-count = 15.
    INSERT temp6 INTO TABLE temp5.
    temp6-text = `Speaker Experts`.
    temp6-count = 3.
    INSERT temp6 INTO TABLE temp5.
    temp6-text = `Brainsoft`.
    temp6-count = 3.
    INSERT temp6 INTO TABLE temp5.
    temp14-values = temp5.
    INSERT temp14 INTO TABLE temp13.
    t_filters_all = temp13.
    t_filters = t_filters_all.

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
        temp16 = `None`.
      ELSEIF weight_kg < 1.
        temp16 = `Success`.
      ELSEIF weight_kg < 5.
        temp16 = `Warning`.
      ELSE.
        temp16 = `Error`.
      ENDIF.
      lr_product->weight_state = temp16.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
