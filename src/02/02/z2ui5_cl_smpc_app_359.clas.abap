" @keywords table sap.ui.table rowaction overflowtoolbar title toolbarspacer select item togglebutton column label text
" @summary Shows how row actions can be used.
CLASS z2ui5_cl_smpc_app_359 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name           TYPE string,
        productid      TYPE string,
        quantity       TYPE i,
        price          TYPE p LENGTH 13 DECIMALS 2,
        currencycode   TYPE string,
        available      TYPE abap_bool,
        navigatedstate TYPE abap_bool,
      END OF ty_s_product,
      BEGIN OF ty_s_key,
        key  TYPE string,
        text TYPE string,
      END OF ty_s_key.
    TYPES temp1_72dcc0e1f1 TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.
DATA t_products TYPE temp1_72dcc0e1f1.

    " the original's `modes>` model, folded onto the one default model
    TYPES temp2_72dcc0e1f1 TYPE STANDARD TABLE OF ty_s_key WITH DEFAULT KEY.
DATA t_modes  TYPE temp2_72dcc0e1f1.
    DATA mode_key TYPE string.

    " what the picked mode means for the row actions - the original builds a
    " different RowAction template per mode in JS; the port declares the UNION
    " of its items once and switches them on and off from the backend
    DATA row_action_count TYPE i.
    DATA show_navigation  TYPE abap_bool.
    DATA show_delete      TYPE abap_bool.
    DATA show_edit        TYPE abap_bool.
    DATA show_multi       TYPE abap_bool.

    " the navigated-indicator ToggleButton
    DATA show_navigated TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS mode_apply.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_359 IMPLEMENTATION.

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
    DATA temp4 TYPE string_table.
    DATA temp5 TYPE string_table.
    DATA temp6 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " the row-action demo. The original builds a different RowAction template
    " per mode in the controller; the port declares the union of its six items
    " once and drives their visible flags plus rowActionCount from the backend,
    " so the Select switches the row actions without any control construction.
    
    CLEAR temp1.
    INSERT `MESSAGE_TOAST` INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    INSERT `Item {0} pressed for product with id {1}` INTO TABLE temp1.
    INSERT `${$parameters>/item}.getText() || ${$parameters>/item}.getType()` INTO TABLE temp1.
    INSERT `${$parameters>/row}.getBindingContext().getProperty('PRODUCTID')` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `MESSAGE_TOAST` INTO TABLE temp2.
    INSERT `show` INTO TABLE temp2.
    INSERT `Item {0} pressed for product with id {1}` INTO TABLE temp2.
    INSERT `${$parameters>/item}.getText() || ${$parameters>/item}.getType()` INTO TABLE temp2.
    INSERT `${$parameters>/row}.getBindingContext().getProperty('PRODUCTID')` INTO TABLE temp2.
    
    CLEAR temp3.
    INSERT `MESSAGE_TOAST` INTO TABLE temp3.
    INSERT `show` INTO TABLE temp3.
    INSERT `Item {0} pressed for product with id {1}` INTO TABLE temp3.
    INSERT `${$parameters>/item}.getText() || ${$parameters>/item}.getType()` INTO TABLE temp3.
    INSERT `${$parameters>/row}.getBindingContext().getProperty('PRODUCTID')` INTO TABLE temp3.
    
    CLEAR temp4.
    INSERT `MESSAGE_TOAST` INTO TABLE temp4.
    INSERT `show` INTO TABLE temp4.
    INSERT `Item {0} pressed for product with id {1}` INTO TABLE temp4.
    INSERT `${$parameters>/item}.getText() || ${$parameters>/item}.getType()` INTO TABLE temp4.
    INSERT `${$parameters>/row}.getBindingContext().getProperty('PRODUCTID')` INTO TABLE temp4.
    
    CLEAR temp5.
    INSERT `MESSAGE_TOAST` INTO TABLE temp5.
    INSERT `show` INTO TABLE temp5.
    INSERT `Item {0} pressed for product with id {1}` INTO TABLE temp5.
    INSERT `${$parameters>/item}.getText() || ${$parameters>/item}.getType()` INTO TABLE temp5.
    INSERT `${$parameters>/row}.getBindingContext().getProperty('PRODUCTID')` INTO TABLE temp5.
    
    CLEAR temp6.
    INSERT `MESSAGE_TOAST` INTO TABLE temp6.
    INSERT `show` INTO TABLE temp6.
    INSERT `Item {0} pressed for product with id {1}` INTO TABLE temp6.
    INSERT `${$parameters>/item}.getText() || ${$parameters>/item}.getType()` INTO TABLE temp6.
    INSERT `${$parameters>/row}.getBindingContext().getProperty('PRODUCTID')` INTO TABLE temp6.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.ui.table`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:u`   v = `sap.ui.unified`
        )->a( n = `xmlns:c`   v = `sap.ui.core`
        )->a( n = `xmlns:m`   v = `sap.m`
        )->a( n = `height`    v = `100%`

        )->ele( n = `Page` ns = `m`
            )->a( n = `showHeader`      v = `false`
            )->a( n = `enableScrolling` v = `false`
            )->a( n = `class`           v = `sapUiContentPadding`

            )->ele( n = `content` ns = `m`
                )->ele( `Table`
                    )->a( n = `id`             v = `table`
                    )->a( n = `rows`           v = client->_bind( t_products )
                    )->a( n = `rowActionCount` v = client->_bind( row_action_count )
                    )->a( n = `selectionMode`  v = `MultiToggle`
                    )->a( n = `ariaLabelledBy` v = `title`

                    )->ele( `extension`
                        )->ele( n = `OverflowToolbar` ns = `m`
                            )->a( n = `style` v = `Clear`

                            )->tag( n = `Title` ns = `m`
                                )->a( n = `id`   v = `title`
                                )->a( n = `text` v = `Products`

                            )->tag( n = `ToolbarSpacer` ns = `m`

                            )->ele( n = `Select` ns = `m`
                                )->a( n = `id`          v = `select`
                                )->a( n = `items`       v = client->_bind( t_modes )
                                )->a( n = `selectedKey` v = client->_bind( mode_key )
                                )->a( n = `change`      v = client->_event( `MODE_CHANGE` )

                                )->tag( n = `Item` ns = `c`
                                    )->a( n = `key`  v = `{KEY}`
                                    )->a( n = `text` v = `{TEXT}`

                            )->end(
                            )->tag( n = `ToggleButton` ns = `m`
                                )->a( n = `text`    v = `Toggle Navigated Indicators`
                                )->a( n = `pressed` v = client->_bind( show_navigated )

                        )->end(
                    )->end(
                    )->ele( `columns`
                        )->ele( `Column`
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Product Name`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{NAME}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Product Id`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{PRODUCTID}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `hAlign` v = `End`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Quantity`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{QUANTITY}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Price`

                            )->ele( `template`
                                )->tag( n = `Currency` ns = `u`
                                    )->a( n = `value`    v = `{PRICE}`
                                    )->a( n = `currency` v = `{CURRENCYCODE}`

                            )->end(
                        )->end(
                    )->end(
                    )->ele( `rowActionTemplate`
                        )->ele( `RowAction`
                            )->tag( `RowActionItem`
                                )->a( n = `type`    v = `Navigation`
                                )->a( n = `visible` v = |\{= ${ client->_bind( show_navigation ) } && $\{AVAILABLE\} \}|
                                )->a( n = `press`   v = client->follow_up_action(
                                          val   = client->cs_event-control_global
                                          t_arg = temp1 )

                            )->tag( `RowActionItem`
                                )->a( n = `type`    v = `Delete`
                                )->a( n = `visible` v = client->_bind( show_delete )
                                )->a( n = `press`   v = client->follow_up_action(
                                          val   = client->cs_event-control_global
                                          t_arg = temp2 )

                            )->tag( `RowActionItem`
                                )->a( n = `icon`    v = `sap-icon://attachment`
                                )->a( n = `text`    v = `Attachment`
                                )->a( n = `visible` v = client->_bind( show_multi )
                                )->a( n = `press`   v = client->follow_up_action(
                                          val   = client->cs_event-control_global
                                          t_arg = temp3 )

                            )->tag( `RowActionItem`
                                )->a( n = `icon`    v = `sap-icon://search`
                                )->a( n = `text`    v = `Search`
                                )->a( n = `visible` v = client->_bind( show_multi )
                                )->a( n = `press`   v = client->follow_up_action(
                                          val   = client->cs_event-control_global
                                          t_arg = temp4 )

                            )->tag( `RowActionItem`
                                )->a( n = `icon`    v = `sap-icon://edit`
                                )->a( n = `text`    v = `Edit`
                                )->a( n = `visible` v = client->_bind( show_edit )
                                )->a( n = `press`   v = client->follow_up_action(
                                          val   = client->cs_event-control_global
                                          t_arg = temp5 )

                            )->tag( `RowActionItem`
                                )->a( n = `icon`    v = `sap-icon://line-chart`
                                )->a( n = `text`    v = `Analyze`
                                )->a( n = `visible` v = client->_bind( show_multi )
                                )->a( n = `press`   v = client->follow_up_action(
                                          val   = client->cs_event-control_global
                                          t_arg = temp6 )

                        )->end(
                    )->end(
                    )->ele( `rowSettingsTemplate`
                        )->tag( `RowSettings`
                            )->a( n = `navigated` v = |\{= ${ client->_bind( show_navigated ) } && $\{NAVIGATEDSTATE\} \}|

                    )->end(
                )->end(
            )->end(
        )->end(
    )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
      DATA lv_was_none TYPE abap_bool.
      DATA temp1 TYPE xsdboolean.

    IF client->get_event( ) = `MODE_CHANGE`.
      " onBehaviourModeChange -> switchState: the picked mode decides the
      " row action count and which items are shown
      
      
      temp1 = boolc( row_action_count = 0 ).
      lv_was_none = temp1.
      mode_apply( ).
      " switchState always calls setRowActionTemplate BEFORE setRowActionCount,
      " and that ordering is load-bearing: the template setter ends in an
      " invalidateRowsAggregation call, the count setter in a plain setProperty.
      " A row's _rowAction is attached exclusively in _getRowClone( ), guarded
      " by hasRowActions( ) - which needs getRowActionCount( ) > 0 - so any row
      " created while the count is 0 has NO _rowAction, and merely raising the
      " count afterwards never re-creates the clones. The port drives only the
      " count from the model, so it had no counterpart for that invalidation,
      " and invalidateRowsAggregation( ) cannot be wired (the frontend action
      " allowlist denies the whole invalidate* prefix - the render lifecycle is
      " the framework's). Re-displaying the slot rebuilds the Table with the new
      " count already set, so the rows are created WITH their actions.
      " Reachable without anything exotic: pick "No Actions", leave and come
      " back - check_on_navigated rebuilds the view with mode_key still 'None',
      " so every row is created actionless and no later switch brings them back.
      IF lv_was_none = abap_true AND row_action_count > 0.
        view_display( ).
      ENDIF.
    ENDIF.


  ENDMETHOD.


  METHOD mode_apply.

    " the five handlers of the controller's `modes` array, as data
    DATA temp2 TYPE xsdboolean.
    DATA temp4 TYPE xsdboolean.
    DATA temp5 TYPE xsdboolean.
    DATA temp6 TYPE xsdboolean.
    DATA temp3 TYPE i.
    temp2 = boolc( mode_key = `Navigation` OR mode_key = `NavigationDelete` OR mode_key = `NavigationCustom` ).
    show_navigation = temp2.
    
    temp4 = boolc( mode_key = `NavigationDelete` ).
    show_delete     = temp4.
    
    temp5 = boolc( mode_key = `NavigationCustom` OR mode_key = `Multi` ).
    show_edit       = temp5.
    
    temp6 = boolc( mode_key = `Multi` ).
    show_multi      = temp6.
    
    CASE mode_key.
      WHEN `None`.
        temp3 = 0.
      WHEN `Navigation`.
        temp3 = 1.
      WHEN OTHERS.
        temp3 = 2.
    ENDCASE.
    row_action_count = temp3.

  ENDMETHOD.


  METHOD model_init.

    " the controller's `modes` array - key and label per row-action mode
    DATA temp4 LIKE t_modes.
    DATA temp5 LIKE LINE OF temp4.
    DATA temp6 LIKE t_products.
    DATA temp7 LIKE LINE OF temp6.
    CLEAR temp4.
    
    temp5-key = `Navigation`.
    temp5-text = `Navigation`.
    INSERT temp5 INTO TABLE temp4.
    temp5-key = `NavigationDelete`.
    temp5-text = `Navigation & Delete`.
    INSERT temp5 INTO TABLE temp4.
    temp5-key = `NavigationCustom`.
    temp5-text = `Navigation & Custom`.
    INSERT temp5 INTO TABLE temp4.
    temp5-key = `Multi`.
    temp5-text = `Multiple Actions`.
    INSERT temp5 INTO TABLE temp4.
    temp5-key = `None`.
    temp5-text = `No Actions`.
    INSERT temp5 INTO TABLE temp4.
    t_modes = temp4.

    " switchState("Navigation") in onInit
    mode_key = `Navigation`.
    mode_apply( ).

    " the shared 123-row demo ProductCollection (sap/ui/demo/mock/products.json)
    " with the four columns the sample binds, plus the derived Available flag
    " the Navigation item's visible binding needs. The original marks the
    " SECOND row as navigated (i === 1), which is reproduced here
    
    CLEAR temp6.
    
    temp7-name = `Notebook Basic 15`.
    temp7-productid = `HT-1000`.
    temp7-quantity = 10.
    temp7-price = 956.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Notebook Basic 17`.
    temp7-productid = `HT-1001`.
    temp7-quantity = 20.
    temp7-price = 1249.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    temp7-navigatedstate = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Notebook Basic 18`.
    temp7-productid = `HT-1002`.
    temp7-quantity = 10.
    temp7-price = 1570.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Notebook Basic 19`.
    temp7-productid = `HT-1003`.
    temp7-quantity = 15.
    temp7-price = 1650.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `ITelO Vault`.
    temp7-productid = `HT-1007`.
    temp7-quantity = 15.
    temp7-price = 299.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Notebook Professional 15`.
    temp7-productid = `HT-1010`.
    temp7-quantity = 16.
    temp7-price = 1999.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Notebook Professional 17`.
    temp7-productid = `HT-1011`.
    temp7-quantity = 17.
    temp7-price = 2299.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `ITelO Vault Net`.
    temp7-productid = `HT-1020`.
    temp7-quantity = 14.
    temp7-price = 459.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `ITelO Vault SAT`.
    temp7-productid = `HT-1021`.
    temp7-quantity = 50.
    temp7-price = 149.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Comfort Easy`.
    temp7-productid = `HT-1022`.
    temp7-quantity = 30.
    temp7-price = 1679.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Comfort Senior`.
    temp7-productid = `HT-1023`.
    temp7-quantity = 24.
    temp7-price = 512.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Ergo Screen E-I`.
    temp7-productid = `HT-1030`.
    temp7-quantity = 14.
    temp7-price = 230.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Ergo Screen E-II`.
    temp7-productid = `HT-1031`.
    temp7-quantity = 24.
    temp7-price = 285.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Ergo Screen E-III`.
    temp7-productid = `HT-1032`.
    temp7-quantity = 50.
    temp7-price = 345.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Flat Basic`.
    temp7-productid = `HT-1035`.
    temp7-quantity = 23.
    temp7-price = 399.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Flat Future`.
    temp7-productid = `HT-1036`.
    temp7-quantity = 22.
    temp7-price = 430.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Flat XL`.
    temp7-productid = `HT-1037`.
    temp7-quantity = 23.
    temp7-price = 1230.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Laser Professional Eco`.
    temp7-productid = `HT-1040`.
    temp7-quantity = 21.
    temp7-price = 830.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Laser Basic`.
    temp7-productid = `HT-1041`.
    temp7-quantity = 8.
    temp7-price = 490.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Laser Allround`.
    temp7-productid = `HT-1042`.
    temp7-quantity = 9.
    temp7-price = 349.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Ultra Jet Super Color`.
    temp7-productid = `HT-1050`.
    temp7-quantity = 17.
    temp7-price = 139.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Ultra Jet Mobile`.
    temp7-productid = `HT-1051`.
    temp7-quantity = 18.
    temp7-price = 99.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Ultra Jet Super Highspeed`.
    temp7-productid = `HT-1052`.
    temp7-quantity = 25.
    temp7-price = 170.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Multi Print`.
    temp7-productid = `HT-1055`.
    temp7-quantity = 16.
    temp7-price = 99.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Multi Color`.
    temp7-productid = `HT-1056`.
    temp7-quantity = 5.
    temp7-price = 119.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Cordless Mouse`.
    temp7-productid = `HT-1060`.
    temp7-quantity = 25.
    temp7-price = 9.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Speed Mouse`.
    temp7-productid = `HT-1061`.
    temp7-quantity = 12.
    temp7-price = 7.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Track Mouse`.
    temp7-productid = `HT-1062`.
    temp7-quantity = 12.
    temp7-price = 11.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Ergonomic Keyboard`.
    temp7-productid = `HT-1063`.
    temp7-quantity = 50.
    temp7-price = 14.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Internet Keyboard`.
    temp7-productid = `HT-1064`.
    temp7-quantity = 35.
    temp7-price = 16.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Media Keyboard`.
    temp7-productid = `HT-1065`.
    temp7-quantity = 26.
    temp7-price = 26.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Mousepad`.
    temp7-productid = `HT-1066`.
    temp7-quantity = 12.
    temp7-price = `6.99`.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Ergo Mousepad`.
    temp7-productid = `HT-1067`.
    temp7-quantity = 16.
    temp7-price = `8.99`.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Designer Mousepad`.
    temp7-productid = `HT-1068`.
    temp7-quantity = 26.
    temp7-price = `12.99`.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Universal card reader`.
    temp7-productid = `HT-1069`.
    temp7-quantity = 22.
    temp7-price = 14.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Proctra X`.
    temp7-productid = `HT-1070`.
    temp7-quantity = 15.
    temp7-price = `70.9`.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Gladiator MX`.
    temp7-productid = `HT-1071`.
    temp7-quantity = 16.
    temp7-price = `81.7`.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Hurricane GX`.
    temp7-productid = `HT-1072`.
    temp7-quantity = 13.
    temp7-price = `101.2`.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Hurricane GX/LN`.
    temp7-productid = `HT-1073`.
    temp7-quantity = 5.
    temp7-price = `139.99`.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Photo Scan`.
    temp7-productid = `HT-1080`.
    temp7-quantity = 8.
    temp7-price = 129.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Power Scan`.
    temp7-productid = `HT-1081`.
    temp7-quantity = 11.
    temp7-price = 89.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Jet Scan Professional`.
    temp7-productid = `HT-1082`.
    temp7-quantity = 13.
    temp7-price = 169.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Jet Scan Professional`.
    temp7-productid = `HT-1083`.
    temp7-quantity = 10.
    temp7-price = 189.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Copymaster`.
    temp7-productid = `HT-1085`.
    temp7-quantity = 10.
    temp7-price = 1499.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Surround Sound`.
    temp7-productid = `HT-1090`.
    temp7-quantity = 20.
    temp7-price = 39.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Blaster Extreme`.
    temp7-productid = `HT-1091`.
    temp7-quantity = 15.
    temp7-price = 26.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Sound Booster`.
    temp7-productid = `HT-1092`.
    temp7-quantity = 50.
    temp7-price = 45.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Lovely Sound 5.1 Wireless`.
    temp7-productid = `HT-1095`.
    temp7-quantity = 12.
    temp7-price = 49.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Lovely Sound 5.1`.
    temp7-productid = `HT-1096`.
    temp7-quantity = 18.
    temp7-price = 39.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Lovely Sound Stereo`.
    temp7-productid = `HT-1097`.
    temp7-quantity = 21.
    temp7-price = 29.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Smart Office`.
    temp7-productid = `HT-1100`.
    temp7-quantity = 25.
    temp7-price = `89.9`.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Smart Design`.
    temp7-productid = `HT-1101`.
    temp7-quantity = 26.
    temp7-price = `79.9`.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Smart Network`.
    temp7-productid = `HT-1102`.
    temp7-quantity = 28.
    temp7-price = 69.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Smart Multimedia`.
    temp7-productid = `HT-1103`.
    temp7-quantity = 9.
    temp7-price = 77.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Smart Games`.
    temp7-productid = `HT-1104`.
    temp7-quantity = 13.
    temp7-price = 55.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Smart Internet Antivirus`.
    temp7-productid = `HT-1105`.
    temp7-quantity = 17.
    temp7-price = 29.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Smart Firewall`.
    temp7-productid = `HT-1106`.
    temp7-quantity = 19.
    temp7-price = 34.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Smart Money`.
    temp7-productid = `HT-1107`.
    temp7-quantity = 18.
    temp7-price = `29.9`.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `PC Lock`.
    temp7-productid = `HT-1110`.
    temp7-quantity = 14.
    temp7-price = `8.9`.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Notebook Lock`.
    temp7-productid = `HT-1111`.
    temp7-quantity = 20.
    temp7-price = `6.9`.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Web cam reality`.
    temp7-productid = `HT-1112`.
    temp7-quantity = 27.
    temp7-price = 39.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Screen clean`.
    temp7-productid = `HT-1113`.
    temp7-quantity = 17.
    temp7-price = `2.3`.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Fabric bag professional`.
    temp7-productid = `HT-1114`.
    temp7-quantity = 14.
    temp7-price = 31.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Wireless DSL Router`.
    temp7-productid = `HT-1115`.
    temp7-quantity = 16.
    temp7-price = 49.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Wireless DSL Router / Repeater`.
    temp7-productid = `HT-1116`.
    temp7-quantity = 12.
    temp7-price = 59.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Wireless DSL Router / Repeater and Print Server`.
    temp7-productid = `HT-1117`.
    temp7-quantity = 12.
    temp7-price = 69.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `USB Stick`.
    temp7-productid = `HT-1118`.
    temp7-quantity = 14.
    temp7-price = 35.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Travel Adapter`.
    temp7-productid = `HT-1119`.
    temp7-quantity = 10.
    temp7-price = 79.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Cordless Bluetooth Keyboard, english international`.
    temp7-productid = `HT-1120`.
    temp7-quantity = 13.
    temp7-price = 29.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Flat XXL`.
    temp7-productid = `HT-1137`.
    temp7-quantity = 10.
    temp7-price = 1430.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Pocket Mouse`.
    temp7-productid = `HT-1138`.
    temp7-quantity = 20.
    temp7-price = 23.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `PC Power Station`.
    temp7-productid = `HT-1210`.
    temp7-quantity = 22.
    temp7-price = 2399.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Astro Laptop 1516`.
    temp7-productid = `HT-1251`.
    temp7-quantity = 23.
    temp7-price = 989.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Astro Phone 6`.
    temp7-productid = `HT-1252`.
    temp7-quantity = 28.
    temp7-price = 649.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Benda Laptop 1408`.
    temp7-productid = `HT-1253`.
    temp7-quantity = 27.
    temp7-price = 976.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Bending Screen 21HD`.
    temp7-productid = `HT-1254`.
    temp7-quantity = 23.
    temp7-price = 250.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Broad Screen 22HD`.
    temp7-productid = `HT-1255`.
    temp7-quantity = 5.
    temp7-price = 270.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Cerdik Phone 7`.
    temp7-productid = `HT-1256`.
    temp7-quantity = 19.
    temp7-price = 549.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Cepat Tablet 10.5`.
    temp7-productid = `HT-1257`.
    temp7-quantity = 17.
    temp7-price = 549.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Cepat Tablet 8`.
    temp7-productid = `HT-1258`.
    temp7-quantity = 24.
    temp7-price = 529.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Server Basic`.
    temp7-productid = `HT-1500`.
    temp7-quantity = 24.
    temp7-price = 5000.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Server Professional`.
    temp7-productid = `HT-1501`.
    temp7-quantity = 26.
    temp7-price = 15000.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Server Power Pro`.
    temp7-productid = `HT-1502`.
    temp7-quantity = 34.
    temp7-price = 25000.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Family PC Basic`.
    temp7-productid = `HT-1600`.
    temp7-quantity = 10.
    temp7-price = 600.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Family PC Pro`.
    temp7-productid = `HT-1601`.
    temp7-quantity = 20.
    temp7-price = 900.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Gaming Monster`.
    temp7-productid = `HT-1602`.
    temp7-quantity = 24.
    temp7-price = 1200.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Gaming Monster Pro`.
    temp7-productid = `HT-1603`.
    temp7-quantity = 25.
    temp7-price = 1700.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `7" Widescreen Portable DVD Player w MP3`.
    temp7-productid = `HT-2000`.
    temp7-quantity = 20.
    temp7-price = `249.99`.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `10" Portable DVD player`.
    temp7-productid = `HT-2001`.
    temp7-quantity = 21.
    temp7-price = `449.99`.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Portable DVD Player with 9" LCD Monitor`.
    temp7-productid = `HT-2002`.
    temp7-quantity = 50.
    temp7-price = `853.99`.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `CD/DVD case: 264 sleeves`.
    temp7-productid = `HT-2025`.
    temp7-quantity = 26.
    temp7-price = `44.99`.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Audio/Video Cable Kit - 4m`.
    temp7-productid = `HT-2026`.
    temp7-quantity = 16.
    temp7-price = `29.99`.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Removable CD/DVD Laser Labels`.
    temp7-productid = `HT-2027`.
    temp7-quantity = 25.
    temp7-price = `8.99`.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Beam Breaker B-1`.
    temp7-productid = `HT-6100`.
    temp7-quantity = 32.
    temp7-price = 469.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Beam Breaker B-2`.
    temp7-productid = `HT-6101`.
    temp7-quantity = 18.
    temp7-price = 679.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Beam Breaker B-3`.
    temp7-productid = `HT-6102`.
    temp7-quantity = 16.
    temp7-price = 889.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Play Movie`.
    temp7-productid = `HT-6110`.
    temp7-quantity = 15.
    temp7-price = 130.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Record Movie`.
    temp7-productid = `HT-6111`.
    temp7-quantity = 24.
    temp7-price = 288.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `ITelo MusicStick`.
    temp7-productid = `HT-6120`.
    temp7-quantity = 15.
    temp7-price = 45.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `ITelo Jog-Mate`.
    temp7-productid = `HT-6121`.
    temp7-quantity = 24.
    temp7-price = 63.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Power Pro Player 40`.
    temp7-productid = `HT-6122`.
    temp7-quantity = 23.
    temp7-price = 167.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Power Pro Player 80`.
    temp7-productid = `HT-6123`.
    temp7-quantity = 13.
    temp7-price = 299.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Flat Watch HD32`.
    temp7-productid = `HT-6130`.
    temp7-quantity = 16.
    temp7-price = 1459.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Flat Watch HD37`.
    temp7-productid = `HT-6131`.
    temp7-quantity = 14.
    temp7-price = 1199.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Flat Watch HD41`.
    temp7-productid = `HT-6132`.
    temp7-quantity = 13.
    temp7-price = 899.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Copperberry`.
    temp7-productid = `HT-7000`.
    temp7-quantity = 5.
    temp7-price = 549.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Silverberry`.
    temp7-productid = `HT-7010`.
    temp7-quantity = 9.
    temp7-price = 549.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Goldberry`.
    temp7-productid = `HT-7020`.
    temp7-quantity = 11.
    temp7-price = 549.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Platinberry`.
    temp7-productid = `HT-7030`.
    temp7-quantity = 12.
    temp7-price = 549.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `ITelO FlexTop I4000`.
    temp7-productid = `HT-8000`.
    temp7-quantity = 11.
    temp7-price = 799.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `ITelO FlexTop I6300c`.
    temp7-productid = `HT-8001`.
    temp7-quantity = 20.
    temp7-price = 799.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `ITelO FlexTop I9100`.
    temp7-productid = `HT-8002`.
    temp7-quantity = 20.
    temp7-price = 1199.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `ITelO FlexTop I9800`.
    temp7-productid = `HT-8003`.
    temp7-quantity = 22.
    temp7-price = 1388.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Smartphone Leather Case`.
    temp7-productid = `HT-9991`.
    temp7-quantity = 12.
    temp7-price = 25.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Smartphone Alpha`.
    temp7-productid = `HT-9992`.
    temp7-quantity = 13.
    temp7-price = 599.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Mini Tablet`.
    temp7-productid = `HT-9993`.
    temp7-quantity = 10.
    temp7-price = 833.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Camcorder View`.
    temp7-productid = `HT-9994`.
    temp7-quantity = 50.
    temp7-price = 1388.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Tablet Pouch`.
    temp7-productid = `HT-9995`.
    temp7-quantity = 34.
    temp7-price = 20.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Tablet Pouch`.
    temp7-productid = `HT-9996`.
    temp7-quantity = 34.
    temp7-price = 20.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `e-Book Reader ReadMe`.
    temp7-productid = `HT-9997`.
    temp7-quantity = 23.
    temp7-price = 33.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Smartphone Beta`.
    temp7-productid = `HT-9998`.
    temp7-quantity = 21.
    temp7-price = 30.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Maxi Tablet`.
    temp7-productid = `HT-9999`.
    temp7-quantity = 20.
    temp7-price = 749.
    temp7-currencycode = `EUR`.
    temp7-available = abap_true.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Flyer`.
    temp7-productid = `PF-1000`.
    temp7-quantity = 33.
    temp7-price = 0.
    temp7-currencycode = `EUR`.
    temp7-available = abap_false.
    INSERT temp7 INTO TABLE temp6.
    t_products = temp6.

  ENDMETHOD.

ENDCLASS.
