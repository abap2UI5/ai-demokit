" @keywords table sap.ui.table filtering overflowtoolbar title toolbarspacer togglebutton button toolbarseparator searchfield column label
" @summary Example showing the different facets of filtering within a table
CLASS z2ui5_cl_smpc_app_354 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name           TYPE string,
        category       TYPE string,
        productpicurl  TYPE string,
        available      TYPE abap_bool,
        availablestate TYPE string,
        status         TYPE string,
        price          TYPE p LENGTH 13 DECIMALS 2,
        currencycode   TYPE string,
        quantity       TYPE i,
      END OF ty_s_product,
      ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

    " the ROWS the table shows - the filtered result. The full catalog stays in
    " a method (see catalog): it is never bound, so it does not belong in the
    " model that travels on every round-trip
    DATA t_products TYPE ty_t_product.

    " the original's `ui>` model, folded onto the one default model
    DATA global_filter           TYPE string.
    DATA availability_filter_on  TYPE abap_bool.
    DATA cell_filter_on          TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    " the price column's own filter (the original's _oPriceFilter): the value
    " the user typed, and the +/- 20 band around it
    DATA price_filter TYPE string.

    METHODS view_display.
    METHODS on_event.
    METHODS filter_apply.
    METHODS catalog
      RETURNING
        VALUE(result) TYPE ty_t_product.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_354 IMPLEMENTATION.

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
    DATA temp2 TYPE z2ui5_if_client=>ty_s_event_control.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " the filtering demo. Every filter is applied in ABAP and the table binds
    " the filtered rows, so the controller's Filter objects and its
    " binding.filter( ) calls become one server-side selection.
    
    CLEAR temp1.
    INSERT `${$parameters>/column}.getFilterProperty()` INTO TABLE temp1.
    INSERT `${$parameters>/value}` INTO TABLE temp1.
    
    CLEAR temp2.
    temp2-prevent_default_expr = `${$parameters>/column}.getId().indexOf('price') >= 0`.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.ui.table`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:u`   v = `sap.ui.unified`
        )->a( n = `xmlns:m`   v = `sap.m`
        )->a( n = `height`    v = `100%`

        )->ele( n = `Page` ns = `m`
            )->a( n = `showHeader`      v = `false`
            )->a( n = `enableScrolling` v = `false`
            )->a( n = `class`           v = `sapUiContentPadding`

            )->ele( n = `content` ns = `m`
                )->ele( `Table`
                    )->a( n = `id`               v = `table`
                    )->a( n = `selectionMode`    v = `MultiToggle`
                    )->a( n = `rows`             v = client->_bind( t_products )
                    )->a( n = `enableCellFilter` v = client->_bind( cell_filter_on )
                    )->a( n = `filter`           v = client->_event(
                                        val    = `COLUMN_FILTER`
                                        t_arg  = temp1
                                        " filterPrice returns BEFORE preventDefault for
                                        " every column but price, so the other four keep
                                        " the table's own client-side filtering. A boolean
                                        " check_prevent_default is baked per WIRE and would
                                        " veto all five - the conditional form is what this
                                        " needs (worked precedent: app 247's columnResize)
                                        s_ctrl = temp2 )
                    )->a( n = `ariaLabelledBy`   v = `title`

                    )->ele( `extension`
                        )->ele( n = `OverflowToolbar` ns = `m`
                            )->a( n = `style` v = `Clear`

                            )->tag( n = `Title` ns = `m`
                                )->a( n = `id`   v = `title`
                                )->a( n = `text` v = `Products`

                            )->tag( n = `ToolbarSpacer` ns = `m`

                            )->tag( n = `ToggleButton` ns = `m`
                                )->a( n = `icon`    v = `sap-icon://complete`
                                )->a( n = `tooltip` v = `Show available products only`
                                )->a( n = `pressed` v = client->_bind( availability_filter_on )
                                )->a( n = `press`   v = client->_event( `TOGGLE_AVAILABILITY` )

                            )->tag( n = `ToggleButton` ns = `m`
                                )->a( n = `icon`    v = `sap-icon://grid`
                                )->a( n = `tooltip` v = `Enable / Disable Cell Filter Functionality`
                                )->a( n = `pressed` v = client->_bind( cell_filter_on )

                            )->tag( n = `Button` ns = `m`
                                )->a( n = `icon`    v = `sap-icon://decline`
                                )->a( n = `tooltip` v = `Clear all filters`
                                )->a( n = `press`   v = client->_event( `CLEAR_FILTERS` )

                            )->tag( n = `ToolbarSeparator` ns = `m`

                            )->tag( n = `SearchField` ns = `m`
                                )->a( n = `placeholder` v = `Filter`
                                )->a( n = `value`       v = client->_bind( global_filter )
                                )->a( n = `search`      v = client->_event( `SEARCH` )
                                )->a( n = `width`       v = `15rem`

                        )->end(
                    )->end(
                    )->ele( `columns`
                        )->ele( `Column`
                            )->a( n = `id`             v = `name`
                            )->a( n = `width`          v = `11rem`
                            )->a( n = `filterProperty` v = `NAME`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Product Name`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{NAME}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `id`                    v = `category`
                            )->a( n = `width`                 v = `11rem`
                            )->a( n = `filterProperty`        v = `CATEGORY`
                            )->a( n = `defaultFilterOperator` v = `StartsWith`

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
                            )->a( n = `id`                    v = `availability`
                            )->a( n = `width`                 v = `9rem`
                            )->a( n = `filterProperty`        v = `AVAILABLE`
                            )->a( n = `showFilterMenuEntry`   v = `false`
                            )->a( n = `defaultFilterOperator` v = `EQ`
                            )->a( n = `filterType`            v = `sap.ui.model.type.Boolean`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Status`

                            )->ele( `template`
                                )->tag( n = `ObjectStatus` ns = `m`
                                    )->a( n = `text`  v = `{STATUS}`
                                    )->a( n = `state` v = `{AVAILABLESTATE}`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `id`             v = `price`
                            )->a( n = `width`          v = `9rem`
                            )->a( n = `filterProperty` v = `PRICE`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Price`

                            )->ele( `template`
                                )->tag( n = `Currency` ns = `u`
                                    )->a( n = `value`    v = `{PRICE}`
                                    )->a( n = `currency` v = `{CURRENCYCODE}`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `id`             v = `quantity`
                            )->a( n = `width`          v = `6rem`
                            )->a( n = `hAlign`         v = `End`
                            )->a( n = `filterProperty` v = `QUANTITY`
                            )->a( n = `filterType`     v = `sap.ui.model.type.Integer`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Quantity`

                            )->ele( `template`
                                )->tag( n = `Label` ns = `m`
                                    )->a( n = `text` v = |\{ path: 'QUANTITY', type: 'sap.ui.model.type.Integer' \}|

                            )->end(
                        )->end(
                    )->end(
                    )->ele( `footer`
                        )->tag( n = `OverflowToolbar` ns = `m`
                            )->a( n = `id` v = `infobar`

                    )->end(
                )->end(
            )->end(
        )->end(
    )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA temp5 TYPE string_table.
        DATA temp3 LIKE temp5.
        DATA lv_col LIKE LINE OF temp3.
          DATA temp4 TYPE string_table.

    CASE client->get_event( ).

      WHEN `SEARCH`.
        " filterGlobally: Name OR Category contains the query
        filter_apply( ).

      WHEN `TOGGLE_AVAILABILITY`.
        " toggleAvailabilityFilter: filter the availability column on/off
        filter_apply( ).

      WHEN `COLUMN_FILTER`.
        " filterPrice: the price column filters a +/- 20 BAND around the entered
        " value instead of an exact match, so its client-side default is vetoed
        " and the band is computed server-side. Every other column keeps the
        " default and filters on its own filterProperty in the client, which is
        " what the original does by returning before preventDefault - the veto
        " is therefore conditional on the column, not baked into the wire
        IF client->get_event_arg( ) = `PRICE`.
          price_filter = client->get_event_arg( 2 ).
        ENDIF.
        filter_apply( ).

      WHEN `CLEAR_FILTERS`.
        " clearAllFilters resets the ui-model fields AND loops every column
        " calling oTable.filter( column, null ). Only the first half was
        " reproduced until 2026-08-24, which left the button doing half its job:
        " this port deliberately keeps Name / Category / Available / Quantity
        " filtering CLIENT-side (only the price column is vetoed), so those four
        " are Control-type filters living on the rows binding, untouched by
        " anything the backend does to the model - and on_event never rebuilds
        " the view, so they simply stayed on.
        global_filter          = ``.
        availability_filter_on = abap_false.
        price_filter           = ``.
        filter_apply( ).
        " Table.filter( col, null ) delegates to Column.filter( '' ), which does
        " setFiltered( abap_false ), setFilterValue( '' ) and re-applies the
        " Control filters - so the header indicators clear with the rows. The
        " price column needs no call: its filter event is vetoed, so
        " Column.filter returns before setFiltered and it never carries an
        " indicator in the first place.
        
        CLEAR temp5.
        INSERT `name` INTO TABLE temp5.
        INSERT `category` INTO TABLE temp5.
        INSERT `availability` INTO TABLE temp5.
        INSERT `quantity` INTO TABLE temp5.
        
        temp3 = temp5.
        
        LOOP AT temp3 INTO lv_col.
          
          CLEAR temp4.
          INSERT lv_col INTO TABLE temp4.
          INSERT `filter` INTO TABLE temp4.
          INSERT `` INTO TABLE temp4.
          client->follow_up_action( val   = client->cs_event-control_by_id
                                    t_arg = temp4 ).
        ENDLOOP.

    ENDCASE.


  ENDMETHOD.


  METHOD filter_apply.
      DATA lv_query TYPE string.
      DATA temp6 TYPE ty_t_product.
      DATA lt_keep LIKE temp6.
      DATA ls_row LIKE LINE OF t_products.
    DATA lv_text TYPE string.
    DATA lv_whole TYPE string.
    DATA lv_frac TYPE string.
      DATA temp7 TYPE decfloat34.
      DATA lv_price LIKE temp7.

    " the controller's _filter( ): the global filter and the price filter are
    " ANDed, each one on its own an OR over its columns
    t_products = catalog( ).

    IF global_filter IS NOT INITIAL.
      
      lv_query = to_upper( global_filter ).
      " Collected rather than deleted in place: DELETE ... INDEX sy-tabix inside
      " a LOOP over the same table shifts the rows under the loop's own cursor -
      " on a system it silently SKIPS the row after each deletion, on the
      " transpiled backend it raises TABLE_INVALID_INDEX (2026-08-17).
      
      CLEAR temp6.
      
      lt_keep = temp6.
      
      LOOP AT t_products INTO ls_row.
        IF to_upper( ls_row-name ) CS lv_query OR to_upper( ls_row-category ) CS lv_query.
          APPEND ls_row TO lt_keep.
        ENDIF.
      ENDLOOP.
      t_products = lt_keep.
    ENDIF.

    IF availability_filter_on = abap_true.
      DELETE t_products WHERE available = abap_false.
    ENDIF.

    " CO tests WHICH characters occur, never how they are ARRANGED: `.`, `12.`,
    " `1.2.3` and `1 2` all pass it and none of them is valid ABAP numeric text,
    " so CONV decfloat34 raised CX_SY_CONVERSION_NO_NUMBER and the round-trip
    " died. They are one Enter away: Column.filter( ) fires the table's filter
    " event with the RAW text before it parses anything (Column.js:914) and the
    " price column declares no filterType, so the column menu's field submits
    " whatever was typed. SPLIT decides the shape completely - at most one
    " point, digits on each side of it, at least one digit present - and the
    " padding literal is value-preserving: a leading zero on the whole part and
    " a trailing one on the fraction change nothing. No length term is needed
    " here (unlike the i-targeted guards elsewhere): decfloat34 carries 34
    " digits and the comparison against PRICE is done in decfloat34 too
    
    lv_text = condense( price_filter ).
    
    
    SPLIT lv_text AT `.` INTO lv_whole lv_frac.
    IF lv_text IS NOT INITIAL AND lv_text <> `.`
       AND lv_whole CO `0123456789` AND lv_frac CO `0123456789`.
      
      temp7 = |0{ lv_whole }.{ lv_frac }0|.
      
      lv_price = temp7.
      DELETE t_products WHERE price < lv_price - 20 OR price > lv_price + 20.
    ENDIF.

  ENDMETHOD.


  METHOD catalog.

    " the shared 123-row demo ProductCollection (sap/ui/demo/mock/products.json)
    " with the columns the six table columns bind. The controller's
    " formatAvailableToObjectState is precomputed into AVAILABLESTATE, since
    " business logic belongs in the backend. ProductPicUrl values point at the
    " OpenUI5 host per the asset-URL rule; the mock carries them host-relative
    DATA temp8 TYPE z2ui5_cl_smpc_app_354=>ty_t_product.
    DATA temp9 LIKE LINE OF temp8.
    CLEAR temp8.
    
    temp9-name = `Notebook Basic 15`.
    temp9-category = `Laptops`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 956.
    temp9-currencycode = `EUR`.
    temp9-quantity = 10.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Notebook Basic 17`.
    temp9-category = `Laptops`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1001.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 1249.
    temp9-currencycode = `EUR`.
    temp9-quantity = 20.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Notebook Basic 18`.
    temp9-category = `Laptops`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1002.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 1570.
    temp9-currencycode = `EUR`.
    temp9-quantity = 10.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Notebook Basic 19`.
    temp9-category = `Laptops`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1003.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Out of Stock`.
    temp9-price = 1650.
    temp9-currencycode = `EUR`.
    temp9-quantity = 15.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `ITelO Vault`.
    temp9-category = `Accessories`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1007.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Out of Stock`.
    temp9-price = 299.
    temp9-currencycode = `EUR`.
    temp9-quantity = 15.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Notebook Professional 15`.
    temp9-category = `Accessories`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Out of Stock`.
    temp9-price = 1999.
    temp9-currencycode = `EUR`.
    temp9-quantity = 16.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Notebook Professional 17`.
    temp9-category = `Laptops`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1011.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Out of Stock`.
    temp9-price = 2299.
    temp9-currencycode = `EUR`.
    temp9-quantity = 17.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `ITelO Vault Net`.
    temp9-category = `Accessories`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1020.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Discontinued`.
    temp9-price = 459.
    temp9-currencycode = `EUR`.
    temp9-quantity = 14.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `ITelO Vault SAT`.
    temp9-category = `Accessories`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1021.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 149.
    temp9-currencycode = `EUR`.
    temp9-quantity = 50.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Comfort Easy`.
    temp9-category = `Accessories`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1022.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Out of Stock`.
    temp9-price = 1679.
    temp9-currencycode = `EUR`.
    temp9-quantity = 30.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Comfort Senior`.
    temp9-category = `Accessories`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1023.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 512.
    temp9-currencycode = `EUR`.
    temp9-quantity = 24.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Ergo Screen E-I`.
    temp9-category = `Flat Screen Monitors`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1030.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 230.
    temp9-currencycode = `EUR`.
    temp9-quantity = 14.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Ergo Screen E-II`.
    temp9-category = `Flat Screen Monitors`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1031.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 285.
    temp9-currencycode = `EUR`.
    temp9-quantity = 24.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Ergo Screen E-III`.
    temp9-category = `Flat Screen Monitors`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1032.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Out of Stock`.
    temp9-price = 345.
    temp9-currencycode = `EUR`.
    temp9-quantity = 50.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Flat Basic`.
    temp9-category = `Flat Screen Monitors`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1035.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 399.
    temp9-currencycode = `EUR`.
    temp9-quantity = 23.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Flat Future`.
    temp9-category = `Flat Screen Monitors`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1036.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 430.
    temp9-currencycode = `EUR`.
    temp9-quantity = 22.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Flat XL`.
    temp9-category = `Flat Screen Monitors`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1037.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 1230.
    temp9-currencycode = `EUR`.
    temp9-quantity = 23.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Laser Professional Eco`.
    temp9-category = `Printers`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1040.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 830.
    temp9-currencycode = `EUR`.
    temp9-quantity = 21.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Laser Basic`.
    temp9-category = `Printers`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1041.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 490.
    temp9-currencycode = `EUR`.
    temp9-quantity = 8.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Laser Allround`.
    temp9-category = `Printers`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1042.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 349.
    temp9-currencycode = `EUR`.
    temp9-quantity = 9.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Ultra Jet Super Color`.
    temp9-category = `Printers`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1050.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Discontinued`.
    temp9-price = 139.
    temp9-currencycode = `EUR`.
    temp9-quantity = 17.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Ultra Jet Mobile`.
    temp9-category = `Printers`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1051.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Discontinued`.
    temp9-price = 99.
    temp9-currencycode = `EUR`.
    temp9-quantity = 18.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Ultra Jet Super Highspeed`.
    temp9-category = `Printers`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1052.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 170.
    temp9-currencycode = `EUR`.
    temp9-quantity = 25.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Multi Print`.
    temp9-category = `Multifunction Printers`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1055.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 99.
    temp9-currencycode = `EUR`.
    temp9-quantity = 16.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Multi Color`.
    temp9-category = `Multifunction Printers`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1056.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 119.
    temp9-currencycode = `EUR`.
    temp9-quantity = 5.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Cordless Mouse`.
    temp9-category = `Mice`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1060.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 9.
    temp9-currencycode = `EUR`.
    temp9-quantity = 25.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Speed Mouse`.
    temp9-category = `Mice`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1061.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 7.
    temp9-currencycode = `EUR`.
    temp9-quantity = 12.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Track Mouse`.
    temp9-category = `Mice`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1062.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Discontinued`.
    temp9-price = 11.
    temp9-currencycode = `EUR`.
    temp9-quantity = 12.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Ergonomic Keyboard`.
    temp9-category = `Keyboards`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1063.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 14.
    temp9-currencycode = `EUR`.
    temp9-quantity = 50.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Internet Keyboard`.
    temp9-category = `Keyboards`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1064.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Out of Stock`.
    temp9-price = 16.
    temp9-currencycode = `EUR`.
    temp9-quantity = 35.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Media Keyboard`.
    temp9-category = `Keyboards`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1065.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 26.
    temp9-currencycode = `EUR`.
    temp9-quantity = 26.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Mousepad`.
    temp9-category = `Mousepads`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1066.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = `6.99`.
    temp9-currencycode = `EUR`.
    temp9-quantity = 12.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Ergo Mousepad`.
    temp9-category = `Mousepads`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1067.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Out of Stock`.
    temp9-price = `8.99`.
    temp9-currencycode = `EUR`.
    temp9-quantity = 16.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Designer Mousepad`.
    temp9-category = `Mousepads`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1068.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = `12.99`.
    temp9-currencycode = `EUR`.
    temp9-quantity = 26.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Universal card reader`.
    temp9-category = `Computer System Accessories`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1069.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 14.
    temp9-currencycode = `EUR`.
    temp9-quantity = 22.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Proctra X`.
    temp9-category = `Graphic Cards`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1070.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Out of Stock`.
    temp9-price = `70.9`.
    temp9-currencycode = `EUR`.
    temp9-quantity = 15.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Gladiator MX`.
    temp9-category = `Graphic Cards`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1071.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Discontinued`.
    temp9-price = `81.7`.
    temp9-currencycode = `EUR`.
    temp9-quantity = 16.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Hurricane GX`.
    temp9-category = `Graphic Cards`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1072.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = `101.2`.
    temp9-currencycode = `EUR`.
    temp9-quantity = 13.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Hurricane GX/LN`.
    temp9-category = `Graphic Cards`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1073.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Out of Stock`.
    temp9-price = `139.99`.
    temp9-currencycode = `EUR`.
    temp9-quantity = 5.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Photo Scan`.
    temp9-category = `Scanners`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1080.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Out of Stock`.
    temp9-price = 129.
    temp9-currencycode = `EUR`.
    temp9-quantity = 8.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Power Scan`.
    temp9-category = `Scanners`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1081.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Out of Stock`.
    temp9-price = 89.
    temp9-currencycode = `EUR`.
    temp9-quantity = 11.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Jet Scan Professional`.
    temp9-category = `Scanners`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1082.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Out of Stock`.
    temp9-price = 169.
    temp9-currencycode = `EUR`.
    temp9-quantity = 13.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Jet Scan Professional`.
    temp9-category = `Scanners`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1083.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 189.
    temp9-currencycode = `EUR`.
    temp9-quantity = 10.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Copymaster`.
    temp9-category = `Multifunction Printers`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1085.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 1499.
    temp9-currencycode = `EUR`.
    temp9-quantity = 10.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Surround Sound`.
    temp9-category = `Speakers`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1090.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 39.
    temp9-currencycode = `EUR`.
    temp9-quantity = 20.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Blaster Extreme`.
    temp9-category = `Speakers`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1091.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 26.
    temp9-currencycode = `EUR`.
    temp9-quantity = 15.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Sound Booster`.
    temp9-category = `Speakers`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1092.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Discontinued`.
    temp9-price = 45.
    temp9-currencycode = `EUR`.
    temp9-quantity = 50.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Lovely Sound 5.1 Wireless`.
    temp9-category = `Accessories`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1095.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 49.
    temp9-currencycode = `EUR`.
    temp9-quantity = 12.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Lovely Sound 5.1`.
    temp9-category = `Accessories`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1096.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 39.
    temp9-currencycode = `EUR`.
    temp9-quantity = 18.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Lovely Sound Stereo`.
    temp9-category = `Accessories`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1097.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Out of Stock`.
    temp9-price = 29.
    temp9-currencycode = `EUR`.
    temp9-quantity = 21.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Smart Office`.
    temp9-category = `Software`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1100.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Out of Stock`.
    temp9-price = `89.9`.
    temp9-currencycode = `EUR`.
    temp9-quantity = 25.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Smart Design`.
    temp9-category = `Software`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1101.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = `79.9`.
    temp9-currencycode = `EUR`.
    temp9-quantity = 26.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Smart Network`.
    temp9-category = `Software`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1102.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 69.
    temp9-currencycode = `EUR`.
    temp9-quantity = 28.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Smart Multimedia`.
    temp9-category = `Software`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1103.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 77.
    temp9-currencycode = `EUR`.
    temp9-quantity = 9.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Smart Games`.
    temp9-category = `Software`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1104.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 55.
    temp9-currencycode = `EUR`.
    temp9-quantity = 13.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Smart Internet Antivirus`.
    temp9-category = `Software`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1105.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 29.
    temp9-currencycode = `EUR`.
    temp9-quantity = 17.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Smart Firewall`.
    temp9-category = `Software`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1106.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Discontinued`.
    temp9-price = 34.
    temp9-currencycode = `EUR`.
    temp9-quantity = 19.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Smart Money`.
    temp9-category = `Software`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1107.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Out of Stock`.
    temp9-price = `29.9`.
    temp9-currencycode = `EUR`.
    temp9-quantity = 18.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `PC Lock`.
    temp9-category = `Computer System Accessories`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1110.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = `8.9`.
    temp9-currencycode = `EUR`.
    temp9-quantity = 14.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Notebook Lock`.
    temp9-category = `Computer System Accessories`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1111.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = `6.9`.
    temp9-currencycode = `EUR`.
    temp9-quantity = 20.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Web cam reality`.
    temp9-category = `Computer System Accessories`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1112.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Out of Stock`.
    temp9-price = 39.
    temp9-currencycode = `EUR`.
    temp9-quantity = 27.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Screen clean`.
    temp9-category = `Computer System Accessories`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1113.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = `2.3`.
    temp9-currencycode = `EUR`.
    temp9-quantity = 17.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Fabric bag professional`.
    temp9-category = `Computer System Accessories`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1114.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 31.
    temp9-currencycode = `EUR`.
    temp9-quantity = 14.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Wireless DSL Router`.
    temp9-category = `Telecommunications`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1115.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 49.
    temp9-currencycode = `EUR`.
    temp9-quantity = 16.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Wireless DSL Router / Repeater`.
    temp9-category = `Telecommunications`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1116.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Out of Stock`.
    temp9-price = 59.
    temp9-currencycode = `EUR`.
    temp9-quantity = 12.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Wireless DSL Router / Repeater and Print Server`.
    temp9-category = `Telecommunications`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1117.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 69.
    temp9-currencycode = `EUR`.
    temp9-quantity = 12.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `USB Stick`.
    temp9-category = `Computer System Accessories`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1118.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 35.
    temp9-currencycode = `EUR`.
    temp9-quantity = 14.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Travel Adapter`.
    temp9-category = `Accessories`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1119.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Discontinued`.
    temp9-price = 79.
    temp9-currencycode = `EUR`.
    temp9-quantity = 10.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Cordless Bluetooth Keyboard, english international`.
    temp9-category = `Keyboards`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1120.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Out of Stock`.
    temp9-price = 29.
    temp9-currencycode = `EUR`.
    temp9-quantity = 13.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Flat XXL`.
    temp9-category = `Flat Screen Monitors`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1137.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Discontinued`.
    temp9-price = 1430.
    temp9-currencycode = `EUR`.
    temp9-quantity = 10.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Pocket Mouse`.
    temp9-category = `Mice`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1138.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 23.
    temp9-currencycode = `EUR`.
    temp9-quantity = 20.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `PC Power Station`.
    temp9-category = `PCs`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1210.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 2399.
    temp9-currencycode = `EUR`.
    temp9-quantity = 22.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Astro Laptop 1516`.
    temp9-category = `Laptops`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1251.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 989.
    temp9-currencycode = `EUR`.
    temp9-quantity = 23.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Astro Phone 6`.
    temp9-category = `Smartphones and Tablets`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1252.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 649.
    temp9-currencycode = `EUR`.
    temp9-quantity = 28.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Benda Laptop 1408`.
    temp9-category = `Laptops`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1253.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Discontinued`.
    temp9-price = 976.
    temp9-currencycode = `EUR`.
    temp9-quantity = 27.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Bending Screen 21HD`.
    temp9-category = `Flat Screens`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1254.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 250.
    temp9-currencycode = `EUR`.
    temp9-quantity = 23.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Broad Screen 22HD`.
    temp9-category = `Flat Screens`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1255.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Discontinued`.
    temp9-price = 270.
    temp9-currencycode = `EUR`.
    temp9-quantity = 5.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Cerdik Phone 7`.
    temp9-category = `Smartphones and Tablets`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1256.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Discontinued`.
    temp9-price = 549.
    temp9-currencycode = `EUR`.
    temp9-quantity = 19.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Cepat Tablet 10.5`.
    temp9-category = `Smartphones and Tablets`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1257.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 549.
    temp9-currencycode = `EUR`.
    temp9-quantity = 17.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Cepat Tablet 8`.
    temp9-category = `Smartphones and Tablets`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1258.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 529.
    temp9-currencycode = `EUR`.
    temp9-quantity = 24.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Server Basic`.
    temp9-category = `Servers`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1500.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 5000.
    temp9-currencycode = `EUR`.
    temp9-quantity = 24.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Server Professional`.
    temp9-category = `Servers`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1501.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Out of Stock`.
    temp9-price = 15000.
    temp9-currencycode = `EUR`.
    temp9-quantity = 26.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Server Power Pro`.
    temp9-category = `Servers`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1502.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 25000.
    temp9-currencycode = `EUR`.
    temp9-quantity = 34.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Family PC Basic`.
    temp9-category = `Desktop Computers`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1600.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 600.
    temp9-currencycode = `EUR`.
    temp9-quantity = 10.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Family PC Pro`.
    temp9-category = `Desktop Computers`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1601.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 900.
    temp9-currencycode = `EUR`.
    temp9-quantity = 20.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Gaming Monster`.
    temp9-category = `Desktop Computers`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1602.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 1200.
    temp9-currencycode = `EUR`.
    temp9-quantity = 24.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Gaming Monster Pro`.
    temp9-category = `Desktop Computers`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1603.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Discontinued`.
    temp9-price = 1700.
    temp9-currencycode = `EUR`.
    temp9-quantity = 25.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `7" Widescreen Portable DVD Player w MP3`.
    temp9-category = `Accessories`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2000.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = `249.99`.
    temp9-currencycode = `EUR`.
    temp9-quantity = 20.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `10" Portable DVD player`.
    temp9-category = `Accessories`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2001.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = `449.99`.
    temp9-currencycode = `EUR`.
    temp9-quantity = 21.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Portable DVD Player with 9" LCD Monitor`.
    temp9-category = `Accessories`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2002.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = `853.99`.
    temp9-currencycode = `EUR`.
    temp9-quantity = 50.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `CD/DVD case: 264 sleeves`.
    temp9-category = `Accessories`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2025.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Discontinued`.
    temp9-price = `44.99`.
    temp9-currencycode = `EUR`.
    temp9-quantity = 26.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Audio/Video Cable Kit - 4m`.
    temp9-category = `Accessories`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2026.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = `29.99`.
    temp9-currencycode = `EUR`.
    temp9-quantity = 16.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Removable CD/DVD Laser Labels`.
    temp9-category = `Accessories`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2027.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Discontinued`.
    temp9-price = `8.99`.
    temp9-currencycode = `EUR`.
    temp9-quantity = 25.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Beam Breaker B-1`.
    temp9-category = `Accessories`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6100.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Out of Stock`.
    temp9-price = 469.
    temp9-currencycode = `EUR`.
    temp9-quantity = 32.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Beam Breaker B-2`.
    temp9-category = `Accessories`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6101.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 679.
    temp9-currencycode = `EUR`.
    temp9-quantity = 18.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Beam Breaker B-3`.
    temp9-category = `Accessories`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6102.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Out of Stock`.
    temp9-price = 889.
    temp9-currencycode = `EUR`.
    temp9-quantity = 16.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Play Movie`.
    temp9-category = `Accessories`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6110.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 130.
    temp9-currencycode = `EUR`.
    temp9-quantity = 15.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Record Movie`.
    temp9-category = `Accessories`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6111.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Discontinued`.
    temp9-price = 288.
    temp9-currencycode = `EUR`.
    temp9-quantity = 24.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `ITelo MusicStick`.
    temp9-category = `Accessories`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6120.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 45.
    temp9-currencycode = `EUR`.
    temp9-quantity = 15.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `ITelo Jog-Mate`.
    temp9-category = `Accessories`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6121.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 63.
    temp9-currencycode = `EUR`.
    temp9-quantity = 24.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Power Pro Player 40`.
    temp9-category = `Accessories`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6122.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 167.
    temp9-currencycode = `EUR`.
    temp9-quantity = 23.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Power Pro Player 80`.
    temp9-category = `Accessories`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6123.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 299.
    temp9-currencycode = `EUR`.
    temp9-quantity = 13.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Flat Watch HD32`.
    temp9-category = `Flat Screen TVs`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6130.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 1459.
    temp9-currencycode = `EUR`.
    temp9-quantity = 16.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Flat Watch HD37`.
    temp9-category = `Flat Screen TVs`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6131.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 1199.
    temp9-currencycode = `EUR`.
    temp9-quantity = 14.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Flat Watch HD41`.
    temp9-category = `Flat Screen TVs`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6132.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Discontinued`.
    temp9-price = 899.
    temp9-currencycode = `EUR`.
    temp9-quantity = 13.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Copperberry`.
    temp9-category = `Accessories`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7000.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Discontinued`.
    temp9-price = 549.
    temp9-currencycode = `EUR`.
    temp9-quantity = 5.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Silverberry`.
    temp9-category = `Accessories`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7010.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Discontinued`.
    temp9-price = 549.
    temp9-currencycode = `EUR`.
    temp9-quantity = 9.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Goldberry`.
    temp9-category = `Accessories`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7020.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 549.
    temp9-currencycode = `EUR`.
    temp9-quantity = 11.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Platinberry`.
    temp9-category = `Accessories`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7030.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 549.
    temp9-currencycode = `EUR`.
    temp9-quantity = 12.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `ITelO FlexTop I4000`.
    temp9-category = `Laptops`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8000.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 799.
    temp9-currencycode = `EUR`.
    temp9-quantity = 11.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `ITelO FlexTop I6300c`.
    temp9-category = `Laptops`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8001.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Discontinued`.
    temp9-price = 799.
    temp9-currencycode = `EUR`.
    temp9-quantity = 20.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `ITelO FlexTop I9100`.
    temp9-category = `Laptops`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8002.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 1199.
    temp9-currencycode = `EUR`.
    temp9-quantity = 20.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `ITelO FlexTop I9800`.
    temp9-category = `Laptops`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8003.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 1388.
    temp9-currencycode = `EUR`.
    temp9-quantity = 22.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Smartphone Leather Case`.
    temp9-category = `Accessories`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9991.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 25.
    temp9-currencycode = `EUR`.
    temp9-quantity = 12.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Smartphone Alpha`.
    temp9-category = `Smartphones and Tablets`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9992.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Out of Stock`.
    temp9-price = 599.
    temp9-currencycode = `EUR`.
    temp9-quantity = 13.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Mini Tablet`.
    temp9-category = `Smartphones and Tablets`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9993.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 833.
    temp9-currencycode = `EUR`.
    temp9-quantity = 10.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Camcorder View`.
    temp9-category = `Accessories`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9994.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Out of Stock`.
    temp9-price = 1388.
    temp9-currencycode = `EUR`.
    temp9-quantity = 50.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Tablet Pouch`.
    temp9-category = `Accessories`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9995.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 20.
    temp9-currencycode = `EUR`.
    temp9-quantity = 34.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Tablet Pouch`.
    temp9-category = `Accessories`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9996.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 20.
    temp9-currencycode = `EUR`.
    temp9-quantity = 34.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `e-Book Reader ReadMe`.
    temp9-category = `Smartphones and Tablets`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9997.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 33.
    temp9-currencycode = `EUR`.
    temp9-quantity = 23.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Smartphone Beta`.
    temp9-category = `Smartphones and Tablets`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9998.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 30.
    temp9-currencycode = `EUR`.
    temp9-quantity = 21.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Maxi Tablet`.
    temp9-category = `Tablets`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9999.jpg`.
    temp9-available = abap_true.
    temp9-availablestate = `Success`.
    temp9-status = `Available`.
    temp9-price = 749.
    temp9-currencycode = `EUR`.
    temp9-quantity = 20.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Flyer`.
    temp9-category = `Accessories`.
    temp9-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/PF-1000.jpg`.
    temp9-available = abap_false.
    temp9-availablestate = `Error`.
    temp9-status = `Out of Stock`.
    temp9-price = 0.
    temp9-currencycode = `EUR`.
    temp9-quantity = 33.
    INSERT temp9 INTO TABLE temp8.
    result = temp8.

  ENDMETHOD.


  METHOD model_init.

    " the original's `ui>` model defaults: no global filter, both toggles off
    t_products = catalog( ).

  ENDMETHOD.

ENDCLASS.
