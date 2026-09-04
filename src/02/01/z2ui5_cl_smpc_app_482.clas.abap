" @keywords standardlistitem standard list item sap.m standardlistitemnavigated
" @summary This example demonstrates the navigated property of the list item.
CLASS z2ui5_cl_smpc_app_482 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             name      TYPE string,
             productid TYPE string,
             navigated TYPE abap_bool,
           END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

    DATA t_products TYPE ty_t_product.
  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_482 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( `List`
            )->a( n = `id`         v = `ShortProductList`
            )->a( n = `headerText` v = `Products (Click on an item to set as navigated)`
            )->a( n = `items`      v = |\{ path: '{ client->_bind_path( t_products ) }', sorter: \{ path: 'NAME' \} \}|

            )->ele( `items`
                " isNavigated compares the pressed ProductId with the one the settings
                " model holds - the comparison is business logic, so the flag is a
                " model field the press wire sets in ABAP
                )->tag( `StandardListItem`
                    )->a( n = `type`      v = `Active`
                    )->a( n = `title`     v = `{NAME}`
                    )->a( n = `navigated` v = `{NAVIGATED}`
                    )->a( n = `press`     v = client->_event( val = `PRESS` arg = `${PRODUCTID}` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
      DATA pressed_id TYPE string.
      FIELD-SYMBOLS <product> LIKE LINE OF t_products.
        DATA temp1 TYPE xsdboolean.

    IF client->get_event( ) = `PRESS`.

      " onPress writes the pressed row's ProductId into the settings model, which
      " the navigated formatter compares against every row
      
      pressed_id = client->get_event_arg( ).
      
      LOOP AT t_products ASSIGNING <product>.
        
        temp1 = boolc( <product>-productid = pressed_id ).
        <product>-navigated = temp1.
      ENDLOOP.

    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " full mock /ProductCollection of ui5/mock/products.json (the bound fields)
    DATA temp1 TYPE z2ui5_cl_smpc_app_482=>ty_t_product.
    DATA temp2 LIKE LINE OF temp1.
    CLEAR temp1.
    
    temp2-name = `Notebook Basic 15`.
    temp2-productid = `HT-1000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Basic 17`.
    temp2-productid = `HT-1001`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Basic 18`.
    temp2-productid = `HT-1002`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Basic 19`.
    temp2-productid = `HT-1003`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO Vault`.
    temp2-productid = `HT-1007`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Professional 15`.
    temp2-productid = `HT-1010`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Professional 17`.
    temp2-productid = `HT-1011`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO Vault Net`.
    temp2-productid = `HT-1020`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO Vault SAT`.
    temp2-productid = `HT-1021`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Comfort Easy`.
    temp2-productid = `HT-1022`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Comfort Senior`.
    temp2-productid = `HT-1023`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ergo Screen E-I`.
    temp2-productid = `HT-1030`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ergo Screen E-II`.
    temp2-productid = `HT-1031`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ergo Screen E-III`.
    temp2-productid = `HT-1032`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat Basic`.
    temp2-productid = `HT-1035`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat Future`.
    temp2-productid = `HT-1036`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat XL`.
    temp2-productid = `HT-1037`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Laser Professional Eco`.
    temp2-productid = `HT-1040`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Laser Basic`.
    temp2-productid = `HT-1041`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Laser Allround`.
    temp2-productid = `HT-1042`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ultra Jet Super Color`.
    temp2-productid = `HT-1050`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ultra Jet Mobile`.
    temp2-productid = `HT-1051`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ultra Jet Super Highspeed`.
    temp2-productid = `HT-1052`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Multi Print`.
    temp2-productid = `HT-1055`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Multi Color`.
    temp2-productid = `HT-1056`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Cordless Mouse`.
    temp2-productid = `HT-1060`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Speed Mouse`.
    temp2-productid = `HT-1061`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Track Mouse`.
    temp2-productid = `HT-1062`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ergonomic Keyboard`.
    temp2-productid = `HT-1063`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Internet Keyboard`.
    temp2-productid = `HT-1064`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Media Keyboard`.
    temp2-productid = `HT-1065`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Mousepad`.
    temp2-productid = `HT-1066`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ergo Mousepad`.
    temp2-productid = `HT-1067`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Designer Mousepad`.
    temp2-productid = `HT-1068`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Universal card reader`.
    temp2-productid = `HT-1069`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Proctra X`.
    temp2-productid = `HT-1070`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Gladiator MX`.
    temp2-productid = `HT-1071`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Hurricane GX`.
    temp2-productid = `HT-1072`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Hurricane GX/LN`.
    temp2-productid = `HT-1073`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Photo Scan`.
    temp2-productid = `HT-1080`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Power Scan`.
    temp2-productid = `HT-1081`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Jet Scan Professional`.
    temp2-productid = `HT-1082`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Jet Scan Professional`.
    temp2-productid = `HT-1083`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Copymaster`.
    temp2-productid = `HT-1085`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Surround Sound`.
    temp2-productid = `HT-1090`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Blaster Extreme`.
    temp2-productid = `HT-1091`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Sound Booster`.
    temp2-productid = `HT-1092`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Lovely Sound 5.1 Wireless`.
    temp2-productid = `HT-1095`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Lovely Sound 5.1`.
    temp2-productid = `HT-1096`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Lovely Sound Stereo`.
    temp2-productid = `HT-1097`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Office`.
    temp2-productid = `HT-1100`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Design`.
    temp2-productid = `HT-1101`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Network`.
    temp2-productid = `HT-1102`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Multimedia`.
    temp2-productid = `HT-1103`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Games`.
    temp2-productid = `HT-1104`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Internet Antivirus`.
    temp2-productid = `HT-1105`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Firewall`.
    temp2-productid = `HT-1106`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Money`.
    temp2-productid = `HT-1107`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `PC Lock`.
    temp2-productid = `HT-1110`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Lock`.
    temp2-productid = `HT-1111`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Web cam reality`.
    temp2-productid = `HT-1112`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Screen clean`.
    temp2-productid = `HT-1113`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Fabric bag professional`.
    temp2-productid = `HT-1114`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Wireless DSL Router`.
    temp2-productid = `HT-1115`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Wireless DSL Router / Repeater`.
    temp2-productid = `HT-1116`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Wireless DSL Router / Repeater and Print Server`.
    temp2-productid = `HT-1117`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `USB Stick`.
    temp2-productid = `HT-1118`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Travel Adapter`.
    temp2-productid = `HT-1119`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Cordless Bluetooth Keyboard, english international`.
    temp2-productid = `HT-1120`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat XXL`.
    temp2-productid = `HT-1137`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Pocket Mouse`.
    temp2-productid = `HT-1138`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `PC Power Station`.
    temp2-productid = `HT-1210`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Astro Laptop 1516`.
    temp2-productid = `HT-1251`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Astro Phone 6`.
    temp2-productid = `HT-1252`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Benda Laptop 1408`.
    temp2-productid = `HT-1253`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Bending Screen 21HD`.
    temp2-productid = `HT-1254`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Broad Screen 22HD`.
    temp2-productid = `HT-1255`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Cerdik Phone 7`.
    temp2-productid = `HT-1256`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Cepat Tablet 10.5`.
    temp2-productid = `HT-1257`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Cepat Tablet 8`.
    temp2-productid = `HT-1258`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Server Basic`.
    temp2-productid = `HT-1500`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Server Professional`.
    temp2-productid = `HT-1501`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Server Power Pro`.
    temp2-productid = `HT-1502`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Family PC Basic`.
    temp2-productid = `HT-1600`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Family PC Pro`.
    temp2-productid = `HT-1601`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Gaming Monster`.
    temp2-productid = `HT-1602`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Gaming Monster Pro`.
    temp2-productid = `HT-1603`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `7" Widescreen Portable DVD Player w MP3`.
    temp2-productid = `HT-2000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `10" Portable DVD player`.
    temp2-productid = `HT-2001`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Portable DVD Player with 9" LCD Monitor`.
    temp2-productid = `HT-2002`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `CD/DVD case: 264 sleeves`.
    temp2-productid = `HT-2025`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Audio/Video Cable Kit - 4m`.
    temp2-productid = `HT-2026`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Removable CD/DVD Laser Labels`.
    temp2-productid = `HT-2027`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Beam Breaker B-1`.
    temp2-productid = `HT-6100`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Beam Breaker B-2`.
    temp2-productid = `HT-6101`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Beam Breaker B-3`.
    temp2-productid = `HT-6102`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Play Movie`.
    temp2-productid = `HT-6110`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Record Movie`.
    temp2-productid = `HT-6111`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelo MusicStick`.
    temp2-productid = `HT-6120`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelo Jog-Mate`.
    temp2-productid = `HT-6121`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Power Pro Player 40`.
    temp2-productid = `HT-6122`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Power Pro Player 80`.
    temp2-productid = `HT-6123`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat Watch HD32`.
    temp2-productid = `HT-6130`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat Watch HD37`.
    temp2-productid = `HT-6131`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat Watch HD41`.
    temp2-productid = `HT-6132`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Copperberry`.
    temp2-productid = `HT-7000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Silverberry`.
    temp2-productid = `HT-7010`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Goldberry`.
    temp2-productid = `HT-7020`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Platinberry`.
    temp2-productid = `HT-7030`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO FlexTop I4000`.
    temp2-productid = `HT-8000`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO FlexTop I6300c`.
    temp2-productid = `HT-8001`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO FlexTop I9100`.
    temp2-productid = `HT-8002`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO FlexTop I9800`.
    temp2-productid = `HT-8003`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smartphone Leather Case`.
    temp2-productid = `HT-9991`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smartphone Alpha`.
    temp2-productid = `HT-9992`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Mini Tablet`.
    temp2-productid = `HT-9993`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Camcorder View`.
    temp2-productid = `HT-9994`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Tablet Pouch`.
    temp2-productid = `HT-9995`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Tablet Pouch`.
    temp2-productid = `HT-9996`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `e-Book Reader ReadMe`.
    temp2-productid = `HT-9997`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smartphone Beta`.
    temp2-productid = `HT-9998`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Maxi Tablet`.
    temp2-productid = `HT-9999`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flyer`.
    temp2-productid = `PF-1000`.
    INSERT temp2 INTO TABLE temp1.
    t_products = temp1.

  ENDMETHOD.

ENDCLASS.
