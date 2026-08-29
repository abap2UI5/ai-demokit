" @keywords facetfilter facet filter sap.m facetfiltersimple vbox facetfilterlist facetfilteritem table overflowtoolbar title toolbarspacer
" @summary With the Facet Filter you can offer multiple filters ('facets') to assist the user in narrowing down the data in, say, a table. With this default 'Simple' type, each filter is displayed in a row for selection.
CLASS z2ui5_cl_smpc_app_235 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name          TYPE string,
        category      TYPE string,
        suppliername  TYPE string,
        width         TYPE string,
        depth         TYPE string,
        height        TYPE string,
        dimunit       TYPE string,
        weightmeasure TYPE string,
        weightunit    TYPE string,
        weight_state  TYPE string,
        price         TYPE p LENGTH 14 DECIMALS 2,
        currencycode  TYPE string,
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
    DATA t_sticky            TYPE STANDARD TABLE OF string WITH EMPTY KEY.
    DATA t_categories        TYPE ty_t_facet.
    DATA t_suppliers         TYPE ty_t_facet.
    DATA popin_layout        TYPE string.
    DATA info_toolbar_hidden TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    " the compound filter the LIVE items binding was last given, so a rebuilt
    " view can be handed exactly the same one again (see view_display). Empty
    " until the user has filtered once, which is the guard. PROTECTED, not
    " PUBLIC: it is bookkeeping and not model data, and only PUBLIC attributes
    " are serialized into the view model - and not PRIVATE, because the draft
    " serialization walks the attributes with a dynamic ASSIGN obj->(name)
    " that cannot reach a PRIVATE one
    DATA filter_live TYPE string.

    METHODS view_display.
    METHODS on_event.
    METHODS apply_filter.
    METHODS filter_issue.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_235 IMPLEMENTATION.

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

    " bound lists collection unrolled into two static facet filter lists; the appended demo table of sap.m.sample.Table is rebuilt inline
    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->ele( `VBox`
            )->a( n = `id` v = `idVBox`

            )->ele( `FacetFilter`
                )->a( n = `id`                  v = `idFacetFilter`
                )->a( n = `type`                v = `Simple`
                )->a( n = `showPersonalization` v = `true`
                )->a( n = `showReset`           v = `true`
                )->a( n = `reset`               v = client->_event( `RESET` )
                )->a( n = `confirm`             v = client->_event( `CONFIRM` )

                " each item binds selected two-way - confirm signals the backend to read the flags and filter
                )->ele( `FacetFilterList`
                    )->a( n = `title` v = `Category`
                    )->a( n = `key`   v = `Category`
                    )->a( n = `mode`  v = `MultiSelect`
                    )->a( n = `items` v = client->_bind( t_categories )

                    )->tag( `FacetFilterItem`
                        )->a( n = `text`     v = `{TEXT}`
                        )->a( n = `key`      v = `{TEXT}`
                        )->a( n = `counter`  v = `{COUNT}`
                        )->a( n = `selected` v = `{SELECTED}`

                )->end(
                )->ele( `FacetFilterList`
                    )->a( n = `title` v = `SupplierName`
                    )->a( n = `key`   v = `SupplierName`
                    )->a( n = `mode`  v = `MultiSelect`
                    )->a( n = `items` v = client->_bind( t_suppliers )

                    )->tag( `FacetFilterItem`
                        )->a( n = `text`     v = `{TEXT}`
                        )->a( n = `key`      v = `{TEXT}`
                        )->a( n = `counter`  v = `{COUNT}`
                        )->a( n = `selected` v = `{SELECTED}`

                )->end(
            )->end(
            )->ele( `Table`
                )->a( n = `id`          v = `idProductsTable`
                )->a( n = `sticky`      v = client->_bind( t_sticky )
                )->a( n = `inset`       v = `false`
                " popinLayout mirrors the original's setPopinLayout controller switch - an empty ComboBox selection maps to the Block default
                )->a( n = `popinLayout` v = |\{= ${ client->_bind( popin_layout ) } \|\| 'Block' \}|
                )->a( n = `items`       v = |\{ path: '{ client->_bind_path( t_products ) }', sorter: \{ path: 'NAME' \} \}|

                )->ele( `headerToolbar`
                    )->ele( `OverflowToolbar`
                        )->tag( `Title`
                            )->a( n = `text`  v = `Products`
                            )->a( n = `level` v = `H2`
                        )->tag( `ToolbarSpacer`

                        )->ele( `ComboBox`
                            )->a( n = `id`          v = `idPopinLayout`
                            )->a( n = `placeholder` v = `Popin layout options`
                            " two-way selectedKey replaces the original's change handler (a pure key-to-property pass-through)
                            )->a( n = `selectedKey` v = client->_bind( popin_layout )

                            )->ele( `items`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `text` v = `Block`
                                    )->a( n = `key`  v = `Block`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `text` v = `Grid Large`
                                    )->a( n = `key`  v = `GridLarge`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `text` v = `Grid Small`
                                    )->a( n = `key`  v = `GridSmall`

                            )->end(
                        )->end(
                        " the sticky options: Table.sticky is an ARRAY property, bound here to a
                        " string table and maintained in the backend - the app-009 pattern
                        )->tag( `Label`
                            )->a( n = `text` v = `Sticky options:`
                        )->tag( `CheckBox`
                            )->a( n = `text`   v = `ColumnHeaders`
                            )->a( n = `select` v = client->_event( val   = `STICKY_SELECT`
                                                                   t_arg = VALUE #( ( `${$source>/text}` ) ( `${$parameters>/selected}` ) ) )
                        )->tag( `CheckBox`
                            )->a( n = `text`   v = `HeaderToolbar`
                            )->a( n = `select` v = client->_event( val   = `STICKY_SELECT`
                                                                   t_arg = VALUE #( ( `${$source>/text}` ) ( `${$parameters>/selected}` ) ) )
                        )->tag( `CheckBox`
                            )->a( n = `text`   v = `InfoToolbar`
                            )->a( n = `select` v = client->_event( val   = `STICKY_SELECT`
                                                                   t_arg = VALUE #( ( `${$source>/text}` ) ( `${$parameters>/selected}` ) ) )
                        )->tag( `ToggleButton`
                            )->a( n = `id`      v = `toggleInfoToolbar`
                            )->a( n = `text`    v = `Hide/Show InfoToolbar`
                            " two-way pressed replaces the original's press handler - the infoToolbar visibility is a pure expression over it
                            )->a( n = `pressed` v = client->_bind( info_toolbar_hidden )

                    )->end(
                )->end(
                )->ele( `infoToolbar`
                    )->ele( `OverflowToolbar`
                        )->a( n = `visible` v = |\{= !${ client->_bind( info_toolbar_hidden ) } \}|

                        )->tag( `Label`
                            )->a( n = `text` v = `Wide range of available products`

                    )->end(
                )->end(
                )->ele( `columns`
                    )->ele( `Column`
                        )->a( n = `width` v = `12em`

                        )->tag( `Text`
                            )->a( n = `text` v = `Product`

                    )->end(
                    )->ele( `Column`
                        )->a( n = `minScreenWidth` v = `Tablet`
                        )->a( n = `demandPopin`    v = `true`

                        )->tag( `Text`
                            )->a( n = `text` v = `Supplier`

                    )->end(
                    )->ele( `Column`
                        )->a( n = `minScreenWidth` v = `Desktop`
                        )->a( n = `demandPopin`    v = `true`
                        )->a( n = `hAlign`         v = `End`

                        )->tag( `Text`
                            )->a( n = `text` v = `Dimensions`

                    )->end(
                    )->ele( `Column`
                        )->a( n = `minScreenWidth` v = `Desktop`
                        )->a( n = `demandPopin`    v = `true`
                        )->a( n = `hAlign`         v = `Center`

                        )->tag( `Text`
                            )->a( n = `text` v = `Weight`

                    )->end(
                    )->ele( `Column`
                        )->a( n = `hAlign` v = `End`

                        )->tag( `Text`
                            )->a( n = `text` v = `Price`

                    )->end(
                )->end(
                )->ele( `items`
                    )->ele( `ColumnListItem`
                        )->a( n = `vAlign` v = `Middle`

                        )->ele( `cells`
                            )->tag( `ObjectIdentifier`
                                )->a( n = `title` v = `{NAME}`
                                )->a( n = `text`  v = `{CATEGORY}`
                            )->tag( `Text`
                                )->a( n = `text` v = `{SUPPLIERNAME}`
                            )->tag( `Text`
                                )->a( n = `text` v = `{WIDTH} x {DEPTH} x {HEIGHT} {DIMUNIT}`
                            )->tag( `ObjectNumber`
                                )->a( n = `number` v = `{WEIGHTMEASURE}`
                                )->a( n = `unit`   v = `{WEIGHTUNIT}`
                                )->a( n = `state`  v = `{WEIGHT_STATE}`
                            )->tag( `ObjectNumber`
                                )->a( n = `number` v = |\{ parts:[\{path:'PRICE'\},\{path:'CURRENCYCODE'\}], type:'sap.ui.model.type.Currency', formatOptions:\{showMeasure:false\} \}|
                                )->a( n = `unit`   v = `{CURRENCYCODE}` ).

    client->view_display( view->stringify( ) ).

    " A rebuilt view creates a FRESH items binding whose aFilters is empty, so
    " the client-side filter is gone - while the two-way bound selected flags
    " of t_categories/t_suppliers are class state that survives. Without this
    " the FacetFilter comes back claiming a selection the table does not show.
    " check_on_navigated( ) takes exactly this path: measured on the
    " framework's own bookmark restore
    " (?app_start=<class>#/z2ui5-xapp-state=<draft>, the URL
    " cs_event-clipboard_app_state hands out) - 34 filtered rows before,
    " 123 unfiltered rows and the facet still reading Accessories after.
    " Re-issuing the SAME payload is the app-000 idiom; statement order does
    " not matter, the frontend awaits every T_SYSTEM display before it runs a
    " T_CUSTOM follow-up
    IF filter_live IS NOT INITIAL.
      filter_issue( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `STICKY_SELECT`.
        " onSelect: the controller maintains an array of sap.m.Sticky keys and
        " calls oTable.setSticky( ). The array is a bound string table here (the
        " app-009 pattern, live-verified there): the CheckBox round-trips its own
        " text and the selected flag, the backend keeps the set
        DATA(sticky_text) = client->get_event_arg( ).
        DATA(sticky_on) = CONV abap_bool( client->get_event_arg( 2 ) ).
        IF sticky_on = abap_true.
          INSERT sticky_text INTO TABLE t_sticky.
        ELSE.
          DELETE t_sticky WHERE table_line = sticky_text.
        ENDIF.

      WHEN `RESET`.
        " like handleFacetFilterReset: clear the two-way bound selection flags and re-filter
        LOOP AT t_categories ASSIGNING FIELD-SYMBOL(<category>).
          <category>-selected = abap_false.
        ENDLOOP.
        LOOP AT t_suppliers ASSIGNING FIELD-SYMBOL(<supplier>).
          <supplier>-selected = abap_false.
        ENDLOOP.
        apply_filter( ).

      WHEN `CONFIRM`.
        " like handleConfirm: build the compound filter from the selected flags, then toast
        apply_filter( ).
        client->message_toast_display( `confirm event fired` ).

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
      rows_supplier = rows_supplier && |["SUPPLIERNAME","EQ","{ supplier-text }"]|.
    ENDLOOP.

    filter_live = `[`.
    IF rows_category IS NOT INITIAL.
      filter_live = filter_live && |[{ rows_category }]|.
    ENDIF.
    IF rows_supplier IS NOT INITIAL.
      IF rows_category IS NOT INITIAL.
        filter_live = filter_live && `,`.
      ENDIF.
      filter_live = filter_live && |[{ rows_supplier }]|.
    ENDIF.
    filter_live = filter_live && `]`.

    filter_issue( ).

  ENDMETHOD.


  METHOD filter_issue.

    " like _filterModel (ORs inside a group, AND across the groups) - declarative compound filter on the items binding, model untouched.
    " Issued from apply_filter( ) and again from view_display( ), because the filter lives on the binding and not in the model
    client->follow_up_action( val   = client->cs_event-binding_call
                              t_arg = VALUE #( ( `idProductsTable` ) ( `items` ) ( `filter` ) ( filter_live ) ) ).

  ENDMETHOD.


  METHOD model_init.

    " full mock /ProductCollection (sap/ui/demo/mock/products.json) of the original sample
    t_products = VALUE #(
        ( name = `Notebook Basic 15` category = `Laptops` suppliername = `Very Best Screens` width = `30` depth = `18` height = `3` dimunit = `cm`
          weightmeasure = `4.2` weightunit = `KG` price = `956.00` currencycode = `EUR` )
        ( name = `Notebook Basic 17` category = `Laptops` suppliername = `Very Best Screens` width = `29` depth = `17` height = `3.1` dimunit = `cm`
          weightmeasure = `4.5` weightunit = `KG` price = `1249.00` currencycode = `EUR` )
        ( name = `Notebook Basic 18` category = `Laptops` suppliername = `Very Best Screens` width = `28` depth = `19` height = `2.5` dimunit = `cm`
          weightmeasure = `4.2` weightunit = `KG` price = `1570.00` currencycode = `EUR` )
        ( name = `Notebook Basic 19` category = `Laptops` suppliername = `Smartcards` width = `32` depth = `21` height = `4` dimunit = `cm`
          weightmeasure = `4.2` weightunit = `KG` price = `1650.00` currencycode = `EUR` )
        ( name = `ITelO Vault` category = `Accessories` suppliername = `Technocom` width = `32` depth = `22` height = `3` dimunit = `cm`
          weightmeasure = `0.2` weightunit = `KG` price = `299.00` currencycode = `EUR` )
        ( name = `Notebook Professional 15` category = `Accessories` suppliername = `Very Best Screens` width = `33` depth = `20` height = `3` dimunit = `cm`
          weightmeasure = `4.3` weightunit = `KG` price = `1999.00` currencycode = `EUR` )
        ( name = `Notebook Professional 17` category = `Laptops` suppliername = `Very Best Screens` width = `33` depth = `23` height = `2` dimunit = `cm`
          weightmeasure = `4.1` weightunit = `KG` price = `2299.00` currencycode = `EUR` )
        ( name = `ITelO Vault Net` category = `Accessories` suppliername = `Technocom` width = `10` depth = `1.8` height = `17` dimunit = `cm`
          weightmeasure = `0.16` weightunit = `KG` price = `459.00` currencycode = `EUR` )
        ( name = `ITelO Vault SAT` category = `Accessories` suppliername = `Technocom` width = `11` depth = `1.7` height = `18` dimunit = `cm`
          weightmeasure = `0.18` weightunit = `KG` price = `149.00` currencycode = `EUR` )
        ( name = `Comfort Easy` category = `Accessories` suppliername = `Technocom` width = `84` depth = `1.5` height = `14` dimunit = `cm`
          weightmeasure = `0.2` weightunit = `KG` price = `1679.00` currencycode = `EUR` )
        ( name = `Comfort Senior` category = `Accessories` suppliername = `Technocom` width = `80` depth = `1.6` height = `13` dimunit = `cm`
          weightmeasure = `0.8` weightunit = `KG` price = `512.00` currencycode = `EUR` )
        ( name = `Ergo Screen E-I` category = `Flat Screen Monitors` suppliername = `Very Best Screens` width = `37` depth = `12` height = `36` dimunit = `cm`
          weightmeasure = `21` weightunit = `KG` price = `230.00` currencycode = `EUR` )
        ( name = `Ergo Screen E-II` category = `Flat Screen Monitors` suppliername = `Very Best Screens` width = `40.8` depth = `19` height = `43` dimunit = `cm`
          weightmeasure = `21` weightunit = `KG` price = `285.00` currencycode = `EUR` )
        ( name = `Ergo Screen E-III` category = `Flat Screen Monitors` suppliername = `Very Best Screens` width = `40.8` depth = `19` height = `43` dimunit = `cm`
          weightmeasure = `21` weightunit = `KG` price = `345.00` currencycode = `EUR` )
        ( name = `Flat Basic` category = `Flat Screen Monitors` suppliername = `Very Best Screens` width = `39` depth = `20` height = `41` dimunit = `cm`
          weightmeasure = `14` weightunit = `KG` price = `399.00` currencycode = `EUR` )
        ( name = `Flat Future` category = `Flat Screen Monitors` suppliername = `Very Best Screens` width = `45` depth = `26` height = `46` dimunit = `cm`
          weightmeasure = `15` weightunit = `KG` price = `430.00` currencycode = `EUR` )
        ( name = `Flat XL` category = `Flat Screen Monitors` suppliername = `Very Best Screens` width = `54.5` depth = `22.1` height = `39.1` dimunit = `cm`
          weightmeasure = `17` weightunit = `KG` price = `1230.00` currencycode = `EUR` )
        ( name = `Laser Professional Eco` category = `Printers` suppliername = `Alpha Printers` width = `51` depth = `46` height = `30` dimunit = `cm`
          weightmeasure = `32` weightunit = `KG` price = `830.00` currencycode = `EUR` )
        ( name = `Laser Basic` category = `Printers` suppliername = `Alpha Printers` width = `48` depth = `42` height = `26` dimunit = `cm`
          weightmeasure = `23` weightunit = `KG` price = `490.00` currencycode = `EUR` )
        ( name = `Laser Allround` category = `Printers` suppliername = `Alpha Printers` width = `53` depth = `50` height = `65` dimunit = `cm`
          weightmeasure = `17` weightunit = `KG` price = `349.00` currencycode = `EUR` )
        ( name = `Ultra Jet Super Color` category = `Printers` suppliername = `Alpha Printers` width = `41` depth = `41` height = `28` dimunit = `cm`
          weightmeasure = `3` weightunit = `KG` price = `139.00` currencycode = `EUR` )
        ( name = `Ultra Jet Mobile` category = `Printers` suppliername = `Printer for All` width = `46` depth = `32` height = `25` dimunit = `cm`
          weightmeasure = `1.9` weightunit = `KG` price = `99.00` currencycode = `EUR` )
        ( name = `Ultra Jet Super Highspeed` category = `Printers` suppliername = `Printer for All` width = `41` depth = `41` height = `28` dimunit = `cm`
          weightmeasure = `18` weightunit = `KG` price = `170.00` currencycode = `EUR` )
        ( name = `Multi Print` category = `Multifunction Printers` suppliername = `Printer for All` width = `55` depth = `45` height = `29` dimunit = `cm`
          weightmeasure = `6.3` weightunit = `KG` price = `99.00` currencycode = `EUR` )
        ( name = `Multi Color` category = `Multifunction Printers` suppliername = `Printer for All` width = `51` depth = `41.3` height = `22` dimunit = `cm`
          weightmeasure = `4.3` weightunit = `KG` price = `119.00` currencycode = `EUR` )
        ( name = `Cordless Mouse` category = `Mice` suppliername = `Oxynum` width = `6` depth = `14.5` height = `3.5` dimunit = `cm`
          weightmeasure = `0.09` weightunit = `KG` price = `9.00` currencycode = `EUR` )
        ( name = `Speed Mouse` category = `Mice` suppliername = `Oxynum` width = `7` depth = `15` height = `3.1` dimunit = `cm`
          weightmeasure = `0.09` weightunit = `KG` price = `7.00` currencycode = `EUR` )
        ( name = `Track Mouse` category = `Mice` suppliername = `Oxynum` width = `3` depth = `7` height = `4` dimunit = `cm`
          weightmeasure = `0.03` weightunit = `KG` price = `11.00` currencycode = `EUR` )
        ( name = `Ergonomic Keyboard` category = `Keyboards` suppliername = `Oxynum` width = `50` depth = `21` height = `3.5` dimunit = `cm`
          weightmeasure = `2.1` weightunit = `KG` price = `14.00` currencycode = `EUR` )
        ( name = `Internet Keyboard` category = `Keyboards` suppliername = `Oxynum` width = `52` depth = `25` height = `3` dimunit = `cm`
          weightmeasure = `1.8` weightunit = `KG` price = `16.00` currencycode = `EUR` )
        ( name = `Media Keyboard` category = `Keyboards` suppliername = `Oxynum` width = `51.4` depth = `23` height = `4` dimunit = `cm`
          weightmeasure = `2.3` weightunit = `KG` price = `26.00` currencycode = `EUR` )
        ( name = `Mousepad` category = `Mousepads` suppliername = `Oxynum` width = `15` depth = `6` height = `0.2` dimunit = `cm`
          weightmeasure = `80` weightunit = `G` price = `6.99` currencycode = `EUR` )
        ( name = `Ergo Mousepad` category = `Mousepads` suppliername = `Oxynum` width = `15` depth = `6` height = `0.2` dimunit = `cm`
          weightmeasure = `80` weightunit = `G` price = `8.99` currencycode = `EUR` )
        ( name = `Designer Mousepad` category = `Mousepads` suppliername = `Fasttech` width = `24` depth = `24` height = `0.6` dimunit = `cm`
          weightmeasure = `90` weightunit = `G` price = `12.99` currencycode = `EUR` )
        ( name = `Universal card reader` category = `Computer System Accessories` suppliername = `Fasttech` width = `6` depth = `6` height = `3` dimunit = `cm`
          weightmeasure = `45` weightunit = `G` price = `14.00` currencycode = `EUR` )
        ( name = `Proctra X` category = `Graphic Cards` suppliername = `Ultrasonic United` width = `22` depth = `35` height = `17` dimunit = `cm`
          weightmeasure = `0.255` weightunit = `KG` price = `70.90` currencycode = `EUR` )
        ( name = `Gladiator MX` category = `Graphic Cards` suppliername = `Ultrasonic United` width = `22` depth = `35` height = `17` dimunit = `cm`
          weightmeasure = `0.3` weightunit = `KG` price = `81.70` currencycode = `EUR` )
        ( name = `Hurricane GX` category = `Graphic Cards` suppliername = `Ultrasonic United` width = `22` depth = `35` height = `17` dimunit = `cm`
          weightmeasure = `0.4` weightunit = `KG` price = `101.20` currencycode = `EUR` )
        ( name = `Hurricane GX/LN` category = `Graphic Cards` suppliername = `Smartcards` width = `22` depth = `35` height = `17` dimunit = `cm`
          weightmeasure = `0.4` weightunit = `KG` price = `139.99` currencycode = `EUR` )
        ( name = `Photo Scan` category = `Scanners` suppliername = `Printer for All` width = `34` depth = `48` height = `5` dimunit = `cm`
          weightmeasure = `2.3` weightunit = `KG` price = `129.00` currencycode = `EUR` )
        ( name = `Power Scan` category = `Scanners` suppliername = `Printer for All` width = `31` depth = `43` height = `7` dimunit = `cm`
          weightmeasure = `2.4` weightunit = `KG` price = `89.00` currencycode = `EUR` )
        ( name = `Jet Scan Professional` category = `Scanners` suppliername = `Printer for All` width = `33` depth = `41` height = `12` dimunit = `cm`
          weightmeasure = `3.2` weightunit = `KG` price = `169.00` currencycode = `EUR` )
        ( name = `Jet Scan Professional` category = `Scanners` suppliername = `Printer for All` width = `35` depth = `40` height = `10` dimunit = `cm`
          weightmeasure = `3.2` weightunit = `KG` price = `189.00` currencycode = `EUR` )
        ( name = `Copymaster` category = `Multifunction Printers` suppliername = `Alpha Printers` width = `45` depth = `42` height = `22` dimunit = `cm`
          weightmeasure = `23.2` weightunit = `KG` price = `1499.00` currencycode = `EUR` )
        ( name = `Surround Sound` category = `Speakers` suppliername = `Speaker Experts` width = `12` depth = `10` height = `16` dimunit = `cm`
          weightmeasure = `3` weightunit = `KG` price = `39.00` currencycode = `EUR` )
        ( name = `Blaster Extreme` category = `Speakers` suppliername = `Speaker Experts` width = `13` depth = `11` height = `17.5` dimunit = `cm`
          weightmeasure = `1.4` weightunit = `KG` price = `26.00` currencycode = `EUR` )
        ( name = `Sound Booster` category = `Speakers` suppliername = `Speaker Experts` width = `12.4` depth = `10.4` height = `18.1` dimunit = `cm`
          weightmeasure = `2.1` weightunit = `KG` price = `45.00` currencycode = `EUR` )
        ( name = `Lovely Sound 5.1 Wireless` category = `Accessories` suppliername = `Fasttech` width = `24` depth = `19` height = `23` dimunit = `cm`
          weightmeasure = `80` weightunit = `G` price = `49.00` currencycode = `EUR` )
        ( name = `Lovely Sound 5.1` category = `Accessories` suppliername = `Fasttech` width = `25` depth = `17` height = `19` dimunit = `cm`
          weightmeasure = `130` weightunit = `G` price = `39.00` currencycode = `EUR` )
        ( name = `Lovely Sound Stereo` category = `Accessories` suppliername = `Fasttech` width = `21.3` depth = `2.4` height = `19.7` dimunit = `cm`
          weightmeasure = `60` weightunit = `G` price = `29.00` currencycode = `EUR` )
        ( name = `Smart Office` category = `Software` suppliername = `Technocom` width = `15` depth = `6.5` height = `2.1` dimunit = `cm`
          weightmeasure = `1.2` weightunit = `KG` price = `89.90` currencycode = `EUR` )
        ( name = `Smart Design` category = `Software` suppliername = `Technocom` width = `14` depth = `6.7` height = `24` dimunit = `cm`
          weightmeasure = `0.8` weightunit = `KG` price = `79.90` currencycode = `EUR` )
        ( name = `Smart Network` category = `Software` suppliername = `Technocom` width = `16` depth = `6` height = `27` dimunit = `cm`
          weightmeasure = `0.8` weightunit = `KG` price = `69.00` currencycode = `EUR` )
        ( name = `Smart Multimedia` category = `Software` suppliername = `Technocom` width = `11` depth = `3.4` height = `22` dimunit = `cm`
          weightmeasure = `0.8` weightunit = `KG` price = `77.00` currencycode = `EUR` )
        ( name = `Smart Games` category = `Software` suppliername = `Technocom` width = `10` depth = `3` height = `30` dimunit = `cm`
          weightmeasure = `1.1` weightunit = `KG` price = `55.00` currencycode = `EUR` )
        ( name = `Smart Internet Antivirus` category = `Software` suppliername = `Brainsoft` width = `16` depth = `4` height = `21` dimunit = `cm`
          weightmeasure = `0.7` weightunit = `KG` price = `29.00` currencycode = `EUR` )
        ( name = `Smart Firewall` category = `Software` suppliername = `Brainsoft` width = `17.9` depth = `4.2` height = `23.1` dimunit = `cm`
          weightmeasure = `0.9` weightunit = `KG` price = `34.00` currencycode = `EUR` )
        ( name = `Smart Money` category = `Software` suppliername = `Brainsoft` width = `12` depth = `1.5` height = `19` dimunit = `cm`
          weightmeasure = `0.5` weightunit = `KG` price = `29.90` currencycode = `EUR` )
        ( name = `PC Lock` category = `Computer System Accessories` suppliername = `Red Point Stores` width = `20` depth = `8` height = `4.3` dimunit = `cm`
          weightmeasure = `0.03` weightunit = `KG` price = `8.90` currencycode = `EUR` )
        ( name = `Notebook Lock` category = `Computer System Accessories` suppliername = `Red Point Stores` width = `31` depth = `9` height = `7` dimunit = `cm`
          weightmeasure = `0.02` weightunit = `KG` price = `6.90` currencycode = `EUR` )
        ( name = `Web cam reality` category = `Computer System Accessories` suppliername = `Red Point Stores` width = `9` depth = `8.2` height = `1.3` dimunit = `cm`
          weightmeasure = `0.075` weightunit = `KG` price = `39.00` currencycode = `EUR` )
        ( name = `Screen clean` category = `Computer System Accessories` suppliername = `Red Point Stores` width = `2` depth = `2` height = `0.1` dimunit = `cm`
          weightmeasure = `0.05` weightunit = `KG` price = `2.30` currencycode = `EUR` )
        ( name = `Fabric bag professional` category = `Computer System Accessories` suppliername = `Red Point Stores` width = `42` depth = `32` height = `7` dimunit = `cm`
          weightmeasure = `1.8` weightunit = `KG` price = `31.00` currencycode = `EUR` )
        ( name = `Wireless DSL Router` category = `Telecommunications` suppliername = `Red Point Stores` width = `19.3` depth = `18` height = `5` dimunit = `cm`
          weightmeasure = `0.45` weightunit = `KG` price = `49.00` currencycode = `EUR` )
        ( name = `Wireless DSL Router / Repeater` category = `Telecommunications` suppliername = `Red Point Stores` width = `19.3` depth = `18` height = `5` dimunit = `cm`
          weightmeasure = `0.45` weightunit = `KG` price = `59.00` currencycode = `EUR` )
        ( name = `Wireless DSL Router / Repeater and Print Server` category = `Telecommunications` suppliername = `Technocom` width = `19.3` depth = `18` height = `5` dimunit = `cm`
          weightmeasure = `0.45` weightunit = `KG` price = `69.00` currencycode = `EUR` )
        ( name = `USB Stick` category = `Computer System Accessories` suppliername = `Technocom` width = `1.5` depth = `8.7` height = `1.2` dimunit = `cm`
          weightmeasure = `0.015` weightunit = `KG` price = `35.00` currencycode = `EUR` )
        ( name = `Travel Adapter` category = `Accessories` suppliername = `Titanium` width = `2` depth = `3.1` height = `3.9` dimunit = `cm`
          weightmeasure = `88` weightunit = `G` price = `79.00` currencycode = `EUR` )
        ( name = `Cordless Bluetooth Keyboard, english international` category = `Keyboards` suppliername = `Technocom` width = `51.4` depth = `23` height = `4` dimunit = `cm`
          weightmeasure = `1` weightunit = `KG` price = `29.00` currencycode = `EUR` )
        ( name = `Flat XXL` category = `Flat Screen Monitors` suppliername = `Technocom` width = `54` depth = `22` height = `38` dimunit = `cm`
          weightmeasure = `18` weightunit = `KG` price = `1430.00` currencycode = `EUR` )
        ( name = `Pocket Mouse` category = `Mice` suppliername = `Technocom` width = `0.3` depth = `0.5` height = `1` dimunit = `cm`
          weightmeasure = `0.02` weightunit = `KG` price = `23.00` currencycode = `EUR` )
        ( name = `PC Power Station` category = `PCs` suppliername = `Technocom` width = `28` depth = `31` height = `43` dimunit = `cm`
          weightmeasure = `2.3` weightunit = `KG` price = `2399.00` currencycode = `EUR` )
        ( name = `Astro Laptop 1516` category = `Laptops` suppliername = `Ultrasonic United` width = `30` depth = `18` height = `3` dimunit = `cm`
          weightmeasure = `4.2` weightunit = `KG` price = `989.00` currencycode = `EUR` )
        ( name = `Astro Phone 6` category = `Smartphones and Tablets` suppliername = `Ultrasonic United` width = `8` depth = `6` height = `1.5` dimunit = `cm`
          weightmeasure = `0.75` weightunit = `KG` price = `649.00` currencycode = `EUR` )
        ( name = `Benda Laptop 1408` category = `Laptops` suppliername = `Ultrasonic United` width = `30` depth = `18` height = `3` dimunit = `cm`
          weightmeasure = `4.2` weightunit = `KG` price = `976.00` currencycode = `EUR` )
        ( name = `Bending Screen 21HD` category = `Flat Screens` suppliername = `Ultrasonic United` width = `37` depth = `12` height = `36` dimunit = `cm`
          weightmeasure = `15` weightunit = `KG` price = `250.00` currencycode = `EUR` )
        ( name = `Broad Screen 22HD` category = `Flat Screens` suppliername = `Ultrasonic United` width = `39` depth = `12` height = `38` dimunit = `cm`
          weightmeasure = `16` weightunit = `KG` price = `270.00` currencycode = `EUR` )
        ( name = `Cerdik Phone 7` category = `Smartphones and Tablets` suppliername = `Ultrasonic United` width = `9` depth = `15` height = `1.5` dimunit = `cm`
          weightmeasure = `0.75` weightunit = `KG` price = `549.00` currencycode = `EUR` )
        ( name = `Cepat Tablet 10.5` category = `Smartphones and Tablets` suppliername = `Ultrasonic United` width = `48` depth = `31` height = `4.5` dimunit = `cm`
          weightmeasure = `2.8` weightunit = `KG` price = `549.00` currencycode = `EUR` )
        ( name = `Cepat Tablet 8` category = `Smartphones and Tablets` suppliername = `Ultrasonic United` width = `38` depth = `21` height = `3.5` dimunit = `cm`
          weightmeasure = `2.5` weightunit = `KG` price = `529.00` currencycode = `EUR` )
        ( name = `Server Basic` category = `Servers` suppliername = `Technocom` width = `34` depth = `35` height = `23` dimunit = `cm`
          weightmeasure = `18` weightunit = `KG` price = `5000.00` currencycode = `EUR` )
        ( name = `Server Professional` category = `Servers` suppliername = `Technocom` width = `29` depth = `30` height = `27` dimunit = `cm`
          weightmeasure = `25` weightunit = `KG` price = `15000.00` currencycode = `EUR` )
        ( name = `Server Power Pro` category = `Servers` suppliername = `Technocom` width = `22` depth = `27.3` height = `37` dimunit = `cm`
          weightmeasure = `35` weightunit = `KG` price = `25000.00` currencycode = `EUR` )
        ( name = `Family PC Basic` category = `Desktop Computers` suppliername = `Titanium` width = `21.4` depth = `29` height = `38` dimunit = `cm`
          weightmeasure = `4.8` weightunit = `KG` price = `600.00` currencycode = `EUR` )
        ( name = `Family PC Pro` category = `Desktop Computers` suppliername = `Titanium` width = `25` depth = `31.7` height = `40.2` dimunit = `cm`
          weightmeasure = `5.3` weightunit = `KG` price = `900.00` currencycode = `EUR` )
        ( name = `Gaming Monster` category = `Desktop Computers` suppliername = `Titanium` width = `26.5` depth = `34` height = `47` dimunit = `cm`
          weightmeasure = `5.9` weightunit = `KG` price = `1200.00` currencycode = `EUR` )
        ( name = `Gaming Monster Pro` category = `Desktop Computers` suppliername = `Titanium` width = `27` depth = `28` height = `42` dimunit = `cm`
          weightmeasure = `6.8` weightunit = `KG` price = `1700.00` currencycode = `EUR` )
        ( name = `7" Widescreen Portable DVD Player w MP3` category = `Accessories` suppliername = `Titanium` width = `21.4` depth = `19` height = `27.6` dimunit = `cm`
          weightmeasure = `0.79` weightunit = `KG` price = `249.99` currencycode = `EUR` )
        ( name = `10" Portable DVD player` category = `Accessories` suppliername = `Titanium` width = `24` depth = `19.5` height = `29` dimunit = `cm`
          weightmeasure = `0.84` weightunit = `KG` price = `449.99` currencycode = `EUR` )
        ( name = `Portable DVD Player with 9" LCD Monitor` category = `Accessories` suppliername = `Technocom` width = `21` depth = `16.5` height = `14` dimunit = `cm`
          weightmeasure = `0.72` weightunit = `KG` price = `853.99` currencycode = `EUR` )
        ( name = `CD/DVD case: 264 sleeves` category = `Accessories` suppliername = `Titanium` width = `13` depth = `13` height = `20` dimunit = `cm`
          weightmeasure = `0.65` weightunit = `KG` price = `44.99` currencycode = `EUR` )
        ( name = `Audio/Video Cable Kit - 4m` category = `Accessories` suppliername = `Titanium` width = `21` depth = `10.2` height = `13` dimunit = `cm`
          weightmeasure = `0.2` weightunit = `KG` price = `29.99` currencycode = `EUR` )
        ( name = `Removable CD/DVD Laser Labels` category = `Accessories` suppliername = `Titanium` width = `5.5` depth = `2` height = `2` dimunit = `cm`
          weightmeasure = `0.15` weightunit = `KG` price = `8.99` currencycode = `EUR` )
        ( name = `Beam Breaker B-1` category = `Accessories` suppliername = `Titanium` width = `30.4` depth = `23.1` height = `23` dimunit = `cm`
          weightmeasure = `1.7` weightunit = `KG` price = `469.00` currencycode = `EUR` )
        ( name = `Beam Breaker B-2` category = `Accessories` suppliername = `Technocom` width = `30.4` depth = `23.1` height = `23` dimunit = `cm`
          weightmeasure = `2` weightunit = `KG` price = `679.00` currencycode = `EUR` )
        ( name = `Beam Breaker B-3` category = `Accessories` suppliername = `Technocom` width = `30.4` depth = `23.1` height = `23` dimunit = `cm`
          weightmeasure = `2.5` weightunit = `KG` price = `889.00` currencycode = `EUR` )
        ( name = `Play Movie` category = `Accessories` suppliername = `Fasttech` width = `37` depth = `24` height = `6` dimunit = `cm`
          weightmeasure = `2.4` weightunit = `KG` price = `130.00` currencycode = `EUR` )
        ( name = `Record Movie` category = `Accessories` suppliername = `Fasttech` width = `38` depth = `26` height = `6.2` dimunit = `cm`
          weightmeasure = `3.1` weightunit = `KG` price = `288.00` currencycode = `EUR` )
        ( name = `ITelo MusicStick` category = `Accessories` suppliername = `Fasttech` width = `1.5` depth = `6` height = `1` dimunit = `cm`
          weightmeasure = `134` weightunit = `G` price = `45.00` currencycode = `EUR` )
        ( name = `ITelo Jog-Mate` category = `Accessories` suppliername = `Fasttech` width = `5.1` depth = `8` height = `9.2` dimunit = `cm`
          weightmeasure = `134` weightunit = `G` price = `63.00` currencycode = `EUR` )
        ( name = `Power Pro Player 40` category = `Accessories` suppliername = `Fasttech` width = `5.1` depth = `8` height = `9.2` dimunit = `cm`
          weightmeasure = `266` weightunit = `G` price = `167.00` currencycode = `EUR` )
        ( name = `Power Pro Player 80` category = `Accessories` suppliername = `Fasttech` width = `4` depth = `6` height = `0.8` dimunit = `cm`
          weightmeasure = `267` weightunit = `G` price = `299.00` currencycode = `EUR` )
        ( name = `Flat Watch HD32` category = `Flat Screen TVs` suppliername = `Very Best Screens` width = `78` depth = `22.1` height = `55` dimunit = `cm`
          weightmeasure = `2.6` weightunit = `KG` price = `1459.00` currencycode = `EUR` )
        ( name = `Flat Watch HD37` category = `Flat Screen TVs` suppliername = `Very Best Screens` width = `99.1` depth = `26` height = `61` dimunit = `cm`
          weightmeasure = `2.2` weightunit = `KG` price = `1199.00` currencycode = `EUR` )
        ( name = `Flat Watch HD41` category = `Flat Screen TVs` suppliername = `Very Best Screens` width = `128` depth = `23` height = `79.1` dimunit = `cm`
          weightmeasure = `1.8` weightunit = `KG` price = `899.00` currencycode = `EUR` )
        ( name = `Copperberry` category = `Accessories` suppliername = `Fasttech` width = `8.1` depth = `13` height = `12.1` dimunit = `cm`
          weightmeasure = `0.5` weightunit = `KG` price = `549.00` currencycode = `EUR` )
        ( name = `Silverberry` category = `Accessories` suppliername = `Fasttech` width = `8.1` depth = `13` height = `12.1` dimunit = `cm`
          weightmeasure = `0.5` weightunit = `KG` price = `549.00` currencycode = `EUR` )
        ( name = `Goldberry` category = `Accessories` suppliername = `Fasttech` width = `8.1` depth = `13` height = `12.1` dimunit = `cm`
          weightmeasure = `0.5` weightunit = `KG` price = `549.00` currencycode = `EUR` )
        ( name = `Platinberry` category = `Accessories` suppliername = `Fasttech` width = `8.1` depth = `13` height = `12.1` dimunit = `cm`
          weightmeasure = `0.5` weightunit = `KG` price = `549.00` currencycode = `EUR` )
        ( name = `ITelO FlexTop I4000` category = `Laptops` suppliername = `Titanium` width = `31` depth = `19` height = `3.1` dimunit = `cm`
          weightmeasure = `4` weightunit = `KG` price = `799.00` currencycode = `EUR` )
        ( name = `ITelO FlexTop I6300c` category = `Laptops` suppliername = `Titanium` width = `32` depth = `20` height = `3.4` dimunit = `cm`
          weightmeasure = `4.2` weightunit = `KG` price = `799.00` currencycode = `EUR` )
        ( name = `ITelO FlexTop I9100` category = `Laptops` suppliername = `Titanium` width = `38` depth = `21` height = `4.1` dimunit = `cm`
          weightmeasure = `3.5` weightunit = `KG` price = `1199.00` currencycode = `EUR` )
        ( name = `ITelO FlexTop I9800` category = `Laptops` suppliername = `Titanium` width = `48` depth = `31` height = `4.5` dimunit = `cm`
          weightmeasure = `3.8` weightunit = `KG` price = `1388.00` currencycode = `EUR` )
        ( name = `Smartphone Leather Case` category = `Accessories` suppliername = `Ultrasonic United` width = `48` depth = `31` height = `4.5` dimunit = `cm`
          weightmeasure = `0.02` weightunit = `KG` price = `25.00` currencycode = `EUR` )
        ( name = `Smartphone Alpha` category = `Smartphones and Tablets` suppliername = `Ultrasonic United` width = `48` depth = `31` height = `4.5` dimunit = `cm`
          weightmeasure = `0.75` weightunit = `KG` price = `599.00` currencycode = `EUR` )
        ( name = `Mini Tablet` category = `Smartphones and Tablets` suppliername = `Ultrasonic United` width = `48` depth = `31` height = `4.5` dimunit = `cm`
          weightmeasure = `3.8` weightunit = `KG` price = `833.00` currencycode = `EUR` )
        ( name = `Camcorder View` category = `Accessories` suppliername = `Ultrasonic United` width = `48` depth = `31` height = `27` dimunit = `cm`
          weightmeasure = `3.8` weightunit = `KG` price = `1388.00` currencycode = `EUR` )
        ( name = `Tablet Pouch` category = `Accessories` suppliername = `Titanium` width = `25` depth = `40` height = `4.5` dimunit = `cm`
          weightmeasure = `0.03` weightunit = `KG` price = `20.00` currencycode = `EUR` )
        ( name = `Tablet Pouch` category = `Accessories` suppliername = `Titanium` width = `25` depth = `40` height = `4.5` dimunit = `cm`
          weightmeasure = `0.03` weightunit = `KG` price = `20.00` currencycode = `EUR` )
        ( name = `e-Book Reader ReadMe` category = `Smartphones and Tablets` suppliername = `Titanium` width = `48` depth = `31` height = `4.5` dimunit = `cm`
          weightmeasure = `3.8` weightunit = `KG` price = `33.00` currencycode = `EUR` )
        ( name = `Smartphone Beta` category = `Smartphones and Tablets` suppliername = `Titanium` width = `48` depth = `31` height = `4.5` dimunit = `cm`
          weightmeasure = `0.75` weightunit = `KG` price = `30.00` currencycode = `EUR` )
        ( name = `Maxi Tablet` category = `Tablets` suppliername = `Titanium` width = `48` depth = `31` height = `4.5` dimunit = `cm`
          weightmeasure = `3.8` weightunit = `KG` price = `749.00` currencycode = `EUR` )
        ( name = `Flyer` category = `Accessories` suppliername = `Titanium` width = `46` depth = `30` height = `3` dimunit = `cm`
          weightmeasure = `0.01` weightunit = `KG` price = `0.00` currencycode = `EUR` ) ).

    " Facet values with the precomputed counters from the mock /ProductCollectionStats/Filters (1:1, as the original binds them)
    t_categories = VALUE #(
        ( text = `Accessories`                 count = 34 )
        ( text = `Desktop Computers`           count = 7 )
        ( text = `Flat Screens`                count = 2 )
        ( text = `Keyboards`                   count = 4 )
        ( text = `Laptops`                     count = 11 )
        ( text = `Printers`                    count = 9 )
        ( text = `Smartphones and Tablets`     count = 9 )
        ( text = `Mice`                        count = 7 )
        ( text = `Computer System Accessories` count = 8 )
        ( text = `Graphics Card`               count = 4 )
        ( text = `Scanners`                    count = 4 )
        ( text = `Speakers`                    count = 3 )
        ( text = `Software`                    count = 8 )
        ( text = `Telekommunikation`           count = 3 )
        ( text = `Servers`                     count = 3 )
        ( text = `Flat Screen TVs`             count = 3 ) ).
    t_suppliers = VALUE #(
        ( text = `Titanium`          count = 21 )
        ( text = `Technocom`         count = 22 )
        ( text = `Red Point Stores`  count = 7 )
        ( text = `Very Best Screens` count = 14 )
        ( text = `Smartcards`        count = 2 )
        ( text = `Alpha Printers`    count = 5 )
        ( text = `Printer for All`   count = 8 )
        ( text = `Oxynum`            count = 8 )
        ( text = `Fasttech`          count = 15 )
        ( text = `Ultrasonic United` count = 15 )
        ( text = `Speaker Experts`   count = 3 )
        ( text = `Brainsoft`         count = 3 ) ).


    " weightState is business logic (KG conversion + Success/Warning/Error
    " thresholds), not presentation - abap2UI5 is a thin frontend, so the
    " ObjectNumber state is computed here in the backend (the original does it in
    " its frontend Formatter.js, which a faithful port moves server-side).
    LOOP AT t_products REFERENCE INTO DATA(lr_product).
      DATA(weight_kg) = lr_product->weightmeasure.
      IF lr_product->weightunit = `G`.
        weight_kg = weight_kg / 1000.
      ENDIF.
      lr_product->weight_state = COND #( WHEN weight_kg < 0 THEN `None`
                                         WHEN weight_kg < 1 THEN `Success`
                                         WHEN weight_kg < 5 THEN `Warning`
                                         ELSE `Error` ).
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
