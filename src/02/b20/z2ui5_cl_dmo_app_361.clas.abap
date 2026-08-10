CLASS z2ui5_cl_dmo_app_361 DEFINITION PUBLIC.

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
    DATA t_products   TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.
    DATA t_suppliers  TYPE STANDARD TABLE OF ty_s_name WITH EMPTY KEY.
    DATA t_categories TYPE STANDARD TABLE OF ty_s_name WITH EMPTY KEY.

    " the two Selects of the original's `selectionmodel>` model, folded onto
    " the one default model
    DATA t_selectionitems TYPE STANDARD TABLE OF ty_s_key WITH EMPTY KEY.
    DATA t_behavioritems  TYPE STANDARD TABLE OF ty_s_key WITH EMPTY KEY.

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


CLASS z2ui5_cl_dmo_app_361 IMPLEMENTATION.

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

    " the selection demo: selectionMode, selectionBehavior and enableSelectAll
    " are bound properties driven by the two Selects and the Switch, and the
    " table reports its selection through rowSelectionChange so the three
    " toolbar buttons can report it from the model.
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.ui.table`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:u`   v = `sap.ui.unified`
        )->a( n = `xmlns:c`   v = `sap.ui.core`
        )->a( n = `xmlns:m`   v = `sap.m`
        )->a( n = `height`    v = `100%`

        )->open( n = `Page` ns = `m`
            )->a( n = `showHeader`      v = `false`
            )->a( n = `enableScrolling` v = `false`
            )->a( n = `class`           v = `sapUiContentPadding`

            )->open( n = `content` ns = `m`
                )->leaf( n = `Label` ns = `m`
                    )->a( n = `text`     v = `Selection Mode`
                    )->a( n = `labelFor` v = `select1`

                )->open( n = `Select` ns = `m`
                    )->a( n = `id`          v = `select1`
                    )->a( n = `width`       v = `100%`
                    )->a( n = `items`       v = client->_bind( t_selectionitems )
                    )->a( n = `selectedKey` v = client->_bind( select_mode_key )
                    )->a( n = `change`      v = client->_event( `MODE_CHANGE` )

                    )->leaf( n = `Item` ns = `c`
                        )->a( n = `key`  v = `{KEY}`
                        )->a( n = `text` v = `{TEXT}`

                )->shut(
                )->leaf( n = `Label` ns = `m`
                    )->a( n = `text`     v = `Selection Behavior`
                    )->a( n = `labelFor` v = `select2`

                )->open( n = `Select` ns = `m`
                    )->a( n = `id`          v = `select2`
                    )->a( n = `width`       v = `100%`
                    )->a( n = `items`       v = client->_bind( t_behavioritems )
                    )->a( n = `selectedKey` v = client->_bind( selection_behavior )

                    )->leaf( n = `Item` ns = `c`
                        )->a( n = `key`  v = `{KEY}`
                        )->a( n = `text` v = `{TEXT}`

                )->shut(
                )->open( `Table`
                    )->a( n = `id`                 v = `table1`
                    )->a( n = `rows`               v = client->_bind( t_products )
                    )->a( n = `selectionMode`      v = client->_bind( selection_mode )
                    )->a( n = `selectionBehavior`  v = client->_bind( selection_behavior )
                    )->a( n = `enableSelectAll`    v = client->_bind( enable_select_all )
                    )->a( n = `rowSelectionChange` v = client->_event(
                              val   = `SELECTION_CHANGE`
                              t_arg = VALUE #( ( `${$parameters>/rowIndices}` ) ( `${$parameters>/rowIndex}` ) ) )
                    )->a( n = `ariaLabelledBy`     v = `title`

                    )->open( `extension`
                        )->open( n = `OverflowToolbar` ns = `m`
                            )->a( n = `style` v = `Clear`

                            )->leaf( n = `Title` ns = `m`
                                )->a( n = `id`   v = `title`
                                )->a( n = `text` v = `Products`

                            )->leaf( n = `ToolbarSpacer` ns = `m`

                            )->leaf( n = `Button` ns = `m`
                                )->a( n = `icon`    v = `sap-icon://activities`
                                )->a( n = `tooltip` v = `show indices of selected items`
                                )->a( n = `press`   v = client->_event( `SHOW_INDICES` )

                            )->leaf( n = `Button` ns = `m`
                                )->a( n = `icon`    v = `sap-icon://activity-items`
                                )->a( n = `tooltip` v = `show context of latest selection item`
                                )->a( n = `press`   v = client->_event( `SHOW_CONTEXT` )

                            )->leaf( n = `Button` ns = `m`
                                )->a( n = `icon`    v = `sap-icon://decline`
                                )->a( n = `tooltip` v = `clear selection`
                                )->a( n = `press`   v = client->_event( `CLEAR_SELECTION` )

                            )->leaf( n = `Switch` ns = `m`
                                )->a( n = `state`         v = client->_bind( enable_select_all )
                                )->a( n = `customTextOn`  v = `on`
                                )->a( n = `customTextOff` v = `off`
                                )->a( n = `tooltip`       v = `enable select all items`

                        )->shut(
                    )->shut(
                    )->open( `columns`
                        )->open( `Column`
                            )->a( n = `width` v = `11rem`

                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text` v = `Product Name`

                            )->open( `template`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{NAME}`
                                    )->a( n = `wrapping` v = `false`

                            )->shut(
                        )->shut(
                        )->open( `Column`
                            )->a( n = `width` v = `11rem`

                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text` v = `Product Id`

                            )->open( `template`
                                )->leaf( n = `Input` ns = `m`
                                    )->a( n = `value` v = `{PRODUCTID}`

                            )->shut(
                        )->shut(
                        )->open( `Column`
                            )->a( n = `width`  v = `6rem`
                            )->a( n = `hAlign` v = `End`

                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text` v = `Quantity`

                            )->open( `template`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `{QUANTITY}`

                            )->shut(
                        )->shut(
                        )->open( `Column`
                            )->a( n = `width` v = `9rem`

                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text` v = `Status`

                            )->open( `template`
                                )->leaf( n = `ObjectStatus` ns = `m`
                                    )->a( n = `text`  v = `{STATUS}`
                                    )->a( n = `state` v = `{AVAILABLESTATE}`

                            )->shut(
                        )->shut(
                        )->open( `Column`
                            )->a( n = `width` v = `9rem`

                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text` v = `Price`

                            )->open( `template`
                                )->leaf( n = `Currency` ns = `u`
                                    )->a( n = `value`    v = `{PRICE}`
                                    )->a( n = `currency` v = `{CURRENCYCODE}`

                            )->shut(
                        )->shut(
                        )->open( `Column`
                            )->a( n = `width` v = `12rem`

                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text` v = `Supplier`

                            )->open( `template`
                                )->open( n = `ComboBox` ns = `m`
                                    )->a( n = `value` v = `{SUPPLIERNAME}`
                                    )->a( n = `items` v = |\{ path: '{ client->_bind( val = t_suppliers path = abap_true ) }', templateShareable: false \}|

                                    )->leaf( n = `Item` ns = `c`
                                        )->a( n = `text` v = `{NAME}`

                                )->shut(
                            )->shut(
                        )->shut(
                        )->open( `Column`
                            )->a( n = `width` v = `9rem`

                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text` v = `Image`

                            )->open( `template`
                                )->leaf( n = `Link` ns = `m`
                                    )->a( n = `text`   v = `Show Image`
                                    )->a( n = `href`   v = `{PRODUCTPICURL}`
                                    )->a( n = `target` v = `_blank`

                            )->shut(
                        )->shut(
                        )->open( `Column`
                            )->a( n = `width` v = `9rem`

                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text` v = `Details`

                            )->open( `template`
                                )->leaf( n = `Button` ns = `m`
                                    )->a( n = `text`  v = `Show Details`
                                    )->a( n = `press` v = client->_event_client(
                                              val   = client->cs_event-control_global
                                              t_arg = VALUE #( ( `MESSAGE_TOAST` )
                                                               ( `show` )
                                                               ( `Details for product with id {0}` )
                                                               ( `${PRODUCTID}` ) ) )

                            )->shut(
                        )->shut(
                        )->open( `Column`
                            )->a( n = `width` v = `7rem`

                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text` v = `Heavy Weight`

                            )->open( `template`
                                )->leaf( n = `CheckBox` ns = `m`
                                    )->a( n = `selected` v = |\{ path: 'HEAVY', type: 'sap.ui.model.type.String' \}|

                            )->shut(
                        )->shut(
                        )->open( `Column`
                            )->a( n = `width` v = `12rem`

                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text` v = `Category`

                            )->open( `template`
                                )->open( n = `Select` ns = `m`
                                    )->a( n = `selectedKey` v = `{CATEGORY}`
                                    )->a( n = `items`       v = |\{ path: '{ client->_bind( val = t_categories path = abap_true ) }', templateShareable: false \}|

                                    )->leaf( n = `Item` ns = `c`
                                        )->a( n = `text` v = `{NAME}`
                                        )->a( n = `key`  v = `{NAME}`

                                )->shut(
                            )->shut(
                        )->shut(
                        )->open( `Column`
                            )->a( n = `width`  v = `6rem`
                            )->a( n = `hAlign` v = `Center`

                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text` v = `Status`

                            )->open( `template`
                                )->leaf( n = `Icon` ns = `c`
                                    )->a( n = `src` v = `{AVAILABLEICON}`

                            )->shut(
                        )->shut(
                        )->open( `Column`
                            )->a( n = `width`  v = `11rem`
                            )->a( n = `hAlign` v = `Center`

                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text` v = `Delivery Date`

                            )->open( `template`
                                )->leaf( n = `DatePicker` ns = `m`
                                    )->a( n = `value` v = |\{ path: 'DELIVERYDATE', type: 'sap.ui.model.type.Date', formatOptions: \{ source: \{ pattern: 'timestamp' \} \} \}|

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
        " getSelectedIndices
        client->message_toast_display( COND #( WHEN selected_indices IS INITIAL OR selected_indices = `[]`
                                               THEN `no item selected`
                                               ELSE selected_indices ) ).

      WHEN `SHOW_CONTEXT`.
        " getContextByIndex: the original toasts the binding context of the
        " last selected row, which renders as its model path
        client->message_toast_display( COND #( WHEN selected_indices IS INITIAL OR selected_indices = `[]`
                                               THEN `no item selected`
                                               ELSE |{ client->_bind( val = t_products path = abap_true ) }/{ selected_index }| ) ).

      WHEN `CLEAR_SELECTION`.
        " clearSelection: the selection lives in the control, so it is cleared
        " there - and the mirrored model state goes with it
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( `table1` ) ( `clearSelection` ) ) ).
        selected_indices = ``.
        selected_index   = 0.

    ENDCASE.

    client->view_model_update( ).

  ENDMETHOD.


  METHOD model_init.

    " the two Select item sets the controller builds from the sap.ui.table
    " SelectionMode / SelectionBehavior enums (Multi is skipped, as there)
    t_selectionitems = VALUE #(
      ( key = `MultiToggle` text = `MultiToggle` )
      ( key = `None`        text = `None` )
      ( key = `Single`      text = `Single` )
      ( key = `All`         text = `All` ) ).

    t_behavioritems = VALUE #(
      ( key = `Row`         text = `Row` )
      ( key = `RowOnly`     text = `RowOnly` )
      ( key = `RowSelector` text = `RowSelector` ) ).

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
    t_products = VALUE #(
      ( name = `Notebook Basic 15` productid = `HT-1000` quantity = 10 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 956 currencycode = `EUR` suppliername = `Very Best Screens`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg` heavy = `false` category = `Laptops` deliverydate = 1784764800000 )
      ( name = `Notebook Basic 17` productid = `HT-1001` quantity = 20 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 1249 currencycode = `EUR` suppliername = `Very Best Screens`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1001.jpg` heavy = `false` category = `Laptops` deliverydate = 1784419200000 )
      ( name = `Notebook Basic 18` productid = `HT-1002` quantity = 10 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 1570 currencycode = `EUR` suppliername = `Very Best Screens`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1002.jpg` heavy = `false` category = `Laptops` deliverydate = 1784073600000 )
      ( name = `Notebook Basic 19` productid = `HT-1003` quantity = 15 status = `Out of Stock` availablestate = `Error` availableicon = `sap-icon://decline` price = 1650 currencycode = `EUR` suppliername = `Smartcards`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1003.jpg` heavy = `false` category = `Laptops` deliverydate = 1783728000000 )
      ( name = `ITelO Vault` productid = `HT-1007` quantity = 15 status = `Out of Stock` availablestate = `Error` availableicon = `sap-icon://decline` price = 299 currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1007.jpg` heavy = `false` category = `Accessories` deliverydate = 1783382400000 )
      ( name = `Notebook Professional 15` productid = `HT-1010` quantity = 16 status = `Out of Stock` availablestate = `Error` availableicon = `sap-icon://decline` price = 1999 currencycode = `EUR` suppliername = `Very Best Screens`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg` heavy = `false` category = `Accessories` deliverydate = 1783036800000 )
      ( name = `Notebook Professional 17` productid = `HT-1011` quantity = 17 status = `Out of Stock` availablestate = `Error` availableicon = `sap-icon://decline` price = 2299 currencycode = `EUR` suppliername = `Very Best Screens`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1011.jpg` heavy = `false` category = `Laptops` deliverydate = 1782691200000 )
      ( name = `ITelO Vault Net` productid = `HT-1020` quantity = 14 status = `Discontinued` availablestate = `Error` availableicon = `sap-icon://decline` price = 459 currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1020.jpg` heavy = `false` category = `Accessories` deliverydate = 1782345600000 )
      ( name = `ITelO Vault SAT` productid = `HT-1021` quantity = 50 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 149 currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1021.jpg` heavy = `false` category = `Accessories` deliverydate = 1782000000000 )
      ( name = `Comfort Easy` productid = `HT-1022` quantity = 30 status = `Out of Stock` availablestate = `Error` availableicon = `sap-icon://decline` price = 1679 currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1022.jpg` heavy = `false` category = `Accessories` deliverydate = 1781654400000 )
      ( name = `Comfort Senior` productid = `HT-1023` quantity = 24 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 512 currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1023.jpg` heavy = `false` category = `Accessories` deliverydate = 1784764800000 )
      ( name = `Ergo Screen E-I` productid = `HT-1030` quantity = 14 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 230 currencycode = `EUR` suppliername = `Very Best Screens`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1030.jpg` heavy = `false` category = `Flat Screen Monitors` deliverydate = 1784419200000 )
      ( name = `Ergo Screen E-II` productid = `HT-1031` quantity = 24 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 285 currencycode = `EUR` suppliername = `Very Best Screens`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1031.jpg` heavy = `false` category = `Flat Screen Monitors` deliverydate = 1784073600000 )
      ( name = `Ergo Screen E-III` productid = `HT-1032` quantity = 50 status = `Out of Stock` availablestate = `Error` availableicon = `sap-icon://decline` price = 345 currencycode = `EUR` suppliername = `Very Best Screens`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1032.jpg` heavy = `false` category = `Flat Screen Monitors` deliverydate = 1783728000000 )
      ( name = `Flat Basic` productid = `HT-1035` quantity = 23 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 399 currencycode = `EUR` suppliername = `Very Best Screens`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1035.jpg` heavy = `false` category = `Flat Screen Monitors` deliverydate = 1783382400000 )
      ( name = `Flat Future` productid = `HT-1036` quantity = 22 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 430 currencycode = `EUR` suppliername = `Very Best Screens`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1036.jpg` heavy = `false` category = `Flat Screen Monitors` deliverydate = 1783036800000 )
      ( name = `Flat XL` productid = `HT-1037` quantity = 23 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 1230 currencycode = `EUR` suppliername = `Very Best Screens`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1037.jpg` heavy = `false` category = `Flat Screen Monitors` deliverydate = 1782691200000 )
      ( name = `Laser Professional Eco` productid = `HT-1040` quantity = 21 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 830 currencycode = `EUR` suppliername = `Alpha Printers`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1040.jpg` heavy = `false` category = `Printers` deliverydate = 1782345600000 )
      ( name = `Laser Basic` productid = `HT-1041` quantity = 8 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 490 currencycode = `EUR` suppliername = `Alpha Printers`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1041.jpg` heavy = `false` category = `Printers` deliverydate = 1782000000000 )
      ( name = `Laser Allround` productid = `HT-1042` quantity = 9 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 349 currencycode = `EUR` suppliername = `Alpha Printers`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1042.jpg` heavy = `false` category = `Printers` deliverydate = 1781654400000 )
      ( name = `Ultra Jet Super Color` productid = `HT-1050` quantity = 17 status = `Discontinued` availablestate = `Error` availableicon = `sap-icon://decline` price = 139 currencycode = `EUR` suppliername = `Alpha Printers`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1050.jpg` heavy = `false` category = `Printers` deliverydate = 1784764800000 )
      ( name = `Ultra Jet Mobile` productid = `HT-1051` quantity = 18 status = `Discontinued` availablestate = `Error` availableicon = `sap-icon://decline` price = 99 currencycode = `EUR` suppliername = `Printer for All`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1051.jpg` heavy = `false` category = `Printers` deliverydate = 1784419200000 )
      ( name = `Ultra Jet Super Highspeed` productid = `HT-1052` quantity = 25 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 170 currencycode = `EUR` suppliername = `Printer for All`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1052.jpg` heavy = `false` category = `Printers` deliverydate = 1784073600000 )
      ( name = `Multi Print` productid = `HT-1055` quantity = 16 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 99 currencycode = `EUR` suppliername = `Printer for All`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1055.jpg` heavy = `false` category = `Multifunction Printers` deliverydate = 1783728000000 )
      ( name = `Multi Color` productid = `HT-1056` quantity = 5 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 119 currencycode = `EUR` suppliername = `Printer for All`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1056.jpg` heavy = `false` category = `Multifunction Printers` deliverydate = 1783382400000 )
      ( name = `Cordless Mouse` productid = `HT-1060` quantity = 25 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 9 currencycode = `EUR` suppliername = `Oxynum`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1060.jpg` heavy = `false` category = `Mice` deliverydate = 1783036800000 )
      ( name = `Speed Mouse` productid = `HT-1061` quantity = 12 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 7 currencycode = `EUR` suppliername = `Oxynum`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1061.jpg` heavy = `false` category = `Mice` deliverydate = 1782691200000 )
      ( name = `Track Mouse` productid = `HT-1062` quantity = 12 status = `Discontinued` availablestate = `Error` availableicon = `sap-icon://decline` price = 11 currencycode = `EUR` suppliername = `Oxynum`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1062.jpg` heavy = `false` category = `Mice` deliverydate = 1782345600000 )
      ( name = `Ergonomic Keyboard` productid = `HT-1063` quantity = 50 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 14 currencycode = `EUR` suppliername = `Oxynum`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1063.jpg` heavy = `false` category = `Keyboards` deliverydate = 1782000000000 )
      ( name = `Internet Keyboard` productid = `HT-1064` quantity = 35 status = `Out of Stock` availablestate = `Error` availableicon = `sap-icon://decline` price = 16 currencycode = `EUR` suppliername = `Oxynum`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1064.jpg` heavy = `false` category = `Keyboards` deliverydate = 1781654400000 )
      ( name = `Media Keyboard` productid = `HT-1065` quantity = 26 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 26 currencycode = `EUR` suppliername = `Oxynum`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1065.jpg` heavy = `false` category = `Keyboards` deliverydate = 1784764800000 )
      ( name = `Mousepad` productid = `HT-1066` quantity = 12 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 6.99 currencycode = `EUR` suppliername = `Oxynum`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1066.jpg` heavy = `false` category = `Mousepads` deliverydate = 1784419200000 )
      ( name = `Ergo Mousepad` productid = `HT-1067` quantity = 16 status = `Out of Stock` availablestate = `Error` availableicon = `sap-icon://decline` price = 8.99 currencycode = `EUR` suppliername = `Oxynum`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1067.jpg` heavy = `false` category = `Mousepads` deliverydate = 1784073600000 )
      ( name = `Designer Mousepad` productid = `HT-1068` quantity = 26 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 12.99 currencycode = `EUR` suppliername = `Fasttech`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1068.jpg` heavy = `false` category = `Mousepads` deliverydate = 1783728000000 )
      ( name = `Universal card reader` productid = `HT-1069` quantity = 22 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 14 currencycode = `EUR` suppliername = `Fasttech`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1069.jpg` heavy = `false` category = `Computer System Accessories` deliverydate = 1783382400000 )
      ( name = `Proctra X` productid = `HT-1070` quantity = 15 status = `Out of Stock` availablestate = `Error` availableicon = `sap-icon://decline` price = 70.9 currencycode = `EUR` suppliername = `Ultrasonic United`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1070.jpg` heavy = `false` category = `Graphic Cards` deliverydate = 1783036800000 )
      ( name = `Gladiator MX` productid = `HT-1071` quantity = 16 status = `Discontinued` availablestate = `Error` availableicon = `sap-icon://decline` price = 81.7 currencycode = `EUR` suppliername = `Ultrasonic United`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1071.jpg` heavy = `false` category = `Graphic Cards` deliverydate = 1782691200000 )
      ( name = `Hurricane GX` productid = `HT-1072` quantity = 13 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 101.2 currencycode = `EUR` suppliername = `Ultrasonic United`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1072.jpg` heavy = `false` category = `Graphic Cards` deliverydate = 1782345600000 )
      ( name = `Hurricane GX/LN` productid = `HT-1073` quantity = 5 status = `Out of Stock` availablestate = `Error` availableicon = `sap-icon://decline` price = 139.99 currencycode = `EUR` suppliername = `Smartcards`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1073.jpg` heavy = `false` category = `Graphic Cards` deliverydate = 1782000000000 )
      ( name = `Photo Scan` productid = `HT-1080` quantity = 8 status = `Out of Stock` availablestate = `Error` availableicon = `sap-icon://decline` price = 129 currencycode = `EUR` suppliername = `Printer for All`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1080.jpg` heavy = `false` category = `Scanners` deliverydate = 1781654400000 )
      ( name = `Power Scan` productid = `HT-1081` quantity = 11 status = `Out of Stock` availablestate = `Error` availableicon = `sap-icon://decline` price = 89 currencycode = `EUR` suppliername = `Printer for All`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1081.jpg` heavy = `false` category = `Scanners` deliverydate = 1784764800000 )
      ( name = `Jet Scan Professional` productid = `HT-1082` quantity = 13 status = `Out of Stock` availablestate = `Error` availableicon = `sap-icon://decline` price = 169 currencycode = `EUR` suppliername = `Printer for All`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1082.jpg` heavy = `false` category = `Scanners` deliverydate = 1784419200000 )
      ( name = `Jet Scan Professional` productid = `HT-1083` quantity = 10 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 189 currencycode = `EUR` suppliername = `Printer for All`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1083.jpg` heavy = `false` category = `Scanners` deliverydate = 1784073600000 )
      ( name = `Copymaster` productid = `HT-1085` quantity = 10 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 1499 currencycode = `EUR` suppliername = `Alpha Printers`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1085.jpg` heavy = `false` category = `Multifunction Printers` deliverydate = 1783728000000 )
      ( name = `Surround Sound` productid = `HT-1090` quantity = 20 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 39 currencycode = `EUR` suppliername = `Speaker Experts`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1090.jpg` heavy = `false` category = `Speakers` deliverydate = 1783382400000 )
      ( name = `Blaster Extreme` productid = `HT-1091` quantity = 15 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 26 currencycode = `EUR` suppliername = `Speaker Experts`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1091.jpg` heavy = `false` category = `Speakers` deliverydate = 1783036800000 )
      ( name = `Sound Booster` productid = `HT-1092` quantity = 50 status = `Discontinued` availablestate = `Error` availableicon = `sap-icon://decline` price = 45 currencycode = `EUR` suppliername = `Speaker Experts`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1092.jpg` heavy = `false` category = `Speakers` deliverydate = 1782691200000 )
      ( name = `Lovely Sound 5.1 Wireless` productid = `HT-1095` quantity = 12 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 49 currencycode = `EUR` suppliername = `Fasttech`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1095.jpg` heavy = `false` category = `Accessories` deliverydate = 1782345600000 )
      ( name = `Lovely Sound 5.1` productid = `HT-1096` quantity = 18 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 39 currencycode = `EUR` suppliername = `Fasttech`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1096.jpg` heavy = `false` category = `Accessories` deliverydate = 1782000000000 )
      ( name = `Lovely Sound Stereo` productid = `HT-1097` quantity = 21 status = `Out of Stock` availablestate = `Error` availableicon = `sap-icon://decline` price = 29 currencycode = `EUR` suppliername = `Fasttech`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1097.jpg` heavy = `false` category = `Accessories` deliverydate = 1781654400000 )
      ( name = `Smart Office` productid = `HT-1100` quantity = 25 status = `Out of Stock` availablestate = `Error` availableicon = `sap-icon://decline` price = 89.9 currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1100.jpg` heavy = `false` category = `Software` deliverydate = 1784764800000 )
      ( name = `Smart Design` productid = `HT-1101` quantity = 26 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 79.9 currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1101.jpg` heavy = `false` category = `Software` deliverydate = 1784419200000 )
      ( name = `Smart Network` productid = `HT-1102` quantity = 28 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 69 currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1102.jpg` heavy = `false` category = `Software` deliverydate = 1784073600000 )
      ( name = `Smart Multimedia` productid = `HT-1103` quantity = 9 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 77 currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1103.jpg` heavy = `false` category = `Software` deliverydate = 1783728000000 )
      ( name = `Smart Games` productid = `HT-1104` quantity = 13 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 55 currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1104.jpg` heavy = `false` category = `Software` deliverydate = 1783382400000 )
      ( name = `Smart Internet Antivirus` productid = `HT-1105` quantity = 17 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 29 currencycode = `EUR` suppliername = `Brainsoft`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1105.jpg` heavy = `false` category = `Software` deliverydate = 1783036800000 )
      ( name = `Smart Firewall` productid = `HT-1106` quantity = 19 status = `Discontinued` availablestate = `Error` availableicon = `sap-icon://decline` price = 34 currencycode = `EUR` suppliername = `Brainsoft`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1106.jpg` heavy = `false` category = `Software` deliverydate = 1782691200000 )
      ( name = `Smart Money` productid = `HT-1107` quantity = 18 status = `Out of Stock` availablestate = `Error` availableicon = `sap-icon://decline` price = 29.9 currencycode = `EUR` suppliername = `Brainsoft`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1107.jpg` heavy = `false` category = `Software` deliverydate = 1782345600000 )
      ( name = `PC Lock` productid = `HT-1110` quantity = 14 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 8.9 currencycode = `EUR` suppliername = `Red Point Stores`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1110.jpg` heavy = `false` category = `Computer System Accessories` deliverydate = 1782000000000 )
      ( name = `Notebook Lock` productid = `HT-1111` quantity = 20 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 6.9 currencycode = `EUR` suppliername = `Red Point Stores`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1111.jpg` heavy = `false` category = `Computer System Accessories` deliverydate = 1781654400000 )
      ( name = `Web cam reality` productid = `HT-1112` quantity = 27 status = `Out of Stock` availablestate = `Error` availableicon = `sap-icon://decline` price = 39 currencycode = `EUR` suppliername = `Red Point Stores`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1112.jpg` heavy = `false` category = `Computer System Accessories` deliverydate = 1784764800000 )
      ( name = `Screen clean` productid = `HT-1113` quantity = 17 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 2.3 currencycode = `EUR` suppliername = `Red Point Stores`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1113.jpg` heavy = `false` category = `Computer System Accessories` deliverydate = 1784419200000 )
      ( name = `Fabric bag professional` productid = `HT-1114` quantity = 14 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 31 currencycode = `EUR` suppliername = `Red Point Stores`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1114.jpg` heavy = `false` category = `Computer System Accessories` deliverydate = 1784073600000 )
      ( name = `Wireless DSL Router` productid = `HT-1115` quantity = 16 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 49 currencycode = `EUR` suppliername = `Red Point Stores`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1115.jpg` heavy = `false` category = `Telecommunications` deliverydate = 1783728000000 )
      ( name = `Wireless DSL Router / Repeater` productid = `HT-1116` quantity = 12 status = `Out of Stock` availablestate = `Error` availableicon = `sap-icon://decline` price = 59 currencycode = `EUR` suppliername = `Red Point Stores`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1116.jpg` heavy = `false` category = `Telecommunications` deliverydate = 1783382400000 )
      ( name = `Wireless DSL Router / Repeater and Print Server` productid = `HT-1117` quantity = 12 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 69 currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1117.jpg` heavy = `false` category = `Telecommunications` deliverydate = 1783036800000 )
      ( name = `USB Stick` productid = `HT-1118` quantity = 14 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 35 currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1118.jpg` heavy = `false` category = `Computer System Accessories` deliverydate = 1782691200000 )
      ( name = `Travel Adapter` productid = `HT-1119` quantity = 10 status = `Discontinued` availablestate = `Error` availableicon = `sap-icon://decline` price = 79 currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1119.jpg` heavy = `false` category = `Accessories` deliverydate = 1782345600000 )
      ( name = `Cordless Bluetooth Keyboard, english international` productid = `HT-1120` quantity = 13 status = `Out of Stock` availablestate = `Error` availableicon = `sap-icon://decline` price = 29 currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1120.jpg` heavy = `false` category = `Keyboards` deliverydate = 1782000000000 )
      ( name = `Flat XXL` productid = `HT-1137` quantity = 10 status = `Discontinued` availablestate = `Error` availableicon = `sap-icon://decline` price = 1430 currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1137.jpg` heavy = `false` category = `Flat Screen Monitors` deliverydate = 1781654400000 )
      ( name = `Pocket Mouse` productid = `HT-1138` quantity = 20 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 23 currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1138.jpg` heavy = `false` category = `Mice` deliverydate = 1784764800000 )
      ( name = `PC Power Station` productid = `HT-1210` quantity = 22 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 2399 currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1210.jpg` heavy = `false` category = `PCs` deliverydate = 1784419200000 )
      ( name = `Astro Laptop 1516` productid = `HT-1251` quantity = 23 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 989 currencycode = `EUR` suppliername = `Ultrasonic United`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1251.jpg` heavy = `false` category = `Laptops` deliverydate = 1784073600000 )
      ( name = `Astro Phone 6` productid = `HT-1252` quantity = 28 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 649 currencycode = `EUR` suppliername = `Ultrasonic United`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1252.jpg` heavy = `false` category = `Smartphones and Tablets` deliverydate = 1783728000000 )
      ( name = `Benda Laptop 1408` productid = `HT-1253` quantity = 27 status = `Discontinued` availablestate = `Error` availableicon = `sap-icon://decline` price = 976 currencycode = `EUR` suppliername = `Ultrasonic United`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1253.jpg` heavy = `false` category = `Laptops` deliverydate = 1783382400000 )
      ( name = `Bending Screen 21HD` productid = `HT-1254` quantity = 23 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 250 currencycode = `EUR` suppliername = `Ultrasonic United`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1254.jpg` heavy = `false` category = `Flat Screens` deliverydate = 1783036800000 )
      ( name = `Broad Screen 22HD` productid = `HT-1255` quantity = 5 status = `Discontinued` availablestate = `Error` availableicon = `sap-icon://decline` price = 270 currencycode = `EUR` suppliername = `Ultrasonic United`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1255.jpg` heavy = `false` category = `Flat Screens` deliverydate = 1782691200000 )
      ( name = `Cerdik Phone 7` productid = `HT-1256` quantity = 19 status = `Discontinued` availablestate = `Error` availableicon = `sap-icon://decline` price = 549 currencycode = `EUR` suppliername = `Ultrasonic United`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1256.jpg` heavy = `false` category = `Smartphones and Tablets` deliverydate = 1782345600000 )
      ( name = `Cepat Tablet 10.5` productid = `HT-1257` quantity = 17 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 549 currencycode = `EUR` suppliername = `Ultrasonic United`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1257.jpg` heavy = `false` category = `Smartphones and Tablets` deliverydate = 1782000000000 )
      ( name = `Cepat Tablet 8` productid = `HT-1258` quantity = 24 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 529 currencycode = `EUR` suppliername = `Ultrasonic United`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1258.jpg` heavy = `false` category = `Smartphones and Tablets` deliverydate = 1781654400000 )
      ( name = `Server Basic` productid = `HT-1500` quantity = 24 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 5000 currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1500.jpg` heavy = `false` category = `Servers` deliverydate = 1784764800000 )
      ( name = `Server Professional` productid = `HT-1501` quantity = 26 status = `Out of Stock` availablestate = `Error` availableicon = `sap-icon://decline` price = 15000 currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1501.jpg` heavy = `false` category = `Servers` deliverydate = 1784419200000 )
      ( name = `Server Power Pro` productid = `HT-1502` quantity = 34 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 25000 currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1502.jpg` heavy = `false` category = `Servers` deliverydate = 1784073600000 )
      ( name = `Family PC Basic` productid = `HT-1600` quantity = 10 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 600 currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1600.jpg` heavy = `false` category = `Desktop Computers` deliverydate = 1783728000000 )
      ( name = `Family PC Pro` productid = `HT-1601` quantity = 20 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 900 currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1601.jpg` heavy = `false` category = `Desktop Computers` deliverydate = 1783382400000 )
      ( name = `Gaming Monster` productid = `HT-1602` quantity = 24 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 1200 currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1602.jpg` heavy = `false` category = `Desktop Computers` deliverydate = 1783036800000 )
      ( name = `Gaming Monster Pro` productid = `HT-1603` quantity = 25 status = `Discontinued` availablestate = `Error` availableicon = `sap-icon://decline` price = 1700 currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1603.jpg` heavy = `false` category = `Desktop Computers` deliverydate = 1782691200000 )
      ( name = `7" Widescreen Portable DVD Player w MP3` productid = `HT-2000` quantity = 20 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 249.99 currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2000.jpg` heavy = `false` category = `Accessories` deliverydate = 1782345600000 )
      ( name = `10" Portable DVD player` productid = `HT-2001` quantity = 21 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 449.99 currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2001.jpg` heavy = `false` category = `Accessories` deliverydate = 1782000000000 )
      ( name = `Portable DVD Player with 9" LCD Monitor` productid = `HT-2002` quantity = 50 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 853.99 currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2002.jpg` heavy = `false` category = `Accessories` deliverydate = 1781654400000 )
      ( name = `CD/DVD case: 264 sleeves` productid = `HT-2025` quantity = 26 status = `Discontinued` availablestate = `Error` availableicon = `sap-icon://decline` price = 44.99 currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2025.jpg` heavy = `false` category = `Accessories` deliverydate = 1784764800000 )
      ( name = `Audio/Video Cable Kit - 4m` productid = `HT-2026` quantity = 16 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 29.99 currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2026.jpg` heavy = `false` category = `Accessories` deliverydate = 1784419200000 )
      ( name = `Removable CD/DVD Laser Labels` productid = `HT-2027` quantity = 25 status = `Discontinued` availablestate = `Error` availableicon = `sap-icon://decline` price = 8.99 currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2027.jpg` heavy = `false` category = `Accessories` deliverydate = 1784073600000 )
      ( name = `Beam Breaker B-1` productid = `HT-6100` quantity = 32 status = `Out of Stock` availablestate = `Error` availableicon = `sap-icon://decline` price = 469 currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6100.jpg` heavy = `false` category = `Accessories` deliverydate = 1783728000000 )
      ( name = `Beam Breaker B-2` productid = `HT-6101` quantity = 18 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 679 currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6101.jpg` heavy = `false` category = `Accessories` deliverydate = 1783382400000 )
      ( name = `Beam Breaker B-3` productid = `HT-6102` quantity = 16 status = `Out of Stock` availablestate = `Error` availableicon = `sap-icon://decline` price = 889 currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6102.jpg` heavy = `false` category = `Accessories` deliverydate = 1783036800000 )
      ( name = `Play Movie` productid = `HT-6110` quantity = 15 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 130 currencycode = `EUR` suppliername = `Fasttech`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6110.jpg` heavy = `false` category = `Accessories` deliverydate = 1782691200000 )
      ( name = `Record Movie` productid = `HT-6111` quantity = 24 status = `Discontinued` availablestate = `Error` availableicon = `sap-icon://decline` price = 288 currencycode = `EUR` suppliername = `Fasttech`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6111.jpg` heavy = `false` category = `Accessories` deliverydate = 1782345600000 )
      ( name = `ITelo MusicStick` productid = `HT-6120` quantity = 15 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 45 currencycode = `EUR` suppliername = `Fasttech`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6120.jpg` heavy = `false` category = `Accessories` deliverydate = 1782000000000 )
      ( name = `ITelo Jog-Mate` productid = `HT-6121` quantity = 24 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 63 currencycode = `EUR` suppliername = `Fasttech`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6121.jpg` heavy = `false` category = `Accessories` deliverydate = 1781654400000 )
      ( name = `Power Pro Player 40` productid = `HT-6122` quantity = 23 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 167 currencycode = `EUR` suppliername = `Fasttech`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6122.jpg` heavy = `false` category = `Accessories` deliverydate = 1784764800000 )
      ( name = `Power Pro Player 80` productid = `HT-6123` quantity = 13 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 299 currencycode = `EUR` suppliername = `Fasttech`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6123.jpg` heavy = `false` category = `Accessories` deliverydate = 1784419200000 )
      ( name = `Flat Watch HD32` productid = `HT-6130` quantity = 16 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 1459 currencycode = `EUR` suppliername = `Very Best Screens`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6130.jpg` heavy = `false` category = `Flat Screen TVs` deliverydate = 1784073600000 )
      ( name = `Flat Watch HD37` productid = `HT-6131` quantity = 14 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 1199 currencycode = `EUR` suppliername = `Very Best Screens`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6131.jpg` heavy = `false` category = `Flat Screen TVs` deliverydate = 1783728000000 )
      ( name = `Flat Watch HD41` productid = `HT-6132` quantity = 13 status = `Discontinued` availablestate = `Error` availableicon = `sap-icon://decline` price = 899 currencycode = `EUR` suppliername = `Very Best Screens`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6132.jpg` heavy = `false` category = `Flat Screen TVs` deliverydate = 1783382400000 )
      ( name = `Copperberry` productid = `HT-7000` quantity = 5 status = `Discontinued` availablestate = `Error` availableicon = `sap-icon://decline` price = 549 currencycode = `EUR` suppliername = `Fasttech`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7000.jpg` heavy = `false` category = `Accessories` deliverydate = 1783036800000 )
      ( name = `Silverberry` productid = `HT-7010` quantity = 9 status = `Discontinued` availablestate = `Error` availableicon = `sap-icon://decline` price = 549 currencycode = `EUR` suppliername = `Fasttech`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7010.jpg` heavy = `false` category = `Accessories` deliverydate = 1782691200000 )
      ( name = `Goldberry` productid = `HT-7020` quantity = 11 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 549 currencycode = `EUR` suppliername = `Fasttech`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7020.jpg` heavy = `false` category = `Accessories` deliverydate = 1782345600000 )
      ( name = `Platinberry` productid = `HT-7030` quantity = 12 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 549 currencycode = `EUR` suppliername = `Fasttech`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7030.jpg` heavy = `false` category = `Accessories` deliverydate = 1782000000000 )
      ( name = `ITelO FlexTop I4000` productid = `HT-8000` quantity = 11 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 799 currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8000.jpg` heavy = `false` category = `Laptops` deliverydate = 1781654400000 )
      ( name = `ITelO FlexTop I6300c` productid = `HT-8001` quantity = 20 status = `Discontinued` availablestate = `Error` availableicon = `sap-icon://decline` price = 799 currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8001.jpg` heavy = `false` category = `Laptops` deliverydate = 1784764800000 )
      ( name = `ITelO FlexTop I9100` productid = `HT-8002` quantity = 20 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 1199 currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8002.jpg` heavy = `false` category = `Laptops` deliverydate = 1784419200000 )
      ( name = `ITelO FlexTop I9800` productid = `HT-8003` quantity = 22 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 1388 currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8003.jpg` heavy = `false` category = `Laptops` deliverydate = 1784073600000 )
      ( name = `Smartphone Leather Case` productid = `HT-9991` quantity = 12 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 25 currencycode = `EUR` suppliername = `Ultrasonic United`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9991.jpg` heavy = `false` category = `Accessories` deliverydate = 1783728000000 )
      ( name = `Smartphone Alpha` productid = `HT-9992` quantity = 13 status = `Out of Stock` availablestate = `Error` availableicon = `sap-icon://decline` price = 599 currencycode = `EUR` suppliername = `Ultrasonic United`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9992.jpg` heavy = `false` category = `Smartphones and Tablets` deliverydate = 1783382400000 )
      ( name = `Mini Tablet` productid = `HT-9993` quantity = 10 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 833 currencycode = `EUR` suppliername = `Ultrasonic United`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9993.jpg` heavy = `false` category = `Smartphones and Tablets` deliverydate = 1783036800000 )
      ( name = `Camcorder View` productid = `HT-9994` quantity = 50 status = `Out of Stock` availablestate = `Error` availableicon = `sap-icon://decline` price = 1388 currencycode = `EUR` suppliername = `Ultrasonic United`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9994.jpg` heavy = `false` category = `Accessories` deliverydate = 1782691200000 )
      ( name = `Tablet Pouch` productid = `HT-9995` quantity = 34 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 20 currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9995.jpg` heavy = `false` category = `Accessories` deliverydate = 1782345600000 )
      ( name = `Tablet Pouch` productid = `HT-9996` quantity = 34 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 20 currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9996.jpg` heavy = `false` category = `Accessories` deliverydate = 1782000000000 )
      ( name = `e-Book Reader ReadMe` productid = `HT-9997` quantity = 23 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 33 currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9997.jpg` heavy = `false` category = `Smartphones and Tablets` deliverydate = 1781654400000 )
      ( name = `Smartphone Beta` productid = `HT-9998` quantity = 21 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 30 currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9998.jpg` heavy = `false` category = `Smartphones and Tablets` deliverydate = 1784764800000 )
      ( name = `Maxi Tablet` productid = `HT-9999` quantity = 20 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 749 currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9999.jpg` heavy = `false` category = `Tablets` deliverydate = 1784419200000 )
      ( name = `Flyer` productid = `PF-1000` quantity = 33 status = `Out of Stock` availablestate = `Error` availableicon = `sap-icon://decline` price = 0 currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/PF-1000.jpg` heavy = `false` category = `Accessories` deliverydate = 1784073600000 )
      ).

    " the Suppliers / Categories collections the controller derives from the
    " products for the two in-cell dropdowns - the distinct values, in first
    " appearance order, exactly as the JS loop collects them
    t_suppliers = VALUE #(
      ( name = `Very Best Screens` )
      ( name = `Smartcards` )
      ( name = `Technocom` )
      ( name = `Alpha Printers` )
      ( name = `Printer for All` )
      ( name = `Oxynum` )
      ( name = `Fasttech` )
      ( name = `Ultrasonic United` )
      ( name = `Speaker Experts` )
      ( name = `Brainsoft` )
      ( name = `Red Point Stores` )
      ( name = `Titanium` )
      ).

    t_categories = VALUE #(
      ( name = `Laptops` )
      ( name = `Accessories` )
      ( name = `Flat Screen Monitors` )
      ( name = `Printers` )
      ( name = `Multifunction Printers` )
      ( name = `Mice` )
      ( name = `Keyboards` )
      ( name = `Mousepads` )
      ( name = `Computer System Accessories` )
      ( name = `Graphic Cards` )
      ( name = `Scanners` )
      ( name = `Speakers` )
      ( name = `Software` )
      ( name = `Telecommunications` )
      ( name = `PCs` )
      ( name = `Smartphones and Tablets` )
      ( name = `Flat Screens` )
      ( name = `Servers` )
      ( name = `Desktop Computers` )
      ( name = `Flat Screen TVs` )
      ( name = `Tablets` )
      ).

  ENDMETHOD.

ENDCLASS.
