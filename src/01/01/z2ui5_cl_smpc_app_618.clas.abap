" @keywords icontabbar icon tab bar sap.m icontabbarprocess icontabfilter icontabseparator table overflowtoolbar label column
" @summary In this example, the Icon Tab Bar is used to apply filters on the same content along a business process.
CLASS z2ui5_cl_smpc_app_618 DEFINITION PUBLIC.

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
             weightmeasure TYPE string,
             weightunit    TYPE string,
             " Formatter.weightState, computed in the backend (thin frontend)
             weight_state  TYPE string,
             price         TYPE string,
             currencycode  TYPE string,
           END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

    DATA t_products TYPE ty_t_product.

    " ProductCollectionStats/Counts - what the four tab filters show
    DATA count_total       TYPE string.
    DATA count_ok          TYPE string.
    DATA count_heavy       TYPE string.
    DATA count_overweight  TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    " PROTECTED, not PRIVATE: the app's state is serialized into the draft with
    " CALL TRANSFORMATION id, and the transpiled runtime's re-implementation of
    " it walks the attributes with a dynamic ASSIGN obj->(name), which cannot
    " reach a PRIVATE one - it asserts, and every roundtrip 500s with
    " ASSERTION_FAILED (e2e-caught 2026-08-22)
    DATA t_all TYPE ty_t_product.

    METHODS view_display.
    METHODS on_event.
    METHODS filter_apply.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_618 IMPLEMENTATION.

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
    DATA panel TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA bar TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA table TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    panel = view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc` ).

    
    bar = panel->ele( `IconTabBar`
        )->a( n = `id`                      v = `idIconTabBar`
        )->a( n = `class`                   v = `sapUiResponsiveContentPadding`
        )->a( n = `select`                  v = client->_event( val = `FILTER` arg = `${$parameters>/key}` ) ).

    bar->ele( `items`
        )->tag( `IconTabFilter`
            )->a( n = `icon`      v = `sap-icon://begin`
            )->a( n = `iconColor` v = `Positive`
            )->a( n = `design`    v = `Horizontal`
            )->a( n = `count`     v = client->_bind( count_ok )
            )->a( n = `text`      v = `Confirm Ok`
            )->a( n = `key`       v = `Ok`
        )->tag( `IconTabSeparator`
            )->a( n = `icon` v = `sap-icon://open-command-field`
        )->tag( `IconTabFilter`
            )->a( n = `icon`      v = `sap-icon://compare`
            )->a( n = `iconColor` v = `Critical`
            )->a( n = `design`    v = `Horizontal`
            )->a( n = `count`     v = client->_bind( count_heavy )
            )->a( n = `text`      v = `Check Heavys`
            )->a( n = `key`       v = `Heavy`
        )->tag( `IconTabSeparator`
            )->a( n = `icon` v = `sap-icon://open-command-field`
        )->tag( `IconTabFilter`
            )->a( n = `icon`      v = `sap-icon://inventory`
            )->a( n = `iconColor` v = `Negative`
            )->a( n = `design`    v = `Horizontal`
            )->a( n = `count`     v = client->_bind( count_overweight )
            )->a( n = `text`      v = `Claim Overweights`
            )->a( n = `key`       v = `Overweight`
    )->end( ).

    
    table = bar->ele( `content`
        )->ele( `Table`
            )->a( n = `id`             v = `productsTable`
            )->a( n = `inset`          v = `false`
            )->a( n = `showSeparators` v = `Inner`
            )->a( n = `headerText`     v = `Products`
            " the rows binding carries a sorter on Name; a thin frontend sorts
            " the data it sends (app 298 idiom)
            )->a( n = `items`          v = client->_bind( t_products ) ).

    table->ele( `infoToolbar`
        )->ele( `OverflowToolbar`
            )->tag( `Label`
                )->a( n = `text` v = `Wide range of available products`
        )->end(
    )->end( ).

    table->ele( `columns`
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
    )->end( ).

    table->ele( `items`
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
                    )->a( n = `state`  v = `{WEIGHT_STATE}`
                )->tag( `ObjectNumber`
                    )->a( n = `number` v = |\{ parts:[\{path:'PRICE'\},\{path:'CURRENCYCODE'\}],| &&
                                          | type: 'sap.ui.model.type.Currency', formatOptions: \{showMeasure: false\} \}|
                    )->a( n = `unit`   v = `{CURRENCYCODE}`
            )->end(
        )->end(
    )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `FILTER`.
      filter_apply( ).
    ENDIF.

  ENDMETHOD.


  METHOD filter_apply.

    DATA lt_keep TYPE ty_t_product.

    " onFilterSelect: the picked tab's weight range; a thin frontend filters
    " the data it sends rather than the binding (app 298 idiom)
    DATA key TYPE string.
    DATA row LIKE LINE OF t_products.
      DATA temp1 TYPE decfloat34.
      DATA temp3 TYPE decfloat34.
      DATA temp4 TYPE decfloat34.
      DATA kg LIKE temp4.
      DATA temp2 TYPE abap_bool.
          DATA temp5 TYPE xsdboolean.
          DATA temp6 TYPE xsdboolean.
          DATA temp7 TYPE xsdboolean.
      DATA keep LIKE temp2.
    key = client->get_event_arg( ).

    t_products = t_all.
    IF key IS INITIAL.
      RETURN.
    ENDIF.

    " the sample OR-s a KG filter with a G one, each AND-ed with its own bounds
    " (1 / 5 kg, 1000 / 5000 g); comparing in kilograms is the same partition.
    " Collected rather than deleted in place: DELETE ... INDEX sy-tabix inside
    " a LOOP over the same table shifts the rows under the loop's own cursor -
    " on a system it silently SKIPS the row after each deletion, on the
    " transpiled backend it raises TABLE_INVALID_INDEX (app 298, 2026-08-17)
    CLEAR lt_keep.
    
    LOOP AT t_products INTO row.
      
      temp1 = row-weightmeasure.
      
      temp3 = row-weightmeasure.
      
      IF row-weightunit = `G`.
        temp4 = temp1 / 1000.
      ELSE.
        temp4 = temp3.
      ENDIF.
      
      kg = temp4.
      
      CASE key.
        WHEN `Ok`.
          
          temp5 = boolc( kg < 1 ).
          temp2 = temp5.
        WHEN `Heavy`.
          
          temp6 = boolc( kg >= 1 AND kg <= 5 ).
          temp2 = temp6.
        WHEN `Overweight`.
          
          temp7 = boolc( kg > 5 ).
          temp2 = temp7.
        WHEN OTHERS.
          temp2 = abap_true.
      ENDCASE.
      
      keep = temp2.
      IF keep = abap_true.
        APPEND row TO lt_keep.
      ENDIF.
    ENDLOOP.
    t_products = lt_keep.

  ENDMETHOD.


  METHOD model_init.
    DATA temp3 TYPE z2ui5_cl_smpc_app_618=>ty_t_product.
    DATA temp4 LIKE LINE OF temp3.

    " sap/ui/demo/mock/products.json /ProductCollectionStats/Counts
    " the counts are composed '<n> of <total>' in the sample's own binding
    count_total      = `123`.
    count_ok         = |53 of { count_total }|.
    count_heavy      = |51 of { count_total }|.
    count_overweight = |19 of { count_total }|.

    " /ProductCollection, seeded verbatim; weight_state is Formatter.weightState
    " over the row's own measure and unit, computed here rather than in the view
    
    CLEAR temp3.
    
    temp4-name = `Notebook Basic 15`.
    temp4-productid = `HT-1000`.
    temp4-suppliername = `Very Best Screens`.
    temp4-width = `30`.
    temp4-depth = `18`.
    temp4-height = `3`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `4.2`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `956`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Basic 17`.
    temp4-productid = `HT-1001`.
    temp4-suppliername = `Very Best Screens`.
    temp4-width = `29`.
    temp4-depth = `17`.
    temp4-height = `3.1`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `4.5`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `1249`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Basic 18`.
    temp4-productid = `HT-1002`.
    temp4-suppliername = `Very Best Screens`.
    temp4-width = `28`.
    temp4-depth = `19`.
    temp4-height = `2.5`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `4.2`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `1570`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Basic 19`.
    temp4-productid = `HT-1003`.
    temp4-suppliername = `Smartcards`.
    temp4-width = `32`.
    temp4-depth = `21`.
    temp4-height = `4`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `4.2`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `1650`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO Vault`.
    temp4-productid = `HT-1007`.
    temp4-suppliername = `Technocom`.
    temp4-width = `32`.
    temp4-depth = `22`.
    temp4-height = `3`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.2`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `299`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Professional 15`.
    temp4-productid = `HT-1010`.
    temp4-suppliername = `Very Best Screens`.
    temp4-width = `33`.
    temp4-depth = `20`.
    temp4-height = `3`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `4.3`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `1999`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Professional 17`.
    temp4-productid = `HT-1011`.
    temp4-suppliername = `Very Best Screens`.
    temp4-width = `33`.
    temp4-depth = `23`.
    temp4-height = `2`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `4.1`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `2299`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO Vault Net`.
    temp4-productid = `HT-1020`.
    temp4-suppliername = `Technocom`.
    temp4-width = `10`.
    temp4-depth = `1.8`.
    temp4-height = `17`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.16`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `459`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO Vault SAT`.
    temp4-productid = `HT-1021`.
    temp4-suppliername = `Technocom`.
    temp4-width = `11`.
    temp4-depth = `1.7`.
    temp4-height = `18`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.18`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `149`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Comfort Easy`.
    temp4-productid = `HT-1022`.
    temp4-suppliername = `Technocom`.
    temp4-width = `84`.
    temp4-depth = `1.5`.
    temp4-height = `14`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.2`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `1679`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Comfort Senior`.
    temp4-productid = `HT-1023`.
    temp4-suppliername = `Technocom`.
    temp4-width = `80`.
    temp4-depth = `1.6`.
    temp4-height = `13`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.8`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `512`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergo Screen E-I`.
    temp4-productid = `HT-1030`.
    temp4-suppliername = `Very Best Screens`.
    temp4-width = `37`.
    temp4-depth = `12`.
    temp4-height = `36`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `21`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Error`.
    temp4-price = `230`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergo Screen E-II`.
    temp4-productid = `HT-1031`.
    temp4-suppliername = `Very Best Screens`.
    temp4-width = `40.8`.
    temp4-depth = `19`.
    temp4-height = `43`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `21`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Error`.
    temp4-price = `285`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergo Screen E-III`.
    temp4-productid = `HT-1032`.
    temp4-suppliername = `Very Best Screens`.
    temp4-width = `40.8`.
    temp4-depth = `19`.
    temp4-height = `43`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `21`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Error`.
    temp4-price = `345`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Basic`.
    temp4-productid = `HT-1035`.
    temp4-suppliername = `Very Best Screens`.
    temp4-width = `39`.
    temp4-depth = `20`.
    temp4-height = `41`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `14`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Error`.
    temp4-price = `399`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Future`.
    temp4-productid = `HT-1036`.
    temp4-suppliername = `Very Best Screens`.
    temp4-width = `45`.
    temp4-depth = `26`.
    temp4-height = `46`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `15`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Error`.
    temp4-price = `430`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat XL`.
    temp4-productid = `HT-1037`.
    temp4-suppliername = `Very Best Screens`.
    temp4-width = `54.5`.
    temp4-depth = `22.1`.
    temp4-height = `39.1`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `17`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Error`.
    temp4-price = `1230`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Laser Professional Eco`.
    temp4-productid = `HT-1040`.
    temp4-suppliername = `Alpha Printers`.
    temp4-width = `51`.
    temp4-depth = `46`.
    temp4-height = `30`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `32`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Error`.
    temp4-price = `830`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Laser Basic`.
    temp4-productid = `HT-1041`.
    temp4-suppliername = `Alpha Printers`.
    temp4-width = `48`.
    temp4-depth = `42`.
    temp4-height = `26`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `23`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Error`.
    temp4-price = `490`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Laser Allround`.
    temp4-productid = `HT-1042`.
    temp4-suppliername = `Alpha Printers`.
    temp4-width = `53`.
    temp4-depth = `50`.
    temp4-height = `65`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `17`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Error`.
    temp4-price = `349`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ultra Jet Super Color`.
    temp4-productid = `HT-1050`.
    temp4-suppliername = `Alpha Printers`.
    temp4-width = `41`.
    temp4-depth = `41`.
    temp4-height = `28`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `3`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `139`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ultra Jet Mobile`.
    temp4-productid = `HT-1051`.
    temp4-suppliername = `Printer for All`.
    temp4-width = `46`.
    temp4-depth = `32`.
    temp4-height = `25`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `1.9`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `99`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ultra Jet Super Highspeed`.
    temp4-productid = `HT-1052`.
    temp4-suppliername = `Printer for All`.
    temp4-width = `41`.
    temp4-depth = `41`.
    temp4-height = `28`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `18`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Error`.
    temp4-price = `170`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Multi Print`.
    temp4-productid = `HT-1055`.
    temp4-suppliername = `Printer for All`.
    temp4-width = `55`.
    temp4-depth = `45`.
    temp4-height = `29`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `6.3`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Error`.
    temp4-price = `99`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Multi Color`.
    temp4-productid = `HT-1056`.
    temp4-suppliername = `Printer for All`.
    temp4-width = `51`.
    temp4-depth = `41.3`.
    temp4-height = `22`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `4.3`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `119`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cordless Mouse`.
    temp4-productid = `HT-1060`.
    temp4-suppliername = `Oxynum`.
    temp4-width = `6`.
    temp4-depth = `14.5`.
    temp4-height = `3.5`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.09`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `9`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Speed Mouse`.
    temp4-productid = `HT-1061`.
    temp4-suppliername = `Oxynum`.
    temp4-width = `7`.
    temp4-depth = `15`.
    temp4-height = `3.1`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.09`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `7`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Track Mouse`.
    temp4-productid = `HT-1062`.
    temp4-suppliername = `Oxynum`.
    temp4-width = `3`.
    temp4-depth = `7`.
    temp4-height = `4`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.03`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `11`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergonomic Keyboard`.
    temp4-productid = `HT-1063`.
    temp4-suppliername = `Oxynum`.
    temp4-width = `50`.
    temp4-depth = `21`.
    temp4-height = `3.5`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `2.1`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `14`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Internet Keyboard`.
    temp4-productid = `HT-1064`.
    temp4-suppliername = `Oxynum`.
    temp4-width = `52`.
    temp4-depth = `25`.
    temp4-height = `3`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `1.8`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `16`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Media Keyboard`.
    temp4-productid = `HT-1065`.
    temp4-suppliername = `Oxynum`.
    temp4-width = `51.4`.
    temp4-depth = `23`.
    temp4-height = `4`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `2.3`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `26`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Mousepad`.
    temp4-productid = `HT-1066`.
    temp4-suppliername = `Oxynum`.
    temp4-width = `15`.
    temp4-depth = `6`.
    temp4-height = `0.2`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `80`.
    temp4-weightunit = `G`.
    temp4-weight_state = `Success`.
    temp4-price = `6.99`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergo Mousepad`.
    temp4-productid = `HT-1067`.
    temp4-suppliername = `Oxynum`.
    temp4-width = `15`.
    temp4-depth = `6`.
    temp4-height = `0.2`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `80`.
    temp4-weightunit = `G`.
    temp4-weight_state = `Success`.
    temp4-price = `8.99`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Designer Mousepad`.
    temp4-productid = `HT-1068`.
    temp4-suppliername = `Fasttech`.
    temp4-width = `24`.
    temp4-depth = `24`.
    temp4-height = `0.6`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `90`.
    temp4-weightunit = `G`.
    temp4-weight_state = `Success`.
    temp4-price = `12.99`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Universal card reader`.
    temp4-productid = `HT-1069`.
    temp4-suppliername = `Fasttech`.
    temp4-width = `6`.
    temp4-depth = `6`.
    temp4-height = `3`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `45`.
    temp4-weightunit = `G`.
    temp4-weight_state = `Success`.
    temp4-price = `14`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Proctra X`.
    temp4-productid = `HT-1070`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-width = `22`.
    temp4-depth = `35`.
    temp4-height = `17`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.255`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `70.9`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Gladiator MX`.
    temp4-productid = `HT-1071`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-width = `22`.
    temp4-depth = `35`.
    temp4-height = `17`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.3`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `81.7`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Hurricane GX`.
    temp4-productid = `HT-1072`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-width = `22`.
    temp4-depth = `35`.
    temp4-height = `17`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.4`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `101.2`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Hurricane GX/LN`.
    temp4-productid = `HT-1073`.
    temp4-suppliername = `Smartcards`.
    temp4-width = `22`.
    temp4-depth = `35`.
    temp4-height = `17`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.4`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `139.99`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Photo Scan`.
    temp4-productid = `HT-1080`.
    temp4-suppliername = `Printer for All`.
    temp4-width = `34`.
    temp4-depth = `48`.
    temp4-height = `5`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `2.3`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `129`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Power Scan`.
    temp4-productid = `HT-1081`.
    temp4-suppliername = `Printer for All`.
    temp4-width = `31`.
    temp4-depth = `43`.
    temp4-height = `7`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `2.4`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `89`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Jet Scan Professional`.
    temp4-productid = `HT-1082`.
    temp4-suppliername = `Printer for All`.
    temp4-width = `33`.
    temp4-depth = `41`.
    temp4-height = `12`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `3.2`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `169`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Jet Scan Professional`.
    temp4-productid = `HT-1083`.
    temp4-suppliername = `Printer for All`.
    temp4-width = `35`.
    temp4-depth = `40`.
    temp4-height = `10`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `3.2`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `189`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Copymaster`.
    temp4-productid = `HT-1085`.
    temp4-suppliername = `Alpha Printers`.
    temp4-width = `45`.
    temp4-depth = `42`.
    temp4-height = `22`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `23.2`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Error`.
    temp4-price = `1499`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Surround Sound`.
    temp4-productid = `HT-1090`.
    temp4-suppliername = `Speaker Experts`.
    temp4-width = `12`.
    temp4-depth = `10`.
    temp4-height = `16`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `3`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `39`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Blaster Extreme`.
    temp4-productid = `HT-1091`.
    temp4-suppliername = `Speaker Experts`.
    temp4-width = `13`.
    temp4-depth = `11`.
    temp4-height = `17.5`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `1.4`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `26`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Sound Booster`.
    temp4-productid = `HT-1092`.
    temp4-suppliername = `Speaker Experts`.
    temp4-width = `12.4`.
    temp4-depth = `10.4`.
    temp4-height = `18.1`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `2.1`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `45`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Lovely Sound 5.1 Wireless`.
    temp4-productid = `HT-1095`.
    temp4-suppliername = `Fasttech`.
    temp4-width = `24`.
    temp4-depth = `19`.
    temp4-height = `23`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `80`.
    temp4-weightunit = `G`.
    temp4-weight_state = `Success`.
    temp4-price = `49`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Lovely Sound 5.1`.
    temp4-productid = `HT-1096`.
    temp4-suppliername = `Fasttech`.
    temp4-width = `25`.
    temp4-depth = `17`.
    temp4-height = `19`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `130`.
    temp4-weightunit = `G`.
    temp4-weight_state = `Success`.
    temp4-price = `39`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Lovely Sound Stereo`.
    temp4-productid = `HT-1097`.
    temp4-suppliername = `Fasttech`.
    temp4-width = `21.3`.
    temp4-depth = `2.4`.
    temp4-height = `19.7`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `60`.
    temp4-weightunit = `G`.
    temp4-weight_state = `Success`.
    temp4-price = `29`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Office`.
    temp4-productid = `HT-1100`.
    temp4-suppliername = `Technocom`.
    temp4-width = `15`.
    temp4-depth = `6.5`.
    temp4-height = `2.1`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `1.2`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `89.9`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Design`.
    temp4-productid = `HT-1101`.
    temp4-suppliername = `Technocom`.
    temp4-width = `14`.
    temp4-depth = `6.7`.
    temp4-height = `24`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.8`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `79.9`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Network`.
    temp4-productid = `HT-1102`.
    temp4-suppliername = `Technocom`.
    temp4-width = `16`.
    temp4-depth = `6`.
    temp4-height = `27`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.8`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `69`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Multimedia`.
    temp4-productid = `HT-1103`.
    temp4-suppliername = `Technocom`.
    temp4-width = `11`.
    temp4-depth = `3.4`.
    temp4-height = `22`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.8`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `77`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Games`.
    temp4-productid = `HT-1104`.
    temp4-suppliername = `Technocom`.
    temp4-width = `10`.
    temp4-depth = `3`.
    temp4-height = `30`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `1.1`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `55`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Internet Antivirus`.
    temp4-productid = `HT-1105`.
    temp4-suppliername = `Brainsoft`.
    temp4-width = `16`.
    temp4-depth = `4`.
    temp4-height = `21`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.7`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `29`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Firewall`.
    temp4-productid = `HT-1106`.
    temp4-suppliername = `Brainsoft`.
    temp4-width = `17.9`.
    temp4-depth = `4.2`.
    temp4-height = `23.1`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.9`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `34`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Money`.
    temp4-productid = `HT-1107`.
    temp4-suppliername = `Brainsoft`.
    temp4-width = `12`.
    temp4-depth = `1.5`.
    temp4-height = `19`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.5`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `29.9`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `PC Lock`.
    temp4-productid = `HT-1110`.
    temp4-suppliername = `Red Point Stores`.
    temp4-width = `20`.
    temp4-depth = `8`.
    temp4-height = `4.3`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.03`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `8.9`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Lock`.
    temp4-productid = `HT-1111`.
    temp4-suppliername = `Red Point Stores`.
    temp4-width = `31`.
    temp4-depth = `9`.
    temp4-height = `7`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.02`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `6.9`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Web cam reality`.
    temp4-productid = `HT-1112`.
    temp4-suppliername = `Red Point Stores`.
    temp4-width = `9`.
    temp4-depth = `8.2`.
    temp4-height = `1.3`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.075`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `39`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Screen clean`.
    temp4-productid = `HT-1113`.
    temp4-suppliername = `Red Point Stores`.
    temp4-width = `2`.
    temp4-depth = `2`.
    temp4-height = `0.1`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.05`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `2.3`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Fabric bag professional`.
    temp4-productid = `HT-1114`.
    temp4-suppliername = `Red Point Stores`.
    temp4-width = `42`.
    temp4-depth = `32`.
    temp4-height = `7`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `1.8`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `31`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Wireless DSL Router`.
    temp4-productid = `HT-1115`.
    temp4-suppliername = `Red Point Stores`.
    temp4-width = `19.3`.
    temp4-depth = `18`.
    temp4-height = `5`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.45`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `49`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Wireless DSL Router / Repeater`.
    temp4-productid = `HT-1116`.
    temp4-suppliername = `Red Point Stores`.
    temp4-width = `19.3`.
    temp4-depth = `18`.
    temp4-height = `5`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.45`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `59`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Wireless DSL Router / Repeater and Print Server`.
    temp4-productid = `HT-1117`.
    temp4-suppliername = `Technocom`.
    temp4-width = `19.3`.
    temp4-depth = `18`.
    temp4-height = `5`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.45`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `69`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `USB Stick`.
    temp4-productid = `HT-1118`.
    temp4-suppliername = `Technocom`.
    temp4-width = `1.5`.
    temp4-depth = `8.7`.
    temp4-height = `1.2`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.015`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `35`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Travel Adapter`.
    temp4-productid = `HT-1119`.
    temp4-suppliername = `Titanium`.
    temp4-width = `2`.
    temp4-depth = `3.1`.
    temp4-height = `3.9`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `88`.
    temp4-weightunit = `G`.
    temp4-weight_state = `Success`.
    temp4-price = `79`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cordless Bluetooth Keyboard, english international`.
    temp4-productid = `HT-1120`.
    temp4-suppliername = `Technocom`.
    temp4-width = `51.4`.
    temp4-depth = `23`.
    temp4-height = `4`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `1`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `29`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat XXL`.
    temp4-productid = `HT-1137`.
    temp4-suppliername = `Technocom`.
    temp4-width = `54`.
    temp4-depth = `22`.
    temp4-height = `38`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `18`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Error`.
    temp4-price = `1430`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Pocket Mouse`.
    temp4-productid = `HT-1138`.
    temp4-suppliername = `Technocom`.
    temp4-width = `0.3`.
    temp4-depth = `0.5`.
    temp4-height = `1`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.02`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `23`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `PC Power Station`.
    temp4-productid = `HT-1210`.
    temp4-suppliername = `Technocom`.
    temp4-width = `28`.
    temp4-depth = `31`.
    temp4-height = `43`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `2.3`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `2399`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Astro Laptop 1516`.
    temp4-productid = `HT-1251`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-width = `30`.
    temp4-depth = `18`.
    temp4-height = `3`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `4.2`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `989`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Astro Phone 6`.
    temp4-productid = `HT-1252`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-width = `8`.
    temp4-depth = `6`.
    temp4-height = `1.5`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.75`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `649`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Benda Laptop 1408`.
    temp4-productid = `HT-1253`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-width = `30`.
    temp4-depth = `18`.
    temp4-height = `3`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `4.2`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `976`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Bending Screen 21HD`.
    temp4-productid = `HT-1254`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-width = `37`.
    temp4-depth = `12`.
    temp4-height = `36`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `15`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Error`.
    temp4-price = `250`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Broad Screen 22HD`.
    temp4-productid = `HT-1255`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-width = `39`.
    temp4-depth = `12`.
    temp4-height = `38`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `16`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Error`.
    temp4-price = `270`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cerdik Phone 7`.
    temp4-productid = `HT-1256`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-width = `9`.
    temp4-depth = `15`.
    temp4-height = `1.5`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.75`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `549`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cepat Tablet 10.5`.
    temp4-productid = `HT-1257`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-width = `48`.
    temp4-depth = `31`.
    temp4-height = `4.5`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `2.8`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `549`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cepat Tablet 8`.
    temp4-productid = `HT-1258`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-width = `38`.
    temp4-depth = `21`.
    temp4-height = `3.5`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `2.5`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `529`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Server Basic`.
    temp4-productid = `HT-1500`.
    temp4-suppliername = `Technocom`.
    temp4-width = `34`.
    temp4-depth = `35`.
    temp4-height = `23`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `18`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Error`.
    temp4-price = `5000`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Server Professional`.
    temp4-productid = `HT-1501`.
    temp4-suppliername = `Technocom`.
    temp4-width = `29`.
    temp4-depth = `30`.
    temp4-height = `27`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `25`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Error`.
    temp4-price = `15000`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Server Power Pro`.
    temp4-productid = `HT-1502`.
    temp4-suppliername = `Technocom`.
    temp4-width = `22`.
    temp4-depth = `27.3`.
    temp4-height = `37`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `35`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Error`.
    temp4-price = `25000`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Family PC Basic`.
    temp4-productid = `HT-1600`.
    temp4-suppliername = `Titanium`.
    temp4-width = `21.4`.
    temp4-depth = `29`.
    temp4-height = `38`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `4.8`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `600`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Family PC Pro`.
    temp4-productid = `HT-1601`.
    temp4-suppliername = `Titanium`.
    temp4-width = `25`.
    temp4-depth = `31.7`.
    temp4-height = `40.2`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `5.3`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Error`.
    temp4-price = `900`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Gaming Monster`.
    temp4-productid = `HT-1602`.
    temp4-suppliername = `Titanium`.
    temp4-width = `26.5`.
    temp4-depth = `34`.
    temp4-height = `47`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `5.9`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Error`.
    temp4-price = `1200`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Gaming Monster Pro`.
    temp4-productid = `HT-1603`.
    temp4-suppliername = `Titanium`.
    temp4-width = `27`.
    temp4-depth = `28`.
    temp4-height = `42`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `6.8`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Error`.
    temp4-price = `1700`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `7" Widescreen Portable DVD Player w MP3`.
    temp4-productid = `HT-2000`.
    temp4-suppliername = `Titanium`.
    temp4-width = `21.4`.
    temp4-depth = `19`.
    temp4-height = `27.6`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.79`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `249.99`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `10" Portable DVD player`.
    temp4-productid = `HT-2001`.
    temp4-suppliername = `Titanium`.
    temp4-width = `24`.
    temp4-depth = `19.5`.
    temp4-height = `29`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.84`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `449.99`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Portable DVD Player with 9" LCD Monitor`.
    temp4-productid = `HT-2002`.
    temp4-suppliername = `Technocom`.
    temp4-width = `21`.
    temp4-depth = `16.5`.
    temp4-height = `14`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.72`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `853.99`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `CD/DVD case: 264 sleeves`.
    temp4-productid = `HT-2025`.
    temp4-suppliername = `Titanium`.
    temp4-width = `13`.
    temp4-depth = `13`.
    temp4-height = `20`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.65`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `44.99`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Audio/Video Cable Kit - 4m`.
    temp4-productid = `HT-2026`.
    temp4-suppliername = `Titanium`.
    temp4-width = `21`.
    temp4-depth = `10.2`.
    temp4-height = `13`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.2`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `29.99`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Removable CD/DVD Laser Labels`.
    temp4-productid = `HT-2027`.
    temp4-suppliername = `Titanium`.
    temp4-width = `5.5`.
    temp4-depth = `2`.
    temp4-height = `2`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.15`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `8.99`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Beam Breaker B-1`.
    temp4-productid = `HT-6100`.
    temp4-suppliername = `Titanium`.
    temp4-width = `30.4`.
    temp4-depth = `23.1`.
    temp4-height = `23`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `1.7`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `469`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Beam Breaker B-2`.
    temp4-productid = `HT-6101`.
    temp4-suppliername = `Technocom`.
    temp4-width = `30.4`.
    temp4-depth = `23.1`.
    temp4-height = `23`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `2`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `679`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Beam Breaker B-3`.
    temp4-productid = `HT-6102`.
    temp4-suppliername = `Technocom`.
    temp4-width = `30.4`.
    temp4-depth = `23.1`.
    temp4-height = `23`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `2.5`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `889`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Play Movie`.
    temp4-productid = `HT-6110`.
    temp4-suppliername = `Fasttech`.
    temp4-width = `37`.
    temp4-depth = `24`.
    temp4-height = `6`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `2.4`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `130`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Record Movie`.
    temp4-productid = `HT-6111`.
    temp4-suppliername = `Fasttech`.
    temp4-width = `38`.
    temp4-depth = `26`.
    temp4-height = `6.2`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `3.1`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `288`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelo MusicStick`.
    temp4-productid = `HT-6120`.
    temp4-suppliername = `Fasttech`.
    temp4-width = `1.5`.
    temp4-depth = `6`.
    temp4-height = `1`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `134`.
    temp4-weightunit = `G`.
    temp4-weight_state = `Success`.
    temp4-price = `45`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelo Jog-Mate`.
    temp4-productid = `HT-6121`.
    temp4-suppliername = `Fasttech`.
    temp4-width = `5.1`.
    temp4-depth = `8`.
    temp4-height = `9.2`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `134`.
    temp4-weightunit = `G`.
    temp4-weight_state = `Success`.
    temp4-price = `63`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Power Pro Player 40`.
    temp4-productid = `HT-6122`.
    temp4-suppliername = `Fasttech`.
    temp4-width = `5.1`.
    temp4-depth = `8`.
    temp4-height = `9.2`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `266`.
    temp4-weightunit = `G`.
    temp4-weight_state = `Success`.
    temp4-price = `167`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Power Pro Player 80`.
    temp4-productid = `HT-6123`.
    temp4-suppliername = `Fasttech`.
    temp4-width = `4`.
    temp4-depth = `6`.
    temp4-height = `0.8`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `267`.
    temp4-weightunit = `G`.
    temp4-weight_state = `Success`.
    temp4-price = `299`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Watch HD32`.
    temp4-productid = `HT-6130`.
    temp4-suppliername = `Very Best Screens`.
    temp4-width = `78`.
    temp4-depth = `22.1`.
    temp4-height = `55`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `2.6`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `1459`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Watch HD37`.
    temp4-productid = `HT-6131`.
    temp4-suppliername = `Very Best Screens`.
    temp4-width = `99.1`.
    temp4-depth = `26`.
    temp4-height = `61`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `2.2`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `1199`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Watch HD41`.
    temp4-productid = `HT-6132`.
    temp4-suppliername = `Very Best Screens`.
    temp4-width = `128`.
    temp4-depth = `23`.
    temp4-height = `79.1`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `1.8`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `899`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Copperberry`.
    temp4-productid = `HT-7000`.
    temp4-suppliername = `Fasttech`.
    temp4-width = `8.1`.
    temp4-depth = `13`.
    temp4-height = `12.1`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.5`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `549`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Silverberry`.
    temp4-productid = `HT-7010`.
    temp4-suppliername = `Fasttech`.
    temp4-width = `8.1`.
    temp4-depth = `13`.
    temp4-height = `12.1`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.5`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `549`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Goldberry`.
    temp4-productid = `HT-7020`.
    temp4-suppliername = `Fasttech`.
    temp4-width = `8.1`.
    temp4-depth = `13`.
    temp4-height = `12.1`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.5`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `549`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Platinberry`.
    temp4-productid = `HT-7030`.
    temp4-suppliername = `Fasttech`.
    temp4-width = `8.1`.
    temp4-depth = `13`.
    temp4-height = `12.1`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.5`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `549`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO FlexTop I4000`.
    temp4-productid = `HT-8000`.
    temp4-suppliername = `Titanium`.
    temp4-width = `31`.
    temp4-depth = `19`.
    temp4-height = `3.1`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `4`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `799`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO FlexTop I6300c`.
    temp4-productid = `HT-8001`.
    temp4-suppliername = `Titanium`.
    temp4-width = `32`.
    temp4-depth = `20`.
    temp4-height = `3.4`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `4.2`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `799`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO FlexTop I9100`.
    temp4-productid = `HT-8002`.
    temp4-suppliername = `Titanium`.
    temp4-width = `38`.
    temp4-depth = `21`.
    temp4-height = `4.1`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `3.5`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `1199`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO FlexTop I9800`.
    temp4-productid = `HT-8003`.
    temp4-suppliername = `Titanium`.
    temp4-width = `48`.
    temp4-depth = `31`.
    temp4-height = `4.5`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `3.8`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `1388`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smartphone Leather Case`.
    temp4-productid = `HT-9991`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-width = `48`.
    temp4-depth = `31`.
    temp4-height = `4.5`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.02`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `25`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smartphone Alpha`.
    temp4-productid = `HT-9992`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-width = `48`.
    temp4-depth = `31`.
    temp4-height = `4.5`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.75`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `599`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Mini Tablet`.
    temp4-productid = `HT-9993`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-width = `48`.
    temp4-depth = `31`.
    temp4-height = `4.5`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `3.8`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `833`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Camcorder View`.
    temp4-productid = `HT-9994`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-width = `48`.
    temp4-depth = `31`.
    temp4-height = `27`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `3.8`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `1388`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Tablet Pouch`.
    temp4-productid = `HT-9995`.
    temp4-suppliername = `Titanium`.
    temp4-width = `25`.
    temp4-depth = `40`.
    temp4-height = `4.5`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.03`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `20`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Tablet Pouch`.
    temp4-productid = `HT-9996`.
    temp4-suppliername = `Titanium`.
    temp4-width = `25`.
    temp4-depth = `40`.
    temp4-height = `4.5`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.03`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `20`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `e-Book Reader ReadMe`.
    temp4-productid = `HT-9997`.
    temp4-suppliername = `Titanium`.
    temp4-width = `48`.
    temp4-depth = `31`.
    temp4-height = `4.5`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `3.8`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `33`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smartphone Beta`.
    temp4-productid = `HT-9998`.
    temp4-suppliername = `Titanium`.
    temp4-width = `48`.
    temp4-depth = `31`.
    temp4-height = `4.5`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.75`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `30`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Maxi Tablet`.
    temp4-productid = `HT-9999`.
    temp4-suppliername = `Titanium`.
    temp4-width = `48`.
    temp4-depth = `31`.
    temp4-height = `4.5`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `3.8`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Warning`.
    temp4-price = `749`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flyer`.
    temp4-productid = `PF-1000`.
    temp4-suppliername = `Titanium`.
    temp4-width = `46`.
    temp4-depth = `30`.
    temp4-height = `3`.
    temp4-dimunit = `cm`.
    temp4-weightmeasure = `0.01`.
    temp4-weightunit = `KG`.
    temp4-weight_state = `Success`.
    temp4-price = `0`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    t_all = temp3.

    " the rows binding's sorter, applied to the data the backend sends
    SORT t_all BY name AS TEXT ASCENDING.
    t_products = t_all.

  ENDMETHOD.

ENDCLASS.
