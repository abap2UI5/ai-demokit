" @keywords tableselectdialog table select dialog sap.m tableselectdialoggrowing button column text columnlistitem objectidentifier objectnumber
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
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

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

    CASE client->get_event( ).

      WHEN `DIALOG_GROWING`.
        popup_dialog_display( abap_true ).

      WHEN `DIALOG_PLAIN`.
        popup_dialog_display( abap_false ).

      WHEN `SEARCH`.
        " handleSearch filters the dialog's items binding by Name - the same
        " declarative filter on the aggregation binding, the model untouched
        client->follow_up_action( val   = client->cs_event-binding_call
                                  t_arg = VALUE #( ( `myDialog` )
                                                   ( `items` )
                                                   ( `filter` )
                                                   ( |[\{"path":"NAME","operator":"Contains","value1":"{ client->get_event_arg( ) }"\}]| ) ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD popup_dialog_display.

    DATA(popup) = z2ui5_cl_ui5_view_builder=>factory( ).

    popup->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->ele( `TableSelectDialog`
            )->a( n = `id`           v = `myDialog`
            )->a( n = `noDataText`   v = `No Products Found`
            )->a( n = `title`        v = `Select Product`
            )->a( n = `search`       v = client->_event( val   = `SEARCH`
                                                         t_arg = VALUE #( ( `${$parameters>/value}` ) ) )
            )->a( n = `multiSelect`  v = `true`
            " the two buttons differ only in these two properties
            )->a( n = `growing`      b = growing
            )->a( n = `initialFocus` v = COND #( WHEN growing = abap_true THEN `SearchField` ELSE `List` )
            )->a( n = `items`        v = |\{ path : '{ client->_bind( val = t_products path = abap_true ) }', sorter : \{ path : 'NAME', descending : false \} \}|

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
    t_products = VALUE #(
        ( name = `Notebook Basic 15` productid = `HT-1000` suppliername = `Very Best Screens`
          width = `30` depth = `18` height = `3` dimunit = `cm`
          weightmeasure = `4.2` weightunit = `KG` weightstate = `Success`
          price = `956` currencycode = `EUR` )
        ( name = `Notebook Basic 17` productid = `HT-1001` suppliername = `Very Best Screens`
          width = `29` depth = `17` height = `3.1` dimunit = `cm`
          weightmeasure = `4.5` weightunit = `KG` weightstate = `Success`
          price = `1249` currencycode = `EUR` )
        ( name = `Notebook Basic 18` productid = `HT-1002` suppliername = `Very Best Screens`
          width = `28` depth = `19` height = `2.5` dimunit = `cm`
          weightmeasure = `4.2` weightunit = `KG` weightstate = `Success`
          price = `1570` currencycode = `EUR` )
        ( name = `Notebook Basic 19` productid = `HT-1003` suppliername = `Smartcards`
          width = `32` depth = `21` height = `4` dimunit = `cm`
          weightmeasure = `4.2` weightunit = `KG` weightstate = `Success`
          price = `1650` currencycode = `EUR` )
        ( name = `ITelO Vault` productid = `HT-1007` suppliername = `Technocom`
          width = `32` depth = `22` height = `3` dimunit = `cm`
          weightmeasure = `0.2` weightunit = `KG` weightstate = `Success`
          price = `299` currencycode = `EUR` )
        ( name = `Notebook Professional 15` productid = `HT-1010` suppliername = `Very Best Screens`
          width = `33` depth = `20` height = `3` dimunit = `cm`
          weightmeasure = `4.3` weightunit = `KG` weightstate = `Success`
          price = `1999` currencycode = `EUR` )
        ( name = `Notebook Professional 17` productid = `HT-1011` suppliername = `Very Best Screens`
          width = `33` depth = `23` height = `2` dimunit = `cm`
          weightmeasure = `4.1` weightunit = `KG` weightstate = `Success`
          price = `2299` currencycode = `EUR` )
        ( name = `ITelO Vault Net` productid = `HT-1020` suppliername = `Technocom`
          width = `10` depth = `1.8` height = `17` dimunit = `cm`
          weightmeasure = `0.16` weightunit = `KG` weightstate = `Success`
          price = `459` currencycode = `EUR` )
        ( name = `ITelO Vault SAT` productid = `HT-1021` suppliername = `Technocom`
          width = `11` depth = `1.7` height = `18` dimunit = `cm`
          weightmeasure = `0.18` weightunit = `KG` weightstate = `Success`
          price = `149` currencycode = `EUR` )
        ( name = `Comfort Easy` productid = `HT-1022` suppliername = `Technocom`
          width = `84` depth = `1.5` height = `14` dimunit = `cm`
          weightmeasure = `0.2` weightunit = `KG` weightstate = `Success`
          price = `1679` currencycode = `EUR` )
        ( name = `Comfort Senior` productid = `HT-1023` suppliername = `Technocom`
          width = `80` depth = `1.6` height = `13` dimunit = `cm`
          weightmeasure = `0.8` weightunit = `KG` weightstate = `Success`
          price = `512` currencycode = `EUR` )
        ( name = `Ergo Screen E-I` productid = `HT-1030` suppliername = `Very Best Screens`
          width = `37` depth = `12` height = `36` dimunit = `cm`
          weightmeasure = `21` weightunit = `KG` weightstate = `Success`
          price = `230` currencycode = `EUR` )
        ( name = `Ergo Screen E-II` productid = `HT-1031` suppliername = `Very Best Screens`
          width = `40.8` depth = `19` height = `43` dimunit = `cm`
          weightmeasure = `21` weightunit = `KG` weightstate = `Success`
          price = `285` currencycode = `EUR` )
        ( name = `Ergo Screen E-III` productid = `HT-1032` suppliername = `Very Best Screens`
          width = `40.8` depth = `19` height = `43` dimunit = `cm`
          weightmeasure = `21` weightunit = `KG` weightstate = `Success`
          price = `345` currencycode = `EUR` )
        ( name = `Flat Basic` productid = `HT-1035` suppliername = `Very Best Screens`
          width = `39` depth = `20` height = `41` dimunit = `cm`
          weightmeasure = `14` weightunit = `KG` weightstate = `Success`
          price = `399` currencycode = `EUR` )
        ( name = `Flat Future` productid = `HT-1036` suppliername = `Very Best Screens`
          width = `45` depth = `26` height = `46` dimunit = `cm`
          weightmeasure = `15` weightunit = `KG` weightstate = `Success`
          price = `430` currencycode = `EUR` )
        ( name = `Flat XL` productid = `HT-1037` suppliername = `Very Best Screens`
          width = `54.5` depth = `22.1` height = `39.1` dimunit = `cm`
          weightmeasure = `17` weightunit = `KG` weightstate = `Success`
          price = `1230` currencycode = `EUR` )
        ( name = `Laser Professional Eco` productid = `HT-1040` suppliername = `Alpha Printers`
          width = `51` depth = `46` height = `30` dimunit = `cm`
          weightmeasure = `32` weightunit = `KG` weightstate = `Success`
          price = `830` currencycode = `EUR` )
        ( name = `Laser Basic` productid = `HT-1041` suppliername = `Alpha Printers`
          width = `48` depth = `42` height = `26` dimunit = `cm`
          weightmeasure = `23` weightunit = `KG` weightstate = `Success`
          price = `490` currencycode = `EUR` )
        ( name = `Laser Allround` productid = `HT-1042` suppliername = `Alpha Printers`
          width = `53` depth = `50` height = `65` dimunit = `cm`
          weightmeasure = `17` weightunit = `KG` weightstate = `Success`
          price = `349` currencycode = `EUR` )
        ( name = `Ultra Jet Super Color` productid = `HT-1050` suppliername = `Alpha Printers`
          width = `41` depth = `41` height = `28` dimunit = `cm`
          weightmeasure = `3` weightunit = `KG` weightstate = `Success`
          price = `139` currencycode = `EUR` )
        ( name = `Ultra Jet Mobile` productid = `HT-1051` suppliername = `Printer for All`
          width = `46` depth = `32` height = `25` dimunit = `cm`
          weightmeasure = `1.9` weightunit = `KG` weightstate = `Success`
          price = `99` currencycode = `EUR` )
        ( name = `Ultra Jet Super Highspeed` productid = `HT-1052` suppliername = `Printer for All`
          width = `41` depth = `41` height = `28` dimunit = `cm`
          weightmeasure = `18` weightunit = `KG` weightstate = `Success`
          price = `170` currencycode = `EUR` )
        ( name = `Multi Print` productid = `HT-1055` suppliername = `Printer for All`
          width = `55` depth = `45` height = `29` dimunit = `cm`
          weightmeasure = `6.3` weightunit = `KG` weightstate = `Success`
          price = `99` currencycode = `EUR` )
        ( name = `Multi Color` productid = `HT-1056` suppliername = `Printer for All`
          width = `51` depth = `41.3` height = `22` dimunit = `cm`
          weightmeasure = `4.3` weightunit = `KG` weightstate = `Success`
          price = `119` currencycode = `EUR` )
        ( name = `Cordless Mouse` productid = `HT-1060` suppliername = `Oxynum`
          width = `6` depth = `14.5` height = `3.5` dimunit = `cm`
          weightmeasure = `0.09` weightunit = `KG` weightstate = `Success`
          price = `9` currencycode = `EUR` )
        ( name = `Speed Mouse` productid = `HT-1061` suppliername = `Oxynum`
          width = `7` depth = `15` height = `3.1` dimunit = `cm`
          weightmeasure = `0.09` weightunit = `KG` weightstate = `Success`
          price = `7` currencycode = `EUR` )
        ( name = `Track Mouse` productid = `HT-1062` suppliername = `Oxynum`
          width = `3` depth = `7` height = `4` dimunit = `cm`
          weightmeasure = `0.03` weightunit = `KG` weightstate = `Success`
          price = `11` currencycode = `EUR` )
        ( name = `Ergonomic Keyboard` productid = `HT-1063` suppliername = `Oxynum`
          width = `50` depth = `21` height = `3.5` dimunit = `cm`
          weightmeasure = `2.1` weightunit = `KG` weightstate = `Success`
          price = `14` currencycode = `EUR` )
        ( name = `Internet Keyboard` productid = `HT-1064` suppliername = `Oxynum`
          width = `52` depth = `25` height = `3` dimunit = `cm`
          weightmeasure = `1.8` weightunit = `KG` weightstate = `Success`
          price = `16` currencycode = `EUR` )
        ( name = `Media Keyboard` productid = `HT-1065` suppliername = `Oxynum`
          width = `51.4` depth = `23` height = `4` dimunit = `cm`
          weightmeasure = `2.3` weightunit = `KG` weightstate = `Success`
          price = `26` currencycode = `EUR` )
        ( name = `Mousepad` productid = `HT-1066` suppliername = `Oxynum`
          width = `15` depth = `6` height = `0.2` dimunit = `cm`
          weightmeasure = `80` weightunit = `G` weightstate = `Success`
          price = `6.99` currencycode = `EUR` )
        ( name = `Ergo Mousepad` productid = `HT-1067` suppliername = `Oxynum`
          width = `15` depth = `6` height = `0.2` dimunit = `cm`
          weightmeasure = `80` weightunit = `G` weightstate = `Success`
          price = `8.99` currencycode = `EUR` )
        ( name = `Designer Mousepad` productid = `HT-1068` suppliername = `Fasttech`
          width = `24` depth = `24` height = `0.6` dimunit = `cm`
          weightmeasure = `90` weightunit = `G` weightstate = `Success`
          price = `12.99` currencycode = `EUR` )
        ( name = `Universal card reader` productid = `HT-1069` suppliername = `Fasttech`
          width = `6` depth = `6` height = `3` dimunit = `cm`
          weightmeasure = `45` weightunit = `G` weightstate = `Success`
          price = `14` currencycode = `EUR` )
        ( name = `Proctra X` productid = `HT-1070` suppliername = `Ultrasonic United`
          width = `22` depth = `35` height = `17` dimunit = `cm`
          weightmeasure = `0.255` weightunit = `KG` weightstate = `Success`
          price = `70.9` currencycode = `EUR` )
        ( name = `Gladiator MX` productid = `HT-1071` suppliername = `Ultrasonic United`
          width = `22` depth = `35` height = `17` dimunit = `cm`
          weightmeasure = `0.3` weightunit = `KG` weightstate = `Success`
          price = `81.7` currencycode = `EUR` )
        ( name = `Hurricane GX` productid = `HT-1072` suppliername = `Ultrasonic United`
          width = `22` depth = `35` height = `17` dimunit = `cm`
          weightmeasure = `0.4` weightunit = `KG` weightstate = `Success`
          price = `101.2` currencycode = `EUR` )
        ( name = `Hurricane GX/LN` productid = `HT-1073` suppliername = `Smartcards`
          width = `22` depth = `35` height = `17` dimunit = `cm`
          weightmeasure = `0.4` weightunit = `KG` weightstate = `Success`
          price = `139.99` currencycode = `EUR` )
        ( name = `Photo Scan` productid = `HT-1080` suppliername = `Printer for All`
          width = `34` depth = `48` height = `5` dimunit = `cm`
          weightmeasure = `2.3` weightunit = `KG` weightstate = `Success`
          price = `129` currencycode = `EUR` )
        ( name = `Power Scan` productid = `HT-1081` suppliername = `Printer for All`
          width = `31` depth = `43` height = `7` dimunit = `cm`
          weightmeasure = `2.4` weightunit = `KG` weightstate = `Success`
          price = `89` currencycode = `EUR` )
        ( name = `Jet Scan Professional` productid = `HT-1082` suppliername = `Printer for All`
          width = `33` depth = `41` height = `12` dimunit = `cm`
          weightmeasure = `3.2` weightunit = `KG` weightstate = `Success`
          price = `169` currencycode = `EUR` )
        ( name = `Jet Scan Professional` productid = `HT-1083` suppliername = `Printer for All`
          width = `35` depth = `40` height = `10` dimunit = `cm`
          weightmeasure = `3.2` weightunit = `KG` weightstate = `Success`
          price = `189` currencycode = `EUR` )
        ( name = `Copymaster` productid = `HT-1085` suppliername = `Alpha Printers`
          width = `45` depth = `42` height = `22` dimunit = `cm`
          weightmeasure = `23.2` weightunit = `KG` weightstate = `Success`
          price = `1499` currencycode = `EUR` )
        ( name = `Surround Sound` productid = `HT-1090` suppliername = `Speaker Experts`
          width = `12` depth = `10` height = `16` dimunit = `cm`
          weightmeasure = `3` weightunit = `KG` weightstate = `Success`
          price = `39` currencycode = `EUR` )
        ( name = `Blaster Extreme` productid = `HT-1091` suppliername = `Speaker Experts`
          width = `13` depth = `11` height = `17.5` dimunit = `cm`
          weightmeasure = `1.4` weightunit = `KG` weightstate = `Success`
          price = `26` currencycode = `EUR` )
        ( name = `Sound Booster` productid = `HT-1092` suppliername = `Speaker Experts`
          width = `12.4` depth = `10.4` height = `18.1` dimunit = `cm`
          weightmeasure = `2.1` weightunit = `KG` weightstate = `Success`
          price = `45` currencycode = `EUR` )
        ( name = `Lovely Sound 5.1 Wireless` productid = `HT-1095` suppliername = `Fasttech`
          width = `24` depth = `19` height = `23` dimunit = `cm`
          weightmeasure = `80` weightunit = `G` weightstate = `Success`
          price = `49` currencycode = `EUR` )
        ( name = `Lovely Sound 5.1` productid = `HT-1096` suppliername = `Fasttech`
          width = `25` depth = `17` height = `19` dimunit = `cm`
          weightmeasure = `130` weightunit = `G` weightstate = `Success`
          price = `39` currencycode = `EUR` )
        ( name = `Lovely Sound Stereo` productid = `HT-1097` suppliername = `Fasttech`
          width = `21.3` depth = `2.4` height = `19.7` dimunit = `cm`
          weightmeasure = `60` weightunit = `G` weightstate = `Success`
          price = `29` currencycode = `EUR` )
        ( name = `Smart Office` productid = `HT-1100` suppliername = `Technocom`
          width = `15` depth = `6.5` height = `2.1` dimunit = `cm`
          weightmeasure = `1.2` weightunit = `KG` weightstate = `Success`
          price = `89.9` currencycode = `EUR` )
        ( name = `Smart Design` productid = `HT-1101` suppliername = `Technocom`
          width = `14` depth = `6.7` height = `24` dimunit = `cm`
          weightmeasure = `0.8` weightunit = `KG` weightstate = `Success`
          price = `79.9` currencycode = `EUR` )
        ( name = `Smart Network` productid = `HT-1102` suppliername = `Technocom`
          width = `16` depth = `6` height = `27` dimunit = `cm`
          weightmeasure = `0.8` weightunit = `KG` weightstate = `Success`
          price = `69` currencycode = `EUR` )
        ( name = `Smart Multimedia` productid = `HT-1103` suppliername = `Technocom`
          width = `11` depth = `3.4` height = `22` dimunit = `cm`
          weightmeasure = `0.8` weightunit = `KG` weightstate = `Success`
          price = `77` currencycode = `EUR` )
        ( name = `Smart Games` productid = `HT-1104` suppliername = `Technocom`
          width = `10` depth = `3` height = `30` dimunit = `cm`
          weightmeasure = `1.1` weightunit = `KG` weightstate = `Success`
          price = `55` currencycode = `EUR` )
        ( name = `Smart Internet Antivirus` productid = `HT-1105` suppliername = `Brainsoft`
          width = `16` depth = `4` height = `21` dimunit = `cm`
          weightmeasure = `0.7` weightunit = `KG` weightstate = `Success`
          price = `29` currencycode = `EUR` )
        ( name = `Smart Firewall` productid = `HT-1106` suppliername = `Brainsoft`
          width = `17.9` depth = `4.2` height = `23.1` dimunit = `cm`
          weightmeasure = `0.9` weightunit = `KG` weightstate = `Success`
          price = `34` currencycode = `EUR` )
        ( name = `Smart Money` productid = `HT-1107` suppliername = `Brainsoft`
          width = `12` depth = `1.5` height = `19` dimunit = `cm`
          weightmeasure = `0.5` weightunit = `KG` weightstate = `Success`
          price = `29.9` currencycode = `EUR` )
        ( name = `PC Lock` productid = `HT-1110` suppliername = `Red Point Stores`
          width = `20` depth = `8` height = `4.3` dimunit = `cm`
          weightmeasure = `0.03` weightunit = `KG` weightstate = `Success`
          price = `8.9` currencycode = `EUR` )
        ( name = `Notebook Lock` productid = `HT-1111` suppliername = `Red Point Stores`
          width = `31` depth = `9` height = `7` dimunit = `cm`
          weightmeasure = `0.02` weightunit = `KG` weightstate = `Success`
          price = `6.9` currencycode = `EUR` )
        ( name = `Web cam reality` productid = `HT-1112` suppliername = `Red Point Stores`
          width = `9` depth = `8.2` height = `1.3` dimunit = `cm`
          weightmeasure = `0.075` weightunit = `KG` weightstate = `Success`
          price = `39` currencycode = `EUR` )
        ( name = `Screen clean` productid = `HT-1113` suppliername = `Red Point Stores`
          width = `2` depth = `2` height = `0.1` dimunit = `cm`
          weightmeasure = `0.05` weightunit = `KG` weightstate = `Success`
          price = `2.3` currencycode = `EUR` )
        ( name = `Fabric bag professional` productid = `HT-1114` suppliername = `Red Point Stores`
          width = `42` depth = `32` height = `7` dimunit = `cm`
          weightmeasure = `1.8` weightunit = `KG` weightstate = `Success`
          price = `31` currencycode = `EUR` )
        ( name = `Wireless DSL Router` productid = `HT-1115` suppliername = `Red Point Stores`
          width = `19.3` depth = `18` height = `5` dimunit = `cm`
          weightmeasure = `0.45` weightunit = `KG` weightstate = `Success`
          price = `49` currencycode = `EUR` )
        ( name = `Wireless DSL Router / Repeater` productid = `HT-1116` suppliername = `Red Point Stores`
          width = `19.3` depth = `18` height = `5` dimunit = `cm`
          weightmeasure = `0.45` weightunit = `KG` weightstate = `Success`
          price = `59` currencycode = `EUR` )
        ( name = `Wireless DSL Router / Repeater and Print Server` productid = `HT-1117` suppliername = `Technocom`
          width = `19.3` depth = `18` height = `5` dimunit = `cm`
          weightmeasure = `0.45` weightunit = `KG` weightstate = `Success`
          price = `69` currencycode = `EUR` )
        ( name = `USB Stick` productid = `HT-1118` suppliername = `Technocom`
          width = `1.5` depth = `8.7` height = `1.2` dimunit = `cm`
          weightmeasure = `0.015` weightunit = `KG` weightstate = `Success`
          price = `35` currencycode = `EUR` )
        ( name = `Travel Adapter` productid = `HT-1119` suppliername = `Titanium`
          width = `2` depth = `3.1` height = `3.9` dimunit = `cm`
          weightmeasure = `88` weightunit = `G` weightstate = `Success`
          price = `79` currencycode = `EUR` )
        ( name = `Cordless Bluetooth Keyboard, english international` productid = `HT-1120` suppliername = `Technocom`
          width = `51.4` depth = `23` height = `4` dimunit = `cm`
          weightmeasure = `1` weightunit = `KG` weightstate = `Success`
          price = `29` currencycode = `EUR` )
        ( name = `Flat XXL` productid = `HT-1137` suppliername = `Technocom`
          width = `54` depth = `22` height = `38` dimunit = `cm`
          weightmeasure = `18` weightunit = `KG` weightstate = `Success`
          price = `1430` currencycode = `EUR` )
        ( name = `Pocket Mouse` productid = `HT-1138` suppliername = `Technocom`
          width = `0.3` depth = `0.5` height = `1` dimunit = `cm`
          weightmeasure = `0.02` weightunit = `KG` weightstate = `Success`
          price = `23` currencycode = `EUR` )
        ( name = `PC Power Station` productid = `HT-1210` suppliername = `Technocom`
          width = `28` depth = `31` height = `43` dimunit = `cm`
          weightmeasure = `2.3` weightunit = `KG` weightstate = `Success`
          price = `2399` currencycode = `EUR` )
        ( name = `Astro Laptop 1516` productid = `HT-1251` suppliername = `Ultrasonic United`
          width = `30` depth = `18` height = `3` dimunit = `cm`
          weightmeasure = `4.2` weightunit = `KG` weightstate = `Success`
          price = `989` currencycode = `EUR` )
        ( name = `Astro Phone 6` productid = `HT-1252` suppliername = `Ultrasonic United`
          width = `8` depth = `6` height = `1.5` dimunit = `cm`
          weightmeasure = `0.75` weightunit = `KG` weightstate = `Success`
          price = `649` currencycode = `EUR` )
        ( name = `Benda Laptop 1408` productid = `HT-1253` suppliername = `Ultrasonic United`
          width = `30` depth = `18` height = `3` dimunit = `cm`
          weightmeasure = `4.2` weightunit = `KG` weightstate = `Success`
          price = `976` currencycode = `EUR` )
        ( name = `Bending Screen 21HD` productid = `HT-1254` suppliername = `Ultrasonic United`
          width = `37` depth = `12` height = `36` dimunit = `cm`
          weightmeasure = `15` weightunit = `KG` weightstate = `Success`
          price = `250` currencycode = `EUR` )
        ( name = `Broad Screen 22HD` productid = `HT-1255` suppliername = `Ultrasonic United`
          width = `39` depth = `12` height = `38` dimunit = `cm`
          weightmeasure = `16` weightunit = `KG` weightstate = `Success`
          price = `270` currencycode = `EUR` )
        ( name = `Cerdik Phone 7` productid = `HT-1256` suppliername = `Ultrasonic United`
          width = `9` depth = `15` height = `1.5` dimunit = `cm`
          weightmeasure = `0.75` weightunit = `KG` weightstate = `Success`
          price = `549` currencycode = `EUR` )
        ( name = `Cepat Tablet 10.5` productid = `HT-1257` suppliername = `Ultrasonic United`
          width = `48` depth = `31` height = `4.5` dimunit = `cm`
          weightmeasure = `2.8` weightunit = `KG` weightstate = `Success`
          price = `549` currencycode = `EUR` )
        ( name = `Cepat Tablet 8` productid = `HT-1258` suppliername = `Ultrasonic United`
          width = `38` depth = `21` height = `3.5` dimunit = `cm`
          weightmeasure = `2.5` weightunit = `KG` weightstate = `Success`
          price = `529` currencycode = `EUR` )
        ( name = `Server Basic` productid = `HT-1500` suppliername = `Technocom`
          width = `34` depth = `35` height = `23` dimunit = `cm`
          weightmeasure = `18` weightunit = `KG` weightstate = `Success`
          price = `5000` currencycode = `EUR` )
        ( name = `Server Professional` productid = `HT-1501` suppliername = `Technocom`
          width = `29` depth = `30` height = `27` dimunit = `cm`
          weightmeasure = `25` weightunit = `KG` weightstate = `Success`
          price = `15000` currencycode = `EUR` )
        ( name = `Server Power Pro` productid = `HT-1502` suppliername = `Technocom`
          width = `22` depth = `27.3` height = `37` dimunit = `cm`
          weightmeasure = `35` weightunit = `KG` weightstate = `Success`
          price = `25000` currencycode = `EUR` )
        ( name = `Family PC Basic` productid = `HT-1600` suppliername = `Titanium`
          width = `21.4` depth = `29` height = `38` dimunit = `cm`
          weightmeasure = `4.8` weightunit = `KG` weightstate = `Success`
          price = `600` currencycode = `EUR` )
        ( name = `Family PC Pro` productid = `HT-1601` suppliername = `Titanium`
          width = `25` depth = `31.7` height = `40.2` dimunit = `cm`
          weightmeasure = `5.3` weightunit = `KG` weightstate = `Success`
          price = `900` currencycode = `EUR` )
        ( name = `Gaming Monster` productid = `HT-1602` suppliername = `Titanium`
          width = `26.5` depth = `34` height = `47` dimunit = `cm`
          weightmeasure = `5.9` weightunit = `KG` weightstate = `Success`
          price = `1200` currencycode = `EUR` )
        ( name = `Gaming Monster Pro` productid = `HT-1603` suppliername = `Titanium`
          width = `27` depth = `28` height = `42` dimunit = `cm`
          weightmeasure = `6.8` weightunit = `KG` weightstate = `Success`
          price = `1700` currencycode = `EUR` )
        ( name = `7" Widescreen Portable DVD Player w MP3` productid = `HT-2000` suppliername = `Titanium`
          width = `21.4` depth = `19` height = `27.6` dimunit = `cm`
          weightmeasure = `0.79` weightunit = `KG` weightstate = `Success`
          price = `249.99` currencycode = `EUR` )
        ( name = `10" Portable DVD player` productid = `HT-2001` suppliername = `Titanium`
          width = `24` depth = `19.5` height = `29` dimunit = `cm`
          weightmeasure = `0.84` weightunit = `KG` weightstate = `Success`
          price = `449.99` currencycode = `EUR` )
        ( name = `Portable DVD Player with 9" LCD Monitor` productid = `HT-2002` suppliername = `Technocom`
          width = `21` depth = `16.5` height = `14` dimunit = `cm`
          weightmeasure = `0.72` weightunit = `KG` weightstate = `Success`
          price = `853.99` currencycode = `EUR` )
        ( name = `CD/DVD case: 264 sleeves` productid = `HT-2025` suppliername = `Titanium`
          width = `13` depth = `13` height = `20` dimunit = `cm`
          weightmeasure = `0.65` weightunit = `KG` weightstate = `Success`
          price = `44.99` currencycode = `EUR` )
        ( name = `Audio/Video Cable Kit - 4m` productid = `HT-2026` suppliername = `Titanium`
          width = `21` depth = `10.2` height = `13` dimunit = `cm`
          weightmeasure = `0.2` weightunit = `KG` weightstate = `Success`
          price = `29.99` currencycode = `EUR` )
        ( name = `Removable CD/DVD Laser Labels` productid = `HT-2027` suppliername = `Titanium`
          width = `5.5` depth = `2` height = `2` dimunit = `cm`
          weightmeasure = `0.15` weightunit = `KG` weightstate = `Success`
          price = `8.99` currencycode = `EUR` )
        ( name = `Beam Breaker B-1` productid = `HT-6100` suppliername = `Titanium`
          width = `30.4` depth = `23.1` height = `23` dimunit = `cm`
          weightmeasure = `1.7` weightunit = `KG` weightstate = `Success`
          price = `469` currencycode = `EUR` )
        ( name = `Beam Breaker B-2` productid = `HT-6101` suppliername = `Technocom`
          width = `30.4` depth = `23.1` height = `23` dimunit = `cm`
          weightmeasure = `2` weightunit = `KG` weightstate = `Success`
          price = `679` currencycode = `EUR` )
        ( name = `Beam Breaker B-3` productid = `HT-6102` suppliername = `Technocom`
          width = `30.4` depth = `23.1` height = `23` dimunit = `cm`
          weightmeasure = `2.5` weightunit = `KG` weightstate = `Success`
          price = `889` currencycode = `EUR` )
        ( name = `Play Movie` productid = `HT-6110` suppliername = `Fasttech`
          width = `37` depth = `24` height = `6` dimunit = `cm`
          weightmeasure = `2.4` weightunit = `KG` weightstate = `Success`
          price = `130` currencycode = `EUR` )
        ( name = `Record Movie` productid = `HT-6111` suppliername = `Fasttech`
          width = `38` depth = `26` height = `6.2` dimunit = `cm`
          weightmeasure = `3.1` weightunit = `KG` weightstate = `Success`
          price = `288` currencycode = `EUR` )
        ( name = `ITelo MusicStick` productid = `HT-6120` suppliername = `Fasttech`
          width = `1.5` depth = `6` height = `1` dimunit = `cm`
          weightmeasure = `134` weightunit = `G` weightstate = `Success`
          price = `45` currencycode = `EUR` )
        ( name = `ITelo Jog-Mate` productid = `HT-6121` suppliername = `Fasttech`
          width = `5.1` depth = `8` height = `9.2` dimunit = `cm`
          weightmeasure = `134` weightunit = `G` weightstate = `Success`
          price = `63` currencycode = `EUR` )
        ( name = `Power Pro Player 40` productid = `HT-6122` suppliername = `Fasttech`
          width = `5.1` depth = `8` height = `9.2` dimunit = `cm`
          weightmeasure = `266` weightunit = `G` weightstate = `Success`
          price = `167` currencycode = `EUR` )
        ( name = `Power Pro Player 80` productid = `HT-6123` suppliername = `Fasttech`
          width = `4` depth = `6` height = `0.8` dimunit = `cm`
          weightmeasure = `267` weightunit = `G` weightstate = `Success`
          price = `299` currencycode = `EUR` )
        ( name = `Flat Watch HD32` productid = `HT-6130` suppliername = `Very Best Screens`
          width = `78` depth = `22.1` height = `55` dimunit = `cm`
          weightmeasure = `2.6` weightunit = `KG` weightstate = `Success`
          price = `1459` currencycode = `EUR` )
        ( name = `Flat Watch HD37` productid = `HT-6131` suppliername = `Very Best Screens`
          width = `99.1` depth = `26` height = `61` dimunit = `cm`
          weightmeasure = `2.2` weightunit = `KG` weightstate = `Success`
          price = `1199` currencycode = `EUR` )
        ( name = `Flat Watch HD41` productid = `HT-6132` suppliername = `Very Best Screens`
          width = `128` depth = `23` height = `79.1` dimunit = `cm`
          weightmeasure = `1.8` weightunit = `KG` weightstate = `Success`
          price = `899` currencycode = `EUR` )
        ( name = `Copperberry` productid = `HT-7000` suppliername = `Fasttech`
          width = `8.1` depth = `13` height = `12.1` dimunit = `cm`
          weightmeasure = `0.5` weightunit = `KG` weightstate = `Success`
          price = `549` currencycode = `EUR` )
        ( name = `Silverberry` productid = `HT-7010` suppliername = `Fasttech`
          width = `8.1` depth = `13` height = `12.1` dimunit = `cm`
          weightmeasure = `0.5` weightunit = `KG` weightstate = `Success`
          price = `549` currencycode = `EUR` )
        ( name = `Goldberry` productid = `HT-7020` suppliername = `Fasttech`
          width = `8.1` depth = `13` height = `12.1` dimunit = `cm`
          weightmeasure = `0.5` weightunit = `KG` weightstate = `Success`
          price = `549` currencycode = `EUR` )
        ( name = `Platinberry` productid = `HT-7030` suppliername = `Fasttech`
          width = `8.1` depth = `13` height = `12.1` dimunit = `cm`
          weightmeasure = `0.5` weightunit = `KG` weightstate = `Success`
          price = `549` currencycode = `EUR` )
        ( name = `ITelO FlexTop I4000` productid = `HT-8000` suppliername = `Titanium`
          width = `31` depth = `19` height = `3.1` dimunit = `cm`
          weightmeasure = `4` weightunit = `KG` weightstate = `Success`
          price = `799` currencycode = `EUR` )
        ( name = `ITelO FlexTop I6300c` productid = `HT-8001` suppliername = `Titanium`
          width = `32` depth = `20` height = `3.4` dimunit = `cm`
          weightmeasure = `4.2` weightunit = `KG` weightstate = `Success`
          price = `799` currencycode = `EUR` )
        ( name = `ITelO FlexTop I9100` productid = `HT-8002` suppliername = `Titanium`
          width = `38` depth = `21` height = `4.1` dimunit = `cm`
          weightmeasure = `3.5` weightunit = `KG` weightstate = `Success`
          price = `1199` currencycode = `EUR` )
        ( name = `ITelO FlexTop I9800` productid = `HT-8003` suppliername = `Titanium`
          width = `48` depth = `31` height = `4.5` dimunit = `cm`
          weightmeasure = `3.8` weightunit = `KG` weightstate = `Success`
          price = `1388` currencycode = `EUR` )
        ( name = `Smartphone Leather Case` productid = `HT-9991` suppliername = `Ultrasonic United`
          width = `48` depth = `31` height = `4.5` dimunit = `cm`
          weightmeasure = `0.02` weightunit = `KG` weightstate = `Success`
          price = `25` currencycode = `EUR` )
        ( name = `Smartphone Alpha` productid = `HT-9992` suppliername = `Ultrasonic United`
          width = `48` depth = `31` height = `4.5` dimunit = `cm`
          weightmeasure = `0.75` weightunit = `KG` weightstate = `Success`
          price = `599` currencycode = `EUR` )
        ( name = `Mini Tablet` productid = `HT-9993` suppliername = `Ultrasonic United`
          width = `48` depth = `31` height = `4.5` dimunit = `cm`
          weightmeasure = `3.8` weightunit = `KG` weightstate = `Success`
          price = `833` currencycode = `EUR` )
        ( name = `Camcorder View` productid = `HT-9994` suppliername = `Ultrasonic United`
          width = `48` depth = `31` height = `27` dimunit = `cm`
          weightmeasure = `3.8` weightunit = `KG` weightstate = `Success`
          price = `1388` currencycode = `EUR` )
        ( name = `Tablet Pouch` productid = `HT-9995` suppliername = `Titanium`
          width = `25` depth = `40` height = `4.5` dimunit = `cm`
          weightmeasure = `0.03` weightunit = `KG` weightstate = `Success`
          price = `20` currencycode = `EUR` )
        ( name = `Tablet Pouch` productid = `HT-9996` suppliername = `Titanium`
          width = `25` depth = `40` height = `4.5` dimunit = `cm`
          weightmeasure = `0.03` weightunit = `KG` weightstate = `Success`
          price = `20` currencycode = `EUR` )
        ( name = `e-Book Reader ReadMe` productid = `HT-9997` suppliername = `Titanium`
          width = `48` depth = `31` height = `4.5` dimunit = `cm`
          weightmeasure = `3.8` weightunit = `KG` weightstate = `Success`
          price = `33` currencycode = `EUR` )
        ( name = `Smartphone Beta` productid = `HT-9998` suppliername = `Titanium`
          width = `48` depth = `31` height = `4.5` dimunit = `cm`
          weightmeasure = `0.75` weightunit = `KG` weightstate = `Success`
          price = `30` currencycode = `EUR` )
        ( name = `Maxi Tablet` productid = `HT-9999` suppliername = `Titanium`
          width = `48` depth = `31` height = `4.5` dimunit = `cm`
          weightmeasure = `3.8` weightunit = `KG` weightstate = `Success`
          price = `749` currencycode = `EUR` )
        ( name = `Flyer` productid = `PF-1000` suppliername = `Titanium`
          width = `46` depth = `30` height = `3` dimunit = `cm`
          weightmeasure = `0.01` weightunit = `KG` weightstate = `Success`
          price = `0` currencycode = `EUR` )
    ).

  ENDMETHOD.

ENDCLASS.
