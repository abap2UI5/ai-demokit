" @keywords table sap.m tableoutdated overflowtoolbar combobox item button toolbarspacer segmentedbutton segmentedbuttonitem verticallayout column
" @summary You can use the 'showOverlay' property to indicate that the table data is no longer up to date. When the user modifies the filter values of the table, this results in displaying an overlay, which disables operations on the table.
CLASS z2ui5_cl_smpc_app_505 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             name          TYPE string,
             productid     TYPE string,
             suppliername  TYPE string,
             width         TYPE string,
             depth         TYPE string,
             height        TYPE string,
             dimunit       TYPE string,
             weightmeasure TYPE p LENGTH 8 DECIMALS 2,
             weightunit    TYPE string,
             weightstate   TYPE string,
             price         TYPE p LENGTH 8 DECIMALS 2,
             currencycode  TYPE string,
           END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

    TYPES: BEGIN OF ty_s_filter,
             text TYPE string,
           END OF ty_s_filter.
    TYPES ty_t_filter TYPE STANDARD TABLE OF ty_s_filter WITH DEFAULT KEY.

    DATA t_products TYPE ty_t_product.
    DATA t_filters  TYPE ty_t_filter.
    DATA supplier   TYPE string.
    DATA overlay    TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    " the unfiltered mock, so Reset can put every row back
    DATA t_all TYPE ty_t_product.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_505 IMPLEMENTATION.

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

    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns`      v = `sap.m`

        )->ele( `OverflowToolbar`

            " onChange only switches the overlay on; the selected supplier is two-way
            " bound and the filter is applied by the Filter button
            )->ele( `ComboBox`
                )->a( n = `id`          v = `oComboBox`
                )->a( n = `change`      v = client->_event( `CHANGE` )
                )->a( n = `selectedKey` v = client->_bind( supplier )
                )->a( n = `items`       v = client->_bind( t_filters )

                )->tag( n = `Item` ns = `core`
                    )->a( n = `text` v = `{TEXT}`
                    )->a( n = `key`  v = `{TEXT}`

            )->end(

            )->tag( `Button`
                )->a( n = `text`  v = `Filter`
                )->a( n = `press` v = client->_event( `SEARCH` )
                )->a( n = `icon`  v = `sap-icon://filter`
            )->tag( `Button`
                )->a( n = `text`  v = `Reset`
                )->a( n = `press` v = client->_event( `RESET` )
                )->a( n = `type`  v = `Transparent`
            )->tag( `ToolbarSpacer`

            )->ele( `SegmentedButton`
                )->a( n = `enabled` v = `false`

                )->ele( `items`
                    )->tag( `SegmentedButtonItem`
                        )->a( n = `icon` v = `sap-icon://settings`
                    )->tag( `SegmentedButtonItem`
                        )->a( n = `icon` v = `sap-icon://settings`
                    )->tag( `SegmentedButtonItem`
                        )->a( n = `icon` v = `sap-icon://settings`

                )->end(
            )->end(
        )->end(

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `id` v = `tableLayout`

            " the original inserts the sap.m.sample.Table component's table here and
            " hides its header toolbar - the same table is declared inline, without
            " that toolbar
            )->ele( `Table`
                )->a( n = `id`          v = `idProductsTable`
                )->a( n = `inset`       v = `false`
                " NOT `b = <field>`: that parameter writes the LITERAL 'true' or
                " 'false' into the attribute at render time (view_builder->a),
                " so a field the event handler changes never reaches the
                " control - none of these apps re-renders after an event
                " (e2e-caught on app 505, 2026-08-22)
                )->a( n = `showOverlay` v = client->_bind( overlay )
                )->a( n = `items`       v = |\{ path: '{ client->_bind_path( t_products ) }', sorter: \{ path: 'NAME' \} \}|

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
                                )->a( n = `text`  v = `{PRODUCTID}`
                            )->tag( `Text`
                                )->a( n = `text` v = `{SUPPLIERNAME}`
                            )->tag( `Text`
                                )->a( n = `text` v = `{WIDTH} x {DEPTH} x {HEIGHT} {DIMUNIT}`
                            )->tag( `ObjectNumber`
                                )->a( n = `number` v = `{WEIGHTMEASURE}`
                                )->a( n = `unit`   v = `{WEIGHTUNIT}`
                                )->a( n = `state`  v = `{WEIGHTSTATE}`
                            )->tag( `ObjectNumber`
                                )->a( n = `number` v = |\{ parts: [\{path: 'PRICE'\}, \{path: 'CURRENCYCODE'\}], type: 'sap.ui.model.type.Currency', formatOptions: \{showMeasure: false\} \}|
                                )->a( n = `unit`   v = `{CURRENCYCODE}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA temp1 TYPE z2ui5_cl_smpc_app_505=>ty_t_product.
        DATA row LIKE LINE OF t_all.

    CASE client->get_event( ).

      WHEN `CHANGE`.
        " onChange: any change to the ComboBox puts the outdated overlay on
        overlay = abap_true.

      WHEN `SEARCH`.
        " onSearch: filter by the selected supplier and take the overlay off
        overlay = abap_false.
        
        CLEAR temp1.
        
        LOOP AT t_all INTO row WHERE suppliername = supplier.
          INSERT row INTO TABLE temp1.
        ENDLOOP.
        t_products = temp1.

      WHEN `RESET`.
        " onReset: clear the filter, the overlay and the ComboBox selection
        overlay = abap_false.
        CLEAR supplier.
        t_products = t_all.

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " /ProductCollectionStats/Filters/1/values of ui5/mock/products.json
    DATA temp3 TYPE z2ui5_cl_smpc_app_505=>ty_t_filter.
    DATA temp4 LIKE LINE OF temp3.
    DATA temp5 TYPE z2ui5_cl_smpc_app_505=>ty_t_product.
    DATA temp6 LIKE LINE OF temp5.
    DATA temp7 LIKE LINE OF t_all.
    DATA lr_product LIKE REF TO temp7.
      DATA weight_kg LIKE lr_product->weightmeasure.
      DATA temp8 TYPE z2ui5_cl_smpc_app_505=>ty_s_product-weightstate.
    CLEAR temp3.
    
    temp4-text = `Titanium`.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Technocom`.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Red Point Stores`.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Very Best Screens`.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Smartcards`.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Alpha Printers`.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Printer for All`.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Oxynum`.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Fasttech`.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Ultrasonic United`.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Speaker Experts`.
    INSERT temp4 INTO TABLE temp3.
    temp4-text = `Brainsoft`.
    INSERT temp4 INTO TABLE temp3.
    t_filters = temp3.

    " full mock /ProductCollection (the bound fields); weightstate is computed
    " below, not seeded
    
    CLEAR temp5.
    
    temp6-name = `Notebook Basic 15`.
    temp6-productid = `HT-1000`.
    temp6-suppliername = `Very Best Screens`.
    temp6-width = `30`.
    temp6-depth = `18`.
    temp6-height = `3`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `4.2`.
    temp6-weightunit = `KG`.
    temp6-price = `956`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Notebook Basic 17`.
    temp6-productid = `HT-1001`.
    temp6-suppliername = `Very Best Screens`.
    temp6-width = `29`.
    temp6-depth = `17`.
    temp6-height = `3.1`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `4.5`.
    temp6-weightunit = `KG`.
    temp6-price = `1249`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Notebook Basic 18`.
    temp6-productid = `HT-1002`.
    temp6-suppliername = `Very Best Screens`.
    temp6-width = `28`.
    temp6-depth = `19`.
    temp6-height = `2.5`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `4.2`.
    temp6-weightunit = `KG`.
    temp6-price = `1570`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Notebook Basic 19`.
    temp6-productid = `HT-1003`.
    temp6-suppliername = `Smartcards`.
    temp6-width = `32`.
    temp6-depth = `21`.
    temp6-height = `4`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `4.2`.
    temp6-weightunit = `KG`.
    temp6-price = `1650`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `ITelO Vault`.
    temp6-productid = `HT-1007`.
    temp6-suppliername = `Technocom`.
    temp6-width = `32`.
    temp6-depth = `22`.
    temp6-height = `3`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.2`.
    temp6-weightunit = `KG`.
    temp6-price = `299`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Notebook Professional 15`.
    temp6-productid = `HT-1010`.
    temp6-suppliername = `Very Best Screens`.
    temp6-width = `33`.
    temp6-depth = `20`.
    temp6-height = `3`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `4.3`.
    temp6-weightunit = `KG`.
    temp6-price = `1999`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Notebook Professional 17`.
    temp6-productid = `HT-1011`.
    temp6-suppliername = `Very Best Screens`.
    temp6-width = `33`.
    temp6-depth = `23`.
    temp6-height = `2`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `4.1`.
    temp6-weightunit = `KG`.
    temp6-price = `2299`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `ITelO Vault Net`.
    temp6-productid = `HT-1020`.
    temp6-suppliername = `Technocom`.
    temp6-width = `10`.
    temp6-depth = `1.8`.
    temp6-height = `17`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.16`.
    temp6-weightunit = `KG`.
    temp6-price = `459`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `ITelO Vault SAT`.
    temp6-productid = `HT-1021`.
    temp6-suppliername = `Technocom`.
    temp6-width = `11`.
    temp6-depth = `1.7`.
    temp6-height = `18`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.18`.
    temp6-weightunit = `KG`.
    temp6-price = `149`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Comfort Easy`.
    temp6-productid = `HT-1022`.
    temp6-suppliername = `Technocom`.
    temp6-width = `84`.
    temp6-depth = `1.5`.
    temp6-height = `14`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.2`.
    temp6-weightunit = `KG`.
    temp6-price = `1679`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Comfort Senior`.
    temp6-productid = `HT-1023`.
    temp6-suppliername = `Technocom`.
    temp6-width = `80`.
    temp6-depth = `1.6`.
    temp6-height = `13`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.8`.
    temp6-weightunit = `KG`.
    temp6-price = `512`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Ergo Screen E-I`.
    temp6-productid = `HT-1030`.
    temp6-suppliername = `Very Best Screens`.
    temp6-width = `37`.
    temp6-depth = `12`.
    temp6-height = `36`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `21`.
    temp6-weightunit = `KG`.
    temp6-price = `230`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Ergo Screen E-II`.
    temp6-productid = `HT-1031`.
    temp6-suppliername = `Very Best Screens`.
    temp6-width = `40.8`.
    temp6-depth = `19`.
    temp6-height = `43`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `21`.
    temp6-weightunit = `KG`.
    temp6-price = `285`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Ergo Screen E-III`.
    temp6-productid = `HT-1032`.
    temp6-suppliername = `Very Best Screens`.
    temp6-width = `40.8`.
    temp6-depth = `19`.
    temp6-height = `43`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `21`.
    temp6-weightunit = `KG`.
    temp6-price = `345`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Flat Basic`.
    temp6-productid = `HT-1035`.
    temp6-suppliername = `Very Best Screens`.
    temp6-width = `39`.
    temp6-depth = `20`.
    temp6-height = `41`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `14`.
    temp6-weightunit = `KG`.
    temp6-price = `399`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Flat Future`.
    temp6-productid = `HT-1036`.
    temp6-suppliername = `Very Best Screens`.
    temp6-width = `45`.
    temp6-depth = `26`.
    temp6-height = `46`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `15`.
    temp6-weightunit = `KG`.
    temp6-price = `430`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Flat XL`.
    temp6-productid = `HT-1037`.
    temp6-suppliername = `Very Best Screens`.
    temp6-width = `54.5`.
    temp6-depth = `22.1`.
    temp6-height = `39.1`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `17`.
    temp6-weightunit = `KG`.
    temp6-price = `1230`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Laser Professional Eco`.
    temp6-productid = `HT-1040`.
    temp6-suppliername = `Alpha Printers`.
    temp6-width = `51`.
    temp6-depth = `46`.
    temp6-height = `30`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `32`.
    temp6-weightunit = `KG`.
    temp6-price = `830`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Laser Basic`.
    temp6-productid = `HT-1041`.
    temp6-suppliername = `Alpha Printers`.
    temp6-width = `48`.
    temp6-depth = `42`.
    temp6-height = `26`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `23`.
    temp6-weightunit = `KG`.
    temp6-price = `490`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Laser Allround`.
    temp6-productid = `HT-1042`.
    temp6-suppliername = `Alpha Printers`.
    temp6-width = `53`.
    temp6-depth = `50`.
    temp6-height = `65`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `17`.
    temp6-weightunit = `KG`.
    temp6-price = `349`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Ultra Jet Super Color`.
    temp6-productid = `HT-1050`.
    temp6-suppliername = `Alpha Printers`.
    temp6-width = `41`.
    temp6-depth = `41`.
    temp6-height = `28`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `3`.
    temp6-weightunit = `KG`.
    temp6-price = `139`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Ultra Jet Mobile`.
    temp6-productid = `HT-1051`.
    temp6-suppliername = `Printer for All`.
    temp6-width = `46`.
    temp6-depth = `32`.
    temp6-height = `25`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `1.9`.
    temp6-weightunit = `KG`.
    temp6-price = `99`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Ultra Jet Super Highspeed`.
    temp6-productid = `HT-1052`.
    temp6-suppliername = `Printer for All`.
    temp6-width = `41`.
    temp6-depth = `41`.
    temp6-height = `28`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `18`.
    temp6-weightunit = `KG`.
    temp6-price = `170`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Multi Print`.
    temp6-productid = `HT-1055`.
    temp6-suppliername = `Printer for All`.
    temp6-width = `55`.
    temp6-depth = `45`.
    temp6-height = `29`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `6.3`.
    temp6-weightunit = `KG`.
    temp6-price = `99`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Multi Color`.
    temp6-productid = `HT-1056`.
    temp6-suppliername = `Printer for All`.
    temp6-width = `51`.
    temp6-depth = `41.3`.
    temp6-height = `22`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `4.3`.
    temp6-weightunit = `KG`.
    temp6-price = `119`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Cordless Mouse`.
    temp6-productid = `HT-1060`.
    temp6-suppliername = `Oxynum`.
    temp6-width = `6`.
    temp6-depth = `14.5`.
    temp6-height = `3.5`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.09`.
    temp6-weightunit = `KG`.
    temp6-price = `9`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Speed Mouse`.
    temp6-productid = `HT-1061`.
    temp6-suppliername = `Oxynum`.
    temp6-width = `7`.
    temp6-depth = `15`.
    temp6-height = `3.1`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.09`.
    temp6-weightunit = `KG`.
    temp6-price = `7`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Track Mouse`.
    temp6-productid = `HT-1062`.
    temp6-suppliername = `Oxynum`.
    temp6-width = `3`.
    temp6-depth = `7`.
    temp6-height = `4`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.03`.
    temp6-weightunit = `KG`.
    temp6-price = `11`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Ergonomic Keyboard`.
    temp6-productid = `HT-1063`.
    temp6-suppliername = `Oxynum`.
    temp6-width = `50`.
    temp6-depth = `21`.
    temp6-height = `3.5`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `2.1`.
    temp6-weightunit = `KG`.
    temp6-price = `14`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Internet Keyboard`.
    temp6-productid = `HT-1064`.
    temp6-suppliername = `Oxynum`.
    temp6-width = `52`.
    temp6-depth = `25`.
    temp6-height = `3`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `1.8`.
    temp6-weightunit = `KG`.
    temp6-price = `16`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Media Keyboard`.
    temp6-productid = `HT-1065`.
    temp6-suppliername = `Oxynum`.
    temp6-width = `51.4`.
    temp6-depth = `23`.
    temp6-height = `4`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `2.3`.
    temp6-weightunit = `KG`.
    temp6-price = `26`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Mousepad`.
    temp6-productid = `HT-1066`.
    temp6-suppliername = `Oxynum`.
    temp6-width = `15`.
    temp6-depth = `6`.
    temp6-height = `0.2`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `80`.
    temp6-weightunit = `G`.
    temp6-price = `6.99`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Ergo Mousepad`.
    temp6-productid = `HT-1067`.
    temp6-suppliername = `Oxynum`.
    temp6-width = `15`.
    temp6-depth = `6`.
    temp6-height = `0.2`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `80`.
    temp6-weightunit = `G`.
    temp6-price = `8.99`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Designer Mousepad`.
    temp6-productid = `HT-1068`.
    temp6-suppliername = `Fasttech`.
    temp6-width = `24`.
    temp6-depth = `24`.
    temp6-height = `0.6`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `90`.
    temp6-weightunit = `G`.
    temp6-price = `12.99`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Universal card reader`.
    temp6-productid = `HT-1069`.
    temp6-suppliername = `Fasttech`.
    temp6-width = `6`.
    temp6-depth = `6`.
    temp6-height = `3`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `45`.
    temp6-weightunit = `G`.
    temp6-price = `14`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Proctra X`.
    temp6-productid = `HT-1070`.
    temp6-suppliername = `Ultrasonic United`.
    temp6-width = `22`.
    temp6-depth = `35`.
    temp6-height = `17`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.255`.
    temp6-weightunit = `KG`.
    temp6-price = `70.9`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Gladiator MX`.
    temp6-productid = `HT-1071`.
    temp6-suppliername = `Ultrasonic United`.
    temp6-width = `22`.
    temp6-depth = `35`.
    temp6-height = `17`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.3`.
    temp6-weightunit = `KG`.
    temp6-price = `81.7`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Hurricane GX`.
    temp6-productid = `HT-1072`.
    temp6-suppliername = `Ultrasonic United`.
    temp6-width = `22`.
    temp6-depth = `35`.
    temp6-height = `17`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.4`.
    temp6-weightunit = `KG`.
    temp6-price = `101.2`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Hurricane GX/LN`.
    temp6-productid = `HT-1073`.
    temp6-suppliername = `Smartcards`.
    temp6-width = `22`.
    temp6-depth = `35`.
    temp6-height = `17`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.4`.
    temp6-weightunit = `KG`.
    temp6-price = `139.99`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Photo Scan`.
    temp6-productid = `HT-1080`.
    temp6-suppliername = `Printer for All`.
    temp6-width = `34`.
    temp6-depth = `48`.
    temp6-height = `5`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `2.3`.
    temp6-weightunit = `KG`.
    temp6-price = `129`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Power Scan`.
    temp6-productid = `HT-1081`.
    temp6-suppliername = `Printer for All`.
    temp6-width = `31`.
    temp6-depth = `43`.
    temp6-height = `7`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `2.4`.
    temp6-weightunit = `KG`.
    temp6-price = `89`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Jet Scan Professional`.
    temp6-productid = `HT-1082`.
    temp6-suppliername = `Printer for All`.
    temp6-width = `33`.
    temp6-depth = `41`.
    temp6-height = `12`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `3.2`.
    temp6-weightunit = `KG`.
    temp6-price = `169`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Jet Scan Professional`.
    temp6-productid = `HT-1083`.
    temp6-suppliername = `Printer for All`.
    temp6-width = `35`.
    temp6-depth = `40`.
    temp6-height = `10`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `3.2`.
    temp6-weightunit = `KG`.
    temp6-price = `189`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Copymaster`.
    temp6-productid = `HT-1085`.
    temp6-suppliername = `Alpha Printers`.
    temp6-width = `45`.
    temp6-depth = `42`.
    temp6-height = `22`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `23.2`.
    temp6-weightunit = `KG`.
    temp6-price = `1499`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Surround Sound`.
    temp6-productid = `HT-1090`.
    temp6-suppliername = `Speaker Experts`.
    temp6-width = `12`.
    temp6-depth = `10`.
    temp6-height = `16`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `3`.
    temp6-weightunit = `KG`.
    temp6-price = `39`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Blaster Extreme`.
    temp6-productid = `HT-1091`.
    temp6-suppliername = `Speaker Experts`.
    temp6-width = `13`.
    temp6-depth = `11`.
    temp6-height = `17.5`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `1.4`.
    temp6-weightunit = `KG`.
    temp6-price = `26`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Sound Booster`.
    temp6-productid = `HT-1092`.
    temp6-suppliername = `Speaker Experts`.
    temp6-width = `12.4`.
    temp6-depth = `10.4`.
    temp6-height = `18.1`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `2.1`.
    temp6-weightunit = `KG`.
    temp6-price = `45`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Lovely Sound 5.1 Wireless`.
    temp6-productid = `HT-1095`.
    temp6-suppliername = `Fasttech`.
    temp6-width = `24`.
    temp6-depth = `19`.
    temp6-height = `23`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `80`.
    temp6-weightunit = `G`.
    temp6-price = `49`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Lovely Sound 5.1`.
    temp6-productid = `HT-1096`.
    temp6-suppliername = `Fasttech`.
    temp6-width = `25`.
    temp6-depth = `17`.
    temp6-height = `19`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `130`.
    temp6-weightunit = `G`.
    temp6-price = `39`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Lovely Sound Stereo`.
    temp6-productid = `HT-1097`.
    temp6-suppliername = `Fasttech`.
    temp6-width = `21.3`.
    temp6-depth = `2.4`.
    temp6-height = `19.7`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `60`.
    temp6-weightunit = `G`.
    temp6-price = `29`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Smart Office`.
    temp6-productid = `HT-1100`.
    temp6-suppliername = `Technocom`.
    temp6-width = `15`.
    temp6-depth = `6.5`.
    temp6-height = `2.1`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `1.2`.
    temp6-weightunit = `KG`.
    temp6-price = `89.9`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Smart Design`.
    temp6-productid = `HT-1101`.
    temp6-suppliername = `Technocom`.
    temp6-width = `14`.
    temp6-depth = `6.7`.
    temp6-height = `24`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.8`.
    temp6-weightunit = `KG`.
    temp6-price = `79.9`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Smart Network`.
    temp6-productid = `HT-1102`.
    temp6-suppliername = `Technocom`.
    temp6-width = `16`.
    temp6-depth = `6`.
    temp6-height = `27`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.8`.
    temp6-weightunit = `KG`.
    temp6-price = `69`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Smart Multimedia`.
    temp6-productid = `HT-1103`.
    temp6-suppliername = `Technocom`.
    temp6-width = `11`.
    temp6-depth = `3.4`.
    temp6-height = `22`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.8`.
    temp6-weightunit = `KG`.
    temp6-price = `77`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Smart Games`.
    temp6-productid = `HT-1104`.
    temp6-suppliername = `Technocom`.
    temp6-width = `10`.
    temp6-depth = `3`.
    temp6-height = `30`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `1.1`.
    temp6-weightunit = `KG`.
    temp6-price = `55`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Smart Internet Antivirus`.
    temp6-productid = `HT-1105`.
    temp6-suppliername = `Brainsoft`.
    temp6-width = `16`.
    temp6-depth = `4`.
    temp6-height = `21`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.7`.
    temp6-weightunit = `KG`.
    temp6-price = `29`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Smart Firewall`.
    temp6-productid = `HT-1106`.
    temp6-suppliername = `Brainsoft`.
    temp6-width = `17.9`.
    temp6-depth = `4.2`.
    temp6-height = `23.1`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.9`.
    temp6-weightunit = `KG`.
    temp6-price = `34`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Smart Money`.
    temp6-productid = `HT-1107`.
    temp6-suppliername = `Brainsoft`.
    temp6-width = `12`.
    temp6-depth = `1.5`.
    temp6-height = `19`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.5`.
    temp6-weightunit = `KG`.
    temp6-price = `29.9`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `PC Lock`.
    temp6-productid = `HT-1110`.
    temp6-suppliername = `Red Point Stores`.
    temp6-width = `20`.
    temp6-depth = `8`.
    temp6-height = `4.3`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.03`.
    temp6-weightunit = `KG`.
    temp6-price = `8.9`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Notebook Lock`.
    temp6-productid = `HT-1111`.
    temp6-suppliername = `Red Point Stores`.
    temp6-width = `31`.
    temp6-depth = `9`.
    temp6-height = `7`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.02`.
    temp6-weightunit = `KG`.
    temp6-price = `6.9`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Web cam reality`.
    temp6-productid = `HT-1112`.
    temp6-suppliername = `Red Point Stores`.
    temp6-width = `9`.
    temp6-depth = `8.2`.
    temp6-height = `1.3`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.075`.
    temp6-weightunit = `KG`.
    temp6-price = `39`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Screen clean`.
    temp6-productid = `HT-1113`.
    temp6-suppliername = `Red Point Stores`.
    temp6-width = `2`.
    temp6-depth = `2`.
    temp6-height = `0.1`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.05`.
    temp6-weightunit = `KG`.
    temp6-price = `2.3`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Fabric bag professional`.
    temp6-productid = `HT-1114`.
    temp6-suppliername = `Red Point Stores`.
    temp6-width = `42`.
    temp6-depth = `32`.
    temp6-height = `7`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `1.8`.
    temp6-weightunit = `KG`.
    temp6-price = `31`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Wireless DSL Router`.
    temp6-productid = `HT-1115`.
    temp6-suppliername = `Red Point Stores`.
    temp6-width = `19.3`.
    temp6-depth = `18`.
    temp6-height = `5`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.45`.
    temp6-weightunit = `KG`.
    temp6-price = `49`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Wireless DSL Router / Repeater`.
    temp6-productid = `HT-1116`.
    temp6-suppliername = `Red Point Stores`.
    temp6-width = `19.3`.
    temp6-depth = `18`.
    temp6-height = `5`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.45`.
    temp6-weightunit = `KG`.
    temp6-price = `59`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Wireless DSL Router / Repeater and Print Server`.
    temp6-productid = `HT-1117`.
    temp6-suppliername = `Technocom`.
    temp6-width = `19.3`.
    temp6-depth = `18`.
    temp6-height = `5`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.45`.
    temp6-weightunit = `KG`.
    temp6-price = `69`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `USB Stick`.
    temp6-productid = `HT-1118`.
    temp6-suppliername = `Technocom`.
    temp6-width = `1.5`.
    temp6-depth = `8.7`.
    temp6-height = `1.2`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.015`.
    temp6-weightunit = `KG`.
    temp6-price = `35`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Travel Adapter`.
    temp6-productid = `HT-1119`.
    temp6-suppliername = `Titanium`.
    temp6-width = `2`.
    temp6-depth = `3.1`.
    temp6-height = `3.9`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `88`.
    temp6-weightunit = `G`.
    temp6-price = `79`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Cordless Bluetooth Keyboard, english international`.
    temp6-productid = `HT-1120`.
    temp6-suppliername = `Technocom`.
    temp6-width = `51.4`.
    temp6-depth = `23`.
    temp6-height = `4`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `1`.
    temp6-weightunit = `KG`.
    temp6-price = `29`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Flat XXL`.
    temp6-productid = `HT-1137`.
    temp6-suppliername = `Technocom`.
    temp6-width = `54`.
    temp6-depth = `22`.
    temp6-height = `38`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `18`.
    temp6-weightunit = `KG`.
    temp6-price = `1430`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Pocket Mouse`.
    temp6-productid = `HT-1138`.
    temp6-suppliername = `Technocom`.
    temp6-width = `0.3`.
    temp6-depth = `0.5`.
    temp6-height = `1`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.02`.
    temp6-weightunit = `KG`.
    temp6-price = `23`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `PC Power Station`.
    temp6-productid = `HT-1210`.
    temp6-suppliername = `Technocom`.
    temp6-width = `28`.
    temp6-depth = `31`.
    temp6-height = `43`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `2.3`.
    temp6-weightunit = `KG`.
    temp6-price = `2399`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Astro Laptop 1516`.
    temp6-productid = `HT-1251`.
    temp6-suppliername = `Ultrasonic United`.
    temp6-width = `30`.
    temp6-depth = `18`.
    temp6-height = `3`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `4.2`.
    temp6-weightunit = `KG`.
    temp6-price = `989`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Astro Phone 6`.
    temp6-productid = `HT-1252`.
    temp6-suppliername = `Ultrasonic United`.
    temp6-width = `8`.
    temp6-depth = `6`.
    temp6-height = `1.5`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.75`.
    temp6-weightunit = `KG`.
    temp6-price = `649`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Benda Laptop 1408`.
    temp6-productid = `HT-1253`.
    temp6-suppliername = `Ultrasonic United`.
    temp6-width = `30`.
    temp6-depth = `18`.
    temp6-height = `3`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `4.2`.
    temp6-weightunit = `KG`.
    temp6-price = `976`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Bending Screen 21HD`.
    temp6-productid = `HT-1254`.
    temp6-suppliername = `Ultrasonic United`.
    temp6-width = `37`.
    temp6-depth = `12`.
    temp6-height = `36`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `15`.
    temp6-weightunit = `KG`.
    temp6-price = `250`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Broad Screen 22HD`.
    temp6-productid = `HT-1255`.
    temp6-suppliername = `Ultrasonic United`.
    temp6-width = `39`.
    temp6-depth = `12`.
    temp6-height = `38`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `16`.
    temp6-weightunit = `KG`.
    temp6-price = `270`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Cerdik Phone 7`.
    temp6-productid = `HT-1256`.
    temp6-suppliername = `Ultrasonic United`.
    temp6-width = `9`.
    temp6-depth = `15`.
    temp6-height = `1.5`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.75`.
    temp6-weightunit = `KG`.
    temp6-price = `549`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Cepat Tablet 10.5`.
    temp6-productid = `HT-1257`.
    temp6-suppliername = `Ultrasonic United`.
    temp6-width = `48`.
    temp6-depth = `31`.
    temp6-height = `4.5`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `2.8`.
    temp6-weightunit = `KG`.
    temp6-price = `549`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Cepat Tablet 8`.
    temp6-productid = `HT-1258`.
    temp6-suppliername = `Ultrasonic United`.
    temp6-width = `38`.
    temp6-depth = `21`.
    temp6-height = `3.5`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `2.5`.
    temp6-weightunit = `KG`.
    temp6-price = `529`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Server Basic`.
    temp6-productid = `HT-1500`.
    temp6-suppliername = `Technocom`.
    temp6-width = `34`.
    temp6-depth = `35`.
    temp6-height = `23`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `18`.
    temp6-weightunit = `KG`.
    temp6-price = `5000`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Server Professional`.
    temp6-productid = `HT-1501`.
    temp6-suppliername = `Technocom`.
    temp6-width = `29`.
    temp6-depth = `30`.
    temp6-height = `27`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `25`.
    temp6-weightunit = `KG`.
    temp6-price = `15000`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Server Power Pro`.
    temp6-productid = `HT-1502`.
    temp6-suppliername = `Technocom`.
    temp6-width = `22`.
    temp6-depth = `27.3`.
    temp6-height = `37`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `35`.
    temp6-weightunit = `KG`.
    temp6-price = `25000`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Family PC Basic`.
    temp6-productid = `HT-1600`.
    temp6-suppliername = `Titanium`.
    temp6-width = `21.4`.
    temp6-depth = `29`.
    temp6-height = `38`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `4.8`.
    temp6-weightunit = `KG`.
    temp6-price = `600`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Family PC Pro`.
    temp6-productid = `HT-1601`.
    temp6-suppliername = `Titanium`.
    temp6-width = `25`.
    temp6-depth = `31.7`.
    temp6-height = `40.2`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `5.3`.
    temp6-weightunit = `KG`.
    temp6-price = `900`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Gaming Monster`.
    temp6-productid = `HT-1602`.
    temp6-suppliername = `Titanium`.
    temp6-width = `26.5`.
    temp6-depth = `34`.
    temp6-height = `47`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `5.9`.
    temp6-weightunit = `KG`.
    temp6-price = `1200`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Gaming Monster Pro`.
    temp6-productid = `HT-1603`.
    temp6-suppliername = `Titanium`.
    temp6-width = `27`.
    temp6-depth = `28`.
    temp6-height = `42`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `6.8`.
    temp6-weightunit = `KG`.
    temp6-price = `1700`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `7" Widescreen Portable DVD Player w MP3`.
    temp6-productid = `HT-2000`.
    temp6-suppliername = `Titanium`.
    temp6-width = `21.4`.
    temp6-depth = `19`.
    temp6-height = `27.6`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.79`.
    temp6-weightunit = `KG`.
    temp6-price = `249.99`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `10" Portable DVD player`.
    temp6-productid = `HT-2001`.
    temp6-suppliername = `Titanium`.
    temp6-width = `24`.
    temp6-depth = `19.5`.
    temp6-height = `29`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.84`.
    temp6-weightunit = `KG`.
    temp6-price = `449.99`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Portable DVD Player with 9" LCD Monitor`.
    temp6-productid = `HT-2002`.
    temp6-suppliername = `Technocom`.
    temp6-width = `21`.
    temp6-depth = `16.5`.
    temp6-height = `14`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.72`.
    temp6-weightunit = `KG`.
    temp6-price = `853.99`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `CD/DVD case: 264 sleeves`.
    temp6-productid = `HT-2025`.
    temp6-suppliername = `Titanium`.
    temp6-width = `13`.
    temp6-depth = `13`.
    temp6-height = `20`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.65`.
    temp6-weightunit = `KG`.
    temp6-price = `44.99`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Audio/Video Cable Kit - 4m`.
    temp6-productid = `HT-2026`.
    temp6-suppliername = `Titanium`.
    temp6-width = `21`.
    temp6-depth = `10.2`.
    temp6-height = `13`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.2`.
    temp6-weightunit = `KG`.
    temp6-price = `29.99`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Removable CD/DVD Laser Labels`.
    temp6-productid = `HT-2027`.
    temp6-suppliername = `Titanium`.
    temp6-width = `5.5`.
    temp6-depth = `2`.
    temp6-height = `2`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.15`.
    temp6-weightunit = `KG`.
    temp6-price = `8.99`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Beam Breaker B-1`.
    temp6-productid = `HT-6100`.
    temp6-suppliername = `Titanium`.
    temp6-width = `30.4`.
    temp6-depth = `23.1`.
    temp6-height = `23`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `1.7`.
    temp6-weightunit = `KG`.
    temp6-price = `469`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Beam Breaker B-2`.
    temp6-productid = `HT-6101`.
    temp6-suppliername = `Technocom`.
    temp6-width = `30.4`.
    temp6-depth = `23.1`.
    temp6-height = `23`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `2`.
    temp6-weightunit = `KG`.
    temp6-price = `679`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Beam Breaker B-3`.
    temp6-productid = `HT-6102`.
    temp6-suppliername = `Technocom`.
    temp6-width = `30.4`.
    temp6-depth = `23.1`.
    temp6-height = `23`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `2.5`.
    temp6-weightunit = `KG`.
    temp6-price = `889`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Play Movie`.
    temp6-productid = `HT-6110`.
    temp6-suppliername = `Fasttech`.
    temp6-width = `37`.
    temp6-depth = `24`.
    temp6-height = `6`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `2.4`.
    temp6-weightunit = `KG`.
    temp6-price = `130`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Record Movie`.
    temp6-productid = `HT-6111`.
    temp6-suppliername = `Fasttech`.
    temp6-width = `38`.
    temp6-depth = `26`.
    temp6-height = `6.2`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `3.1`.
    temp6-weightunit = `KG`.
    temp6-price = `288`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `ITelo MusicStick`.
    temp6-productid = `HT-6120`.
    temp6-suppliername = `Fasttech`.
    temp6-width = `1.5`.
    temp6-depth = `6`.
    temp6-height = `1`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `134`.
    temp6-weightunit = `G`.
    temp6-price = `45`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `ITelo Jog-Mate`.
    temp6-productid = `HT-6121`.
    temp6-suppliername = `Fasttech`.
    temp6-width = `5.1`.
    temp6-depth = `8`.
    temp6-height = `9.2`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `134`.
    temp6-weightunit = `G`.
    temp6-price = `63`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Power Pro Player 40`.
    temp6-productid = `HT-6122`.
    temp6-suppliername = `Fasttech`.
    temp6-width = `5.1`.
    temp6-depth = `8`.
    temp6-height = `9.2`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `266`.
    temp6-weightunit = `G`.
    temp6-price = `167`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Power Pro Player 80`.
    temp6-productid = `HT-6123`.
    temp6-suppliername = `Fasttech`.
    temp6-width = `4`.
    temp6-depth = `6`.
    temp6-height = `0.8`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `267`.
    temp6-weightunit = `G`.
    temp6-price = `299`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Flat Watch HD32`.
    temp6-productid = `HT-6130`.
    temp6-suppliername = `Very Best Screens`.
    temp6-width = `78`.
    temp6-depth = `22.1`.
    temp6-height = `55`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `2.6`.
    temp6-weightunit = `KG`.
    temp6-price = `1459`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Flat Watch HD37`.
    temp6-productid = `HT-6131`.
    temp6-suppliername = `Very Best Screens`.
    temp6-width = `99.1`.
    temp6-depth = `26`.
    temp6-height = `61`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `2.2`.
    temp6-weightunit = `KG`.
    temp6-price = `1199`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Flat Watch HD41`.
    temp6-productid = `HT-6132`.
    temp6-suppliername = `Very Best Screens`.
    temp6-width = `128`.
    temp6-depth = `23`.
    temp6-height = `79.1`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `1.8`.
    temp6-weightunit = `KG`.
    temp6-price = `899`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Copperberry`.
    temp6-productid = `HT-7000`.
    temp6-suppliername = `Fasttech`.
    temp6-width = `8.1`.
    temp6-depth = `13`.
    temp6-height = `12.1`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.5`.
    temp6-weightunit = `KG`.
    temp6-price = `549`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Silverberry`.
    temp6-productid = `HT-7010`.
    temp6-suppliername = `Fasttech`.
    temp6-width = `8.1`.
    temp6-depth = `13`.
    temp6-height = `12.1`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.5`.
    temp6-weightunit = `KG`.
    temp6-price = `549`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Goldberry`.
    temp6-productid = `HT-7020`.
    temp6-suppliername = `Fasttech`.
    temp6-width = `8.1`.
    temp6-depth = `13`.
    temp6-height = `12.1`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.5`.
    temp6-weightunit = `KG`.
    temp6-price = `549`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Platinberry`.
    temp6-productid = `HT-7030`.
    temp6-suppliername = `Fasttech`.
    temp6-width = `8.1`.
    temp6-depth = `13`.
    temp6-height = `12.1`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.5`.
    temp6-weightunit = `KG`.
    temp6-price = `549`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `ITelO FlexTop I4000`.
    temp6-productid = `HT-8000`.
    temp6-suppliername = `Titanium`.
    temp6-width = `31`.
    temp6-depth = `19`.
    temp6-height = `3.1`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `4`.
    temp6-weightunit = `KG`.
    temp6-price = `799`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `ITelO FlexTop I6300c`.
    temp6-productid = `HT-8001`.
    temp6-suppliername = `Titanium`.
    temp6-width = `32`.
    temp6-depth = `20`.
    temp6-height = `3.4`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `4.2`.
    temp6-weightunit = `KG`.
    temp6-price = `799`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `ITelO FlexTop I9100`.
    temp6-productid = `HT-8002`.
    temp6-suppliername = `Titanium`.
    temp6-width = `38`.
    temp6-depth = `21`.
    temp6-height = `4.1`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `3.5`.
    temp6-weightunit = `KG`.
    temp6-price = `1199`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `ITelO FlexTop I9800`.
    temp6-productid = `HT-8003`.
    temp6-suppliername = `Titanium`.
    temp6-width = `48`.
    temp6-depth = `31`.
    temp6-height = `4.5`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `3.8`.
    temp6-weightunit = `KG`.
    temp6-price = `1388`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Smartphone Leather Case`.
    temp6-productid = `HT-9991`.
    temp6-suppliername = `Ultrasonic United`.
    temp6-width = `48`.
    temp6-depth = `31`.
    temp6-height = `4.5`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.02`.
    temp6-weightunit = `KG`.
    temp6-price = `25`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Smartphone Alpha`.
    temp6-productid = `HT-9992`.
    temp6-suppliername = `Ultrasonic United`.
    temp6-width = `48`.
    temp6-depth = `31`.
    temp6-height = `4.5`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.75`.
    temp6-weightunit = `KG`.
    temp6-price = `599`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Mini Tablet`.
    temp6-productid = `HT-9993`.
    temp6-suppliername = `Ultrasonic United`.
    temp6-width = `48`.
    temp6-depth = `31`.
    temp6-height = `4.5`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `3.8`.
    temp6-weightunit = `KG`.
    temp6-price = `833`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Camcorder View`.
    temp6-productid = `HT-9994`.
    temp6-suppliername = `Ultrasonic United`.
    temp6-width = `48`.
    temp6-depth = `31`.
    temp6-height = `27`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `3.8`.
    temp6-weightunit = `KG`.
    temp6-price = `1388`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Tablet Pouch`.
    temp6-productid = `HT-9995`.
    temp6-suppliername = `Titanium`.
    temp6-width = `25`.
    temp6-depth = `40`.
    temp6-height = `4.5`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.03`.
    temp6-weightunit = `KG`.
    temp6-price = `20`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Tablet Pouch`.
    temp6-productid = `HT-9996`.
    temp6-suppliername = `Titanium`.
    temp6-width = `25`.
    temp6-depth = `40`.
    temp6-height = `4.5`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.03`.
    temp6-weightunit = `KG`.
    temp6-price = `20`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `e-Book Reader ReadMe`.
    temp6-productid = `HT-9997`.
    temp6-suppliername = `Titanium`.
    temp6-width = `48`.
    temp6-depth = `31`.
    temp6-height = `4.5`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `3.8`.
    temp6-weightunit = `KG`.
    temp6-price = `33`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Smartphone Beta`.
    temp6-productid = `HT-9998`.
    temp6-suppliername = `Titanium`.
    temp6-width = `48`.
    temp6-depth = `31`.
    temp6-height = `4.5`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.75`.
    temp6-weightunit = `KG`.
    temp6-price = `30`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Maxi Tablet`.
    temp6-productid = `HT-9999`.
    temp6-suppliername = `Titanium`.
    temp6-width = `48`.
    temp6-depth = `31`.
    temp6-height = `4.5`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `3.8`.
    temp6-weightunit = `KG`.
    temp6-price = `749`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Flyer`.
    temp6-productid = `PF-1000`.
    temp6-suppliername = `Titanium`.
    temp6-width = `46`.
    temp6-depth = `30`.
    temp6-height = `3`.
    temp6-dimunit = `cm`.
    temp6-weightmeasure = `0.01`.
    temp6-weightunit = `KG`.
    temp6-price = `0`.
    temp6-currencycode = `EUR`.
    INSERT temp6 INTO TABLE temp5.
    t_all = temp5.

    " weightState is business logic (KG conversion + Success/Warning/Error
    " thresholds), not presentation - abap2UI5 is a thin frontend, so the
    " ObjectNumber state is computed here in the backend. TableOutdated reuses the
    " sap.m.sample.Table COMPONENT, so it inherits that sample's Formatter.js:
    " thresholds 1 and 5 KG with G converted, NOT the 1000/2000 raw thresholds the
    " TableSelectDialog family uses (app 009 computes the identical rule).
    
    
    LOOP AT t_all REFERENCE INTO lr_product.
      
      weight_kg = lr_product->weightmeasure.
      IF lr_product->weightunit = `G`.
        weight_kg = weight_kg / 1000.
      ENDIF.
      
      IF weight_kg < 0.
        temp8 = `None`.
      ELSEIF weight_kg < 1.
        temp8 = `Success`.
      ELSEIF weight_kg < 5.
        temp8 = `Warning`.
      ELSE.
        temp8 = `Error`.
      ENDIF.
      lr_product->weightstate = temp8.
    ENDLOOP.

    t_products = t_all.

  ENDMETHOD.

ENDCLASS.
