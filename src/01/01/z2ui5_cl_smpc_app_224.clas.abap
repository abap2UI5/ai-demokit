" @keywords list sap.m listselection overflowtoolbar title toolbarspacer select item standardlistitem
" @summary 'Single selection' forces the user to choose exactly one out of many items. With the 'multi' selection the user can pick multiple items at the same time. This is helpful for e.g. batch processing.
CLASS z2ui5_cl_smpc_app_224 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name          TYPE string,
        productid     TYPE string,
        productpicurl TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.
    DATA mode       TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_224 IMPLEMENTATION.

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
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`

        )->ele( `List`
            )->a( n = `id`                     v = `ProductList`
            )->a( n = `items`                  v = client->_bind( t_products )
            )->a( n = `mode`                   v = client->_bind( mode )
            )->a( n = `includeItemInSelection` v = `true`

            )->ele( `headerToolbar`
                )->ele( `OverflowToolbar`
                    )->ele( `content`
                        )->tag( `Title`
                            )->a( n = `text`  v = `Products`
                            )->a( n = `level` v = `H2`
                        )->tag( `ToolbarSpacer`

                        )->ele( `Select`
                            )->a( n = `selectedKey` v = client->_bind( mode )

                            )->ele( `items`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `key`  v = `None`
                                    )->a( n = `text` v = `No Selection`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `key`  v = `SingleSelect`
                                    )->a( n = `text` v = `Single Selection`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `key`  v = `SingleSelectLeft`
                                    )->a( n = `text` v = `Single Selection Left`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `key`  v = `SingleSelectMaster`
                                    )->a( n = `text` v = `Single Selection (Master)`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `key`  v = `MultiSelect`
                                    )->a( n = `text` v = `Multi Selection`

                            )->end(
                        )->end(
                    )->end(
                )->end(
            )->end(

            )->ele( `items`
                )->tag( `StandardListItem`
                    )->a( n = `title`            v = `{NAME}`
                    )->a( n = `description`      v = `{PRODUCTID}`
                    )->a( n = `icon`             v = `{PRODUCTPICURL}`
                    )->a( n = `iconDensityAware` v = `false`
                    )->a( n = `iconInset`        v = `false`

            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.
    DATA temp1 LIKE t_products.
    DATA temp2 LIKE LINE OF temp1.

    mode = `MultiSelect`.

    " full mock /ProductCollection (sap/ui/demo/mock/products.json) of the original sample
    
    CLEAR temp1.
    
    temp2-name = `Notebook Basic 15`.
    temp2-productid = `HT-1000`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Basic 17`.
    temp2-productid = `HT-1001`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1001.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Basic 18`.
    temp2-productid = `HT-1002`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1002.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Basic 19`.
    temp2-productid = `HT-1003`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1003.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO Vault`.
    temp2-productid = `HT-1007`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1007.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Professional 15`.
    temp2-productid = `HT-1010`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Professional 17`.
    temp2-productid = `HT-1011`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1011.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO Vault Net`.
    temp2-productid = `HT-1020`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1020.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO Vault SAT`.
    temp2-productid = `HT-1021`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1021.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Comfort Easy`.
    temp2-productid = `HT-1022`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1022.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Comfort Senior`.
    temp2-productid = `HT-1023`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1023.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ergo Screen E-I`.
    temp2-productid = `HT-1030`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1030.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ergo Screen E-II`.
    temp2-productid = `HT-1031`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1031.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ergo Screen E-III`.
    temp2-productid = `HT-1032`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1032.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat Basic`.
    temp2-productid = `HT-1035`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1035.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat Future`.
    temp2-productid = `HT-1036`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1036.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat XL`.
    temp2-productid = `HT-1037`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1037.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Laser Professional Eco`.
    temp2-productid = `HT-1040`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1040.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Laser Basic`.
    temp2-productid = `HT-1041`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1041.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Laser Allround`.
    temp2-productid = `HT-1042`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1042.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ultra Jet Super Color`.
    temp2-productid = `HT-1050`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1050.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ultra Jet Mobile`.
    temp2-productid = `HT-1051`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1051.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ultra Jet Super Highspeed`.
    temp2-productid = `HT-1052`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1052.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Multi Print`.
    temp2-productid = `HT-1055`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1055.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Multi Color`.
    temp2-productid = `HT-1056`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1056.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Cordless Mouse`.
    temp2-productid = `HT-1060`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1060.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Speed Mouse`.
    temp2-productid = `HT-1061`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1061.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Track Mouse`.
    temp2-productid = `HT-1062`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1062.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ergonomic Keyboard`.
    temp2-productid = `HT-1063`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1063.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Internet Keyboard`.
    temp2-productid = `HT-1064`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1064.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Media Keyboard`.
    temp2-productid = `HT-1065`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1065.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Mousepad`.
    temp2-productid = `HT-1066`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1066.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ergo Mousepad`.
    temp2-productid = `HT-1067`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1067.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Designer Mousepad`.
    temp2-productid = `HT-1068`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1068.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Universal card reader`.
    temp2-productid = `HT-1069`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1069.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Proctra X`.
    temp2-productid = `HT-1070`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1070.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Gladiator MX`.
    temp2-productid = `HT-1071`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1071.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Hurricane GX`.
    temp2-productid = `HT-1072`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1072.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Hurricane GX/LN`.
    temp2-productid = `HT-1073`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1073.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Photo Scan`.
    temp2-productid = `HT-1080`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1080.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Power Scan`.
    temp2-productid = `HT-1081`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1081.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Jet Scan Professional`.
    temp2-productid = `HT-1082`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1082.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Jet Scan Professional`.
    temp2-productid = `HT-1083`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1083.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Copymaster`.
    temp2-productid = `HT-1085`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1085.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Surround Sound`.
    temp2-productid = `HT-1090`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1090.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Blaster Extreme`.
    temp2-productid = `HT-1091`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1091.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Sound Booster`.
    temp2-productid = `HT-1092`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1092.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Lovely Sound 5.1 Wireless`.
    temp2-productid = `HT-1095`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1095.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Lovely Sound 5.1`.
    temp2-productid = `HT-1096`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1096.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Lovely Sound Stereo`.
    temp2-productid = `HT-1097`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1097.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Office`.
    temp2-productid = `HT-1100`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1100.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Design`.
    temp2-productid = `HT-1101`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1101.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Network`.
    temp2-productid = `HT-1102`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1102.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Multimedia`.
    temp2-productid = `HT-1103`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1103.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Games`.
    temp2-productid = `HT-1104`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1104.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Internet Antivirus`.
    temp2-productid = `HT-1105`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1105.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Firewall`.
    temp2-productid = `HT-1106`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1106.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Money`.
    temp2-productid = `HT-1107`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1107.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `PC Lock`.
    temp2-productid = `HT-1110`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1110.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Lock`.
    temp2-productid = `HT-1111`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1111.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Web cam reality`.
    temp2-productid = `HT-1112`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1112.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Screen clean`.
    temp2-productid = `HT-1113`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1113.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Fabric bag professional`.
    temp2-productid = `HT-1114`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1114.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Wireless DSL Router`.
    temp2-productid = `HT-1115`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1115.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Wireless DSL Router / Repeater`.
    temp2-productid = `HT-1116`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1116.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Wireless DSL Router / Repeater and Print Server`.
    temp2-productid = `HT-1117`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1117.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `USB Stick`.
    temp2-productid = `HT-1118`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1118.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Travel Adapter`.
    temp2-productid = `HT-1119`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1119.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Cordless Bluetooth Keyboard, english international`.
    temp2-productid = `HT-1120`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1120.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat XXL`.
    temp2-productid = `HT-1137`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1137.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Pocket Mouse`.
    temp2-productid = `HT-1138`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1138.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `PC Power Station`.
    temp2-productid = `HT-1210`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1210.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Astro Laptop 1516`.
    temp2-productid = `HT-1251`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1251.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Astro Phone 6`.
    temp2-productid = `HT-1252`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1252.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Benda Laptop 1408`.
    temp2-productid = `HT-1253`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1253.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Bending Screen 21HD`.
    temp2-productid = `HT-1254`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1254.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Broad Screen 22HD`.
    temp2-productid = `HT-1255`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1255.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Cerdik Phone 7`.
    temp2-productid = `HT-1256`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1256.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Cepat Tablet 10.5`.
    temp2-productid = `HT-1257`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1257.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Cepat Tablet 8`.
    temp2-productid = `HT-1258`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1258.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Server Basic`.
    temp2-productid = `HT-1500`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1500.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Server Professional`.
    temp2-productid = `HT-1501`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1501.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Server Power Pro`.
    temp2-productid = `HT-1502`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1502.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Family PC Basic`.
    temp2-productid = `HT-1600`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1600.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Family PC Pro`.
    temp2-productid = `HT-1601`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1601.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Gaming Monster`.
    temp2-productid = `HT-1602`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1602.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Gaming Monster Pro`.
    temp2-productid = `HT-1603`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1603.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `7" Widescreen Portable DVD Player w MP3`.
    temp2-productid = `HT-2000`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2000.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `10" Portable DVD player`.
    temp2-productid = `HT-2001`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2001.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Portable DVD Player with 9" LCD Monitor`.
    temp2-productid = `HT-2002`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2002.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `CD/DVD case: 264 sleeves`.
    temp2-productid = `HT-2025`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2025.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Audio/Video Cable Kit - 4m`.
    temp2-productid = `HT-2026`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2026.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Removable CD/DVD Laser Labels`.
    temp2-productid = `HT-2027`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2027.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Beam Breaker B-1`.
    temp2-productid = `HT-6100`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6100.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Beam Breaker B-2`.
    temp2-productid = `HT-6101`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6101.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Beam Breaker B-3`.
    temp2-productid = `HT-6102`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6102.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Play Movie`.
    temp2-productid = `HT-6110`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6110.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Record Movie`.
    temp2-productid = `HT-6111`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6111.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelo MusicStick`.
    temp2-productid = `HT-6120`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6120.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelo Jog-Mate`.
    temp2-productid = `HT-6121`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6121.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Power Pro Player 40`.
    temp2-productid = `HT-6122`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6122.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Power Pro Player 80`.
    temp2-productid = `HT-6123`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6123.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat Watch HD32`.
    temp2-productid = `HT-6130`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6130.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat Watch HD37`.
    temp2-productid = `HT-6131`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6131.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat Watch HD41`.
    temp2-productid = `HT-6132`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6132.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Copperberry`.
    temp2-productid = `HT-7000`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7000.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Silverberry`.
    temp2-productid = `HT-7010`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7010.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Goldberry`.
    temp2-productid = `HT-7020`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7020.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Platinberry`.
    temp2-productid = `HT-7030`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7030.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO FlexTop I4000`.
    temp2-productid = `HT-8000`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8000.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO FlexTop I6300c`.
    temp2-productid = `HT-8001`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8001.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO FlexTop I9100`.
    temp2-productid = `HT-8002`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8002.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO FlexTop I9800`.
    temp2-productid = `HT-8003`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8003.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smartphone Leather Case`.
    temp2-productid = `HT-9991`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9991.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smartphone Alpha`.
    temp2-productid = `HT-9992`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9992.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Mini Tablet`.
    temp2-productid = `HT-9993`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9993.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Camcorder View`.
    temp2-productid = `HT-9994`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9994.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Tablet Pouch`.
    temp2-productid = `HT-9995`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9995.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Tablet Pouch`.
    temp2-productid = `HT-9996`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9996.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `e-Book Reader ReadMe`.
    temp2-productid = `HT-9997`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9997.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smartphone Beta`.
    temp2-productid = `HT-9998`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9998.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Maxi Tablet`.
    temp2-productid = `HT-9999`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9999.jpg`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flyer`.
    temp2-productid = `PF-1000`.
    temp2-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/PF-1000.jpg`.
    INSERT temp2 INTO TABLE temp1.
    t_products = temp1.

  ENDMETHOD.

ENDCLASS.
