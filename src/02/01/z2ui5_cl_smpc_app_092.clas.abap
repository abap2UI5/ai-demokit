" @keywords table sap.m automatic pop-in column importance messagestrip slider overflowtoolbar title toolbarspacer label
" @summary This example demonstrates the automatic pop-in behavior of the table and hiding columns instead of moving them into the pop-in depending on their importance.
CLASS z2ui5_cl_smpc_app_092 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name           TYPE string,
        product_id     TYPE string,
        description    TYPE string,
        category       TYPE string,
        main_category  TYPE string,
        supplier_name  TYPE string,
        width          TYPE string,
        depth          TYPE string,
        height         TYPE string,
        dim_unit       TYPE string,
        weight_measure TYPE string,
        weight_unit    TYPE string,
        weight_state   TYPE string,
        quantity       TYPE string,
        price          TYPE p LENGTH 8 DECIMALS 2,
        currency_code  TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.
    DATA t_hidden   TYPE string_table.
    DATA width_pct  TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_092 IMPLEMENTATION.

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

    
    CLEAR temp1.
    INSERT `MESSAGE_TOAST` INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    INSERT `Number of hidden pop-ins: {0}` INTO TABLE temp1.
    INSERT `${$parameters>/hiddenInPopin}.length` INTO TABLE temp1.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `height`     v = `100%`

        )->tag( `MessageStrip`
            )->a( n = `id`              v = `idMessageStrip`
            )->a( n = `text`            v = `Move the slider to see the automatic pop-in behavior based on the importance of the columns.`
            )->a( n = `type`            v = `Success`
            )->a( n = `showIcon`        v = `true`
            )->a( n = `showCloseButton` v = `true`
            )->a( n = `class`           v = `sapUiMediumMarginBottom`

        )->tag( `Slider`
            )->a( n = `id`         v = `widthSlider`
            )->a( n = `value`      v = client->_bind( width_pct )

        )->ele( `Table`
            )->a( n = `id`              v = `idProductsTable`
            )->a( n = `autoPopinMode`   v = `true`
            )->a( n = `contextualWidth` v = `Auto`
            " hiddenInPopin is a bindable property; the MultiComboBox's
            " selectedKeys already IS the Priority array the original hands to
            " setHiddenInPopin, so both bind the same field
            )->a( n = `hiddenInPopin`   v = client->_bind( t_hidden )
            )->a( n = `width`           v = |\{= ${ client->_bind( width_pct ) } + '%' \}|
            " onPopinChanged: MessageToast.show('Number of hidden pop-ins: ' +
            " hiddenInPopin.length) - client-composed, roundtrip-free
            )->a( n = `popinChanged`    v = client->follow_up_action( val   = client->cs_event-control_global
                                                                      t_arg = temp1 )
            )->a( n = `items`           v = |\{ path: '{ client->_bind_path( t_products ) }', sorter: \{ path: 'NAME' \} \}|

            )->ele( `headerToolbar`
                )->ele( `OverflowToolbar`
                    )->tag( `Title`
                        )->a( n = `text`  v = `Products`
                        )->a( n = `level` v = `H2`
                    )->tag( `ToolbarSpacer`
                    )->tag( `Label`
                        )->a( n = `text`     v = `Hide columns with importance`
                        )->a( n = `labelFor` v = `idMultiComboBox`
                    )->ele( `MultiComboBox`
                        )->a( n = `id`              v = `idMultiComboBox`
                        )->a( n = `width`           v = `10rem`
                        )->a( n = `selectedKeys`    v = client->_bind( t_hidden )
                        " abap2ui5lint-disable-next-line event-without-handler -- the roundtrip alone is the point: selectedKeys is written back into t_hidden, which hiddenInPopin is bound to
                        )->a( n = `selectionFinish` v = client->_event( `HIDE` )
                        )->ele( `items`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `None`
                                )->a( n = `text` v = `None`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `Low`
                                )->a( n = `text` v = `Low`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `Medium`
                                )->a( n = `text` v = `Medium`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `High`
                                )->a( n = `text` v = `High`

                        )->end(
                    )->end(
                )->end(
            )->end(

            )->ele( `columns`
                )->ele( `Column`
                    )->a( n = `width`      v = `14em`
                    )->a( n = `importance` v = `High`
                    )->tag( `Text`
                        )->a( n = `text` v = `Product`

                )->end(
                )->ele( `Column`
                    )->a( n = `width`      v = `auto`
                    )->a( n = `importance` v = `None`
                    )->tag( `Text`
                        )->a( n = `text` v = `Description`

                )->end(
                )->ele( `Column`
                    )->a( n = `width`      v = `8em`
                    )->a( n = `importance` v = `Low`
                    )->tag( `Text`
                        )->a( n = `text` v = `Category`

                )->end(
                )->ele( `Column`
                    )->a( n = `width`      v = `8%`
                    )->a( n = `importance` v = `None`
                    )->tag( `Text`
                        )->a( n = `text` v = `Main Category`

                )->end(
                )->ele( `Column`
                    )->a( n = `width`      v = `8em`
                    )->a( n = `importance` v = `None`
                    )->tag( `Text`
                        )->a( n = `text` v = `Supplier`

                )->end(
                )->ele( `Column`
                    )->a( n = `width`      v = `10em`
                    )->a( n = `importance` v = `Low`
                    )->tag( `Text`
                        )->a( n = `text` v = `Dimensions`

                )->end(
                )->ele( `Column`
                    )->a( n = `width`      v = `6em`
                    )->a( n = `hAlign`     v = `Center`
                    )->a( n = `importance` v = `Low`
                    )->tag( `Text`
                        )->a( n = `text` v = `Weight`

                )->end(
                )->ele( `Column`
                    )->a( n = `width`      v = `6%`
                    )->a( n = `hAlign`     v = `Center`
                    )->a( n = `importance` v = `Medium`
                    )->tag( `Text`
                        )->a( n = `text` v = `Quantity`

                )->end(
                )->ele( `Column`
                    )->a( n = `width`      v = `6em`
                    )->a( n = `hAlign`     v = `End`
                    )->a( n = `importance` v = `High`
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
                            )->a( n = `text`  v = `{PRODUCT_ID}`
                        )->tag( `Text`
                            )->a( n = `text` v = `{DESCRIPTION}`
                        )->tag( `Text`
                            )->a( n = `text` v = `{CATEGORY}`
                        )->tag( `Text`
                            )->a( n = `text` v = `{MAIN_CATEGORY}`
                        )->tag( `Text`
                            )->a( n = `text` v = `{SUPPLIER_NAME}`
                        )->tag( `Text`
                            )->a( n = `text` v = `{WIDTH} x {DEPTH} x {HEIGHT} {DIM_UNIT}`
                        )->tag( `ObjectNumber`
                            )->a( n = `number` v = `{WEIGHT_MEASURE}`
                            )->a( n = `unit`   v = `{WEIGHT_UNIT}`
                            )->a( n = `state`  v = `{WEIGHT_STATE}`
                        )->tag( `ObjectNumber`
                            )->a( n = `number` v = `{QUANTITY}`
                        )->tag( `ObjectNumber`
                            )->a( n = `number` v = |\{ parts:[\{path:'PRICE'\},\{path:'CURRENCY_CODE'\}], type: 'sap.ui.model.type.Currency', formatOptions: \{showMeasure: false\} \}|
                            )->a( n = `unit`   v = `{CURRENCY_CODE}`

                    )->end(
                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    " HIDE / selectionFinish needs no handler: the MultiComboBox keys arrive
    " two-way bound in t_hidden, and the table's hiddenInPopin is bound to the
    " same field - so the sample's setHiddenInPopin( getSelectedKeys( ) ) is
    " already done by the model push this round-trip ends in.

  ENDMETHOD.


  METHOD model_init.
    DATA temp3 LIKE t_products.
    DATA temp4 LIKE LINE OF temp3.
    DATA temp5 LIKE LINE OF t_products.
    DATA lr_product LIKE REF TO temp5.
      DATA weight_kg LIKE lr_product->weight_measure.
      DATA temp6 TYPE z2ui5_cl_smpc_app_092=>ty_s_product-weight_state.

    " Slider starts at 100 (%) - the table fills its container, like the original
    width_pct = 100.

    " full mock /ProductCollection (sap/ui/demo/mock/products.json), verbatim
    
    CLEAR temp3.
    
    temp4-name = `Notebook Basic 15`.
    temp4-product_id = `HT-1000`.
    temp4-category = `Laptops`.
    temp4-main_category = `Computer Systems`.
    temp4-supplier_name = `Very Best Screens`.
    temp4-description = `Notebook Basic 15 with 2,80 GHz quad core, 15" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`.
    temp4-width = `30`.
    temp4-depth = `18`.
    temp4-height = `3`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `4.2`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `10`.
    temp4-price = '956.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Basic 17`.
    temp4-product_id = `HT-1001`.
    temp4-category = `Laptops`.
    temp4-main_category = `Computer Systems`.
    temp4-supplier_name = `Very Best Screens`.
    temp4-description = `Notebook Basic 17 with 2,80 GHz quad core, 17" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`.
    temp4-width = `29`.
    temp4-depth = `17`.
    temp4-height = `3.1`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `4.5`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `20`.
    temp4-price = '1249.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Basic 18`.
    temp4-product_id = `HT-1002`.
    temp4-category = `Laptops`.
    temp4-main_category = `Computer Systems`.
    temp4-supplier_name = `Very Best Screens`.
    temp4-description = `Notebook Basic 18 with 2,80 GHz quad core, 18" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro`.
    temp4-width = `28`.
    temp4-depth = `19`.
    temp4-height = `2.5`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `4.2`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `10`.
    temp4-price = '1570.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Basic 19`.
    temp4-product_id = `HT-1003`.
    temp4-category = `Laptops`.
    temp4-main_category = `Computer Systems`.
    temp4-supplier_name = `Smartcards`.
    temp4-description = `Notebook Basic 19 with 2,80 GHz quad core, 19" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro`.
    temp4-width = `32`.
    temp4-depth = `21`.
    temp4-height = `4`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `4.2`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `15`.
    temp4-price = '1650.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO Vault`.
    temp4-product_id = `HT-1007`.
    temp4-category = `Accessories`.
    temp4-main_category = `Computer Components`.
    temp4-supplier_name = `Technocom`.
    temp4-description = `Digital Organizer with State-of-the-Art Storage Encryption`.
    temp4-width = `32`.
    temp4-depth = `22`.
    temp4-height = `3`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.2`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `15`.
    temp4-price = '299.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Professional 15`.
    temp4-product_id = `HT-1010`.
    temp4-category = `Accessories`.
    temp4-main_category = `Computer Systems`.
    temp4-supplier_name = `Very Best Screens`.
    temp4-description = `Notebook Professional 15 with 2,80 GHz quad core, 15" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro`.
    temp4-width = `33`.
    temp4-depth = `20`.
    temp4-height = `3`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `4.3`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `16`.
    temp4-price = '1999.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Professional 17`.
    temp4-product_id = `HT-1011`.
    temp4-category = `Laptops`.
    temp4-main_category = `Computer Systems`.
    temp4-supplier_name = `Very Best Screens`.
    temp4-description = `Notebook Professional 17 with 2,80 GHz quad core, 17" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro`.
    temp4-width = `33`.
    temp4-depth = `23`.
    temp4-height = `2`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `4.1`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `17`.
    temp4-price = '2299.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO Vault Net`.
    temp4-product_id = `HT-1020`.
    temp4-category = `Accessories`.
    temp4-main_category = `Computer Components`.
    temp4-supplier_name = `Technocom`.
    temp4-description = `Digital Organizer with State-of-the-Art Encryption for Storage and Network Communications`.
    temp4-width = `10`.
    temp4-depth = `1.8`.
    temp4-height = `17`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.16`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `14`.
    temp4-price = '459.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO Vault SAT`.
    temp4-product_id = `HT-1021`.
    temp4-category = `Accessories`.
    temp4-main_category = `Computer Components`.
    temp4-supplier_name = `Technocom`.
    temp4-description = `Digital Organizer with State-of-the-Art Encryption for Storage and Secure Stellite Link`.
    temp4-width = `11`.
    temp4-depth = `1.7`.
    temp4-height = `18`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.18`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `50`.
    temp4-price = '149.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Comfort Easy`.
    temp4-product_id = `HT-1022`.
    temp4-category = `Accessories`.
    temp4-main_category = `Computer Components`.
    temp4-supplier_name = `Technocom`.
    temp4-description = `32 GB Digital Assistant with high-resolution color screen`.
    temp4-width = `84`.
    temp4-depth = `1.5`.
    temp4-height = `14`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.2`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `30`.
    temp4-price = '1679.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Comfort Senior`.
    temp4-product_id = `HT-1023`.
    temp4-category = `Accessories`.
    temp4-main_category = `Computer Components`.
    temp4-supplier_name = `Technocom`.
    temp4-description = `64 GB Digital Assistant with high-resolution color screen and synthesized voice output`.
    temp4-width = `80`.
    temp4-depth = `1.6`.
    temp4-height = `13`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.8`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `24`.
    temp4-price = '512.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergo Screen E-I`.
    temp4-product_id = `HT-1030`.
    temp4-category = `Flat Screen Monitors`.
    temp4-main_category = `Computer Components`.
    temp4-supplier_name = `Very Best Screens`.
    temp4-description = `Optimum Hi-Resolution max. 1920 x 1080 @ 85Hz, Dot Pitch: 0.27mm`.
    temp4-width = `37`.
    temp4-depth = `12`.
    temp4-height = `36`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `21`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `14`.
    temp4-price = '230.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergo Screen E-II`.
    temp4-product_id = `HT-1031`.
    temp4-category = `Flat Screen Monitors`.
    temp4-main_category = `Computer Components`.
    temp4-supplier_name = `Very Best Screens`.
    temp4-description = `Optimum Hi-Resolution max. 1920 x 1200 @ 85Hz, Dot Pitch: 0.26mm`.
    temp4-width = `40.8`.
    temp4-depth = `19`.
    temp4-height = `43`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `21`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `24`.
    temp4-price = '285.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergo Screen E-III`.
    temp4-product_id = `HT-1032`.
    temp4-category = `Flat Screen Monitors`.
    temp4-main_category = `Computer Components`.
    temp4-supplier_name = `Very Best Screens`.
    temp4-description = `Optimum Hi-Resolution max. 2560 x 1440 @ 85Hz, Dot Pitch: 0.25mm`.
    temp4-width = `40.8`.
    temp4-depth = `19`.
    temp4-height = `43`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `21`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `50`.
    temp4-price = '345.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Basic`.
    temp4-product_id = `HT-1035`.
    temp4-category = `Flat Screen Monitors`.
    temp4-main_category = `Computer Components`.
    temp4-supplier_name = `Very Best Screens`.
    temp4-description = `Optimum Hi-Resolution max. 1600 x 1200 @ 85Hz, Dot Pitch: 0.24mm`.
    temp4-width = `39`.
    temp4-depth = `20`.
    temp4-height = `41`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `14`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `23`.
    temp4-price = '399.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Future`.
    temp4-product_id = `HT-1036`.
    temp4-category = `Flat Screen Monitors`.
    temp4-main_category = `Computer Components`.
    temp4-supplier_name = `Very Best Screens`.
    temp4-description = `Optimum Hi-Resolution max. 2048 x 1080 @ 85Hz, Dot Pitch: 0.26mm`.
    temp4-width = `45`.
    temp4-depth = `26`.
    temp4-height = `46`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `15`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `22`.
    temp4-price = '430.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat XL`.
    temp4-product_id = `HT-1037`.
    temp4-category = `Flat Screen Monitors`.
    temp4-main_category = `Computer Components`.
    temp4-supplier_name = `Very Best Screens`.
    temp4-description = `Optimum Hi-Resolution max. 2016 x 1512 @ 85Hz, Dot Pitch: 0.24mm`.
    temp4-width = `54.5`.
    temp4-depth = `22.1`.
    temp4-height = `39.1`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `17`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `23`.
    temp4-price = '1230.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Laser Professional Eco`.
    temp4-product_id = `HT-1040`.
    temp4-category = `Printers`.
    temp4-main_category = `Printers & Scanners`.
    temp4-supplier_name = `Alpha Printers`.
    temp4-description = `Print 2400 dpi image quality color documents at speeds of up to 32 ppm (color) or 36 ppm (monochrome), letter/A4. Powerful 500 MHz processor, 512MB of memory`.
    temp4-width = `51`.
    temp4-depth = `46`.
    temp4-height = `30`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `32`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `21`.
    temp4-price = '830.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Laser Basic`.
    temp4-product_id = `HT-1041`.
    temp4-category = `Printers`.
    temp4-main_category = `Printers & Scanners`.
    temp4-supplier_name = `Alpha Printers`.
    temp4-description = `Up to 22 ppm color or 24 ppm monochrome A4/letter, powerful 500 MHz processor and 128MB of memory`.
    temp4-width = `48`.
    temp4-depth = `42`.
    temp4-height = `26`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `23`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `8`.
    temp4-price = '490.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Laser Allround`.
    temp4-product_id = `HT-1042`.
    temp4-category = `Printers`.
    temp4-main_category = `Printers & Scanners`.
    temp4-supplier_name = `Alpha Printers`.
    temp4-description = `Print up to 25 ppm letter and 24 ppm A4 color or monochrome, with Available first-page-out-time of less than 13 seconds for monochrome and less than 15 seconds for color`.
    temp4-width = `53`.
    temp4-depth = `50`.
    temp4-height = `65`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `17`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `9`.
    temp4-price = '349.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ultra Jet Super Color`.
    temp4-product_id = `HT-1050`.
    temp4-category = `Printers`.
    temp4-main_category = `Printers & Scanners`.
    temp4-supplier_name = `Alpha Printers`.
    temp4-description = `4800 dpi x 1200 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB, Ethernet`.
    temp4-width = `41`.
    temp4-depth = `41`.
    temp4-height = `28`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `3`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `17`.
    temp4-price = '139.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ultra Jet Mobile`.
    temp4-product_id = `HT-1051`.
    temp4-category = `Printers`.
    temp4-main_category = `Printers & Scanners`.
    temp4-supplier_name = `Printer for All`.
    temp4-description = `1000 dpi x 1000 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB - excellent dimensions for the small office`.
    temp4-width = `46`.
    temp4-depth = `32`.
    temp4-height = `25`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `1.9`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `18`.
    temp4-price = '99.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ultra Jet Super Highspeed`.
    temp4-product_id = `HT-1052`.
    temp4-category = `Printers`.
    temp4-main_category = `Printers & Scanners`.
    temp4-supplier_name = `Printer for All`.
    temp4-description = `4800 dpi x 1200 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB2.0, Ethernet`.
    temp4-width = `41`.
    temp4-depth = `41`.
    temp4-height = `28`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `18`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `25`.
    temp4-price = '170.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Multi Print`.
    temp4-product_id = `HT-1055`.
    temp4-category = `Multifunction Printers`.
    temp4-main_category = `Printers & Scanners`.
    temp4-supplier_name = `Printer for All`.
    temp4-description = `1000 dpi x 1000 dpi - up to 16 ppm (mono) / up to 15 ppm (color)- capacity 80 sheets - scanner (216 x 297 mm, 1200dpi x 2400dpi)`.
    temp4-width = `55`.
    temp4-depth = `45`.
    temp4-height = `29`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `6.3`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `16`.
    temp4-price = '99.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Multi Color`.
    temp4-product_id = `HT-1056`.
    temp4-category = `Multifunction Printers`.
    temp4-main_category = `Printers & Scanners`.
    temp4-supplier_name = `Printer for All`.
    temp4-description = `1200 dpi x 1200 dpi - up to 25 ppm (mono) / up to 24 ppm (color)- capacity 80 sheets - scanner (216 x 297 mm, 2400dpi x 4800dpi, high resolution)`.
    temp4-width = `51`.
    temp4-depth = `41.3`.
    temp4-height = `22`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `4.3`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `5`.
    temp4-price = '119.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cordless Mouse`.
    temp4-product_id = `HT-1060`.
    temp4-category = `Mice`.
    temp4-main_category = `Computer Components`.
    temp4-supplier_name = `Oxynum`.
    temp4-description = `Cordless Optical USB Mice, Laptop, Color: Black, Plug&Play`.
    temp4-width = `6`.
    temp4-depth = `14.5`.
    temp4-height = `3.5`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.09`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `25`.
    temp4-price = '9.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Speed Mouse`.
    temp4-product_id = `HT-1061`.
    temp4-category = `Mice`.
    temp4-main_category = `Computer Components`.
    temp4-supplier_name = `Oxynum`.
    temp4-description = `Optical USB, PS/2 Mouse, Color: Blue, 3-button-functionality (incl. Scroll wheel)`.
    temp4-width = `7`.
    temp4-depth = `15`.
    temp4-height = `3.1`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.09`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `12`.
    temp4-price = '7.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Track Mouse`.
    temp4-product_id = `HT-1062`.
    temp4-category = `Mice`.
    temp4-main_category = `Computer Components`.
    temp4-supplier_name = `Oxynum`.
    temp4-description = `Optical USB Mouse, Color: Red, 5-button-functionality(incl. Scroll wheel), Plug&Play`.
    temp4-width = `3`.
    temp4-depth = `7`.
    temp4-height = `4`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.03`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `12`.
    temp4-price = '11.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergonomic Keyboard`.
    temp4-product_id = `HT-1063`.
    temp4-category = `Keyboards`.
    temp4-main_category = `Computer Components`.
    temp4-supplier_name = `Oxynum`.
    temp4-description = `Ergonomic USB Keyboard for Desktop, Plug&Play`.
    temp4-width = `50`.
    temp4-depth = `21`.
    temp4-height = `3.5`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `2.1`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `50`.
    temp4-price = '14.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Internet Keyboard`.
    temp4-product_id = `HT-1064`.
    temp4-category = `Keyboards`.
    temp4-main_category = `Computer Components`.
    temp4-supplier_name = `Oxynum`.
    temp4-description = `Corded Keyboard with special keys for Internet Usability, USB`.
    temp4-width = `52`.
    temp4-depth = `25`.
    temp4-height = `3`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `1.8`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `35`.
    temp4-price = '16.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Media Keyboard`.
    temp4-product_id = `HT-1065`.
    temp4-category = `Keyboards`.
    temp4-main_category = `Computer Components`.
    temp4-supplier_name = `Oxynum`.
    temp4-description = `Corded Ergonomic Keyboard with special keys for Media Usability, USB`.
    temp4-width = `51.4`.
    temp4-depth = `23`.
    temp4-height = `4`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `2.3`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `26`.
    temp4-price = '26.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Mousepad`.
    temp4-product_id = `HT-1066`.
    temp4-category = `Mousepads`.
    temp4-main_category = `Computer Components`.
    temp4-supplier_name = `Oxynum`.
    temp4-description = `Nice mouse pad with ITelO Logo`.
    temp4-width = `15`.
    temp4-depth = `6`.
    temp4-height = `0.2`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `80`.
    temp4-weight_unit = `G`.
    temp4-quantity = `12`.
    temp4-price = '6.99'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergo Mousepad`.
    temp4-product_id = `HT-1067`.
    temp4-category = `Mousepads`.
    temp4-main_category = `Computer Components`.
    temp4-supplier_name = `Oxynum`.
    temp4-description = `Ergonomic mouse pad with ITelO Logo`.
    temp4-width = `15`.
    temp4-depth = `6`.
    temp4-height = `0.2`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `80`.
    temp4-weight_unit = `G`.
    temp4-quantity = `16`.
    temp4-price = '8.99'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Designer Mousepad`.
    temp4-product_id = `HT-1068`.
    temp4-category = `Mousepads`.
    temp4-main_category = `Computer Components`.
    temp4-supplier_name = `Fasttech`.
    temp4-description = `ITelO Mousepad Special Edition`.
    temp4-width = `24`.
    temp4-depth = `24`.
    temp4-height = `0.6`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `90`.
    temp4-weight_unit = `G`.
    temp4-quantity = `26`.
    temp4-price = '12.99'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Universal card reader`.
    temp4-product_id = `HT-1069`.
    temp4-category = `Computer System Accessories`.
    temp4-main_category = `Computer Systems`.
    temp4-supplier_name = `Fasttech`.
    temp4-description = `Universal card reader`.
    temp4-width = `6`.
    temp4-depth = `6`.
    temp4-height = `3`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `45`.
    temp4-weight_unit = `G`.
    temp4-quantity = `22`.
    temp4-price = '14.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Proctra X`.
    temp4-product_id = `HT-1070`.
    temp4-category = `Graphic Cards`.
    temp4-main_category = `Computer Components`.
    temp4-supplier_name = `Ultrasonic United`.
    temp4-description = `Proctra X: PCI-E GDDR5 3072MB`.
    temp4-width = `22`.
    temp4-depth = `35`.
    temp4-height = `17`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.255`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `15`.
    temp4-price = '70.90'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Gladiator MX`.
    temp4-product_id = `HT-1071`.
    temp4-category = `Graphic Cards`.
    temp4-main_category = `Computer Components`.
    temp4-supplier_name = `Ultrasonic United`.
    temp4-description = `Gladiator XLN: PCI-E GDDR5 3072MB DVI Out, TV Out low-noise`.
    temp4-width = `22`.
    temp4-depth = `35`.
    temp4-height = `17`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.3`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `16`.
    temp4-price = '81.70'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Hurricane GX`.
    temp4-product_id = `HT-1072`.
    temp4-category = `Graphic Cards`.
    temp4-main_category = `Computer Components`.
    temp4-supplier_name = `Ultrasonic United`.
    temp4-description = `Hurricane GX: PCI-E 691 GFLOPS game-optimized`.
    temp4-width = `22`.
    temp4-depth = `35`.
    temp4-height = `17`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.4`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `13`.
    temp4-price = '101.20'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Hurricane GX/LN`.
    temp4-product_id = `HT-1073`.
    temp4-category = `Graphic Cards`.
    temp4-main_category = `Computer Components`.
    temp4-supplier_name = `Smartcards`.
    temp4-description = `Hurricane GX/LN: PCI-E 691 GFLOPS game-optimized, low-noise.`.
    temp4-width = `22`.
    temp4-depth = `35`.
    temp4-height = `17`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.4`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `5`.
    temp4-price = '139.99'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Photo Scan`.
    temp4-product_id = `HT-1080`.
    temp4-category = `Scanners`.
    temp4-main_category = `Printers & Scanners`.
    temp4-supplier_name = `Printer for All`.
    temp4-description = `Flatbed scanner - 9.600 × 9.600 dpi - 216 x 297 mm - Hi-Speed USB - Bluetooth`.
    temp4-width = `34`.
    temp4-depth = `48`.
    temp4-height = `5`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `2.3`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `8`.
    temp4-price = '129.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Power Scan`.
    temp4-product_id = `HT-1081`.
    temp4-category = `Scanners`.
    temp4-main_category = `Printers & Scanners`.
    temp4-supplier_name = `Printer for All`.
    temp4-description = `Flatbed scanner - 9.600 × 9.600 dpi - 216 x 297 mm - SCSI for backward compatibility`.
    temp4-width = `31`.
    temp4-depth = `43`.
    temp4-height = `7`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `2.4`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `11`.
    temp4-price = '89.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Jet Scan Professional`.
    temp4-product_id = `HT-1082`.
    temp4-category = `Scanners`.
    temp4-main_category = `Printers & Scanners`.
    temp4-supplier_name = `Printer for All`.
    temp4-description = `Flatbed scanner - Letter - 2400 dpi x 2400 dpi - 216 x 297 mm - add-on module`.
    temp4-width = `33`.
    temp4-depth = `41`.
    temp4-height = `12`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `3.2`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `13`.
    temp4-price = '169.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Jet Scan Professional`.
    temp4-product_id = `HT-1083`.
    temp4-category = `Scanners`.
    temp4-main_category = `Printers & Scanners`.
    temp4-supplier_name = `Printer for All`.
    temp4-description = `Flatbed scanner - A4 - 2400 dpi x 2400 dpi - 216 x 297 mm - add-on module`.
    temp4-width = `35`.
    temp4-depth = `40`.
    temp4-height = `10`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `3.2`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `10`.
    temp4-price = '189.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Copymaster`.
    temp4-product_id = `HT-1085`.
    temp4-category = `Multifunction Printers`.
    temp4-main_category = `Printers & Scanners`.
    temp4-supplier_name = `Alpha Printers`.
    temp4-description = `Copymaster`.
    temp4-width = `45`.
    temp4-depth = `42`.
    temp4-height = `22`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `23.2`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `10`.
    temp4-price = '1499.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Surround Sound`.
    temp4-product_id = `HT-1090`.
    temp4-category = `Speakers`.
    temp4-main_category = `Computer Components`.
    temp4-supplier_name = `Speaker Experts`.
    temp4-description = `PC multimedia speakers - 5 Watt (Total)`.
    temp4-width = `12`.
    temp4-depth = `10`.
    temp4-height = `16`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `3`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `20`.
    temp4-price = '39.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Blaster Extreme`.
    temp4-product_id = `HT-1091`.
    temp4-category = `Speakers`.
    temp4-main_category = `Computer Components`.
    temp4-supplier_name = `Speaker Experts`.
    temp4-description = `PC multimedia speakers - 10 Watt (Total) - 2-way`.
    temp4-width = `13`.
    temp4-depth = `11`.
    temp4-height = `17.5`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `1.4`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `15`.
    temp4-price = '26.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Sound Booster`.
    temp4-product_id = `HT-1092`.
    temp4-category = `Speakers`.
    temp4-main_category = `Computer Components`.
    temp4-supplier_name = `Speaker Experts`.
    temp4-description = `PC multimedia speakers - optimized for Blutooth/A2DP`.
    temp4-width = `12.4`.
    temp4-depth = `10.4`.
    temp4-height = `18.1`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `2.1`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `50`.
    temp4-price = '45.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Lovely Sound 5.1 Wireless`.
    temp4-product_id = `HT-1095`.
    temp4-category = `Accessories`.
    temp4-main_category = `Computer Components`.
    temp4-supplier_name = `Fasttech`.
    temp4-description = `5.1 Headset, 40 Hz-20 kHz, Wireless`.
    temp4-width = `24`.
    temp4-depth = `19`.
    temp4-height = `23`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `80`.
    temp4-weight_unit = `G`.
    temp4-quantity = `12`.
    temp4-price = '49.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Lovely Sound 5.1`.
    temp4-product_id = `HT-1096`.
    temp4-category = `Accessories`.
    temp4-main_category = `Computer Components`.
    temp4-supplier_name = `Fasttech`.
    temp4-description = `5.1 Headset, 40 Hz-20 kHz, 3m cable`.
    temp4-width = `25`.
    temp4-depth = `17`.
    temp4-height = `19`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `130`.
    temp4-weight_unit = `G`.
    temp4-quantity = `18`.
    temp4-price = '39.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Lovely Sound Stereo`.
    temp4-product_id = `HT-1097`.
    temp4-category = `Accessories`.
    temp4-main_category = `Computer Components`.
    temp4-supplier_name = `Fasttech`.
    temp4-description = `5.1 Headset, 40 Hz-20 kHz, 1m cable`.
    temp4-width = `21.3`.
    temp4-depth = `2.4`.
    temp4-height = `19.7`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `60`.
    temp4-weight_unit = `G`.
    temp4-quantity = `21`.
    temp4-price = '29.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Office`.
    temp4-product_id = `HT-1100`.
    temp4-category = `Software`.
    temp4-main_category = `Software`.
    temp4-supplier_name = `Technocom`.
    temp4-description = `Complete package, 1 User, Office Applications (word processing, spreadsheet, presentations)`.
    temp4-width = `15`.
    temp4-depth = `6.5`.
    temp4-height = `2.1`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `1.2`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `25`.
    temp4-price = '89.90'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Design`.
    temp4-product_id = `HT-1101`.
    temp4-category = `Software`.
    temp4-main_category = `Software`.
    temp4-supplier_name = `Technocom`.
    temp4-description = `Complete package, 1 User, Image editing, processing`.
    temp4-width = `14`.
    temp4-depth = `6.7`.
    temp4-height = `24`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.8`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `26`.
    temp4-price = '79.90'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Network`.
    temp4-product_id = `HT-1102`.
    temp4-category = `Software`.
    temp4-main_category = `Software`.
    temp4-supplier_name = `Technocom`.
    temp4-description = `Complete package, 1 User, Network Software Utilities, Useful Applications and Documentation`.
    temp4-width = `16`.
    temp4-depth = `6`.
    temp4-height = `27`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.8`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `28`.
    temp4-price = '69.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Multimedia`.
    temp4-product_id = `HT-1103`.
    temp4-category = `Software`.
    temp4-main_category = `Software`.
    temp4-supplier_name = `Technocom`.
    temp4-description = `Complete package, 1 User, different Multimedia applications, playing music, watching DVDs, only with this Smart package`.
    temp4-width = `11`.
    temp4-depth = `3.4`.
    temp4-height = `22`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.8`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `9`.
    temp4-price = '77.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Games`.
    temp4-product_id = `HT-1104`.
    temp4-category = `Software`.
    temp4-main_category = `Software`.
    temp4-supplier_name = `Technocom`.
    temp4-description = `Complete package, 1 User, various games for amusement, logic, action, jump&run`.
    temp4-width = `10`.
    temp4-depth = `3`.
    temp4-height = `30`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `1.1`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `13`.
    temp4-price = '55.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Internet Antivirus`.
    temp4-product_id = `HT-1105`.
    temp4-category = `Software`.
    temp4-main_category = `Software`.
    temp4-supplier_name = `Brainsoft`.
    temp4-description = `Complete package, 1 User, highly recommended for internet users as anti-virus protection`.
    temp4-width = `16`.
    temp4-depth = `4`.
    temp4-height = `21`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.7`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `17`.
    temp4-price = '29.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Firewall`.
    temp4-product_id = `HT-1106`.
    temp4-category = `Software`.
    temp4-main_category = `Software`.
    temp4-supplier_name = `Brainsoft`.
    temp4-description = `Complete package, 1 User, recommended for internet users, protect your PC against cyber-crime`.
    temp4-width = `17.9`.
    temp4-depth = `4.2`.
    temp4-height = `23.1`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.9`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `19`.
    temp4-price = '34.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Money`.
    temp4-product_id = `HT-1107`.
    temp4-category = `Software`.
    temp4-main_category = `Software`.
    temp4-supplier_name = `Brainsoft`.
    temp4-description = `Complete package, 1 User, bring your money in your mind, see what you have and what you want`.
    temp4-width = `12`.
    temp4-depth = `1.5`.
    temp4-height = `19`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.5`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `18`.
    temp4-price = '29.90'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `PC Lock`.
    temp4-product_id = `HT-1110`.
    temp4-category = `Computer System Accessories`.
    temp4-main_category = `Computer Systems`.
    temp4-supplier_name = `Red Point Stores`.
    temp4-description = `Robust 3m anti-burglary protection for your laptop computer`.
    temp4-width = `20`.
    temp4-depth = `8`.
    temp4-height = `4.3`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.03`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `14`.
    temp4-price = '8.90'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Lock`.
    temp4-product_id = `HT-1111`.
    temp4-category = `Computer System Accessories`.
    temp4-main_category = `Computer Systems`.
    temp4-supplier_name = `Red Point Stores`.
    temp4-description = `Robust 1m anti-burglary protection for your desktop computer`.
    temp4-width = `31`.
    temp4-depth = `9`.
    temp4-height = `7`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.02`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `20`.
    temp4-price = '6.90'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Web cam reality`.
    temp4-product_id = `HT-1112`.
    temp4-category = `Computer System Accessories`.
    temp4-main_category = `Computer Systems`.
    temp4-supplier_name = `Red Point Stores`.
    temp4-description = `Color webcam, color, High-Speed USB`.
    temp4-width = `9`.
    temp4-depth = `8.2`.
    temp4-height = `1.3`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.075`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `27`.
    temp4-price = '39.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Screen clean`.
    temp4-product_id = `HT-1113`.
    temp4-category = `Computer System Accessories`.
    temp4-main_category = `Computer Systems`.
    temp4-supplier_name = `Red Point Stores`.
    temp4-description = `10 separately packed screen wipes`.
    temp4-width = `2`.
    temp4-depth = `2`.
    temp4-height = `0.1`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.05`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `17`.
    temp4-price = '2.30'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Fabric bag professional`.
    temp4-product_id = `HT-1114`.
    temp4-category = `Computer System Accessories`.
    temp4-main_category = `Computer Systems`.
    temp4-supplier_name = `Red Point Stores`.
    temp4-description = `Notebook bag, plenty of room for stationery and writing materials`.
    temp4-width = `42`.
    temp4-depth = `32`.
    temp4-height = `7`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `1.8`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `14`.
    temp4-price = '31.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Wireless DSL Router`.
    temp4-product_id = `HT-1115`.
    temp4-category = `Telecommunications`.
    temp4-main_category = `Computer Components`.
    temp4-supplier_name = `Red Point Stores`.
    temp4-description = `Wireless DSL Router (available in blue, black and silver)`.
    temp4-width = `19.3`.
    temp4-depth = `18`.
    temp4-height = `5`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.45`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `16`.
    temp4-price = '49.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Wireless DSL Router / Repeater`.
    temp4-product_id = `HT-1116`.
    temp4-category = `Telecommunications`.
    temp4-main_category = `Computer Components`.
    temp4-supplier_name = `Red Point Stores`.
    temp4-description = `Wireless DSL Router / Repeater (available in blue, black and silver)`.
    temp4-width = `19.3`.
    temp4-depth = `18`.
    temp4-height = `5`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.45`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `12`.
    temp4-price = '59.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Wireless DSL Router / Repeater and Print Server`.
    temp4-product_id = `HT-1117`.
    temp4-category = `Telecommunications`.
    temp4-main_category = `Computer Components`.
    temp4-supplier_name = `Technocom`.
    temp4-description = `Wireless DSL Router / Repeater and Print Server (available in blue, black and silver)`.
    temp4-width = `19.3`.
    temp4-depth = `18`.
    temp4-height = `5`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.45`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `12`.
    temp4-price = '69.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `USB Stick`.
    temp4-product_id = `HT-1118`.
    temp4-category = `Computer System Accessories`.
    temp4-main_category = `Computer Systems`.
    temp4-supplier_name = `Technocom`.
    temp4-description = `USB 2.0 High-Speed 64 GB`.
    temp4-width = `1.5`.
    temp4-depth = `8.7`.
    temp4-height = `1.2`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.015`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `14`.
    temp4-price = '35.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Travel Adapter`.
    temp4-product_id = `HT-1119`.
    temp4-category = `Accessories`.
    temp4-main_category = `Computer Systems`.
    temp4-supplier_name = `Titanium`.
    temp4-description = `Universal Travel Adapter`.
    temp4-width = `2`.
    temp4-depth = `3.1`.
    temp4-height = `3.9`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `88`.
    temp4-weight_unit = `G`.
    temp4-quantity = `10`.
    temp4-price = '79.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cordless Bluetooth Keyboard, english international`.
    temp4-product_id = `HT-1120`.
    temp4-category = `Keyboards`.
    temp4-main_category = `Computer Components`.
    temp4-supplier_name = `Technocom`.
    temp4-description = `Cordless Bluetooth Keyboard with English keys`.
    temp4-width = `51.4`.
    temp4-depth = `23`.
    temp4-height = `4`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `1`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `13`.
    temp4-price = '29.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat XXL`.
    temp4-product_id = `HT-1137`.
    temp4-category = `Flat Screen Monitors`.
    temp4-main_category = `Computer Components`.
    temp4-supplier_name = `Technocom`.
    temp4-description = `Optimum Hi-Resolution max. 2048 × 1536 @ 85Hz, Dot Pitch: 0.24mm`.
    temp4-width = `54`.
    temp4-depth = `22`.
    temp4-height = `38`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `18`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `10`.
    temp4-price = '1430.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Pocket Mouse`.
    temp4-product_id = `HT-1138`.
    temp4-category = `Mice`.
    temp4-main_category = `Computer Components`.
    temp4-supplier_name = `Technocom`.
    temp4-description = `Portable pocket Mouse with retracting cord`.
    temp4-width = `0.3`.
    temp4-depth = `0.5`.
    temp4-height = `1`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.02`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `20`.
    temp4-price = '23.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `PC Power Station`.
    temp4-product_id = `HT-1210`.
    temp4-category = `PCs`.
    temp4-main_category = `Computer Systems`.
    temp4-supplier_name = `Technocom`.
    temp4-description = `PC Power Station with 3,4 Ghz quad-core, 32 GB DDR3 SDRAM, feels like Available PC, Windows 8 Pro`.
    temp4-width = `28`.
    temp4-depth = `31`.
    temp4-height = `43`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `2.3`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `22`.
    temp4-price = '2399.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Astro Laptop 1516`.
    temp4-product_id = `HT-1251`.
    temp4-category = `Laptops`.
    temp4-main_category = `Computer Systems`.
    temp4-supplier_name = `Ultrasonic United`.
    temp4-description = `Flexible Laptop with 2,5 GHz Quad Core, 15" HD TN, 16 GB DDR SDRAM, 256 GB SSD, Windows 10 Pro`.
    temp4-width = `30`.
    temp4-depth = `18`.
    temp4-height = `3`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `4.2`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `23`.
    temp4-price = '989.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Astro Phone 6`.
    temp4-product_id = `HT-1252`.
    temp4-category = `Smartphones and Tablets`.
    temp4-main_category = `Smartphones & Tablets`.
    temp4-supplier_name = `Ultrasonic United`.
    temp4-description = `6 inch 1280x800 HD display (216 ppi), Quad-core processor, 8 GB internal storage (actual formatted capacity will be less), 3050 mAh battery (Up to 8 hours of active use), grey or black`.
    temp4-width = `8`.
    temp4-depth = `6`.
    temp4-height = `1.5`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.75`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `28`.
    temp4-price = '649.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Benda Laptop 1408`.
    temp4-product_id = `HT-1253`.
    temp4-category = `Laptops`.
    temp4-main_category = `Computer Systems`.
    temp4-supplier_name = `Ultrasonic United`.
    temp4-description = `Flexible Laptop with 2,5 GHz Dual Core, 14" HD+ TN, 8 GB DDR SDRAM, 324 GB SSD, Windows 10 Pro`.
    temp4-width = `30`.
    temp4-depth = `18`.
    temp4-height = `3`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `4.2`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `27`.
    temp4-price = '976.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Bending Screen 21HD`.
    temp4-product_id = `HT-1254`.
    temp4-category = `Flat Screens`.
    temp4-main_category = `Computer Components`.
    temp4-supplier_name = `Ultrasonic United`.
    temp4-description = `Optimum Hi-Resolution Widescreen max. 1920 x 1080 @ 85Hz, Dot Pitch: 0.27mm, HDMI, Discontinued-Sub`.
    temp4-width = `37`.
    temp4-depth = `12`.
    temp4-height = `36`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `15`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `23`.
    temp4-price = '250.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Broad Screen 22HD`.
    temp4-product_id = `HT-1255`.
    temp4-category = `Flat Screens`.
    temp4-main_category = `Computer Components`.
    temp4-supplier_name = `Ultrasonic United`.
    temp4-description = `Optimum Hi-Resolution Widescreen max. 2048 x 1080 @ 85Hz, Dot Pitch: 0.27mm, HDMI, Discontinued-Sub`.
    temp4-width = `39`.
    temp4-depth = `12`.
    temp4-height = `38`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `16`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `5`.
    temp4-price = '270.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cerdik Phone 7`.
    temp4-product_id = `HT-1256`.
    temp4-category = `Smartphones and Tablets`.
    temp4-main_category = `Smartphones & Tablets`.
    temp4-supplier_name = `Ultrasonic United`.
    temp4-description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage (actual formatted capacity will be less), 4325 mAh battery (Up to 8 hours of active use), white or black`.
    temp4-width = `9`.
    temp4-depth = `15`.
    temp4-height = `1.5`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.75`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `19`.
    temp4-price = '549.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cepat Tablet 10.5`.
    temp4-product_id = `HT-1257`.
    temp4-category = `Smartphones and Tablets`.
    temp4-main_category = `Smartphones & Tablets`.
    temp4-supplier_name = `Ultrasonic United`.
    temp4-description = `10.5-inch Multitouch HD Screen (1280 x 800), 16GB Internal Memory, Wireless N Wi-Fi; Bluetooth, GPS Enabled, 1GHz Dual-Core Processor`.
    temp4-width = `48`.
    temp4-depth = `31`.
    temp4-height = `4.5`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `2.8`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `17`.
    temp4-price = '549.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cepat Tablet 8`.
    temp4-product_id = `HT-1258`.
    temp4-category = `Smartphones and Tablets`.
    temp4-main_category = `Smartphones & Tablets`.
    temp4-supplier_name = `Ultrasonic United`.
    temp4-description = `8-inch Multitouch HD Screen (2000 x 1500) 32GB Internal Memory, Wireless N Wi-Fi, Bluetooth, GPS Enabled, 1.5 GHz Quad-Core Processor`.
    temp4-width = `38`.
    temp4-depth = `21`.
    temp4-height = `3.5`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `2.5`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `24`.
    temp4-price = '529.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Server Basic`.
    temp4-product_id = `HT-1500`.
    temp4-category = `Servers`.
    temp4-main_category = `Computer Systems`.
    temp4-supplier_name = `Technocom`.
    temp4-description = `Dual socket, quad-core processing server with 1333 MHz Front Side Bus with 10Gb connectivity`.
    temp4-width = `34`.
    temp4-depth = `35`.
    temp4-height = `23`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `18`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `24`.
    temp4-price = '5000.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Server Professional`.
    temp4-product_id = `HT-1501`.
    temp4-category = `Servers`.
    temp4-main_category = `Computer Systems`.
    temp4-supplier_name = `Technocom`.
    temp4-description = `Dual socket, quad-core processing server with 1644 MHz Front Side Bus with 10Gb connectivity`.
    temp4-width = `29`.
    temp4-depth = `30`.
    temp4-height = `27`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `25`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `26`.
    temp4-price = '15000.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Server Power Pro`.
    temp4-product_id = `HT-1502`.
    temp4-category = `Servers`.
    temp4-main_category = `Computer Systems`.
    temp4-supplier_name = `Technocom`.
    temp4-description = `Dual socket, quad-core processing server with 1644 MHz Front Side Bus with 100Gb connectivity`.
    temp4-width = `22`.
    temp4-depth = `27.3`.
    temp4-height = `37`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `35`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `34`.
    temp4-price = '25000.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Family PC Basic`.
    temp4-product_id = `HT-1600`.
    temp4-category = `Desktop Computers`.
    temp4-main_category = `Computer Systems`.
    temp4-supplier_name = `Titanium`.
    temp4-description = `2,8 Ghz dual core, 4 GB DDR3 SDRAM, 500 GB Hard Disc, Graphic Card: Proctra X, Windows 8`.
    temp4-width = `21.4`.
    temp4-depth = `29`.
    temp4-height = `38`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `4.8`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `10`.
    temp4-price = '600.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Family PC Pro`.
    temp4-product_id = `HT-1601`.
    temp4-category = `Desktop Computers`.
    temp4-main_category = `Computer Systems`.
    temp4-supplier_name = `Titanium`.
    temp4-description = `2,8 Ghz dual core, 4 GB DDR3 SDRAM, 1000 GB Hard Disc, Graphic Card: Gladiator MX, Windows 8`.
    temp4-width = `25`.
    temp4-depth = `31.7`.
    temp4-height = `40.2`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `5.3`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `20`.
    temp4-price = '900.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Gaming Monster`.
    temp4-product_id = `HT-1602`.
    temp4-category = `Desktop Computers`.
    temp4-main_category = `Computer Systems`.
    temp4-supplier_name = `Titanium`.
    temp4-description = `3,4 Ghz quad core, 8 GB DDR3 SDRAM, 2000 GB Hard Disc, Graphic Card: Gladiator MX, Windows 8`.
    temp4-width = `26.5`.
    temp4-depth = `34`.
    temp4-height = `47`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `5.9`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `24`.
    temp4-price = '1200.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Gaming Monster Pro`.
    temp4-product_id = `HT-1603`.
    temp4-category = `Desktop Computers`.
    temp4-main_category = `Computer Systems`.
    temp4-supplier_name = `Titanium`.
    temp4-description = `3,4 Ghz quad core, 16 GB DDR3 SDRAM, 4000 GB Hard Disc, Graphic Card: Hurricane GX, Windows 8`.
    temp4-width = `27`.
    temp4-depth = `28`.
    temp4-height = `42`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `6.8`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `25`.
    temp4-price = '1700.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `7" Widescreen Portable DVD Player w MP3`.
    temp4-product_id = `HT-2000`.
    temp4-category = `Accessories`.
    temp4-main_category = `TV, Video & HiFi`.
    temp4-supplier_name = `Titanium`.
    temp4-description = `7" LCD Screen, storage battery holds up to 6 hours!`.
    temp4-width = `21.4`.
    temp4-depth = `19`.
    temp4-height = `27.6`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.79`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `20`.
    temp4-price = '249.99'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `10" Portable DVD player`.
    temp4-product_id = `HT-2001`.
    temp4-category = `Accessories`.
    temp4-main_category = `TV, Video & HiFi`.
    temp4-supplier_name = `Titanium`.
    temp4-description = `10" LCD Screen, storage battery holds up to 8 hours`.
    temp4-width = `24`.
    temp4-depth = `19.5`.
    temp4-height = `29`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.84`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `21`.
    temp4-price = '449.99'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Portable DVD Player with 9" LCD Monitor`.
    temp4-product_id = `HT-2002`.
    temp4-category = `Accessories`.
    temp4-main_category = `TV, Video & HiFi`.
    temp4-supplier_name = `Technocom`.
    temp4-description = `9" LCD Screen, storage holds up to 8 hours, 2 speakers included`.
    temp4-width = `21`.
    temp4-depth = `16.5`.
    temp4-height = `14`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.72`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `50`.
    temp4-price = '853.99'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `CD/DVD case: 264 sleeves`.
    temp4-product_id = `HT-2025`.
    temp4-category = `Accessories`.
    temp4-main_category = `Computer Systems`.
    temp4-supplier_name = `Titanium`.
    temp4-description = `Organizer and protective case for 264 CDs and DVDs`.
    temp4-width = `13`.
    temp4-depth = `13`.
    temp4-height = `20`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.65`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `26`.
    temp4-price = '44.99'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Audio/Video Cable Kit - 4m`.
    temp4-product_id = `HT-2026`.
    temp4-category = `Accessories`.
    temp4-main_category = `Computer Systems`.
    temp4-supplier_name = `Titanium`.
    temp4-description = `Quality cables for notebooks and projectors`.
    temp4-width = `21`.
    temp4-depth = `10.2`.
    temp4-height = `13`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.2`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `16`.
    temp4-price = '29.99'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Removable CD/DVD Laser Labels`.
    temp4-product_id = `HT-2027`.
    temp4-category = `Accessories`.
    temp4-main_category = `Computer Systems`.
    temp4-supplier_name = `Titanium`.
    temp4-description = `Removable jewel case labels, zero residues (100)`.
    temp4-width = `5.5`.
    temp4-depth = `2`.
    temp4-height = `2`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.15`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `25`.
    temp4-price = '8.99'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Beam Breaker B-1`.
    temp4-product_id = `HT-6100`.
    temp4-category = `Accessories`.
    temp4-main_category = `TV, Video & HiFi`.
    temp4-supplier_name = `Titanium`.
    temp4-description = `720p, DLP Projector max. 8,45 Meter, 2D`.
    temp4-width = `30.4`.
    temp4-depth = `23.1`.
    temp4-height = `23`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `1.7`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `32`.
    temp4-price = '469.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Beam Breaker B-2`.
    temp4-product_id = `HT-6101`.
    temp4-category = `Accessories`.
    temp4-main_category = `TV, Video & HiFi`.
    temp4-supplier_name = `Technocom`.
    temp4-description = `1080p, DLP max.9,34 Meter, 2D-ready`.
    temp4-width = `30.4`.
    temp4-depth = `23.1`.
    temp4-height = `23`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `2`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `18`.
    temp4-price = '679.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Beam Breaker B-3`.
    temp4-product_id = `HT-6102`.
    temp4-category = `Accessories`.
    temp4-main_category = `TV, Video & HiFi`.
    temp4-supplier_name = `Technocom`.
    temp4-description = `1080p, DLP max. 12,3 Meter, 3D-ready`.
    temp4-width = `30.4`.
    temp4-depth = `23.1`.
    temp4-height = `23`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `2.5`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `16`.
    temp4-price = '889.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Play Movie`.
    temp4-product_id = `HT-6110`.
    temp4-category = `Accessories`.
    temp4-main_category = `TV, Video & HiFi`.
    temp4-supplier_name = `Fasttech`.
    temp4-description = `CD-RW, DVD+R/RW, DVD-R/RW, MPEG 2 (Video-DVD), MPEG 4, VCD, SVCD, DivX, Xvid`.
    temp4-width = `37`.
    temp4-depth = `24`.
    temp4-height = `6`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `2.4`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `15`.
    temp4-price = '130.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Record Movie`.
    temp4-product_id = `HT-6111`.
    temp4-category = `Accessories`.
    temp4-main_category = `TV, Video & HiFi`.
    temp4-supplier_name = `Fasttech`.
    temp4-description = `160 GB HDD, CD-RW, DVD+R/RW, DVD-R/RW, MPEG 2 (Video-DVD), MPEG 4, VCD, SVCD, DivX, Xvid`.
    temp4-width = `38`.
    temp4-depth = `26`.
    temp4-height = `6.2`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `3.1`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `24`.
    temp4-price = '288.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelo MusicStick`.
    temp4-product_id = `HT-6120`.
    temp4-category = `Accessories`.
    temp4-main_category = `TV, Video & HiFi`.
    temp4-supplier_name = `Fasttech`.
    temp4-description = `64 GB USB Music-on-Available-Stick`.
    temp4-width = `1.5`.
    temp4-depth = `6`.
    temp4-height = `1`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `134`.
    temp4-weight_unit = `G`.
    temp4-quantity = `15`.
    temp4-price = '45.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelo Jog-Mate`.
    temp4-product_id = `HT-6121`.
    temp4-category = `Accessories`.
    temp4-main_category = `TV, Video & HiFi`.
    temp4-supplier_name = `Fasttech`.
    temp4-description = `ITelo Jog-Mate 64 GB HDD and Color Display, can play movies`.
    temp4-width = `5.1`.
    temp4-depth = `8`.
    temp4-height = `9.2`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `134`.
    temp4-weight_unit = `G`.
    temp4-quantity = `24`.
    temp4-price = '63.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Power Pro Player 40`.
    temp4-product_id = `HT-6122`.
    temp4-category = `Accessories`.
    temp4-main_category = `TV, Video & HiFi`.
    temp4-supplier_name = `Fasttech`.
    temp4-description = `MP3-Player with 40 GB HDD and Color Display, can play movies`.
    temp4-width = `5.1`.
    temp4-depth = `8`.
    temp4-height = `9.2`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `266`.
    temp4-weight_unit = `G`.
    temp4-quantity = `23`.
    temp4-price = '167.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Power Pro Player 80`.
    temp4-product_id = `HT-6123`.
    temp4-category = `Accessories`.
    temp4-main_category = `TV, Video & HiFi`.
    temp4-supplier_name = `Fasttech`.
    temp4-description = `MP3-Player with 80 GB SSD and Color Display, can play movies`.
    temp4-width = `4`.
    temp4-depth = `6`.
    temp4-height = `0.8`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `267`.
    temp4-weight_unit = `G`.
    temp4-quantity = `13`.
    temp4-price = '299.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Watch HD32`.
    temp4-product_id = `HT-6130`.
    temp4-category = `Flat Screen TVs`.
    temp4-main_category = `TV, Video & HiFi`.
    temp4-supplier_name = `Very Best Screens`.
    temp4-description = `32-inch, 1366x768 Pixel, 16:9, HDTV ready`.
    temp4-width = `78`.
    temp4-depth = `22.1`.
    temp4-height = `55`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `2.6`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `16`.
    temp4-price = '1459.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Watch HD37`.
    temp4-product_id = `HT-6131`.
    temp4-category = `Flat Screen TVs`.
    temp4-main_category = `TV, Video & HiFi`.
    temp4-supplier_name = `Very Best Screens`.
    temp4-description = `37-inch, 1366x768 Pixel, 16:9, HDTV ready`.
    temp4-width = `99.1`.
    temp4-depth = `26`.
    temp4-height = `61`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `2.2`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `14`.
    temp4-price = '1199.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Watch HD41`.
    temp4-product_id = `HT-6132`.
    temp4-category = `Flat Screen TVs`.
    temp4-main_category = `TV, Video & HiFi`.
    temp4-supplier_name = `Very Best Screens`.
    temp4-description = `41-inch, 1366x768 Pixel, 16:9, HDTV ready`.
    temp4-width = `128`.
    temp4-depth = `23`.
    temp4-height = `79.1`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `1.8`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `13`.
    temp4-price = '899.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Copperberry`.
    temp4-product_id = `HT-7000`.
    temp4-category = `Accessories`.
    temp4-main_category = `Computer Components`.
    temp4-supplier_name = `Fasttech`.
    temp4-description = `Our new multifunctional Handheld with phone function in copper`.
    temp4-width = `8.1`.
    temp4-depth = `13`.
    temp4-height = `12.1`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.5`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `5`.
    temp4-price = '549.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Silverberry`.
    temp4-product_id = `HT-7010`.
    temp4-category = `Accessories`.
    temp4-main_category = `Computer Components`.
    temp4-supplier_name = `Fasttech`.
    temp4-description = `Our new multifunctional Handheld with phone function in silver`.
    temp4-width = `8.1`.
    temp4-depth = `13`.
    temp4-height = `12.1`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.5`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `9`.
    temp4-price = '549.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Goldberry`.
    temp4-product_id = `HT-7020`.
    temp4-category = `Accessories`.
    temp4-main_category = `Computer Components`.
    temp4-supplier_name = `Fasttech`.
    temp4-description = `Our new multifunctional Handheld with phone function in gold`.
    temp4-width = `8.1`.
    temp4-depth = `13`.
    temp4-height = `12.1`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.5`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `11`.
    temp4-price = '549.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Platinberry`.
    temp4-product_id = `HT-7030`.
    temp4-category = `Accessories`.
    temp4-main_category = `Computer Components`.
    temp4-supplier_name = `Fasttech`.
    temp4-description = `Our new multifunctional Handheld with phone function in platinum`.
    temp4-width = `8.1`.
    temp4-depth = `13`.
    temp4-height = `12.1`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.5`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `12`.
    temp4-price = '549.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO FlexTop I4000`.
    temp4-product_id = `HT-8000`.
    temp4-category = `Laptops`.
    temp4-main_category = `Computer Systems`.
    temp4-supplier_name = `Titanium`.
    temp4-description = `Notebook with 2,80 GHz dual core, 4 GB DDR3 SDRAM, 500 GB Hard Disc, Windows 8`.
    temp4-width = `31`.
    temp4-depth = `19`.
    temp4-height = `3.1`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `4`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `11`.
    temp4-price = '799.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO FlexTop I6300c`.
    temp4-product_id = `HT-8001`.
    temp4-category = `Laptops`.
    temp4-main_category = `Computer Systems`.
    temp4-supplier_name = `Titanium`.
    temp4-description = `Notebook with 2,80 GHz dual core, 8 GB DDR3 SDRAM, 500 GB Hard Disc, Windows 8`.
    temp4-width = `32`.
    temp4-depth = `20`.
    temp4-height = `3.4`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `4.2`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `20`.
    temp4-price = '799.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO FlexTop I9100`.
    temp4-product_id = `HT-8002`.
    temp4-category = `Laptops`.
    temp4-main_category = `Computer Systems`.
    temp4-supplier_name = `Titanium`.
    temp4-description = `Notebook with 2,80 GHz quad core, 4 GB DDR3 SDRAM, 1000 GB Hard Disc, Windows 8`.
    temp4-width = `38`.
    temp4-depth = `21`.
    temp4-height = `4.1`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `3.5`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `20`.
    temp4-price = '1199.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO FlexTop I9800`.
    temp4-product_id = `HT-8003`.
    temp4-category = `Laptops`.
    temp4-main_category = `Computer Systems`.
    temp4-supplier_name = `Titanium`.
    temp4-description = `Notebook with 2,80 GHz quad core, 8 GB DDR3 SDRAM, 1000 GB Hard Disc, Windows 8`.
    temp4-width = `48`.
    temp4-depth = `31`.
    temp4-height = `4.5`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `3.8`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `22`.
    temp4-price = '1388.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smartphone Leather Case`.
    temp4-product_id = `HT-9991`.
    temp4-category = `Accessories`.
    temp4-main_category = `Smartphones & Tablets`.
    temp4-supplier_name = `Ultrasonic United`.
    temp4-description = `Button Clasp, Quality Material, 100% Leather, compatible with many smartphone models`.
    temp4-width = `48`.
    temp4-depth = `31`.
    temp4-height = `4.5`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.02`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `12`.
    temp4-price = '25.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smartphone Alpha`.
    temp4-product_id = `HT-9992`.
    temp4-category = `Smartphones and Tablets`.
    temp4-main_category = `Smartphones & Tablets`.
    temp4-supplier_name = `Ultrasonic United`.
    temp4-description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage (actual formatted capacity will be less), 4325 mAh battery (Up to 8 hours of active use), white or black`.
    temp4-width = `48`.
    temp4-depth = `31`.
    temp4-height = `4.5`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.75`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `13`.
    temp4-price = '599.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Mini Tablet`.
    temp4-product_id = `HT-9993`.
    temp4-category = `Smartphones and Tablets`.
    temp4-main_category = `Smartphones & Tablets`.
    temp4-supplier_name = `Ultrasonic United`.
    temp4-description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage, 4325 mAh battery (Up to 8 hours of active use)`.
    temp4-width = `48`.
    temp4-depth = `31`.
    temp4-height = `4.5`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `3.8`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `10`.
    temp4-price = '833.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Camcorder View`.
    temp4-product_id = `HT-9994`.
    temp4-category = `Accessories`.
    temp4-main_category = `TV, Video & HiFi`.
    temp4-supplier_name = `Ultrasonic United`.
    temp4-description = `1920x1080 Full HD, image stabilization reduces blur, 27x Optical / 32x Extended Zoom, wide angle Lens, 2.7" wide LCD display`.
    temp4-width = `48`.
    temp4-depth = `31`.
    temp4-height = `27`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `3.8`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `50`.
    temp4-price = '1388.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Tablet Pouch`.
    temp4-product_id = `HT-9995`.
    temp4-category = `Accessories`.
    temp4-main_category = `Smartphones & Tablets`.
    temp4-supplier_name = `Titanium`.
    temp4-description = `Stylish tablet pouch, protects from scratches, color: black`.
    temp4-width = `25`.
    temp4-depth = `40`.
    temp4-height = `4.5`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.03`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `34`.
    temp4-price = '20.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Tablet Pouch`.
    temp4-product_id = `HT-9996`.
    temp4-category = `Accessories`.
    temp4-main_category = `Smartphones & Tablets`.
    temp4-supplier_name = `Titanium`.
    temp4-description = `Stylish tablet pouch, protects from scratches, color: black`.
    temp4-width = `25`.
    temp4-depth = `40`.
    temp4-height = `4.5`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.03`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `34`.
    temp4-price = '20.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `e-Book Reader ReadMe`.
    temp4-product_id = `HT-9997`.
    temp4-category = `Smartphones and Tablets`.
    temp4-main_category = `Smartphones & Tablets`.
    temp4-supplier_name = `Titanium`.
    temp4-description = `6-Inch E Ink Screen, Access To e-book Store, Adjustable Font Styles and Sizes, Stores Up To 1,000 Books`.
    temp4-width = `48`.
    temp4-depth = `31`.
    temp4-height = `4.5`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `3.8`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `23`.
    temp4-price = '33.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smartphone Beta`.
    temp4-product_id = `HT-9998`.
    temp4-category = `Smartphones and Tablets`.
    temp4-main_category = `Smartphones & Tablets`.
    temp4-supplier_name = `Titanium`.
    temp4-description = `5 Megapixel Camera, Wi-Fi 802.11 b/g/n, Bluetooth, GPS Available-GPS support`.
    temp4-width = `48`.
    temp4-depth = `31`.
    temp4-height = `4.5`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.75`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `21`.
    temp4-price = '30.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Maxi Tablet`.
    temp4-product_id = `HT-9999`.
    temp4-category = `Tablets`.
    temp4-main_category = `Smartphones & Tablets`.
    temp4-supplier_name = `Titanium`.
    temp4-description = `10.1-inch Multitouch HD Screen (1280 x 800), 16GB Internal Memory, Wireless N Wi-Fi; Bluetooth, GPS Enabled, 1GHz Dual-Core Processor`.
    temp4-width = `48`.
    temp4-depth = `31`.
    temp4-height = `4.5`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `3.8`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `20`.
    temp4-price = '749.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flyer`.
    temp4-product_id = `PF-1000`.
    temp4-category = `Accessories`.
    temp4-main_category = `Computer Systems`.
    temp4-supplier_name = `Titanium`.
    temp4-description = `Flyer for our product palette`.
    temp4-width = `46`.
    temp4-depth = `30`.
    temp4-height = `3`.
    temp4-dim_unit = `cm`.
    temp4-weight_measure = `0.01`.
    temp4-weight_unit = `KG`.
    temp4-quantity = `33`.
    temp4-price = '0.00'.
    temp4-currency_code = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    t_products = temp3.


    " weightState is business logic (KG conversion + Success/Warning/Error
    " thresholds), not presentation - abap2UI5 is a thin frontend, so the
    " ObjectNumber state is computed here in the backend (the original does it in
    " its frontend Formatter.js, which a faithful port moves server-side).
    
    
    LOOP AT t_products REFERENCE INTO lr_product.
      
      weight_kg = lr_product->weight_measure.
      IF lr_product->weight_unit = `G`.
        weight_kg = weight_kg / 1000.
      ENDIF.
      
      IF weight_kg < 0.
        temp6 = `None`.
      ELSEIF weight_kg < 1.
        temp6 = `Success`.
      ELSEIF weight_kg < 5.
        temp6 = `Warning`.
      ELSE.
        temp6 = `Error`.
      ENDIF.
      lr_product->weight_state = temp6.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
