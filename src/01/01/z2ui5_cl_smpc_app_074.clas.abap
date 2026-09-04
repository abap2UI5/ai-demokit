" @keywords objectlistitem object list item sap.m status attributes currency objectstatus objectattribute
" @summary The Object List Item has many possibilities to provide a quick overview for an object within a list.
CLASS z2ui5_cl_smpc_app_074 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name           TYPE string,
        price          TYPE p LENGTH 8 DECIMALS 2,
        currency_code  TYPE string,
        status         TYPE string,
        status_state   TYPE string,
        weight_measure TYPE string,
        weight_unit    TYPE string,
        width          TYPE string,
        depth          TYPE string,
        height         TYPE string,
        dim_unit       TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_074 IMPLEMENTATION.

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
    DATA temp1 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `MESSAGE_TOAST` INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    INSERT `Pressed : {0}` INTO TABLE temp1.
    INSERT `${NAME}` INTO TABLE temp1.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( `List`
            )->a( n = `items`      v = client->_bind( t_products )
            )->a( n = `headerText` v = `Products`

            )->ele( `ObjectListItem`
                )->a( n = `title`      v = `{NAME}`
                )->a( n = `type`       v = `Active`
                " client-composed toast, roundtrip-free - e2e-covered (see the sidecar)
                )->a( n = `press`      v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp1 )
                )->a( n = `number`     v = |\{ parts:[\{path:'PRICE'\},\{path:'CURRENCY_CODE'\}], type: 'sap.ui.model.type.Currency', formatOptions: \{showMeasure: false\} \}|
                )->a( n = `numberUnit` v = `{CURRENCY_CODE}`

                )->ele( `firstStatus`
                    )->tag( `ObjectStatus`
                        )->a( n = `text`  v = `{STATUS}`
                        " the original's '.formatter.status' (Status -> ValueState) is precomputed into STATUS_STATE
                        )->a( n = `state` v = `{STATUS_STATE}`

                )->end(
                )->tag( `ObjectAttribute`
                    )->a( n = `text` v = `{WEIGHT_MEASURE} {WEIGHT_UNIT}`
                )->tag( `ObjectAttribute`
                    )->a( n = `text` v = `{WIDTH} x {DEPTH} x {HEIGHT} {DIM_UNIT}`

            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " full mock /ProductCollection (sap/ui/demo/mock/products.json); STATUS_STATE precomputes the sample's '.formatter.status'
    DATA temp3 LIKE t_products.
    DATA temp4 LIKE LINE OF temp3.
    CLEAR temp3.
    
    temp4-name = `Notebook Basic 15`.
    temp4-price = '956.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `4.2`.
    temp4-weight_unit = `KG`.
    temp4-width = `30`.
    temp4-depth = `18`.
    temp4-height = `3`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Basic 17`.
    temp4-price = '1249.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `4.5`.
    temp4-weight_unit = `KG`.
    temp4-width = `29`.
    temp4-depth = `17`.
    temp4-height = `3.1`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Basic 18`.
    temp4-price = '1570.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `4.2`.
    temp4-weight_unit = `KG`.
    temp4-width = `28`.
    temp4-depth = `19`.
    temp4-height = `2.5`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Basic 19`.
    temp4-price = '1650.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Out of Stock`.
    temp4-status_state = `Warning`.
    temp4-weight_measure = `4.2`.
    temp4-weight_unit = `KG`.
    temp4-width = `32`.
    temp4-depth = `21`.
    temp4-height = `4`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO Vault`.
    temp4-price = '299.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Out of Stock`.
    temp4-status_state = `Warning`.
    temp4-weight_measure = `0.2`.
    temp4-weight_unit = `KG`.
    temp4-width = `32`.
    temp4-depth = `22`.
    temp4-height = `3`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Professional 15`.
    temp4-price = '1999.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Out of Stock`.
    temp4-status_state = `Warning`.
    temp4-weight_measure = `4.3`.
    temp4-weight_unit = `KG`.
    temp4-width = `33`.
    temp4-depth = `20`.
    temp4-height = `3`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Professional 17`.
    temp4-price = '2299.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Out of Stock`.
    temp4-status_state = `Warning`.
    temp4-weight_measure = `4.1`.
    temp4-weight_unit = `KG`.
    temp4-width = `33`.
    temp4-depth = `23`.
    temp4-height = `2`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO Vault Net`.
    temp4-price = '459.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Discontinued`.
    temp4-status_state = `Error`.
    temp4-weight_measure = `0.16`.
    temp4-weight_unit = `KG`.
    temp4-width = `10`.
    temp4-depth = `1.8`.
    temp4-height = `17`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO Vault SAT`.
    temp4-price = '149.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `0.18`.
    temp4-weight_unit = `KG`.
    temp4-width = `11`.
    temp4-depth = `1.7`.
    temp4-height = `18`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Comfort Easy`.
    temp4-price = '1679.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Out of Stock`.
    temp4-status_state = `Warning`.
    temp4-weight_measure = `0.2`.
    temp4-weight_unit = `KG`.
    temp4-width = `84`.
    temp4-depth = `1.5`.
    temp4-height = `14`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Comfort Senior`.
    temp4-price = '512.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `0.8`.
    temp4-weight_unit = `KG`.
    temp4-width = `80`.
    temp4-depth = `1.6`.
    temp4-height = `13`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergo Screen E-I`.
    temp4-price = '230.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `21`.
    temp4-weight_unit = `KG`.
    temp4-width = `37`.
    temp4-depth = `12`.
    temp4-height = `36`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergo Screen E-II`.
    temp4-price = '285.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `21`.
    temp4-weight_unit = `KG`.
    temp4-width = `40.8`.
    temp4-depth = `19`.
    temp4-height = `43`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergo Screen E-III`.
    temp4-price = '345.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Out of Stock`.
    temp4-status_state = `Warning`.
    temp4-weight_measure = `21`.
    temp4-weight_unit = `KG`.
    temp4-width = `40.8`.
    temp4-depth = `19`.
    temp4-height = `43`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Basic`.
    temp4-price = '399.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `14`.
    temp4-weight_unit = `KG`.
    temp4-width = `39`.
    temp4-depth = `20`.
    temp4-height = `41`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Future`.
    temp4-price = '430.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `15`.
    temp4-weight_unit = `KG`.
    temp4-width = `45`.
    temp4-depth = `26`.
    temp4-height = `46`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat XL`.
    temp4-price = '1230.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `17`.
    temp4-weight_unit = `KG`.
    temp4-width = `54.5`.
    temp4-depth = `22.1`.
    temp4-height = `39.1`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Laser Professional Eco`.
    temp4-price = '830.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `32`.
    temp4-weight_unit = `KG`.
    temp4-width = `51`.
    temp4-depth = `46`.
    temp4-height = `30`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Laser Basic`.
    temp4-price = '490.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `23`.
    temp4-weight_unit = `KG`.
    temp4-width = `48`.
    temp4-depth = `42`.
    temp4-height = `26`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Laser Allround`.
    temp4-price = '349.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `17`.
    temp4-weight_unit = `KG`.
    temp4-width = `53`.
    temp4-depth = `50`.
    temp4-height = `65`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ultra Jet Super Color`.
    temp4-price = '139.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Discontinued`.
    temp4-status_state = `Error`.
    temp4-weight_measure = `3`.
    temp4-weight_unit = `KG`.
    temp4-width = `41`.
    temp4-depth = `41`.
    temp4-height = `28`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ultra Jet Mobile`.
    temp4-price = '99.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Discontinued`.
    temp4-status_state = `Error`.
    temp4-weight_measure = `1.9`.
    temp4-weight_unit = `KG`.
    temp4-width = `46`.
    temp4-depth = `32`.
    temp4-height = `25`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ultra Jet Super Highspeed`.
    temp4-price = '170.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `18`.
    temp4-weight_unit = `KG`.
    temp4-width = `41`.
    temp4-depth = `41`.
    temp4-height = `28`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Multi Print`.
    temp4-price = '99.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `6.3`.
    temp4-weight_unit = `KG`.
    temp4-width = `55`.
    temp4-depth = `45`.
    temp4-height = `29`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Multi Color`.
    temp4-price = '119.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `4.3`.
    temp4-weight_unit = `KG`.
    temp4-width = `51`.
    temp4-depth = `41.3`.
    temp4-height = `22`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cordless Mouse`.
    temp4-price = '9.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `0.09`.
    temp4-weight_unit = `KG`.
    temp4-width = `6`.
    temp4-depth = `14.5`.
    temp4-height = `3.5`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Speed Mouse`.
    temp4-price = '7.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `0.09`.
    temp4-weight_unit = `KG`.
    temp4-width = `7`.
    temp4-depth = `15`.
    temp4-height = `3.1`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Track Mouse`.
    temp4-price = '11.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Discontinued`.
    temp4-status_state = `Error`.
    temp4-weight_measure = `0.03`.
    temp4-weight_unit = `KG`.
    temp4-width = `3`.
    temp4-depth = `7`.
    temp4-height = `4`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergonomic Keyboard`.
    temp4-price = '14.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `2.1`.
    temp4-weight_unit = `KG`.
    temp4-width = `50`.
    temp4-depth = `21`.
    temp4-height = `3.5`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Internet Keyboard`.
    temp4-price = '16.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Out of Stock`.
    temp4-status_state = `Warning`.
    temp4-weight_measure = `1.8`.
    temp4-weight_unit = `KG`.
    temp4-width = `52`.
    temp4-depth = `25`.
    temp4-height = `3`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Media Keyboard`.
    temp4-price = '26.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `2.3`.
    temp4-weight_unit = `KG`.
    temp4-width = `51.4`.
    temp4-depth = `23`.
    temp4-height = `4`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Mousepad`.
    temp4-price = '6.99'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `80`.
    temp4-weight_unit = `G`.
    temp4-width = `15`.
    temp4-depth = `6`.
    temp4-height = `0.2`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergo Mousepad`.
    temp4-price = '8.99'.
    temp4-currency_code = `EUR`.
    temp4-status = `Out of Stock`.
    temp4-status_state = `Warning`.
    temp4-weight_measure = `80`.
    temp4-weight_unit = `G`.
    temp4-width = `15`.
    temp4-depth = `6`.
    temp4-height = `0.2`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Designer Mousepad`.
    temp4-price = '12.99'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `90`.
    temp4-weight_unit = `G`.
    temp4-width = `24`.
    temp4-depth = `24`.
    temp4-height = `0.6`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Universal card reader`.
    temp4-price = '14.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `45`.
    temp4-weight_unit = `G`.
    temp4-width = `6`.
    temp4-depth = `6`.
    temp4-height = `3`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Proctra X`.
    temp4-price = '70.90'.
    temp4-currency_code = `EUR`.
    temp4-status = `Out of Stock`.
    temp4-status_state = `Warning`.
    temp4-weight_measure = `0.255`.
    temp4-weight_unit = `KG`.
    temp4-width = `22`.
    temp4-depth = `35`.
    temp4-height = `17`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Gladiator MX`.
    temp4-price = '81.70'.
    temp4-currency_code = `EUR`.
    temp4-status = `Discontinued`.
    temp4-status_state = `Error`.
    temp4-weight_measure = `0.3`.
    temp4-weight_unit = `KG`.
    temp4-width = `22`.
    temp4-depth = `35`.
    temp4-height = `17`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Hurricane GX`.
    temp4-price = '101.20'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `0.4`.
    temp4-weight_unit = `KG`.
    temp4-width = `22`.
    temp4-depth = `35`.
    temp4-height = `17`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Hurricane GX/LN`.
    temp4-price = '139.99'.
    temp4-currency_code = `EUR`.
    temp4-status = `Out of Stock`.
    temp4-status_state = `Warning`.
    temp4-weight_measure = `0.4`.
    temp4-weight_unit = `KG`.
    temp4-width = `22`.
    temp4-depth = `35`.
    temp4-height = `17`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Photo Scan`.
    temp4-price = '129.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Out of Stock`.
    temp4-status_state = `Warning`.
    temp4-weight_measure = `2.3`.
    temp4-weight_unit = `KG`.
    temp4-width = `34`.
    temp4-depth = `48`.
    temp4-height = `5`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Power Scan`.
    temp4-price = '89.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Out of Stock`.
    temp4-status_state = `Warning`.
    temp4-weight_measure = `2.4`.
    temp4-weight_unit = `KG`.
    temp4-width = `31`.
    temp4-depth = `43`.
    temp4-height = `7`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Jet Scan Professional`.
    temp4-price = '169.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Out of Stock`.
    temp4-status_state = `Warning`.
    temp4-weight_measure = `3.2`.
    temp4-weight_unit = `KG`.
    temp4-width = `33`.
    temp4-depth = `41`.
    temp4-height = `12`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Jet Scan Professional`.
    temp4-price = '189.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `3.2`.
    temp4-weight_unit = `KG`.
    temp4-width = `35`.
    temp4-depth = `40`.
    temp4-height = `10`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Copymaster`.
    temp4-price = '1499.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `23.2`.
    temp4-weight_unit = `KG`.
    temp4-width = `45`.
    temp4-depth = `42`.
    temp4-height = `22`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Surround Sound`.
    temp4-price = '39.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `3`.
    temp4-weight_unit = `KG`.
    temp4-width = `12`.
    temp4-depth = `10`.
    temp4-height = `16`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Blaster Extreme`.
    temp4-price = '26.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `1.4`.
    temp4-weight_unit = `KG`.
    temp4-width = `13`.
    temp4-depth = `11`.
    temp4-height = `17.5`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Sound Booster`.
    temp4-price = '45.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Discontinued`.
    temp4-status_state = `Error`.
    temp4-weight_measure = `2.1`.
    temp4-weight_unit = `KG`.
    temp4-width = `12.4`.
    temp4-depth = `10.4`.
    temp4-height = `18.1`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Lovely Sound 5.1 Wireless`.
    temp4-price = '49.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `80`.
    temp4-weight_unit = `G`.
    temp4-width = `24`.
    temp4-depth = `19`.
    temp4-height = `23`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Lovely Sound 5.1`.
    temp4-price = '39.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `130`.
    temp4-weight_unit = `G`.
    temp4-width = `25`.
    temp4-depth = `17`.
    temp4-height = `19`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Lovely Sound Stereo`.
    temp4-price = '29.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Out of Stock`.
    temp4-status_state = `Warning`.
    temp4-weight_measure = `60`.
    temp4-weight_unit = `G`.
    temp4-width = `21.3`.
    temp4-depth = `2.4`.
    temp4-height = `19.7`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Office`.
    temp4-price = '89.90'.
    temp4-currency_code = `EUR`.
    temp4-status = `Out of Stock`.
    temp4-status_state = `Warning`.
    temp4-weight_measure = `1.2`.
    temp4-weight_unit = `KG`.
    temp4-width = `15`.
    temp4-depth = `6.5`.
    temp4-height = `2.1`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Design`.
    temp4-price = '79.90'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `0.8`.
    temp4-weight_unit = `KG`.
    temp4-width = `14`.
    temp4-depth = `6.7`.
    temp4-height = `24`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Network`.
    temp4-price = '69.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `0.8`.
    temp4-weight_unit = `KG`.
    temp4-width = `16`.
    temp4-depth = `6`.
    temp4-height = `27`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Multimedia`.
    temp4-price = '77.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `0.8`.
    temp4-weight_unit = `KG`.
    temp4-width = `11`.
    temp4-depth = `3.4`.
    temp4-height = `22`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Games`.
    temp4-price = '55.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `1.1`.
    temp4-weight_unit = `KG`.
    temp4-width = `10`.
    temp4-depth = `3`.
    temp4-height = `30`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Internet Antivirus`.
    temp4-price = '29.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `0.7`.
    temp4-weight_unit = `KG`.
    temp4-width = `16`.
    temp4-depth = `4`.
    temp4-height = `21`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Firewall`.
    temp4-price = '34.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Discontinued`.
    temp4-status_state = `Error`.
    temp4-weight_measure = `0.9`.
    temp4-weight_unit = `KG`.
    temp4-width = `17.9`.
    temp4-depth = `4.2`.
    temp4-height = `23.1`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Money`.
    temp4-price = '29.90'.
    temp4-currency_code = `EUR`.
    temp4-status = `Out of Stock`.
    temp4-status_state = `Warning`.
    temp4-weight_measure = `0.5`.
    temp4-weight_unit = `KG`.
    temp4-width = `12`.
    temp4-depth = `1.5`.
    temp4-height = `19`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `PC Lock`.
    temp4-price = '8.90'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `0.03`.
    temp4-weight_unit = `KG`.
    temp4-width = `20`.
    temp4-depth = `8`.
    temp4-height = `4.3`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Lock`.
    temp4-price = '6.90'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `0.02`.
    temp4-weight_unit = `KG`.
    temp4-width = `31`.
    temp4-depth = `9`.
    temp4-height = `7`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Web cam reality`.
    temp4-price = '39.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Out of Stock`.
    temp4-status_state = `Warning`.
    temp4-weight_measure = `0.075`.
    temp4-weight_unit = `KG`.
    temp4-width = `9`.
    temp4-depth = `8.2`.
    temp4-height = `1.3`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Screen clean`.
    temp4-price = '2.30'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `0.05`.
    temp4-weight_unit = `KG`.
    temp4-width = `2`.
    temp4-depth = `2`.
    temp4-height = `0.1`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Fabric bag professional`.
    temp4-price = '31.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `1.8`.
    temp4-weight_unit = `KG`.
    temp4-width = `42`.
    temp4-depth = `32`.
    temp4-height = `7`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Wireless DSL Router`.
    temp4-price = '49.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `0.45`.
    temp4-weight_unit = `KG`.
    temp4-width = `19.3`.
    temp4-depth = `18`.
    temp4-height = `5`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Wireless DSL Router / Repeater`.
    temp4-price = '59.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Out of Stock`.
    temp4-status_state = `Warning`.
    temp4-weight_measure = `0.45`.
    temp4-weight_unit = `KG`.
    temp4-width = `19.3`.
    temp4-depth = `18`.
    temp4-height = `5`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Wireless DSL Router / Repeater and Print Server`.
    temp4-price = '69.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `0.45`.
    temp4-weight_unit = `KG`.
    temp4-width = `19.3`.
    temp4-depth = `18`.
    temp4-height = `5`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `USB Stick`.
    temp4-price = '35.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `0.015`.
    temp4-weight_unit = `KG`.
    temp4-width = `1.5`.
    temp4-depth = `8.7`.
    temp4-height = `1.2`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Travel Adapter`.
    temp4-price = '79.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Discontinued`.
    temp4-status_state = `Error`.
    temp4-weight_measure = `88`.
    temp4-weight_unit = `G`.
    temp4-width = `2`.
    temp4-depth = `3.1`.
    temp4-height = `3.9`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cordless Bluetooth Keyboard, english international`.
    temp4-price = '29.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Out of Stock`.
    temp4-status_state = `Warning`.
    temp4-weight_measure = `1`.
    temp4-weight_unit = `KG`.
    temp4-width = `51.4`.
    temp4-depth = `23`.
    temp4-height = `4`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat XXL`.
    temp4-price = '1430.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Discontinued`.
    temp4-status_state = `Error`.
    temp4-weight_measure = `18`.
    temp4-weight_unit = `KG`.
    temp4-width = `54`.
    temp4-depth = `22`.
    temp4-height = `38`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Pocket Mouse`.
    temp4-price = '23.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `0.02`.
    temp4-weight_unit = `KG`.
    temp4-width = `0.3`.
    temp4-depth = `0.5`.
    temp4-height = `1`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `PC Power Station`.
    temp4-price = '2399.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `2.3`.
    temp4-weight_unit = `KG`.
    temp4-width = `28`.
    temp4-depth = `31`.
    temp4-height = `43`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Astro Laptop 1516`.
    temp4-price = '989.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `4.2`.
    temp4-weight_unit = `KG`.
    temp4-width = `30`.
    temp4-depth = `18`.
    temp4-height = `3`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Astro Phone 6`.
    temp4-price = '649.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `0.75`.
    temp4-weight_unit = `KG`.
    temp4-width = `8`.
    temp4-depth = `6`.
    temp4-height = `1.5`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Benda Laptop 1408`.
    temp4-price = '976.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Discontinued`.
    temp4-status_state = `Error`.
    temp4-weight_measure = `4.2`.
    temp4-weight_unit = `KG`.
    temp4-width = `30`.
    temp4-depth = `18`.
    temp4-height = `3`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Bending Screen 21HD`.
    temp4-price = '250.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `15`.
    temp4-weight_unit = `KG`.
    temp4-width = `37`.
    temp4-depth = `12`.
    temp4-height = `36`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Broad Screen 22HD`.
    temp4-price = '270.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Discontinued`.
    temp4-status_state = `Error`.
    temp4-weight_measure = `16`.
    temp4-weight_unit = `KG`.
    temp4-width = `39`.
    temp4-depth = `12`.
    temp4-height = `38`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cerdik Phone 7`.
    temp4-price = '549.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Discontinued`.
    temp4-status_state = `Error`.
    temp4-weight_measure = `0.75`.
    temp4-weight_unit = `KG`.
    temp4-width = `9`.
    temp4-depth = `15`.
    temp4-height = `1.5`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cepat Tablet 10.5`.
    temp4-price = '549.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `2.8`.
    temp4-weight_unit = `KG`.
    temp4-width = `48`.
    temp4-depth = `31`.
    temp4-height = `4.5`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cepat Tablet 8`.
    temp4-price = '529.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `2.5`.
    temp4-weight_unit = `KG`.
    temp4-width = `38`.
    temp4-depth = `21`.
    temp4-height = `3.5`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Server Basic`.
    temp4-price = '5000.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `18`.
    temp4-weight_unit = `KG`.
    temp4-width = `34`.
    temp4-depth = `35`.
    temp4-height = `23`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Server Professional`.
    temp4-price = '15000.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Out of Stock`.
    temp4-status_state = `Warning`.
    temp4-weight_measure = `25`.
    temp4-weight_unit = `KG`.
    temp4-width = `29`.
    temp4-depth = `30`.
    temp4-height = `27`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Server Power Pro`.
    temp4-price = '25000.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `35`.
    temp4-weight_unit = `KG`.
    temp4-width = `22`.
    temp4-depth = `27.3`.
    temp4-height = `37`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Family PC Basic`.
    temp4-price = '600.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `4.8`.
    temp4-weight_unit = `KG`.
    temp4-width = `21.4`.
    temp4-depth = `29`.
    temp4-height = `38`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Family PC Pro`.
    temp4-price = '900.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `5.3`.
    temp4-weight_unit = `KG`.
    temp4-width = `25`.
    temp4-depth = `31.7`.
    temp4-height = `40.2`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Gaming Monster`.
    temp4-price = '1200.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `5.9`.
    temp4-weight_unit = `KG`.
    temp4-width = `26.5`.
    temp4-depth = `34`.
    temp4-height = `47`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Gaming Monster Pro`.
    temp4-price = '1700.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Discontinued`.
    temp4-status_state = `Error`.
    temp4-weight_measure = `6.8`.
    temp4-weight_unit = `KG`.
    temp4-width = `27`.
    temp4-depth = `28`.
    temp4-height = `42`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `7" Widescreen Portable DVD Player w MP3`.
    temp4-price = '249.99'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `0.79`.
    temp4-weight_unit = `KG`.
    temp4-width = `21.4`.
    temp4-depth = `19`.
    temp4-height = `27.6`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `10" Portable DVD player`.
    temp4-price = '449.99'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `0.84`.
    temp4-weight_unit = `KG`.
    temp4-width = `24`.
    temp4-depth = `19.5`.
    temp4-height = `29`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Portable DVD Player with 9" LCD Monitor`.
    temp4-price = '853.99'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `0.72`.
    temp4-weight_unit = `KG`.
    temp4-width = `21`.
    temp4-depth = `16.5`.
    temp4-height = `14`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `CD/DVD case: 264 sleeves`.
    temp4-price = '44.99'.
    temp4-currency_code = `EUR`.
    temp4-status = `Discontinued`.
    temp4-status_state = `Error`.
    temp4-weight_measure = `0.65`.
    temp4-weight_unit = `KG`.
    temp4-width = `13`.
    temp4-depth = `13`.
    temp4-height = `20`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Audio/Video Cable Kit - 4m`.
    temp4-price = '29.99'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `0.2`.
    temp4-weight_unit = `KG`.
    temp4-width = `21`.
    temp4-depth = `10.2`.
    temp4-height = `13`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Removable CD/DVD Laser Labels`.
    temp4-price = '8.99'.
    temp4-currency_code = `EUR`.
    temp4-status = `Discontinued`.
    temp4-status_state = `Error`.
    temp4-weight_measure = `0.15`.
    temp4-weight_unit = `KG`.
    temp4-width = `5.5`.
    temp4-depth = `2`.
    temp4-height = `2`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Beam Breaker B-1`.
    temp4-price = '469.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Out of Stock`.
    temp4-status_state = `Warning`.
    temp4-weight_measure = `1.7`.
    temp4-weight_unit = `KG`.
    temp4-width = `30.4`.
    temp4-depth = `23.1`.
    temp4-height = `23`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Beam Breaker B-2`.
    temp4-price = '679.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `2`.
    temp4-weight_unit = `KG`.
    temp4-width = `30.4`.
    temp4-depth = `23.1`.
    temp4-height = `23`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Beam Breaker B-3`.
    temp4-price = '889.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Out of Stock`.
    temp4-status_state = `Warning`.
    temp4-weight_measure = `2.5`.
    temp4-weight_unit = `KG`.
    temp4-width = `30.4`.
    temp4-depth = `23.1`.
    temp4-height = `23`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Play Movie`.
    temp4-price = '130.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `2.4`.
    temp4-weight_unit = `KG`.
    temp4-width = `37`.
    temp4-depth = `24`.
    temp4-height = `6`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Record Movie`.
    temp4-price = '288.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Discontinued`.
    temp4-status_state = `Error`.
    temp4-weight_measure = `3.1`.
    temp4-weight_unit = `KG`.
    temp4-width = `38`.
    temp4-depth = `26`.
    temp4-height = `6.2`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelo MusicStick`.
    temp4-price = '45.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `134`.
    temp4-weight_unit = `G`.
    temp4-width = `1.5`.
    temp4-depth = `6`.
    temp4-height = `1`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelo Jog-Mate`.
    temp4-price = '63.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `134`.
    temp4-weight_unit = `G`.
    temp4-width = `5.1`.
    temp4-depth = `8`.
    temp4-height = `9.2`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Power Pro Player 40`.
    temp4-price = '167.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `266`.
    temp4-weight_unit = `G`.
    temp4-width = `5.1`.
    temp4-depth = `8`.
    temp4-height = `9.2`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Power Pro Player 80`.
    temp4-price = '299.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `267`.
    temp4-weight_unit = `G`.
    temp4-width = `4`.
    temp4-depth = `6`.
    temp4-height = `0.8`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Watch HD32`.
    temp4-price = '1459.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `2.6`.
    temp4-weight_unit = `KG`.
    temp4-width = `78`.
    temp4-depth = `22.1`.
    temp4-height = `55`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Watch HD37`.
    temp4-price = '1199.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `2.2`.
    temp4-weight_unit = `KG`.
    temp4-width = `99.1`.
    temp4-depth = `26`.
    temp4-height = `61`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Watch HD41`.
    temp4-price = '899.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Discontinued`.
    temp4-status_state = `Error`.
    temp4-weight_measure = `1.8`.
    temp4-weight_unit = `KG`.
    temp4-width = `128`.
    temp4-depth = `23`.
    temp4-height = `79.1`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Copperberry`.
    temp4-price = '549.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Discontinued`.
    temp4-status_state = `Error`.
    temp4-weight_measure = `0.5`.
    temp4-weight_unit = `KG`.
    temp4-width = `8.1`.
    temp4-depth = `13`.
    temp4-height = `12.1`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Silverberry`.
    temp4-price = '549.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Discontinued`.
    temp4-status_state = `Error`.
    temp4-weight_measure = `0.5`.
    temp4-weight_unit = `KG`.
    temp4-width = `8.1`.
    temp4-depth = `13`.
    temp4-height = `12.1`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Goldberry`.
    temp4-price = '549.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `0.5`.
    temp4-weight_unit = `KG`.
    temp4-width = `8.1`.
    temp4-depth = `13`.
    temp4-height = `12.1`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Platinberry`.
    temp4-price = '549.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `0.5`.
    temp4-weight_unit = `KG`.
    temp4-width = `8.1`.
    temp4-depth = `13`.
    temp4-height = `12.1`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO FlexTop I4000`.
    temp4-price = '799.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `4`.
    temp4-weight_unit = `KG`.
    temp4-width = `31`.
    temp4-depth = `19`.
    temp4-height = `3.1`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO FlexTop I6300c`.
    temp4-price = '799.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Discontinued`.
    temp4-status_state = `Error`.
    temp4-weight_measure = `4.2`.
    temp4-weight_unit = `KG`.
    temp4-width = `32`.
    temp4-depth = `20`.
    temp4-height = `3.4`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO FlexTop I9100`.
    temp4-price = '1199.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `3.5`.
    temp4-weight_unit = `KG`.
    temp4-width = `38`.
    temp4-depth = `21`.
    temp4-height = `4.1`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO FlexTop I9800`.
    temp4-price = '1388.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `3.8`.
    temp4-weight_unit = `KG`.
    temp4-width = `48`.
    temp4-depth = `31`.
    temp4-height = `4.5`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smartphone Leather Case`.
    temp4-price = '25.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `0.02`.
    temp4-weight_unit = `KG`.
    temp4-width = `48`.
    temp4-depth = `31`.
    temp4-height = `4.5`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smartphone Alpha`.
    temp4-price = '599.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Out of Stock`.
    temp4-status_state = `Warning`.
    temp4-weight_measure = `0.75`.
    temp4-weight_unit = `KG`.
    temp4-width = `48`.
    temp4-depth = `31`.
    temp4-height = `4.5`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Mini Tablet`.
    temp4-price = '833.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `3.8`.
    temp4-weight_unit = `KG`.
    temp4-width = `48`.
    temp4-depth = `31`.
    temp4-height = `4.5`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Camcorder View`.
    temp4-price = '1388.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Out of Stock`.
    temp4-status_state = `Warning`.
    temp4-weight_measure = `3.8`.
    temp4-weight_unit = `KG`.
    temp4-width = `48`.
    temp4-depth = `31`.
    temp4-height = `27`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Tablet Pouch`.
    temp4-price = '20.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `0.03`.
    temp4-weight_unit = `KG`.
    temp4-width = `25`.
    temp4-depth = `40`.
    temp4-height = `4.5`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Tablet Pouch`.
    temp4-price = '20.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `0.03`.
    temp4-weight_unit = `KG`.
    temp4-width = `25`.
    temp4-depth = `40`.
    temp4-height = `4.5`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `e-Book Reader ReadMe`.
    temp4-price = '33.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `3.8`.
    temp4-weight_unit = `KG`.
    temp4-width = `48`.
    temp4-depth = `31`.
    temp4-height = `4.5`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smartphone Beta`.
    temp4-price = '30.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `0.75`.
    temp4-weight_unit = `KG`.
    temp4-width = `48`.
    temp4-depth = `31`.
    temp4-height = `4.5`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Maxi Tablet`.
    temp4-price = '749.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Available`.
    temp4-status_state = `Success`.
    temp4-weight_measure = `3.8`.
    temp4-weight_unit = `KG`.
    temp4-width = `48`.
    temp4-depth = `31`.
    temp4-height = `4.5`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flyer`.
    temp4-price = '0.00'.
    temp4-currency_code = `EUR`.
    temp4-status = `Out of Stock`.
    temp4-status_state = `Warning`.
    temp4-weight_measure = `0.01`.
    temp4-weight_unit = `KG`.
    temp4-width = `46`.
    temp4-depth = `30`.
    temp4-height = `3`.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    t_products = temp3.

  ENDMETHOD.

ENDCLASS.
