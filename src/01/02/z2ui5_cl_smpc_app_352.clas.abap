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
      ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY,
      BEGIN OF ty_s_value,
        text     TYPE string,
        data     TYPE i,
        selected TYPE abap_bool,
      END OF ty_s_value,
      ty_t_value TYPE STANDARD TABLE OF ty_s_value WITH EMPTY KEY,
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
    DATA t_filters TYPE STANDARD TABLE OF ty_s_filter WITH EMPTY KEY.

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
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

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

    CASE client->get_event( ).

      WHEN `SEARCH`.
        " handleTxtFilter: Name OR Status contains the query
        filter_apply( ).

      WHEN `LIST_CLOSE`.
        " handleListClose: the two-way bound selected flags are already back
        filter_apply( ).

      WHEN `FACET_RESET`.
        " handleFacetFilterReset: clear every facet selection
        LOOP AT t_filters REFERENCE INTO DATA(lr_filter).
          LOOP AT lr_filter->values REFERENCE INTO DATA(lr_value).
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

    " the controller's _filter( ): the text filter and the facet filter are
    " ANDed; inside a facet list the selected values are ORed, and only a list
    " with a selection takes part - exactly the two nested Filter groups
    t_products = catalog( ).

    IF filter_value IS NOT INITIAL.
      DATA(lv_query) = to_upper( filter_value ).
      LOOP AT t_products INTO DATA(ls_row).
        IF to_upper( ls_row-name ) NS lv_query AND to_upper( ls_row-status ) NS lv_query.
          DELETE t_products INDEX sy-tabix.
        ENDIF.
      ENDLOOP.
    ENDIF.

    LOOP AT t_filters INTO DATA(ls_filter).
      DATA(lt_selected) = VALUE string_table( FOR value IN ls_filter-values
                                              WHERE ( selected = abap_true )
                                              ( value-text ) ).
      IF lt_selected IS INITIAL.
        CONTINUE.
      ENDIF.
      LOOP AT t_products INTO DATA(ls_product).
        DATA(lv_value) = COND string( WHEN ls_filter-type = `Category`
                                      THEN ls_product-category
                                      ELSE ls_product-suppliername ).
        IF NOT line_exists( lt_selected[ table_line = lv_value ] ).
          DELETE t_products INDEX sy-tabix.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.


  METHOD catalog.

    " the shared 123-row demo ProductCollection (sap/ui/demo/mock/products.json)
    " with the five columns the sample binds. The controller's
    " formatAvailableToObjectState is precomputed into AVAILABLESTATE, since
    " business logic belongs in the backend
    result = VALUE #(
      ( name = `Notebook Basic 15` category = `Laptops` suppliername = `Very Best Screens` status = `Available` availablestate = `Success` price = 956 currencycode = `EUR` )
      ( name = `Notebook Basic 17` category = `Laptops` suppliername = `Very Best Screens` status = `Available` availablestate = `Success` price = 1249 currencycode = `EUR` )
      ( name = `Notebook Basic 18` category = `Laptops` suppliername = `Very Best Screens` status = `Available` availablestate = `Success` price = 1570 currencycode = `EUR` )
      ( name = `Notebook Basic 19` category = `Laptops` suppliername = `Smartcards` status = `Out of Stock` availablestate = `Error` price = 1650 currencycode = `EUR` )
      ( name = `ITelO Vault` category = `Accessories` suppliername = `Technocom` status = `Out of Stock` availablestate = `Error` price = 299 currencycode = `EUR` )
      ( name = `Notebook Professional 15` category = `Accessories` suppliername = `Very Best Screens` status = `Out of Stock` availablestate = `Error` price = 1999 currencycode = `EUR` )
      ( name = `Notebook Professional 17` category = `Laptops` suppliername = `Very Best Screens` status = `Out of Stock` availablestate = `Error` price = 2299 currencycode = `EUR` )
      ( name = `ITelO Vault Net` category = `Accessories` suppliername = `Technocom` status = `Discontinued` availablestate = `Error` price = 459 currencycode = `EUR` )
      ( name = `ITelO Vault SAT` category = `Accessories` suppliername = `Technocom` status = `Available` availablestate = `Success` price = 149 currencycode = `EUR` )
      ( name = `Comfort Easy` category = `Accessories` suppliername = `Technocom` status = `Out of Stock` availablestate = `Error` price = 1679 currencycode = `EUR` )
      ( name = `Comfort Senior` category = `Accessories` suppliername = `Technocom` status = `Available` availablestate = `Success` price = 512 currencycode = `EUR` )
      ( name = `Ergo Screen E-I` category = `Flat Screen Monitors` suppliername = `Very Best Screens` status = `Available` availablestate = `Success` price = 230 currencycode = `EUR` )
      ( name = `Ergo Screen E-II` category = `Flat Screen Monitors` suppliername = `Very Best Screens` status = `Available` availablestate = `Success` price = 285 currencycode = `EUR` )
      ( name = `Ergo Screen E-III` category = `Flat Screen Monitors` suppliername = `Very Best Screens` status = `Out of Stock` availablestate = `Error` price = 345 currencycode = `EUR` )
      ( name = `Flat Basic` category = `Flat Screen Monitors` suppliername = `Very Best Screens` status = `Available` availablestate = `Success` price = 399 currencycode = `EUR` )
      ( name = `Flat Future` category = `Flat Screen Monitors` suppliername = `Very Best Screens` status = `Available` availablestate = `Success` price = 430 currencycode = `EUR` )
      ( name = `Flat XL` category = `Flat Screen Monitors` suppliername = `Very Best Screens` status = `Available` availablestate = `Success` price = 1230 currencycode = `EUR` )
      ( name = `Laser Professional Eco` category = `Printers` suppliername = `Alpha Printers` status = `Available` availablestate = `Success` price = 830 currencycode = `EUR` )
      ( name = `Laser Basic` category = `Printers` suppliername = `Alpha Printers` status = `Available` availablestate = `Success` price = 490 currencycode = `EUR` )
      ( name = `Laser Allround` category = `Printers` suppliername = `Alpha Printers` status = `Available` availablestate = `Success` price = 349 currencycode = `EUR` )
      ( name = `Ultra Jet Super Color` category = `Printers` suppliername = `Alpha Printers` status = `Discontinued` availablestate = `Error` price = 139 currencycode = `EUR` )
      ( name = `Ultra Jet Mobile` category = `Printers` suppliername = `Printer for All` status = `Discontinued` availablestate = `Error` price = 99 currencycode = `EUR` )
      ( name = `Ultra Jet Super Highspeed` category = `Printers` suppliername = `Printer for All` status = `Available` availablestate = `Success` price = 170 currencycode = `EUR` )
      ( name = `Multi Print` category = `Multifunction Printers` suppliername = `Printer for All` status = `Available` availablestate = `Success` price = 99 currencycode = `EUR` )
      ( name = `Multi Color` category = `Multifunction Printers` suppliername = `Printer for All` status = `Available` availablestate = `Success` price = 119 currencycode = `EUR` )
      ( name = `Cordless Mouse` category = `Mice` suppliername = `Oxynum` status = `Available` availablestate = `Success` price = 9 currencycode = `EUR` )
      ( name = `Speed Mouse` category = `Mice` suppliername = `Oxynum` status = `Available` availablestate = `Success` price = 7 currencycode = `EUR` )
      ( name = `Track Mouse` category = `Mice` suppliername = `Oxynum` status = `Discontinued` availablestate = `Error` price = 11 currencycode = `EUR` )
      ( name = `Ergonomic Keyboard` category = `Keyboards` suppliername = `Oxynum` status = `Available` availablestate = `Success` price = 14 currencycode = `EUR` )
      ( name = `Internet Keyboard` category = `Keyboards` suppliername = `Oxynum` status = `Out of Stock` availablestate = `Error` price = 16 currencycode = `EUR` )
      ( name = `Media Keyboard` category = `Keyboards` suppliername = `Oxynum` status = `Available` availablestate = `Success` price = 26 currencycode = `EUR` )
      ( name = `Mousepad` category = `Mousepads` suppliername = `Oxynum` status = `Available` availablestate = `Success` price = `6.99` currencycode = `EUR` )
      ( name = `Ergo Mousepad` category = `Mousepads` suppliername = `Oxynum` status = `Out of Stock` availablestate = `Error` price = `8.99` currencycode = `EUR` )
      ( name = `Designer Mousepad` category = `Mousepads` suppliername = `Fasttech` status = `Available` availablestate = `Success` price = `12.99` currencycode = `EUR` )
      ( name = `Universal card reader` category = `Computer System Accessories` suppliername = `Fasttech` status = `Available` availablestate = `Success` price = 14 currencycode = `EUR` )
      ( name = `Proctra X` category = `Graphic Cards` suppliername = `Ultrasonic United` status = `Out of Stock` availablestate = `Error` price = `70.9` currencycode = `EUR` )
      ( name = `Gladiator MX` category = `Graphic Cards` suppliername = `Ultrasonic United` status = `Discontinued` availablestate = `Error` price = `81.7` currencycode = `EUR` )
      ( name = `Hurricane GX` category = `Graphic Cards` suppliername = `Ultrasonic United` status = `Available` availablestate = `Success` price = `101.2` currencycode = `EUR` )
      ( name = `Hurricane GX/LN` category = `Graphic Cards` suppliername = `Smartcards` status = `Out of Stock` availablestate = `Error` price = `139.99` currencycode = `EUR` )
      ( name = `Photo Scan` category = `Scanners` suppliername = `Printer for All` status = `Out of Stock` availablestate = `Error` price = 129 currencycode = `EUR` )
      ( name = `Power Scan` category = `Scanners` suppliername = `Printer for All` status = `Out of Stock` availablestate = `Error` price = 89 currencycode = `EUR` )
      ( name = `Jet Scan Professional` category = `Scanners` suppliername = `Printer for All` status = `Out of Stock` availablestate = `Error` price = 169 currencycode = `EUR` )
      ( name = `Jet Scan Professional` category = `Scanners` suppliername = `Printer for All` status = `Available` availablestate = `Success` price = 189 currencycode = `EUR` )
      ( name = `Copymaster` category = `Multifunction Printers` suppliername = `Alpha Printers` status = `Available` availablestate = `Success` price = 1499 currencycode = `EUR` )
      ( name = `Surround Sound` category = `Speakers` suppliername = `Speaker Experts` status = `Available` availablestate = `Success` price = 39 currencycode = `EUR` )
      ( name = `Blaster Extreme` category = `Speakers` suppliername = `Speaker Experts` status = `Available` availablestate = `Success` price = 26 currencycode = `EUR` )
      ( name = `Sound Booster` category = `Speakers` suppliername = `Speaker Experts` status = `Discontinued` availablestate = `Error` price = 45 currencycode = `EUR` )
      ( name = `Lovely Sound 5.1 Wireless` category = `Accessories` suppliername = `Fasttech` status = `Available` availablestate = `Success` price = 49 currencycode = `EUR` )
      ( name = `Lovely Sound 5.1` category = `Accessories` suppliername = `Fasttech` status = `Available` availablestate = `Success` price = 39 currencycode = `EUR` )
      ( name = `Lovely Sound Stereo` category = `Accessories` suppliername = `Fasttech` status = `Out of Stock` availablestate = `Error` price = 29 currencycode = `EUR` )
      ( name = `Smart Office` category = `Software` suppliername = `Technocom` status = `Out of Stock` availablestate = `Error` price = `89.9` currencycode = `EUR` )
      ( name = `Smart Design` category = `Software` suppliername = `Technocom` status = `Available` availablestate = `Success` price = `79.9` currencycode = `EUR` )
      ( name = `Smart Network` category = `Software` suppliername = `Technocom` status = `Available` availablestate = `Success` price = 69 currencycode = `EUR` )
      ( name = `Smart Multimedia` category = `Software` suppliername = `Technocom` status = `Available` availablestate = `Success` price = 77 currencycode = `EUR` )
      ( name = `Smart Games` category = `Software` suppliername = `Technocom` status = `Available` availablestate = `Success` price = 55 currencycode = `EUR` )
      ( name = `Smart Internet Antivirus` category = `Software` suppliername = `Brainsoft` status = `Available` availablestate = `Success` price = 29 currencycode = `EUR` )
      ( name = `Smart Firewall` category = `Software` suppliername = `Brainsoft` status = `Discontinued` availablestate = `Error` price = 34 currencycode = `EUR` )
      ( name = `Smart Money` category = `Software` suppliername = `Brainsoft` status = `Out of Stock` availablestate = `Error` price = `29.9` currencycode = `EUR` )
      ( name = `PC Lock` category = `Computer System Accessories` suppliername = `Red Point Stores` status = `Available` availablestate = `Success` price = `8.9` currencycode = `EUR` )
      ( name = `Notebook Lock` category = `Computer System Accessories` suppliername = `Red Point Stores` status = `Available` availablestate = `Success` price = `6.9` currencycode = `EUR` )
      ( name = `Web cam reality` category = `Computer System Accessories` suppliername = `Red Point Stores` status = `Out of Stock` availablestate = `Error` price = 39 currencycode = `EUR` )
      ( name = `Screen clean` category = `Computer System Accessories` suppliername = `Red Point Stores` status = `Available` availablestate = `Success` price = `2.3` currencycode = `EUR` )
      ( name = `Fabric bag professional` category = `Computer System Accessories` suppliername = `Red Point Stores` status = `Available` availablestate = `Success` price = 31 currencycode = `EUR` )
      ( name = `Wireless DSL Router` category = `Telecommunications` suppliername = `Red Point Stores` status = `Available` availablestate = `Success` price = 49 currencycode = `EUR` )
      ( name = `Wireless DSL Router / Repeater` category = `Telecommunications` suppliername = `Red Point Stores` status = `Out of Stock` availablestate = `Error` price = 59 currencycode = `EUR` )
      ( name = `Wireless DSL Router / Repeater and Print Server` category = `Telecommunications` suppliername = `Technocom` status = `Available` availablestate = `Success` price = 69 currencycode = `EUR` )
      ( name = `USB Stick` category = `Computer System Accessories` suppliername = `Technocom` status = `Available` availablestate = `Success` price = 35 currencycode = `EUR` )
      ( name = `Travel Adapter` category = `Accessories` suppliername = `Titanium` status = `Discontinued` availablestate = `Error` price = 79 currencycode = `EUR` )
      ( name = `Cordless Bluetooth Keyboard, english international` category = `Keyboards` suppliername = `Technocom` status = `Out of Stock` availablestate = `Error` price = 29 currencycode = `EUR` )
      ( name = `Flat XXL` category = `Flat Screen Monitors` suppliername = `Technocom` status = `Discontinued` availablestate = `Error` price = 1430 currencycode = `EUR` )
      ( name = `Pocket Mouse` category = `Mice` suppliername = `Technocom` status = `Available` availablestate = `Success` price = 23 currencycode = `EUR` )
      ( name = `PC Power Station` category = `PCs` suppliername = `Technocom` status = `Available` availablestate = `Success` price = 2399 currencycode = `EUR` )
      ( name = `Astro Laptop 1516` category = `Laptops` suppliername = `Ultrasonic United` status = `Available` availablestate = `Success` price = 989 currencycode = `EUR` )
      ( name = `Astro Phone 6` category = `Smartphones and Tablets` suppliername = `Ultrasonic United` status = `Available` availablestate = `Success` price = 649 currencycode = `EUR` )
      ( name = `Benda Laptop 1408` category = `Laptops` suppliername = `Ultrasonic United` status = `Discontinued` availablestate = `Error` price = 976 currencycode = `EUR` )
      ( name = `Bending Screen 21HD` category = `Flat Screens` suppliername = `Ultrasonic United` status = `Available` availablestate = `Success` price = 250 currencycode = `EUR` )
      ( name = `Broad Screen 22HD` category = `Flat Screens` suppliername = `Ultrasonic United` status = `Discontinued` availablestate = `Error` price = 270 currencycode = `EUR` )
      ( name = `Cerdik Phone 7` category = `Smartphones and Tablets` suppliername = `Ultrasonic United` status = `Discontinued` availablestate = `Error` price = 549 currencycode = `EUR` )
      ( name = `Cepat Tablet 10.5` category = `Smartphones and Tablets` suppliername = `Ultrasonic United` status = `Available` availablestate = `Success` price = 549 currencycode = `EUR` )
      ( name = `Cepat Tablet 8` category = `Smartphones and Tablets` suppliername = `Ultrasonic United` status = `Available` availablestate = `Success` price = 529 currencycode = `EUR` )
      ( name = `Server Basic` category = `Servers` suppliername = `Technocom` status = `Available` availablestate = `Success` price = 5000 currencycode = `EUR` )
      ( name = `Server Professional` category = `Servers` suppliername = `Technocom` status = `Out of Stock` availablestate = `Error` price = 15000 currencycode = `EUR` )
      ( name = `Server Power Pro` category = `Servers` suppliername = `Technocom` status = `Available` availablestate = `Success` price = 25000 currencycode = `EUR` )
      ( name = `Family PC Basic` category = `Desktop Computers` suppliername = `Titanium` status = `Available` availablestate = `Success` price = 600 currencycode = `EUR` )
      ( name = `Family PC Pro` category = `Desktop Computers` suppliername = `Titanium` status = `Available` availablestate = `Success` price = 900 currencycode = `EUR` )
      ( name = `Gaming Monster` category = `Desktop Computers` suppliername = `Titanium` status = `Available` availablestate = `Success` price = 1200 currencycode = `EUR` )
      ( name = `Gaming Monster Pro` category = `Desktop Computers` suppliername = `Titanium` status = `Discontinued` availablestate = `Error` price = 1700 currencycode = `EUR` )
      ( name = `7" Widescreen Portable DVD Player w MP3` category = `Accessories` suppliername = `Titanium` status = `Available` availablestate = `Success` price = `249.99` currencycode = `EUR` )
      ( name = `10" Portable DVD player` category = `Accessories` suppliername = `Titanium` status = `Available` availablestate = `Success` price = `449.99` currencycode = `EUR` )
      ( name = `Portable DVD Player with 9" LCD Monitor` category = `Accessories` suppliername = `Technocom` status = `Available` availablestate = `Success` price = `853.99` currencycode = `EUR` )
      ( name = `CD/DVD case: 264 sleeves` category = `Accessories` suppliername = `Titanium` status = `Discontinued` availablestate = `Error` price = `44.99` currencycode = `EUR` )
      ( name = `Audio/Video Cable Kit - 4m` category = `Accessories` suppliername = `Titanium` status = `Available` availablestate = `Success` price = `29.99` currencycode = `EUR` )
      ( name = `Removable CD/DVD Laser Labels` category = `Accessories` suppliername = `Titanium` status = `Discontinued` availablestate = `Error` price = `8.99` currencycode = `EUR` )
      ( name = `Beam Breaker B-1` category = `Accessories` suppliername = `Titanium` status = `Out of Stock` availablestate = `Error` price = 469 currencycode = `EUR` )
      ( name = `Beam Breaker B-2` category = `Accessories` suppliername = `Technocom` status = `Available` availablestate = `Success` price = 679 currencycode = `EUR` )
      ( name = `Beam Breaker B-3` category = `Accessories` suppliername = `Technocom` status = `Out of Stock` availablestate = `Error` price = 889 currencycode = `EUR` )
      ( name = `Play Movie` category = `Accessories` suppliername = `Fasttech` status = `Available` availablestate = `Success` price = 130 currencycode = `EUR` )
      ( name = `Record Movie` category = `Accessories` suppliername = `Fasttech` status = `Discontinued` availablestate = `Error` price = 288 currencycode = `EUR` )
      ( name = `ITelo MusicStick` category = `Accessories` suppliername = `Fasttech` status = `Available` availablestate = `Success` price = 45 currencycode = `EUR` )
      ( name = `ITelo Jog-Mate` category = `Accessories` suppliername = `Fasttech` status = `Available` availablestate = `Success` price = 63 currencycode = `EUR` )
      ( name = `Power Pro Player 40` category = `Accessories` suppliername = `Fasttech` status = `Available` availablestate = `Success` price = 167 currencycode = `EUR` )
      ( name = `Power Pro Player 80` category = `Accessories` suppliername = `Fasttech` status = `Available` availablestate = `Success` price = 299 currencycode = `EUR` )
      ( name = `Flat Watch HD32` category = `Flat Screen TVs` suppliername = `Very Best Screens` status = `Available` availablestate = `Success` price = 1459 currencycode = `EUR` )
      ( name = `Flat Watch HD37` category = `Flat Screen TVs` suppliername = `Very Best Screens` status = `Available` availablestate = `Success` price = 1199 currencycode = `EUR` )
      ( name = `Flat Watch HD41` category = `Flat Screen TVs` suppliername = `Very Best Screens` status = `Discontinued` availablestate = `Error` price = 899 currencycode = `EUR` )
      ( name = `Copperberry` category = `Accessories` suppliername = `Fasttech` status = `Discontinued` availablestate = `Error` price = 549 currencycode = `EUR` )
      ( name = `Silverberry` category = `Accessories` suppliername = `Fasttech` status = `Discontinued` availablestate = `Error` price = 549 currencycode = `EUR` )
      ( name = `Goldberry` category = `Accessories` suppliername = `Fasttech` status = `Available` availablestate = `Success` price = 549 currencycode = `EUR` )
      ( name = `Platinberry` category = `Accessories` suppliername = `Fasttech` status = `Available` availablestate = `Success` price = 549 currencycode = `EUR` )
      ( name = `ITelO FlexTop I4000` category = `Laptops` suppliername = `Titanium` status = `Available` availablestate = `Success` price = 799 currencycode = `EUR` )
      ( name = `ITelO FlexTop I6300c` category = `Laptops` suppliername = `Titanium` status = `Discontinued` availablestate = `Error` price = 799 currencycode = `EUR` )
      ( name = `ITelO FlexTop I9100` category = `Laptops` suppliername = `Titanium` status = `Available` availablestate = `Success` price = 1199 currencycode = `EUR` )
      ( name = `ITelO FlexTop I9800` category = `Laptops` suppliername = `Titanium` status = `Available` availablestate = `Success` price = 1388 currencycode = `EUR` )
      ( name = `Smartphone Leather Case` category = `Accessories` suppliername = `Ultrasonic United` status = `Available` availablestate = `Success` price = 25 currencycode = `EUR` )
      ( name = `Smartphone Alpha` category = `Smartphones and Tablets` suppliername = `Ultrasonic United` status = `Out of Stock` availablestate = `Error` price = 599 currencycode = `EUR` )
      ( name = `Mini Tablet` category = `Smartphones and Tablets` suppliername = `Ultrasonic United` status = `Available` availablestate = `Success` price = 833 currencycode = `EUR` )
      ( name = `Camcorder View` category = `Accessories` suppliername = `Ultrasonic United` status = `Out of Stock` availablestate = `Error` price = 1388 currencycode = `EUR` )
      ( name = `Tablet Pouch` category = `Accessories` suppliername = `Titanium` status = `Available` availablestate = `Success` price = 20 currencycode = `EUR` )
      ( name = `Tablet Pouch` category = `Accessories` suppliername = `Titanium` status = `Available` availablestate = `Success` price = 20 currencycode = `EUR` )
      ( name = `e-Book Reader ReadMe` category = `Smartphones and Tablets` suppliername = `Titanium` status = `Available` availablestate = `Success` price = 33 currencycode = `EUR` )
      ( name = `Smartphone Beta` category = `Smartphones and Tablets` suppliername = `Titanium` status = `Available` availablestate = `Success` price = 30 currencycode = `EUR` )
      ( name = `Maxi Tablet` category = `Tablets` suppliername = `Titanium` status = `Available` availablestate = `Success` price = 749 currencycode = `EUR` )
      ( name = `Flyer` category = `Accessories` suppliername = `Titanium` status = `Out of Stock` availablestate = `Error` price = 0 currencycode = `EUR` )
      ).

  ENDMETHOD.


  METHOD model_init.

    " /ProductCollectionStats/Filters of the same mock - the two facet lists
    " (Category, SupplierName) with their values and counts, verbatim
    t_filters = VALUE #(
      ( type = `Category` values = VALUE #(
          ( text = `Accessories` data = 34 )
          ( text = `Desktop Computers` data = 7 )
          ( text = `Flat Screens` data = 2 )
          ( text = `Keyboards` data = 4 )
          ( text = `Laptops` data = 11 )
          ( text = `Printers` data = 9 )
          ( text = `Smartphones and Tablets` data = 9 )
          ( text = `Mice` data = 7 )
          ( text = `Computer System Accessories` data = 8 )
          ( text = `Graphics Card` data = 4 )
          ( text = `Scanners` data = 4 )
          ( text = `Speakers` data = 3 )
          ( text = `Software` data = 8 )
          ( text = `Telekommunikation` data = 3 )
          ( text = `Servers` data = 3 )
          ( text = `Flat Screen TVs` data = 3 )
        ) )
      ( type = `SupplierName` values = VALUE #(
          ( text = `Titanium` data = 21 )
          ( text = `Technocom` data = 22 )
          ( text = `Red Point Stores` data = 7 )
          ( text = `Very Best Screens` data = 14 )
          ( text = `Smartcards` data = 2 )
          ( text = `Alpha Printers` data = 5 )
          ( text = `Printer for All` data = 8 )
          ( text = `Oxynum` data = 8 )
          ( text = `Fasttech` data = 15 )
          ( text = `Ultrasonic United` data = 15 )
          ( text = `Speaker Experts` data = 3 )
          ( text = `Brainsoft` data = 3 )
        ) )
      ).

    t_products = catalog( ).

  ENDMETHOD.

ENDCLASS.
