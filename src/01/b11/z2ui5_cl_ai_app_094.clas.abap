CLASS z2ui5_cl_ai_app_094 DEFINITION PUBLIC.

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
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_094 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->open( `App`
            )->open( `pages`
                )->open( `Page`
                    )->a( n = `class` v = `sapUiContentPadding`
                    )->a( n = `title` v = `Header`
                    )->open( `content`
                        )->open( `Table`
                            )->a( n = `id`        v = `idProductsTable`
                            )->a( n = `mode`      v = `MultiSelect`
                            )->a( n = `inset`     v = `false`
                            )->a( n = `items`     v = |\{ path: '{ client->_bind( val = t_products path = abap_true ) }', sorter: \{ path: 'NAME' \} \}|
                            )->a( n = `itemPress` v = client->_event( `DRILL` )

                            )->open( `headerToolbar`
                                )->open( `Toolbar`
                                    )->leaf( `Title`
                                        )->a( n = `text`  v = `Table - click events are disabled while a popover is open`
                                        )->a( n = `level` v = `H2`

                                )->shut(
                            )->shut(

                            )->open( `columns`
                                )->open( `Column`
                                    )->leaf( `Text`
                                        )->a( n = `text` v = `Product`

                                )->shut(
                                )->open( `Column`
                                    )->leaf( `Text`
                                        )->a( n = `text` v = `ID (Example feature)`

                                )->shut(
                                )->open( `Column`
                                    )->a( n = `hAlign`         v = `End`
                                    )->a( n = `width`          v = `12em`
                                    )->a( n = `minScreenWidth` v = `Tablet`
                                    )->a( n = `demandPopin`    v = `true`
                                    )->leaf( `Text`
                                        )->a( n = `text` v = `Quantity`

                                )->shut(
                                )->open( `Column`
                                    )->a( n = `minScreenWidth` v = `Tablet`
                                    )->a( n = `demandPopin`    v = `true`
                                    )->a( n = `hAlign`         v = `End`
                                    )->leaf( `Text`
                                        )->a( n = `text` v = `Weight`

                                )->shut(
                                )->open( `Column`
                                    )->a( n = `hAlign` v = `End`
                                    )->leaf( `Text`
                                        )->a( n = `text` v = `Unit Price`

                                )->shut(
                            )->shut(

                            )->open( `items`
                                )->open( `ColumnListItem`
                                    )->a( n = `vAlign` v = `Middle`
                                    )->a( n = `type`   v = `Navigation`
                                    )->open( `cells`
                                        )->leaf( `ObjectIdentifier`
                                            )->a( n = `title` v = `{NAME}`
                                        )->leaf( `Link`
                                            )->a( n = `text`         v = `{PRODUCT_ID}`
                                            )->a( n = `press`        v = client->_event( val   = `POPOVER`
                                                                                         t_arg = VALUE #( ( `$event.oSource.getBindingContext().getPath().split('/').pop()` ) ( `$event.oSource.sId` ) ) )
                                            )->a( n = `ariaHasPopup` v = `Dialog`
                                        )->leaf( `Input`
                                            )->a( n = `value`       v = `{QUANTITY}`
                                            )->a( n = `type`        v = `{Text}`
                                            )->a( n = `description` v = `{UOM}`
                                            )->a( n = `fieldWidth`  v = `{60%}`
                                        )->leaf( `ObjectNumber`
                                            )->a( n = `number` v = `{WEIGHT_MEASURE}`
                                            )->a( n = `unit`   v = `{WEIGHT_UNIT}`
                                        )->leaf( `ObjectNumber`
                                            )->a( n = `number` v = |\{ parts:[\{path:'PRICE'\},\{path:'CURRENCY_CODE'\}], type: 'sap.ui.model.type.Currency', formatOptions: \{showMeasure: false\} \}|
                                            )->a( n = `unit`   v = `{CURRENCY_CODE}`

                                    )->shut(
                                )->shut(
                            )->shut(
                        )->shut(
                    )->shut(
                )->shut(
            )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
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
        DATA(idx) = client->get_event_arg( ).
        DATA(popup) = z2ui5_cl_ai_xml=>factory( ).
        popup->open( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`      v = `sap.m`
            )->a( n = `xmlns:core` v = `sap.ui.core`
            )->open( `Popover`
                )->a( n = `id`        v = `myPopover`
                )->a( n = `title`     v = `{PRODUCT_ID}`
                )->a( n = `class`     v = `sapUiContentPadding`
                )->a( n = `placement` v = `Right`
                )->a( n = `initialFocus` v = `action`
                )->open( `footer`
                    )->open( `Toolbar`
                        )->leaf( `ToolbarSpacer`
                        )->leaf( `Button`
                            )->a( n = `id`    v = `action`
                            )->a( n = `text`  v = `Action`
                            )->a( n = `press` v = client->_event( `ACTION` )

                    )->shut(
                )->shut(
                )->open( `VBox`
                    )->leaf( `Title`
                        )->a( n = `text` v = `{NAME}`
                    )->leaf( `Image`
                        )->a( n = `src`          v = `{PRODUCT_PIC_URL}`
                        )->a( n = `width`        v = `15em`
                        )->a( n = `densityAware` v = `false`

                )->shut(
            )->shut( ).
        client->popover_display( xml   = popup->stringify( )
                                 by_id = client->get_event_arg( 2 ) ).
        client->follow_up_action( val   = client->cs_event-bind_element
                                  view  = client->cs_view-popover
                                  t_arg = VALUE #( ( idx ) ( client->_bind( t_products ) ) ) ).
    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " full mock /ProductCollection (sap/ui/demo/mock/products.json), verbatim
    t_products = VALUE #(
      ( name = `Notebook Basic 15` product_id = `HT-1000` quantity = `10` uom = `PC` weight_measure = `4.2` weight_unit = `KG`
        price = '956.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg` )
      ( name = `Notebook Basic 17` product_id = `HT-1001` quantity = `20` uom = `PC` weight_measure = `4.5` weight_unit = `KG`
        price = '1249.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1001.jpg` )
      ( name = `Notebook Basic 18` product_id = `HT-1002` quantity = `10` uom = `PC` weight_measure = `4.2` weight_unit = `KG`
        price = '1570.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1002.jpg` )
      ( name = `Notebook Basic 19` product_id = `HT-1003` quantity = `15` uom = `PC` weight_measure = `4.2` weight_unit = `KG`
        price = '1650.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1003.jpg` )
      ( name = `ITelO Vault` product_id = `HT-1007` quantity = `15` uom = `PC` weight_measure = `0.2` weight_unit = `KG`
        price = '299.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1007.jpg` )
      ( name = `Notebook Professional 15` product_id = `HT-1010` quantity = `16` uom = `PC` weight_measure = `4.3` weight_unit = `KG`
        price = '1999.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg` )
      ( name = `Notebook Professional 17` product_id = `HT-1011` quantity = `17` uom = `PC` weight_measure = `4.1` weight_unit = `KG`
        price = '2299.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1011.jpg` )
      ( name = `ITelO Vault Net` product_id = `HT-1020` quantity = `14` uom = `PC` weight_measure = `0.16` weight_unit = `KG`
        price = '459.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1020.jpg` )
      ( name = `ITelO Vault SAT` product_id = `HT-1021` quantity = `50` uom = `PC` weight_measure = `0.18` weight_unit = `KG`
        price = '149.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1021.jpg` )
      ( name = `Comfort Easy` product_id = `HT-1022` quantity = `30` uom = `PC` weight_measure = `0.2` weight_unit = `KG`
        price = '1679.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1022.jpg` )
      ( name = `Comfort Senior` product_id = `HT-1023` quantity = `24` uom = `PC` weight_measure = `0.8` weight_unit = `KG`
        price = '512.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1023.jpg` )
      ( name = `Ergo Screen E-I` product_id = `HT-1030` quantity = `14` uom = `PC` weight_measure = `21` weight_unit = `KG`
        price = '230.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1030.jpg` )
      ( name = `Ergo Screen E-II` product_id = `HT-1031` quantity = `24` uom = `PC` weight_measure = `21` weight_unit = `KG`
        price = '285.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1031.jpg` )
      ( name = `Ergo Screen E-III` product_id = `HT-1032` quantity = `50` uom = `PC` weight_measure = `21` weight_unit = `KG`
        price = '345.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1032.jpg` )
      ( name = `Flat Basic` product_id = `HT-1035` quantity = `23` uom = `PC` weight_measure = `14` weight_unit = `KG`
        price = '399.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1035.jpg` )
      ( name = `Flat Future` product_id = `HT-1036` quantity = `22` uom = `PC` weight_measure = `15` weight_unit = `KG`
        price = '430.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1036.jpg` )
      ( name = `Flat XL` product_id = `HT-1037` quantity = `23` uom = `PC` weight_measure = `17` weight_unit = `KG`
        price = '1230.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1037.jpg` )
      ( name = `Laser Professional Eco` product_id = `HT-1040` quantity = `21` uom = `PC` weight_measure = `32` weight_unit = `KG`
        price = '830.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1040.jpg` )
      ( name = `Laser Basic` product_id = `HT-1041` quantity = `8` uom = `PC` weight_measure = `23` weight_unit = `KG`
        price = '490.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1041.jpg` )
      ( name = `Laser Allround` product_id = `HT-1042` quantity = `9` uom = `PC` weight_measure = `17` weight_unit = `KG`
        price = '349.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1042.jpg` )
      ( name = `Ultra Jet Super Color` product_id = `HT-1050` quantity = `17` uom = `PC` weight_measure = `3` weight_unit = `KG`
        price = '139.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1050.jpg` )
      ( name = `Ultra Jet Mobile` product_id = `HT-1051` quantity = `18` uom = `PC` weight_measure = `1.9` weight_unit = `KG`
        price = '99.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1051.jpg` )
      ( name = `Ultra Jet Super Highspeed` product_id = `HT-1052` quantity = `25` uom = `PC` weight_measure = `18` weight_unit = `KG`
        price = '170.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1052.jpg` )
      ( name = `Multi Print` product_id = `HT-1055` quantity = `16` uom = `PC` weight_measure = `6.3` weight_unit = `KG`
        price = '99.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1055.jpg` )
      ( name = `Multi Color` product_id = `HT-1056` quantity = `5` uom = `PC` weight_measure = `4.3` weight_unit = `KG`
        price = '119.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1056.jpg` )
      ( name = `Cordless Mouse` product_id = `HT-1060` quantity = `25` uom = `PC` weight_measure = `0.09` weight_unit = `KG`
        price = '9.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1060.jpg` )
      ( name = `Speed Mouse` product_id = `HT-1061` quantity = `12` uom = `PC` weight_measure = `0.09` weight_unit = `KG`
        price = '7.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1061.jpg` )
      ( name = `Track Mouse` product_id = `HT-1062` quantity = `12` uom = `PC` weight_measure = `0.03` weight_unit = `KG`
        price = '11.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1062.jpg` )
      ( name = `Ergonomic Keyboard` product_id = `HT-1063` quantity = `50` uom = `PC` weight_measure = `2.1` weight_unit = `KG`
        price = '14.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1063.jpg` )
      ( name = `Internet Keyboard` product_id = `HT-1064` quantity = `35` uom = `PC` weight_measure = `1.8` weight_unit = `KG`
        price = '16.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1064.jpg` )
      ( name = `Media Keyboard` product_id = `HT-1065` quantity = `26` uom = `PC` weight_measure = `2.3` weight_unit = `KG`
        price = '26.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1065.jpg` )
      ( name = `Mousepad` product_id = `HT-1066` quantity = `12` uom = `PC` weight_measure = `80` weight_unit = `G`
        price = '6.99' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1066.jpg` )
      ( name = `Ergo Mousepad` product_id = `HT-1067` quantity = `16` uom = `PC` weight_measure = `80` weight_unit = `G`
        price = '8.99' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1067.jpg` )
      ( name = `Designer Mousepad` product_id = `HT-1068` quantity = `26` uom = `PC` weight_measure = `90` weight_unit = `G`
        price = '12.99' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1068.jpg` )
      ( name = `Universal card reader` product_id = `HT-1069` quantity = `22` uom = `PC` weight_measure = `45` weight_unit = `G`
        price = '14.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1069.jpg` )
      ( name = `Proctra X` product_id = `HT-1070` quantity = `15` uom = `PC` weight_measure = `0.255` weight_unit = `KG`
        price = '70.90' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1070.jpg` )
      ( name = `Gladiator MX` product_id = `HT-1071` quantity = `16` uom = `PC` weight_measure = `0.3` weight_unit = `KG`
        price = '81.70' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1071.jpg` )
      ( name = `Hurricane GX` product_id = `HT-1072` quantity = `13` uom = `PC` weight_measure = `0.4` weight_unit = `KG`
        price = '101.20' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1072.jpg` )
      ( name = `Hurricane GX/LN` product_id = `HT-1073` quantity = `5` uom = `PC` weight_measure = `0.4` weight_unit = `KG`
        price = '139.99' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1073.jpg` )
      ( name = `Photo Scan` product_id = `HT-1080` quantity = `8` uom = `PC` weight_measure = `2.3` weight_unit = `KG`
        price = '129.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1080.jpg` )
      ( name = `Power Scan` product_id = `HT-1081` quantity = `11` uom = `PC` weight_measure = `2.4` weight_unit = `KG`
        price = '89.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1081.jpg` )
      ( name = `Jet Scan Professional` product_id = `HT-1082` quantity = `13` uom = `PC` weight_measure = `3.2` weight_unit = `KG`
        price = '169.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1082.jpg` )
      ( name = `Jet Scan Professional` product_id = `HT-1083` quantity = `10` uom = `PC` weight_measure = `3.2` weight_unit = `KG`
        price = '189.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1083.jpg` )
      ( name = `Copymaster` product_id = `HT-1085` quantity = `10` uom = `PC` weight_measure = `23.2` weight_unit = `KG`
        price = '1499.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1085.jpg` )
      ( name = `Surround Sound` product_id = `HT-1090` quantity = `20` uom = `PC` weight_measure = `3` weight_unit = `KG`
        price = '39.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1090.jpg` )
      ( name = `Blaster Extreme` product_id = `HT-1091` quantity = `15` uom = `PC` weight_measure = `1.4` weight_unit = `KG`
        price = '26.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1091.jpg` )
      ( name = `Sound Booster` product_id = `HT-1092` quantity = `50` uom = `PC` weight_measure = `2.1` weight_unit = `KG`
        price = '45.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1092.jpg` )
      ( name = `Lovely Sound 5.1 Wireless` product_id = `HT-1095` quantity = `12` uom = `PC` weight_measure = `80` weight_unit = `G`
        price = '49.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1095.jpg` )
      ( name = `Lovely Sound 5.1` product_id = `HT-1096` quantity = `18` uom = `PC` weight_measure = `130` weight_unit = `G`
        price = '39.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1096.jpg` )
      ( name = `Lovely Sound Stereo` product_id = `HT-1097` quantity = `21` uom = `PC` weight_measure = `60` weight_unit = `G`
        price = '29.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1097.jpg` )
      ( name = `Smart Office` product_id = `HT-1100` quantity = `25` uom = `PC` weight_measure = `1.2` weight_unit = `KG`
        price = '89.90' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1100.jpg` )
      ( name = `Smart Design` product_id = `HT-1101` quantity = `26` uom = `PC` weight_measure = `0.8` weight_unit = `KG`
        price = '79.90' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1101.jpg` )
      ( name = `Smart Network` product_id = `HT-1102` quantity = `28` uom = `PC` weight_measure = `0.8` weight_unit = `KG`
        price = '69.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1102.jpg` )
      ( name = `Smart Multimedia` product_id = `HT-1103` quantity = `9` uom = `PC` weight_measure = `0.8` weight_unit = `KG`
        price = '77.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1103.jpg` )
      ( name = `Smart Games` product_id = `HT-1104` quantity = `13` uom = `PC` weight_measure = `1.1` weight_unit = `KG`
        price = '55.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1104.jpg` )
      ( name = `Smart Internet Antivirus` product_id = `HT-1105` quantity = `17` uom = `PC` weight_measure = `0.7` weight_unit = `KG`
        price = '29.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1105.jpg` )
      ( name = `Smart Firewall` product_id = `HT-1106` quantity = `19` uom = `PC` weight_measure = `0.9` weight_unit = `KG`
        price = '34.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1106.jpg` )
      ( name = `Smart Money` product_id = `HT-1107` quantity = `18` uom = `PC` weight_measure = `0.5` weight_unit = `KG`
        price = '29.90' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1107.jpg` )
      ( name = `PC Lock` product_id = `HT-1110` quantity = `14` uom = `PC` weight_measure = `0.03` weight_unit = `KG`
        price = '8.90' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1110.jpg` )
      ( name = `Notebook Lock` product_id = `HT-1111` quantity = `20` uom = `PC` weight_measure = `0.02` weight_unit = `KG`
        price = '6.90' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1111.jpg` )
      ( name = `Web cam reality` product_id = `HT-1112` quantity = `27` uom = `PC` weight_measure = `0.075` weight_unit = `KG`
        price = '39.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1112.jpg` )
      ( name = `Screen clean` product_id = `HT-1113` quantity = `17` uom = `PC` weight_measure = `0.05` weight_unit = `KG`
        price = '2.30' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1113.jpg` )
      ( name = `Fabric bag professional` product_id = `HT-1114` quantity = `14` uom = `PC` weight_measure = `1.8` weight_unit = `KG`
        price = '31.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1114.jpg` )
      ( name = `Wireless DSL Router` product_id = `HT-1115` quantity = `16` uom = `PC` weight_measure = `0.45` weight_unit = `KG`
        price = '49.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1115.jpg` )
      ( name = `Wireless DSL Router / Repeater` product_id = `HT-1116` quantity = `12` uom = `PC` weight_measure = `0.45` weight_unit = `KG`
        price = '59.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1116.jpg` )
      ( name = `Wireless DSL Router / Repeater and Print Server` product_id = `HT-1117` quantity = `12` uom = `PC` weight_measure = `0.45` weight_unit = `KG`
        price = '69.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1117.jpg` )
      ( name = `USB Stick` product_id = `HT-1118` quantity = `14` uom = `PC` weight_measure = `0.015` weight_unit = `KG`
        price = '35.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1118.jpg` )
      ( name = `Travel Adapter` product_id = `HT-1119` quantity = `10` uom = `PC` weight_measure = `88` weight_unit = `G`
        price = '79.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1119.jpg` )
      ( name = `Cordless Bluetooth Keyboard, english international` product_id = `HT-1120` quantity = `13` uom = `PC` weight_measure = `1` weight_unit = `KG`
        price = '29.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1120.jpg` )
      ( name = `Flat XXL` product_id = `HT-1137` quantity = `10` uom = `PC` weight_measure = `18` weight_unit = `KG`
        price = '1430.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1137.jpg` )
      ( name = `Pocket Mouse` product_id = `HT-1138` quantity = `20` uom = `PC` weight_measure = `0.02` weight_unit = `KG`
        price = '23.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1138.jpg` )
      ( name = `PC Power Station` product_id = `HT-1210` quantity = `22` uom = `PC` weight_measure = `2.3` weight_unit = `KG`
        price = '2399.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1210.jpg` )
      ( name = `Astro Laptop 1516` product_id = `HT-1251` quantity = `23` uom = `PC` weight_measure = `4.2` weight_unit = `KG`
        price = '989.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1251.jpg` )
      ( name = `Astro Phone 6` product_id = `HT-1252` quantity = `28` uom = `PC` weight_measure = `0.75` weight_unit = `KG`
        price = '649.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1252.jpg` )
      ( name = `Benda Laptop 1408` product_id = `HT-1253` quantity = `27` uom = `PC` weight_measure = `4.2` weight_unit = `KG`
        price = '976.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1253.jpg` )
      ( name = `Bending Screen 21HD` product_id = `HT-1254` quantity = `23` uom = `PC` weight_measure = `15` weight_unit = `KG`
        price = '250.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1254.jpg` )
      ( name = `Broad Screen 22HD` product_id = `HT-1255` quantity = `5` uom = `PC` weight_measure = `16` weight_unit = `KG`
        price = '270.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1255.jpg` )
      ( name = `Cerdik Phone 7` product_id = `HT-1256` quantity = `19` uom = `PC` weight_measure = `0.75` weight_unit = `KG`
        price = '549.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1256.jpg` )
      ( name = `Cepat Tablet 10.5` product_id = `HT-1257` quantity = `17` uom = `PC` weight_measure = `2.8` weight_unit = `KG`
        price = '549.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1257.jpg` )
      ( name = `Cepat Tablet 8` product_id = `HT-1258` quantity = `24` uom = `PC` weight_measure = `2.5` weight_unit = `KG`
        price = '529.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1258.jpg` )
      ( name = `Server Basic` product_id = `HT-1500` quantity = `24` uom = `PC` weight_measure = `18` weight_unit = `KG`
        price = '5000.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1500.jpg` )
      ( name = `Server Professional` product_id = `HT-1501` quantity = `26` uom = `PC` weight_measure = `25` weight_unit = `KG`
        price = '15000.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1501.jpg` )
      ( name = `Server Power Pro` product_id = `HT-1502` quantity = `34` uom = `PC` weight_measure = `35` weight_unit = `KG`
        price = '25000.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1502.jpg` )
      ( name = `Family PC Basic` product_id = `HT-1600` quantity = `10` uom = `PC` weight_measure = `4.8` weight_unit = `KG`
        price = '600.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1600.jpg` )
      ( name = `Family PC Pro` product_id = `HT-1601` quantity = `20` uom = `PC` weight_measure = `5.3` weight_unit = `KG`
        price = '900.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1601.jpg` )
      ( name = `Gaming Monster` product_id = `HT-1602` quantity = `24` uom = `PC` weight_measure = `5.9` weight_unit = `KG`
        price = '1200.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1602.jpg` )
      ( name = `Gaming Monster Pro` product_id = `HT-1603` quantity = `25` uom = `PC` weight_measure = `6.8` weight_unit = `KG`
        price = '1700.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1603.jpg` )
      ( name = `7" Widescreen Portable DVD Player w MP3` product_id = `HT-2000` quantity = `20` uom = `PC` weight_measure = `0.79` weight_unit = `KG`
        price = '249.99' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2000.jpg` )
      ( name = `10" Portable DVD player` product_id = `HT-2001` quantity = `21` uom = `PC` weight_measure = `0.84` weight_unit = `KG`
        price = '449.99' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2001.jpg` )
      ( name = `Portable DVD Player with 9" LCD Monitor` product_id = `HT-2002` quantity = `50` uom = `PC` weight_measure = `0.72` weight_unit = `KG`
        price = '853.99' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2002.jpg` )
      ( name = `CD/DVD case: 264 sleeves` product_id = `HT-2025` quantity = `26` uom = `PC` weight_measure = `0.65` weight_unit = `KG`
        price = '44.99' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2025.jpg` )
      ( name = `Audio/Video Cable Kit - 4m` product_id = `HT-2026` quantity = `16` uom = `PC` weight_measure = `0.2` weight_unit = `KG`
        price = '29.99' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2026.jpg` )
      ( name = `Removable CD/DVD Laser Labels` product_id = `HT-2027` quantity = `25` uom = `PC` weight_measure = `0.15` weight_unit = `KG`
        price = '8.99' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2027.jpg` )
      ( name = `Beam Breaker B-1` product_id = `HT-6100` quantity = `32` uom = `PC` weight_measure = `1.7` weight_unit = `KG`
        price = '469.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6100.jpg` )
      ( name = `Beam Breaker B-2` product_id = `HT-6101` quantity = `18` uom = `PC` weight_measure = `2` weight_unit = `KG`
        price = '679.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6101.jpg` )
      ( name = `Beam Breaker B-3` product_id = `HT-6102` quantity = `16` uom = `PC` weight_measure = `2.5` weight_unit = `KG`
        price = '889.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6102.jpg` )
      ( name = `Play Movie` product_id = `HT-6110` quantity = `15` uom = `PC` weight_measure = `2.4` weight_unit = `KG`
        price = '130.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6110.jpg` )
      ( name = `Record Movie` product_id = `HT-6111` quantity = `24` uom = `PC` weight_measure = `3.1` weight_unit = `KG`
        price = '288.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6111.jpg` )
      ( name = `ITelo MusicStick` product_id = `HT-6120` quantity = `15` uom = `PC` weight_measure = `134` weight_unit = `G`
        price = '45.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6120.jpg` )
      ( name = `ITelo Jog-Mate` product_id = `HT-6121` quantity = `24` uom = `PC` weight_measure = `134` weight_unit = `G`
        price = '63.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6121.jpg` )
      ( name = `Power Pro Player 40` product_id = `HT-6122` quantity = `23` uom = `PC` weight_measure = `266` weight_unit = `G`
        price = '167.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6122.jpg` )
      ( name = `Power Pro Player 80` product_id = `HT-6123` quantity = `13` uom = `PC` weight_measure = `267` weight_unit = `G`
        price = '299.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6123.jpg` )
      ( name = `Flat Watch HD32` product_id = `HT-6130` quantity = `16` uom = `PC` weight_measure = `2.6` weight_unit = `KG`
        price = '1459.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6130.jpg` )
      ( name = `Flat Watch HD37` product_id = `HT-6131` quantity = `14` uom = `PC` weight_measure = `2.2` weight_unit = `KG`
        price = '1199.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6131.jpg` )
      ( name = `Flat Watch HD41` product_id = `HT-6132` quantity = `13` uom = `PC` weight_measure = `1.8` weight_unit = `KG`
        price = '899.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6132.jpg` )
      ( name = `Copperberry` product_id = `HT-7000` quantity = `5` uom = `PC` weight_measure = `0.5` weight_unit = `KG`
        price = '549.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7000.jpg` )
      ( name = `Silverberry` product_id = `HT-7010` quantity = `9` uom = `PC` weight_measure = `0.5` weight_unit = `KG`
        price = '549.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7010.jpg` )
      ( name = `Goldberry` product_id = `HT-7020` quantity = `11` uom = `PC` weight_measure = `0.5` weight_unit = `KG`
        price = '549.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7020.jpg` )
      ( name = `Platinberry` product_id = `HT-7030` quantity = `12` uom = `PC` weight_measure = `0.5` weight_unit = `KG`
        price = '549.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7030.jpg` )
      ( name = `ITelO FlexTop I4000` product_id = `HT-8000` quantity = `11` uom = `PC` weight_measure = `4` weight_unit = `KG`
        price = '799.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8000.jpg` )
      ( name = `ITelO FlexTop I6300c` product_id = `HT-8001` quantity = `20` uom = `PC` weight_measure = `4.2` weight_unit = `KG`
        price = '799.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8001.jpg` )
      ( name = `ITelO FlexTop I9100` product_id = `HT-8002` quantity = `20` uom = `PC` weight_measure = `3.5` weight_unit = `KG`
        price = '1199.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8002.jpg` )
      ( name = `ITelO FlexTop I9800` product_id = `HT-8003` quantity = `22` uom = `PC` weight_measure = `3.8` weight_unit = `KG`
        price = '1388.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8003.jpg` )
      ( name = `Smartphone Leather Case` product_id = `HT-9991` quantity = `12` uom = `PC` weight_measure = `0.02` weight_unit = `KG`
        price = '25.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9991.jpg` )
      ( name = `Smartphone Alpha` product_id = `HT-9992` quantity = `13` uom = `PC` weight_measure = `0.75` weight_unit = `KG`
        price = '599.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9992.jpg` )
      ( name = `Mini Tablet` product_id = `HT-9993` quantity = `10` uom = `PC` weight_measure = `3.8` weight_unit = `KG`
        price = '833.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9993.jpg` )
      ( name = `Camcorder View` product_id = `HT-9994` quantity = `50` uom = `PC` weight_measure = `3.8` weight_unit = `KG`
        price = '1388.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9994.jpg` )
      ( name = `Tablet Pouch` product_id = `HT-9995` quantity = `34` uom = `PC` weight_measure = `0.03` weight_unit = `KG`
        price = '20.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9995.jpg` )
      ( name = `Tablet Pouch` product_id = `HT-9996` quantity = `34` uom = `PC` weight_measure = `0.03` weight_unit = `KG`
        price = '20.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9996.jpg` )
      ( name = `e-Book Reader ReadMe` product_id = `HT-9997` quantity = `23` uom = `PC` weight_measure = `3.8` weight_unit = `KG`
        price = '33.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9997.jpg` )
      ( name = `Smartphone Beta` product_id = `HT-9998` quantity = `21` uom = `PC` weight_measure = `0.75` weight_unit = `KG`
        price = '30.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9998.jpg` )
      ( name = `Maxi Tablet` product_id = `HT-9999` quantity = `20` uom = `PC` weight_measure = `3.8` weight_unit = `KG`
        price = '749.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9999.jpg` )
      ( name = `Flyer` product_id = `PF-1000` quantity = `33` uom = `PC` weight_measure = `0.01` weight_unit = `KG`
        price = '0.00' currency_code = `EUR` product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/PF-1000.jpg` ) ).

  ENDMETHOD.

ENDCLASS.
