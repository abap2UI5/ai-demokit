" @keywords multicombobox multi combo box sap.m items could gr verticallayout item
" @summary Items in the MultiComboBox could be grouped by a property
CLASS z2ui5_cl_smpc_app_039 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        product_id    TYPE string,
        name          TYPE string,
        supplier_name TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_039 IMPLEMENTATION.

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
                )->a( n = `width` v = `500px`
                )->a( n = `items` v = |\{ path: '{ client->_bind_path( t_products ) }', sorter: \{ path: 'SUPPLIER_NAME', descending: false, group: true \} \}|

                )->tag( n = `Item` ns = `core`
                    )->a( n = `key`  v = `{PRODUCT_ID}`
                    )->a( n = `text` v = `{NAME}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " full mock /ProductCollection (sap/ui/demo/mock/products.json) of the original sample
    DATA temp1 LIKE t_products.
    DATA temp2 LIKE LINE OF temp1.
    CLEAR temp1.
    
    temp2-product_id = `HT-1000`.
    temp2-name = `Notebook Basic 15`.
    temp2-supplier_name = `Very Best Screens`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1001`.
    temp2-name = `Notebook Basic 17`.
    temp2-supplier_name = `Very Best Screens`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1002`.
    temp2-name = `Notebook Basic 18`.
    temp2-supplier_name = `Very Best Screens`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1003`.
    temp2-name = `Notebook Basic 19`.
    temp2-supplier_name = `Smartcards`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1007`.
    temp2-name = `ITelO Vault`.
    temp2-supplier_name = `Technocom`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1010`.
    temp2-name = `Notebook Professional 15`.
    temp2-supplier_name = `Very Best Screens`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1011`.
    temp2-name = `Notebook Professional 17`.
    temp2-supplier_name = `Very Best Screens`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1020`.
    temp2-name = `ITelO Vault Net`.
    temp2-supplier_name = `Technocom`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1021`.
    temp2-name = `ITelO Vault SAT`.
    temp2-supplier_name = `Technocom`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1022`.
    temp2-name = `Comfort Easy`.
    temp2-supplier_name = `Technocom`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1023`.
    temp2-name = `Comfort Senior`.
    temp2-supplier_name = `Technocom`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1030`.
    temp2-name = `Ergo Screen E-I`.
    temp2-supplier_name = `Very Best Screens`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1031`.
    temp2-name = `Ergo Screen E-II`.
    temp2-supplier_name = `Very Best Screens`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1032`.
    temp2-name = `Ergo Screen E-III`.
    temp2-supplier_name = `Very Best Screens`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1035`.
    temp2-name = `Flat Basic`.
    temp2-supplier_name = `Very Best Screens`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1036`.
    temp2-name = `Flat Future`.
    temp2-supplier_name = `Very Best Screens`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1037`.
    temp2-name = `Flat XL`.
    temp2-supplier_name = `Very Best Screens`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1040`.
    temp2-name = `Laser Professional Eco`.
    temp2-supplier_name = `Alpha Printers`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1041`.
    temp2-name = `Laser Basic`.
    temp2-supplier_name = `Alpha Printers`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1042`.
    temp2-name = `Laser Allround`.
    temp2-supplier_name = `Alpha Printers`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1050`.
    temp2-name = `Ultra Jet Super Color`.
    temp2-supplier_name = `Alpha Printers`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1051`.
    temp2-name = `Ultra Jet Mobile`.
    temp2-supplier_name = `Printer for All`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1052`.
    temp2-name = `Ultra Jet Super Highspeed`.
    temp2-supplier_name = `Printer for All`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1055`.
    temp2-name = `Multi Print`.
    temp2-supplier_name = `Printer for All`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1056`.
    temp2-name = `Multi Color`.
    temp2-supplier_name = `Printer for All`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1060`.
    temp2-name = `Cordless Mouse`.
    temp2-supplier_name = `Oxynum`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1061`.
    temp2-name = `Speed Mouse`.
    temp2-supplier_name = `Oxynum`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1062`.
    temp2-name = `Track Mouse`.
    temp2-supplier_name = `Oxynum`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1063`.
    temp2-name = `Ergonomic Keyboard`.
    temp2-supplier_name = `Oxynum`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1064`.
    temp2-name = `Internet Keyboard`.
    temp2-supplier_name = `Oxynum`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1065`.
    temp2-name = `Media Keyboard`.
    temp2-supplier_name = `Oxynum`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1066`.
    temp2-name = `Mousepad`.
    temp2-supplier_name = `Oxynum`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1067`.
    temp2-name = `Ergo Mousepad`.
    temp2-supplier_name = `Oxynum`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1068`.
    temp2-name = `Designer Mousepad`.
    temp2-supplier_name = `Fasttech`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1069`.
    temp2-name = `Universal card reader`.
    temp2-supplier_name = `Fasttech`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1070`.
    temp2-name = `Proctra X`.
    temp2-supplier_name = `Ultrasonic United`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1071`.
    temp2-name = `Gladiator MX`.
    temp2-supplier_name = `Ultrasonic United`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1072`.
    temp2-name = `Hurricane GX`.
    temp2-supplier_name = `Ultrasonic United`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1073`.
    temp2-name = `Hurricane GX/LN`.
    temp2-supplier_name = `Smartcards`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1080`.
    temp2-name = `Photo Scan`.
    temp2-supplier_name = `Printer for All`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1081`.
    temp2-name = `Power Scan`.
    temp2-supplier_name = `Printer for All`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1082`.
    temp2-name = `Jet Scan Professional`.
    temp2-supplier_name = `Printer for All`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1083`.
    temp2-name = `Jet Scan Professional`.
    temp2-supplier_name = `Printer for All`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1085`.
    temp2-name = `Copymaster`.
    temp2-supplier_name = `Alpha Printers`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1090`.
    temp2-name = `Surround Sound`.
    temp2-supplier_name = `Speaker Experts`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1091`.
    temp2-name = `Blaster Extreme`.
    temp2-supplier_name = `Speaker Experts`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1092`.
    temp2-name = `Sound Booster`.
    temp2-supplier_name = `Speaker Experts`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1095`.
    temp2-name = `Lovely Sound 5.1 Wireless`.
    temp2-supplier_name = `Fasttech`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1096`.
    temp2-name = `Lovely Sound 5.1`.
    temp2-supplier_name = `Fasttech`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1097`.
    temp2-name = `Lovely Sound Stereo`.
    temp2-supplier_name = `Fasttech`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1100`.
    temp2-name = `Smart Office`.
    temp2-supplier_name = `Technocom`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1101`.
    temp2-name = `Smart Design`.
    temp2-supplier_name = `Technocom`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1102`.
    temp2-name = `Smart Network`.
    temp2-supplier_name = `Technocom`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1103`.
    temp2-name = `Smart Multimedia`.
    temp2-supplier_name = `Technocom`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1104`.
    temp2-name = `Smart Games`.
    temp2-supplier_name = `Technocom`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1105`.
    temp2-name = `Smart Internet Antivirus`.
    temp2-supplier_name = `Brainsoft`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1106`.
    temp2-name = `Smart Firewall`.
    temp2-supplier_name = `Brainsoft`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1107`.
    temp2-name = `Smart Money`.
    temp2-supplier_name = `Brainsoft`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1110`.
    temp2-name = `PC Lock`.
    temp2-supplier_name = `Red Point Stores`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1111`.
    temp2-name = `Notebook Lock`.
    temp2-supplier_name = `Red Point Stores`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1112`.
    temp2-name = `Web cam reality`.
    temp2-supplier_name = `Red Point Stores`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1113`.
    temp2-name = `Screen clean`.
    temp2-supplier_name = `Red Point Stores`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1114`.
    temp2-name = `Fabric bag professional`.
    temp2-supplier_name = `Red Point Stores`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1115`.
    temp2-name = `Wireless DSL Router`.
    temp2-supplier_name = `Red Point Stores`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1116`.
    temp2-name = `Wireless DSL Router / Repeater`.
    temp2-supplier_name = `Red Point Stores`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1117`.
    temp2-name = `Wireless DSL Router / Repeater and Print Server`.
    temp2-supplier_name = `Technocom`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1118`.
    temp2-name = `USB Stick`.
    temp2-supplier_name = `Technocom`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1119`.
    temp2-name = `Travel Adapter`.
    temp2-supplier_name = `Titanium`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1120`.
    temp2-name = `Cordless Bluetooth Keyboard, english international`.
    temp2-supplier_name = `Technocom`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1137`.
    temp2-name = `Flat XXL`.
    temp2-supplier_name = `Technocom`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1138`.
    temp2-name = `Pocket Mouse`.
    temp2-supplier_name = `Technocom`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1210`.
    temp2-name = `PC Power Station`.
    temp2-supplier_name = `Technocom`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1251`.
    temp2-name = `Astro Laptop 1516`.
    temp2-supplier_name = `Ultrasonic United`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1252`.
    temp2-name = `Astro Phone 6`.
    temp2-supplier_name = `Ultrasonic United`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1253`.
    temp2-name = `Benda Laptop 1408`.
    temp2-supplier_name = `Ultrasonic United`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1254`.
    temp2-name = `Bending Screen 21HD`.
    temp2-supplier_name = `Ultrasonic United`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1255`.
    temp2-name = `Broad Screen 22HD`.
    temp2-supplier_name = `Ultrasonic United`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1256`.
    temp2-name = `Cerdik Phone 7`.
    temp2-supplier_name = `Ultrasonic United`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1257`.
    temp2-name = `Cepat Tablet 10.5`.
    temp2-supplier_name = `Ultrasonic United`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1258`.
    temp2-name = `Cepat Tablet 8`.
    temp2-supplier_name = `Ultrasonic United`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1500`.
    temp2-name = `Server Basic`.
    temp2-supplier_name = `Technocom`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1501`.
    temp2-name = `Server Professional`.
    temp2-supplier_name = `Technocom`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1502`.
    temp2-name = `Server Power Pro`.
    temp2-supplier_name = `Technocom`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1600`.
    temp2-name = `Family PC Basic`.
    temp2-supplier_name = `Titanium`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1601`.
    temp2-name = `Family PC Pro`.
    temp2-supplier_name = `Titanium`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1602`.
    temp2-name = `Gaming Monster`.
    temp2-supplier_name = `Titanium`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1603`.
    temp2-name = `Gaming Monster Pro`.
    temp2-supplier_name = `Titanium`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-2000`.
    temp2-name = `7" Widescreen Portable DVD Player w MP3`.
    temp2-supplier_name = `Titanium`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-2001`.
    temp2-name = `10" Portable DVD player`.
    temp2-supplier_name = `Titanium`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-2002`.
    temp2-name = `Portable DVD Player with 9" LCD Monitor`.
    temp2-supplier_name = `Technocom`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-2025`.
    temp2-name = `CD/DVD case: 264 sleeves`.
    temp2-supplier_name = `Titanium`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-2026`.
    temp2-name = `Audio/Video Cable Kit - 4m`.
    temp2-supplier_name = `Titanium`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-2027`.
    temp2-name = `Removable CD/DVD Laser Labels`.
    temp2-supplier_name = `Titanium`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-6100`.
    temp2-name = `Beam Breaker B-1`.
    temp2-supplier_name = `Titanium`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-6101`.
    temp2-name = `Beam Breaker B-2`.
    temp2-supplier_name = `Technocom`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-6102`.
    temp2-name = `Beam Breaker B-3`.
    temp2-supplier_name = `Technocom`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-6110`.
    temp2-name = `Play Movie`.
    temp2-supplier_name = `Fasttech`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-6111`.
    temp2-name = `Record Movie`.
    temp2-supplier_name = `Fasttech`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-6120`.
    temp2-name = `ITelo MusicStick`.
    temp2-supplier_name = `Fasttech`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-6121`.
    temp2-name = `ITelo Jog-Mate`.
    temp2-supplier_name = `Fasttech`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-6122`.
    temp2-name = `Power Pro Player 40`.
    temp2-supplier_name = `Fasttech`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-6123`.
    temp2-name = `Power Pro Player 80`.
    temp2-supplier_name = `Fasttech`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-6130`.
    temp2-name = `Flat Watch HD32`.
    temp2-supplier_name = `Very Best Screens`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-6131`.
    temp2-name = `Flat Watch HD37`.
    temp2-supplier_name = `Very Best Screens`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-6132`.
    temp2-name = `Flat Watch HD41`.
    temp2-supplier_name = `Very Best Screens`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-7000`.
    temp2-name = `Copperberry`.
    temp2-supplier_name = `Fasttech`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-7010`.
    temp2-name = `Silverberry`.
    temp2-supplier_name = `Fasttech`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-7020`.
    temp2-name = `Goldberry`.
    temp2-supplier_name = `Fasttech`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-7030`.
    temp2-name = `Platinberry`.
    temp2-supplier_name = `Fasttech`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-8000`.
    temp2-name = `ITelO FlexTop I4000`.
    temp2-supplier_name = `Titanium`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-8001`.
    temp2-name = `ITelO FlexTop I6300c`.
    temp2-supplier_name = `Titanium`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-8002`.
    temp2-name = `ITelO FlexTop I9100`.
    temp2-supplier_name = `Titanium`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-8003`.
    temp2-name = `ITelO FlexTop I9800`.
    temp2-supplier_name = `Titanium`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-9991`.
    temp2-name = `Smartphone Leather Case`.
    temp2-supplier_name = `Ultrasonic United`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-9992`.
    temp2-name = `Smartphone Alpha`.
    temp2-supplier_name = `Ultrasonic United`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-9993`.
    temp2-name = `Mini Tablet`.
    temp2-supplier_name = `Ultrasonic United`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-9994`.
    temp2-name = `Camcorder View`.
    temp2-supplier_name = `Ultrasonic United`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-9995`.
    temp2-name = `Tablet Pouch`.
    temp2-supplier_name = `Titanium`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-9996`.
    temp2-name = `Tablet Pouch`.
    temp2-supplier_name = `Titanium`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-9997`.
    temp2-name = `e-Book Reader ReadMe`.
    temp2-supplier_name = `Titanium`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-9998`.
    temp2-name = `Smartphone Beta`.
    temp2-supplier_name = `Titanium`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-9999`.
    temp2-name = `Maxi Tablet`.
    temp2-supplier_name = `Titanium`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `PF-1000`.
    temp2-name = `Flyer`.
    temp2-supplier_name = `Titanium`.
    INSERT temp2 INTO TABLE temp1.
    t_products = temp1.

  ENDMETHOD.

ENDCLASS.
