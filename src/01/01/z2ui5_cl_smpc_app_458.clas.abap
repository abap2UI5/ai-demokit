" @keywords multicombobox multi combo box sap.m multicomboboxtwocolumnslayout verticallayout listitem
" @summary Use the dropdown list with two columns layout if you need to display additional information to your options, like e.g. currencies to countries or abbreviations to systems.
CLASS z2ui5_cl_smpc_app_458 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             productid TYPE string,
             name      TYPE string,
           END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

    DATA t_products TYPE ty_t_product.


  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_458 IMPLEMENTATION.

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
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->ele( `MultiComboBox`
                )->a( n = `showSecondaryValues` v = `true`
                )->a( n = `width`               v = `500px`
                )->a( n = `items`               v = |\{ path: '{ client->_bind_path( t_products ) }', sorter: \{ path: 'NAME' \} \}|

                )->tag( n = `ListItem` ns = `core`
                    )->a( n = `key`            v = `{PRODUCTID}`
                    )->a( n = `text`           v = `{NAME}`
                    )->a( n = `additionalText` v = `{PRODUCTID}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " full mock /ProductCollection of ui5/mock/products.json (the two bound fields)
    DATA temp1 TYPE z2ui5_cl_smpc_app_458=>ty_t_product.
    DATA temp2 LIKE LINE OF temp1.
    CLEAR temp1.
    
    temp2-productid = `HT-1000`.
    temp2-name = `Notebook Basic 15`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1001`.
    temp2-name = `Notebook Basic 17`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1002`.
    temp2-name = `Notebook Basic 18`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1003`.
    temp2-name = `Notebook Basic 19`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1007`.
    temp2-name = `ITelO Vault`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1010`.
    temp2-name = `Notebook Professional 15`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1011`.
    temp2-name = `Notebook Professional 17`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1020`.
    temp2-name = `ITelO Vault Net`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1021`.
    temp2-name = `ITelO Vault SAT`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1022`.
    temp2-name = `Comfort Easy`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1023`.
    temp2-name = `Comfort Senior`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1030`.
    temp2-name = `Ergo Screen E-I`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1031`.
    temp2-name = `Ergo Screen E-II`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1032`.
    temp2-name = `Ergo Screen E-III`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1035`.
    temp2-name = `Flat Basic`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1036`.
    temp2-name = `Flat Future`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1037`.
    temp2-name = `Flat XL`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1040`.
    temp2-name = `Laser Professional Eco`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1041`.
    temp2-name = `Laser Basic`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1042`.
    temp2-name = `Laser Allround`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1050`.
    temp2-name = `Ultra Jet Super Color`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1051`.
    temp2-name = `Ultra Jet Mobile`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1052`.
    temp2-name = `Ultra Jet Super Highspeed`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1055`.
    temp2-name = `Multi Print`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1056`.
    temp2-name = `Multi Color`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1060`.
    temp2-name = `Cordless Mouse`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1061`.
    temp2-name = `Speed Mouse`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1062`.
    temp2-name = `Track Mouse`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1063`.
    temp2-name = `Ergonomic Keyboard`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1064`.
    temp2-name = `Internet Keyboard`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1065`.
    temp2-name = `Media Keyboard`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1066`.
    temp2-name = `Mousepad`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1067`.
    temp2-name = `Ergo Mousepad`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1068`.
    temp2-name = `Designer Mousepad`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1069`.
    temp2-name = `Universal card reader`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1070`.
    temp2-name = `Proctra X`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1071`.
    temp2-name = `Gladiator MX`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1072`.
    temp2-name = `Hurricane GX`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1073`.
    temp2-name = `Hurricane GX/LN`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1080`.
    temp2-name = `Photo Scan`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1081`.
    temp2-name = `Power Scan`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1082`.
    temp2-name = `Jet Scan Professional`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1083`.
    temp2-name = `Jet Scan Professional`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1085`.
    temp2-name = `Copymaster`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1090`.
    temp2-name = `Surround Sound`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1091`.
    temp2-name = `Blaster Extreme`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1092`.
    temp2-name = `Sound Booster`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1095`.
    temp2-name = `Lovely Sound 5.1 Wireless`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1096`.
    temp2-name = `Lovely Sound 5.1`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1097`.
    temp2-name = `Lovely Sound Stereo`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1100`.
    temp2-name = `Smart Office`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1101`.
    temp2-name = `Smart Design`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1102`.
    temp2-name = `Smart Network`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1103`.
    temp2-name = `Smart Multimedia`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1104`.
    temp2-name = `Smart Games`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1105`.
    temp2-name = `Smart Internet Antivirus`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1106`.
    temp2-name = `Smart Firewall`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1107`.
    temp2-name = `Smart Money`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1110`.
    temp2-name = `PC Lock`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1111`.
    temp2-name = `Notebook Lock`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1112`.
    temp2-name = `Web cam reality`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1113`.
    temp2-name = `Screen clean`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1114`.
    temp2-name = `Fabric bag professional`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1115`.
    temp2-name = `Wireless DSL Router`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1116`.
    temp2-name = `Wireless DSL Router / Repeater`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1117`.
    temp2-name = `Wireless DSL Router / Repeater and Print Server`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1118`.
    temp2-name = `USB Stick`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1119`.
    temp2-name = `Travel Adapter`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1120`.
    temp2-name = `Cordless Bluetooth Keyboard, english international`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1137`.
    temp2-name = `Flat XXL`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1138`.
    temp2-name = `Pocket Mouse`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1210`.
    temp2-name = `PC Power Station`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1251`.
    temp2-name = `Astro Laptop 1516`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1252`.
    temp2-name = `Astro Phone 6`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1253`.
    temp2-name = `Benda Laptop 1408`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1254`.
    temp2-name = `Bending Screen 21HD`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1255`.
    temp2-name = `Broad Screen 22HD`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1256`.
    temp2-name = `Cerdik Phone 7`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1257`.
    temp2-name = `Cepat Tablet 10.5`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1258`.
    temp2-name = `Cepat Tablet 8`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1500`.
    temp2-name = `Server Basic`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1501`.
    temp2-name = `Server Professional`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1502`.
    temp2-name = `Server Power Pro`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1600`.
    temp2-name = `Family PC Basic`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1601`.
    temp2-name = `Family PC Pro`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1602`.
    temp2-name = `Gaming Monster`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1603`.
    temp2-name = `Gaming Monster Pro`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-2000`.
    temp2-name = `7" Widescreen Portable DVD Player w MP3`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-2001`.
    temp2-name = `10" Portable DVD player`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-2002`.
    temp2-name = `Portable DVD Player with 9" LCD Monitor`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-2025`.
    temp2-name = `CD/DVD case: 264 sleeves`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-2026`.
    temp2-name = `Audio/Video Cable Kit - 4m`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-2027`.
    temp2-name = `Removable CD/DVD Laser Labels`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6100`.
    temp2-name = `Beam Breaker B-1`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6101`.
    temp2-name = `Beam Breaker B-2`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6102`.
    temp2-name = `Beam Breaker B-3`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6110`.
    temp2-name = `Play Movie`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6111`.
    temp2-name = `Record Movie`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6120`.
    temp2-name = `ITelo MusicStick`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6121`.
    temp2-name = `ITelo Jog-Mate`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6122`.
    temp2-name = `Power Pro Player 40`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6123`.
    temp2-name = `Power Pro Player 80`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6130`.
    temp2-name = `Flat Watch HD32`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6131`.
    temp2-name = `Flat Watch HD37`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6132`.
    temp2-name = `Flat Watch HD41`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-7000`.
    temp2-name = `Copperberry`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-7010`.
    temp2-name = `Silverberry`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-7020`.
    temp2-name = `Goldberry`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-7030`.
    temp2-name = `Platinberry`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-8000`.
    temp2-name = `ITelO FlexTop I4000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-8001`.
    temp2-name = `ITelO FlexTop I6300c`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-8002`.
    temp2-name = `ITelO FlexTop I9100`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-8003`.
    temp2-name = `ITelO FlexTop I9800`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-9991`.
    temp2-name = `Smartphone Leather Case`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-9992`.
    temp2-name = `Smartphone Alpha`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-9993`.
    temp2-name = `Mini Tablet`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-9994`.
    temp2-name = `Camcorder View`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-9995`.
    temp2-name = `Tablet Pouch`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-9996`.
    temp2-name = `Tablet Pouch`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-9997`.
    temp2-name = `e-Book Reader ReadMe`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-9998`.
    temp2-name = `Smartphone Beta`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-9999`.
    temp2-name = `Maxi Tablet`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `PF-1000`.
    temp2-name = `Flyer`.
    INSERT temp2 INTO TABLE temp1.
    t_products = temp1.


  ENDMETHOD.

ENDCLASS.
