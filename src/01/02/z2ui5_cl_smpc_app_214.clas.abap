" @keywords blocklayout block layout sap.ui.layout blocklayoutdefault simpleform label slider segmentedbutton segmentedbuttonitem verticallayout blocklayoutrow
" @summary The BlockLayout is intended to be used with rows and cells. The cells have predefined width, the rows have predefined rendering modes - scrollable/vertical/horizontal.
CLASS z2ui5_cl_smpc_app_214 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        productid     TYPE string,
        name          TYPE string,
        suppliername  TYPE string,
        width         TYPE string,
        depth         TYPE string,
        height        TYPE string,
        dimunit       TYPE string,
        weightmeasure TYPE string,
        weightunit    TYPE string,
        price         TYPE p LENGTH 14 DECIMALS 2,
        currencycode  TYPE string,
      END OF ty_s_product.
    DATA t_products         TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.
    DATA selectedbackground TYPE string.
    DATA slider_value       TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_214 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA lorem TYPE string.
    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    lorem = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. ` &&
                  `At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. ` &&
                  `Lorem ipsum dolor sit amet, consetetur sadipscing elitr.`.

    
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:form` v = `sap.ui.layout.form`

        )->ele( n = `SimpleForm` ns = `form`
            )->a( n = `editable`         v = `true`
            )->a( n = `backgroundDesign` v = `Transparent`
            )->a( n = `layout`           v = `ColumnLayout`

            )->tag( `Label`
                )->a( n = `text` v = `Parent width`
            )->tag( `Slider`
                )->a( n = `id`    v = `widthSlider`
                )->a( n = `value` v = client->_bind( slider_value )
            )->tag( `Label`
                )->a( n = `id`   v = `backgroundLabel`
                )->a( n = `text` v = `Background`

            )->ele( `SegmentedButton`
                )->a( n = `selectedKey`     v = client->_bind( selectedbackground )
                )->a( n = `ariaDescribedBy` v = `backgroundLabel`
                )->a( n = `ariaLabelledBy`  v = `backgroundLabel`

                )->ele( `items`
                    )->tag( `SegmentedButtonItem`
                        )->a( n = `key`  v = `Default`
                        )->a( n = `text` v = `Default`
                    )->tag( `SegmentedButtonItem`
                        )->a( n = `key`  v = `Light`
                        )->a( n = `text` v = `Light`
                    )->tag( `SegmentedButtonItem`
                        )->a( n = `key`  v = `Accent`
                        )->a( n = `text` v = `Accent`
                    )->tag( `SegmentedButtonItem`
                        )->a( n = `key`  v = `Dashboard`
                        )->a( n = `text` v = `Dashboard`

                )->end(
            )->end(
        )->end(

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `id`    v = `containerLayout`
            )->a( n = `width` v = |\{= ${ client->_bind( slider_value ) } + '%' \}|

            )->ele( n = `BlockLayout` ns = `l`
                )->a( n = `id`         v = `BlockLayout`
                )->a( n = `background` v = client->_bind( selectedbackground )

                )->ele( n = `BlockLayoutRow` ns = `l`
                    )->a( n = `accentCells` v = `Accent1`

                    )->ele( n = `BlockLayoutCell` ns = `l`
                        )->a( n = `id`    v = `Accent1`
                        )->a( n = `width` v = `2`
                        )->a( n = `title` v = `Left aligned heading`

                        )->tag( `Text`
                            )->a( n = `text` v = lorem

                        )->ele( `RadioButtonGroup`
                            )->a( n = `columns`       v = `2`
                            )->a( n = `selectedIndex` v = `2`
                            )->a( n = `class`         v = `sapUiMediumMarginTop`

                            )->tag( `RadioButton`
                                )->a( n = `id`   v = `RB2-1`
                                )->a( n = `text` v = `Option 1`
                            )->tag( `RadioButton`
                                )->a( n = `id`       v = `RB2-2`
                                )->a( n = `text`     v = `Option 2`
                                )->a( n = `editable` v = `false`
                            )->tag( `RadioButton`
                                )->a( n = `id`   v = `RB2-3`
                                )->a( n = `text` v = `Option 3`

                        )->end(
                    )->end(
                    )->ele( n = `BlockLayoutCell` ns = `l`
                        )->a( n = `title` v = `25% width cell`

                        )->tag( `Text`
                            )->a( n = `text` v = lorem

                    )->end(
                    )->ele( n = `BlockLayoutCell` ns = `l`
                        )->a( n = `titleAlignment` v = `End`
                        )->a( n = `title`          v = `End aligned heading`

                        )->tag( `Text`
                            )->a( n = `text` v = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.`

                    )->end(
                )->end(

                )->ele( n = `BlockLayoutRow` ns = `l`
                    )->ele( n = `BlockLayoutCell` ns = `l`
                        )->a( n = `title` v = `50% width cell`

                        )->tag( `Text`
                            )->a( n = `text` v = lorem

                    )->end(
                    )->ele( n = `BlockLayoutCell` ns = `l`
                        )->a( n = `title` v = `50% width cell`

                        )->tag( `FeedInput`
                            )->a( n = `showIcon` v = `true`
                        )->tag( `FeedInput`
                            )->a( n = `showIcon` v = `true`

                    )->end(
                )->end(

                )->ele( n = `BlockLayoutRow` ns = `l`
                    )->a( n = `scrollable` v = `true`

                    )->ele( n = `BlockLayoutCell` ns = `l`
                        )->a( n = `width` v = `50`
                        )->a( n = `title` v = `Cell inside scrollable row`

                        )->tag( `Text`
                            )->a( n = `text` v = lorem

                    )->end(
                    )->ele( n = `BlockLayoutCell` ns = `l`
                        )->a( n = `width`          v = `100`
                        )->a( n = `title`          v = `Centered Heading`
                        )->a( n = `titleAlignment` v = `Center`

                        )->tag( `Text`
                            )->a( n = `text` v = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore`

                    )->end(
                    )->ele( n = `BlockLayoutCell` ns = `l`
                        )->tag( `Text`
                            )->a( n = `text` v = lorem

                    )->end(
                    )->ele( n = `BlockLayoutCell` ns = `l`
                        )->a( n = `width` v = `90`

                        )->tag( `Text`
                            )->a( n = `text` v = lorem

                    )->end(
                    )->ele( n = `BlockLayoutCell` ns = `l`
                        )->tag( `Text`
                            )->a( n = `text` v = lorem

                    )->end(
                    )->ele( n = `BlockLayoutCell` ns = `l`
                        )->tag( `Text`
                            )->a( n = `text` v = lorem

                    )->end(
                )->end(

                )->ele( n = `BlockLayoutRow` ns = `l`
                    )->ele( n = `BlockLayoutCell` ns = `l`
                        )->a( n = `title` v = `75% width cell`
                        )->a( n = `width` v = `3`

                        )->ele( n = `SimpleForm` ns = `form`
                            )->a( n = `editable`         v = `true`
                            )->a( n = `backgroundDesign` v = `Transparent`
                            )->a( n = `layout`           v = `ResponsiveGridLayout`

                            )->tag( `Label`
                                )->a( n = `text` v = `Name on card`
                            )->tag( `Input`
                            )->tag( `Label`
                                )->a( n = `text` v = `Card number`
                            )->tag( `Input`
                            )->tag( `Label`
                                )->a( n = `text` v = `Security code`
                            )->tag( `Input`
                            )->tag( `Label`
                                )->a( n = `text` v = `Expiration date`
                            )->tag( `DatePicker`

                        )->end(

                        )->tag( `Text`
                            )->a( n = `text` v = lorem

                    )->end(
                    )->ele( n = `BlockLayoutCell` ns = `l`
                        )->a( n = `title` v = `25% width cell`

                        )->tag( `Text`
                            )->a( n = `text` v = lorem

                    )->end(
                )->end(

                )->ele( n = `BlockLayoutRow` ns = `l`
                    )->ele( n = `BlockLayoutCell` ns = `l`
                        )->a( n = `title` v = `25% width cell`

                        )->tag( `Text`
                            )->a( n = `text` v = lorem

                    )->end(
                    )->ele( n = `BlockLayoutCell` ns = `l`
                        )->a( n = `title` v = `25% width cell`

                        )->tag( `Text`
                            )->a( n = `text` v = lorem

                    )->end(
                    )->ele( n = `BlockLayoutCell` ns = `l`
                        )->a( n = `title` v = `25% width cell`

                        )->tag( `Text`
                            )->a( n = `text` v = lorem

                    )->end(
                    )->ele( n = `BlockLayoutCell` ns = `l`
                        )->a( n = `title` v = `25% width cell`

                        )->tag( `Text`
                            )->a( n = `text` v = lorem

                    )->end(
                )->end(

                )->ele( n = `BlockLayoutRow` ns = `l`
                    )->ele( n = `BlockLayoutCell` ns = `l`
                        )->tag( `Text`
                            )->a( n = `text` v = lorem

                    )->end(
                )->end(

                )->ele( n = `BlockLayoutRow` ns = `l`
                    )->ele( n = `BlockLayoutCell` ns = `l`
                        )->tag( `Text`
                            )->a( n = `text` v = lorem

                    )->end(
                )->end(

                )->ele( n = `BlockLayoutRow` ns = `l`
                    )->ele( n = `BlockLayoutCell` ns = `l`
                        )->tag( `Text`
                            )->a( n = `text` v = lorem

                    )->end(
                )->end(

                )->ele( n = `BlockLayoutRow` ns = `l`
                    )->a( n = `accentCells` v = `Accent2`

                    )->ele( n = `BlockLayoutCell` ns = `l`
                        )->a( n = `id` v = `Accent2`

                        )->tag( `MessageStrip`
                            )->a( n = `text` v = `You can use the cells with 100% width, if you set the vertical property of the row to true`

                        )->tag( `Text`
                            )->a( n = `text` v = lorem

                    )->end(
                )->end(

                )->ele( n = `BlockLayoutRow` ns = `l`
                    )->a( n = `accentCells` v = `Accent3`

                    )->ele( n = `BlockLayoutCell` ns = `l`
                        )->a( n = `id` v = `Accent3`

                        )->ele( `Table`
                            )->a( n = `id`    v = `idProductsTable`
                            )->a( n = `inset` v = `false`
                            )->a( n = `items` v = |\{ path: '{ client->_bind_path( t_products ) }', sorter: \{ path: 'NAME' \} \}|

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
                                    )->a( n = `minScreenWidth` v = `Tablet`
                                    )->a( n = `demandPopin`    v = `true`
                                    )->a( n = `hAlign`         v = `Right`

                                    )->tag( `Text`
                                        )->a( n = `text` v = `Dimensions`

                                )->end(
                                )->ele( `Column`
                                    )->a( n = `minScreenWidth` v = `Tablet`
                                    )->a( n = `demandPopin`    v = `true`
                                    )->a( n = `hAlign`         v = `Center`

                                    )->tag( `Text`
                                        )->a( n = `text` v = `Weight`

                                )->end(
                                )->ele( `Column`
                                    )->a( n = `hAlign` v = `Right`

                                    )->tag( `Text`
                                        )->a( n = `text` v = `Price`

                                )->end(
                            )->end(

                            )->ele( `items`
                                )->ele( `ColumnListItem`
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
                                        )->tag( `ObjectNumber`
                                            )->a( n = `number` v = |\{ parts:[\{path:'PRICE'\},\{path:'CURRENCYCODE'\}], type:'sap.ui.model.type.Currency' \}|
                                            )->a( n = `unit`   v = `{CURRENCYCODE}`

                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.
    DATA temp1 LIKE t_products.
    DATA temp2 LIKE LINE OF temp1.

    slider_value       = 100.
    selectedbackground = `Default`.

    " Product rows inlined from the shared mock ui5/mock/products.json
    " (/ProductCollection, all 123 rows; only the columns the table binds).
    
    CLEAR temp1.
    
    temp2-productid = `HT-1000`.
    temp2-name = `Notebook Basic 15`.
    temp2-suppliername = `Very Best Screens`.
    temp2-width = `30`.
    temp2-depth = `18`.
    temp2-height = `3`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `4.2`.
    temp2-weightunit = `KG`.
    temp2-price = `956`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1001`.
    temp2-name = `Notebook Basic 17`.
    temp2-suppliername = `Very Best Screens`.
    temp2-width = `29`.
    temp2-depth = `17`.
    temp2-height = `3.1`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `4.5`.
    temp2-weightunit = `KG`.
    temp2-price = `1249`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1002`.
    temp2-name = `Notebook Basic 18`.
    temp2-suppliername = `Very Best Screens`.
    temp2-width = `28`.
    temp2-depth = `19`.
    temp2-height = `2.5`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `4.2`.
    temp2-weightunit = `KG`.
    temp2-price = `1570`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1003`.
    temp2-name = `Notebook Basic 19`.
    temp2-suppliername = `Smartcards`.
    temp2-width = `32`.
    temp2-depth = `21`.
    temp2-height = `4`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `4.2`.
    temp2-weightunit = `KG`.
    temp2-price = `1650`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1007`.
    temp2-name = `ITelO Vault`.
    temp2-suppliername = `Technocom`.
    temp2-width = `32`.
    temp2-depth = `22`.
    temp2-height = `3`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.2`.
    temp2-weightunit = `KG`.
    temp2-price = `299`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1010`.
    temp2-name = `Notebook Professional 15`.
    temp2-suppliername = `Very Best Screens`.
    temp2-width = `33`.
    temp2-depth = `20`.
    temp2-height = `3`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `4.3`.
    temp2-weightunit = `KG`.
    temp2-price = `1999`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1011`.
    temp2-name = `Notebook Professional 17`.
    temp2-suppliername = `Very Best Screens`.
    temp2-width = `33`.
    temp2-depth = `23`.
    temp2-height = `2`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `4.1`.
    temp2-weightunit = `KG`.
    temp2-price = `2299`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1020`.
    temp2-name = `ITelO Vault Net`.
    temp2-suppliername = `Technocom`.
    temp2-width = `10`.
    temp2-depth = `1.8`.
    temp2-height = `17`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.16`.
    temp2-weightunit = `KG`.
    temp2-price = `459`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1021`.
    temp2-name = `ITelO Vault SAT`.
    temp2-suppliername = `Technocom`.
    temp2-width = `11`.
    temp2-depth = `1.7`.
    temp2-height = `18`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.18`.
    temp2-weightunit = `KG`.
    temp2-price = `149`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1022`.
    temp2-name = `Comfort Easy`.
    temp2-suppliername = `Technocom`.
    temp2-width = `84`.
    temp2-depth = `1.5`.
    temp2-height = `14`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.2`.
    temp2-weightunit = `KG`.
    temp2-price = `1679`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1023`.
    temp2-name = `Comfort Senior`.
    temp2-suppliername = `Technocom`.
    temp2-width = `80`.
    temp2-depth = `1.6`.
    temp2-height = `13`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.8`.
    temp2-weightunit = `KG`.
    temp2-price = `512`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1030`.
    temp2-name = `Ergo Screen E-I`.
    temp2-suppliername = `Very Best Screens`.
    temp2-width = `37`.
    temp2-depth = `12`.
    temp2-height = `36`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `21`.
    temp2-weightunit = `KG`.
    temp2-price = `230`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1031`.
    temp2-name = `Ergo Screen E-II`.
    temp2-suppliername = `Very Best Screens`.
    temp2-width = `40.8`.
    temp2-depth = `19`.
    temp2-height = `43`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `21`.
    temp2-weightunit = `KG`.
    temp2-price = `285`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1032`.
    temp2-name = `Ergo Screen E-III`.
    temp2-suppliername = `Very Best Screens`.
    temp2-width = `40.8`.
    temp2-depth = `19`.
    temp2-height = `43`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `21`.
    temp2-weightunit = `KG`.
    temp2-price = `345`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1035`.
    temp2-name = `Flat Basic`.
    temp2-suppliername = `Very Best Screens`.
    temp2-width = `39`.
    temp2-depth = `20`.
    temp2-height = `41`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `14`.
    temp2-weightunit = `KG`.
    temp2-price = `399`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1036`.
    temp2-name = `Flat Future`.
    temp2-suppliername = `Very Best Screens`.
    temp2-width = `45`.
    temp2-depth = `26`.
    temp2-height = `46`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `15`.
    temp2-weightunit = `KG`.
    temp2-price = `430`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1037`.
    temp2-name = `Flat XL`.
    temp2-suppliername = `Very Best Screens`.
    temp2-width = `54.5`.
    temp2-depth = `22.1`.
    temp2-height = `39.1`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `17`.
    temp2-weightunit = `KG`.
    temp2-price = `1230`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1040`.
    temp2-name = `Laser Professional Eco`.
    temp2-suppliername = `Alpha Printers`.
    temp2-width = `51`.
    temp2-depth = `46`.
    temp2-height = `30`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `32`.
    temp2-weightunit = `KG`.
    temp2-price = `830`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1041`.
    temp2-name = `Laser Basic`.
    temp2-suppliername = `Alpha Printers`.
    temp2-width = `48`.
    temp2-depth = `42`.
    temp2-height = `26`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `23`.
    temp2-weightunit = `KG`.
    temp2-price = `490`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1042`.
    temp2-name = `Laser Allround`.
    temp2-suppliername = `Alpha Printers`.
    temp2-width = `53`.
    temp2-depth = `50`.
    temp2-height = `65`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `17`.
    temp2-weightunit = `KG`.
    temp2-price = `349`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1050`.
    temp2-name = `Ultra Jet Super Color`.
    temp2-suppliername = `Alpha Printers`.
    temp2-width = `41`.
    temp2-depth = `41`.
    temp2-height = `28`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `3`.
    temp2-weightunit = `KG`.
    temp2-price = `139`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1051`.
    temp2-name = `Ultra Jet Mobile`.
    temp2-suppliername = `Printer for All`.
    temp2-width = `46`.
    temp2-depth = `32`.
    temp2-height = `25`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `1.9`.
    temp2-weightunit = `KG`.
    temp2-price = `99`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1052`.
    temp2-name = `Ultra Jet Super Highspeed`.
    temp2-suppliername = `Printer for All`.
    temp2-width = `41`.
    temp2-depth = `41`.
    temp2-height = `28`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `18`.
    temp2-weightunit = `KG`.
    temp2-price = `170`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1055`.
    temp2-name = `Multi Print`.
    temp2-suppliername = `Printer for All`.
    temp2-width = `55`.
    temp2-depth = `45`.
    temp2-height = `29`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `6.3`.
    temp2-weightunit = `KG`.
    temp2-price = `99`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1056`.
    temp2-name = `Multi Color`.
    temp2-suppliername = `Printer for All`.
    temp2-width = `51`.
    temp2-depth = `41.3`.
    temp2-height = `22`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `4.3`.
    temp2-weightunit = `KG`.
    temp2-price = `119`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1060`.
    temp2-name = `Cordless Mouse`.
    temp2-suppliername = `Oxynum`.
    temp2-width = `6`.
    temp2-depth = `14.5`.
    temp2-height = `3.5`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.09`.
    temp2-weightunit = `KG`.
    temp2-price = `9`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1061`.
    temp2-name = `Speed Mouse`.
    temp2-suppliername = `Oxynum`.
    temp2-width = `7`.
    temp2-depth = `15`.
    temp2-height = `3.1`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.09`.
    temp2-weightunit = `KG`.
    temp2-price = `7`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1062`.
    temp2-name = `Track Mouse`.
    temp2-suppliername = `Oxynum`.
    temp2-width = `3`.
    temp2-depth = `7`.
    temp2-height = `4`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.03`.
    temp2-weightunit = `KG`.
    temp2-price = `11`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1063`.
    temp2-name = `Ergonomic Keyboard`.
    temp2-suppliername = `Oxynum`.
    temp2-width = `50`.
    temp2-depth = `21`.
    temp2-height = `3.5`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `2.1`.
    temp2-weightunit = `KG`.
    temp2-price = `14`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1064`.
    temp2-name = `Internet Keyboard`.
    temp2-suppliername = `Oxynum`.
    temp2-width = `52`.
    temp2-depth = `25`.
    temp2-height = `3`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `1.8`.
    temp2-weightunit = `KG`.
    temp2-price = `16`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1065`.
    temp2-name = `Media Keyboard`.
    temp2-suppliername = `Oxynum`.
    temp2-width = `51.4`.
    temp2-depth = `23`.
    temp2-height = `4`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `2.3`.
    temp2-weightunit = `KG`.
    temp2-price = `26`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1066`.
    temp2-name = `Mousepad`.
    temp2-suppliername = `Oxynum`.
    temp2-width = `15`.
    temp2-depth = `6`.
    temp2-height = `0.2`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `80`.
    temp2-weightunit = `G`.
    temp2-price = `6.99`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1067`.
    temp2-name = `Ergo Mousepad`.
    temp2-suppliername = `Oxynum`.
    temp2-width = `15`.
    temp2-depth = `6`.
    temp2-height = `0.2`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `80`.
    temp2-weightunit = `G`.
    temp2-price = `8.99`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1068`.
    temp2-name = `Designer Mousepad`.
    temp2-suppliername = `Fasttech`.
    temp2-width = `24`.
    temp2-depth = `24`.
    temp2-height = `0.6`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `90`.
    temp2-weightunit = `G`.
    temp2-price = `12.99`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1069`.
    temp2-name = `Universal card reader`.
    temp2-suppliername = `Fasttech`.
    temp2-width = `6`.
    temp2-depth = `6`.
    temp2-height = `3`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `45`.
    temp2-weightunit = `G`.
    temp2-price = `14`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1070`.
    temp2-name = `Proctra X`.
    temp2-suppliername = `Ultrasonic United`.
    temp2-width = `22`.
    temp2-depth = `35`.
    temp2-height = `17`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.255`.
    temp2-weightunit = `KG`.
    temp2-price = `70.9`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1071`.
    temp2-name = `Gladiator MX`.
    temp2-suppliername = `Ultrasonic United`.
    temp2-width = `22`.
    temp2-depth = `35`.
    temp2-height = `17`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.3`.
    temp2-weightunit = `KG`.
    temp2-price = `81.7`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1072`.
    temp2-name = `Hurricane GX`.
    temp2-suppliername = `Ultrasonic United`.
    temp2-width = `22`.
    temp2-depth = `35`.
    temp2-height = `17`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.4`.
    temp2-weightunit = `KG`.
    temp2-price = `101.2`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1073`.
    temp2-name = `Hurricane GX/LN`.
    temp2-suppliername = `Smartcards`.
    temp2-width = `22`.
    temp2-depth = `35`.
    temp2-height = `17`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.4`.
    temp2-weightunit = `KG`.
    temp2-price = `139.99`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1080`.
    temp2-name = `Photo Scan`.
    temp2-suppliername = `Printer for All`.
    temp2-width = `34`.
    temp2-depth = `48`.
    temp2-height = `5`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `2.3`.
    temp2-weightunit = `KG`.
    temp2-price = `129`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1081`.
    temp2-name = `Power Scan`.
    temp2-suppliername = `Printer for All`.
    temp2-width = `31`.
    temp2-depth = `43`.
    temp2-height = `7`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `2.4`.
    temp2-weightunit = `KG`.
    temp2-price = `89`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1082`.
    temp2-name = `Jet Scan Professional`.
    temp2-suppliername = `Printer for All`.
    temp2-width = `33`.
    temp2-depth = `41`.
    temp2-height = `12`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `3.2`.
    temp2-weightunit = `KG`.
    temp2-price = `169`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1083`.
    temp2-name = `Jet Scan Professional`.
    temp2-suppliername = `Printer for All`.
    temp2-width = `35`.
    temp2-depth = `40`.
    temp2-height = `10`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `3.2`.
    temp2-weightunit = `KG`.
    temp2-price = `189`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1085`.
    temp2-name = `Copymaster`.
    temp2-suppliername = `Alpha Printers`.
    temp2-width = `45`.
    temp2-depth = `42`.
    temp2-height = `22`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `23.2`.
    temp2-weightunit = `KG`.
    temp2-price = `1499`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1090`.
    temp2-name = `Surround Sound`.
    temp2-suppliername = `Speaker Experts`.
    temp2-width = `12`.
    temp2-depth = `10`.
    temp2-height = `16`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `3`.
    temp2-weightunit = `KG`.
    temp2-price = `39`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1091`.
    temp2-name = `Blaster Extreme`.
    temp2-suppliername = `Speaker Experts`.
    temp2-width = `13`.
    temp2-depth = `11`.
    temp2-height = `17.5`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `1.4`.
    temp2-weightunit = `KG`.
    temp2-price = `26`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1092`.
    temp2-name = `Sound Booster`.
    temp2-suppliername = `Speaker Experts`.
    temp2-width = `12.4`.
    temp2-depth = `10.4`.
    temp2-height = `18.1`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `2.1`.
    temp2-weightunit = `KG`.
    temp2-price = `45`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1095`.
    temp2-name = `Lovely Sound 5.1 Wireless`.
    temp2-suppliername = `Fasttech`.
    temp2-width = `24`.
    temp2-depth = `19`.
    temp2-height = `23`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `80`.
    temp2-weightunit = `G`.
    temp2-price = `49`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1096`.
    temp2-name = `Lovely Sound 5.1`.
    temp2-suppliername = `Fasttech`.
    temp2-width = `25`.
    temp2-depth = `17`.
    temp2-height = `19`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `130`.
    temp2-weightunit = `G`.
    temp2-price = `39`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1097`.
    temp2-name = `Lovely Sound Stereo`.
    temp2-suppliername = `Fasttech`.
    temp2-width = `21.3`.
    temp2-depth = `2.4`.
    temp2-height = `19.7`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `60`.
    temp2-weightunit = `G`.
    temp2-price = `29`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1100`.
    temp2-name = `Smart Office`.
    temp2-suppliername = `Technocom`.
    temp2-width = `15`.
    temp2-depth = `6.5`.
    temp2-height = `2.1`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `1.2`.
    temp2-weightunit = `KG`.
    temp2-price = `89.9`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1101`.
    temp2-name = `Smart Design`.
    temp2-suppliername = `Technocom`.
    temp2-width = `14`.
    temp2-depth = `6.7`.
    temp2-height = `24`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.8`.
    temp2-weightunit = `KG`.
    temp2-price = `79.9`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1102`.
    temp2-name = `Smart Network`.
    temp2-suppliername = `Technocom`.
    temp2-width = `16`.
    temp2-depth = `6`.
    temp2-height = `27`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.8`.
    temp2-weightunit = `KG`.
    temp2-price = `69`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1103`.
    temp2-name = `Smart Multimedia`.
    temp2-suppliername = `Technocom`.
    temp2-width = `11`.
    temp2-depth = `3.4`.
    temp2-height = `22`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.8`.
    temp2-weightunit = `KG`.
    temp2-price = `77`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1104`.
    temp2-name = `Smart Games`.
    temp2-suppliername = `Technocom`.
    temp2-width = `10`.
    temp2-depth = `3`.
    temp2-height = `30`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `1.1`.
    temp2-weightunit = `KG`.
    temp2-price = `55`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1105`.
    temp2-name = `Smart Internet Antivirus`.
    temp2-suppliername = `Brainsoft`.
    temp2-width = `16`.
    temp2-depth = `4`.
    temp2-height = `21`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.7`.
    temp2-weightunit = `KG`.
    temp2-price = `29`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1106`.
    temp2-name = `Smart Firewall`.
    temp2-suppliername = `Brainsoft`.
    temp2-width = `17.9`.
    temp2-depth = `4.2`.
    temp2-height = `23.1`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.9`.
    temp2-weightunit = `KG`.
    temp2-price = `34`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1107`.
    temp2-name = `Smart Money`.
    temp2-suppliername = `Brainsoft`.
    temp2-width = `12`.
    temp2-depth = `1.5`.
    temp2-height = `19`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.5`.
    temp2-weightunit = `KG`.
    temp2-price = `29.9`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1110`.
    temp2-name = `PC Lock`.
    temp2-suppliername = `Red Point Stores`.
    temp2-width = `20`.
    temp2-depth = `8`.
    temp2-height = `4.3`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.03`.
    temp2-weightunit = `KG`.
    temp2-price = `8.9`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1111`.
    temp2-name = `Notebook Lock`.
    temp2-suppliername = `Red Point Stores`.
    temp2-width = `31`.
    temp2-depth = `9`.
    temp2-height = `7`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.02`.
    temp2-weightunit = `KG`.
    temp2-price = `6.9`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1112`.
    temp2-name = `Web cam reality`.
    temp2-suppliername = `Red Point Stores`.
    temp2-width = `9`.
    temp2-depth = `8.2`.
    temp2-height = `1.3`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.075`.
    temp2-weightunit = `KG`.
    temp2-price = `39`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1113`.
    temp2-name = `Screen clean`.
    temp2-suppliername = `Red Point Stores`.
    temp2-width = `2`.
    temp2-depth = `2`.
    temp2-height = `0.1`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.05`.
    temp2-weightunit = `KG`.
    temp2-price = `2.3`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1114`.
    temp2-name = `Fabric bag professional`.
    temp2-suppliername = `Red Point Stores`.
    temp2-width = `42`.
    temp2-depth = `32`.
    temp2-height = `7`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `1.8`.
    temp2-weightunit = `KG`.
    temp2-price = `31`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1115`.
    temp2-name = `Wireless DSL Router`.
    temp2-suppliername = `Red Point Stores`.
    temp2-width = `19.3`.
    temp2-depth = `18`.
    temp2-height = `5`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.45`.
    temp2-weightunit = `KG`.
    temp2-price = `49`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1116`.
    temp2-name = `Wireless DSL Router / Repeater`.
    temp2-suppliername = `Red Point Stores`.
    temp2-width = `19.3`.
    temp2-depth = `18`.
    temp2-height = `5`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.45`.
    temp2-weightunit = `KG`.
    temp2-price = `59`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1117`.
    temp2-name = `Wireless DSL Router / Repeater and Print Server`.
    temp2-suppliername = `Technocom`.
    temp2-width = `19.3`.
    temp2-depth = `18`.
    temp2-height = `5`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.45`.
    temp2-weightunit = `KG`.
    temp2-price = `69`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1118`.
    temp2-name = `USB Stick`.
    temp2-suppliername = `Technocom`.
    temp2-width = `1.5`.
    temp2-depth = `8.7`.
    temp2-height = `1.2`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.015`.
    temp2-weightunit = `KG`.
    temp2-price = `35`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1119`.
    temp2-name = `Travel Adapter`.
    temp2-suppliername = `Titanium`.
    temp2-width = `2`.
    temp2-depth = `3.1`.
    temp2-height = `3.9`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `88`.
    temp2-weightunit = `G`.
    temp2-price = `79`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1120`.
    temp2-name = `Cordless Bluetooth Keyboard, english international`.
    temp2-suppliername = `Technocom`.
    temp2-width = `51.4`.
    temp2-depth = `23`.
    temp2-height = `4`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `1`.
    temp2-weightunit = `KG`.
    temp2-price = `29`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1137`.
    temp2-name = `Flat XXL`.
    temp2-suppliername = `Technocom`.
    temp2-width = `54`.
    temp2-depth = `22`.
    temp2-height = `38`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `18`.
    temp2-weightunit = `KG`.
    temp2-price = `1430`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1138`.
    temp2-name = `Pocket Mouse`.
    temp2-suppliername = `Technocom`.
    temp2-width = `0.3`.
    temp2-depth = `0.5`.
    temp2-height = `1`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.02`.
    temp2-weightunit = `KG`.
    temp2-price = `23`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1210`.
    temp2-name = `PC Power Station`.
    temp2-suppliername = `Technocom`.
    temp2-width = `28`.
    temp2-depth = `31`.
    temp2-height = `43`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `2.3`.
    temp2-weightunit = `KG`.
    temp2-price = `2399`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1251`.
    temp2-name = `Astro Laptop 1516`.
    temp2-suppliername = `Ultrasonic United`.
    temp2-width = `30`.
    temp2-depth = `18`.
    temp2-height = `3`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `4.2`.
    temp2-weightunit = `KG`.
    temp2-price = `989`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1252`.
    temp2-name = `Astro Phone 6`.
    temp2-suppliername = `Ultrasonic United`.
    temp2-width = `8`.
    temp2-depth = `6`.
    temp2-height = `1.5`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.75`.
    temp2-weightunit = `KG`.
    temp2-price = `649`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1253`.
    temp2-name = `Benda Laptop 1408`.
    temp2-suppliername = `Ultrasonic United`.
    temp2-width = `30`.
    temp2-depth = `18`.
    temp2-height = `3`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `4.2`.
    temp2-weightunit = `KG`.
    temp2-price = `976`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1254`.
    temp2-name = `Bending Screen 21HD`.
    temp2-suppliername = `Ultrasonic United`.
    temp2-width = `37`.
    temp2-depth = `12`.
    temp2-height = `36`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `15`.
    temp2-weightunit = `KG`.
    temp2-price = `250`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1255`.
    temp2-name = `Broad Screen 22HD`.
    temp2-suppliername = `Ultrasonic United`.
    temp2-width = `39`.
    temp2-depth = `12`.
    temp2-height = `38`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `16`.
    temp2-weightunit = `KG`.
    temp2-price = `270`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1256`.
    temp2-name = `Cerdik Phone 7`.
    temp2-suppliername = `Ultrasonic United`.
    temp2-width = `9`.
    temp2-depth = `15`.
    temp2-height = `1.5`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.75`.
    temp2-weightunit = `KG`.
    temp2-price = `549`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1257`.
    temp2-name = `Cepat Tablet 10.5`.
    temp2-suppliername = `Ultrasonic United`.
    temp2-width = `48`.
    temp2-depth = `31`.
    temp2-height = `4.5`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `2.8`.
    temp2-weightunit = `KG`.
    temp2-price = `549`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1258`.
    temp2-name = `Cepat Tablet 8`.
    temp2-suppliername = `Ultrasonic United`.
    temp2-width = `38`.
    temp2-depth = `21`.
    temp2-height = `3.5`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `2.5`.
    temp2-weightunit = `KG`.
    temp2-price = `529`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1500`.
    temp2-name = `Server Basic`.
    temp2-suppliername = `Technocom`.
    temp2-width = `34`.
    temp2-depth = `35`.
    temp2-height = `23`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `18`.
    temp2-weightunit = `KG`.
    temp2-price = `5000`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1501`.
    temp2-name = `Server Professional`.
    temp2-suppliername = `Technocom`.
    temp2-width = `29`.
    temp2-depth = `30`.
    temp2-height = `27`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `25`.
    temp2-weightunit = `KG`.
    temp2-price = `15000`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1502`.
    temp2-name = `Server Power Pro`.
    temp2-suppliername = `Technocom`.
    temp2-width = `22`.
    temp2-depth = `27.3`.
    temp2-height = `37`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `35`.
    temp2-weightunit = `KG`.
    temp2-price = `25000`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1600`.
    temp2-name = `Family PC Basic`.
    temp2-suppliername = `Titanium`.
    temp2-width = `21.4`.
    temp2-depth = `29`.
    temp2-height = `38`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `4.8`.
    temp2-weightunit = `KG`.
    temp2-price = `600`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1601`.
    temp2-name = `Family PC Pro`.
    temp2-suppliername = `Titanium`.
    temp2-width = `25`.
    temp2-depth = `31.7`.
    temp2-height = `40.2`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `5.3`.
    temp2-weightunit = `KG`.
    temp2-price = `900`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1602`.
    temp2-name = `Gaming Monster`.
    temp2-suppliername = `Titanium`.
    temp2-width = `26.5`.
    temp2-depth = `34`.
    temp2-height = `47`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `5.9`.
    temp2-weightunit = `KG`.
    temp2-price = `1200`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1603`.
    temp2-name = `Gaming Monster Pro`.
    temp2-suppliername = `Titanium`.
    temp2-width = `27`.
    temp2-depth = `28`.
    temp2-height = `42`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `6.8`.
    temp2-weightunit = `KG`.
    temp2-price = `1700`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-2000`.
    temp2-name = `7" Widescreen Portable DVD Player w MP3`.
    temp2-suppliername = `Titanium`.
    temp2-width = `21.4`.
    temp2-depth = `19`.
    temp2-height = `27.6`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.79`.
    temp2-weightunit = `KG`.
    temp2-price = `249.99`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-2001`.
    temp2-name = `10" Portable DVD player`.
    temp2-suppliername = `Titanium`.
    temp2-width = `24`.
    temp2-depth = `19.5`.
    temp2-height = `29`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.84`.
    temp2-weightunit = `KG`.
    temp2-price = `449.99`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-2002`.
    temp2-name = `Portable DVD Player with 9" LCD Monitor`.
    temp2-suppliername = `Technocom`.
    temp2-width = `21`.
    temp2-depth = `16.5`.
    temp2-height = `14`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.72`.
    temp2-weightunit = `KG`.
    temp2-price = `853.99`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-2025`.
    temp2-name = `CD/DVD case: 264 sleeves`.
    temp2-suppliername = `Titanium`.
    temp2-width = `13`.
    temp2-depth = `13`.
    temp2-height = `20`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.65`.
    temp2-weightunit = `KG`.
    temp2-price = `44.99`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-2026`.
    temp2-name = `Audio/Video Cable Kit - 4m`.
    temp2-suppliername = `Titanium`.
    temp2-width = `21`.
    temp2-depth = `10.2`.
    temp2-height = `13`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.2`.
    temp2-weightunit = `KG`.
    temp2-price = `29.99`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-2027`.
    temp2-name = `Removable CD/DVD Laser Labels`.
    temp2-suppliername = `Titanium`.
    temp2-width = `5.5`.
    temp2-depth = `2`.
    temp2-height = `2`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.15`.
    temp2-weightunit = `KG`.
    temp2-price = `8.99`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6100`.
    temp2-name = `Beam Breaker B-1`.
    temp2-suppliername = `Titanium`.
    temp2-width = `30.4`.
    temp2-depth = `23.1`.
    temp2-height = `23`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `1.7`.
    temp2-weightunit = `KG`.
    temp2-price = `469`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6101`.
    temp2-name = `Beam Breaker B-2`.
    temp2-suppliername = `Technocom`.
    temp2-width = `30.4`.
    temp2-depth = `23.1`.
    temp2-height = `23`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `2`.
    temp2-weightunit = `KG`.
    temp2-price = `679`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6102`.
    temp2-name = `Beam Breaker B-3`.
    temp2-suppliername = `Technocom`.
    temp2-width = `30.4`.
    temp2-depth = `23.1`.
    temp2-height = `23`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `2.5`.
    temp2-weightunit = `KG`.
    temp2-price = `889`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6110`.
    temp2-name = `Play Movie`.
    temp2-suppliername = `Fasttech`.
    temp2-width = `37`.
    temp2-depth = `24`.
    temp2-height = `6`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `2.4`.
    temp2-weightunit = `KG`.
    temp2-price = `130`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6111`.
    temp2-name = `Record Movie`.
    temp2-suppliername = `Fasttech`.
    temp2-width = `38`.
    temp2-depth = `26`.
    temp2-height = `6.2`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `3.1`.
    temp2-weightunit = `KG`.
    temp2-price = `288`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6120`.
    temp2-name = `ITelo MusicStick`.
    temp2-suppliername = `Fasttech`.
    temp2-width = `1.5`.
    temp2-depth = `6`.
    temp2-height = `1`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `134`.
    temp2-weightunit = `G`.
    temp2-price = `45`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6121`.
    temp2-name = `ITelo Jog-Mate`.
    temp2-suppliername = `Fasttech`.
    temp2-width = `5.1`.
    temp2-depth = `8`.
    temp2-height = `9.2`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `134`.
    temp2-weightunit = `G`.
    temp2-price = `63`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6122`.
    temp2-name = `Power Pro Player 40`.
    temp2-suppliername = `Fasttech`.
    temp2-width = `5.1`.
    temp2-depth = `8`.
    temp2-height = `9.2`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `266`.
    temp2-weightunit = `G`.
    temp2-price = `167`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6123`.
    temp2-name = `Power Pro Player 80`.
    temp2-suppliername = `Fasttech`.
    temp2-width = `4`.
    temp2-depth = `6`.
    temp2-height = `0.8`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `267`.
    temp2-weightunit = `G`.
    temp2-price = `299`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6130`.
    temp2-name = `Flat Watch HD32`.
    temp2-suppliername = `Very Best Screens`.
    temp2-width = `78`.
    temp2-depth = `22.1`.
    temp2-height = `55`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `2.6`.
    temp2-weightunit = `KG`.
    temp2-price = `1459`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6131`.
    temp2-name = `Flat Watch HD37`.
    temp2-suppliername = `Very Best Screens`.
    temp2-width = `99.1`.
    temp2-depth = `26`.
    temp2-height = `61`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `2.2`.
    temp2-weightunit = `KG`.
    temp2-price = `1199`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6132`.
    temp2-name = `Flat Watch HD41`.
    temp2-suppliername = `Very Best Screens`.
    temp2-width = `128`.
    temp2-depth = `23`.
    temp2-height = `79.1`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `1.8`.
    temp2-weightunit = `KG`.
    temp2-price = `899`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-7000`.
    temp2-name = `Copperberry`.
    temp2-suppliername = `Fasttech`.
    temp2-width = `8.1`.
    temp2-depth = `13`.
    temp2-height = `12.1`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.5`.
    temp2-weightunit = `KG`.
    temp2-price = `549`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-7010`.
    temp2-name = `Silverberry`.
    temp2-suppliername = `Fasttech`.
    temp2-width = `8.1`.
    temp2-depth = `13`.
    temp2-height = `12.1`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.5`.
    temp2-weightunit = `KG`.
    temp2-price = `549`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-7020`.
    temp2-name = `Goldberry`.
    temp2-suppliername = `Fasttech`.
    temp2-width = `8.1`.
    temp2-depth = `13`.
    temp2-height = `12.1`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.5`.
    temp2-weightunit = `KG`.
    temp2-price = `549`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-7030`.
    temp2-name = `Platinberry`.
    temp2-suppliername = `Fasttech`.
    temp2-width = `8.1`.
    temp2-depth = `13`.
    temp2-height = `12.1`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.5`.
    temp2-weightunit = `KG`.
    temp2-price = `549`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-8000`.
    temp2-name = `ITelO FlexTop I4000`.
    temp2-suppliername = `Titanium`.
    temp2-width = `31`.
    temp2-depth = `19`.
    temp2-height = `3.1`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `4`.
    temp2-weightunit = `KG`.
    temp2-price = `799`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-8001`.
    temp2-name = `ITelO FlexTop I6300c`.
    temp2-suppliername = `Titanium`.
    temp2-width = `32`.
    temp2-depth = `20`.
    temp2-height = `3.4`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `4.2`.
    temp2-weightunit = `KG`.
    temp2-price = `799`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-8002`.
    temp2-name = `ITelO FlexTop I9100`.
    temp2-suppliername = `Titanium`.
    temp2-width = `38`.
    temp2-depth = `21`.
    temp2-height = `4.1`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `3.5`.
    temp2-weightunit = `KG`.
    temp2-price = `1199`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-8003`.
    temp2-name = `ITelO FlexTop I9800`.
    temp2-suppliername = `Titanium`.
    temp2-width = `48`.
    temp2-depth = `31`.
    temp2-height = `4.5`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `3.8`.
    temp2-weightunit = `KG`.
    temp2-price = `1388`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-9991`.
    temp2-name = `Smartphone Leather Case`.
    temp2-suppliername = `Ultrasonic United`.
    temp2-width = `48`.
    temp2-depth = `31`.
    temp2-height = `4.5`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.02`.
    temp2-weightunit = `KG`.
    temp2-price = `25`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-9992`.
    temp2-name = `Smartphone Alpha`.
    temp2-suppliername = `Ultrasonic United`.
    temp2-width = `48`.
    temp2-depth = `31`.
    temp2-height = `4.5`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.75`.
    temp2-weightunit = `KG`.
    temp2-price = `599`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-9993`.
    temp2-name = `Mini Tablet`.
    temp2-suppliername = `Ultrasonic United`.
    temp2-width = `48`.
    temp2-depth = `31`.
    temp2-height = `4.5`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `3.8`.
    temp2-weightunit = `KG`.
    temp2-price = `833`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-9994`.
    temp2-name = `Camcorder View`.
    temp2-suppliername = `Ultrasonic United`.
    temp2-width = `48`.
    temp2-depth = `31`.
    temp2-height = `27`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `3.8`.
    temp2-weightunit = `KG`.
    temp2-price = `1388`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-9995`.
    temp2-name = `Tablet Pouch`.
    temp2-suppliername = `Titanium`.
    temp2-width = `25`.
    temp2-depth = `40`.
    temp2-height = `4.5`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.03`.
    temp2-weightunit = `KG`.
    temp2-price = `20`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-9996`.
    temp2-name = `Tablet Pouch`.
    temp2-suppliername = `Titanium`.
    temp2-width = `25`.
    temp2-depth = `40`.
    temp2-height = `4.5`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.03`.
    temp2-weightunit = `KG`.
    temp2-price = `20`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-9997`.
    temp2-name = `e-Book Reader ReadMe`.
    temp2-suppliername = `Titanium`.
    temp2-width = `48`.
    temp2-depth = `31`.
    temp2-height = `4.5`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `3.8`.
    temp2-weightunit = `KG`.
    temp2-price = `33`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-9998`.
    temp2-name = `Smartphone Beta`.
    temp2-suppliername = `Titanium`.
    temp2-width = `48`.
    temp2-depth = `31`.
    temp2-height = `4.5`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.75`.
    temp2-weightunit = `KG`.
    temp2-price = `30`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-9999`.
    temp2-name = `Maxi Tablet`.
    temp2-suppliername = `Titanium`.
    temp2-width = `48`.
    temp2-depth = `31`.
    temp2-height = `4.5`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `3.8`.
    temp2-weightunit = `KG`.
    temp2-price = `749`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `PF-1000`.
    temp2-name = `Flyer`.
    temp2-suppliername = `Titanium`.
    temp2-width = `46`.
    temp2-depth = `30`.
    temp2-height = `3`.
    temp2-dimunit = `cm`.
    temp2-weightmeasure = `0.01`.
    temp2-weightunit = `KG`.
    temp2-price = `0`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    t_products = temp1.

  ENDMETHOD.

ENDCLASS.
