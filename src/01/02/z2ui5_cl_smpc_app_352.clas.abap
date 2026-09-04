" @keywords table sap.ui.table aggregations hbox icon title overflowtoolbar toolbarspacer searchfield facetfilter facetfilterlist facetfilteritem
" @summary Example which shows the different aggregations of the table
CLASS z2ui5_cl_smpc_app_352 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name           TYPE string,
        category       TYPE string,
        suppliername   TYPE string,
        status         TYPE string,
        availablestate TYPE string,
        price          TYPE p LENGTH 13 DECIMALS 2,
        currencycode   TYPE string,
      END OF ty_s_product,
      ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY,
      BEGIN OF ty_s_value,
        text     TYPE string,
        data     TYPE i,
        selected TYPE abap_bool,
      END OF ty_s_value,
      ty_t_value TYPE STANDARD TABLE OF ty_s_value WITH DEFAULT KEY,
      BEGIN OF ty_s_filter,
        type   TYPE string,
        values TYPE ty_t_value,
      END OF ty_s_filter.

    " the ROWS the table shows - the filtered result. The full catalog stays in
    " a method (see catalog): it is never bound, so it does not belong in the
    " model that travels on every round-trip
    DATA t_products TYPE ty_t_product.

    " /ProductCollectionStats/Filters - the two facet lists with their values;
    " each value carries the selected flag the FacetFilterItem binds two-way
    DATA t_filters TYPE STANDARD TABLE OF ty_s_filter WITH DEFAULT KEY.

    " the original's `ui>` model
    DATA filter_value TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS filter_apply.
    METHODS catalog
      RETURNING
        VALUE(result) TYPE ty_t_product.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_352 IMPLEMENTATION.

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
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " the aggregation demo: a SearchField and a two-list FacetFilter over the
    " same table. Both filters are applied in ABAP and the table binds the
    " result, so the controller's Filter objects become one server-side
    " selection; each FacetFilterItem binds its selected flag two-way, so the
    " listClose event only has to tell the backend to read them (the app-022
    " idiom).
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

                    )->ele( `extension`
                        )->ele( n = `HBox` ns = `m`
                            )->ele( n = `items` ns = `m`
                                )->tag( n = `Icon` ns = `c`
                                    )->a( n = `src`  v = `sap-icon://cart`
                                    )->a( n = `alt`  v = `Cart`
                                    )->a( n = `size` v = `1.25rem`

                                )->tag( n = `Title` ns = `m`
                                    )->a( n = `text`       v = `Shopping Portal`
                                    )->a( n = `titleStyle` v = `H3`
                                    )->a( n = `class`      v = `sapUiTinyMarginBeginEnd`

                            )->end(
                        )->end(
                        )->ele( n = `OverflowToolbar` ns = `m`
                            )->a( n = `style` v = `Clear`

                            )->tag( n = `Title` ns = `m`
                                )->a( n = `id`   v = `title`
                                )->a( n = `text` v = `Products`

                            )->tag( n = `ToolbarSpacer` ns = `m`

                            )->tag( n = `SearchField` ns = `m`
                                )->a( n = `placeholder` v = `Filter`
                                )->a( n = `value`       v = client->_bind( filter_value )
                                )->a( n = `search`      v = client->_event( `SEARCH` )
                                )->a( n = `width`       v = `15rem`

                        )->end(
                        )->ele( n = `FacetFilter` ns = `m`
                            )->a( n = `id`                  v = `facetFilter`
                            )->a( n = `type`                v = `Simple`
                            )->a( n = `showReset`           v = `true`
                            )->a( n = `showPopoverOKButton` v = `true`
                            )->a( n = `reset`               v = client->_event( `FACET_RESET` )
                            )->a( n = `lists`               v = client->_bind( t_filters )

                            )->ele( n = `lists` ns = `m`
                                )->ele( n = `FacetFilterList` ns = `m`
                                    )->a( n = `title`     v = `{TYPE}`
                                    )->a( n = `key`       v = `{TYPE}`
                                    )->a( n = `mode`      v = `MultiSelect`
                                    )->a( n = `listClose` v = client->_event( `LIST_CLOSE` )
                                    )->a( n = `items`     v = |\{ path: 'VALUES', templateShareable: false \}|

                                    )->ele( n = `items` ns = `m`
                                        )->tag( n = `FacetFilterItem` ns = `m`
                                            )->a( n = `text`     v = `{TEXT}`
                                            )->a( n = `key`      v = `{TEXT}`
                                            )->a( n = `selected` v = `{SELECTED}`

                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                    )->ele( `noData`
                        )->tag( n = `Link` ns = `m`
                            )->a( n = `class` v = `sapUiMediumMargin`
                            )->a( n = `text`  v = `No Data found. Press here to reset all filters.`
                            )->a( n = `press` v = client->_event( `CLEAR_FILTERS` )

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
                                )->a( n = `text` v = `Category`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{CATEGORY}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `width` v = `12rem`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Supplier`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{SUPPLIERNAME}`
                                    )->a( n = `wrapping` v = `false`

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
        DATA temp1 LIKE LINE OF t_filters.
        DATA lr_filter LIKE REF TO temp1.
          DATA temp2 LIKE LINE OF lr_filter->values.
          DATA lr_value LIKE REF TO temp2.

    CASE client->get_event( ).

      WHEN `SEARCH`.
        " handleTxtFilter: Name OR Status contains the query
        filter_apply( ).

      WHEN `LIST_CLOSE`.
        " handleListClose: the two-way bound selected flags are already back
        filter_apply( ).

      WHEN `FACET_RESET`.
        " handleFacetFilterReset: clear every facet selection
        
        
        LOOP AT t_filters REFERENCE INTO lr_filter.
          
          
          LOOP AT lr_filter->values REFERENCE INTO lr_value.
            lr_value->selected = abap_false.
          ENDLOOP.
        ENDLOOP.
        filter_apply( ).

      WHEN `CLEAR_FILTERS`.
        " clearAllFilters: the noData Link resets both filters at once
        filter_value = ``.
        LOOP AT t_filters REFERENCE INTO lr_filter.
          LOOP AT lr_filter->values REFERENCE INTO lr_value.
            lr_value->selected = abap_false.
          ENDLOOP.
        ENDLOOP.
        filter_apply( ).

    ENDCASE.


  ENDMETHOD.


  METHOD filter_apply.
      DATA lv_query TYPE string.
      DATA temp3 TYPE ty_t_product.
      DATA lt_keep LIKE temp3.
      DATA ls_row LIKE LINE OF t_products.
    DATA ls_filter LIKE LINE OF t_filters.
      DATA temp4 TYPE string_table.
      DATA value LIKE LINE OF ls_filter-values.
      DATA lt_selected LIKE temp4.
      DATA temp6 TYPE ty_t_product.
      DATA lt_facet_keep LIKE temp6.
      DATA ls_product LIKE LINE OF t_products.
        DATA temp7 TYPE string.
        DATA lv_value LIKE temp7.
        DATA temp8 LIKE sy-subrc.

    " the controller's _filter( ): the text filter and the facet filter are
    " ANDed; inside a facet list the selected values are ORed, and only a list
    " with a selection takes part - exactly the two nested Filter groups
    t_products = catalog( ).

    " Collected rather than deleted in place: DELETE ... INDEX sy-tabix inside
    " a LOOP over the same table shifts the rows under the loop's own cursor -
    " on a system it silently SKIPS the row after each deletion, and on the
    " transpiled backend it raises TABLE_INVALID_INDEX (found by the e2e
    " interaction, 2026-08-17). Building the keep list has neither problem.
    IF filter_value IS NOT INITIAL.
      
      lv_query = to_upper( filter_value ).
      
      CLEAR temp3.
      
      lt_keep = temp3.
      
      LOOP AT t_products INTO ls_row.
        IF to_upper( ls_row-name ) CS lv_query OR to_upper( ls_row-status ) CS lv_query.
          APPEND ls_row TO lt_keep.
        ENDIF.
      ENDLOOP.
      t_products = lt_keep.
    ENDIF.

    
    LOOP AT t_filters INTO ls_filter.
      
      CLEAR temp4.
      
      LOOP AT ls_filter-values INTO value WHERE selected = abap_true.
        INSERT value-text INTO TABLE temp4.
      ENDLOOP.
      
      lt_selected = temp4.
      IF lt_selected IS INITIAL.
        CONTINUE.
      ENDIF.
      
      CLEAR temp6.
      
      lt_facet_keep = temp6.
      
      LOOP AT t_products INTO ls_product.
        
        IF ls_filter-type = `Category`.
          temp7 = ls_product-category.
        ELSE.
          temp7 = ls_product-suppliername.
        ENDIF.
        
        lv_value = temp7.
        
        READ TABLE lt_selected WITH KEY table_line = lv_value TRANSPORTING NO FIELDS.
        temp8 = sy-subrc.
        IF temp8 = 0.
          APPEND ls_product TO lt_facet_keep.
        ENDIF.
      ENDLOOP.
      t_products = lt_facet_keep.
    ENDLOOP.

  ENDMETHOD.


  METHOD catalog.

    " the shared 123-row demo ProductCollection (sap/ui/demo/mock/products.json)
    " with the five columns the sample binds. The controller's
    " formatAvailableToObjectState is precomputed into AVAILABLESTATE, since
    " business logic belongs in the backend
    DATA temp9 TYPE z2ui5_cl_smpc_app_352=>ty_t_product.
    DATA temp10 LIKE LINE OF temp9.
    CLEAR temp9.
    
    temp10-name = `Notebook Basic 15`.
    temp10-category = `Laptops`.
    temp10-suppliername = `Very Best Screens`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 956.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Notebook Basic 17`.
    temp10-category = `Laptops`.
    temp10-suppliername = `Very Best Screens`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 1249.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Notebook Basic 18`.
    temp10-category = `Laptops`.
    temp10-suppliername = `Very Best Screens`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 1570.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Notebook Basic 19`.
    temp10-category = `Laptops`.
    temp10-suppliername = `Smartcards`.
    temp10-status = `Out of Stock`.
    temp10-availablestate = `Error`.
    temp10-price = 1650.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `ITelO Vault`.
    temp10-category = `Accessories`.
    temp10-suppliername = `Technocom`.
    temp10-status = `Out of Stock`.
    temp10-availablestate = `Error`.
    temp10-price = 299.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Notebook Professional 15`.
    temp10-category = `Accessories`.
    temp10-suppliername = `Very Best Screens`.
    temp10-status = `Out of Stock`.
    temp10-availablestate = `Error`.
    temp10-price = 1999.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Notebook Professional 17`.
    temp10-category = `Laptops`.
    temp10-suppliername = `Very Best Screens`.
    temp10-status = `Out of Stock`.
    temp10-availablestate = `Error`.
    temp10-price = 2299.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `ITelO Vault Net`.
    temp10-category = `Accessories`.
    temp10-suppliername = `Technocom`.
    temp10-status = `Discontinued`.
    temp10-availablestate = `Error`.
    temp10-price = 459.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `ITelO Vault SAT`.
    temp10-category = `Accessories`.
    temp10-suppliername = `Technocom`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 149.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Comfort Easy`.
    temp10-category = `Accessories`.
    temp10-suppliername = `Technocom`.
    temp10-status = `Out of Stock`.
    temp10-availablestate = `Error`.
    temp10-price = 1679.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Comfort Senior`.
    temp10-category = `Accessories`.
    temp10-suppliername = `Technocom`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 512.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Ergo Screen E-I`.
    temp10-category = `Flat Screen Monitors`.
    temp10-suppliername = `Very Best Screens`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 230.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Ergo Screen E-II`.
    temp10-category = `Flat Screen Monitors`.
    temp10-suppliername = `Very Best Screens`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 285.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Ergo Screen E-III`.
    temp10-category = `Flat Screen Monitors`.
    temp10-suppliername = `Very Best Screens`.
    temp10-status = `Out of Stock`.
    temp10-availablestate = `Error`.
    temp10-price = 345.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Flat Basic`.
    temp10-category = `Flat Screen Monitors`.
    temp10-suppliername = `Very Best Screens`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 399.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Flat Future`.
    temp10-category = `Flat Screen Monitors`.
    temp10-suppliername = `Very Best Screens`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 430.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Flat XL`.
    temp10-category = `Flat Screen Monitors`.
    temp10-suppliername = `Very Best Screens`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 1230.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Laser Professional Eco`.
    temp10-category = `Printers`.
    temp10-suppliername = `Alpha Printers`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 830.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Laser Basic`.
    temp10-category = `Printers`.
    temp10-suppliername = `Alpha Printers`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 490.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Laser Allround`.
    temp10-category = `Printers`.
    temp10-suppliername = `Alpha Printers`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 349.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Ultra Jet Super Color`.
    temp10-category = `Printers`.
    temp10-suppliername = `Alpha Printers`.
    temp10-status = `Discontinued`.
    temp10-availablestate = `Error`.
    temp10-price = 139.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Ultra Jet Mobile`.
    temp10-category = `Printers`.
    temp10-suppliername = `Printer for All`.
    temp10-status = `Discontinued`.
    temp10-availablestate = `Error`.
    temp10-price = 99.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Ultra Jet Super Highspeed`.
    temp10-category = `Printers`.
    temp10-suppliername = `Printer for All`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 170.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Multi Print`.
    temp10-category = `Multifunction Printers`.
    temp10-suppliername = `Printer for All`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 99.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Multi Color`.
    temp10-category = `Multifunction Printers`.
    temp10-suppliername = `Printer for All`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 119.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Cordless Mouse`.
    temp10-category = `Mice`.
    temp10-suppliername = `Oxynum`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 9.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Speed Mouse`.
    temp10-category = `Mice`.
    temp10-suppliername = `Oxynum`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 7.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Track Mouse`.
    temp10-category = `Mice`.
    temp10-suppliername = `Oxynum`.
    temp10-status = `Discontinued`.
    temp10-availablestate = `Error`.
    temp10-price = 11.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Ergonomic Keyboard`.
    temp10-category = `Keyboards`.
    temp10-suppliername = `Oxynum`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 14.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Internet Keyboard`.
    temp10-category = `Keyboards`.
    temp10-suppliername = `Oxynum`.
    temp10-status = `Out of Stock`.
    temp10-availablestate = `Error`.
    temp10-price = 16.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Media Keyboard`.
    temp10-category = `Keyboards`.
    temp10-suppliername = `Oxynum`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 26.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Mousepad`.
    temp10-category = `Mousepads`.
    temp10-suppliername = `Oxynum`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = `6.99`.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Ergo Mousepad`.
    temp10-category = `Mousepads`.
    temp10-suppliername = `Oxynum`.
    temp10-status = `Out of Stock`.
    temp10-availablestate = `Error`.
    temp10-price = `8.99`.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Designer Mousepad`.
    temp10-category = `Mousepads`.
    temp10-suppliername = `Fasttech`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = `12.99`.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Universal card reader`.
    temp10-category = `Computer System Accessories`.
    temp10-suppliername = `Fasttech`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 14.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Proctra X`.
    temp10-category = `Graphic Cards`.
    temp10-suppliername = `Ultrasonic United`.
    temp10-status = `Out of Stock`.
    temp10-availablestate = `Error`.
    temp10-price = `70.9`.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Gladiator MX`.
    temp10-category = `Graphic Cards`.
    temp10-suppliername = `Ultrasonic United`.
    temp10-status = `Discontinued`.
    temp10-availablestate = `Error`.
    temp10-price = `81.7`.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Hurricane GX`.
    temp10-category = `Graphic Cards`.
    temp10-suppliername = `Ultrasonic United`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = `101.2`.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Hurricane GX/LN`.
    temp10-category = `Graphic Cards`.
    temp10-suppliername = `Smartcards`.
    temp10-status = `Out of Stock`.
    temp10-availablestate = `Error`.
    temp10-price = `139.99`.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Photo Scan`.
    temp10-category = `Scanners`.
    temp10-suppliername = `Printer for All`.
    temp10-status = `Out of Stock`.
    temp10-availablestate = `Error`.
    temp10-price = 129.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Power Scan`.
    temp10-category = `Scanners`.
    temp10-suppliername = `Printer for All`.
    temp10-status = `Out of Stock`.
    temp10-availablestate = `Error`.
    temp10-price = 89.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Jet Scan Professional`.
    temp10-category = `Scanners`.
    temp10-suppliername = `Printer for All`.
    temp10-status = `Out of Stock`.
    temp10-availablestate = `Error`.
    temp10-price = 169.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Jet Scan Professional`.
    temp10-category = `Scanners`.
    temp10-suppliername = `Printer for All`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 189.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Copymaster`.
    temp10-category = `Multifunction Printers`.
    temp10-suppliername = `Alpha Printers`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 1499.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Surround Sound`.
    temp10-category = `Speakers`.
    temp10-suppliername = `Speaker Experts`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 39.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Blaster Extreme`.
    temp10-category = `Speakers`.
    temp10-suppliername = `Speaker Experts`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 26.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Sound Booster`.
    temp10-category = `Speakers`.
    temp10-suppliername = `Speaker Experts`.
    temp10-status = `Discontinued`.
    temp10-availablestate = `Error`.
    temp10-price = 45.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Lovely Sound 5.1 Wireless`.
    temp10-category = `Accessories`.
    temp10-suppliername = `Fasttech`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 49.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Lovely Sound 5.1`.
    temp10-category = `Accessories`.
    temp10-suppliername = `Fasttech`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 39.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Lovely Sound Stereo`.
    temp10-category = `Accessories`.
    temp10-suppliername = `Fasttech`.
    temp10-status = `Out of Stock`.
    temp10-availablestate = `Error`.
    temp10-price = 29.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Smart Office`.
    temp10-category = `Software`.
    temp10-suppliername = `Technocom`.
    temp10-status = `Out of Stock`.
    temp10-availablestate = `Error`.
    temp10-price = `89.9`.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Smart Design`.
    temp10-category = `Software`.
    temp10-suppliername = `Technocom`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = `79.9`.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Smart Network`.
    temp10-category = `Software`.
    temp10-suppliername = `Technocom`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 69.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Smart Multimedia`.
    temp10-category = `Software`.
    temp10-suppliername = `Technocom`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 77.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Smart Games`.
    temp10-category = `Software`.
    temp10-suppliername = `Technocom`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 55.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Smart Internet Antivirus`.
    temp10-category = `Software`.
    temp10-suppliername = `Brainsoft`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 29.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Smart Firewall`.
    temp10-category = `Software`.
    temp10-suppliername = `Brainsoft`.
    temp10-status = `Discontinued`.
    temp10-availablestate = `Error`.
    temp10-price = 34.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Smart Money`.
    temp10-category = `Software`.
    temp10-suppliername = `Brainsoft`.
    temp10-status = `Out of Stock`.
    temp10-availablestate = `Error`.
    temp10-price = `29.9`.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `PC Lock`.
    temp10-category = `Computer System Accessories`.
    temp10-suppliername = `Red Point Stores`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = `8.9`.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Notebook Lock`.
    temp10-category = `Computer System Accessories`.
    temp10-suppliername = `Red Point Stores`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = `6.9`.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Web cam reality`.
    temp10-category = `Computer System Accessories`.
    temp10-suppliername = `Red Point Stores`.
    temp10-status = `Out of Stock`.
    temp10-availablestate = `Error`.
    temp10-price = 39.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Screen clean`.
    temp10-category = `Computer System Accessories`.
    temp10-suppliername = `Red Point Stores`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = `2.3`.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Fabric bag professional`.
    temp10-category = `Computer System Accessories`.
    temp10-suppliername = `Red Point Stores`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 31.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Wireless DSL Router`.
    temp10-category = `Telecommunications`.
    temp10-suppliername = `Red Point Stores`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 49.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Wireless DSL Router / Repeater`.
    temp10-category = `Telecommunications`.
    temp10-suppliername = `Red Point Stores`.
    temp10-status = `Out of Stock`.
    temp10-availablestate = `Error`.
    temp10-price = 59.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Wireless DSL Router / Repeater and Print Server`.
    temp10-category = `Telecommunications`.
    temp10-suppliername = `Technocom`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 69.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `USB Stick`.
    temp10-category = `Computer System Accessories`.
    temp10-suppliername = `Technocom`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 35.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Travel Adapter`.
    temp10-category = `Accessories`.
    temp10-suppliername = `Titanium`.
    temp10-status = `Discontinued`.
    temp10-availablestate = `Error`.
    temp10-price = 79.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Cordless Bluetooth Keyboard, english international`.
    temp10-category = `Keyboards`.
    temp10-suppliername = `Technocom`.
    temp10-status = `Out of Stock`.
    temp10-availablestate = `Error`.
    temp10-price = 29.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Flat XXL`.
    temp10-category = `Flat Screen Monitors`.
    temp10-suppliername = `Technocom`.
    temp10-status = `Discontinued`.
    temp10-availablestate = `Error`.
    temp10-price = 1430.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Pocket Mouse`.
    temp10-category = `Mice`.
    temp10-suppliername = `Technocom`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 23.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `PC Power Station`.
    temp10-category = `PCs`.
    temp10-suppliername = `Technocom`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 2399.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Astro Laptop 1516`.
    temp10-category = `Laptops`.
    temp10-suppliername = `Ultrasonic United`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 989.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Astro Phone 6`.
    temp10-category = `Smartphones and Tablets`.
    temp10-suppliername = `Ultrasonic United`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 649.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Benda Laptop 1408`.
    temp10-category = `Laptops`.
    temp10-suppliername = `Ultrasonic United`.
    temp10-status = `Discontinued`.
    temp10-availablestate = `Error`.
    temp10-price = 976.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Bending Screen 21HD`.
    temp10-category = `Flat Screens`.
    temp10-suppliername = `Ultrasonic United`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 250.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Broad Screen 22HD`.
    temp10-category = `Flat Screens`.
    temp10-suppliername = `Ultrasonic United`.
    temp10-status = `Discontinued`.
    temp10-availablestate = `Error`.
    temp10-price = 270.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Cerdik Phone 7`.
    temp10-category = `Smartphones and Tablets`.
    temp10-suppliername = `Ultrasonic United`.
    temp10-status = `Discontinued`.
    temp10-availablestate = `Error`.
    temp10-price = 549.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Cepat Tablet 10.5`.
    temp10-category = `Smartphones and Tablets`.
    temp10-suppliername = `Ultrasonic United`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 549.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Cepat Tablet 8`.
    temp10-category = `Smartphones and Tablets`.
    temp10-suppliername = `Ultrasonic United`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 529.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Server Basic`.
    temp10-category = `Servers`.
    temp10-suppliername = `Technocom`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 5000.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Server Professional`.
    temp10-category = `Servers`.
    temp10-suppliername = `Technocom`.
    temp10-status = `Out of Stock`.
    temp10-availablestate = `Error`.
    temp10-price = 15000.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Server Power Pro`.
    temp10-category = `Servers`.
    temp10-suppliername = `Technocom`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 25000.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Family PC Basic`.
    temp10-category = `Desktop Computers`.
    temp10-suppliername = `Titanium`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 600.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Family PC Pro`.
    temp10-category = `Desktop Computers`.
    temp10-suppliername = `Titanium`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 900.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Gaming Monster`.
    temp10-category = `Desktop Computers`.
    temp10-suppliername = `Titanium`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 1200.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Gaming Monster Pro`.
    temp10-category = `Desktop Computers`.
    temp10-suppliername = `Titanium`.
    temp10-status = `Discontinued`.
    temp10-availablestate = `Error`.
    temp10-price = 1700.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `7" Widescreen Portable DVD Player w MP3`.
    temp10-category = `Accessories`.
    temp10-suppliername = `Titanium`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = `249.99`.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `10" Portable DVD player`.
    temp10-category = `Accessories`.
    temp10-suppliername = `Titanium`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = `449.99`.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Portable DVD Player with 9" LCD Monitor`.
    temp10-category = `Accessories`.
    temp10-suppliername = `Technocom`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = `853.99`.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `CD/DVD case: 264 sleeves`.
    temp10-category = `Accessories`.
    temp10-suppliername = `Titanium`.
    temp10-status = `Discontinued`.
    temp10-availablestate = `Error`.
    temp10-price = `44.99`.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Audio/Video Cable Kit - 4m`.
    temp10-category = `Accessories`.
    temp10-suppliername = `Titanium`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = `29.99`.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Removable CD/DVD Laser Labels`.
    temp10-category = `Accessories`.
    temp10-suppliername = `Titanium`.
    temp10-status = `Discontinued`.
    temp10-availablestate = `Error`.
    temp10-price = `8.99`.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Beam Breaker B-1`.
    temp10-category = `Accessories`.
    temp10-suppliername = `Titanium`.
    temp10-status = `Out of Stock`.
    temp10-availablestate = `Error`.
    temp10-price = 469.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Beam Breaker B-2`.
    temp10-category = `Accessories`.
    temp10-suppliername = `Technocom`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 679.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Beam Breaker B-3`.
    temp10-category = `Accessories`.
    temp10-suppliername = `Technocom`.
    temp10-status = `Out of Stock`.
    temp10-availablestate = `Error`.
    temp10-price = 889.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Play Movie`.
    temp10-category = `Accessories`.
    temp10-suppliername = `Fasttech`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 130.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Record Movie`.
    temp10-category = `Accessories`.
    temp10-suppliername = `Fasttech`.
    temp10-status = `Discontinued`.
    temp10-availablestate = `Error`.
    temp10-price = 288.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `ITelo MusicStick`.
    temp10-category = `Accessories`.
    temp10-suppliername = `Fasttech`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 45.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `ITelo Jog-Mate`.
    temp10-category = `Accessories`.
    temp10-suppliername = `Fasttech`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 63.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Power Pro Player 40`.
    temp10-category = `Accessories`.
    temp10-suppliername = `Fasttech`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 167.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Power Pro Player 80`.
    temp10-category = `Accessories`.
    temp10-suppliername = `Fasttech`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 299.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Flat Watch HD32`.
    temp10-category = `Flat Screen TVs`.
    temp10-suppliername = `Very Best Screens`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 1459.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Flat Watch HD37`.
    temp10-category = `Flat Screen TVs`.
    temp10-suppliername = `Very Best Screens`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 1199.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Flat Watch HD41`.
    temp10-category = `Flat Screen TVs`.
    temp10-suppliername = `Very Best Screens`.
    temp10-status = `Discontinued`.
    temp10-availablestate = `Error`.
    temp10-price = 899.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Copperberry`.
    temp10-category = `Accessories`.
    temp10-suppliername = `Fasttech`.
    temp10-status = `Discontinued`.
    temp10-availablestate = `Error`.
    temp10-price = 549.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Silverberry`.
    temp10-category = `Accessories`.
    temp10-suppliername = `Fasttech`.
    temp10-status = `Discontinued`.
    temp10-availablestate = `Error`.
    temp10-price = 549.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Goldberry`.
    temp10-category = `Accessories`.
    temp10-suppliername = `Fasttech`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 549.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Platinberry`.
    temp10-category = `Accessories`.
    temp10-suppliername = `Fasttech`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 549.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `ITelO FlexTop I4000`.
    temp10-category = `Laptops`.
    temp10-suppliername = `Titanium`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 799.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `ITelO FlexTop I6300c`.
    temp10-category = `Laptops`.
    temp10-suppliername = `Titanium`.
    temp10-status = `Discontinued`.
    temp10-availablestate = `Error`.
    temp10-price = 799.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `ITelO FlexTop I9100`.
    temp10-category = `Laptops`.
    temp10-suppliername = `Titanium`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 1199.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `ITelO FlexTop I9800`.
    temp10-category = `Laptops`.
    temp10-suppliername = `Titanium`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 1388.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Smartphone Leather Case`.
    temp10-category = `Accessories`.
    temp10-suppliername = `Ultrasonic United`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 25.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Smartphone Alpha`.
    temp10-category = `Smartphones and Tablets`.
    temp10-suppliername = `Ultrasonic United`.
    temp10-status = `Out of Stock`.
    temp10-availablestate = `Error`.
    temp10-price = 599.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Mini Tablet`.
    temp10-category = `Smartphones and Tablets`.
    temp10-suppliername = `Ultrasonic United`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 833.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Camcorder View`.
    temp10-category = `Accessories`.
    temp10-suppliername = `Ultrasonic United`.
    temp10-status = `Out of Stock`.
    temp10-availablestate = `Error`.
    temp10-price = 1388.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Tablet Pouch`.
    temp10-category = `Accessories`.
    temp10-suppliername = `Titanium`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 20.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Tablet Pouch`.
    temp10-category = `Accessories`.
    temp10-suppliername = `Titanium`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 20.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `e-Book Reader ReadMe`.
    temp10-category = `Smartphones and Tablets`.
    temp10-suppliername = `Titanium`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 33.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Smartphone Beta`.
    temp10-category = `Smartphones and Tablets`.
    temp10-suppliername = `Titanium`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 30.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Maxi Tablet`.
    temp10-category = `Tablets`.
    temp10-suppliername = `Titanium`.
    temp10-status = `Available`.
    temp10-availablestate = `Success`.
    temp10-price = 749.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Flyer`.
    temp10-category = `Accessories`.
    temp10-suppliername = `Titanium`.
    temp10-status = `Out of Stock`.
    temp10-availablestate = `Error`.
    temp10-price = 0.
    temp10-currencycode = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    result = temp9.

  ENDMETHOD.


  METHOD model_init.

    " /ProductCollectionStats/Filters of the same mock - the two facet lists
    " (Category, SupplierName) with their values and counts, verbatim
    DATA temp11 LIKE t_filters.
    DATA temp12 LIKE LINE OF temp11.
    DATA temp1 TYPE z2ui5_cl_smpc_app_352=>ty_t_value.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp3 TYPE z2ui5_cl_smpc_app_352=>ty_t_value.
    DATA temp4 LIKE LINE OF temp3.
    CLEAR temp11.
    
    temp12-type = `Category`.
    
    CLEAR temp1.
    
    temp2-text = `Accessories`.
    temp2-data = 34.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `Desktop Computers`.
    temp2-data = 7.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `Flat Screens`.
    temp2-data = 2.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `Keyboards`.
    temp2-data = 4.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `Laptops`.
    temp2-data = 11.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `Printers`.
    temp2-data = 9.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `Smartphones and Tablets`.
    temp2-data = 9.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `Mice`.
    temp2-data = 7.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `Computer System Accessories`.
    temp2-data = 8.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `Graphics Card`.
    temp2-data = 4.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `Scanners`.
    temp2-data = 4.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `Speakers`.
    temp2-data = 3.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `Software`.
    temp2-data = 8.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `Telekommunikation`.
    temp2-data = 3.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `Servers`.
    temp2-data = 3.
    INSERT temp2 INTO TABLE temp1.
    temp2-text = `Flat Screen TVs`.
    temp2-data = 3.
    INSERT temp2 INTO TABLE temp1.
    temp12-values = temp1.
    INSERT temp12 INTO TABLE temp11.
    temp12-type = `SupplierName`.
    
    CLEAR temp3.
    
    temp4-text = `Titanium`.
    temp4-data = 21.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Technocom`.
    temp4-data = 22.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Red Point Stores`.
    temp4-data = 7.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Very Best Screens`.
    temp4-data = 14.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Smartcards`.
    temp4-data = 2.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Alpha Printers`.
    temp4-data = 5.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Printer for All`.
    temp4-data = 8.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Oxynum`.
    temp4-data = 8.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Fasttech`.
    temp4-data = 15.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Ultrasonic United`.
    temp4-data = 15.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Speaker Experts`.
    temp4-data = 3.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Brainsoft`.
    temp4-data = 3.
    INSERT temp4 INTO TABLE temp3.
    temp12-values = temp3.
    INSERT temp12 INTO TABLE temp11.
    t_filters = temp11.

    t_products = catalog( ).

  ENDMETHOD.

ENDCLASS.
