" @keywords table sap.m tableviewsettingsdialog menu quicksort quicksortitem quickresize actionitem viewsettingsdialog viewsettingsitem viewsettingsfilteritem overflowtoolbar
" @summary The View Settings Dialog is standard UI pattern for specifying sorting, grouping and filtering. For a table it should be triggered by a button in the table header with the 'drop-down-list' icon.
CLASS z2ui5_cl_smpc_app_298 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        product_id     TYPE string,
        name           TYPE string,
        supplier_name  TYPE string,
        weight_measure TYPE p LENGTH 8 DECIMALS 3,
        weight_unit    TYPE string,
        weight_state   TYPE string,
        price          TYPE p LENGTH 8 DECIMALS 2,
        currency_code  TYPE string,
        width          TYPE string,
        depth          TYPE string,
        height         TYPE string,
        dim_unit       TYPE string,
      END OF ty_s_product.
    TYPES temp1_6fa4fe2962 TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.
DATA t_products TYPE temp1_6fa4fe2962.

    DATA filter_bar_visible TYPE abap_bool.
    DATA filter_label TYPE string.

    " onResize writes the Product column's width. A bound CSSSize carries it:
    " an empty value is valid there (the type's 0* branch matches it), so the
    " column keeps its automatic width until the user drags once.
    DATA product_width TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    TYPES temp2_6fa4fe2962 TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.
DATA t_all TYPE temp2_6fa4fe2962.
    " the filtered set in MODEL ORDER, i.e. before any sort. Restoring it is
    " what oBinding.sort( ) with no argument does in the original, and both the
    " QuickSort None entry and the group dialog's Reset need exactly that.
    TYPES temp3_6fa4fe2962 TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.
