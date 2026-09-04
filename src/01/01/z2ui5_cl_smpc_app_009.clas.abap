" @keywords column sap.m allows define specific properties table overflowtoolbar title toolbarspacer combobox item
" @summary The table shares many features with the list and, in addition, introduces columns. The table is fully responsive and can hide columns or shown them in-place if the screen space is not sufficient.
CLASS z2ui5_cl_smpc_app_009 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        product_id     TYPE string,
        name           TYPE string,
        supplier_name  TYPE string,
        weight_measure TYPE p LENGTH 8 DECIMALS 3,
        weight_unit    TYPE string,
        weight_state   TYPE string,
        price          TYPE p LENGTH 8 DECIMALS 2,
        currency_code  TYPE string,
        width          TYPE p LENGTH 4 DECIMALS 1,
        depth          TYPE p LENGTH 4 DECIMALS 1,
        height         TYPE p LENGTH 4 DECIMALS 1,
        dim_unit       TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.
    DATA t_sticky TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
    DATA popin_key TYPE string.
    DATA toggle_pressed TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_009 IMPLEMENTATION.

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
    DATA temp2 TYPE string_table.
    DATA temp3 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `${$source>/text}` INTO TABLE temp1.
    INSERT `${$parameters>/selected}` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `${$source>/text}` INTO TABLE temp2.
    INSERT `${$parameters>/selected}` INTO TABLE temp2.
    
    CLEAR temp3.
    INSERT `${$source>/text}` INTO TABLE temp3.
    INSERT `${$parameters>/selected}` INTO TABLE temp3.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core`   v = `sap.ui.core`

        " sticky + popinLayout are set imperatively by the original controller (onSelect / onPopinLayoutChanged) - bound properties here
        )->ele( `Table`
            )->a( n = `id`          v = `idProductsTable`
            )->a( n = `inset`       v = `false`
            )->a( n = `items`       v = |\{ path: '{ client->_bind_path( t_products ) }', sorter: \{ path: 'NAME' \} \}|
            )->a( n = `sticky`      v = client->_bind( t_sticky )
            )->a( n = `popinLayout` v = |\{= ${ client->_bind( popin_key ) } === 'GridLarge' \|\| ${ client->_bind( popin_key ) } === 'GridSmall' ? ${ client->_bind( popin_key ) } : 'Block' \}|

            )->ele( `headerToolbar`
                )->ele( `OverflowToolbar`
                    )->ele( `content`
                        )->tag( `Title`
                            )->a( n = `text`  v = `Products`
                            )->a( n = `level` v = `H2`
                        )->tag( `ToolbarSpacer`

                        " the original change handler's PopinLayout switch lives in the Table's popinLayout expression binding
                        )->ele( `ComboBox`
                            )->a( n = `id`          v = `idPopinLayout`
                            )->a( n = `placeholder` v = `Popin layout options`
                            )->a( n = `selectedKey` v = client->_bind( popin_key )

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
                        )->tag( `Label`
                            )->a( n = `text` v = `Sticky options:`
                        )->tag( `CheckBox`
                            )->a( n = `text`   v = `ColumnHeaders`
                            )->a( n = `select` v = client->_event( val   = `STICKY_SELECT`
                                                                   t_arg = temp1 )
                        )->tag( `CheckBox`
                            )->a( n = `text`   v = `HeaderToolbar`
                            )->a( n = `select` v = client->_event( val   = `STICKY_SELECT`
                                                                   t_arg = temp2 )
                        )->tag( `CheckBox`
                            )->a( n = `text`   v = `InfoToolbar`
                            )->a( n = `select` v = client->_event( val   = `STICKY_SELECT`
                                                                   t_arg = temp3 )
                        " the original press handler (infoToolbar.setVisible(!pressed)) is the visible expression binding on the infoToolbar below
                        )->tag( `ToggleButton`
                            )->a( n = `id`      v = `toggleInfoToolbar`
                            )->a( n = `text`    v = `Hide/Show InfoToolbar`
                            )->a( n = `pressed` v = client->_bind( toggle_pressed )

                    )->end(
                )->end(
            )->end(
            )->ele( `infoToolbar`
                )->ele( `OverflowToolbar`
                    )->a( n = `visible` v = |\{= !${ client->_bind( toggle_pressed ) } \}|

                    )->tag( `Label`
                        )->a( n = `text` v = `Wide range of available products`

                )->end(
            )->end(
            )->ele( `columns`
                )->ele( `Column`
                    )->a( n = `width` v = `12em`

                    " p:ColumnAIAction dependents dropped - plugin class newer than 1.71, see DROPPED_171 (as app 022)
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

    DATA selected TYPE abap_bool.
      DATA sticky_text TYPE string.

    IF client->get_event( ) = `STICKY_SELECT`.
      
      sticky_text = client->get_event_arg( ).
      selected = client->get_event_arg( 2 ).
      IF selected = abap_true.
        INSERT sticky_text INTO TABLE t_sticky.
      ELSE.
        DELETE t_sticky WHERE table_line = sticky_text.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " the shared mock /ProductCollection flattened to the bound columns, all 123 rows kept verbatim (see the model-flattening NOTE)
    DATA temp3 LIKE t_products.
    DATA temp4 LIKE LINE OF temp3.
    DATA temp5 LIKE LINE OF t_products.
    DATA lr_product LIKE REF TO temp5.
      DATA weight_kg LIKE lr_product->weight_measure.
      DATA temp6 TYPE z2ui5_cl_smpc_app_009=>ty_s_product-weight_state.
    CLEAR temp3.
    
    temp4-product_id = `HT-1000`.
    temp4-name = `Notebook Basic 15`.
    temp4-supplier_name = `Very Best Screens`.
    temp4-weight_measure = '4.2'.
    temp4-weight_unit = `KG`.
    temp4-price = '956'.
    temp4-currency_code = `EUR`.
    temp4-width = '30'.
    temp4-depth = '18'.
    temp4-height = '3'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1001`.
    temp4-name = `Notebook Basic 17`.
    temp4-supplier_name = `Very Best Screens`.
    temp4-weight_measure = '4.5'.
    temp4-weight_unit = `KG`.
    temp4-price = '1249'.
    temp4-currency_code = `EUR`.
    temp4-width = '29'.
    temp4-depth = '17'.
    temp4-height = '3.1'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1002`.
    temp4-name = `Notebook Basic 18`.
    temp4-supplier_name = `Very Best Screens`.
    temp4-weight_measure = '4.2'.
    temp4-weight_unit = `KG`.
    temp4-price = '1570'.
    temp4-currency_code = `EUR`.
    temp4-width = '28'.
    temp4-depth = '19'.
    temp4-height = '2.5'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1003`.
    temp4-name = `Notebook Basic 19`.
    temp4-supplier_name = `Smartcards`.
    temp4-weight_measure = '4.2'.
    temp4-weight_unit = `KG`.
    temp4-price = '1650'.
    temp4-currency_code = `EUR`.
    temp4-width = '32'.
    temp4-depth = '21'.
    temp4-height = '4'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1007`.
    temp4-name = `ITelO Vault`.
    temp4-supplier_name = `Technocom`.
    temp4-weight_measure = '0.2'.
    temp4-weight_unit = `KG`.
    temp4-price = '299'.
    temp4-currency_code = `EUR`.
    temp4-width = '32'.
    temp4-depth = '22'.
    temp4-height = '3'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1010`.
    temp4-name = `Notebook Professional 15`.
    temp4-supplier_name = `Very Best Screens`.
    temp4-weight_measure = '4.3'.
    temp4-weight_unit = `KG`.
    temp4-price = '1999'.
    temp4-currency_code = `EUR`.
    temp4-width = '33'.
    temp4-depth = '20'.
    temp4-height = '3'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1011`.
    temp4-name = `Notebook Professional 17`.
    temp4-supplier_name = `Very Best Screens`.
    temp4-weight_measure = '4.1'.
    temp4-weight_unit = `KG`.
    temp4-price = '2299'.
    temp4-currency_code = `EUR`.
    temp4-width = '33'.
    temp4-depth = '23'.
    temp4-height = '2'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1020`.
    temp4-name = `ITelO Vault Net`.
    temp4-supplier_name = `Technocom`.
    temp4-weight_measure = '0.16'.
    temp4-weight_unit = `KG`.
    temp4-price = '459'.
    temp4-currency_code = `EUR`.
    temp4-width = '10'.
    temp4-depth = '1.8'.
    temp4-height = '17'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1021`.
    temp4-name = `ITelO Vault SAT`.
    temp4-supplier_name = `Technocom`.
    temp4-weight_measure = '0.18'.
    temp4-weight_unit = `KG`.
    temp4-price = '149'.
    temp4-currency_code = `EUR`.
    temp4-width = '11'.
    temp4-depth = '1.7'.
    temp4-height = '18'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1022`.
    temp4-name = `Comfort Easy`.
    temp4-supplier_name = `Technocom`.
    temp4-weight_measure = '0.2'.
    temp4-weight_unit = `KG`.
    temp4-price = '1679'.
    temp4-currency_code = `EUR`.
    temp4-width = '84'.
    temp4-depth = '1.5'.
    temp4-height = '14'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1023`.
    temp4-name = `Comfort Senior`.
    temp4-supplier_name = `Technocom`.
    temp4-weight_measure = '0.8'.
    temp4-weight_unit = `KG`.
    temp4-price = '512'.
    temp4-currency_code = `EUR`.
    temp4-width = '80'.
    temp4-depth = '1.6'.
    temp4-height = '13'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1030`.
    temp4-name = `Ergo Screen E-I`.
    temp4-supplier_name = `Very Best Screens`.
    temp4-weight_measure = '21'.
    temp4-weight_unit = `KG`.
    temp4-price = '230'.
    temp4-currency_code = `EUR`.
    temp4-width = '37'.
    temp4-depth = '12'.
    temp4-height = '36'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1031`.
    temp4-name = `Ergo Screen E-II`.
    temp4-supplier_name = `Very Best Screens`.
    temp4-weight_measure = '21'.
    temp4-weight_unit = `KG`.
    temp4-price = '285'.
    temp4-currency_code = `EUR`.
    temp4-width = '40.8'.
    temp4-depth = '19'.
    temp4-height = '43'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1032`.
    temp4-name = `Ergo Screen E-III`.
    temp4-supplier_name = `Very Best Screens`.
    temp4-weight_measure = '21'.
    temp4-weight_unit = `KG`.
    temp4-price = '345'.
    temp4-currency_code = `EUR`.
    temp4-width = '40.8'.
    temp4-depth = '19'.
    temp4-height = '43'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1035`.
    temp4-name = `Flat Basic`.
    temp4-supplier_name = `Very Best Screens`.
    temp4-weight_measure = '14'.
    temp4-weight_unit = `KG`.
    temp4-price = '399'.
    temp4-currency_code = `EUR`.
    temp4-width = '39'.
    temp4-depth = '20'.
    temp4-height = '41'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1036`.
    temp4-name = `Flat Future`.
    temp4-supplier_name = `Very Best Screens`.
    temp4-weight_measure = '15'.
    temp4-weight_unit = `KG`.
    temp4-price = '430'.
    temp4-currency_code = `EUR`.
    temp4-width = '45'.
    temp4-depth = '26'.
    temp4-height = '46'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1037`.
    temp4-name = `Flat XL`.
    temp4-supplier_name = `Very Best Screens`.
    temp4-weight_measure = '17'.
    temp4-weight_unit = `KG`.
    temp4-price = '1230'.
    temp4-currency_code = `EUR`.
    temp4-width = '54.5'.
    temp4-depth = '22.1'.
    temp4-height = '39.1'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1040`.
    temp4-name = `Laser Professional Eco`.
    temp4-supplier_name = `Alpha Printers`.
    temp4-weight_measure = '32'.
    temp4-weight_unit = `KG`.
    temp4-price = '830'.
    temp4-currency_code = `EUR`.
    temp4-width = '51'.
    temp4-depth = '46'.
    temp4-height = '30'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1041`.
    temp4-name = `Laser Basic`.
    temp4-supplier_name = `Alpha Printers`.
    temp4-weight_measure = '23'.
    temp4-weight_unit = `KG`.
    temp4-price = '490'.
    temp4-currency_code = `EUR`.
    temp4-width = '48'.
    temp4-depth = '42'.
    temp4-height = '26'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1042`.
    temp4-name = `Laser Allround`.
    temp4-supplier_name = `Alpha Printers`.
    temp4-weight_measure = '17'.
    temp4-weight_unit = `KG`.
    temp4-price = '349'.
    temp4-currency_code = `EUR`.
    temp4-width = '53'.
    temp4-depth = '50'.
    temp4-height = '65'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1050`.
    temp4-name = `Ultra Jet Super Color`.
    temp4-supplier_name = `Alpha Printers`.
    temp4-weight_measure = '3'.
    temp4-weight_unit = `KG`.
    temp4-price = '139'.
    temp4-currency_code = `EUR`.
    temp4-width = '41'.
    temp4-depth = '41'.
    temp4-height = '28'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1051`.
    temp4-name = `Ultra Jet Mobile`.
    temp4-supplier_name = `Printer for All`.
    temp4-weight_measure = '1.9'.
    temp4-weight_unit = `KG`.
    temp4-price = '99'.
    temp4-currency_code = `EUR`.
    temp4-width = '46'.
    temp4-depth = '32'.
    temp4-height = '25'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1052`.
    temp4-name = `Ultra Jet Super Highspeed`.
    temp4-supplier_name = `Printer for All`.
    temp4-weight_measure = '18'.
    temp4-weight_unit = `KG`.
    temp4-price = '170'.
    temp4-currency_code = `EUR`.
    temp4-width = '41'.
    temp4-depth = '41'.
    temp4-height = '28'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1055`.
    temp4-name = `Multi Print`.
    temp4-supplier_name = `Printer for All`.
    temp4-weight_measure = '6.3'.
    temp4-weight_unit = `KG`.
    temp4-price = '99'.
    temp4-currency_code = `EUR`.
    temp4-width = '55'.
    temp4-depth = '45'.
    temp4-height = '29'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1056`.
    temp4-name = `Multi Color`.
    temp4-supplier_name = `Printer for All`.
    temp4-weight_measure = '4.3'.
    temp4-weight_unit = `KG`.
    temp4-price = '119'.
    temp4-currency_code = `EUR`.
    temp4-width = '51'.
    temp4-depth = '41.3'.
    temp4-height = '22'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1060`.
    temp4-name = `Cordless Mouse`.
    temp4-supplier_name = `Oxynum`.
    temp4-weight_measure = '0.09'.
    temp4-weight_unit = `KG`.
    temp4-price = '9'.
    temp4-currency_code = `EUR`.
    temp4-width = '6'.
    temp4-depth = '14.5'.
    temp4-height = '3.5'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1061`.
    temp4-name = `Speed Mouse`.
    temp4-supplier_name = `Oxynum`.
    temp4-weight_measure = '0.09'.
    temp4-weight_unit = `KG`.
    temp4-price = '7'.
    temp4-currency_code = `EUR`.
    temp4-width = '7'.
    temp4-depth = '15'.
    temp4-height = '3.1'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1062`.
    temp4-name = `Track Mouse`.
    temp4-supplier_name = `Oxynum`.
    temp4-weight_measure = '0.03'.
    temp4-weight_unit = `KG`.
    temp4-price = '11'.
    temp4-currency_code = `EUR`.
    temp4-width = '3'.
    temp4-depth = '7'.
    temp4-height = '4'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1063`.
    temp4-name = `Ergonomic Keyboard`.
    temp4-supplier_name = `Oxynum`.
    temp4-weight_measure = '2.1'.
    temp4-weight_unit = `KG`.
    temp4-price = '14'.
    temp4-currency_code = `EUR`.
    temp4-width = '50'.
    temp4-depth = '21'.
    temp4-height = '3.5'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1064`.
    temp4-name = `Internet Keyboard`.
    temp4-supplier_name = `Oxynum`.
    temp4-weight_measure = '1.8'.
    temp4-weight_unit = `KG`.
    temp4-price = '16'.
    temp4-currency_code = `EUR`.
    temp4-width = '52'.
    temp4-depth = '25'.
    temp4-height = '3'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1065`.
    temp4-name = `Media Keyboard`.
    temp4-supplier_name = `Oxynum`.
    temp4-weight_measure = '2.3'.
    temp4-weight_unit = `KG`.
    temp4-price = '26'.
    temp4-currency_code = `EUR`.
    temp4-width = '51.4'.
    temp4-depth = '23'.
    temp4-height = '4'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1066`.
    temp4-name = `Mousepad`.
    temp4-supplier_name = `Oxynum`.
    temp4-weight_measure = '80'.
    temp4-weight_unit = `G`.
    temp4-price = '6.99'.
    temp4-currency_code = `EUR`.
    temp4-width = '15'.
    temp4-depth = '6'.
    temp4-height = '0.2'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1067`.
    temp4-name = `Ergo Mousepad`.
    temp4-supplier_name = `Oxynum`.
    temp4-weight_measure = '80'.
    temp4-weight_unit = `G`.
    temp4-price = '8.99'.
    temp4-currency_code = `EUR`.
    temp4-width = '15'.
    temp4-depth = '6'.
    temp4-height = '0.2'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1068`.
    temp4-name = `Designer Mousepad`.
    temp4-supplier_name = `Fasttech`.
    temp4-weight_measure = '90'.
    temp4-weight_unit = `G`.
    temp4-price = '12.99'.
    temp4-currency_code = `EUR`.
    temp4-width = '24'.
    temp4-depth = '24'.
    temp4-height = '0.6'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1069`.
    temp4-name = `Universal card reader`.
    temp4-supplier_name = `Fasttech`.
    temp4-weight_measure = '45'.
    temp4-weight_unit = `G`.
    temp4-price = '14'.
    temp4-currency_code = `EUR`.
    temp4-width = '6'.
    temp4-depth = '6'.
    temp4-height = '3'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1070`.
    temp4-name = `Proctra X`.
    temp4-supplier_name = `Ultrasonic United`.
    temp4-weight_measure = '0.255'.
    temp4-weight_unit = `KG`.
    temp4-price = '70.9'.
    temp4-currency_code = `EUR`.
    temp4-width = '22'.
    temp4-depth = '35'.
    temp4-height = '17'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1071`.
    temp4-name = `Gladiator MX`.
    temp4-supplier_name = `Ultrasonic United`.
    temp4-weight_measure = '0.3'.
    temp4-weight_unit = `KG`.
    temp4-price = '81.7'.
    temp4-currency_code = `EUR`.
    temp4-width = '22'.
    temp4-depth = '35'.
    temp4-height = '17'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1072`.
    temp4-name = `Hurricane GX`.
    temp4-supplier_name = `Ultrasonic United`.
    temp4-weight_measure = '0.4'.
    temp4-weight_unit = `KG`.
    temp4-price = '101.2'.
    temp4-currency_code = `EUR`.
    temp4-width = '22'.
    temp4-depth = '35'.
    temp4-height = '17'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1073`.
    temp4-name = `Hurricane GX/LN`.
    temp4-supplier_name = `Smartcards`.
    temp4-weight_measure = '0.4'.
    temp4-weight_unit = `KG`.
    temp4-price = '139.99'.
    temp4-currency_code = `EUR`.
    temp4-width = '22'.
    temp4-depth = '35'.
    temp4-height = '17'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1080`.
    temp4-name = `Photo Scan`.
    temp4-supplier_name = `Printer for All`.
    temp4-weight_measure = '2.3'.
    temp4-weight_unit = `KG`.
    temp4-price = '129'.
    temp4-currency_code = `EUR`.
    temp4-width = '34'.
    temp4-depth = '48'.
    temp4-height = '5'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1081`.
    temp4-name = `Power Scan`.
    temp4-supplier_name = `Printer for All`.
    temp4-weight_measure = '2.4'.
    temp4-weight_unit = `KG`.
    temp4-price = '89'.
    temp4-currency_code = `EUR`.
    temp4-width = '31'.
    temp4-depth = '43'.
    temp4-height = '7'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1082`.
    temp4-name = `Jet Scan Professional`.
    temp4-supplier_name = `Printer for All`.
    temp4-weight_measure = '3.2'.
    temp4-weight_unit = `KG`.
    temp4-price = '169'.
    temp4-currency_code = `EUR`.
    temp4-width = '33'.
    temp4-depth = '41'.
    temp4-height = '12'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1083`.
    temp4-name = `Jet Scan Professional`.
    temp4-supplier_name = `Printer for All`.
    temp4-weight_measure = '3.2'.
    temp4-weight_unit = `KG`.
    temp4-price = '189'.
    temp4-currency_code = `EUR`.
    temp4-width = '35'.
    temp4-depth = '40'.
    temp4-height = '10'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1085`.
    temp4-name = `Copymaster`.
    temp4-supplier_name = `Alpha Printers`.
    temp4-weight_measure = '23.2'.
    temp4-weight_unit = `KG`.
    temp4-price = '1499'.
    temp4-currency_code = `EUR`.
    temp4-width = '45'.
    temp4-depth = '42'.
    temp4-height = '22'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1090`.
    temp4-name = `Surround Sound`.
    temp4-supplier_name = `Speaker Experts`.
    temp4-weight_measure = '3'.
    temp4-weight_unit = `KG`.
    temp4-price = '39'.
    temp4-currency_code = `EUR`.
    temp4-width = '12'.
    temp4-depth = '10'.
    temp4-height = '16'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1091`.
    temp4-name = `Blaster Extreme`.
    temp4-supplier_name = `Speaker Experts`.
    temp4-weight_measure = '1.4'.
    temp4-weight_unit = `KG`.
    temp4-price = '26'.
    temp4-currency_code = `EUR`.
    temp4-width = '13'.
    temp4-depth = '11'.
    temp4-height = '17.5'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1092`.
    temp4-name = `Sound Booster`.
    temp4-supplier_name = `Speaker Experts`.
    temp4-weight_measure = '2.1'.
    temp4-weight_unit = `KG`.
    temp4-price = '45'.
    temp4-currency_code = `EUR`.
    temp4-width = '12.4'.
    temp4-depth = '10.4'.
    temp4-height = '18.1'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1095`.
    temp4-name = `Lovely Sound 5.1 Wireless`.
    temp4-supplier_name = `Fasttech`.
    temp4-weight_measure = '80'.
    temp4-weight_unit = `G`.
    temp4-price = '49'.
    temp4-currency_code = `EUR`.
    temp4-width = '24'.
    temp4-depth = '19'.
    temp4-height = '23'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1096`.
    temp4-name = `Lovely Sound 5.1`.
    temp4-supplier_name = `Fasttech`.
    temp4-weight_measure = '130'.
    temp4-weight_unit = `G`.
    temp4-price = '39'.
    temp4-currency_code = `EUR`.
    temp4-width = '25'.
    temp4-depth = '17'.
    temp4-height = '19'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1097`.
    temp4-name = `Lovely Sound Stereo`.
    temp4-supplier_name = `Fasttech`.
    temp4-weight_measure = '60'.
    temp4-weight_unit = `G`.
    temp4-price = '29'.
    temp4-currency_code = `EUR`.
    temp4-width = '21.3'.
    temp4-depth = '2.4'.
    temp4-height = '19.7'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1100`.
    temp4-name = `Smart Office`.
    temp4-supplier_name = `Technocom`.
    temp4-weight_measure = '1.2'.
    temp4-weight_unit = `KG`.
    temp4-price = '89.9'.
    temp4-currency_code = `EUR`.
    temp4-width = '15'.
    temp4-depth = '6.5'.
    temp4-height = '2.1'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1101`.
    temp4-name = `Smart Design`.
    temp4-supplier_name = `Technocom`.
    temp4-weight_measure = '0.8'.
    temp4-weight_unit = `KG`.
    temp4-price = '79.9'.
    temp4-currency_code = `EUR`.
    temp4-width = '14'.
    temp4-depth = '6.7'.
    temp4-height = '24'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1102`.
    temp4-name = `Smart Network`.
    temp4-supplier_name = `Technocom`.
    temp4-weight_measure = '0.8'.
    temp4-weight_unit = `KG`.
    temp4-price = '69'.
    temp4-currency_code = `EUR`.
    temp4-width = '16'.
    temp4-depth = '6'.
    temp4-height = '27'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1103`.
    temp4-name = `Smart Multimedia`.
    temp4-supplier_name = `Technocom`.
    temp4-weight_measure = '0.8'.
    temp4-weight_unit = `KG`.
    temp4-price = '77'.
    temp4-currency_code = `EUR`.
    temp4-width = '11'.
    temp4-depth = '3.4'.
    temp4-height = '22'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1104`.
    temp4-name = `Smart Games`.
    temp4-supplier_name = `Technocom`.
    temp4-weight_measure = '1.1'.
    temp4-weight_unit = `KG`.
    temp4-price = '55'.
    temp4-currency_code = `EUR`.
    temp4-width = '10'.
    temp4-depth = '3'.
    temp4-height = '30'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1105`.
    temp4-name = `Smart Internet Antivirus`.
    temp4-supplier_name = `Brainsoft`.
    temp4-weight_measure = '0.7'.
    temp4-weight_unit = `KG`.
    temp4-price = '29'.
    temp4-currency_code = `EUR`.
    temp4-width = '16'.
    temp4-depth = '4'.
    temp4-height = '21'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1106`.
    temp4-name = `Smart Firewall`.
    temp4-supplier_name = `Brainsoft`.
    temp4-weight_measure = '0.9'.
    temp4-weight_unit = `KG`.
    temp4-price = '34'.
    temp4-currency_code = `EUR`.
    temp4-width = '17.9'.
    temp4-depth = '4.2'.
    temp4-height = '23.1'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1107`.
    temp4-name = `Smart Money`.
    temp4-supplier_name = `Brainsoft`.
    temp4-weight_measure = '0.5'.
    temp4-weight_unit = `KG`.
    temp4-price = '29.9'.
    temp4-currency_code = `EUR`.
    temp4-width = '12'.
    temp4-depth = '1.5'.
    temp4-height = '19'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1110`.
    temp4-name = `PC Lock`.
    temp4-supplier_name = `Red Point Stores`.
    temp4-weight_measure = '0.03'.
    temp4-weight_unit = `KG`.
    temp4-price = '8.9'.
    temp4-currency_code = `EUR`.
    temp4-width = '20'.
    temp4-depth = '8'.
    temp4-height = '4.3'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1111`.
    temp4-name = `Notebook Lock`.
    temp4-supplier_name = `Red Point Stores`.
    temp4-weight_measure = '0.02'.
    temp4-weight_unit = `KG`.
    temp4-price = '6.9'.
    temp4-currency_code = `EUR`.
    temp4-width = '31'.
    temp4-depth = '9'.
    temp4-height = '7'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1112`.
    temp4-name = `Web cam reality`.
    temp4-supplier_name = `Red Point Stores`.
    temp4-weight_measure = '0.075'.
    temp4-weight_unit = `KG`.
    temp4-price = '39'.
    temp4-currency_code = `EUR`.
    temp4-width = '9'.
    temp4-depth = '8.2'.
    temp4-height = '1.3'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1113`.
    temp4-name = `Screen clean`.
    temp4-supplier_name = `Red Point Stores`.
    temp4-weight_measure = '0.05'.
    temp4-weight_unit = `KG`.
    temp4-price = '2.3'.
    temp4-currency_code = `EUR`.
    temp4-width = '2'.
    temp4-depth = '2'.
    temp4-height = '0.1'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1114`.
    temp4-name = `Fabric bag professional`.
    temp4-supplier_name = `Red Point Stores`.
    temp4-weight_measure = '1.8'.
    temp4-weight_unit = `KG`.
    temp4-price = '31'.
    temp4-currency_code = `EUR`.
    temp4-width = '42'.
    temp4-depth = '32'.
    temp4-height = '7'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1115`.
    temp4-name = `Wireless DSL Router`.
    temp4-supplier_name = `Red Point Stores`.
    temp4-weight_measure = '0.45'.
    temp4-weight_unit = `KG`.
    temp4-price = '49'.
    temp4-currency_code = `EUR`.
    temp4-width = '19.3'.
    temp4-depth = '18'.
    temp4-height = '5'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1116`.
    temp4-name = `Wireless DSL Router / Repeater`.
    temp4-supplier_name = `Red Point Stores`.
    temp4-weight_measure = '0.45'.
    temp4-weight_unit = `KG`.
    temp4-price = '59'.
    temp4-currency_code = `EUR`.
    temp4-width = '19.3'.
    temp4-depth = '18'.
    temp4-height = '5'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1117`.
    temp4-name = `Wireless DSL Router / Repeater and Print Server`.
    temp4-supplier_name = `Technocom`.
    temp4-weight_measure = '0.45'.
    temp4-weight_unit = `KG`.
    temp4-price = '69'.
    temp4-currency_code = `EUR`.
    temp4-width = '19.3'.
    temp4-depth = '18'.
    temp4-height = '5'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1118`.
    temp4-name = `USB Stick`.
    temp4-supplier_name = `Technocom`.
    temp4-weight_measure = '0.015'.
    temp4-weight_unit = `KG`.
    temp4-price = '35'.
    temp4-currency_code = `EUR`.
    temp4-width = '1.5'.
    temp4-depth = '8.7'.
    temp4-height = '1.2'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1119`.
    temp4-name = `Travel Adapter`.
    temp4-supplier_name = `Titanium`.
    temp4-weight_measure = '88'.
    temp4-weight_unit = `G`.
    temp4-price = '79'.
    temp4-currency_code = `EUR`.
    temp4-width = '2'.
    temp4-depth = '3.1'.
    temp4-height = '3.9'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1120`.
    temp4-name = `Cordless Bluetooth Keyboard, english international`.
    temp4-supplier_name = `Technocom`.
    temp4-weight_measure = '1'.
    temp4-weight_unit = `KG`.
    temp4-price = '29'.
    temp4-currency_code = `EUR`.
    temp4-width = '51.4'.
    temp4-depth = '23'.
    temp4-height = '4'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1137`.
    temp4-name = `Flat XXL`.
    temp4-supplier_name = `Technocom`.
    temp4-weight_measure = '18'.
    temp4-weight_unit = `KG`.
    temp4-price = '1430'.
    temp4-currency_code = `EUR`.
    temp4-width = '54'.
    temp4-depth = '22'.
    temp4-height = '38'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1138`.
    temp4-name = `Pocket Mouse`.
    temp4-supplier_name = `Technocom`.
    temp4-weight_measure = '0.02'.
    temp4-weight_unit = `KG`.
    temp4-price = '23'.
    temp4-currency_code = `EUR`.
    temp4-width = '0.3'.
    temp4-depth = '0.5'.
    temp4-height = '1'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1210`.
    temp4-name = `PC Power Station`.
    temp4-supplier_name = `Technocom`.
    temp4-weight_measure = '2.3'.
    temp4-weight_unit = `KG`.
    temp4-price = '2399'.
    temp4-currency_code = `EUR`.
    temp4-width = '28'.
    temp4-depth = '31'.
    temp4-height = '43'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1251`.
    temp4-name = `Astro Laptop 1516`.
    temp4-supplier_name = `Ultrasonic United`.
    temp4-weight_measure = '4.2'.
    temp4-weight_unit = `KG`.
    temp4-price = '989'.
    temp4-currency_code = `EUR`.
    temp4-width = '30'.
    temp4-depth = '18'.
    temp4-height = '3'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1252`.
    temp4-name = `Astro Phone 6`.
    temp4-supplier_name = `Ultrasonic United`.
    temp4-weight_measure = '0.75'.
    temp4-weight_unit = `KG`.
    temp4-price = '649'.
    temp4-currency_code = `EUR`.
    temp4-width = '8'.
    temp4-depth = '6'.
    temp4-height = '1.5'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1253`.
    temp4-name = `Benda Laptop 1408`.
    temp4-supplier_name = `Ultrasonic United`.
    temp4-weight_measure = '4.2'.
    temp4-weight_unit = `KG`.
    temp4-price = '976'.
    temp4-currency_code = `EUR`.
    temp4-width = '30'.
    temp4-depth = '18'.
    temp4-height = '3'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1254`.
    temp4-name = `Bending Screen 21HD`.
    temp4-supplier_name = `Ultrasonic United`.
    temp4-weight_measure = '15'.
    temp4-weight_unit = `KG`.
    temp4-price = '250'.
    temp4-currency_code = `EUR`.
    temp4-width = '37'.
    temp4-depth = '12'.
    temp4-height = '36'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1255`.
    temp4-name = `Broad Screen 22HD`.
    temp4-supplier_name = `Ultrasonic United`.
    temp4-weight_measure = '16'.
    temp4-weight_unit = `KG`.
    temp4-price = '270'.
    temp4-currency_code = `EUR`.
    temp4-width = '39'.
    temp4-depth = '12'.
    temp4-height = '38'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1256`.
    temp4-name = `Cerdik Phone 7`.
    temp4-supplier_name = `Ultrasonic United`.
    temp4-weight_measure = '0.75'.
    temp4-weight_unit = `KG`.
    temp4-price = '549'.
    temp4-currency_code = `EUR`.
    temp4-width = '9'.
    temp4-depth = '15'.
    temp4-height = '1.5'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1257`.
    temp4-name = `Cepat Tablet 10.5`.
    temp4-supplier_name = `Ultrasonic United`.
    temp4-weight_measure = '2.8'.
    temp4-weight_unit = `KG`.
    temp4-price = '549'.
    temp4-currency_code = `EUR`.
    temp4-width = '48'.
    temp4-depth = '31'.
    temp4-height = '4.5'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1258`.
    temp4-name = `Cepat Tablet 8`.
    temp4-supplier_name = `Ultrasonic United`.
    temp4-weight_measure = '2.5'.
    temp4-weight_unit = `KG`.
    temp4-price = '529'.
    temp4-currency_code = `EUR`.
    temp4-width = '38'.
    temp4-depth = '21'.
    temp4-height = '3.5'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1500`.
    temp4-name = `Server Basic`.
    temp4-supplier_name = `Technocom`.
    temp4-weight_measure = '18'.
    temp4-weight_unit = `KG`.
    temp4-price = '5000'.
    temp4-currency_code = `EUR`.
    temp4-width = '34'.
    temp4-depth = '35'.
    temp4-height = '23'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1501`.
    temp4-name = `Server Professional`.
    temp4-supplier_name = `Technocom`.
    temp4-weight_measure = '25'.
    temp4-weight_unit = `KG`.
    temp4-price = '15000'.
    temp4-currency_code = `EUR`.
    temp4-width = '29'.
    temp4-depth = '30'.
    temp4-height = '27'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1502`.
    temp4-name = `Server Power Pro`.
    temp4-supplier_name = `Technocom`.
    temp4-weight_measure = '35'.
    temp4-weight_unit = `KG`.
    temp4-price = '25000'.
    temp4-currency_code = `EUR`.
    temp4-width = '22'.
    temp4-depth = '27.3'.
    temp4-height = '37'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1600`.
    temp4-name = `Family PC Basic`.
    temp4-supplier_name = `Titanium`.
    temp4-weight_measure = '4.8'.
    temp4-weight_unit = `KG`.
    temp4-price = '600'.
    temp4-currency_code = `EUR`.
    temp4-width = '21.4'.
    temp4-depth = '29'.
    temp4-height = '38'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1601`.
    temp4-name = `Family PC Pro`.
    temp4-supplier_name = `Titanium`.
    temp4-weight_measure = '5.3'.
    temp4-weight_unit = `KG`.
    temp4-price = '900'.
    temp4-currency_code = `EUR`.
    temp4-width = '25'.
    temp4-depth = '31.7'.
    temp4-height = '40.2'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1602`.
    temp4-name = `Gaming Monster`.
    temp4-supplier_name = `Titanium`.
    temp4-weight_measure = '5.9'.
    temp4-weight_unit = `KG`.
    temp4-price = '1200'.
    temp4-currency_code = `EUR`.
    temp4-width = '26.5'.
    temp4-depth = '34'.
    temp4-height = '47'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1603`.
    temp4-name = `Gaming Monster Pro`.
    temp4-supplier_name = `Titanium`.
    temp4-weight_measure = '6.8'.
    temp4-weight_unit = `KG`.
    temp4-price = '1700'.
    temp4-currency_code = `EUR`.
    temp4-width = '27'.
    temp4-depth = '28'.
    temp4-height = '42'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-2000`.
    temp4-name = `7" Widescreen Portable DVD Player w MP3`.
    temp4-supplier_name = `Titanium`.
    temp4-weight_measure = '0.79'.
    temp4-weight_unit = `KG`.
    temp4-price = '249.99'.
    temp4-currency_code = `EUR`.
    temp4-width = '21.4'.
    temp4-depth = '19'.
    temp4-height = '27.6'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-2001`.
    temp4-name = `10" Portable DVD player`.
    temp4-supplier_name = `Titanium`.
    temp4-weight_measure = '0.84'.
    temp4-weight_unit = `KG`.
    temp4-price = '449.99'.
    temp4-currency_code = `EUR`.
    temp4-width = '24'.
    temp4-depth = '19.5'.
    temp4-height = '29'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-2002`.
    temp4-name = `Portable DVD Player with 9" LCD Monitor`.
    temp4-supplier_name = `Technocom`.
    temp4-weight_measure = '0.72'.
    temp4-weight_unit = `KG`.
    temp4-price = '853.99'.
    temp4-currency_code = `EUR`.
    temp4-width = '21'.
    temp4-depth = '16.5'.
    temp4-height = '14'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-2025`.
    temp4-name = `CD/DVD case: 264 sleeves`.
    temp4-supplier_name = `Titanium`.
    temp4-weight_measure = '0.65'.
    temp4-weight_unit = `KG`.
    temp4-price = '44.99'.
    temp4-currency_code = `EUR`.
    temp4-width = '13'.
    temp4-depth = '13'.
    temp4-height = '20'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-2026`.
    temp4-name = `Audio/Video Cable Kit - 4m`.
    temp4-supplier_name = `Titanium`.
    temp4-weight_measure = '0.2'.
    temp4-weight_unit = `KG`.
    temp4-price = '29.99'.
    temp4-currency_code = `EUR`.
    temp4-width = '21'.
    temp4-depth = '10.2'.
    temp4-height = '13'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-2027`.
    temp4-name = `Removable CD/DVD Laser Labels`.
    temp4-supplier_name = `Titanium`.
    temp4-weight_measure = '0.15'.
    temp4-weight_unit = `KG`.
    temp4-price = '8.99'.
    temp4-currency_code = `EUR`.
    temp4-width = '5.5'.
    temp4-depth = '2'.
    temp4-height = '2'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-6100`.
    temp4-name = `Beam Breaker B-1`.
    temp4-supplier_name = `Titanium`.
    temp4-weight_measure = '1.7'.
    temp4-weight_unit = `KG`.
    temp4-price = '469'.
    temp4-currency_code = `EUR`.
    temp4-width = '30.4'.
    temp4-depth = '23.1'.
    temp4-height = '23'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-6101`.
    temp4-name = `Beam Breaker B-2`.
    temp4-supplier_name = `Technocom`.
    temp4-weight_measure = '2'.
    temp4-weight_unit = `KG`.
    temp4-price = '679'.
    temp4-currency_code = `EUR`.
    temp4-width = '30.4'.
    temp4-depth = '23.1'.
    temp4-height = '23'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-6102`.
    temp4-name = `Beam Breaker B-3`.
    temp4-supplier_name = `Technocom`.
    temp4-weight_measure = '2.5'.
    temp4-weight_unit = `KG`.
    temp4-price = '889'.
    temp4-currency_code = `EUR`.
    temp4-width = '30.4'.
    temp4-depth = '23.1'.
    temp4-height = '23'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-6110`.
    temp4-name = `Play Movie`.
    temp4-supplier_name = `Fasttech`.
    temp4-weight_measure = '2.4'.
    temp4-weight_unit = `KG`.
    temp4-price = '130'.
    temp4-currency_code = `EUR`.
    temp4-width = '37'.
    temp4-depth = '24'.
    temp4-height = '6'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-6111`.
    temp4-name = `Record Movie`.
    temp4-supplier_name = `Fasttech`.
    temp4-weight_measure = '3.1'.
    temp4-weight_unit = `KG`.
    temp4-price = '288'.
    temp4-currency_code = `EUR`.
    temp4-width = '38'.
    temp4-depth = '26'.
    temp4-height = '6.2'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-6120`.
    temp4-name = `ITelo MusicStick`.
    temp4-supplier_name = `Fasttech`.
    temp4-weight_measure = '134'.
    temp4-weight_unit = `G`.
    temp4-price = '45'.
    temp4-currency_code = `EUR`.
    temp4-width = '1.5'.
    temp4-depth = '6'.
    temp4-height = '1'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-6121`.
    temp4-name = `ITelo Jog-Mate`.
    temp4-supplier_name = `Fasttech`.
    temp4-weight_measure = '134'.
    temp4-weight_unit = `G`.
    temp4-price = '63'.
    temp4-currency_code = `EUR`.
    temp4-width = '5.1'.
    temp4-depth = '8'.
    temp4-height = '9.2'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-6122`.
    temp4-name = `Power Pro Player 40`.
    temp4-supplier_name = `Fasttech`.
    temp4-weight_measure = '266'.
    temp4-weight_unit = `G`.
    temp4-price = '167'.
    temp4-currency_code = `EUR`.
    temp4-width = '5.1'.
    temp4-depth = '8'.
    temp4-height = '9.2'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-6123`.
    temp4-name = `Power Pro Player 80`.
    temp4-supplier_name = `Fasttech`.
    temp4-weight_measure = '267'.
    temp4-weight_unit = `G`.
    temp4-price = '299'.
    temp4-currency_code = `EUR`.
    temp4-width = '4'.
    temp4-depth = '6'.
    temp4-height = '0.8'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-6130`.
    temp4-name = `Flat Watch HD32`.
    temp4-supplier_name = `Very Best Screens`.
    temp4-weight_measure = '2.6'.
    temp4-weight_unit = `KG`.
    temp4-price = '1459'.
    temp4-currency_code = `EUR`.
    temp4-width = '78'.
    temp4-depth = '22.1'.
    temp4-height = '55'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-6131`.
    temp4-name = `Flat Watch HD37`.
    temp4-supplier_name = `Very Best Screens`.
    temp4-weight_measure = '2.2'.
    temp4-weight_unit = `KG`.
    temp4-price = '1199'.
    temp4-currency_code = `EUR`.
    temp4-width = '99.1'.
    temp4-depth = '26'.
    temp4-height = '61'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-6132`.
    temp4-name = `Flat Watch HD41`.
    temp4-supplier_name = `Very Best Screens`.
    temp4-weight_measure = '1.8'.
    temp4-weight_unit = `KG`.
    temp4-price = '899'.
    temp4-currency_code = `EUR`.
    temp4-width = '128'.
    temp4-depth = '23'.
    temp4-height = '79.1'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-7000`.
    temp4-name = `Copperberry`.
    temp4-supplier_name = `Fasttech`.
    temp4-weight_measure = '0.5'.
    temp4-weight_unit = `KG`.
    temp4-price = '549'.
    temp4-currency_code = `EUR`.
    temp4-width = '8.1'.
    temp4-depth = '13'.
    temp4-height = '12.1'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-7010`.
    temp4-name = `Silverberry`.
    temp4-supplier_name = `Fasttech`.
    temp4-weight_measure = '0.5'.
    temp4-weight_unit = `KG`.
    temp4-price = '549'.
    temp4-currency_code = `EUR`.
    temp4-width = '8.1'.
    temp4-depth = '13'.
    temp4-height = '12.1'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-7020`.
    temp4-name = `Goldberry`.
    temp4-supplier_name = `Fasttech`.
    temp4-weight_measure = '0.5'.
    temp4-weight_unit = `KG`.
    temp4-price = '549'.
    temp4-currency_code = `EUR`.
    temp4-width = '8.1'.
    temp4-depth = '13'.
    temp4-height = '12.1'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-7030`.
    temp4-name = `Platinberry`.
    temp4-supplier_name = `Fasttech`.
    temp4-weight_measure = '0.5'.
    temp4-weight_unit = `KG`.
    temp4-price = '549'.
    temp4-currency_code = `EUR`.
    temp4-width = '8.1'.
    temp4-depth = '13'.
    temp4-height = '12.1'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-8000`.
    temp4-name = `ITelO FlexTop I4000`.
    temp4-supplier_name = `Titanium`.
    temp4-weight_measure = '4'.
    temp4-weight_unit = `KG`.
    temp4-price = '799'.
    temp4-currency_code = `EUR`.
    temp4-width = '31'.
    temp4-depth = '19'.
    temp4-height = '3.1'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-8001`.
    temp4-name = `ITelO FlexTop I6300c`.
    temp4-supplier_name = `Titanium`.
    temp4-weight_measure = '4.2'.
    temp4-weight_unit = `KG`.
    temp4-price = '799'.
    temp4-currency_code = `EUR`.
    temp4-width = '32'.
    temp4-depth = '20'.
    temp4-height = '3.4'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-8002`.
    temp4-name = `ITelO FlexTop I9100`.
    temp4-supplier_name = `Titanium`.
    temp4-weight_measure = '3.5'.
    temp4-weight_unit = `KG`.
    temp4-price = '1199'.
    temp4-currency_code = `EUR`.
    temp4-width = '38'.
    temp4-depth = '21'.
    temp4-height = '4.1'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-8003`.
    temp4-name = `ITelO FlexTop I9800`.
    temp4-supplier_name = `Titanium`.
    temp4-weight_measure = '3.8'.
    temp4-weight_unit = `KG`.
    temp4-price = '1388'.
    temp4-currency_code = `EUR`.
    temp4-width = '48'.
    temp4-depth = '31'.
    temp4-height = '4.5'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-9991`.
    temp4-name = `Smartphone Leather Case`.
    temp4-supplier_name = `Ultrasonic United`.
    temp4-weight_measure = '0.02'.
    temp4-weight_unit = `KG`.
    temp4-price = '25'.
    temp4-currency_code = `EUR`.
    temp4-width = '48'.
    temp4-depth = '31'.
    temp4-height = '4.5'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-9992`.
    temp4-name = `Smartphone Alpha`.
    temp4-supplier_name = `Ultrasonic United`.
    temp4-weight_measure = '0.75'.
    temp4-weight_unit = `KG`.
    temp4-price = '599'.
    temp4-currency_code = `EUR`.
    temp4-width = '48'.
    temp4-depth = '31'.
    temp4-height = '4.5'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-9993`.
    temp4-name = `Mini Tablet`.
    temp4-supplier_name = `Ultrasonic United`.
    temp4-weight_measure = '3.8'.
    temp4-weight_unit = `KG`.
    temp4-price = '833'.
    temp4-currency_code = `EUR`.
    temp4-width = '48'.
    temp4-depth = '31'.
    temp4-height = '4.5'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-9994`.
    temp4-name = `Camcorder View`.
    temp4-supplier_name = `Ultrasonic United`.
    temp4-weight_measure = '3.8'.
    temp4-weight_unit = `KG`.
    temp4-price = '1388'.
    temp4-currency_code = `EUR`.
    temp4-width = '48'.
    temp4-depth = '31'.
    temp4-height = '27'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-9995`.
    temp4-name = `Tablet Pouch`.
    temp4-supplier_name = `Titanium`.
    temp4-weight_measure = '0.03'.
    temp4-weight_unit = `KG`.
    temp4-price = '20'.
    temp4-currency_code = `EUR`.
    temp4-width = '25'.
    temp4-depth = '40'.
    temp4-height = '4.5'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-9996`.
    temp4-name = `Tablet Pouch`.
    temp4-supplier_name = `Titanium`.
    temp4-weight_measure = '0.03'.
    temp4-weight_unit = `KG`.
    temp4-price = '20'.
    temp4-currency_code = `EUR`.
    temp4-width = '25'.
    temp4-depth = '40'.
    temp4-height = '4.5'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-9997`.
    temp4-name = `e-Book Reader ReadMe`.
    temp4-supplier_name = `Titanium`.
    temp4-weight_measure = '3.8'.
    temp4-weight_unit = `KG`.
    temp4-price = '33'.
    temp4-currency_code = `EUR`.
    temp4-width = '48'.
    temp4-depth = '31'.
    temp4-height = '4.5'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-9998`.
    temp4-name = `Smartphone Beta`.
    temp4-supplier_name = `Titanium`.
    temp4-weight_measure = '0.75'.
    temp4-weight_unit = `KG`.
    temp4-price = '30'.
    temp4-currency_code = `EUR`.
    temp4-width = '48'.
    temp4-depth = '31'.
    temp4-height = '4.5'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-9999`.
    temp4-name = `Maxi Tablet`.
    temp4-supplier_name = `Titanium`.
    temp4-weight_measure = '3.8'.
    temp4-weight_unit = `KG`.
    temp4-price = '749'.
    temp4-currency_code = `EUR`.
    temp4-width = '48'.
    temp4-depth = '31'.
    temp4-height = '4.5'.
    temp4-dim_unit = `cm`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `PF-1000`.
    temp4-name = `Flyer`.
    temp4-supplier_name = `Titanium`.
    temp4-weight_measure = '0.01'.
    temp4-weight_unit = `KG`.
    temp4-price = '0'.
    temp4-currency_code = `EUR`.
    temp4-width = '46'.
    temp4-depth = '30'.
    temp4-height = '3'.
    temp4-dim_unit = `cm`.
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
