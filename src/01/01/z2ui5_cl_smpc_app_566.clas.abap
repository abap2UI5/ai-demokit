" @keywords table sap.m tablebreadcrumb overflowtoolbar toolbarspacer button breadcrumbs link label column text columnlistitem
" @summary With an InfoToolbar and some crumb logic you can navigate simple hierarchies with a breadcrumb table approach.
CLASS z2ui5_cl_smpc_app_566 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    " the three levels of the hierarchy in one flat table: 1 Suppliers,
    " 2 Categories, 3 Products
    TYPES: BEGIN OF ty_s_node,
             level         TYPE i,
             supplier      TYPE string,
             category      TYPE string,
             name          TYPE string,
             productid     TYPE string,
             dimensions    TYPE string,
             weightmeasure TYPE string,
             weightunit    TYPE string,
             weight_state  TYPE string,
             price         TYPE string,
             currencycode  TYPE string,
             row_type      TYPE string,
             selected      TYPE abap_bool,
           END OF ty_s_node.
    TYPES ty_t_node TYPE STANDARD TABLE OF ty_s_node WITH EMPTY KEY.

    TYPES: BEGIN OF ty_s_crumb,
             text  TYPE string,
             level TYPE i,
           END OF ty_s_crumb.
    TYPES ty_t_crumb TYPE STANDARD TABLE OF ty_s_crumb WITH EMPTY KEY.

    DATA t_nodes  TYPE ty_t_node.
    DATA t_rows   TYPE ty_t_node.
    DATA t_crumbs TYPE ty_t_crumb.

    " where the drill-down currently is
    DATA cur_level    TYPE i VALUE 1.
    DATA cur_supplier TYPE string.
    DATA cur_category TYPE string.
    " the Order model: count + hasCounts
    DATA order_count  TYPE i.
    DATA has_counts   TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS rows_refresh.
    METHODS order_refresh.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_566 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      rows_refresh( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    DATA(page) = view->ele( n = `View` ns = `mvc`
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->ele( `Page`
            )->a( n = `showHeader` v = `false` ).

    " the Order button is enabled while at least one product is selected
    page->ele( `footer`
        )->ele( `OverflowToolbar`
            )->tag( `ToolbarSpacer`
            )->tag( `Button`
                )->a( n = `text`    v = `Order`
                )->a( n = `enabled` v = client->_bind( has_counts )
                )->a( n = `press`   v = client->_event( `ORDER` )

        )->end(
    )->end( ).

    page->ele( `content`
        )->ele( `Table`
            )->a( n = `id`    v = `idProductsTable`
            )->a( n = `inset` v = `false`
            " _setAggregation switches the mode with the level; the property is
            " bindable, so the expression follows the level instead
            )->a( n = `mode`  v = |\{= ${ client->_bind( cur_level ) } === 3 ? 'MultiSelect' : 'SingleSelectMaster' \}|
            )->a( n = `items` v = client->_bind( t_rows )
            )->a( n = `selectionChange` v = client->_event( val   = `SELECTION_CHANGE`
                                                            t_arg = VALUE #( ( `${$parameters>/listItem}.getBindingContext().getProperty('NAME')` )
                                                                             ( `${$parameters>/selected}` ) ) )

            )->ele( `headerToolbar`
                )->ele( `OverflowToolbar`
                    )->a( n = `id` v = `idCrumbToolbar`

                    )->ele( `Breadcrumbs`
                        )->a( n = `id`    v = `breadcrumb`
                        )->a( n = `links` v = client->_bind( t_crumbs )

                        )->tag( `Link`
                            )->a( n = `text`  v = `{TEXT}`
                            )->a( n = `press` v = client->_event( val   = `CRUMB`
                                                                  t_arg = VALUE #( ( `${LEVEL}` ) ) )

                    )->end(
                )->end(
            )->end(
            )->ele( `infoToolbar`
                )->ele( `OverflowToolbar`
                    )->a( n = `visible` v = client->_bind( has_counts )

                    )->tag( `Label`
                        )->a( n = `text` v = |\{{ client->_bind( val = order_count path = abap_true ) }\} Products Selected|

                )->end(
            )->end(
            )->ele( `columns`
                )->ele( `Column`
                    )->a( n = `width` v = `12em`

                    )->tag( `Text`
                        )->a( n = `text` v = `Name`

                )->end(
                )->ele( `Column`
                    )->a( n = `id`             v = `dimensionsColumn`
                    )->a( n = `minScreenWidth` v = `Tablet`
                    )->a( n = `demandPopin`    v = `true`
                    )->a( n = `hAlign`         v = `End`
                    )->a( n = `visible`        v = |\{= ${ client->_bind( cur_level ) } === 3 \}|

                    )->tag( `Text`
                        )->a( n = `text` v = `Dimensions`

                )->end(
                )->ele( `Column`
                    )->a( n = `id`             v = `weightColumn`
                    )->a( n = `minScreenWidth` v = `Tablet`
                    )->a( n = `demandPopin`    v = `true`
                    )->a( n = `hAlign`         v = `Center`
                    )->a( n = `visible`        v = |\{= ${ client->_bind( cur_level ) } === 3 \}|

                    )->tag( `Text`
                        )->a( n = `text` v = `Weight`

                )->end(
                )->ele( `Column`
                    )->a( n = `hAlign` v = `End`

                    )->tag( `Text`
                        )->a( n = `text` v = `Price`

                )->end(
            )->end(

            " Row.fragment.xml - the row template the controller binds
            )->ele( `items`
                )->ele( `ColumnListItem`
                    )->a( n = `vAlign`   v = `Middle`
                    )->a( n = `type`     v = `{ROW_TYPE}`
                    )->a( n = `selected` v = `{SELECTED}`

                    )->ele( `cells`
                        )->tag( `ObjectIdentifier`
                            )->a( n = `title` v = `{NAME}`
                            )->a( n = `text`  v = `{PRODUCTID}`
                        )->tag( `Text`
                            )->a( n = `text` v = `{DIMENSIONS}`
                        )->tag( `ObjectNumber`
                            )->a( n = `number` v = `{WEIGHTMEASURE}`
                            )->a( n = `unit`   v = `{WEIGHTUNIT}`
                            )->a( n = `state`  v = `{WEIGHT_STATE}`
                        )->tag( `ObjectNumber`
                            )->a( n = `number` v = `{PRICE}`
                            )->a( n = `unit`   v = `{CURRENCYCODE}`

                    )->end(
                )->end(
            )->end(
        )->end(
    )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD rows_refresh.

    " _setAggregation rebinds the table to the branch the user drilled into
    CLEAR t_rows.
    LOOP AT t_nodes INTO DATA(node).
      CASE cur_level.
        WHEN 1.
          IF node-level = 1.
            APPEND node TO t_rows.
          ENDIF.
        WHEN 2.
          IF node-level = 2 AND node-supplier = cur_supplier.
            APPEND node TO t_rows.
          ENDIF.
        WHEN OTHERS.
          IF node-level = 3 AND node-supplier = cur_supplier AND node-category = cur_category.
            APPEND node TO t_rows.
          ENDIF.
      ENDCASE.
    ENDLOOP.

    " the breadcrumb carries one link per level already visited
    t_crumbs = VALUE #( ( text = `Suppliers` level = 1 ) ).
    IF cur_level >= 2.
      APPEND VALUE #( text = cur_supplier level = 2 ) TO t_crumbs.
    ENDIF.
    IF cur_level >= 3.
      APPEND VALUE #( text = cur_category level = 3 ) TO t_crumbs.
    ENDIF.

  ENDMETHOD.


  METHOD order_refresh.

    " the Order model's count / hasCounts (Formatter.listProductsSelected)
    order_count = REDUCE i( INIT n = 0
                            FOR node IN t_nodes
                            NEXT n = COND #( WHEN node-selected = abap_true THEN n + 1 ELSE n ) ).
    has_counts = xsdbool( order_count > 0 ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `SELECTION_CHANGE`.
        " handleSelectionChange: on a branch the selection navigates one level
        " deeper, on a leaf it only records the order selection
        DATA(row_name) = client->get_event_arg( ).
        DATA(is_selected) = CONV abap_bool( client->get_event_arg( 2 ) ).
        CASE cur_level.
          WHEN 1.
            cur_supplier = row_name.
            cur_level = 2.
          WHEN 2.
            cur_category = row_name.
            cur_level = 3.
          WHEN OTHERS.
            ASSIGN t_nodes[ level = 3 supplier = cur_supplier category = cur_category name = row_name ]
                   TO FIELD-SYMBOL(<node>).
            IF sy-subrc = 0.
              <node>-selected = is_selected.
            ENDIF.
            order_refresh( ).
        ENDCASE.
        rows_refresh( ).
        view_display( ).

      WHEN `CRUMB`.
        " onBreadcrumbPress: the links after the pressed one are dropped and the
        " table goes back to that level
        cur_level = client->get_event_arg( ).
        rows_refresh( ).
        view_display( ).

      WHEN `ORDER`.
        " handleOrderPress toasts the names of the selected products
        DATA(names) = ``.
        LOOP AT t_nodes INTO DATA(sel) WHERE selected = abap_true.
          IF names IS NOT INITIAL.
            names = names && `,`.
          ENDIF.
          names = names && sel-name.
        ENDLOOP.
        client->message_toast_display( |Ordering: { names }| ).

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " productHierarchy.json, flattened into one node table: 4 suppliers, their
    " 9 categories and the 14 products under them. Price is already rounded to
    " two decimals (Formatter.round2DP) and the dimensions string is already
    " joined (Formatter.dimensions skips the missing ones)
    t_nodes = VALUE #(
      ( level = 1 name = `Titanium` price = `1884.49` currencycode = `EUR` row_type = `Navigation` )
      ( level = 2 supplier = `Titanium` name = `Projector` price = `856.49` currencycode = `EUR` row_type = `Navigation` )
      ( level = 3 supplier = `Titanium` category = `Projector` name = `Power Projector 4713` productid = `1239102`
        dimensions = `51 x 42 x 18 cm` weightmeasure = `1467` weightunit = `g` weight_state = `Warning`
        price = `856.49` currencycode = `EUR` row_type = `Inactive` )
      ( level = 2 supplier = `Titanium` name = `Laptop` price = `939.00` currencycode = `EUR` row_type = `Navigation` )
      ( level = 3 supplier = `Titanium` category = `Laptop` name = `High End Laptop 2b` productid = `OP-38800002`
        dimensions = `64 x 34 x 4 cm` weightmeasure = `1190` weightunit = `g` weight_state = `Warning`
        price = `939.00` currencycode = `EUR` row_type = `Inactive` )
      ( level = 2 supplier = `Titanium` name = `Keyboard` price = `89.00` currencycode = `EUR` row_type = `Navigation` )
      ( level = 3 supplier = `Titanium` category = `Keyboard` name = `Hardcore Hacker` productid = `977700-11`
        dimensions = `53 x 24 x 6 cm` weightmeasure = `651` weightunit = `g` weight_state = `Success`
        price = `89.00` currencycode = `EUR` row_type = `Inactive` )
      ( level = 1 name = `Technocom` price = `154.19` currencycode = `EUR` row_type = `Navigation` )
      ( level = 2 supplier = `Technocom` name = `Graphics Card` price = `81.70` currencycode = `EUR` row_type = `Navigation` )
      ( level = 3 supplier = `Technocom` category = `Graphics Card` name = `Gladiator MX` productid = `2212-121-828`
        dimensions = `34 x 14 x 2 cm` weightmeasure = `321` weightunit = `g` weight_state = `Success`
        price = `81.70` currencycode = `EUR` row_type = `Inactive` )
      ( level = 2 supplier = `Technocom` name = `Accessory` price = `72.49` currencycode = `EUR` row_type = `Navigation` )
      ( level = 3 supplier = `Technocom` category = `Accessory` name = `Webcam` productid = `22134T`
        dimensions = `18 x 19 x 21 cm` weightmeasure = `700` weightunit = `g` weight_state = `Success`
        price = `59.00` currencycode = `EUR` row_type = `Inactive` )
      ( level = 3 supplier = `Technocom` category = `Accessory` name = `Monitor Locking Cable` productid = `P1239823`
        dimensions = `11 x 11 x 3 cm` weightmeasure = `40` weightunit = `g` weight_state = `Success`
        price = `13.49` currencycode = `EUR` row_type = `Inactive` )
      ( level = 1 name = `Red Point Stores` price = `472.36` currencycode = `EUR` row_type = `Navigation` )
      ( level = 2 supplier = `Red Point Stores` name = `Graphics Card` price = `219.00` currencycode = `EUR` row_type = `Navigation` )
      ( level = 3 supplier = `Red Point Stores` category = `Graphics Card` name = `Hurricane GX` productid = `K47322.1`
        dimensions = `34 x 14 x 2 cm` weightmeasure = `588` weightunit = `g` weight_state = `Success`
        price = `219.00` currencycode = `EUR` row_type = `Inactive` )
      ( level = 2 supplier = `Red Point Stores` name = `Accessory` price = `96.18` currencycode = `EUR` row_type = `Navigation` )
      ( level = 3 supplier = `Red Point Stores` category = `Accessory` name = `Laptop Case` productid = `214-121-828`
        dimensions = `53 x 34 x 7 cm` weightmeasure = `1289` weightunit = `g` weight_state = `Warning`
        price = `78.99` currencycode = `EUR` row_type = `Inactive` )
      ( level = 3 supplier = `Red Point Stores` category = `Accessory` name = `USB Stick 16 GByte` productid = `XKP-312548`
        dimensions = `6 x 2 x 0.5 cm` weightmeasure = `11` weightunit = `g` weight_state = `Success`
        price = `17.19` currencycode = `EUR` row_type = `Inactive` )
      ( level = 2 supplier = `Red Point Stores` name = `Printer` price = `157.18` currencycode = `EUR` row_type = `Navigation` )
      ( level = 3 supplier = `Red Point Stores` category = `Printer` name = `Deskjet Super Highspeed` productid = `KTZ-12012.V2`
        dimensions = `87 x 45 x 39 cm` weightmeasure = `100` weightunit = `g` weight_state = `Success`
        price = `117.19` currencycode = `EUR` row_type = `Inactive` )
      ( level = 3 supplier = `Red Point Stores` category = `Printer` name = `Laser Allround Pro` productid = `89932-922`
        dimensions = `42 x 29 x 31 cm` weightmeasure = `2134` weightunit = `g` weight_state = `Error`
        price = `39.99` currencycode = `EUR` row_type = `Inactive` )
      ( level = 1 name = `Very Best Screens` price = `2217.00` currencycode = `EUR` row_type = `Navigation` )
      ( level = 2 supplier = `Very Best Screens` name = `Monitor` price = `2217.00` currencycode = `EUR` row_type = `Navigation` )
      ( level = 3 supplier = `Very Best Screens` category = `Monitor` name = `Flat S` productid = `38094020.1`
        dimensions = `88 x 13 x 49 cm` weightmeasure = `1401` weightunit = `g` weight_state = `Warning`
        price = `339.00` currencycode = `EUR` row_type = `Inactive` )
      ( level = 3 supplier = `Very Best Screens` category = `Monitor` name = `Flat Medium` productid = `870394932`
        dimensions = `102 x 13 x 54 cm` weightmeasure = `1800` weightunit = `g` weight_state = `Warning`
        price = `639.00` currencycode = `EUR` row_type = `Inactive` )
      ( level = 3 supplier = `Very Best Screens` category = `Monitor` name = `Flat X-large II` productid = `282948303-02`
        dimensions = `112 x 13 x 60 cm` weightmeasure = `2100` weightunit = `g` weight_state = `Error`
        price = `1239.00` currencycode = `EUR` row_type = `Inactive` ) ).

    " a flat ABAP row serializes EVERY field, so the supplier and category rows -
    " which carry no weight at all - would send an empty string into the
    " ObjectNumber's ValueState and take the whole view down. None is the
    " control's own default and is what the sample's formatter returns for a
    " missing measure (**e2e-caught 2026-08-22**)
    LOOP AT t_nodes ASSIGNING FIELD-SYMBOL(<node>) WHERE weight_state IS INITIAL.
      <node>-weight_state = `None`.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
