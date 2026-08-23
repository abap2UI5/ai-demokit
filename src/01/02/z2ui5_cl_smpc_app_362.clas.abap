" @keywords table sap.ui.table sorting overflowtoolbar title toolbarspacer button column label text link
" @summary Example showing the different kinds of sorting capabilities
CLASS z2ui5_cl_smpc_app_362 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name            TYPE string,
        category        TYPE string,
        productpicurl   TYPE string,
        quantity        TYPE i,
        deliverydatestr TYPE string,
        deliverydate    TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

    " one field per sortable Column's sortOrder - the original drives them
    " imperatively (oTable.sort( column, order ) / setSortOrder), here the
    " sorting happens on the model and the indicator follows it
    DATA sort_name         TYPE string.
    DATA sort_category     TYPE string.
    DATA sort_quantity     TYPE string.
    DATA sort_deliverydate TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    " sortCategories alternates ascending / descending on every press
    DATA category_descending TYPE abap_bool.

    " The ACTIVE sorters, in precedence order - the model equivalent of the
    " table's own _aSortedColumns. sortCategories passes bAdd = true, which
    " pushes its column onto that list rather than replacing it, so the port
    " needs the list too: a single dynamic SORT can only ever express one key.
    TYPES:
      BEGIN OF ty_s_sortkey,
        field      TYPE string,
        descending TYPE abap_bool,
      END OF ty_s_sortkey.
    DATA t_sortkeys TYPE STANDARD TABLE OF ty_s_sortkey WITH EMPTY KEY.

    METHODS view_display.
    METHODS on_event.
    METHODS sort_clear.
    METHODS sort_apply.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_362 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      " Every sortOrder starts at the enum's own None. Leaving the other three
      " initial made them serialize as "" - which sap.ui.core.SortOrder rejects
      " outright, so the app terminated on its first render with
      " `"" is of type string, expected sap.ui.core.SortOrder`. The original
      " calls _resetSortingState for the same reason; sort_clear( ) is it.
      sort_clear( ).
      " the original sorts by Product Name ascending in onInit
      SORT t_products BY name ASCENDING.
      sort_name = `Ascending`.
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " every sort of this sample happens in ABAP: the three toolbar buttons and
    " the column header menu all fire a backend event, the model comes back
    " sorted and each Column's sortOrder is bound so the indicator follows.
    " The sort event vetoes the control's own client-side sort, which is what
    " the original does for the delivery-date column (its date strings cannot
    " be compared as text - here the underlying timestamp is sorted instead).
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
                    )->a( n = `selectionMode`  v = `MultiToggle`
                    )->a( n = `rows`           v = client->_bind( t_products )
                    )->a( n = `ariaLabelledBy` v = `title`
                    )->a( n = `sort`           v = client->_event(
                              val    = `SORT`
                              t_arg  = VALUE #( ( `${$parameters>/column}.getSortProperty()` )
                                                ( `${$parameters>/sortOrder}` ) )
                              s_ctrl = VALUE #( check_prevent_default = abap_true ) )

                    )->ele( `extension`
                        )->ele( n = `OverflowToolbar` ns = `m`
                            )->a( n = `style` v = `Clear`

                            )->tag( n = `Title` ns = `m`
                                )->a( n = `id`   v = `title`
                                )->a( n = `text` v = `Products`

                            )->tag( n = `ToolbarSpacer` ns = `m`

                            )->tag( n = `Button` ns = `m`
                                )->a( n = `icon`    v = `sap-icon://sorting-ranking`
                                )->a( n = `tooltip` v = `Sort ascending across Categories and Name`
                                )->a( n = `press`   v = client->_event( `SORT_CATEGORIES_AND_NAME` )

                            )->tag( n = `Button` ns = `m`
                                )->a( n = `icon`    v = `sap-icon://sort`
                                )->a( n = `tooltip` v = `Sort Categories in addition to current sorting`
                                )->a( n = `press`   v = client->_event( `SORT_CATEGORIES` )

                            )->tag( n = `Button` ns = `m`
                                )->a( n = `icon`    v = `sap-icon://decline`
                                )->a( n = `tooltip` v = `Clear all sortings`
                                )->a( n = `press`   v = client->_event( `CLEAR_SORTINGS` )

                        )->end(
                    )->end(
                    )->ele( `columns`
                        )->ele( `Column`
                            )->a( n = `id`           v = `name`
                            )->a( n = `width`        v = `11rem`
                            )->a( n = `sortProperty` v = `NAME`
                            )->a( n = `sortOrder`    v = client->_bind( sort_name )

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Product Name`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{NAME}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `id`                v = `categories`
                            )->a( n = `width`             v = `11rem`
                            )->a( n = `showSortMenuEntry` v = `false`
                            )->a( n = `sortProperty`      v = `CATEGORY`
                            )->a( n = `sortOrder`         v = client->_bind( sort_category )

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Category`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{CATEGORY}`
                                    )->a( n = `wrapping` v = `false`

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
                            )->a( n = `id`           v = `quantity`
                            )->a( n = `width`        v = `6rem`
                            )->a( n = `hAlign`       v = `End`
                            )->a( n = `sortProperty` v = `QUANTITY`
                            )->a( n = `sortOrder`    v = client->_bind( sort_quantity )

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Quantity`

                            )->ele( `template`
                                )->tag( n = `Label` ns = `m`
                                    )->a( n = `text` v = |\{ path: 'QUANTITY', type: 'sap.ui.model.type.Integer' \}|

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `id`           v = `deliverydate`
                            )->a( n = `width`        v = `9rem`
                            )->a( n = `sortProperty` v = `DELIVERYDATESTR`
                            )->a( n = `sortOrder`    v = client->_bind( sort_deliverydate )

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Delivery Date`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = |\{ path: 'DELIVERYDATESTR', type: 'sap.ui.model.type.Date', formatOptions: \{ source: \{ pattern: 'dd/MM/yyyy' \}, style: 'long' \} \}|
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                    )->end(
                    )->ele( `footer`
                        )->tag( n = `OverflowToolbar` ns = `m`
                            )->a( n = `id` v = `infobar` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `SORT`.
        " sortDeliveryDate: no multi-column sorting - every other column's
        " indicator is reset first, then the pressed one is sorted. The
        " delivery-date column is the reason the sort runs server-side at all:
        " its cells hold dd/MM/yyyy STRINGS, which no text compare can order,
        " so the underlying timestamp is sorted instead (the ABAP equivalent of
        " the original's custom Sorter.fnCompare)
        DATA(lv_property)  = client->get_event_arg( ).
        DATA(lv_order)     = client->get_event_arg( 2 ).
        DATA(lv_ascending) = xsdbool( lv_order <> `Descending` ).
        sort_clear( ).

        CASE lv_property.
          WHEN `NAME`.
            sort_name = lv_order.
            IF lv_ascending = abap_true.
              SORT t_products BY name ASCENDING.
            ELSE.
              SORT t_products BY name DESCENDING.
            ENDIF.

          WHEN `CATEGORY`.
            sort_category = lv_order.
            IF lv_ascending = abap_true.
              SORT t_products BY category ASCENDING.
            ELSE.
              SORT t_products BY category DESCENDING.
            ENDIF.

          WHEN `QUANTITY`.
            sort_quantity = lv_order.
            IF lv_ascending = abap_true.
              SORT t_products BY quantity ASCENDING.
            ELSE.
              SORT t_products BY quantity DESCENDING.
            ENDIF.

          WHEN `DELIVERYDATESTR`.
            sort_deliverydate = lv_order.
            IF lv_ascending = abap_true.
              SORT t_products BY deliverydate ASCENDING.
            ELSE.
              SORT t_products BY deliverydate DESCENDING.
            ENDIF.
        ENDCASE.

      WHEN `SORT_CATEGORIES_AND_NAME`.
        " sortCategoriesAndName: Category ascending, then Name ascending
        sort_clear( ).
        t_sortkeys    = VALUE #( ( field = `CATEGORY` ) ( field = `NAME` ) ).
        sort_category = `Ascending`.
        sort_name     = `Ascending`.
        sort_apply( ).

      WHEN `SORT_CATEGORIES`.
        " sortCategories passes bAdd = TRUE - Table.pushSortedColumn appends
        " the column to the active sorter list, so whatever was sorting keeps
        " precedence and Category is added behind it. Until 2026-08-21 this
        " issued a fresh single-key SORT instead, which reordered the whole
        " table while leaving the other columns' indicators standing: the
        " header claimed Name-ascending while the rows were Category-ascending.
        " The button's own tooltip says "in addition to current sorting".
        DATA(ls_cat) = VALUE ty_s_sortkey( field      = `CATEGORY`
                                           descending = category_descending ).
        READ TABLE t_sortkeys TRANSPORTING NO FIELDS WITH KEY field = `CATEGORY`.
        IF sy-subrc = 0.
          t_sortkeys[ sy-tabix ] = ls_cat.
        ELSE.
          APPEND ls_cat TO t_sortkeys.
        ENDIF.
        sort_category       = COND #( WHEN category_descending = abap_true THEN `Descending` ELSE `Ascending` ).
        category_descending = xsdbool( category_descending = abap_false ).
        sort_apply( ).

      WHEN `CLEAR_SORTINGS`.
        " clearAllSortings: drop the sorter and every column indicator - the
        " model goes back to the mock's own row order
        model_init( ).
        sort_clear( ).

    ENDCASE.


  ENDMETHOD.


  METHOD sort_clear.

    " _resetSortingState: every column back to SortOrder.None
    sort_name         = `None`.
    sort_category     = `None`.
    sort_quantity     = `None`.
    sort_deliverydate = `None`.
    CLEAR t_sortkeys.

  ENDMETHOD.


  METHOD sort_apply.

    " Sort by the whole key list, primary first. ABAP has one sort key per
    " SORT, so the list is applied from the LAST key to the first with STABLE -
    " each pass preserves the order the previous one established, which leaves
    " the rows ordered by the list exactly as a multi-key sorter would.
    DATA(lv_index) = lines( t_sortkeys ).
    WHILE lv_index >= 1.
      DATA(ls_key) = t_sortkeys[ lv_index ].
      " the component is named STATICALLY per key rather than through
      " SORT BY (ls_key-field): the transpiled backend drops the dynamic BY
      " clause altogether (abap.statements.sort(t, {}) - **e2e-caught
      " 2026-08-22** on app 571), so the table came back in its original order
      CASE ls_key-field.
        WHEN `CATEGORY`.
          IF ls_key-descending = abap_true.
            SORT t_products STABLE BY category AS TEXT DESCENDING.
          ELSE.
            SORT t_products STABLE BY category AS TEXT ASCENDING.
          ENDIF.
        WHEN OTHERS.
          IF ls_key-descending = abap_true.
            SORT t_products STABLE BY name AS TEXT DESCENDING.
          ELSE.
            SORT t_products STABLE BY name AS TEXT ASCENDING.
          ENDIF.
      ENDCASE.
      lv_index = lv_index - 1.
    ENDWHILE.

  ENDMETHOD.


  METHOD model_init.

    " the shared 123-row demo ProductCollection (sap/ui/demo/mock/products.json)
    " with the five columns the sample binds. DeliveryDate is Date.now()-derived
    " in the original (i mod 10 offset in 4-day steps); a fixed base (2026-07-23)
    " is used here so the port is deterministic - the corpus convention of app
    " 164. DeliveryDateStr is that timestamp formatted dd/MM/yyyy, exactly what
    " the controller's DateFormat produces; the raw timestamp is kept alongside
    " it as the sort key the original needs its custom compare function for.
    t_products = VALUE #(
      ( name = `Notebook Basic 15` category = `Laptops` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg` quantity = 10 deliverydatestr = `23/07/2026` deliverydate = 1784764800000 )
      ( name = `Notebook Basic 17` category = `Laptops` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1001.jpg` quantity = 20 deliverydatestr = `19/07/2026` deliverydate = 1784419200000 )
      ( name = `Notebook Basic 18` category = `Laptops` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1002.jpg` quantity = 10 deliverydatestr = `15/07/2026` deliverydate = 1784073600000 )
      ( name = `Notebook Basic 19` category = `Laptops` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1003.jpg` quantity = 15 deliverydatestr = `11/07/2026` deliverydate = 1783728000000 )
      ( name = `ITelO Vault` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1007.jpg` quantity = 15 deliverydatestr = `07/07/2026` deliverydate = 1783382400000 )
      ( name = `Notebook Professional 15` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg` quantity = 16 deliverydatestr = `03/07/2026` deliverydate = 1783036800000 )
      ( name = `Notebook Professional 17` category = `Laptops` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1011.jpg` quantity = 17 deliverydatestr = `29/06/2026` deliverydate = 1782691200000 )
      ( name = `ITelO Vault Net` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1020.jpg` quantity = 14 deliverydatestr = `25/06/2026` deliverydate = 1782345600000 )
      ( name = `ITelO Vault SAT` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1021.jpg` quantity = 50 deliverydatestr = `21/06/2026` deliverydate = 1782000000000 )
      ( name = `Comfort Easy` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1022.jpg` quantity = 30 deliverydatestr = `17/06/2026` deliverydate = 1781654400000 )
      ( name = `Comfort Senior` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1023.jpg` quantity = 24 deliverydatestr = `23/07/2026` deliverydate = 1784764800000 )
      ( name = `Ergo Screen E-I` category = `Flat Screen Monitors` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1030.jpg` quantity = 14 deliverydatestr = `19/07/2026` deliverydate = 1784419200000 )
      ( name = `Ergo Screen E-II` category = `Flat Screen Monitors` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1031.jpg` quantity = 24 deliverydatestr = `15/07/2026` deliverydate = 1784073600000 )
      ( name = `Ergo Screen E-III` category = `Flat Screen Monitors` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1032.jpg` quantity = 50 deliverydatestr = `11/07/2026` deliverydate = 1783728000000 )
      ( name = `Flat Basic` category = `Flat Screen Monitors` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1035.jpg` quantity = 23 deliverydatestr = `07/07/2026` deliverydate = 1783382400000 )
      ( name = `Flat Future` category = `Flat Screen Monitors` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1036.jpg` quantity = 22 deliverydatestr = `03/07/2026` deliverydate = 1783036800000 )
      ( name = `Flat XL` category = `Flat Screen Monitors` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1037.jpg` quantity = 23 deliverydatestr = `29/06/2026` deliverydate = 1782691200000 )
      ( name = `Laser Professional Eco` category = `Printers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1040.jpg` quantity = 21 deliverydatestr = `25/06/2026` deliverydate = 1782345600000 )
      ( name = `Laser Basic` category = `Printers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1041.jpg` quantity = 8 deliverydatestr = `21/06/2026` deliverydate = 1782000000000 )
      ( name = `Laser Allround` category = `Printers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1042.jpg` quantity = 9 deliverydatestr = `17/06/2026` deliverydate = 1781654400000 )
      ( name = `Ultra Jet Super Color` category = `Printers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1050.jpg` quantity = 17 deliverydatestr = `23/07/2026` deliverydate = 1784764800000 )
      ( name = `Ultra Jet Mobile` category = `Printers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1051.jpg` quantity = 18 deliverydatestr = `19/07/2026` deliverydate = 1784419200000 )
      ( name = `Ultra Jet Super Highspeed` category = `Printers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1052.jpg` quantity = 25 deliverydatestr = `15/07/2026` deliverydate = 1784073600000 )
      ( name = `Multi Print` category = `Multifunction Printers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1055.jpg` quantity = 16 deliverydatestr = `11/07/2026` deliverydate = 1783728000000 )
      ( name = `Multi Color` category = `Multifunction Printers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1056.jpg` quantity = 5 deliverydatestr = `07/07/2026` deliverydate = 1783382400000 )
      ( name = `Cordless Mouse` category = `Mice` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1060.jpg` quantity = 25 deliverydatestr = `03/07/2026` deliverydate = 1783036800000 )
      ( name = `Speed Mouse` category = `Mice` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1061.jpg` quantity = 12 deliverydatestr = `29/06/2026` deliverydate = 1782691200000 )
      ( name = `Track Mouse` category = `Mice` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1062.jpg` quantity = 12 deliverydatestr = `25/06/2026` deliverydate = 1782345600000 )
      ( name = `Ergonomic Keyboard` category = `Keyboards` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1063.jpg` quantity = 50 deliverydatestr = `21/06/2026` deliverydate = 1782000000000 )
      ( name = `Internet Keyboard` category = `Keyboards` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1064.jpg` quantity = 35 deliverydatestr = `17/06/2026` deliverydate = 1781654400000 )
      ( name = `Media Keyboard` category = `Keyboards` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1065.jpg` quantity = 26 deliverydatestr = `23/07/2026` deliverydate = 1784764800000 )
      ( name = `Mousepad` category = `Mousepads` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1066.jpg` quantity = 12 deliverydatestr = `19/07/2026` deliverydate = 1784419200000 )
      ( name = `Ergo Mousepad` category = `Mousepads` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1067.jpg` quantity = 16 deliverydatestr = `15/07/2026` deliverydate = 1784073600000 )
      ( name = `Designer Mousepad` category = `Mousepads` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1068.jpg` quantity = 26 deliverydatestr = `11/07/2026` deliverydate = 1783728000000 )
      ( name = `Universal card reader` category = `Computer System Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1069.jpg` quantity = 22 deliverydatestr = `07/07/2026`
        deliverydate = 1783382400000 )
      ( name = `Proctra X` category = `Graphic Cards` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1070.jpg` quantity = 15 deliverydatestr = `03/07/2026` deliverydate = 1783036800000 )
      ( name = `Gladiator MX` category = `Graphic Cards` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1071.jpg` quantity = 16 deliverydatestr = `29/06/2026` deliverydate = 1782691200000 )
      ( name = `Hurricane GX` category = `Graphic Cards` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1072.jpg` quantity = 13 deliverydatestr = `25/06/2026` deliverydate = 1782345600000 )
      ( name = `Hurricane GX/LN` category = `Graphic Cards` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1073.jpg` quantity = 5 deliverydatestr = `21/06/2026` deliverydate = 1782000000000 )
      ( name = `Photo Scan` category = `Scanners` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1080.jpg` quantity = 8 deliverydatestr = `17/06/2026` deliverydate = 1781654400000 )
      ( name = `Power Scan` category = `Scanners` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1081.jpg` quantity = 11 deliverydatestr = `23/07/2026` deliverydate = 1784764800000 )
      ( name = `Jet Scan Professional` category = `Scanners` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1082.jpg` quantity = 13 deliverydatestr = `19/07/2026` deliverydate = 1784419200000 )
      ( name = `Jet Scan Professional` category = `Scanners` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1083.jpg` quantity = 10 deliverydatestr = `15/07/2026` deliverydate = 1784073600000 )
      ( name = `Copymaster` category = `Multifunction Printers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1085.jpg` quantity = 10 deliverydatestr = `11/07/2026` deliverydate = 1783728000000 )
      ( name = `Surround Sound` category = `Speakers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1090.jpg` quantity = 20 deliverydatestr = `07/07/2026` deliverydate = 1783382400000 )
      ( name = `Blaster Extreme` category = `Speakers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1091.jpg` quantity = 15 deliverydatestr = `03/07/2026` deliverydate = 1783036800000 )
      ( name = `Sound Booster` category = `Speakers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1092.jpg` quantity = 50 deliverydatestr = `29/06/2026` deliverydate = 1782691200000 )
      ( name = `Lovely Sound 5.1 Wireless` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1095.jpg` quantity = 12 deliverydatestr = `25/06/2026` deliverydate = 1782345600000 )
      ( name = `Lovely Sound 5.1` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1096.jpg` quantity = 18 deliverydatestr = `21/06/2026` deliverydate = 1782000000000 )
      ( name = `Lovely Sound Stereo` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1097.jpg` quantity = 21 deliverydatestr = `17/06/2026` deliverydate = 1781654400000 )
      ( name = `Smart Office` category = `Software` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1100.jpg` quantity = 25 deliverydatestr = `23/07/2026` deliverydate = 1784764800000 )
      ( name = `Smart Design` category = `Software` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1101.jpg` quantity = 26 deliverydatestr = `19/07/2026` deliverydate = 1784419200000 )
      ( name = `Smart Network` category = `Software` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1102.jpg` quantity = 28 deliverydatestr = `15/07/2026` deliverydate = 1784073600000 )
      ( name = `Smart Multimedia` category = `Software` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1103.jpg` quantity = 9 deliverydatestr = `11/07/2026` deliverydate = 1783728000000 )
      ( name = `Smart Games` category = `Software` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1104.jpg` quantity = 13 deliverydatestr = `07/07/2026` deliverydate = 1783382400000 )
      ( name = `Smart Internet Antivirus` category = `Software` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1105.jpg` quantity = 17 deliverydatestr = `03/07/2026` deliverydate = 1783036800000 )
      ( name = `Smart Firewall` category = `Software` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1106.jpg` quantity = 19 deliverydatestr = `29/06/2026` deliverydate = 1782691200000 )
      ( name = `Smart Money` category = `Software` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1107.jpg` quantity = 18 deliverydatestr = `25/06/2026` deliverydate = 1782345600000 )
      ( name = `PC Lock` category = `Computer System Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1110.jpg` quantity = 14 deliverydatestr = `21/06/2026` deliverydate = 1782000000000 )
      ( name = `Notebook Lock` category = `Computer System Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1111.jpg` quantity = 20 deliverydatestr = `17/06/2026` deliverydate = 1781654400000 )
      ( name = `Web cam reality` category = `Computer System Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1112.jpg` quantity = 27 deliverydatestr = `23/07/2026` deliverydate = 1784764800000 )
      ( name = `Screen clean` category = `Computer System Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1113.jpg` quantity = 17 deliverydatestr = `19/07/2026` deliverydate = 1784419200000 )
      ( name = `Fabric bag professional` category = `Computer System Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1114.jpg` quantity = 14 deliverydatestr = `15/07/2026`
        deliverydate = 1784073600000 )
      ( name = `Wireless DSL Router` category = `Telecommunications` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1115.jpg` quantity = 16 deliverydatestr = `11/07/2026` deliverydate = 1783728000000 )
      ( name = `Wireless DSL Router / Repeater` category = `Telecommunications` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1116.jpg` quantity = 12 deliverydatestr = `07/07/2026`
        deliverydate = 1783382400000 )
      ( name = `Wireless DSL Router / Repeater and Print Server` category = `Telecommunications` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1117.jpg` quantity = 12 deliverydatestr = `03/07/2026`
        deliverydate = 1783036800000 )
      ( name = `USB Stick` category = `Computer System Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1118.jpg` quantity = 14 deliverydatestr = `29/06/2026` deliverydate = 1782691200000 )
      ( name = `Travel Adapter` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1119.jpg` quantity = 10 deliverydatestr = `25/06/2026` deliverydate = 1782345600000 )
      ( name = `Cordless Bluetooth Keyboard, english international` category = `Keyboards` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1120.jpg` quantity = 13 deliverydatestr = `21/06/2026`
        deliverydate = 1782000000000 )
      ( name = `Flat XXL` category = `Flat Screen Monitors` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1137.jpg` quantity = 10 deliverydatestr = `17/06/2026` deliverydate = 1781654400000 )
      ( name = `Pocket Mouse` category = `Mice` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1138.jpg` quantity = 20 deliverydatestr = `23/07/2026` deliverydate = 1784764800000 )
      ( name = `PC Power Station` category = `PCs` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1210.jpg` quantity = 22 deliverydatestr = `19/07/2026` deliverydate = 1784419200000 )
      ( name = `Astro Laptop 1516` category = `Laptops` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1251.jpg` quantity = 23 deliverydatestr = `15/07/2026` deliverydate = 1784073600000 )
      ( name = `Astro Phone 6` category = `Smartphones and Tablets` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1252.jpg` quantity = 28 deliverydatestr = `11/07/2026` deliverydate = 1783728000000 )
      ( name = `Benda Laptop 1408` category = `Laptops` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1253.jpg` quantity = 27 deliverydatestr = `07/07/2026` deliverydate = 1783382400000 )
      ( name = `Bending Screen 21HD` category = `Flat Screens` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1254.jpg` quantity = 23 deliverydatestr = `03/07/2026` deliverydate = 1783036800000 )
      ( name = `Broad Screen 22HD` category = `Flat Screens` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1255.jpg` quantity = 5 deliverydatestr = `29/06/2026` deliverydate = 1782691200000 )
      ( name = `Cerdik Phone 7` category = `Smartphones and Tablets` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1256.jpg` quantity = 19 deliverydatestr = `25/06/2026` deliverydate = 1782345600000 )
      ( name = `Cepat Tablet 10.5` category = `Smartphones and Tablets` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1257.jpg` quantity = 17 deliverydatestr = `21/06/2026` deliverydate = 1782000000000 )
      ( name = `Cepat Tablet 8` category = `Smartphones and Tablets` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1258.jpg` quantity = 24 deliverydatestr = `17/06/2026` deliverydate = 1781654400000 )
      ( name = `Server Basic` category = `Servers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1500.jpg` quantity = 24 deliverydatestr = `23/07/2026` deliverydate = 1784764800000 )
      ( name = `Server Professional` category = `Servers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1501.jpg` quantity = 26 deliverydatestr = `19/07/2026` deliverydate = 1784419200000 )
      ( name = `Server Power Pro` category = `Servers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1502.jpg` quantity = 34 deliverydatestr = `15/07/2026` deliverydate = 1784073600000 )
      ( name = `Family PC Basic` category = `Desktop Computers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1600.jpg` quantity = 10 deliverydatestr = `11/07/2026` deliverydate = 1783728000000 )
      ( name = `Family PC Pro` category = `Desktop Computers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1601.jpg` quantity = 20 deliverydatestr = `07/07/2026` deliverydate = 1783382400000 )
      ( name = `Gaming Monster` category = `Desktop Computers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1602.jpg` quantity = 24 deliverydatestr = `03/07/2026` deliverydate = 1783036800000 )
      ( name = `Gaming Monster Pro` category = `Desktop Computers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1603.jpg` quantity = 25 deliverydatestr = `29/06/2026` deliverydate = 1782691200000 )
      ( name = `7" Widescreen Portable DVD Player w MP3` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2000.jpg` quantity = 20 deliverydatestr = `25/06/2026`
        deliverydate = 1782345600000 )
      ( name = `10" Portable DVD player` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2001.jpg` quantity = 21 deliverydatestr = `21/06/2026` deliverydate = 1782000000000 )
      ( name = `Portable DVD Player with 9" LCD Monitor` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2002.jpg` quantity = 50 deliverydatestr = `17/06/2026`
        deliverydate = 1781654400000 )
      ( name = `CD/DVD case: 264 sleeves` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2025.jpg` quantity = 26 deliverydatestr = `23/07/2026` deliverydate = 1784764800000 )
      ( name = `Audio/Video Cable Kit - 4m` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2026.jpg` quantity = 16 deliverydatestr = `19/07/2026` deliverydate = 1784419200000 )
      ( name = `Removable CD/DVD Laser Labels` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2027.jpg` quantity = 25 deliverydatestr = `15/07/2026` deliverydate = 1784073600000 )
      ( name = `Beam Breaker B-1` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6100.jpg` quantity = 32 deliverydatestr = `11/07/2026` deliverydate = 1783728000000 )
      ( name = `Beam Breaker B-2` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6101.jpg` quantity = 18 deliverydatestr = `07/07/2026` deliverydate = 1783382400000 )
      ( name = `Beam Breaker B-3` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6102.jpg` quantity = 16 deliverydatestr = `03/07/2026` deliverydate = 1783036800000 )
      ( name = `Play Movie` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6110.jpg` quantity = 15 deliverydatestr = `29/06/2026` deliverydate = 1782691200000 )
      ( name = `Record Movie` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6111.jpg` quantity = 24 deliverydatestr = `25/06/2026` deliverydate = 1782345600000 )
      ( name = `ITelo MusicStick` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6120.jpg` quantity = 15 deliverydatestr = `21/06/2026` deliverydate = 1782000000000 )
      ( name = `ITelo Jog-Mate` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6121.jpg` quantity = 24 deliverydatestr = `17/06/2026` deliverydate = 1781654400000 )
      ( name = `Power Pro Player 40` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6122.jpg` quantity = 23 deliverydatestr = `23/07/2026` deliverydate = 1784764800000 )
      ( name = `Power Pro Player 80` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6123.jpg` quantity = 13 deliverydatestr = `19/07/2026` deliverydate = 1784419200000 )
      ( name = `Flat Watch HD32` category = `Flat Screen TVs` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6130.jpg` quantity = 16 deliverydatestr = `15/07/2026` deliverydate = 1784073600000 )
      ( name = `Flat Watch HD37` category = `Flat Screen TVs` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6131.jpg` quantity = 14 deliverydatestr = `11/07/2026` deliverydate = 1783728000000 )
      ( name = `Flat Watch HD41` category = `Flat Screen TVs` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6132.jpg` quantity = 13 deliverydatestr = `07/07/2026` deliverydate = 1783382400000 )
      ( name = `Copperberry` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7000.jpg` quantity = 5 deliverydatestr = `03/07/2026` deliverydate = 1783036800000 )
      ( name = `Silverberry` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7010.jpg` quantity = 9 deliverydatestr = `29/06/2026` deliverydate = 1782691200000 )
      ( name = `Goldberry` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7020.jpg` quantity = 11 deliverydatestr = `25/06/2026` deliverydate = 1782345600000 )
      ( name = `Platinberry` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7030.jpg` quantity = 12 deliverydatestr = `21/06/2026` deliverydate = 1782000000000 )
      ( name = `ITelO FlexTop I4000` category = `Laptops` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8000.jpg` quantity = 11 deliverydatestr = `17/06/2026` deliverydate = 1781654400000 )
      ( name = `ITelO FlexTop I6300c` category = `Laptops` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8001.jpg` quantity = 20 deliverydatestr = `23/07/2026` deliverydate = 1784764800000 )
      ( name = `ITelO FlexTop I9100` category = `Laptops` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8002.jpg` quantity = 20 deliverydatestr = `19/07/2026` deliverydate = 1784419200000 )
      ( name = `ITelO FlexTop I9800` category = `Laptops` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8003.jpg` quantity = 22 deliverydatestr = `15/07/2026` deliverydate = 1784073600000 )
      ( name = `Smartphone Leather Case` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9991.jpg` quantity = 12 deliverydatestr = `11/07/2026` deliverydate = 1783728000000 )
      ( name = `Smartphone Alpha` category = `Smartphones and Tablets` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9992.jpg` quantity = 13 deliverydatestr = `07/07/2026` deliverydate = 1783382400000 )
      ( name = `Mini Tablet` category = `Smartphones and Tablets` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9993.jpg` quantity = 10 deliverydatestr = `03/07/2026` deliverydate = 1783036800000 )
      ( name = `Camcorder View` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9994.jpg` quantity = 50 deliverydatestr = `29/06/2026` deliverydate = 1782691200000 )
      ( name = `Tablet Pouch` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9995.jpg` quantity = 34 deliverydatestr = `25/06/2026` deliverydate = 1782345600000 )
      ( name = `Tablet Pouch` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9996.jpg` quantity = 34 deliverydatestr = `21/06/2026` deliverydate = 1782000000000 )
      ( name = `e-Book Reader ReadMe` category = `Smartphones and Tablets` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9997.jpg` quantity = 23 deliverydatestr = `17/06/2026` deliverydate = 1781654400000 )
      ( name = `Smartphone Beta` category = `Smartphones and Tablets` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9998.jpg` quantity = 21 deliverydatestr = `23/07/2026` deliverydate = 1784764800000 )
      ( name = `Maxi Tablet` category = `Tablets` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9999.jpg` quantity = 20 deliverydatestr = `19/07/2026` deliverydate = 1784419200000 )
      ( name = `Flyer` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/PF-1000.jpg` quantity = 33 deliverydatestr = `15/07/2026` deliverydate = 1784073600000 )
      ).

  ENDMETHOD.

ENDCLASS.
