" @keywords objectpagesubsection object sub section sap.uxap objectpagesubsectionhiddentitle objectpagelayout objectpageheader objectpagesection simpleform label text
" @summary Example of a subsection with showTitle property set to false.
CLASS z2ui5_cl_smpc_app_245 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        suppliername  TYPE string,
        name          TYPE string,
        productid     TYPE string,
        width         TYPE string,
        depth         TYPE string,
        height        TYPE string,
        dimunit       TYPE string,
        weightmeasure TYPE string,
        weightunit    TYPE string,
        weightstate   TYPE string,
        price         TYPE p LENGTH 13 DECIMALS 2,
        currencycode  TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_245 IMPLEMENTATION.

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

    " sap.uxap ObjectPageLayout demonstrating ObjectPageSubSection.showTitle=false
    " (the promoted, hidden-title subsection hosting the Products table). Two
    " SimpleForm subsections precede it. The ObjectNumber weight state is computed
    " in ABAP (thin frontend) instead of the original frontend .weightState.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc`   v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core`  v = `sap.ui.core`
        )->a( n = `xmlns:forms` v = `sap.ui.layout.form`
        )->a( n = `xmlns:uxap`  v = `sap.uxap`
        )->a( n = `xmlns`       v = `sap.m`
        )->a( n = `height`      v = `100%`

        )->ele( n = `ObjectPageLayout` ns = `uxap`
            )->a( n = `id`               v = `ObjectPageLayout`
            )->a( n = `upperCaseAnchorBar` v = `false`

            )->ele( n = `headerTitle` ns = `uxap`
                )->tag( n = `ObjectPageHeader` ns = `uxap`
                    )->a( n = `objectTitle`    v = `ObjectPageSubSection with hidden title`
                    )->a( n = `objectSubtitle` v = `This example demonstrates the showTitle property set to false.`

            )->end(

            )->ele( n = `sections` ns = `uxap`
                )->ele( n = `ObjectPageSection` ns = `uxap`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `Sample Forms`

                    )->ele( n = `subSections` ns = `uxap`
                        )->ele( n = `ObjectPageSubSection` ns = `uxap`
                            )->a( n = `title`          v = `First Sample Form`
                            )->a( n = `titleUppercase` v = `false`

                            )->ele( n = `blocks` ns = `uxap`
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `title`    v = `Location`
                                    )->a( n = `editable` v = `false`
                                    )->a( n = `layout`   v = `ColumnLayout`

                                    )->tag( `Label`
                                        )->a( n = `text` v = `Country`
                                    )->tag( `Text`
                                        )->a( n = `text` v = `France`
                                    )->tag( `Label`
                                        )->a( n = `text` v = `Subsidiary`
                                    )->tag( `Text`
                                        )->a( n = `text` v = `SAP France`

                                )->end(
                            )->end(
                        )->end(

                        )->ele( n = `ObjectPageSubSection` ns = `uxap`
                            )->a( n = `title`          v = `Second Sample Form`
                            )->a( n = `titleUppercase` v = `false`

                            )->ele( n = `blocks` ns = `uxap`
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `title`    v = `Location`
                                    )->a( n = `editable` v = `false`
                                    )->a( n = `layout`   v = `ColumnLayout`

                                    )->tag( `Label`
                                        )->a( n = `text` v = `Country`
                                    )->tag( `Text`
                                        )->a( n = `text` v = `France`
                                    )->tag( `Label`
                                        )->a( n = `text` v = `Subsidiary`
                                    )->tag( `Text`
                                        )->a( n = `text` v = `SAP France`
                                    )->tag( `Label`
                                        )->a( n = `text` v = `Building`
                                    )->tag( `Text`
                                        )->a( n = `text` v = `LVL B`
                                    )->tag( `Label`
                                        )->a( n = `text` v = `Room`
                                    )->tag( `Text`
                                        )->a( n = `text` v = `AppHaus`

                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( n = `ObjectPageSection` ns = `uxap`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `showTitle`      v = `false`

                    )->ele( n = `subSections` ns = `uxap`
                        )->ele( n = `ObjectPageSubSection` ns = `uxap`
                            )->a( n = `title`          v = `Promoted SubSection with Hidden Title`
                            )->a( n = `titleUppercase` v = `false`

                            )->ele( `Table`
                                )->a( n = `headerText` v = `Products`
                                )->a( n = `items`      v = |\{ path: '{ client->_bind( val = t_products path = abap_true ) }', sorter: \{ path: 'SUPPLIERNAME', descending: false \} \}|

                                )->ele( `headerToolbar`
                                    )->ele( `OverflowToolbar`
                                        )->ele( `content`
                                            )->tag( `Title`
                                                )->a( n = `text`  v = `Products`
                                                )->a( n = `level` v = `H2`
                                            )->tag( `ToolbarSpacer`
                                            )->ele( `ComboBox`
                                                )->a( n = `id`          v = `idPopinLayout`
                                                )->a( n = `placeholder` v = `Popin layout options`
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
                                                )->a( n = `text` v = `ColumnHeaders`
                                            )->tag( `CheckBox`
                                                )->a( n = `text` v = `HeaderToolbar`
                                            )->tag( `CheckBox`
                                                )->a( n = `text` v = `InfoToolbar`
                                            )->tag( `ToggleButton`
                                                )->a( n = `id`   v = `toggleInfoToolbar`
                                                )->a( n = `text` v = `Hide/Show InfoToolbar`

                                        )->end(
                                    )->end(
                                )->end(

                                )->ele( `infoToolbar`
                                    )->ele( `OverflowToolbar`
                                        )->tag( `Label`
                                            )->a( n = `text` v = `Wide range of available products`

                                    )->end(
                                )->end(

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
                                        )->a( n = `minScreenWidth` v = `Tablet`
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
                                                )->a( n = `text` v = `Price`

                                        )->end(
                                    )->end(
                                )->end(

                                )->ele( `ColumnListItem`
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
                                        )->a( n = `state`  v = `{WEIGHTSTATE}`
                                    )->tag( `ObjectNumber`
                                        )->a( n = `number` v = |\{ parts:[\{path:'PRICE'\},\{path:'CURRENCYCODE'\}], type: 'sap.ui.model.type.Currency', formatOptions: \{showMeasure: false\} \}|
                                        )->a( n = `unit`   v = `{CURRENCYCODE}`

                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " the shared 123-row demo ProductCollection (sap/ui/demo/mock/products.json)
    t_products = VALUE #(
      ( suppliername = `Very Best Screens` name = `Notebook Basic 15` productid = `HT-1000` width = `30` depth = `18` height = `3` dimunit = `cm` weightmeasure = `4.2` weightunit = `KG` price = `956` currencycode = `EUR` )
      ( suppliername = `Very Best Screens` name = `Notebook Basic 17` productid = `HT-1001` width = `29` depth = `17` height = `3.1` dimunit = `cm` weightmeasure = `4.5` weightunit = `KG` price = `1249` currencycode = `EUR` )
      ( suppliername = `Very Best Screens` name = `Notebook Basic 18` productid = `HT-1002` width = `28` depth = `19` height = `2.5` dimunit = `cm` weightmeasure = `4.2` weightunit = `KG` price = `1570` currencycode = `EUR` )
      ( suppliername = `Smartcards` name = `Notebook Basic 19` productid = `HT-1003` width = `32` depth = `21` height = `4` dimunit = `cm` weightmeasure = `4.2` weightunit = `KG` price = `1650` currencycode = `EUR` )
      ( suppliername = `Technocom` name = `ITelO Vault` productid = `HT-1007` width = `32` depth = `22` height = `3` dimunit = `cm` weightmeasure = `0.2` weightunit = `KG` price = `299` currencycode = `EUR` )
      ( suppliername = `Very Best Screens` name = `Notebook Professional 15` productid = `HT-1010` width = `33` depth = `20` height = `3` dimunit = `cm` weightmeasure = `4.3` weightunit = `KG` price = `1999` currencycode = `EUR` )
      ( suppliername = `Very Best Screens` name = `Notebook Professional 17` productid = `HT-1011` width = `33` depth = `23` height = `2` dimunit = `cm` weightmeasure = `4.1` weightunit = `KG` price = `2299` currencycode = `EUR` )
      ( suppliername = `Technocom` name = `ITelO Vault Net` productid = `HT-1020` width = `10` depth = `1.8` height = `17` dimunit = `cm` weightmeasure = `0.16` weightunit = `KG` price = `459` currencycode = `EUR` )
      ( suppliername = `Technocom` name = `ITelO Vault SAT` productid = `HT-1021` width = `11` depth = `1.7` height = `18` dimunit = `cm` weightmeasure = `0.18` weightunit = `KG` price = `149` currencycode = `EUR` )
      ( suppliername = `Technocom` name = `Comfort Easy` productid = `HT-1022` width = `84` depth = `1.5` height = `14` dimunit = `cm` weightmeasure = `0.2` weightunit = `KG` price = `1679` currencycode = `EUR` )
      ( suppliername = `Technocom` name = `Comfort Senior` productid = `HT-1023` width = `80` depth = `1.6` height = `13` dimunit = `cm` weightmeasure = `0.8` weightunit = `KG` price = `512` currencycode = `EUR` )
      ( suppliername = `Very Best Screens` name = `Ergo Screen E-I` productid = `HT-1030` width = `37` depth = `12` height = `36` dimunit = `cm` weightmeasure = `21` weightunit = `KG` price = `230` currencycode = `EUR` )
      ( suppliername = `Very Best Screens` name = `Ergo Screen E-II` productid = `HT-1031` width = `40.8` depth = `19` height = `43` dimunit = `cm` weightmeasure = `21` weightunit = `KG` price = `285` currencycode = `EUR` )
      ( suppliername = `Very Best Screens` name = `Ergo Screen E-III` productid = `HT-1032` width = `40.8` depth = `19` height = `43` dimunit = `cm` weightmeasure = `21` weightunit = `KG` price = `345` currencycode = `EUR` )
      ( suppliername = `Very Best Screens` name = `Flat Basic` productid = `HT-1035` width = `39` depth = `20` height = `41` dimunit = `cm` weightmeasure = `14` weightunit = `KG` price = `399` currencycode = `EUR` )
      ( suppliername = `Very Best Screens` name = `Flat Future` productid = `HT-1036` width = `45` depth = `26` height = `46` dimunit = `cm` weightmeasure = `15` weightunit = `KG` price = `430` currencycode = `EUR` )
      ( suppliername = `Very Best Screens` name = `Flat XL` productid = `HT-1037` width = `54.5` depth = `22.1` height = `39.1` dimunit = `cm` weightmeasure = `17` weightunit = `KG` price = `1230` currencycode = `EUR` )
      ( suppliername = `Alpha Printers` name = `Laser Professional Eco` productid = `HT-1040` width = `51` depth = `46` height = `30` dimunit = `cm` weightmeasure = `32` weightunit = `KG` price = `830` currencycode = `EUR` )
      ( suppliername = `Alpha Printers` name = `Laser Basic` productid = `HT-1041` width = `48` depth = `42` height = `26` dimunit = `cm` weightmeasure = `23` weightunit = `KG` price = `490` currencycode = `EUR` )
      ( suppliername = `Alpha Printers` name = `Laser Allround` productid = `HT-1042` width = `53` depth = `50` height = `65` dimunit = `cm` weightmeasure = `17` weightunit = `KG` price = `349` currencycode = `EUR` )
      ( suppliername = `Alpha Printers` name = `Ultra Jet Super Color` productid = `HT-1050` width = `41` depth = `41` height = `28` dimunit = `cm` weightmeasure = `3` weightunit = `KG` price = `139` currencycode = `EUR` )
      ( suppliername = `Printer for All` name = `Ultra Jet Mobile` productid = `HT-1051` width = `46` depth = `32` height = `25` dimunit = `cm` weightmeasure = `1.9` weightunit = `KG` price = `99` currencycode = `EUR` )
      ( suppliername = `Printer for All` name = `Ultra Jet Super Highspeed` productid = `HT-1052` width = `41` depth = `41` height = `28` dimunit = `cm` weightmeasure = `18` weightunit = `KG` price = `170` currencycode = `EUR` )
      ( suppliername = `Printer for All` name = `Multi Print` productid = `HT-1055` width = `55` depth = `45` height = `29` dimunit = `cm` weightmeasure = `6.3` weightunit = `KG` price = `99` currencycode = `EUR` )
      ( suppliername = `Printer for All` name = `Multi Color` productid = `HT-1056` width = `51` depth = `41.3` height = `22` dimunit = `cm` weightmeasure = `4.3` weightunit = `KG` price = `119` currencycode = `EUR` )
      ( suppliername = `Oxynum` name = `Cordless Mouse` productid = `HT-1060` width = `6` depth = `14.5` height = `3.5` dimunit = `cm` weightmeasure = `0.09` weightunit = `KG` price = `9` currencycode = `EUR` )
      ( suppliername = `Oxynum` name = `Speed Mouse` productid = `HT-1061` width = `7` depth = `15` height = `3.1` dimunit = `cm` weightmeasure = `0.09` weightunit = `KG` price = `7` currencycode = `EUR` )
      ( suppliername = `Oxynum` name = `Track Mouse` productid = `HT-1062` width = `3` depth = `7` height = `4` dimunit = `cm` weightmeasure = `0.03` weightunit = `KG` price = `11` currencycode = `EUR` )
      ( suppliername = `Oxynum` name = `Ergonomic Keyboard` productid = `HT-1063` width = `50` depth = `21` height = `3.5` dimunit = `cm` weightmeasure = `2.1` weightunit = `KG` price = `14` currencycode = `EUR` )
      ( suppliername = `Oxynum` name = `Internet Keyboard` productid = `HT-1064` width = `52` depth = `25` height = `3` dimunit = `cm` weightmeasure = `1.8` weightunit = `KG` price = `16` currencycode = `EUR` )
      ( suppliername = `Oxynum` name = `Media Keyboard` productid = `HT-1065` width = `51.4` depth = `23` height = `4` dimunit = `cm` weightmeasure = `2.3` weightunit = `KG` price = `26` currencycode = `EUR` )
      ( suppliername = `Oxynum` name = `Mousepad` productid = `HT-1066` width = `15` depth = `6` height = `0.2` dimunit = `cm` weightmeasure = `80` weightunit = `G` price = `6.99` currencycode = `EUR` )
      ( suppliername = `Oxynum` name = `Ergo Mousepad` productid = `HT-1067` width = `15` depth = `6` height = `0.2` dimunit = `cm` weightmeasure = `80` weightunit = `G` price = `8.99` currencycode = `EUR` )
      ( suppliername = `Fasttech` name = `Designer Mousepad` productid = `HT-1068` width = `24` depth = `24` height = `0.6` dimunit = `cm` weightmeasure = `90` weightunit = `G` price = `12.99` currencycode = `EUR` )
      ( suppliername = `Fasttech` name = `Universal card reader` productid = `HT-1069` width = `6` depth = `6` height = `3` dimunit = `cm` weightmeasure = `45` weightunit = `G` price = `14` currencycode = `EUR` )
      ( suppliername = `Ultrasonic United` name = `Proctra X` productid = `HT-1070` width = `22` depth = `35` height = `17` dimunit = `cm` weightmeasure = `0.255` weightunit = `KG` price = `70.9` currencycode = `EUR` )
      ( suppliername = `Ultrasonic United` name = `Gladiator MX` productid = `HT-1071` width = `22` depth = `35` height = `17` dimunit = `cm` weightmeasure = `0.3` weightunit = `KG` price = `81.7` currencycode = `EUR` )
      ( suppliername = `Ultrasonic United` name = `Hurricane GX` productid = `HT-1072` width = `22` depth = `35` height = `17` dimunit = `cm` weightmeasure = `0.4` weightunit = `KG` price = `101.2` currencycode = `EUR` )
      ( suppliername = `Smartcards` name = `Hurricane GX/LN` productid = `HT-1073` width = `22` depth = `35` height = `17` dimunit = `cm` weightmeasure = `0.4` weightunit = `KG` price = `139.99` currencycode = `EUR` )
      ( suppliername = `Printer for All` name = `Photo Scan` productid = `HT-1080` width = `34` depth = `48` height = `5` dimunit = `cm` weightmeasure = `2.3` weightunit = `KG` price = `129` currencycode = `EUR` )
      ( suppliername = `Printer for All` name = `Power Scan` productid = `HT-1081` width = `31` depth = `43` height = `7` dimunit = `cm` weightmeasure = `2.4` weightunit = `KG` price = `89` currencycode = `EUR` )
      ( suppliername = `Printer for All` name = `Jet Scan Professional` productid = `HT-1082` width = `33` depth = `41` height = `12` dimunit = `cm` weightmeasure = `3.2` weightunit = `KG` price = `169` currencycode = `EUR` )
      ( suppliername = `Printer for All` name = `Jet Scan Professional` productid = `HT-1083` width = `35` depth = `40` height = `10` dimunit = `cm` weightmeasure = `3.2` weightunit = `KG` price = `189` currencycode = `EUR` )
      ( suppliername = `Alpha Printers` name = `Copymaster` productid = `HT-1085` width = `45` depth = `42` height = `22` dimunit = `cm` weightmeasure = `23.2` weightunit = `KG` price = `1499` currencycode = `EUR` )
      ( suppliername = `Speaker Experts` name = `Surround Sound` productid = `HT-1090` width = `12` depth = `10` height = `16` dimunit = `cm` weightmeasure = `3` weightunit = `KG` price = `39` currencycode = `EUR` )
      ( suppliername = `Speaker Experts` name = `Blaster Extreme` productid = `HT-1091` width = `13` depth = `11` height = `17.5` dimunit = `cm` weightmeasure = `1.4` weightunit = `KG` price = `26` currencycode = `EUR` )
      ( suppliername = `Speaker Experts` name = `Sound Booster` productid = `HT-1092` width = `12.4` depth = `10.4` height = `18.1` dimunit = `cm` weightmeasure = `2.1` weightunit = `KG` price = `45` currencycode = `EUR` )
      ( suppliername = `Fasttech` name = `Lovely Sound 5.1 Wireless` productid = `HT-1095` width = `24` depth = `19` height = `23` dimunit = `cm` weightmeasure = `80` weightunit = `G` price = `49` currencycode = `EUR` )
      ( suppliername = `Fasttech` name = `Lovely Sound 5.1` productid = `HT-1096` width = `25` depth = `17` height = `19` dimunit = `cm` weightmeasure = `130` weightunit = `G` price = `39` currencycode = `EUR` )
      ( suppliername = `Fasttech` name = `Lovely Sound Stereo` productid = `HT-1097` width = `21.3` depth = `2.4` height = `19.7` dimunit = `cm` weightmeasure = `60` weightunit = `G` price = `29` currencycode = `EUR` )
      ( suppliername = `Technocom` name = `Smart Office` productid = `HT-1100` width = `15` depth = `6.5` height = `2.1` dimunit = `cm` weightmeasure = `1.2` weightunit = `KG` price = `89.9` currencycode = `EUR` )
      ( suppliername = `Technocom` name = `Smart Design` productid = `HT-1101` width = `14` depth = `6.7` height = `24` dimunit = `cm` weightmeasure = `0.8` weightunit = `KG` price = `79.9` currencycode = `EUR` )
      ( suppliername = `Technocom` name = `Smart Network` productid = `HT-1102` width = `16` depth = `6` height = `27` dimunit = `cm` weightmeasure = `0.8` weightunit = `KG` price = `69` currencycode = `EUR` )
      ( suppliername = `Technocom` name = `Smart Multimedia` productid = `HT-1103` width = `11` depth = `3.4` height = `22` dimunit = `cm` weightmeasure = `0.8` weightunit = `KG` price = `77` currencycode = `EUR` )
      ( suppliername = `Technocom` name = `Smart Games` productid = `HT-1104` width = `10` depth = `3` height = `30` dimunit = `cm` weightmeasure = `1.1` weightunit = `KG` price = `55` currencycode = `EUR` )
      ( suppliername = `Brainsoft` name = `Smart Internet Antivirus` productid = `HT-1105` width = `16` depth = `4` height = `21` dimunit = `cm` weightmeasure = `0.7` weightunit = `KG` price = `29` currencycode = `EUR` )
      ( suppliername = `Brainsoft` name = `Smart Firewall` productid = `HT-1106` width = `17.9` depth = `4.2` height = `23.1` dimunit = `cm` weightmeasure = `0.9` weightunit = `KG` price = `34` currencycode = `EUR` )
      ( suppliername = `Brainsoft` name = `Smart Money` productid = `HT-1107` width = `12` depth = `1.5` height = `19` dimunit = `cm` weightmeasure = `0.5` weightunit = `KG` price = `29.9` currencycode = `EUR` )
      ( suppliername = `Red Point Stores` name = `PC Lock` productid = `HT-1110` width = `20` depth = `8` height = `4.3` dimunit = `cm` weightmeasure = `0.03` weightunit = `KG` price = `8.9` currencycode = `EUR` )
      ( suppliername = `Red Point Stores` name = `Notebook Lock` productid = `HT-1111` width = `31` depth = `9` height = `7` dimunit = `cm` weightmeasure = `0.02` weightunit = `KG` price = `6.9` currencycode = `EUR` )
      ( suppliername = `Red Point Stores` name = `Web cam reality` productid = `HT-1112` width = `9` depth = `8.2` height = `1.3` dimunit = `cm` weightmeasure = `0.075` weightunit = `KG` price = `39` currencycode = `EUR` )
      ( suppliername = `Red Point Stores` name = `Screen clean` productid = `HT-1113` width = `2` depth = `2` height = `0.1` dimunit = `cm` weightmeasure = `0.05` weightunit = `KG` price = `2.3` currencycode = `EUR` )
      ( suppliername = `Red Point Stores` name = `Fabric bag professional` productid = `HT-1114` width = `42` depth = `32` height = `7` dimunit = `cm` weightmeasure = `1.8` weightunit = `KG` price = `31` currencycode = `EUR` )
      ( suppliername = `Red Point Stores` name = `Wireless DSL Router` productid = `HT-1115` width = `19.3` depth = `18` height = `5` dimunit = `cm` weightmeasure = `0.45` weightunit = `KG` price = `49` currencycode = `EUR` )
      ( suppliername = `Red Point Stores` name = `Wireless DSL Router / Repeater` productid = `HT-1116` width = `19.3` depth = `18` height = `5` dimunit = `cm` weightmeasure = `0.45` weightunit = `KG` price = `59` currencycode = `EUR` )
      ( suppliername = `Technocom` name = `Wireless DSL Router / Repeater and Print Server` productid = `HT-1117` width = `19.3` depth = `18` height = `5` dimunit = `cm` weightmeasure = `0.45` weightunit = `KG` price = `69` currencycode = `EUR` )
      ( suppliername = `Technocom` name = `USB Stick` productid = `HT-1118` width = `1.5` depth = `8.7` height = `1.2` dimunit = `cm` weightmeasure = `0.015` weightunit = `KG` price = `35` currencycode = `EUR` )
      ( suppliername = `Titanium` name = `Travel Adapter` productid = `HT-1119` width = `2` depth = `3.1` height = `3.9` dimunit = `cm` weightmeasure = `88` weightunit = `G` price = `79` currencycode = `EUR` )
      ( suppliername = `Technocom` name = `Cordless Bluetooth Keyboard, english international` productid = `HT-1120` width = `51.4` depth = `23` height = `4` dimunit = `cm` weightmeasure = `1` weightunit = `KG` price = `29` currencycode = `EUR` )
      ( suppliername = `Technocom` name = `Flat XXL` productid = `HT-1137` width = `54` depth = `22` height = `38` dimunit = `cm` weightmeasure = `18` weightunit = `KG` price = `1430` currencycode = `EUR` )
      ( suppliername = `Technocom` name = `Pocket Mouse` productid = `HT-1138` width = `0.3` depth = `0.5` height = `1` dimunit = `cm` weightmeasure = `0.02` weightunit = `KG` price = `23` currencycode = `EUR` )
      ( suppliername = `Technocom` name = `PC Power Station` productid = `HT-1210` width = `28` depth = `31` height = `43` dimunit = `cm` weightmeasure = `2.3` weightunit = `KG` price = `2399` currencycode = `EUR` )
      ( suppliername = `Ultrasonic United` name = `Astro Laptop 1516` productid = `HT-1251` width = `30` depth = `18` height = `3` dimunit = `cm` weightmeasure = `4.2` weightunit = `KG` price = `989` currencycode = `EUR` )
      ( suppliername = `Ultrasonic United` name = `Astro Phone 6` productid = `HT-1252` width = `8` depth = `6` height = `1.5` dimunit = `cm` weightmeasure = `0.75` weightunit = `KG` price = `649` currencycode = `EUR` )
      ( suppliername = `Ultrasonic United` name = `Benda Laptop 1408` productid = `HT-1253` width = `30` depth = `18` height = `3` dimunit = `cm` weightmeasure = `4.2` weightunit = `KG` price = `976` currencycode = `EUR` )
      ( suppliername = `Ultrasonic United` name = `Bending Screen 21HD` productid = `HT-1254` width = `37` depth = `12` height = `36` dimunit = `cm` weightmeasure = `15` weightunit = `KG` price = `250` currencycode = `EUR` )
      ( suppliername = `Ultrasonic United` name = `Broad Screen 22HD` productid = `HT-1255` width = `39` depth = `12` height = `38` dimunit = `cm` weightmeasure = `16` weightunit = `KG` price = `270` currencycode = `EUR` )
      ( suppliername = `Ultrasonic United` name = `Cerdik Phone 7` productid = `HT-1256` width = `9` depth = `15` height = `1.5` dimunit = `cm` weightmeasure = `0.75` weightunit = `KG` price = `549` currencycode = `EUR` )
      ( suppliername = `Ultrasonic United` name = `Cepat Tablet 10.5` productid = `HT-1257` width = `48` depth = `31` height = `4.5` dimunit = `cm` weightmeasure = `2.8` weightunit = `KG` price = `549` currencycode = `EUR` )
      ( suppliername = `Ultrasonic United` name = `Cepat Tablet 8` productid = `HT-1258` width = `38` depth = `21` height = `3.5` dimunit = `cm` weightmeasure = `2.5` weightunit = `KG` price = `529` currencycode = `EUR` )
      ( suppliername = `Technocom` name = `Server Basic` productid = `HT-1500` width = `34` depth = `35` height = `23` dimunit = `cm` weightmeasure = `18` weightunit = `KG` price = `5000` currencycode = `EUR` )
      ( suppliername = `Technocom` name = `Server Professional` productid = `HT-1501` width = `29` depth = `30` height = `27` dimunit = `cm` weightmeasure = `25` weightunit = `KG` price = `15000` currencycode = `EUR` )
      ( suppliername = `Technocom` name = `Server Power Pro` productid = `HT-1502` width = `22` depth = `27.3` height = `37` dimunit = `cm` weightmeasure = `35` weightunit = `KG` price = `25000` currencycode = `EUR` )
      ( suppliername = `Titanium` name = `Family PC Basic` productid = `HT-1600` width = `21.4` depth = `29` height = `38` dimunit = `cm` weightmeasure = `4.8` weightunit = `KG` price = `600` currencycode = `EUR` )
      ( suppliername = `Titanium` name = `Family PC Pro` productid = `HT-1601` width = `25` depth = `31.7` height = `40.2` dimunit = `cm` weightmeasure = `5.3` weightunit = `KG` price = `900` currencycode = `EUR` )
      ( suppliername = `Titanium` name = `Gaming Monster` productid = `HT-1602` width = `26.5` depth = `34` height = `47` dimunit = `cm` weightmeasure = `5.9` weightunit = `KG` price = `1200` currencycode = `EUR` )
      ( suppliername = `Titanium` name = `Gaming Monster Pro` productid = `HT-1603` width = `27` depth = `28` height = `42` dimunit = `cm` weightmeasure = `6.8` weightunit = `KG` price = `1700` currencycode = `EUR` )
      ( suppliername = `Titanium` name = `7" Widescreen Portable DVD Player w MP3` productid = `HT-2000` width = `21.4` depth = `19` height = `27.6` dimunit = `cm` weightmeasure = `0.79` weightunit = `KG` price = `249.99` currencycode = `EUR` )
      ( suppliername = `Titanium` name = `10" Portable DVD player` productid = `HT-2001` width = `24` depth = `19.5` height = `29` dimunit = `cm` weightmeasure = `0.84` weightunit = `KG` price = `449.99` currencycode = `EUR` )
      ( suppliername = `Technocom` name = `Portable DVD Player with 9" LCD Monitor` productid = `HT-2002` width = `21` depth = `16.5` height = `14` dimunit = `cm` weightmeasure = `0.72` weightunit = `KG` price = `853.99` currencycode = `EUR` )
      ( suppliername = `Titanium` name = `CD/DVD case: 264 sleeves` productid = `HT-2025` width = `13` depth = `13` height = `20` dimunit = `cm` weightmeasure = `0.65` weightunit = `KG` price = `44.99` currencycode = `EUR` )
      ( suppliername = `Titanium` name = `Audio/Video Cable Kit - 4m` productid = `HT-2026` width = `21` depth = `10.2` height = `13` dimunit = `cm` weightmeasure = `0.2` weightunit = `KG` price = `29.99` currencycode = `EUR` )
      ( suppliername = `Titanium` name = `Removable CD/DVD Laser Labels` productid = `HT-2027` width = `5.5` depth = `2` height = `2` dimunit = `cm` weightmeasure = `0.15` weightunit = `KG` price = `8.99` currencycode = `EUR` )
      ( suppliername = `Titanium` name = `Beam Breaker B-1` productid = `HT-6100` width = `30.4` depth = `23.1` height = `23` dimunit = `cm` weightmeasure = `1.7` weightunit = `KG` price = `469` currencycode = `EUR` )
      ( suppliername = `Technocom` name = `Beam Breaker B-2` productid = `HT-6101` width = `30.4` depth = `23.1` height = `23` dimunit = `cm` weightmeasure = `2` weightunit = `KG` price = `679` currencycode = `EUR` )
      ( suppliername = `Technocom` name = `Beam Breaker B-3` productid = `HT-6102` width = `30.4` depth = `23.1` height = `23` dimunit = `cm` weightmeasure = `2.5` weightunit = `KG` price = `889` currencycode = `EUR` )
      ( suppliername = `Fasttech` name = `Play Movie` productid = `HT-6110` width = `37` depth = `24` height = `6` dimunit = `cm` weightmeasure = `2.4` weightunit = `KG` price = `130` currencycode = `EUR` )
      ( suppliername = `Fasttech` name = `Record Movie` productid = `HT-6111` width = `38` depth = `26` height = `6.2` dimunit = `cm` weightmeasure = `3.1` weightunit = `KG` price = `288` currencycode = `EUR` )
      ( suppliername = `Fasttech` name = `ITelo MusicStick` productid = `HT-6120` width = `1.5` depth = `6` height = `1` dimunit = `cm` weightmeasure = `134` weightunit = `G` price = `45` currencycode = `EUR` )
      ( suppliername = `Fasttech` name = `ITelo Jog-Mate` productid = `HT-6121` width = `5.1` depth = `8` height = `9.2` dimunit = `cm` weightmeasure = `134` weightunit = `G` price = `63` currencycode = `EUR` )
      ( suppliername = `Fasttech` name = `Power Pro Player 40` productid = `HT-6122` width = `5.1` depth = `8` height = `9.2` dimunit = `cm` weightmeasure = `266` weightunit = `G` price = `167` currencycode = `EUR` )
      ( suppliername = `Fasttech` name = `Power Pro Player 80` productid = `HT-6123` width = `4` depth = `6` height = `0.8` dimunit = `cm` weightmeasure = `267` weightunit = `G` price = `299` currencycode = `EUR` )
      ( suppliername = `Very Best Screens` name = `Flat Watch HD32` productid = `HT-6130` width = `78` depth = `22.1` height = `55` dimunit = `cm` weightmeasure = `2.6` weightunit = `KG` price = `1459` currencycode = `EUR` )
      ( suppliername = `Very Best Screens` name = `Flat Watch HD37` productid = `HT-6131` width = `99.1` depth = `26` height = `61` dimunit = `cm` weightmeasure = `2.2` weightunit = `KG` price = `1199` currencycode = `EUR` )
      ( suppliername = `Very Best Screens` name = `Flat Watch HD41` productid = `HT-6132` width = `128` depth = `23` height = `79.1` dimunit = `cm` weightmeasure = `1.8` weightunit = `KG` price = `899` currencycode = `EUR` )
      ( suppliername = `Fasttech` name = `Copperberry` productid = `HT-7000` width = `8.1` depth = `13` height = `12.1` dimunit = `cm` weightmeasure = `0.5` weightunit = `KG` price = `549` currencycode = `EUR` )
      ( suppliername = `Fasttech` name = `Silverberry` productid = `HT-7010` width = `8.1` depth = `13` height = `12.1` dimunit = `cm` weightmeasure = `0.5` weightunit = `KG` price = `549` currencycode = `EUR` )
      ( suppliername = `Fasttech` name = `Goldberry` productid = `HT-7020` width = `8.1` depth = `13` height = `12.1` dimunit = `cm` weightmeasure = `0.5` weightunit = `KG` price = `549` currencycode = `EUR` )
      ( suppliername = `Fasttech` name = `Platinberry` productid = `HT-7030` width = `8.1` depth = `13` height = `12.1` dimunit = `cm` weightmeasure = `0.5` weightunit = `KG` price = `549` currencycode = `EUR` )
      ( suppliername = `Titanium` name = `ITelO FlexTop I4000` productid = `HT-8000` width = `31` depth = `19` height = `3.1` dimunit = `cm` weightmeasure = `4` weightunit = `KG` price = `799` currencycode = `EUR` )
      ( suppliername = `Titanium` name = `ITelO FlexTop I6300c` productid = `HT-8001` width = `32` depth = `20` height = `3.4` dimunit = `cm` weightmeasure = `4.2` weightunit = `KG` price = `799` currencycode = `EUR` )
      ( suppliername = `Titanium` name = `ITelO FlexTop I9100` productid = `HT-8002` width = `38` depth = `21` height = `4.1` dimunit = `cm` weightmeasure = `3.5` weightunit = `KG` price = `1199` currencycode = `EUR` )
      ( suppliername = `Titanium` name = `ITelO FlexTop I9800` productid = `HT-8003` width = `48` depth = `31` height = `4.5` dimunit = `cm` weightmeasure = `3.8` weightunit = `KG` price = `1388` currencycode = `EUR` )
      ( suppliername = `Ultrasonic United` name = `Smartphone Leather Case` productid = `HT-9991` width = `48` depth = `31` height = `4.5` dimunit = `cm` weightmeasure = `0.02` weightunit = `KG` price = `25` currencycode = `EUR` )
      ( suppliername = `Ultrasonic United` name = `Smartphone Alpha` productid = `HT-9992` width = `48` depth = `31` height = `4.5` dimunit = `cm` weightmeasure = `0.75` weightunit = `KG` price = `599` currencycode = `EUR` )
      ( suppliername = `Ultrasonic United` name = `Mini Tablet` productid = `HT-9993` width = `48` depth = `31` height = `4.5` dimunit = `cm` weightmeasure = `3.8` weightunit = `KG` price = `833` currencycode = `EUR` )
      ( suppliername = `Ultrasonic United` name = `Camcorder View` productid = `HT-9994` width = `48` depth = `31` height = `27` dimunit = `cm` weightmeasure = `3.8` weightunit = `KG` price = `1388` currencycode = `EUR` )
      ( suppliername = `Titanium` name = `Tablet Pouch` productid = `HT-9995` width = `25` depth = `40` height = `4.5` dimunit = `cm` weightmeasure = `0.03` weightunit = `KG` price = `20` currencycode = `EUR` )
      ( suppliername = `Titanium` name = `Tablet Pouch` productid = `HT-9996` width = `25` depth = `40` height = `4.5` dimunit = `cm` weightmeasure = `0.03` weightunit = `KG` price = `20` currencycode = `EUR` )
      ( suppliername = `Titanium` name = `e-Book Reader ReadMe` productid = `HT-9997` width = `48` depth = `31` height = `4.5` dimunit = `cm` weightmeasure = `3.8` weightunit = `KG` price = `33` currencycode = `EUR` )
      ( suppliername = `Titanium` name = `Smartphone Beta` productid = `HT-9998` width = `48` depth = `31` height = `4.5` dimunit = `cm` weightmeasure = `0.75` weightunit = `KG` price = `30` currencycode = `EUR` )
      ( suppliername = `Titanium` name = `Maxi Tablet` productid = `HT-9999` width = `48` depth = `31` height = `4.5` dimunit = `cm` weightmeasure = `3.8` weightunit = `KG` price = `749` currencycode = `EUR` )
      ( suppliername = `Titanium` name = `Flyer` productid = `PF-1000` width = `46` depth = `30` height = `3` dimunit = `cm` weightmeasure = `0.01` weightunit = `KG` price = `0` currencycode = `EUR` )
    ).

    " weightState is business logic (parseFloat + Success/Warning/Error
    " thresholds) - computed in ABAP per the thin-frontend principle, not in a
    " frontend formatter, then bound state="{WEIGHTSTATE}" (apps 009/010/022/092)
    LOOP AT t_products ASSIGNING FIELD-SYMBOL(<product>).
      DATA(weight) = CONV f( <product>-weightmeasure ).
      <product>-weightstate = COND #( WHEN weight < 0    THEN `None`
                                      WHEN weight < 1000 THEN `Success`
                                      WHEN weight < 2000 THEN `Warning`
                                      ELSE                    `Error` ).
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
