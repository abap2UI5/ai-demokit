" @keywords table sap.ui.table dnd hbox overflowtoolbar title contextmenusetting menu menuitem column text draginfo
" @summary Shows various drag-and-drop capabilities along with custom context menu alternatives for each action.
CLASS z2ui5_cl_smpc_app_353 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name     TYPE string,
        category TYPE string,
        quantity TYPE i,
        " the row's index in the original ProductCollection. The original does not
        " need one: it keeps ONE collection and a Rank per row, table 1 binds it
        " with `filters: Rank EQ 0` and NO sorter, so a row whose Rank goes back
        " to 0 reappears exactly where it sits in ProductCollection. This port
        " carves the collection into two tables instead, which throws that order
        " away - so the position has to be carried explicitly to restore it.
        ordinal  TYPE i,
      END OF ty_s_product,
      ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

    " the original keeps ONE collection and separates the two tables by a Rank
    " filter (Rank = 0 available, Rank > 0 selected, sorted by Rank); with the
    " one default model the two tables are two tables, and their row ORDER is
    " what the Rank encoded
    DATA t_available TYPE ty_t_product.
    DATA t_selected  TYPE ty_t_product.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    " the selected row of each table, mirrored from rowSelectionChange /
    " beforeOpenContextMenu (which is what the original's setSelectedIndex in
    " onBeforeOpenContextMenu does), 1-based; 0 means nothing selected
    DATA selected_1 TYPE i.
    DATA selected_2 TYPE i.

    METHODS view_display.
    METHODS on_event.
    " re-insert a row into the available table at its ORIGINAL place, which is
    " what the original's `Rank = 0` + unsorted, filtered binding does
    METHODS available_restore
      IMPORTING row TYPE ty_s_product.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_353 IMPLEMENTATION.

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
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " the two-table move demo. Both tables bind their own model table, the two
    " arrow buttons and the context menus move the selected row across, and the
    " drag & drop wires ship the dragged / dropped row indices plus the drop
    " position so the move and the reorder happen in ABAP.
    
    CLEAR temp1.
    INSERT `${$parameters>/draggedControl}.getIndex()` INTO TABLE temp1.
    INSERT `${$parameters>/droppedControl}.getIndex()` INTO TABLE temp1.
    INSERT `${$parameters>/dropPosition}` INTO TABLE temp1.
    INSERT `${$parameters>/draggedControl}.getParent().getId().indexOf('table2') >= 0` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `${$parameters>/draggedControl}.getIndex()` INTO TABLE temp2.
    INSERT `${$parameters>/droppedControl}.getIndex()` INTO TABLE temp2.
    INSERT `${$parameters>/dropPosition}` INTO TABLE temp2.
    INSERT `${$parameters>/draggedControl}.getParent().getId().indexOf('table2') >= 0` INTO TABLE temp2.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`         v = `sap.ui.table`
        )->a( n = `xmlns:plugins` v = `sap.m.plugins`
        )->a( n = `xmlns:dnd`     v = `sap.ui.core.dnd`
        )->a( n = `xmlns:mvc`     v = `sap.ui.core.mvc`
        )->a( n = `xmlns:c`       v = `sap.ui.core`
        )->a( n = `xmlns:m`       v = `sap.m`
        )->a( n = `height`        v = `100%`

        )->ele( n = `Page` ns = `m`
            )->a( n = `showHeader`      v = `false`
            )->a( n = `enableScrolling` v = `false`
            )->a( n = `class`           v = `sapUiContentPadding`

            )->ele( n = `content` ns = `m`
                )->ele( n = `HBox` ns = `m`
                    )->a( n = `renderType` v = `Bare`

                    )->ele( `Table`
                        )->a( n = `id`                    v = `table1`
                        )->a( n = `selectionMode`         v = `Single`
                        )->a( n = `ariaLabelledBy`        v = `title`
                        )->a( n = `beforeOpenContextMenu` v = client->_event( val = `CTX_MENU_1` arg = `${$parameters>/rowIndex}` )
                        )->a( n = `rows`                  v = client->_bind( t_available )
                        )->a( n = `rowSelectionChange`    v = client->_event( val = `SELECT_1` arg = `${$parameters>/rowIndex}` )

                        )->ele( `extension`
                            )->ele( n = `OverflowToolbar` ns = `m`
                                )->a( n = `id`    v = `infobar`
                                )->a( n = `style` v = `Clear`

                                )->tag( n = `Title` ns = `m`
                                    )->a( n = `id`   v = `title`
                                    )->a( n = `text` v = `Available Products`

                            )->end(
                        )->end(
                        )->ele( `dependents`
                            )->tag( n = `ContextMenuSetting` ns = `plugins`
                                )->a( n = `scope` v = `Selection`

                        )->end(
                        )->ele( `contextMenu`
                            )->ele( n = `Menu` ns = `m`
                                )->tag( n = `MenuItem` ns = `m`
                                    )->a( n = `text`  v = `Move to Selected Products`
                                    )->a( n = `press` v = client->_event( `MOVE_TO_2` )

                            )->end(
                        )->end(
                        )->ele( `columns`
                            )->ele( `Column`
                                )->a( n = `sortProperty`   v = `NAME`
                                )->a( n = `filterProperty` v = `NAME`

                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text` v = `Product Name`

                                )->ele( `template`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text`     v = `{NAME}`
                                        )->a( n = `wrapping` v = `false`

                                )->end(
                            )->end(
                            )->ele( `Column`
                                )->a( n = `sortProperty`   v = `CATEGORY`
                                )->a( n = `filterProperty` v = `CATEGORY`

                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text` v = `Category`

                                )->ele( `template`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text`     v = `{CATEGORY}`
                                        )->a( n = `wrapping` v = `false`

                                )->end(
                            )->end(
                            )->ele( `Column`
                                )->a( n = `hAlign`       v = `End`
                                )->a( n = `width`        v = `6rem`
                                )->a( n = `sortProperty` v = `QUANTITY`

                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text` v = `Quantity`

                                )->ele( `template`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = |\{ path: 'QUANTITY', type: 'sap.ui.model.type.Integer' \}|

                                )->end(
                            )->end(
                        )->end(
                        )->ele( `dragDropConfig`
                            )->tag( n = `DragInfo` ns = `dnd`
                                )->a( n = `groupName`         v = `moveToTable2`
                                )->a( n = `sourceAggregation` v = `rows`

                            )->tag( n = `DropInfo` ns = `dnd`
                                )->a( n = `groupName` v = `moveToTable1`
                                )->a( n = `drop`      v = client->_event( val = `DROP_TO_1` arg = `${$parameters>/draggedControl}.getIndex()` )

                        )->end(
                    )->end(
                    )->ele( n = `VBox` ns = `m`
                        )->a( n = `justifyContent` v = `Center`
                        )->a( n = `class`          v = `sapUiTinyMarginBeginEnd`

                        )->tag( n = `Button` ns = `m`
                            )->a( n = `class`   v = `sapUiTinyMarginBottom`
                            )->a( n = `icon`    v = `sap-icon://navigation-right-arrow`
                            )->a( n = `tooltip` v = `Move to selected`
                            )->a( n = `press`   v = client->_event( `MOVE_TO_2` )

                        )->tag( n = `Button` ns = `m`
                            )->a( n = `icon`    v = `sap-icon://navigation-left-arrow`
                            )->a( n = `tooltip` v = `Move to available`
                            )->a( n = `press`   v = client->_event( `MOVE_TO_1` )

                    )->end(
                    )->ele( `Table`
                        )->a( n = `id`                    v = `table2`
                        )->a( n = `selectionMode`         v = `Single`
                        )->a( n = `ariaLabelledBy`        v = `title2`
                        )->a( n = `beforeOpenContextMenu` v = client->_event( val = `CTX_MENU_2` arg = `${$parameters>/rowIndex}` )
                        )->a( n = `rows`                  v = client->_bind( t_selected )
                        )->a( n = `rowSelectionChange`    v = client->_event( val = `SELECT_2` arg = `${$parameters>/rowIndex}` )
                        )->a( n = `noData`                v = `Please drag-and-drop products here.`

                        )->ele( `dependents`
                            )->tag( n = `ContextMenuSetting` ns = `plugins`
                                )->a( n = `scope` v = `Selection`

                        )->end(
                        )->ele( `contextMenu`
                            )->ele( n = `Menu` ns = `m`
                                )->tag( n = `MenuItem` ns = `m`
                                    )->a( n = `text`  v = `Move to Available Products`
                                    )->a( n = `press` v = client->_event( `MOVE_TO_1` )

                                )->tag( n = `MenuItem` ns = `m`
                                    )->a( n = `text`  v = `Move up`
                                    )->a( n = `press` v = client->_event( `MOVE_UP` )

                                )->tag( n = `MenuItem` ns = `m`
                                    )->a( n = `text`  v = `Move down`
                                    )->a( n = `press` v = client->_event( `MOVE_DOWN` )

                            )->end(
                        )->end(
                        )->ele( `extension`
                            )->ele( n = `OverflowToolbar` ns = `m`
                                )->a( n = `style` v = `Clear`

                                )->tag( n = `Title` ns = `m`
                                    )->a( n = `id`   v = `title2`
                                    )->a( n = `text` v = `Selected Products`

                                )->tag( n = `ToolbarSpacer` ns = `m`

                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `icon`    v = `sap-icon://navigation-up-arrow`
                                    )->a( n = `tooltip` v = `Move up`
                                    )->a( n = `press`   v = client->_event( `MOVE_UP` )

                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `icon`    v = `sap-icon://navigation-down-arrow`
                                    )->a( n = `tooltip` v = `Move down`
                                    )->a( n = `press`   v = client->_event( `MOVE_DOWN` )

                            )->end(
                        )->end(
                        )->ele( `columns`
                            )->ele( `Column`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text` v = `Product Name`

                                )->ele( `template`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text`     v = `{NAME}`
                                        )->a( n = `wrapping` v = `false`

                                )->end(
                            )->end(
                            )->ele( `Column`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text` v = `Category`

                                )->ele( `template`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text`     v = `{CATEGORY}`
                                        )->a( n = `wrapping` v = `false`

                                )->end(
                            )->end(
                            )->ele( `Column`
                                )->a( n = `hAlign` v = `End`
                                )->a( n = `width`  v = `6rem`

                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text` v = `Quantity`

                                )->ele( `template`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = |\{ path: 'QUANTITY', type: 'sap.ui.model.type.Integer' \}|

                                )->end(
                            )->end(
                        )->end(
                        )->ele( `dragDropConfig`
                            )->tag( n = `DragInfo` ns = `dnd`
                                )->a( n = `groupName`         v = `moveToTable1`
                                )->a( n = `sourceAggregation` v = `rows`

                            )->tag( n = `DropInfo` ns = `dnd`
                                )->a( n = `groupName`         v = `moveToTable2`
                                )->a( n = `targetAggregation` v = `rows`
                                )->a( n = `dropPosition`      v = `Between`
                                )->a( n = `drop`              v = client->_event( val   = `DROP_TO_2`
                                                                                  t_arg = temp1 )

                            )->tag( n = `DragDropInfo` ns = `dnd`
                                )->a( n = `sourceAggregation` v = `rows`
                                )->a( n = `targetAggregation` v = `rows`
                                )->a( n = `dropPosition`      v = `Between`
                                )->a( n = `drop`              v = client->_event( val   = `DROP_TO_2`
                                                                                  t_arg = temp2 )

                        )->end(
                    )->end(
                )->end(
            )->end(
        )->end(
    )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA temp3 TYPE i.
        DATA temp4 TYPE i.
        DATA temp5 TYPE i.
        DATA temp6 TYPE i.
          DATA temp7 LIKE LINE OF t_available.
          DATA temp8 LIKE sy-tabix.
          DATA temp9 LIKE LINE OF t_selected.
          DATA temp10 LIKE sy-tabix.
          DATA ls_row LIKE LINE OF t_selected.
          DATA temp22 LIKE LINE OF t_selected.
          DATA temp23 LIKE sy-tabix.
          DATA temp11 LIKE LINE OF t_selected.
          DATA temp12 LIKE sy-tabix.
        DATA temp13 TYPE i.
        DATA lv_from TYPE i.
          DATA temp14 LIKE LINE OF t_selected.
          DATA temp15 LIKE sy-tabix.
        DATA temp16 TYPE i.
        DATA temp17 TYPE i.
        DATA lv_to TYPE i.
        DATA lv_after TYPE abap_bool.
        DATA temp1 TYPE xsdboolean.
        DATA lv_internal TYPE string.
          DATA temp18 LIKE LINE OF t_selected.
          DATA temp19 LIKE sy-tabix.
          DATA temp20 LIKE LINE OF t_available.
          DATA temp21 LIKE sy-tabix.

    CASE client->get_event( ).

      WHEN `SELECT_1`.
        
        temp3 = client->get_event_arg( ).
        selected_1 = temp3 + 1.

      WHEN `CTX_MENU_1`.
        " onBeforeOpenContextMenu selects the row under the cursor
        
        temp4 = client->get_event_arg( ).
        selected_1 = temp4 + 1.

      WHEN `SELECT_2`.
        
        temp5 = client->get_event_arg( ).
        selected_2 = temp5 + 1.

      WHEN `CTX_MENU_2`.
        
        temp6 = client->get_event_arg( ).
        selected_2 = temp6 + 1.

      WHEN `MOVE_TO_2`.
        " moveToTable2: the selected available product becomes a selected one
        IF selected_1 < 1 OR selected_1 > lines( t_available ).
          client->message_toast_display( `Please select a row!` ).
        ELSE.
          " "insert always as a first row" - the original gives the row a Rank
          " Before( ) the current first one and table 2 is sorted descending by
          " Rank, so it lands at the TOP. INSERT ... INTO TABLE on a STANDARD
          " TABLE WITH EMPTY KEY appends, which put it at the bottom instead.
          
          
          temp8 = sy-tabix.
          READ TABLE t_available INDEX selected_1 INTO temp7.
          sy-tabix = temp8.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          INSERT temp7 INTO t_selected INDEX 1.
          DELETE t_available INDEX selected_1.
          selected_1 = 0.
        ENDIF.

      WHEN `MOVE_TO_1`.
        " moveToTable1: back to the available products (the original resets the
        " row's Rank, which is the same thing with one collection)
        IF selected_2 < 1 OR selected_2 > lines( t_selected ).
          client->message_toast_display( `Please select a row!` ).
        ELSE.
          
          
          temp10 = sy-tabix.
          READ TABLE t_selected INDEX selected_2 INTO temp9.
          sy-tabix = temp10.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          available_restore( temp9 ).
          DELETE t_selected INDEX selected_2.
          selected_2 = 0.
        ENDIF.

      WHEN `MOVE_UP`.
        IF selected_2 > 1 AND selected_2 <= lines( t_selected ).
          
          
          
          temp23 = sy-tabix.
          READ TABLE t_selected INDEX selected_2 INTO temp22.
          sy-tabix = temp23.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          ls_row = temp22.
          DELETE t_selected INDEX selected_2.
          INSERT ls_row INTO t_selected INDEX selected_2 - 1.
          selected_2 = selected_2 - 1.
        ENDIF.

      WHEN `MOVE_DOWN`.
        IF selected_2 >= 1 AND selected_2 < lines( t_selected ).
          
          
          temp12 = sy-tabix.
          READ TABLE t_selected INDEX selected_2 INTO temp11.
          sy-tabix = temp12.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          ls_row = temp11.
          DELETE t_selected INDEX selected_2.
          INSERT ls_row INTO t_selected INDEX selected_2 + 1.
          selected_2 = selected_2 + 1.
        ENDIF.

      WHEN `DROP_TO_1`.
        " onDropTable1: whatever was dragged out of the selected table goes
        " back to the available one
        
        temp13 = client->get_event_arg( ).
        
        lv_from = temp13 + 1.
        IF lv_from >= 1 AND lv_from <= lines( t_selected ).
          
          
          temp15 = sy-tabix.
          READ TABLE t_selected INDEX lv_from INTO temp14.
          sy-tabix = temp15.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          available_restore( temp14 ).
          DELETE t_selected INDEX lv_from.
        ENDIF.

      WHEN `DROP_TO_2`.
        " onDropTable2: insert Before or After the dropped row - the original
        " computes a Rank between the two neighbours, which with an ordered
        " table is simply the insert index. The fourth argument says whether
        " the drag started INSIDE table 2 (a reorder) or came from table 1
        
        temp16 = client->get_event_arg( ).
        lv_from = temp16 + 1.
        
        temp17 = client->get_event_arg( 2 ).
        
        lv_to = temp17 + 1.
        
        
        temp1 = boolc( client->get_event_arg( 3 ) = `After` ).
        lv_after = temp1.
        
        lv_internal = client->get_event_arg( 4 ).

        IF lv_internal = abap_true.
          IF lv_from < 1 OR lv_from > lines( t_selected ).
            RETURN.
          ENDIF.
          
          
          temp19 = sy-tabix.
          READ TABLE t_selected INDEX lv_from INTO temp18.
          sy-tabix = temp19.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          ls_row = temp18.
          DELETE t_selected INDEX lv_from.
          IF lv_from < lv_to.
            lv_to = lv_to - 1.
          ENDIF.
        ELSE.
          IF lv_from < 1 OR lv_from > lines( t_available ).
            RETURN.
          ENDIF.
          
          
          temp21 = sy-tabix.
          READ TABLE t_available INDEX lv_from INTO temp20.
          sy-tabix = temp21.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          ls_row = temp20.
          DELETE t_available INDEX lv_from.
        ENDIF.

        IF lv_after = abap_true.
          lv_to = lv_to + 1.
        ENDIF.
        IF lv_to < 1.
          lv_to = 1.
        ENDIF.
        IF lv_to > lines( t_selected ) + 1.
          lv_to = lines( t_selected ) + 1.
        ENDIF.
        INSERT ls_row INTO t_selected INDEX lv_to.

    ENDCASE.


  ENDMETHOD.


  METHOD available_restore.

    " the first row that belongs AFTER this one is the insert point; if there is
    " none the row goes last, which is the same rule as ProductCollection order
    LOOP AT t_available TRANSPORTING NO FIELDS WHERE ordinal > row-ordinal.
      INSERT row INTO t_available INDEX sy-tabix.
      RETURN.
    ENDLOOP.

    APPEND row TO t_available.

  ENDMETHOD.


  METHOD model_init.

    " the shared 123-row demo ProductCollection (sap/ui/demo/mock/products.json)
    " with the three columns both tables bind; every product starts in the
    " available table, which is what the original's initialRank = 0 means
    DATA temp22 TYPE z2ui5_cl_smpc_app_353=>ty_t_product.
    DATA temp23 LIKE LINE OF temp22.
    FIELD-SYMBOLS <seed> LIKE LINE OF t_available.
    CLEAR temp22.
    
    temp23-name = `Notebook Basic 15`.
    temp23-category = `Laptops`.
    temp23-quantity = 10.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Notebook Basic 17`.
    temp23-category = `Laptops`.
    temp23-quantity = 20.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Notebook Basic 18`.
    temp23-category = `Laptops`.
    temp23-quantity = 10.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Notebook Basic 19`.
    temp23-category = `Laptops`.
    temp23-quantity = 15.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `ITelO Vault`.
    temp23-category = `Accessories`.
    temp23-quantity = 15.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Notebook Professional 15`.
    temp23-category = `Accessories`.
    temp23-quantity = 16.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Notebook Professional 17`.
    temp23-category = `Laptops`.
    temp23-quantity = 17.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `ITelO Vault Net`.
    temp23-category = `Accessories`.
    temp23-quantity = 14.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `ITelO Vault SAT`.
    temp23-category = `Accessories`.
    temp23-quantity = 50.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Comfort Easy`.
    temp23-category = `Accessories`.
    temp23-quantity = 30.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Comfort Senior`.
    temp23-category = `Accessories`.
    temp23-quantity = 24.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Ergo Screen E-I`.
    temp23-category = `Flat Screen Monitors`.
    temp23-quantity = 14.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Ergo Screen E-II`.
    temp23-category = `Flat Screen Monitors`.
    temp23-quantity = 24.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Ergo Screen E-III`.
    temp23-category = `Flat Screen Monitors`.
    temp23-quantity = 50.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Flat Basic`.
    temp23-category = `Flat Screen Monitors`.
    temp23-quantity = 23.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Flat Future`.
    temp23-category = `Flat Screen Monitors`.
    temp23-quantity = 22.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Flat XL`.
    temp23-category = `Flat Screen Monitors`.
    temp23-quantity = 23.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Laser Professional Eco`.
    temp23-category = `Printers`.
    temp23-quantity = 21.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Laser Basic`.
    temp23-category = `Printers`.
    temp23-quantity = 8.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Laser Allround`.
    temp23-category = `Printers`.
    temp23-quantity = 9.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Ultra Jet Super Color`.
    temp23-category = `Printers`.
    temp23-quantity = 17.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Ultra Jet Mobile`.
    temp23-category = `Printers`.
    temp23-quantity = 18.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Ultra Jet Super Highspeed`.
    temp23-category = `Printers`.
    temp23-quantity = 25.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Multi Print`.
    temp23-category = `Multifunction Printers`.
    temp23-quantity = 16.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Multi Color`.
    temp23-category = `Multifunction Printers`.
    temp23-quantity = 5.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Cordless Mouse`.
    temp23-category = `Mice`.
    temp23-quantity = 25.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Speed Mouse`.
    temp23-category = `Mice`.
    temp23-quantity = 12.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Track Mouse`.
    temp23-category = `Mice`.
    temp23-quantity = 12.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Ergonomic Keyboard`.
    temp23-category = `Keyboards`.
    temp23-quantity = 50.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Internet Keyboard`.
    temp23-category = `Keyboards`.
    temp23-quantity = 35.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Media Keyboard`.
    temp23-category = `Keyboards`.
    temp23-quantity = 26.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Mousepad`.
    temp23-category = `Mousepads`.
    temp23-quantity = 12.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Ergo Mousepad`.
    temp23-category = `Mousepads`.
    temp23-quantity = 16.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Designer Mousepad`.
    temp23-category = `Mousepads`.
    temp23-quantity = 26.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Universal card reader`.
    temp23-category = `Computer System Accessories`.
    temp23-quantity = 22.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Proctra X`.
    temp23-category = `Graphic Cards`.
    temp23-quantity = 15.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Gladiator MX`.
    temp23-category = `Graphic Cards`.
    temp23-quantity = 16.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Hurricane GX`.
    temp23-category = `Graphic Cards`.
    temp23-quantity = 13.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Hurricane GX/LN`.
    temp23-category = `Graphic Cards`.
    temp23-quantity = 5.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Photo Scan`.
    temp23-category = `Scanners`.
    temp23-quantity = 8.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Power Scan`.
    temp23-category = `Scanners`.
    temp23-quantity = 11.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Jet Scan Professional`.
    temp23-category = `Scanners`.
    temp23-quantity = 13.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Jet Scan Professional`.
    temp23-category = `Scanners`.
    temp23-quantity = 10.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Copymaster`.
    temp23-category = `Multifunction Printers`.
    temp23-quantity = 10.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Surround Sound`.
    temp23-category = `Speakers`.
    temp23-quantity = 20.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Blaster Extreme`.
    temp23-category = `Speakers`.
    temp23-quantity = 15.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Sound Booster`.
    temp23-category = `Speakers`.
    temp23-quantity = 50.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Lovely Sound 5.1 Wireless`.
    temp23-category = `Accessories`.
    temp23-quantity = 12.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Lovely Sound 5.1`.
    temp23-category = `Accessories`.
    temp23-quantity = 18.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Lovely Sound Stereo`.
    temp23-category = `Accessories`.
    temp23-quantity = 21.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Smart Office`.
    temp23-category = `Software`.
    temp23-quantity = 25.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Smart Design`.
    temp23-category = `Software`.
    temp23-quantity = 26.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Smart Network`.
    temp23-category = `Software`.
    temp23-quantity = 28.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Smart Multimedia`.
    temp23-category = `Software`.
    temp23-quantity = 9.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Smart Games`.
    temp23-category = `Software`.
    temp23-quantity = 13.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Smart Internet Antivirus`.
    temp23-category = `Software`.
    temp23-quantity = 17.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Smart Firewall`.
    temp23-category = `Software`.
    temp23-quantity = 19.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Smart Money`.
    temp23-category = `Software`.
    temp23-quantity = 18.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `PC Lock`.
    temp23-category = `Computer System Accessories`.
    temp23-quantity = 14.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Notebook Lock`.
    temp23-category = `Computer System Accessories`.
    temp23-quantity = 20.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Web cam reality`.
    temp23-category = `Computer System Accessories`.
    temp23-quantity = 27.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Screen clean`.
    temp23-category = `Computer System Accessories`.
    temp23-quantity = 17.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Fabric bag professional`.
    temp23-category = `Computer System Accessories`.
    temp23-quantity = 14.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Wireless DSL Router`.
    temp23-category = `Telecommunications`.
    temp23-quantity = 16.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Wireless DSL Router / Repeater`.
    temp23-category = `Telecommunications`.
    temp23-quantity = 12.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Wireless DSL Router / Repeater and Print Server`.
    temp23-category = `Telecommunications`.
    temp23-quantity = 12.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `USB Stick`.
    temp23-category = `Computer System Accessories`.
    temp23-quantity = 14.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Travel Adapter`.
    temp23-category = `Accessories`.
    temp23-quantity = 10.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Cordless Bluetooth Keyboard, english international`.
    temp23-category = `Keyboards`.
    temp23-quantity = 13.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Flat XXL`.
    temp23-category = `Flat Screen Monitors`.
    temp23-quantity = 10.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Pocket Mouse`.
    temp23-category = `Mice`.
    temp23-quantity = 20.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `PC Power Station`.
    temp23-category = `PCs`.
    temp23-quantity = 22.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Astro Laptop 1516`.
    temp23-category = `Laptops`.
    temp23-quantity = 23.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Astro Phone 6`.
    temp23-category = `Smartphones and Tablets`.
    temp23-quantity = 28.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Benda Laptop 1408`.
    temp23-category = `Laptops`.
    temp23-quantity = 27.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Bending Screen 21HD`.
    temp23-category = `Flat Screens`.
    temp23-quantity = 23.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Broad Screen 22HD`.
    temp23-category = `Flat Screens`.
    temp23-quantity = 5.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Cerdik Phone 7`.
    temp23-category = `Smartphones and Tablets`.
    temp23-quantity = 19.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Cepat Tablet 10.5`.
    temp23-category = `Smartphones and Tablets`.
    temp23-quantity = 17.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Cepat Tablet 8`.
    temp23-category = `Smartphones and Tablets`.
    temp23-quantity = 24.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Server Basic`.
    temp23-category = `Servers`.
    temp23-quantity = 24.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Server Professional`.
    temp23-category = `Servers`.
    temp23-quantity = 26.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Server Power Pro`.
    temp23-category = `Servers`.
    temp23-quantity = 34.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Family PC Basic`.
    temp23-category = `Desktop Computers`.
    temp23-quantity = 10.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Family PC Pro`.
    temp23-category = `Desktop Computers`.
    temp23-quantity = 20.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Gaming Monster`.
    temp23-category = `Desktop Computers`.
    temp23-quantity = 24.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Gaming Monster Pro`.
    temp23-category = `Desktop Computers`.
    temp23-quantity = 25.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `7" Widescreen Portable DVD Player w MP3`.
    temp23-category = `Accessories`.
    temp23-quantity = 20.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `10" Portable DVD player`.
    temp23-category = `Accessories`.
    temp23-quantity = 21.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Portable DVD Player with 9" LCD Monitor`.
    temp23-category = `Accessories`.
    temp23-quantity = 50.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `CD/DVD case: 264 sleeves`.
    temp23-category = `Accessories`.
    temp23-quantity = 26.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Audio/Video Cable Kit - 4m`.
    temp23-category = `Accessories`.
    temp23-quantity = 16.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Removable CD/DVD Laser Labels`.
    temp23-category = `Accessories`.
    temp23-quantity = 25.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Beam Breaker B-1`.
    temp23-category = `Accessories`.
    temp23-quantity = 32.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Beam Breaker B-2`.
    temp23-category = `Accessories`.
    temp23-quantity = 18.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Beam Breaker B-3`.
    temp23-category = `Accessories`.
    temp23-quantity = 16.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Play Movie`.
    temp23-category = `Accessories`.
    temp23-quantity = 15.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Record Movie`.
    temp23-category = `Accessories`.
    temp23-quantity = 24.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `ITelo MusicStick`.
    temp23-category = `Accessories`.
    temp23-quantity = 15.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `ITelo Jog-Mate`.
    temp23-category = `Accessories`.
    temp23-quantity = 24.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Power Pro Player 40`.
    temp23-category = `Accessories`.
    temp23-quantity = 23.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Power Pro Player 80`.
    temp23-category = `Accessories`.
    temp23-quantity = 13.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Flat Watch HD32`.
    temp23-category = `Flat Screen TVs`.
    temp23-quantity = 16.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Flat Watch HD37`.
    temp23-category = `Flat Screen TVs`.
    temp23-quantity = 14.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Flat Watch HD41`.
    temp23-category = `Flat Screen TVs`.
    temp23-quantity = 13.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Copperberry`.
    temp23-category = `Accessories`.
    temp23-quantity = 5.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Silverberry`.
    temp23-category = `Accessories`.
    temp23-quantity = 9.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Goldberry`.
    temp23-category = `Accessories`.
    temp23-quantity = 11.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Platinberry`.
    temp23-category = `Accessories`.
    temp23-quantity = 12.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `ITelO FlexTop I4000`.
    temp23-category = `Laptops`.
    temp23-quantity = 11.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `ITelO FlexTop I6300c`.
    temp23-category = `Laptops`.
    temp23-quantity = 20.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `ITelO FlexTop I9100`.
    temp23-category = `Laptops`.
    temp23-quantity = 20.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `ITelO FlexTop I9800`.
    temp23-category = `Laptops`.
    temp23-quantity = 22.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Smartphone Leather Case`.
    temp23-category = `Accessories`.
    temp23-quantity = 12.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Smartphone Alpha`.
    temp23-category = `Smartphones and Tablets`.
    temp23-quantity = 13.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Mini Tablet`.
    temp23-category = `Smartphones and Tablets`.
    temp23-quantity = 10.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Camcorder View`.
    temp23-category = `Accessories`.
    temp23-quantity = 50.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Tablet Pouch`.
    temp23-category = `Accessories`.
    temp23-quantity = 34.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Tablet Pouch`.
    temp23-category = `Accessories`.
    temp23-quantity = 34.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `e-Book Reader ReadMe`.
    temp23-category = `Smartphones and Tablets`.
    temp23-quantity = 23.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Smartphone Beta`.
    temp23-category = `Smartphones and Tablets`.
    temp23-quantity = 21.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Maxi Tablet`.
    temp23-category = `Tablets`.
    temp23-quantity = 20.
    INSERT temp23 INTO TABLE temp22.
    temp23-name = `Flyer`.
    temp23-category = `Accessories`.
    temp23-quantity = 33.
    INSERT temp23 INTO TABLE temp22.
    t_available = temp22.

    " stamped after the literals rather than written into them, so the seeded
    " values stay exactly the mock's
    
    LOOP AT t_available ASSIGNING <seed>.
      <seed>-ordinal = sy-tabix.
    ENDLOOP.

  ENDMETHOD.


ENDCLASS.
