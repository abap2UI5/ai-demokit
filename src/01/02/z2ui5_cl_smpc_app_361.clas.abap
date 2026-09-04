" @keywords table sap.ui.table selection label select item overflowtoolbar title toolbarspacer button switch column
" @summary Selection example showing selection modes and selection behaviors of table.
CLASS z2ui5_cl_smpc_app_361 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name           TYPE string,
        productid      TYPE string,
        quantity       TYPE i,
        status         TYPE string,
        availablestate TYPE string,
        availableicon  TYPE string,
        price          TYPE p LENGTH 13 DECIMALS 2,
        currencycode   TYPE string,
        suppliername   TYPE string,
        productpicurl  TYPE string,
        heavy          TYPE string,
        category       TYPE string,
        deliverydate   TYPE string,
      END OF ty_s_product,
      BEGIN OF ty_s_name,
        name TYPE string,
      END OF ty_s_name,
      BEGIN OF ty_s_key,
        key  TYPE string,
        text TYPE string,
      END OF ty_s_key.
    DATA t_products   TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.
    DATA t_suppliers  TYPE STANDARD TABLE OF ty_s_name WITH DEFAULT KEY.
    DATA t_categories TYPE STANDARD TABLE OF ty_s_name WITH DEFAULT KEY.

    " the two Selects of the original's `selectionmodel>` model, folded onto
    " the one default model
    DATA t_selectionitems TYPE STANDARD TABLE OF ty_s_key WITH DEFAULT KEY.
    DATA t_behavioritems  TYPE STANDARD TABLE OF ty_s_key WITH DEFAULT KEY.

    " the Select's own key and the Table's selectionMode are two SEPARATE
    " fields, because onSelectionModeChange REFUSES the deprecated All mode -
    " the change handler copies the one into the other unless it is All
    DATA select_mode_key    TYPE string.
    DATA selection_mode     TYPE string.
    DATA selection_behavior TYPE string.
    DATA enable_select_all  TYPE abap_bool.

    " the current selection, kept in the model by rowSelectionChange so the
    " three toolbar buttons can report it without reading the control
    DATA selected_indices TYPE string.
    DATA selected_index   TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_361 IMPLEMENTATION.

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

    " the selection demo: selectionMode, selectionBehavior and enableSelectAll
    " are bound properties driven by the two Selects and the Switch, and the
    " table reports its selection through rowSelectionChange so the three
    " toolbar buttons can report it from the model.
    
    CLEAR temp1.
    INSERT `${$source>}.getSelectedIndices()` INTO TABLE temp1.
    INSERT `${$source>}.getSelectedIndex()` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `MESSAGE_TOAST` INTO TABLE temp2.
    INSERT `show` INTO TABLE temp2.
    INSERT `Details for product with id {0}` INTO TABLE temp2.
    INSERT `${PRODUCTID}` INTO TABLE temp2.
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
                )->tag( n = `Label` ns = `m`
                    )->a( n = `text`     v = `Selection Mode`
                    )->a( n = `labelFor` v = `select1`

                )->ele( n = `Select` ns = `m`
                    )->a( n = `id`          v = `select1`
                    )->a( n = `width`       v = `100%`
                    )->a( n = `items`       v = client->_bind( t_selectionitems )
                    )->a( n = `selectedKey` v = client->_bind( select_mode_key )
                    )->a( n = `change`      v = client->_event( `MODE_CHANGE` )

                    )->tag( n = `Item` ns = `c`
                        )->a( n = `key`  v = `{KEY}`
                        )->a( n = `text` v = `{TEXT}`

                )->end(
                )->tag( n = `Label` ns = `m`
                    )->a( n = `text`     v = `Selection Behavior`
                    )->a( n = `labelFor` v = `select2`

                )->ele( n = `Select` ns = `m`
                    )->a( n = `id`          v = `select2`
                    )->a( n = `width`       v = `100%`
                    )->a( n = `items`       v = client->_bind( t_behavioritems )
                    )->a( n = `selectedKey` v = client->_bind( selection_behavior )

                    )->tag( n = `Item` ns = `c`
                        )->a( n = `key`  v = `{KEY}`
                        )->a( n = `text` v = `{TEXT}`

                )->end(
                )->ele( `Table`
                    )->a( n = `id`                 v = `table1`
                    )->a( n = `rows`               v = client->_bind( t_products )
                    )->a( n = `selectionMode`      v = client->_bind( selection_mode )
                    )->a( n = `selectionBehavior`  v = client->_bind( selection_behavior )
                    )->a( n = `enableSelectAll`    v = client->_bind( enable_select_all )
                    " The three buttons all read the table's CURRENT selection,
                    " so the wire has to carry that - not the event's delta.
                    " rowIndices is documented as "array of row indices which
                    " selection has been changed (either selected or
                    " deselected)", so ctrl-clicking a second row reported [1]
                    " where the original reports [0,1], and deselecting the only
                    " selected row reported [0] where the original says "no item
                    " selected". Ask the source control, exactly as
                    " getSelectedIndices( ) does (the idiom app 356 uses on this
                    " same control).
                    )->a( n = `rowSelectionChange` v = client->_event(
                              val   = `SELECTION_CHANGE`
                              t_arg = temp1 )
                    )->a( n = `ariaLabelledBy`     v = `title`

                    )->ele( `extension`
                        )->ele( n = `OverflowToolbar` ns = `m`
                            )->a( n = `style` v = `Clear`

                            )->tag( n = `Title` ns = `m`
                                )->a( n = `id`   v = `title`
                                )->a( n = `text` v = `Products`

                            )->tag( n = `ToolbarSpacer` ns = `m`

                            )->tag( n = `Button` ns = `m`
                                )->a( n = `icon`    v = `sap-icon://activities`
                                )->a( n = `tooltip` v = `show indices of selected items`
                                )->a( n = `press`   v = client->_event( `SHOW_INDICES` )

                            )->tag( n = `Button` ns = `m`
                                )->a( n = `icon`    v = `sap-icon://activity-items`
                                )->a( n = `tooltip` v = `show context of latest selection item`
                                )->a( n = `press`   v = client->_event( `SHOW_CONTEXT` )

                            )->tag( n = `Button` ns = `m`
                                )->a( n = `icon`    v = `sap-icon://decline`
                                )->a( n = `tooltip` v = `clear selection`
                                )->a( n = `press`   v = client->_event( `CLEAR_SELECTION` )

                            )->tag( n = `Switch` ns = `m`
                                )->a( n = `state`         v = client->_bind( enable_select_all )
                                )->a( n = `customTextOn`  v = `on`
                                )->a( n = `customTextOff` v = `off`
                                )->a( n = `tooltip`       v = `enable select all items`

                        )->end(
                    )->end(
                    )->ele( `columns`
                        )->ele( `Column`
                            )->a( n = `width` v = `11rem`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Product Name`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{NAME}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `width` v = `11rem`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Product Id`

                            )->ele( `template`
                                )->tag( n = `Input` ns = `m`
                                    )->a( n = `value` v = `{PRODUCTID}`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `width`  v = `6rem`
                            )->a( n = `hAlign` v = `End`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Quantity`

                            )->ele( `template`
                                )->tag( n = `Label` ns = `m`
                                    )->a( n = `text` v = `{QUANTITY}`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `width` v = `9rem`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Status`

                            )->ele( `template`
                                )->tag( n = `ObjectStatus` ns = `m`
                                    )->a( n = `text`  v = `{STATUS}`
                                    )->a( n = `state` v = `{AVAILABLESTATE}`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `width` v = `9rem`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Price`

                            )->ele( `template`
                                )->tag( n = `Currency` ns = `u`
                                    )->a( n = `value`    v = `{PRICE}`
                                    )->a( n = `currency` v = `{CURRENCYCODE}`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `width` v = `12rem`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Supplier`

                            )->ele( `template`
                                )->ele( n = `ComboBox` ns = `m`
                                    )->a( n = `value` v = `{SUPPLIERNAME}`
                                    )->a( n = `items` v = |\{ path: '{ client->_bind_path( t_suppliers ) }', templateShareable: false \}|

                                    )->tag( n = `Item` ns = `c`
                                        )->a( n = `text` v = `{NAME}`

                                )->end(
                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `width` v = `9rem`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Image`

                            )->ele( `template`
                                )->tag( n = `Link` ns = `m`
                                    )->a( n = `text`   v = `Show Image`
                                    )->a( n = `href`   v = `{PRODUCTPICURL}`
                                    )->a( n = `target` v = `_blank`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `width` v = `9rem`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Details`

                            )->ele( `template`
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `text`  v = `Show Details`
                                    )->a( n = `press` v = client->follow_up_action(
                                              val   = client->cs_event-control_global
                                              t_arg = temp2 )

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `width` v = `7rem`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Heavy Weight`

                            )->ele( `template`
                                )->tag( n = `CheckBox` ns = `m`
                                    )->a( n = `selected` v = |\{ path: 'HEAVY', type: 'sap.ui.model.type.String' \}|

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `width` v = `12rem`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Category`

                            )->ele( `template`
                                )->ele( n = `Select` ns = `m`
                                    )->a( n = `selectedKey` v = `{CATEGORY}`
                                    )->a( n = `items`       v = |\{ path: '{ client->_bind_path( t_categories ) }', templateShareable: false \}|

                                    )->tag( n = `Item` ns = `c`
                                        )->a( n = `text` v = `{NAME}`
                                        )->a( n = `key`  v = `{NAME}`

                                )->end(
                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `width`  v = `6rem`
                            )->a( n = `hAlign` v = `Center`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Status`

                            )->ele( `template`
                                )->tag( n = `Icon` ns = `c`
                                    )->a( n = `src` v = `{AVAILABLEICON}`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `width`  v = `11rem`
                            )->a( n = `hAlign` v = `Center`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Delivery Date`

                            )->ele( `template`
                                )->tag( n = `DatePicker` ns = `m`
                                    )->a( n = `value` v = |\{ path: 'DELIVERYDATE', type: 'sap.ui.model.type.Date', formatOptions: \{ source: \{ pattern: 'timestamp' \} \} \}|

                            )->end(
                        )->end(
                    )->end(
                )->end(
            )->end(
        )->end(
    )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA temp3 TYPE string.
        DATA temp4 TYPE string.
        DATA temp5 TYPE string_table.

    CASE client->get_event( ).

      WHEN `MODE_CHANGE`.
        " onSelectionModeChange: All is deprecated and is refused - the table
        " keeps the mode it had and the Select snaps back to it
        IF select_mode_key = `All`.
          client->message_toast_display( `selectionMode:All is deprecated. Please select another one.` ).
          select_mode_key = selection_mode.
        ELSE.
          selection_mode = select_mode_key.
        ENDIF.

      WHEN `SELECTION_CHANGE`.
        " the table's own selection is control state, so it is mirrored into
        " the model here - that is what makes the three buttons expressible
        selected_indices = client->get_event_arg( ).
        selected_index   = client->get_event_arg( 2 ).

      WHEN `SHOW_INDICES`.
        " getSelectedIndices: the original toasts the ARRAY, which MessageToast
        " coerces to "0,1" - the JSON brackets the wire carries are not part of
        " what the sample shows
        
        IF selected_indices IS INITIAL OR selected_indices = `[]`.
          temp3 = `no item selected`.
        ELSE.
          temp3 = condense( translate( val = selected_indices from = `[]` to = `  ` ) ).
        ENDIF.
        client->message_toast_display( temp3 ).

      WHEN `SHOW_CONTEXT`.
        " getContextByIndex: the original toasts the binding context of the
        " last selected row, which renders as its model path
        
        IF selected_indices IS INITIAL OR selected_indices = `[]`.
          temp4 = `no item selected`.
        ELSE.
          temp4 = |{ client->_bind_path( t_products ) }/{ selected_index }|.
        ENDIF.
        client->message_toast_display( temp4 ).

      WHEN `CLEAR_SELECTION`.
        " clearSelection: the selection lives in the control, so it is cleared
        " there - and the mirrored model state goes with it
        
        CLEAR temp5.
        INSERT `table1` INTO TABLE temp5.
        INSERT `clearSelection` INTO TABLE temp5.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = temp5 ).
        selected_indices = ``.
        selected_index   = 0.

    ENDCASE.


  ENDMETHOD.


  METHOD model_init.

    " the two Select item sets the controller builds from the sap.ui.table
    " SelectionMode / SelectionBehavior enums, in the Object.keys order it
    " walks them (Multi is skipped, as there). Until 2026-08-21 the first list
    " carried a fourth entry `All`, which is not a member of SelectionMode at
    " all, and both lists were in an order the enums do not have - while the
    " sidecar asserted they were the enum members as of the current release.
    " Unlike app 356, where the same wrong entry crashes, here on_event refuses
    " `All` before it can reach selection_mode; it still put an item on screen
    " the original never shows, and turned a DEAD upstream branch into a live
    " one. The guard stays - it is a faithful copy of that dead code.
    DATA temp7 LIKE t_selectionitems.
    DATA temp8 LIKE LINE OF temp7.
    DATA temp9 LIKE t_behavioritems.
    DATA temp10 LIKE LINE OF temp9.
    DATA temp11 LIKE t_products.
    DATA temp12 LIKE LINE OF temp11.
    DATA temp13 LIKE t_suppliers.
    DATA temp14 LIKE LINE OF temp13.
    DATA temp15 LIKE t_categories.
    DATA temp16 LIKE LINE OF temp15.
    CLEAR temp7.
    
    temp8-key = `MultiToggle`.
    temp8-text = `MultiToggle`.
    INSERT temp8 INTO TABLE temp7.
    temp8-key = `Single`.
    temp8-text = `Single`.
    INSERT temp8 INTO TABLE temp7.
    temp8-key = `None`.
    temp8-text = `None`.
    INSERT temp8 INTO TABLE temp7.
    t_selectionitems = temp7.

    
    CLEAR temp9.
    
    temp10-key = `Row`.
    temp10-text = `Row`.
    INSERT temp10 INTO TABLE temp9.
    temp10-key = `RowSelector`.
    temp10-text = `RowSelector`.
    INSERT temp10 INTO TABLE temp9.
    temp10-key = `RowOnly`.
    temp10-text = `RowOnly`.
    INSERT temp10 INTO TABLE temp9.
    t_behavioritems = temp9.

    " the view's initial selectedKey values, and the Switch's state="true"
    select_mode_key    = `MultiToggle`.
    selection_mode     = `MultiToggle`.
    selection_behavior = `RowSelector`.
    enable_select_all  = abap_true.

    " the shared 123-row demo ProductCollection (sap/ui/demo/mock/products.json)
    " with the columns the twelve table columns bind. DeliveryDate is
    " Date.now()-derived in the original (i mod 10 offset in 4-day steps); a
    " fixed base (2026-07-23) is used here so the port is deterministic - the
    " corpus convention of app 164. Heavy is WeightMeasure > 1000 as the string
    " the typed CheckBox binding expects, and the two Available formatters of
    " the controller are precomputed into AVAILABLESTATE / AVAILABLEICON.
    
    CLEAR temp11.
    
    temp12-name = `Notebook Basic 15`.
    temp12-productid = `HT-1000`.
    temp12-quantity = 10.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 956.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Very Best Screens`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Laptops`.
    temp12-deliverydate = 1784764800000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Notebook Basic 17`.
    temp12-productid = `HT-1001`.
    temp12-quantity = 20.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 1249.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Very Best Screens`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1001.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Laptops`.
    temp12-deliverydate = 1784419200000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Notebook Basic 18`.
    temp12-productid = `HT-1002`.
    temp12-quantity = 10.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 1570.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Very Best Screens`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1002.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Laptops`.
    temp12-deliverydate = 1784073600000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Notebook Basic 19`.
    temp12-productid = `HT-1003`.
    temp12-quantity = 15.
    temp12-status = `Out of Stock`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = 1650.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Smartcards`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1003.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Laptops`.
    temp12-deliverydate = 1783728000000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `ITelO Vault`.
    temp12-productid = `HT-1007`.
    temp12-quantity = 15.
    temp12-status = `Out of Stock`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = 299.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Technocom`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1007.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Accessories`.
    temp12-deliverydate = 1783382400000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Notebook Professional 15`.
    temp12-productid = `HT-1010`.
    temp12-quantity = 16.
    temp12-status = `Out of Stock`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = 1999.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Very Best Screens`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Accessories`.
    temp12-deliverydate = 1783036800000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Notebook Professional 17`.
    temp12-productid = `HT-1011`.
    temp12-quantity = 17.
    temp12-status = `Out of Stock`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = 2299.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Very Best Screens`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1011.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Laptops`.
    temp12-deliverydate = 1782691200000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `ITelO Vault Net`.
    temp12-productid = `HT-1020`.
    temp12-quantity = 14.
    temp12-status = `Discontinued`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = 459.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Technocom`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1020.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Accessories`.
    temp12-deliverydate = 1782345600000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `ITelO Vault SAT`.
    temp12-productid = `HT-1021`.
    temp12-quantity = 50.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 149.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Technocom`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1021.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Accessories`.
    temp12-deliverydate = 1782000000000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Comfort Easy`.
    temp12-productid = `HT-1022`.
    temp12-quantity = 30.
    temp12-status = `Out of Stock`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = 1679.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Technocom`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1022.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Accessories`.
    temp12-deliverydate = 1781654400000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Comfort Senior`.
    temp12-productid = `HT-1023`.
    temp12-quantity = 24.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 512.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Technocom`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1023.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Accessories`.
    temp12-deliverydate = 1784764800000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Ergo Screen E-I`.
    temp12-productid = `HT-1030`.
    temp12-quantity = 14.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 230.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Very Best Screens`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1030.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Flat Screen Monitors`.
    temp12-deliverydate = 1784419200000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Ergo Screen E-II`.
    temp12-productid = `HT-1031`.
    temp12-quantity = 24.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 285.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Very Best Screens`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1031.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Flat Screen Monitors`.
    temp12-deliverydate = 1784073600000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Ergo Screen E-III`.
    temp12-productid = `HT-1032`.
    temp12-quantity = 50.
    temp12-status = `Out of Stock`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = 345.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Very Best Screens`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1032.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Flat Screen Monitors`.
    temp12-deliverydate = 1783728000000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Flat Basic`.
    temp12-productid = `HT-1035`.
    temp12-quantity = 23.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 399.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Very Best Screens`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1035.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Flat Screen Monitors`.
    temp12-deliverydate = 1783382400000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Flat Future`.
    temp12-productid = `HT-1036`.
    temp12-quantity = 22.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 430.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Very Best Screens`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1036.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Flat Screen Monitors`.
    temp12-deliverydate = 1783036800000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Flat XL`.
    temp12-productid = `HT-1037`.
    temp12-quantity = 23.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 1230.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Very Best Screens`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1037.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Flat Screen Monitors`.
    temp12-deliverydate = 1782691200000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Laser Professional Eco`.
    temp12-productid = `HT-1040`.
    temp12-quantity = 21.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 830.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Alpha Printers`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1040.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Printers`.
    temp12-deliverydate = 1782345600000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Laser Basic`.
    temp12-productid = `HT-1041`.
    temp12-quantity = 8.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 490.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Alpha Printers`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1041.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Printers`.
    temp12-deliverydate = 1782000000000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Laser Allround`.
    temp12-productid = `HT-1042`.
    temp12-quantity = 9.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 349.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Alpha Printers`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1042.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Printers`.
    temp12-deliverydate = 1781654400000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Ultra Jet Super Color`.
    temp12-productid = `HT-1050`.
    temp12-quantity = 17.
    temp12-status = `Discontinued`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = 139.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Alpha Printers`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1050.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Printers`.
    temp12-deliverydate = 1784764800000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Ultra Jet Mobile`.
    temp12-productid = `HT-1051`.
    temp12-quantity = 18.
    temp12-status = `Discontinued`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = 99.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Printer for All`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1051.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Printers`.
    temp12-deliverydate = 1784419200000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Ultra Jet Super Highspeed`.
    temp12-productid = `HT-1052`.
    temp12-quantity = 25.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 170.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Printer for All`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1052.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Printers`.
    temp12-deliverydate = 1784073600000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Multi Print`.
    temp12-productid = `HT-1055`.
    temp12-quantity = 16.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 99.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Printer for All`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1055.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Multifunction Printers`.
    temp12-deliverydate = 1783728000000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Multi Color`.
    temp12-productid = `HT-1056`.
    temp12-quantity = 5.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 119.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Printer for All`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1056.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Multifunction Printers`.
    temp12-deliverydate = 1783382400000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Cordless Mouse`.
    temp12-productid = `HT-1060`.
    temp12-quantity = 25.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 9.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Oxynum`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1060.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Mice`.
    temp12-deliverydate = 1783036800000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Speed Mouse`.
    temp12-productid = `HT-1061`.
    temp12-quantity = 12.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 7.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Oxynum`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1061.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Mice`.
    temp12-deliverydate = 1782691200000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Track Mouse`.
    temp12-productid = `HT-1062`.
    temp12-quantity = 12.
    temp12-status = `Discontinued`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = 11.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Oxynum`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1062.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Mice`.
    temp12-deliverydate = 1782345600000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Ergonomic Keyboard`.
    temp12-productid = `HT-1063`.
    temp12-quantity = 50.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 14.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Oxynum`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1063.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Keyboards`.
    temp12-deliverydate = 1782000000000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Internet Keyboard`.
    temp12-productid = `HT-1064`.
    temp12-quantity = 35.
    temp12-status = `Out of Stock`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = 16.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Oxynum`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1064.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Keyboards`.
    temp12-deliverydate = 1781654400000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Media Keyboard`.
    temp12-productid = `HT-1065`.
    temp12-quantity = 26.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 26.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Oxynum`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1065.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Keyboards`.
    temp12-deliverydate = 1784764800000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Mousepad`.
    temp12-productid = `HT-1066`.
    temp12-quantity = 12.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = `6.99`.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Oxynum`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1066.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Mousepads`.
    temp12-deliverydate = 1784419200000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Ergo Mousepad`.
    temp12-productid = `HT-1067`.
    temp12-quantity = 16.
    temp12-status = `Out of Stock`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = `8.99`.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Oxynum`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1067.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Mousepads`.
    temp12-deliverydate = 1784073600000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Designer Mousepad`.
    temp12-productid = `HT-1068`.
    temp12-quantity = 26.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = `12.99`.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Fasttech`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1068.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Mousepads`.
    temp12-deliverydate = 1783728000000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Universal card reader`.
    temp12-productid = `HT-1069`.
    temp12-quantity = 22.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 14.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Fasttech`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1069.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Computer System Accessories`.
    temp12-deliverydate = 1783382400000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Proctra X`.
    temp12-productid = `HT-1070`.
    temp12-quantity = 15.
    temp12-status = `Out of Stock`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = `70.9`.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Ultrasonic United`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1070.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Graphic Cards`.
    temp12-deliverydate = 1783036800000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Gladiator MX`.
    temp12-productid = `HT-1071`.
    temp12-quantity = 16.
    temp12-status = `Discontinued`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = `81.7`.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Ultrasonic United`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1071.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Graphic Cards`.
    temp12-deliverydate = 1782691200000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Hurricane GX`.
    temp12-productid = `HT-1072`.
    temp12-quantity = 13.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = `101.2`.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Ultrasonic United`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1072.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Graphic Cards`.
    temp12-deliverydate = 1782345600000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Hurricane GX/LN`.
    temp12-productid = `HT-1073`.
    temp12-quantity = 5.
    temp12-status = `Out of Stock`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = `139.99`.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Smartcards`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1073.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Graphic Cards`.
    temp12-deliverydate = 1782000000000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Photo Scan`.
    temp12-productid = `HT-1080`.
    temp12-quantity = 8.
    temp12-status = `Out of Stock`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = 129.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Printer for All`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1080.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Scanners`.
    temp12-deliverydate = 1781654400000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Power Scan`.
    temp12-productid = `HT-1081`.
    temp12-quantity = 11.
    temp12-status = `Out of Stock`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = 89.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Printer for All`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1081.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Scanners`.
    temp12-deliverydate = 1784764800000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Jet Scan Professional`.
    temp12-productid = `HT-1082`.
    temp12-quantity = 13.
    temp12-status = `Out of Stock`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = 169.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Printer for All`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1082.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Scanners`.
    temp12-deliverydate = 1784419200000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Jet Scan Professional`.
    temp12-productid = `HT-1083`.
    temp12-quantity = 10.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 189.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Printer for All`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1083.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Scanners`.
    temp12-deliverydate = 1784073600000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Copymaster`.
    temp12-productid = `HT-1085`.
    temp12-quantity = 10.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 1499.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Alpha Printers`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1085.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Multifunction Printers`.
    temp12-deliverydate = 1783728000000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Surround Sound`.
    temp12-productid = `HT-1090`.
    temp12-quantity = 20.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 39.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Speaker Experts`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1090.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Speakers`.
    temp12-deliverydate = 1783382400000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Blaster Extreme`.
    temp12-productid = `HT-1091`.
    temp12-quantity = 15.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 26.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Speaker Experts`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1091.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Speakers`.
    temp12-deliverydate = 1783036800000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Sound Booster`.
    temp12-productid = `HT-1092`.
    temp12-quantity = 50.
    temp12-status = `Discontinued`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = 45.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Speaker Experts`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1092.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Speakers`.
    temp12-deliverydate = 1782691200000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Lovely Sound 5.1 Wireless`.
    temp12-productid = `HT-1095`.
    temp12-quantity = 12.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 49.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Fasttech`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1095.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Accessories`.
    temp12-deliverydate = 1782345600000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Lovely Sound 5.1`.
    temp12-productid = `HT-1096`.
    temp12-quantity = 18.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 39.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Fasttech`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1096.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Accessories`.
    temp12-deliverydate = 1782000000000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Lovely Sound Stereo`.
    temp12-productid = `HT-1097`.
    temp12-quantity = 21.
    temp12-status = `Out of Stock`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = 29.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Fasttech`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1097.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Accessories`.
    temp12-deliverydate = 1781654400000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Smart Office`.
    temp12-productid = `HT-1100`.
    temp12-quantity = 25.
    temp12-status = `Out of Stock`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = `89.9`.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Technocom`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1100.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Software`.
    temp12-deliverydate = 1784764800000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Smart Design`.
    temp12-productid = `HT-1101`.
    temp12-quantity = 26.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = `79.9`.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Technocom`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1101.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Software`.
    temp12-deliverydate = 1784419200000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Smart Network`.
    temp12-productid = `HT-1102`.
    temp12-quantity = 28.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 69.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Technocom`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1102.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Software`.
    temp12-deliverydate = 1784073600000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Smart Multimedia`.
    temp12-productid = `HT-1103`.
    temp12-quantity = 9.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 77.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Technocom`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1103.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Software`.
    temp12-deliverydate = 1783728000000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Smart Games`.
    temp12-productid = `HT-1104`.
    temp12-quantity = 13.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 55.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Technocom`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1104.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Software`.
    temp12-deliverydate = 1783382400000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Smart Internet Antivirus`.
    temp12-productid = `HT-1105`.
    temp12-quantity = 17.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 29.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Brainsoft`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1105.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Software`.
    temp12-deliverydate = 1783036800000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Smart Firewall`.
    temp12-productid = `HT-1106`.
    temp12-quantity = 19.
    temp12-status = `Discontinued`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = 34.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Brainsoft`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1106.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Software`.
    temp12-deliverydate = 1782691200000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Smart Money`.
    temp12-productid = `HT-1107`.
    temp12-quantity = 18.
    temp12-status = `Out of Stock`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = `29.9`.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Brainsoft`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1107.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Software`.
    temp12-deliverydate = 1782345600000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `PC Lock`.
    temp12-productid = `HT-1110`.
    temp12-quantity = 14.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = `8.9`.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Red Point Stores`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1110.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Computer System Accessories`.
    temp12-deliverydate = 1782000000000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Notebook Lock`.
    temp12-productid = `HT-1111`.
    temp12-quantity = 20.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = `6.9`.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Red Point Stores`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1111.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Computer System Accessories`.
    temp12-deliverydate = 1781654400000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Web cam reality`.
    temp12-productid = `HT-1112`.
    temp12-quantity = 27.
    temp12-status = `Out of Stock`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = 39.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Red Point Stores`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1112.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Computer System Accessories`.
    temp12-deliverydate = 1784764800000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Screen clean`.
    temp12-productid = `HT-1113`.
    temp12-quantity = 17.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = `2.3`.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Red Point Stores`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1113.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Computer System Accessories`.
    temp12-deliverydate = 1784419200000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Fabric bag professional`.
    temp12-productid = `HT-1114`.
    temp12-quantity = 14.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 31.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Red Point Stores`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1114.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Computer System Accessories`.
    temp12-deliverydate = 1784073600000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Wireless DSL Router`.
    temp12-productid = `HT-1115`.
    temp12-quantity = 16.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 49.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Red Point Stores`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1115.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Telecommunications`.
    temp12-deliverydate = 1783728000000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Wireless DSL Router / Repeater`.
    temp12-productid = `HT-1116`.
    temp12-quantity = 12.
    temp12-status = `Out of Stock`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = 59.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Red Point Stores`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1116.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Telecommunications`.
    temp12-deliverydate = 1783382400000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Wireless DSL Router / Repeater and Print Server`.
    temp12-productid = `HT-1117`.
    temp12-quantity = 12.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 69.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Technocom`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1117.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Telecommunications`.
    temp12-deliverydate = 1783036800000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `USB Stick`.
    temp12-productid = `HT-1118`.
    temp12-quantity = 14.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 35.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Technocom`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1118.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Computer System Accessories`.
    temp12-deliverydate = 1782691200000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Travel Adapter`.
    temp12-productid = `HT-1119`.
    temp12-quantity = 10.
    temp12-status = `Discontinued`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = 79.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Titanium`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1119.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Accessories`.
    temp12-deliverydate = 1782345600000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Cordless Bluetooth Keyboard, english international`.
    temp12-productid = `HT-1120`.
    temp12-quantity = 13.
    temp12-status = `Out of Stock`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = 29.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Technocom`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1120.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Keyboards`.
    temp12-deliverydate = 1782000000000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Flat XXL`.
    temp12-productid = `HT-1137`.
    temp12-quantity = 10.
    temp12-status = `Discontinued`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = 1430.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Technocom`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1137.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Flat Screen Monitors`.
    temp12-deliverydate = 1781654400000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Pocket Mouse`.
    temp12-productid = `HT-1138`.
    temp12-quantity = 20.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 23.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Technocom`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1138.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Mice`.
    temp12-deliverydate = 1784764800000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `PC Power Station`.
    temp12-productid = `HT-1210`.
    temp12-quantity = 22.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 2399.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Technocom`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1210.jpg`.
    temp12-heavy = `false`.
    temp12-category = `PCs`.
    temp12-deliverydate = 1784419200000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Astro Laptop 1516`.
    temp12-productid = `HT-1251`.
    temp12-quantity = 23.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 989.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Ultrasonic United`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1251.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Laptops`.
    temp12-deliverydate = 1784073600000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Astro Phone 6`.
    temp12-productid = `HT-1252`.
    temp12-quantity = 28.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 649.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Ultrasonic United`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1252.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Smartphones and Tablets`.
    temp12-deliverydate = 1783728000000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Benda Laptop 1408`.
    temp12-productid = `HT-1253`.
    temp12-quantity = 27.
    temp12-status = `Discontinued`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = 976.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Ultrasonic United`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1253.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Laptops`.
    temp12-deliverydate = 1783382400000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Bending Screen 21HD`.
    temp12-productid = `HT-1254`.
    temp12-quantity = 23.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 250.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Ultrasonic United`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1254.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Flat Screens`.
    temp12-deliverydate = 1783036800000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Broad Screen 22HD`.
    temp12-productid = `HT-1255`.
    temp12-quantity = 5.
    temp12-status = `Discontinued`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = 270.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Ultrasonic United`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1255.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Flat Screens`.
    temp12-deliverydate = 1782691200000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Cerdik Phone 7`.
    temp12-productid = `HT-1256`.
    temp12-quantity = 19.
    temp12-status = `Discontinued`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = 549.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Ultrasonic United`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1256.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Smartphones and Tablets`.
    temp12-deliverydate = 1782345600000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Cepat Tablet 10.5`.
    temp12-productid = `HT-1257`.
    temp12-quantity = 17.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 549.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Ultrasonic United`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1257.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Smartphones and Tablets`.
    temp12-deliverydate = 1782000000000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Cepat Tablet 8`.
    temp12-productid = `HT-1258`.
    temp12-quantity = 24.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 529.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Ultrasonic United`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1258.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Smartphones and Tablets`.
    temp12-deliverydate = 1781654400000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Server Basic`.
    temp12-productid = `HT-1500`.
    temp12-quantity = 24.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 5000.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Technocom`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1500.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Servers`.
    temp12-deliverydate = 1784764800000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Server Professional`.
    temp12-productid = `HT-1501`.
    temp12-quantity = 26.
    temp12-status = `Out of Stock`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = 15000.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Technocom`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1501.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Servers`.
    temp12-deliverydate = 1784419200000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Server Power Pro`.
    temp12-productid = `HT-1502`.
    temp12-quantity = 34.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 25000.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Technocom`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1502.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Servers`.
    temp12-deliverydate = 1784073600000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Family PC Basic`.
    temp12-productid = `HT-1600`.
    temp12-quantity = 10.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 600.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Titanium`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1600.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Desktop Computers`.
    temp12-deliverydate = 1783728000000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Family PC Pro`.
    temp12-productid = `HT-1601`.
    temp12-quantity = 20.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 900.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Titanium`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1601.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Desktop Computers`.
    temp12-deliverydate = 1783382400000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Gaming Monster`.
    temp12-productid = `HT-1602`.
    temp12-quantity = 24.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 1200.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Titanium`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1602.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Desktop Computers`.
    temp12-deliverydate = 1783036800000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Gaming Monster Pro`.
    temp12-productid = `HT-1603`.
    temp12-quantity = 25.
    temp12-status = `Discontinued`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = 1700.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Titanium`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1603.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Desktop Computers`.
    temp12-deliverydate = 1782691200000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `7" Widescreen Portable DVD Player w MP3`.
    temp12-productid = `HT-2000`.
    temp12-quantity = 20.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = `249.99`.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Titanium`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2000.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Accessories`.
    temp12-deliverydate = 1782345600000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `10" Portable DVD player`.
    temp12-productid = `HT-2001`.
    temp12-quantity = 21.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = `449.99`.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Titanium`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2001.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Accessories`.
    temp12-deliverydate = 1782000000000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Portable DVD Player with 9" LCD Monitor`.
    temp12-productid = `HT-2002`.
    temp12-quantity = 50.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = `853.99`.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Technocom`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2002.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Accessories`.
    temp12-deliverydate = 1781654400000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `CD/DVD case: 264 sleeves`.
    temp12-productid = `HT-2025`.
    temp12-quantity = 26.
    temp12-status = `Discontinued`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = `44.99`.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Titanium`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2025.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Accessories`.
    temp12-deliverydate = 1784764800000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Audio/Video Cable Kit - 4m`.
    temp12-productid = `HT-2026`.
    temp12-quantity = 16.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = `29.99`.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Titanium`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2026.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Accessories`.
    temp12-deliverydate = 1784419200000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Removable CD/DVD Laser Labels`.
    temp12-productid = `HT-2027`.
    temp12-quantity = 25.
    temp12-status = `Discontinued`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = `8.99`.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Titanium`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2027.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Accessories`.
    temp12-deliverydate = 1784073600000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Beam Breaker B-1`.
    temp12-productid = `HT-6100`.
    temp12-quantity = 32.
    temp12-status = `Out of Stock`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = 469.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Titanium`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6100.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Accessories`.
    temp12-deliverydate = 1783728000000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Beam Breaker B-2`.
    temp12-productid = `HT-6101`.
    temp12-quantity = 18.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 679.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Technocom`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6101.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Accessories`.
    temp12-deliverydate = 1783382400000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Beam Breaker B-3`.
    temp12-productid = `HT-6102`.
    temp12-quantity = 16.
    temp12-status = `Out of Stock`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = 889.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Technocom`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6102.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Accessories`.
    temp12-deliverydate = 1783036800000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Play Movie`.
    temp12-productid = `HT-6110`.
    temp12-quantity = 15.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 130.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Fasttech`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6110.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Accessories`.
    temp12-deliverydate = 1782691200000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Record Movie`.
    temp12-productid = `HT-6111`.
    temp12-quantity = 24.
    temp12-status = `Discontinued`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = 288.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Fasttech`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6111.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Accessories`.
    temp12-deliverydate = 1782345600000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `ITelo MusicStick`.
    temp12-productid = `HT-6120`.
    temp12-quantity = 15.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 45.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Fasttech`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6120.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Accessories`.
    temp12-deliverydate = 1782000000000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `ITelo Jog-Mate`.
    temp12-productid = `HT-6121`.
    temp12-quantity = 24.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 63.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Fasttech`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6121.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Accessories`.
    temp12-deliverydate = 1781654400000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Power Pro Player 40`.
    temp12-productid = `HT-6122`.
    temp12-quantity = 23.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 167.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Fasttech`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6122.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Accessories`.
    temp12-deliverydate = 1784764800000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Power Pro Player 80`.
    temp12-productid = `HT-6123`.
    temp12-quantity = 13.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 299.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Fasttech`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6123.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Accessories`.
    temp12-deliverydate = 1784419200000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Flat Watch HD32`.
    temp12-productid = `HT-6130`.
    temp12-quantity = 16.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 1459.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Very Best Screens`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6130.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Flat Screen TVs`.
    temp12-deliverydate = 1784073600000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Flat Watch HD37`.
    temp12-productid = `HT-6131`.
    temp12-quantity = 14.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 1199.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Very Best Screens`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6131.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Flat Screen TVs`.
    temp12-deliverydate = 1783728000000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Flat Watch HD41`.
    temp12-productid = `HT-6132`.
    temp12-quantity = 13.
    temp12-status = `Discontinued`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = 899.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Very Best Screens`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6132.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Flat Screen TVs`.
    temp12-deliverydate = 1783382400000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Copperberry`.
    temp12-productid = `HT-7000`.
    temp12-quantity = 5.
    temp12-status = `Discontinued`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = 549.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Fasttech`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7000.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Accessories`.
    temp12-deliverydate = 1783036800000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Silverberry`.
    temp12-productid = `HT-7010`.
    temp12-quantity = 9.
    temp12-status = `Discontinued`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = 549.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Fasttech`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7010.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Accessories`.
    temp12-deliverydate = 1782691200000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Goldberry`.
    temp12-productid = `HT-7020`.
    temp12-quantity = 11.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 549.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Fasttech`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7020.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Accessories`.
    temp12-deliverydate = 1782345600000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Platinberry`.
    temp12-productid = `HT-7030`.
    temp12-quantity = 12.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 549.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Fasttech`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7030.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Accessories`.
    temp12-deliverydate = 1782000000000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `ITelO FlexTop I4000`.
    temp12-productid = `HT-8000`.
    temp12-quantity = 11.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 799.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Titanium`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8000.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Laptops`.
    temp12-deliverydate = 1781654400000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `ITelO FlexTop I6300c`.
    temp12-productid = `HT-8001`.
    temp12-quantity = 20.
    temp12-status = `Discontinued`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = 799.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Titanium`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8001.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Laptops`.
    temp12-deliverydate = 1784764800000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `ITelO FlexTop I9100`.
    temp12-productid = `HT-8002`.
    temp12-quantity = 20.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 1199.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Titanium`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8002.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Laptops`.
    temp12-deliverydate = 1784419200000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `ITelO FlexTop I9800`.
    temp12-productid = `HT-8003`.
    temp12-quantity = 22.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 1388.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Titanium`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8003.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Laptops`.
    temp12-deliverydate = 1784073600000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Smartphone Leather Case`.
    temp12-productid = `HT-9991`.
    temp12-quantity = 12.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 25.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Ultrasonic United`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9991.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Accessories`.
    temp12-deliverydate = 1783728000000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Smartphone Alpha`.
    temp12-productid = `HT-9992`.
    temp12-quantity = 13.
    temp12-status = `Out of Stock`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = 599.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Ultrasonic United`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9992.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Smartphones and Tablets`.
    temp12-deliverydate = 1783382400000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Mini Tablet`.
    temp12-productid = `HT-9993`.
    temp12-quantity = 10.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 833.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Ultrasonic United`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9993.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Smartphones and Tablets`.
    temp12-deliverydate = 1783036800000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Camcorder View`.
    temp12-productid = `HT-9994`.
    temp12-quantity = 50.
    temp12-status = `Out of Stock`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = 1388.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Ultrasonic United`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9994.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Accessories`.
    temp12-deliverydate = 1782691200000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Tablet Pouch`.
    temp12-productid = `HT-9995`.
    temp12-quantity = 34.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 20.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Titanium`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9995.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Accessories`.
    temp12-deliverydate = 1782345600000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Tablet Pouch`.
    temp12-productid = `HT-9996`.
    temp12-quantity = 34.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 20.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Titanium`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9996.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Accessories`.
    temp12-deliverydate = 1782000000000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `e-Book Reader ReadMe`.
    temp12-productid = `HT-9997`.
    temp12-quantity = 23.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 33.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Titanium`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9997.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Smartphones and Tablets`.
    temp12-deliverydate = 1781654400000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Smartphone Beta`.
    temp12-productid = `HT-9998`.
    temp12-quantity = 21.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 30.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Titanium`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9998.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Smartphones and Tablets`.
    temp12-deliverydate = 1784764800000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Maxi Tablet`.
    temp12-productid = `HT-9999`.
    temp12-quantity = 20.
    temp12-status = `Available`.
    temp12-availablestate = `Success`.
    temp12-availableicon = `sap-icon://accept`.
    temp12-price = 749.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Titanium`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9999.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Tablets`.
    temp12-deliverydate = 1784419200000.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Flyer`.
    temp12-productid = `PF-1000`.
    temp12-quantity = 33.
    temp12-status = `Out of Stock`.
    temp12-availablestate = `Error`.
    temp12-availableicon = `sap-icon://decline`.
    temp12-price = 0.
    temp12-currencycode = `EUR`.
    temp12-suppliername = `Titanium`.
    temp12-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/PF-1000.jpg`.
    temp12-heavy = `false`.
    temp12-category = `Accessories`.
    temp12-deliverydate = 1784073600000.
    INSERT temp12 INTO TABLE temp11.
    t_products = temp11.

    " the Suppliers / Categories collections the controller derives from the
    " products for the two in-cell dropdowns - the distinct values, in first
    " appearance order, exactly as the JS loop collects them
    
    CLEAR temp13.
    
    temp14-name = `Very Best Screens`.
    INSERT temp14 INTO TABLE temp13.
    temp14-name = `Smartcards`.
    INSERT temp14 INTO TABLE temp13.
    temp14-name = `Technocom`.
    INSERT temp14 INTO TABLE temp13.
    temp14-name = `Alpha Printers`.
    INSERT temp14 INTO TABLE temp13.
    temp14-name = `Printer for All`.
    INSERT temp14 INTO TABLE temp13.
    temp14-name = `Oxynum`.
    INSERT temp14 INTO TABLE temp13.
    temp14-name = `Fasttech`.
    INSERT temp14 INTO TABLE temp13.
    temp14-name = `Ultrasonic United`.
    INSERT temp14 INTO TABLE temp13.
    temp14-name = `Speaker Experts`.
    INSERT temp14 INTO TABLE temp13.
    temp14-name = `Brainsoft`.
    INSERT temp14 INTO TABLE temp13.
    temp14-name = `Red Point Stores`.
    INSERT temp14 INTO TABLE temp13.
    temp14-name = `Titanium`.
    INSERT temp14 INTO TABLE temp13.
    t_suppliers = temp13.

    
    CLEAR temp15.
    
    temp16-name = `Laptops`.
    INSERT temp16 INTO TABLE temp15.
    temp16-name = `Accessories`.
    INSERT temp16 INTO TABLE temp15.
    temp16-name = `Flat Screen Monitors`.
    INSERT temp16 INTO TABLE temp15.
    temp16-name = `Printers`.
    INSERT temp16 INTO TABLE temp15.
    temp16-name = `Multifunction Printers`.
    INSERT temp16 INTO TABLE temp15.
    temp16-name = `Mice`.
    INSERT temp16 INTO TABLE temp15.
    temp16-name = `Keyboards`.
    INSERT temp16 INTO TABLE temp15.
    temp16-name = `Mousepads`.
    INSERT temp16 INTO TABLE temp15.
    temp16-name = `Computer System Accessories`.
    INSERT temp16 INTO TABLE temp15.
    temp16-name = `Graphic Cards`.
    INSERT temp16 INTO TABLE temp15.
    temp16-name = `Scanners`.
    INSERT temp16 INTO TABLE temp15.
    temp16-name = `Speakers`.
    INSERT temp16 INTO TABLE temp15.
    temp16-name = `Software`.
    INSERT temp16 INTO TABLE temp15.
    temp16-name = `Telecommunications`.
    INSERT temp16 INTO TABLE temp15.
    temp16-name = `PCs`.
    INSERT temp16 INTO TABLE temp15.
    temp16-name = `Smartphones and Tablets`.
    INSERT temp16 INTO TABLE temp15.
    temp16-name = `Flat Screens`.
    INSERT temp16 INTO TABLE temp15.
    temp16-name = `Servers`.
    INSERT temp16 INTO TABLE temp15.
    temp16-name = `Desktop Computers`.
    INSERT temp16 INTO TABLE temp15.
    temp16-name = `Flat Screen TVs`.
    INSERT temp16 INTO TABLE temp15.
    temp16-name = `Tablets`.
    INSERT temp16 INTO TABLE temp15.
    t_categories = temp15.

  ENDMETHOD.

ENDCLASS.
