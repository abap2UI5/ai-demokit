" @keywords table sap.m tableverticalalignment overflowtoolbar title column text columnlistitem objectidentifier input objectnumber
" @summary This is a good example of how to vertically align different elements within a Table's ColumnListItem row template.
CLASS z2ui5_cl_smpc_app_576 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             productid     TYPE string,
             name          TYPE string,
             quantity      TYPE i,
             uom           TYPE string,
             weightmeasure TYPE string,
             weightunit    TYPE string,
             " Formatter.weightState, computed in the backend (thin frontend)
             weight_state  TYPE string,
             price         TYPE p LENGTH 9 DECIMALS 2,
             currencycode  TYPE string,
           END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

    DATA t_products TYPE ty_t_product.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_576 IMPLEMENTATION.

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

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->ele( `Table`
            )->a( n = `id`    v = `idProductsTable`
            )->a( n = `mode`  v = `MultiSelect`
            )->a( n = `inset` v = `false`
            )->a( n = `items` v = |\{ path: '{ client->_bind_path( t_products ) }', sorter: \{ path: 'NAME' \} \}|

            )->ele( `headerToolbar`
                )->ele( `OverflowToolbar`
                    )->tag( `Title`
                        )->a( n = `text`  v = `Products`
                        )->a( n = `level` v = `H2`

                )->end(
            )->end(
            )->ele( `columns`
                )->ele( `Column`

                    )->tag( `Text`
                        )->a( n = `text` v = `Product`

                )->end(
                )->ele( `Column`
                    )->a( n = `hAlign`         v = `Center`
                    )->a( n = `width`          v = `12em`
                    )->a( n = `minScreenWidth` v = `Tablet`
                    )->a( n = `demandPopin`    v = `true`

                    )->tag( `Text`
                        )->a( n = `text` v = `Quantity`

                )->end(
                )->ele( `Column`
                    )->a( n = `minScreenWidth` v = `Tablet`
                    )->a( n = `demandPopin`    v = `true`
                    )->a( n = `hAlign`         v = `Center`

                    )->tag( `Text`
                        )->a( n = `text` v = `Weight`

                )->end(
                )->ele( `Column`
                    )->a( n = `hAlign` v = `End`

                    )->tag( `Text`
                        )->a( n = `text` v = `Unit Price`

                )->end(
            )->end(
            )->ele( `items`
                )->ele( `ColumnListItem`
                    )->a( n = `vAlign` v = `Middle`
                    )->a( n = `type`   v = `Navigation`

                    )->ele( `cells`
                        )->tag( `ObjectIdentifier`
                            )->a( n = `title` v = `{NAME}`
                            )->a( n = `text`  v = `{PRODUCTID}`
                        " the sample writes type="{Text}" and fieldWidth="{60%}", which are
                        " PATH bindings, not literals: neither path exists in its model, so
                        " both resolve to undefined and the Input keeps its defaults (Text,
                        " 50%). Carrying them over would be a binding to a field that is not
                        " there, so they are dropped - same rendering (see sidecar)
                        )->tag( `Input`
                            )->a( n = `value`       v = `{QUANTITY}`
                            )->a( n = `description` v = `{UOM}`
                        )->tag( `ObjectNumber`
                            )->a( n = `number` v = `{WEIGHTMEASURE}`
                            )->a( n = `unit`   v = `{WEIGHTUNIT}`
                            )->a( n = `state`  v = `{WEIGHT_STATE}`
                        )->tag( `ObjectNumber`
                            )->a( n = `number` v = |\{ parts:[\{path:'PRICE'\},\{path:'CURRENCYCODE'\}], type:'sap.ui.model.type.Currency', formatOptions:\{showMeasure:false\} \}|
                            )->a( n = `unit`   v = `{CURRENCYCODE}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " the full mock /ProductCollection, in the mock order - the items binding
    " keeps its own sorter on NAME
    DATA temp1 TYPE z2ui5_cl_smpc_app_576=>ty_t_product.
    DATA temp2 LIKE LINE OF temp1.
    CLEAR temp1.
    
    temp2-productid = `HT-1000`.
    temp2-name = `Notebook Basic 15`.
    temp2-quantity = `10`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `4.2`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `956`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1001`.
    temp2-name = `Notebook Basic 17`.
    temp2-quantity = `20`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `4.5`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `1249`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1002`.
    temp2-name = `Notebook Basic 18`.
    temp2-quantity = `10`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `4.2`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `1570`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1003`.
    temp2-name = `Notebook Basic 19`.
    temp2-quantity = `15`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `4.2`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `1650`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1007`.
    temp2-name = `ITelO Vault`.
    temp2-quantity = `15`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.2`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `299`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1010`.
    temp2-name = `Notebook Professional 15`.
    temp2-quantity = `16`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `4.3`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `1999`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1011`.
    temp2-name = `Notebook Professional 17`.
    temp2-quantity = `17`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `4.1`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `2299`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1020`.
    temp2-name = `ITelO Vault Net`.
    temp2-quantity = `14`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.16`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `459`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1021`.
    temp2-name = `ITelO Vault SAT`.
    temp2-quantity = `50`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.18`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `149`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1022`.
    temp2-name = `Comfort Easy`.
    temp2-quantity = `30`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.2`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `1679`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1023`.
    temp2-name = `Comfort Senior`.
    temp2-quantity = `24`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.8`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `512`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1030`.
    temp2-name = `Ergo Screen E-I`.
    temp2-quantity = `14`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `21`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `230`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1031`.
    temp2-name = `Ergo Screen E-II`.
    temp2-quantity = `24`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `21`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `285`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1032`.
    temp2-name = `Ergo Screen E-III`.
    temp2-quantity = `50`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `21`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `345`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1035`.
    temp2-name = `Flat Basic`.
    temp2-quantity = `23`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `14`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `399`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1036`.
    temp2-name = `Flat Future`.
    temp2-quantity = `22`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `15`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `430`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1037`.
    temp2-name = `Flat XL`.
    temp2-quantity = `23`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `17`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `1230`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1040`.
    temp2-name = `Laser Professional Eco`.
    temp2-quantity = `21`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `32`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `830`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1041`.
    temp2-name = `Laser Basic`.
    temp2-quantity = `8`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `23`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `490`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1042`.
    temp2-name = `Laser Allround`.
    temp2-quantity = `9`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `17`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `349`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1050`.
    temp2-name = `Ultra Jet Super Color`.
    temp2-quantity = `17`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `3`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `139`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1051`.
    temp2-name = `Ultra Jet Mobile`.
    temp2-quantity = `18`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `1.9`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `99`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1052`.
    temp2-name = `Ultra Jet Super Highspeed`.
    temp2-quantity = `25`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `18`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `170`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1055`.
    temp2-name = `Multi Print`.
    temp2-quantity = `16`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `6.3`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `99`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1056`.
    temp2-name = `Multi Color`.
    temp2-quantity = `5`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `4.3`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `119`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1060`.
    temp2-name = `Cordless Mouse`.
    temp2-quantity = `25`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.09`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `9`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1061`.
    temp2-name = `Speed Mouse`.
    temp2-quantity = `12`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.09`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `7`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1062`.
    temp2-name = `Track Mouse`.
    temp2-quantity = `12`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.03`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `11`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1063`.
    temp2-name = `Ergonomic Keyboard`.
    temp2-quantity = `50`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `2.1`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `14`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1064`.
    temp2-name = `Internet Keyboard`.
    temp2-quantity = `35`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `1.8`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `16`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1065`.
    temp2-name = `Media Keyboard`.
    temp2-quantity = `26`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `2.3`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `26`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1066`.
    temp2-name = `Mousepad`.
    temp2-quantity = `12`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `80`.
    temp2-weightunit = `G`.
    temp2-weight_state = `Success`.
    temp2-price = `6.99`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1067`.
    temp2-name = `Ergo Mousepad`.
    temp2-quantity = `16`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `80`.
    temp2-weightunit = `G`.
    temp2-weight_state = `Success`.
    temp2-price = `8.99`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1068`.
    temp2-name = `Designer Mousepad`.
    temp2-quantity = `26`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `90`.
    temp2-weightunit = `G`.
    temp2-weight_state = `Success`.
    temp2-price = `12.99`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1069`.
    temp2-name = `Universal card reader`.
    temp2-quantity = `22`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `45`.
    temp2-weightunit = `G`.
    temp2-weight_state = `Success`.
    temp2-price = `14`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1070`.
    temp2-name = `Proctra X`.
    temp2-quantity = `15`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.255`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `70.9`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1071`.
    temp2-name = `Gladiator MX`.
    temp2-quantity = `16`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.3`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `81.7`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1072`.
    temp2-name = `Hurricane GX`.
    temp2-quantity = `13`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.4`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `101.2`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1073`.
    temp2-name = `Hurricane GX/LN`.
    temp2-quantity = `5`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.4`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `139.99`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1080`.
    temp2-name = `Photo Scan`.
    temp2-quantity = `8`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `2.3`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `129`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1081`.
    temp2-name = `Power Scan`.
    temp2-quantity = `11`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `2.4`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `89`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1082`.
    temp2-name = `Jet Scan Professional`.
    temp2-quantity = `13`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `3.2`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `169`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1083`.
    temp2-name = `Jet Scan Professional`.
    temp2-quantity = `10`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `3.2`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `189`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1085`.
    temp2-name = `Copymaster`.
    temp2-quantity = `10`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `23.2`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `1499`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1090`.
    temp2-name = `Surround Sound`.
    temp2-quantity = `20`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `3`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `39`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1091`.
    temp2-name = `Blaster Extreme`.
    temp2-quantity = `15`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `1.4`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `26`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1092`.
    temp2-name = `Sound Booster`.
    temp2-quantity = `50`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `2.1`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `45`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1095`.
    temp2-name = `Lovely Sound 5.1 Wireless`.
    temp2-quantity = `12`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `80`.
    temp2-weightunit = `G`.
    temp2-weight_state = `Success`.
    temp2-price = `49`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1096`.
    temp2-name = `Lovely Sound 5.1`.
    temp2-quantity = `18`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `130`.
    temp2-weightunit = `G`.
    temp2-weight_state = `Success`.
    temp2-price = `39`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1097`.
    temp2-name = `Lovely Sound Stereo`.
    temp2-quantity = `21`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `60`.
    temp2-weightunit = `G`.
    temp2-weight_state = `Success`.
    temp2-price = `29`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1100`.
    temp2-name = `Smart Office`.
    temp2-quantity = `25`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `1.2`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `89.9`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1101`.
    temp2-name = `Smart Design`.
    temp2-quantity = `26`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.8`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `79.9`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1102`.
    temp2-name = `Smart Network`.
    temp2-quantity = `28`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.8`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `69`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1103`.
    temp2-name = `Smart Multimedia`.
    temp2-quantity = `9`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.8`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `77`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1104`.
    temp2-name = `Smart Games`.
    temp2-quantity = `13`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `1.1`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `55`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1105`.
    temp2-name = `Smart Internet Antivirus`.
    temp2-quantity = `17`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.7`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `29`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1106`.
    temp2-name = `Smart Firewall`.
    temp2-quantity = `19`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.9`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `34`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1107`.
    temp2-name = `Smart Money`.
    temp2-quantity = `18`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.5`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `29.9`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1110`.
    temp2-name = `PC Lock`.
    temp2-quantity = `14`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.03`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `8.9`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1111`.
    temp2-name = `Notebook Lock`.
    temp2-quantity = `20`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.02`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `6.9`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1112`.
    temp2-name = `Web cam reality`.
    temp2-quantity = `27`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.075`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `39`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1113`.
    temp2-name = `Screen clean`.
    temp2-quantity = `17`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.05`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `2.3`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1114`.
    temp2-name = `Fabric bag professional`.
    temp2-quantity = `14`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `1.8`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `31`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1115`.
    temp2-name = `Wireless DSL Router`.
    temp2-quantity = `16`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.45`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `49`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1116`.
    temp2-name = `Wireless DSL Router / Repeater`.
    temp2-quantity = `12`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.45`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `59`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1117`.
    temp2-name = `Wireless DSL Router / Repeater and Print Server`.
    temp2-quantity = `12`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.45`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `69`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1118`.
    temp2-name = `USB Stick`.
    temp2-quantity = `14`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.015`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `35`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1119`.
    temp2-name = `Travel Adapter`.
    temp2-quantity = `10`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `88`.
    temp2-weightunit = `G`.
    temp2-weight_state = `Success`.
    temp2-price = `79`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1120`.
    temp2-name = `Cordless Bluetooth Keyboard, english international`.
    temp2-quantity = `13`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `1`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `29`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1137`.
    temp2-name = `Flat XXL`.
    temp2-quantity = `10`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `18`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `1430`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1138`.
    temp2-name = `Pocket Mouse`.
    temp2-quantity = `20`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.02`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `23`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1210`.
    temp2-name = `PC Power Station`.
    temp2-quantity = `22`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `2.3`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `2399`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1251`.
    temp2-name = `Astro Laptop 1516`.
    temp2-quantity = `23`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `4.2`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `989`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1252`.
    temp2-name = `Astro Phone 6`.
    temp2-quantity = `28`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.75`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `649`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1253`.
    temp2-name = `Benda Laptop 1408`.
    temp2-quantity = `27`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `4.2`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `976`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1254`.
    temp2-name = `Bending Screen 21HD`.
    temp2-quantity = `23`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `15`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `250`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1255`.
    temp2-name = `Broad Screen 22HD`.
    temp2-quantity = `5`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `16`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `270`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1256`.
    temp2-name = `Cerdik Phone 7`.
    temp2-quantity = `19`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.75`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `549`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1257`.
    temp2-name = `Cepat Tablet 10.5`.
    temp2-quantity = `17`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `2.8`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `549`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1258`.
    temp2-name = `Cepat Tablet 8`.
    temp2-quantity = `24`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `2.5`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `529`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1500`.
    temp2-name = `Server Basic`.
    temp2-quantity = `24`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `18`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `5000`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1501`.
    temp2-name = `Server Professional`.
    temp2-quantity = `26`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `25`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `15000`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1502`.
    temp2-name = `Server Power Pro`.
    temp2-quantity = `34`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `35`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `25000`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1600`.
    temp2-name = `Family PC Basic`.
    temp2-quantity = `10`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `4.8`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `600`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1601`.
    temp2-name = `Family PC Pro`.
    temp2-quantity = `20`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `5.3`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `900`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1602`.
    temp2-name = `Gaming Monster`.
    temp2-quantity = `24`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `5.9`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `1200`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1603`.
    temp2-name = `Gaming Monster Pro`.
    temp2-quantity = `25`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `6.8`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `1700`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-2000`.
    temp2-name = `7" Widescreen Portable DVD Player w MP3`.
    temp2-quantity = `20`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.79`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `249.99`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-2001`.
    temp2-name = `10" Portable DVD player`.
    temp2-quantity = `21`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.84`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `449.99`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-2002`.
    temp2-name = `Portable DVD Player with 9" LCD Monitor`.
    temp2-quantity = `50`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.72`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `853.99`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-2025`.
    temp2-name = `CD/DVD case: 264 sleeves`.
    temp2-quantity = `26`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.65`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `44.99`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-2026`.
    temp2-name = `Audio/Video Cable Kit - 4m`.
    temp2-quantity = `16`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.2`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `29.99`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-2027`.
    temp2-name = `Removable CD/DVD Laser Labels`.
    temp2-quantity = `25`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.15`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `8.99`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6100`.
    temp2-name = `Beam Breaker B-1`.
    temp2-quantity = `32`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `1.7`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `469`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6101`.
    temp2-name = `Beam Breaker B-2`.
    temp2-quantity = `18`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `2`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `679`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6102`.
    temp2-name = `Beam Breaker B-3`.
    temp2-quantity = `16`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `2.5`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `889`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6110`.
    temp2-name = `Play Movie`.
    temp2-quantity = `15`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `2.4`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `130`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6111`.
    temp2-name = `Record Movie`.
    temp2-quantity = `24`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `3.1`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `288`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6120`.
    temp2-name = `ITelo MusicStick`.
    temp2-quantity = `15`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `134`.
    temp2-weightunit = `G`.
    temp2-weight_state = `Success`.
    temp2-price = `45`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6121`.
    temp2-name = `ITelo Jog-Mate`.
    temp2-quantity = `24`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `134`.
    temp2-weightunit = `G`.
    temp2-weight_state = `Success`.
    temp2-price = `63`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6122`.
    temp2-name = `Power Pro Player 40`.
    temp2-quantity = `23`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `266`.
    temp2-weightunit = `G`.
    temp2-weight_state = `Success`.
    temp2-price = `167`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6123`.
    temp2-name = `Power Pro Player 80`.
    temp2-quantity = `13`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `267`.
    temp2-weightunit = `G`.
    temp2-weight_state = `Success`.
    temp2-price = `299`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6130`.
    temp2-name = `Flat Watch HD32`.
    temp2-quantity = `16`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `2.6`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `1459`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6131`.
    temp2-name = `Flat Watch HD37`.
    temp2-quantity = `14`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `2.2`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `1199`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6132`.
    temp2-name = `Flat Watch HD41`.
    temp2-quantity = `13`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `1.8`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `899`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-7000`.
    temp2-name = `Copperberry`.
    temp2-quantity = `5`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.5`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `549`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-7010`.
    temp2-name = `Silverberry`.
    temp2-quantity = `9`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.5`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `549`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-7020`.
    temp2-name = `Goldberry`.
    temp2-quantity = `11`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.5`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `549`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-7030`.
    temp2-name = `Platinberry`.
    temp2-quantity = `12`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.5`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `549`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-8000`.
    temp2-name = `ITelO FlexTop I4000`.
    temp2-quantity = `11`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `4`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `799`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-8001`.
    temp2-name = `ITelO FlexTop I6300c`.
    temp2-quantity = `20`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `4.2`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `799`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-8002`.
    temp2-name = `ITelO FlexTop I9100`.
    temp2-quantity = `20`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `3.5`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `1199`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-8003`.
    temp2-name = `ITelO FlexTop I9800`.
    temp2-quantity = `22`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `3.8`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `1388`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-9991`.
    temp2-name = `Smartphone Leather Case`.
    temp2-quantity = `12`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.02`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `25`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-9992`.
    temp2-name = `Smartphone Alpha`.
    temp2-quantity = `13`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.75`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `599`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-9993`.
    temp2-name = `Mini Tablet`.
    temp2-quantity = `10`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `3.8`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `833`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-9994`.
    temp2-name = `Camcorder View`.
    temp2-quantity = `50`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `3.8`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `1388`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-9995`.
    temp2-name = `Tablet Pouch`.
    temp2-quantity = `34`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.03`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `20`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-9996`.
    temp2-name = `Tablet Pouch`.
    temp2-quantity = `34`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.03`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `20`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-9997`.
    temp2-name = `e-Book Reader ReadMe`.
    temp2-quantity = `23`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `3.8`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `33`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-9998`.
    temp2-name = `Smartphone Beta`.
    temp2-quantity = `21`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.75`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `30`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-9999`.
    temp2-name = `Maxi Tablet`.
    temp2-quantity = `20`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `3.8`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `749`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `PF-1000`.
    temp2-name = `Flyer`.
    temp2-quantity = `33`.
    temp2-uom = `PC`.
    temp2-weightmeasure = `0.01`.
    temp2-weightunit = `KG`.
    temp2-weight_state = `Success`.
    temp2-price = `0`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    t_products = temp1.

  ENDMETHOD.

ENDCLASS.
