CLASS z2ui5_cl_dmo_app_233 DEFINITION PUBLIC.

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
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.
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
    DATA t_purchases TYPE STANDARD TABLE OF ty_s_purchase WITH EMPTY KEY.

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


CLASS z2ui5_cl_dmo_app_233 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`       v = `sap.m`
        )->a( n = `xmlns:mvc`   v = `sap.ui.core.mvc`
        )->a( n = `xmlns:uxap`  v = `sap.uxap`
        )->a( n = `xmlns:core`  v = `sap.ui.core`
        )->a( n = `xmlns:m`     v = `sap.m`
        )->a( n = `xmlns:forms` v = `sap.ui.layout.form`
        )->a( n = `height`      v = `100%`

        " Dialog.fragment.xml - loaded in the controller via oView.addDependent
        )->open( n = `dependents` ns = `mvc`
            )->open( `SelectDialog`
                )->a( n = `id`      v = `selectDialog`
                )->a( n = `title`   v = `Purchases`
                )->a( n = `items`   v = client->_bind( t_purchases )
                " handleValueHelpSearch/_getCombinedFilter build an OR over PurchaseID
                " and SupplierName. The compound binding_call payload is one JSON
                " string, so the value cannot be substituted client-side - the search
                " round-trips and the backend issues the compound filter (app 022 idiom)
                )->a( n = `search`  v = client->_event( val   = `VH_SEARCH`
                                                        t_arg = VALUE #( ( `${$parameters>/value}` ) ) )
                )->a( n = `confirm` v = client->_event( val   = `VH_CONFIRM`
                                                        t_arg = VALUE #( ( `${$parameters>/selectedItem}.getDescription()` ) ) )

                )->leaf( `StandardListItem`
                    )->a( n = `title`       v = `{SUPPLIERNAME}`
                    )->a( n = `description` v = `{PURCHASEID}`

            )->shut(
        )->shut(

        )->open( n = `ObjectPageLayout` ns = `uxap`
            )->a( n = `id`                     v = `ObjectPageLayout`
            )->a( n = `showHeaderContent`      v = client->_bind( has_selection )
            )->a( n = `toggleHeaderOnTitleClick` v = client->_bind( has_selection )
            )->a( n = `upperCaseAnchorBar`     v = `false`

            )->open( n = `headerTitle` ns = `uxap`
                )->open( n = `ObjectPageDynamicHeaderTitle` ns = `uxap`

                    )->open( n = `heading` ns = `uxap`
                        " Input.fragment.xml
                        )->open( `Input`
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
                            " opens unfiltered: the original pre-filters and calls open(sInputValue) - see meta deviation
                            " _filterAndOpenValueHelpDialog opens the dialog with the
                            " current input value: open( ) takes that search string
                            )->a( n = `valueHelpRequest` v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                                       t_arg = VALUE #( ( `selectDialog` )
                                                                                                     ( `open` )
                                                                                                     ( `$event.oSource.getValue()` ) ) )
                            )->a( n = `suggestionItems` v = client->_bind( t_purchases )
                            )->a( n = `suggestionItemSelected` v = client->_event( val   = `SUGGEST`
                                                                                   t_arg = VALUE #( ( `${$parameters>/selectedItem}.getKey()` ) ) )

                            )->open( `suggestionItems`
                                )->leaf( n = `ListItem` ns = `core`
                                    )->a( n = `key`            v = `{PURCHASEID}`
                                    )->a( n = `text`           v = `{SUPPLIERNAME}`
                                    )->a( n = `additionalText` v = `{PURCHASEID}`

                            )->shut(
                        )->shut(
                    )->shut(
                )->shut(
            )->shut(

            )->open( n = `headerContent` ns = `uxap`
                " HeaderContent.fragment.xml
                )->open( `FlexBox`
                    )->a( n = `wrap`         v = `Wrap`
                    )->a( n = `fitContainer` v = `true`

                    )->open( `VBox`
                        )->a( n = `class` v = `sapUiLargeMarginEnd`

                        )->open( `HBox`
                            )->leaf( `Title`
                                )->a( n = `text` v = `Receipt Information`

                        )->shut(
                        )->open( `HBox`
                            )->leaf( `Label`
                                )->a( n = `class` v = `sapUiTinyMarginEnd`
                                )->a( n = `text`  v = `Category:`
                            )->leaf( `Text`
                                )->a( n = `text` v = client->_bind( sel_category )

                        )->shut(
                        )->open( `HBox`
                            )->leaf( `Label`
                                )->a( n = `class` v = `sapUiTinyMarginEnd`
                                )->a( n = `text`  v = `Sub-Category:`
                            )->leaf( `Text`
                                )->a( n = `text` v = client->_bind( sel_subcategory )

                        )->shut(
                        )->open( `HBox`
                            )->leaf( `Label`
                                )->a( n = `class` v = `sapUiTinyMarginEnd`
                                )->a( n = `text`  v = `Supplier:`
                            )->leaf( `Text`
                                )->a( n = `text` v = client->_bind( sel_suppliername )

                        )->shut(
                        )->open( `HBox`
                            )->leaf( `Label`
                                )->a( n = `class` v = `sapUiTinyMarginEnd`
                                )->a( n = `text`  v = `Payment Type:`
                            )->leaf( `Text`
                                )->a( n = `text` v = client->_bind( sel_paymenttype )

                        )->shut(
                    )->shut(

                    )->open( `VBox`
                        )->open( `HBox`
                            )->leaf( `Title`
                                )->a( n = `text` v = `Delivery Status`

                        )->shut(
                        )->open( `HBox`
                            )->leaf( `ObjectStatus`
                                )->a( n = `class` v = `sapMObjectStatusLarge`
                                )->a( n = `text`  v = client->_bind( sel_deliverystatus )
                                )->a( n = `state` v = client->_bind( sel_delivery_state )

                        )->shut(
                    )->shut(
                )->shut(
            )->shut(

            )->open( n = `sections` ns = `uxap`

                " IllustratedMessage.fragment.xml
                )->open( n = `ObjectPageSection` ns = `uxap`
                    )->a( n = `showTitle` v = `false`
                    )->a( n = `visible`   v = |\{= !${ client->_bind( has_selection ) } \}|

                    )->open( n = `subSections` ns = `uxap`
                        )->open( n = `ObjectPageSubSection` ns = `uxap`
                            )->a( n = `class` v = `sapUxAPObjectPageSubSectionFitContainer`

                            )->leaf( n = `IllustratedMessage` ns = `m`
                                )->a( n = `illustrationType` v = |\{= ${ client->_bind( inputpopulated ) } ? 'sapIllus-UnableToUpload' : 'sapIllus-NoSearchResults' \}|
                                )->a( n = `title`            v = |\{= ${ client->_bind( inputpopulated ) } ? 'Purchase not found' : 'Enter purchase ID' \}|
                                )->a( n = `description`      v = |\{= ${ client->_bind( inputpopulated ) } ? 'No matching items found' : 'Enter the purchase order ID for the goods receipt.' \}|

                        )->shut(
                    )->shut(
                )->shut(

                " ProductsTable.fragment.xml
                )->open( n = `ObjectPageSection` ns = `uxap`
                    )->a( n = `title`   v = `Products`
                    )->a( n = `visible` v = client->_bind( has_selection )

                    )->open( n = `subSections` ns = `uxap`
                        )->open( n = `ObjectPageSubSection` ns = `uxap`

                            )->open( `Table`
                                )->a( n = `id`    v = `idProductsTable`
                                )->a( n = `items` v = client->_bind( sel_products )
                                )->a( n = `class` v = `sapUxAPObjectPageSubSectionAlignContent`
                                )->a( n = `width` v = `auto`

                                )->open( `headerToolbar`
                                    )->open( `Toolbar`
                                        )->leaf( `Title`
                                            )->a( n = `text`  v = `Products`
                                            )->a( n = `level` v = `H2`

                                    )->shut(
                                )->shut(

                                )->open( `columns`
                                    )->open( `Column`
                                        )->a( n = `width` v = `12rem`
                                        )->leaf( `Text`
                                            )->a( n = `text` v = `Product`

                                    )->shut(
                                    )->open( `Column`
                                        )->a( n = `minScreenWidth` v = `Tablet`
                                        )->a( n = `demandPopin`    v = `true`
                                        )->a( n = `hAlign`         v = `End`
                                        )->leaf( `Text`
                                            )->a( n = `text` v = `Dimensions`

                                    )->shut(
                                    )->open( `Column`
                                        )->a( n = `minScreenWidth` v = `Tablet`
                                        )->a( n = `demandPopin`    v = `true`
                                        )->a( n = `hAlign`         v = `End`
                                        )->leaf( `Text`
                                            )->a( n = `text` v = `Quantity`

                                    )->shut(
                                    )->open( `Column`
                                        )->a( n = `hAlign` v = `End`
                                        )->leaf( `Text`
                                            )->a( n = `text` v = `Price`

                                    )->shut(
                                )->shut(

                                )->open( `items`
                                    )->open( `ColumnListItem`
                                        )->open( `cells`
                                            )->leaf( `ObjectIdentifier`
                                                )->a( n = `title` v = `{NAME}`
                                                )->a( n = `text`  v = `{PRODUCTID}`
                                            )->leaf( `Text`
                                                )->a( n = `text` v = `{WIDTH} x {DEPTH} x {HEIGHT} {DIMUNIT}`
                                            )->leaf( `Text`
                                                )->a( n = `text` v = `{QUANTITY} each`
                                            )->leaf( `ObjectNumber`
                                                )->a( n = `number` v = |\{ parts: [ \{ path: 'PRICE' \}, \{ path: 'CURRENCYCODE' \} ], type: 'sap.ui.model.type.Currency', formatOptions: \{ showMeasure: false \} \}|
                                                )->a( n = `unit`   v = `{CURRENCYCODE}`

                                        )->shut(
                                    )->shut(
                                )->shut(
                            )->shut(
                        )->shut(
                    )->shut(
                )->shut(

                " SupplierDetails.fragment.xml
                )->open( n = `ObjectPageSection` ns = `uxap`
                    )->a( n = `title`   v = `Supplier details`
                    )->a( n = `visible` v = client->_bind( has_selection )

                    )->open( n = `subSections` ns = `uxap`
                        )->open( n = `ObjectPageSubSection` ns = `uxap`
                            )->a( n = `title` v = `Connect`

                            )->open( n = `blocks` ns = `uxap`
                                )->open( n = `SimpleForm` ns = `forms`
                                    )->a( n = `layout`   v = `ColumnLayout`
                                    )->a( n = `width`    v = `100%`
                                    )->a( n = `class`    v = `sapUxAPObjectPageSubSectionAlignContent`
                                    )->a( n = `columnsM` v = `2`
                                    )->a( n = `columnsL` v = `3`
                                    )->a( n = `columnsXL` v = `4`

                                    )->leaf( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Phone Numbers`
                                    )->leaf( `Label`
                                        )->a( n = `text` v = `Home`
                                    )->leaf( `Text`
                                        )->a( n = `text` v = `+ 1 415-321-1234`
                                    )->leaf( `Label`
                                        )->a( n = `text` v = `Office phone`
                                    )->leaf( `Text`
                                        )->a( n = `text` v = `+ 1 415-321-5555`
                                    )->leaf( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Social Accounts`
                                    )->leaf( `Label`
                                        )->a( n = `text` v = `LinkedIn`
                                    )->leaf( `Text`
                                        )->a( n = `text` v = `/DeniseSmith`
                                    )->leaf( `Label`
                                        )->a( n = `text` v = `Twitter`
                                    )->leaf( `Text`
                                        )->a( n = `text` v = `@DeniseSmith`
                                    )->leaf( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Addresses`
                                    )->leaf( `Label`
                                        )->a( n = `text` v = `Home Address`
                                    )->leaf( `Text`
                                        )->a( n = `text` v = `2096 Mission Street`
                                    )->leaf( `Label`
                                        )->a( n = `text` v = `Mailing Address`
                                    )->leaf( `Text`
                                        )->a( n = `text` v = `PO Box 32114`
                                    )->leaf( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Mailing Address`
                                    )->leaf( `Label`
                                        )->a( n = `text` v = `Work`
                                    )->leaf( `Text`
                                        )->a( n = `text` v = `DeniseSmith@sap.com`

                                )->shut(
                            )->shut(
                        )->shut(

                        )->open( n = `ObjectPageSubSection` ns = `uxap`
                            )->a( n = `title` v = `Payment information`

                            )->open( n = `blocks` ns = `uxap`
                                )->open( n = `SimpleForm` ns = `forms`
                                    )->a( n = `layout`    v = `ColumnLayout`
                                    )->a( n = `width`     v = `100%`
                                    )->a( n = `class`     v = `sapUxAPObjectPageSubSectionAlignContent`
                                    )->a( n = `columnsM`  v = `2`
                                    )->a( n = `columnsL`  v = `3`
                                    )->a( n = `columnsXL` v = `4`

                                    )->leaf( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Main Payment Method`
                                    )->leaf( `Label`
                                        )->a( n = `text` v = `Bank Transfer`
                                    )->leaf( `Text`
                                        )->a( n = `text` v = `Sparkasse Heimfeld, Germany`

                                )->shut(
                            )->shut(
                        )->shut(
                    )->shut(
                )->shut(
            )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `SUBMIT`.
        " handleInputSubmit: the entered value (two-way bound) selects the purchase
        IF input_value IS NOT INITIAL.
          set_selection( input_value ).
        ELSE.
          inputpopulated = abap_false.
          has_selection  = abap_false.
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
        DATA(search_value) = client->get_event_arg( ).
        client->follow_up_action(
            val   = client->cs_event-binding_call
            t_arg = VALUE #( ( `selectDialog` )
                             ( `items` )
                             ( `filter` )
                             ( |[[["PURCHASEID","Contains","{ search_value }"],["SUPPLIERNAME","Contains","{ search_value }"]]]| ) ) ).

      WHEN `VH_CONFIRM`.
        " handleValueHelpConfirm: the picked item's description = PurchaseID
        set_selection( client->get_event_arg( ) ).
        view_display( ).

    ENDCASE.

  ENDMETHOD.


  METHOD set_selection.

    " _setSelectedPurchaseAndUpdateInput: resolve the purchase by PurchaseID and
    " seed the flattened /selectedPurchase fields; if none is found, force "no
    " selection" so the IllustratedMessage "not found" state shows
    input_value    = key.
    inputpopulated = abap_true.

    READ TABLE t_purchases INTO DATA(purchase) WITH KEY purchaseid = key.
    IF sy-subrc = 0.
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

    " no purchase selected yet - seed the ObjectStatus state with the formatter's
    " default ValueState (None) so the enum property is valid before a selection
    sel_delivery_state = `None`.

    t_purchases = VALUE #(
      ( purchaseid = `123` suppliername = `BestEastern` category = `Computers` subcategory = `Laptops`
        paymenttype = `Invoice` deliverystatus = `Not Completed` deliverystatus_state = `None`
        productcollection = VALUE #(
          ( productid = `HT-1000` name = `Notebook Basic 15` width = `30` depth = `18` height = `3` dimunit = `cm` quantity = 10 price = '956' currencycode = `EUR` )
          ( productid = `HT-1001` name = `Notebook Basic 17` width = `29` depth = `17` height = `3.1` dimunit = `cm` quantity = 20 price = '1249' currencycode = `EUR` )
          ( productid = `HT-1002` name = `Notebook Basic 18` width = `28` depth = `19` height = `2.5` dimunit = `cm` quantity = 10 price = '1570' currencycode = `EUR` )
          ( productid = `HT-6132` name = `Flat Watch HD41` width = `128` depth = `23` height = `79.1` dimunit = `cm` quantity = 13 price = '899' currencycode = `EUR` )
          ( productid = `HT-7030` name = `Platinberry` width = `8.1` depth = `13` height = `12.1` dimunit = `cm` quantity = 12 price = '549' currencycode = `EUR` )
          ( productid = `HT-7020` name = `Goldberry` width = `8.1` depth = `13` height = `12.1` dimunit = `cm` quantity = 11 price = '549' currencycode = `EUR` )
          ( productid = `HT-7010` name = `Silverberry` width = `8.1` depth = `13` height = `12.1` dimunit = `cm` quantity = 9 price = '549' currencycode = `EUR` )
          ( productid = `HT-7000` name = `Copperberry` width = `8.1` depth = `13` height = `12.1` dimunit = `cm` quantity = 5 price = '549' currencycode = `EUR` )
          ( productid = `HT-1095` name = `Lovely Sound 5.1 Wireless` width = `24` depth = `19` height = `23` dimunit = `cm` quantity = 12 price = '49' currencycode = `EUR` )
          ( productid = `HT-1096` name = `Lovely Sound 5.1` width = `25` depth = `17` height = `19` dimunit = `cm` quantity = 18 price = '39' currencycode = `EUR` )
          ( productid = `HT-1097` name = `Lovely Sound Stereo` width = `21.3` depth = `2.4` height = `19.7` dimunit = `cm` quantity = 21 price = '29' currencycode = `EUR` )
          ( productid = `HT-6123` name = `Power Pro Player 80` width = `4` depth = `6` height = `0.8` dimunit = `cm` quantity = 13 price = '299' currencycode = `EUR` )
          ( productid = `HT-6122` name = `Power Pro Player 40` width = `5.1` depth = `8` height = `9.2` dimunit = `cm` quantity = 23 price = '167' currencycode = `EUR` )
          ( productid = `HT-6121` name = `ITelo Jog-Mate` width = `5.1` depth = `8` height = `9.2` dimunit = `cm` quantity = 24 price = '63' currencycode = `EUR` )
          ( productid = `HT-6120` name = `ITelo MusicStick` width = `1.5` depth = `6` height = `1` dimunit = `cm` quantity = 15 price = '45' currencycode = `EUR` )
          ( productid = `HT-6111` name = `Record Movie` width = `38` depth = `26` height = `6.2` dimunit = `cm` quantity = 24 price = '288' currencycode = `EUR` )
          ( productid = `HT-6110` name = `Play Movie` width = `37` depth = `24` height = `6` dimunit = `cm` quantity = 15 price = '130' currencycode = `EUR` )
          ( productid = `HT-6102` name = `Beam Breaker B-3` width = `30.4` depth = `23.1` height = `23` dimunit = `cm` quantity = 16 price = '889' currencycode = `EUR` )
          ( productid = `HT-6101` name = `Beam Breaker B-2` width = `30.4` depth = `23.1` height = `23` dimunit = `cm` quantity = 18 price = '679' currencycode = `EUR` )
          ( productid = `HT-2002` name = `Portable DVD Player with 9" LCD Monitor` width = `21` depth = `16.5` height = `14` dimunit = `cm` quantity = 50 price = '853.99' currencycode = `EUR` )
          ( productid = `HT-6100` name = `Beam Breaker B-1` width = `30.4` depth = `23.1` height = `23` dimunit = `cm` quantity = 32 price = '469' currencycode = `EUR` )
          ( productid = `HT-2027` name = `Removable CD/DVD Laser Labels` width = `5.5` depth = `2` height = `2` dimunit = `cm` quantity = 25 price = '8.99' currencycode = `EUR` )
        ) )
      ( purchaseid = `420` suppliername = `Ultrasonic` category = `Computer Peripherals` subcategory = `Monitors`
        paymenttype = `Debit Card` deliverystatus = `Shipped` deliverystatus_state = `Success`
        productcollection = VALUE #(
          ( productid = `HT-1072` name = `Hurricane GX` width = `22` depth = `35` height = `17` dimunit = `cm` quantity = 13 price = '101.2' currencycode = `EUR` )
          ( productid = `HT-1073` name = `Hurricane GX/LN` width = `22` depth = `35` height = `17` dimunit = `cm` quantity = 5 price = '139.99' currencycode = `EUR` )
          ( productid = `HT-1080` name = `Photo Scan` width = `34` depth = `48` height = `5` dimunit = `cm` quantity = 8 price = '129' currencycode = `EUR` )
          ( productid = `HT-1081` name = `Power Scan` width = `31` depth = `43` height = `7` dimunit = `cm` quantity = 11 price = '89' currencycode = `EUR` )
          ( productid = `HT-1082` name = `Jet Scan Professional` width = `33` depth = `41` height = `12` dimunit = `cm` quantity = 13 price = '169' currencycode = `EUR` )
          ( productid = `HT-1083` name = `Jet Scan Professional` width = `35` depth = `40` height = `10` dimunit = `cm` quantity = 10 price = '189' currencycode = `EUR` )
          ( productid = `HT-1085` name = `Copymaster` width = `45` depth = `42` height = `22` dimunit = `cm` quantity = 10 price = '1499' currencycode = `EUR` )
          ( productid = `HT-1090` name = `Surround Sound` width = `12` depth = `10` height = `16` dimunit = `cm` quantity = 20 price = '39' currencycode = `EUR` )
          ( productid = `HT-1091` name = `Blaster Extreme` width = `13` depth = `11` height = `17.5` dimunit = `cm` quantity = 15 price = '26' currencycode = `EUR` )
          ( productid = `HT-1092` name = `Sound Booster` width = `12.4` depth = `10.4` height = `18.1` dimunit = `cm` quantity = 50 price = '45' currencycode = `EUR` )
          ( productid = `HT-1100` name = `Smart Office` width = `15` depth = `6.5` height = `2.1` dimunit = `cm` quantity = 25 price = '89.9' currencycode = `EUR` )
          ( productid = `HT-1101` name = `Smart Design` width = `14` depth = `6.7` height = `24` dimunit = `cm` quantity = 26 price = '79.9' currencycode = `EUR` )
          ( productid = `HT-1102` name = `Smart Network` width = `16` depth = `6` height = `27` dimunit = `cm` quantity = 28 price = '69' currencycode = `EUR` )
          ( productid = `HT-1103` name = `Smart Multimedia` width = `11` depth = `3.4` height = `22` dimunit = `cm` quantity = 9 price = '77' currencycode = `EUR` )
          ( productid = `HT-1104` name = `Smart Games` width = `10` depth = `3` height = `30` dimunit = `cm` quantity = 13 price = '55' currencycode = `EUR` )
          ( productid = `HT-1105` name = `Smart Internet Antivirus` width = `16` depth = `4` height = `21` dimunit = `cm` quantity = 17 price = '29' currencycode = `EUR` )
          ( productid = `HT-1106` name = `Smart Firewall` width = `17.9` depth = `4.2` height = `23.1` dimunit = `cm` quantity = 19 price = '34' currencycode = `EUR` )
          ( productid = `HT-1107` name = `Smart Money` width = `12` depth = `1.5` height = `19` dimunit = `cm` quantity = 18 price = '29.9' currencycode = `EUR` )
          ( productid = `HT-1110` name = `PC Lock` width = `20` depth = `8` height = `4.3` dimunit = `cm` quantity = 14 price = '8.9' currencycode = `EUR` )
          ( productid = `HT-1111` name = `Notebook Lock` width = `31` depth = `9` height = `7` dimunit = `cm` quantity = 20 price = '6.9' currencycode = `EUR` )
          ( productid = `HT-1112` name = `Web cam reality` width = `9` depth = `8.2` height = `1.3` dimunit = `cm` quantity = 27 price = '39' currencycode = `EUR` )
          ( productid = `HT-1113` name = `Screen clean` width = `2` depth = `2` height = `0.1` dimunit = `cm` quantity = 17 price = '2.3' currencycode = `EUR` )
          ( productid = `HT-1114` name = `Fabric bag professional` width = `42` depth = `32` height = `7` dimunit = `cm` quantity = 14 price = '31' currencycode = `EUR` )
          ( productid = `HT-1115` name = `Wireless DSL Router` width = `19.3` depth = `18` height = `5` dimunit = `cm` quantity = 16 price = '49' currencycode = `EUR` )
          ( productid = `HT-1116` name = `Wireless DSL Router / Repeater` width = `19.3` depth = `18` height = `5` dimunit = `cm` quantity = 12 price = '59' currencycode = `EUR` )
          ( productid = `HT-1117` name = `Wireless DSL Router / Repeater and Print Server` width = `19.3` depth = `18` height = `5` dimunit = `cm` quantity = 12 price = '69' currencycode = `EUR` )
          ( productid = `HT-1118` name = `USB Stick` width = `1.5` depth = `8.7` height = `1.2` dimunit = `cm` quantity = 14 price = '35' currencycode = `EUR` )
          ( productid = `HT-1120` name = `Cordless Bluetooth Keyboard, english international` width = `51.4` depth = `23` height = `4` dimunit = `cm` quantity = 13 price = '29' currencycode = `EUR` )
          ( productid = `HT-1137` name = `Flat XXL` width = `54` depth = `22` height = `38` dimunit = `cm` quantity = 10 price = '1430' currencycode = `EUR` )
          ( productid = `HT-1138` name = `Pocket Mouse` width = `0.3` depth = `0.5` height = `1` dimunit = `cm` quantity = 20 price = '23' currencycode = `EUR` )
          ( productid = `HT-1210` name = `PC Power Station` width = `28` depth = `31` height = `43` dimunit = `cm` quantity = 22 price = '2399' currencycode = `EUR` )
          ( productid = `HT-1500` name = `Server Basic` width = `34` depth = `35` height = `23` dimunit = `cm` quantity = 24 price = '5000' currencycode = `EUR` )
          ( productid = `HT-1501` name = `Server Professional` width = `29` depth = `30` height = `27` dimunit = `cm` quantity = 26 price = '15000' currencycode = `EUR` )
          ( productid = `HT-1502` name = `Server Power Pro` width = `22` depth = `27.3` height = `37` dimunit = `cm` quantity = 34 price = '25000' currencycode = `EUR` )
          ( productid = `HT-6130` name = `Flat Watch HD32` width = `78` depth = `22.1` height = `55` dimunit = `cm` quantity = 16 price = '1459' currencycode = `EUR` )
          ( productid = `HT-6131` name = `Flat Watch HD37` width = `99.1` depth = `26` height = `61` dimunit = `cm` quantity = 14 price = '1199' currencycode = `EUR` )
        ) )
      ( purchaseid = `321` suppliername = `Technocom` category = `Computer Hardware` subcategory = `Video Cards`
        paymenttype = `Credit Card` deliverystatus = `Failed Shipping` deliverystatus_state = `Error`
        productcollection = VALUE #(
          ( productid = `HT-1003` name = `Notebook Basic 19` width = `32` depth = `21` height = `4` dimunit = `cm` quantity = 15 price = '1650' currencycode = `EUR` )
          ( productid = `HT-1007` name = `ITelO Vault` width = `32` depth = `22` height = `3` dimunit = `cm` quantity = 15 price = '299' currencycode = `EUR` )
          ( productid = `HT-1010` name = `Notebook Professional 15` width = `33` depth = `20` height = `3` dimunit = `cm` quantity = 16 price = '1999' currencycode = `EUR` )
          ( productid = `HT-2026` name = `Audio/Video Cable Kit - 4m` width = `21` depth = `10.2` height = `13` dimunit = `cm` quantity = 16 price = '29.99' currencycode = `EUR` )
          ( productid = `HT-2025` name = `CD/DVD case: 264 sleeves` width = `13` depth = `13` height = `20` dimunit = `cm` quantity = 26 price = '44.99' currencycode = `EUR` )
          ( productid = `HT-2001` name = `10" Portable DVD player` width = `24` depth = `19.5` height = `29` dimunit = `cm` quantity = 21 price = '449.99' currencycode = `EUR` )
          ( productid = `HT-2000` name = `7" Widescreen Portable DVD Player w MP3` width = `21.4` depth = `19` height = `27.6` dimunit = `cm` quantity = 20 price = '249.99' currencycode = `EUR` )
          ( productid = `HT-1603` name = `Gaming Monster Pro` width = `27` depth = `28` height = `42` dimunit = `cm` quantity = 25 price = '1700' currencycode = `EUR` )
          ( productid = `HT-1602` name = `Gaming Monster` width = `26.5` depth = `34` height = `47` dimunit = `cm` quantity = 24 price = '1200' currencycode = `EUR` )
          ( productid = `HT-1601` name = `Family PC Pro` width = `25` depth = `31.7` height = `40.2` dimunit = `cm` quantity = 20 price = '900' currencycode = `EUR` )
          ( productid = `HT-1600` name = `Family PC Basic` width = `21.4` depth = `29` height = `38` dimunit = `cm` quantity = 10 price = '600' currencycode = `EUR` )
          ( productid = `HT-1119` name = `Travel Adapter` width = `2` depth = `3.1` height = `3.9` dimunit = `cm` quantity = 10 price = '79' currencycode = `EUR` )
          ( productid = `HT-8000` name = `ITelO FlexTop I4000` width = `31` depth = `19` height = `3.1` dimunit = `cm` quantity = 11 price = '799' currencycode = `EUR` )
          ( productid = `HT-8001` name = `ITelO FlexTop I6300c` width = `32` depth = `20` height = `3.4` dimunit = `cm` quantity = 20 price = '799' currencycode = `EUR` )
          ( productid = `HT-8002` name = `ITelO FlexTop I9100` width = `38` depth = `21` height = `4.1` dimunit = `cm` quantity = 20 price = '1199' currencycode = `EUR` )
          ( productid = `HT-8003` name = `ITelO FlexTop I9800` width = `48` depth = `31` height = `4.5` dimunit = `cm` quantity = 22 price = '1388' currencycode = `EUR` )
          ( productid = `PF-1000` name = `Flyer` width = `46` depth = `30` height = `3` dimunit = `cm` quantity = 33 price = '0' currencycode = `EUR` )
          ( productid = `HT-9999` name = `Maxi Tablet` width = `48` depth = `31` height = `4.5` dimunit = `cm` quantity = 20 price = '749' currencycode = `EUR` )
          ( productid = `HT-9998` name = `Smartphone Beta` width = `48` depth = `31` height = `4.5` dimunit = `cm` quantity = 21 price = '30' currencycode = `EUR` )
          ( productid = `HT-9997` name = `e-Book Reader ReadMe` width = `48` depth = `31` height = `4.5` dimunit = `cm` quantity = 23 price = '33' currencycode = `EUR` )
          ( productid = `HT-9996` name = `Tablet Pouch` width = `25` depth = `40` height = `4.5` dimunit = `cm` quantity = 34 price = '20' currencycode = `EUR` )
          ( productid = `HT-9995` name = `Smartphone Cover` width = `48` depth = `31` height = `4.5` dimunit = `cm` quantity = 23 price = '15' currencycode = `EUR` )
          ( productid = `HT-9994` name = `Camcorder View` width = `48` depth = `31` height = `27` dimunit = `cm` quantity = 50 price = '1388' currencycode = `EUR` )
          ( productid = `HT-9993` name = `Mini Tablet` width = `48` depth = `31` height = `4.5` dimunit = `cm` quantity = 10 price = '833' currencycode = `EUR` )
          ( productid = `HT-9992` name = `Smartphone Alpha` width = `48` depth = `31` height = `4.5` dimunit = `cm` quantity = 13 price = '599' currencycode = `EUR` )
          ( productid = `HT-9991` name = `Smartphone Leather Case` width = `48` depth = `31` height = `4.5` dimunit = `cm` quantity = 12 price = '25' currencycode = `EUR` )
          ( productid = `HT-1251` name = `Astro Laptop 1516` width = `30` depth = `18` height = `3` dimunit = `cm` quantity = 23 price = '989' currencycode = `EUR` )
          ( productid = `HT-1252` name = `Astro Phone 6` width = `8` depth = `6` height = `1.5` dimunit = `cm` quantity = 28 price = '649' currencycode = `EUR` )
          ( productid = `HT-1253` name = `Benda Laptop 1408` width = `30` depth = `18` height = `3` dimunit = `cm` quantity = 27 price = '976' currencycode = `EUR` )
          ( productid = `HT-1254` name = `Bending Screen 21HD` width = `37` depth = `12` height = `36` dimunit = `cm` quantity = 23 price = '250' currencycode = `EUR` )
          ( productid = `HT-1255` name = `Broad Screen 22HD` width = `39` depth = `12` height = `38` dimunit = `cm` quantity = 5 price = '270' currencycode = `EUR` )
          ( productid = `HT-1256` name = `Cerdik Phone 7` width = `9` depth = `15` height = `1.5` dimunit = `cm` quantity = 19 price = '549' currencycode = `EUR` )
          ( productid = `HT-1257` name = `Cepat Tablet 10.5` width = `48` depth = `31` height = `4.5` dimunit = `cm` quantity = 17 price = '549' currencycode = `EUR` )
          ( productid = `HT-1258` name = `Cepat Tablet 8` width = `38` depth = `21` height = `3.5` dimunit = `cm` quantity = 24 price = '529' currencycode = `EUR` )
        ) )
    ).

  ENDMETHOD.

ENDCLASS.
