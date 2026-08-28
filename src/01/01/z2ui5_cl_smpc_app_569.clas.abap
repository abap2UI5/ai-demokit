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
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

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

    DATA(box) = view->ele( n = `View` ns = `mvc`
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
    DATA(items) = COND string(
        WHEN selected = abap_true
        THEN |\{ path: '{ client->_bind( val = t_products path = abap_true ) }', filters: \{path: 'RANK', operator: 'GT', value1: '0'\}, sorter: \{path: 'RANK', descending: true\} \}|
        ELSE |\{ path: '{ client->_bind( val = t_products path = abap_true ) }', filters: \{path: 'RANK', operator: 'EQ', value1: '0'\} \}| ).

    DATA(table) = node->ele( `Table`
        )->a( n = `id`               v = COND #( WHEN selected = abap_true THEN `selectedTable` ELSE `availableTable` )
        )->a( n = `mode`             v = `SingleSelectMaster`
        )->a( n = `growing`          v = `true`
        )->a( n = `growingThreshold` v = `10`
        )->a( n = `items`            v = items ).

    IF selected = abap_true.
      table->a( n = `noDataText` v = `Please drag-and-drop products here.` ).
    ENDIF.

    DATA(toolbar) = table->ele( `headerToolbar`
        )->ele( `OverflowToolbar`
            )->tag( `Title`
                )->a( n = `text` v = COND #( WHEN selected = abap_true THEN `Selected Products` ELSE `Available Products` ) ).

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
    DATA(menu) = table->ele( `contextMenu`
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
    DATA(dnd) = table->ele( `dragDropConfig` ).

    IF selected = abap_true.
      dnd->tag( n = `DragInfo` ns = `dnd`
          )->a( n = `groupName`         v = `selected2available`
          )->a( n = `sourceAggregation` v = `items`
          )->tag( n = `DropInfo` ns = `dnd`
              )->a( n = `groupName`         v = `available2selected`
              )->a( n = `targetAggregation` v = `items`
              )->a( n = `dropPosition`      v = `Between`
              )->a( n = `drop`              v = client->_event( val   = `DROP_SELECTED`
                                                                t_arg = VALUE #( ( `${$parameters>/draggedControl}.getBindingContext().getProperty('NAME')` )
                                                                                 ( `${$parameters>/droppedControl}.getBindingContext() ? ${$parameters>/droppedControl}.getBindingContext().getProperty('NAME') : ''` )
                                                                                 ( `${$parameters>/dropPosition}` ) ) )
          )->tag( n = `DragDropInfo` ns = `dnd`
              )->a( n = `sourceAggregation` v = `items`
              )->a( n = `targetAggregation` v = `items`
              )->a( n = `dropPosition`      v = `Between`
              )->a( n = `drop`              v = client->_event( val   = `DROP_SELECTED`
                                                                t_arg = VALUE #( ( `${$parameters>/draggedControl}.getBindingContext().getProperty('NAME')` )
                                                                                 ( `${$parameters>/droppedControl}.getBindingContext() ? ${$parameters>/droppedControl}.getBindingContext().getProperty('NAME') : ''` )
                                                                                 ( `${$parameters>/dropPosition}` ) ) ) ).
    ELSE.
      dnd->tag( n = `DragInfo` ns = `dnd`
          )->a( n = `groupName`         v = `available2selected`
          )->a( n = `sourceAggregation` v = `items`
          )->tag( n = `DropInfo` ns = `dnd`
              )->a( n = `groupName`         v = `selected2available`
              )->a( n = `drop`              v = client->_event( val   = `DROP_AVAILABLE`
                                                                t_arg = VALUE #( ( `${$parameters>/draggedControl}.getBindingContext().getProperty('NAME')` ) ) ) ).
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
    ASSIGN t_products[ selected = abap_true rank = 0 ] TO FIELD-SYMBOL(<row>).
    IF sy-subrc <> 0.
      client->message_toast_display( `Please select a row!` ).
      RETURN.
    ENDIF.

    DATA(top_rank) = 0.
    LOOP AT t_products INTO DATA(product) WHERE rank > 0.
      IF product-rank > top_rank.
        top_rank = product-rank.
      ENDIF.
    ENDLOOP.

    <row>-rank = COND i( WHEN top_rank = 0 THEN c_rank_default ELSE top_rank + c_rank_default ).

  ENDMETHOD.


  METHOD move_to_available.

    " moveToAvailableProductsTable: the rank goes back to Initial
    ASSIGN t_products[ selected = abap_true ] TO FIELD-SYMBOL(<row>).
    IF sy-subrc <> 0 OR <row>-rank = 0.
      client->message_toast_display( `Please select a row!` ).
      RETURN.
    ENDIF.
    <row>-rank = 0.

  ENDMETHOD.


  METHOD move_sibling.

    " moveSelectedItem: swap the ranks of the selected row and its neighbour in
    " the descending order the selected table is sorted in
    DATA(ordered) = t_products.
    DELETE ordered WHERE rank = 0.
    SORT ordered BY rank DESCENDING.

    DATA(index) = line_index( ordered[ selected = abap_true ] ).
    IF index = 0.
      client->message_toast_display( `Please select a row!` ).
      RETURN.
    ENDIF.

    DATA(sibling) = COND i( WHEN up = abap_true THEN index - 1 ELSE index + 1 ).
    IF sibling < 1 OR sibling > lines( ordered ).
      RETURN.
    ENDIF.

    DATA(moved_name) = ordered[ index ]-name.
    DATA(sibling_name) = ordered[ sibling ]-name.
    DATA(moved_rank) = ordered[ index ]-rank.
    DATA(sibling_rank) = ordered[ sibling ]-rank.

    ASSIGN t_products[ name = moved_name ] TO FIELD-SYMBOL(<moved>).
    IF sy-subrc = 0.
      <moved>-rank = sibling_rank.
    ENDIF.
    ASSIGN t_products[ name = sibling_name ] TO FIELD-SYMBOL(<sibling>).
    IF sy-subrc = 0.
      <sibling>-rank = moved_rank.
    ENDIF.

  ENDMETHOD.


  METHOD rank_after_drop.

    " onDropSelectedProductsTable: Before/After/Between of Utils.ranking
    ASSIGN t_products[ name = dragged ] TO FIELD-SYMBOL(<dragged>).
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    IF dropped IS INITIAL.
      " dropped on the empty table
      <dragged>-rank = c_rank_default.
      RETURN.
    ENDIF.

    DATA(ordered) = t_products.
    DELETE ordered WHERE rank = 0.
    SORT ordered BY rank DESCENDING.

    DATA(drop_index) = line_index( ordered[ name = dropped ] ).
    IF drop_index = 0.
      <dragged>-rank = c_rank_default.
      RETURN.
    ENDIF.

    DATA(drop_rank) = ordered[ drop_index ]-rank.
    DATA(neighbour) = COND i( WHEN position = `After` THEN drop_index + 1 ELSE drop_index - 1 ).

    IF neighbour < 1 OR neighbour > lines( ordered ).
      " dropped before the first row or after the last one
      <dragged>-rank = COND i( WHEN position = `After` THEN drop_rank DIV 2 ELSE drop_rank + c_rank_default ).
      RETURN.
    ENDIF.

    <dragged>-rank = ( drop_rank + ordered[ neighbour ]-rank ) DIV 2.

  ENDMETHOD.


  METHOD on_event.

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
        DATA(back_name) = client->get_event_arg( ).
        ASSIGN t_products[ name = back_name ] TO FIELD-SYMBOL(<row>).
        IF sy-subrc = 0.
          <row>-rank = 0.
        ENDIF.
        view_display( ).

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " the full mock /ProductCollection with the Rank the controller seeds
    " (Utils.ranking.Initial = 0 for every row)
    t_products = VALUE #(
      ( name = `Notebook Basic 15`                                  category = `Laptops`                     quantity = 10 )
      ( name = `Notebook Basic 17`                                  category = `Laptops`                     quantity = 20 )
      ( name = `Notebook Basic 18`                                  category = `Laptops`                     quantity = 10 )
      ( name = `Notebook Basic 19`                                  category = `Laptops`                     quantity = 15 )
      ( name = `ITelO Vault`                                        category = `Accessories`                 quantity = 15 )
      ( name = `Notebook Professional 15`                           category = `Accessories`                 quantity = 16 )
      ( name = `Notebook Professional 17`                           category = `Laptops`                     quantity = 17 )
      ( name = `ITelO Vault Net`                                    category = `Accessories`                 quantity = 14 )
      ( name = `ITelO Vault SAT`                                    category = `Accessories`                 quantity = 50 )
      ( name = `Comfort Easy`                                       category = `Accessories`                 quantity = 30 )
      ( name = `Comfort Senior`                                     category = `Accessories`                 quantity = 24 )
      ( name = `Ergo Screen E-I`                                    category = `Flat Screen Monitors`        quantity = 14 )
      ( name = `Ergo Screen E-II`                                   category = `Flat Screen Monitors`        quantity = 24 )
      ( name = `Ergo Screen E-III`                                  category = `Flat Screen Monitors`        quantity = 50 )
      ( name = `Flat Basic`                                         category = `Flat Screen Monitors`        quantity = 23 )
      ( name = `Flat Future`                                        category = `Flat Screen Monitors`        quantity = 22 )
      ( name = `Flat XL`                                            category = `Flat Screen Monitors`        quantity = 23 )
      ( name = `Laser Professional Eco`                             category = `Printers`                    quantity = 21 )
      ( name = `Laser Basic`                                        category = `Printers`                    quantity = 8 )
      ( name = `Laser Allround`                                     category = `Printers`                    quantity = 9 )
      ( name = `Ultra Jet Super Color`                              category = `Printers`                    quantity = 17 )
      ( name = `Ultra Jet Mobile`                                   category = `Printers`                    quantity = 18 )
      ( name = `Ultra Jet Super Highspeed`                          category = `Printers`                    quantity = 25 )
      ( name = `Multi Print`                                        category = `Multifunction Printers`      quantity = 16 )
      ( name = `Multi Color`                                        category = `Multifunction Printers`      quantity = 5 )
      ( name = `Cordless Mouse`                                     category = `Mice`                        quantity = 25 )
      ( name = `Speed Mouse`                                        category = `Mice`                        quantity = 12 )
      ( name = `Track Mouse`                                        category = `Mice`                        quantity = 12 )
      ( name = `Ergonomic Keyboard`                                 category = `Keyboards`                   quantity = 50 )
      ( name = `Internet Keyboard`                                  category = `Keyboards`                   quantity = 35 )
      ( name = `Media Keyboard`                                     category = `Keyboards`                   quantity = 26 )
      ( name = `Mousepad`                                           category = `Mousepads`                   quantity = 12 )
      ( name = `Ergo Mousepad`                                      category = `Mousepads`                   quantity = 16 )
      ( name = `Designer Mousepad`                                  category = `Mousepads`                   quantity = 26 )
      ( name = `Universal card reader`                              category = `Computer System Accessories` quantity = 22 )
      ( name = `Proctra X`                                          category = `Graphic Cards`               quantity = 15 )
      ( name = `Gladiator MX`                                       category = `Graphic Cards`               quantity = 16 )
      ( name = `Hurricane GX`                                       category = `Graphic Cards`               quantity = 13 )
      ( name = `Hurricane GX/LN`                                    category = `Graphic Cards`               quantity = 5 )
      ( name = `Photo Scan`                                         category = `Scanners`                    quantity = 8 )
      ( name = `Power Scan`                                         category = `Scanners`                    quantity = 11 )
      ( name = `Jet Scan Professional`                              category = `Scanners`                    quantity = 13 )
      ( name = `Jet Scan Professional`                              category = `Scanners`                    quantity = 10 )
      ( name = `Copymaster`                                         category = `Multifunction Printers`      quantity = 10 )
      ( name = `Surround Sound`                                     category = `Speakers`                    quantity = 20 )
      ( name = `Blaster Extreme`                                    category = `Speakers`                    quantity = 15 )
      ( name = `Sound Booster`                                      category = `Speakers`                    quantity = 50 )
      ( name = `Lovely Sound 5.1 Wireless`                          category = `Accessories`                 quantity = 12 )
      ( name = `Lovely Sound 5.1`                                   category = `Accessories`                 quantity = 18 )
      ( name = `Lovely Sound Stereo`                                category = `Accessories`                 quantity = 21 )
      ( name = `Smart Office`                                       category = `Software`                    quantity = 25 )
      ( name = `Smart Design`                                       category = `Software`                    quantity = 26 )
      ( name = `Smart Network`                                      category = `Software`                    quantity = 28 )
      ( name = `Smart Multimedia`                                   category = `Software`                    quantity = 9 )
      ( name = `Smart Games`                                        category = `Software`                    quantity = 13 )
      ( name = `Smart Internet Antivirus`                           category = `Software`                    quantity = 17 )
      ( name = `Smart Firewall`                                     category = `Software`                    quantity = 19 )
      ( name = `Smart Money`                                        category = `Software`                    quantity = 18 )
      ( name = `PC Lock`                                            category = `Computer System Accessories` quantity = 14 )
      ( name = `Notebook Lock`                                      category = `Computer System Accessories` quantity = 20 )
      ( name = `Web cam reality`                                    category = `Computer System Accessories` quantity = 27 )
      ( name = `Screen clean`                                       category = `Computer System Accessories` quantity = 17 )
      ( name = `Fabric bag professional`                            category = `Computer System Accessories` quantity = 14 )
      ( name = `Wireless DSL Router`                                category = `Telecommunications`          quantity = 16 )
      ( name = `Wireless DSL Router / Repeater`                     category = `Telecommunications`          quantity = 12 )
      ( name = `Wireless DSL Router / Repeater and Print Server`    category = `Telecommunications`          quantity = 12 )
      ( name = `USB Stick`                                          category = `Computer System Accessories` quantity = 14 )
      ( name = `Travel Adapter`                                     category = `Accessories`                 quantity = 10 )
      ( name = `Cordless Bluetooth Keyboard, english international` category = `Keyboards`                   quantity = 13 )
      ( name = `Flat XXL`                                           category = `Flat Screen Monitors`        quantity = 10 )
      ( name = `Pocket Mouse`                                       category = `Mice`                        quantity = 20 )
      ( name = `PC Power Station`                                   category = `PCs`                         quantity = 22 )
      ( name = `Astro Laptop 1516`                                  category = `Laptops`                     quantity = 23 )
      ( name = `Astro Phone 6`                                      category = `Smartphones and Tablets`     quantity = 28 )
      ( name = `Benda Laptop 1408`                                  category = `Laptops`                     quantity = 27 )
      ( name = `Bending Screen 21HD`                                category = `Flat Screens`                quantity = 23 )
      ( name = `Broad Screen 22HD`                                  category = `Flat Screens`                quantity = 5 )
      ( name = `Cerdik Phone 7`                                     category = `Smartphones and Tablets`     quantity = 19 )
      ( name = `Cepat Tablet 10.5`                                  category = `Smartphones and Tablets`     quantity = 17 )
      ( name = `Cepat Tablet 8`                                     category = `Smartphones and Tablets`     quantity = 24 )
      ( name = `Server Basic`                                       category = `Servers`                     quantity = 24 )
      ( name = `Server Professional`                                category = `Servers`                     quantity = 26 )
      ( name = `Server Power Pro`                                   category = `Servers`                     quantity = 34 )
      ( name = `Family PC Basic`                                    category = `Desktop Computers`           quantity = 10 )
      ( name = `Family PC Pro`                                      category = `Desktop Computers`           quantity = 20 )
      ( name = `Gaming Monster`                                     category = `Desktop Computers`           quantity = 24 )
      ( name = `Gaming Monster Pro`                                 category = `Desktop Computers`           quantity = 25 )
      ( name = `7" Widescreen Portable DVD Player w MP3`            category = `Accessories`                 quantity = 20 )
      ( name = `10" Portable DVD player`                            category = `Accessories`                 quantity = 21 )
      ( name = `Portable DVD Player with 9" LCD Monitor`            category = `Accessories`                 quantity = 50 )
      ( name = `CD/DVD case: 264 sleeves`                           category = `Accessories`                 quantity = 26 )
      ( name = `Audio/Video Cable Kit - 4m`                         category = `Accessories`                 quantity = 16 )
      ( name = `Removable CD/DVD Laser Labels`                      category = `Accessories`                 quantity = 25 )
      ( name = `Beam Breaker B-1`                                   category = `Accessories`                 quantity = 32 )
      ( name = `Beam Breaker B-2`                                   category = `Accessories`                 quantity = 18 )
      ( name = `Beam Breaker B-3`                                   category = `Accessories`                 quantity = 16 )
      ( name = `Play Movie`                                         category = `Accessories`                 quantity = 15 )
      ( name = `Record Movie`                                       category = `Accessories`                 quantity = 24 )
      ( name = `ITelo MusicStick`                                   category = `Accessories`                 quantity = 15 )
      ( name = `ITelo Jog-Mate`                                     category = `Accessories`                 quantity = 24 )
      ( name = `Power Pro Player 40`                                category = `Accessories`                 quantity = 23 )
      ( name = `Power Pro Player 80`                                category = `Accessories`                 quantity = 13 )
      ( name = `Flat Watch HD32`                                    category = `Flat Screen TVs`             quantity = 16 )
      ( name = `Flat Watch HD37`                                    category = `Flat Screen TVs`             quantity = 14 )
      ( name = `Flat Watch HD41`                                    category = `Flat Screen TVs`             quantity = 13 )
      ( name = `Copperberry`                                        category = `Accessories`                 quantity = 5 )
      ( name = `Silverberry`                                        category = `Accessories`                 quantity = 9 )
      ( name = `Goldberry`                                          category = `Accessories`                 quantity = 11 )
      ( name = `Platinberry`                                        category = `Accessories`                 quantity = 12 )
      ( name = `ITelO FlexTop I4000`                                category = `Laptops`                     quantity = 11 )
      ( name = `ITelO FlexTop I6300c`                               category = `Laptops`                     quantity = 20 )
      ( name = `ITelO FlexTop I9100`                                category = `Laptops`                     quantity = 20 )
      ( name = `ITelO FlexTop I9800`                                category = `Laptops`                     quantity = 22 )
      ( name = `Smartphone Leather Case`                            category = `Accessories`                 quantity = 12 )
      ( name = `Smartphone Alpha`                                   category = `Smartphones and Tablets`     quantity = 13 )
      ( name = `Mini Tablet`                                        category = `Smartphones and Tablets`     quantity = 10 )
      ( name = `Camcorder View`                                     category = `Accessories`                 quantity = 50 )
      ( name = `Tablet Pouch`                                       category = `Accessories`                 quantity = 34 )
      ( name = `Tablet Pouch`                                       category = `Accessories`                 quantity = 34 )
      ( name = `e-Book Reader ReadMe`                               category = `Smartphones and Tablets`     quantity = 23 )
      ( name = `Smartphone Beta`                                    category = `Smartphones and Tablets`     quantity = 21 )
      ( name = `Maxi Tablet`                                        category = `Tablets`                     quantity = 20 )
      ( name = `Flyer`                                              category = `Accessories`                 quantity = 33 ) ).

  ENDMETHOD.

ENDCLASS.
