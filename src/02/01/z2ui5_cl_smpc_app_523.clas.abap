" @keywords table sap.m tableselectcopy cellselector overflowtoolbar title toolbarspacer checkbox column text columnlistitem objectidentifier
" @summary This example demonstrates how the Table data can be copied to the clipboard via CopyProvider plugin.
CLASS z2ui5_cl_smpc_app_523 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             name         TYPE string,
             productid    TYPE string,
             suppliername TYPE string,
             quantity     TYPE string,
             uom          TYPE string,
             price        TYPE p LENGTH 8 DECIMALS 2,
             currencycode TYPE string,
           END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

    DATA t_products  TYPE ty_t_product.
    DATA copy_visible TYPE abap_bool VALUE abap_true.
    DATA copy_enabled TYPE abap_bool VALUE abap_true.
    DATA copy_sparse  TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_523 IMPLEMENTATION.

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
        )->a( n = `xmlns`         v = `sap.m`
        )->a( n = `xmlns:core`    v = `sap.ui.core`
        )->a( n = `xmlns:mvc`     v = `sap.ui.core.mvc`
        )->a( n = `xmlns:plugins` v = `sap.m.plugins`
        )->a( n = `xmlns:app`     v = `http://schemas.sap.com/sapui5/extension/sap.ui.core.CustomData/1`

        )->ele( `Table`
            )->a( n = `id`      v = `idProductsTable`
            )->a( n = `growing` v = `true`
            )->a( n = `mode`    v = `MultiSelect`
            )->a( n = `items`   v = |\{ path: '{ client->_bind_path( t_products ) }', sorter: \{ path: 'NAME' \} \}|

            " only the CellSelector - the CopyProvider is dropped, it refuses to be
            " created without the extractData JS callback (see sidecar)
            )->ele( `dependents`
                )->tag( n = `CellSelector` ns = `plugins`
                    )->a( n = `id` v = `cellSelector`

            )->end(

            )->ele( `headerToolbar`
                )->ele( `OverflowToolbar`
                    )->a( n = `id` v = `toolbar`

                    )->tag( `Title`
                        )->a( n = `text`  v = `Products`
                        )->a( n = `level` v = `H2`
                    )->tag( `ToolbarSpacer`
                    )->tag( `CheckBox`
                        )->a( n = `text`     v = `Visible`
                        )->a( n = `selected` v = client->_bind( copy_visible )
                    )->tag( `CheckBox`
                        )->a( n = `text`     v = `Enabled`
                        )->a( n = `selected` v = client->_bind( copy_enabled )
                    )->tag( `CheckBox`
                        )->a( n = `text`     v = `Sparse`
                        )->a( n = `selected` v = client->_bind( copy_sparse )

                )->end(
            )->end(

            )->ele( `columns`
                )->ele( `Column`
                    )->a( n = `width`         v = `16em`
                    )->a( n = `app:bindings`  v = `ProductId,Name`
                    )->a( n = `app:template`  v = `\{1\}\n\{0\}`

                    )->tag( `Text`
                        )->a( n = `text` v = `Product`

                )->end(

                )->ele( `Column`
                    )->a( n = `minScreenWidth` v = `Desktop`
                    )->a( n = `demandPopin`    v = `true`
                    )->a( n = `app:bindings`   v = `SupplierName`

                    )->tag( `Text`
                        )->a( n = `text` v = `Supplier`

                )->end(

                )->ele( `Column`
                    )->a( n = `minScreenWidth` v = `Desktop`
                    )->a( n = `demandPopin`    v = `true`
                    )->a( n = `hAlign`         v = `End`
                    )->a( n = `app:bindings`   v = `Quantity,UoM`
                    )->a( n = `app:template`   v = `\{0\} \{1\}`

                    )->tag( `Text`
                        )->a( n = `text` v = `Quantity`

                )->end(

                )->ele( `Column`
                    )->a( n = `width`        v = `10em`
                    )->a( n = `hAlign`       v = `End`
                    )->a( n = `app:bindings` v = `Price,CurrencyCode`
                    )->a( n = `app:template` v = `\{0\} \{1\}`

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
                            )->a( n = `text`  v = `{PRODUCTID}`
                        )->tag( `Text`
                            )->a( n = `text` v = `{SUPPLIERNAME}`
                        )->tag( `Text`
                            )->a( n = `text` v = `{QUANTITY} {UOM}`
                        )->tag( `ObjectNumber`
                            )->a( n = `number` v = |\{ parts: [\{path: 'PRICE'\}, \{path: 'CURRENCYCODE'\}], type: 'sap.ui.model.type.Currency', formatOptions: \{showMeasure: false\} \}|
                            )->a( n = `unit`   v = `{CURRENCYCODE}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " full mock /ProductCollection of ui5/mock/products.json (the bound fields)
    t_products = VALUE #(
        ( name = `Notebook Basic 15`                                  productid = `HT-1000` suppliername = `Very Best Screens` quantity = `10` uom = `PC` price = `956`    currencycode = `EUR` )
        ( name = `Notebook Basic 17`                                  productid = `HT-1001` suppliername = `Very Best Screens` quantity = `20` uom = `PC` price = `1249`   currencycode = `EUR` )
        ( name = `Notebook Basic 18`                                  productid = `HT-1002` suppliername = `Very Best Screens` quantity = `10` uom = `PC` price = `1570`   currencycode = `EUR` )
        ( name = `Notebook Basic 19`                                  productid = `HT-1003` suppliername = `Smartcards`        quantity = `15` uom = `PC` price = `1650`   currencycode = `EUR` )
        ( name = `ITelO Vault`                                        productid = `HT-1007` suppliername = `Technocom`         quantity = `15` uom = `PC` price = `299`    currencycode = `EUR` )
        ( name = `Notebook Professional 15`                           productid = `HT-1010` suppliername = `Very Best Screens` quantity = `16` uom = `PC` price = `1999`   currencycode = `EUR` )
        ( name = `Notebook Professional 17`                           productid = `HT-1011` suppliername = `Very Best Screens` quantity = `17` uom = `PC` price = `2299`   currencycode = `EUR` )
        ( name = `ITelO Vault Net`                                    productid = `HT-1020` suppliername = `Technocom`         quantity = `14` uom = `PC` price = `459`    currencycode = `EUR` )
        ( name = `ITelO Vault SAT`                                    productid = `HT-1021` suppliername = `Technocom`         quantity = `50` uom = `PC` price = `149`    currencycode = `EUR` )
        ( name = `Comfort Easy`                                       productid = `HT-1022` suppliername = `Technocom`         quantity = `30` uom = `PC` price = `1679`   currencycode = `EUR` )
        ( name = `Comfort Senior`                                     productid = `HT-1023` suppliername = `Technocom`         quantity = `24` uom = `PC` price = `512`    currencycode = `EUR` )
        ( name = `Ergo Screen E-I`                                    productid = `HT-1030` suppliername = `Very Best Screens` quantity = `14` uom = `PC` price = `230`    currencycode = `EUR` )
        ( name = `Ergo Screen E-II`                                   productid = `HT-1031` suppliername = `Very Best Screens` quantity = `24` uom = `PC` price = `285`    currencycode = `EUR` )
        ( name = `Ergo Screen E-III`                                  productid = `HT-1032` suppliername = `Very Best Screens` quantity = `50` uom = `PC` price = `345`    currencycode = `EUR` )
        ( name = `Flat Basic`                                         productid = `HT-1035` suppliername = `Very Best Screens` quantity = `23` uom = `PC` price = `399`    currencycode = `EUR` )
        ( name = `Flat Future`                                        productid = `HT-1036` suppliername = `Very Best Screens` quantity = `22` uom = `PC` price = `430`    currencycode = `EUR` )
        ( name = `Flat XL`                                            productid = `HT-1037` suppliername = `Very Best Screens` quantity = `23` uom = `PC` price = `1230`   currencycode = `EUR` )
        ( name = `Laser Professional Eco`                             productid = `HT-1040` suppliername = `Alpha Printers`    quantity = `21` uom = `PC` price = `830`    currencycode = `EUR` )
        ( name = `Laser Basic`                                        productid = `HT-1041` suppliername = `Alpha Printers`    quantity = `8`  uom = `PC` price = `490`    currencycode = `EUR` )
        ( name = `Laser Allround`                                     productid = `HT-1042` suppliername = `Alpha Printers`    quantity = `9`  uom = `PC` price = `349`    currencycode = `EUR` )
        ( name = `Ultra Jet Super Color`                              productid = `HT-1050` suppliername = `Alpha Printers`    quantity = `17` uom = `PC` price = `139`    currencycode = `EUR` )
        ( name = `Ultra Jet Mobile`                                   productid = `HT-1051` suppliername = `Printer for All`   quantity = `18` uom = `PC` price = `99`     currencycode = `EUR` )
        ( name = `Ultra Jet Super Highspeed`                          productid = `HT-1052` suppliername = `Printer for All`   quantity = `25` uom = `PC` price = `170`    currencycode = `EUR` )
        ( name = `Multi Print`                                        productid = `HT-1055` suppliername = `Printer for All`   quantity = `16` uom = `PC` price = `99`     currencycode = `EUR` )
        ( name = `Multi Color`                                        productid = `HT-1056` suppliername = `Printer for All`   quantity = `5`  uom = `PC` price = `119`    currencycode = `EUR` )
        ( name = `Cordless Mouse`                                     productid = `HT-1060` suppliername = `Oxynum`            quantity = `25` uom = `PC` price = `9`      currencycode = `EUR` )
        ( name = `Speed Mouse`                                        productid = `HT-1061` suppliername = `Oxynum`            quantity = `12` uom = `PC` price = `7`      currencycode = `EUR` )
        ( name = `Track Mouse`                                        productid = `HT-1062` suppliername = `Oxynum`            quantity = `12` uom = `PC` price = `11`     currencycode = `EUR` )
        ( name = `Ergonomic Keyboard`                                 productid = `HT-1063` suppliername = `Oxynum`            quantity = `50` uom = `PC` price = `14`     currencycode = `EUR` )
        ( name = `Internet Keyboard`                                  productid = `HT-1064` suppliername = `Oxynum`            quantity = `35` uom = `PC` price = `16`     currencycode = `EUR` )
        ( name = `Media Keyboard`                                     productid = `HT-1065` suppliername = `Oxynum`            quantity = `26` uom = `PC` price = `26`     currencycode = `EUR` )
        ( name = `Mousepad`                                           productid = `HT-1066` suppliername = `Oxynum`            quantity = `12` uom = `PC` price = `6.99`   currencycode = `EUR` )
        ( name = `Ergo Mousepad`                                      productid = `HT-1067` suppliername = `Oxynum`            quantity = `16` uom = `PC` price = `8.99`   currencycode = `EUR` )
        ( name = `Designer Mousepad`                                  productid = `HT-1068` suppliername = `Fasttech`          quantity = `26` uom = `PC` price = `12.99`  currencycode = `EUR` )
        ( name = `Universal card reader`                              productid = `HT-1069` suppliername = `Fasttech`          quantity = `22` uom = `PC` price = `14`     currencycode = `EUR` )
        ( name = `Proctra X`                                          productid = `HT-1070` suppliername = `Ultrasonic United` quantity = `15` uom = `PC` price = `70.9`   currencycode = `EUR` )
        ( name = `Gladiator MX`                                       productid = `HT-1071` suppliername = `Ultrasonic United` quantity = `16` uom = `PC` price = `81.7`   currencycode = `EUR` )
        ( name = `Hurricane GX`                                       productid = `HT-1072` suppliername = `Ultrasonic United` quantity = `13` uom = `PC` price = `101.2`  currencycode = `EUR` )
        ( name = `Hurricane GX/LN`                                    productid = `HT-1073` suppliername = `Smartcards`        quantity = `5`  uom = `PC` price = `139.99` currencycode = `EUR` )
        ( name = `Photo Scan`                                         productid = `HT-1080` suppliername = `Printer for All`   quantity = `8`  uom = `PC` price = `129`    currencycode = `EUR` )
        ( name = `Power Scan`                                         productid = `HT-1081` suppliername = `Printer for All`   quantity = `11` uom = `PC` price = `89`     currencycode = `EUR` )
        ( name = `Jet Scan Professional`                              productid = `HT-1082` suppliername = `Printer for All`   quantity = `13` uom = `PC` price = `169`    currencycode = `EUR` )
        ( name = `Jet Scan Professional`                              productid = `HT-1083` suppliername = `Printer for All`   quantity = `10` uom = `PC` price = `189`    currencycode = `EUR` )
        ( name = `Copymaster`                                         productid = `HT-1085` suppliername = `Alpha Printers`    quantity = `10` uom = `PC` price = `1499`   currencycode = `EUR` )
        ( name = `Surround Sound`                                     productid = `HT-1090` suppliername = `Speaker Experts`   quantity = `20` uom = `PC` price = `39`     currencycode = `EUR` )
        ( name = `Blaster Extreme`                                    productid = `HT-1091` suppliername = `Speaker Experts`   quantity = `15` uom = `PC` price = `26`     currencycode = `EUR` )
        ( name = `Sound Booster`                                      productid = `HT-1092` suppliername = `Speaker Experts`   quantity = `50` uom = `PC` price = `45`     currencycode = `EUR` )
        ( name = `Lovely Sound 5.1 Wireless`                          productid = `HT-1095` suppliername = `Fasttech`          quantity = `12` uom = `PC` price = `49`     currencycode = `EUR` )
        ( name = `Lovely Sound 5.1`                                   productid = `HT-1096` suppliername = `Fasttech`          quantity = `18` uom = `PC` price = `39`     currencycode = `EUR` )
        ( name = `Lovely Sound Stereo`                                productid = `HT-1097` suppliername = `Fasttech`          quantity = `21` uom = `PC` price = `29`     currencycode = `EUR` )
        ( name = `Smart Office`                                       productid = `HT-1100` suppliername = `Technocom`         quantity = `25` uom = `PC` price = `89.9`   currencycode = `EUR` )
        ( name = `Smart Design`                                       productid = `HT-1101` suppliername = `Technocom`         quantity = `26` uom = `PC` price = `79.9`   currencycode = `EUR` )
        ( name = `Smart Network`                                      productid = `HT-1102` suppliername = `Technocom`         quantity = `28` uom = `PC` price = `69`     currencycode = `EUR` )
        ( name = `Smart Multimedia`                                   productid = `HT-1103` suppliername = `Technocom`         quantity = `9`  uom = `PC` price = `77`     currencycode = `EUR` )
        ( name = `Smart Games`                                        productid = `HT-1104` suppliername = `Technocom`         quantity = `13` uom = `PC` price = `55`     currencycode = `EUR` )
        ( name = `Smart Internet Antivirus`                           productid = `HT-1105` suppliername = `Brainsoft`         quantity = `17` uom = `PC` price = `29`     currencycode = `EUR` )
        ( name = `Smart Firewall`                                     productid = `HT-1106` suppliername = `Brainsoft`         quantity = `19` uom = `PC` price = `34`     currencycode = `EUR` )
        ( name = `Smart Money`                                        productid = `HT-1107` suppliername = `Brainsoft`         quantity = `18` uom = `PC` price = `29.9`   currencycode = `EUR` )
        ( name = `PC Lock`                                            productid = `HT-1110` suppliername = `Red Point Stores`  quantity = `14` uom = `PC` price = `8.9`    currencycode = `EUR` )
        ( name = `Notebook Lock`                                      productid = `HT-1111` suppliername = `Red Point Stores`  quantity = `20` uom = `PC` price = `6.9`    currencycode = `EUR` )
        ( name = `Web cam reality`                                    productid = `HT-1112` suppliername = `Red Point Stores`  quantity = `27` uom = `PC` price = `39`     currencycode = `EUR` )
        ( name = `Screen clean`                                       productid = `HT-1113` suppliername = `Red Point Stores`  quantity = `17` uom = `PC` price = `2.3`    currencycode = `EUR` )
        ( name = `Fabric bag professional`                            productid = `HT-1114` suppliername = `Red Point Stores`  quantity = `14` uom = `PC` price = `31`     currencycode = `EUR` )
        ( name = `Wireless DSL Router`                                productid = `HT-1115` suppliername = `Red Point Stores`  quantity = `16` uom = `PC` price = `49`     currencycode = `EUR` )
        ( name = `Wireless DSL Router / Repeater`                     productid = `HT-1116` suppliername = `Red Point Stores`  quantity = `12` uom = `PC` price = `59`     currencycode = `EUR` )
        ( name = `Wireless DSL Router / Repeater and Print Server`    productid = `HT-1117` suppliername = `Technocom`         quantity = `12` uom = `PC` price = `69`     currencycode = `EUR` )
        ( name = `USB Stick`                                          productid = `HT-1118` suppliername = `Technocom`         quantity = `14` uom = `PC` price = `35`     currencycode = `EUR` )
        ( name = `Travel Adapter`                                     productid = `HT-1119` suppliername = `Titanium`          quantity = `10` uom = `PC` price = `79`     currencycode = `EUR` )
        ( name = `Cordless Bluetooth Keyboard, english international` productid = `HT-1120` suppliername = `Technocom`         quantity = `13` uom = `PC` price = `29`     currencycode = `EUR` )
        ( name = `Flat XXL`                                           productid = `HT-1137` suppliername = `Technocom`         quantity = `10` uom = `PC` price = `1430`   currencycode = `EUR` )
        ( name = `Pocket Mouse`                                       productid = `HT-1138` suppliername = `Technocom`         quantity = `20` uom = `PC` price = `23`     currencycode = `EUR` )
        ( name = `PC Power Station`                                   productid = `HT-1210` suppliername = `Technocom`         quantity = `22` uom = `PC` price = `2399`   currencycode = `EUR` )
        ( name = `Astro Laptop 1516`                                  productid = `HT-1251` suppliername = `Ultrasonic United` quantity = `23` uom = `PC` price = `989`    currencycode = `EUR` )
        ( name = `Astro Phone 6`                                      productid = `HT-1252` suppliername = `Ultrasonic United` quantity = `28` uom = `PC` price = `649`    currencycode = `EUR` )
        ( name = `Benda Laptop 1408`                                  productid = `HT-1253` suppliername = `Ultrasonic United` quantity = `27` uom = `PC` price = `976`    currencycode = `EUR` )
        ( name = `Bending Screen 21HD`                                productid = `HT-1254` suppliername = `Ultrasonic United` quantity = `23` uom = `PC` price = `250`    currencycode = `EUR` )
        ( name = `Broad Screen 22HD`                                  productid = `HT-1255` suppliername = `Ultrasonic United` quantity = `5`  uom = `PC` price = `270`    currencycode = `EUR` )
        ( name = `Cerdik Phone 7`                                     productid = `HT-1256` suppliername = `Ultrasonic United` quantity = `19` uom = `PC` price = `549`    currencycode = `EUR` )
        ( name = `Cepat Tablet 10.5`                                  productid = `HT-1257` suppliername = `Ultrasonic United` quantity = `17` uom = `PC` price = `549`    currencycode = `EUR` )
        ( name = `Cepat Tablet 8`                                     productid = `HT-1258` suppliername = `Ultrasonic United` quantity = `24` uom = `PC` price = `529`    currencycode = `EUR` )
        ( name = `Server Basic`                                       productid = `HT-1500` suppliername = `Technocom`         quantity = `24` uom = `PC` price = `5000`   currencycode = `EUR` )
        ( name = `Server Professional`                                productid = `HT-1501` suppliername = `Technocom`         quantity = `26` uom = `PC` price = `15000`  currencycode = `EUR` )
        ( name = `Server Power Pro`                                   productid = `HT-1502` suppliername = `Technocom`         quantity = `34` uom = `PC` price = `25000`  currencycode = `EUR` )
        ( name = `Family PC Basic`                                    productid = `HT-1600` suppliername = `Titanium`          quantity = `10` uom = `PC` price = `600`    currencycode = `EUR` )
        ( name = `Family PC Pro`                                      productid = `HT-1601` suppliername = `Titanium`          quantity = `20` uom = `PC` price = `900`    currencycode = `EUR` )
        ( name = `Gaming Monster`                                     productid = `HT-1602` suppliername = `Titanium`          quantity = `24` uom = `PC` price = `1200`   currencycode = `EUR` )
        ( name = `Gaming Monster Pro`                                 productid = `HT-1603` suppliername = `Titanium`          quantity = `25` uom = `PC` price = `1700`   currencycode = `EUR` )
        ( name = `7" Widescreen Portable DVD Player w MP3`            productid = `HT-2000` suppliername = `Titanium`          quantity = `20` uom = `PC` price = `249.99` currencycode = `EUR` )
        ( name = `10" Portable DVD player`                            productid = `HT-2001` suppliername = `Titanium`          quantity = `21` uom = `PC` price = `449.99` currencycode = `EUR` )
        ( name = `Portable DVD Player with 9" LCD Monitor`            productid = `HT-2002` suppliername = `Technocom`         quantity = `50` uom = `PC` price = `853.99` currencycode = `EUR` )
        ( name = `CD/DVD case: 264 sleeves`                           productid = `HT-2025` suppliername = `Titanium`          quantity = `26` uom = `PC` price = `44.99`  currencycode = `EUR` )
        ( name = `Audio/Video Cable Kit - 4m`                         productid = `HT-2026` suppliername = `Titanium`          quantity = `16` uom = `PC` price = `29.99`  currencycode = `EUR` )
        ( name = `Removable CD/DVD Laser Labels`                      productid = `HT-2027` suppliername = `Titanium`          quantity = `25` uom = `PC` price = `8.99`   currencycode = `EUR` )
        ( name = `Beam Breaker B-1`                                   productid = `HT-6100` suppliername = `Titanium`          quantity = `32` uom = `PC` price = `469`    currencycode = `EUR` )
        ( name = `Beam Breaker B-2`                                   productid = `HT-6101` suppliername = `Technocom`         quantity = `18` uom = `PC` price = `679`    currencycode = `EUR` )
        ( name = `Beam Breaker B-3`                                   productid = `HT-6102` suppliername = `Technocom`         quantity = `16` uom = `PC` price = `889`    currencycode = `EUR` )
        ( name = `Play Movie`                                         productid = `HT-6110` suppliername = `Fasttech`          quantity = `15` uom = `PC` price = `130`    currencycode = `EUR` )
        ( name = `Record Movie`                                       productid = `HT-6111` suppliername = `Fasttech`          quantity = `24` uom = `PC` price = `288`    currencycode = `EUR` )
        ( name = `ITelo MusicStick`                                   productid = `HT-6120` suppliername = `Fasttech`          quantity = `15` uom = `PC` price = `45`     currencycode = `EUR` )
        ( name = `ITelo Jog-Mate`                                     productid = `HT-6121` suppliername = `Fasttech`          quantity = `24` uom = `PC` price = `63`     currencycode = `EUR` )
        ( name = `Power Pro Player 40`                                productid = `HT-6122` suppliername = `Fasttech`          quantity = `23` uom = `PC` price = `167`    currencycode = `EUR` )
        ( name = `Power Pro Player 80`                                productid = `HT-6123` suppliername = `Fasttech`          quantity = `13` uom = `PC` price = `299`    currencycode = `EUR` )
        ( name = `Flat Watch HD32`                                    productid = `HT-6130` suppliername = `Very Best Screens` quantity = `16` uom = `PC` price = `1459`   currencycode = `EUR` )
        ( name = `Flat Watch HD37`                                    productid = `HT-6131` suppliername = `Very Best Screens` quantity = `14` uom = `PC` price = `1199`   currencycode = `EUR` )
        ( name = `Flat Watch HD41`                                    productid = `HT-6132` suppliername = `Very Best Screens` quantity = `13` uom = `PC` price = `899`    currencycode = `EUR` )
        ( name = `Copperberry`                                        productid = `HT-7000` suppliername = `Fasttech`          quantity = `5`  uom = `PC` price = `549`    currencycode = `EUR` )
        ( name = `Silverberry`                                        productid = `HT-7010` suppliername = `Fasttech`          quantity = `9`  uom = `PC` price = `549`    currencycode = `EUR` )
        ( name = `Goldberry`                                          productid = `HT-7020` suppliername = `Fasttech`          quantity = `11` uom = `PC` price = `549`    currencycode = `EUR` )
        ( name = `Platinberry`                                        productid = `HT-7030` suppliername = `Fasttech`          quantity = `12` uom = `PC` price = `549`    currencycode = `EUR` )
        ( name = `ITelO FlexTop I4000`                                productid = `HT-8000` suppliername = `Titanium`          quantity = `11` uom = `PC` price = `799`    currencycode = `EUR` )
        ( name = `ITelO FlexTop I6300c`                               productid = `HT-8001` suppliername = `Titanium`          quantity = `20` uom = `PC` price = `799`    currencycode = `EUR` )
        ( name = `ITelO FlexTop I9100`                                productid = `HT-8002` suppliername = `Titanium`          quantity = `20` uom = `PC` price = `1199`   currencycode = `EUR` )
        ( name = `ITelO FlexTop I9800`                                productid = `HT-8003` suppliername = `Titanium`          quantity = `22` uom = `PC` price = `1388`   currencycode = `EUR` )
        ( name = `Smartphone Leather Case`                            productid = `HT-9991` suppliername = `Ultrasonic United` quantity = `12` uom = `PC` price = `25`     currencycode = `EUR` )
        ( name = `Smartphone Alpha`                                   productid = `HT-9992` suppliername = `Ultrasonic United` quantity = `13` uom = `PC` price = `599`    currencycode = `EUR` )
        ( name = `Mini Tablet`                                        productid = `HT-9993` suppliername = `Ultrasonic United` quantity = `10` uom = `PC` price = `833`    currencycode = `EUR` )
        ( name = `Camcorder View`                                     productid = `HT-9994` suppliername = `Ultrasonic United` quantity = `50` uom = `PC` price = `1388`   currencycode = `EUR` )
        ( name = `Tablet Pouch`                                       productid = `HT-9995` suppliername = `Titanium`          quantity = `34` uom = `PC` price = `20`     currencycode = `EUR` )
        ( name = `Tablet Pouch`                                       productid = `HT-9996` suppliername = `Titanium`          quantity = `34` uom = `PC` price = `20`     currencycode = `EUR` )
        ( name = `e-Book Reader ReadMe`                               productid = `HT-9997` suppliername = `Titanium`          quantity = `23` uom = `PC` price = `33`     currencycode = `EUR` )
        ( name = `Smartphone Beta`                                    productid = `HT-9998` suppliername = `Titanium`          quantity = `21` uom = `PC` price = `30`     currencycode = `EUR` )
        ( name = `Maxi Tablet`                                        productid = `HT-9999` suppliername = `Titanium`          quantity = `20` uom = `PC` price = `749`    currencycode = `EUR` )
        ( name = `Flyer`                                              productid = `PF-1000` suppliername = `Titanium`          quantity = `33` uom = `PC` price = `0`      currencycode = `EUR` ) ).

  ENDMETHOD.

ENDCLASS.
