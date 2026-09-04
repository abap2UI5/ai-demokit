" @keywords popover sap.m controlling click behavior html app table toolbar title column text
" @summary In some cases the closing behavior of the Popover can lead to drill down navigation. This sample demonstrates how you can control this.
CLASS z2ui5_cl_smpc_app_094 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name            TYPE string,
        product_id      TYPE string,
        quantity        TYPE string,
        uom             TYPE string,
        weight_measure  TYPE string,
        weight_unit     TYPE string,
        price           TYPE p LENGTH 8 DECIMALS 2,
        currency_code   TYPE string,
        product_pic_url TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_094 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.
      DATA temp1 TYPE string_table.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      " onInit: oModel.setSizeLimit( 10 ) - the model-level limit 1:1, so the
      " table renders the ten rows the original shows, not all 123
      
      CLEAR temp1.
      INSERT `10` INTO TABLE temp1.
      INSERT client->cs_view-main INTO TABLE temp1.
      client->follow_up_action( val   = client->cs_event-set_size_limit
                                t_arg = temp1 ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp3 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp3.
    INSERT `$event.oSource.getBindingContext().getPath().split('/').pop()` INTO TABLE temp3.
    INSERT `$event.oSource.sId` INTO TABLE temp3.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        " the rule behind disablePointerEvents/enablePointerEvents. The css
        " control method cannot carry it - pointer-events is not on the
        " framework's CSS_PROPERTIES whitelist - so the popover toggles a
        " style CLASS instead, which is. \{ \} escaped: the XMLView parser
        " reads an unescaped brace as a binding
        )->tag( n = `HTML` ns = `core`
            )->a( n = `content` v = `<style>.tableNoPointerEvents\{pointer-events:none\}</style>`

        )->ele( `App`
            )->ele( `pages`
                )->ele( `Page`
                    )->a( n = `class` v = `sapUiContentPadding`
                    )->a( n = `title` v = `Header`
                    )->ele( `content`
                        )->ele( `Table`
                            )->a( n = `id`        v = `idProductsTable`
                            )->a( n = `mode`      v = `MultiSelect`
                            )->a( n = `inset`     v = `false`
                            )->a( n = `items`     v = |\{ path: '{ client->_bind_path( t_products ) }', sorter: \{ path: 'NAME' \} \}|
                            )->a( n = `itemPress` v = client->_event( `DRILL` )

                            )->ele( `headerToolbar`
                                )->ele( `Toolbar`
                                    )->tag( `Title`
                                        )->a( n = `text`  v = `Table - click events are disabled while a popover is open`
                                        )->a( n = `level` v = `H2`

                                )->end(
                            )->end(

                            )->ele( `columns`
                                )->ele( `Column`
                                    )->tag( `Text`
                                        )->a( n = `text` v = `Product`

                                )->end(
                                )->ele( `Column`
                                    )->tag( `Text`
                                        )->a( n = `text` v = `ID (Example feature)`

                                )->end(
                                )->ele( `Column`
                                    )->a( n = `hAlign`         v = `End`
                                    )->a( n = `width`          v = `12em`
                                    )->a( n = `minScreenWidth` v = `Tablet`
                                    )->a( n = `demandPopin`    v = `true`
                                    )->tag( `Text`
                                        )->a( n = `text` v = `Quantity`

                                )->end(
                                )->ele( `Column`
                                    )->a( n = `minScreenWidth` v = `Tablet`
                                    )->a( n = `demandPopin`    v = `true`
                                    )->a( n = `hAlign`         v = `End`
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
                                        )->tag( `Link`
                                            )->a( n = `text`         v = `{PRODUCT_ID}`
                                            )->a( n = `press`        v = client->_event( val   = `POPOVER`
                                                                                         t_arg = temp3 )
                                            )->a( n = `ariaHasPopup` v = `Dialog`
                                        )->tag( `Input`
                                            )->a( n = `value`       v = `{QUANTITY}`
                                            " the ORIGINAL writes type="{Text}"
                                            " (PopoverControllingCloseBehavior.view.xml): it meant the literal
                                            " enum value and wrote a binding, so the property falls back to
                                            " its default. Ported verbatim rather than repaired
                                            " abap2ui5lint-disable-next-line unknown-binding-path -- the sample's own quirk
                                            )->a( n = `type`        v = `{Text}`
                                            )->a( n = `description` v = `{UOM}`
                                            )->a( n = `fieldWidth`  v = `{60%}`
                                        )->tag( `ObjectNumber`
                                            )->a( n = `number` v = `{WEIGHT_MEASURE}`
                                            )->a( n = `unit`   v = `{WEIGHT_UNIT}`
                                        )->tag( `ObjectNumber`
                                            )->a( n = `number` v = |\{ parts:[\{path:'PRICE'\},\{path:'CURRENCY_CODE'\}], type: 'sap.ui.model.type.Currency', formatOptions: \{showMeasure: false\} \}|
                                            )->a( n = `unit`   v = `{CURRENCY_CODE}`

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


  METHOD on_event.
        DATA idx TYPE string.
        DATA popup TYPE REF TO z2ui5_cl_ui5_view_builder.
        DATA temp5 TYPE string_table.
        DATA temp1 TYPE string_table.
        DATA temp7 TYPE string_table.

    CASE client->get_event( ).
      WHEN `DRILL`.
        client->message_toast_display( `Drill down activated.` ).
      WHEN `ACTION`.
        " the popover's Action button: toast + close (1:1 with the original
        " handleActionPress - MessageToast.show + myPopover.close())
        client->message_toast_display( `Action has been pressed` ).
        client->follow_up_action( client->cs_event-popover_close ).
      WHEN `POPOVER`.
        " the original opens a Popover bound to the pressed row (title=ProductId,
        " Name + Image). Instead of copying each field into an event arg, the
        " popover uses relative bindings and follow_up_action element-binds the
        " popover slot to t_products/<index>; the row index and the Link's control
        " id arrive as the two event args.
        
        idx = client->get_event_arg( ).
        
        popup = z2ui5_cl_ui5_view_builder=>factory( ).
        
        CLEAR temp5.
        INSERT `idProductsTable` INTO TABLE temp5.
        INSERT `addStyleClass` INTO TABLE temp5.
        INSERT `tableNoPointerEvents` INTO TABLE temp5.
        
        CLEAR temp1.
        INSERT `idProductsTable` INTO TABLE temp1.
        INSERT `removeStyleClass` INTO TABLE temp1.
        INSERT `tableNoPointerEvents` INTO TABLE temp1.
        popup->ele( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`      v = `sap.m`
            )->a( n = `xmlns:core` v = `sap.ui.core`
            )->ele( `Popover`
                )->a( n = `id`        v = `myPopover`
                )->a( n = `title`     v = `{PRODUCT_ID}`
                )->a( n = `class`     v = `sapUiContentPadding`
                )->a( n = `placement` v = `Right`
                )->a( n = `initialFocus` v = `action`
                " attachAfterOpen -> disablePointerEvents, afterClose -> enable:
                " clicks on the table are dead while the popover is open, which
                " is the behaviour the page header advertises
                )->a( n = `afterOpen`  v = client->follow_up_action(
                                              val   = client->cs_event-control_by_id
                                              t_arg = temp5 )
                )->a( n = `afterClose` v = client->follow_up_action(
                                              val   = client->cs_event-control_by_id
                                              t_arg = temp1 )
                )->ele( `footer`
                    )->ele( `Toolbar`
                        )->tag( `ToolbarSpacer`
                        )->tag( `Button`
                            )->a( n = `id`    v = `action`
                            )->a( n = `text`  v = `Action`
                            )->a( n = `press` v = client->_event( `ACTION` )

                    )->end(
                )->end(
                )->ele( `VBox`
                    )->tag( `Title`
                        )->a( n = `text` v = `{NAME}`
                    )->tag( `Image`
                        )->a( n = `src`          v = `{PRODUCT_PIC_URL}`
                        )->a( n = `width`        v = `15em`
                        )->a( n = `densityAware` v = `false`

                )->end(
            )->end( ).
        client->popover_display( xml   = popup->stringify( )
                                 by_id = client->get_event_arg( 2 ) ).
        
        CLEAR temp7.
        INSERT idx INTO TABLE temp7.
        INSERT client->_bind( t_products ) INTO TABLE temp7.
        client->follow_up_action( val   = client->cs_event-bind_element
                                  view  = client->cs_view-popover
                                  t_arg = temp7 ).
    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " full mock /ProductCollection (sap/ui/demo/mock/products.json), verbatim
    DATA temp9 LIKE t_products.
    DATA temp10 LIKE LINE OF temp9.
    CLEAR temp9.
    
    temp10-name = `Notebook Basic 15`.
    temp10-product_id = `HT-1000`.
    temp10-quantity = `10`.
    temp10-uom = `PC`.
    temp10-weight_measure = `4.2`.
    temp10-weight_unit = `KG`.
    temp10-price = '956.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Notebook Basic 17`.
    temp10-product_id = `HT-1001`.
    temp10-quantity = `20`.
    temp10-uom = `PC`.
    temp10-weight_measure = `4.5`.
    temp10-weight_unit = `KG`.
    temp10-price = '1249.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1001.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Notebook Basic 18`.
    temp10-product_id = `HT-1002`.
    temp10-quantity = `10`.
    temp10-uom = `PC`.
    temp10-weight_measure = `4.2`.
    temp10-weight_unit = `KG`.
    temp10-price = '1570.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1002.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Notebook Basic 19`.
    temp10-product_id = `HT-1003`.
    temp10-quantity = `15`.
    temp10-uom = `PC`.
    temp10-weight_measure = `4.2`.
    temp10-weight_unit = `KG`.
    temp10-price = '1650.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1003.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `ITelO Vault`.
    temp10-product_id = `HT-1007`.
    temp10-quantity = `15`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.2`.
    temp10-weight_unit = `KG`.
    temp10-price = '299.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1007.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Notebook Professional 15`.
    temp10-product_id = `HT-1010`.
    temp10-quantity = `16`.
    temp10-uom = `PC`.
    temp10-weight_measure = `4.3`.
    temp10-weight_unit = `KG`.
    temp10-price = '1999.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Notebook Professional 17`.
    temp10-product_id = `HT-1011`.
    temp10-quantity = `17`.
    temp10-uom = `PC`.
    temp10-weight_measure = `4.1`.
    temp10-weight_unit = `KG`.
    temp10-price = '2299.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1011.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `ITelO Vault Net`.
    temp10-product_id = `HT-1020`.
    temp10-quantity = `14`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.16`.
    temp10-weight_unit = `KG`.
    temp10-price = '459.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1020.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `ITelO Vault SAT`.
    temp10-product_id = `HT-1021`.
    temp10-quantity = `50`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.18`.
    temp10-weight_unit = `KG`.
    temp10-price = '149.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1021.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Comfort Easy`.
    temp10-product_id = `HT-1022`.
    temp10-quantity = `30`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.2`.
    temp10-weight_unit = `KG`.
    temp10-price = '1679.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1022.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Comfort Senior`.
    temp10-product_id = `HT-1023`.
    temp10-quantity = `24`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.8`.
    temp10-weight_unit = `KG`.
    temp10-price = '512.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1023.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Ergo Screen E-I`.
    temp10-product_id = `HT-1030`.
    temp10-quantity = `14`.
    temp10-uom = `PC`.
    temp10-weight_measure = `21`.
    temp10-weight_unit = `KG`.
    temp10-price = '230.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1030.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Ergo Screen E-II`.
    temp10-product_id = `HT-1031`.
    temp10-quantity = `24`.
    temp10-uom = `PC`.
    temp10-weight_measure = `21`.
    temp10-weight_unit = `KG`.
    temp10-price = '285.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1031.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Ergo Screen E-III`.
    temp10-product_id = `HT-1032`.
    temp10-quantity = `50`.
    temp10-uom = `PC`.
    temp10-weight_measure = `21`.
    temp10-weight_unit = `KG`.
    temp10-price = '345.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1032.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Flat Basic`.
    temp10-product_id = `HT-1035`.
    temp10-quantity = `23`.
    temp10-uom = `PC`.
    temp10-weight_measure = `14`.
    temp10-weight_unit = `KG`.
    temp10-price = '399.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1035.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Flat Future`.
    temp10-product_id = `HT-1036`.
    temp10-quantity = `22`.
    temp10-uom = `PC`.
    temp10-weight_measure = `15`.
    temp10-weight_unit = `KG`.
    temp10-price = '430.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1036.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Flat XL`.
    temp10-product_id = `HT-1037`.
    temp10-quantity = `23`.
    temp10-uom = `PC`.
    temp10-weight_measure = `17`.
    temp10-weight_unit = `KG`.
    temp10-price = '1230.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1037.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Laser Professional Eco`.
    temp10-product_id = `HT-1040`.
    temp10-quantity = `21`.
    temp10-uom = `PC`.
    temp10-weight_measure = `32`.
    temp10-weight_unit = `KG`.
    temp10-price = '830.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1040.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Laser Basic`.
    temp10-product_id = `HT-1041`.
    temp10-quantity = `8`.
    temp10-uom = `PC`.
    temp10-weight_measure = `23`.
    temp10-weight_unit = `KG`.
    temp10-price = '490.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1041.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Laser Allround`.
    temp10-product_id = `HT-1042`.
    temp10-quantity = `9`.
    temp10-uom = `PC`.
    temp10-weight_measure = `17`.
    temp10-weight_unit = `KG`.
    temp10-price = '349.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1042.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Ultra Jet Super Color`.
    temp10-product_id = `HT-1050`.
    temp10-quantity = `17`.
    temp10-uom = `PC`.
    temp10-weight_measure = `3`.
    temp10-weight_unit = `KG`.
    temp10-price = '139.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1050.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Ultra Jet Mobile`.
    temp10-product_id = `HT-1051`.
    temp10-quantity = `18`.
    temp10-uom = `PC`.
    temp10-weight_measure = `1.9`.
    temp10-weight_unit = `KG`.
    temp10-price = '99.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1051.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Ultra Jet Super Highspeed`.
    temp10-product_id = `HT-1052`.
    temp10-quantity = `25`.
    temp10-uom = `PC`.
    temp10-weight_measure = `18`.
    temp10-weight_unit = `KG`.
    temp10-price = '170.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1052.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Multi Print`.
    temp10-product_id = `HT-1055`.
    temp10-quantity = `16`.
    temp10-uom = `PC`.
    temp10-weight_measure = `6.3`.
    temp10-weight_unit = `KG`.
    temp10-price = '99.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1055.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Multi Color`.
    temp10-product_id = `HT-1056`.
    temp10-quantity = `5`.
    temp10-uom = `PC`.
    temp10-weight_measure = `4.3`.
    temp10-weight_unit = `KG`.
    temp10-price = '119.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1056.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Cordless Mouse`.
    temp10-product_id = `HT-1060`.
    temp10-quantity = `25`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.09`.
    temp10-weight_unit = `KG`.
    temp10-price = '9.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1060.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Speed Mouse`.
    temp10-product_id = `HT-1061`.
    temp10-quantity = `12`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.09`.
    temp10-weight_unit = `KG`.
    temp10-price = '7.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1061.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Track Mouse`.
    temp10-product_id = `HT-1062`.
    temp10-quantity = `12`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.03`.
    temp10-weight_unit = `KG`.
    temp10-price = '11.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1062.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Ergonomic Keyboard`.
    temp10-product_id = `HT-1063`.
    temp10-quantity = `50`.
    temp10-uom = `PC`.
    temp10-weight_measure = `2.1`.
    temp10-weight_unit = `KG`.
    temp10-price = '14.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1063.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Internet Keyboard`.
    temp10-product_id = `HT-1064`.
    temp10-quantity = `35`.
    temp10-uom = `PC`.
    temp10-weight_measure = `1.8`.
    temp10-weight_unit = `KG`.
    temp10-price = '16.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1064.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Media Keyboard`.
    temp10-product_id = `HT-1065`.
    temp10-quantity = `26`.
    temp10-uom = `PC`.
    temp10-weight_measure = `2.3`.
    temp10-weight_unit = `KG`.
    temp10-price = '26.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1065.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Mousepad`.
    temp10-product_id = `HT-1066`.
    temp10-quantity = `12`.
    temp10-uom = `PC`.
    temp10-weight_measure = `80`.
    temp10-weight_unit = `G`.
    temp10-price = '6.99'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1066.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Ergo Mousepad`.
    temp10-product_id = `HT-1067`.
    temp10-quantity = `16`.
    temp10-uom = `PC`.
    temp10-weight_measure = `80`.
    temp10-weight_unit = `G`.
    temp10-price = '8.99'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1067.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Designer Mousepad`.
    temp10-product_id = `HT-1068`.
    temp10-quantity = `26`.
    temp10-uom = `PC`.
    temp10-weight_measure = `90`.
    temp10-weight_unit = `G`.
    temp10-price = '12.99'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1068.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Universal card reader`.
    temp10-product_id = `HT-1069`.
    temp10-quantity = `22`.
    temp10-uom = `PC`.
    temp10-weight_measure = `45`.
    temp10-weight_unit = `G`.
    temp10-price = '14.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1069.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Proctra X`.
    temp10-product_id = `HT-1070`.
    temp10-quantity = `15`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.255`.
    temp10-weight_unit = `KG`.
    temp10-price = '70.90'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1070.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Gladiator MX`.
    temp10-product_id = `HT-1071`.
    temp10-quantity = `16`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.3`.
    temp10-weight_unit = `KG`.
    temp10-price = '81.70'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1071.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Hurricane GX`.
    temp10-product_id = `HT-1072`.
    temp10-quantity = `13`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.4`.
    temp10-weight_unit = `KG`.
    temp10-price = '101.20'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1072.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Hurricane GX/LN`.
    temp10-product_id = `HT-1073`.
    temp10-quantity = `5`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.4`.
    temp10-weight_unit = `KG`.
    temp10-price = '139.99'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1073.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Photo Scan`.
    temp10-product_id = `HT-1080`.
    temp10-quantity = `8`.
    temp10-uom = `PC`.
    temp10-weight_measure = `2.3`.
    temp10-weight_unit = `KG`.
    temp10-price = '129.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1080.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Power Scan`.
    temp10-product_id = `HT-1081`.
    temp10-quantity = `11`.
    temp10-uom = `PC`.
    temp10-weight_measure = `2.4`.
    temp10-weight_unit = `KG`.
    temp10-price = '89.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1081.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Jet Scan Professional`.
    temp10-product_id = `HT-1082`.
    temp10-quantity = `13`.
    temp10-uom = `PC`.
    temp10-weight_measure = `3.2`.
    temp10-weight_unit = `KG`.
    temp10-price = '169.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1082.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Jet Scan Professional`.
    temp10-product_id = `HT-1083`.
    temp10-quantity = `10`.
    temp10-uom = `PC`.
    temp10-weight_measure = `3.2`.
    temp10-weight_unit = `KG`.
    temp10-price = '189.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1083.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Copymaster`.
    temp10-product_id = `HT-1085`.
    temp10-quantity = `10`.
    temp10-uom = `PC`.
    temp10-weight_measure = `23.2`.
    temp10-weight_unit = `KG`.
    temp10-price = '1499.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1085.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Surround Sound`.
    temp10-product_id = `HT-1090`.
    temp10-quantity = `20`.
    temp10-uom = `PC`.
    temp10-weight_measure = `3`.
    temp10-weight_unit = `KG`.
    temp10-price = '39.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1090.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Blaster Extreme`.
    temp10-product_id = `HT-1091`.
    temp10-quantity = `15`.
    temp10-uom = `PC`.
    temp10-weight_measure = `1.4`.
    temp10-weight_unit = `KG`.
    temp10-price = '26.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1091.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Sound Booster`.
    temp10-product_id = `HT-1092`.
    temp10-quantity = `50`.
    temp10-uom = `PC`.
    temp10-weight_measure = `2.1`.
    temp10-weight_unit = `KG`.
    temp10-price = '45.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1092.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Lovely Sound 5.1 Wireless`.
    temp10-product_id = `HT-1095`.
    temp10-quantity = `12`.
    temp10-uom = `PC`.
    temp10-weight_measure = `80`.
    temp10-weight_unit = `G`.
    temp10-price = '49.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1095.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Lovely Sound 5.1`.
    temp10-product_id = `HT-1096`.
    temp10-quantity = `18`.
    temp10-uom = `PC`.
    temp10-weight_measure = `130`.
    temp10-weight_unit = `G`.
    temp10-price = '39.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1096.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Lovely Sound Stereo`.
    temp10-product_id = `HT-1097`.
    temp10-quantity = `21`.
    temp10-uom = `PC`.
    temp10-weight_measure = `60`.
    temp10-weight_unit = `G`.
    temp10-price = '29.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1097.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Smart Office`.
    temp10-product_id = `HT-1100`.
    temp10-quantity = `25`.
    temp10-uom = `PC`.
    temp10-weight_measure = `1.2`.
    temp10-weight_unit = `KG`.
    temp10-price = '89.90'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1100.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Smart Design`.
    temp10-product_id = `HT-1101`.
    temp10-quantity = `26`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.8`.
    temp10-weight_unit = `KG`.
    temp10-price = '79.90'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1101.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Smart Network`.
    temp10-product_id = `HT-1102`.
    temp10-quantity = `28`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.8`.
    temp10-weight_unit = `KG`.
    temp10-price = '69.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1102.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Smart Multimedia`.
    temp10-product_id = `HT-1103`.
    temp10-quantity = `9`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.8`.
    temp10-weight_unit = `KG`.
    temp10-price = '77.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1103.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Smart Games`.
    temp10-product_id = `HT-1104`.
    temp10-quantity = `13`.
    temp10-uom = `PC`.
    temp10-weight_measure = `1.1`.
    temp10-weight_unit = `KG`.
    temp10-price = '55.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1104.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Smart Internet Antivirus`.
    temp10-product_id = `HT-1105`.
    temp10-quantity = `17`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.7`.
    temp10-weight_unit = `KG`.
    temp10-price = '29.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1105.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Smart Firewall`.
    temp10-product_id = `HT-1106`.
    temp10-quantity = `19`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.9`.
    temp10-weight_unit = `KG`.
    temp10-price = '34.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1106.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Smart Money`.
    temp10-product_id = `HT-1107`.
    temp10-quantity = `18`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.5`.
    temp10-weight_unit = `KG`.
    temp10-price = '29.90'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1107.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `PC Lock`.
    temp10-product_id = `HT-1110`.
    temp10-quantity = `14`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.03`.
    temp10-weight_unit = `KG`.
    temp10-price = '8.90'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1110.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Notebook Lock`.
    temp10-product_id = `HT-1111`.
    temp10-quantity = `20`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.02`.
    temp10-weight_unit = `KG`.
    temp10-price = '6.90'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1111.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Web cam reality`.
    temp10-product_id = `HT-1112`.
    temp10-quantity = `27`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.075`.
    temp10-weight_unit = `KG`.
    temp10-price = '39.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1112.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Screen clean`.
    temp10-product_id = `HT-1113`.
    temp10-quantity = `17`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.05`.
    temp10-weight_unit = `KG`.
    temp10-price = '2.30'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1113.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Fabric bag professional`.
    temp10-product_id = `HT-1114`.
    temp10-quantity = `14`.
    temp10-uom = `PC`.
    temp10-weight_measure = `1.8`.
    temp10-weight_unit = `KG`.
    temp10-price = '31.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1114.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Wireless DSL Router`.
    temp10-product_id = `HT-1115`.
    temp10-quantity = `16`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.45`.
    temp10-weight_unit = `KG`.
    temp10-price = '49.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1115.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Wireless DSL Router / Repeater`.
    temp10-product_id = `HT-1116`.
    temp10-quantity = `12`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.45`.
    temp10-weight_unit = `KG`.
    temp10-price = '59.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1116.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Wireless DSL Router / Repeater and Print Server`.
    temp10-product_id = `HT-1117`.
    temp10-quantity = `12`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.45`.
    temp10-weight_unit = `KG`.
    temp10-price = '69.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1117.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `USB Stick`.
    temp10-product_id = `HT-1118`.
    temp10-quantity = `14`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.015`.
    temp10-weight_unit = `KG`.
    temp10-price = '35.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1118.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Travel Adapter`.
    temp10-product_id = `HT-1119`.
    temp10-quantity = `10`.
    temp10-uom = `PC`.
    temp10-weight_measure = `88`.
    temp10-weight_unit = `G`.
    temp10-price = '79.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1119.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Cordless Bluetooth Keyboard, english international`.
    temp10-product_id = `HT-1120`.
    temp10-quantity = `13`.
    temp10-uom = `PC`.
    temp10-weight_measure = `1`.
    temp10-weight_unit = `KG`.
    temp10-price = '29.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1120.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Flat XXL`.
    temp10-product_id = `HT-1137`.
    temp10-quantity = `10`.
    temp10-uom = `PC`.
    temp10-weight_measure = `18`.
    temp10-weight_unit = `KG`.
    temp10-price = '1430.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1137.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Pocket Mouse`.
    temp10-product_id = `HT-1138`.
    temp10-quantity = `20`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.02`.
    temp10-weight_unit = `KG`.
    temp10-price = '23.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1138.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `PC Power Station`.
    temp10-product_id = `HT-1210`.
    temp10-quantity = `22`.
    temp10-uom = `PC`.
    temp10-weight_measure = `2.3`.
    temp10-weight_unit = `KG`.
    temp10-price = '2399.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1210.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Astro Laptop 1516`.
    temp10-product_id = `HT-1251`.
    temp10-quantity = `23`.
    temp10-uom = `PC`.
    temp10-weight_measure = `4.2`.
    temp10-weight_unit = `KG`.
    temp10-price = '989.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1251.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Astro Phone 6`.
    temp10-product_id = `HT-1252`.
    temp10-quantity = `28`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.75`.
    temp10-weight_unit = `KG`.
    temp10-price = '649.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1252.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Benda Laptop 1408`.
    temp10-product_id = `HT-1253`.
    temp10-quantity = `27`.
    temp10-uom = `PC`.
    temp10-weight_measure = `4.2`.
    temp10-weight_unit = `KG`.
    temp10-price = '976.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1253.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Bending Screen 21HD`.
    temp10-product_id = `HT-1254`.
    temp10-quantity = `23`.
    temp10-uom = `PC`.
    temp10-weight_measure = `15`.
    temp10-weight_unit = `KG`.
    temp10-price = '250.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1254.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Broad Screen 22HD`.
    temp10-product_id = `HT-1255`.
    temp10-quantity = `5`.
    temp10-uom = `PC`.
    temp10-weight_measure = `16`.
    temp10-weight_unit = `KG`.
    temp10-price = '270.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1255.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Cerdik Phone 7`.
    temp10-product_id = `HT-1256`.
    temp10-quantity = `19`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.75`.
    temp10-weight_unit = `KG`.
    temp10-price = '549.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1256.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Cepat Tablet 10.5`.
    temp10-product_id = `HT-1257`.
    temp10-quantity = `17`.
    temp10-uom = `PC`.
    temp10-weight_measure = `2.8`.
    temp10-weight_unit = `KG`.
    temp10-price = '549.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1257.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Cepat Tablet 8`.
    temp10-product_id = `HT-1258`.
    temp10-quantity = `24`.
    temp10-uom = `PC`.
    temp10-weight_measure = `2.5`.
    temp10-weight_unit = `KG`.
    temp10-price = '529.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1258.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Server Basic`.
    temp10-product_id = `HT-1500`.
    temp10-quantity = `24`.
    temp10-uom = `PC`.
    temp10-weight_measure = `18`.
    temp10-weight_unit = `KG`.
    temp10-price = '5000.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1500.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Server Professional`.
    temp10-product_id = `HT-1501`.
    temp10-quantity = `26`.
    temp10-uom = `PC`.
    temp10-weight_measure = `25`.
    temp10-weight_unit = `KG`.
    temp10-price = '15000.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1501.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Server Power Pro`.
    temp10-product_id = `HT-1502`.
    temp10-quantity = `34`.
    temp10-uom = `PC`.
    temp10-weight_measure = `35`.
    temp10-weight_unit = `KG`.
    temp10-price = '25000.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1502.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Family PC Basic`.
    temp10-product_id = `HT-1600`.
    temp10-quantity = `10`.
    temp10-uom = `PC`.
    temp10-weight_measure = `4.8`.
    temp10-weight_unit = `KG`.
    temp10-price = '600.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1600.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Family PC Pro`.
    temp10-product_id = `HT-1601`.
    temp10-quantity = `20`.
    temp10-uom = `PC`.
    temp10-weight_measure = `5.3`.
    temp10-weight_unit = `KG`.
    temp10-price = '900.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1601.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Gaming Monster`.
    temp10-product_id = `HT-1602`.
    temp10-quantity = `24`.
    temp10-uom = `PC`.
    temp10-weight_measure = `5.9`.
    temp10-weight_unit = `KG`.
    temp10-price = '1200.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1602.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Gaming Monster Pro`.
    temp10-product_id = `HT-1603`.
    temp10-quantity = `25`.
    temp10-uom = `PC`.
    temp10-weight_measure = `6.8`.
    temp10-weight_unit = `KG`.
    temp10-price = '1700.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1603.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `7" Widescreen Portable DVD Player w MP3`.
    temp10-product_id = `HT-2000`.
    temp10-quantity = `20`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.79`.
    temp10-weight_unit = `KG`.
    temp10-price = '249.99'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2000.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `10" Portable DVD player`.
    temp10-product_id = `HT-2001`.
    temp10-quantity = `21`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.84`.
    temp10-weight_unit = `KG`.
    temp10-price = '449.99'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2001.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Portable DVD Player with 9" LCD Monitor`.
    temp10-product_id = `HT-2002`.
    temp10-quantity = `50`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.72`.
    temp10-weight_unit = `KG`.
    temp10-price = '853.99'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2002.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `CD/DVD case: 264 sleeves`.
    temp10-product_id = `HT-2025`.
    temp10-quantity = `26`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.65`.
    temp10-weight_unit = `KG`.
    temp10-price = '44.99'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2025.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Audio/Video Cable Kit - 4m`.
    temp10-product_id = `HT-2026`.
    temp10-quantity = `16`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.2`.
    temp10-weight_unit = `KG`.
    temp10-price = '29.99'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2026.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Removable CD/DVD Laser Labels`.
    temp10-product_id = `HT-2027`.
    temp10-quantity = `25`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.15`.
    temp10-weight_unit = `KG`.
    temp10-price = '8.99'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2027.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Beam Breaker B-1`.
    temp10-product_id = `HT-6100`.
    temp10-quantity = `32`.
    temp10-uom = `PC`.
    temp10-weight_measure = `1.7`.
    temp10-weight_unit = `KG`.
    temp10-price = '469.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6100.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Beam Breaker B-2`.
    temp10-product_id = `HT-6101`.
    temp10-quantity = `18`.
    temp10-uom = `PC`.
    temp10-weight_measure = `2`.
    temp10-weight_unit = `KG`.
    temp10-price = '679.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6101.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Beam Breaker B-3`.
    temp10-product_id = `HT-6102`.
    temp10-quantity = `16`.
    temp10-uom = `PC`.
    temp10-weight_measure = `2.5`.
    temp10-weight_unit = `KG`.
    temp10-price = '889.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6102.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Play Movie`.
    temp10-product_id = `HT-6110`.
    temp10-quantity = `15`.
    temp10-uom = `PC`.
    temp10-weight_measure = `2.4`.
    temp10-weight_unit = `KG`.
    temp10-price = '130.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6110.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Record Movie`.
    temp10-product_id = `HT-6111`.
    temp10-quantity = `24`.
    temp10-uom = `PC`.
    temp10-weight_measure = `3.1`.
    temp10-weight_unit = `KG`.
    temp10-price = '288.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6111.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `ITelo MusicStick`.
    temp10-product_id = `HT-6120`.
    temp10-quantity = `15`.
    temp10-uom = `PC`.
    temp10-weight_measure = `134`.
    temp10-weight_unit = `G`.
    temp10-price = '45.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6120.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `ITelo Jog-Mate`.
    temp10-product_id = `HT-6121`.
    temp10-quantity = `24`.
    temp10-uom = `PC`.
    temp10-weight_measure = `134`.
    temp10-weight_unit = `G`.
    temp10-price = '63.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6121.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Power Pro Player 40`.
    temp10-product_id = `HT-6122`.
    temp10-quantity = `23`.
    temp10-uom = `PC`.
    temp10-weight_measure = `266`.
    temp10-weight_unit = `G`.
    temp10-price = '167.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6122.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Power Pro Player 80`.
    temp10-product_id = `HT-6123`.
    temp10-quantity = `13`.
    temp10-uom = `PC`.
    temp10-weight_measure = `267`.
    temp10-weight_unit = `G`.
    temp10-price = '299.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6123.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Flat Watch HD32`.
    temp10-product_id = `HT-6130`.
    temp10-quantity = `16`.
    temp10-uom = `PC`.
    temp10-weight_measure = `2.6`.
    temp10-weight_unit = `KG`.
    temp10-price = '1459.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6130.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Flat Watch HD37`.
    temp10-product_id = `HT-6131`.
    temp10-quantity = `14`.
    temp10-uom = `PC`.
    temp10-weight_measure = `2.2`.
    temp10-weight_unit = `KG`.
    temp10-price = '1199.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6131.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Flat Watch HD41`.
    temp10-product_id = `HT-6132`.
    temp10-quantity = `13`.
    temp10-uom = `PC`.
    temp10-weight_measure = `1.8`.
    temp10-weight_unit = `KG`.
    temp10-price = '899.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6132.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Copperberry`.
    temp10-product_id = `HT-7000`.
    temp10-quantity = `5`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.5`.
    temp10-weight_unit = `KG`.
    temp10-price = '549.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7000.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Silverberry`.
    temp10-product_id = `HT-7010`.
    temp10-quantity = `9`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.5`.
    temp10-weight_unit = `KG`.
    temp10-price = '549.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7010.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Goldberry`.
    temp10-product_id = `HT-7020`.
    temp10-quantity = `11`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.5`.
    temp10-weight_unit = `KG`.
    temp10-price = '549.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7020.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Platinberry`.
    temp10-product_id = `HT-7030`.
    temp10-quantity = `12`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.5`.
    temp10-weight_unit = `KG`.
    temp10-price = '549.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7030.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `ITelO FlexTop I4000`.
    temp10-product_id = `HT-8000`.
    temp10-quantity = `11`.
    temp10-uom = `PC`.
    temp10-weight_measure = `4`.
    temp10-weight_unit = `KG`.
    temp10-price = '799.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8000.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `ITelO FlexTop I6300c`.
    temp10-product_id = `HT-8001`.
    temp10-quantity = `20`.
    temp10-uom = `PC`.
    temp10-weight_measure = `4.2`.
    temp10-weight_unit = `KG`.
    temp10-price = '799.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8001.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `ITelO FlexTop I9100`.
    temp10-product_id = `HT-8002`.
    temp10-quantity = `20`.
    temp10-uom = `PC`.
    temp10-weight_measure = `3.5`.
    temp10-weight_unit = `KG`.
    temp10-price = '1199.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8002.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `ITelO FlexTop I9800`.
    temp10-product_id = `HT-8003`.
    temp10-quantity = `22`.
    temp10-uom = `PC`.
    temp10-weight_measure = `3.8`.
    temp10-weight_unit = `KG`.
    temp10-price = '1388.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8003.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Smartphone Leather Case`.
    temp10-product_id = `HT-9991`.
    temp10-quantity = `12`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.02`.
    temp10-weight_unit = `KG`.
    temp10-price = '25.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9991.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Smartphone Alpha`.
    temp10-product_id = `HT-9992`.
    temp10-quantity = `13`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.75`.
    temp10-weight_unit = `KG`.
    temp10-price = '599.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9992.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Mini Tablet`.
    temp10-product_id = `HT-9993`.
    temp10-quantity = `10`.
    temp10-uom = `PC`.
    temp10-weight_measure = `3.8`.
    temp10-weight_unit = `KG`.
    temp10-price = '833.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9993.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Camcorder View`.
    temp10-product_id = `HT-9994`.
    temp10-quantity = `50`.
    temp10-uom = `PC`.
    temp10-weight_measure = `3.8`.
    temp10-weight_unit = `KG`.
    temp10-price = '1388.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9994.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Tablet Pouch`.
    temp10-product_id = `HT-9995`.
    temp10-quantity = `34`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.03`.
    temp10-weight_unit = `KG`.
    temp10-price = '20.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9995.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Tablet Pouch`.
    temp10-product_id = `HT-9996`.
    temp10-quantity = `34`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.03`.
    temp10-weight_unit = `KG`.
    temp10-price = '20.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9996.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `e-Book Reader ReadMe`.
    temp10-product_id = `HT-9997`.
    temp10-quantity = `23`.
    temp10-uom = `PC`.
    temp10-weight_measure = `3.8`.
    temp10-weight_unit = `KG`.
    temp10-price = '33.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9997.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Smartphone Beta`.
    temp10-product_id = `HT-9998`.
    temp10-quantity = `21`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.75`.
    temp10-weight_unit = `KG`.
    temp10-price = '30.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9998.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Maxi Tablet`.
    temp10-product_id = `HT-9999`.
    temp10-quantity = `20`.
    temp10-uom = `PC`.
    temp10-weight_measure = `3.8`.
    temp10-weight_unit = `KG`.
    temp10-price = '749.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9999.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Flyer`.
    temp10-product_id = `PF-1000`.
    temp10-quantity = `33`.
    temp10-uom = `PC`.
    temp10-weight_measure = `0.01`.
    temp10-weight_unit = `KG`.
    temp10-price = '0.00'.
    temp10-currency_code = `EUR`.
    temp10-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/PF-1000.jpg`.
    INSERT temp10 INTO TABLE temp9.
    t_products = temp9.

  ENDMETHOD.

ENDCLASS.
