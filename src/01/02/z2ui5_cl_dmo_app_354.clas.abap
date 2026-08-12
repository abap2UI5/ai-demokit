CLASS z2ui5_cl_dmo_app_354 DEFINITION PUBLIC.

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
      ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

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


CLASS z2ui5_cl_dmo_app_354 IMPLEMENTATION.

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

    " the filtering demo. Every filter is applied in ABAP and the table binds
    " the filtered rows, so the controller's Filter objects and its
    " binding.filter( ) calls become one server-side selection.
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.ui.table`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:u`   v = `sap.ui.unified`
        )->a( n = `xmlns:m`   v = `sap.m`
        )->a( n = `height`    v = `100%`

        )->open( n = `Page` ns = `m`
            )->a( n = `showHeader`      v = `false`
            )->a( n = `enableScrolling` v = `false`
            )->a( n = `class`           v = `sapUiContentPadding`

            )->open( n = `content` ns = `m`
                )->open( `Table`
                    )->a( n = `id`               v = `table`
                    )->a( n = `selectionMode`    v = `MultiToggle`
                    )->a( n = `rows`             v = client->_bind( t_products )
                    )->a( n = `enableCellFilter` v = client->_bind( cell_filter_on )
                    )->a( n = `filter`           v = client->_event(
                                        val    = `COLUMN_FILTER`
                                        t_arg  = VALUE #( ( `${$parameters>/column}.getFilterProperty()` )
                                                          ( `${$parameters>/value}` ) )
                                        s_ctrl = VALUE #( check_prevent_default = abap_true ) )
                    )->a( n = `ariaLabelledBy`   v = `title`

                    )->open( `extension`
                        )->open( n = `OverflowToolbar` ns = `m`
                            )->a( n = `style` v = `Clear`

                            )->leaf( n = `Title` ns = `m`
                                )->a( n = `id`   v = `title`
                                )->a( n = `text` v = `Products`

                            )->leaf( n = `ToolbarSpacer` ns = `m`

                            )->leaf( n = `ToggleButton` ns = `m`
                                )->a( n = `icon`    v = `sap-icon://complete`
                                )->a( n = `tooltip` v = `Show available products only`
                                )->a( n = `pressed` v = client->_bind( availability_filter_on )
                                )->a( n = `press`   v = client->_event( `TOGGLE_AVAILABILITY` )

                            )->leaf( n = `ToggleButton` ns = `m`
                                )->a( n = `icon`    v = `sap-icon://grid`
                                )->a( n = `tooltip` v = `Enable / Disable Cell Filter Functionality`
                                )->a( n = `pressed` v = client->_bind( cell_filter_on )

                            )->leaf( n = `Button` ns = `m`
                                )->a( n = `icon`    v = `sap-icon://decline`
                                )->a( n = `tooltip` v = `Clear all filters`
                                )->a( n = `press`   v = client->_event( `CLEAR_FILTERS` )

                            )->leaf( n = `ToolbarSeparator` ns = `m`

                            )->leaf( n = `SearchField` ns = `m`
                                )->a( n = `placeholder` v = `Filter`
                                )->a( n = `value`       v = client->_bind( global_filter )
                                )->a( n = `search`      v = client->_event( `SEARCH` )
                                )->a( n = `width`       v = `15rem`

                        )->shut(
                    )->shut(
                    )->open( `columns`
                        )->open( `Column`
                            )->a( n = `width`          v = `11rem`
                            )->a( n = `filterProperty` v = `NAME`

                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text` v = `Product Name`

                            )->open( `template`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{NAME}`
                                    )->a( n = `wrapping` v = `false`

                            )->shut(
                        )->shut(
                        )->open( `Column`
                            )->a( n = `width`                 v = `11rem`
                            )->a( n = `filterProperty`        v = `CATEGORY`
                            )->a( n = `defaultFilterOperator` v = `StartsWith`

                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text` v = `Category`

                            )->open( `template`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{CATEGORY}`
                                    )->a( n = `wrapping` v = `false`

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
                            )->a( n = `id`                    v = `availability`
                            )->a( n = `width`                 v = `9rem`
                            )->a( n = `filterProperty`        v = `AVAILABLE`
                            )->a( n = `showFilterMenuEntry`   v = `false`
                            )->a( n = `defaultFilterOperator` v = `EQ`
                            )->a( n = `filterType`            v = `sap.ui.model.type.Boolean`

                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text` v = `Status`

                            )->open( `template`
                                )->leaf( n = `ObjectStatus` ns = `m`
                                    )->a( n = `text`  v = `{STATUS}`
                                    )->a( n = `state` v = `{AVAILABLESTATE}`

                            )->shut(
                        )->shut(
                        )->open( `Column`
                            )->a( n = `id`             v = `price`
                            )->a( n = `width`          v = `9rem`
                            )->a( n = `filterProperty` v = `PRICE`

                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text` v = `Price`

                            )->open( `template`
                                )->leaf( n = `Currency` ns = `u`
                                    )->a( n = `value`    v = `{PRICE}`
                                    )->a( n = `currency` v = `{CURRENCYCODE}`

                            )->shut(
                        )->shut(
                        )->open( `Column`
                            )->a( n = `width`          v = `6rem`
                            )->a( n = `hAlign`         v = `End`
                            )->a( n = `filterProperty` v = `QUANTITY`
                            )->a( n = `filterType`     v = `sap.ui.model.type.Integer`

                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text` v = `Quantity`

                            )->open( `template`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = |\{ path: 'QUANTITY', type: 'sap.ui.model.type.Integer' \}|

                            )->shut(
                        )->shut(
                    )->shut(
                    )->open( `footer`
                        )->leaf( n = `OverflowToolbar` ns = `m`
                            )->a( n = `id` v = `infobar`

                    )->shut(
                )->shut(
            )->shut(
        )->shut(
    )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `SEARCH`.
        " filterGlobally: Name OR Category contains the query
        filter_apply( ).

      WHEN `TOGGLE_AVAILABILITY`.
        " toggleAvailabilityFilter: filter the availability column on/off
        filter_apply( ).

      WHEN `COLUMN_FILTER`.
        " filterPrice: the price column filters a +/- 20 BAND around the entered
        " value instead of an exact match - every other column filters on its
        " own filterProperty. The client-side default is vetoed for all of them
        " because the model here is already the filtered result
        IF client->get_event_arg( ) = `PRICE`.
          price_filter = client->get_event_arg( 2 ).
        ENDIF.
        filter_apply( ).

      WHEN `CLEAR_FILTERS`.
        " clearAllFilters
        global_filter          = ``.
        availability_filter_on = abap_false.
        price_filter           = ``.
        filter_apply( ).

    ENDCASE.

    client->view_model_update( ).

  ENDMETHOD.


  METHOD filter_apply.

    " the controller's _filter( ): the global filter and the price filter are
    " ANDed, each one on its own an OR over its columns
    t_products = catalog( ).

    IF global_filter IS NOT INITIAL.
      DATA(lv_query) = to_upper( global_filter ).
      LOOP AT t_products INTO DATA(ls_row).
        IF to_upper( ls_row-name ) NS lv_query AND to_upper( ls_row-category ) NS lv_query.
          DELETE t_products INDEX sy-tabix.
        ENDIF.
      ENDLOOP.
    ENDIF.

    IF availability_filter_on = abap_true.
      DELETE t_products WHERE available = abap_false.
    ENDIF.

    IF price_filter CO ` 0123456789.` AND price_filter IS NOT INITIAL.
      DATA(lv_price) = CONV decfloat34( price_filter ).
      DELETE t_products WHERE price < lv_price - 20 OR price > lv_price + 20.
    ENDIF.

  ENDMETHOD.


  METHOD catalog.

    " the shared 123-row demo ProductCollection (sap/ui/demo/mock/products.json)
    " with the columns the six table columns bind. The controller's
    " formatAvailableToObjectState is precomputed into AVAILABLESTATE, since
    " business logic belongs in the backend. ProductPicUrl values point at the
    " OpenUI5 host per the asset-URL rule; the mock carries them host-relative
    result = VALUE #(
      ( name = `Notebook Basic 15` category = `Laptops` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg` available = abap_true availablestate = `Success` status = `Available` price = 956
        currencycode = `EUR` quantity = 10 )
      ( name = `Notebook Basic 17` category = `Laptops` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1001.jpg` available = abap_true availablestate = `Success` status = `Available` price = 1249
        currencycode = `EUR` quantity = 20 )
      ( name = `Notebook Basic 18` category = `Laptops` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1002.jpg` available = abap_true availablestate = `Success` status = `Available` price = 1570
        currencycode = `EUR` quantity = 10 )
      ( name = `Notebook Basic 19` category = `Laptops` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1003.jpg` available = abap_false availablestate = `Error` status = `Out of Stock` price = 1650
        currencycode = `EUR` quantity = 15 )
      ( name = `ITelO Vault` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1007.jpg` available = abap_false availablestate = `Error` status = `Out of Stock` price = 299
        currencycode = `EUR` quantity = 15 )
      ( name = `Notebook Professional 15` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg` available = abap_false availablestate = `Error` status = `Out of Stock`
        price = 1999 currencycode = `EUR` quantity = 16 )
      ( name = `Notebook Professional 17` category = `Laptops` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1011.jpg` available = abap_false availablestate = `Error` status = `Out of Stock` price = 2299
        currencycode = `EUR` quantity = 17 )
      ( name = `ITelO Vault Net` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1020.jpg` available = abap_false availablestate = `Error` status = `Discontinued` price = 459
        currencycode = `EUR` quantity = 14 )
      ( name = `ITelO Vault SAT` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1021.jpg` available = abap_true availablestate = `Success` status = `Available` price = 149
        currencycode = `EUR` quantity = 50 )
      ( name = `Comfort Easy` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1022.jpg` available = abap_false availablestate = `Error` status = `Out of Stock` price = 1679
        currencycode = `EUR` quantity = 30 )
      ( name = `Comfort Senior` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1023.jpg` available = abap_true availablestate = `Success` status = `Available` price = 512
        currencycode = `EUR` quantity = 24 )
      ( name = `Ergo Screen E-I` category = `Flat Screen Monitors` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1030.jpg` available = abap_true availablestate = `Success` status = `Available` price = 230
        currencycode = `EUR` quantity = 14 )
      ( name = `Ergo Screen E-II` category = `Flat Screen Monitors` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1031.jpg` available = abap_true availablestate = `Success` status = `Available` price = 285
        currencycode = `EUR` quantity = 24 )
      ( name = `Ergo Screen E-III` category = `Flat Screen Monitors` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1032.jpg` available = abap_false availablestate = `Error` status = `Out of Stock`
        price = 345 currencycode = `EUR` quantity = 50 )
      ( name = `Flat Basic` category = `Flat Screen Monitors` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1035.jpg` available = abap_true availablestate = `Success` status = `Available` price = 399
        currencycode = `EUR` quantity = 23 )
      ( name = `Flat Future` category = `Flat Screen Monitors` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1036.jpg` available = abap_true availablestate = `Success` status = `Available` price = 430
        currencycode = `EUR` quantity = 22 )
      ( name = `Flat XL` category = `Flat Screen Monitors` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1037.jpg` available = abap_true availablestate = `Success` status = `Available` price = 1230
        currencycode = `EUR` quantity = 23 )
      ( name = `Laser Professional Eco` category = `Printers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1040.jpg` available = abap_true availablestate = `Success` status = `Available` price = 830
        currencycode = `EUR` quantity = 21 )
      ( name = `Laser Basic` category = `Printers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1041.jpg` available = abap_true availablestate = `Success` status = `Available` price = 490
        currencycode = `EUR` quantity = 8 )
      ( name = `Laser Allround` category = `Printers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1042.jpg` available = abap_true availablestate = `Success` status = `Available` price = 349
        currencycode = `EUR` quantity = 9 )
      ( name = `Ultra Jet Super Color` category = `Printers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1050.jpg` available = abap_false availablestate = `Error` status = `Discontinued` price = 139
        currencycode = `EUR` quantity = 17 )
      ( name = `Ultra Jet Mobile` category = `Printers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1051.jpg` available = abap_false availablestate = `Error` status = `Discontinued` price = 99
        currencycode = `EUR` quantity = 18 )
      ( name = `Ultra Jet Super Highspeed` category = `Printers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1052.jpg` available = abap_true availablestate = `Success` status = `Available` price = 170
        currencycode = `EUR` quantity = 25 )
      ( name = `Multi Print` category = `Multifunction Printers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1055.jpg` available = abap_true availablestate = `Success` status = `Available` price = 99
        currencycode = `EUR` quantity = 16 )
      ( name = `Multi Color` category = `Multifunction Printers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1056.jpg` available = abap_true availablestate = `Success` status = `Available` price = 119
        currencycode = `EUR` quantity = 5 )
      ( name = `Cordless Mouse` category = `Mice` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1060.jpg` available = abap_true availablestate = `Success` status = `Available` price = 9
        currencycode = `EUR` quantity = 25 )
      ( name = `Speed Mouse` category = `Mice` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1061.jpg` available = abap_true availablestate = `Success` status = `Available` price = 7 currencycode = `EUR`
        quantity = 12 )
      ( name = `Track Mouse` category = `Mice` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1062.jpg` available = abap_false availablestate = `Error` status = `Discontinued` price = 11
        currencycode = `EUR` quantity = 12 )
      ( name = `Ergonomic Keyboard` category = `Keyboards` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1063.jpg` available = abap_true availablestate = `Success` status = `Available` price = 14
        currencycode = `EUR` quantity = 50 )
      ( name = `Internet Keyboard` category = `Keyboards` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1064.jpg` available = abap_false availablestate = `Error` status = `Out of Stock` price = 16
        currencycode = `EUR` quantity = 35 )
      ( name = `Media Keyboard` category = `Keyboards` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1065.jpg` available = abap_true availablestate = `Success` status = `Available` price = 26
        currencycode = `EUR` quantity = 26 )
      ( name = `Mousepad` category = `Mousepads` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1066.jpg` available = abap_true availablestate = `Success` status = `Available` price = `6.99`
        currencycode = `EUR` quantity = 12 )
      ( name = `Ergo Mousepad` category = `Mousepads` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1067.jpg` available = abap_false availablestate = `Error` status = `Out of Stock` price = `8.99`
        currencycode = `EUR` quantity = 16 )
      ( name = `Designer Mousepad` category = `Mousepads` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1068.jpg` available = abap_true availablestate = `Success` status = `Available` price = `12.99`
        currencycode = `EUR` quantity = 26 )
      ( name = `Universal card reader` category = `Computer System Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1069.jpg` available = abap_true availablestate = `Success` status = `Available`
        price = 14 currencycode = `EUR` quantity = 22 )
      ( name = `Proctra X` category = `Graphic Cards` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1070.jpg` available = abap_false availablestate = `Error` status = `Out of Stock` price = `70.9`
        currencycode = `EUR` quantity = 15 )
      ( name = `Gladiator MX` category = `Graphic Cards` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1071.jpg` available = abap_false availablestate = `Error` status = `Discontinued` price = `81.7`
        currencycode = `EUR` quantity = 16 )
      ( name = `Hurricane GX` category = `Graphic Cards` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1072.jpg` available = abap_true availablestate = `Success` status = `Available` price = `101.2`
        currencycode = `EUR` quantity = 13 )
      ( name = `Hurricane GX/LN` category = `Graphic Cards` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1073.jpg` available = abap_false availablestate = `Error` status = `Out of Stock` price = `139.99`
        currencycode = `EUR` quantity = 5 )
      ( name = `Photo Scan` category = `Scanners` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1080.jpg` available = abap_false availablestate = `Error` status = `Out of Stock` price = 129
        currencycode = `EUR` quantity = 8 )
      ( name = `Power Scan` category = `Scanners` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1081.jpg` available = abap_false availablestate = `Error` status = `Out of Stock` price = 89
        currencycode = `EUR` quantity = 11 )
      ( name = `Jet Scan Professional` category = `Scanners` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1082.jpg` available = abap_false availablestate = `Error` status = `Out of Stock` price = 169
        currencycode = `EUR` quantity = 13 )
      ( name = `Jet Scan Professional` category = `Scanners` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1083.jpg` available = abap_true availablestate = `Success` status = `Available` price = 189
        currencycode = `EUR` quantity = 10 )
      ( name = `Copymaster` category = `Multifunction Printers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1085.jpg` available = abap_true availablestate = `Success` status = `Available` price = 1499
        currencycode = `EUR` quantity = 10 )
      ( name = `Surround Sound` category = `Speakers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1090.jpg` available = abap_true availablestate = `Success` status = `Available` price = 39
        currencycode = `EUR` quantity = 20 )
      ( name = `Blaster Extreme` category = `Speakers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1091.jpg` available = abap_true availablestate = `Success` status = `Available` price = 26
        currencycode = `EUR` quantity = 15 )
      ( name = `Sound Booster` category = `Speakers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1092.jpg` available = abap_false availablestate = `Error` status = `Discontinued` price = 45
        currencycode = `EUR` quantity = 50 )
      ( name = `Lovely Sound 5.1 Wireless` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1095.jpg` available = abap_true availablestate = `Success` status = `Available` price = 49
        currencycode = `EUR` quantity = 12 )
      ( name = `Lovely Sound 5.1` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1096.jpg` available = abap_true availablestate = `Success` status = `Available` price = 39
        currencycode = `EUR` quantity = 18 )
      ( name = `Lovely Sound Stereo` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1097.jpg` available = abap_false availablestate = `Error` status = `Out of Stock` price = 29
        currencycode = `EUR` quantity = 21 )
      ( name = `Smart Office` category = `Software` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1100.jpg` available = abap_false availablestate = `Error` status = `Out of Stock` price = `89.9`
        currencycode = `EUR` quantity = 25 )
      ( name = `Smart Design` category = `Software` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1101.jpg` available = abap_true availablestate = `Success` status = `Available` price = `79.9`
        currencycode = `EUR` quantity = 26 )
      ( name = `Smart Network` category = `Software` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1102.jpg` available = abap_true availablestate = `Success` status = `Available` price = 69
        currencycode = `EUR` quantity = 28 )
      ( name = `Smart Multimedia` category = `Software` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1103.jpg` available = abap_true availablestate = `Success` status = `Available` price = 77
        currencycode = `EUR` quantity = 9 )
      ( name = `Smart Games` category = `Software` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1104.jpg` available = abap_true availablestate = `Success` status = `Available` price = 55
        currencycode = `EUR` quantity = 13 )
      ( name = `Smart Internet Antivirus` category = `Software` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1105.jpg` available = abap_true availablestate = `Success` status = `Available` price = 29
        currencycode = `EUR` quantity = 17 )
      ( name = `Smart Firewall` category = `Software` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1106.jpg` available = abap_false availablestate = `Error` status = `Discontinued` price = 34
        currencycode = `EUR` quantity = 19 )
      ( name = `Smart Money` category = `Software` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1107.jpg` available = abap_false availablestate = `Error` status = `Out of Stock` price = `29.9`
        currencycode = `EUR` quantity = 18 )
      ( name = `PC Lock` category = `Computer System Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1110.jpg` available = abap_true availablestate = `Success` status = `Available` price = `8.9`
        currencycode = `EUR` quantity = 14 )
      ( name = `Notebook Lock` category = `Computer System Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1111.jpg` available = abap_true availablestate = `Success` status = `Available`
        price = `6.9` currencycode = `EUR` quantity = 20 )
      ( name = `Web cam reality` category = `Computer System Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1112.jpg` available = abap_false availablestate = `Error` status = `Out of Stock`
        price = 39 currencycode = `EUR` quantity = 27 )
      ( name = `Screen clean` category = `Computer System Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1113.jpg` available = abap_true availablestate = `Success` status = `Available`
        price = `2.3` currencycode = `EUR` quantity = 17 )
      ( name = `Fabric bag professional` category = `Computer System Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1114.jpg` available = abap_true availablestate = `Success`
        status = `Available` price = 31 currencycode = `EUR` quantity = 14 )
      ( name = `Wireless DSL Router` category = `Telecommunications` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1115.jpg` available = abap_true availablestate = `Success` status = `Available` price = 49
        currencycode = `EUR` quantity = 16 )
      ( name = `Wireless DSL Router / Repeater` category = `Telecommunications` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1116.jpg` available = abap_false availablestate = `Error`
        status = `Out of Stock` price = 59 currencycode = `EUR` quantity = 12 )
      ( name = `Wireless DSL Router / Repeater and Print Server` category = `Telecommunications` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1117.jpg` available = abap_true availablestate = `Success`
        status = `Available` price = 69 currencycode = `EUR` quantity = 12 )
      ( name = `USB Stick` category = `Computer System Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1118.jpg` available = abap_true availablestate = `Success` status = `Available` price = 35
        currencycode = `EUR` quantity = 14 )
      ( name = `Travel Adapter` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1119.jpg` available = abap_false availablestate = `Error` status = `Discontinued` price = 79
        currencycode = `EUR` quantity = 10 )
      ( name = `Cordless Bluetooth Keyboard, english international` category = `Keyboards` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1120.jpg` available = abap_false availablestate = `Error`
        status = `Out of Stock` price = 29 currencycode = `EUR` quantity = 13 )
      ( name = `Flat XXL` category = `Flat Screen Monitors` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1137.jpg` available = abap_false availablestate = `Error` status = `Discontinued` price = 1430
        currencycode = `EUR` quantity = 10 )
      ( name = `Pocket Mouse` category = `Mice` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1138.jpg` available = abap_true availablestate = `Success` status = `Available` price = 23 currencycode = `EUR`
        quantity = 20 )
      ( name = `PC Power Station` category = `PCs` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1210.jpg` available = abap_true availablestate = `Success` status = `Available` price = 2399
        currencycode = `EUR` quantity = 22 )
      ( name = `Astro Laptop 1516` category = `Laptops` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1251.jpg` available = abap_true availablestate = `Success` status = `Available` price = 989
        currencycode = `EUR` quantity = 23 )
      ( name = `Astro Phone 6` category = `Smartphones and Tablets` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1252.jpg` available = abap_true availablestate = `Success` status = `Available` price = 649
        currencycode = `EUR` quantity = 28 )
      ( name = `Benda Laptop 1408` category = `Laptops` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1253.jpg` available = abap_false availablestate = `Error` status = `Discontinued` price = 976
        currencycode = `EUR` quantity = 27 )
      ( name = `Bending Screen 21HD` category = `Flat Screens` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1254.jpg` available = abap_true availablestate = `Success` status = `Available` price = 250
        currencycode = `EUR` quantity = 23 )
      ( name = `Broad Screen 22HD` category = `Flat Screens` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1255.jpg` available = abap_false availablestate = `Error` status = `Discontinued` price = 270
        currencycode = `EUR` quantity = 5 )
      ( name = `Cerdik Phone 7` category = `Smartphones and Tablets` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1256.jpg` available = abap_false availablestate = `Error` status = `Discontinued`
        price = 549 currencycode = `EUR` quantity = 19 )
      ( name = `Cepat Tablet 10.5` category = `Smartphones and Tablets` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1257.jpg` available = abap_true availablestate = `Success` status = `Available`
        price = 549 currencycode = `EUR` quantity = 17 )
      ( name = `Cepat Tablet 8` category = `Smartphones and Tablets` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1258.jpg` available = abap_true availablestate = `Success` status = `Available`
        price = 529 currencycode = `EUR` quantity = 24 )
      ( name = `Server Basic` category = `Servers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1500.jpg` available = abap_true availablestate = `Success` status = `Available` price = 5000
        currencycode = `EUR` quantity = 24 )
      ( name = `Server Professional` category = `Servers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1501.jpg` available = abap_false availablestate = `Error` status = `Out of Stock` price = 15000
        currencycode = `EUR` quantity = 26 )
      ( name = `Server Power Pro` category = `Servers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1502.jpg` available = abap_true availablestate = `Success` status = `Available` price = 25000
        currencycode = `EUR` quantity = 34 )
      ( name = `Family PC Basic` category = `Desktop Computers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1600.jpg` available = abap_true availablestate = `Success` status = `Available` price = 600
        currencycode = `EUR` quantity = 10 )
      ( name = `Family PC Pro` category = `Desktop Computers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1601.jpg` available = abap_true availablestate = `Success` status = `Available` price = 900
        currencycode = `EUR` quantity = 20 )
      ( name = `Gaming Monster` category = `Desktop Computers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1602.jpg` available = abap_true availablestate = `Success` status = `Available` price = 1200
        currencycode = `EUR` quantity = 24 )
      ( name = `Gaming Monster Pro` category = `Desktop Computers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1603.jpg` available = abap_false availablestate = `Error` status = `Discontinued`
        price = 1700 currencycode = `EUR` quantity = 25 )
      ( name = `7" Widescreen Portable DVD Player w MP3` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2000.jpg` available = abap_true availablestate = `Success`
        status = `Available` price = `249.99` currencycode = `EUR` quantity = 20 )
      ( name = `10" Portable DVD player` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2001.jpg` available = abap_true availablestate = `Success` status = `Available`
        price = `449.99` currencycode = `EUR` quantity = 21 )
      ( name = `Portable DVD Player with 9" LCD Monitor` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2002.jpg` available = abap_true availablestate = `Success`
        status = `Available` price = `853.99` currencycode = `EUR` quantity = 50 )
      ( name = `CD/DVD case: 264 sleeves` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2025.jpg` available = abap_false availablestate = `Error` status = `Discontinued`
        price = `44.99` currencycode = `EUR` quantity = 26 )
      ( name = `Audio/Video Cable Kit - 4m` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2026.jpg` available = abap_true availablestate = `Success` status = `Available`
        price = `29.99` currencycode = `EUR` quantity = 16 )
      ( name = `Removable CD/DVD Laser Labels` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2027.jpg` available = abap_false availablestate = `Error` status = `Discontinued`
        price = `8.99` currencycode = `EUR` quantity = 25 )
      ( name = `Beam Breaker B-1` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6100.jpg` available = abap_false availablestate = `Error` status = `Out of Stock` price = 469
        currencycode = `EUR` quantity = 32 )
      ( name = `Beam Breaker B-2` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6101.jpg` available = abap_true availablestate = `Success` status = `Available` price = 679
        currencycode = `EUR` quantity = 18 )
      ( name = `Beam Breaker B-3` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6102.jpg` available = abap_false availablestate = `Error` status = `Out of Stock` price = 889
        currencycode = `EUR` quantity = 16 )
      ( name = `Play Movie` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6110.jpg` available = abap_true availablestate = `Success` status = `Available` price = 130
        currencycode = `EUR` quantity = 15 )
      ( name = `Record Movie` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6111.jpg` available = abap_false availablestate = `Error` status = `Discontinued` price = 288
        currencycode = `EUR` quantity = 24 )
      ( name = `ITelo MusicStick` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6120.jpg` available = abap_true availablestate = `Success` status = `Available` price = 45
        currencycode = `EUR` quantity = 15 )
      ( name = `ITelo Jog-Mate` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6121.jpg` available = abap_true availablestate = `Success` status = `Available` price = 63
        currencycode = `EUR` quantity = 24 )
      ( name = `Power Pro Player 40` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6122.jpg` available = abap_true availablestate = `Success` status = `Available` price = 167
        currencycode = `EUR` quantity = 23 )
      ( name = `Power Pro Player 80` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6123.jpg` available = abap_true availablestate = `Success` status = `Available` price = 299
        currencycode = `EUR` quantity = 13 )
      ( name = `Flat Watch HD32` category = `Flat Screen TVs` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6130.jpg` available = abap_true availablestate = `Success` status = `Available` price = 1459
        currencycode = `EUR` quantity = 16 )
      ( name = `Flat Watch HD37` category = `Flat Screen TVs` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6131.jpg` available = abap_true availablestate = `Success` status = `Available` price = 1199
        currencycode = `EUR` quantity = 14 )
      ( name = `Flat Watch HD41` category = `Flat Screen TVs` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6132.jpg` available = abap_false availablestate = `Error` status = `Discontinued` price = 899
        currencycode = `EUR` quantity = 13 )
      ( name = `Copperberry` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7000.jpg` available = abap_false availablestate = `Error` status = `Discontinued` price = 549
        currencycode = `EUR` quantity = 5 )
      ( name = `Silverberry` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7010.jpg` available = abap_false availablestate = `Error` status = `Discontinued` price = 549
        currencycode = `EUR` quantity = 9 )
      ( name = `Goldberry` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7020.jpg` available = abap_true availablestate = `Success` status = `Available` price = 549
        currencycode = `EUR` quantity = 11 )
      ( name = `Platinberry` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7030.jpg` available = abap_true availablestate = `Success` status = `Available` price = 549
        currencycode = `EUR` quantity = 12 )
      ( name = `ITelO FlexTop I4000` category = `Laptops` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8000.jpg` available = abap_true availablestate = `Success` status = `Available` price = 799
        currencycode = `EUR` quantity = 11 )
      ( name = `ITelO FlexTop I6300c` category = `Laptops` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8001.jpg` available = abap_false availablestate = `Error` status = `Discontinued` price = 799
        currencycode = `EUR` quantity = 20 )
      ( name = `ITelO FlexTop I9100` category = `Laptops` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8002.jpg` available = abap_true availablestate = `Success` status = `Available` price = 1199
        currencycode = `EUR` quantity = 20 )
      ( name = `ITelO FlexTop I9800` category = `Laptops` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8003.jpg` available = abap_true availablestate = `Success` status = `Available` price = 1388
        currencycode = `EUR` quantity = 22 )
      ( name = `Smartphone Leather Case` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9991.jpg` available = abap_true availablestate = `Success` status = `Available` price = 25
        currencycode = `EUR` quantity = 12 )
      ( name = `Smartphone Alpha` category = `Smartphones and Tablets` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9992.jpg` available = abap_false availablestate = `Error` status = `Out of Stock`
        price = 599 currencycode = `EUR` quantity = 13 )
      ( name = `Mini Tablet` category = `Smartphones and Tablets` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9993.jpg` available = abap_true availablestate = `Success` status = `Available` price = 833
        currencycode = `EUR` quantity = 10 )
      ( name = `Camcorder View` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9994.jpg` available = abap_false availablestate = `Error` status = `Out of Stock` price = 1388
        currencycode = `EUR` quantity = 50 )
      ( name = `Tablet Pouch` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9995.jpg` available = abap_true availablestate = `Success` status = `Available` price = 20
        currencycode = `EUR` quantity = 34 )
      ( name = `Tablet Pouch` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9996.jpg` available = abap_true availablestate = `Success` status = `Available` price = 20
        currencycode = `EUR` quantity = 34 )
      ( name = `e-Book Reader ReadMe` category = `Smartphones and Tablets` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9997.jpg` available = abap_true availablestate = `Success` status = `Available`
        price = 33 currencycode = `EUR` quantity = 23 )
      ( name = `Smartphone Beta` category = `Smartphones and Tablets` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9998.jpg` available = abap_true availablestate = `Success` status = `Available`
        price = 30 currencycode = `EUR` quantity = 21 )
      ( name = `Maxi Tablet` category = `Tablets` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9999.jpg` available = abap_true availablestate = `Success` status = `Available` price = 749
        currencycode = `EUR` quantity = 20 )
      ( name = `Flyer` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/PF-1000.jpg` available = abap_false availablestate = `Error` status = `Out of Stock` price = 0
        currencycode = `EUR` quantity = 33 )
      ).

  ENDMETHOD.


  METHOD model_init.

    " the original's `ui>` model defaults: no global filter, both toggles off
    t_products = catalog( ).

  ENDMETHOD.

ENDCLASS.
