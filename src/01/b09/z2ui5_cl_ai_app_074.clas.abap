CLASS z2ui5_cl_ai_app_074 DEFINITION PUBLIC.

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
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_074 IMPLEMENTATION.

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

        )->open( `List`
            )->a( n = `items`      v = client->_bind( t_products )
            )->a( n = `headerText` v = `Products`

            )->open( `ObjectListItem`
                )->a( n = `title`      v = `{NAME}`
                )->a( n = `type`       v = `Active`
                )->a( n = `press`      v = client->_event( val = `PRESS` t_arg = VALUE #( ( `${NAME}` ) ) )
                )->a( n = `number`     v = |\{ parts:[\{path:'PRICE'\},\{path:'CURRENCY_CODE'\}], type: 'sap.ui.model.type.Currency', formatOptions: \{showMeasure: false\} \}|
                )->a( n = `numberUnit` v = `{CURRENCY_CODE}`

                )->open( `firstStatus`
                    )->leaf( `ObjectStatus`
                        )->a( n = `text`  v = `{STATUS}`
                        " the original's '.formatter.status' (Status -> ValueState) is precomputed into STATUS_STATE
                        )->a( n = `state` v = `{STATUS_STATE}`

                )->shut(
                )->leaf( `ObjectAttribute`
                    )->a( n = `text` v = `{WEIGHT_MEASURE} {WEIGHT_UNIT}`
                )->leaf( `ObjectAttribute`
                    )->a( n = `text` v = `{WIDTH} x {DEPTH} x {HEIGHT} {DIM_UNIT}`

            )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `PRESS`.
        " the original's onListItemPress - MessageToast.show("Pressed : " + title)
        client->message_toast_display( |Pressed : { client->get_event_arg( ) }| ).
    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " full mock /ProductCollection (sap/ui/demo/mock/products.json); STATUS_STATE precomputes the sample's '.formatter.status'
    t_products = VALUE #(
      ( name = `Notebook Basic 15`                                  price = '956.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `4.2` weight_unit = `KG` width = `30` depth = `18` height = `3` dim_unit = `cm` )
      ( name = `Notebook Basic 17`                                  price = '1249.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `4.5` weight_unit = `KG` width = `29` depth = `17` height = `3.1` dim_unit = `cm` )
      ( name = `Notebook Basic 18`                                  price = '1570.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `4.2` weight_unit = `KG` width = `28` depth = `19` height = `2.5` dim_unit = `cm` )
      ( name = `Notebook Basic 19`                                  price = '1650.00' currency_code = `EUR` status = `Out of Stock` status_state = `Warning`
        weight_measure = `4.2` weight_unit = `KG` width = `32` depth = `21` height = `4` dim_unit = `cm` )
      ( name = `ITelO Vault`                                        price = '299.00' currency_code = `EUR` status = `Out of Stock` status_state = `Warning`
        weight_measure = `0.2` weight_unit = `KG` width = `32` depth = `22` height = `3` dim_unit = `cm` )
      ( name = `Notebook Professional 15`                           price = '1999.00' currency_code = `EUR` status = `Out of Stock` status_state = `Warning`
        weight_measure = `4.3` weight_unit = `KG` width = `33` depth = `20` height = `3` dim_unit = `cm` )
      ( name = `Notebook Professional 17`                           price = '2299.00' currency_code = `EUR` status = `Out of Stock` status_state = `Warning`
        weight_measure = `4.1` weight_unit = `KG` width = `33` depth = `23` height = `2` dim_unit = `cm` )
      ( name = `ITelO Vault Net`                                    price = '459.00' currency_code = `EUR` status = `Discontinued` status_state = `Error`
        weight_measure = `0.16` weight_unit = `KG` width = `10` depth = `1.8` height = `17` dim_unit = `cm` )
      ( name = `ITelO Vault SAT`                                    price = '149.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `0.18` weight_unit = `KG` width = `11` depth = `1.7` height = `18` dim_unit = `cm` )
      ( name = `Comfort Easy`                                       price = '1679.00' currency_code = `EUR` status = `Out of Stock` status_state = `Warning`
        weight_measure = `0.2` weight_unit = `KG` width = `84` depth = `1.5` height = `14` dim_unit = `cm` )
      ( name = `Comfort Senior`                                     price = '512.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `0.8` weight_unit = `KG` width = `80` depth = `1.6` height = `13` dim_unit = `cm` )
      ( name = `Ergo Screen E-I`                                    price = '230.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `21` weight_unit = `KG` width = `37` depth = `12` height = `36` dim_unit = `cm` )
      ( name = `Ergo Screen E-II`                                   price = '285.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `21` weight_unit = `KG` width = `40.8` depth = `19` height = `43` dim_unit = `cm` )
      ( name = `Ergo Screen E-III`                                  price = '345.00' currency_code = `EUR` status = `Out of Stock` status_state = `Warning`
        weight_measure = `21` weight_unit = `KG` width = `40.8` depth = `19` height = `43` dim_unit = `cm` )
      ( name = `Flat Basic`                                         price = '399.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `14` weight_unit = `KG` width = `39` depth = `20` height = `41` dim_unit = `cm` )
      ( name = `Flat Future`                                        price = '430.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `15` weight_unit = `KG` width = `45` depth = `26` height = `46` dim_unit = `cm` )
      ( name = `Flat XL`                                            price = '1230.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `17` weight_unit = `KG` width = `54.5` depth = `22.1` height = `39.1` dim_unit = `cm` )
      ( name = `Laser Professional Eco`                             price = '830.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `32` weight_unit = `KG` width = `51` depth = `46` height = `30` dim_unit = `cm` )
      ( name = `Laser Basic`                                        price = '490.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `23` weight_unit = `KG` width = `48` depth = `42` height = `26` dim_unit = `cm` )
      ( name = `Laser Allround`                                     price = '349.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `17` weight_unit = `KG` width = `53` depth = `50` height = `65` dim_unit = `cm` )
      ( name = `Ultra Jet Super Color`                              price = '139.00' currency_code = `EUR` status = `Discontinued` status_state = `Error`
        weight_measure = `3` weight_unit = `KG` width = `41` depth = `41` height = `28` dim_unit = `cm` )
      ( name = `Ultra Jet Mobile`                                   price = '99.00' currency_code = `EUR` status = `Discontinued` status_state = `Error`
        weight_measure = `1.9` weight_unit = `KG` width = `46` depth = `32` height = `25` dim_unit = `cm` )
      ( name = `Ultra Jet Super Highspeed`                          price = '170.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `18` weight_unit = `KG` width = `41` depth = `41` height = `28` dim_unit = `cm` )
      ( name = `Multi Print`                                        price = '99.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `6.3` weight_unit = `KG` width = `55` depth = `45` height = `29` dim_unit = `cm` )
      ( name = `Multi Color`                                        price = '119.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `4.3` weight_unit = `KG` width = `51` depth = `41.3` height = `22` dim_unit = `cm` )
      ( name = `Cordless Mouse`                                     price = '9.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `0.09` weight_unit = `KG` width = `6` depth = `14.5` height = `3.5` dim_unit = `cm` )
      ( name = `Speed Mouse`                                        price = '7.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `0.09` weight_unit = `KG` width = `7` depth = `15` height = `3.1` dim_unit = `cm` )
      ( name = `Track Mouse`                                        price = '11.00' currency_code = `EUR` status = `Discontinued` status_state = `Error`
        weight_measure = `0.03` weight_unit = `KG` width = `3` depth = `7` height = `4` dim_unit = `cm` )
      ( name = `Ergonomic Keyboard`                                 price = '14.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `2.1` weight_unit = `KG` width = `50` depth = `21` height = `3.5` dim_unit = `cm` )
      ( name = `Internet Keyboard`                                  price = '16.00' currency_code = `EUR` status = `Out of Stock` status_state = `Warning`
        weight_measure = `1.8` weight_unit = `KG` width = `52` depth = `25` height = `3` dim_unit = `cm` )
      ( name = `Media Keyboard`                                     price = '26.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `2.3` weight_unit = `KG` width = `51.4` depth = `23` height = `4` dim_unit = `cm` )
      ( name = `Mousepad`                                           price = '6.99' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `80` weight_unit = `G` width = `15` depth = `6` height = `0.2` dim_unit = `cm` )
      ( name = `Ergo Mousepad`                                      price = '8.99' currency_code = `EUR` status = `Out of Stock` status_state = `Warning`
        weight_measure = `80` weight_unit = `G` width = `15` depth = `6` height = `0.2` dim_unit = `cm` )
      ( name = `Designer Mousepad`                                  price = '12.99' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `90` weight_unit = `G` width = `24` depth = `24` height = `0.6` dim_unit = `cm` )
      ( name = `Universal card reader`                              price = '14.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `45` weight_unit = `G` width = `6` depth = `6` height = `3` dim_unit = `cm` )
      ( name = `Proctra X`                                          price = '70.90' currency_code = `EUR` status = `Out of Stock` status_state = `Warning`
        weight_measure = `0.255` weight_unit = `KG` width = `22` depth = `35` height = `17` dim_unit = `cm` )
      ( name = `Gladiator MX`                                       price = '81.70' currency_code = `EUR` status = `Discontinued` status_state = `Error`
        weight_measure = `0.3` weight_unit = `KG` width = `22` depth = `35` height = `17` dim_unit = `cm` )
      ( name = `Hurricane GX`                                       price = '101.20' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `0.4` weight_unit = `KG` width = `22` depth = `35` height = `17` dim_unit = `cm` )
      ( name = `Hurricane GX/LN`                                    price = '139.99' currency_code = `EUR` status = `Out of Stock` status_state = `Warning`
        weight_measure = `0.4` weight_unit = `KG` width = `22` depth = `35` height = `17` dim_unit = `cm` )
      ( name = `Photo Scan`                                         price = '129.00' currency_code = `EUR` status = `Out of Stock` status_state = `Warning`
        weight_measure = `2.3` weight_unit = `KG` width = `34` depth = `48` height = `5` dim_unit = `cm` )
      ( name = `Power Scan`                                         price = '89.00' currency_code = `EUR` status = `Out of Stock` status_state = `Warning`
        weight_measure = `2.4` weight_unit = `KG` width = `31` depth = `43` height = `7` dim_unit = `cm` )
      ( name = `Jet Scan Professional`                              price = '169.00' currency_code = `EUR` status = `Out of Stock` status_state = `Warning`
        weight_measure = `3.2` weight_unit = `KG` width = `33` depth = `41` height = `12` dim_unit = `cm` )
      ( name = `Jet Scan Professional`                              price = '189.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `3.2` weight_unit = `KG` width = `35` depth = `40` height = `10` dim_unit = `cm` )
      ( name = `Copymaster`                                         price = '1499.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `23.2` weight_unit = `KG` width = `45` depth = `42` height = `22` dim_unit = `cm` )
      ( name = `Surround Sound`                                     price = '39.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `3` weight_unit = `KG` width = `12` depth = `10` height = `16` dim_unit = `cm` )
      ( name = `Blaster Extreme`                                    price = '26.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `1.4` weight_unit = `KG` width = `13` depth = `11` height = `17.5` dim_unit = `cm` )
      ( name = `Sound Booster`                                      price = '45.00' currency_code = `EUR` status = `Discontinued` status_state = `Error`
        weight_measure = `2.1` weight_unit = `KG` width = `12.4` depth = `10.4` height = `18.1` dim_unit = `cm` )
      ( name = `Lovely Sound 5.1 Wireless`                          price = '49.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `80` weight_unit = `G` width = `24` depth = `19` height = `23` dim_unit = `cm` )
      ( name = `Lovely Sound 5.1`                                   price = '39.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `130` weight_unit = `G` width = `25` depth = `17` height = `19` dim_unit = `cm` )
      ( name = `Lovely Sound Stereo`                                price = '29.00' currency_code = `EUR` status = `Out of Stock` status_state = `Warning`
        weight_measure = `60` weight_unit = `G` width = `21.3` depth = `2.4` height = `19.7` dim_unit = `cm` )
      ( name = `Smart Office`                                       price = '89.90' currency_code = `EUR` status = `Out of Stock` status_state = `Warning`
        weight_measure = `1.2` weight_unit = `KG` width = `15` depth = `6.5` height = `2.1` dim_unit = `cm` )
      ( name = `Smart Design`                                       price = '79.90' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `0.8` weight_unit = `KG` width = `14` depth = `6.7` height = `24` dim_unit = `cm` )
      ( name = `Smart Network`                                      price = '69.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `0.8` weight_unit = `KG` width = `16` depth = `6` height = `27` dim_unit = `cm` )
      ( name = `Smart Multimedia`                                   price = '77.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `0.8` weight_unit = `KG` width = `11` depth = `3.4` height = `22` dim_unit = `cm` )
      ( name = `Smart Games`                                        price = '55.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `1.1` weight_unit = `KG` width = `10` depth = `3` height = `30` dim_unit = `cm` )
      ( name = `Smart Internet Antivirus`                           price = '29.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `0.7` weight_unit = `KG` width = `16` depth = `4` height = `21` dim_unit = `cm` )
      ( name = `Smart Firewall`                                     price = '34.00' currency_code = `EUR` status = `Discontinued` status_state = `Error`
        weight_measure = `0.9` weight_unit = `KG` width = `17.9` depth = `4.2` height = `23.1` dim_unit = `cm` )
      ( name = `Smart Money`                                        price = '29.90' currency_code = `EUR` status = `Out of Stock` status_state = `Warning`
        weight_measure = `0.5` weight_unit = `KG` width = `12` depth = `1.5` height = `19` dim_unit = `cm` )
      ( name = `PC Lock`                                            price = '8.90' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `0.03` weight_unit = `KG` width = `20` depth = `8` height = `4.3` dim_unit = `cm` )
      ( name = `Notebook Lock`                                      price = '6.90' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `0.02` weight_unit = `KG` width = `31` depth = `9` height = `7` dim_unit = `cm` )
      ( name = `Web cam reality`                                    price = '39.00' currency_code = `EUR` status = `Out of Stock` status_state = `Warning`
        weight_measure = `0.075` weight_unit = `KG` width = `9` depth = `8.2` height = `1.3` dim_unit = `cm` )
      ( name = `Screen clean`                                       price = '2.30' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `0.05` weight_unit = `KG` width = `2` depth = `2` height = `0.1` dim_unit = `cm` )
      ( name = `Fabric bag professional`                            price = '31.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `1.8` weight_unit = `KG` width = `42` depth = `32` height = `7` dim_unit = `cm` )
      ( name = `Wireless DSL Router`                                price = '49.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `0.45` weight_unit = `KG` width = `19.3` depth = `18` height = `5` dim_unit = `cm` )
      ( name = `Wireless DSL Router / Repeater`                     price = '59.00' currency_code = `EUR` status = `Out of Stock` status_state = `Warning`
        weight_measure = `0.45` weight_unit = `KG` width = `19.3` depth = `18` height = `5` dim_unit = `cm` )
      ( name = `Wireless DSL Router / Repeater and Print Server`    price = '69.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `0.45` weight_unit = `KG` width = `19.3` depth = `18` height = `5` dim_unit = `cm` )
      ( name = `USB Stick`                                          price = '35.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `0.015` weight_unit = `KG` width = `1.5` depth = `8.7` height = `1.2` dim_unit = `cm` )
      ( name = `Travel Adapter`                                     price = '79.00' currency_code = `EUR` status = `Discontinued` status_state = `Error`
        weight_measure = `88` weight_unit = `G` width = `2` depth = `3.1` height = `3.9` dim_unit = `cm` )
      ( name = `Cordless Bluetooth Keyboard, english international` price = '29.00' currency_code = `EUR` status = `Out of Stock` status_state = `Warning`
        weight_measure = `1` weight_unit = `KG` width = `51.4` depth = `23` height = `4` dim_unit = `cm` )
      ( name = `Flat XXL`                                           price = '1430.00' currency_code = `EUR` status = `Discontinued` status_state = `Error`
        weight_measure = `18` weight_unit = `KG` width = `54` depth = `22` height = `38` dim_unit = `cm` )
      ( name = `Pocket Mouse`                                       price = '23.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `0.02` weight_unit = `KG` width = `0.3` depth = `0.5` height = `1` dim_unit = `cm` )
      ( name = `PC Power Station`                                   price = '2399.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `2.3` weight_unit = `KG` width = `28` depth = `31` height = `43` dim_unit = `cm` )
      ( name = `Astro Laptop 1516`                                  price = '989.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `4.2` weight_unit = `KG` width = `30` depth = `18` height = `3` dim_unit = `cm` )
      ( name = `Astro Phone 6`                                      price = '649.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `0.75` weight_unit = `KG` width = `8` depth = `6` height = `1.5` dim_unit = `cm` )
      ( name = `Benda Laptop 1408`                                  price = '976.00' currency_code = `EUR` status = `Discontinued` status_state = `Error`
        weight_measure = `4.2` weight_unit = `KG` width = `30` depth = `18` height = `3` dim_unit = `cm` )
      ( name = `Bending Screen 21HD`                                price = '250.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `15` weight_unit = `KG` width = `37` depth = `12` height = `36` dim_unit = `cm` )
      ( name = `Broad Screen 22HD`                                  price = '270.00' currency_code = `EUR` status = `Discontinued` status_state = `Error`
        weight_measure = `16` weight_unit = `KG` width = `39` depth = `12` height = `38` dim_unit = `cm` )
      ( name = `Cerdik Phone 7`                                     price = '549.00' currency_code = `EUR` status = `Discontinued` status_state = `Error`
        weight_measure = `0.75` weight_unit = `KG` width = `9` depth = `15` height = `1.5` dim_unit = `cm` )
      ( name = `Cepat Tablet 10.5`                                  price = '549.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `2.8` weight_unit = `KG` width = `48` depth = `31` height = `4.5` dim_unit = `cm` )
      ( name = `Cepat Tablet 8`                                     price = '529.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `2.5` weight_unit = `KG` width = `38` depth = `21` height = `3.5` dim_unit = `cm` )
      ( name = `Server Basic`                                       price = '5000.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `18` weight_unit = `KG` width = `34` depth = `35` height = `23` dim_unit = `cm` )
      ( name = `Server Professional`                                price = '15000.00' currency_code = `EUR` status = `Out of Stock` status_state = `Warning`
        weight_measure = `25` weight_unit = `KG` width = `29` depth = `30` height = `27` dim_unit = `cm` )
      ( name = `Server Power Pro`                                   price = '25000.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `35` weight_unit = `KG` width = `22` depth = `27.3` height = `37` dim_unit = `cm` )
      ( name = `Family PC Basic`                                    price = '600.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `4.8` weight_unit = `KG` width = `21.4` depth = `29` height = `38` dim_unit = `cm` )
      ( name = `Family PC Pro`                                      price = '900.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `5.3` weight_unit = `KG` width = `25` depth = `31.7` height = `40.2` dim_unit = `cm` )
      ( name = `Gaming Monster`                                     price = '1200.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `5.9` weight_unit = `KG` width = `26.5` depth = `34` height = `47` dim_unit = `cm` )
      ( name = `Gaming Monster Pro`                                 price = '1700.00' currency_code = `EUR` status = `Discontinued` status_state = `Error`
        weight_measure = `6.8` weight_unit = `KG` width = `27` depth = `28` height = `42` dim_unit = `cm` )
      ( name = `7" Widescreen Portable DVD Player w MP3`            price = '249.99' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `0.79` weight_unit = `KG` width = `21.4` depth = `19` height = `27.6` dim_unit = `cm` )
      ( name = `10" Portable DVD player`                            price = '449.99' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `0.84` weight_unit = `KG` width = `24` depth = `19.5` height = `29` dim_unit = `cm` )
      ( name = `Portable DVD Player with 9" LCD Monitor`            price = '853.99' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `0.72` weight_unit = `KG` width = `21` depth = `16.5` height = `14` dim_unit = `cm` )
      ( name = `CD/DVD case: 264 sleeves`                           price = '44.99' currency_code = `EUR` status = `Discontinued` status_state = `Error`
        weight_measure = `0.65` weight_unit = `KG` width = `13` depth = `13` height = `20` dim_unit = `cm` )
      ( name = `Audio/Video Cable Kit - 4m`                         price = '29.99' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `0.2` weight_unit = `KG` width = `21` depth = `10.2` height = `13` dim_unit = `cm` )
      ( name = `Removable CD/DVD Laser Labels`                      price = '8.99' currency_code = `EUR` status = `Discontinued` status_state = `Error`
        weight_measure = `0.15` weight_unit = `KG` width = `5.5` depth = `2` height = `2` dim_unit = `cm` )
      ( name = `Beam Breaker B-1`                                   price = '469.00' currency_code = `EUR` status = `Out of Stock` status_state = `Warning`
        weight_measure = `1.7` weight_unit = `KG` width = `30.4` depth = `23.1` height = `23` dim_unit = `cm` )
      ( name = `Beam Breaker B-2`                                   price = '679.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `2` weight_unit = `KG` width = `30.4` depth = `23.1` height = `23` dim_unit = `cm` )
      ( name = `Beam Breaker B-3`                                   price = '889.00' currency_code = `EUR` status = `Out of Stock` status_state = `Warning`
        weight_measure = `2.5` weight_unit = `KG` width = `30.4` depth = `23.1` height = `23` dim_unit = `cm` )
      ( name = `Play Movie`                                         price = '130.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `2.4` weight_unit = `KG` width = `37` depth = `24` height = `6` dim_unit = `cm` )
      ( name = `Record Movie`                                       price = '288.00' currency_code = `EUR` status = `Discontinued` status_state = `Error`
        weight_measure = `3.1` weight_unit = `KG` width = `38` depth = `26` height = `6.2` dim_unit = `cm` )
      ( name = `ITelo MusicStick`                                   price = '45.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `134` weight_unit = `G` width = `1.5` depth = `6` height = `1` dim_unit = `cm` )
      ( name = `ITelo Jog-Mate`                                     price = '63.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `134` weight_unit = `G` width = `5.1` depth = `8` height = `9.2` dim_unit = `cm` )
      ( name = `Power Pro Player 40`                                price = '167.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `266` weight_unit = `G` width = `5.1` depth = `8` height = `9.2` dim_unit = `cm` )
      ( name = `Power Pro Player 80`                                price = '299.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `267` weight_unit = `G` width = `4` depth = `6` height = `0.8` dim_unit = `cm` )
      ( name = `Flat Watch HD32`                                    price = '1459.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `2.6` weight_unit = `KG` width = `78` depth = `22.1` height = `55` dim_unit = `cm` )
      ( name = `Flat Watch HD37`                                    price = '1199.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `2.2` weight_unit = `KG` width = `99.1` depth = `26` height = `61` dim_unit = `cm` )
      ( name = `Flat Watch HD41`                                    price = '899.00' currency_code = `EUR` status = `Discontinued` status_state = `Error`
        weight_measure = `1.8` weight_unit = `KG` width = `128` depth = `23` height = `79.1` dim_unit = `cm` )
      ( name = `Copperberry`                                        price = '549.00' currency_code = `EUR` status = `Discontinued` status_state = `Error`
        weight_measure = `0.5` weight_unit = `KG` width = `8.1` depth = `13` height = `12.1` dim_unit = `cm` )
      ( name = `Silverberry`                                        price = '549.00' currency_code = `EUR` status = `Discontinued` status_state = `Error`
        weight_measure = `0.5` weight_unit = `KG` width = `8.1` depth = `13` height = `12.1` dim_unit = `cm` )
      ( name = `Goldberry`                                          price = '549.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `0.5` weight_unit = `KG` width = `8.1` depth = `13` height = `12.1` dim_unit = `cm` )
      ( name = `Platinberry`                                        price = '549.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `0.5` weight_unit = `KG` width = `8.1` depth = `13` height = `12.1` dim_unit = `cm` )
      ( name = `ITelO FlexTop I4000`                                price = '799.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `4` weight_unit = `KG` width = `31` depth = `19` height = `3.1` dim_unit = `cm` )
      ( name = `ITelO FlexTop I6300c`                               price = '799.00' currency_code = `EUR` status = `Discontinued` status_state = `Error`
        weight_measure = `4.2` weight_unit = `KG` width = `32` depth = `20` height = `3.4` dim_unit = `cm` )
      ( name = `ITelO FlexTop I9100`                                price = '1199.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `3.5` weight_unit = `KG` width = `38` depth = `21` height = `4.1` dim_unit = `cm` )
      ( name = `ITelO FlexTop I9800`                                price = '1388.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `3.8` weight_unit = `KG` width = `48` depth = `31` height = `4.5` dim_unit = `cm` )
      ( name = `Smartphone Leather Case`                            price = '25.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `0.02` weight_unit = `KG` width = `48` depth = `31` height = `4.5` dim_unit = `cm` )
      ( name = `Smartphone Alpha`                                   price = '599.00' currency_code = `EUR` status = `Out of Stock` status_state = `Warning`
        weight_measure = `0.75` weight_unit = `KG` width = `48` depth = `31` height = `4.5` dim_unit = `cm` )
      ( name = `Mini Tablet`                                        price = '833.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `3.8` weight_unit = `KG` width = `48` depth = `31` height = `4.5` dim_unit = `cm` )
      ( name = `Camcorder View`                                     price = '1388.00' currency_code = `EUR` status = `Out of Stock` status_state = `Warning`
        weight_measure = `3.8` weight_unit = `KG` width = `48` depth = `31` height = `27` dim_unit = `cm` )
      ( name = `Tablet Pouch`                                       price = '20.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `0.03` weight_unit = `KG` width = `25` depth = `40` height = `4.5` dim_unit = `cm` )
      ( name = `Tablet Pouch`                                       price = '20.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `0.03` weight_unit = `KG` width = `25` depth = `40` height = `4.5` dim_unit = `cm` )
      ( name = `e-Book Reader ReadMe`                               price = '33.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `3.8` weight_unit = `KG` width = `48` depth = `31` height = `4.5` dim_unit = `cm` )
      ( name = `Smartphone Beta`                                    price = '30.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `0.75` weight_unit = `KG` width = `48` depth = `31` height = `4.5` dim_unit = `cm` )
      ( name = `Maxi Tablet`                                        price = '749.00' currency_code = `EUR` status = `Available` status_state = `Success`
        weight_measure = `3.8` weight_unit = `KG` width = `48` depth = `31` height = `4.5` dim_unit = `cm` )
      ( name = `Flyer`                                              price = '0.00' currency_code = `EUR` status = `Out of Stock` status_state = `Warning`
        weight_measure = `0.01` weight_unit = `KG` width = `46` depth = `30` height = `3` dim_unit = `cm` ) ).

  ENDMETHOD.

ENDCLASS.
