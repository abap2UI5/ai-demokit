" @keywords multicombobox multi combo box sap.m multicomboboxselectall verticallayout item
" @summary MultiComboBox with enabled Select All feature inside suggestions.
CLASS z2ui5_cl_smpc_app_281 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        productid TYPE string,
        name      TYPE string,
      END OF ty_s_product.
    DATA t_products      TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.
    DATA t_selected_keys TYPE string_table.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_281 IMPLEMENTATION.

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
    DATA temp1 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `${$parameters>/changedItem}.getText()` INTO TABLE temp1.
    INSERT `${$parameters>/selected}` INTO TABLE temp1.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `height`     v = `100%`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->ele( `MultiComboBox`
                )->a( n = `selectionChange` v = client->_event( val = `SELECTION_CHANGE` t_arg = temp1 )
                )->a( n = `selectionFinish` v = client->_event( `SELECTION_FINISH` )
                )->a( n = `showSelectAll`   v = `true`
                )->a( n = `width`           v = `350px`
                )->a( n = `items`           v = |\{ path: '{ client->_bind_path( t_products ) }', sorter: \{ path: 'NAME' \} \}|
                " added binding: the selected keys must reach the backend for the
                " selectionFinish text (the original reads getSelectedItems in the controller)
                )->a( n = `selectedKeys`    v = client->_bind( t_selected_keys )

                )->tag( n = `Item` ns = `core`
                    )->a( n = `key`  v = `{PRODUCTID}`
                    )->a( n = `text` v = `{NAME}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA temp3 TYPE string.
        DATA names TYPE string.
        DATA key LIKE LINE OF t_selected_keys.
          DATA temp4 TYPE string.
          DATA temp5 TYPE z2ui5_cl_smpc_app_281=>ty_s_product.
          DATA temp1 TYPE string.

    CASE client->get_event( ).

      WHEN `SELECTION_CHANGE`.

        
        IF client->get_event_arg( 2 ) = abap_true.
          temp3 = `Selected`.
        ELSE.
          temp3 = `Deselected`.
        ENDIF.
        client->message_toast_display(
          text  = |Event 'selectionChange': { temp3 } '{ client->get_event_arg( ) }'|
          width = `auto` ).

      WHEN `SELECTION_FINISH`.

        
        names = ``.
        
        LOOP AT t_selected_keys INTO key.
          
          CLEAR temp4.
          
          READ TABLE t_products INTO temp5 WITH KEY productid = key.
          IF sy-subrc = 0.
            temp4 = temp5-name.
          ENDIF.
          
          IF sy-tabix > 1.
            temp1 = `,`.
          ELSE.
            CLEAR temp1.
          ENDIF.
          names = |{ names }{ temp1 }'{ temp4 }'|.
        ENDLOOP.

        client->message_toast_display( text = |Event 'selectionFinished': [{ names }]| width = `auto` ).

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " /ProductCollection of sap/ui/demo/mock/products.json - the two bound keys of every row
    DATA temp6 LIKE t_products.
    DATA temp7 LIKE LINE OF temp6.
    CLEAR temp6.
    
    temp7-productid = `HT-1000`.
    temp7-name = `Notebook Basic 15`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1001`.
    temp7-name = `Notebook Basic 17`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1002`.
    temp7-name = `Notebook Basic 18`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1003`.
    temp7-name = `Notebook Basic 19`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1007`.
    temp7-name = `ITelO Vault`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1010`.
    temp7-name = `Notebook Professional 15`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1011`.
    temp7-name = `Notebook Professional 17`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1020`.
    temp7-name = `ITelO Vault Net`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1021`.
    temp7-name = `ITelO Vault SAT`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1022`.
    temp7-name = `Comfort Easy`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1023`.
    temp7-name = `Comfort Senior`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1030`.
    temp7-name = `Ergo Screen E-I`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1031`.
    temp7-name = `Ergo Screen E-II`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1032`.
    temp7-name = `Ergo Screen E-III`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1035`.
    temp7-name = `Flat Basic`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1036`.
    temp7-name = `Flat Future`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1037`.
    temp7-name = `Flat XL`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1040`.
    temp7-name = `Laser Professional Eco`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1041`.
    temp7-name = `Laser Basic`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1042`.
    temp7-name = `Laser Allround`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1050`.
    temp7-name = `Ultra Jet Super Color`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1051`.
    temp7-name = `Ultra Jet Mobile`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1052`.
    temp7-name = `Ultra Jet Super Highspeed`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1055`.
    temp7-name = `Multi Print`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1056`.
    temp7-name = `Multi Color`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1060`.
    temp7-name = `Cordless Mouse`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1061`.
    temp7-name = `Speed Mouse`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1062`.
    temp7-name = `Track Mouse`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1063`.
    temp7-name = `Ergonomic Keyboard`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1064`.
    temp7-name = `Internet Keyboard`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1065`.
    temp7-name = `Media Keyboard`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1066`.
    temp7-name = `Mousepad`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1067`.
    temp7-name = `Ergo Mousepad`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1068`.
    temp7-name = `Designer Mousepad`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1069`.
    temp7-name = `Universal card reader`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1070`.
    temp7-name = `Proctra X`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1071`.
    temp7-name = `Gladiator MX`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1072`.
    temp7-name = `Hurricane GX`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1073`.
    temp7-name = `Hurricane GX/LN`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1080`.
    temp7-name = `Photo Scan`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1081`.
    temp7-name = `Power Scan`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1082`.
    temp7-name = `Jet Scan Professional`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1083`.
    temp7-name = `Jet Scan Professional`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1085`.
    temp7-name = `Copymaster`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1090`.
    temp7-name = `Surround Sound`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1091`.
    temp7-name = `Blaster Extreme`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1092`.
    temp7-name = `Sound Booster`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1095`.
    temp7-name = `Lovely Sound 5.1 Wireless`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1096`.
    temp7-name = `Lovely Sound 5.1`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1097`.
    temp7-name = `Lovely Sound Stereo`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1100`.
    temp7-name = `Smart Office`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1101`.
    temp7-name = `Smart Design`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1102`.
    temp7-name = `Smart Network`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1103`.
    temp7-name = `Smart Multimedia`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1104`.
    temp7-name = `Smart Games`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1105`.
    temp7-name = `Smart Internet Antivirus`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1106`.
    temp7-name = `Smart Firewall`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1107`.
    temp7-name = `Smart Money`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1110`.
    temp7-name = `PC Lock`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1111`.
    temp7-name = `Notebook Lock`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1112`.
    temp7-name = `Web cam reality`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1113`.
    temp7-name = `Screen clean`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1114`.
    temp7-name = `Fabric bag professional`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1115`.
    temp7-name = `Wireless DSL Router`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1116`.
    temp7-name = `Wireless DSL Router / Repeater`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1117`.
    temp7-name = `Wireless DSL Router / Repeater and Print Server`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1118`.
    temp7-name = `USB Stick`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1119`.
    temp7-name = `Travel Adapter`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1120`.
    temp7-name = `Cordless Bluetooth Keyboard, english international`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1137`.
    temp7-name = `Flat XXL`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1138`.
    temp7-name = `Pocket Mouse`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1210`.
    temp7-name = `PC Power Station`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1251`.
    temp7-name = `Astro Laptop 1516`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1252`.
    temp7-name = `Astro Phone 6`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1253`.
    temp7-name = `Benda Laptop 1408`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1254`.
    temp7-name = `Bending Screen 21HD`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1255`.
    temp7-name = `Broad Screen 22HD`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1256`.
    temp7-name = `Cerdik Phone 7`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1257`.
    temp7-name = `Cepat Tablet 10.5`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1258`.
    temp7-name = `Cepat Tablet 8`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1500`.
    temp7-name = `Server Basic`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1501`.
    temp7-name = `Server Professional`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1502`.
    temp7-name = `Server Power Pro`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1600`.
    temp7-name = `Family PC Basic`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1601`.
    temp7-name = `Family PC Pro`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1602`.
    temp7-name = `Gaming Monster`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-1603`.
    temp7-name = `Gaming Monster Pro`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-2000`.
    temp7-name = `7" Widescreen Portable DVD Player w MP3`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-2001`.
    temp7-name = `10" Portable DVD player`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-2002`.
    temp7-name = `Portable DVD Player with 9" LCD Monitor`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-2025`.
    temp7-name = `CD/DVD case: 264 sleeves`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-2026`.
    temp7-name = `Audio/Video Cable Kit - 4m`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-2027`.
    temp7-name = `Removable CD/DVD Laser Labels`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-6100`.
    temp7-name = `Beam Breaker B-1`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-6101`.
    temp7-name = `Beam Breaker B-2`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-6102`.
    temp7-name = `Beam Breaker B-3`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-6110`.
    temp7-name = `Play Movie`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-6111`.
    temp7-name = `Record Movie`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-6120`.
    temp7-name = `ITelo MusicStick`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-6121`.
    temp7-name = `ITelo Jog-Mate`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-6122`.
    temp7-name = `Power Pro Player 40`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-6123`.
    temp7-name = `Power Pro Player 80`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-6130`.
    temp7-name = `Flat Watch HD32`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-6131`.
    temp7-name = `Flat Watch HD37`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-6132`.
    temp7-name = `Flat Watch HD41`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-7000`.
    temp7-name = `Copperberry`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-7010`.
    temp7-name = `Silverberry`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-7020`.
    temp7-name = `Goldberry`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-7030`.
    temp7-name = `Platinberry`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-8000`.
    temp7-name = `ITelO FlexTop I4000`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-8001`.
    temp7-name = `ITelO FlexTop I6300c`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-8002`.
    temp7-name = `ITelO FlexTop I9100`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-8003`.
    temp7-name = `ITelO FlexTop I9800`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-9991`.
    temp7-name = `Smartphone Leather Case`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-9992`.
    temp7-name = `Smartphone Alpha`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-9993`.
    temp7-name = `Mini Tablet`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-9994`.
    temp7-name = `Camcorder View`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-9995`.
    temp7-name = `Tablet Pouch`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-9996`.
    temp7-name = `Tablet Pouch`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-9997`.
    temp7-name = `e-Book Reader ReadMe`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-9998`.
    temp7-name = `Smartphone Beta`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `HT-9999`.
    temp7-name = `Maxi Tablet`.
    INSERT temp7 INTO TABLE temp6.
    temp7-productid = `PF-1000`.
    temp7-name = `Flyer`.
    INSERT temp7 INTO TABLE temp6.
    t_products = temp6.

  ENDMETHOD.

ENDCLASS.
