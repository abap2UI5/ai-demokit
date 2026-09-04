" @keywords multiinput multi input sap.m multiinputgrouping verticallayout item column label columnlistitem multiinputext
" @summary Items in the MultiInput could be grouped by a property
CLASS z2ui5_cl_smpc_app_613 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             name         TYPE string,
             productid    TYPE string,
             suppliername TYPE string,
             price        TYPE string,
             currencycode TYPE string,
           END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

    DATA t_products TYPE ty_t_product.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_613 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA layout TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    layout = view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:z2ui5` v = `z2ui5.cc`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%` ).

    " both MultiInputs group their suggestions by SupplierName, descending -
    " the grouping sorter of the original binding-info rides along verbatim,
    " UI5 builds the group headers from it on the client
    layout->tag( `Label`
        )->a( n = `text`     v = `Multi Input with grouped suggestions`
        )->a( n = `labelFor` v = `productMIWithList`

        )->ele( `MultiInput`
            )->a( n = `id`              v = `productMIWithList`
            )->a( n = `type`            v = `Text`
            )->a( n = `placeholder`     v = `Enter Product ...`
            )->a( n = `showSuggestion`  v = `true`
            )->a( n = `showValueHelp`   v = `false`
            )->a( n = `suggestionItems` v = |\{ path: '{ client->_bind_path( t_products ) }', sorter: \{ path: 'SUPPLIERNAME', group: true, ascending: false \} \}|

            )->ele( `suggestionItems`
                )->tag( n = `Item` ns = `core`
                    )->a( n = `text` v = `{NAME}`
                    )->a( n = `key`  v = `{PRODUCTID}`

            )->end(
        )->end( ).

    " the tabular one carries the controller's addValidator( ): the picked row
    " becomes a Token with key = the Name cell and text = 'key(price cell)'.
    " The z2ui5.cc.MultiInputExt companion below installs exactly that
    " validator, so the token is built on the client with no round trip
    layout->tag( `Label`
        )->a( n = `text`     v = `Multi Input with grouped tabular suggestions`
        )->a( n = `labelFor` v = `productMIWithTable`

        )->ele( `MultiInput`
            )->a( n = `id`                           v = `productMIWithTable`
            )->a( n = `type`                         v = `Text`
            )->a( n = `placeholder`                  v = `Enter Product ...`
            )->a( n = `showSuggestion`               v = `true`
            )->a( n = `showValueHelp`                v = `false`
            )->a( n = `showTableSuggestionValueHelp` v = `false`
            )->a( n = `suggestionRows`               v = |\{ path: '{ client->_bind_path( t_products ) }', sorter: \{ path: 'SUPPLIERNAME', group: true, ascending: false \} \}|

            )->ele( `suggestionColumns`
                )->ele( `Column`
                    )->a( n = `hAlign`       v = `Begin`
                    )->a( n = `popinDisplay` v = `Inline`
                    )->a( n = `demandPopin`  v = `true`
                    )->tag( `Label`
                        )->a( n = `text` v = `Name`

                )->end(
                )->ele( `Column`
                    )->a( n = `hAlign`         v = `Center`
                    )->a( n = `popinDisplay`   v = `Inline`
                    )->a( n = `demandPopin`    v = `true`
                    )->a( n = `minScreenWidth` v = `Tablet`
                    )->tag( `Label`
                        )->a( n = `text` v = `Product ID`

                )->end(
                )->ele( `Column`
                    )->a( n = `hAlign`         v = `Center`
                    )->a( n = `popinDisplay`   v = `Inline`
                    )->a( n = `demandPopin`    v = `false`
                    )->a( n = `minScreenWidth` v = `Tablet`
                    )->tag( `Label`
                        )->a( n = `text` v = `Supplier Name`

                )->end(
                )->ele( `Column`
                    )->a( n = `hAlign`       v = `End`
                    )->a( n = `popinDisplay` v = `Inline`
                    )->a( n = `demandPopin`  v = `true`
                    )->tag( `Label`
                        )->a( n = `text` v = `Price`

                )->end(
            )->end(

            )->ele( `suggestionRows`
                )->ele( `ColumnListItem`
                    )->tag( `Label`
                        )->a( n = `text` v = `{NAME}`
                    )->tag( `Label`
                        )->a( n = `text` v = `{PRODUCTID}`
                    )->tag( `Label`
                        )->a( n = `text` v = `{SUPPLIERNAME}`
                    )->tag( `Label`
                        )->a( n = `text` v = |\{ parts:[\{path:'PRICE'\},\{path:'CURRENCYCODE'\}],| &&
                                                 | type: 'sap.ui.model.type.Currency', formatOptions: \{showMeasure: true\} \}|

                )->end(
            )->end(
        )->end(

        " the controller's addValidator( ), installed by the invisible
        " z2ui5.cc.MultiInputExt companion: a picked row becomes a Token whose
        " key is cell 0 (Name) and whose text is rendered key(cell 3) - the
        " Name(Price CurrencyCode) shape the original builds in JavaScript
        )->tag( n = `MultiInputExt` ns = `z2ui5`
            )->a( n = `MultiInputId`   v = `productMIWithTable`
            )->a( n = `TokenKeyCell`   v = `0`
            )->a( n = `TokenTextCells` v = `3` ).

    client->view_display( view->stringify( ) ).

    " onInit: oModel.setSizeLimit(1000000) - "the default limit of the model is set
    " to 100. We want to show all the entries." A size limit caps a BOUND
    " aggregation, not the transport, so shipping all 123 rows with the view does
    " not make it moot: both suggestion aggregations stop at 100 without this
    
    CLEAR temp1.
    INSERT `1000000` INTO TABLE temp1.
    INSERT client->cs_view-main INTO TABLE temp1.
    client->follow_up_action( val   = client->cs_event-set_size_limit
                              t_arg = temp1 ).

  ENDMETHOD.


  METHOD model_init.

    " sap/ui/demo/mock/products.json /ProductCollection - the suggestion items
    " and the suggestion rows of both MultiInputs. The controller raises the
    " model's size limit to 1000000 so that all of them stay visible
    DATA temp3 TYPE z2ui5_cl_smpc_app_613=>ty_t_product.
    DATA temp4 LIKE LINE OF temp3.
    CLEAR temp3.
    
    temp4-name = `Notebook Basic 15`.
    temp4-productid = `HT-1000`.
    temp4-suppliername = `Very Best Screens`.
    temp4-price = `956`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Basic 17`.
    temp4-productid = `HT-1001`.
    temp4-suppliername = `Very Best Screens`.
    temp4-price = `1249`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Basic 18`.
    temp4-productid = `HT-1002`.
    temp4-suppliername = `Very Best Screens`.
    temp4-price = `1570`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Basic 19`.
    temp4-productid = `HT-1003`.
    temp4-suppliername = `Smartcards`.
    temp4-price = `1650`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO Vault`.
    temp4-productid = `HT-1007`.
    temp4-suppliername = `Technocom`.
    temp4-price = `299`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Professional 15`.
    temp4-productid = `HT-1010`.
    temp4-suppliername = `Very Best Screens`.
    temp4-price = `1999`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Professional 17`.
    temp4-productid = `HT-1011`.
    temp4-suppliername = `Very Best Screens`.
    temp4-price = `2299`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO Vault Net`.
    temp4-productid = `HT-1020`.
    temp4-suppliername = `Technocom`.
    temp4-price = `459`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO Vault SAT`.
    temp4-productid = `HT-1021`.
    temp4-suppliername = `Technocom`.
    temp4-price = `149`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Comfort Easy`.
    temp4-productid = `HT-1022`.
    temp4-suppliername = `Technocom`.
    temp4-price = `1679`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Comfort Senior`.
    temp4-productid = `HT-1023`.
    temp4-suppliername = `Technocom`.
    temp4-price = `512`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergo Screen E-I`.
    temp4-productid = `HT-1030`.
    temp4-suppliername = `Very Best Screens`.
    temp4-price = `230`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergo Screen E-II`.
    temp4-productid = `HT-1031`.
    temp4-suppliername = `Very Best Screens`.
    temp4-price = `285`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergo Screen E-III`.
    temp4-productid = `HT-1032`.
    temp4-suppliername = `Very Best Screens`.
    temp4-price = `345`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Basic`.
    temp4-productid = `HT-1035`.
    temp4-suppliername = `Very Best Screens`.
    temp4-price = `399`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Future`.
    temp4-productid = `HT-1036`.
    temp4-suppliername = `Very Best Screens`.
    temp4-price = `430`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat XL`.
    temp4-productid = `HT-1037`.
    temp4-suppliername = `Very Best Screens`.
    temp4-price = `1230`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Laser Professional Eco`.
    temp4-productid = `HT-1040`.
    temp4-suppliername = `Alpha Printers`.
    temp4-price = `830`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Laser Basic`.
    temp4-productid = `HT-1041`.
    temp4-suppliername = `Alpha Printers`.
    temp4-price = `490`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Laser Allround`.
    temp4-productid = `HT-1042`.
    temp4-suppliername = `Alpha Printers`.
    temp4-price = `349`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ultra Jet Super Color`.
    temp4-productid = `HT-1050`.
    temp4-suppliername = `Alpha Printers`.
    temp4-price = `139`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ultra Jet Mobile`.
    temp4-productid = `HT-1051`.
    temp4-suppliername = `Printer for All`.
    temp4-price = `99`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ultra Jet Super Highspeed`.
    temp4-productid = `HT-1052`.
    temp4-suppliername = `Printer for All`.
    temp4-price = `170`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Multi Print`.
    temp4-productid = `HT-1055`.
    temp4-suppliername = `Printer for All`.
    temp4-price = `99`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Multi Color`.
    temp4-productid = `HT-1056`.
    temp4-suppliername = `Printer for All`.
    temp4-price = `119`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cordless Mouse`.
    temp4-productid = `HT-1060`.
    temp4-suppliername = `Oxynum`.
    temp4-price = `9`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Speed Mouse`.
    temp4-productid = `HT-1061`.
    temp4-suppliername = `Oxynum`.
    temp4-price = `7`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Track Mouse`.
    temp4-productid = `HT-1062`.
    temp4-suppliername = `Oxynum`.
    temp4-price = `11`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergonomic Keyboard`.
    temp4-productid = `HT-1063`.
    temp4-suppliername = `Oxynum`.
    temp4-price = `14`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Internet Keyboard`.
    temp4-productid = `HT-1064`.
    temp4-suppliername = `Oxynum`.
    temp4-price = `16`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Media Keyboard`.
    temp4-productid = `HT-1065`.
    temp4-suppliername = `Oxynum`.
    temp4-price = `26`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Mousepad`.
    temp4-productid = `HT-1066`.
    temp4-suppliername = `Oxynum`.
    temp4-price = `6.99`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergo Mousepad`.
    temp4-productid = `HT-1067`.
    temp4-suppliername = `Oxynum`.
    temp4-price = `8.99`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Designer Mousepad`.
    temp4-productid = `HT-1068`.
    temp4-suppliername = `Fasttech`.
    temp4-price = `12.99`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Universal card reader`.
    temp4-productid = `HT-1069`.
    temp4-suppliername = `Fasttech`.
    temp4-price = `14`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Proctra X`.
    temp4-productid = `HT-1070`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-price = `70.9`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Gladiator MX`.
    temp4-productid = `HT-1071`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-price = `81.7`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Hurricane GX`.
    temp4-productid = `HT-1072`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-price = `101.2`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Hurricane GX/LN`.
    temp4-productid = `HT-1073`.
    temp4-suppliername = `Smartcards`.
    temp4-price = `139.99`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Photo Scan`.
    temp4-productid = `HT-1080`.
    temp4-suppliername = `Printer for All`.
    temp4-price = `129`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Power Scan`.
    temp4-productid = `HT-1081`.
    temp4-suppliername = `Printer for All`.
    temp4-price = `89`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Jet Scan Professional`.
    temp4-productid = `HT-1082`.
    temp4-suppliername = `Printer for All`.
    temp4-price = `169`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Jet Scan Professional`.
    temp4-productid = `HT-1083`.
    temp4-suppliername = `Printer for All`.
    temp4-price = `189`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Copymaster`.
    temp4-productid = `HT-1085`.
    temp4-suppliername = `Alpha Printers`.
    temp4-price = `1499`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Surround Sound`.
    temp4-productid = `HT-1090`.
    temp4-suppliername = `Speaker Experts`.
    temp4-price = `39`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Blaster Extreme`.
    temp4-productid = `HT-1091`.
    temp4-suppliername = `Speaker Experts`.
    temp4-price = `26`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Sound Booster`.
    temp4-productid = `HT-1092`.
    temp4-suppliername = `Speaker Experts`.
    temp4-price = `45`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Lovely Sound 5.1 Wireless`.
    temp4-productid = `HT-1095`.
    temp4-suppliername = `Fasttech`.
    temp4-price = `49`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Lovely Sound 5.1`.
    temp4-productid = `HT-1096`.
    temp4-suppliername = `Fasttech`.
    temp4-price = `39`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Lovely Sound Stereo`.
    temp4-productid = `HT-1097`.
    temp4-suppliername = `Fasttech`.
    temp4-price = `29`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Office`.
    temp4-productid = `HT-1100`.
    temp4-suppliername = `Technocom`.
    temp4-price = `89.9`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Design`.
    temp4-productid = `HT-1101`.
    temp4-suppliername = `Technocom`.
    temp4-price = `79.9`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Network`.
    temp4-productid = `HT-1102`.
    temp4-suppliername = `Technocom`.
    temp4-price = `69`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Multimedia`.
    temp4-productid = `HT-1103`.
    temp4-suppliername = `Technocom`.
    temp4-price = `77`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Games`.
    temp4-productid = `HT-1104`.
    temp4-suppliername = `Technocom`.
    temp4-price = `55`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Internet Antivirus`.
    temp4-productid = `HT-1105`.
    temp4-suppliername = `Brainsoft`.
    temp4-price = `29`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Firewall`.
    temp4-productid = `HT-1106`.
    temp4-suppliername = `Brainsoft`.
    temp4-price = `34`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Money`.
    temp4-productid = `HT-1107`.
    temp4-suppliername = `Brainsoft`.
    temp4-price = `29.9`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `PC Lock`.
    temp4-productid = `HT-1110`.
    temp4-suppliername = `Red Point Stores`.
    temp4-price = `8.9`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Lock`.
    temp4-productid = `HT-1111`.
    temp4-suppliername = `Red Point Stores`.
    temp4-price = `6.9`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Web cam reality`.
    temp4-productid = `HT-1112`.
    temp4-suppliername = `Red Point Stores`.
    temp4-price = `39`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Screen clean`.
    temp4-productid = `HT-1113`.
    temp4-suppliername = `Red Point Stores`.
    temp4-price = `2.3`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Fabric bag professional`.
    temp4-productid = `HT-1114`.
    temp4-suppliername = `Red Point Stores`.
    temp4-price = `31`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Wireless DSL Router`.
    temp4-productid = `HT-1115`.
    temp4-suppliername = `Red Point Stores`.
    temp4-price = `49`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Wireless DSL Router / Repeater`.
    temp4-productid = `HT-1116`.
    temp4-suppliername = `Red Point Stores`.
    temp4-price = `59`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Wireless DSL Router / Repeater and Print Server`.
    temp4-productid = `HT-1117`.
    temp4-suppliername = `Technocom`.
    temp4-price = `69`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `USB Stick`.
    temp4-productid = `HT-1118`.
    temp4-suppliername = `Technocom`.
    temp4-price = `35`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Travel Adapter`.
    temp4-productid = `HT-1119`.
    temp4-suppliername = `Titanium`.
    temp4-price = `79`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cordless Bluetooth Keyboard, english international`.
    temp4-productid = `HT-1120`.
    temp4-suppliername = `Technocom`.
    temp4-price = `29`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat XXL`.
    temp4-productid = `HT-1137`.
    temp4-suppliername = `Technocom`.
    temp4-price = `1430`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Pocket Mouse`.
    temp4-productid = `HT-1138`.
    temp4-suppliername = `Technocom`.
    temp4-price = `23`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `PC Power Station`.
    temp4-productid = `HT-1210`.
    temp4-suppliername = `Technocom`.
    temp4-price = `2399`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Astro Laptop 1516`.
    temp4-productid = `HT-1251`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-price = `989`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Astro Phone 6`.
    temp4-productid = `HT-1252`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-price = `649`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Benda Laptop 1408`.
    temp4-productid = `HT-1253`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-price = `976`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Bending Screen 21HD`.
    temp4-productid = `HT-1254`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-price = `250`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Broad Screen 22HD`.
    temp4-productid = `HT-1255`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-price = `270`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cerdik Phone 7`.
    temp4-productid = `HT-1256`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-price = `549`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cepat Tablet 10.5`.
    temp4-productid = `HT-1257`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-price = `549`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cepat Tablet 8`.
    temp4-productid = `HT-1258`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-price = `529`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Server Basic`.
    temp4-productid = `HT-1500`.
    temp4-suppliername = `Technocom`.
    temp4-price = `5000`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Server Professional`.
    temp4-productid = `HT-1501`.
    temp4-suppliername = `Technocom`.
    temp4-price = `15000`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Server Power Pro`.
    temp4-productid = `HT-1502`.
    temp4-suppliername = `Technocom`.
    temp4-price = `25000`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Family PC Basic`.
    temp4-productid = `HT-1600`.
    temp4-suppliername = `Titanium`.
    temp4-price = `600`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Family PC Pro`.
    temp4-productid = `HT-1601`.
    temp4-suppliername = `Titanium`.
    temp4-price = `900`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Gaming Monster`.
    temp4-productid = `HT-1602`.
    temp4-suppliername = `Titanium`.
    temp4-price = `1200`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Gaming Monster Pro`.
    temp4-productid = `HT-1603`.
    temp4-suppliername = `Titanium`.
    temp4-price = `1700`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `7" Widescreen Portable DVD Player w MP3`.
    temp4-productid = `HT-2000`.
    temp4-suppliername = `Titanium`.
    temp4-price = `249.99`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `10" Portable DVD player`.
    temp4-productid = `HT-2001`.
    temp4-suppliername = `Titanium`.
    temp4-price = `449.99`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Portable DVD Player with 9" LCD Monitor`.
    temp4-productid = `HT-2002`.
    temp4-suppliername = `Technocom`.
    temp4-price = `853.99`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `CD/DVD case: 264 sleeves`.
    temp4-productid = `HT-2025`.
    temp4-suppliername = `Titanium`.
    temp4-price = `44.99`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Audio/Video Cable Kit - 4m`.
    temp4-productid = `HT-2026`.
    temp4-suppliername = `Titanium`.
    temp4-price = `29.99`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Removable CD/DVD Laser Labels`.
    temp4-productid = `HT-2027`.
    temp4-suppliername = `Titanium`.
    temp4-price = `8.99`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Beam Breaker B-1`.
    temp4-productid = `HT-6100`.
    temp4-suppliername = `Titanium`.
    temp4-price = `469`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Beam Breaker B-2`.
    temp4-productid = `HT-6101`.
    temp4-suppliername = `Technocom`.
    temp4-price = `679`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Beam Breaker B-3`.
    temp4-productid = `HT-6102`.
    temp4-suppliername = `Technocom`.
    temp4-price = `889`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Play Movie`.
    temp4-productid = `HT-6110`.
    temp4-suppliername = `Fasttech`.
    temp4-price = `130`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Record Movie`.
    temp4-productid = `HT-6111`.
    temp4-suppliername = `Fasttech`.
    temp4-price = `288`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelo MusicStick`.
    temp4-productid = `HT-6120`.
    temp4-suppliername = `Fasttech`.
    temp4-price = `45`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelo Jog-Mate`.
    temp4-productid = `HT-6121`.
    temp4-suppliername = `Fasttech`.
    temp4-price = `63`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Power Pro Player 40`.
    temp4-productid = `HT-6122`.
    temp4-suppliername = `Fasttech`.
    temp4-price = `167`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Power Pro Player 80`.
    temp4-productid = `HT-6123`.
    temp4-suppliername = `Fasttech`.
    temp4-price = `299`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Watch HD32`.
    temp4-productid = `HT-6130`.
    temp4-suppliername = `Very Best Screens`.
    temp4-price = `1459`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Watch HD37`.
    temp4-productid = `HT-6131`.
    temp4-suppliername = `Very Best Screens`.
    temp4-price = `1199`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Watch HD41`.
    temp4-productid = `HT-6132`.
    temp4-suppliername = `Very Best Screens`.
    temp4-price = `899`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Copperberry`.
    temp4-productid = `HT-7000`.
    temp4-suppliername = `Fasttech`.
    temp4-price = `549`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Silverberry`.
    temp4-productid = `HT-7010`.
    temp4-suppliername = `Fasttech`.
    temp4-price = `549`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Goldberry`.
    temp4-productid = `HT-7020`.
    temp4-suppliername = `Fasttech`.
    temp4-price = `549`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Platinberry`.
    temp4-productid = `HT-7030`.
    temp4-suppliername = `Fasttech`.
    temp4-price = `549`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO FlexTop I4000`.
    temp4-productid = `HT-8000`.
    temp4-suppliername = `Titanium`.
    temp4-price = `799`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO FlexTop I6300c`.
    temp4-productid = `HT-8001`.
    temp4-suppliername = `Titanium`.
    temp4-price = `799`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO FlexTop I9100`.
    temp4-productid = `HT-8002`.
    temp4-suppliername = `Titanium`.
    temp4-price = `1199`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO FlexTop I9800`.
    temp4-productid = `HT-8003`.
    temp4-suppliername = `Titanium`.
    temp4-price = `1388`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smartphone Leather Case`.
    temp4-productid = `HT-9991`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-price = `25`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smartphone Alpha`.
    temp4-productid = `HT-9992`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-price = `599`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Mini Tablet`.
    temp4-productid = `HT-9993`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-price = `833`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Camcorder View`.
    temp4-productid = `HT-9994`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-price = `1388`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Tablet Pouch`.
    temp4-productid = `HT-9995`.
    temp4-suppliername = `Titanium`.
    temp4-price = `20`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Tablet Pouch`.
    temp4-productid = `HT-9996`.
    temp4-suppliername = `Titanium`.
    temp4-price = `20`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `e-Book Reader ReadMe`.
    temp4-productid = `HT-9997`.
    temp4-suppliername = `Titanium`.
    temp4-price = `33`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smartphone Beta`.
    temp4-productid = `HT-9998`.
    temp4-suppliername = `Titanium`.
    temp4-price = `30`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Maxi Tablet`.
    temp4-productid = `HT-9999`.
    temp4-suppliername = `Titanium`.
    temp4-price = `749`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flyer`.
    temp4-productid = `PF-1000`.
    temp4-suppliername = `Titanium`.
    temp4-price = `0`.
    temp4-currencycode = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    t_products = temp3.

  ENDMETHOD.

ENDCLASS.