DATA t_filtered TYPE temp3_6fa4fe2962.
    DATA group_key TYPE string.
    DATA context_menu_on TYPE abap_bool.

    TYPES:
      BEGIN OF ty_s_event_item,
        id       TYPE string,
        key      TYPE string,
        text     TYPE string,
        selected TYPE abap_bool,
      END OF ty_s_event_item.
    TYPES ty_t_event_item TYPE STANDARD TABLE OF ty_s_event_item WITH DEFAULT KEY.

    METHODS view_display.
    METHODS on_event.
    METHODS on_event_filter_confirm.
    METHODS weight_state_set.
    METHODS table_sort
      IMPORTING
        field      TYPE string
        descending TYPE abap_bool.
    METHODS abap_field
      IMPORTING
        val           TYPE string
      RETURNING
        VALUE(result) TYPE string.
    METHODS event_items
      IMPORTING
        val           TYPE string
      RETURNING
        VALUE(result) TYPE ty_t_event_item.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_298 IMPLEMENTATION.

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
    DATA temp2 TYPE string_table.
    DATA temp3 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `${$parameters>/item}.getKey()` INTO TABLE temp1.
    INSERT `${$parameters>/item}.getSortOrder()` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `${$parameters>/sortItem}` INTO TABLE temp2.
    INSERT `${$parameters>/sortDescending}` INTO TABLE temp2.
    
    CLEAR temp3.
    INSERT `${$parameters>/filterItems}` INTO TABLE temp3.
    INSERT `${$parameters>/filterString}` INTO TABLE temp3.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:tcm`  v = `sap.m.table.columnmenu`
        )->a( n = `height`     v = `100%`

        " the four controller-loaded fragments (ColumnMenu, Sort, Group,
        " Filter), declared in the view's dependents aggregation
        )->ele( n = `dependents` ns = `mvc`

            )->ele( n = `Menu` ns = `tcm`
                )->a( n = `id`         v = `columnHeaderMenu`

                )->ele( n = `QuickSort` ns = `tcm`
                    " QuickSort.change DECLARES key and sortOrder in its event
                    " metadata and fires neither: onChange does
                    " fireChange({ item: oItem }) and nothing else. Reading the
                    " declared names therefore delivered two empty strings on
                    " every firing, and the handler's fallback sorted Name
                    " ascending whatever was clicked. The original reads the
                    " same `item` the control really passes, so the port asks
                    " the item for its key and order - an event arg is a full
                    " UI5 expression, so the two getters resolve in the client.
                    )->a( n = `change` v = client->_event( val   = `MENU_SORT`
                                                           t_arg = temp1 )

                    )->ele( n = `items` ns = `tcm`
                        )->tag( n = `QuickSortItem` ns = `tcm`
                            )->a( n = `key`   v = `Name`
                            )->a( n = `label` v = `Product`

                    )->end(
                )->end(
                )->ele( n = `QuickResize` ns = `tcm`
                    )->a( n = `id`     v = `quickResize`
                    )->a( n = `change` v = client->_event( val = `MENU_RESIZE` arg = `${$parameters>/width}` )

                )->end(
                )->ele( n = `items` ns = `tcm`
                    )->tag( n = `ActionItem` ns = `tcm`
                        )->a( n = `label` v = `Action Item`
                        )->a( n = `press` v = client->_event( `MENU_ACTION` )

                )->end(
            )->end(

            )->ele( `ViewSettingsDialog`
                )->a( n = `id`      v = `sortDialog`
                )->a( n = `confirm` v = client->_event( val   = `SORT_CONFIRM`
                                                        t_arg = temp2 )

                )->ele( `sortItems`
                    )->tag( `ViewSettingsItem`
                        )->a( n = `text`     v = `Product`
                        )->a( n = `key`      v = `Name`
                        )->a( n = `selected` v = `true`
                    )->tag( `ViewSettingsItem`
                        )->a( n = `text` v = `Supplier`
                        )->a( n = `key`  v = `SupplierName`
                    )->tag( `ViewSettingsItem`
                        )->a( n = `text` v = `Weight`
                        )->a( n = `key`  v = `WeightMeasure`
                    )->tag( `ViewSettingsItem`
                        )->a( n = `text` v = `Price`
                        )->a( n = `key`  v = `Price`

                )->end(
            )->end(

            )->ele( `ViewSettingsDialog`
                )->a( n = `id`      v = `groupDialog`
                )->a( n = `confirm` v = client->_event( val = `GROUP_CONFIRM` arg = `${$parameters>/groupItem}` )
                )->a( n = `reset`   v = client->_event( `GROUP_RESET` )

                )->ele( `groupItems`
                    )->tag( `ViewSettingsItem`
                        )->a( n = `text` v = `Supplier`
                        )->a( n = `key`  v = `SupplierName`
                    )->tag( `ViewSettingsItem`
                        )->a( n = `text` v = `Price`
                        )->a( n = `key`  v = `Price`

                )->end(
            )->end(

            )->ele( `ViewSettingsDialog`
                )->a( n = `id`      v = `filterDialog`
                )->a( n = `confirm` v = client->_event( val   = `FILTER_CONFIRM`
                                                        t_arg = temp3 )

                )->ele( `filterItems`
                    )->ele( `ViewSettingsFilterItem`
                        )->a( n = `text`        v = `Weight`
                        )->a( n = `key`         v = `WeightMeasure`
                        )->a( n = `multiSelect` v = `false`

                        )->ele( `items`
                            )->tag( `ViewSettingsItem`
                                )->a( n = `text` v = `Less than 1000`
                                )->a( n = `key`  v = `WeightMeasure___LE___1000___X`
                            )->tag( `ViewSettingsItem`
                                )->a( n = `text` v = `Between 1000 and 2000`
                                )->a( n = `key`  v = `WeightMeasure___BT___1000___2000`
                            )->tag( `ViewSettingsItem`
                                )->a( n = `text` v = `More Than 2000`
                                )->a( n = `key`  v = `WeightMeasure___GT___2000___X`

                        )->end(
                    )->end(
                    )->ele( `ViewSettingsFilterItem`
                        )->a( n = `text`        v = `Price`
                        )->a( n = `key`         v = `Price`
                        )->a( n = `multiSelect` v = `false`

                        )->ele( `items`
                            )->tag( `ViewSettingsItem`
                                )->a( n = `text` v = `Less Than 100`
                                )->a( n = `key`  v = `Price___LE___100___X`
                            )->tag( `ViewSettingsItem`
                                )->a( n = `text` v = `Between 100 and 1000`
                                )->a( n = `key`  v = `Price___BT___100___1000`
                            )->tag( `ViewSettingsItem`
                                )->a( n = `text` v = `More Than 1000`
                                )->a( n = `key`  v = `Price___GT___1000___X`

                        )->end(
                    )->end(
                )->end(
            )->end(
        )->end(

        )->ele( `Page`
            )->a( n = `showHeader` v = `false`

            )->ele( `Table`
                )->a( n = `id`    v = `idProductsTable`
                )->a( n = `items` v = client->_bind( t_products )

                )->ele( `headerToolbar`
                    )->ele( `OverflowToolbar`
                        )->tag( `Title`
                            )->a( n = `text`  v = `Products`
                            )->a( n = `level` v = `H2`
                        )->tag( `ToolbarSpacer`
                        )->tag( `Button`
                            )->a( n = `tooltip` v = `Sort`
                            )->a( n = `icon`    v = `sap-icon://sort`
                            )->a( n = `press`   v = client->_event( `OPEN_SORT` )
                        )->tag( `Button`
                            )->a( n = `tooltip` v = `Filter`
                            )->a( n = `icon`    v = `sap-icon://filter`
                            )->a( n = `press`   v = client->_event( `OPEN_FILTER` )
                        )->tag( `Button`
                            )->a( n = `tooltip` v = `Group`
                            )->a( n = `icon`    v = `sap-icon://group-2`
                            )->a( n = `press`   v = client->_event( `OPEN_GROUP` )
                        )->tag( `ToggleButton`
                            )->a( n = `icon`    v = `sap-icon://menu`
                            )->a( n = `tooltip` v = `Enable Custom Context Menu`
                            )->a( n = `press`   v = client->_event( `TOGGLE_CONTEXT_MENU` )

                    )->end(
                )->end(
                )->ele( `infoToolbar`
                    )->ele( `OverflowToolbar`
                        )->a( n = `id`      v = `vsdFilterBar`
                        )->a( n = `visible` v = client->_bind( filter_bar_visible )

                        )->tag( `Text`
                            )->a( n = `id`   v = `vsdFilterLabel`
                            )->a( n = `text` v = client->_bind( filter_label )

                    )->end(
                )->end(
                )->ele( `columns`
                    )->ele( `Column`
                        )->a( n = `id`         v = `product`
                        )->a( n = `headerMenu` v = `columnHeaderMenu`
                        " onResize's oColumn.setWidth( iWidth + 'px' ) - a
                        " bindable property, so the width travels back through
                        " the model instead of a setter
                        )->a( n = `width`      v = client->_bind( product_width )

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
                        )->a( n = `minScreenWidth` v = `Tablet`
                        )->a( n = `demandPopin`    v = `true`
                        )->a( n = `hAlign`         v = `End`

                        )->tag( `Text`
                            )->a( n = `text` v = `Dimensions`

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
                            )->a( n = `text` v = `Price`

                    )->end(
                )->end(
                )->ele( `items`
                    )->ele( `ColumnListItem`
                        )->a( n = `vAlign` v = `Middle`

                        )->ele( `cells`
                            )->tag( `ObjectIdentifier`
                                )->a( n = `title` v = `{NAME}`
                                )->a( n = `text`  v = `{PRODUCT_ID}`
                            )->tag( `Text`
                                )->a( n = `text` v = `{SUPPLIER_NAME}`
                            )->tag( `Text`
                                )->a( n = `text` v = `{WIDTH} x {DEPTH} x {HEIGHT} {DIM_UNIT}`
                            )->tag( `ObjectNumber`
                                )->a( n = `number` v = `{WEIGHT_MEASURE}`
                                )->a( n = `unit`   v = `{WEIGHT_UNIT}`
                                )->a( n = `state`  v = `{WEIGHT_STATE}`
                            )->tag( `ObjectNumber`
                                )->a( n = `number` v = |\{ parts:[\{path:'PRICE'\},\{path:'CURRENCY_CODE'\}], type: 'sap.ui.model.type.Currency', formatOptions: \{showMeasure: false\} \}|
                                )->a( n = `unit`   v = `{CURRENCY_CODE}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA temp3 TYPE string_table.
        DATA temp5 TYPE string_table.
        DATA temp7 TYPE string_table.
        DATA t_item TYPE z2ui5_cl_smpc_app_298=>ty_t_event_item.
          DATA temp9 LIKE LINE OF t_item.
          DATA temp10 LIKE sy-tabix.
          DATA temp1 TYPE xsdboolean.
          DATA temp2 TYPE xsdboolean.
        DATA temp11 TYPE string.
          DATA temp4 LIKE LINE OF t_item.
          DATA temp6 LIKE sy-tabix.
        DATA temp8 TYPE xsdboolean.
        DATA temp12 TYPE string.

    CASE client->get_event( ).

      WHEN `OPEN_SORT`.
        
        CLEAR temp3.
        INSERT `sortDialog` INTO TABLE temp3.
        INSERT `open` INTO TABLE temp3.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = temp3 ).

      WHEN `OPEN_FILTER`.
        
        CLEAR temp5.
        INSERT `filterDialog` INTO TABLE temp5.
        INSERT `open` INTO TABLE temp5.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = temp5 ).

      WHEN `OPEN_GROUP`.
        
        CLEAR temp7.
        INSERT `groupDialog` INTO TABLE temp7.
        INSERT `open` INTO TABLE temp7.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = temp7 ).

      WHEN `SORT_CONFIRM`.
        
        t_item = event_items( client->get_event_arg( ) ).
        IF t_item IS NOT INITIAL.
          
          
          temp10 = sy-tabix.
          READ TABLE t_item INDEX 1 INTO temp9.
          sy-tabix = temp10.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          
          temp1 = boolc( client->get_event_arg( 2 ) = abap_true ).
          table_sort( field      = abap_field( temp9-key )
                      descending = temp1 ).
        ENDIF.

      WHEN `MENU_SORT`.
        " onSortChange: sortOrder None clears the sorter (oBinding.sort( ) with
        " no argument), which restores MODEL order rather than sorting by
        " anything - the branch the port used to fall through
        IF client->get_event_arg( 2 ) = `None`.
          t_products = t_filtered.
        ELSE.
          
          temp2 = boolc( client->get_event_arg( 2 ) = `Descending` ).
          table_sort( field      = abap_field( client->get_event_arg( ) )
                      descending = temp2 ).
        ENDIF.

      WHEN `GROUP_CONFIRM`.
        t_item = event_items( client->get_event_arg( ) ).
        
        IF t_item IS INITIAL.
          temp11 = ``.
        ELSE.
          
          
          temp6 = sy-tabix.
          READ TABLE t_item INDEX 1 INTO temp4.
          sy-tabix = temp6.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          temp11 = temp4-key.
        ENDIF.
        group_key = temp11.
        CASE group_key.

          WHEN `SupplierName`.
            SORT t_products BY supplier_name ASCENDING.

          WHEN `Price`.
            SORT t_products BY price ASCENDING.

        ENDCASE.

      WHEN `GROUP_RESET`.
        " resetGroupDialog sets this.groupReset, and the confirm handler then
        " calls oBinding.sort( ) - so Reset really puts the rows back in model
        " order. Clearing group_key alone changed nothing observable: it is
        " read only inside GROUP_CONFIRM, which reassigns it first.
        group_key  = ``.
        t_products = t_filtered.

      WHEN `FILTER_CONFIRM`.
        on_event_filter_confirm( ).

      WHEN `TOGGLE_CONTEXT_MENU`.
        
        temp8 = boolc( context_menu_on = abap_false ).
        context_menu_on = temp8.
        
        IF context_menu_on = abap_true.
          temp12 = `Custom context menu enabled`.
        ELSE.
          temp12 = `Custom context menu disabled`.
        ENDIF.
        client->message_toast_display( temp12 ).

      WHEN `MENU_ACTION`.
        client->message_toast_display( `Action Item Pressed` ).

      WHEN `MENU_RESIZE`.
        " onResize: oColumn.setWidth( oEvent.getParameter('width') + 'px' ).
        " The width now travels as an event arg and lands on the bound
        " property; the toast this used to show instead was not in the original
        " at all, and the comment beside it claimed onResize only logs.
        product_width = |{ client->get_event_arg( ) }px|.

    ENDCASE.

  ENDMETHOD.


  METHOD on_event_filter_confirm.

    DATA lt_keep LIKE t_products.

    " the item key encodes the whole condition: <field>___<operator>___<v1>___<v2>
    DATA t_item TYPE z2ui5_cl_smpc_app_298=>ty_t_event_item.
    DATA temp9 TYPE xsdboolean.
    DATA s_item LIKE LINE OF t_item.
      DATA field TYPE string.
      DATA operator TYPE string.
      DATA value1 TYPE string.
      DATA value2 TYPE string.
      DATA temp13 TYPE decfloat34.
      DATA low LIKE temp13.
      DATA temp14 TYPE decfloat34.
      DATA temp7 TYPE string.
      DATA high LIKE temp14.
      DATA s_row LIKE LINE OF t_products.
        DATA temp15 TYPE decfloat34.
        DATA compare LIKE temp15.
        DATA temp16 TYPE abap_bool.
            DATA temp10 TYPE xsdboolean.
            DATA temp11 TYPE xsdboolean.
            DATA temp12 TYPE xsdboolean.
        DATA keep LIKE temp16.
    t_item = event_items( client->get_event_arg( ) ).

    t_products = t_all.
    filter_label       = client->get_event_arg( 2 ).
    
    temp9 = boolc( filter_label IS NOT INITIAL ).
    filter_bar_visible = temp9.

    
    LOOP AT t_item INTO s_item.
      
      
      
      
      SPLIT s_item-key AT `___` INTO field operator value1 value2.

      
      temp13 = value1.
      
      low = temp13.
      
      
      IF value2 = `X`.
        temp7 = `0`.
      ELSE.
        temp7 = value2.
      ENDIF.
      temp14 = temp7.
      
      high = temp14.

      " Collected rather than deleted in place: DELETE ... INDEX sy-tabix inside
      " a LOOP over the same table shifts the rows under the loop's own cursor -
      " on a system it silently SKIPS the row after each deletion, on the
      " transpiled backend it raises TABLE_INVALID_INDEX (2026-08-17).
      CLEAR lt_keep.
      
      LOOP AT t_products INTO s_row.
        
        IF field = `WeightMeasure`.
          temp15 = s_row-weight_measure.
        ELSE.
          temp15 = s_row-price.
        ENDIF.
        
        compare = temp15.
        
        CASE operator.
          WHEN `LE`.
            
            temp10 = boolc( compare <= low ).
            temp16 = temp10.
          WHEN `GT`.
            
            temp11 = boolc( compare > low ).
            temp16 = temp11.
          WHEN `BT`.
            
            temp12 = boolc( compare >= low AND compare <= high ).
            temp16 = temp12.
          WHEN OTHERS.
            temp16 = abap_true.
        ENDCASE.
        
        keep = temp16.
        IF keep = abap_true.
          APPEND s_row TO lt_keep.
        ENDIF.
      ENDLOOP.
      t_products = lt_keep.
    ENDLOOP.

    " the filter result in model order - what a cleared sorter goes back to
    t_filtered = t_products.


  ENDMETHOD.


  METHOD weight_state_set.

    " weightState is business logic, not presentation - abap2UI5 is a thin
    " frontend, so it is computed here rather than in a frontend formatter.
    " THIS SAMPLE'S OWN Formatter.js takes ONE argument and compares the RAW
    " measure: < 0 None, < 1000 Success, < 2000 Warning, else Error - and the
    " view binds a single part (WeightMeasure), so the unit never reaches it.
    " The KG rule with the 1/5 boundaries belongs to a DIFFERENT sample
    " (sap.m.Table, app 009, whose formatter takes measure AND unit); it was
    " imported here on 2026-08-21 and made 66 of the 123 rows disagree with the
    " original, every one of which renders Success.
    DATA temp17 LIKE LINE OF t_products.
    DATA lr_row LIKE REF TO temp17.
      DATA temp18 TYPE z2ui5_cl_smpc_app_298=>ty_s_product-weight_state.
    LOOP AT t_products REFERENCE INTO lr_row.
      
      IF lr_row->weight_measure < 0.
        temp18 = `None`.
      ELSEIF lr_row->weight_measure < 1000.
        temp18 = `Success`.
      ELSEIF lr_row->weight_measure < 2000.
        temp18 = `Warning`.
      ELSE.
        temp18 = `Error`.
      ENDIF.
      lr_row->weight_state = temp18.
    ENDLOOP.

  ENDMETHOD.


  METHOD table_sort.

    " the component is named STATICALLY per field rather than through
    " SORT BY (field): the transpiled backend drops the dynamic BY clause
    " altogether (abap.statements.sort(t, {}) - **e2e-caught 2026-08-22** on
    " app 571), so the table came back in its original order
    CASE field.
      WHEN `SUPPLIER_NAME`.
        IF descending = abap_true.
          SORT t_products BY supplier_name AS TEXT DESCENDING.
        ELSE.
          SORT t_products BY supplier_name AS TEXT ASCENDING.
        ENDIF.
      WHEN `WEIGHT_MEASURE`.
        IF descending = abap_true.
          SORT t_products BY weight_measure DESCENDING.
        ELSE.
          SORT t_products BY weight_measure ASCENDING.
        ENDIF.
      WHEN `PRICE`.
        IF descending = abap_true.
          SORT t_products BY price DESCENDING.
        ELSE.
          SORT t_products BY price ASCENDING.
        ENDIF.
      WHEN OTHERS.
        IF descending = abap_true.
          SORT t_products BY name AS TEXT DESCENDING.
        ELSE.
          SORT t_products BY name AS TEXT ASCENDING.
        ENDIF.
    ENDCASE.

  ENDMETHOD.


  METHOD abap_field.

    " the dialog keys are the mock's UI5 field names; the model carries the
    " ABAP component names
    DATA temp19 TYPE string.
    CASE val.
      WHEN `Name`.
        temp19 = `NAME`.
      WHEN `SupplierName`.
        temp19 = `SUPPLIER_NAME`.
      WHEN `WeightMeasure`.
        temp19 = `WEIGHT_MEASURE`.
      WHEN `Price`.
        temp19 = `PRICE`.
      WHEN OTHERS.
        temp19 = `NAME`.
    ENDCASE.
    result = temp19.

  ENDMETHOD.


  METHOD event_items.

    DATA lv_json TYPE string.
    lv_json = condense( val ).
    IF lv_json IS INITIAL.
      RETURN.
    ENDIF.

    IF lv_json(1) <> `[`.
      lv_json = |[{ lv_json }]|.
    ENDIF.

    TRY.
        " the frontend marshals a control with ALL its public properties
        " (enabled, textDirection, wrapping, ...), so only the fields this port
        " models are mapped - a plain to_abap( ) fails on the first extra one
        "
        " z2ui5_cl_ajson is the framework's VENDORED ajson copy and lives
        " outside the released API (src/02), so it may be renamed or
        " restructured without notice - the linter says so, and it is right.
        " There is no released JSON reader to use instead: src/02 carries the
        " http handler, the view builder and the four interfaces, and none of
        " them parses a string. A sample class is installed on its own and
        " cannot carry its own ajson copy either, so the choice here is this
        " call or a hand-rolled parser for a payload UI5 defines - and a
        " hand-rolled one would be the more fragile of the two. Declared as a
        " deviation in the sidecar; revisit when the framework releases a JSON
        " reader.
        " abap2ui5lint-disable-next-line non-released-api -- no released JSON reader exists; see the comment above and the sidecar deviation
        z2ui5_cl_ajson=>parse( lv_json
          )->to_abap_corresponding_only(
          )->to_abap( IMPORTING ev_container = result ).
        " abap2ui5lint-disable-next-line non-released-api -- the exception of the call above
      CATCH z2ui5_cx_ajson_error.
        CLEAR result.
    ENDTRY.

  ENDMETHOD.

  METHOD model_init.

    " the shared mock /ProductCollection flattened to the bound columns, all 123 rows kept verbatim
    DATA temp20 LIKE t_products.
    DATA temp21 LIKE LINE OF temp20.
    CLEAR temp20.
    
    temp21-product_id = `HT-1000`.
    temp21-name = `Notebook Basic 15`.
    temp21-supplier_name = `Very Best Screens`.
    temp21-weight_measure = '4.2'.
    temp21-weight_unit = `KG`.
    temp21-price = '956'.
    temp21-currency_code = `EUR`.
    temp21-width = '30'.
    temp21-depth = '18'.
    temp21-height = '3'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1001`.
    temp21-name = `Notebook Basic 17`.
    temp21-supplier_name = `Very Best Screens`.
    temp21-weight_measure = '4.5'.
    temp21-weight_unit = `KG`.
    temp21-price = '1249'.
    temp21-currency_code = `EUR`.
    temp21-width = '29'.
    temp21-depth = '17'.
    temp21-height = '3.1'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1002`.
    temp21-name = `Notebook Basic 18`.
    temp21-supplier_name = `Very Best Screens`.
    temp21-weight_measure = '4.2'.
    temp21-weight_unit = `KG`.
    temp21-price = '1570'.
    temp21-currency_code = `EUR`.
    temp21-width = '28'.
    temp21-depth = '19'.
    temp21-height = '2.5'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1003`.
    temp21-name = `Notebook Basic 19`.
    temp21-supplier_name = `Smartcards`.
    temp21-weight_measure = '4.2'.
    temp21-weight_unit = `KG`.
    temp21-price = '1650'.
    temp21-currency_code = `EUR`.
    temp21-width = '32'.
    temp21-depth = '21'.
    temp21-height = '4'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1007`.
    temp21-name = `ITelO Vault`.
    temp21-supplier_name = `Technocom`.
    temp21-weight_measure = '0.2'.
    temp21-weight_unit = `KG`.
    temp21-price = '299'.
    temp21-currency_code = `EUR`.
    temp21-width = '32'.
    temp21-depth = '22'.
    temp21-height = '3'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1010`.
    temp21-name = `Notebook Professional 15`.
    temp21-supplier_name = `Very Best Screens`.
    temp21-weight_measure = '4.3'.
    temp21-weight_unit = `KG`.
    temp21-price = '1999'.
    temp21-currency_code = `EUR`.
    temp21-width = '33'.
    temp21-depth = '20'.
    temp21-height = '3'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1011`.
    temp21-name = `Notebook Professional 17`.
    temp21-supplier_name = `Very Best Screens`.
    temp21-weight_measure = '4.1'.
    temp21-weight_unit = `KG`.
    temp21-price = '2299'.
    temp21-currency_code = `EUR`.
    temp21-width = '33'.
    temp21-depth = '23'.
    temp21-height = '2'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1020`.
    temp21-name = `ITelO Vault Net`.
    temp21-supplier_name = `Technocom`.
    temp21-weight_measure = '0.16'.
    temp21-weight_unit = `KG`.
    temp21-price = '459'.
    temp21-currency_code = `EUR`.
    temp21-width = '10'.
    temp21-depth = '1.8'.
    temp21-height = '17'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1021`.
    temp21-name = `ITelO Vault SAT`.
    temp21-supplier_name = `Technocom`.
    temp21-weight_measure = '0.18'.
    temp21-weight_unit = `KG`.
    temp21-price = '149'.
    temp21-currency_code = `EUR`.
    temp21-width = '11'.
    temp21-depth = '1.7'.
    temp21-height = '18'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1022`.
    temp21-name = `Comfort Easy`.
    temp21-supplier_name = `Technocom`.
    temp21-weight_measure = '0.2'.
    temp21-weight_unit = `KG`.
    temp21-price = '1679'.
    temp21-currency_code = `EUR`.
    temp21-width = '84'.
    temp21-depth = '1.5'.
    temp21-height = '14'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1023`.
    temp21-name = `Comfort Senior`.
    temp21-supplier_name = `Technocom`.
    temp21-weight_measure = '0.8'.
    temp21-weight_unit = `KG`.
    temp21-price = '512'.
    temp21-currency_code = `EUR`.
    temp21-width = '80'.
    temp21-depth = '1.6'.
    temp21-height = '13'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1030`.
    temp21-name = `Ergo Screen E-I`.
    temp21-supplier_name = `Very Best Screens`.
    temp21-weight_measure = '21'.
    temp21-weight_unit = `KG`.
    temp21-price = '230'.
    temp21-currency_code = `EUR`.
    temp21-width = '37'.
    temp21-depth = '12'.
    temp21-height = '36'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1031`.
    temp21-name = `Ergo Screen E-II`.
    temp21-supplier_name = `Very Best Screens`.
    temp21-weight_measure = '21'.
    temp21-weight_unit = `KG`.
    temp21-price = '285'.
    temp21-currency_code = `EUR`.
    temp21-width = '40.8'.
    temp21-depth = '19'.
    temp21-height = '43'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1032`.
    temp21-name = `Ergo Screen E-III`.
    temp21-supplier_name = `Very Best Screens`.
    temp21-weight_measure = '21'.
    temp21-weight_unit = `KG`.
    temp21-price = '345'.
    temp21-currency_code = `EUR`.
    temp21-width = '40.8'.
    temp21-depth = '19'.
    temp21-height = '43'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1035`.
    temp21-name = `Flat Basic`.
    temp21-supplier_name = `Very Best Screens`.
    temp21-weight_measure = '14'.
    temp21-weight_unit = `KG`.
    temp21-price = '399'.
    temp21-currency_code = `EUR`.
    temp21-width = '39'.
    temp21-depth = '20'.
    temp21-height = '41'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1036`.
    temp21-name = `Flat Future`.
    temp21-supplier_name = `Very Best Screens`.
    temp21-weight_measure = '15'.
    temp21-weight_unit = `KG`.
    temp21-price = '430'.
    temp21-currency_code = `EUR`.
    temp21-width = '45'.
    temp21-depth = '26'.
    temp21-height = '46'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1037`.
    temp21-name = `Flat XL`.
    temp21-supplier_name = `Very Best Screens`.
    temp21-weight_measure = '17'.
    temp21-weight_unit = `KG`.
    temp21-price = '1230'.
    temp21-currency_code = `EUR`.
    temp21-width = '54.5'.
    temp21-depth = '22.1'.
    temp21-height = '39.1'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1040`.
    temp21-name = `Laser Professional Eco`.
    temp21-supplier_name = `Alpha Printers`.
    temp21-weight_measure = '32'.
    temp21-weight_unit = `KG`.
    temp21-price = '830'.
    temp21-currency_code = `EUR`.
    temp21-width = '51'.
    temp21-depth = '46'.
    temp21-height = '30'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1041`.
    temp21-name = `Laser Basic`.
    temp21-supplier_name = `Alpha Printers`.
    temp21-weight_measure = '23'.
    temp21-weight_unit = `KG`.
    temp21-price = '490'.
    temp21-currency_code = `EUR`.
    temp21-width = '48'.
    temp21-depth = '42'.
    temp21-height = '26'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1042`.
    temp21-name = `Laser Allround`.
    temp21-supplier_name = `Alpha Printers`.
    temp21-weight_measure = '17'.
    temp21-weight_unit = `KG`.
    temp21-price = '349'.
    temp21-currency_code = `EUR`.
    temp21-width = '53'.
    temp21-depth = '50'.
    temp21-height = '65'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1050`.
    temp21-name = `Ultra Jet Super Color`.
    temp21-supplier_name = `Alpha Printers`.
    temp21-weight_measure = '3'.
    temp21-weight_unit = `KG`.
    temp21-price = '139'.
    temp21-currency_code = `EUR`.
    temp21-width = '41'.
    temp21-depth = '41'.
    temp21-height = '28'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1051`.
    temp21-name = `Ultra Jet Mobile`.
    temp21-supplier_name = `Printer for All`.
    temp21-weight_measure = '1.9'.
    temp21-weight_unit = `KG`.
    temp21-price = '99'.
    temp21-currency_code = `EUR`.
    temp21-width = '46'.
    temp21-depth = '32'.
    temp21-height = '25'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1052`.
    temp21-name = `Ultra Jet Super Highspeed`.
    temp21-supplier_name = `Printer for All`.
    temp21-weight_measure = '18'.
    temp21-weight_unit = `KG`.
    temp21-price = '170'.
    temp21-currency_code = `EUR`.
    temp21-width = '41'.
    temp21-depth = '41'.
    temp21-height = '28'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1055`.
    temp21-name = `Multi Print`.
    temp21-supplier_name = `Printer for All`.
    temp21-weight_measure = '6.3'.
    temp21-weight_unit = `KG`.
    temp21-price = '99'.
    temp21-currency_code = `EUR`.
    temp21-width = '55'.
    temp21-depth = '45'.
    temp21-height = '29'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1056`.
    temp21-name = `Multi Color`.
    temp21-supplier_name = `Printer for All`.
    temp21-weight_measure = '4.3'.
    temp21-weight_unit = `KG`.
    temp21-price = '119'.
    temp21-currency_code = `EUR`.
    temp21-width = '51'.
    temp21-depth = '41.3'.
    temp21-height = '22'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1060`.
    temp21-name = `Cordless Mouse`.
    temp21-supplier_name = `Oxynum`.
    temp21-weight_measure = '0.09'.
    temp21-weight_unit = `KG`.
    temp21-price = '9'.
    temp21-currency_code = `EUR`.
    temp21-width = '6'.
    temp21-depth = '14.5'.
    temp21-height = '3.5'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1061`.
    temp21-name = `Speed Mouse`.
    temp21-supplier_name = `Oxynum`.
    temp21-weight_measure = '0.09'.
    temp21-weight_unit = `KG`.
    temp21-price = '7'.
    temp21-currency_code = `EUR`.
    temp21-width = '7'.
    temp21-depth = '15'.
    temp21-height = '3.1'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1062`.
    temp21-name = `Track Mouse`.
    temp21-supplier_name = `Oxynum`.
    temp21-weight_measure = '0.03'.
    temp21-weight_unit = `KG`.
    temp21-price = '11'.
    temp21-currency_code = `EUR`.
    temp21-width = '3'.
    temp21-depth = '7'.
    temp21-height = '4'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1063`.
    temp21-name = `Ergonomic Keyboard`.
    temp21-supplier_name = `Oxynum`.
    temp21-weight_measure = '2.1'.
    temp21-weight_unit = `KG`.
    temp21-price = '14'.
    temp21-currency_code = `EUR`.
    temp21-width = '50'.
    temp21-depth = '21'.
    temp21-height = '3.5'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1064`.
    temp21-name = `Internet Keyboard`.
    temp21-supplier_name = `Oxynum`.
    temp21-weight_measure = '1.8'.
    temp21-weight_unit = `KG`.
    temp21-price = '16'.
    temp21-currency_code = `EUR`.
    temp21-width = '52'.
    temp21-depth = '25'.
    temp21-height = '3'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1065`.
    temp21-name = `Media Keyboard`.
    temp21-supplier_name = `Oxynum`.
    temp21-weight_measure = '2.3'.
    temp21-weight_unit = `KG`.
    temp21-price = '26'.
    temp21-currency_code = `EUR`.
    temp21-width = '51.4'.
    temp21-depth = '23'.
    temp21-height = '4'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1066`.
    temp21-name = `Mousepad`.
    temp21-supplier_name = `Oxynum`.
    temp21-weight_measure = '80'.
    temp21-weight_unit = `G`.
    temp21-price = '6.99'.
    temp21-currency_code = `EUR`.
    temp21-width = '15'.
    temp21-depth = '6'.
    temp21-height = '0.2'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1067`.
    temp21-name = `Ergo Mousepad`.
    temp21-supplier_name = `Oxynum`.
    temp21-weight_measure = '80'.
    temp21-weight_unit = `G`.
    temp21-price = '8.99'.
    temp21-currency_code = `EUR`.
    temp21-width = '15'.
    temp21-depth = '6'.
    temp21-height = '0.2'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1068`.
    temp21-name = `Designer Mousepad`.
    temp21-supplier_name = `Fasttech`.
    temp21-weight_measure = '90'.
    temp21-weight_unit = `G`.
    temp21-price = '12.99'.
    temp21-currency_code = `EUR`.
    temp21-width = '24'.
    temp21-depth = '24'.
    temp21-height = '0.6'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1069`.
    temp21-name = `Universal card reader`.
    temp21-supplier_name = `Fasttech`.
    temp21-weight_measure = '45'.
    temp21-weight_unit = `G`.
    temp21-price = '14'.
    temp21-currency_code = `EUR`.
    temp21-width = '6'.
    temp21-depth = '6'.
    temp21-height = '3'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1070`.
    temp21-name = `Proctra X`.
    temp21-supplier_name = `Ultrasonic United`.
    temp21-weight_measure = '0.255'.
    temp21-weight_unit = `KG`.
    temp21-price = '70.9'.
    temp21-currency_code = `EUR`.
    temp21-width = '22'.
    temp21-depth = '35'.
    temp21-height = '17'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1071`.
    temp21-name = `Gladiator MX`.
    temp21-supplier_name = `Ultrasonic United`.
    temp21-weight_measure = '0.3'.
    temp21-weight_unit = `KG`.
    temp21-price = '81.7'.
    temp21-currency_code = `EUR`.
    temp21-width = '22'.
    temp21-depth = '35'.
    temp21-height = '17'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1072`.
    temp21-name = `Hurricane GX`.
    temp21-supplier_name = `Ultrasonic United`.
    temp21-weight_measure = '0.4'.
    temp21-weight_unit = `KG`.
    temp21-price = '101.2'.
    temp21-currency_code = `EUR`.
    temp21-width = '22'.
    temp21-depth = '35'.
    temp21-height = '17'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1073`.
    temp21-name = `Hurricane GX/LN`.
    temp21-supplier_name = `Smartcards`.
    temp21-weight_measure = '0.4'.
    temp21-weight_unit = `KG`.
    temp21-price = '139.99'.
    temp21-currency_code = `EUR`.
    temp21-width = '22'.
    temp21-depth = '35'.
    temp21-height = '17'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1080`.
    temp21-name = `Photo Scan`.
    temp21-supplier_name = `Printer for All`.
    temp21-weight_measure = '2.3'.
    temp21-weight_unit = `KG`.
    temp21-price = '129'.
    temp21-currency_code = `EUR`.
    temp21-width = '34'.
    temp21-depth = '48'.
    temp21-height = '5'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1081`.
    temp21-name = `Power Scan`.
    temp21-supplier_name = `Printer for All`.
    temp21-weight_measure = '2.4'.
    temp21-weight_unit = `KG`.
    temp21-price = '89'.
    temp21-currency_code = `EUR`.
    temp21-width = '31'.
    temp21-depth = '43'.
    temp21-height = '7'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1082`.
    temp21-name = `Jet Scan Professional`.
    temp21-supplier_name = `Printer for All`.
    temp21-weight_measure = '3.2'.
    temp21-weight_unit = `KG`.
    temp21-price = '169'.
    temp21-currency_code = `EUR`.
    temp21-width = '33'.
    temp21-depth = '41'.
    temp21-height = '12'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1083`.
    temp21-name = `Jet Scan Professional`.
    temp21-supplier_name = `Printer for All`.
    temp21-weight_measure = '3.2'.
    temp21-weight_unit = `KG`.
    temp21-price = '189'.
    temp21-currency_code = `EUR`.
    temp21-width = '35'.
    temp21-depth = '40'.
    temp21-height = '10'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1085`.
    temp21-name = `Copymaster`.
    temp21-supplier_name = `Alpha Printers`.
    temp21-weight_measure = '23.2'.
    temp21-weight_unit = `KG`.
    temp21-price = '1499'.
    temp21-currency_code = `EUR`.
    temp21-width = '45'.
    temp21-depth = '42'.
    temp21-height = '22'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1090`.
    temp21-name = `Surround Sound`.
    temp21-supplier_name = `Speaker Experts`.
    temp21-weight_measure = '3'.
    temp21-weight_unit = `KG`.
    temp21-price = '39'.
    temp21-currency_code = `EUR`.
    temp21-width = '12'.
    temp21-depth = '10'.
    temp21-height = '16'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1091`.
    temp21-name = `Blaster Extreme`.
    temp21-supplier_name = `Speaker Experts`.
    temp21-weight_measure = '1.4'.
    temp21-weight_unit = `KG`.
    temp21-price = '26'.
    temp21-currency_code = `EUR`.
    temp21-width = '13'.
    temp21-depth = '11'.
    temp21-height = '17.5'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1092`.
    temp21-name = `Sound Booster`.
    temp21-supplier_name = `Speaker Experts`.
    temp21-weight_measure = '2.1'.
    temp21-weight_unit = `KG`.
    temp21-price = '45'.
    temp21-currency_code = `EUR`.
    temp21-width = '12.4'.
    temp21-depth = '10.4'.
    temp21-height = '18.1'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1095`.
    temp21-name = `Lovely Sound 5.1 Wireless`.
    temp21-supplier_name = `Fasttech`.
    temp21-weight_measure = '80'.
    temp21-weight_unit = `G`.
    temp21-price = '49'.
    temp21-currency_code = `EUR`.
    temp21-width = '24'.
    temp21-depth = '19'.
    temp21-height = '23'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1096`.
    temp21-name = `Lovely Sound 5.1`.
    temp21-supplier_name = `Fasttech`.
    temp21-weight_measure = '130'.
    temp21-weight_unit = `G`.
    temp21-price = '39'.
    temp21-currency_code = `EUR`.
    temp21-width = '25'.
    temp21-depth = '17'.
    temp21-height = '19'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1097`.
    temp21-name = `Lovely Sound Stereo`.
    temp21-supplier_name = `Fasttech`.
    temp21-weight_measure = '60'.
    temp21-weight_unit = `G`.
    temp21-price = '29'.
    temp21-currency_code = `EUR`.
    temp21-width = '21.3'.
    temp21-depth = '2.4'.
    temp21-height = '19.7'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1100`.
    temp21-name = `Smart Office`.
    temp21-supplier_name = `Technocom`.
    temp21-weight_measure = '1.2'.
    temp21-weight_unit = `KG`.
    temp21-price = '89.9'.
    temp21-currency_code = `EUR`.
    temp21-width = '15'.
    temp21-depth = '6.5'.
    temp21-height = '2.1'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1101`.
    temp21-name = `Smart Design`.
    temp21-supplier_name = `Technocom`.
    temp21-weight_measure = '0.8'.
    temp21-weight_unit = `KG`.
    temp21-price = '79.9'.
    temp21-currency_code = `EUR`.
    temp21-width = '14'.
    temp21-depth = '6.7'.
    temp21-height = '24'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1102`.
    temp21-name = `Smart Network`.
    temp21-supplier_name = `Technocom`.
    temp21-weight_measure = '0.8'.
    temp21-weight_unit = `KG`.
    temp21-price = '69'.
    temp21-currency_code = `EUR`.
    temp21-width = '16'.
    temp21-depth = '6'.
    temp21-height = '27'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1103`.
    temp21-name = `Smart Multimedia`.
    temp21-supplier_name = `Technocom`.
    temp21-weight_measure = '0.8'.
    temp21-weight_unit = `KG`.
    temp21-price = '77'.
    temp21-currency_code = `EUR`.
    temp21-width = '11'.
    temp21-depth = '3.4'.
    temp21-height = '22'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1104`.
    temp21-name = `Smart Games`.
    temp21-supplier_name = `Technocom`.
    temp21-weight_measure = '1.1'.
    temp21-weight_unit = `KG`.
    temp21-price = '55'.
    temp21-currency_code = `EUR`.
    temp21-width = '10'.
    temp21-depth = '3'.
    temp21-height = '30'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1105`.
    temp21-name = `Smart Internet Antivirus`.
    temp21-supplier_name = `Brainsoft`.
    temp21-weight_measure = '0.7'.
    temp21-weight_unit = `KG`.
    temp21-price = '29'.
    temp21-currency_code = `EUR`.
    temp21-width = '16'.
    temp21-depth = '4'.
    temp21-height = '21'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1106`.
    temp21-name = `Smart Firewall`.
    temp21-supplier_name = `Brainsoft`.
    temp21-weight_measure = '0.9'.
    temp21-weight_unit = `KG`.
    temp21-price = '34'.
    temp21-currency_code = `EUR`.
    temp21-width = '17.9'.
    temp21-depth = '4.2'.
    temp21-height = '23.1'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1107`.
    temp21-name = `Smart Money`.
    temp21-supplier_name = `Brainsoft`.
    temp21-weight_measure = '0.5'.
    temp21-weight_unit = `KG`.
    temp21-price = '29.9'.
    temp21-currency_code = `EUR`.
    temp21-width = '12'.
    temp21-depth = '1.5'.
    temp21-height = '19'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1110`.
    temp21-name = `PC Lock`.
    temp21-supplier_name = `Red Point Stores`.
    temp21-weight_measure = '0.03'.
    temp21-weight_unit = `KG`.
    temp21-price = '8.9'.
    temp21-currency_code = `EUR`.
    temp21-width = '20'.
    temp21-depth = '8'.
    temp21-height = '4.3'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1111`.
    temp21-name = `Notebook Lock`.
    temp21-supplier_name = `Red Point Stores`.
    temp21-weight_measure = '0.02'.
    temp21-weight_unit = `KG`.
    temp21-price = '6.9'.
    temp21-currency_code = `EUR`.
    temp21-width = '31'.
    temp21-depth = '9'.
    temp21-height = '7'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1112`.
    temp21-name = `Web cam reality`.
    temp21-supplier_name = `Red Point Stores`.
    temp21-weight_measure = '0.075'.
    temp21-weight_unit = `KG`.
    temp21-price = '39'.
    temp21-currency_code = `EUR`.
    temp21-width = '9'.
    temp21-depth = '8.2'.
    temp21-height = '1.3'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1113`.
    temp21-name = `Screen clean`.
    temp21-supplier_name = `Red Point Stores`.
    temp21-weight_measure = '0.05'.
    temp21-weight_unit = `KG`.
    temp21-price = '2.3'.
    temp21-currency_code = `EUR`.
    temp21-width = '2'.
    temp21-depth = '2'.
    temp21-height = '0.1'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1114`.
    temp21-name = `Fabric bag professional`.
    temp21-supplier_name = `Red Point Stores`.
    temp21-weight_measure = '1.8'.
    temp21-weight_unit = `KG`.
    temp21-price = '31'.
    temp21-currency_code = `EUR`.
    temp21-width = '42'.
    temp21-depth = '32'.
    temp21-height = '7'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1115`.
    temp21-name = `Wireless DSL Router`.
    temp21-supplier_name = `Red Point Stores`.
    temp21-weight_measure = '0.45'.
    temp21-weight_unit = `KG`.
    temp21-price = '49'.
    temp21-currency_code = `EUR`.
    temp21-width = '19.3'.
    temp21-depth = '18'.
    temp21-height = '5'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1116`.
    temp21-name = `Wireless DSL Router / Repeater`.
    temp21-supplier_name = `Red Point Stores`.
    temp21-weight_measure = '0.45'.
    temp21-weight_unit = `KG`.
    temp21-price = '59'.
    temp21-currency_code = `EUR`.
    temp21-width = '19.3'.
    temp21-depth = '18'.
    temp21-height = '5'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1117`.
    temp21-name = `Wireless DSL Router / Repeater and Print Server`.
    temp21-supplier_name = `Technocom`.
    temp21-weight_measure = '0.45'.
    temp21-weight_unit = `KG`.
    temp21-price = '69'.
    temp21-currency_code = `EUR`.
    temp21-width = '19.3'.
    temp21-depth = '18'.
    temp21-height = '5'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1118`.
    temp21-name = `USB Stick`.
    temp21-supplier_name = `Technocom`.
    temp21-weight_measure = '0.015'.
    temp21-weight_unit = `KG`.
    temp21-price = '35'.
    temp21-currency_code = `EUR`.
    temp21-width = '1.5'.
    temp21-depth = '8.7'.
    temp21-height = '1.2'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1119`.
    temp21-name = `Travel Adapter`.
    temp21-supplier_name = `Titanium`.
    temp21-weight_measure = '88'.
    temp21-weight_unit = `G`.
    temp21-price = '79'.
    temp21-currency_code = `EUR`.
    temp21-width = '2'.
    temp21-depth = '3.1'.
    temp21-height = '3.9'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1120`.
    temp21-name = `Cordless Bluetooth Keyboard, english international`.
    temp21-supplier_name = `Technocom`.
    temp21-weight_measure = '1'.
    temp21-weight_unit = `KG`.
    temp21-price = '29'.
    temp21-currency_code = `EUR`.
    temp21-width = '51.4'.
    temp21-depth = '23'.
    temp21-height = '4'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1137`.
    temp21-name = `Flat XXL`.
    temp21-supplier_name = `Technocom`.
    temp21-weight_measure = '18'.
    temp21-weight_unit = `KG`.
    temp21-price = '1430'.
    temp21-currency_code = `EUR`.
    temp21-width = '54'.
    temp21-depth = '22'.
    temp21-height = '38'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1138`.
    temp21-name = `Pocket Mouse`.
    temp21-supplier_name = `Technocom`.
    temp21-weight_measure = '0.02'.
    temp21-weight_unit = `KG`.
    temp21-price = '23'.
    temp21-currency_code = `EUR`.
    temp21-width = '0.3'.
    temp21-depth = '0.5'.
    temp21-height = '1'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1210`.
    temp21-name = `PC Power Station`.
    temp21-supplier_name = `Technocom`.
    temp21-weight_measure = '2.3'.
    temp21-weight_unit = `KG`.
    temp21-price = '2399'.
    temp21-currency_code = `EUR`.
    temp21-width = '28'.
    temp21-depth = '31'.
    temp21-height = '43'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1251`.
    temp21-name = `Astro Laptop 1516`.
    temp21-supplier_name = `Ultrasonic United`.
    temp21-weight_measure = '4.2'.
    temp21-weight_unit = `KG`.
    temp21-price = '989'.
    temp21-currency_code = `EUR`.
    temp21-width = '30'.
    temp21-depth = '18'.
    temp21-height = '3'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1252`.
    temp21-name = `Astro Phone 6`.
    temp21-supplier_name = `Ultrasonic United`.
    temp21-weight_measure = '0.75'.
    temp21-weight_unit = `KG`.
    temp21-price = '649'.
    temp21-currency_code = `EUR`.
    temp21-width = '8'.
    temp21-depth = '6'.
    temp21-height = '1.5'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1253`.
    temp21-name = `Benda Laptop 1408`.
    temp21-supplier_name = `Ultrasonic United`.
    temp21-weight_measure = '4.2'.
    temp21-weight_unit = `KG`.
    temp21-price = '976'.
    temp21-currency_code = `EUR`.
    temp21-width = '30'.
    temp21-depth = '18'.
    temp21-height = '3'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1254`.
    temp21-name = `Bending Screen 21HD`.
    temp21-supplier_name = `Ultrasonic United`.
    temp21-weight_measure = '15'.
    temp21-weight_unit = `KG`.
    temp21-price = '250'.
    temp21-currency_code = `EUR`.
    temp21-width = '37'.
    temp21-depth = '12'.
    temp21-height = '36'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1255`.
    temp21-name = `Broad Screen 22HD`.
    temp21-supplier_name = `Ultrasonic United`.
    temp21-weight_measure = '16'.
    temp21-weight_unit = `KG`.
    temp21-price = '270'.
    temp21-currency_code = `EUR`.
    temp21-width = '39'.
    temp21-depth = '12'.
    temp21-height = '38'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1256`.
    temp21-name = `Cerdik Phone 7`.
    temp21-supplier_name = `Ultrasonic United`.
    temp21-weight_measure = '0.75'.
    temp21-weight_unit = `KG`.
    temp21-price = '549'.
    temp21-currency_code = `EUR`.
    temp21-width = '9'.
    temp21-depth = '15'.
    temp21-height = '1.5'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1257`.
    temp21-name = `Cepat Tablet 10.5`.
    temp21-supplier_name = `Ultrasonic United`.
    temp21-weight_measure = '2.8'.
    temp21-weight_unit = `KG`.
    temp21-price = '549'.
    temp21-currency_code = `EUR`.
    temp21-width = '48'.
    temp21-depth = '31'.
    temp21-height = '4.5'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1258`.
    temp21-name = `Cepat Tablet 8`.
    temp21-supplier_name = `Ultrasonic United`.
    temp21-weight_measure = '2.5'.
    temp21-weight_unit = `KG`.
    temp21-price = '529'.
    temp21-currency_code = `EUR`.
    temp21-width = '38'.
    temp21-depth = '21'.
    temp21-height = '3.5'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1500`.
    temp21-name = `Server Basic`.
    temp21-supplier_name = `Technocom`.
    temp21-weight_measure = '18'.
    temp21-weight_unit = `KG`.
    temp21-price = '5000'.
    temp21-currency_code = `EUR`.
    temp21-width = '34'.
    temp21-depth = '35'.
    temp21-height = '23'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1501`.
    temp21-name = `Server Professional`.
    temp21-supplier_name = `Technocom`.
    temp21-weight_measure = '25'.
    temp21-weight_unit = `KG`.
    temp21-price = '15000'.
    temp21-currency_code = `EUR`.
    temp21-width = '29'.
    temp21-depth = '30'.
    temp21-height = '27'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1502`.
    temp21-name = `Server Power Pro`.
    temp21-supplier_name = `Technocom`.
    temp21-weight_measure = '35'.
    temp21-weight_unit = `KG`.
    temp21-price = '25000'.
    temp21-currency_code = `EUR`.
    temp21-width = '22'.
    temp21-depth = '27.3'.
    temp21-height = '37'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1600`.
    temp21-name = `Family PC Basic`.
    temp21-supplier_name = `Titanium`.
    temp21-weight_measure = '4.8'.
    temp21-weight_unit = `KG`.
    temp21-price = '600'.
    temp21-currency_code = `EUR`.
    temp21-width = '21.4'.
    temp21-depth = '29'.
    temp21-height = '38'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1601`.
    temp21-name = `Family PC Pro`.
    temp21-supplier_name = `Titanium`.
    temp21-weight_measure = '5.3'.
    temp21-weight_unit = `KG`.
    temp21-price = '900'.
    temp21-currency_code = `EUR`.
    temp21-width = '25'.
    temp21-depth = '31.7'.
    temp21-height = '40.2'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1602`.
    temp21-name = `Gaming Monster`.
    temp21-supplier_name = `Titanium`.
    temp21-weight_measure = '5.9'.
    temp21-weight_unit = `KG`.
    temp21-price = '1200'.
    temp21-currency_code = `EUR`.
    temp21-width = '26.5'.
    temp21-depth = '34'.
    temp21-height = '47'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-1603`.
    temp21-name = `Gaming Monster Pro`.
    temp21-supplier_name = `Titanium`.
    temp21-weight_measure = '6.8'.
    temp21-weight_unit = `KG`.
    temp21-price = '1700'.
    temp21-currency_code = `EUR`.
    temp21-width = '27'.
    temp21-depth = '28'.
    temp21-height = '42'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-2000`.
    temp21-name = `7" Widescreen Portable DVD Player w MP3`.
    temp21-supplier_name = `Titanium`.
    temp21-weight_measure = '0.79'.
    temp21-weight_unit = `KG`.
    temp21-price = '249.99'.
    temp21-currency_code = `EUR`.
    temp21-width = '21.4'.
    temp21-depth = '19'.
    temp21-height = '27.6'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-2001`.
    temp21-name = `10" Portable DVD player`.
    temp21-supplier_name = `Titanium`.
    temp21-weight_measure = '0.84'.
    temp21-weight_unit = `KG`.
    temp21-price = '449.99'.
    temp21-currency_code = `EUR`.
    temp21-width = '24'.
    temp21-depth = '19.5'.
    temp21-height = '29'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-2002`.
    temp21-name = `Portable DVD Player with 9" LCD Monitor`.
    temp21-supplier_name = `Technocom`.
    temp21-weight_measure = '0.72'.
    temp21-weight_unit = `KG`.
    temp21-price = '853.99'.
    temp21-currency_code = `EUR`.
    temp21-width = '21'.
    temp21-depth = '16.5'.
    temp21-height = '14'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-2025`.
    temp21-name = `CD/DVD case: 264 sleeves`.
    temp21-supplier_name = `Titanium`.
    temp21-weight_measure = '0.65'.
    temp21-weight_unit = `KG`.
    temp21-price = '44.99'.
    temp21-currency_code = `EUR`.
    temp21-width = '13'.
    temp21-depth = '13'.
    temp21-height = '20'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-2026`.
    temp21-name = `Audio/Video Cable Kit - 4m`.
    temp21-supplier_name = `Titanium`.
    temp21-weight_measure = '0.2'.
    temp21-weight_unit = `KG`.
    temp21-price = '29.99'.
    temp21-currency_code = `EUR`.
    temp21-width = '21'.
    temp21-depth = '10.2'.
    temp21-height = '13'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-2027`.
    temp21-name = `Removable CD/DVD Laser Labels`.
    temp21-supplier_name = `Titanium`.
    temp21-weight_measure = '0.15'.
    temp21-weight_unit = `KG`.
    temp21-price = '8.99'.
    temp21-currency_code = `EUR`.
    temp21-width = '5.5'.
    temp21-depth = '2'.
    temp21-height = '2'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-6100`.
    temp21-name = `Beam Breaker B-1`.
    temp21-supplier_name = `Titanium`.
    temp21-weight_measure = '1.7'.
    temp21-weight_unit = `KG`.
    temp21-price = '469'.
    temp21-currency_code = `EUR`.
    temp21-width = '30.4'.
    temp21-depth = '23.1'.
    temp21-height = '23'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-6101`.
    temp21-name = `Beam Breaker B-2`.
    temp21-supplier_name = `Technocom`.
    temp21-weight_measure = '2'.
    temp21-weight_unit = `KG`.
    temp21-price = '679'.
    temp21-currency_code = `EUR`.
    temp21-width = '30.4'.
    temp21-depth = '23.1'.
    temp21-height = '23'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-6102`.
    temp21-name = `Beam Breaker B-3`.
    temp21-supplier_name = `Technocom`.
    temp21-weight_measure = '2.5'.
    temp21-weight_unit = `KG`.
    temp21-price = '889'.
    temp21-currency_code = `EUR`.
    temp21-width = '30.4'.
    temp21-depth = '23.1'.
    temp21-height = '23'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-6110`.
    temp21-name = `Play Movie`.
    temp21-supplier_name = `Fasttech`.
    temp21-weight_measure = '2.4'.
    temp21-weight_unit = `KG`.
    temp21-price = '130'.
    temp21-currency_code = `EUR`.
    temp21-width = '37'.
    temp21-depth = '24'.
    temp21-height = '6'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-6111`.
    temp21-name = `Record Movie`.
    temp21-supplier_name = `Fasttech`.
    temp21-weight_measure = '3.1'.
    temp21-weight_unit = `KG`.
    temp21-price = '288'.
    temp21-currency_code = `EUR`.
    temp21-width = '38'.
    temp21-depth = '26'.
    temp21-height = '6.2'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-6120`.
    temp21-name = `ITelo MusicStick`.
    temp21-supplier_name = `Fasttech`.
    temp21-weight_measure = '134'.
    temp21-weight_unit = `G`.
    temp21-price = '45'.
    temp21-currency_code = `EUR`.
    temp21-width = '1.5'.
    temp21-depth = '6'.
    temp21-height = '1'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-6121`.
    temp21-name = `ITelo Jog-Mate`.
    temp21-supplier_name = `Fasttech`.
    temp21-weight_measure = '134'.
    temp21-weight_unit = `G`.
    temp21-price = '63'.
    temp21-currency_code = `EUR`.
    temp21-width = '5.1'.
    temp21-depth = '8'.
    temp21-height = '9.2'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-6122`.
    temp21-name = `Power Pro Player 40`.
    temp21-supplier_name = `Fasttech`.
    temp21-weight_measure = '266'.
    temp21-weight_unit = `G`.
    temp21-price = '167'.
    temp21-currency_code = `EUR`.
    temp21-width = '5.1'.
    temp21-depth = '8'.
    temp21-height = '9.2'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-6123`.
    temp21-name = `Power Pro Player 80`.
    temp21-supplier_name = `Fasttech`.
    temp21-weight_measure = '267'.
    temp21-weight_unit = `G`.
    temp21-price = '299'.
    temp21-currency_code = `EUR`.
    temp21-width = '4'.
    temp21-depth = '6'.
    temp21-height = '0.8'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-6130`.
    temp21-name = `Flat Watch HD32`.
    temp21-supplier_name = `Very Best Screens`.
    temp21-weight_measure = '2.6'.
    temp21-weight_unit = `KG`.
    temp21-price = '1459'.
    temp21-currency_code = `EUR`.
    temp21-width = '78'.
    temp21-depth = '22.1'.
    temp21-height = '55'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-6131`.
    temp21-name = `Flat Watch HD37`.
    temp21-supplier_name = `Very Best Screens`.
    temp21-weight_measure = '2.2'.
    temp21-weight_unit = `KG`.
    temp21-price = '1199'.
    temp21-currency_code = `EUR`.
    temp21-width = '99.1'.
    temp21-depth = '26'.
    temp21-height = '61'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-6132`.
    temp21-name = `Flat Watch HD41`.
    temp21-supplier_name = `Very Best Screens`.
    temp21-weight_measure = '1.8'.
    temp21-weight_unit = `KG`.
    temp21-price = '899'.
    temp21-currency_code = `EUR`.
    temp21-width = '128'.
    temp21-depth = '23'.
    temp21-height = '79.1'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-7000`.
    temp21-name = `Copperberry`.
    temp21-supplier_name = `Fasttech`.
    temp21-weight_measure = '0.5'.
    temp21-weight_unit = `KG`.
    temp21-price = '549'.
    temp21-currency_code = `EUR`.
    temp21-width = '8.1'.
    temp21-depth = '13'.
    temp21-height = '12.1'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-7010`.
    temp21-name = `Silverberry`.
    temp21-supplier_name = `Fasttech`.
    temp21-weight_measure = '0.5'.
    temp21-weight_unit = `KG`.
    temp21-price = '549'.
    temp21-currency_code = `EUR`.
    temp21-width = '8.1'.
    temp21-depth = '13'.
    temp21-height = '12.1'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-7020`.
    temp21-name = `Goldberry`.
    temp21-supplier_name = `Fasttech`.
    temp21-weight_measure = '0.5'.
    temp21-weight_unit = `KG`.
    temp21-price = '549'.
    temp21-currency_code = `EUR`.
    temp21-width = '8.1'.
    temp21-depth = '13'.
    temp21-height = '12.1'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-7030`.
    temp21-name = `Platinberry`.
    temp21-supplier_name = `Fasttech`.
    temp21-weight_measure = '0.5'.
    temp21-weight_unit = `KG`.
    temp21-price = '549'.
    temp21-currency_code = `EUR`.
    temp21-width = '8.1'.
    temp21-depth = '13'.
    temp21-height = '12.1'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-8000`.
    temp21-name = `ITelO FlexTop I4000`.
    temp21-supplier_name = `Titanium`.
    temp21-weight_measure = '4'.
    temp21-weight_unit = `KG`.
    temp21-price = '799'.
    temp21-currency_code = `EUR`.
    temp21-width = '31'.
    temp21-depth = '19'.
    temp21-height = '3.1'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-8001`.
    temp21-name = `ITelO FlexTop I6300c`.
    temp21-supplier_name = `Titanium`.
    temp21-weight_measure = '4.2'.
    temp21-weight_unit = `KG`.
    temp21-price = '799'.
    temp21-currency_code = `EUR`.
    temp21-width = '32'.
    temp21-depth = '20'.
    temp21-height = '3.4'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-8002`.
    temp21-name = `ITelO FlexTop I9100`.
    temp21-supplier_name = `Titanium`.
    temp21-weight_measure = '3.5'.
    temp21-weight_unit = `KG`.
    temp21-price = '1199'.
    temp21-currency_code = `EUR`.
    temp21-width = '38'.
    temp21-depth = '21'.
    temp21-height = '4.1'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-8003`.
    temp21-name = `ITelO FlexTop I9800`.
    temp21-supplier_name = `Titanium`.
    temp21-weight_measure = '3.8'.
    temp21-weight_unit = `KG`.
    temp21-price = '1388'.
    temp21-currency_code = `EUR`.
    temp21-width = '48'.
    temp21-depth = '31'.
    temp21-height = '4.5'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-9991`.
    temp21-name = `Smartphone Leather Case`.
    temp21-supplier_name = `Ultrasonic United`.
    temp21-weight_measure = '0.02'.
    temp21-weight_unit = `KG`.
    temp21-price = '25'.
    temp21-currency_code = `EUR`.
    temp21-width = '48'.
    temp21-depth = '31'.
    temp21-height = '4.5'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-9992`.
    temp21-name = `Smartphone Alpha`.
    temp21-supplier_name = `Ultrasonic United`.
    temp21-weight_measure = '0.75'.
    temp21-weight_unit = `KG`.
    temp21-price = '599'.
    temp21-currency_code = `EUR`.
    temp21-width = '48'.
    temp21-depth = '31'.
    temp21-height = '4.5'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-9993`.
    temp21-name = `Mini Tablet`.
    temp21-supplier_name = `Ultrasonic United`.
    temp21-weight_measure = '3.8'.
    temp21-weight_unit = `KG`.
    temp21-price = '833'.
    temp21-currency_code = `EUR`.
    temp21-width = '48'.
    temp21-depth = '31'.
    temp21-height = '4.5'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-9994`.
    temp21-name = `Camcorder View`.
    temp21-supplier_name = `Ultrasonic United`.
    temp21-weight_measure = '3.8'.
    temp21-weight_unit = `KG`.
    temp21-price = '1388'.
    temp21-currency_code = `EUR`.
    temp21-width = '48'.
    temp21-depth = '31'.
    temp21-height = '27'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-9995`.
    temp21-name = `Tablet Pouch`.
    temp21-supplier_name = `Titanium`.
    temp21-weight_measure = '0.03'.
    temp21-weight_unit = `KG`.
    temp21-price = '20'.
    temp21-currency_code = `EUR`.
    temp21-width = '25'.
    temp21-depth = '40'.
    temp21-height = '4.5'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-9996`.
    temp21-name = `Tablet Pouch`.
    temp21-supplier_name = `Titanium`.
    temp21-weight_measure = '0.03'.
    temp21-weight_unit = `KG`.
    temp21-price = '20'.
    temp21-currency_code = `EUR`.
    temp21-width = '25'.
    temp21-depth = '40'.
    temp21-height = '4.5'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-9997`.
    temp21-name = `e-Book Reader ReadMe`.
    temp21-supplier_name = `Titanium`.
    temp21-weight_measure = '3.8'.
    temp21-weight_unit = `KG`.
    temp21-price = '33'.
    temp21-currency_code = `EUR`.
    temp21-width = '48'.
    temp21-depth = '31'.
    temp21-height = '4.5'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-9998`.
    temp21-name = `Smartphone Beta`.
    temp21-supplier_name = `Titanium`.
    temp21-weight_measure = '0.75'.
    temp21-weight_unit = `KG`.
    temp21-price = '30'.
    temp21-currency_code = `EUR`.
    temp21-width = '48'.
    temp21-depth = '31'.
    temp21-height = '4.5'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `HT-9999`.
    temp21-name = `Maxi Tablet`.
    temp21-supplier_name = `Titanium`.
    temp21-weight_measure = '3.8'.
    temp21-weight_unit = `KG`.
    temp21-price = '749'.
    temp21-currency_code = `EUR`.
    temp21-width = '48'.
    temp21-depth = '31'.
    temp21-height = '4.5'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    temp21-product_id = `PF-1000`.
    temp21-name = `Flyer`.
    temp21-supplier_name = `Titanium`.
    temp21-weight_measure = '0.01'.
    temp21-weight_unit = `KG`.
    temp21-price = '0'.
    temp21-currency_code = `EUR`.
    temp21-width = '46'.
    temp21-depth = '30'.
    temp21-height = '3'.
    temp21-dim_unit = `cm`.
    INSERT temp21 INTO TABLE temp20.
    t_products = temp20.


    weight_state_set( ).
    t_all      = t_products.
    t_filtered = t_products.

  ENDMETHOD.

ENDCLASS.
