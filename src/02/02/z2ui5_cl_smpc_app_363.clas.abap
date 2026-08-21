" @keywords table sap.ui.table tablefreeze column
" @summary Example which shows table freeze with fixed columns
CLASS z2ui5_cl_smpc_app_363 DEFINITION PUBLIC.

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
      END OF ty_s_name.
    DATA t_products   TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.
    DATA t_suppliers  TYPE STANDARD TABLE OF ty_s_name WITH EMPTY KEY.
    DATA t_categories TYPE STANDARD TABLE OF ty_s_name WITH EMPTY KEY.

    " the Inputs and the Table are bound to DIFFERENT fields on purpose: an
    " Input writes its value back as a STRING, and feeding that into the
    " int-typed fixedColumnCount / fixedTopRowCount / fixedBottomRowCount kills
    " the view outright ("20" is of type string, expected int). The original
    " keeps them apart the same way - it parseInts the Input and only then
    " calls setFixedColumnCount - so Apply converts, clamps, and writes the
    " corrected number back into the Input, which is the original's setValue.
    DATA column_count_text      TYPE string.
    DATA top_row_count_text     TYPE string.
    DATA bottom_row_count_text  TYPE string.
    DATA fixed_column_count     TYPE i.
    DATA fixed_top_row_count    TYPE i.
    DATA fixed_bottom_row_count TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    CONSTANTS cv_total_columns TYPE i VALUE 12.
    CONSTANTS cv_total_rows    TYPE i VALUE 10.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_363 IMPLEMENTATION.

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

    " the freeze demo: the three count Inputs are two-way bound and the Table's
    " fixedColumnCount and the rowMode's fixedTopRowCount / fixedBottomRowCount
    " bind the same fields, so the Apply press only clamps them in ABAP - the
    " validation the original does in buttonPress before calling the setters.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`          v = `sap.ui.table`
        )->a( n = `xmlns:rowmodes` v = `sap.ui.table.rowmodes`
        )->a( n = `xmlns:mvc`      v = `sap.ui.core.mvc`
        )->a( n = `xmlns:u`        v = `sap.ui.unified`
        )->a( n = `xmlns:c`        v = `sap.ui.core`
        )->a( n = `xmlns:m`        v = `sap.m`
        )->a( n = `height`         v = `100%`

        )->ele( n = `Page` ns = `m`
            )->a( n = `showHeader`      v = `false`
            )->a( n = `enableScrolling` v = `false`
            )->a( n = `class`           v = `sapUiContentPadding`

            )->ele( n = `content` ns = `m`
                )->ele( `Table`
                    )->a( n = `id`               v = `table1`
                    )->a( n = `rows`             v = client->_bind( t_products )
                    )->a( n = `selectionMode`    v = `MultiToggle`
                    )->a( n = `fixedColumnCount` v = client->_bind( fixed_column_count )
                    )->a( n = `ariaLabelledBy`   v = `title`

                    )->ele( `extension`
                        )->ele( n = `OverflowToolbar` ns = `m`
                            )->a( n = `style` v = `Clear`

                            )->tag( n = `Title` ns = `m`
                                )->a( n = `id`   v = `title`
                                )->a( n = `text` v = `Products`

                            )->tag( n = `ToolbarSpacer` ns = `m`

                            )->tag( n = `Input` ns = `m`
                                )->a( n = `id`          v = `inputColumn`
                                )->a( n = `width`       v = `20%`
                                )->a( n = `placeholder` v = `fixed column count`
                                )->a( n = `tooltip`     v = `fixed column count`
                                )->a( n = `value`       v = client->_bind( column_count_text )

                            )->tag( n = `Input` ns = `m`
                                )->a( n = `id`          v = `inputRow`
                                )->a( n = `width`       v = `20%`
                                )->a( n = `placeholder` v = `fixed row count`
                                )->a( n = `tooltip`     v = `fixed row count`
                                )->a( n = `value`       v = client->_bind( top_row_count_text )

                            )->tag( n = `Input` ns = `m`
                                )->a( n = `id`          v = `inputBottomRow`
                                )->a( n = `width`       v = `20%`
                                )->a( n = `placeholder` v = `fixed bottom row count`
                                )->a( n = `tooltip`     v = `fixed bottom row count`
                                )->a( n = `value`       v = client->_bind( bottom_row_count_text )

                            )->tag( n = `Button` ns = `m`
                                )->a( n = `id`    v = `button`
                                )->a( n = `text`  v = `Apply`
                                )->a( n = `press` v = client->_event( `APPLY` )

                        )->end(
                    )->end(
                    )->ele( `rowMode`
                        )->tag( n = `Fixed` ns = `rowmodes`
                            )->a( n = `fixedTopRowCount`    v = client->_bind( fixed_top_row_count )
                            )->a( n = `fixedBottomRowCount` v = client->_bind( fixed_bottom_row_count )

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
                                    )->a( n = `items` v = |\{ path: '{ client->_bind( val = t_suppliers path = abap_true ) }', templateShareable: false \}|

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
                                              t_arg = VALUE #( ( `MESSAGE_TOAST` )
                                                               ( `show` )
                                                               ( `Details for product with id {0}` )
                                                               ( `${PRODUCTID}` ) ) )

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
                                    )->a( n = `items`       v = |\{ path: '{ client->_bind( val = t_categories path = abap_true ) }', templateShareable: false \}|

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

    IF client->get_event( ) = `APPLY`.
      " buttonPress: read the Inputs the way the original parseInts them, then
      " clamp against the table's own totals and tell the user when a value
      " had to be corrected. A non-numeric entry keeps the last value - the
      " original's parseInt would hand setFixedColumnCount a NaN there.
      IF column_count_text CO ` 0123456789` AND column_count_text IS NOT INITIAL.
        fixed_column_count = CONV i( column_count_text ).
      ENDIF.
      IF top_row_count_text CO ` 0123456789` AND top_row_count_text IS NOT INITIAL.
        fixed_top_row_count = CONV i( top_row_count_text ).
      ENDIF.
      IF bottom_row_count_text CO ` 0123456789` AND bottom_row_count_text IS NOT INITIAL.
        fixed_bottom_row_count = CONV i( bottom_row_count_text ).
      ENDIF.

      IF fixed_column_count > cv_total_columns.
        fixed_column_count = cv_total_columns.
        client->message_toast_display( `Fixed column count exceeds the total column count. Value in column count input got updated.` ).
      ENDIF.

      IF fixed_top_row_count + fixed_bottom_row_count > cv_total_rows.
        IF fixed_top_row_count < cv_total_rows AND fixed_bottom_row_count < cv_total_rows.
          fixed_bottom_row_count = 1.
        ELSEIF fixed_top_row_count > cv_total_rows AND fixed_bottom_row_count < cv_total_rows.
          fixed_top_row_count = cv_total_rows - fixed_bottom_row_count - 1.
        ELSEIF fixed_top_row_count < cv_total_rows AND fixed_bottom_row_count > cv_total_rows.
          fixed_bottom_row_count = cv_total_rows - fixed_top_row_count - 1.
        ELSE.
          fixed_top_row_count    = 1.
          fixed_bottom_row_count = 1.
        ENDIF.
        client->message_toast_display( `Sum of fixed row count and bottom row count exceeds the total row count. Input values got updated.` ).
      ENDIF.

      " the original's oView.byId( ... ).setValue( ) - the corrected numbers
      " travel back into the Inputs
      column_count_text     = |{ fixed_column_count }|.
      top_row_count_text    = |{ fixed_top_row_count }|.
      bottom_row_count_text = |{ fixed_bottom_row_count }|.
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " The three Inputs start EMPTY, as in the original, which gives them no
    " value at all - so their placeholders ("fixed column count" and friends)
    " are what the user sees, and buttonPress reads them as getValue( ) || 0.
    " Until 2026-08-21 they were seeded from the freeze counts, i.e. with "0",
    " and sap.m.Input hides the placeholder as soon as a value is set: the port
    " opened with three zeroes where the sample opens with three hints. The
    " counts themselves stay 0; only the text fields are unset.

    " the shared 123-row demo ProductCollection (sap/ui/demo/mock/products.json)
    " with the columns the twelve table columns bind. DeliveryDate is
    " Date.now()-derived in the original (i mod 10 offset in 4-day steps); a
    " fixed base (2026-07-23) is used here so the port is deterministic - the
    " corpus convention of app 164. Heavy is WeightMeasure > 1000 as the string
    " the typed CheckBox binding expects, and the two Available formatters of
    " the controller are precomputed into AVAILABLESTATE / AVAILABLEICON, since
    " business logic belongs in the backend.
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
      ( name = `Mousepad` productid = `HT-1066` quantity = 12 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = `6.99` currencycode = `EUR` suppliername = `Oxynum`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1066.jpg` heavy = `false` category = `Mousepads` deliverydate = 1784419200000 )
      ( name = `Ergo Mousepad` productid = `HT-1067` quantity = 16 status = `Out of Stock` availablestate = `Error` availableicon = `sap-icon://decline` price = `8.99` currencycode = `EUR` suppliername = `Oxynum`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1067.jpg` heavy = `false` category = `Mousepads` deliverydate = 1784073600000 )
      ( name = `Designer Mousepad` productid = `HT-1068` quantity = 26 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = `12.99` currencycode = `EUR` suppliername = `Fasttech`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1068.jpg` heavy = `false` category = `Mousepads` deliverydate = 1783728000000 )
      ( name = `Universal card reader` productid = `HT-1069` quantity = 22 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = 14 currencycode = `EUR` suppliername = `Fasttech`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1069.jpg` heavy = `false` category = `Computer System Accessories` deliverydate = 1783382400000 )
      ( name = `Proctra X` productid = `HT-1070` quantity = 15 status = `Out of Stock` availablestate = `Error` availableicon = `sap-icon://decline` price = `70.9` currencycode = `EUR` suppliername = `Ultrasonic United`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1070.jpg` heavy = `false` category = `Graphic Cards` deliverydate = 1783036800000 )
      ( name = `Gladiator MX` productid = `HT-1071` quantity = 16 status = `Discontinued` availablestate = `Error` availableicon = `sap-icon://decline` price = `81.7` currencycode = `EUR` suppliername = `Ultrasonic United`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1071.jpg` heavy = `false` category = `Graphic Cards` deliverydate = 1782691200000 )
      ( name = `Hurricane GX` productid = `HT-1072` quantity = 13 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = `101.2` currencycode = `EUR` suppliername = `Ultrasonic United`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1072.jpg` heavy = `false` category = `Graphic Cards` deliverydate = 1782345600000 )
      ( name = `Hurricane GX/LN` productid = `HT-1073` quantity = 5 status = `Out of Stock` availablestate = `Error` availableicon = `sap-icon://decline` price = `139.99` currencycode = `EUR` suppliername = `Smartcards`
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
      ( name = `Smart Office` productid = `HT-1100` quantity = 25 status = `Out of Stock` availablestate = `Error` availableicon = `sap-icon://decline` price = `89.9` currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1100.jpg` heavy = `false` category = `Software` deliverydate = 1784764800000 )
      ( name = `Smart Design` productid = `HT-1101` quantity = 26 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = `79.9` currencycode = `EUR` suppliername = `Technocom`
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
      ( name = `Smart Money` productid = `HT-1107` quantity = 18 status = `Out of Stock` availablestate = `Error` availableicon = `sap-icon://decline` price = `29.9` currencycode = `EUR` suppliername = `Brainsoft`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1107.jpg` heavy = `false` category = `Software` deliverydate = 1782345600000 )
      ( name = `PC Lock` productid = `HT-1110` quantity = 14 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = `8.9` currencycode = `EUR` suppliername = `Red Point Stores`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1110.jpg` heavy = `false` category = `Computer System Accessories` deliverydate = 1782000000000 )
      ( name = `Notebook Lock` productid = `HT-1111` quantity = 20 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = `6.9` currencycode = `EUR` suppliername = `Red Point Stores`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1111.jpg` heavy = `false` category = `Computer System Accessories` deliverydate = 1781654400000 )
      ( name = `Web cam reality` productid = `HT-1112` quantity = 27 status = `Out of Stock` availablestate = `Error` availableicon = `sap-icon://decline` price = 39 currencycode = `EUR` suppliername = `Red Point Stores`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1112.jpg` heavy = `false` category = `Computer System Accessories` deliverydate = 1784764800000 )
      ( name = `Screen clean` productid = `HT-1113` quantity = 17 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = `2.3` currencycode = `EUR` suppliername = `Red Point Stores`
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
      ( name = `7" Widescreen Portable DVD Player w MP3` productid = `HT-2000` quantity = 20 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = `249.99` currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2000.jpg` heavy = `false` category = `Accessories` deliverydate = 1782345600000 )
      ( name = `10" Portable DVD player` productid = `HT-2001` quantity = 21 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = `449.99` currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2001.jpg` heavy = `false` category = `Accessories` deliverydate = 1782000000000 )
      ( name = `Portable DVD Player with 9" LCD Monitor` productid = `HT-2002` quantity = 50 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = `853.99` currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2002.jpg` heavy = `false` category = `Accessories` deliverydate = 1781654400000 )
      ( name = `CD/DVD case: 264 sleeves` productid = `HT-2025` quantity = 26 status = `Discontinued` availablestate = `Error` availableicon = `sap-icon://decline` price = `44.99` currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2025.jpg` heavy = `false` category = `Accessories` deliverydate = 1784764800000 )
      ( name = `Audio/Video Cable Kit - 4m` productid = `HT-2026` quantity = 16 status = `Available` availablestate = `Success` availableicon = `sap-icon://accept` price = `29.99` currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2026.jpg` heavy = `false` category = `Accessories` deliverydate = 1784419200000 )
      ( name = `Removable CD/DVD Laser Labels` productid = `HT-2027` quantity = 25 status = `Discontinued` availablestate = `Error` availableicon = `sap-icon://decline` price = `8.99` currencycode = `EUR` suppliername = `Titanium`
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
