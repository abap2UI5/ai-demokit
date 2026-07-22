CLASS z2ui5_cl_ai_app_022 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name           TYPE string,
        category       TYPE string,
        supplier_name  TYPE string,
        width          TYPE string,
        depth          TYPE string,
        height         TYPE string,
        dim_unit       TYPE string,
        weight_measure TYPE string,
        weight_unit    TYPE string,
        price          TYPE p LENGTH 14 DECIMALS 2,
        currency_code  TYPE string,
      END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.
    TYPES:
      BEGIN OF ty_s_facet,
        text     TYPE string,
        count    TYPE i,
        selected TYPE abap_bool,
      END OF ty_s_facet.
    TYPES ty_t_facet TYPE STANDARD TABLE OF ty_s_facet WITH EMPTY KEY.
    DATA t_products          TYPE ty_t_product.
    DATA t_categories        TYPE ty_t_facet.
    DATA t_suppliers         TYPE ty_t_facet.
    DATA popin_layout        TYPE string.
    DATA info_toolbar_hidden TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS apply_filter.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_022 IMPLEMENTATION.

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

    " bound lists collection unrolled into two static facet filter lists; the appended demo table of sap.m.sample.Table is rebuilt inline
    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        " the framework's curated formatter module, wired like the original wires './Formatter' (core:require needs UI5 >= 1.74)
        )->a( n = `core:require` v = `{Formatter: 'z2ui5/model/formatter'}`

        )->open( `VBox`
            )->a( n = `id` v = `idVBox`

            )->open( `FacetFilter`
                )->a( n = `id`                  v = `idFacetFilter`
                )->a( n = `type`                v = `Light`
                )->a( n = `showPersonalization` v = `true`
                )->a( n = `showReset`           v = `true`
                )->a( n = `reset`               v = client->_event( `RESET` )

                " each item binds selected two-way - listClose only signals the backend to read the flags
                )->open( `FacetFilterList`
                    )->a( n = `title`     v = `Category`
                    )->a( n = `key`       v = `Category`
                    )->a( n = `mode`      v = `MultiSelect`
                    )->a( n = `listClose` v = client->_event( `LIST_CLOSE` )
                    )->a( n = `items`     v = client->_bind( t_categories )

                    )->leaf( `FacetFilterItem`
                        )->a( n = `text`     v = `{TEXT}`
                        )->a( n = `key`      v = `{TEXT}`
                        )->a( n = `counter`  v = `{COUNT}`
                        )->a( n = `selected` v = `{SELECTED}`

                )->shut(
                )->open( `FacetFilterList`
                    )->a( n = `title`     v = `SupplierName`
                    )->a( n = `key`       v = `SupplierName`
                    )->a( n = `mode`      v = `MultiSelect`
                    )->a( n = `listClose` v = client->_event( `LIST_CLOSE` )
                    )->a( n = `items`     v = client->_bind( t_suppliers )

                    )->leaf( `FacetFilterItem`
                        )->a( n = `text`     v = `{TEXT}`
                        )->a( n = `key`      v = `{TEXT}`
                        )->a( n = `counter`  v = `{COUNT}`
                        )->a( n = `selected` v = `{SELECTED}`

                )->shut(
            )->shut(
            )->open( `Table`
                )->a( n = `id`          v = `idProductsTable`
                )->a( n = `inset`       v = `false`
                " popinLayout mirrors the original's setPopinLayout controller switch - an empty ComboBox selection maps to the Block default
                )->a( n = `popinLayout` v = |\{= ${ client->_bind( popin_layout ) } \|\| 'Block' \}|
                )->a( n = `items`       v = |\{ path: '{ client->_bind( val = t_products path = abap_true ) }', sorter: \{ path: 'NAME' \} \}|

                )->open( `headerToolbar`
                    )->open( `OverflowToolbar`
                        )->leaf( `Title`
                            )->a( n = `text`  v = `Products`
                            )->a( n = `level` v = `H2`
                        )->leaf( `ToolbarSpacer`

                        )->open( `ComboBox`
                            )->a( n = `id`          v = `idPopinLayout`
                            )->a( n = `placeholder` v = `Popin layout options`
                            " two-way selectedKey replaces the original's change handler (a pure key-to-property pass-through)
                            )->a( n = `selectedKey` v = client->_bind( popin_layout )

                            )->open( `items`
                                )->leaf( n = `Item` ns = `core`
                                    )->a( n = `text` v = `Block`
                                    )->a( n = `key`  v = `Block`
                                )->leaf( n = `Item` ns = `core`
                                    )->a( n = `text` v = `Grid Large`
                                    )->a( n = `key`  v = `GridLarge`
                                )->leaf( n = `Item` ns = `core`
                                    )->a( n = `text` v = `Grid Small`
                                    )->a( n = `key`  v = `GridSmall`

                            )->shut(
                        )->shut(
                        " the original's sticky Label + CheckBoxes are dropped - Table.sticky is an array property with no binding path
                        )->leaf( `ToggleButton`
                            )->a( n = `id`      v = `toggleInfoToolbar`
                            )->a( n = `text`    v = `Hide/Show InfoToolbar`
                            " two-way pressed replaces the original's press handler - the infoToolbar visibility is a pure expression over it
                            )->a( n = `pressed` v = client->_bind( info_toolbar_hidden )

                    )->shut(
                )->shut(
                )->open( `infoToolbar`
                    )->open( `OverflowToolbar`
                        )->a( n = `visible` v = |\{= !${ client->_bind( info_toolbar_hidden ) } \}|

                        )->leaf( `Label`
                            )->a( n = `text` v = `Wide range of available products`

                    )->shut(
                )->shut(
                )->open( `columns`
                    )->open( `Column`
                        )->a( n = `width` v = `12em`

                        )->leaf( `Text`
                            )->a( n = `text` v = `Product`

                    )->shut(
                    )->open( `Column`
                        )->a( n = `minScreenWidth` v = `Tablet`
                        )->a( n = `demandPopin`    v = `true`

                        )->leaf( `Text`
                            )->a( n = `text` v = `Supplier`

                    )->shut(
                    )->open( `Column`
                        )->a( n = `minScreenWidth` v = `Desktop`
                        )->a( n = `demandPopin`    v = `true`
                        )->a( n = `hAlign`         v = `End`

                        )->leaf( `Text`
                            )->a( n = `text` v = `Dimensions`

                    )->shut(
                    )->open( `Column`
                        )->a( n = `minScreenWidth` v = `Desktop`
                        )->a( n = `demandPopin`    v = `true`
                        )->a( n = `hAlign`         v = `Center`

                        )->leaf( `Text`
                            )->a( n = `text` v = `Weight`

                    )->shut(
                    )->open( `Column`
                        )->a( n = `hAlign` v = `End`

                        )->leaf( `Text`
                            )->a( n = `text` v = `Price`

                    )->shut(
                )->shut(
                )->open( `items`
                    )->open( `ColumnListItem`
                        )->a( n = `vAlign` v = `Middle`

                        )->open( `cells`
                            )->leaf( `ObjectIdentifier`
                                )->a( n = `title` v = `{NAME}`
                                )->a( n = `text`  v = `{CATEGORY}`
                            )->leaf( `Text`
                                )->a( n = `text` v = `{SUPPLIER_NAME}`
                            )->leaf( `Text`
                                )->a( n = `text` v = `{WIDTH} x {DEPTH} x {HEIGHT} {DIM_UNIT}`
                            " parts+formatter binding kept 1:1 - the curated formatter module is required into the view (core:require above)
                            )->leaf( `ObjectNumber`
                                )->a( n = `number` v = `{WEIGHT_MEASURE}`
                                )->a( n = `unit`   v = `{WEIGHT_UNIT}`
                                )->a( n = `state`  v = |\{ parts: [\{path: 'WEIGHT_MEASURE'\}, \{path: 'WEIGHT_UNIT'\}], formatter: 'Formatter.weightState' \}|
                            )->leaf( `ObjectNumber`
                                )->a( n = `number` v = |\{ parts:[\{path:'PRICE'\},\{path:'CURRENCY_CODE'\}], type:'sap.ui.model.type.Currency', formatOptions:\{showMeasure:false\} \}|
                                )->a( n = `unit`   v = `{CURRENCY_CODE}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `RESET`.
        " like handleFacetFilterReset: clear the two-way bound selection flags and re-filter
        LOOP AT t_categories ASSIGNING FIELD-SYMBOL(<category>).
          <category>-selected = abap_false.
        ENDLOOP.
        LOOP AT t_suppliers ASSIGNING FIELD-SYMBOL(<supplier>).
          <supplier>-selected = abap_false.
        ENDLOOP.
        apply_filter( ).

      WHEN `LIST_CLOSE`.
        apply_filter( ).

    ENDCASE.

  ENDMETHOD.


  METHOD apply_filter.

    DATA rows_category TYPE string.
    DATA rows_supplier TYPE string.

    " the two-way bound selected flags arrive with the event - one JSON group per facet list with selections (values are static demo texts, no escaping needed)
    LOOP AT t_categories INTO DATA(category) WHERE selected = abap_true.
      IF rows_category IS NOT INITIAL.
        rows_category = rows_category && `,`.
      ENDIF.
      rows_category = rows_category && |["CATEGORY","EQ","{ category-text }"]|.
    ENDLOOP.
    LOOP AT t_suppliers INTO DATA(supplier) WHERE selected = abap_true.
      IF rows_supplier IS NOT INITIAL.
        rows_supplier = rows_supplier && `,`.
      ENDIF.
      rows_supplier = rows_supplier && |["SUPPLIER_NAME","EQ","{ supplier-text }"]|.
    ENDLOOP.

    DATA(json_groups) = `[`.
    IF rows_category IS NOT INITIAL.
      json_groups = json_groups && |[{ rows_category }]|.
    ENDIF.
    IF rows_supplier IS NOT INITIAL.
      IF rows_category IS NOT INITIAL.
        json_groups = json_groups && `,`.
      ENDIF.
      json_groups = json_groups && |[{ rows_supplier }]|.
    ENDIF.
    json_groups = json_groups && `]`.

    " like _filterModel (ORs inside a group, AND across the groups) - declarative compound filter on the items binding, model untouched
    client->follow_up_action( val   = client->cs_event-binding_call
                              t_arg = VALUE #( ( `idProductsTable` ) ( `items` ) ( `filter` ) ( json_groups ) ) ).
    client->view_model_update( ).

  ENDMETHOD.


  METHOD model_init.

    " full mock /ProductCollection (sap/ui/demo/mock/products.json) of the original sample
    t_products = VALUE #(
        ( name = `Notebook Basic 15` category = `Laptops` supplier_name = `Very Best Screens` width = `30` depth = `18` height = `3` dim_unit = `cm`
          weight_measure = `4.2` weight_unit = `KG` price = `956.00` currency_code = `EUR` )
        ( name = `Notebook Basic 17` category = `Laptops` supplier_name = `Very Best Screens` width = `29` depth = `17` height = `3.1` dim_unit = `cm`
          weight_measure = `4.5` weight_unit = `KG` price = `1249.00` currency_code = `EUR` )
        ( name = `Notebook Basic 18` category = `Laptops` supplier_name = `Very Best Screens` width = `28` depth = `19` height = `2.5` dim_unit = `cm`
          weight_measure = `4.2` weight_unit = `KG` price = `1570.00` currency_code = `EUR` )
        ( name = `Notebook Basic 19` category = `Laptops` supplier_name = `Smartcards` width = `32` depth = `21` height = `4` dim_unit = `cm`
          weight_measure = `4.2` weight_unit = `KG` price = `1650.00` currency_code = `EUR` )
        ( name = `ITelO Vault` category = `Accessories` supplier_name = `Technocom` width = `32` depth = `22` height = `3` dim_unit = `cm`
          weight_measure = `0.2` weight_unit = `KG` price = `299.00` currency_code = `EUR` )
        ( name = `Notebook Professional 15` category = `Accessories` supplier_name = `Very Best Screens` width = `33` depth = `20` height = `3` dim_unit = `cm`
          weight_measure = `4.3` weight_unit = `KG` price = `1999.00` currency_code = `EUR` )
        ( name = `Notebook Professional 17` category = `Laptops` supplier_name = `Very Best Screens` width = `33` depth = `23` height = `2` dim_unit = `cm`
          weight_measure = `4.1` weight_unit = `KG` price = `2299.00` currency_code = `EUR` )
        ( name = `ITelO Vault Net` category = `Accessories` supplier_name = `Technocom` width = `10` depth = `1.8` height = `17` dim_unit = `cm`
          weight_measure = `0.16` weight_unit = `KG` price = `459.00` currency_code = `EUR` )
        ( name = `ITelO Vault SAT` category = `Accessories` supplier_name = `Technocom` width = `11` depth = `1.7` height = `18` dim_unit = `cm`
          weight_measure = `0.18` weight_unit = `KG` price = `149.00` currency_code = `EUR` )
        ( name = `Comfort Easy` category = `Accessories` supplier_name = `Technocom` width = `84` depth = `1.5` height = `14` dim_unit = `cm`
          weight_measure = `0.2` weight_unit = `KG` price = `1679.00` currency_code = `EUR` )
        ( name = `Comfort Senior` category = `Accessories` supplier_name = `Technocom` width = `80` depth = `1.6` height = `13` dim_unit = `cm`
          weight_measure = `0.8` weight_unit = `KG` price = `512.00` currency_code = `EUR` )
        ( name = `Ergo Screen E-I` category = `Flat Screen Monitors` supplier_name = `Very Best Screens` width = `37` depth = `12` height = `36` dim_unit = `cm`
          weight_measure = `21` weight_unit = `KG` price = `230.00` currency_code = `EUR` )
        ( name = `Ergo Screen E-II` category = `Flat Screen Monitors` supplier_name = `Very Best Screens` width = `40.8` depth = `19` height = `43` dim_unit = `cm`
          weight_measure = `21` weight_unit = `KG` price = `285.00` currency_code = `EUR` )
        ( name = `Ergo Screen E-III` category = `Flat Screen Monitors` supplier_name = `Very Best Screens` width = `40.8` depth = `19` height = `43` dim_unit = `cm`
          weight_measure = `21` weight_unit = `KG` price = `345.00` currency_code = `EUR` )
        ( name = `Flat Basic` category = `Flat Screen Monitors` supplier_name = `Very Best Screens` width = `39` depth = `20` height = `41` dim_unit = `cm`
          weight_measure = `14` weight_unit = `KG` price = `399.00` currency_code = `EUR` )
        ( name = `Flat Future` category = `Flat Screen Monitors` supplier_name = `Very Best Screens` width = `45` depth = `26` height = `46` dim_unit = `cm`
          weight_measure = `15` weight_unit = `KG` price = `430.00` currency_code = `EUR` )
        ( name = `Flat XL` category = `Flat Screen Monitors` supplier_name = `Very Best Screens` width = `54.5` depth = `22.1` height = `39.1` dim_unit = `cm`
          weight_measure = `17` weight_unit = `KG` price = `1230.00` currency_code = `EUR` )
        ( name = `Laser Professional Eco` category = `Printers` supplier_name = `Alpha Printers` width = `51` depth = `46` height = `30` dim_unit = `cm`
          weight_measure = `32` weight_unit = `KG` price = `830.00` currency_code = `EUR` )
        ( name = `Laser Basic` category = `Printers` supplier_name = `Alpha Printers` width = `48` depth = `42` height = `26` dim_unit = `cm`
          weight_measure = `23` weight_unit = `KG` price = `490.00` currency_code = `EUR` )
        ( name = `Laser Allround` category = `Printers` supplier_name = `Alpha Printers` width = `53` depth = `50` height = `65` dim_unit = `cm`
          weight_measure = `17` weight_unit = `KG` price = `349.00` currency_code = `EUR` )
        ( name = `Ultra Jet Super Color` category = `Printers` supplier_name = `Alpha Printers` width = `41` depth = `41` height = `28` dim_unit = `cm`
          weight_measure = `3` weight_unit = `KG` price = `139.00` currency_code = `EUR` )
        ( name = `Ultra Jet Mobile` category = `Printers` supplier_name = `Printer for All` width = `46` depth = `32` height = `25` dim_unit = `cm`
          weight_measure = `1.9` weight_unit = `KG` price = `99.00` currency_code = `EUR` )
        ( name = `Ultra Jet Super Highspeed` category = `Printers` supplier_name = `Printer for All` width = `41` depth = `41` height = `28` dim_unit = `cm`
          weight_measure = `18` weight_unit = `KG` price = `170.00` currency_code = `EUR` )
        ( name = `Multi Print` category = `Multifunction Printers` supplier_name = `Printer for All` width = `55` depth = `45` height = `29` dim_unit = `cm`
          weight_measure = `6.3` weight_unit = `KG` price = `99.00` currency_code = `EUR` )
        ( name = `Multi Color` category = `Multifunction Printers` supplier_name = `Printer for All` width = `51` depth = `41.3` height = `22` dim_unit = `cm`
          weight_measure = `4.3` weight_unit = `KG` price = `119.00` currency_code = `EUR` )
        ( name = `Cordless Mouse` category = `Mice` supplier_name = `Oxynum` width = `6` depth = `14.5` height = `3.5` dim_unit = `cm`
          weight_measure = `0.09` weight_unit = `KG` price = `9.00` currency_code = `EUR` )
        ( name = `Speed Mouse` category = `Mice` supplier_name = `Oxynum` width = `7` depth = `15` height = `3.1` dim_unit = `cm`
          weight_measure = `0.09` weight_unit = `KG` price = `7.00` currency_code = `EUR` )
        ( name = `Track Mouse` category = `Mice` supplier_name = `Oxynum` width = `3` depth = `7` height = `4` dim_unit = `cm`
          weight_measure = `0.03` weight_unit = `KG` price = `11.00` currency_code = `EUR` )
        ( name = `Ergonomic Keyboard` category = `Keyboards` supplier_name = `Oxynum` width = `50` depth = `21` height = `3.5` dim_unit = `cm`
          weight_measure = `2.1` weight_unit = `KG` price = `14.00` currency_code = `EUR` )
        ( name = `Internet Keyboard` category = `Keyboards` supplier_name = `Oxynum` width = `52` depth = `25` height = `3` dim_unit = `cm`
          weight_measure = `1.8` weight_unit = `KG` price = `16.00` currency_code = `EUR` )
        ( name = `Media Keyboard` category = `Keyboards` supplier_name = `Oxynum` width = `51.4` depth = `23` height = `4` dim_unit = `cm`
          weight_measure = `2.3` weight_unit = `KG` price = `26.00` currency_code = `EUR` )
        ( name = `Mousepad` category = `Mousepads` supplier_name = `Oxynum` width = `15` depth = `6` height = `0.2` dim_unit = `cm`
          weight_measure = `80` weight_unit = `G` price = `6.99` currency_code = `EUR` )
        ( name = `Ergo Mousepad` category = `Mousepads` supplier_name = `Oxynum` width = `15` depth = `6` height = `0.2` dim_unit = `cm`
          weight_measure = `80` weight_unit = `G` price = `8.99` currency_code = `EUR` )
        ( name = `Designer Mousepad` category = `Mousepads` supplier_name = `Fasttech` width = `24` depth = `24` height = `0.6` dim_unit = `cm`
          weight_measure = `90` weight_unit = `G` price = `12.99` currency_code = `EUR` )
        ( name = `Universal card reader` category = `Computer System Accessories` supplier_name = `Fasttech` width = `6` depth = `6` height = `3` dim_unit = `cm`
          weight_measure = `45` weight_unit = `G` price = `14.00` currency_code = `EUR` )
        ( name = `Proctra X` category = `Graphic Cards` supplier_name = `Ultrasonic United` width = `22` depth = `35` height = `17` dim_unit = `cm`
          weight_measure = `0.255` weight_unit = `KG` price = `70.90` currency_code = `EUR` )
        ( name = `Gladiator MX` category = `Graphic Cards` supplier_name = `Ultrasonic United` width = `22` depth = `35` height = `17` dim_unit = `cm`
          weight_measure = `0.3` weight_unit = `KG` price = `81.70` currency_code = `EUR` )
        ( name = `Hurricane GX` category = `Graphic Cards` supplier_name = `Ultrasonic United` width = `22` depth = `35` height = `17` dim_unit = `cm`
          weight_measure = `0.4` weight_unit = `KG` price = `101.20` currency_code = `EUR` )
        ( name = `Hurricane GX/LN` category = `Graphic Cards` supplier_name = `Smartcards` width = `22` depth = `35` height = `17` dim_unit = `cm`
          weight_measure = `0.4` weight_unit = `KG` price = `139.99` currency_code = `EUR` )
        ( name = `Photo Scan` category = `Scanners` supplier_name = `Printer for All` width = `34` depth = `48` height = `5` dim_unit = `cm`
          weight_measure = `2.3` weight_unit = `KG` price = `129.00` currency_code = `EUR` )
        ( name = `Power Scan` category = `Scanners` supplier_name = `Printer for All` width = `31` depth = `43` height = `7` dim_unit = `cm`
          weight_measure = `2.4` weight_unit = `KG` price = `89.00` currency_code = `EUR` )
        ( name = `Jet Scan Professional` category = `Scanners` supplier_name = `Printer for All` width = `33` depth = `41` height = `12` dim_unit = `cm`
          weight_measure = `3.2` weight_unit = `KG` price = `169.00` currency_code = `EUR` )
        ( name = `Jet Scan Professional` category = `Scanners` supplier_name = `Printer for All` width = `35` depth = `40` height = `10` dim_unit = `cm`
          weight_measure = `3.2` weight_unit = `KG` price = `189.00` currency_code = `EUR` )
        ( name = `Copymaster` category = `Multifunction Printers` supplier_name = `Alpha Printers` width = `45` depth = `42` height = `22` dim_unit = `cm`
          weight_measure = `23.2` weight_unit = `KG` price = `1499.00` currency_code = `EUR` )
        ( name = `Surround Sound` category = `Speakers` supplier_name = `Speaker Experts` width = `12` depth = `10` height = `16` dim_unit = `cm`
          weight_measure = `3` weight_unit = `KG` price = `39.00` currency_code = `EUR` )
        ( name = `Blaster Extreme` category = `Speakers` supplier_name = `Speaker Experts` width = `13` depth = `11` height = `17.5` dim_unit = `cm`
          weight_measure = `1.4` weight_unit = `KG` price = `26.00` currency_code = `EUR` )
        ( name = `Sound Booster` category = `Speakers` supplier_name = `Speaker Experts` width = `12.4` depth = `10.4` height = `18.1` dim_unit = `cm`
          weight_measure = `2.1` weight_unit = `KG` price = `45.00` currency_code = `EUR` )
        ( name = `Lovely Sound 5.1 Wireless` category = `Accessories` supplier_name = `Fasttech` width = `24` depth = `19` height = `23` dim_unit = `cm`
          weight_measure = `80` weight_unit = `G` price = `49.00` currency_code = `EUR` )
        ( name = `Lovely Sound 5.1` category = `Accessories` supplier_name = `Fasttech` width = `25` depth = `17` height = `19` dim_unit = `cm`
          weight_measure = `130` weight_unit = `G` price = `39.00` currency_code = `EUR` )
        ( name = `Lovely Sound Stereo` category = `Accessories` supplier_name = `Fasttech` width = `21.3` depth = `2.4` height = `19.7` dim_unit = `cm`
          weight_measure = `60` weight_unit = `G` price = `29.00` currency_code = `EUR` )
        ( name = `Smart Office` category = `Software` supplier_name = `Technocom` width = `15` depth = `6.5` height = `2.1` dim_unit = `cm`
          weight_measure = `1.2` weight_unit = `KG` price = `89.90` currency_code = `EUR` )
        ( name = `Smart Design` category = `Software` supplier_name = `Technocom` width = `14` depth = `6.7` height = `24` dim_unit = `cm`
          weight_measure = `0.8` weight_unit = `KG` price = `79.90` currency_code = `EUR` )
        ( name = `Smart Network` category = `Software` supplier_name = `Technocom` width = `16` depth = `6` height = `27` dim_unit = `cm`
          weight_measure = `0.8` weight_unit = `KG` price = `69.00` currency_code = `EUR` )
        ( name = `Smart Multimedia` category = `Software` supplier_name = `Technocom` width = `11` depth = `3.4` height = `22` dim_unit = `cm`
          weight_measure = `0.8` weight_unit = `KG` price = `77.00` currency_code = `EUR` )
        ( name = `Smart Games` category = `Software` supplier_name = `Technocom` width = `10` depth = `3` height = `30` dim_unit = `cm`
          weight_measure = `1.1` weight_unit = `KG` price = `55.00` currency_code = `EUR` )
        ( name = `Smart Internet Antivirus` category = `Software` supplier_name = `Brainsoft` width = `16` depth = `4` height = `21` dim_unit = `cm`
          weight_measure = `0.7` weight_unit = `KG` price = `29.00` currency_code = `EUR` )
        ( name = `Smart Firewall` category = `Software` supplier_name = `Brainsoft` width = `17.9` depth = `4.2` height = `23.1` dim_unit = `cm`
          weight_measure = `0.9` weight_unit = `KG` price = `34.00` currency_code = `EUR` )
        ( name = `Smart Money` category = `Software` supplier_name = `Brainsoft` width = `12` depth = `1.5` height = `19` dim_unit = `cm`
          weight_measure = `0.5` weight_unit = `KG` price = `29.90` currency_code = `EUR` )
        ( name = `PC Lock` category = `Computer System Accessories` supplier_name = `Red Point Stores` width = `20` depth = `8` height = `4.3` dim_unit = `cm`
          weight_measure = `0.03` weight_unit = `KG` price = `8.90` currency_code = `EUR` )
        ( name = `Notebook Lock` category = `Computer System Accessories` supplier_name = `Red Point Stores` width = `31` depth = `9` height = `7` dim_unit = `cm`
          weight_measure = `0.02` weight_unit = `KG` price = `6.90` currency_code = `EUR` )
        ( name = `Web cam reality` category = `Computer System Accessories` supplier_name = `Red Point Stores` width = `9` depth = `8.2` height = `1.3` dim_unit = `cm`
          weight_measure = `0.075` weight_unit = `KG` price = `39.00` currency_code = `EUR` )
        ( name = `Screen clean` category = `Computer System Accessories` supplier_name = `Red Point Stores` width = `2` depth = `2` height = `0.1` dim_unit = `cm`
          weight_measure = `0.05` weight_unit = `KG` price = `2.30` currency_code = `EUR` )
        ( name = `Fabric bag professional` category = `Computer System Accessories` supplier_name = `Red Point Stores` width = `42` depth = `32` height = `7` dim_unit = `cm`
          weight_measure = `1.8` weight_unit = `KG` price = `31.00` currency_code = `EUR` )
        ( name = `Wireless DSL Router` category = `Telecommunications` supplier_name = `Red Point Stores` width = `19.3` depth = `18` height = `5` dim_unit = `cm`
          weight_measure = `0.45` weight_unit = `KG` price = `49.00` currency_code = `EUR` )
        ( name = `Wireless DSL Router / Repeater` category = `Telecommunications` supplier_name = `Red Point Stores` width = `19.3` depth = `18` height = `5` dim_unit = `cm`
          weight_measure = `0.45` weight_unit = `KG` price = `59.00` currency_code = `EUR` )
        ( name = `Wireless DSL Router / Repeater and Print Server` category = `Telecommunications` supplier_name = `Technocom` width = `19.3` depth = `18` height = `5` dim_unit = `cm`
          weight_measure = `0.45` weight_unit = `KG` price = `69.00` currency_code = `EUR` )
        ( name = `USB Stick` category = `Computer System Accessories` supplier_name = `Technocom` width = `1.5` depth = `8.7` height = `1.2` dim_unit = `cm`
          weight_measure = `0.015` weight_unit = `KG` price = `35.00` currency_code = `EUR` )
        ( name = `Travel Adapter` category = `Accessories` supplier_name = `Titanium` width = `2` depth = `3.1` height = `3.9` dim_unit = `cm`
          weight_measure = `88` weight_unit = `G` price = `79.00` currency_code = `EUR` )
        ( name = `Cordless Bluetooth Keyboard, english international` category = `Keyboards` supplier_name = `Technocom` width = `51.4` depth = `23` height = `4` dim_unit = `cm`
          weight_measure = `1` weight_unit = `KG` price = `29.00` currency_code = `EUR` )
        ( name = `Flat XXL` category = `Flat Screen Monitors` supplier_name = `Technocom` width = `54` depth = `22` height = `38` dim_unit = `cm`
          weight_measure = `18` weight_unit = `KG` price = `1430.00` currency_code = `EUR` )
        ( name = `Pocket Mouse` category = `Mice` supplier_name = `Technocom` width = `0.3` depth = `0.5` height = `1` dim_unit = `cm`
          weight_measure = `0.02` weight_unit = `KG` price = `23.00` currency_code = `EUR` )
        ( name = `PC Power Station` category = `PCs` supplier_name = `Technocom` width = `28` depth = `31` height = `43` dim_unit = `cm`
          weight_measure = `2.3` weight_unit = `KG` price = `2399.00` currency_code = `EUR` )
        ( name = `Astro Laptop 1516` category = `Laptops` supplier_name = `Ultrasonic United` width = `30` depth = `18` height = `3` dim_unit = `cm`
          weight_measure = `4.2` weight_unit = `KG` price = `989.00` currency_code = `EUR` )
        ( name = `Astro Phone 6` category = `Smartphones and Tablets` supplier_name = `Ultrasonic United` width = `8` depth = `6` height = `1.5` dim_unit = `cm`
          weight_measure = `0.75` weight_unit = `KG` price = `649.00` currency_code = `EUR` )
        ( name = `Benda Laptop 1408` category = `Laptops` supplier_name = `Ultrasonic United` width = `30` depth = `18` height = `3` dim_unit = `cm`
          weight_measure = `4.2` weight_unit = `KG` price = `976.00` currency_code = `EUR` )
        ( name = `Bending Screen 21HD` category = `Flat Screens` supplier_name = `Ultrasonic United` width = `37` depth = `12` height = `36` dim_unit = `cm`
          weight_measure = `15` weight_unit = `KG` price = `250.00` currency_code = `EUR` )
        ( name = `Broad Screen 22HD` category = `Flat Screens` supplier_name = `Ultrasonic United` width = `39` depth = `12` height = `38` dim_unit = `cm`
          weight_measure = `16` weight_unit = `KG` price = `270.00` currency_code = `EUR` )
        ( name = `Cerdik Phone 7` category = `Smartphones and Tablets` supplier_name = `Ultrasonic United` width = `9` depth = `15` height = `1.5` dim_unit = `cm`
          weight_measure = `0.75` weight_unit = `KG` price = `549.00` currency_code = `EUR` )
        ( name = `Cepat Tablet 10.5` category = `Smartphones and Tablets` supplier_name = `Ultrasonic United` width = `48` depth = `31` height = `4.5` dim_unit = `cm`
          weight_measure = `2.8` weight_unit = `KG` price = `549.00` currency_code = `EUR` )
        ( name = `Cepat Tablet 8` category = `Smartphones and Tablets` supplier_name = `Ultrasonic United` width = `38` depth = `21` height = `3.5` dim_unit = `cm`
          weight_measure = `2.5` weight_unit = `KG` price = `529.00` currency_code = `EUR` )
        ( name = `Server Basic` category = `Servers` supplier_name = `Technocom` width = `34` depth = `35` height = `23` dim_unit = `cm`
          weight_measure = `18` weight_unit = `KG` price = `5000.00` currency_code = `EUR` )
        ( name = `Server Professional` category = `Servers` supplier_name = `Technocom` width = `29` depth = `30` height = `27` dim_unit = `cm`
          weight_measure = `25` weight_unit = `KG` price = `15000.00` currency_code = `EUR` )
        ( name = `Server Power Pro` category = `Servers` supplier_name = `Technocom` width = `22` depth = `27.3` height = `37` dim_unit = `cm`
          weight_measure = `35` weight_unit = `KG` price = `25000.00` currency_code = `EUR` )
        ( name = `Family PC Basic` category = `Desktop Computers` supplier_name = `Titanium` width = `21.4` depth = `29` height = `38` dim_unit = `cm`
          weight_measure = `4.8` weight_unit = `KG` price = `600.00` currency_code = `EUR` )
        ( name = `Family PC Pro` category = `Desktop Computers` supplier_name = `Titanium` width = `25` depth = `31.7` height = `40.2` dim_unit = `cm`
          weight_measure = `5.3` weight_unit = `KG` price = `900.00` currency_code = `EUR` )
        ( name = `Gaming Monster` category = `Desktop Computers` supplier_name = `Titanium` width = `26.5` depth = `34` height = `47` dim_unit = `cm`
          weight_measure = `5.9` weight_unit = `KG` price = `1200.00` currency_code = `EUR` )
        ( name = `Gaming Monster Pro` category = `Desktop Computers` supplier_name = `Titanium` width = `27` depth = `28` height = `42` dim_unit = `cm`
          weight_measure = `6.8` weight_unit = `KG` price = `1700.00` currency_code = `EUR` )
        ( name = `7" Widescreen Portable DVD Player w MP3` category = `Accessories` supplier_name = `Titanium` width = `21.4` depth = `19` height = `27.6` dim_unit = `cm`
          weight_measure = `0.79` weight_unit = `KG` price = `249.99` currency_code = `EUR` )
        ( name = `10" Portable DVD player` category = `Accessories` supplier_name = `Titanium` width = `24` depth = `19.5` height = `29` dim_unit = `cm`
          weight_measure = `0.84` weight_unit = `KG` price = `449.99` currency_code = `EUR` )
        ( name = `Portable DVD Player with 9" LCD Monitor` category = `Accessories` supplier_name = `Technocom` width = `21` depth = `16.5` height = `14` dim_unit = `cm`
          weight_measure = `0.72` weight_unit = `KG` price = `853.99` currency_code = `EUR` )
        ( name = `CD/DVD case: 264 sleeves` category = `Accessories` supplier_name = `Titanium` width = `13` depth = `13` height = `20` dim_unit = `cm`
          weight_measure = `0.65` weight_unit = `KG` price = `44.99` currency_code = `EUR` )
        ( name = `Audio/Video Cable Kit - 4m` category = `Accessories` supplier_name = `Titanium` width = `21` depth = `10.2` height = `13` dim_unit = `cm`
          weight_measure = `0.2` weight_unit = `KG` price = `29.99` currency_code = `EUR` )
        ( name = `Removable CD/DVD Laser Labels` category = `Accessories` supplier_name = `Titanium` width = `5.5` depth = `2` height = `2` dim_unit = `cm`
          weight_measure = `0.15` weight_unit = `KG` price = `8.99` currency_code = `EUR` )
        ( name = `Beam Breaker B-1` category = `Accessories` supplier_name = `Titanium` width = `30.4` depth = `23.1` height = `23` dim_unit = `cm`
          weight_measure = `1.7` weight_unit = `KG` price = `469.00` currency_code = `EUR` )
        ( name = `Beam Breaker B-2` category = `Accessories` supplier_name = `Technocom` width = `30.4` depth = `23.1` height = `23` dim_unit = `cm`
          weight_measure = `2` weight_unit = `KG` price = `679.00` currency_code = `EUR` )
        ( name = `Beam Breaker B-3` category = `Accessories` supplier_name = `Technocom` width = `30.4` depth = `23.1` height = `23` dim_unit = `cm`
          weight_measure = `2.5` weight_unit = `KG` price = `889.00` currency_code = `EUR` )
        ( name = `Play Movie` category = `Accessories` supplier_name = `Fasttech` width = `37` depth = `24` height = `6` dim_unit = `cm`
          weight_measure = `2.4` weight_unit = `KG` price = `130.00` currency_code = `EUR` )
        ( name = `Record Movie` category = `Accessories` supplier_name = `Fasttech` width = `38` depth = `26` height = `6.2` dim_unit = `cm`
          weight_measure = `3.1` weight_unit = `KG` price = `288.00` currency_code = `EUR` )
        ( name = `ITelo MusicStick` category = `Accessories` supplier_name = `Fasttech` width = `1.5` depth = `6` height = `1` dim_unit = `cm`
          weight_measure = `134` weight_unit = `G` price = `45.00` currency_code = `EUR` )
        ( name = `ITelo Jog-Mate` category = `Accessories` supplier_name = `Fasttech` width = `5.1` depth = `8` height = `9.2` dim_unit = `cm`
          weight_measure = `134` weight_unit = `G` price = `63.00` currency_code = `EUR` )
        ( name = `Power Pro Player 40` category = `Accessories` supplier_name = `Fasttech` width = `5.1` depth = `8` height = `9.2` dim_unit = `cm`
          weight_measure = `266` weight_unit = `G` price = `167.00` currency_code = `EUR` )
        ( name = `Power Pro Player 80` category = `Accessories` supplier_name = `Fasttech` width = `4` depth = `6` height = `0.8` dim_unit = `cm`
          weight_measure = `267` weight_unit = `G` price = `299.00` currency_code = `EUR` )
        ( name = `Flat Watch HD32` category = `Flat Screen TVs` supplier_name = `Very Best Screens` width = `78` depth = `22.1` height = `55` dim_unit = `cm`
          weight_measure = `2.6` weight_unit = `KG` price = `1459.00` currency_code = `EUR` )
        ( name = `Flat Watch HD37` category = `Flat Screen TVs` supplier_name = `Very Best Screens` width = `99.1` depth = `26` height = `61` dim_unit = `cm`
          weight_measure = `2.2` weight_unit = `KG` price = `1199.00` currency_code = `EUR` )
        ( name = `Flat Watch HD41` category = `Flat Screen TVs` supplier_name = `Very Best Screens` width = `128` depth = `23` height = `79.1` dim_unit = `cm`
          weight_measure = `1.8` weight_unit = `KG` price = `899.00` currency_code = `EUR` )
        ( name = `Copperberry` category = `Accessories` supplier_name = `Fasttech` width = `8.1` depth = `13` height = `12.1` dim_unit = `cm`
          weight_measure = `0.5` weight_unit = `KG` price = `549.00` currency_code = `EUR` )
        ( name = `Silverberry` category = `Accessories` supplier_name = `Fasttech` width = `8.1` depth = `13` height = `12.1` dim_unit = `cm`
          weight_measure = `0.5` weight_unit = `KG` price = `549.00` currency_code = `EUR` )
        ( name = `Goldberry` category = `Accessories` supplier_name = `Fasttech` width = `8.1` depth = `13` height = `12.1` dim_unit = `cm`
          weight_measure = `0.5` weight_unit = `KG` price = `549.00` currency_code = `EUR` )
        ( name = `Platinberry` category = `Accessories` supplier_name = `Fasttech` width = `8.1` depth = `13` height = `12.1` dim_unit = `cm`
          weight_measure = `0.5` weight_unit = `KG` price = `549.00` currency_code = `EUR` )
        ( name = `ITelO FlexTop I4000` category = `Laptops` supplier_name = `Titanium` width = `31` depth = `19` height = `3.1` dim_unit = `cm`
          weight_measure = `4` weight_unit = `KG` price = `799.00` currency_code = `EUR` )
        ( name = `ITelO FlexTop I6300c` category = `Laptops` supplier_name = `Titanium` width = `32` depth = `20` height = `3.4` dim_unit = `cm`
          weight_measure = `4.2` weight_unit = `KG` price = `799.00` currency_code = `EUR` )
        ( name = `ITelO FlexTop I9100` category = `Laptops` supplier_name = `Titanium` width = `38` depth = `21` height = `4.1` dim_unit = `cm`
          weight_measure = `3.5` weight_unit = `KG` price = `1199.00` currency_code = `EUR` )
        ( name = `ITelO FlexTop I9800` category = `Laptops` supplier_name = `Titanium` width = `48` depth = `31` height = `4.5` dim_unit = `cm`
          weight_measure = `3.8` weight_unit = `KG` price = `1388.00` currency_code = `EUR` )
        ( name = `Smartphone Leather Case` category = `Accessories` supplier_name = `Ultrasonic United` width = `48` depth = `31` height = `4.5` dim_unit = `cm`
          weight_measure = `0.02` weight_unit = `KG` price = `25.00` currency_code = `EUR` )
        ( name = `Smartphone Alpha` category = `Smartphones and Tablets` supplier_name = `Ultrasonic United` width = `48` depth = `31` height = `4.5` dim_unit = `cm`
          weight_measure = `0.75` weight_unit = `KG` price = `599.00` currency_code = `EUR` )
        ( name = `Mini Tablet` category = `Smartphones and Tablets` supplier_name = `Ultrasonic United` width = `48` depth = `31` height = `4.5` dim_unit = `cm`
          weight_measure = `3.8` weight_unit = `KG` price = `833.00` currency_code = `EUR` )
        ( name = `Camcorder View` category = `Accessories` supplier_name = `Ultrasonic United` width = `48` depth = `31` height = `27` dim_unit = `cm`
          weight_measure = `3.8` weight_unit = `KG` price = `1388.00` currency_code = `EUR` )
        ( name = `Tablet Pouch` category = `Accessories` supplier_name = `Titanium` width = `25` depth = `40` height = `4.5` dim_unit = `cm`
          weight_measure = `0.03` weight_unit = `KG` price = `20.00` currency_code = `EUR` )
        ( name = `Tablet Pouch` category = `Accessories` supplier_name = `Titanium` width = `25` depth = `40` height = `4.5` dim_unit = `cm`
          weight_measure = `0.03` weight_unit = `KG` price = `20.00` currency_code = `EUR` )
        ( name = `e-Book Reader ReadMe` category = `Smartphones and Tablets` supplier_name = `Titanium` width = `48` depth = `31` height = `4.5` dim_unit = `cm`
          weight_measure = `3.8` weight_unit = `KG` price = `33.00` currency_code = `EUR` )
        ( name = `Smartphone Beta` category = `Smartphones and Tablets` supplier_name = `Titanium` width = `48` depth = `31` height = `4.5` dim_unit = `cm`
          weight_measure = `0.75` weight_unit = `KG` price = `30.00` currency_code = `EUR` )
        ( name = `Maxi Tablet` category = `Tablets` supplier_name = `Titanium` width = `48` depth = `31` height = `4.5` dim_unit = `cm`
          weight_measure = `3.8` weight_unit = `KG` price = `749.00` currency_code = `EUR` )
        ( name = `Flyer` category = `Accessories` supplier_name = `Titanium` width = `46` depth = `30` height = `3` dim_unit = `cm`
          weight_measure = `0.01` weight_unit = `KG` price = `0.00` currency_code = `EUR` ) ).

    " Facet values with the precomputed counters from the mock /ProductCollectionStats/Filters (1:1, as the original binds them)
    t_categories = VALUE #(
        ( text = `Accessories` count = 34 )
        ( text = `Desktop Computers` count = 7 )
        ( text = `Flat Screens` count = 2 )
        ( text = `Keyboards` count = 4 )
        ( text = `Laptops` count = 11 )
        ( text = `Printers` count = 9 )
        ( text = `Smartphones and Tablets` count = 9 )
        ( text = `Mice` count = 7 )
        ( text = `Computer System Accessories` count = 8 )
        ( text = `Graphics Card` count = 4 )
        ( text = `Scanners` count = 4 )
        ( text = `Speakers` count = 3 )
        ( text = `Software` count = 8 )
        ( text = `Telekommunikation` count = 3 )
        ( text = `Servers` count = 3 )
        ( text = `Flat Screen TVs` count = 3 ) ).
    t_suppliers = VALUE #(
        ( text = `Titanium` count = 21 )
        ( text = `Technocom` count = 22 )
        ( text = `Red Point Stores` count = 7 )
        ( text = `Very Best Screens` count = 14 )
        ( text = `Smartcards` count = 2 )
        ( text = `Alpha Printers` count = 5 )
        ( text = `Printer for All` count = 8 )
        ( text = `Oxynum` count = 8 )
        ( text = `Fasttech` count = 15 )
        ( text = `Ultrasonic United` count = 15 )
        ( text = `Speaker Experts` count = 3 )
        ( text = `Brainsoft` count = 3 ) ).

  ENDMETHOD.

ENDCLASS.
