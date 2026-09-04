" @keywords tableselectdialog table select dialog sap.m tableselectdialoggrowing verticallayout button customdata column text columnlistitem
" @summary Table Select Dialog can be created with property growing set to true or false.
CLASS z2ui5_cl_smpc_app_454 DEFINITION PUBLIC.

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

    DATA t_products TYPE ty_t_product.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popup_dialog_display IMPORTING growing TYPE abap_bool.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_454 IMPLEMENTATION.

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
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            " the growing flag rides on the button's CustomData in the original;
            " here the two buttons raise two events instead
            )->ele( `Button`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
                )->a( n = `text`  v = `Show Table Select Dialog (Growing: True)`
                )->a( n = `press` v = client->_event( `DIALOG_GROWING` )

                )->ele( `customData`
                    )->tag( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `growing`
                        )->a( n = `value` v = `true`

                )->end(
            )->end(

            )->tag( `Button`
                )->a( n = `class` v = `sapUiSmallMarginBottom`
                )->a( n = `text`  v = `Show Table Select Dialog (Growing: False)`
                )->a( n = `press` v = client->_event( `DIALOG_PLAIN` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA temp1 TYPE string_table.

    CASE client->get_event( ).

      WHEN `DIALOG_GROWING`.
        popup_dialog_display( abap_true ).

      WHEN `DIALOG_PLAIN`.
        popup_dialog_display( abap_false ).

      WHEN `SEARCH`.
        " handleSearch filters the dialog's items binding by Name - the same
        " declarative filter on the aggregation binding, the model untouched
        
        CLEAR temp1.
        INSERT `myDialog` INTO TABLE temp1.
        INSERT `items` INTO TABLE temp1.
        INSERT `filter` INTO TABLE temp1.
        INSERT `NAME` INTO TABLE temp1.
        INSERT `Contains` INTO TABLE temp1.
        INSERT client->get_event_arg( ) INTO TABLE temp1.
        client->follow_up_action( val   = client->cs_event-binding_call
                                  t_arg = temp1 ).

    ENDCASE.

  ENDMETHOD.


  METHOD popup_dialog_display.

    DATA popup TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp3 TYPE string.
    popup = z2ui5_cl_ui5_view_builder=>factory( ).

    
    IF growing = abap_true.
      temp3 = `SearchField`.
    ELSE.
      temp3 = `List`.
    ENDIF.
    popup->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->ele( `TableSelectDialog`
            )->a( n = `id`           v = `myDialog`
            )->a( n = `noDataText`   v = `No Products Found`
            )->a( n = `title`        v = `Select Product`
            )->a( n = `search`       v = client->_event( val = `SEARCH` arg = `${$parameters>/value}` )
            )->a( n = `multiSelect`  v = `true`
            " the two buttons differ only in these two properties
            )->a( n = `growing`      b = growing
            )->a( n = `initialFocus` v = temp3
            )->a( n = `items`        v = |\{ path : '{ client->_bind_path( t_products ) }', sorter : \{ path : 'NAME', descending : false \} \}|

            )->ele( `columns`
                )->ele( `Column`
                    )->a( n = `width` v = `12em`

                    )->ele( `header`
                        )->tag( `Text`
                            )->a( n = `text` v = `Product`

                    )->end(
                )->end(

                )->ele( `Column`
                    )->a( n = `minScreenWidth` v = `Tablet`
                    )->a( n = `demandPopin`    v = `true`

                    )->ele( `header`
                        )->tag( `Text`
                            )->a( n = `text` v = `Supplier`

                    )->end(
                )->end(

                )->ele( `Column`
                    )->a( n = `minScreenWidth` v = `Desktop`
                    )->a( n = `demandPopin`    v = `true`
                    )->a( n = `hAlign`         v = `End`

                    )->ele( `header`
                        )->tag( `Text`
                            )->a( n = `text` v = `Dimensions`

                    )->end(
                )->end(

                )->ele( `Column`
                    )->a( n = `minScreenWidth` v = `Desktop`
                    )->a( n = `demandPopin`    v = `true`
                    )->a( n = `hAlign`         v = `Center`

                    )->ele( `header`
                        )->tag( `Text`
                            )->a( n = `text` v = `Weight`

                    )->end(
                )->end(

                )->ele( `Column`
                    )->a( n = `hAlign` v = `End`

                    )->ele( `header`
                        )->tag( `Text`
                            )->a( n = `text` v = `Product`

                    )->end(
                )->end(
            )->end(

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
                    " Formatter.weightState is business logic - computed in model_init
                    )->tag( `ObjectNumber`
                        )->a( n = `number` v = `{WEIGHTMEASURE}`
                        )->a( n = `unit`   v = `{WEIGHTUNIT}`
                        )->a( n = `state`  v = `{WEIGHTSTATE}`
                    )->tag( `ObjectNumber`
                        )->a( n = `number` v = |\{ parts:[\{path:'PRICE'\},\{path:'CURRENCYCODE'\}], type: 'sap.ui.model.type.Currency', formatOptions: \{showMeasure: false\} \}|
                        )->a( n = `unit`   v = `{CURRENCYCODE}` ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " full mock /ProductCollection of ui5/mock/products.json (the bound fields);
    " weightstate is Formatter.weightState of THIS sample: <0 None, <1000 Success,
    " <2000 Warning, else Error - the raw measure, no unit conversion
    DATA temp4 TYPE z2ui5_cl_smpc_app_454=>ty_t_product.
    DATA temp5 LIKE LINE OF temp4.
    CLEAR temp4.
    
    temp5-name = `Notebook Basic 15`.
    temp5-productid = `HT-1000`.
    temp5-suppliername = `Very Best Screens`.
    temp5-width = `30`.
    temp5-depth = `18`.
    temp5-height = `3`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `4.2`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `956`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Notebook Basic 17`.
    temp5-productid = `HT-1001`.
    temp5-suppliername = `Very Best Screens`.
    temp5-width = `29`.
    temp5-depth = `17`.
    temp5-height = `3.1`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `4.5`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `1249`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Notebook Basic 18`.
    temp5-productid = `HT-1002`.
    temp5-suppliername = `Very Best Screens`.
    temp5-width = `28`.
    temp5-depth = `19`.
    temp5-height = `2.5`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `4.2`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `1570`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Notebook Basic 19`.
    temp5-productid = `HT-1003`.
    temp5-suppliername = `Smartcards`.
    temp5-width = `32`.
    temp5-depth = `21`.
    temp5-height = `4`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `4.2`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `1650`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `ITelO Vault`.
    temp5-productid = `HT-1007`.
    temp5-suppliername = `Technocom`.
    temp5-width = `32`.
    temp5-depth = `22`.
    temp5-height = `3`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.2`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `299`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Notebook Professional 15`.
    temp5-productid = `HT-1010`.
    temp5-suppliername = `Very Best Screens`.
    temp5-width = `33`.
    temp5-depth = `20`.
    temp5-height = `3`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `4.3`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `1999`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Notebook Professional 17`.
    temp5-productid = `HT-1011`.
    temp5-suppliername = `Very Best Screens`.
    temp5-width = `33`.
    temp5-depth = `23`.
    temp5-height = `2`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `4.1`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `2299`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `ITelO Vault Net`.
    temp5-productid = `HT-1020`.
    temp5-suppliername = `Technocom`.
    temp5-width = `10`.
    temp5-depth = `1.8`.
    temp5-height = `17`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.16`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `459`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `ITelO Vault SAT`.
    temp5-productid = `HT-1021`.
    temp5-suppliername = `Technocom`.
    temp5-width = `11`.
    temp5-depth = `1.7`.
    temp5-height = `18`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.18`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `149`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Comfort Easy`.
    temp5-productid = `HT-1022`.
    temp5-suppliername = `Technocom`.
    temp5-width = `84`.
    temp5-depth = `1.5`.
    temp5-height = `14`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.2`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `1679`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Comfort Senior`.
    temp5-productid = `HT-1023`.
    temp5-suppliername = `Technocom`.
    temp5-width = `80`.
    temp5-depth = `1.6`.
    temp5-height = `13`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.8`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `512`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Ergo Screen E-I`.
    temp5-productid = `HT-1030`.
    temp5-suppliername = `Very Best Screens`.
    temp5-width = `37`.
    temp5-depth = `12`.
    temp5-height = `36`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `21`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `230`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Ergo Screen E-II`.
    temp5-productid = `HT-1031`.
    temp5-suppliername = `Very Best Screens`.
    temp5-width = `40.8`.
    temp5-depth = `19`.
    temp5-height = `43`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `21`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `285`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Ergo Screen E-III`.
    temp5-productid = `HT-1032`.
    temp5-suppliername = `Very Best Screens`.
    temp5-width = `40.8`.
    temp5-depth = `19`.
    temp5-height = `43`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `21`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `345`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Flat Basic`.
    temp5-productid = `HT-1035`.
    temp5-suppliername = `Very Best Screens`.
    temp5-width = `39`.
    temp5-depth = `20`.
    temp5-height = `41`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `14`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `399`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Flat Future`.
    temp5-productid = `HT-1036`.
    temp5-suppliername = `Very Best Screens`.
    temp5-width = `45`.
    temp5-depth = `26`.
    temp5-height = `46`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `15`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `430`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Flat XL`.
    temp5-productid = `HT-1037`.
    temp5-suppliername = `Very Best Screens`.
    temp5-width = `54.5`.
    temp5-depth = `22.1`.
    temp5-height = `39.1`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `17`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `1230`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Laser Professional Eco`.
    temp5-productid = `HT-1040`.
    temp5-suppliername = `Alpha Printers`.
    temp5-width = `51`.
    temp5-depth = `46`.
    temp5-height = `30`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `32`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `830`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Laser Basic`.
    temp5-productid = `HT-1041`.
    temp5-suppliername = `Alpha Printers`.
    temp5-width = `48`.
    temp5-depth = `42`.
    temp5-height = `26`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `23`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `490`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Laser Allround`.
    temp5-productid = `HT-1042`.
    temp5-suppliername = `Alpha Printers`.
    temp5-width = `53`.
    temp5-depth = `50`.
    temp5-height = `65`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `17`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `349`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Ultra Jet Super Color`.
    temp5-productid = `HT-1050`.
    temp5-suppliername = `Alpha Printers`.
    temp5-width = `41`.
    temp5-depth = `41`.
    temp5-height = `28`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `3`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `139`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Ultra Jet Mobile`.
    temp5-productid = `HT-1051`.
    temp5-suppliername = `Printer for All`.
    temp5-width = `46`.
    temp5-depth = `32`.
    temp5-height = `25`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `1.9`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `99`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Ultra Jet Super Highspeed`.
    temp5-productid = `HT-1052`.
    temp5-suppliername = `Printer for All`.
    temp5-width = `41`.
    temp5-depth = `41`.
    temp5-height = `28`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `18`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `170`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Multi Print`.
    temp5-productid = `HT-1055`.
    temp5-suppliername = `Printer for All`.
    temp5-width = `55`.
    temp5-depth = `45`.
    temp5-height = `29`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `6.3`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `99`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Multi Color`.
    temp5-productid = `HT-1056`.
    temp5-suppliername = `Printer for All`.
    temp5-width = `51`.
    temp5-depth = `41.3`.
    temp5-height = `22`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `4.3`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `119`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Cordless Mouse`.
    temp5-productid = `HT-1060`.
    temp5-suppliername = `Oxynum`.
    temp5-width = `6`.
    temp5-depth = `14.5`.
    temp5-height = `3.5`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.09`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `9`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Speed Mouse`.
    temp5-productid = `HT-1061`.
    temp5-suppliername = `Oxynum`.
    temp5-width = `7`.
    temp5-depth = `15`.
    temp5-height = `3.1`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.09`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `7`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Track Mouse`.
    temp5-productid = `HT-1062`.
    temp5-suppliername = `Oxynum`.
    temp5-width = `3`.
    temp5-depth = `7`.
    temp5-height = `4`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.03`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `11`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Ergonomic Keyboard`.
    temp5-productid = `HT-1063`.
    temp5-suppliername = `Oxynum`.
    temp5-width = `50`.
    temp5-depth = `21`.
    temp5-height = `3.5`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `2.1`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `14`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Internet Keyboard`.
    temp5-productid = `HT-1064`.
    temp5-suppliername = `Oxynum`.
    temp5-width = `52`.
    temp5-depth = `25`.
    temp5-height = `3`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `1.8`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `16`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Media Keyboard`.
    temp5-productid = `HT-1065`.
    temp5-suppliername = `Oxynum`.
    temp5-width = `51.4`.
    temp5-depth = `23`.
    temp5-height = `4`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `2.3`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `26`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Mousepad`.
    temp5-productid = `HT-1066`.
    temp5-suppliername = `Oxynum`.
    temp5-width = `15`.
    temp5-depth = `6`.
    temp5-height = `0.2`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `80`.
    temp5-weightunit = `G`.
    temp5-weightstate = `Success`.
    temp5-price = `6.99`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Ergo Mousepad`.
    temp5-productid = `HT-1067`.
    temp5-suppliername = `Oxynum`.
    temp5-width = `15`.
    temp5-depth = `6`.
    temp5-height = `0.2`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `80`.
    temp5-weightunit = `G`.
    temp5-weightstate = `Success`.
    temp5-price = `8.99`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Designer Mousepad`.
    temp5-productid = `HT-1068`.
    temp5-suppliername = `Fasttech`.
    temp5-width = `24`.
    temp5-depth = `24`.
    temp5-height = `0.6`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `90`.
    temp5-weightunit = `G`.
    temp5-weightstate = `Success`.
    temp5-price = `12.99`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Universal card reader`.
    temp5-productid = `HT-1069`.
    temp5-suppliername = `Fasttech`.
    temp5-width = `6`.
    temp5-depth = `6`.
    temp5-height = `3`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `45`.
    temp5-weightunit = `G`.
    temp5-weightstate = `Success`.
    temp5-price = `14`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Proctra X`.
    temp5-productid = `HT-1070`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-width = `22`.
    temp5-depth = `35`.
    temp5-height = `17`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.255`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `70.9`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Gladiator MX`.
    temp5-productid = `HT-1071`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-width = `22`.
    temp5-depth = `35`.
    temp5-height = `17`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.3`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `81.7`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Hurricane GX`.
    temp5-productid = `HT-1072`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-width = `22`.
    temp5-depth = `35`.
    temp5-height = `17`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.4`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `101.2`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Hurricane GX/LN`.
    temp5-productid = `HT-1073`.
    temp5-suppliername = `Smartcards`.
    temp5-width = `22`.
    temp5-depth = `35`.
    temp5-height = `17`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.4`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `139.99`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Photo Scan`.
    temp5-productid = `HT-1080`.
    temp5-suppliername = `Printer for All`.
    temp5-width = `34`.
    temp5-depth = `48`.
    temp5-height = `5`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `2.3`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `129`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Power Scan`.
    temp5-productid = `HT-1081`.
    temp5-suppliername = `Printer for All`.
    temp5-width = `31`.
    temp5-depth = `43`.
    temp5-height = `7`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `2.4`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `89`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Jet Scan Professional`.
    temp5-productid = `HT-1082`.
    temp5-suppliername = `Printer for All`.
    temp5-width = `33`.
    temp5-depth = `41`.
    temp5-height = `12`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `3.2`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `169`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Jet Scan Professional`.
    temp5-productid = `HT-1083`.
    temp5-suppliername = `Printer for All`.
    temp5-width = `35`.
    temp5-depth = `40`.
    temp5-height = `10`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `3.2`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `189`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Copymaster`.
    temp5-productid = `HT-1085`.
    temp5-suppliername = `Alpha Printers`.
    temp5-width = `45`.
    temp5-depth = `42`.
    temp5-height = `22`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `23.2`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `1499`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Surround Sound`.
    temp5-productid = `HT-1090`.
    temp5-suppliername = `Speaker Experts`.
    temp5-width = `12`.
    temp5-depth = `10`.
    temp5-height = `16`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `3`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `39`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Blaster Extreme`.
    temp5-productid = `HT-1091`.
    temp5-suppliername = `Speaker Experts`.
    temp5-width = `13`.
    temp5-depth = `11`.
    temp5-height = `17.5`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `1.4`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `26`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Sound Booster`.
    temp5-productid = `HT-1092`.
    temp5-suppliername = `Speaker Experts`.
    temp5-width = `12.4`.
    temp5-depth = `10.4`.
    temp5-height = `18.1`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `2.1`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `45`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Lovely Sound 5.1 Wireless`.
    temp5-productid = `HT-1095`.
    temp5-suppliername = `Fasttech`.
    temp5-width = `24`.
    temp5-depth = `19`.
    temp5-height = `23`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `80`.
    temp5-weightunit = `G`.
    temp5-weightstate = `Success`.
    temp5-price = `49`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Lovely Sound 5.1`.
    temp5-productid = `HT-1096`.
    temp5-suppliername = `Fasttech`.
    temp5-width = `25`.
    temp5-depth = `17`.
    temp5-height = `19`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `130`.
    temp5-weightunit = `G`.
    temp5-weightstate = `Success`.
    temp5-price = `39`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Lovely Sound Stereo`.
    temp5-productid = `HT-1097`.
    temp5-suppliername = `Fasttech`.
    temp5-width = `21.3`.
    temp5-depth = `2.4`.
    temp5-height = `19.7`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `60`.
    temp5-weightunit = `G`.
    temp5-weightstate = `Success`.
    temp5-price = `29`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Smart Office`.
    temp5-productid = `HT-1100`.
    temp5-suppliername = `Technocom`.
    temp5-width = `15`.
    temp5-depth = `6.5`.
    temp5-height = `2.1`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `1.2`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `89.9`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Smart Design`.
    temp5-productid = `HT-1101`.
    temp5-suppliername = `Technocom`.
    temp5-width = `14`.
    temp5-depth = `6.7`.
    temp5-height = `24`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.8`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `79.9`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Smart Network`.
    temp5-productid = `HT-1102`.
    temp5-suppliername = `Technocom`.
    temp5-width = `16`.
    temp5-depth = `6`.
    temp5-height = `27`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.8`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `69`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Smart Multimedia`.
    temp5-productid = `HT-1103`.
    temp5-suppliername = `Technocom`.
    temp5-width = `11`.
    temp5-depth = `3.4`.
    temp5-height = `22`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.8`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `77`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Smart Games`.
    temp5-productid = `HT-1104`.
    temp5-suppliername = `Technocom`.
    temp5-width = `10`.
    temp5-depth = `3`.
    temp5-height = `30`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `1.1`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `55`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Smart Internet Antivirus`.
    temp5-productid = `HT-1105`.
    temp5-suppliername = `Brainsoft`.
    temp5-width = `16`.
    temp5-depth = `4`.
    temp5-height = `21`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.7`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `29`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Smart Firewall`.
    temp5-productid = `HT-1106`.
    temp5-suppliername = `Brainsoft`.
    temp5-width = `17.9`.
    temp5-depth = `4.2`.
    temp5-height = `23.1`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.9`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `34`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Smart Money`.
    temp5-productid = `HT-1107`.
    temp5-suppliername = `Brainsoft`.
    temp5-width = `12`.
    temp5-depth = `1.5`.
    temp5-height = `19`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.5`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `29.9`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `PC Lock`.
    temp5-productid = `HT-1110`.
    temp5-suppliername = `Red Point Stores`.
    temp5-width = `20`.
    temp5-depth = `8`.
    temp5-height = `4.3`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.03`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `8.9`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Notebook Lock`.
    temp5-productid = `HT-1111`.
    temp5-suppliername = `Red Point Stores`.
    temp5-width = `31`.
    temp5-depth = `9`.
    temp5-height = `7`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.02`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `6.9`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Web cam reality`.
    temp5-productid = `HT-1112`.
    temp5-suppliername = `Red Point Stores`.
    temp5-width = `9`.
    temp5-depth = `8.2`.
    temp5-height = `1.3`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.075`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `39`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Screen clean`.
    temp5-productid = `HT-1113`.
    temp5-suppliername = `Red Point Stores`.
    temp5-width = `2`.
    temp5-depth = `2`.
    temp5-height = `0.1`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.05`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `2.3`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Fabric bag professional`.
    temp5-productid = `HT-1114`.
    temp5-suppliername = `Red Point Stores`.
    temp5-width = `42`.
    temp5-depth = `32`.
    temp5-height = `7`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `1.8`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `31`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Wireless DSL Router`.
    temp5-productid = `HT-1115`.
    temp5-suppliername = `Red Point Stores`.
    temp5-width = `19.3`.
    temp5-depth = `18`.
    temp5-height = `5`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.45`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `49`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Wireless DSL Router / Repeater`.
    temp5-productid = `HT-1116`.
    temp5-suppliername = `Red Point Stores`.
    temp5-width = `19.3`.
    temp5-depth = `18`.
    temp5-height = `5`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.45`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `59`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Wireless DSL Router / Repeater and Print Server`.
    temp5-productid = `HT-1117`.
    temp5-suppliername = `Technocom`.
    temp5-width = `19.3`.
    temp5-depth = `18`.
    temp5-height = `5`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.45`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `69`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `USB Stick`.
    temp5-productid = `HT-1118`.
    temp5-suppliername = `Technocom`.
    temp5-width = `1.5`.
    temp5-depth = `8.7`.
    temp5-height = `1.2`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.015`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `35`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Travel Adapter`.
    temp5-productid = `HT-1119`.
    temp5-suppliername = `Titanium`.
    temp5-width = `2`.
    temp5-depth = `3.1`.
    temp5-height = `3.9`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `88`.
    temp5-weightunit = `G`.
    temp5-weightstate = `Success`.
    temp5-price = `79`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Cordless Bluetooth Keyboard, english international`.
    temp5-productid = `HT-1120`.
    temp5-suppliername = `Technocom`.
    temp5-width = `51.4`.
    temp5-depth = `23`.
    temp5-height = `4`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `1`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `29`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Flat XXL`.
    temp5-productid = `HT-1137`.
    temp5-suppliername = `Technocom`.
    temp5-width = `54`.
    temp5-depth = `22`.
    temp5-height = `38`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `18`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `1430`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Pocket Mouse`.
    temp5-productid = `HT-1138`.
    temp5-suppliername = `Technocom`.
    temp5-width = `0.3`.
    temp5-depth = `0.5`.
    temp5-height = `1`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.02`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `23`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `PC Power Station`.
    temp5-productid = `HT-1210`.
    temp5-suppliername = `Technocom`.
    temp5-width = `28`.
    temp5-depth = `31`.
    temp5-height = `43`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `2.3`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `2399`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Astro Laptop 1516`.
    temp5-productid = `HT-1251`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-width = `30`.
    temp5-depth = `18`.
    temp5-height = `3`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `4.2`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `989`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Astro Phone 6`.
    temp5-productid = `HT-1252`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-width = `8`.
    temp5-depth = `6`.
    temp5-height = `1.5`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.75`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `649`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Benda Laptop 1408`.
    temp5-productid = `HT-1253`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-width = `30`.
    temp5-depth = `18`.
    temp5-height = `3`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `4.2`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `976`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Bending Screen 21HD`.
    temp5-productid = `HT-1254`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-width = `37`.
    temp5-depth = `12`.
    temp5-height = `36`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `15`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `250`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Broad Screen 22HD`.
    temp5-productid = `HT-1255`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-width = `39`.
    temp5-depth = `12`.
    temp5-height = `38`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `16`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `270`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Cerdik Phone 7`.
    temp5-productid = `HT-1256`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-width = `9`.
    temp5-depth = `15`.
    temp5-height = `1.5`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.75`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `549`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Cepat Tablet 10.5`.
    temp5-productid = `HT-1257`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-width = `48`.
    temp5-depth = `31`.
    temp5-height = `4.5`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `2.8`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `549`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Cepat Tablet 8`.
    temp5-productid = `HT-1258`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-width = `38`.
    temp5-depth = `21`.
    temp5-height = `3.5`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `2.5`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `529`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Server Basic`.
    temp5-productid = `HT-1500`.
    temp5-suppliername = `Technocom`.
    temp5-width = `34`.
    temp5-depth = `35`.
    temp5-height = `23`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `18`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `5000`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Server Professional`.
    temp5-productid = `HT-1501`.
    temp5-suppliername = `Technocom`.
    temp5-width = `29`.
    temp5-depth = `30`.
    temp5-height = `27`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `25`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `15000`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Server Power Pro`.
    temp5-productid = `HT-1502`.
    temp5-suppliername = `Technocom`.
    temp5-width = `22`.
    temp5-depth = `27.3`.
    temp5-height = `37`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `35`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `25000`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Family PC Basic`.
    temp5-productid = `HT-1600`.
    temp5-suppliername = `Titanium`.
    temp5-width = `21.4`.
    temp5-depth = `29`.
    temp5-height = `38`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `4.8`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `600`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Family PC Pro`.
    temp5-productid = `HT-1601`.
    temp5-suppliername = `Titanium`.
    temp5-width = `25`.
    temp5-depth = `31.7`.
    temp5-height = `40.2`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `5.3`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `900`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Gaming Monster`.
    temp5-productid = `HT-1602`.
    temp5-suppliername = `Titanium`.
    temp5-width = `26.5`.
    temp5-depth = `34`.
    temp5-height = `47`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `5.9`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `1200`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Gaming Monster Pro`.
    temp5-productid = `HT-1603`.
    temp5-suppliername = `Titanium`.
    temp5-width = `27`.
    temp5-depth = `28`.
    temp5-height = `42`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `6.8`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `1700`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `7" Widescreen Portable DVD Player w MP3`.
    temp5-productid = `HT-2000`.
    temp5-suppliername = `Titanium`.
    temp5-width = `21.4`.
    temp5-depth = `19`.
    temp5-height = `27.6`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.79`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `249.99`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `10" Portable DVD player`.
    temp5-productid = `HT-2001`.
    temp5-suppliername = `Titanium`.
    temp5-width = `24`.
    temp5-depth = `19.5`.
    temp5-height = `29`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.84`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `449.99`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Portable DVD Player with 9" LCD Monitor`.
    temp5-productid = `HT-2002`.
    temp5-suppliername = `Technocom`.
    temp5-width = `21`.
    temp5-depth = `16.5`.
    temp5-height = `14`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.72`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `853.99`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `CD/DVD case: 264 sleeves`.
    temp5-productid = `HT-2025`.
    temp5-suppliername = `Titanium`.
    temp5-width = `13`.
    temp5-depth = `13`.
    temp5-height = `20`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.65`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `44.99`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Audio/Video Cable Kit - 4m`.
    temp5-productid = `HT-2026`.
    temp5-suppliername = `Titanium`.
    temp5-width = `21`.
    temp5-depth = `10.2`.
    temp5-height = `13`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.2`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `29.99`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Removable CD/DVD Laser Labels`.
    temp5-productid = `HT-2027`.
    temp5-suppliername = `Titanium`.
    temp5-width = `5.5`.
    temp5-depth = `2`.
    temp5-height = `2`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.15`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `8.99`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Beam Breaker B-1`.
    temp5-productid = `HT-6100`.
    temp5-suppliername = `Titanium`.
    temp5-width = `30.4`.
    temp5-depth = `23.1`.
    temp5-height = `23`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `1.7`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `469`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Beam Breaker B-2`.
    temp5-productid = `HT-6101`.
    temp5-suppliername = `Technocom`.
    temp5-width = `30.4`.
    temp5-depth = `23.1`.
    temp5-height = `23`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `2`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `679`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Beam Breaker B-3`.
    temp5-productid = `HT-6102`.
    temp5-suppliername = `Technocom`.
    temp5-width = `30.4`.
    temp5-depth = `23.1`.
    temp5-height = `23`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `2.5`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `889`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Play Movie`.
    temp5-productid = `HT-6110`.
    temp5-suppliername = `Fasttech`.
    temp5-width = `37`.
    temp5-depth = `24`.
    temp5-height = `6`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `2.4`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `130`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Record Movie`.
    temp5-productid = `HT-6111`.
    temp5-suppliername = `Fasttech`.
    temp5-width = `38`.
    temp5-depth = `26`.
    temp5-height = `6.2`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `3.1`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `288`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `ITelo MusicStick`.
    temp5-productid = `HT-6120`.
    temp5-suppliername = `Fasttech`.
    temp5-width = `1.5`.
    temp5-depth = `6`.
    temp5-height = `1`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `134`.
    temp5-weightunit = `G`.
    temp5-weightstate = `Success`.
    temp5-price = `45`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `ITelo Jog-Mate`.
    temp5-productid = `HT-6121`.
    temp5-suppliername = `Fasttech`.
    temp5-width = `5.1`.
    temp5-depth = `8`.
    temp5-height = `9.2`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `134`.
    temp5-weightunit = `G`.
    temp5-weightstate = `Success`.
    temp5-price = `63`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Power Pro Player 40`.
    temp5-productid = `HT-6122`.
    temp5-suppliername = `Fasttech`.
    temp5-width = `5.1`.
    temp5-depth = `8`.
    temp5-height = `9.2`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `266`.
    temp5-weightunit = `G`.
    temp5-weightstate = `Success`.
    temp5-price = `167`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Power Pro Player 80`.
    temp5-productid = `HT-6123`.
    temp5-suppliername = `Fasttech`.
    temp5-width = `4`.
    temp5-depth = `6`.
    temp5-height = `0.8`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `267`.
    temp5-weightunit = `G`.
    temp5-weightstate = `Success`.
    temp5-price = `299`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Flat Watch HD32`.
    temp5-productid = `HT-6130`.
    temp5-suppliername = `Very Best Screens`.
    temp5-width = `78`.
    temp5-depth = `22.1`.
    temp5-height = `55`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `2.6`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `1459`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Flat Watch HD37`.
    temp5-productid = `HT-6131`.
    temp5-suppliername = `Very Best Screens`.
    temp5-width = `99.1`.
    temp5-depth = `26`.
    temp5-height = `61`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `2.2`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `1199`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Flat Watch HD41`.
    temp5-productid = `HT-6132`.
    temp5-suppliername = `Very Best Screens`.
    temp5-width = `128`.
    temp5-depth = `23`.
    temp5-height = `79.1`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `1.8`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `899`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Copperberry`.
    temp5-productid = `HT-7000`.
    temp5-suppliername = `Fasttech`.
    temp5-width = `8.1`.
    temp5-depth = `13`.
    temp5-height = `12.1`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.5`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `549`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Silverberry`.
    temp5-productid = `HT-7010`.
    temp5-suppliername = `Fasttech`.
    temp5-width = `8.1`.
    temp5-depth = `13`.
    temp5-height = `12.1`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.5`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `549`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Goldberry`.
    temp5-productid = `HT-7020`.
    temp5-suppliername = `Fasttech`.
    temp5-width = `8.1`.
    temp5-depth = `13`.
    temp5-height = `12.1`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.5`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `549`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Platinberry`.
    temp5-productid = `HT-7030`.
    temp5-suppliername = `Fasttech`.
    temp5-width = `8.1`.
    temp5-depth = `13`.
    temp5-height = `12.1`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.5`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `549`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `ITelO FlexTop I4000`.
    temp5-productid = `HT-8000`.
    temp5-suppliername = `Titanium`.
    temp5-width = `31`.
    temp5-depth = `19`.
    temp5-height = `3.1`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `4`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `799`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `ITelO FlexTop I6300c`.
    temp5-productid = `HT-8001`.
    temp5-suppliername = `Titanium`.
    temp5-width = `32`.
    temp5-depth = `20`.
    temp5-height = `3.4`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `4.2`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `799`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `ITelO FlexTop I9100`.
    temp5-productid = `HT-8002`.
    temp5-suppliername = `Titanium`.
    temp5-width = `38`.
    temp5-depth = `21`.
    temp5-height = `4.1`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `3.5`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `1199`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `ITelO FlexTop I9800`.
    temp5-productid = `HT-8003`.
    temp5-suppliername = `Titanium`.
    temp5-width = `48`.
    temp5-depth = `31`.
    temp5-height = `4.5`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `3.8`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `1388`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Smartphone Leather Case`.
    temp5-productid = `HT-9991`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-width = `48`.
    temp5-depth = `31`.
    temp5-height = `4.5`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.02`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `25`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Smartphone Alpha`.
    temp5-productid = `HT-9992`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-width = `48`.
    temp5-depth = `31`.
    temp5-height = `4.5`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.75`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `599`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Mini Tablet`.
    temp5-productid = `HT-9993`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-width = `48`.
    temp5-depth = `31`.
    temp5-height = `4.5`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `3.8`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `833`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Camcorder View`.
    temp5-productid = `HT-9994`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-width = `48`.
    temp5-depth = `31`.
    temp5-height = `27`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `3.8`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `1388`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Tablet Pouch`.
    temp5-productid = `HT-9995`.
    temp5-suppliername = `Titanium`.
    temp5-width = `25`.
    temp5-depth = `40`.
    temp5-height = `4.5`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.03`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `20`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Tablet Pouch`.
    temp5-productid = `HT-9996`.
    temp5-suppliername = `Titanium`.
    temp5-width = `25`.
    temp5-depth = `40`.
    temp5-height = `4.5`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.03`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `20`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `e-Book Reader ReadMe`.
    temp5-productid = `HT-9997`.
    temp5-suppliername = `Titanium`.
    temp5-width = `48`.
    temp5-depth = `31`.
    temp5-height = `4.5`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `3.8`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `33`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Smartphone Beta`.
    temp5-productid = `HT-9998`.
    temp5-suppliername = `Titanium`.
    temp5-width = `48`.
    temp5-depth = `31`.
    temp5-height = `4.5`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.75`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `30`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Maxi Tablet`.
    temp5-productid = `HT-9999`.
    temp5-suppliername = `Titanium`.
    temp5-width = `48`.
    temp5-depth = `31`.
    temp5-height = `4.5`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `3.8`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `749`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Flyer`.
    temp5-productid = `PF-1000`.
    temp5-suppliername = `Titanium`.
    temp5-width = `46`.
    temp5-depth = `30`.
    temp5-height = `3`.
    temp5-dimunit = `cm`.
    temp5-weightmeasure = `0.01`.
    temp5-weightunit = `KG`.
    temp5-weightstate = `Success`.
    temp5-price = `0`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    t_products = temp4.

  ENDMETHOD.

ENDCLASS.
