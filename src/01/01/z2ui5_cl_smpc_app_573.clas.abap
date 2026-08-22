" @keywords table sap.m tablemergecells column text columnlistitem objectidentifier objectnumber
" @summary With column duplicate merging, you can improve the display of repeated data. See the effect of mergeDuplicates on the Supplier column, space permitting. Note: This feature is ignored if a column is shown in the pop-in.
CLASS z2ui5_cl_smpc_app_573 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             productid     TYPE string,
             name          TYPE string,
             suppliername  TYPE string,
             width         TYPE string,
             depth         TYPE string,
             height        TYPE string,
             dimunit       TYPE string,
             weightmeasure TYPE string,
             weightunit    TYPE string,
             " Formatter.weightState and Formatter.formatType, computed in the
             " backend (thin frontend)
             weight_state  TYPE string,
             row_type      TYPE string,
             price         TYPE p LENGTH 9 DECIMALS 2,
             currencycode  TYPE string,
           END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

    DATA t_products TYPE ty_t_product.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_573 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->ele( `Table`
            )->a( n = `headerText` v = `Products`
            )->a( n = `mode`       v = `MultiSelect`
            )->a( n = `items`      v = |\{ path: '{ client->_bind( val = t_products path = abap_true ) }', sorter: \{ path: 'SUPPLIERNAME', descending: false \} \}|

            )->ele( `columns`
                )->ele( `Column`
                    )->a( n = `mergeDuplicates` v = `true`

                    )->ele( `header`
                        )->tag( `Text`
                            )->a( n = `text` v = `Supplier`

                    )->end(
                )->end(
                )->ele( `Column`
                    )->a( n = `mergeDuplicates` v = `true`

                    )->ele( `header`
                        )->tag( `Text`
                            )->a( n = `text` v = `Product`

                    )->end(
                )->end(
                )->ele( `Column`
                    )->a( n = `minScreenWidth` v = `Tablet`
                    )->a( n = `demandPopin`    v = `true`
                    )->a( n = `hAlign`         v = `End`

                    )->ele( `header`
                        )->tag( `Text`
                            )->a( n = `text` v = `Dimensions`

                    )->end(
                )->end(
                )->ele( `Column`
                    )->a( n = `minScreenWidth`    v = `Tablet`
                    )->a( n = `demandPopin`       v = `true`
                    )->a( n = `hAlign`            v = `Center`
                    )->a( n = `mergeDuplicates`   v = `true`
                    )->a( n = `mergeFunctionName` v = `getNumber`

                    )->ele( `header`
                        )->tag( `Text`
                            )->a( n = `text` v = `Weight`

                    )->end(
                )->end(
                )->ele( `Column`
                    )->a( n = `hAlign` v = `End`

                    )->ele( `header`
                        )->tag( `Text`
                            )->a( n = `text` v = `Price`

                    )->end(
                )->end(
            )->end(

            )->ele( `ColumnListItem`
                )->a( n = `vAlign` v = `Middle`
                )->a( n = `type`   v = `{ROW_TYPE}`

                )->tag( `Text`
                    )->a( n = `text` v = `{SUPPLIERNAME}`
                )->tag( `ObjectIdentifier`
                    )->a( n = `title` v = `{NAME}`
                    )->a( n = `text`  v = `{PRODUCTID}`
                )->tag( `Text`
                    )->a( n = `text` v = `{WIDTH} x {DEPTH} x {HEIGHT} {DIMUNIT}`
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
    " keeps its own sorter on SUPPLIERNAME
    t_products = VALUE #(
      ( productid = `HT-1000` name = `Notebook Basic 15` suppliername = `Very Best Screens`
        width = `30` depth = `18` height = `3` dimunit = `cm`
        weightmeasure = `4.2` weightunit = `KG` weight_state = `Success` row_type = `Navigation`
        price = `956` currencycode = `EUR` )
      ( productid = `HT-1001` name = `Notebook Basic 17` suppliername = `Very Best Screens`
        width = `29` depth = `17` height = `3.1` dimunit = `cm`
        weightmeasure = `4.5` weightunit = `KG` weight_state = `Success` row_type = `Navigation`
        price = `1249` currencycode = `EUR` )
      ( productid = `HT-1002` name = `Notebook Basic 18` suppliername = `Very Best Screens`
        width = `28` depth = `19` height = `2.5` dimunit = `cm`
        weightmeasure = `4.2` weightunit = `KG` weight_state = `Success` row_type = `Navigation`
        price = `1570` currencycode = `EUR` )
      ( productid = `HT-1003` name = `Notebook Basic 19` suppliername = `Smartcards`
        width = `32` depth = `21` height = `4` dimunit = `cm`
        weightmeasure = `4.2` weightunit = `KG` weight_state = `Success` row_type = `Navigation`
        price = `1650` currencycode = `EUR` )
      ( productid = `HT-1007` name = `ITelO Vault` suppliername = `Technocom`
        width = `32` depth = `22` height = `3` dimunit = `cm`
        weightmeasure = `0.2` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `299` currencycode = `EUR` )
      ( productid = `HT-1010` name = `Notebook Professional 15` suppliername = `Very Best Screens`
        width = `33` depth = `20` height = `3` dimunit = `cm`
        weightmeasure = `4.3` weightunit = `KG` weight_state = `Success` row_type = `Navigation`
        price = `1999` currencycode = `EUR` )
      ( productid = `HT-1011` name = `Notebook Professional 17` suppliername = `Very Best Screens`
        width = `33` depth = `23` height = `2` dimunit = `cm`
        weightmeasure = `4.1` weightunit = `KG` weight_state = `Success` row_type = `Navigation`
        price = `2299` currencycode = `EUR` )
      ( productid = `HT-1020` name = `ITelO Vault Net` suppliername = `Technocom`
        width = `10` depth = `1.8` height = `17` dimunit = `cm`
        weightmeasure = `0.16` weightunit = `KG` weight_state = `Success` row_type = `Navigation`
        price = `459` currencycode = `EUR` )
      ( productid = `HT-1021` name = `ITelO Vault SAT` suppliername = `Technocom`
        width = `11` depth = `1.7` height = `18` dimunit = `cm`
        weightmeasure = `0.18` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `149` currencycode = `EUR` )
      ( productid = `HT-1022` name = `Comfort Easy` suppliername = `Technocom`
        width = `84` depth = `1.5` height = `14` dimunit = `cm`
        weightmeasure = `0.2` weightunit = `KG` weight_state = `Success` row_type = `Navigation`
        price = `1679` currencycode = `EUR` )
      ( productid = `HT-1023` name = `Comfort Senior` suppliername = `Technocom`
        width = `80` depth = `1.6` height = `13` dimunit = `cm`
        weightmeasure = `0.8` weightunit = `KG` weight_state = `Success` row_type = `Navigation`
        price = `512` currencycode = `EUR` )
      ( productid = `HT-1030` name = `Ergo Screen E-I` suppliername = `Very Best Screens`
        width = `37` depth = `12` height = `36` dimunit = `cm`
        weightmeasure = `21` weightunit = `KG` weight_state = `Error` row_type = `Inactive`
        price = `230` currencycode = `EUR` )
      ( productid = `HT-1031` name = `Ergo Screen E-II` suppliername = `Very Best Screens`
        width = `40.8` depth = `19` height = `43` dimunit = `cm`
        weightmeasure = `21` weightunit = `KG` weight_state = `Error` row_type = `Inactive`
        price = `285` currencycode = `EUR` )
      ( productid = `HT-1032` name = `Ergo Screen E-III` suppliername = `Very Best Screens`
        width = `40.8` depth = `19` height = `43` dimunit = `cm`
        weightmeasure = `21` weightunit = `KG` weight_state = `Error` row_type = `Inactive`
        price = `345` currencycode = `EUR` )
      ( productid = `HT-1035` name = `Flat Basic` suppliername = `Very Best Screens`
        width = `39` depth = `20` height = `41` dimunit = `cm`
        weightmeasure = `14` weightunit = `KG` weight_state = `Warning` row_type = `Inactive`
        price = `399` currencycode = `EUR` )
      ( productid = `HT-1036` name = `Flat Future` suppliername = `Very Best Screens`
        width = `45` depth = `26` height = `46` dimunit = `cm`
        weightmeasure = `15` weightunit = `KG` weight_state = `Warning` row_type = `Navigation`
        price = `430` currencycode = `EUR` )
      ( productid = `HT-1037` name = `Flat XL` suppliername = `Very Best Screens`
        width = `54.5` depth = `22.1` height = `39.1` dimunit = `cm`
        weightmeasure = `17` weightunit = `KG` weight_state = `Warning` row_type = `Navigation`
        price = `1230` currencycode = `EUR` )
      ( productid = `HT-1040` name = `Laser Professional Eco` suppliername = `Alpha Printers`
        width = `51` depth = `46` height = `30` dimunit = `cm`
        weightmeasure = `32` weightunit = `KG` weight_state = `Error` row_type = `Navigation`
        price = `830` currencycode = `EUR` )
      ( productid = `HT-1041` name = `Laser Basic` suppliername = `Alpha Printers`
        width = `48` depth = `42` height = `26` dimunit = `cm`
        weightmeasure = `23` weightunit = `KG` weight_state = `Error` row_type = `Navigation`
        price = `490` currencycode = `EUR` )
      ( productid = `HT-1042` name = `Laser Allround` suppliername = `Alpha Printers`
        width = `53` depth = `50` height = `65` dimunit = `cm`
        weightmeasure = `17` weightunit = `KG` weight_state = `Warning` row_type = `Inactive`
        price = `349` currencycode = `EUR` )
      ( productid = `HT-1050` name = `Ultra Jet Super Color` suppliername = `Alpha Printers`
        width = `41` depth = `41` height = `28` dimunit = `cm`
        weightmeasure = `3` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `139` currencycode = `EUR` )
      ( productid = `HT-1051` name = `Ultra Jet Mobile` suppliername = `Printer for All`
        width = `46` depth = `32` height = `25` dimunit = `cm`
        weightmeasure = `1.9` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `99` currencycode = `EUR` )
      ( productid = `HT-1052` name = `Ultra Jet Super Highspeed` suppliername = `Printer for All`
        width = `41` depth = `41` height = `28` dimunit = `cm`
        weightmeasure = `18` weightunit = `KG` weight_state = `Warning` row_type = `Inactive`
        price = `170` currencycode = `EUR` )
      ( productid = `HT-1055` name = `Multi Print` suppliername = `Printer for All`
        width = `55` depth = `45` height = `29` dimunit = `cm`
        weightmeasure = `6.3` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `99` currencycode = `EUR` )
      ( productid = `HT-1056` name = `Multi Color` suppliername = `Printer for All`
        width = `51` depth = `41.3` height = `22` dimunit = `cm`
        weightmeasure = `4.3` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `119` currencycode = `EUR` )
      ( productid = `HT-1060` name = `Cordless Mouse` suppliername = `Oxynum`
        width = `6` depth = `14.5` height = `3.5` dimunit = `cm`
        weightmeasure = `0.09` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `9` currencycode = `EUR` )
      ( productid = `HT-1061` name = `Speed Mouse` suppliername = `Oxynum`
        width = `7` depth = `15` height = `3.1` dimunit = `cm`
        weightmeasure = `0.09` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `7` currencycode = `EUR` )
      ( productid = `HT-1062` name = `Track Mouse` suppliername = `Oxynum`
        width = `3` depth = `7` height = `4` dimunit = `cm`
        weightmeasure = `0.03` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `11` currencycode = `EUR` )
      ( productid = `HT-1063` name = `Ergonomic Keyboard` suppliername = `Oxynum`
        width = `50` depth = `21` height = `3.5` dimunit = `cm`
        weightmeasure = `2.1` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `14` currencycode = `EUR` )
      ( productid = `HT-1064` name = `Internet Keyboard` suppliername = `Oxynum`
        width = `52` depth = `25` height = `3` dimunit = `cm`
        weightmeasure = `1.8` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `16` currencycode = `EUR` )
      ( productid = `HT-1065` name = `Media Keyboard` suppliername = `Oxynum`
        width = `51.4` depth = `23` height = `4` dimunit = `cm`
        weightmeasure = `2.3` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `26` currencycode = `EUR` )
      ( productid = `HT-1066` name = `Mousepad` suppliername = `Oxynum`
        width = `15` depth = `6` height = `0.2` dimunit = `cm`
        weightmeasure = `80` weightunit = `G` weight_state = `Error` row_type = `Inactive`
        price = `6.99` currencycode = `EUR` )
      ( productid = `HT-1067` name = `Ergo Mousepad` suppliername = `Oxynum`
        width = `15` depth = `6` height = `0.2` dimunit = `cm`
        weightmeasure = `80` weightunit = `G` weight_state = `Error` row_type = `Inactive`
        price = `8.99` currencycode = `EUR` )
      ( productid = `HT-1068` name = `Designer Mousepad` suppliername = `Fasttech`
        width = `24` depth = `24` height = `0.6` dimunit = `cm`
        weightmeasure = `90` weightunit = `G` weight_state = `Error` row_type = `Inactive`
        price = `12.99` currencycode = `EUR` )
      ( productid = `HT-1069` name = `Universal card reader` suppliername = `Fasttech`
        width = `6` depth = `6` height = `3` dimunit = `cm`
        weightmeasure = `45` weightunit = `G` weight_state = `Error` row_type = `Inactive`
        price = `14` currencycode = `EUR` )
      ( productid = `HT-1070` name = `Proctra X` suppliername = `Ultrasonic United`
        width = `22` depth = `35` height = `17` dimunit = `cm`
        weightmeasure = `0.255` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `70.9` currencycode = `EUR` )
      ( productid = `HT-1071` name = `Gladiator MX` suppliername = `Ultrasonic United`
        width = `22` depth = `35` height = `17` dimunit = `cm`
        weightmeasure = `0.3` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `81.7` currencycode = `EUR` )
      ( productid = `HT-1072` name = `Hurricane GX` suppliername = `Ultrasonic United`
        width = `22` depth = `35` height = `17` dimunit = `cm`
        weightmeasure = `0.4` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `101.2` currencycode = `EUR` )
      ( productid = `HT-1073` name = `Hurricane GX/LN` suppliername = `Smartcards`
        width = `22` depth = `35` height = `17` dimunit = `cm`
        weightmeasure = `0.4` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `139.99` currencycode = `EUR` )
      ( productid = `HT-1080` name = `Photo Scan` suppliername = `Printer for All`
        width = `34` depth = `48` height = `5` dimunit = `cm`
        weightmeasure = `2.3` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `129` currencycode = `EUR` )
      ( productid = `HT-1081` name = `Power Scan` suppliername = `Printer for All`
        width = `31` depth = `43` height = `7` dimunit = `cm`
        weightmeasure = `2.4` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `89` currencycode = `EUR` )
      ( productid = `HT-1082` name = `Jet Scan Professional` suppliername = `Printer for All`
        width = `33` depth = `41` height = `12` dimunit = `cm`
        weightmeasure = `3.2` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `169` currencycode = `EUR` )
      ( productid = `HT-1083` name = `Jet Scan Professional` suppliername = `Printer for All`
        width = `35` depth = `40` height = `10` dimunit = `cm`
        weightmeasure = `3.2` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `189` currencycode = `EUR` )
      ( productid = `HT-1085` name = `Copymaster` suppliername = `Alpha Printers`
        width = `45` depth = `42` height = `22` dimunit = `cm`
        weightmeasure = `23.2` weightunit = `KG` weight_state = `Error` row_type = `Navigation`
        price = `1499` currencycode = `EUR` )
      ( productid = `HT-1090` name = `Surround Sound` suppliername = `Speaker Experts`
        width = `12` depth = `10` height = `16` dimunit = `cm`
        weightmeasure = `3` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `39` currencycode = `EUR` )
      ( productid = `HT-1091` name = `Blaster Extreme` suppliername = `Speaker Experts`
        width = `13` depth = `11` height = `17.5` dimunit = `cm`
        weightmeasure = `1.4` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `26` currencycode = `EUR` )
      ( productid = `HT-1092` name = `Sound Booster` suppliername = `Speaker Experts`
        width = `12.4` depth = `10.4` height = `18.1` dimunit = `cm`
        weightmeasure = `2.1` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `45` currencycode = `EUR` )
      ( productid = `HT-1095` name = `Lovely Sound 5.1 Wireless` suppliername = `Fasttech`
        width = `24` depth = `19` height = `23` dimunit = `cm`
        weightmeasure = `80` weightunit = `G` weight_state = `Error` row_type = `Inactive`
        price = `49` currencycode = `EUR` )
      ( productid = `HT-1096` name = `Lovely Sound 5.1` suppliername = `Fasttech`
        width = `25` depth = `17` height = `19` dimunit = `cm`
        weightmeasure = `130` weightunit = `G` weight_state = `Error` row_type = `Inactive`
        price = `39` currencycode = `EUR` )
      ( productid = `HT-1097` name = `Lovely Sound Stereo` suppliername = `Fasttech`
        width = `21.3` depth = `2.4` height = `19.7` dimunit = `cm`
        weightmeasure = `60` weightunit = `G` weight_state = `Error` row_type = `Inactive`
        price = `29` currencycode = `EUR` )
      ( productid = `HT-1100` name = `Smart Office` suppliername = `Technocom`
        width = `15` depth = `6.5` height = `2.1` dimunit = `cm`
        weightmeasure = `1.2` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `89.9` currencycode = `EUR` )
      ( productid = `HT-1101` name = `Smart Design` suppliername = `Technocom`
        width = `14` depth = `6.7` height = `24` dimunit = `cm`
        weightmeasure = `0.8` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `79.9` currencycode = `EUR` )
      ( productid = `HT-1102` name = `Smart Network` suppliername = `Technocom`
        width = `16` depth = `6` height = `27` dimunit = `cm`
        weightmeasure = `0.8` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `69` currencycode = `EUR` )
      ( productid = `HT-1103` name = `Smart Multimedia` suppliername = `Technocom`
        width = `11` depth = `3.4` height = `22` dimunit = `cm`
        weightmeasure = `0.8` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `77` currencycode = `EUR` )
      ( productid = `HT-1104` name = `Smart Games` suppliername = `Technocom`
        width = `10` depth = `3` height = `30` dimunit = `cm`
        weightmeasure = `1.1` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `55` currencycode = `EUR` )
      ( productid = `HT-1105` name = `Smart Internet Antivirus` suppliername = `Brainsoft`
        width = `16` depth = `4` height = `21` dimunit = `cm`
        weightmeasure = `0.7` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `29` currencycode = `EUR` )
      ( productid = `HT-1106` name = `Smart Firewall` suppliername = `Brainsoft`
        width = `17.9` depth = `4.2` height = `23.1` dimunit = `cm`
        weightmeasure = `0.9` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `34` currencycode = `EUR` )
      ( productid = `HT-1107` name = `Smart Money` suppliername = `Brainsoft`
        width = `12` depth = `1.5` height = `19` dimunit = `cm`
        weightmeasure = `0.5` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `29.9` currencycode = `EUR` )
      ( productid = `HT-1110` name = `PC Lock` suppliername = `Red Point Stores`
        width = `20` depth = `8` height = `4.3` dimunit = `cm`
        weightmeasure = `0.03` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `8.9` currencycode = `EUR` )
      ( productid = `HT-1111` name = `Notebook Lock` suppliername = `Red Point Stores`
        width = `31` depth = `9` height = `7` dimunit = `cm`
        weightmeasure = `0.02` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `6.9` currencycode = `EUR` )
      ( productid = `HT-1112` name = `Web cam reality` suppliername = `Red Point Stores`
        width = `9` depth = `8.2` height = `1.3` dimunit = `cm`
        weightmeasure = `0.075` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `39` currencycode = `EUR` )
      ( productid = `HT-1113` name = `Screen clean` suppliername = `Red Point Stores`
        width = `2` depth = `2` height = `0.1` dimunit = `cm`
        weightmeasure = `0.05` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `2.3` currencycode = `EUR` )
      ( productid = `HT-1114` name = `Fabric bag professional` suppliername = `Red Point Stores`
        width = `42` depth = `32` height = `7` dimunit = `cm`
        weightmeasure = `1.8` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `31` currencycode = `EUR` )
      ( productid = `HT-1115` name = `Wireless DSL Router` suppliername = `Red Point Stores`
        width = `19.3` depth = `18` height = `5` dimunit = `cm`
        weightmeasure = `0.45` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `49` currencycode = `EUR` )
      ( productid = `HT-1116` name = `Wireless DSL Router / Repeater` suppliername = `Red Point Stores`
        width = `19.3` depth = `18` height = `5` dimunit = `cm`
        weightmeasure = `0.45` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `59` currencycode = `EUR` )
      ( productid = `HT-1117` name = `Wireless DSL Router / Repeater and Print Server` suppliername = `Technocom`
        width = `19.3` depth = `18` height = `5` dimunit = `cm`
        weightmeasure = `0.45` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `69` currencycode = `EUR` )
      ( productid = `HT-1118` name = `USB Stick` suppliername = `Technocom`
        width = `1.5` depth = `8.7` height = `1.2` dimunit = `cm`
        weightmeasure = `0.015` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `35` currencycode = `EUR` )
      ( productid = `HT-1119` name = `Travel Adapter` suppliername = `Titanium`
        width = `2` depth = `3.1` height = `3.9` dimunit = `cm`
        weightmeasure = `88` weightunit = `G` weight_state = `Error` row_type = `Inactive`
        price = `79` currencycode = `EUR` )
      ( productid = `HT-1120` name = `Cordless Bluetooth Keyboard, english international` suppliername = `Technocom`
        width = `51.4` depth = `23` height = `4` dimunit = `cm`
        weightmeasure = `1` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `29` currencycode = `EUR` )
      ( productid = `HT-1137` name = `Flat XXL` suppliername = `Technocom`
        width = `54` depth = `22` height = `38` dimunit = `cm`
        weightmeasure = `18` weightunit = `KG` weight_state = `Warning` row_type = `Navigation`
        price = `1430` currencycode = `EUR` )
      ( productid = `HT-1138` name = `Pocket Mouse` suppliername = `Technocom`
        width = `0.3` depth = `0.5` height = `1` dimunit = `cm`
        weightmeasure = `0.02` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `23` currencycode = `EUR` )
      ( productid = `HT-1210` name = `PC Power Station` suppliername = `Technocom`
        width = `28` depth = `31` height = `43` dimunit = `cm`
        weightmeasure = `2.3` weightunit = `KG` weight_state = `Success` row_type = `Navigation`
        price = `2399` currencycode = `EUR` )
      ( productid = `HT-1251` name = `Astro Laptop 1516` suppliername = `Ultrasonic United`
        width = `30` depth = `18` height = `3` dimunit = `cm`
        weightmeasure = `4.2` weightunit = `KG` weight_state = `Success` row_type = `Navigation`
        price = `989` currencycode = `EUR` )
      ( productid = `HT-1252` name = `Astro Phone 6` suppliername = `Ultrasonic United`
        width = `8` depth = `6` height = `1.5` dimunit = `cm`
        weightmeasure = `0.75` weightunit = `KG` weight_state = `Success` row_type = `Navigation`
        price = `649` currencycode = `EUR` )
      ( productid = `HT-1253` name = `Benda Laptop 1408` suppliername = `Ultrasonic United`
        width = `30` depth = `18` height = `3` dimunit = `cm`
        weightmeasure = `4.2` weightunit = `KG` weight_state = `Success` row_type = `Navigation`
        price = `976` currencycode = `EUR` )
      ( productid = `HT-1254` name = `Bending Screen 21HD` suppliername = `Ultrasonic United`
        width = `37` depth = `12` height = `36` dimunit = `cm`
        weightmeasure = `15` weightunit = `KG` weight_state = `Warning` row_type = `Inactive`
        price = `250` currencycode = `EUR` )
      ( productid = `HT-1255` name = `Broad Screen 22HD` suppliername = `Ultrasonic United`
        width = `39` depth = `12` height = `38` dimunit = `cm`
        weightmeasure = `16` weightunit = `KG` weight_state = `Warning` row_type = `Inactive`
        price = `270` currencycode = `EUR` )
      ( productid = `HT-1256` name = `Cerdik Phone 7` suppliername = `Ultrasonic United`
        width = `9` depth = `15` height = `1.5` dimunit = `cm`
        weightmeasure = `0.75` weightunit = `KG` weight_state = `Success` row_type = `Navigation`
        price = `549` currencycode = `EUR` )
      ( productid = `HT-1257` name = `Cepat Tablet 10.5` suppliername = `Ultrasonic United`
        width = `48` depth = `31` height = `4.5` dimunit = `cm`
        weightmeasure = `2.8` weightunit = `KG` weight_state = `Success` row_type = `Navigation`
        price = `549` currencycode = `EUR` )
      ( productid = `HT-1258` name = `Cepat Tablet 8` suppliername = `Ultrasonic United`
        width = `38` depth = `21` height = `3.5` dimunit = `cm`
        weightmeasure = `2.5` weightunit = `KG` weight_state = `Success` row_type = `Navigation`
        price = `529` currencycode = `EUR` )
      ( productid = `HT-1500` name = `Server Basic` suppliername = `Technocom`
        width = `34` depth = `35` height = `23` dimunit = `cm`
        weightmeasure = `18` weightunit = `KG` weight_state = `Warning` row_type = `Navigation`
        price = `5000` currencycode = `EUR` )
      ( productid = `HT-1501` name = `Server Professional` suppliername = `Technocom`
        width = `29` depth = `30` height = `27` dimunit = `cm`
        weightmeasure = `25` weightunit = `KG` weight_state = `Error` row_type = `Navigation`
        price = `15000` currencycode = `EUR` )
      ( productid = `HT-1502` name = `Server Power Pro` suppliername = `Technocom`
        width = `22` depth = `27.3` height = `37` dimunit = `cm`
        weightmeasure = `35` weightunit = `KG` weight_state = `Error` row_type = `Navigation`
        price = `25000` currencycode = `EUR` )
      ( productid = `HT-1600` name = `Family PC Basic` suppliername = `Titanium`
        width = `21.4` depth = `29` height = `38` dimunit = `cm`
        weightmeasure = `4.8` weightunit = `KG` weight_state = `Success` row_type = `Navigation`
        price = `600` currencycode = `EUR` )
      ( productid = `HT-1601` name = `Family PC Pro` suppliername = `Titanium`
        width = `25` depth = `31.7` height = `40.2` dimunit = `cm`
        weightmeasure = `5.3` weightunit = `KG` weight_state = `Success` row_type = `Navigation`
        price = `900` currencycode = `EUR` )
      ( productid = `HT-1602` name = `Gaming Monster` suppliername = `Titanium`
        width = `26.5` depth = `34` height = `47` dimunit = `cm`
        weightmeasure = `5.9` weightunit = `KG` weight_state = `Success` row_type = `Navigation`
        price = `1200` currencycode = `EUR` )
      ( productid = `HT-1603` name = `Gaming Monster Pro` suppliername = `Titanium`
        width = `27` depth = `28` height = `42` dimunit = `cm`
        weightmeasure = `6.8` weightunit = `KG` weight_state = `Success` row_type = `Navigation`
        price = `1700` currencycode = `EUR` )
      ( productid = `HT-2000` name = `7" Widescreen Portable DVD Player w MP3` suppliername = `Titanium`
        width = `21.4` depth = `19` height = `27.6` dimunit = `cm`
        weightmeasure = `0.79` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `249.99` currencycode = `EUR` )
      ( productid = `HT-2001` name = `10" Portable DVD player` suppliername = `Titanium`
        width = `24` depth = `19.5` height = `29` dimunit = `cm`
        weightmeasure = `0.84` weightunit = `KG` weight_state = `Success` row_type = `Navigation`
        price = `449.99` currencycode = `EUR` )
      ( productid = `HT-2002` name = `Portable DVD Player with 9" LCD Monitor` suppliername = `Technocom`
        width = `21` depth = `16.5` height = `14` dimunit = `cm`
        weightmeasure = `0.72` weightunit = `KG` weight_state = `Success` row_type = `Navigation`
        price = `853.99` currencycode = `EUR` )
      ( productid = `HT-2025` name = `CD/DVD case: 264 sleeves` suppliername = `Titanium`
        width = `13` depth = `13` height = `20` dimunit = `cm`
        weightmeasure = `0.65` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `44.99` currencycode = `EUR` )
      ( productid = `HT-2026` name = `Audio/Video Cable Kit - 4m` suppliername = `Titanium`
        width = `21` depth = `10.2` height = `13` dimunit = `cm`
        weightmeasure = `0.2` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `29.99` currencycode = `EUR` )
      ( productid = `HT-2027` name = `Removable CD/DVD Laser Labels` suppliername = `Titanium`
        width = `5.5` depth = `2` height = `2` dimunit = `cm`
        weightmeasure = `0.15` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `8.99` currencycode = `EUR` )
      ( productid = `HT-6100` name = `Beam Breaker B-1` suppliername = `Titanium`
        width = `30.4` depth = `23.1` height = `23` dimunit = `cm`
        weightmeasure = `1.7` weightunit = `KG` weight_state = `Success` row_type = `Navigation`
        price = `469` currencycode = `EUR` )
      ( productid = `HT-6101` name = `Beam Breaker B-2` suppliername = `Technocom`
        width = `30.4` depth = `23.1` height = `23` dimunit = `cm`
        weightmeasure = `2` weightunit = `KG` weight_state = `Success` row_type = `Navigation`
        price = `679` currencycode = `EUR` )
      ( productid = `HT-6102` name = `Beam Breaker B-3` suppliername = `Technocom`
        width = `30.4` depth = `23.1` height = `23` dimunit = `cm`
        weightmeasure = `2.5` weightunit = `KG` weight_state = `Success` row_type = `Navigation`
        price = `889` currencycode = `EUR` )
      ( productid = `HT-6110` name = `Play Movie` suppliername = `Fasttech`
        width = `37` depth = `24` height = `6` dimunit = `cm`
        weightmeasure = `2.4` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `130` currencycode = `EUR` )
      ( productid = `HT-6111` name = `Record Movie` suppliername = `Fasttech`
        width = `38` depth = `26` height = `6.2` dimunit = `cm`
        weightmeasure = `3.1` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `288` currencycode = `EUR` )
      ( productid = `HT-6120` name = `ITelo MusicStick` suppliername = `Fasttech`
        width = `1.5` depth = `6` height = `1` dimunit = `cm`
        weightmeasure = `134` weightunit = `G` weight_state = `Error` row_type = `Inactive`
        price = `45` currencycode = `EUR` )
      ( productid = `HT-6121` name = `ITelo Jog-Mate` suppliername = `Fasttech`
        width = `5.1` depth = `8` height = `9.2` dimunit = `cm`
        weightmeasure = `134` weightunit = `G` weight_state = `Error` row_type = `Inactive`
        price = `63` currencycode = `EUR` )
      ( productid = `HT-6122` name = `Power Pro Player 40` suppliername = `Fasttech`
        width = `5.1` depth = `8` height = `9.2` dimunit = `cm`
        weightmeasure = `266` weightunit = `G` weight_state = `Error` row_type = `Inactive`
        price = `167` currencycode = `EUR` )
      ( productid = `HT-6123` name = `Power Pro Player 80` suppliername = `Fasttech`
        width = `4` depth = `6` height = `0.8` dimunit = `cm`
        weightmeasure = `267` weightunit = `G` weight_state = `Error` row_type = `Inactive`
        price = `299` currencycode = `EUR` )
      ( productid = `HT-6130` name = `Flat Watch HD32` suppliername = `Very Best Screens`
        width = `78` depth = `22.1` height = `55` dimunit = `cm`
        weightmeasure = `2.6` weightunit = `KG` weight_state = `Success` row_type = `Navigation`
        price = `1459` currencycode = `EUR` )
      ( productid = `HT-6131` name = `Flat Watch HD37` suppliername = `Very Best Screens`
        width = `99.1` depth = `26` height = `61` dimunit = `cm`
        weightmeasure = `2.2` weightunit = `KG` weight_state = `Success` row_type = `Navigation`
        price = `1199` currencycode = `EUR` )
      ( productid = `HT-6132` name = `Flat Watch HD41` suppliername = `Very Best Screens`
        width = `128` depth = `23` height = `79.1` dimunit = `cm`
        weightmeasure = `1.8` weightunit = `KG` weight_state = `Success` row_type = `Navigation`
        price = `899` currencycode = `EUR` )
      ( productid = `HT-7000` name = `Copperberry` suppliername = `Fasttech`
        width = `8.1` depth = `13` height = `12.1` dimunit = `cm`
        weightmeasure = `0.5` weightunit = `KG` weight_state = `Success` row_type = `Navigation`
        price = `549` currencycode = `EUR` )
      ( productid = `HT-7010` name = `Silverberry` suppliername = `Fasttech`
        width = `8.1` depth = `13` height = `12.1` dimunit = `cm`
        weightmeasure = `0.5` weightunit = `KG` weight_state = `Success` row_type = `Navigation`
        price = `549` currencycode = `EUR` )
      ( productid = `HT-7020` name = `Goldberry` suppliername = `Fasttech`
        width = `8.1` depth = `13` height = `12.1` dimunit = `cm`
        weightmeasure = `0.5` weightunit = `KG` weight_state = `Success` row_type = `Navigation`
        price = `549` currencycode = `EUR` )
      ( productid = `HT-7030` name = `Platinberry` suppliername = `Fasttech`
        width = `8.1` depth = `13` height = `12.1` dimunit = `cm`
        weightmeasure = `0.5` weightunit = `KG` weight_state = `Success` row_type = `Navigation`
        price = `549` currencycode = `EUR` )
      ( productid = `HT-8000` name = `ITelO FlexTop I4000` suppliername = `Titanium`
        width = `31` depth = `19` height = `3.1` dimunit = `cm`
        weightmeasure = `4` weightunit = `KG` weight_state = `Success` row_type = `Navigation`
        price = `799` currencycode = `EUR` )
      ( productid = `HT-8001` name = `ITelO FlexTop I6300c` suppliername = `Titanium`
        width = `32` depth = `20` height = `3.4` dimunit = `cm`
        weightmeasure = `4.2` weightunit = `KG` weight_state = `Success` row_type = `Navigation`
        price = `799` currencycode = `EUR` )
      ( productid = `HT-8002` name = `ITelO FlexTop I9100` suppliername = `Titanium`
        width = `38` depth = `21` height = `4.1` dimunit = `cm`
        weightmeasure = `3.5` weightunit = `KG` weight_state = `Success` row_type = `Navigation`
        price = `1199` currencycode = `EUR` )
      ( productid = `HT-8003` name = `ITelO FlexTop I9800` suppliername = `Titanium`
        width = `48` depth = `31` height = `4.5` dimunit = `cm`
        weightmeasure = `3.8` weightunit = `KG` weight_state = `Success` row_type = `Navigation`
        price = `1388` currencycode = `EUR` )
      ( productid = `HT-9991` name = `Smartphone Leather Case` suppliername = `Ultrasonic United`
        width = `48` depth = `31` height = `4.5` dimunit = `cm`
        weightmeasure = `0.02` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `25` currencycode = `EUR` )
      ( productid = `HT-9992` name = `Smartphone Alpha` suppliername = `Ultrasonic United`
        width = `48` depth = `31` height = `4.5` dimunit = `cm`
        weightmeasure = `0.75` weightunit = `KG` weight_state = `Success` row_type = `Navigation`
        price = `599` currencycode = `EUR` )
      ( productid = `HT-9993` name = `Mini Tablet` suppliername = `Ultrasonic United`
        width = `48` depth = `31` height = `4.5` dimunit = `cm`
        weightmeasure = `3.8` weightunit = `KG` weight_state = `Success` row_type = `Navigation`
        price = `833` currencycode = `EUR` )
      ( productid = `HT-9994` name = `Camcorder View` suppliername = `Ultrasonic United`
        width = `48` depth = `31` height = `27` dimunit = `cm`
        weightmeasure = `3.8` weightunit = `KG` weight_state = `Success` row_type = `Navigation`
        price = `1388` currencycode = `EUR` )
      ( productid = `HT-9995` name = `Tablet Pouch` suppliername = `Titanium`
        width = `25` depth = `40` height = `4.5` dimunit = `cm`
        weightmeasure = `0.03` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `20` currencycode = `EUR` )
      ( productid = `HT-9996` name = `Tablet Pouch` suppliername = `Titanium`
        width = `25` depth = `40` height = `4.5` dimunit = `cm`
        weightmeasure = `0.03` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `20` currencycode = `EUR` )
      ( productid = `HT-9997` name = `e-Book Reader ReadMe` suppliername = `Titanium`
        width = `48` depth = `31` height = `4.5` dimunit = `cm`
        weightmeasure = `3.8` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `33` currencycode = `EUR` )
      ( productid = `HT-9998` name = `Smartphone Beta` suppliername = `Titanium`
        width = `48` depth = `31` height = `4.5` dimunit = `cm`
        weightmeasure = `0.75` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `30` currencycode = `EUR` )
      ( productid = `HT-9999` name = `Maxi Tablet` suppliername = `Titanium`
        width = `48` depth = `31` height = `4.5` dimunit = `cm`
        weightmeasure = `3.8` weightunit = `KG` weight_state = `Success` row_type = `Navigation`
        price = `749` currencycode = `EUR` )
      ( productid = `PF-1000` name = `Flyer` suppliername = `Titanium`
        width = `46` depth = `30` height = `3` dimunit = `cm`
        weightmeasure = `0.01` weightunit = `KG` weight_state = `Success` row_type = `Inactive`
        price = `0` currencycode = `EUR` ) ).

  ENDMETHOD.

ENDCLASS.
