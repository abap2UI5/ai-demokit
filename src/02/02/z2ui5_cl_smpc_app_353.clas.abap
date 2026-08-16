" @keywords table sap.ui.table dnd column
" @summary Shows various drag-and-drop capabilities along with custom context menu alternatives for each action.
CLASS z2ui5_cl_smpc_app_353 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name     TYPE string,
        category TYPE string,
        quantity TYPE i,
      END OF ty_s_product,
      ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

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
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_353 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " the two-table move demo. Both tables bind their own model table, the two
    " arrow buttons and the context menus move the selected row across, and the
    " drag & drop wires ship the dragged / dropped row indices plus the drop
    " position so the move and the reorder happen in ABAP.
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
                        )->a( n = `beforeOpenContextMenu` v = client->_event( val   = `CTX_MENU_1`
                                                                              t_arg = VALUE #( ( `${$parameters>/rowIndex}` ) ) )
                        )->a( n = `rows`                  v = client->_bind( t_available )
                        )->a( n = `rowSelectionChange`    v = client->_event( val   = `SELECT_1`
                                                                              t_arg = VALUE #( ( `${$parameters>/rowIndex}` ) ) )

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
                                )->a( n = `sortProperty`   v = `Name`
                                )->a( n = `filterProperty` v = `Name`

                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text` v = `Product Name`

                                )->ele( `template`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text`     v = `{NAME}`
                                        )->a( n = `wrapping` v = `false`

                                )->end(
                            )->end(
                            )->ele( `Column`
                                )->a( n = `sortProperty`   v = `Category`
                                )->a( n = `filterProperty` v = `Category`

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
                                )->a( n = `sortProperty` v = `Quantity`

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
                                )->a( n = `drop`      v = client->_event( val   = `DROP_TO_1`
                                                                          t_arg = VALUE #( ( `${$parameters>/draggedControl}.getIndex()` ) ) )

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
                        )->a( n = `beforeOpenContextMenu` v = client->_event( val   = `CTX_MENU_2`
                                                                              t_arg = VALUE #( ( `${$parameters>/rowIndex}` ) ) )
                        )->a( n = `rows`                  v = client->_bind( t_selected )
                        )->a( n = `rowSelectionChange`    v = client->_event( val   = `SELECT_2`
                                                                              t_arg = VALUE #( ( `${$parameters>/rowIndex}` ) ) )
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
                                                                                  t_arg = VALUE #( ( `${$parameters>/draggedControl}.getIndex()` )
                                                                             ( `${$parameters>/droppedControl}.getIndex()` )
                                                                             ( `${$parameters>/dropPosition}` )
                                                                             ( `${$parameters>/draggedControl}.getParent().getId().indexOf('table2') >= 0` ) ) )

                            )->tag( n = `DragDropInfo` ns = `dnd`
                                )->a( n = `sourceAggregation` v = `rows`
                                )->a( n = `targetAggregation` v = `rows`
                                )->a( n = `dropPosition`      v = `Between`
                                )->a( n = `drop`              v = client->_event( val   = `DROP_TO_2`
                                                                                  t_arg = VALUE #( ( `${$parameters>/draggedControl}.getIndex()` )
                                                                             ( `${$parameters>/droppedControl}.getIndex()` )
                                                                             ( `${$parameters>/dropPosition}` )
                                                                             ( `${$parameters>/draggedControl}.getParent().getId().indexOf('table2') >= 0` ) ) )

                        )->end(
                    )->end(
                )->end(
            )->end(
        )->end(
    )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `SELECT_1`.
        selected_1 = CONV i( client->get_event_arg( ) ) + 1.

      WHEN `CTX_MENU_1`.
        " onBeforeOpenContextMenu selects the row under the cursor
        selected_1 = CONV i( client->get_event_arg( ) ) + 1.

      WHEN `SELECT_2`.
        selected_2 = CONV i( client->get_event_arg( ) ) + 1.

      WHEN `CTX_MENU_2`.
        selected_2 = CONV i( client->get_event_arg( ) ) + 1.

      WHEN `MOVE_TO_2`.
        " moveToTable2: the selected available product becomes a selected one
        IF selected_1 < 1 OR selected_1 > lines( t_available ).
          client->message_toast_display( `Please select a row!` ).
        ELSE.
          INSERT t_available[ selected_1 ] INTO TABLE t_selected.
          DELETE t_available INDEX selected_1.
          selected_1 = 0.
        ENDIF.

      WHEN `MOVE_TO_1`.
        " moveToTable1: back to the available products (the original resets the
        " row's Rank, which is the same thing with one collection)
        IF selected_2 < 1 OR selected_2 > lines( t_selected ).
          client->message_toast_display( `Please select a row!` ).
        ELSE.
          INSERT t_selected[ selected_2 ] INTO TABLE t_available.
          DELETE t_selected INDEX selected_2.
          selected_2 = 0.
        ENDIF.

      WHEN `MOVE_UP`.
        IF selected_2 > 1 AND selected_2 <= lines( t_selected ).
          DATA(ls_row) = t_selected[ selected_2 ].
          DELETE t_selected INDEX selected_2.
          INSERT ls_row INTO t_selected INDEX selected_2 - 1.
          selected_2 = selected_2 - 1.
        ENDIF.

      WHEN `MOVE_DOWN`.
        IF selected_2 >= 1 AND selected_2 < lines( t_selected ).
          ls_row = t_selected[ selected_2 ].
          DELETE t_selected INDEX selected_2.
          INSERT ls_row INTO t_selected INDEX selected_2 + 1.
          selected_2 = selected_2 + 1.
        ENDIF.

      WHEN `DROP_TO_1`.
        " onDropTable1: whatever was dragged out of the selected table goes
        " back to the available one
        DATA(lv_from) = CONV i( client->get_event_arg( ) ) + 1.
        IF lv_from >= 1 AND lv_from <= lines( t_selected ).
          INSERT t_selected[ lv_from ] INTO TABLE t_available.
          DELETE t_selected INDEX lv_from.
        ENDIF.

      WHEN `DROP_TO_2`.
        " onDropTable2: insert Before or After the dropped row - the original
        " computes a Rank between the two neighbours, which with an ordered
        " table is simply the insert index. The fourth argument says whether
        " the drag started INSIDE table 2 (a reorder) or came from table 1
        lv_from = CONV i( client->get_event_arg( ) ) + 1.
        DATA(lv_to) = CONV i( client->get_event_arg( 2 ) ) + 1.
        DATA(lv_after) = xsdbool( client->get_event_arg( 3 ) = `After` ).
        DATA(lv_internal) = client->get_event_arg( 4 ).

        IF lv_internal = abap_true.
          IF lv_from < 1 OR lv_from > lines( t_selected ).
            RETURN.
          ENDIF.
          ls_row = t_selected[ lv_from ].
          DELETE t_selected INDEX lv_from.
          IF lv_from < lv_to.
            lv_to = lv_to - 1.
          ENDIF.
        ELSE.
          IF lv_from < 1 OR lv_from > lines( t_available ).
            RETURN.
          ENDIF.
          ls_row = t_available[ lv_from ].
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


  METHOD model_init.

    " the shared 123-row demo ProductCollection (sap/ui/demo/mock/products.json)
    " with the three columns both tables bind; every product starts in the
    " available table, which is what the original's initialRank = 0 means
    t_available = VALUE #(
      ( name = `Notebook Basic 15` category = `Laptops` quantity = 10 )
      ( name = `Notebook Basic 17` category = `Laptops` quantity = 20 )
      ( name = `Notebook Basic 18` category = `Laptops` quantity = 10 )
      ( name = `Notebook Basic 19` category = `Laptops` quantity = 15 )
      ( name = `ITelO Vault` category = `Accessories` quantity = 15 )
      ( name = `Notebook Professional 15` category = `Accessories` quantity = 16 )
      ( name = `Notebook Professional 17` category = `Laptops` quantity = 17 )
      ( name = `ITelO Vault Net` category = `Accessories` quantity = 14 )
      ( name = `ITelO Vault SAT` category = `Accessories` quantity = 50 )
      ( name = `Comfort Easy` category = `Accessories` quantity = 30 )
      ( name = `Comfort Senior` category = `Accessories` quantity = 24 )
      ( name = `Ergo Screen E-I` category = `Flat Screen Monitors` quantity = 14 )
      ( name = `Ergo Screen E-II` category = `Flat Screen Monitors` quantity = 24 )
      ( name = `Ergo Screen E-III` category = `Flat Screen Monitors` quantity = 50 )
      ( name = `Flat Basic` category = `Flat Screen Monitors` quantity = 23 )
      ( name = `Flat Future` category = `Flat Screen Monitors` quantity = 22 )
      ( name = `Flat XL` category = `Flat Screen Monitors` quantity = 23 )
      ( name = `Laser Professional Eco` category = `Printers` quantity = 21 )
      ( name = `Laser Basic` category = `Printers` quantity = 8 )
      ( name = `Laser Allround` category = `Printers` quantity = 9 )
      ( name = `Ultra Jet Super Color` category = `Printers` quantity = 17 )
      ( name = `Ultra Jet Mobile` category = `Printers` quantity = 18 )
      ( name = `Ultra Jet Super Highspeed` category = `Printers` quantity = 25 )
      ( name = `Multi Print` category = `Multifunction Printers` quantity = 16 )
      ( name = `Multi Color` category = `Multifunction Printers` quantity = 5 )
      ( name = `Cordless Mouse` category = `Mice` quantity = 25 )
      ( name = `Speed Mouse` category = `Mice` quantity = 12 )
      ( name = `Track Mouse` category = `Mice` quantity = 12 )
      ( name = `Ergonomic Keyboard` category = `Keyboards` quantity = 50 )
      ( name = `Internet Keyboard` category = `Keyboards` quantity = 35 )
      ( name = `Media Keyboard` category = `Keyboards` quantity = 26 )
      ( name = `Mousepad` category = `Mousepads` quantity = 12 )
      ( name = `Ergo Mousepad` category = `Mousepads` quantity = 16 )
      ( name = `Designer Mousepad` category = `Mousepads` quantity = 26 )
      ( name = `Universal card reader` category = `Computer System Accessories` quantity = 22 )
      ( name = `Proctra X` category = `Graphic Cards` quantity = 15 )
      ( name = `Gladiator MX` category = `Graphic Cards` quantity = 16 )
      ( name = `Hurricane GX` category = `Graphic Cards` quantity = 13 )
      ( name = `Hurricane GX/LN` category = `Graphic Cards` quantity = 5 )
      ( name = `Photo Scan` category = `Scanners` quantity = 8 )
      ( name = `Power Scan` category = `Scanners` quantity = 11 )
      ( name = `Jet Scan Professional` category = `Scanners` quantity = 13 )
      ( name = `Jet Scan Professional` category = `Scanners` quantity = 10 )
      ( name = `Copymaster` category = `Multifunction Printers` quantity = 10 )
      ( name = `Surround Sound` category = `Speakers` quantity = 20 )
      ( name = `Blaster Extreme` category = `Speakers` quantity = 15 )
      ( name = `Sound Booster` category = `Speakers` quantity = 50 )
      ( name = `Lovely Sound 5.1 Wireless` category = `Accessories` quantity = 12 )
      ( name = `Lovely Sound 5.1` category = `Accessories` quantity = 18 )
      ( name = `Lovely Sound Stereo` category = `Accessories` quantity = 21 )
      ( name = `Smart Office` category = `Software` quantity = 25 )
      ( name = `Smart Design` category = `Software` quantity = 26 )
      ( name = `Smart Network` category = `Software` quantity = 28 )
      ( name = `Smart Multimedia` category = `Software` quantity = 9 )
      ( name = `Smart Games` category = `Software` quantity = 13 )
      ( name = `Smart Internet Antivirus` category = `Software` quantity = 17 )
      ( name = `Smart Firewall` category = `Software` quantity = 19 )
      ( name = `Smart Money` category = `Software` quantity = 18 )
      ( name = `PC Lock` category = `Computer System Accessories` quantity = 14 )
      ( name = `Notebook Lock` category = `Computer System Accessories` quantity = 20 )
      ( name = `Web cam reality` category = `Computer System Accessories` quantity = 27 )
      ( name = `Screen clean` category = `Computer System Accessories` quantity = 17 )
      ( name = `Fabric bag professional` category = `Computer System Accessories` quantity = 14 )
      ( name = `Wireless DSL Router` category = `Telecommunications` quantity = 16 )
      ( name = `Wireless DSL Router / Repeater` category = `Telecommunications` quantity = 12 )
      ( name = `Wireless DSL Router / Repeater and Print Server` category = `Telecommunications` quantity = 12 )
      ( name = `USB Stick` category = `Computer System Accessories` quantity = 14 )
      ( name = `Travel Adapter` category = `Accessories` quantity = 10 )
      ( name = `Cordless Bluetooth Keyboard, english international` category = `Keyboards` quantity = 13 )
      ( name = `Flat XXL` category = `Flat Screen Monitors` quantity = 10 )
      ( name = `Pocket Mouse` category = `Mice` quantity = 20 )
      ( name = `PC Power Station` category = `PCs` quantity = 22 )
      ( name = `Astro Laptop 1516` category = `Laptops` quantity = 23 )
      ( name = `Astro Phone 6` category = `Smartphones and Tablets` quantity = 28 )
      ( name = `Benda Laptop 1408` category = `Laptops` quantity = 27 )
      ( name = `Bending Screen 21HD` category = `Flat Screens` quantity = 23 )
      ( name = `Broad Screen 22HD` category = `Flat Screens` quantity = 5 )
      ( name = `Cerdik Phone 7` category = `Smartphones and Tablets` quantity = 19 )
      ( name = `Cepat Tablet 10.5` category = `Smartphones and Tablets` quantity = 17 )
      ( name = `Cepat Tablet 8` category = `Smartphones and Tablets` quantity = 24 )
      ( name = `Server Basic` category = `Servers` quantity = 24 )
      ( name = `Server Professional` category = `Servers` quantity = 26 )
      ( name = `Server Power Pro` category = `Servers` quantity = 34 )
      ( name = `Family PC Basic` category = `Desktop Computers` quantity = 10 )
      ( name = `Family PC Pro` category = `Desktop Computers` quantity = 20 )
      ( name = `Gaming Monster` category = `Desktop Computers` quantity = 24 )
      ( name = `Gaming Monster Pro` category = `Desktop Computers` quantity = 25 )
      ( name = `7" Widescreen Portable DVD Player w MP3` category = `Accessories` quantity = 20 )
      ( name = `10" Portable DVD player` category = `Accessories` quantity = 21 )
      ( name = `Portable DVD Player with 9" LCD Monitor` category = `Accessories` quantity = 50 )
      ( name = `CD/DVD case: 264 sleeves` category = `Accessories` quantity = 26 )
      ( name = `Audio/Video Cable Kit - 4m` category = `Accessories` quantity = 16 )
      ( name = `Removable CD/DVD Laser Labels` category = `Accessories` quantity = 25 )
      ( name = `Beam Breaker B-1` category = `Accessories` quantity = 32 )
      ( name = `Beam Breaker B-2` category = `Accessories` quantity = 18 )
      ( name = `Beam Breaker B-3` category = `Accessories` quantity = 16 )
      ( name = `Play Movie` category = `Accessories` quantity = 15 )
      ( name = `Record Movie` category = `Accessories` quantity = 24 )
      ( name = `ITelo MusicStick` category = `Accessories` quantity = 15 )
      ( name = `ITelo Jog-Mate` category = `Accessories` quantity = 24 )
      ( name = `Power Pro Player 40` category = `Accessories` quantity = 23 )
      ( name = `Power Pro Player 80` category = `Accessories` quantity = 13 )
      ( name = `Flat Watch HD32` category = `Flat Screen TVs` quantity = 16 )
      ( name = `Flat Watch HD37` category = `Flat Screen TVs` quantity = 14 )
      ( name = `Flat Watch HD41` category = `Flat Screen TVs` quantity = 13 )
      ( name = `Copperberry` category = `Accessories` quantity = 5 )
      ( name = `Silverberry` category = `Accessories` quantity = 9 )
      ( name = `Goldberry` category = `Accessories` quantity = 11 )
      ( name = `Platinberry` category = `Accessories` quantity = 12 )
      ( name = `ITelO FlexTop I4000` category = `Laptops` quantity = 11 )
      ( name = `ITelO FlexTop I6300c` category = `Laptops` quantity = 20 )
      ( name = `ITelO FlexTop I9100` category = `Laptops` quantity = 20 )
      ( name = `ITelO FlexTop I9800` category = `Laptops` quantity = 22 )
      ( name = `Smartphone Leather Case` category = `Accessories` quantity = 12 )
      ( name = `Smartphone Alpha` category = `Smartphones and Tablets` quantity = 13 )
      ( name = `Mini Tablet` category = `Smartphones and Tablets` quantity = 10 )
      ( name = `Camcorder View` category = `Accessories` quantity = 50 )
      ( name = `Tablet Pouch` category = `Accessories` quantity = 34 )
      ( name = `Tablet Pouch` category = `Accessories` quantity = 34 )
      ( name = `e-Book Reader ReadMe` category = `Smartphones and Tablets` quantity = 23 )
      ( name = `Smartphone Beta` category = `Smartphones and Tablets` quantity = 21 )
      ( name = `Maxi Tablet` category = `Tablets` quantity = 20 )
      ( name = `Flyer` category = `Accessories` quantity = 33 )
      ).

  ENDMETHOD.

ENDCLASS.
