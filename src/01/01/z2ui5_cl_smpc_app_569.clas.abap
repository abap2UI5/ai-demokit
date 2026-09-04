" @keywords table sap.m tablednd hbox button overflowtoolbar title menu menuitem column text dropinfo
" @summary Shows the different kinds of drag-and-drop capabilities across view boundaries along with custom context menu alternatives to perform these action.
CLASS z2ui5_cl_smpc_app_569 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             name     TYPE string,
             category TYPE string,
             quantity TYPE i,
             " Utils.ranking: 0 keeps the row in Available, anything above puts it
             " in Selected and orders it there (descending)
             rank     TYPE i,
             selected TYPE abap_bool,
           END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

    CONSTANTS c_rank_default TYPE i VALUE 1024.

    DATA t_products TYPE ty_t_product.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS products_table IMPORTING node     TYPE REF TO z2ui5_cl_ui5_view_builder
                                     selected TYPE abap_bool.
    METHODS move_to_selected.
    METHODS move_to_available.
    METHODS move_sibling IMPORTING up TYPE abap_bool.
    METHODS rank_after_drop IMPORTING dragged  TYPE string
                                      dropped  TYPE string
                                      position TYPE string.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_569 IMPLEMENTATION.

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
    DATA box TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    box = view->ele( n = `View` ns = `mvc`
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:c`   v = `sap.ui.core`
        )->a( n = `xmlns:dnd` v = `sap.ui.core.dnd`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->ele( `Page`
            )->a( n = `showHeader`      v = `false`
            )->a( n = `enableScrolling` v = `true`
            )->a( n = `class`           v = `sapUiContentPadding`

            )->ele( `content`
                )->ele( `HBox`
                    )->a( n = `renderType` v = `Bare` ).

    " the two sub-views of the sample are two tables in one view here
    products_table( node = box selected = abap_false ).

    box->ele( `VBox`
        )->a( n = `justifyContent` v = `Center`
        )->a( n = `class`          v = `sapUiTinyMarginBeginEnd`

        )->tag( `Button`
            )->a( n = `class`   v = `sapUiTinyMarginBottom`
            )->a( n = `icon`    v = `sap-icon://navigation-right-arrow`
            )->a( n = `tooltip` v = `Move to selected`
            )->a( n = `press`   v = client->_event( `MOVE_TO_SELECTED` )
        )->tag( `Button`
            )->a( n = `icon`    v = `sap-icon://navigation-left-arrow`
            )->a( n = `tooltip` v = `Move to available`
            )->a( n = `press`   v = client->_event( `MOVE_TO_AVAILABLE` )

    )->end( ).

    products_table( node = box selected = abap_true ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD products_table.

    " the two tables differ in their filter, their toolbar and their drag/drop
    " groups; both bind the SAME collection, exactly as the sample's two views do
    DATA temp1 TYPE string.
    DATA items LIKE temp1.
    DATA temp2 TYPE string.
    DATA table TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp3 TYPE string.
    DATA toolbar TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA menu TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA dnd TYPE REF TO z2ui5_cl_ui5_view_builder.
      DATA temp4 TYPE string_table.
      DATA temp5 TYPE string_table.
    IF selected = abap_true.
      temp1 = |\{ path: '{ client->_bind_path( t_products ) }', filters: \{path: 'RANK', operator: 'GT', value1: '0'\}, sorter: \{path: 'RANK', descending: true\} \}|.
    ELSE.
      temp1 = |\{ path: '{ client->_bind_path( t_products ) }', filters: \{path: 'RANK', operator: 'EQ', value1: '0'\} \}|.
    ENDIF.
    
    items = temp1.

    
    IF selected = abap_true.
      temp2 = `selectedTable`.
    ELSE.
      temp2 = `availableTable`.
    ENDIF.
    
    table = node->ele( `Table`
        )->a( n = `id`               v = temp2
        )->a( n = `mode`             v = `SingleSelectMaster`
        )->a( n = `growing`          v = `true`
        )->a( n = `growingThreshold` v = `10`
        )->a( n = `items`            v = items ).

    IF selected = abap_true.
      table->a( n = `noDataText` v = `Please drag-and-drop products here.` ).
    ENDIF.

    
    IF selected = abap_true.
      temp3 = `Selected Products`.
    ELSE.
      temp3 = `Available Products`.
    ENDIF.
    
    toolbar = table->ele( `headerToolbar`
        )->ele( `OverflowToolbar`
            )->tag( `Title`
                )->a( n = `text` v = temp3 ).

    IF selected = abap_true.
      toolbar->tag( `ToolbarSpacer`
          )->tag( `Button`
              )->a( n = `icon`    v = `sap-icon://navigation-up-arrow`
              )->a( n = `tooltip` v = `Move up`
              )->a( n = `press`   v = client->_event( `MOVE_UP` )
          )->tag( `Button`
              )->a( n = `icon`    v = `sap-icon://navigation-down-arrow`
              )->a( n = `tooltip` v = `Move down`
              )->a( n = `press`   v = client->_event( `MOVE_DOWN` ) ).
    ENDIF.

    " the context menu of each table
    
    menu = table->ele( `contextMenu`
        )->ele( `Menu` ).

    IF selected = abap_true.
      menu->tag( `MenuItem`
          )->a( n = `text`  v = `Move to Available Products`
          )->a( n = `press` v = client->_event( `MOVE_TO_AVAILABLE` )
          )->tag( `MenuItem`
              )->a( n = `text`  v = `Move up`
              )->a( n = `press` v = client->_event( `MOVE_UP` )
          )->tag( `MenuItem`
              )->a( n = `text`  v = `Move down`
              )->a( n = `press` v = client->_event( `MOVE_DOWN` ) ).
    ELSE.
      menu->tag( `MenuItem`
          )->a( n = `text`  v = `Move to Selected Products`
          )->a( n = `press` v = client->_event( `MOVE_TO_SELECTED` ) ).
    ENDIF.

    table->ele( `columns`
        )->ele( `Column`

            )->tag( `Text`
                )->a( n = `text` v = `Product Name`

        )->end(
        )->ele( `Column`

            )->tag( `Text`
                )->a( n = `text` v = `Category`

        )->end(
        )->ele( `Column`
            )->a( n = `hAlign` v = `End`
            )->a( n = `width`  v = `6rem`

            )->tag( `Text`
                )->a( n = `text` v = `Quantity`

        )->end(
    )->end( ).

    " the drag and drop configuration: the available table only gives rows away
    " and takes them back, the selected one also re-orders within itself
    
    dnd = table->ele( `dragDropConfig` ).

    IF selected = abap_true.
      
      CLEAR temp4.
      INSERT `${$parameters>/draggedControl}.getBindingContext().getProperty('NAME')` INTO TABLE temp4.
      INSERT `${$parameters>/droppedControl}.getBindingContext() ? ${$parameters>/droppedControl}.getBindingContext().getProperty('NAME') : ''` INTO TABLE temp4.
      INSERT `${$parameters>/dropPosition}` INTO TABLE temp4.
      
      CLEAR temp5.
      INSERT `${$parameters>/draggedControl}.getBindingContext().getProperty('NAME')` INTO TABLE temp5.
      INSERT `${$parameters>/droppedControl}.getBindingContext() ? ${$parameters>/droppedControl}.getBindingContext().getProperty('NAME') : ''` INTO TABLE temp5.
      INSERT `${$parameters>/dropPosition}` INTO TABLE temp5.
      dnd->tag( n = `DragInfo` ns = `dnd`
          )->a( n = `groupName`         v = `selected2available`
          )->a( n = `sourceAggregation` v = `items`
          )->tag( n = `DropInfo` ns = `dnd`
              )->a( n = `groupName`         v = `available2selected`
              )->a( n = `targetAggregation` v = `items`
              )->a( n = `dropPosition`      v = `Between`
              )->a( n = `drop`              v = client->_event( val   = `DROP_SELECTED`
                                                                t_arg = temp4 )
          )->tag( n = `DragDropInfo` ns = `dnd`
              )->a( n = `sourceAggregation` v = `items`
              )->a( n = `targetAggregation` v = `items`
              )->a( n = `dropPosition`      v = `Between`
              )->a( n = `drop`              v = client->_event( val   = `DROP_SELECTED`
                                                                t_arg = temp5 ) ).
    ELSE.
      dnd->tag( n = `DragInfo` ns = `dnd`
          )->a( n = `groupName`         v = `available2selected`
          )->a( n = `sourceAggregation` v = `items`
          )->tag( n = `DropInfo` ns = `dnd`
              )->a( n = `groupName`         v = `selected2available`
              )->a( n = `drop`              v = client->_event( val = `DROP_AVAILABLE` arg = `${$parameters>/draggedControl}.getBindingContext().getProperty('NAME')` ) ).
    ENDIF.

    table->ele( `items`
        )->ele( `ColumnListItem`
            )->a( n = `selected` v = `{SELECTED}`

            )->ele( `cells`
                )->tag( `Text`
                    )->a( n = `text`     v = `{NAME}`
                    )->a( n = `wrapping` v = `false`
                )->tag( `Text`
                    )->a( n = `text`     v = `{CATEGORY}`
                    )->a( n = `wrapping` v = `false`
                )->tag( `Text`
                    )->a( n = `text` v = |\{ path: 'QUANTITY', type: 'sap.ui.model.type.Integer' \}|

            )->end(
        )->end(
    )->end( ).

  ENDMETHOD.


  METHOD move_to_selected.

    " moveToSelectedProductsTable: the selected available row joins the selected
    " table ABOVE its current first row (ranking.Before)
    FIELD-SYMBOLS <row> TYPE z2ui5_cl_smpc_app_569=>ty_s_product.
    DATA top_rank TYPE i.
    DATA product LIKE LINE OF t_products.
    DATA temp6 TYPE i.
    READ TABLE t_products WITH KEY selected = abap_true rank = 0 ASSIGNING <row>.
    IF sy-subrc <> 0.
      client->message_toast_display( `Please select a row!` ).
      RETURN.
    ENDIF.

    
    top_rank = 0.
    
    LOOP AT t_products INTO product WHERE rank > 0.
      IF product-rank > top_rank.
        top_rank = product-rank.
      ENDIF.
    ENDLOOP.

    
    IF top_rank = 0.
      temp6 = c_rank_default.
    ELSE.
      temp6 = top_rank + c_rank_default.
    ENDIF.
    <row>-rank = temp6.

  ENDMETHOD.


  METHOD move_to_available.

    " moveToAvailableProductsTable: the rank goes back to Initial
    FIELD-SYMBOLS <row> TYPE z2ui5_cl_smpc_app_569=>ty_s_product.
    READ TABLE t_products WITH KEY selected = abap_true ASSIGNING <row>.
    IF sy-subrc <> 0 OR <row>-rank = 0.
      client->message_toast_display( `Please select a row!` ).
      RETURN.
    ENDIF.
    <row>-rank = 0.

  ENDMETHOD.


  METHOD move_sibling.

    " moveSelectedItem: swap the ranks of the selected row and its neighbour in
    " the descending order the selected table is sorted in
    DATA ordered LIKE t_products.
    DATA index TYPE i.
    DATA temp8 LIKE sy-subrc.
    DATA temp7 TYPE i.
    DATA sibling LIKE temp7.
    DATA moved_name TYPE z2ui5_cl_smpc_app_569=>ty_s_product-name.
    DATA temp9 LIKE LINE OF ordered.
    DATA temp10 LIKE sy-tabix.
    DATA sibling_name TYPE z2ui5_cl_smpc_app_569=>ty_s_product-name.
    DATA temp11 LIKE LINE OF ordered.
    DATA temp12 LIKE sy-tabix.
    DATA moved_rank TYPE z2ui5_cl_smpc_app_569=>ty_s_product-rank.
    DATA temp13 LIKE LINE OF ordered.
    DATA temp14 LIKE sy-tabix.
    DATA sibling_rank TYPE z2ui5_cl_smpc_app_569=>ty_s_product-rank.
    DATA temp15 LIKE LINE OF ordered.
    DATA temp16 LIKE sy-tabix.
    FIELD-SYMBOLS <moved> TYPE z2ui5_cl_smpc_app_569=>ty_s_product.
    FIELD-SYMBOLS <sibling> TYPE z2ui5_cl_smpc_app_569=>ty_s_product.
    ordered = t_products.
    DELETE ordered WHERE rank = 0.
    SORT ordered BY rank DESCENDING.

    
    
    READ TABLE ordered WITH KEY selected = abap_true TRANSPORTING NO FIELDS.
    temp8 = sy-tabix.
    index = temp8.
    IF index = 0.
      client->message_toast_display( `Please select a row!` ).
      RETURN.
    ENDIF.

    
    IF up = abap_true.
      temp7 = index - 1.
    ELSE.
      temp7 = index + 1.
    ENDIF.
    
    sibling = temp7.
    IF sibling < 1 OR sibling > lines( ordered ).
      RETURN.
    ENDIF.

    
    
    
    temp10 = sy-tabix.
    READ TABLE ordered INDEX index INTO temp9.
    sy-tabix = temp10.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    moved_name = temp9-name.
    
    
    
    temp12 = sy-tabix.
    READ TABLE ordered INDEX sibling INTO temp11.
    sy-tabix = temp12.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    sibling_name = temp11-name.
    
    
    
    temp14 = sy-tabix.
    READ TABLE ordered INDEX index INTO temp13.
    sy-tabix = temp14.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    moved_rank = temp13-rank.
    
    
    
    temp16 = sy-tabix.
    READ TABLE ordered INDEX sibling INTO temp15.
    sy-tabix = temp16.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    sibling_rank = temp15-rank.

    
    READ TABLE t_products WITH KEY name = moved_name ASSIGNING <moved>.
    IF sy-subrc = 0.
      <moved>-rank = sibling_rank.
    ENDIF.
    
    READ TABLE t_products WITH KEY name = sibling_name ASSIGNING <sibling>.
    IF sy-subrc = 0.
      <sibling>-rank = moved_rank.
    ENDIF.

  ENDMETHOD.


  METHOD rank_after_drop.

    " onDropSelectedProductsTable: Before/After/Between of Utils.ranking
    FIELD-SYMBOLS <dragged> TYPE z2ui5_cl_smpc_app_569=>ty_s_product.
    DATA ordered LIKE t_products.
    DATA drop_index TYPE i.
    DATA temp17 LIKE sy-subrc.
    DATA drop_rank TYPE z2ui5_cl_smpc_app_569=>ty_s_product-rank.
    DATA temp18 LIKE LINE OF ordered.
    DATA temp19 LIKE sy-tabix.
    DATA temp8 TYPE i.
    DATA neighbour LIKE temp8.
      DATA temp9 TYPE i.
    DATA temp10 LIKE LINE OF ordered.
    DATA temp11 LIKE sy-tabix.
    READ TABLE t_products WITH KEY name = dragged ASSIGNING <dragged>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    IF dropped IS INITIAL.
      " dropped on the empty table
      <dragged>-rank = c_rank_default.
      RETURN.
    ENDIF.

    
    ordered = t_products.
    DELETE ordered WHERE rank = 0.
    SORT ordered BY rank DESCENDING.

    
    
    READ TABLE ordered WITH KEY name = dropped TRANSPORTING NO FIELDS.
    temp17 = sy-tabix.
    drop_index = temp17.
    IF drop_index = 0.
      <dragged>-rank = c_rank_default.
      RETURN.
    ENDIF.

    
    
    
    temp19 = sy-tabix.
    READ TABLE ordered INDEX drop_index INTO temp18.
    sy-tabix = temp19.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    drop_rank = temp18-rank.
    
    IF position = `After`.
      temp8 = drop_index + 1.
    ELSE.
      temp8 = drop_index - 1.
    ENDIF.
    
    neighbour = temp8.

    IF neighbour < 1 OR neighbour > lines( ordered ).
      " dropped before the first row or after the last one
      
      IF position = `After`.
        temp9 = drop_rank DIV 2.
      ELSE.
        temp9 = drop_rank + c_rank_default.
      ENDIF.
      <dragged>-rank = temp9.
      RETURN.
    ENDIF.

    
    
    temp11 = sy-tabix.
    READ TABLE ordered INDEX neighbour INTO temp10.
    sy-tabix = temp11.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    <dragged>-rank = ( drop_rank + temp10-rank ) DIV 2.

  ENDMETHOD.


  METHOD on_event.
        DATA back_name TYPE string.
        FIELD-SYMBOLS <row> TYPE z2ui5_cl_smpc_app_569=>ty_s_product.

    CASE client->get_event( ).

      WHEN `MOVE_TO_SELECTED`.
        move_to_selected( ).
        view_display( ).

      WHEN `MOVE_TO_AVAILABLE`.
        move_to_available( ).
        view_display( ).

      WHEN `MOVE_UP`.
        move_sibling( abap_true ).
        view_display( ).

      WHEN `MOVE_DOWN`.
        move_sibling( abap_false ).
        view_display( ).

      WHEN `DROP_SELECTED`.
        rank_after_drop( dragged  = client->get_event_arg( )
                         dropped  = client->get_event_arg( 2 )
                         position = client->get_event_arg( 3 ) ).
        view_display( ).

      WHEN `DROP_AVAILABLE`.
        " onDropAvailableProductsTable: the rank is reset to Initial
        
        back_name = client->get_event_arg( ).
        
        READ TABLE t_products WITH KEY name = back_name ASSIGNING <row>.
        IF sy-subrc = 0.
          <row>-rank = 0.
        ENDIF.
        view_display( ).

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " the full mock /ProductCollection with the Rank the controller seeds
    " (Utils.ranking.Initial = 0 for every row)
    DATA temp12 TYPE z2ui5_cl_smpc_app_569=>ty_t_product.
    DATA temp13 LIKE LINE OF temp12.
    CLEAR temp12.
    
    temp13-name = `Notebook Basic 15`.
    temp13-category = `Laptops`.
    temp13-quantity = 10.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Notebook Basic 17`.
    temp13-category = `Laptops`.
    temp13-quantity = 20.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Notebook Basic 18`.
    temp13-category = `Laptops`.
    temp13-quantity = 10.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Notebook Basic 19`.
    temp13-category = `Laptops`.
    temp13-quantity = 15.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `ITelO Vault`.
    temp13-category = `Accessories`.
    temp13-quantity = 15.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Notebook Professional 15`.
    temp13-category = `Accessories`.
    temp13-quantity = 16.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Notebook Professional 17`.
    temp13-category = `Laptops`.
    temp13-quantity = 17.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `ITelO Vault Net`.
    temp13-category = `Accessories`.
    temp13-quantity = 14.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `ITelO Vault SAT`.
    temp13-category = `Accessories`.
    temp13-quantity = 50.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Comfort Easy`.
    temp13-category = `Accessories`.
    temp13-quantity = 30.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Comfort Senior`.
    temp13-category = `Accessories`.
    temp13-quantity = 24.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Ergo Screen E-I`.
    temp13-category = `Flat Screen Monitors`.
    temp13-quantity = 14.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Ergo Screen E-II`.
    temp13-category = `Flat Screen Monitors`.
    temp13-quantity = 24.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Ergo Screen E-III`.
    temp13-category = `Flat Screen Monitors`.
    temp13-quantity = 50.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Flat Basic`.
    temp13-category = `Flat Screen Monitors`.
    temp13-quantity = 23.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Flat Future`.
    temp13-category = `Flat Screen Monitors`.
    temp13-quantity = 22.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Flat XL`.
    temp13-category = `Flat Screen Monitors`.
    temp13-quantity = 23.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Laser Professional Eco`.
    temp13-category = `Printers`.
    temp13-quantity = 21.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Laser Basic`.
    temp13-category = `Printers`.
    temp13-quantity = 8.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Laser Allround`.
    temp13-category = `Printers`.
    temp13-quantity = 9.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Ultra Jet Super Color`.
    temp13-category = `Printers`.
    temp13-quantity = 17.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Ultra Jet Mobile`.
    temp13-category = `Printers`.
    temp13-quantity = 18.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Ultra Jet Super Highspeed`.
    temp13-category = `Printers`.
    temp13-quantity = 25.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Multi Print`.
    temp13-category = `Multifunction Printers`.
    temp13-quantity = 16.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Multi Color`.
    temp13-category = `Multifunction Printers`.
    temp13-quantity = 5.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Cordless Mouse`.
    temp13-category = `Mice`.
    temp13-quantity = 25.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Speed Mouse`.
    temp13-category = `Mice`.
    temp13-quantity = 12.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Track Mouse`.
    temp13-category = `Mice`.
    temp13-quantity = 12.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Ergonomic Keyboard`.
    temp13-category = `Keyboards`.
    temp13-quantity = 50.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Internet Keyboard`.
    temp13-category = `Keyboards`.
    temp13-quantity = 35.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Media Keyboard`.
    temp13-category = `Keyboards`.
    temp13-quantity = 26.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Mousepad`.
    temp13-category = `Mousepads`.
    temp13-quantity = 12.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Ergo Mousepad`.
    temp13-category = `Mousepads`.
    temp13-quantity = 16.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Designer Mousepad`.
    temp13-category = `Mousepads`.
    temp13-quantity = 26.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Universal card reader`.
    temp13-category = `Computer System Accessories`.
    temp13-quantity = 22.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Proctra X`.
    temp13-category = `Graphic Cards`.
    temp13-quantity = 15.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Gladiator MX`.
    temp13-category = `Graphic Cards`.
    temp13-quantity = 16.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Hurricane GX`.
    temp13-category = `Graphic Cards`.
    temp13-quantity = 13.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Hurricane GX/LN`.
    temp13-category = `Graphic Cards`.
    temp13-quantity = 5.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Photo Scan`.
    temp13-category = `Scanners`.
    temp13-quantity = 8.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Power Scan`.
    temp13-category = `Scanners`.
    temp13-quantity = 11.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Jet Scan Professional`.
    temp13-category = `Scanners`.
    temp13-quantity = 13.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Jet Scan Professional`.
    temp13-category = `Scanners`.
    temp13-quantity = 10.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Copymaster`.
    temp13-category = `Multifunction Printers`.
    temp13-quantity = 10.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Surround Sound`.
    temp13-category = `Speakers`.
    temp13-quantity = 20.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Blaster Extreme`.
    temp13-category = `Speakers`.
    temp13-quantity = 15.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Sound Booster`.
    temp13-category = `Speakers`.
    temp13-quantity = 50.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Lovely Sound 5.1 Wireless`.
    temp13-category = `Accessories`.
    temp13-quantity = 12.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Lovely Sound 5.1`.
    temp13-category = `Accessories`.
    temp13-quantity = 18.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Lovely Sound Stereo`.
    temp13-category = `Accessories`.
    temp13-quantity = 21.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Smart Office`.
    temp13-category = `Software`.
    temp13-quantity = 25.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Smart Design`.
    temp13-category = `Software`.
    temp13-quantity = 26.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Smart Network`.
    temp13-category = `Software`.
    temp13-quantity = 28.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Smart Multimedia`.
    temp13-category = `Software`.
    temp13-quantity = 9.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Smart Games`.
    temp13-category = `Software`.
    temp13-quantity = 13.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Smart Internet Antivirus`.
    temp13-category = `Software`.
    temp13-quantity = 17.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Smart Firewall`.
    temp13-category = `Software`.
    temp13-quantity = 19.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Smart Money`.
    temp13-category = `Software`.
    temp13-quantity = 18.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `PC Lock`.
    temp13-category = `Computer System Accessories`.
    temp13-quantity = 14.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Notebook Lock`.
    temp13-category = `Computer System Accessories`.
    temp13-quantity = 20.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Web cam reality`.
    temp13-category = `Computer System Accessories`.
    temp13-quantity = 27.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Screen clean`.
    temp13-category = `Computer System Accessories`.
    temp13-quantity = 17.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Fabric bag professional`.
    temp13-category = `Computer System Accessories`.
    temp13-quantity = 14.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Wireless DSL Router`.
    temp13-category = `Telecommunications`.
    temp13-quantity = 16.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Wireless DSL Router / Repeater`.
    temp13-category = `Telecommunications`.
    temp13-quantity = 12.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Wireless DSL Router / Repeater and Print Server`.
    temp13-category = `Telecommunications`.
    temp13-quantity = 12.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `USB Stick`.
    temp13-category = `Computer System Accessories`.
    temp13-quantity = 14.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Travel Adapter`.
    temp13-category = `Accessories`.
    temp13-quantity = 10.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Cordless Bluetooth Keyboard, english international`.
    temp13-category = `Keyboards`.
    temp13-quantity = 13.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Flat XXL`.
    temp13-category = `Flat Screen Monitors`.
    temp13-quantity = 10.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Pocket Mouse`.
    temp13-category = `Mice`.
    temp13-quantity = 20.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `PC Power Station`.
    temp13-category = `PCs`.
    temp13-quantity = 22.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Astro Laptop 1516`.
    temp13-category = `Laptops`.
    temp13-quantity = 23.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Astro Phone 6`.
    temp13-category = `Smartphones and Tablets`.
    temp13-quantity = 28.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Benda Laptop 1408`.
    temp13-category = `Laptops`.
    temp13-quantity = 27.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Bending Screen 21HD`.
    temp13-category = `Flat Screens`.
    temp13-quantity = 23.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Broad Screen 22HD`.
    temp13-category = `Flat Screens`.
    temp13-quantity = 5.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Cerdik Phone 7`.
    temp13-category = `Smartphones and Tablets`.
    temp13-quantity = 19.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Cepat Tablet 10.5`.
    temp13-category = `Smartphones and Tablets`.
    temp13-quantity = 17.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Cepat Tablet 8`.
    temp13-category = `Smartphones and Tablets`.
    temp13-quantity = 24.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Server Basic`.
    temp13-category = `Servers`.
    temp13-quantity = 24.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Server Professional`.
    temp13-category = `Servers`.
    temp13-quantity = 26.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Server Power Pro`.
    temp13-category = `Servers`.
    temp13-quantity = 34.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Family PC Basic`.
    temp13-category = `Desktop Computers`.
    temp13-quantity = 10.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Family PC Pro`.
    temp13-category = `Desktop Computers`.
    temp13-quantity = 20.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Gaming Monster`.
    temp13-category = `Desktop Computers`.
    temp13-quantity = 24.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Gaming Monster Pro`.
    temp13-category = `Desktop Computers`.
    temp13-quantity = 25.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `7" Widescreen Portable DVD Player w MP3`.
    temp13-category = `Accessories`.
    temp13-quantity = 20.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `10" Portable DVD player`.
    temp13-category = `Accessories`.
    temp13-quantity = 21.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Portable DVD Player with 9" LCD Monitor`.
    temp13-category = `Accessories`.
    temp13-quantity = 50.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `CD/DVD case: 264 sleeves`.
    temp13-category = `Accessories`.
    temp13-quantity = 26.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Audio/Video Cable Kit - 4m`.
    temp13-category = `Accessories`.
    temp13-quantity = 16.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Removable CD/DVD Laser Labels`.
    temp13-category = `Accessories`.
    temp13-quantity = 25.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Beam Breaker B-1`.
    temp13-category = `Accessories`.
    temp13-quantity = 32.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Beam Breaker B-2`.
    temp13-category = `Accessories`.
    temp13-quantity = 18.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Beam Breaker B-3`.
    temp13-category = `Accessories`.
    temp13-quantity = 16.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Play Movie`.
    temp13-category = `Accessories`.
    temp13-quantity = 15.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Record Movie`.
    temp13-category = `Accessories`.
    temp13-quantity = 24.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `ITelo MusicStick`.
    temp13-category = `Accessories`.
    temp13-quantity = 15.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `ITelo Jog-Mate`.
    temp13-category = `Accessories`.
    temp13-quantity = 24.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Power Pro Player 40`.
    temp13-category = `Accessories`.
    temp13-quantity = 23.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Power Pro Player 80`.
    temp13-category = `Accessories`.
    temp13-quantity = 13.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Flat Watch HD32`.
    temp13-category = `Flat Screen TVs`.
    temp13-quantity = 16.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Flat Watch HD37`.
    temp13-category = `Flat Screen TVs`.
    temp13-quantity = 14.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Flat Watch HD41`.
    temp13-category = `Flat Screen TVs`.
    temp13-quantity = 13.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Copperberry`.
    temp13-category = `Accessories`.
    temp13-quantity = 5.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Silverberry`.
    temp13-category = `Accessories`.
    temp13-quantity = 9.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Goldberry`.
    temp13-category = `Accessories`.
    temp13-quantity = 11.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Platinberry`.
    temp13-category = `Accessories`.
    temp13-quantity = 12.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `ITelO FlexTop I4000`.
    temp13-category = `Laptops`.
    temp13-quantity = 11.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `ITelO FlexTop I6300c`.
    temp13-category = `Laptops`.
    temp13-quantity = 20.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `ITelO FlexTop I9100`.
    temp13-category = `Laptops`.
    temp13-quantity = 20.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `ITelO FlexTop I9800`.
    temp13-category = `Laptops`.
    temp13-quantity = 22.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Smartphone Leather Case`.
    temp13-category = `Accessories`.
    temp13-quantity = 12.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Smartphone Alpha`.
    temp13-category = `Smartphones and Tablets`.
    temp13-quantity = 13.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Mini Tablet`.
    temp13-category = `Smartphones and Tablets`.
    temp13-quantity = 10.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Camcorder View`.
    temp13-category = `Accessories`.
    temp13-quantity = 50.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Tablet Pouch`.
    temp13-category = `Accessories`.
    temp13-quantity = 34.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Tablet Pouch`.
    temp13-category = `Accessories`.
    temp13-quantity = 34.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `e-Book Reader ReadMe`.
    temp13-category = `Smartphones and Tablets`.
    temp13-quantity = 23.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Smartphone Beta`.
    temp13-category = `Smartphones and Tablets`.
    temp13-quantity = 21.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Maxi Tablet`.
    temp13-category = `Tablets`.
    temp13-quantity = 20.
    INSERT temp13 INTO TABLE temp12.
    temp13-name = `Flyer`.
    temp13-category = `Accessories`.
    temp13-quantity = 33.
    INSERT temp13 INTO TABLE temp12.
    t_products = temp12.

  ENDMETHOD.

ENDCLASS.
