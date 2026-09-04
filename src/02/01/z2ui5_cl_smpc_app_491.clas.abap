" @keywords multicombobox multi combo box sap.m multicomboboxclearicon verticallayout item
" @summary The multi combo box control can show 'clear' icon, which when pressed will remove the user's input.
CLASS z2ui5_cl_smpc_app_491 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             productid TYPE string,
             name      TYPE string,
           END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

    DATA t_products     TYPE ty_t_product.
    DATA t_selected_key TYPE string_table.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_491 IMPLEMENTATION.

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
    INSERT `MESSAGE_TOAST` INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    INSERT `Event 'selectionChange': {0?Selected:Deselected} '{1}'` INTO TABLE temp1.
    INSERT `${$parameters>/selected}` INTO TABLE temp1.
    INSERT `${$parameters>/changedItem}.getText()` INTO TABLE temp1.
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
                " handleSelectionChange toasts the changed item and its new state -
                " composed on the client from the two event parameters
                )->a( n = `selectionChange` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                          t_arg = temp1 )
                " handleSelectionFinish lists every selected item; a UI5 expression has
                " no loop, so the selection travels as the bound selectedKeys and ABAP
                " builds the same line
                )->a( n = `selectionFinish` v = client->_event( `SELECTION_FINISH` )
                )->a( n = `selectedKeys`    v = client->_bind( t_selected_key )
                )->a( n = `showClearIcon`   v = `true`
                )->a( n = `width`           v = `350px`
                )->a( n = `items`           v = |\{ path: '{ client->_bind_path( t_products ) }', sorter: \{ path: 'NAME' \} \}|

                )->tag( n = `Item` ns = `core`
                    )->a( n = `key`  v = `{PRODUCTID}`
                    )->a( n = `text` v = `{NAME}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
      DATA list TYPE string.
      DATA key LIKE LINE OF t_selected_key.
        DATA temp3 TYPE string.
        DATA temp4 TYPE z2ui5_cl_smpc_app_491=>ty_s_product.

    IF client->get_event( ) = `SELECTION_FINISH`.

      " "Event 'selectionFinished': ['A','B']" - the texts of the selected keys in
      " SELECTION order: the original reads the selectedItems event parameter, which
      " MultiComboBox fills by addAssociation per pick, so looping the bound keys
      " (not the product table) is what reproduces it - the app-281 form
      
      list = ``.
      
      LOOP AT t_selected_key INTO key.
        IF list IS NOT INITIAL.
          list = list && `,`.
        ENDIF.
        
        CLEAR temp3.
        
        READ TABLE t_products INTO temp4 WITH KEY productid = key.
        IF sy-subrc = 0.
          temp3 = temp4-name.
        ENDIF.
        list = list && |'{ temp3 }'|.
      ENDLOOP.

      client->message_toast_display( text = |Event 'selectionFinished': [{ list }]| width = `auto` ).

    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " full mock /ProductCollection of ui5/mock/products.json (the bound fields)
    DATA temp5 TYPE z2ui5_cl_smpc_app_491=>ty_t_product.
    DATA temp6 LIKE LINE OF temp5.
    CLEAR temp5.
    
    temp6-productid = `HT-1000`.
    temp6-name = `Notebook Basic 15`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1001`.
    temp6-name = `Notebook Basic 17`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1002`.
    temp6-name = `Notebook Basic 18`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1003`.
    temp6-name = `Notebook Basic 19`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1007`.
    temp6-name = `ITelO Vault`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1010`.
    temp6-name = `Notebook Professional 15`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1011`.
    temp6-name = `Notebook Professional 17`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1020`.
    temp6-name = `ITelO Vault Net`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1021`.
    temp6-name = `ITelO Vault SAT`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1022`.
    temp6-name = `Comfort Easy`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1023`.
    temp6-name = `Comfort Senior`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1030`.
    temp6-name = `Ergo Screen E-I`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1031`.
    temp6-name = `Ergo Screen E-II`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1032`.
    temp6-name = `Ergo Screen E-III`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1035`.
    temp6-name = `Flat Basic`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1036`.
    temp6-name = `Flat Future`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1037`.
    temp6-name = `Flat XL`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1040`.
    temp6-name = `Laser Professional Eco`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1041`.
    temp6-name = `Laser Basic`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1042`.
    temp6-name = `Laser Allround`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1050`.
    temp6-name = `Ultra Jet Super Color`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1051`.
    temp6-name = `Ultra Jet Mobile`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1052`.
    temp6-name = `Ultra Jet Super Highspeed`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1055`.
    temp6-name = `Multi Print`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1056`.
    temp6-name = `Multi Color`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1060`.
    temp6-name = `Cordless Mouse`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1061`.
    temp6-name = `Speed Mouse`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1062`.
    temp6-name = `Track Mouse`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1063`.
    temp6-name = `Ergonomic Keyboard`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1064`.
    temp6-name = `Internet Keyboard`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1065`.
    temp6-name = `Media Keyboard`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1066`.
    temp6-name = `Mousepad`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1067`.
    temp6-name = `Ergo Mousepad`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1068`.
    temp6-name = `Designer Mousepad`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1069`.
    temp6-name = `Universal card reader`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1070`.
    temp6-name = `Proctra X`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1071`.
    temp6-name = `Gladiator MX`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1072`.
    temp6-name = `Hurricane GX`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1073`.
    temp6-name = `Hurricane GX/LN`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1080`.
    temp6-name = `Photo Scan`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1081`.
    temp6-name = `Power Scan`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1082`.
    temp6-name = `Jet Scan Professional`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1083`.
    temp6-name = `Jet Scan Professional`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1085`.
    temp6-name = `Copymaster`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1090`.
    temp6-name = `Surround Sound`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1091`.
    temp6-name = `Blaster Extreme`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1092`.
    temp6-name = `Sound Booster`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1095`.
    temp6-name = `Lovely Sound 5.1 Wireless`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1096`.
    temp6-name = `Lovely Sound 5.1`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1097`.
    temp6-name = `Lovely Sound Stereo`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1100`.
    temp6-name = `Smart Office`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1101`.
    temp6-name = `Smart Design`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1102`.
    temp6-name = `Smart Network`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1103`.
    temp6-name = `Smart Multimedia`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1104`.
    temp6-name = `Smart Games`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1105`.
    temp6-name = `Smart Internet Antivirus`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1106`.
    temp6-name = `Smart Firewall`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1107`.
    temp6-name = `Smart Money`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1110`.
    temp6-name = `PC Lock`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1111`.
    temp6-name = `Notebook Lock`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1112`.
    temp6-name = `Web cam reality`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1113`.
    temp6-name = `Screen clean`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1114`.
    temp6-name = `Fabric bag professional`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1115`.
    temp6-name = `Wireless DSL Router`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1116`.
    temp6-name = `Wireless DSL Router / Repeater`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1117`.
    temp6-name = `Wireless DSL Router / Repeater and Print Server`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1118`.
    temp6-name = `USB Stick`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1119`.
    temp6-name = `Travel Adapter`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1120`.
    temp6-name = `Cordless Bluetooth Keyboard, english international`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1137`.
    temp6-name = `Flat XXL`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1138`.
    temp6-name = `Pocket Mouse`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1210`.
    temp6-name = `PC Power Station`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1251`.
    temp6-name = `Astro Laptop 1516`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1252`.
    temp6-name = `Astro Phone 6`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1253`.
    temp6-name = `Benda Laptop 1408`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1254`.
    temp6-name = `Bending Screen 21HD`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1255`.
    temp6-name = `Broad Screen 22HD`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1256`.
    temp6-name = `Cerdik Phone 7`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1257`.
    temp6-name = `Cepat Tablet 10.5`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1258`.
    temp6-name = `Cepat Tablet 8`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1500`.
    temp6-name = `Server Basic`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1501`.
    temp6-name = `Server Professional`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1502`.
    temp6-name = `Server Power Pro`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1600`.
    temp6-name = `Family PC Basic`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1601`.
    temp6-name = `Family PC Pro`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1602`.
    temp6-name = `Gaming Monster`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-1603`.
    temp6-name = `Gaming Monster Pro`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-2000`.
    temp6-name = `7" Widescreen Portable DVD Player w MP3`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-2001`.
    temp6-name = `10" Portable DVD player`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-2002`.
    temp6-name = `Portable DVD Player with 9" LCD Monitor`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-2025`.
    temp6-name = `CD/DVD case: 264 sleeves`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-2026`.
    temp6-name = `Audio/Video Cable Kit - 4m`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-2027`.
    temp6-name = `Removable CD/DVD Laser Labels`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-6100`.
    temp6-name = `Beam Breaker B-1`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-6101`.
    temp6-name = `Beam Breaker B-2`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-6102`.
    temp6-name = `Beam Breaker B-3`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-6110`.
    temp6-name = `Play Movie`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-6111`.
    temp6-name = `Record Movie`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-6120`.
    temp6-name = `ITelo MusicStick`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-6121`.
    temp6-name = `ITelo Jog-Mate`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-6122`.
    temp6-name = `Power Pro Player 40`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-6123`.
    temp6-name = `Power Pro Player 80`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-6130`.
    temp6-name = `Flat Watch HD32`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-6131`.
    temp6-name = `Flat Watch HD37`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-6132`.
    temp6-name = `Flat Watch HD41`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-7000`.
    temp6-name = `Copperberry`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-7010`.
    temp6-name = `Silverberry`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-7020`.
    temp6-name = `Goldberry`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-7030`.
    temp6-name = `Platinberry`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-8000`.
    temp6-name = `ITelO FlexTop I4000`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-8001`.
    temp6-name = `ITelO FlexTop I6300c`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-8002`.
    temp6-name = `ITelO FlexTop I9100`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-8003`.
    temp6-name = `ITelO FlexTop I9800`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-9991`.
    temp6-name = `Smartphone Leather Case`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-9992`.
    temp6-name = `Smartphone Alpha`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-9993`.
    temp6-name = `Mini Tablet`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-9994`.
    temp6-name = `Camcorder View`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-9995`.
    temp6-name = `Tablet Pouch`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-9996`.
    temp6-name = `Tablet Pouch`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-9997`.
    temp6-name = `e-Book Reader ReadMe`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-9998`.
    temp6-name = `Smartphone Beta`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `HT-9999`.
    temp6-name = `Maxi Tablet`.
    INSERT temp6 INTO TABLE temp5.
    temp6-productid = `PF-1000`.
    temp6-name = `Flyer`.
    INSERT temp6 INTO TABLE temp5.
    t_products = temp5.

  ENDMETHOD.

ENDCLASS.
