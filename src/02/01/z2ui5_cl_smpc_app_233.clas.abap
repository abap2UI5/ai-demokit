" @keywords initialpagepattern initial pattern sap.m selectdialog standardlistitem objectpagelayout objectpagedynamicheadertitle input listitem flexbox vbox
" @summary The initial page floorplan allows the user to navigate to a single object to view or edit it.
CLASS z2ui5_cl_smpc_app_233 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             productid    TYPE string,
             name         TYPE string,
             width        TYPE string,
             depth        TYPE string,
             height       TYPE string,
             dimunit      TYPE string,
             quantity     TYPE i,
             price        TYPE p LENGTH 12 DECIMALS 2,
             currencycode TYPE string,
           END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.
    TYPES: BEGIN OF ty_s_purchase,
             purchaseid           TYPE string,
             suppliername         TYPE string,
             category             TYPE string,
             subcategory          TYPE string,
             paymenttype          TYPE string,
             deliverystatus       TYPE string,
             deliverystatus_state TYPE string,
             productcollection    TYPE ty_t_product,
           END OF ty_s_purchase.
    DATA t_purchases TYPE STANDARD TABLE OF ty_s_purchase WITH DEFAULT KEY.

    " the sample's dynamic /selectedPurchase object is flattened to the default-model
    " root: the header fields, the delivery-status state and the products table
    DATA input_value          TYPE string.
    DATA has_selection        TYPE abap_bool.
    DATA inputpopulated       TYPE abap_bool.
    DATA sel_category         TYPE string.
    DATA sel_subcategory      TYPE string.
    DATA sel_suppliername     TYPE string.
    DATA sel_paymenttype      TYPE string.
    DATA sel_deliverystatus   TYPE string.
    DATA sel_delivery_state   TYPE string.
    DATA sel_products         TYPE ty_t_product.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS set_selection IMPORTING key TYPE string.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_233 IMPLEMENTATION.

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

    
    CLEAR temp1.
    INSERT `selectDialog` INTO TABLE temp1.
    INSERT `items` INTO TABLE temp1.
    INSERT `filter` INTO TABLE temp1.
    INSERT `$event.oSource.getValue() ? '[[["PURCHASEID","Contains","' + $event.oSource.getValue() + '"],["SUPPLIERNAME","Contains","' + $event.oSource.getValue() + '"]]]' : '[]'` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `selectDialog` INTO TABLE temp2.
    INSERT `open` INTO TABLE temp2.
    INSERT `$event.oSource.getValue()` INTO TABLE temp2.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`       v = `sap.m`
        )->a( n = `xmlns:mvc`   v = `sap.ui.core.mvc`
        )->a( n = `xmlns:uxap`  v = `sap.uxap`
        )->a( n = `xmlns:core`  v = `sap.ui.core`
        )->a( n = `xmlns:m`     v = `sap.m`
        )->a( n = `xmlns:forms` v = `sap.ui.layout.form`
        )->a( n = `height`      v = `100%`

        " Dialog.fragment.xml - loaded in the controller via oView.addDependent
        )->ele( n = `dependents` ns = `mvc`
            )->ele( `SelectDialog`
                )->a( n = `id`      v = `selectDialog`
                )->a( n = `title`   v = `Purchases`
                )->a( n = `items`   v = client->_bind( t_purchases )
                " handleValueHelpSearch/_getCombinedFilter build an OR over PurchaseID
                " and SupplierName. The compound binding_call payload is one JSON
                " string, so the value cannot be substituted client-side - the search
                " round-trips and the backend issues the compound filter (app 022 idiom)
                )->a( n = `search`  v = client->_event( val = `VH_SEARCH` arg = `${$parameters>/value}` )
                )->a( n = `confirm` v = client->_event( val = `VH_CONFIRM` arg = `${$parameters>/selectedItem}.getDescription()` )

                )->tag( `StandardListItem`
                    )->a( n = `title`       v = `{SUPPLIERNAME}`
                    )->a( n = `description` v = `{PURCHASEID}`

            )->end(
        )->end(

        )->ele( n = `ObjectPageLayout` ns = `uxap`
            )->a( n = `id`                     v = `ObjectPageLayout`
            )->a( n = `showHeaderContent`      v = client->_bind( has_selection )
            )->a( n = `toggleHeaderOnTitleClick` v = client->_bind( has_selection )
            )->a( n = `upperCaseAnchorBar`     v = `false`

            )->ele( n = `headerTitle` ns = `uxap`
                )->ele( n = `ObjectPageDynamicHeaderTitle` ns = `uxap`

                    )->ele( n = `heading` ns = `uxap`
                        " Input.fragment.xml
                        )->ele( `Input`
                            )->a( n = `class`           v = `sapUiTinyMarginBottom`
                            )->a( n = `id`              v = `purchaseInput`
                            )->a( n = `value`           v = client->_bind( input_value )
                            )->a( n = `textFormatMode`  v = `KeyValue`
                            )->a( n = `submit`          v = client->_event( `SUBMIT` )
                            )->a( n = `placeholder`     v = `Enter product`
                            )->a( n = `showSuggestion`  v = `true`
                            )->a( n = `autocomplete`    v = `false`
                            )->a( n = `showValueHelp`   v = `true`
                            )->a( n = `change`          v = client->_event( `CHANGE` )
                            " _filterAndOpenValueHelpDialog does TWO things: it applies the
                            " combined filter to the dialog's binding and THEN opens it with
                            " the current input value. SelectDialog.open( ) only seeds the
                            " search field - it does not filter - so both are chained here
                            )->a( n = `valueHelpRequest` v = client->follow_up_action(
                                      val   = client->cs_event-binding_call
                                      t_arg = temp1 ) && `; ` &&
                                                  client->follow_up_action(
                                      val   = client->cs_event-control_by_id
                                      t_arg = temp2 )
                            )->a( n = `suggestionItems` v = client->_bind( t_purchases )
                            )->a( n = `suggestionItemSelected` v = client->_event( val = `SUGGEST` arg = `${$parameters>/selectedItem}.getKey()` )

                            )->ele( `suggestionItems`
                                )->tag( n = `ListItem` ns = `core`
                                    )->a( n = `key`            v = `{PURCHASEID}`
                                    )->a( n = `text`           v = `{SUPPLIERNAME}`
                                    )->a( n = `additionalText` v = `{PURCHASEID}`

                            )->end(
                        )->end(
                    )->end(
                )->end(
            )->end(

            )->ele( n = `headerContent` ns = `uxap`
                " HeaderContent.fragment.xml
                )->ele( `FlexBox`
                    )->a( n = `wrap`         v = `Wrap`
                    )->a( n = `fitContainer` v = `true`

                    )->ele( `VBox`
                        )->a( n = `class` v = `sapUiLargeMarginEnd`

                        )->ele( `HBox`
                            )->tag( `Title`
                                )->a( n = `text` v = `Receipt Information`

                        )->end(
                        )->ele( `HBox`
                            )->tag( `Label`
                                )->a( n = `class` v = `sapUiTinyMarginEnd`
                                )->a( n = `text`  v = `Category:`
                            )->tag( `Text`
                                )->a( n = `text` v = client->_bind( sel_category )

                        )->end(
                        )->ele( `HBox`
                            )->tag( `Label`
                                )->a( n = `class` v = `sapUiTinyMarginEnd`
                                )->a( n = `text`  v = `Sub-Category:`
                            )->tag( `Text`
                                )->a( n = `text` v = client->_bind( sel_subcategory )

                        )->end(
                        )->ele( `HBox`
                            )->tag( `Label`
                                )->a( n = `class` v = `sapUiTinyMarginEnd`
                                )->a( n = `text`  v = `Supplier:`
                            )->tag( `Text`
                                )->a( n = `text` v = client->_bind( sel_suppliername )

                        )->end(
                        )->ele( `HBox`
                            )->tag( `Label`
                                )->a( n = `class` v = `sapUiTinyMarginEnd`
                                )->a( n = `text`  v = `Payment Type:`
                            )->tag( `Text`
                                )->a( n = `text` v = client->_bind( sel_paymenttype )

                        )->end(
                    )->end(

                    )->ele( `VBox`
                        )->ele( `HBox`
                            )->tag( `Title`
                                )->a( n = `text` v = `Delivery Status`

                        )->end(
                        )->ele( `HBox`
                            )->tag( `ObjectStatus`
                                )->a( n = `class` v = `sapMObjectStatusLarge`
                                )->a( n = `text`  v = client->_bind( sel_deliverystatus )
                                )->a( n = `state` v = client->_bind( sel_delivery_state )

                        )->end(
                    )->end(
                )->end(
            )->end(

            )->ele( n = `sections` ns = `uxap`

                " IllustratedMessage.fragment.xml
                )->ele( n = `ObjectPageSection` ns = `uxap`
                    )->a( n = `showTitle` v = `false`
                    )->a( n = `visible`   v = |\{= !${ client->_bind( has_selection ) } \}|

                    )->ele( n = `subSections` ns = `uxap`
                        " the original's sapUxAPObjectPageSubSectionFitContainer is NOT carried
                        " over: that class makes the subsection fill its container, and its
                        " contract is an ObjectPageLayout with a DEFINITE height. Here there is
                        " none - abap2UI5 hosts the view in a content-sized sap.m.NavContainer,
                        " so the layout chain reads OPL 329px <- our XMLView 329px <- sapMNav
                        " 329px, every one of them sized by its own content. The class then
                        " closes a positive feedback loop (subsection fits container -> OPL
                        " grows -> container grows -> subsection fits again): measured
                        " 2026-08-27, one window resize took the ObjectPageLayout 329px ->
                        " 19,249px -> 60,142px and then pegged the renderer outright. That is
                        " what failed app 233 in CI TWICE - both times as a layout-dependent
                        " assertion timing out while every wire was intact (the body-text scan
                        " of 2026-08-26, then the PurchaseID input's visibility wait in
                        " bump-a2ui5 run 33087805313). Without the class the same layout holds
                        " at 329px across repeated resizes. The cost is cosmetic: the
                        " IllustratedMessage sits at its content height instead of centred in
                        " the remaining space.
                        )->ele( n = `ObjectPageSubSection` ns = `uxap`

                            )->tag( n = `IllustratedMessage` ns = `m`
                                )->a( n = `illustrationType` v = |\{= ${ client->_bind( inputpopulated ) } ? 'sapIllus-UnableToUpload' : 'sapIllus-NoSearchResults' \}|
                                )->a( n = `title`            v = |\{= ${ client->_bind( inputpopulated ) } ? 'Purchase not found' : 'Enter purchase ID' \}|
                                )->a( n = `description`      v = |\{= ${ client->_bind( inputpopulated ) } ? 'No matching items found' : 'Enter the purchase order ID for the goods receipt.' \}|

                        )->end(
                    )->end(
                )->end(

                " ProductsTable.fragment.xml
                )->ele( n = `ObjectPageSection` ns = `uxap`
                    )->a( n = `title`   v = `Products`
                    )->a( n = `visible` v = client->_bind( has_selection )

                    )->ele( n = `subSections` ns = `uxap`
                        )->ele( n = `ObjectPageSubSection` ns = `uxap`

                            )->ele( `Table`
                                )->a( n = `id`    v = `idProductsTable`
                                )->a( n = `items` v = client->_bind( sel_products )
                                )->a( n = `class` v = `sapUxAPObjectPageSubSectionAlignContent`
                                )->a( n = `width` v = `auto`

                                )->ele( `headerToolbar`
                                    )->ele( `Toolbar`
                                        )->tag( `Title`
                                            )->a( n = `text`  v = `Products`
                                            )->a( n = `level` v = `H2`

                                    )->end(
                                )->end(

                                )->ele( `columns`
                                    )->ele( `Column`
                                        )->a( n = `width` v = `12rem`
                                        )->tag( `Text`
                                            )->a( n = `text` v = `Product`

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
                                        )->a( n = `hAlign`         v = `End`
                                        )->tag( `Text`
                                            )->a( n = `text` v = `Quantity`

                                    )->end(
                                    )->ele( `Column`
                                        )->a( n = `hAlign` v = `End`
                                        )->tag( `Text`
                                            )->a( n = `text` v = `Price`

                                    )->end(
                                )->end(

                                )->ele( `items`
                                    )->ele( `ColumnListItem`
                                        )->ele( `cells`
                                            )->tag( `ObjectIdentifier`
                                                )->a( n = `title` v = `{NAME}`
                                                )->a( n = `text`  v = `{PRODUCTID}`
                                            )->tag( `Text`
                                                )->a( n = `text` v = `{WIDTH} x {DEPTH} x {HEIGHT} {DIMUNIT}`
                                            )->tag( `Text`
                                                )->a( n = `text` v = `{QUANTITY} each`
                                            )->tag( `ObjectNumber`
                                                )->a( n = `number` v = |\{ parts: [ \{ path: 'PRICE' \}, \{ path: 'CURRENCYCODE' \} ], type: 'sap.ui.model.type.Currency', formatOptions: \{ showMeasure: false \} \}|
                                                )->a( n = `unit`   v = `{CURRENCYCODE}`

                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                " SupplierDetails.fragment.xml
                )->ele( n = `ObjectPageSection` ns = `uxap`
                    )->a( n = `title`   v = `Supplier details`
                    )->a( n = `visible` v = client->_bind( has_selection )

                    )->ele( n = `subSections` ns = `uxap`
                        )->ele( n = `ObjectPageSubSection` ns = `uxap`
                            )->a( n = `title` v = `Connect`

                            )->ele( n = `blocks` ns = `uxap`
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `layout`   v = `ColumnLayout`
                                    )->a( n = `width`    v = `100%`
                                    )->a( n = `class`    v = `sapUxAPObjectPageSubSectionAlignContent`
                                    )->a( n = `columnsM` v = `2`
                                    )->a( n = `columnsL` v = `3`
                                    )->a( n = `columnsXL` v = `4`

                                    )->tag( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Phone Numbers`
                                    )->tag( `Label`
                                        )->a( n = `text` v = `Home`
                                    )->tag( `Text`
                                        )->a( n = `text` v = `+ 1 415-321-1234`
                                    )->tag( `Label`
                                        )->a( n = `text` v = `Office phone`
                                    )->tag( `Text`
                                        )->a( n = `text` v = `+ 1 415-321-5555`
                                    )->tag( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Social Accounts`
                                    )->tag( `Label`
                                        )->a( n = `text` v = `LinkedIn`
                                    )->tag( `Text`
                                        )->a( n = `text` v = `/DeniseSmith`
                                    )->tag( `Label`
                                        )->a( n = `text` v = `Twitter`
                                    )->tag( `Text`
                                        )->a( n = `text` v = `@DeniseSmith`
                                    )->tag( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Addresses`
                                    )->tag( `Label`
                                        )->a( n = `text` v = `Home Address`
                                    )->tag( `Text`
                                        )->a( n = `text` v = `2096 Mission Street`
                                    )->tag( `Label`
                                        )->a( n = `text` v = `Mailing Address`
                                    )->tag( `Text`
                                        )->a( n = `text` v = `PO Box 32114`
                                    )->tag( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Mailing Address`
                                    )->tag( `Label`
                                        )->a( n = `text` v = `Work`
                                    )->tag( `Text`
                                        )->a( n = `text` v = `DeniseSmith@sap.com`

                                )->end(
                            )->end(
                        )->end(

                        )->ele( n = `ObjectPageSubSection` ns = `uxap`
                            )->a( n = `title` v = `Payment information`

                            )->ele( n = `blocks` ns = `uxap`
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `layout`    v = `ColumnLayout`
                                    )->a( n = `width`     v = `100%`
                                    )->a( n = `class`     v = `sapUxAPObjectPageSubSectionAlignContent`
                                    )->a( n = `columnsM`  v = `2`
                                    )->a( n = `columnsL`  v = `3`
                                    )->a( n = `columnsXL` v = `4`

                                    )->tag( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Main Payment Method`
                                    )->tag( `Label`
                                        )->a( n = `text` v = `Bank Transfer`
                                    )->tag( `Text`
                                        )->a( n = `text` v = `Sparkasse Heimfeld, Germany`

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
        DATA search_value TYPE string.
        DATA temp3 TYPE string_table.
        DATA temp4 LIKE LINE OF temp3.

    CASE client->get_event( ).

      WHEN `SUBMIT`.
        " handleInputSubmit: the entered value (two-way bound) selects the purchase
        IF input_value IS NOT INITIAL.
          set_selection( input_value ).
        ELSE.
          " the original sets /inputPopulated = false and nothing else - the
          " ObjectPage keeps whatever was selected
          inputpopulated = abap_false.
        ENDIF.
        view_display( ).

      WHEN `CHANGE`.
        " handleInputChange: on empty input, reset the populated flag
        IF input_value IS INITIAL.
          inputpopulated = abap_false.
        ENDIF.

      WHEN `SUGGEST`.
        " handleInputSuggestionItemSelected: the picked suggestion's key
        set_selection( client->get_event_arg( ) ).
        view_display( ).

      WHEN `VH_SEARCH`.
        " _getCombinedFilter: PurchaseID Contains value OR SupplierName Contains
        " value - one group, so the two entries OR (the compound form shipped with
        " pr/binding-call-compound-filters)
        
        search_value = client->get_event_arg( ).
        " free text spliced into a JSON string literal - backslash first, then the quote (app 218/420)
        REPLACE ALL OCCURRENCES OF `\` IN search_value WITH `\\`.
        REPLACE ALL OCCURRENCES OF `"` IN search_value WITH `\"`.
        
        CLEAR temp3.
        INSERT `selectDialog` INTO TABLE temp3.
        INSERT `items` INTO TABLE temp3.
        INSERT `filter` INTO TABLE temp3.
        
        temp4 = |[[["PURCHASEID","Contains","{ search_value }"],["SUPPLIERNAME","Contains","{ search_value }"]]]|.
        INSERT temp4 INTO TABLE temp3.
        client->follow_up_action(
            val   = client->cs_event-binding_call
            t_arg = temp3 ).

      WHEN `VH_CONFIRM`.
        " handleValueHelpConfirm: the picked item's description = PurchaseID
        set_selection( client->get_event_arg( ) ).
        view_display( ).

    ENDCASE.

  ENDMETHOD.


  METHOD set_selection.
    DATA purchase TYPE z2ui5_cl_smpc_app_233=>ty_s_purchase.

    " _setSelectedPurchaseAndUpdateInput: resolve the purchase by PurchaseID and
    " seed the flattened /selectedPurchase fields; if none is found, force "no
    " selection" so the IllustratedMessage "not found" state shows
    inputpopulated = abap_true.

    
    READ TABLE t_purchases INTO purchase WITH KEY purchaseid = key.
    IF sy-subrc = 0.
      " the original resolves the purchase with Input.setSelectedKey, and under
      " textFormatMode="KeyValue" the input then shows "(<key>) <text>" - the
      " same composition, since the port re-renders and would otherwise put the
      " bare key back into the field
      input_value        = |({ key }) { purchase-suppliername }|.
      has_selection      = abap_true.
      sel_category       = purchase-category.
      sel_subcategory    = purchase-subcategory.
      sel_suppliername   = purchase-suppliername.
      sel_paymenttype    = purchase-paymenttype.
      sel_deliverystatus = purchase-deliverystatus.
      sel_delivery_state = purchase-deliverystatus_state.
      sel_products       = purchase-productcollection.
    ELSE.
      has_selection      = abap_false.
      sel_delivery_state = `None`.
    ENDIF.

  ENDMETHOD.


  METHOD model_init.
    DATA temp5 LIKE t_purchases.
    DATA temp6 LIKE LINE OF temp5.
    DATA temp7 TYPE z2ui5_cl_smpc_app_233=>ty_t_product.
    DATA temp8 LIKE LINE OF temp7.
    DATA temp9 TYPE z2ui5_cl_smpc_app_233=>ty_t_product.
    DATA temp10 LIKE LINE OF temp9.
    DATA temp11 TYPE z2ui5_cl_smpc_app_233=>ty_t_product.
    DATA temp12 LIKE LINE OF temp11.

    " no purchase selected yet - seed the ObjectStatus state with the formatter's
    " default ValueState (None) so the enum property is valid before a selection
    sel_delivery_state = `None`.

    
    CLEAR temp5.
    
    temp6-purchaseid = `123`.
    temp6-suppliername = `BestEastern`.
    temp6-category = `Computers`.
    temp6-subcategory = `Laptops`.
    temp6-paymenttype = `Invoice`.
    temp6-deliverystatus = `Not Completed`.
    temp6-deliverystatus_state = `None`.
    
    CLEAR temp7.
    
    temp8-productid = `HT-1000`.
    temp8-name = `Notebook Basic 15`.
    temp8-width = `30`.
    temp8-depth = `18`.
    temp8-height = `3`.
    temp8-dimunit = `cm`.
    temp8-quantity = 10.
    temp8-price = '956'.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1001`.
    temp8-name = `Notebook Basic 17`.
    temp8-width = `29`.
    temp8-depth = `17`.
    temp8-height = `3.1`.
    temp8-dimunit = `cm`.
    temp8-quantity = 20.
    temp8-price = '1249'.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1002`.
    temp8-name = `Notebook Basic 18`.
    temp8-width = `28`.
    temp8-depth = `19`.
    temp8-height = `2.5`.
    temp8-dimunit = `cm`.
    temp8-quantity = 10.
    temp8-price = '1570'.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6132`.
    temp8-name = `Flat Watch HD41`.
    temp8-width = `128`.
    temp8-depth = `23`.
    temp8-height = `79.1`.
    temp8-dimunit = `cm`.
    temp8-quantity = 13.
    temp8-price = '899'.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-7030`.
    temp8-name = `Platinberry`.
    temp8-width = `8.1`.
    temp8-depth = `13`.
    temp8-height = `12.1`.
    temp8-dimunit = `cm`.
    temp8-quantity = 12.
    temp8-price = '549'.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-7020`.
    temp8-name = `Goldberry`.
    temp8-width = `8.1`.
    temp8-depth = `13`.
    temp8-height = `12.1`.
    temp8-dimunit = `cm`.
    temp8-quantity = 11.
    temp8-price = '549'.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-7010`.
    temp8-name = `Silverberry`.
    temp8-width = `8.1`.
    temp8-depth = `13`.
    temp8-height = `12.1`.
    temp8-dimunit = `cm`.
    temp8-quantity = 9.
    temp8-price = '549'.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-7000`.
    temp8-name = `Copperberry`.
    temp8-width = `8.1`.
    temp8-depth = `13`.
    temp8-height = `12.1`.
    temp8-dimunit = `cm`.
    temp8-quantity = 5.
    temp8-price = '549'.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1095`.
    temp8-name = `Lovely Sound 5.1 Wireless`.
    temp8-width = `24`.
    temp8-depth = `19`.
    temp8-height = `23`.
    temp8-dimunit = `cm`.
    temp8-quantity = 12.
    temp8-price = '49'.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1096`.
    temp8-name = `Lovely Sound 5.1`.
    temp8-width = `25`.
    temp8-depth = `17`.
    temp8-height = `19`.
    temp8-dimunit = `cm`.
    temp8-quantity = 18.
    temp8-price = '39'.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1097`.
    temp8-name = `Lovely Sound Stereo`.
    temp8-width = `21.3`.
    temp8-depth = `2.4`.
    temp8-height = `19.7`.
    temp8-dimunit = `cm`.
    temp8-quantity = 21.
    temp8-price = '29'.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6123`.
    temp8-name = `Power Pro Player 80`.
    temp8-width = `4`.
    temp8-depth = `6`.
    temp8-height = `0.8`.
    temp8-dimunit = `cm`.
    temp8-quantity = 13.
    temp8-price = '299'.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6122`.
    temp8-name = `Power Pro Player 40`.
    temp8-width = `5.1`.
    temp8-depth = `8`.
    temp8-height = `9.2`.
    temp8-dimunit = `cm`.
    temp8-quantity = 23.
    temp8-price = '167'.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6121`.
    temp8-name = `ITelo Jog-Mate`.
    temp8-width = `5.1`.
    temp8-depth = `8`.
    temp8-height = `9.2`.
    temp8-dimunit = `cm`.
    temp8-quantity = 24.
    temp8-price = '63'.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6120`.
    temp8-name = `ITelo MusicStick`.
    temp8-width = `1.5`.
    temp8-depth = `6`.
    temp8-height = `1`.
    temp8-dimunit = `cm`.
    temp8-quantity = 15.
    temp8-price = '45'.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6111`.
    temp8-name = `Record Movie`.
    temp8-width = `38`.
    temp8-depth = `26`.
    temp8-height = `6.2`.
    temp8-dimunit = `cm`.
    temp8-quantity = 24.
    temp8-price = '288'.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6110`.
    temp8-name = `Play Movie`.
    temp8-width = `37`.
    temp8-depth = `24`.
    temp8-height = `6`.
    temp8-dimunit = `cm`.
    temp8-quantity = 15.
    temp8-price = '130'.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6102`.
    temp8-name = `Beam Breaker B-3`.
    temp8-width = `30.4`.
    temp8-depth = `23.1`.
    temp8-height = `23`.
    temp8-dimunit = `cm`.
    temp8-quantity = 16.
    temp8-price = '889'.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6101`.
    temp8-name = `Beam Breaker B-2`.
    temp8-width = `30.4`.
    temp8-depth = `23.1`.
    temp8-height = `23`.
    temp8-dimunit = `cm`.
    temp8-quantity = 18.
    temp8-price = '679'.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-2002`.
    temp8-name = `Portable DVD Player with 9" LCD Monitor`.
    temp8-width = `21`.
    temp8-depth = `16.5`.
    temp8-height = `14`.
    temp8-dimunit = `cm`.
    temp8-quantity = 50.
    temp8-price = '853.99'.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6100`.
    temp8-name = `Beam Breaker B-1`.
    temp8-width = `30.4`.
    temp8-depth = `23.1`.
    temp8-height = `23`.
    temp8-dimunit = `cm`.
    temp8-quantity = 32.
    temp8-price = '469'.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-2027`.
    temp8-name = `Removable CD/DVD Laser Labels`.
    temp8-width = `5.5`.
    temp8-depth = `2`.
    temp8-height = `2`.
    temp8-dimunit = `cm`.
    temp8-quantity = 25.
    temp8-price = '8.99'.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp6-productcollection = temp7.
    INSERT temp6 INTO TABLE temp5.
    temp6-purchaseid = `420`.
    temp6-suppliername = `Ultrasonic`.
    temp6-category = `Computer Peripherals`.
    temp6-subcategory = `Monitors`.
    temp6-paymenttype = `Debit Card`.
    temp6-deliverystatus = `Shipped`.
    temp6-deliverystatus_state = `Success`.
    
    CLEAR temp9.
    
    temp10-productid = `HT-1072`.
    temp10-name = `Hurricane GX`.
    temp10-width = `22`.
    temp10-depth = `35`.
    temp10-height = `17`.
    temp10-dimunit = `cm`.
    temp10-quantity = 13.
    temp10-price = '101.2'.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-productid = `HT-1073`.
    temp10-name = `Hurricane GX/LN`.
    temp10-width = `22`.
    temp10-depth = `35`.
    temp10-height = `17`.
    temp10-dimunit = `cm`.
    temp10-quantity = 5.
    temp10-price = '139.99'.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-productid = `HT-1080`.
    temp10-name = `Photo Scan`.
    temp10-width = `34`.
    temp10-depth = `48`.
    temp10-height = `5`.
    temp10-dimunit = `cm`.
    temp10-quantity = 8.
    temp10-price = '129'.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-productid = `HT-1081`.
    temp10-name = `Power Scan`.
    temp10-width = `31`.
    temp10-depth = `43`.
    temp10-height = `7`.
    temp10-dimunit = `cm`.
    temp10-quantity = 11.
    temp10-price = '89'.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-productid = `HT-1082`.
    temp10-name = `Jet Scan Professional`.
    temp10-width = `33`.
    temp10-depth = `41`.
    temp10-height = `12`.
    temp10-dimunit = `cm`.
    temp10-quantity = 13.
    temp10-price = '169'.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-productid = `HT-1083`.
    temp10-name = `Jet Scan Professional`.
    temp10-width = `35`.
    temp10-depth = `40`.
    temp10-height = `10`.
    temp10-dimunit = `cm`.
    temp10-quantity = 10.
    temp10-price = '189'.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-productid = `HT-1085`.
    temp10-name = `Copymaster`.
    temp10-width = `45`.
    temp10-depth = `42`.
    temp10-height = `22`.
    temp10-dimunit = `cm`.
    temp10-quantity = 10.
    temp10-price = '1499'.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-productid = `HT-1090`.
    temp10-name = `Surround Sound`.
    temp10-width = `12`.
    temp10-depth = `10`.
    temp10-height = `16`.
    temp10-dimunit = `cm`.
    temp10-quantity = 20.
    temp10-price = '39'.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-productid = `HT-1091`.
    temp10-name = `Blaster Extreme`.
    temp10-width = `13`.
    temp10-depth = `11`.
    temp10-height = `17.5`.
    temp10-dimunit = `cm`.
    temp10-quantity = 15.
    temp10-price = '26'.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-productid = `HT-1092`.
    temp10-name = `Sound Booster`.
    temp10-width = `12.4`.
    temp10-depth = `10.4`.
    temp10-height = `18.1`.
    temp10-dimunit = `cm`.
    temp10-quantity = 50.
    temp10-price = '45'.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-productid = `HT-1100`.
    temp10-name = `Smart Office`.
    temp10-width = `15`.
    temp10-depth = `6.5`.
    temp10-height = `2.1`.
    temp10-dimunit = `cm`.
    temp10-quantity = 25.
    temp10-price = '89.9'.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-productid = `HT-1101`.
    temp10-name = `Smart Design`.
    temp10-width = `14`.
    temp10-depth = `6.7`.
    temp10-height = `24`.
    temp10-dimunit = `cm`.
    temp10-quantity = 26.
    temp10-price = '79.9'.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-productid = `HT-1102`.
    temp10-name = `Smart Network`.
    temp10-width = `16`.
    temp10-depth = `6`.
    temp10-height = `27`.
    temp10-dimunit = `cm`.
    temp10-quantity = 28.
    temp10-price = '69'.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-productid = `HT-1103`.
    temp10-name = `Smart Multimedia`.
    temp10-width = `11`.
    temp10-depth = `3.4`.
    temp10-height = `22`.
    temp10-dimunit = `cm`.
    temp10-quantity = 9.
    temp10-price = '77'.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-productid = `HT-1104`.
    temp10-name = `Smart Games`.
    temp10-width = `10`.
    temp10-depth = `3`.
    temp10-height = `30`.
    temp10-dimunit = `cm`.
    temp10-quantity = 13.
    temp10-price = '55'.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-productid = `HT-1105`.
    temp10-name = `Smart Internet Antivirus`.
    temp10-width = `16`.
    temp10-depth = `4`.
    temp10-height = `21`.
    temp10-dimunit = `cm`.
    temp10-quantity = 17.
    temp10-price = '29'.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-productid = `HT-1106`.
    temp10-name = `Smart Firewall`.
    temp10-width = `17.9`.
    temp10-depth = `4.2`.
    temp10-height = `23.1`.
    temp10-dimunit = `cm`.
    temp10-quantity = 19.
    temp10-price = '34'.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-productid = `HT-1107`.
    temp10-name = `Smart Money`.
    temp10-width = `12`.
    temp10-depth = `1.5`.
    temp10-height = `19`.
    temp10-dimunit = `cm`.
    temp10-quantity = 18.
    temp10-price = '29.9'.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-productid = `HT-1110`.
    temp10-name = `PC Lock`.
    temp10-width = `20`.
    temp10-depth = `8`.
    temp10-height = `4.3`.
    temp10-dimunit = `cm`.
    temp10-quantity = 14.
    temp10-price = '8.9'.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-productid = `HT-1111`.
    temp10-name = `Notebook Lock`.
    temp10-width = `31`.
    temp10-depth = `9`.
    temp10-height = `7`.
    temp10-dimunit = `cm`.
    temp10-quantity = 20.
    temp10-price = '6.9'.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-productid = `HT-1112`.
    temp10-name = `Web cam reality`.
    temp10-width = `9`.
    temp10-depth = `8.2`.
    temp10-height = `1.3`.
    temp10-dimunit = `cm`.
    temp10-quantity = 27.
    temp10-price = '39'.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-productid = `HT-1113`.
    temp10-name = `Screen clean`.
    temp10-width = `2`.
    temp10-depth = `2`.
    temp10-height = `0.1`.
    temp10-dimunit = `cm`.
    temp10-quantity = 17.
    temp10-price = '2.3'.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-productid = `HT-1114`.
    temp10-name = `Fabric bag professional`.
    temp10-width = `42`.
    temp10-depth = `32`.
    temp10-height = `7`.
    temp10-dimunit = `cm`.
    temp10-quantity = 14.
    temp10-price = '31'.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-productid = `HT-1115`.
    temp10-name = `Wireless DSL Router`.
    temp10-width = `19.3`.
    temp10-depth = `18`.
    temp10-height = `5`.
    temp10-dimunit = `cm`.
    temp10-quantity = 16.
    temp10-price = '49'.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-productid = `HT-1116`.
    temp10-name = `Wireless DSL Router / Repeater`.
    temp10-width = `19.3`.
    temp10-depth = `18`.
    temp10-height = `5`.
    temp10-dimunit = `cm`.
    temp10-quantity = 12.
    temp10-price = '59'.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-productid = `HT-1117`.
    temp10-name = `Wireless DSL Router / Repeater and Print Server`.
    temp10-width = `19.3`.
    temp10-depth = `18`.
    temp10-height = `5`.
    temp10-dimunit = `cm`.
    temp10-quantity = 12.
    temp10-price = '69'.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-productid = `HT-1118`.
    temp10-name = `USB Stick`.
    temp10-width = `1.5`.
    temp10-depth = `8.7`.
    temp10-height = `1.2`.
    temp10-dimunit = `cm`.
    temp10-quantity = 14.
    temp10-price = '35'.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-productid = `HT-1120`.
    temp10-name = `Cordless Bluetooth Keyboard, english international`.
    temp10-width = `51.4`.
    temp10-depth = `23`.
    temp10-height = `4`.
    temp10-dimunit = `cm`.
    temp10-quantity = 13.
    temp10-price = '29'.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-productid = `HT-1137`.
    temp10-name = `Flat XXL`.
    temp10-width = `54`.
    temp10-depth = `22`.
    temp10-height = `38`.
    temp10-dimunit = `cm`.
    temp10-quantity = 10.
    temp10-price = '1430'.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-productid = `HT-1138`.
    temp10-name = `Pocket Mouse`.
    temp10-width = `0.3`.
    temp10-depth = `0.5`.
    temp10-height = `1`.
    temp10-dimunit = `cm`.
    temp10-quantity = 20.
    temp10-price = '23'.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-productid = `HT-1210`.
    temp10-name = `PC Power Station`.
    temp10-width = `28`.
    temp10-depth = `31`.
    temp10-height = `43`.
    temp10-dimunit = `cm`.
    temp10-quantity = 22.
    temp10-price = '2399'.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-productid = `HT-1500`.
    temp10-name = `Server Basic`.
    temp10-width = `34`.
    temp10-depth = `35`.
    temp10-height = `23`.
    temp10-dimunit = `cm`.
    temp10-quantity = 24.
    temp10-price = '5000'.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-productid = `HT-1501`.
    temp10-name = `Server Professional`.
    temp10-width = `29`.
    temp10-depth = `30`.
    temp10-height = `27`.
    temp10-dimunit = `cm`.
    temp10-quantity = 26.
    temp10-price = '15000'.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-productid = `HT-1502`.
    temp10-name = `Server Power Pro`.
    temp10-width = `22`.
    temp10-depth = `27.3`.
    temp10-height = `37`.
    temp10-dimunit = `cm`.
    temp10-quantity = 34.
    temp10-price = '25000'.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-productid = `HT-6130`.
    temp10-name = `Flat Watch HD32`.
    temp10-width = `78`.
    temp10-depth = `22.1`.
    temp10-height = `55`.
    temp10-dimunit = `cm`.
    temp10-quantity = 16.
    temp10-price = '1459'.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-productid = `HT-6131`.
    temp10-name = `Flat Watch HD37`.
    temp10-width = `99.1`.
    temp10-depth = `26`.
    temp10-height = `61`.
    temp10-dimunit = `cm`.
    temp10-quantity = 14.
    temp10-price = '1199'.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp6-productcollection = temp9.
    INSERT temp6 INTO TABLE temp5.
    temp6-purchaseid = `321`.
    temp6-suppliername = `Technocom`.
    temp6-category = `Computer Hardware`.
    temp6-subcategory = `Video Cards`.
    temp6-paymenttype = `Credit Card`.
    temp6-deliverystatus = `Failed Shipping`.
    temp6-deliverystatus_state = `Error`.
    
    CLEAR temp11.
    
    temp12-productid = `HT-1003`.
    temp12-name = `Notebook Basic 19`.
    temp12-width = `32`.
    temp12-depth = `21`.
    temp12-height = `4`.
    temp12-dimunit = `cm`.
    temp12-quantity = 15.
    temp12-price = '1650'.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-productid = `HT-1007`.
    temp12-name = `ITelO Vault`.
    temp12-width = `32`.
    temp12-depth = `22`.
    temp12-height = `3`.
    temp12-dimunit = `cm`.
    temp12-quantity = 15.
    temp12-price = '299'.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-productid = `HT-1010`.
    temp12-name = `Notebook Professional 15`.
    temp12-width = `33`.
    temp12-depth = `20`.
    temp12-height = `3`.
    temp12-dimunit = `cm`.
    temp12-quantity = 16.
    temp12-price = '1999'.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-productid = `HT-2026`.
    temp12-name = `Audio/Video Cable Kit - 4m`.
    temp12-width = `21`.
    temp12-depth = `10.2`.
    temp12-height = `13`.
    temp12-dimunit = `cm`.
    temp12-quantity = 16.
    temp12-price = '29.99'.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-productid = `HT-2025`.
    temp12-name = `CD/DVD case: 264 sleeves`.
    temp12-width = `13`.
    temp12-depth = `13`.
    temp12-height = `20`.
    temp12-dimunit = `cm`.
    temp12-quantity = 26.
    temp12-price = '44.99'.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-productid = `HT-2001`.
    temp12-name = `10" Portable DVD player`.
    temp12-width = `24`.
    temp12-depth = `19.5`.
    temp12-height = `29`.
    temp12-dimunit = `cm`.
    temp12-quantity = 21.
    temp12-price = '449.99'.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-productid = `HT-2000`.
    temp12-name = `7" Widescreen Portable DVD Player w MP3`.
    temp12-width = `21.4`.
    temp12-depth = `19`.
    temp12-height = `27.6`.
    temp12-dimunit = `cm`.
    temp12-quantity = 20.
    temp12-price = '249.99'.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-productid = `HT-1603`.
    temp12-name = `Gaming Monster Pro`.
    temp12-width = `27`.
    temp12-depth = `28`.
    temp12-height = `42`.
    temp12-dimunit = `cm`.
    temp12-quantity = 25.
    temp12-price = '1700'.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-productid = `HT-1602`.
    temp12-name = `Gaming Monster`.
    temp12-width = `26.5`.
    temp12-depth = `34`.
    temp12-height = `47`.
    temp12-dimunit = `cm`.
    temp12-quantity = 24.
    temp12-price = '1200'.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-productid = `HT-1601`.
    temp12-name = `Family PC Pro`.
    temp12-width = `25`.
    temp12-depth = `31.7`.
    temp12-height = `40.2`.
    temp12-dimunit = `cm`.
    temp12-quantity = 20.
    temp12-price = '900'.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-productid = `HT-1600`.
    temp12-name = `Family PC Basic`.
    temp12-width = `21.4`.
    temp12-depth = `29`.
    temp12-height = `38`.
    temp12-dimunit = `cm`.
    temp12-quantity = 10.
    temp12-price = '600'.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-productid = `HT-1119`.
    temp12-name = `Travel Adapter`.
    temp12-width = `2`.
    temp12-depth = `3.1`.
    temp12-height = `3.9`.
    temp12-dimunit = `cm`.
    temp12-quantity = 10.
    temp12-price = '79'.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-productid = `HT-8000`.
    temp12-name = `ITelO FlexTop I4000`.
    temp12-width = `31`.
    temp12-depth = `19`.
    temp12-height = `3.1`.
    temp12-dimunit = `cm`.
    temp12-quantity = 11.
    temp12-price = '799'.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-productid = `HT-8001`.
    temp12-name = `ITelO FlexTop I6300c`.
    temp12-width = `32`.
    temp12-depth = `20`.
    temp12-height = `3.4`.
    temp12-dimunit = `cm`.
    temp12-quantity = 20.
    temp12-price = '799'.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-productid = `HT-8002`.
    temp12-name = `ITelO FlexTop I9100`.
    temp12-width = `38`.
    temp12-depth = `21`.
    temp12-height = `4.1`.
    temp12-dimunit = `cm`.
    temp12-quantity = 20.
    temp12-price = '1199'.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-productid = `HT-8003`.
    temp12-name = `ITelO FlexTop I9800`.
    temp12-width = `48`.
    temp12-depth = `31`.
    temp12-height = `4.5`.
    temp12-dimunit = `cm`.
    temp12-quantity = 22.
    temp12-price = '1388'.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-productid = `PF-1000`.
    temp12-name = `Flyer`.
    temp12-width = `46`.
    temp12-depth = `30`.
    temp12-height = `3`.
    temp12-dimunit = `cm`.
    temp12-quantity = 33.
    temp12-price = '0'.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-productid = `HT-9999`.
    temp12-name = `Maxi Tablet`.
    temp12-width = `48`.
    temp12-depth = `31`.
    temp12-height = `4.5`.
    temp12-dimunit = `cm`.
    temp12-quantity = 20.
    temp12-price = '749'.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-productid = `HT-9998`.
    temp12-name = `Smartphone Beta`.
    temp12-width = `48`.
    temp12-depth = `31`.
    temp12-height = `4.5`.
    temp12-dimunit = `cm`.
    temp12-quantity = 21.
    temp12-price = '30'.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-productid = `HT-9997`.
    temp12-name = `e-Book Reader ReadMe`.
    temp12-width = `48`.
    temp12-depth = `31`.
    temp12-height = `4.5`.
    temp12-dimunit = `cm`.
    temp12-quantity = 23.
    temp12-price = '33'.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-productid = `HT-9996`.
    temp12-name = `Tablet Pouch`.
    temp12-width = `25`.
    temp12-depth = `40`.
    temp12-height = `4.5`.
    temp12-dimunit = `cm`.
    temp12-quantity = 34.
    temp12-price = '20'.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-productid = `HT-9995`.
    temp12-name = `Smartphone Cover`.
    temp12-width = `48`.
    temp12-depth = `31`.
    temp12-height = `4.5`.
    temp12-dimunit = `cm`.
    temp12-quantity = 23.
    temp12-price = '15'.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-productid = `HT-9994`.
    temp12-name = `Camcorder View`.
    temp12-width = `48`.
    temp12-depth = `31`.
    temp12-height = `27`.
    temp12-dimunit = `cm`.
    temp12-quantity = 50.
    temp12-price = '1388'.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-productid = `HT-9993`.
    temp12-name = `Mini Tablet`.
    temp12-width = `48`.
    temp12-depth = `31`.
    temp12-height = `4.5`.
    temp12-dimunit = `cm`.
    temp12-quantity = 10.
    temp12-price = '833'.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-productid = `HT-9992`.
    temp12-name = `Smartphone Alpha`.
    temp12-width = `48`.
    temp12-depth = `31`.
    temp12-height = `4.5`.
    temp12-dimunit = `cm`.
    temp12-quantity = 13.
    temp12-price = '599'.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-productid = `HT-9991`.
    temp12-name = `Smartphone Leather Case`.
    temp12-width = `48`.
    temp12-depth = `31`.
    temp12-height = `4.5`.
    temp12-dimunit = `cm`.
    temp12-quantity = 12.
    temp12-price = '25'.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-productid = `HT-1251`.
    temp12-name = `Astro Laptop 1516`.
    temp12-width = `30`.
    temp12-depth = `18`.
    temp12-height = `3`.
    temp12-dimunit = `cm`.
    temp12-quantity = 23.
    temp12-price = '989'.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-productid = `HT-1252`.
    temp12-name = `Astro Phone 6`.
    temp12-width = `8`.
    temp12-depth = `6`.
    temp12-height = `1.5`.
    temp12-dimunit = `cm`.
    temp12-quantity = 28.
    temp12-price = '649'.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-productid = `HT-1253`.
    temp12-name = `Benda Laptop 1408`.
    temp12-width = `30`.
    temp12-depth = `18`.
    temp12-height = `3`.
    temp12-dimunit = `cm`.
    temp12-quantity = 27.
    temp12-price = '976'.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-productid = `HT-1254`.
    temp12-name = `Bending Screen 21HD`.
    temp12-width = `37`.
    temp12-depth = `12`.
    temp12-height = `36`.
    temp12-dimunit = `cm`.
    temp12-quantity = 23.
    temp12-price = '250'.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-productid = `HT-1255`.
    temp12-name = `Broad Screen 22HD`.
    temp12-width = `39`.
    temp12-depth = `12`.
    temp12-height = `38`.
    temp12-dimunit = `cm`.
    temp12-quantity = 5.
    temp12-price = '270'.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-productid = `HT-1256`.
    temp12-name = `Cerdik Phone 7`.
    temp12-width = `9`.
    temp12-depth = `15`.
    temp12-height = `1.5`.
    temp12-dimunit = `cm`.
    temp12-quantity = 19.
    temp12-price = '549'.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-productid = `HT-1257`.
    temp12-name = `Cepat Tablet 10.5`.
    temp12-width = `48`.
    temp12-depth = `31`.
    temp12-height = `4.5`.
    temp12-dimunit = `cm`.
    temp12-quantity = 17.
    temp12-price = '549'.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp12-productid = `HT-1258`.
    temp12-name = `Cepat Tablet 8`.
    temp12-width = `38`.
    temp12-depth = `21`.
    temp12-height = `3.5`.
    temp12-dimunit = `cm`.
    temp12-quantity = 24.
    temp12-price = '529'.
    temp12-currencycode = `EUR`.
    INSERT temp12 INTO TABLE temp11.
    temp6-productcollection = temp11.
    INSERT temp6 INTO TABLE temp5.
    t_purchases = temp5.

  ENDMETHOD.

ENDCLASS.
