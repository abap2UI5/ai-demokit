" @keywords table sap.m tablemultiselectmode overflowtoolbar title toolbarspacer searchfield label switch combobox item button
" @summary This example demonstrates the different multi-selection modes if the table is configured with MultiToggle mode and the sap.m.table.Title control.
CLASS z2ui5_cl_smpc_app_574 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             productid    TYPE string,
             name         TYPE string,
             suppliername TYPE string,
             width        TYPE string,
             depth        TYPE string,
             height       TYPE string,
             dimunit      TYPE string,
             selected     TYPE abap_bool,
           END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

    DATA t_products     TYPE ty_t_product.
    " the rows the search leaves visible; T_PRODUCTS stays the full set
    DATA t_rows         TYPE ty_t_product.

    " the ui> view model of the sample
    DATA total_count    TYPE i.
    DATA selected_count TYPE i.
    DATA show_total     TYPE abap_bool VALUE abap_true.
    DATA extended_view  TYPE abap_bool.
    DATA select_mode    TYPE string VALUE `Default`.
    DATA new_counter    TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS counts_refresh.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_574 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      t_rows = t_products.
      counts_refresh( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`       v = `sap.m`
        )->a( n = `xmlns:mvc`   v = `sap.ui.core.mvc`
        )->a( n = `xmlns:table` v = `sap.m.table`
        )->a( n = `xmlns:core`  v = `sap.ui.core`

        )->ele( `Table`
            )->a( n = `id`                 v = `idProductsTable`
            )->a( n = `mode`               v = `MultiSelect`
            )->a( n = `items`              v = |\{ path: '{ client->_bind_path( t_rows ) }', sorter: \{ path: 'NAME' \} \}|
            )->a( n = `itemActionCount`    v = `1`
            )->a( n = `rememberSelections` v = `false`
            )->a( n = `selectionChange`    v = client->_event( `ROW_SELECTION` )
            " onItemActionPress deletes the row the action was fired on; the event
            " ships the list item, so its ProductId travels with it
            )->a( n = `itemActionPress`    v = client->_event( val = `ITEM_ACTION` arg = `${$parameters>/listItem}.getBindingContext().getProperty('PRODUCTID')` )
            " onSelectionChange of the ComboBox calls setMultiSelectionMode - see
            " the sidecar; the real property is multiSelectMode and it is bindable
            )->a( n = `multiSelectMode`    v = client->_bind( select_mode )

            )->ele( `headerToolbar`
                )->ele( `OverflowToolbar`

                    )->ele( n = `Title` ns = `table`
                        )->a( n = `id`               v = `idTableTitle`
                        )->a( n = `totalCount`       v = client->_bind( total_count )
                        )->a( n = `selectedCount`    v = client->_bind( selected_count )
                        )->a( n = `showExtendedView` v = client->_bind( extended_view )

                        )->tag( `Title`
                            )->a( n = `text`  v = `Products`
                            )->a( n = `level` v = `H2`

                    )->end(
                    )->tag( `ToolbarSpacer`
                    )->tag( `SearchField`
                        )->a( n = `id`          v = `idSearchField`
                        )->a( n = `width`       v = `15rem`
                        )->a( n = `placeholder` v = `Search products...`
                        )->a( n = `search`      v = client->_event( val = `SEARCH` arg = `${$parameters>/query}` )
                    )->tag( `Label`
                        )->a( n = `text`     v = `Extended view`
                        )->a( n = `labelFor` v = `extViewSwitch`
                    )->tag( `Switch`
                        )->a( n = `id`    v = `extViewSwitch`
                        )->a( n = `state` v = client->_bind( extended_view )
                    )->tag( `Label`
                        )->a( n = `text`     v = `Show totalCount`
                        )->a( n = `labelFor` v = `disableTotalCountSwitch`
                    )->tag( `Switch`
                        )->a( n = `id`     v = `disableTotalCountSwitch`
                        )->a( n = `state`  v = client->_bind( show_total )
                        )->a( n = `change` v = client->_event( `TOGGLE_TOTAL` )
                    )->tag( `Label`
                        )->a( n = `text`     v = `Multi selection modes`
                        )->a( n = `labelFor` v = `idComboBoxSuccess`
                    )->ele( `ComboBox`
                        )->a( n = `id`          v = `idComboBoxSuccess`
                        )->a( n = `selectedKey` v = client->_bind( select_mode )

                        )->tag( n = `Item` ns = `core`
                            )->a( n = `text` v = `Default`
                            )->a( n = `key`  v = `Default`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `text` v = `ClearAll`
                            )->a( n = `key`  v = `ClearAll`

                    )->end(
                    )->tag( `Button`
                        )->a( n = `icon`  v = `sap-icon://add`
                        )->a( n = `text`  v = `Add randomized product`
                        )->a( n = `press` v = client->_event( `ADD_ROW` )

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
                    )->a( n = `minScreenWidth` v = `Tablet`
                    )->a( n = `demandPopin`    v = `true`
                    )->a( n = `hAlign`         v = `End`

                    )->tag( `Text`
                        )->a( n = `text` v = `Dimensions`

                )->end(
            )->end(
            )->ele( `items`
                )->ele( `ColumnListItem`
                    )->a( n = `vAlign`   v = `Middle`
                    )->a( n = `selected` v = `{SELECTED}`

                    )->ele( `actions`
                        )->tag( `ListItemAction`
                            )->a( n = `type` v = `Delete`

                    )->end(
                    )->ele( `cells`
                        )->tag( `ObjectIdentifier`
                            )->a( n = `title` v = `{NAME}`
                            )->a( n = `text`  v = `{PRODUCTID}`
                        )->tag( `Text`
                            )->a( n = `text` v = `{SUPPLIERNAME}`
                        )->tag( `Text`
                            )->a( n = `text` v = `{WIDTH} x {DEPTH} x {HEIGHT} {DIMUNIT}`

                    )->end(
                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD counts_refresh.

    " _updateTotalCount / _updateSelectedCount read the binding and the selection;
    " the backend holds both, so it counts them here
    DATA temp1 TYPE i.
    DATA temp2 TYPE i.
    DATA n TYPE i.
    DATA row LIKE LINE OF t_rows.
      DATA temp3 TYPE i.
    IF show_total = abap_true.
      temp1 = lines( t_rows ).
    ELSE.
      temp1 = -1.
    ENDIF.
    total_count = temp1.
    
    
    n = 0.
    
    LOOP AT t_rows INTO row.
      
      IF row-selected = abap_true.
        temp3 = n + 1.
      ELSE.
        temp3 = n.
      ENDIF.
      n = temp3.
    ENDLOOP.
    temp2 = n.
    selected_count = temp2.

  ENDMETHOD.


  METHOD on_event.
        DATA query TYPE string.
          DATA product LIKE LINE OF t_products.
        DATA del_id TYPE string.
        DATA temp3 LIKE LINE OF t_rows.
        DATA lr_row LIKE REF TO temp3.
        DATA temp4 TYPE string_table.
        DATA suppliers LIKE temp4.
        DATA temp6 TYPE ty_s_product.
        DATA temp5 LIKE LINE OF suppliers.
        DATA temp7 LIKE sy-tabix.
        DATA new_row LIKE temp6.

    CASE client->get_event( ).

      WHEN `ROW_SELECTION`.
        counts_refresh( ).

      WHEN `TOGGLE_TOTAL`.
        counts_refresh( ).

      WHEN `SEARCH`.
        " onSearch filters Name, SupplierName and ProductId with an OR filter
        
        query = to_upper( client->get_event_arg( ) ).
        IF query IS INITIAL.
          t_rows = t_products.
        ELSE.
          CLEAR t_rows.
          
          LOOP AT t_products INTO product.
            IF to_upper( product-name ) CS query
                OR to_upper( product-suppliername ) CS query OR to_upper( product-productid ) CS query.
              APPEND product TO t_rows.
            ENDIF.
          ENDLOOP.
        ENDIF.
        counts_refresh( ).

      WHEN `ITEM_ACTION`.
        " onItemActionPress deletes the row, clears the selection and toasts
        
        del_id = client->get_event_arg( ).
        DELETE t_products WHERE productid = del_id.
        DELETE t_rows WHERE productid = del_id.
        
        
        LOOP AT t_rows REFERENCE INTO lr_row.
          lr_row->selected = abap_false.
        ENDLOOP.
        counts_refresh( ).
        client->message_toast_display( `Product deleted and selection cleared.` ).

      WHEN `ADD_ROW`.
        " onAddRow appends a product with randomised values; a backend cannot
        " repeat a client-side random draw, so it counts up instead
        new_counter = new_counter + 1.
        
        CLEAR temp4.
        INSERT `SupplierA` INTO TABLE temp4.
        INSERT `SupplierB` INTO TABLE temp4.
        INSERT `SupplierC` INTO TABLE temp4.
        
        suppliers = temp4.
        
        CLEAR temp6.
        temp6-productid = |PRD-{ new_counter }|.
        temp6-name = |Product { new_counter }|.
        
        
        temp7 = sy-tabix.
        READ TABLE suppliers INDEX ( new_counter - 1 ) MOD 3 + 1 INTO temp5.
        sy-tabix = temp7.
        IF sy-subrc <> 0.
          ASSERT 1 = 0.
        ENDIF.
        temp6-suppliername = temp5.
        temp6-width = |{ 10 + new_counter MOD 50 }|.
        temp6-depth = |{ 10 + new_counter MOD 50 }|.
        temp6-height = |{ 10 + new_counter MOD 50 }|.
        temp6-dimunit = `cm`.
        
        new_row = temp6.
        APPEND new_row TO t_products.
        APPEND new_row TO t_rows.
        counts_refresh( ).
        client->message_toast_display( |New product added: { new_row-name }| ).

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " the full mock /ProductCollection, in the mock order - the items binding
    " keeps its own sorter on NAME
    DATA temp7 TYPE z2ui5_cl_smpc_app_574=>ty_t_product.
    DATA temp8 LIKE LINE OF temp7.
    CLEAR temp7.
    
    temp8-productid = `HT-1000`.
    temp8-name = `Notebook Basic 15`.
    temp8-suppliername = `Very Best Screens`.
    temp8-width = `30`.
    temp8-depth = `18`.
    temp8-height = `3`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1001`.
    temp8-name = `Notebook Basic 17`.
    temp8-suppliername = `Very Best Screens`.
    temp8-width = `29`.
    temp8-depth = `17`.
    temp8-height = `3.1`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1002`.
    temp8-name = `Notebook Basic 18`.
    temp8-suppliername = `Very Best Screens`.
    temp8-width = `28`.
    temp8-depth = `19`.
    temp8-height = `2.5`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1003`.
    temp8-name = `Notebook Basic 19`.
    temp8-suppliername = `Smartcards`.
    temp8-width = `32`.
    temp8-depth = `21`.
    temp8-height = `4`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1007`.
    temp8-name = `ITelO Vault`.
    temp8-suppliername = `Technocom`.
    temp8-width = `32`.
    temp8-depth = `22`.
    temp8-height = `3`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1010`.
    temp8-name = `Notebook Professional 15`.
    temp8-suppliername = `Very Best Screens`.
    temp8-width = `33`.
    temp8-depth = `20`.
    temp8-height = `3`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1011`.
    temp8-name = `Notebook Professional 17`.
    temp8-suppliername = `Very Best Screens`.
    temp8-width = `33`.
    temp8-depth = `23`.
    temp8-height = `2`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1020`.
    temp8-name = `ITelO Vault Net`.
    temp8-suppliername = `Technocom`.
    temp8-width = `10`.
    temp8-depth = `1.8`.
    temp8-height = `17`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1021`.
    temp8-name = `ITelO Vault SAT`.
    temp8-suppliername = `Technocom`.
    temp8-width = `11`.
    temp8-depth = `1.7`.
    temp8-height = `18`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1022`.
    temp8-name = `Comfort Easy`.
    temp8-suppliername = `Technocom`.
    temp8-width = `84`.
    temp8-depth = `1.5`.
    temp8-height = `14`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1023`.
    temp8-name = `Comfort Senior`.
    temp8-suppliername = `Technocom`.
    temp8-width = `80`.
    temp8-depth = `1.6`.
    temp8-height = `13`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1030`.
    temp8-name = `Ergo Screen E-I`.
    temp8-suppliername = `Very Best Screens`.
    temp8-width = `37`.
    temp8-depth = `12`.
    temp8-height = `36`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1031`.
    temp8-name = `Ergo Screen E-II`.
    temp8-suppliername = `Very Best Screens`.
    temp8-width = `40.8`.
    temp8-depth = `19`.
    temp8-height = `43`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1032`.
    temp8-name = `Ergo Screen E-III`.
    temp8-suppliername = `Very Best Screens`.
    temp8-width = `40.8`.
    temp8-depth = `19`.
    temp8-height = `43`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1035`.
    temp8-name = `Flat Basic`.
    temp8-suppliername = `Very Best Screens`.
    temp8-width = `39`.
    temp8-depth = `20`.
    temp8-height = `41`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1036`.
    temp8-name = `Flat Future`.
    temp8-suppliername = `Very Best Screens`.
    temp8-width = `45`.
    temp8-depth = `26`.
    temp8-height = `46`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1037`.
    temp8-name = `Flat XL`.
    temp8-suppliername = `Very Best Screens`.
    temp8-width = `54.5`.
    temp8-depth = `22.1`.
    temp8-height = `39.1`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1040`.
    temp8-name = `Laser Professional Eco`.
    temp8-suppliername = `Alpha Printers`.
    temp8-width = `51`.
    temp8-depth = `46`.
    temp8-height = `30`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1041`.
    temp8-name = `Laser Basic`.
    temp8-suppliername = `Alpha Printers`.
    temp8-width = `48`.
    temp8-depth = `42`.
    temp8-height = `26`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1042`.
    temp8-name = `Laser Allround`.
    temp8-suppliername = `Alpha Printers`.
    temp8-width = `53`.
    temp8-depth = `50`.
    temp8-height = `65`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1050`.
    temp8-name = `Ultra Jet Super Color`.
    temp8-suppliername = `Alpha Printers`.
    temp8-width = `41`.
    temp8-depth = `41`.
    temp8-height = `28`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1051`.
    temp8-name = `Ultra Jet Mobile`.
    temp8-suppliername = `Printer for All`.
    temp8-width = `46`.
    temp8-depth = `32`.
    temp8-height = `25`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1052`.
    temp8-name = `Ultra Jet Super Highspeed`.
    temp8-suppliername = `Printer for All`.
    temp8-width = `41`.
    temp8-depth = `41`.
    temp8-height = `28`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1055`.
    temp8-name = `Multi Print`.
    temp8-suppliername = `Printer for All`.
    temp8-width = `55`.
    temp8-depth = `45`.
    temp8-height = `29`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1056`.
    temp8-name = `Multi Color`.
    temp8-suppliername = `Printer for All`.
    temp8-width = `51`.
    temp8-depth = `41.3`.
    temp8-height = `22`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1060`.
    temp8-name = `Cordless Mouse`.
    temp8-suppliername = `Oxynum`.
    temp8-width = `6`.
    temp8-depth = `14.5`.
    temp8-height = `3.5`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1061`.
    temp8-name = `Speed Mouse`.
    temp8-suppliername = `Oxynum`.
    temp8-width = `7`.
    temp8-depth = `15`.
    temp8-height = `3.1`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1062`.
    temp8-name = `Track Mouse`.
    temp8-suppliername = `Oxynum`.
    temp8-width = `3`.
    temp8-depth = `7`.
    temp8-height = `4`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1063`.
    temp8-name = `Ergonomic Keyboard`.
    temp8-suppliername = `Oxynum`.
    temp8-width = `50`.
    temp8-depth = `21`.
    temp8-height = `3.5`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1064`.
    temp8-name = `Internet Keyboard`.
    temp8-suppliername = `Oxynum`.
    temp8-width = `52`.
    temp8-depth = `25`.
    temp8-height = `3`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1065`.
    temp8-name = `Media Keyboard`.
    temp8-suppliername = `Oxynum`.
    temp8-width = `51.4`.
    temp8-depth = `23`.
    temp8-height = `4`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1066`.
    temp8-name = `Mousepad`.
    temp8-suppliername = `Oxynum`.
    temp8-width = `15`.
    temp8-depth = `6`.
    temp8-height = `0.2`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1067`.
    temp8-name = `Ergo Mousepad`.
    temp8-suppliername = `Oxynum`.
    temp8-width = `15`.
    temp8-depth = `6`.
    temp8-height = `0.2`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1068`.
    temp8-name = `Designer Mousepad`.
    temp8-suppliername = `Fasttech`.
    temp8-width = `24`.
    temp8-depth = `24`.
    temp8-height = `0.6`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1069`.
    temp8-name = `Universal card reader`.
    temp8-suppliername = `Fasttech`.
    temp8-width = `6`.
    temp8-depth = `6`.
    temp8-height = `3`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1070`.
    temp8-name = `Proctra X`.
    temp8-suppliername = `Ultrasonic United`.
    temp8-width = `22`.
    temp8-depth = `35`.
    temp8-height = `17`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1071`.
    temp8-name = `Gladiator MX`.
    temp8-suppliername = `Ultrasonic United`.
    temp8-width = `22`.
    temp8-depth = `35`.
    temp8-height = `17`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1072`.
    temp8-name = `Hurricane GX`.
    temp8-suppliername = `Ultrasonic United`.
    temp8-width = `22`.
    temp8-depth = `35`.
    temp8-height = `17`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1073`.
    temp8-name = `Hurricane GX/LN`.
    temp8-suppliername = `Smartcards`.
    temp8-width = `22`.
    temp8-depth = `35`.
    temp8-height = `17`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1080`.
    temp8-name = `Photo Scan`.
    temp8-suppliername = `Printer for All`.
    temp8-width = `34`.
    temp8-depth = `48`.
    temp8-height = `5`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1081`.
    temp8-name = `Power Scan`.
    temp8-suppliername = `Printer for All`.
    temp8-width = `31`.
    temp8-depth = `43`.
    temp8-height = `7`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1082`.
    temp8-name = `Jet Scan Professional`.
    temp8-suppliername = `Printer for All`.
    temp8-width = `33`.
    temp8-depth = `41`.
    temp8-height = `12`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1083`.
    temp8-name = `Jet Scan Professional`.
    temp8-suppliername = `Printer for All`.
    temp8-width = `35`.
    temp8-depth = `40`.
    temp8-height = `10`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1085`.
    temp8-name = `Copymaster`.
    temp8-suppliername = `Alpha Printers`.
    temp8-width = `45`.
    temp8-depth = `42`.
    temp8-height = `22`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1090`.
    temp8-name = `Surround Sound`.
    temp8-suppliername = `Speaker Experts`.
    temp8-width = `12`.
    temp8-depth = `10`.
    temp8-height = `16`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1091`.
    temp8-name = `Blaster Extreme`.
    temp8-suppliername = `Speaker Experts`.
    temp8-width = `13`.
    temp8-depth = `11`.
    temp8-height = `17.5`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1092`.
    temp8-name = `Sound Booster`.
    temp8-suppliername = `Speaker Experts`.
    temp8-width = `12.4`.
    temp8-depth = `10.4`.
    temp8-height = `18.1`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1095`.
    temp8-name = `Lovely Sound 5.1 Wireless`.
    temp8-suppliername = `Fasttech`.
    temp8-width = `24`.
    temp8-depth = `19`.
    temp8-height = `23`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1096`.
    temp8-name = `Lovely Sound 5.1`.
    temp8-suppliername = `Fasttech`.
    temp8-width = `25`.
    temp8-depth = `17`.
    temp8-height = `19`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1097`.
    temp8-name = `Lovely Sound Stereo`.
    temp8-suppliername = `Fasttech`.
    temp8-width = `21.3`.
    temp8-depth = `2.4`.
    temp8-height = `19.7`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1100`.
    temp8-name = `Smart Office`.
    temp8-suppliername = `Technocom`.
    temp8-width = `15`.
    temp8-depth = `6.5`.
    temp8-height = `2.1`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1101`.
    temp8-name = `Smart Design`.
    temp8-suppliername = `Technocom`.
    temp8-width = `14`.
    temp8-depth = `6.7`.
    temp8-height = `24`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1102`.
    temp8-name = `Smart Network`.
    temp8-suppliername = `Technocom`.
    temp8-width = `16`.
    temp8-depth = `6`.
    temp8-height = `27`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1103`.
    temp8-name = `Smart Multimedia`.
    temp8-suppliername = `Technocom`.
    temp8-width = `11`.
    temp8-depth = `3.4`.
    temp8-height = `22`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1104`.
    temp8-name = `Smart Games`.
    temp8-suppliername = `Technocom`.
    temp8-width = `10`.
    temp8-depth = `3`.
    temp8-height = `30`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1105`.
    temp8-name = `Smart Internet Antivirus`.
    temp8-suppliername = `Brainsoft`.
    temp8-width = `16`.
    temp8-depth = `4`.
    temp8-height = `21`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1106`.
    temp8-name = `Smart Firewall`.
    temp8-suppliername = `Brainsoft`.
    temp8-width = `17.9`.
    temp8-depth = `4.2`.
    temp8-height = `23.1`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1107`.
    temp8-name = `Smart Money`.
    temp8-suppliername = `Brainsoft`.
    temp8-width = `12`.
    temp8-depth = `1.5`.
    temp8-height = `19`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1110`.
    temp8-name = `PC Lock`.
    temp8-suppliername = `Red Point Stores`.
    temp8-width = `20`.
    temp8-depth = `8`.
    temp8-height = `4.3`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1111`.
    temp8-name = `Notebook Lock`.
    temp8-suppliername = `Red Point Stores`.
    temp8-width = `31`.
    temp8-depth = `9`.
    temp8-height = `7`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1112`.
    temp8-name = `Web cam reality`.
    temp8-suppliername = `Red Point Stores`.
    temp8-width = `9`.
    temp8-depth = `8.2`.
    temp8-height = `1.3`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1113`.
    temp8-name = `Screen clean`.
    temp8-suppliername = `Red Point Stores`.
    temp8-width = `2`.
    temp8-depth = `2`.
    temp8-height = `0.1`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1114`.
    temp8-name = `Fabric bag professional`.
    temp8-suppliername = `Red Point Stores`.
    temp8-width = `42`.
    temp8-depth = `32`.
    temp8-height = `7`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1115`.
    temp8-name = `Wireless DSL Router`.
    temp8-suppliername = `Red Point Stores`.
    temp8-width = `19.3`.
    temp8-depth = `18`.
    temp8-height = `5`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1116`.
    temp8-name = `Wireless DSL Router / Repeater`.
    temp8-suppliername = `Red Point Stores`.
    temp8-width = `19.3`.
    temp8-depth = `18`.
    temp8-height = `5`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1117`.
    temp8-name = `Wireless DSL Router / Repeater and Print Server`.
    temp8-suppliername = `Technocom`.
    temp8-width = `19.3`.
    temp8-depth = `18`.
    temp8-height = `5`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1118`.
    temp8-name = `USB Stick`.
    temp8-suppliername = `Technocom`.
    temp8-width = `1.5`.
    temp8-depth = `8.7`.
    temp8-height = `1.2`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1119`.
    temp8-name = `Travel Adapter`.
    temp8-suppliername = `Titanium`.
    temp8-width = `2`.
    temp8-depth = `3.1`.
    temp8-height = `3.9`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1120`.
    temp8-name = `Cordless Bluetooth Keyboard, english international`.
    temp8-suppliername = `Technocom`.
    temp8-width = `51.4`.
    temp8-depth = `23`.
    temp8-height = `4`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1137`.
    temp8-name = `Flat XXL`.
    temp8-suppliername = `Technocom`.
    temp8-width = `54`.
    temp8-depth = `22`.
    temp8-height = `38`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1138`.
    temp8-name = `Pocket Mouse`.
    temp8-suppliername = `Technocom`.
    temp8-width = `0.3`.
    temp8-depth = `0.5`.
    temp8-height = `1`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1210`.
    temp8-name = `PC Power Station`.
    temp8-suppliername = `Technocom`.
    temp8-width = `28`.
    temp8-depth = `31`.
    temp8-height = `43`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1251`.
    temp8-name = `Astro Laptop 1516`.
    temp8-suppliername = `Ultrasonic United`.
    temp8-width = `30`.
    temp8-depth = `18`.
    temp8-height = `3`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1252`.
    temp8-name = `Astro Phone 6`.
    temp8-suppliername = `Ultrasonic United`.
    temp8-width = `8`.
    temp8-depth = `6`.
    temp8-height = `1.5`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1253`.
    temp8-name = `Benda Laptop 1408`.
    temp8-suppliername = `Ultrasonic United`.
    temp8-width = `30`.
    temp8-depth = `18`.
    temp8-height = `3`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1254`.
    temp8-name = `Bending Screen 21HD`.
    temp8-suppliername = `Ultrasonic United`.
    temp8-width = `37`.
    temp8-depth = `12`.
    temp8-height = `36`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1255`.
    temp8-name = `Broad Screen 22HD`.
    temp8-suppliername = `Ultrasonic United`.
    temp8-width = `39`.
    temp8-depth = `12`.
    temp8-height = `38`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1256`.
    temp8-name = `Cerdik Phone 7`.
    temp8-suppliername = `Ultrasonic United`.
    temp8-width = `9`.
    temp8-depth = `15`.
    temp8-height = `1.5`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1257`.
    temp8-name = `Cepat Tablet 10.5`.
    temp8-suppliername = `Ultrasonic United`.
    temp8-width = `48`.
    temp8-depth = `31`.
    temp8-height = `4.5`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1258`.
    temp8-name = `Cepat Tablet 8`.
    temp8-suppliername = `Ultrasonic United`.
    temp8-width = `38`.
    temp8-depth = `21`.
    temp8-height = `3.5`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1500`.
    temp8-name = `Server Basic`.
    temp8-suppliername = `Technocom`.
    temp8-width = `34`.
    temp8-depth = `35`.
    temp8-height = `23`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1501`.
    temp8-name = `Server Professional`.
    temp8-suppliername = `Technocom`.
    temp8-width = `29`.
    temp8-depth = `30`.
    temp8-height = `27`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1502`.
    temp8-name = `Server Power Pro`.
    temp8-suppliername = `Technocom`.
    temp8-width = `22`.
    temp8-depth = `27.3`.
    temp8-height = `37`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1600`.
    temp8-name = `Family PC Basic`.
    temp8-suppliername = `Titanium`.
    temp8-width = `21.4`.
    temp8-depth = `29`.
    temp8-height = `38`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1601`.
    temp8-name = `Family PC Pro`.
    temp8-suppliername = `Titanium`.
    temp8-width = `25`.
    temp8-depth = `31.7`.
    temp8-height = `40.2`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1602`.
    temp8-name = `Gaming Monster`.
    temp8-suppliername = `Titanium`.
    temp8-width = `26.5`.
    temp8-depth = `34`.
    temp8-height = `47`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1603`.
    temp8-name = `Gaming Monster Pro`.
    temp8-suppliername = `Titanium`.
    temp8-width = `27`.
    temp8-depth = `28`.
    temp8-height = `42`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-2000`.
    temp8-name = `7" Widescreen Portable DVD Player w MP3`.
    temp8-suppliername = `Titanium`.
    temp8-width = `21.4`.
    temp8-depth = `19`.
    temp8-height = `27.6`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-2001`.
    temp8-name = `10" Portable DVD player`.
    temp8-suppliername = `Titanium`.
    temp8-width = `24`.
    temp8-depth = `19.5`.
    temp8-height = `29`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-2002`.
    temp8-name = `Portable DVD Player with 9" LCD Monitor`.
    temp8-suppliername = `Technocom`.
    temp8-width = `21`.
    temp8-depth = `16.5`.
    temp8-height = `14`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-2025`.
    temp8-name = `CD/DVD case: 264 sleeves`.
    temp8-suppliername = `Titanium`.
    temp8-width = `13`.
    temp8-depth = `13`.
    temp8-height = `20`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-2026`.
    temp8-name = `Audio/Video Cable Kit - 4m`.
    temp8-suppliername = `Titanium`.
    temp8-width = `21`.
    temp8-depth = `10.2`.
    temp8-height = `13`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-2027`.
    temp8-name = `Removable CD/DVD Laser Labels`.
    temp8-suppliername = `Titanium`.
    temp8-width = `5.5`.
    temp8-depth = `2`.
    temp8-height = `2`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6100`.
    temp8-name = `Beam Breaker B-1`.
    temp8-suppliername = `Titanium`.
    temp8-width = `30.4`.
    temp8-depth = `23.1`.
    temp8-height = `23`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6101`.
    temp8-name = `Beam Breaker B-2`.
    temp8-suppliername = `Technocom`.
    temp8-width = `30.4`.
    temp8-depth = `23.1`.
    temp8-height = `23`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6102`.
    temp8-name = `Beam Breaker B-3`.
    temp8-suppliername = `Technocom`.
    temp8-width = `30.4`.
    temp8-depth = `23.1`.
    temp8-height = `23`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6110`.
    temp8-name = `Play Movie`.
    temp8-suppliername = `Fasttech`.
    temp8-width = `37`.
    temp8-depth = `24`.
    temp8-height = `6`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6111`.
    temp8-name = `Record Movie`.
    temp8-suppliername = `Fasttech`.
    temp8-width = `38`.
    temp8-depth = `26`.
    temp8-height = `6.2`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6120`.
    temp8-name = `ITelo MusicStick`.
    temp8-suppliername = `Fasttech`.
    temp8-width = `1.5`.
    temp8-depth = `6`.
    temp8-height = `1`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6121`.
    temp8-name = `ITelo Jog-Mate`.
    temp8-suppliername = `Fasttech`.
    temp8-width = `5.1`.
    temp8-depth = `8`.
    temp8-height = `9.2`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6122`.
    temp8-name = `Power Pro Player 40`.
    temp8-suppliername = `Fasttech`.
    temp8-width = `5.1`.
    temp8-depth = `8`.
    temp8-height = `9.2`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6123`.
    temp8-name = `Power Pro Player 80`.
    temp8-suppliername = `Fasttech`.
    temp8-width = `4`.
    temp8-depth = `6`.
    temp8-height = `0.8`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6130`.
    temp8-name = `Flat Watch HD32`.
    temp8-suppliername = `Very Best Screens`.
    temp8-width = `78`.
    temp8-depth = `22.1`.
    temp8-height = `55`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6131`.
    temp8-name = `Flat Watch HD37`.
    temp8-suppliername = `Very Best Screens`.
    temp8-width = `99.1`.
    temp8-depth = `26`.
    temp8-height = `61`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6132`.
    temp8-name = `Flat Watch HD41`.
    temp8-suppliername = `Very Best Screens`.
    temp8-width = `128`.
    temp8-depth = `23`.
    temp8-height = `79.1`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-7000`.
    temp8-name = `Copperberry`.
    temp8-suppliername = `Fasttech`.
    temp8-width = `8.1`.
    temp8-depth = `13`.
    temp8-height = `12.1`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-7010`.
    temp8-name = `Silverberry`.
    temp8-suppliername = `Fasttech`.
    temp8-width = `8.1`.
    temp8-depth = `13`.
    temp8-height = `12.1`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-7020`.
    temp8-name = `Goldberry`.
    temp8-suppliername = `Fasttech`.
    temp8-width = `8.1`.
    temp8-depth = `13`.
    temp8-height = `12.1`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-7030`.
    temp8-name = `Platinberry`.
    temp8-suppliername = `Fasttech`.
    temp8-width = `8.1`.
    temp8-depth = `13`.
    temp8-height = `12.1`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-8000`.
    temp8-name = `ITelO FlexTop I4000`.
    temp8-suppliername = `Titanium`.
    temp8-width = `31`.
    temp8-depth = `19`.
    temp8-height = `3.1`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-8001`.
    temp8-name = `ITelO FlexTop I6300c`.
    temp8-suppliername = `Titanium`.
    temp8-width = `32`.
    temp8-depth = `20`.
    temp8-height = `3.4`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-8002`.
    temp8-name = `ITelO FlexTop I9100`.
    temp8-suppliername = `Titanium`.
    temp8-width = `38`.
    temp8-depth = `21`.
    temp8-height = `4.1`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-8003`.
    temp8-name = `ITelO FlexTop I9800`.
    temp8-suppliername = `Titanium`.
    temp8-width = `48`.
    temp8-depth = `31`.
    temp8-height = `4.5`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-9991`.
    temp8-name = `Smartphone Leather Case`.
    temp8-suppliername = `Ultrasonic United`.
    temp8-width = `48`.
    temp8-depth = `31`.
    temp8-height = `4.5`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-9992`.
    temp8-name = `Smartphone Alpha`.
    temp8-suppliername = `Ultrasonic United`.
    temp8-width = `48`.
    temp8-depth = `31`.
    temp8-height = `4.5`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-9993`.
    temp8-name = `Mini Tablet`.
    temp8-suppliername = `Ultrasonic United`.
    temp8-width = `48`.
    temp8-depth = `31`.
    temp8-height = `4.5`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-9994`.
    temp8-name = `Camcorder View`.
    temp8-suppliername = `Ultrasonic United`.
    temp8-width = `48`.
    temp8-depth = `31`.
    temp8-height = `27`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-9995`.
    temp8-name = `Tablet Pouch`.
    temp8-suppliername = `Titanium`.
    temp8-width = `25`.
    temp8-depth = `40`.
    temp8-height = `4.5`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-9996`.
    temp8-name = `Tablet Pouch`.
    temp8-suppliername = `Titanium`.
    temp8-width = `25`.
    temp8-depth = `40`.
    temp8-height = `4.5`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-9997`.
    temp8-name = `e-Book Reader ReadMe`.
    temp8-suppliername = `Titanium`.
    temp8-width = `48`.
    temp8-depth = `31`.
    temp8-height = `4.5`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-9998`.
    temp8-name = `Smartphone Beta`.
    temp8-suppliername = `Titanium`.
    temp8-width = `48`.
    temp8-depth = `31`.
    temp8-height = `4.5`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-9999`.
    temp8-name = `Maxi Tablet`.
    temp8-suppliername = `Titanium`.
    temp8-width = `48`.
    temp8-depth = `31`.
    temp8-height = `4.5`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `PF-1000`.
    temp8-name = `Flyer`.
    temp8-suppliername = `Titanium`.
    temp8-width = `46`.
    temp8-depth = `30`.
    temp8-height = `3`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    t_products = temp7.

  ENDMETHOD.

ENDCLASS.
