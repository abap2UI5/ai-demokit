" @keywords table sap.m tableeditable page overflowtoolbar button column columnlistitem objectidentifier objectnumber input paste
CLASS z2ui5_cl_smpc_app_570 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             productid     TYPE string,
             name          TYPE string,
             quantity      TYPE string,
             uom           TYPE string,
             weightmeasure TYPE string,
             weightunit    TYPE string,
             " Formatter.weightState, computed in the backend (thin frontend)
             weight_state  TYPE string,
             price         TYPE p LENGTH 9 DECIMALS 2,
             currencycode  TYPE string,
           END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

    DATA t_products TYPE ty_t_product.
    " onEdit keeps a deepExtend copy so onCancel can put it back
    DATA t_backup   TYPE ty_t_product.
    DATA edit_mode  TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_570 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    DATA(page) = view->ele( n = `View` ns = `mvc`
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->ele( `Page`
            )->a( n = `showHeader`      v = `false`
            )->a( n = `enableScrolling` v = `true`
            )->a( n = `class`           v = `sapUiContentPadding`
            )->a( n = `showNavButton`   v = `false` ).

    page->ele( `footer`
        )->ele( `OverflowToolbar`
            )->a( n = `id` v = `otbFooter`

            )->tag( `ToolbarSpacer`
            )->ele( `Button`
                )->a( n = `text`  v = `Order`
                " onOrder shows a static toast - composed on the client
                )->a( n = `press` v = client->follow_up_action(
                          val   = client->cs_event-control_global
                          t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Order button pressed` ) ) )

                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `NeverOverflow`

                )->end(
            )->end(
        )->end(
    )->end( ).

    DATA(cells) = page->ele( `content`
        )->ele( `Table`
            )->a( n = `id`               v = `idProductsTable`
            )->a( n = `growing`          v = `true`
            )->a( n = `growingThreshold` v = `10`
            )->a( n = `items`            v = client->_bind( t_products )
            " onPaste toasts the pasted data - composed on the client
            )->a( n = `paste`            v = client->follow_up_action(
                      val   = client->cs_event-control_global
                      t_arg = VALUE #( ( `MESSAGE_TOAST` )
                                       ( `show` )
                                       ( `Pasted Data: {0}` )
                                       ( `${$parameters>/data}` ) ) )

            )->ele( `headerToolbar`
                )->ele( `OverflowToolbar`
                    )->a( n = `id` v = `otbSubheader`

                    )->tag( `Title`
                        )->a( n = `text`  v = `Products`
                        )->a( n = `level` v = `H2`
                    )->tag( `ToolbarSpacer`
                    )->tag( `Button`
                        )->a( n = `id`      v = `editButton`
                        )->a( n = `text`    v = `Edit`
                        )->a( n = `type`    v = `Transparent`
                        )->a( n = `visible` v = |\{= !$\{{ client->_bind( val = edit_mode path = abap_true ) }\} \}|
                        )->a( n = `press`   v = client->_event( `EDIT` )
                    )->tag( `Button`
                        )->a( n = `id`      v = `saveButton`
                        )->a( n = `text`    v = `Save`
                        )->a( n = `type`    v = `Transparent`
                        )->a( n = `visible` v = client->_bind( edit_mode )
                        )->a( n = `press`   v = client->_event( `SAVE` )
                    )->tag( `Button`
                        )->a( n = `id`      v = `cancelButton`
                        )->a( n = `text`    v = `Cancel`
                        )->a( n = `type`    v = `Transparent`
                        )->a( n = `visible` v = client->_bind( edit_mode )
                        )->a( n = `press`   v = client->_event( `CANCEL` )

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
                    )->a( n = `hAlign`         v = `End`

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
                        )->a( n = `text` v = `Price`

                )->end(
            )->end(
            )->ele( `items`
                )->ele( `ColumnListItem`
                    )->a( n = `vAlign` v = `Middle`

                    )->ele( `cells` ).

    " onEdit / onSave / onCancel rebind the SAME table between a read-only and an
    " editable ColumnListItem template. abap2UI5 rebuilds the view per round trip,
    " so the two templates are the two branches below
    IF edit_mode = abap_true.
      cells->tag( `Input`
          )->a( n = `value` v = `{NAME}`
          )->tag( `Input`
              )->a( n = `value`       v = `{QUANTITY}`
              )->a( n = `description` v = `{UOM}`
          )->tag( `Input`
              )->a( n = `value`       v = `{WEIGHTMEASURE}`
              )->a( n = `description` v = `{WEIGHTUNIT}`
          )->tag( `Input`
              )->a( n = `value`       v = `{PRICE}`
              )->a( n = `description` v = `{CURRENCYCODE}` ).
    ELSE.
      cells->tag( `ObjectIdentifier`
          )->a( n = `title` v = `{NAME}`
          )->a( n = `text`  v = `{PRODUCTID}`
          )->tag( `ObjectNumber`
              )->a( n = `number` v = |\{ path:'QUANTITY', type: 'sap.ui.model.type.String', formatOptions: \{showMeasure: false\} \}|
              )->a( n = `unit`   v = `{UOM}`
          )->tag( `ObjectNumber`
              )->a( n = `number` v = `{WEIGHTMEASURE}`
              )->a( n = `unit`   v = `{WEIGHTUNIT}`
              )->a( n = `state`  v = `{WEIGHT_STATE}`
          )->tag( `ObjectNumber`
              )->a( n = `number` v = |\{ parts:[\{path:'PRICE'\},\{path:'CURRENCYCODE'\}], type:'sap.ui.model.type.Currency', formatOptions:\{showMeasure:false\} \}|
              )->a( n = `unit`   v = `{CURRENCYCODE}` ).
    ENDIF.

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `EDIT`.
        " onEdit: keep a copy for Cancel, then rebind to the editable template
        t_backup = t_products.
        edit_mode = abap_true.
        view_display( ).

      WHEN `SAVE`.
        edit_mode = abap_false.
        view_display( ).

      WHEN `CANCEL`.
        " onCancel: put the copy back
        t_products = t_backup.
        edit_mode = abap_false.
        view_display( ).

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " the full mock /ProductCollection
    t_products = VALUE #(
      ( productid = `HT-1000` name = `Notebook Basic 15` quantity = `10` uom = `PC`
        weightmeasure = `4.2` weightunit = `KG` weight_state = `Success`
        price = `956` currencycode = `EUR` )
      ( productid = `HT-1001` name = `Notebook Basic 17` quantity = `20` uom = `PC`
        weightmeasure = `4.5` weightunit = `KG` weight_state = `Success`
        price = `1249` currencycode = `EUR` )
      ( productid = `HT-1002` name = `Notebook Basic 18` quantity = `10` uom = `PC`
        weightmeasure = `4.2` weightunit = `KG` weight_state = `Success`
        price = `1570` currencycode = `EUR` )
      ( productid = `HT-1003` name = `Notebook Basic 19` quantity = `15` uom = `PC`
        weightmeasure = `4.2` weightunit = `KG` weight_state = `Success`
        price = `1650` currencycode = `EUR` )
      ( productid = `HT-1007` name = `ITelO Vault` quantity = `15` uom = `PC`
        weightmeasure = `0.2` weightunit = `KG` weight_state = `Success`
        price = `299` currencycode = `EUR` )
      ( productid = `HT-1010` name = `Notebook Professional 15` quantity = `16` uom = `PC`
        weightmeasure = `4.3` weightunit = `KG` weight_state = `Success`
        price = `1999` currencycode = `EUR` )
      ( productid = `HT-1011` name = `Notebook Professional 17` quantity = `17` uom = `PC`
        weightmeasure = `4.1` weightunit = `KG` weight_state = `Success`
        price = `2299` currencycode = `EUR` )
      ( productid = `HT-1020` name = `ITelO Vault Net` quantity = `14` uom = `PC`
        weightmeasure = `0.16` weightunit = `KG` weight_state = `Success`
        price = `459` currencycode = `EUR` )
      ( productid = `HT-1021` name = `ITelO Vault SAT` quantity = `50` uom = `PC`
        weightmeasure = `0.18` weightunit = `KG` weight_state = `Success`
        price = `149` currencycode = `EUR` )
      ( productid = `HT-1022` name = `Comfort Easy` quantity = `30` uom = `PC`
        weightmeasure = `0.2` weightunit = `KG` weight_state = `Success`
        price = `1679` currencycode = `EUR` )
      ( productid = `HT-1023` name = `Comfort Senior` quantity = `24` uom = `PC`
        weightmeasure = `0.8` weightunit = `KG` weight_state = `Success`
        price = `512` currencycode = `EUR` )
      ( productid = `HT-1030` name = `Ergo Screen E-I` quantity = `14` uom = `PC`
        weightmeasure = `21` weightunit = `KG` weight_state = `Success`
        price = `230` currencycode = `EUR` )
      ( productid = `HT-1031` name = `Ergo Screen E-II` quantity = `24` uom = `PC`
        weightmeasure = `21` weightunit = `KG` weight_state = `Success`
        price = `285` currencycode = `EUR` )
      ( productid = `HT-1032` name = `Ergo Screen E-III` quantity = `50` uom = `PC`
        weightmeasure = `21` weightunit = `KG` weight_state = `Success`
        price = `345` currencycode = `EUR` )
      ( productid = `HT-1035` name = `Flat Basic` quantity = `23` uom = `PC`
        weightmeasure = `14` weightunit = `KG` weight_state = `Success`
        price = `399` currencycode = `EUR` )
      ( productid = `HT-1036` name = `Flat Future` quantity = `22` uom = `PC`
        weightmeasure = `15` weightunit = `KG` weight_state = `Success`
        price = `430` currencycode = `EUR` )
      ( productid = `HT-1037` name = `Flat XL` quantity = `23` uom = `PC`
        weightmeasure = `17` weightunit = `KG` weight_state = `Success`
        price = `1230` currencycode = `EUR` )
      ( productid = `HT-1040` name = `Laser Professional Eco` quantity = `21` uom = `PC`
        weightmeasure = `32` weightunit = `KG` weight_state = `Success`
        price = `830` currencycode = `EUR` )
      ( productid = `HT-1041` name = `Laser Basic` quantity = `8` uom = `PC`
        weightmeasure = `23` weightunit = `KG` weight_state = `Success`
        price = `490` currencycode = `EUR` )
      ( productid = `HT-1042` name = `Laser Allround` quantity = `9` uom = `PC`
        weightmeasure = `17` weightunit = `KG` weight_state = `Success`
        price = `349` currencycode = `EUR` )
      ( productid = `HT-1050` name = `Ultra Jet Super Color` quantity = `17` uom = `PC`
        weightmeasure = `3` weightunit = `KG` weight_state = `Success`
        price = `139` currencycode = `EUR` )
      ( productid = `HT-1051` name = `Ultra Jet Mobile` quantity = `18` uom = `PC`
        weightmeasure = `1.9` weightunit = `KG` weight_state = `Success`
        price = `99` currencycode = `EUR` )
      ( productid = `HT-1052` name = `Ultra Jet Super Highspeed` quantity = `25` uom = `PC`
        weightmeasure = `18` weightunit = `KG` weight_state = `Success`
        price = `170` currencycode = `EUR` )
      ( productid = `HT-1055` name = `Multi Print` quantity = `16` uom = `PC`
        weightmeasure = `6.3` weightunit = `KG` weight_state = `Success`
        price = `99` currencycode = `EUR` )
      ( productid = `HT-1056` name = `Multi Color` quantity = `5` uom = `PC`
        weightmeasure = `4.3` weightunit = `KG` weight_state = `Success`
        price = `119` currencycode = `EUR` )
      ( productid = `HT-1060` name = `Cordless Mouse` quantity = `25` uom = `PC`
        weightmeasure = `0.09` weightunit = `KG` weight_state = `Success`
        price = `9` currencycode = `EUR` )
      ( productid = `HT-1061` name = `Speed Mouse` quantity = `12` uom = `PC`
        weightmeasure = `0.09` weightunit = `KG` weight_state = `Success`
        price = `7` currencycode = `EUR` )
      ( productid = `HT-1062` name = `Track Mouse` quantity = `12` uom = `PC`
        weightmeasure = `0.03` weightunit = `KG` weight_state = `Success`
        price = `11` currencycode = `EUR` )
      ( productid = `HT-1063` name = `Ergonomic Keyboard` quantity = `50` uom = `PC`
        weightmeasure = `2.1` weightunit = `KG` weight_state = `Success`
        price = `14` currencycode = `EUR` )
      ( productid = `HT-1064` name = `Internet Keyboard` quantity = `35` uom = `PC`
        weightmeasure = `1.8` weightunit = `KG` weight_state = `Success`
        price = `16` currencycode = `EUR` )
      ( productid = `HT-1065` name = `Media Keyboard` quantity = `26` uom = `PC`
        weightmeasure = `2.3` weightunit = `KG` weight_state = `Success`
        price = `26` currencycode = `EUR` )
      ( productid = `HT-1066` name = `Mousepad` quantity = `12` uom = `PC`
        weightmeasure = `80` weightunit = `G` weight_state = `Success`
        price = `6.99` currencycode = `EUR` )
      ( productid = `HT-1067` name = `Ergo Mousepad` quantity = `16` uom = `PC`
        weightmeasure = `80` weightunit = `G` weight_state = `Success`
        price = `8.99` currencycode = `EUR` )
      ( productid = `HT-1068` name = `Designer Mousepad` quantity = `26` uom = `PC`
        weightmeasure = `90` weightunit = `G` weight_state = `Success`
        price = `12.99` currencycode = `EUR` )
      ( productid = `HT-1069` name = `Universal card reader` quantity = `22` uom = `PC`
        weightmeasure = `45` weightunit = `G` weight_state = `Success`
        price = `14` currencycode = `EUR` )
      ( productid = `HT-1070` name = `Proctra X` quantity = `15` uom = `PC`
        weightmeasure = `0.255` weightunit = `KG` weight_state = `Success`
        price = `70.9` currencycode = `EUR` )
      ( productid = `HT-1071` name = `Gladiator MX` quantity = `16` uom = `PC`
        weightmeasure = `0.3` weightunit = `KG` weight_state = `Success`
        price = `81.7` currencycode = `EUR` )
      ( productid = `HT-1072` name = `Hurricane GX` quantity = `13` uom = `PC`
        weightmeasure = `0.4` weightunit = `KG` weight_state = `Success`
        price = `101.2` currencycode = `EUR` )
      ( productid = `HT-1073` name = `Hurricane GX/LN` quantity = `5` uom = `PC`
        weightmeasure = `0.4` weightunit = `KG` weight_state = `Success`
        price = `139.99` currencycode = `EUR` )
      ( productid = `HT-1080` name = `Photo Scan` quantity = `8` uom = `PC`
        weightmeasure = `2.3` weightunit = `KG` weight_state = `Success`
        price = `129` currencycode = `EUR` )
      ( productid = `HT-1081` name = `Power Scan` quantity = `11` uom = `PC`
        weightmeasure = `2.4` weightunit = `KG` weight_state = `Success`
        price = `89` currencycode = `EUR` )
      ( productid = `HT-1082` name = `Jet Scan Professional` quantity = `13` uom = `PC`
        weightmeasure = `3.2` weightunit = `KG` weight_state = `Success`
        price = `169` currencycode = `EUR` )
      ( productid = `HT-1083` name = `Jet Scan Professional` quantity = `10` uom = `PC`
        weightmeasure = `3.2` weightunit = `KG` weight_state = `Success`
        price = `189` currencycode = `EUR` )
      ( productid = `HT-1085` name = `Copymaster` quantity = `10` uom = `PC`
        weightmeasure = `23.2` weightunit = `KG` weight_state = `Success`
        price = `1499` currencycode = `EUR` )
      ( productid = `HT-1090` name = `Surround Sound` quantity = `20` uom = `PC`
        weightmeasure = `3` weightunit = `KG` weight_state = `Success`
        price = `39` currencycode = `EUR` )
      ( productid = `HT-1091` name = `Blaster Extreme` quantity = `15` uom = `PC`
        weightmeasure = `1.4` weightunit = `KG` weight_state = `Success`
        price = `26` currencycode = `EUR` )
      ( productid = `HT-1092` name = `Sound Booster` quantity = `50` uom = `PC`
        weightmeasure = `2.1` weightunit = `KG` weight_state = `Success`
        price = `45` currencycode = `EUR` )
      ( productid = `HT-1095` name = `Lovely Sound 5.1 Wireless` quantity = `12` uom = `PC`
        weightmeasure = `80` weightunit = `G` weight_state = `Success`
        price = `49` currencycode = `EUR` )
      ( productid = `HT-1096` name = `Lovely Sound 5.1` quantity = `18` uom = `PC`
        weightmeasure = `130` weightunit = `G` weight_state = `Success`
        price = `39` currencycode = `EUR` )
      ( productid = `HT-1097` name = `Lovely Sound Stereo` quantity = `21` uom = `PC`
        weightmeasure = `60` weightunit = `G` weight_state = `Success`
        price = `29` currencycode = `EUR` )
      ( productid = `HT-1100` name = `Smart Office` quantity = `25` uom = `PC`
        weightmeasure = `1.2` weightunit = `KG` weight_state = `Success`
        price = `89.9` currencycode = `EUR` )
      ( productid = `HT-1101` name = `Smart Design` quantity = `26` uom = `PC`
        weightmeasure = `0.8` weightunit = `KG` weight_state = `Success`
        price = `79.9` currencycode = `EUR` )
      ( productid = `HT-1102` name = `Smart Network` quantity = `28` uom = `PC`
        weightmeasure = `0.8` weightunit = `KG` weight_state = `Success`
        price = `69` currencycode = `EUR` )
      ( productid = `HT-1103` name = `Smart Multimedia` quantity = `9` uom = `PC`
        weightmeasure = `0.8` weightunit = `KG` weight_state = `Success`
        price = `77` currencycode = `EUR` )
      ( productid = `HT-1104` name = `Smart Games` quantity = `13` uom = `PC`
        weightmeasure = `1.1` weightunit = `KG` weight_state = `Success`
        price = `55` currencycode = `EUR` )
      ( productid = `HT-1105` name = `Smart Internet Antivirus` quantity = `17` uom = `PC`
        weightmeasure = `0.7` weightunit = `KG` weight_state = `Success`
        price = `29` currencycode = `EUR` )
      ( productid = `HT-1106` name = `Smart Firewall` quantity = `19` uom = `PC`
        weightmeasure = `0.9` weightunit = `KG` weight_state = `Success`
        price = `34` currencycode = `EUR` )
      ( productid = `HT-1107` name = `Smart Money` quantity = `18` uom = `PC`
        weightmeasure = `0.5` weightunit = `KG` weight_state = `Success`
        price = `29.9` currencycode = `EUR` )
      ( productid = `HT-1110` name = `PC Lock` quantity = `14` uom = `PC`
        weightmeasure = `0.03` weightunit = `KG` weight_state = `Success`
        price = `8.9` currencycode = `EUR` )
      ( productid = `HT-1111` name = `Notebook Lock` quantity = `20` uom = `PC`
        weightmeasure = `0.02` weightunit = `KG` weight_state = `Success`
        price = `6.9` currencycode = `EUR` )
      ( productid = `HT-1112` name = `Web cam reality` quantity = `27` uom = `PC`
        weightmeasure = `0.075` weightunit = `KG` weight_state = `Success`
        price = `39` currencycode = `EUR` )
      ( productid = `HT-1113` name = `Screen clean` quantity = `17` uom = `PC`
        weightmeasure = `0.05` weightunit = `KG` weight_state = `Success`
        price = `2.3` currencycode = `EUR` )
      ( productid = `HT-1114` name = `Fabric bag professional` quantity = `14` uom = `PC`
        weightmeasure = `1.8` weightunit = `KG` weight_state = `Success`
        price = `31` currencycode = `EUR` )
      ( productid = `HT-1115` name = `Wireless DSL Router` quantity = `16` uom = `PC`
        weightmeasure = `0.45` weightunit = `KG` weight_state = `Success`
        price = `49` currencycode = `EUR` )
      ( productid = `HT-1116` name = `Wireless DSL Router / Repeater` quantity = `12` uom = `PC`
        weightmeasure = `0.45` weightunit = `KG` weight_state = `Success`
        price = `59` currencycode = `EUR` )
      ( productid = `HT-1117` name = `Wireless DSL Router / Repeater and Print Server` quantity = `12` uom = `PC`
        weightmeasure = `0.45` weightunit = `KG` weight_state = `Success`
        price = `69` currencycode = `EUR` )
      ( productid = `HT-1118` name = `USB Stick` quantity = `14` uom = `PC`
        weightmeasure = `0.015` weightunit = `KG` weight_state = `Success`
        price = `35` currencycode = `EUR` )
      ( productid = `HT-1119` name = `Travel Adapter` quantity = `10` uom = `PC`
        weightmeasure = `88` weightunit = `G` weight_state = `Success`
        price = `79` currencycode = `EUR` )
      ( productid = `HT-1120` name = `Cordless Bluetooth Keyboard, english international` quantity = `13` uom = `PC`
        weightmeasure = `1` weightunit = `KG` weight_state = `Success`
        price = `29` currencycode = `EUR` )
      ( productid = `HT-1137` name = `Flat XXL` quantity = `10` uom = `PC`
        weightmeasure = `18` weightunit = `KG` weight_state = `Success`
        price = `1430` currencycode = `EUR` )
      ( productid = `HT-1138` name = `Pocket Mouse` quantity = `20` uom = `PC`
        weightmeasure = `0.02` weightunit = `KG` weight_state = `Success`
        price = `23` currencycode = `EUR` )
      ( productid = `HT-1210` name = `PC Power Station` quantity = `22` uom = `PC`
        weightmeasure = `2.3` weightunit = `KG` weight_state = `Success`
        price = `2399` currencycode = `EUR` )
      ( productid = `HT-1251` name = `Astro Laptop 1516` quantity = `23` uom = `PC`
        weightmeasure = `4.2` weightunit = `KG` weight_state = `Success`
        price = `989` currencycode = `EUR` )
      ( productid = `HT-1252` name = `Astro Phone 6` quantity = `28` uom = `PC`
        weightmeasure = `0.75` weightunit = `KG` weight_state = `Success`
        price = `649` currencycode = `EUR` )
      ( productid = `HT-1253` name = `Benda Laptop 1408` quantity = `27` uom = `PC`
        weightmeasure = `4.2` weightunit = `KG` weight_state = `Success`
        price = `976` currencycode = `EUR` )
      ( productid = `HT-1254` name = `Bending Screen 21HD` quantity = `23` uom = `PC`
        weightmeasure = `15` weightunit = `KG` weight_state = `Success`
        price = `250` currencycode = `EUR` )
      ( productid = `HT-1255` name = `Broad Screen 22HD` quantity = `5` uom = `PC`
        weightmeasure = `16` weightunit = `KG` weight_state = `Success`
        price = `270` currencycode = `EUR` )
      ( productid = `HT-1256` name = `Cerdik Phone 7` quantity = `19` uom = `PC`
        weightmeasure = `0.75` weightunit = `KG` weight_state = `Success`
        price = `549` currencycode = `EUR` )
      ( productid = `HT-1257` name = `Cepat Tablet 10.5` quantity = `17` uom = `PC`
        weightmeasure = `2.8` weightunit = `KG` weight_state = `Success`
        price = `549` currencycode = `EUR` )
      ( productid = `HT-1258` name = `Cepat Tablet 8` quantity = `24` uom = `PC`
        weightmeasure = `2.5` weightunit = `KG` weight_state = `Success`
        price = `529` currencycode = `EUR` )
      ( productid = `HT-1500` name = `Server Basic` quantity = `24` uom = `PC`
        weightmeasure = `18` weightunit = `KG` weight_state = `Success`
        price = `5000` currencycode = `EUR` )
      ( productid = `HT-1501` name = `Server Professional` quantity = `26` uom = `PC`
        weightmeasure = `25` weightunit = `KG` weight_state = `Success`
        price = `15000` currencycode = `EUR` )
      ( productid = `HT-1502` name = `Server Power Pro` quantity = `34` uom = `PC`
        weightmeasure = `35` weightunit = `KG` weight_state = `Success`
        price = `25000` currencycode = `EUR` )
      ( productid = `HT-1600` name = `Family PC Basic` quantity = `10` uom = `PC`
        weightmeasure = `4.8` weightunit = `KG` weight_state = `Success`
        price = `600` currencycode = `EUR` )
      ( productid = `HT-1601` name = `Family PC Pro` quantity = `20` uom = `PC`
        weightmeasure = `5.3` weightunit = `KG` weight_state = `Success`
        price = `900` currencycode = `EUR` )
      ( productid = `HT-1602` name = `Gaming Monster` quantity = `24` uom = `PC`
        weightmeasure = `5.9` weightunit = `KG` weight_state = `Success`
        price = `1200` currencycode = `EUR` )
      ( productid = `HT-1603` name = `Gaming Monster Pro` quantity = `25` uom = `PC`
        weightmeasure = `6.8` weightunit = `KG` weight_state = `Success`
        price = `1700` currencycode = `EUR` )
      ( productid = `HT-2000` name = `7" Widescreen Portable DVD Player w MP3` quantity = `20` uom = `PC`
        weightmeasure = `0.79` weightunit = `KG` weight_state = `Success`
        price = `249.99` currencycode = `EUR` )
      ( productid = `HT-2001` name = `10" Portable DVD player` quantity = `21` uom = `PC`
        weightmeasure = `0.84` weightunit = `KG` weight_state = `Success`
        price = `449.99` currencycode = `EUR` )
      ( productid = `HT-2002` name = `Portable DVD Player with 9" LCD Monitor` quantity = `50` uom = `PC`
        weightmeasure = `0.72` weightunit = `KG` weight_state = `Success`
        price = `853.99` currencycode = `EUR` )
      ( productid = `HT-2025` name = `CD/DVD case: 264 sleeves` quantity = `26` uom = `PC`
        weightmeasure = `0.65` weightunit = `KG` weight_state = `Success`
        price = `44.99` currencycode = `EUR` )
      ( productid = `HT-2026` name = `Audio/Video Cable Kit - 4m` quantity = `16` uom = `PC`
        weightmeasure = `0.2` weightunit = `KG` weight_state = `Success`
        price = `29.99` currencycode = `EUR` )
      ( productid = `HT-2027` name = `Removable CD/DVD Laser Labels` quantity = `25` uom = `PC`
        weightmeasure = `0.15` weightunit = `KG` weight_state = `Success`
        price = `8.99` currencycode = `EUR` )
      ( productid = `HT-6100` name = `Beam Breaker B-1` quantity = `32` uom = `PC`
        weightmeasure = `1.7` weightunit = `KG` weight_state = `Success`
        price = `469` currencycode = `EUR` )
      ( productid = `HT-6101` name = `Beam Breaker B-2` quantity = `18` uom = `PC`
        weightmeasure = `2` weightunit = `KG` weight_state = `Success`
        price = `679` currencycode = `EUR` )
      ( productid = `HT-6102` name = `Beam Breaker B-3` quantity = `16` uom = `PC`
        weightmeasure = `2.5` weightunit = `KG` weight_state = `Success`
        price = `889` currencycode = `EUR` )
      ( productid = `HT-6110` name = `Play Movie` quantity = `15` uom = `PC`
        weightmeasure = `2.4` weightunit = `KG` weight_state = `Success`
        price = `130` currencycode = `EUR` )
      ( productid = `HT-6111` name = `Record Movie` quantity = `24` uom = `PC`
        weightmeasure = `3.1` weightunit = `KG` weight_state = `Success`
        price = `288` currencycode = `EUR` )
      ( productid = `HT-6120` name = `ITelo MusicStick` quantity = `15` uom = `PC`
        weightmeasure = `134` weightunit = `G` weight_state = `Success`
        price = `45` currencycode = `EUR` )
      ( productid = `HT-6121` name = `ITelo Jog-Mate` quantity = `24` uom = `PC`
        weightmeasure = `134` weightunit = `G` weight_state = `Success`
        price = `63` currencycode = `EUR` )
      ( productid = `HT-6122` name = `Power Pro Player 40` quantity = `23` uom = `PC`
        weightmeasure = `266` weightunit = `G` weight_state = `Success`
        price = `167` currencycode = `EUR` )
      ( productid = `HT-6123` name = `Power Pro Player 80` quantity = `13` uom = `PC`
        weightmeasure = `267` weightunit = `G` weight_state = `Success`
        price = `299` currencycode = `EUR` )
      ( productid = `HT-6130` name = `Flat Watch HD32` quantity = `16` uom = `PC`
        weightmeasure = `2.6` weightunit = `KG` weight_state = `Success`
        price = `1459` currencycode = `EUR` )
      ( productid = `HT-6131` name = `Flat Watch HD37` quantity = `14` uom = `PC`
        weightmeasure = `2.2` weightunit = `KG` weight_state = `Success`
        price = `1199` currencycode = `EUR` )
      ( productid = `HT-6132` name = `Flat Watch HD41` quantity = `13` uom = `PC`
        weightmeasure = `1.8` weightunit = `KG` weight_state = `Success`
        price = `899` currencycode = `EUR` )
      ( productid = `HT-7000` name = `Copperberry` quantity = `5` uom = `PC`
        weightmeasure = `0.5` weightunit = `KG` weight_state = `Success`
        price = `549` currencycode = `EUR` )
      ( productid = `HT-7010` name = `Silverberry` quantity = `9` uom = `PC`
        weightmeasure = `0.5` weightunit = `KG` weight_state = `Success`
        price = `549` currencycode = `EUR` )
      ( productid = `HT-7020` name = `Goldberry` quantity = `11` uom = `PC`
        weightmeasure = `0.5` weightunit = `KG` weight_state = `Success`
        price = `549` currencycode = `EUR` )
      ( productid = `HT-7030` name = `Platinberry` quantity = `12` uom = `PC`
        weightmeasure = `0.5` weightunit = `KG` weight_state = `Success`
        price = `549` currencycode = `EUR` )
      ( productid = `HT-8000` name = `ITelO FlexTop I4000` quantity = `11` uom = `PC`
        weightmeasure = `4` weightunit = `KG` weight_state = `Success`
        price = `799` currencycode = `EUR` )
      ( productid = `HT-8001` name = `ITelO FlexTop I6300c` quantity = `20` uom = `PC`
        weightmeasure = `4.2` weightunit = `KG` weight_state = `Success`
        price = `799` currencycode = `EUR` )
      ( productid = `HT-8002` name = `ITelO FlexTop I9100` quantity = `20` uom = `PC`
        weightmeasure = `3.5` weightunit = `KG` weight_state = `Success`
        price = `1199` currencycode = `EUR` )
      ( productid = `HT-8003` name = `ITelO FlexTop I9800` quantity = `22` uom = `PC`
        weightmeasure = `3.8` weightunit = `KG` weight_state = `Success`
        price = `1388` currencycode = `EUR` )
      ( productid = `HT-9991` name = `Smartphone Leather Case` quantity = `12` uom = `PC`
        weightmeasure = `0.02` weightunit = `KG` weight_state = `Success`
        price = `25` currencycode = `EUR` )
      ( productid = `HT-9992` name = `Smartphone Alpha` quantity = `13` uom = `PC`
        weightmeasure = `0.75` weightunit = `KG` weight_state = `Success`
        price = `599` currencycode = `EUR` )
      ( productid = `HT-9993` name = `Mini Tablet` quantity = `10` uom = `PC`
        weightmeasure = `3.8` weightunit = `KG` weight_state = `Success`
        price = `833` currencycode = `EUR` )
      ( productid = `HT-9994` name = `Camcorder View` quantity = `50` uom = `PC`
        weightmeasure = `3.8` weightunit = `KG` weight_state = `Success`
        price = `1388` currencycode = `EUR` )
      ( productid = `HT-9995` name = `Tablet Pouch` quantity = `34` uom = `PC`
        weightmeasure = `0.03` weightunit = `KG` weight_state = `Success`
        price = `20` currencycode = `EUR` )
      ( productid = `HT-9996` name = `Tablet Pouch` quantity = `34` uom = `PC`
        weightmeasure = `0.03` weightunit = `KG` weight_state = `Success`
        price = `20` currencycode = `EUR` )
      ( productid = `HT-9997` name = `e-Book Reader ReadMe` quantity = `23` uom = `PC`
        weightmeasure = `3.8` weightunit = `KG` weight_state = `Success`
        price = `33` currencycode = `EUR` )
      ( productid = `HT-9998` name = `Smartphone Beta` quantity = `21` uom = `PC`
        weightmeasure = `0.75` weightunit = `KG` weight_state = `Success`
        price = `30` currencycode = `EUR` )
      ( productid = `HT-9999` name = `Maxi Tablet` quantity = `20` uom = `PC`
        weightmeasure = `3.8` weightunit = `KG` weight_state = `Success`
        price = `749` currencycode = `EUR` )
      ( productid = `PF-1000` name = `Flyer` quantity = `33` uom = `PC`
        weightmeasure = `0.01` weightunit = `KG` weight_state = `Success`
        price = `0` currencycode = `EUR` ) ).

  ENDMETHOD.

ENDCLASS.
