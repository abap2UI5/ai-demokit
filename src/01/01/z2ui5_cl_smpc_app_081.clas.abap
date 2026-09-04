" @keywords pulltorefresh pull refresh sap.m list standardlistitem
" @summary With the Pull to Refresh you can trigger an update operation by swiping the current page down on touch devices. On other devices the Pull To Refresh is visible all the time and the user clicks it like a button.
CLASS z2ui5_cl_smpc_app_081 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name            TYPE string,
        product_id      TYPE string,
        product_pic_url TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.
    DATA shown      TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.
    METHODS fill_all RETURNING VALUE(result) LIKE t_products.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_081 IMPLEMENTATION.

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
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( `Page`
            )->a( n = `showHeader` v = `false`

            )->ele( `content`
                )->tag( `PullToRefresh`
                    )->a( n = `id`      v = `pullToRefresh`
                    )->a( n = `refresh` v = client->_event( `REFRESH` )
                )->ele( `List`
                    )->a( n = `id`    v = `list`
                    )->a( n = `items` v = client->_bind( t_products )

                    )->tag( `StandardListItem`
                        )->a( n = `title`            v = `{NAME}`
                        )->a( n = `description`      v = `{PRODUCT_ID}`
                        )->a( n = `icon`             v = `{PRODUCT_PIC_URL}`
                        )->a( n = `iconDensityAware` v = `false`
                        )->a( n = `iconInset`        v = `false`

                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
      DATA temp1 TYPE string_table.
      DATA all TYPE STANDARD TABLE OF z2ui5_cl_smpc_app_081=>ty_s_product WITH DEFAULT KEY.
      DATA temp3 LIKE t_products.
      DATA i TYPE i.
      DATA temp5 LIKE sy-index.
        DATA temp2 LIKE LINE OF all.
        DATA temp4 LIKE sy-tabix.

    IF client->get_event( ) = `REFRESH`.
      " handleRefresh calls pullToRefresh.hide( ) before appending: onclick puts
      " the control in its busy state and only hide( ) resets it, so without
      " this the spinner never goes away after the first pull
      
      CLEAR temp1.
      INSERT `pullToRefresh` INTO TABLE temp1.
      INSERT `hide` INTO TABLE temp1.
      client->follow_up_action( val   = client->cs_event-control_by_id
                                t_arg = temp1 ).

      " _pushNewProduct: each pull-to-refresh appends the next product until the full collection is shown
      
      all = fill_all( ).
      IF shown < lines( all ).
        shown = shown + 1.
      ENDIF.
      
      CLEAR temp3.
      
      i = 1.
      
      temp5 = sy-index.
      WHILE i <= shown.
        sy-index = temp5.
        
        
        temp4 = sy-tabix.
        READ TABLE all INDEX i INTO temp2.
        sy-tabix = temp4.
        IF sy-subrc <> 0.
          ASSERT 1 = 0.
        ENDIF.
        INSERT temp2 INTO TABLE temp3.
        i = i + 1.
      ENDWHILE.
      t_products = temp3.
    ENDIF.

  ENDMETHOD.


  METHOD fill_all.

    " full mock /ProductCollection (sap/ui/demo/mock/products.json); ProductPicUrl resolved to absolute OpenUI5 URLs
    DATA temp6 LIKE result.
    DATA temp7 LIKE LINE OF temp6.
    CLEAR temp6.
    
    temp7-name = `Notebook Basic 15`.
    temp7-product_id = `HT-1000`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Notebook Basic 17`.
    temp7-product_id = `HT-1001`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1001.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Notebook Basic 18`.
    temp7-product_id = `HT-1002`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1002.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Notebook Basic 19`.
    temp7-product_id = `HT-1003`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1003.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `ITelO Vault`.
    temp7-product_id = `HT-1007`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1007.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Notebook Professional 15`.
    temp7-product_id = `HT-1010`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Notebook Professional 17`.
    temp7-product_id = `HT-1011`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1011.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `ITelO Vault Net`.
    temp7-product_id = `HT-1020`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1020.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `ITelO Vault SAT`.
    temp7-product_id = `HT-1021`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1021.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Comfort Easy`.
    temp7-product_id = `HT-1022`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1022.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Comfort Senior`.
    temp7-product_id = `HT-1023`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1023.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Ergo Screen E-I`.
    temp7-product_id = `HT-1030`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1030.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Ergo Screen E-II`.
    temp7-product_id = `HT-1031`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1031.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Ergo Screen E-III`.
    temp7-product_id = `HT-1032`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1032.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Flat Basic`.
    temp7-product_id = `HT-1035`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1035.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Flat Future`.
    temp7-product_id = `HT-1036`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1036.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Flat XL`.
    temp7-product_id = `HT-1037`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1037.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Laser Professional Eco`.
    temp7-product_id = `HT-1040`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1040.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Laser Basic`.
    temp7-product_id = `HT-1041`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1041.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Laser Allround`.
    temp7-product_id = `HT-1042`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1042.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Ultra Jet Super Color`.
    temp7-product_id = `HT-1050`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1050.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Ultra Jet Mobile`.
    temp7-product_id = `HT-1051`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1051.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Ultra Jet Super Highspeed`.
    temp7-product_id = `HT-1052`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1052.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Multi Print`.
    temp7-product_id = `HT-1055`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1055.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Multi Color`.
    temp7-product_id = `HT-1056`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1056.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Cordless Mouse`.
    temp7-product_id = `HT-1060`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1060.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Speed Mouse`.
    temp7-product_id = `HT-1061`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1061.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Track Mouse`.
    temp7-product_id = `HT-1062`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1062.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Ergonomic Keyboard`.
    temp7-product_id = `HT-1063`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1063.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Internet Keyboard`.
    temp7-product_id = `HT-1064`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1064.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Media Keyboard`.
    temp7-product_id = `HT-1065`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1065.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Mousepad`.
    temp7-product_id = `HT-1066`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1066.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Ergo Mousepad`.
    temp7-product_id = `HT-1067`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1067.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Designer Mousepad`.
    temp7-product_id = `HT-1068`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1068.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Universal card reader`.
    temp7-product_id = `HT-1069`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1069.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Proctra X`.
    temp7-product_id = `HT-1070`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1070.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Gladiator MX`.
    temp7-product_id = `HT-1071`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1071.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Hurricane GX`.
    temp7-product_id = `HT-1072`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1072.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Hurricane GX/LN`.
    temp7-product_id = `HT-1073`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1073.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Photo Scan`.
    temp7-product_id = `HT-1080`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1080.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Power Scan`.
    temp7-product_id = `HT-1081`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1081.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Jet Scan Professional`.
    temp7-product_id = `HT-1082`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1082.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Jet Scan Professional`.
    temp7-product_id = `HT-1083`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1083.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Copymaster`.
    temp7-product_id = `HT-1085`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1085.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Surround Sound`.
    temp7-product_id = `HT-1090`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1090.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Blaster Extreme`.
    temp7-product_id = `HT-1091`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1091.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Sound Booster`.
    temp7-product_id = `HT-1092`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1092.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Lovely Sound 5.1 Wireless`.
    temp7-product_id = `HT-1095`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1095.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Lovely Sound 5.1`.
    temp7-product_id = `HT-1096`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1096.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Lovely Sound Stereo`.
    temp7-product_id = `HT-1097`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1097.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Smart Office`.
    temp7-product_id = `HT-1100`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1100.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Smart Design`.
    temp7-product_id = `HT-1101`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1101.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Smart Network`.
    temp7-product_id = `HT-1102`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1102.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Smart Multimedia`.
    temp7-product_id = `HT-1103`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1103.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Smart Games`.
    temp7-product_id = `HT-1104`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1104.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Smart Internet Antivirus`.
    temp7-product_id = `HT-1105`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1105.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Smart Firewall`.
    temp7-product_id = `HT-1106`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1106.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Smart Money`.
    temp7-product_id = `HT-1107`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1107.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `PC Lock`.
    temp7-product_id = `HT-1110`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1110.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Notebook Lock`.
    temp7-product_id = `HT-1111`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1111.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Web cam reality`.
    temp7-product_id = `HT-1112`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1112.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Screen clean`.
    temp7-product_id = `HT-1113`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1113.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Fabric bag professional`.
    temp7-product_id = `HT-1114`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1114.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Wireless DSL Router`.
    temp7-product_id = `HT-1115`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1115.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Wireless DSL Router / Repeater`.
    temp7-product_id = `HT-1116`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1116.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Wireless DSL Router / Repeater and Print Server`.
    temp7-product_id = `HT-1117`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1117.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `USB Stick`.
    temp7-product_id = `HT-1118`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1118.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Travel Adapter`.
    temp7-product_id = `HT-1119`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1119.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Cordless Bluetooth Keyboard, english international`.
    temp7-product_id = `HT-1120`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1120.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Flat XXL`.
    temp7-product_id = `HT-1137`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1137.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Pocket Mouse`.
    temp7-product_id = `HT-1138`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1138.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `PC Power Station`.
    temp7-product_id = `HT-1210`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1210.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Astro Laptop 1516`.
    temp7-product_id = `HT-1251`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1251.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Astro Phone 6`.
    temp7-product_id = `HT-1252`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1252.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Benda Laptop 1408`.
    temp7-product_id = `HT-1253`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1253.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Bending Screen 21HD`.
    temp7-product_id = `HT-1254`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1254.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Broad Screen 22HD`.
    temp7-product_id = `HT-1255`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1255.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Cerdik Phone 7`.
    temp7-product_id = `HT-1256`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1256.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Cepat Tablet 10.5`.
    temp7-product_id = `HT-1257`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1257.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Cepat Tablet 8`.
    temp7-product_id = `HT-1258`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1258.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Server Basic`.
    temp7-product_id = `HT-1500`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1500.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Server Professional`.
    temp7-product_id = `HT-1501`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1501.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Server Power Pro`.
    temp7-product_id = `HT-1502`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1502.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Family PC Basic`.
    temp7-product_id = `HT-1600`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1600.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Family PC Pro`.
    temp7-product_id = `HT-1601`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1601.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Gaming Monster`.
    temp7-product_id = `HT-1602`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1602.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Gaming Monster Pro`.
    temp7-product_id = `HT-1603`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1603.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `7" Widescreen Portable DVD Player w MP3`.
    temp7-product_id = `HT-2000`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2000.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `10" Portable DVD player`.
    temp7-product_id = `HT-2001`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2001.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Portable DVD Player with 9" LCD Monitor`.
    temp7-product_id = `HT-2002`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2002.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `CD/DVD case: 264 sleeves`.
    temp7-product_id = `HT-2025`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2025.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Audio/Video Cable Kit - 4m`.
    temp7-product_id = `HT-2026`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2026.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Removable CD/DVD Laser Labels`.
    temp7-product_id = `HT-2027`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2027.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Beam Breaker B-1`.
    temp7-product_id = `HT-6100`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6100.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Beam Breaker B-2`.
    temp7-product_id = `HT-6101`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6101.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Beam Breaker B-3`.
    temp7-product_id = `HT-6102`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6102.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Play Movie`.
    temp7-product_id = `HT-6110`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6110.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Record Movie`.
    temp7-product_id = `HT-6111`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6111.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `ITelo MusicStick`.
    temp7-product_id = `HT-6120`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6120.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `ITelo Jog-Mate`.
    temp7-product_id = `HT-6121`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6121.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Power Pro Player 40`.
    temp7-product_id = `HT-6122`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6122.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Power Pro Player 80`.
    temp7-product_id = `HT-6123`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6123.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Flat Watch HD32`.
    temp7-product_id = `HT-6130`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6130.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Flat Watch HD37`.
    temp7-product_id = `HT-6131`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6131.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Flat Watch HD41`.
    temp7-product_id = `HT-6132`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6132.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Copperberry`.
    temp7-product_id = `HT-7000`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7000.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Silverberry`.
    temp7-product_id = `HT-7010`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7010.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Goldberry`.
    temp7-product_id = `HT-7020`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7020.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Platinberry`.
    temp7-product_id = `HT-7030`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7030.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `ITelO FlexTop I4000`.
    temp7-product_id = `HT-8000`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8000.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `ITelO FlexTop I6300c`.
    temp7-product_id = `HT-8001`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8001.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `ITelO FlexTop I9100`.
    temp7-product_id = `HT-8002`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8002.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `ITelO FlexTop I9800`.
    temp7-product_id = `HT-8003`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8003.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Smartphone Leather Case`.
    temp7-product_id = `HT-9991`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9991.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Smartphone Alpha`.
    temp7-product_id = `HT-9992`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9992.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Mini Tablet`.
    temp7-product_id = `HT-9993`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9993.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Camcorder View`.
    temp7-product_id = `HT-9994`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9994.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Tablet Pouch`.
    temp7-product_id = `HT-9995`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9995.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Tablet Pouch`.
    temp7-product_id = `HT-9996`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9996.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `e-Book Reader ReadMe`.
    temp7-product_id = `HT-9997`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9997.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Smartphone Beta`.
    temp7-product_id = `HT-9998`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9998.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Maxi Tablet`.
    temp7-product_id = `HT-9999`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9999.jpg`.
    INSERT temp7 INTO TABLE temp6.
    temp7-name = `Flyer`.
    temp7-product_id = `PF-1000`.
    temp7-product_pic_url = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/PF-1000.jpg`.
    INSERT temp7 INTO TABLE temp6.
    result = temp6.

  ENDMETHOD.


  METHOD model_init.
    DATA all TYPE STANDARD TABLE OF z2ui5_cl_smpc_app_081=>ty_s_product WITH DEFAULT KEY.
    DATA temp8 LIKE t_products.
    DATA temp5 LIKE LINE OF all.
    DATA temp6 LIKE sy-tabix.

    " the original starts with an empty model and pushes the first product on init
    shown = 1.
    
    all = fill_all( ).
    
    CLEAR temp8.
    
    
    temp6 = sy-tabix.
    READ TABLE all INDEX 1 INTO temp5.
    sy-tabix = temp6.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    INSERT temp5 INTO TABLE temp8.
    t_products = temp8.

  ENDMETHOD.
ENDCLASS.
