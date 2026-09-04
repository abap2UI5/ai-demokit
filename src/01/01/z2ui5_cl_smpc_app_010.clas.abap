" @keywords columnlistitem column list item sap.m opa test app product table toolbar title
" @summary The following example simulates a click on a list item in a table.
CLASS z2ui5_cl_smpc_app_010 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        product_id     TYPE string,
        supplier_name  TYPE string,
        weight_measure TYPE p LENGTH 8 DECIMALS 3,
        weight_unit    TYPE string,
        weight_state   TYPE string,
        name           TYPE string,
        currency_code  TYPE string,
        price          TYPE p LENGTH 8 DECIMALS 2,
        width          TYPE p LENGTH 4 DECIMALS 1,
        depth          TYPE p LENGTH 4 DECIMALS 1,
        height         TYPE p LENGTH 4 DECIMALS 1,
        dim_unit       TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.
    DATA popin_layout TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popup_message_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_010 IMPLEMENTATION.

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
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core`   v = `sap.ui.core`
        )->a( n = `xmlns`        v = `sap.m`

        )->ele( `Table`
            )->a( n = `id`          v = `idProductsTable`
            )->a( n = `inset`       v = `false`
            )->a( n = `items`       v = |\{ path: '{ client->_bind_path( t_products ) }', sorter: \{ path: 'NAME' \} \}|
            " the controller's onPopinLayoutChanged switch lives in this expression binding (as app 009) - never emits an empty enum value
            )->a( n = `popinLayout` v = |\{= ${ client->_bind( popin_layout ) } === 'GridLarge' \|\| ${ client->_bind( popin_layout ) } === 'GridSmall' ? ${ client->_bind( popin_layout ) } : 'Block' \}|

            )->ele( `headerToolbar`
                )->ele( `Toolbar`
                    )->ele( `content`
                        )->tag( `Title`
                            )->a( n = `text`  v = `Products`
                            )->a( n = `level` v = `H2`
                        )->tag( `ToolbarSpacer`

                        )->ele( `ComboBox`
                            )->a( n = `id`          v = `idPopinLayout`
                            )->a( n = `placeholder` v = `Popin layout options`
                            " original change handler dropped - the two-way selectedKey feeds the popinLayout expression binding
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
                    )->end(
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
                    )->a( n = `type`  v = `Navigation`
                    )->a( n = `press` v = client->_event( `MESSAGE_DIALOG_PRESS` )

                    )->ele( `cells`
                        )->tag( `ObjectIdentifier`
                            )->a( n = `title` v = `{NAME}`
                            )->a( n = `text`  v = `{PRODUCT_ID}`
                        )->tag( `Text`
                            )->a( n = `text` v = `{SUPPLIER_NAME}`
                        )->tag( `Text`
                            )->a( n = `text` v = `{WIDTH} x {DEPTH} x {HEIGHT} {DIM_UNIT}`
                        )->tag( `ObjectNumber`
                            )->a( n = `number` v = `{WEIGHT_MEASURE}`
                            )->a( n = `unit`   v = `{WEIGHT_UNIT}`
                            )->a( n = `state`  v = `{WEIGHT_STATE}`
                        )->tag( `ObjectNumber`
                            )->a( n = `number` v = `{ parts: [{path: 'PRICE'}, {path: 'CURRENCY_CODE'}], type: 'sap.ui.model.type.Currency', formatOptions: {showMeasure: false} }`
                            )->a( n = `unit`   v = `{CURRENCY_CODE}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `MESSAGE_DIALOG_PRESS`.
      popup_message_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD popup_message_display.

    " the controller-built message Dialog, shown as a popup fragment
    DATA popup TYPE REF TO z2ui5_cl_ui5_view_builder.
    popup = z2ui5_cl_ui5_view_builder=>factory( ).

    popup->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns`      v = `sap.m`

        )->ele( `Dialog`
            )->a( n = `title` v = `Message`
            )->a( n = `type`  v = `Message`

            )->ele( `content`
                )->tag( `Text`
                    )->a( n = `text` v = `Success`

            )->end(
            )->ele( `beginButton`
                )->tag( `Button`
                    )->a( n = `text`  v = `OK`
                    )->a( n = `press` v = client->follow_up_action( client->cs_event-popup_close ) ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    DATA temp1 LIKE t_products.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp3 LIKE LINE OF t_products.
    DATA lr_product LIKE REF TO temp3.
      DATA weight_kg LIKE lr_product->weight_measure.
      DATA temp4 TYPE z2ui5_cl_smpc_app_010=>ty_s_product-weight_state.
    CLEAR temp1.
    
    temp2-product_id = `HT-1000`.
    temp2-supplier_name = `Very Best Screens`.
    temp2-weight_measure = '4.2'.
    temp2-weight_unit = `KG`.
    temp2-name = `Notebook Basic 15`.
    temp2-currency_code = `EUR`.
    temp2-price = '956'.
    temp2-width = '30'.
    temp2-depth = '18'.
    temp2-height = '3'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1001`.
    temp2-supplier_name = `Very Best Screens`.
    temp2-weight_measure = '4.5'.
    temp2-weight_unit = `KG`.
    temp2-name = `Notebook Basic 17`.
    temp2-currency_code = `EUR`.
    temp2-price = '1249'.
    temp2-width = '29'.
    temp2-depth = '17'.
    temp2-height = '3.1'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1002`.
    temp2-supplier_name = `Very Best Screens`.
    temp2-weight_measure = '4.2'.
    temp2-weight_unit = `KG`.
    temp2-name = `Notebook Basic 18`.
    temp2-currency_code = `EUR`.
    temp2-price = '1570'.
    temp2-width = '28'.
    temp2-depth = '19'.
    temp2-height = '2.5'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1003`.
    temp2-supplier_name = `Smartcards`.
    temp2-weight_measure = '4.2'.
    temp2-weight_unit = `KG`.
    temp2-name = `Notebook Basic 19`.
    temp2-currency_code = `EUR`.
    temp2-price = '1650'.
    temp2-width = '32'.
    temp2-depth = '21'.
    temp2-height = '4'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1007`.
    temp2-supplier_name = `Technocom`.
    temp2-weight_measure = '0.2'.
    temp2-weight_unit = `KG`.
    temp2-name = `ITelO Vault`.
    temp2-currency_code = `EUR`.
    temp2-price = '299'.
    temp2-width = '32'.
    temp2-depth = '22'.
    temp2-height = '3'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1010`.
    temp2-supplier_name = `Very Best Screens`.
    temp2-weight_measure = '4.3'.
    temp2-weight_unit = `KG`.
    temp2-name = `Notebook Professional 15`.
    temp2-currency_code = `EUR`.
    temp2-price = '1999'.
    temp2-width = '33'.
    temp2-depth = '20'.
    temp2-height = '3'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1011`.
    temp2-supplier_name = `Very Best Screens`.
    temp2-weight_measure = '4.1'.
    temp2-weight_unit = `KG`.
    temp2-name = `Notebook Professional 17`.
    temp2-currency_code = `EUR`.
    temp2-price = '2299'.
    temp2-width = '33'.
    temp2-depth = '23'.
    temp2-height = '2'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1020`.
    temp2-supplier_name = `Technocom`.
    temp2-weight_measure = '0.16'.
    temp2-weight_unit = `KG`.
    temp2-name = `ITelO Vault Net`.
    temp2-currency_code = `EUR`.
    temp2-price = '459'.
    temp2-width = '10'.
    temp2-depth = '1.8'.
    temp2-height = '17'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1021`.
    temp2-supplier_name = `Technocom`.
    temp2-weight_measure = '0.18'.
    temp2-weight_unit = `KG`.
    temp2-name = `ITelO Vault SAT`.
    temp2-currency_code = `EUR`.
    temp2-price = '149'.
    temp2-width = '11'.
    temp2-depth = '1.7'.
    temp2-height = '18'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1022`.
    temp2-supplier_name = `Technocom`.
    temp2-weight_measure = '0.2'.
    temp2-weight_unit = `KG`.
    temp2-name = `Comfort Easy`.
    temp2-currency_code = `EUR`.
    temp2-price = '1679'.
    temp2-width = '84'.
    temp2-depth = '1.5'.
    temp2-height = '14'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1023`.
    temp2-supplier_name = `Technocom`.
    temp2-weight_measure = '0.8'.
    temp2-weight_unit = `KG`.
    temp2-name = `Comfort Senior`.
    temp2-currency_code = `EUR`.
    temp2-price = '512'.
    temp2-width = '80'.
    temp2-depth = '1.6'.
    temp2-height = '13'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1030`.
    temp2-supplier_name = `Very Best Screens`.
    temp2-weight_measure = '21'.
    temp2-weight_unit = `KG`.
    temp2-name = `Ergo Screen E-I`.
    temp2-currency_code = `EUR`.
    temp2-price = '230'.
    temp2-width = '37'.
    temp2-depth = '12'.
    temp2-height = '36'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1031`.
    temp2-supplier_name = `Very Best Screens`.
    temp2-weight_measure = '21'.
    temp2-weight_unit = `KG`.
    temp2-name = `Ergo Screen E-II`.
    temp2-currency_code = `EUR`.
    temp2-price = '285'.
    temp2-width = '40.8'.
    temp2-depth = '19'.
    temp2-height = '43'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1032`.
    temp2-supplier_name = `Very Best Screens`.
    temp2-weight_measure = '21'.
    temp2-weight_unit = `KG`.
    temp2-name = `Ergo Screen E-III`.
    temp2-currency_code = `EUR`.
    temp2-price = '345'.
    temp2-width = '40.8'.
    temp2-depth = '19'.
    temp2-height = '43'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1035`.
    temp2-supplier_name = `Very Best Screens`.
    temp2-weight_measure = '14'.
    temp2-weight_unit = `KG`.
    temp2-name = `Flat Basic`.
    temp2-currency_code = `EUR`.
    temp2-price = '399'.
    temp2-width = '39'.
    temp2-depth = '20'.
    temp2-height = '41'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1036`.
    temp2-supplier_name = `Very Best Screens`.
    temp2-weight_measure = '15'.
    temp2-weight_unit = `KG`.
    temp2-name = `Flat Future`.
    temp2-currency_code = `EUR`.
    temp2-price = '430'.
    temp2-width = '45'.
    temp2-depth = '26'.
    temp2-height = '46'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1037`.
    temp2-supplier_name = `Very Best Screens`.
    temp2-weight_measure = '17'.
    temp2-weight_unit = `KG`.
    temp2-name = `Flat XL`.
    temp2-currency_code = `EUR`.
    temp2-price = '1230'.
    temp2-width = '54.5'.
    temp2-depth = '22.1'.
    temp2-height = '39.1'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1040`.
    temp2-supplier_name = `Alpha Printers`.
    temp2-weight_measure = '32'.
    temp2-weight_unit = `KG`.
    temp2-name = `Laser Professional Eco`.
    temp2-currency_code = `EUR`.
    temp2-price = '830'.
    temp2-width = '51'.
    temp2-depth = '46'.
    temp2-height = '30'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1041`.
    temp2-supplier_name = `Alpha Printers`.
    temp2-weight_measure = '23'.
    temp2-weight_unit = `KG`.
    temp2-name = `Laser Basic`.
    temp2-currency_code = `EUR`.
    temp2-price = '490'.
    temp2-width = '48'.
    temp2-depth = '42'.
    temp2-height = '26'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1042`.
    temp2-supplier_name = `Alpha Printers`.
    temp2-weight_measure = '17'.
    temp2-weight_unit = `KG`.
    temp2-name = `Laser Allround`.
    temp2-currency_code = `EUR`.
    temp2-price = '349'.
    temp2-width = '53'.
    temp2-depth = '50'.
    temp2-height = '65'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1050`.
    temp2-supplier_name = `Alpha Printers`.
    temp2-weight_measure = '3'.
    temp2-weight_unit = `KG`.
    temp2-name = `Ultra Jet Super Color`.
    temp2-currency_code = `EUR`.
    temp2-price = '139'.
    temp2-width = '41'.
    temp2-depth = '41'.
    temp2-height = '28'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1051`.
    temp2-supplier_name = `Printer for All`.
    temp2-weight_measure = '1.9'.
    temp2-weight_unit = `KG`.
    temp2-name = `Ultra Jet Mobile`.
    temp2-currency_code = `EUR`.
    temp2-price = '99'.
    temp2-width = '46'.
    temp2-depth = '32'.
    temp2-height = '25'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1052`.
    temp2-supplier_name = `Printer for All`.
    temp2-weight_measure = '18'.
    temp2-weight_unit = `KG`.
    temp2-name = `Ultra Jet Super Highspeed`.
    temp2-currency_code = `EUR`.
    temp2-price = '170'.
    temp2-width = '41'.
    temp2-depth = '41'.
    temp2-height = '28'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1055`.
    temp2-supplier_name = `Printer for All`.
    temp2-weight_measure = '6.3'.
    temp2-weight_unit = `KG`.
    temp2-name = `Multi Print`.
    temp2-currency_code = `EUR`.
    temp2-price = '99'.
    temp2-width = '55'.
    temp2-depth = '45'.
    temp2-height = '29'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1056`.
    temp2-supplier_name = `Printer for All`.
    temp2-weight_measure = '4.3'.
    temp2-weight_unit = `KG`.
    temp2-name = `Multi Color`.
    temp2-currency_code = `EUR`.
    temp2-price = '119'.
    temp2-width = '51'.
    temp2-depth = '41.3'.
    temp2-height = '22'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1060`.
    temp2-supplier_name = `Oxynum`.
    temp2-weight_measure = '0.09'.
    temp2-weight_unit = `KG`.
    temp2-name = `Cordless Mouse`.
    temp2-currency_code = `EUR`.
    temp2-price = '9'.
    temp2-width = '6'.
    temp2-depth = '14.5'.
    temp2-height = '3.5'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1061`.
    temp2-supplier_name = `Oxynum`.
    temp2-weight_measure = '0.09'.
    temp2-weight_unit = `KG`.
    temp2-name = `Speed Mouse`.
    temp2-currency_code = `EUR`.
    temp2-price = '7'.
    temp2-width = '7'.
    temp2-depth = '15'.
    temp2-height = '3.1'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1062`.
    temp2-supplier_name = `Oxynum`.
    temp2-weight_measure = '0.03'.
    temp2-weight_unit = `KG`.
    temp2-name = `Track Mouse`.
    temp2-currency_code = `EUR`.
    temp2-price = '11'.
    temp2-width = '3'.
    temp2-depth = '7'.
    temp2-height = '4'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1063`.
    temp2-supplier_name = `Oxynum`.
    temp2-weight_measure = '2.1'.
    temp2-weight_unit = `KG`.
    temp2-name = `Ergonomic Keyboard`.
    temp2-currency_code = `EUR`.
    temp2-price = '14'.
    temp2-width = '50'.
    temp2-depth = '21'.
    temp2-height = '3.5'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1064`.
    temp2-supplier_name = `Oxynum`.
    temp2-weight_measure = '1.8'.
    temp2-weight_unit = `KG`.
    temp2-name = `Internet Keyboard`.
    temp2-currency_code = `EUR`.
    temp2-price = '16'.
    temp2-width = '52'.
    temp2-depth = '25'.
    temp2-height = '3'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1065`.
    temp2-supplier_name = `Oxynum`.
    temp2-weight_measure = '2.3'.
    temp2-weight_unit = `KG`.
    temp2-name = `Media Keyboard`.
    temp2-currency_code = `EUR`.
    temp2-price = '26'.
    temp2-width = '51.4'.
    temp2-depth = '23'.
    temp2-height = '4'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1066`.
    temp2-supplier_name = `Oxynum`.
    temp2-weight_measure = '80'.
    temp2-weight_unit = `G`.
    temp2-name = `Mousepad`.
    temp2-currency_code = `EUR`.
    temp2-price = '6.99'.
    temp2-width = '15'.
    temp2-depth = '6'.
    temp2-height = '0.2'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1067`.
    temp2-supplier_name = `Oxynum`.
    temp2-weight_measure = '80'.
    temp2-weight_unit = `G`.
    temp2-name = `Ergo Mousepad`.
    temp2-currency_code = `EUR`.
    temp2-price = '8.99'.
    temp2-width = '15'.
    temp2-depth = '6'.
    temp2-height = '0.2'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1068`.
    temp2-supplier_name = `Fasttech`.
    temp2-weight_measure = '90'.
    temp2-weight_unit = `G`.
    temp2-name = `Designer Mousepad`.
    temp2-currency_code = `EUR`.
    temp2-price = '12.99'.
    temp2-width = '24'.
    temp2-depth = '24'.
    temp2-height = '0.6'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1069`.
    temp2-supplier_name = `Fasttech`.
    temp2-weight_measure = '45'.
    temp2-weight_unit = `G`.
    temp2-name = `Universal card reader`.
    temp2-currency_code = `EUR`.
    temp2-price = '14'.
    temp2-width = '6'.
    temp2-depth = '6'.
    temp2-height = '3'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1070`.
    temp2-supplier_name = `Ultrasonic United`.
    temp2-weight_measure = '0.255'.
    temp2-weight_unit = `KG`.
    temp2-name = `Proctra X`.
    temp2-currency_code = `EUR`.
    temp2-price = '70.9'.
    temp2-width = '22'.
    temp2-depth = '35'.
    temp2-height = '17'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1071`.
    temp2-supplier_name = `Ultrasonic United`.
    temp2-weight_measure = '0.3'.
    temp2-weight_unit = `KG`.
    temp2-name = `Gladiator MX`.
    temp2-currency_code = `EUR`.
    temp2-price = '81.7'.
    temp2-width = '22'.
    temp2-depth = '35'.
    temp2-height = '17'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1072`.
    temp2-supplier_name = `Ultrasonic United`.
    temp2-weight_measure = '0.4'.
    temp2-weight_unit = `KG`.
    temp2-name = `Hurricane GX`.
    temp2-currency_code = `EUR`.
    temp2-price = '101.2'.
    temp2-width = '22'.
    temp2-depth = '35'.
    temp2-height = '17'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1073`.
    temp2-supplier_name = `Smartcards`.
    temp2-weight_measure = '0.4'.
    temp2-weight_unit = `KG`.
    temp2-name = `Hurricane GX/LN`.
    temp2-currency_code = `EUR`.
    temp2-price = '139.99'.
    temp2-width = '22'.
    temp2-depth = '35'.
    temp2-height = '17'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1080`.
    temp2-supplier_name = `Printer for All`.
    temp2-weight_measure = '2.3'.
    temp2-weight_unit = `KG`.
    temp2-name = `Photo Scan`.
    temp2-currency_code = `EUR`.
    temp2-price = '129'.
    temp2-width = '34'.
    temp2-depth = '48'.
    temp2-height = '5'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1081`.
    temp2-supplier_name = `Printer for All`.
    temp2-weight_measure = '2.4'.
    temp2-weight_unit = `KG`.
    temp2-name = `Power Scan`.
    temp2-currency_code = `EUR`.
    temp2-price = '89'.
    temp2-width = '31'.
    temp2-depth = '43'.
    temp2-height = '7'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1082`.
    temp2-supplier_name = `Printer for All`.
    temp2-weight_measure = '3.2'.
    temp2-weight_unit = `KG`.
    temp2-name = `Jet Scan Professional`.
    temp2-currency_code = `EUR`.
    temp2-price = '169'.
    temp2-width = '33'.
    temp2-depth = '41'.
    temp2-height = '12'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1083`.
    temp2-supplier_name = `Printer for All`.
    temp2-weight_measure = '3.2'.
    temp2-weight_unit = `KG`.
    temp2-name = `Jet Scan Professional`.
    temp2-currency_code = `EUR`.
    temp2-price = '189'.
    temp2-width = '35'.
    temp2-depth = '40'.
    temp2-height = '10'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1085`.
    temp2-supplier_name = `Alpha Printers`.
    temp2-weight_measure = '23.2'.
    temp2-weight_unit = `KG`.
    temp2-name = `Copymaster`.
    temp2-currency_code = `EUR`.
    temp2-price = '1499'.
    temp2-width = '45'.
    temp2-depth = '42'.
    temp2-height = '22'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1090`.
    temp2-supplier_name = `Speaker Experts`.
    temp2-weight_measure = '3'.
    temp2-weight_unit = `KG`.
    temp2-name = `Surround Sound`.
    temp2-currency_code = `EUR`.
    temp2-price = '39'.
    temp2-width = '12'.
    temp2-depth = '10'.
    temp2-height = '16'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1091`.
    temp2-supplier_name = `Speaker Experts`.
    temp2-weight_measure = '1.4'.
    temp2-weight_unit = `KG`.
    temp2-name = `Blaster Extreme`.
    temp2-currency_code = `EUR`.
    temp2-price = '26'.
    temp2-width = '13'.
    temp2-depth = '11'.
    temp2-height = '17.5'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1092`.
    temp2-supplier_name = `Speaker Experts`.
    temp2-weight_measure = '2.1'.
    temp2-weight_unit = `KG`.
    temp2-name = `Sound Booster`.
    temp2-currency_code = `EUR`.
    temp2-price = '45'.
    temp2-width = '12.4'.
    temp2-depth = '10.4'.
    temp2-height = '18.1'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1100`.
    temp2-supplier_name = `Technocom`.
    temp2-weight_measure = '1.2'.
    temp2-weight_unit = `KG`.
    temp2-name = `Smart Office`.
    temp2-currency_code = `EUR`.
    temp2-price = '89.9'.
    temp2-width = '15'.
    temp2-depth = '6.5'.
    temp2-height = '2.1'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1101`.
    temp2-supplier_name = `Technocom`.
    temp2-weight_measure = '0.8'.
    temp2-weight_unit = `KG`.
    temp2-name = `Smart Design`.
    temp2-currency_code = `EUR`.
    temp2-price = '79.9'.
    temp2-width = '14'.
    temp2-depth = '6.7'.
    temp2-height = '24'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1102`.
    temp2-supplier_name = `Technocom`.
    temp2-weight_measure = '0.8'.
    temp2-weight_unit = `KG`.
    temp2-name = `Smart Network`.
    temp2-currency_code = `EUR`.
    temp2-price = '69'.
    temp2-width = '16'.
    temp2-depth = '6'.
    temp2-height = '27'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1103`.
    temp2-supplier_name = `Technocom`.
    temp2-weight_measure = '0.8'.
    temp2-weight_unit = `KG`.
    temp2-name = `Smart Multimedia`.
    temp2-currency_code = `EUR`.
    temp2-price = '77'.
    temp2-width = '11'.
    temp2-depth = '3.4'.
    temp2-height = '22'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1104`.
    temp2-supplier_name = `Technocom`.
    temp2-weight_measure = '1.1'.
    temp2-weight_unit = `KG`.
    temp2-name = `Smart Games`.
    temp2-currency_code = `EUR`.
    temp2-price = '55'.
    temp2-width = '10'.
    temp2-depth = '3'.
    temp2-height = '30'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1105`.
    temp2-supplier_name = `Brainsoft`.
    temp2-weight_measure = '0.7'.
    temp2-weight_unit = `KG`.
    temp2-name = `Smart Internet Antivirus`.
    temp2-currency_code = `EUR`.
    temp2-price = '29'.
    temp2-width = '16'.
    temp2-depth = '4'.
    temp2-height = '21'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1106`.
    temp2-supplier_name = `Brainsoft`.
    temp2-weight_measure = '0.9'.
    temp2-weight_unit = `KG`.
    temp2-name = `Smart Firewall`.
    temp2-currency_code = `EUR`.
    temp2-price = '34'.
    temp2-width = '17.9'.
    temp2-depth = '4.2'.
    temp2-height = '23.1'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1107`.
    temp2-supplier_name = `Brainsoft`.
    temp2-weight_measure = '0.5'.
    temp2-weight_unit = `KG`.
    temp2-name = `Smart Money`.
    temp2-currency_code = `EUR`.
    temp2-price = '29.9'.
    temp2-width = '12'.
    temp2-depth = '1.5'.
    temp2-height = '19'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1110`.
    temp2-supplier_name = `Red Point Stores`.
    temp2-weight_measure = '0.03'.
    temp2-weight_unit = `KG`.
    temp2-name = `PC Lock`.
    temp2-currency_code = `EUR`.
    temp2-price = '8.9'.
    temp2-width = '20'.
    temp2-depth = '8'.
    temp2-height = '4.3'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1111`.
    temp2-supplier_name = `Red Point Stores`.
    temp2-weight_measure = '0.02'.
    temp2-weight_unit = `KG`.
    temp2-name = `Notebook Lock`.
    temp2-currency_code = `EUR`.
    temp2-price = '6.9'.
    temp2-width = '31'.
    temp2-depth = '9'.
    temp2-height = '7'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1112`.
    temp2-supplier_name = `Red Point Stores`.
    temp2-weight_measure = '0.075'.
    temp2-weight_unit = `KG`.
    temp2-name = `Web cam reality`.
    temp2-currency_code = `EUR`.
    temp2-price = '39'.
    temp2-width = '9'.
    temp2-depth = '8.2'.
    temp2-height = '1.3'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1113`.
    temp2-supplier_name = `Red Point Stores`.
    temp2-weight_measure = '0.05'.
    temp2-weight_unit = `KG`.
    temp2-name = `Screen clean`.
    temp2-currency_code = `EUR`.
    temp2-price = '2.3'.
    temp2-width = '2'.
    temp2-depth = '2'.
    temp2-height = '0.1'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1114`.
    temp2-supplier_name = `Red Point Stores`.
    temp2-weight_measure = '1.8'.
    temp2-weight_unit = `KG`.
    temp2-name = `Fabric bag professional`.
    temp2-currency_code = `EUR`.
    temp2-price = '31'.
    temp2-width = '42'.
    temp2-depth = '32'.
    temp2-height = '7'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1115`.
    temp2-supplier_name = `Red Point Stores`.
    temp2-weight_measure = '0.45'.
    temp2-weight_unit = `KG`.
    temp2-name = `Wireless DSL Router`.
    temp2-currency_code = `EUR`.
    temp2-price = '49'.
    temp2-width = '19.3'.
    temp2-depth = '18'.
    temp2-height = '5'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1116`.
    temp2-supplier_name = `Red Point Stores`.
    temp2-weight_measure = '0.45'.
    temp2-weight_unit = `KG`.
    temp2-name = `Wireless DSL Router / Repeater`.
    temp2-currency_code = `EUR`.
    temp2-price = '59'.
    temp2-width = '19.3'.
    temp2-depth = '18'.
    temp2-height = '5'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1117`.
    temp2-supplier_name = `Technocom`.
    temp2-weight_measure = '0.45'.
    temp2-weight_unit = `KG`.
    temp2-name = `Wireless DSL Router / Repeater and Print Server`.
    temp2-currency_code = `EUR`.
    temp2-price = '69'.
    temp2-width = '19.3'.
    temp2-depth = '18'.
    temp2-height = '5'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1118`.
    temp2-supplier_name = `Technocom`.
    temp2-weight_measure = '0.015'.
    temp2-weight_unit = `KG`.
    temp2-name = `USB Stick`.
    temp2-currency_code = `EUR`.
    temp2-price = '35'.
    temp2-width = '1.5'.
    temp2-depth = '8.7'.
    temp2-height = '1.2'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1120`.
    temp2-supplier_name = `Technocom`.
    temp2-weight_measure = '1'.
    temp2-weight_unit = `KG`.
    temp2-name = `Cordless Bluetooth Keyboard, english international`.
    temp2-currency_code = `EUR`.
    temp2-price = '29'.
    temp2-width = '51.4'.
    temp2-depth = '23'.
    temp2-height = '4'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1137`.
    temp2-supplier_name = `Technocom`.
    temp2-weight_measure = '18'.
    temp2-weight_unit = `KG`.
    temp2-name = `Flat XXL`.
    temp2-currency_code = `EUR`.
    temp2-price = '1430'.
    temp2-width = '54'.
    temp2-depth = '22'.
    temp2-height = '38'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1138`.
    temp2-supplier_name = `Technocom`.
    temp2-weight_measure = '0.02'.
    temp2-weight_unit = `KG`.
    temp2-name = `Pocket Mouse`.
    temp2-currency_code = `EUR`.
    temp2-price = '23'.
    temp2-width = '0.3'.
    temp2-depth = '0.5'.
    temp2-height = '1'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1210`.
    temp2-supplier_name = `Technocom`.
    temp2-weight_measure = '2.3'.
    temp2-weight_unit = `KG`.
    temp2-name = `PC Power Station`.
    temp2-currency_code = `EUR`.
    temp2-price = '2399'.
    temp2-width = '28'.
    temp2-depth = '31'.
    temp2-height = '43'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1500`.
    temp2-supplier_name = `Technocom`.
    temp2-weight_measure = '18'.
    temp2-weight_unit = `KG`.
    temp2-name = `Server Basic`.
    temp2-currency_code = `EUR`.
    temp2-price = '5000'.
    temp2-width = '34'.
    temp2-depth = '35'.
    temp2-height = '23'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1501`.
    temp2-supplier_name = `Technocom`.
    temp2-weight_measure = '25'.
    temp2-weight_unit = `KG`.
    temp2-name = `Server Professional`.
    temp2-currency_code = `EUR`.
    temp2-price = '15000'.
    temp2-width = '29'.
    temp2-depth = '30'.
    temp2-height = '27'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1502`.
    temp2-supplier_name = `Technocom`.
    temp2-weight_measure = '35'.
    temp2-weight_unit = `KG`.
    temp2-name = `Server Power Pro`.
    temp2-currency_code = `EUR`.
    temp2-price = '25000'.
    temp2-width = '22'.
    temp2-depth = '27.3'.
    temp2-height = '37'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-6130`.
    temp2-supplier_name = `Very Best Screens`.
    temp2-weight_measure = '2.6'.
    temp2-weight_unit = `KG`.
    temp2-name = `Flat Watch HD32`.
    temp2-currency_code = `EUR`.
    temp2-price = '1459'.
    temp2-width = '78'.
    temp2-depth = '22.1'.
    temp2-height = '55'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-6131`.
    temp2-supplier_name = `Very Best Screens`.
    temp2-weight_measure = '2.2'.
    temp2-weight_unit = `KG`.
    temp2-name = `Flat Watch HD37`.
    temp2-currency_code = `EUR`.
    temp2-price = '1199'.
    temp2-width = '99.1'.
    temp2-depth = '26'.
    temp2-height = '61'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-6132`.
    temp2-supplier_name = `Very Best Screens`.
    temp2-weight_measure = '1.8'.
    temp2-weight_unit = `KG`.
    temp2-name = `Flat Watch HD41`.
    temp2-currency_code = `EUR`.
    temp2-price = '899'.
    temp2-width = '128'.
    temp2-depth = '23'.
    temp2-height = '79.1'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-7030`.
    temp2-supplier_name = `Fasttech`.
    temp2-weight_measure = '0.5'.
    temp2-weight_unit = `KG`.
    temp2-name = `Platinberry`.
    temp2-currency_code = `EUR`.
    temp2-price = '549'.
    temp2-width = '8.1'.
    temp2-depth = '13'.
    temp2-height = '12.1'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-7020`.
    temp2-supplier_name = `Fasttech`.
    temp2-weight_measure = '0.5'.
    temp2-weight_unit = `KG`.
    temp2-name = `Goldberry`.
    temp2-currency_code = `EUR`.
    temp2-price = '549'.
    temp2-width = '8.1'.
    temp2-depth = '13'.
    temp2-height = '12.1'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-7010`.
    temp2-supplier_name = `Fasttech`.
    temp2-weight_measure = '0.5'.
    temp2-weight_unit = `KG`.
    temp2-name = `Silverberry`.
    temp2-currency_code = `EUR`.
    temp2-price = '549'.
    temp2-width = '8.1'.
    temp2-depth = '13'.
    temp2-height = '12.1'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-7000`.
    temp2-supplier_name = `Fasttech`.
    temp2-weight_measure = '0.5'.
    temp2-weight_unit = `KG`.
    temp2-name = `Copperberry`.
    temp2-currency_code = `EUR`.
    temp2-price = '549'.
    temp2-width = '8.1'.
    temp2-depth = '13'.
    temp2-height = '12.1'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1095`.
    temp2-supplier_name = `Fasttech`.
    temp2-weight_measure = '80'.
    temp2-weight_unit = `G`.
    temp2-name = `Lovely Sound 5.1 Wireless`.
    temp2-currency_code = `EUR`.
    temp2-price = '49'.
    temp2-width = '24'.
    temp2-depth = '19'.
    temp2-height = '23'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1096`.
    temp2-supplier_name = `Fasttech`.
    temp2-weight_measure = '130'.
    temp2-weight_unit = `G`.
    temp2-name = `Lovely Sound 5.1`.
    temp2-currency_code = `EUR`.
    temp2-price = '39'.
    temp2-width = '25'.
    temp2-depth = '17'.
    temp2-height = '19'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1097`.
    temp2-supplier_name = `Fasttech`.
    temp2-weight_measure = '60'.
    temp2-weight_unit = `G`.
    temp2-name = `Lovely Sound Stereo`.
    temp2-currency_code = `EUR`.
    temp2-price = '29'.
    temp2-width = '21.3'.
    temp2-depth = '2.4'.
    temp2-height = '19.7'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-6123`.
    temp2-supplier_name = `Fasttech`.
    temp2-weight_measure = '267'.
    temp2-weight_unit = `G`.
    temp2-name = `Power Pro Player 80`.
    temp2-currency_code = `EUR`.
    temp2-price = '299'.
    temp2-width = '4'.
    temp2-depth = '6'.
    temp2-height = '0.8'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-6122`.
    temp2-supplier_name = `Fasttech`.
    temp2-weight_measure = '266'.
    temp2-weight_unit = `G`.
    temp2-name = `Power Pro Player 40`.
    temp2-currency_code = `EUR`.
    temp2-price = '167'.
    temp2-width = '5.1'.
    temp2-depth = '8'.
    temp2-height = '9.2'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-6121`.
    temp2-supplier_name = `Fasttech`.
    temp2-weight_measure = '134'.
    temp2-weight_unit = `G`.
    temp2-name = `ITelo Jog-Mate`.
    temp2-currency_code = `EUR`.
    temp2-price = '63'.
    temp2-width = '5.1'.
    temp2-depth = '8'.
    temp2-height = '9.2'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-6120`.
    temp2-supplier_name = `Fasttech`.
    temp2-weight_measure = '134'.
    temp2-weight_unit = `G`.
    temp2-name = `ITelo MusicStick`.
    temp2-currency_code = `EUR`.
    temp2-price = '45'.
    temp2-width = '1.5'.
    temp2-depth = '6'.
    temp2-height = '1'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-6111`.
    temp2-supplier_name = `Fasttech`.
    temp2-weight_measure = '3.1'.
    temp2-weight_unit = `KG`.
    temp2-name = `Record Movie`.
    temp2-currency_code = `EUR`.
    temp2-price = '288'.
    temp2-width = '38'.
    temp2-depth = '26'.
    temp2-height = '6.2'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-6110`.
    temp2-supplier_name = `Fasttech`.
    temp2-weight_measure = '2.4'.
    temp2-weight_unit = `KG`.
    temp2-name = `Play Movie`.
    temp2-currency_code = `EUR`.
    temp2-price = '130'.
    temp2-width = '37'.
    temp2-depth = '24'.
    temp2-height = '6'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-6102`.
    temp2-supplier_name = `Technocom`.
    temp2-weight_measure = '2.5'.
    temp2-weight_unit = `KG`.
    temp2-name = `Beam Breaker B-3`.
    temp2-currency_code = `EUR`.
    temp2-price = '889'.
    temp2-width = '30.4'.
    temp2-depth = '23.1'.
    temp2-height = '23'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-6101`.
    temp2-supplier_name = `Technocom`.
    temp2-weight_measure = '2'.
    temp2-weight_unit = `KG`.
    temp2-name = `Beam Breaker B-2`.
    temp2-currency_code = `EUR`.
    temp2-price = '679'.
    temp2-width = '30.4'.
    temp2-depth = '23.1'.
    temp2-height = '23'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-2002`.
    temp2-supplier_name = `Technocom`.
    temp2-weight_measure = '0.72'.
    temp2-weight_unit = `KG`.
    temp2-name = `Portable DVD Player with 9" LCD Monitor`.
    temp2-currency_code = `EUR`.
    temp2-price = '853.99'.
    temp2-width = '21'.
    temp2-depth = '16.5'.
    temp2-height = '14'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-6100`.
    temp2-supplier_name = `Titanium`.
    temp2-weight_measure = '1.7'.
    temp2-weight_unit = `KG`.
    temp2-name = `Beam Breaker B-1`.
    temp2-currency_code = `EUR`.
    temp2-price = '469'.
    temp2-width = '30.4'.
    temp2-depth = '23.1'.
    temp2-height = '23'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-2027`.
    temp2-supplier_name = `Titanium`.
    temp2-weight_measure = '0.15'.
    temp2-weight_unit = `KG`.
    temp2-name = `Removable CD/DVD Laser Labels`.
    temp2-currency_code = `EUR`.
    temp2-price = '8.99'.
    temp2-width = '5.5'.
    temp2-depth = '2'.
    temp2-height = '2'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-2026`.
    temp2-supplier_name = `Titanium`.
    temp2-weight_measure = '0.2'.
    temp2-weight_unit = `KG`.
    temp2-name = `Audio/Video Cable Kit - 4m`.
    temp2-currency_code = `EUR`.
    temp2-price = '29.99'.
    temp2-width = '21'.
    temp2-depth = '10.2'.
    temp2-height = '13'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-2025`.
    temp2-supplier_name = `Titanium`.
    temp2-weight_measure = '0.65'.
    temp2-weight_unit = `KG`.
    temp2-name = `CD/DVD case: 264 sleeves`.
    temp2-currency_code = `EUR`.
    temp2-price = '44.99'.
    temp2-width = '13'.
    temp2-depth = '13'.
    temp2-height = '20'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-2001`.
    temp2-supplier_name = `Titanium`.
    temp2-weight_measure = '0.84'.
    temp2-weight_unit = `KG`.
    temp2-name = `10" Portable DVD player`.
    temp2-currency_code = `EUR`.
    temp2-price = '449.99'.
    temp2-width = '24'.
    temp2-depth = '19.5'.
    temp2-height = '29'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-2000`.
    temp2-supplier_name = `Titanium`.
    temp2-weight_measure = '0.79'.
    temp2-weight_unit = `KG`.
    temp2-name = `7" Widescreen Portable DVD Player w MP3`.
    temp2-currency_code = `EUR`.
    temp2-price = '249.99'.
    temp2-width = '21.4'.
    temp2-depth = '19'.
    temp2-height = '27.6'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1603`.
    temp2-supplier_name = `Titanium`.
    temp2-weight_measure = '6.8'.
    temp2-weight_unit = `KG`.
    temp2-name = `Gaming Monster Pro`.
    temp2-currency_code = `EUR`.
    temp2-price = '1700'.
    temp2-width = '27'.
    temp2-depth = '28'.
    temp2-height = '42'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1602`.
    temp2-supplier_name = `Titanium`.
    temp2-weight_measure = '5.9'.
    temp2-weight_unit = `KG`.
    temp2-name = `Gaming Monster`.
    temp2-currency_code = `EUR`.
    temp2-price = '1200'.
    temp2-width = '26.5'.
    temp2-depth = '34'.
    temp2-height = '47'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1601`.
    temp2-supplier_name = `Titanium`.
    temp2-weight_measure = '5.3'.
    temp2-weight_unit = `KG`.
    temp2-name = `Family PC Pro`.
    temp2-currency_code = `EUR`.
    temp2-price = '900'.
    temp2-width = '25'.
    temp2-depth = '31.7'.
    temp2-height = '40.2'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1600`.
    temp2-supplier_name = `Titanium`.
    temp2-weight_measure = '4.8'.
    temp2-weight_unit = `KG`.
    temp2-name = `Family PC Basic`.
    temp2-currency_code = `EUR`.
    temp2-price = '600'.
    temp2-width = '21.4'.
    temp2-depth = '29'.
    temp2-height = '38'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1119`.
    temp2-supplier_name = `Titanium`.
    temp2-weight_measure = '88'.
    temp2-weight_unit = `G`.
    temp2-name = `Travel Adapter`.
    temp2-currency_code = `EUR`.
    temp2-price = '79'.
    temp2-width = '2'.
    temp2-depth = '3.1'.
    temp2-height = '3.9'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-8000`.
    temp2-supplier_name = `Titanium`.
    temp2-weight_measure = '4'.
    temp2-weight_unit = `KG`.
    temp2-name = `ITelO FlexTop I4000`.
    temp2-currency_code = `EUR`.
    temp2-price = '799'.
    temp2-width = '31'.
    temp2-depth = '19'.
    temp2-height = '3.1'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-8001`.
    temp2-supplier_name = `Titanium`.
    temp2-weight_measure = '4.2'.
    temp2-weight_unit = `KG`.
    temp2-name = `ITelO FlexTop I6300c`.
    temp2-currency_code = `EUR`.
    temp2-price = '799'.
    temp2-width = '32'.
    temp2-depth = '20'.
    temp2-height = '3.4'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-8002`.
    temp2-supplier_name = `Titanium`.
    temp2-weight_measure = '3.5'.
    temp2-weight_unit = `KG`.
    temp2-name = `ITelO FlexTop I9100`.
    temp2-currency_code = `EUR`.
    temp2-price = '1199'.
    temp2-width = '38'.
    temp2-depth = '21'.
    temp2-height = '4.1'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-8003`.
    temp2-supplier_name = `Titanium`.
    temp2-weight_measure = '3.8'.
    temp2-weight_unit = `KG`.
    temp2-name = `ITelO FlexTop I9800`.
    temp2-currency_code = `EUR`.
    temp2-price = '1388'.
    temp2-width = '48'.
    temp2-depth = '31'.
    temp2-height = '4.5'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `PF-1000`.
    temp2-supplier_name = `Titanium`.
    temp2-weight_measure = '0.01'.
    temp2-weight_unit = `KG`.
    temp2-name = `Flyer`.
    temp2-currency_code = `EUR`.
    temp2-price = '0'.
    temp2-width = '46'.
    temp2-depth = '30'.
    temp2-height = '3'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-9999`.
    temp2-supplier_name = `Titanium`.
    temp2-weight_measure = '3.8'.
    temp2-weight_unit = `KG`.
    temp2-name = `Maxi Tablet`.
    temp2-currency_code = `EUR`.
    temp2-price = '749'.
    temp2-width = '48'.
    temp2-depth = '31'.
    temp2-height = '4.5'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-9998`.
    temp2-supplier_name = `Titanium`.
    temp2-weight_measure = '0.75'.
    temp2-weight_unit = `KG`.
    temp2-name = `Smartphone Beta`.
    temp2-currency_code = `EUR`.
    temp2-price = '30'.
    temp2-width = '48'.
    temp2-depth = '31'.
    temp2-height = '4.5'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-9997`.
    temp2-supplier_name = `Titanium`.
    temp2-weight_measure = '3.8'.
    temp2-weight_unit = `KG`.
    temp2-name = `e-Book Reader ReadMe`.
    temp2-currency_code = `EUR`.
    temp2-price = '33'.
    temp2-width = '48'.
    temp2-depth = '31'.
    temp2-height = '4.5'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-9996`.
    temp2-supplier_name = `Titanium`.
    temp2-weight_measure = '0.03'.
    temp2-weight_unit = `KG`.
    temp2-name = `Tablet Pouch`.
    temp2-currency_code = `EUR`.
    temp2-price = '20'.
    temp2-width = '25'.
    temp2-depth = '40'.
    temp2-height = '4.5'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-9995`.
    temp2-supplier_name = `Titanium`.
    temp2-weight_measure = '0.02'.
    temp2-weight_unit = `KG`.
    temp2-name = `Smartphone Cover`.
    temp2-currency_code = `EUR`.
    temp2-price = '15'.
    temp2-width = '48'.
    temp2-depth = '31'.
    temp2-height = '4.5'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-9994`.
    temp2-supplier_name = `Ultrasonic United`.
    temp2-weight_measure = '3.8'.
    temp2-weight_unit = `KG`.
    temp2-name = `Camcorder View`.
    temp2-currency_code = `EUR`.
    temp2-price = '1388'.
    temp2-width = '48'.
    temp2-depth = '31'.
    temp2-height = '27'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-9993`.
    temp2-supplier_name = `Ultrasonic United`.
    temp2-weight_measure = '3.8'.
    temp2-weight_unit = `KG`.
    temp2-name = `Mini Tablet`.
    temp2-currency_code = `EUR`.
    temp2-price = '833'.
    temp2-width = '48'.
    temp2-depth = '31'.
    temp2-height = '4.5'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-9992`.
    temp2-supplier_name = `Ultrasonic United`.
    temp2-weight_measure = '0.75'.
    temp2-weight_unit = `KG`.
    temp2-name = `Smartphone Alpha`.
    temp2-currency_code = `EUR`.
    temp2-price = '599'.
    temp2-width = '48'.
    temp2-depth = '31'.
    temp2-height = '4.5'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-9991`.
    temp2-supplier_name = `Ultrasonic United`.
    temp2-weight_measure = '0.02'.
    temp2-weight_unit = `KG`.
    temp2-name = `Smartphone Leather Case`.
    temp2-currency_code = `EUR`.
    temp2-price = '25'.
    temp2-width = '48'.
    temp2-depth = '31'.
    temp2-height = '4.5'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1251`.
    temp2-supplier_name = `Ultrasonic United`.
    temp2-weight_measure = '4.2'.
    temp2-weight_unit = `KG`.
    temp2-name = `Astro Laptop 1516`.
    temp2-currency_code = `EUR`.
    temp2-price = '989'.
    temp2-width = '30'.
    temp2-depth = '18'.
    temp2-height = '3'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1252`.
    temp2-supplier_name = `Ultrasonic United`.
    temp2-weight_measure = '0.75'.
    temp2-weight_unit = `KG`.
    temp2-name = `Astro Phone 6`.
    temp2-currency_code = `EUR`.
    temp2-price = '649'.
    temp2-width = '8'.
    temp2-depth = '6'.
    temp2-height = '1.5'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1253`.
    temp2-supplier_name = `Ultrasonic United`.
    temp2-weight_measure = '4.2'.
    temp2-weight_unit = `KG`.
    temp2-name = `Benda Laptop 1408`.
    temp2-currency_code = `EUR`.
    temp2-price = '976'.
    temp2-width = '30'.
    temp2-depth = '18'.
    temp2-height = '3'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1254`.
    temp2-supplier_name = `Ultrasonic United`.
    temp2-weight_measure = '15'.
    temp2-weight_unit = `KG`.
    temp2-name = `Bending Screen 21HD`.
    temp2-currency_code = `EUR`.
    temp2-price = '250'.
    temp2-width = '37'.
    temp2-depth = '12'.
    temp2-height = '36'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1255`.
    temp2-supplier_name = `Ultrasonic United`.
    temp2-weight_measure = '16'.
    temp2-weight_unit = `KG`.
    temp2-name = `Broad Screen 22HD`.
    temp2-currency_code = `EUR`.
    temp2-price = '270'.
    temp2-width = '39'.
    temp2-depth = '12'.
    temp2-height = '38'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1256`.
    temp2-supplier_name = `Ultrasonic United`.
    temp2-weight_measure = '0.75'.
    temp2-weight_unit = `KG`.
    temp2-name = `Cerdik Phone 7`.
    temp2-currency_code = `EUR`.
    temp2-price = '549'.
    temp2-width = '9'.
    temp2-depth = '15'.
    temp2-height = '1.5'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1257`.
    temp2-supplier_name = `Ultrasonic United`.
    temp2-weight_measure = '2.8'.
    temp2-weight_unit = `KG`.
    temp2-name = `Cepat Tablet 10.5`.
    temp2-currency_code = `EUR`.
    temp2-price = '549'.
    temp2-width = '48'.
    temp2-depth = '31'.
    temp2-height = '4.5'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1258`.
    temp2-supplier_name = `Ultrasonic United`.
    temp2-weight_measure = '2.5'.
    temp2-weight_unit = `KG`.
    temp2-name = `Cepat Tablet 8`.
    temp2-currency_code = `EUR`.
    temp2-price = '529'.
    temp2-width = '38'.
    temp2-depth = '21'.
    temp2-height = '3.5'.
    temp2-dim_unit = `cm`.
    INSERT temp2 INTO TABLE temp1.
    t_products = temp1.


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
        temp4 = `None`.
      ELSEIF weight_kg < 1.
        temp4 = `Success`.
      ELSEIF weight_kg < 5.
        temp4 = `Warning`.
      ELSE.
        temp4 = `Error`.
      ENDIF.
      lr_product->weight_state = temp4.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
