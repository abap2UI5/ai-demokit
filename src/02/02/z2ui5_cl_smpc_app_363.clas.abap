" @keywords table sap.ui.table tablefreeze overflowtoolbar title toolbarspacer input button fixed column label text
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
    DATA t_products   TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.
    DATA t_suppliers  TYPE STANDARD TABLE OF ty_s_name WITH DEFAULT KEY.
    DATA t_categories TYPE STANDARD TABLE OF ty_s_name WITH DEFAULT KEY.

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
    " one Input's value the way the original's `getValue() || 0` + parseInt
    " reads it: empty means 0, a clean number means that number, and anything
    " else keeps what was there (where the original would pass on a NaN)
    METHODS count_read
      IMPORTING text          TYPE string
                last          TYPE i
      RETURNING VALUE(result) TYPE i.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_363 IMPLEMENTATION.

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
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " the freeze demo: the three count Inputs are two-way bound and the Table's
    " fixedColumnCount and the rowMode's fixedTopRowCount / fixedBottomRowCount
    " bind the same fields, so the Apply press only clamps them in ABAP - the
    " validation the original does in buttonPress before calling the setters.
    
    CLEAR temp1.
    INSERT `MESSAGE_TOAST` INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    INSERT `Details for product with id {0}` INTO TABLE temp1.
    INSERT `${PRODUCTID}` INTO TABLE temp1.
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
                                              t_arg = temp1 )

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

    IF client->get_event( ) = `APPLY`.
      " buttonPress: read the Inputs the way the original parseInts them, then
      " clamp against the table's own totals and tell the user when a value
      " had to be corrected.
      " EMPTY and non-numeric are NOT the same case, and treating them alike
      " until 2026-08-24 cost the sample its unfreeze: the original reads
      " `getValue() || 0`, so a cleared Input is 0 and Apply un-freezes. The
      " port kept the previous value for empty too, which left no way to
      " un-freeze at all. Only a non-empty, non-numeric entry keeps the last
      " value - there the original's parseInt hands the setter a NaN.
      fixed_column_count = count_read( text = column_count_text last = fixed_column_count ).
      fixed_top_row_count = count_read( text = top_row_count_text last = fixed_top_row_count ).
      fixed_bottom_row_count = count_read( text = bottom_row_count_text last = fixed_bottom_row_count ).

      IF fixed_column_count > cv_total_columns.
        fixed_column_count = cv_total_columns.
        " the original's oView.byId( 'inputColumn' ).setValue( ) - inside the
        " clamp branch, not after it
        column_count_text = |{ fixed_column_count }|.
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
        " likewise the original's two setValue( ) calls, both inside the branch
        top_row_count_text    = |{ fixed_top_row_count }|.
        bottom_row_count_text = |{ fixed_bottom_row_count }|.
        client->message_toast_display( `Sum of fixed row count and bottom row count exceeds the total row count. Input values got updated.` ).
      ENDIF.

      " NOTHING is written back outside those two branches. Writing all three
      " unconditionally (until 2026-08-24) meant the very first Apply on a
      " freshly loaded app - where all three Inputs are legitimately empty and
      " nothing is clamped - stamped "0" into each of them and dropped all
      " three placeholders, which is the defect the initial render already
      " fixed once.
    ENDIF.

  ENDMETHOD.


  METHOD count_read.

    IF text IS INITIAL.
      result = 0.
    " the length term guards the implicit conversion: `99999999999` is all
    " digits and overflows the TYPE i target
    ELSEIF text CO ` 0123456789` AND strlen( condense( text ) ) <= 9.
      result = text.
    ELSE.
      result = last.
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
    DATA temp3 LIKE t_products.
    DATA temp4 LIKE LINE OF temp3.
    DATA temp5 LIKE t_suppliers.
    DATA temp6 LIKE LINE OF temp5.
    DATA temp7 LIKE t_categories.
    DATA temp8 LIKE LINE OF temp7.
    CLEAR temp3.
    
    temp4-name = `Notebook Basic 15`.
    temp4-productid = `HT-1000`.
    temp4-quantity = 10.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 956.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Very Best Screens`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Laptops`.
    temp4-deliverydate = 1784764800000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Basic 17`.
    temp4-productid = `HT-1001`.
    temp4-quantity = 20.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 1249.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Very Best Screens`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1001.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Laptops`.
    temp4-deliverydate = 1784419200000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Basic 18`.
    temp4-productid = `HT-1002`.
    temp4-quantity = 10.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 1570.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Very Best Screens`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1002.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Laptops`.
    temp4-deliverydate = 1784073600000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Basic 19`.
    temp4-productid = `HT-1003`.
    temp4-quantity = 15.
    temp4-status = `Out of Stock`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = 1650.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Smartcards`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1003.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Laptops`.
    temp4-deliverydate = 1783728000000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO Vault`.
    temp4-productid = `HT-1007`.
    temp4-quantity = 15.
    temp4-status = `Out of Stock`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = 299.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Technocom`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1007.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Accessories`.
    temp4-deliverydate = 1783382400000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Professional 15`.
    temp4-productid = `HT-1010`.
    temp4-quantity = 16.
    temp4-status = `Out of Stock`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = 1999.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Very Best Screens`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Accessories`.
    temp4-deliverydate = 1783036800000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Professional 17`.
    temp4-productid = `HT-1011`.
    temp4-quantity = 17.
    temp4-status = `Out of Stock`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = 2299.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Very Best Screens`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1011.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Laptops`.
    temp4-deliverydate = 1782691200000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO Vault Net`.
    temp4-productid = `HT-1020`.
    temp4-quantity = 14.
    temp4-status = `Discontinued`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = 459.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Technocom`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1020.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Accessories`.
    temp4-deliverydate = 1782345600000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO Vault SAT`.
    temp4-productid = `HT-1021`.
    temp4-quantity = 50.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 149.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Technocom`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1021.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Accessories`.
    temp4-deliverydate = 1782000000000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Comfort Easy`.
    temp4-productid = `HT-1022`.
    temp4-quantity = 30.
    temp4-status = `Out of Stock`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = 1679.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Technocom`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1022.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Accessories`.
    temp4-deliverydate = 1781654400000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Comfort Senior`.
    temp4-productid = `HT-1023`.
    temp4-quantity = 24.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 512.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Technocom`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1023.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Accessories`.
    temp4-deliverydate = 1784764800000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergo Screen E-I`.
    temp4-productid = `HT-1030`.
    temp4-quantity = 14.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 230.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Very Best Screens`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1030.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Flat Screen Monitors`.
    temp4-deliverydate = 1784419200000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergo Screen E-II`.
    temp4-productid = `HT-1031`.
    temp4-quantity = 24.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 285.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Very Best Screens`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1031.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Flat Screen Monitors`.
    temp4-deliverydate = 1784073600000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergo Screen E-III`.
    temp4-productid = `HT-1032`.
    temp4-quantity = 50.
    temp4-status = `Out of Stock`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = 345.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Very Best Screens`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1032.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Flat Screen Monitors`.
    temp4-deliverydate = 1783728000000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Basic`.
    temp4-productid = `HT-1035`.
    temp4-quantity = 23.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 399.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Very Best Screens`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1035.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Flat Screen Monitors`.
    temp4-deliverydate = 1783382400000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Future`.
    temp4-productid = `HT-1036`.
    temp4-quantity = 22.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 430.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Very Best Screens`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1036.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Flat Screen Monitors`.
    temp4-deliverydate = 1783036800000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat XL`.
    temp4-productid = `HT-1037`.
    temp4-quantity = 23.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 1230.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Very Best Screens`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1037.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Flat Screen Monitors`.
    temp4-deliverydate = 1782691200000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Laser Professional Eco`.
    temp4-productid = `HT-1040`.
    temp4-quantity = 21.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 830.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Alpha Printers`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1040.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Printers`.
    temp4-deliverydate = 1782345600000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Laser Basic`.
    temp4-productid = `HT-1041`.
    temp4-quantity = 8.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 490.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Alpha Printers`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1041.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Printers`.
    temp4-deliverydate = 1782000000000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Laser Allround`.
    temp4-productid = `HT-1042`.
    temp4-quantity = 9.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 349.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Alpha Printers`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1042.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Printers`.
    temp4-deliverydate = 1781654400000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ultra Jet Super Color`.
    temp4-productid = `HT-1050`.
    temp4-quantity = 17.
    temp4-status = `Discontinued`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = 139.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Alpha Printers`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1050.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Printers`.
    temp4-deliverydate = 1784764800000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ultra Jet Mobile`.
    temp4-productid = `HT-1051`.
    temp4-quantity = 18.
    temp4-status = `Discontinued`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = 99.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Printer for All`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1051.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Printers`.
    temp4-deliverydate = 1784419200000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ultra Jet Super Highspeed`.
    temp4-productid = `HT-1052`.
    temp4-quantity = 25.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 170.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Printer for All`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1052.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Printers`.
    temp4-deliverydate = 1784073600000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Multi Print`.
    temp4-productid = `HT-1055`.
    temp4-quantity = 16.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 99.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Printer for All`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1055.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Multifunction Printers`.
    temp4-deliverydate = 1783728000000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Multi Color`.
    temp4-productid = `HT-1056`.
    temp4-quantity = 5.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 119.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Printer for All`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1056.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Multifunction Printers`.
    temp4-deliverydate = 1783382400000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cordless Mouse`.
    temp4-productid = `HT-1060`.
    temp4-quantity = 25.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 9.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Oxynum`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1060.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Mice`.
    temp4-deliverydate = 1783036800000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Speed Mouse`.
    temp4-productid = `HT-1061`.
    temp4-quantity = 12.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 7.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Oxynum`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1061.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Mice`.
    temp4-deliverydate = 1782691200000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Track Mouse`.
    temp4-productid = `HT-1062`.
    temp4-quantity = 12.
    temp4-status = `Discontinued`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = 11.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Oxynum`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1062.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Mice`.
    temp4-deliverydate = 1782345600000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergonomic Keyboard`.
    temp4-productid = `HT-1063`.
    temp4-quantity = 50.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 14.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Oxynum`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1063.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Keyboards`.
    temp4-deliverydate = 1782000000000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Internet Keyboard`.
    temp4-productid = `HT-1064`.
    temp4-quantity = 35.
    temp4-status = `Out of Stock`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = 16.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Oxynum`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1064.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Keyboards`.
    temp4-deliverydate = 1781654400000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Media Keyboard`.
    temp4-productid = `HT-1065`.
    temp4-quantity = 26.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 26.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Oxynum`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1065.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Keyboards`.
    temp4-deliverydate = 1784764800000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Mousepad`.
    temp4-productid = `HT-1066`.
    temp4-quantity = 12.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = `6.99`.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Oxynum`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1066.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Mousepads`.
    temp4-deliverydate = 1784419200000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergo Mousepad`.
    temp4-productid = `HT-1067`.
    temp4-quantity = 16.
    temp4-status = `Out of Stock`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = `8.99`.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Oxynum`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1067.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Mousepads`.
    temp4-deliverydate = 1784073600000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Designer Mousepad`.
    temp4-productid = `HT-1068`.
    temp4-quantity = 26.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = `12.99`.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Fasttech`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1068.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Mousepads`.
    temp4-deliverydate = 1783728000000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Universal card reader`.
    temp4-productid = `HT-1069`.
    temp4-quantity = 22.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 14.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Fasttech`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1069.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Computer System Accessories`.
    temp4-deliverydate = 1783382400000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Proctra X`.
    temp4-productid = `HT-1070`.
    temp4-quantity = 15.
    temp4-status = `Out of Stock`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = `70.9`.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1070.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Graphic Cards`.
    temp4-deliverydate = 1783036800000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Gladiator MX`.
    temp4-productid = `HT-1071`.
    temp4-quantity = 16.
    temp4-status = `Discontinued`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = `81.7`.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1071.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Graphic Cards`.
    temp4-deliverydate = 1782691200000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Hurricane GX`.
    temp4-productid = `HT-1072`.
    temp4-quantity = 13.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = `101.2`.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1072.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Graphic Cards`.
    temp4-deliverydate = 1782345600000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Hurricane GX/LN`.
    temp4-productid = `HT-1073`.
    temp4-quantity = 5.
    temp4-status = `Out of Stock`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = `139.99`.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Smartcards`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1073.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Graphic Cards`.
    temp4-deliverydate = 1782000000000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Photo Scan`.
    temp4-productid = `HT-1080`.
    temp4-quantity = 8.
    temp4-status = `Out of Stock`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = 129.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Printer for All`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1080.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Scanners`.
    temp4-deliverydate = 1781654400000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Power Scan`.
    temp4-productid = `HT-1081`.
    temp4-quantity = 11.
    temp4-status = `Out of Stock`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = 89.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Printer for All`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1081.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Scanners`.
    temp4-deliverydate = 1784764800000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Jet Scan Professional`.
    temp4-productid = `HT-1082`.
    temp4-quantity = 13.
    temp4-status = `Out of Stock`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = 169.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Printer for All`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1082.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Scanners`.
    temp4-deliverydate = 1784419200000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Jet Scan Professional`.
    temp4-productid = `HT-1083`.
    temp4-quantity = 10.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 189.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Printer for All`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1083.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Scanners`.
    temp4-deliverydate = 1784073600000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Copymaster`.
    temp4-productid = `HT-1085`.
    temp4-quantity = 10.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 1499.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Alpha Printers`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1085.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Multifunction Printers`.
    temp4-deliverydate = 1783728000000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Surround Sound`.
    temp4-productid = `HT-1090`.
    temp4-quantity = 20.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 39.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Speaker Experts`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1090.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Speakers`.
    temp4-deliverydate = 1783382400000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Blaster Extreme`.
    temp4-productid = `HT-1091`.
    temp4-quantity = 15.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 26.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Speaker Experts`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1091.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Speakers`.
    temp4-deliverydate = 1783036800000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Sound Booster`.
    temp4-productid = `HT-1092`.
    temp4-quantity = 50.
    temp4-status = `Discontinued`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = 45.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Speaker Experts`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1092.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Speakers`.
    temp4-deliverydate = 1782691200000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Lovely Sound 5.1 Wireless`.
    temp4-productid = `HT-1095`.
    temp4-quantity = 12.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 49.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Fasttech`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1095.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Accessories`.
    temp4-deliverydate = 1782345600000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Lovely Sound 5.1`.
    temp4-productid = `HT-1096`.
    temp4-quantity = 18.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 39.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Fasttech`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1096.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Accessories`.
    temp4-deliverydate = 1782000000000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Lovely Sound Stereo`.
    temp4-productid = `HT-1097`.
    temp4-quantity = 21.
    temp4-status = `Out of Stock`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = 29.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Fasttech`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1097.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Accessories`.
    temp4-deliverydate = 1781654400000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Office`.
    temp4-productid = `HT-1100`.
    temp4-quantity = 25.
    temp4-status = `Out of Stock`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = `89.9`.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Technocom`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1100.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Software`.
    temp4-deliverydate = 1784764800000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Design`.
    temp4-productid = `HT-1101`.
    temp4-quantity = 26.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = `79.9`.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Technocom`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1101.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Software`.
    temp4-deliverydate = 1784419200000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Network`.
    temp4-productid = `HT-1102`.
    temp4-quantity = 28.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 69.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Technocom`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1102.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Software`.
    temp4-deliverydate = 1784073600000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Multimedia`.
    temp4-productid = `HT-1103`.
    temp4-quantity = 9.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 77.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Technocom`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1103.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Software`.
    temp4-deliverydate = 1783728000000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Games`.
    temp4-productid = `HT-1104`.
    temp4-quantity = 13.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 55.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Technocom`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1104.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Software`.
    temp4-deliverydate = 1783382400000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Internet Antivirus`.
    temp4-productid = `HT-1105`.
    temp4-quantity = 17.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 29.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Brainsoft`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1105.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Software`.
    temp4-deliverydate = 1783036800000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Firewall`.
    temp4-productid = `HT-1106`.
    temp4-quantity = 19.
    temp4-status = `Discontinued`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = 34.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Brainsoft`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1106.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Software`.
    temp4-deliverydate = 1782691200000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Money`.
    temp4-productid = `HT-1107`.
    temp4-quantity = 18.
    temp4-status = `Out of Stock`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = `29.9`.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Brainsoft`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1107.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Software`.
    temp4-deliverydate = 1782345600000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `PC Lock`.
    temp4-productid = `HT-1110`.
    temp4-quantity = 14.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = `8.9`.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Red Point Stores`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1110.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Computer System Accessories`.
    temp4-deliverydate = 1782000000000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Lock`.
    temp4-productid = `HT-1111`.
    temp4-quantity = 20.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = `6.9`.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Red Point Stores`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1111.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Computer System Accessories`.
    temp4-deliverydate = 1781654400000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Web cam reality`.
    temp4-productid = `HT-1112`.
    temp4-quantity = 27.
    temp4-status = `Out of Stock`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = 39.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Red Point Stores`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1112.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Computer System Accessories`.
    temp4-deliverydate = 1784764800000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Screen clean`.
    temp4-productid = `HT-1113`.
    temp4-quantity = 17.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = `2.3`.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Red Point Stores`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1113.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Computer System Accessories`.
    temp4-deliverydate = 1784419200000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Fabric bag professional`.
    temp4-productid = `HT-1114`.
    temp4-quantity = 14.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 31.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Red Point Stores`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1114.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Computer System Accessories`.
    temp4-deliverydate = 1784073600000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Wireless DSL Router`.
    temp4-productid = `HT-1115`.
    temp4-quantity = 16.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 49.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Red Point Stores`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1115.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Telecommunications`.
    temp4-deliverydate = 1783728000000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Wireless DSL Router / Repeater`.
    temp4-productid = `HT-1116`.
    temp4-quantity = 12.
    temp4-status = `Out of Stock`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = 59.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Red Point Stores`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1116.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Telecommunications`.
    temp4-deliverydate = 1783382400000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Wireless DSL Router / Repeater and Print Server`.
    temp4-productid = `HT-1117`.
    temp4-quantity = 12.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 69.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Technocom`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1117.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Telecommunications`.
    temp4-deliverydate = 1783036800000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `USB Stick`.
    temp4-productid = `HT-1118`.
    temp4-quantity = 14.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 35.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Technocom`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1118.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Computer System Accessories`.
    temp4-deliverydate = 1782691200000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Travel Adapter`.
    temp4-productid = `HT-1119`.
    temp4-quantity = 10.
    temp4-status = `Discontinued`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = 79.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Titanium`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1119.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Accessories`.
    temp4-deliverydate = 1782345600000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cordless Bluetooth Keyboard, english international`.
    temp4-productid = `HT-1120`.
    temp4-quantity = 13.
    temp4-status = `Out of Stock`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = 29.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Technocom`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1120.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Keyboards`.
    temp4-deliverydate = 1782000000000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat XXL`.
    temp4-productid = `HT-1137`.
    temp4-quantity = 10.
    temp4-status = `Discontinued`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = 1430.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Technocom`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1137.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Flat Screen Monitors`.
    temp4-deliverydate = 1781654400000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Pocket Mouse`.
    temp4-productid = `HT-1138`.
    temp4-quantity = 20.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 23.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Technocom`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1138.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Mice`.
    temp4-deliverydate = 1784764800000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `PC Power Station`.
    temp4-productid = `HT-1210`.
    temp4-quantity = 22.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 2399.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Technocom`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1210.jpg`.
    temp4-heavy = `false`.
    temp4-category = `PCs`.
    temp4-deliverydate = 1784419200000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Astro Laptop 1516`.
    temp4-productid = `HT-1251`.
    temp4-quantity = 23.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 989.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1251.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Laptops`.
    temp4-deliverydate = 1784073600000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Astro Phone 6`.
    temp4-productid = `HT-1252`.
    temp4-quantity = 28.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 649.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1252.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Smartphones and Tablets`.
    temp4-deliverydate = 1783728000000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Benda Laptop 1408`.
    temp4-productid = `HT-1253`.
    temp4-quantity = 27.
    temp4-status = `Discontinued`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = 976.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1253.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Laptops`.
    temp4-deliverydate = 1783382400000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Bending Screen 21HD`.
    temp4-productid = `HT-1254`.
    temp4-quantity = 23.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 250.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1254.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Flat Screens`.
    temp4-deliverydate = 1783036800000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Broad Screen 22HD`.
    temp4-productid = `HT-1255`.
    temp4-quantity = 5.
    temp4-status = `Discontinued`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = 270.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1255.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Flat Screens`.
    temp4-deliverydate = 1782691200000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cerdik Phone 7`.
    temp4-productid = `HT-1256`.
    temp4-quantity = 19.
    temp4-status = `Discontinued`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = 549.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1256.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Smartphones and Tablets`.
    temp4-deliverydate = 1782345600000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cepat Tablet 10.5`.
    temp4-productid = `HT-1257`.
    temp4-quantity = 17.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 549.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1257.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Smartphones and Tablets`.
    temp4-deliverydate = 1782000000000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cepat Tablet 8`.
    temp4-productid = `HT-1258`.
    temp4-quantity = 24.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 529.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1258.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Smartphones and Tablets`.
    temp4-deliverydate = 1781654400000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Server Basic`.
    temp4-productid = `HT-1500`.
    temp4-quantity = 24.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 5000.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Technocom`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1500.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Servers`.
    temp4-deliverydate = 1784764800000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Server Professional`.
    temp4-productid = `HT-1501`.
    temp4-quantity = 26.
    temp4-status = `Out of Stock`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = 15000.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Technocom`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1501.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Servers`.
    temp4-deliverydate = 1784419200000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Server Power Pro`.
    temp4-productid = `HT-1502`.
    temp4-quantity = 34.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 25000.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Technocom`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1502.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Servers`.
    temp4-deliverydate = 1784073600000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Family PC Basic`.
    temp4-productid = `HT-1600`.
    temp4-quantity = 10.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 600.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Titanium`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1600.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Desktop Computers`.
    temp4-deliverydate = 1783728000000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Family PC Pro`.
    temp4-productid = `HT-1601`.
    temp4-quantity = 20.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 900.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Titanium`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1601.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Desktop Computers`.
    temp4-deliverydate = 1783382400000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Gaming Monster`.
    temp4-productid = `HT-1602`.
    temp4-quantity = 24.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 1200.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Titanium`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1602.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Desktop Computers`.
    temp4-deliverydate = 1783036800000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Gaming Monster Pro`.
    temp4-productid = `HT-1603`.
    temp4-quantity = 25.
    temp4-status = `Discontinued`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = 1700.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Titanium`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1603.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Desktop Computers`.
    temp4-deliverydate = 1782691200000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `7" Widescreen Portable DVD Player w MP3`.
    temp4-productid = `HT-2000`.
    temp4-quantity = 20.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = `249.99`.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Titanium`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2000.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Accessories`.
    temp4-deliverydate = 1782345600000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `10" Portable DVD player`.
    temp4-productid = `HT-2001`.
    temp4-quantity = 21.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = `449.99`.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Titanium`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2001.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Accessories`.
    temp4-deliverydate = 1782000000000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Portable DVD Player with 9" LCD Monitor`.
    temp4-productid = `HT-2002`.
    temp4-quantity = 50.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = `853.99`.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Technocom`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2002.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Accessories`.
    temp4-deliverydate = 1781654400000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `CD/DVD case: 264 sleeves`.
    temp4-productid = `HT-2025`.
    temp4-quantity = 26.
    temp4-status = `Discontinued`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = `44.99`.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Titanium`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2025.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Accessories`.
    temp4-deliverydate = 1784764800000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Audio/Video Cable Kit - 4m`.
    temp4-productid = `HT-2026`.
    temp4-quantity = 16.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = `29.99`.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Titanium`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2026.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Accessories`.
    temp4-deliverydate = 1784419200000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Removable CD/DVD Laser Labels`.
    temp4-productid = `HT-2027`.
    temp4-quantity = 25.
    temp4-status = `Discontinued`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = `8.99`.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Titanium`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2027.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Accessories`.
    temp4-deliverydate = 1784073600000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Beam Breaker B-1`.
    temp4-productid = `HT-6100`.
    temp4-quantity = 32.
    temp4-status = `Out of Stock`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = 469.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Titanium`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6100.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Accessories`.
    temp4-deliverydate = 1783728000000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Beam Breaker B-2`.
    temp4-productid = `HT-6101`.
    temp4-quantity = 18.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 679.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Technocom`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6101.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Accessories`.
    temp4-deliverydate = 1783382400000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Beam Breaker B-3`.
    temp4-productid = `HT-6102`.
    temp4-quantity = 16.
    temp4-status = `Out of Stock`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = 889.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Technocom`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6102.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Accessories`.
    temp4-deliverydate = 1783036800000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Play Movie`.
    temp4-productid = `HT-6110`.
    temp4-quantity = 15.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 130.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Fasttech`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6110.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Accessories`.
    temp4-deliverydate = 1782691200000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Record Movie`.
    temp4-productid = `HT-6111`.
    temp4-quantity = 24.
    temp4-status = `Discontinued`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = 288.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Fasttech`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6111.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Accessories`.
    temp4-deliverydate = 1782345600000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelo MusicStick`.
    temp4-productid = `HT-6120`.
    temp4-quantity = 15.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 45.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Fasttech`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6120.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Accessories`.
    temp4-deliverydate = 1782000000000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelo Jog-Mate`.
    temp4-productid = `HT-6121`.
    temp4-quantity = 24.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 63.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Fasttech`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6121.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Accessories`.
    temp4-deliverydate = 1781654400000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Power Pro Player 40`.
    temp4-productid = `HT-6122`.
    temp4-quantity = 23.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 167.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Fasttech`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6122.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Accessories`.
    temp4-deliverydate = 1784764800000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Power Pro Player 80`.
    temp4-productid = `HT-6123`.
    temp4-quantity = 13.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 299.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Fasttech`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6123.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Accessories`.
    temp4-deliverydate = 1784419200000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Watch HD32`.
    temp4-productid = `HT-6130`.
    temp4-quantity = 16.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 1459.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Very Best Screens`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6130.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Flat Screen TVs`.
    temp4-deliverydate = 1784073600000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Watch HD37`.
    temp4-productid = `HT-6131`.
    temp4-quantity = 14.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 1199.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Very Best Screens`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6131.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Flat Screen TVs`.
    temp4-deliverydate = 1783728000000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Watch HD41`.
    temp4-productid = `HT-6132`.
    temp4-quantity = 13.
    temp4-status = `Discontinued`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = 899.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Very Best Screens`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6132.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Flat Screen TVs`.
    temp4-deliverydate = 1783382400000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Copperberry`.
    temp4-productid = `HT-7000`.
    temp4-quantity = 5.
    temp4-status = `Discontinued`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = 549.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Fasttech`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7000.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Accessories`.
    temp4-deliverydate = 1783036800000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Silverberry`.
    temp4-productid = `HT-7010`.
    temp4-quantity = 9.
    temp4-status = `Discontinued`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = 549.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Fasttech`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7010.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Accessories`.
    temp4-deliverydate = 1782691200000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Goldberry`.
    temp4-productid = `HT-7020`.
    temp4-quantity = 11.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 549.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Fasttech`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7020.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Accessories`.
    temp4-deliverydate = 1782345600000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Platinberry`.
    temp4-productid = `HT-7030`.
    temp4-quantity = 12.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 549.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Fasttech`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7030.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Accessories`.
    temp4-deliverydate = 1782000000000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO FlexTop I4000`.
    temp4-productid = `HT-8000`.
    temp4-quantity = 11.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 799.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Titanium`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8000.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Laptops`.
    temp4-deliverydate = 1781654400000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO FlexTop I6300c`.
    temp4-productid = `HT-8001`.
    temp4-quantity = 20.
    temp4-status = `Discontinued`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = 799.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Titanium`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8001.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Laptops`.
    temp4-deliverydate = 1784764800000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO FlexTop I9100`.
    temp4-productid = `HT-8002`.
    temp4-quantity = 20.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 1199.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Titanium`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8002.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Laptops`.
    temp4-deliverydate = 1784419200000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO FlexTop I9800`.
    temp4-productid = `HT-8003`.
    temp4-quantity = 22.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 1388.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Titanium`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8003.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Laptops`.
    temp4-deliverydate = 1784073600000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smartphone Leather Case`.
    temp4-productid = `HT-9991`.
    temp4-quantity = 12.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 25.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9991.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Accessories`.
    temp4-deliverydate = 1783728000000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smartphone Alpha`.
    temp4-productid = `HT-9992`.
    temp4-quantity = 13.
    temp4-status = `Out of Stock`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = 599.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9992.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Smartphones and Tablets`.
    temp4-deliverydate = 1783382400000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Mini Tablet`.
    temp4-productid = `HT-9993`.
    temp4-quantity = 10.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 833.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9993.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Smartphones and Tablets`.
    temp4-deliverydate = 1783036800000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Camcorder View`.
    temp4-productid = `HT-9994`.
    temp4-quantity = 50.
    temp4-status = `Out of Stock`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = 1388.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9994.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Accessories`.
    temp4-deliverydate = 1782691200000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Tablet Pouch`.
    temp4-productid = `HT-9995`.
    temp4-quantity = 34.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 20.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Titanium`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9995.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Accessories`.
    temp4-deliverydate = 1782345600000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Tablet Pouch`.
    temp4-productid = `HT-9996`.
    temp4-quantity = 34.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 20.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Titanium`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9996.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Accessories`.
    temp4-deliverydate = 1782000000000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `e-Book Reader ReadMe`.
    temp4-productid = `HT-9997`.
    temp4-quantity = 23.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 33.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Titanium`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9997.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Smartphones and Tablets`.
    temp4-deliverydate = 1781654400000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smartphone Beta`.
    temp4-productid = `HT-9998`.
    temp4-quantity = 21.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 30.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Titanium`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9998.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Smartphones and Tablets`.
    temp4-deliverydate = 1784764800000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Maxi Tablet`.
    temp4-productid = `HT-9999`.
    temp4-quantity = 20.
    temp4-status = `Available`.
    temp4-availablestate = `Success`.
    temp4-availableicon = `sap-icon://accept`.
    temp4-price = 749.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Titanium`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9999.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Tablets`.
    temp4-deliverydate = 1784419200000.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flyer`.
    temp4-productid = `PF-1000`.
    temp4-quantity = 33.
    temp4-status = `Out of Stock`.
    temp4-availablestate = `Error`.
    temp4-availableicon = `sap-icon://decline`.
    temp4-price = 0.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Titanium`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/PF-1000.jpg`.
    temp4-heavy = `false`.
    temp4-category = `Accessories`.
    temp4-deliverydate = 1784073600000.
    INSERT temp4 INTO TABLE temp3.
    t_products = temp3.

    " the Suppliers / Categories collections the controller derives from the
    " products for the two in-cell dropdowns - the distinct values, in first
    " appearance order, exactly as the JS loop collects them
    
    CLEAR temp5.
    
    temp6-name = `Very Best Screens`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Smartcards`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Technocom`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Alpha Printers`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Printer for All`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Oxynum`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Fasttech`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Ultrasonic United`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Speaker Experts`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Brainsoft`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Red Point Stores`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Titanium`.
    INSERT temp6 INTO TABLE temp5.
    t_suppliers = temp5.

    
    CLEAR temp7.
    
    temp8-name = `Laptops`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Accessories`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Flat Screen Monitors`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Printers`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Multifunction Printers`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Mice`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Keyboards`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Mousepads`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Computer System Accessories`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Graphic Cards`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Scanners`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Speakers`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Software`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Telecommunications`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `PCs`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Smartphones and Tablets`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Flat Screens`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Servers`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Desktop Computers`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Flat Screen TVs`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Tablets`.
    INSERT temp8 INTO TABLE temp7.
    t_categories = temp7.

  ENDMETHOD.

ENDCLASS.
