" @keywords list sap.m listswipe standardlistitem button
" @summary With a swipe gesture you can show additional content for an item without having to navigate to a detail page. This feature is only available for touch devices.
CLASS z2ui5_cl_smpc_app_497 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             name          TYPE string,
             productid     TYPE string,
             productpicurl TYPE string,
           END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

    DATA t_products  TYPE ty_t_product.
    DATA swipe_text  TYPE string VALUE `Approve`.
    DATA swipe_type  TYPE string VALUE `Accept`.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_497 IMPLEMENTATION.

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
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( `List`
            )->a( n = `headerText` v = `Products`
            )->a( n = `items`      v = client->_bind( t_products )
            " handleSwipe rewrites the swipe button and toasts the direction - the
            " direction travels to the backend, which writes the two bound properties
            )->a( n = `swipe`      v = client->_event( val = `SWIPE` arg = `${$parameters>/swipeDirection}` )

            )->tag( `StandardListItem`
                )->a( n = `title`            v = `{NAME}`
                )->a( n = `description`      v = `{PRODUCTID}`
                )->a( n = `icon`             v = `{PRODUCTPICURL}`
                )->a( n = `iconDensityAware` v = `false`
                )->a( n = `iconInset`        v = `false`

            )->ele( `swipeContent`
                " handleReject removes the swiped item and swipes out; the row index
                " travels with the press
                )->tag( `Button`
                    )->a( n = `text`  v = client->_bind( swipe_text )
                    )->a( n = `type`  v = client->_bind( swipe_type )
                    )->a( n = `press` v = client->_event( val = `REJECT` arg = `$event.oSource.getParent().indexOfItem($event.oSource.getParent().getSwipedItem())` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA temp1 TYPE i.
        DATA index LIKE temp1.

    CASE client->get_event( ).

      WHEN `SWIPE`.
        " BeginToEnd -> Approve/Accept, otherwise Disapprove/Reject
        IF client->get_event_arg( ) = `BeginToEnd`.
          swipe_text = `Approve`.
          swipe_type = `Accept`.
          client->message_toast_display( `Swipe direction is from the beginning to the end (left ro right in LTR languages)` ).
        ELSE.
          swipe_text = `Disapprove`.
          swipe_type = `Reject`.
          client->message_toast_display( `Swipe direction is from the end to the beginning (right to left in LTR languages)` ).
        ENDIF.

      WHEN `REJECT`.
        
        temp1 = client->get_event_arg( ).
        
        index = temp1.
        IF index >= 0 AND index < lines( t_products ).
          DELETE t_products INDEX index + 1.
        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " full mock /ProductCollection of ui5/mock/products.json (the bound fields)
    DATA temp2 TYPE z2ui5_cl_smpc_app_497=>ty_t_product.
    DATA temp3 LIKE LINE OF temp2.
    CLEAR temp2.
    
    temp3-name = `Notebook Basic 15`.
    temp3-productid = `HT-1000`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Notebook Basic 17`.
    temp3-productid = `HT-1001`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1001.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Notebook Basic 18`.
    temp3-productid = `HT-1002`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1002.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Notebook Basic 19`.
    temp3-productid = `HT-1003`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1003.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `ITelO Vault`.
    temp3-productid = `HT-1007`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1007.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Notebook Professional 15`.
    temp3-productid = `HT-1010`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Notebook Professional 17`.
    temp3-productid = `HT-1011`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1011.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `ITelO Vault Net`.
    temp3-productid = `HT-1020`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1020.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `ITelO Vault SAT`.
    temp3-productid = `HT-1021`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1021.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Comfort Easy`.
    temp3-productid = `HT-1022`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1022.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Comfort Senior`.
    temp3-productid = `HT-1023`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1023.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Ergo Screen E-I`.
    temp3-productid = `HT-1030`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1030.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Ergo Screen E-II`.
    temp3-productid = `HT-1031`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1031.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Ergo Screen E-III`.
    temp3-productid = `HT-1032`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1032.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Flat Basic`.
    temp3-productid = `HT-1035`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1035.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Flat Future`.
    temp3-productid = `HT-1036`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1036.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Flat XL`.
    temp3-productid = `HT-1037`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1037.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Laser Professional Eco`.
    temp3-productid = `HT-1040`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1040.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Laser Basic`.
    temp3-productid = `HT-1041`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1041.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Laser Allround`.
    temp3-productid = `HT-1042`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1042.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Ultra Jet Super Color`.
    temp3-productid = `HT-1050`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1050.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Ultra Jet Mobile`.
    temp3-productid = `HT-1051`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1051.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Ultra Jet Super Highspeed`.
    temp3-productid = `HT-1052`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1052.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Multi Print`.
    temp3-productid = `HT-1055`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1055.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Multi Color`.
    temp3-productid = `HT-1056`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1056.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Cordless Mouse`.
    temp3-productid = `HT-1060`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1060.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Speed Mouse`.
    temp3-productid = `HT-1061`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1061.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Track Mouse`.
    temp3-productid = `HT-1062`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1062.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Ergonomic Keyboard`.
    temp3-productid = `HT-1063`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1063.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Internet Keyboard`.
    temp3-productid = `HT-1064`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1064.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Media Keyboard`.
    temp3-productid = `HT-1065`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1065.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Mousepad`.
    temp3-productid = `HT-1066`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1066.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Ergo Mousepad`.
    temp3-productid = `HT-1067`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1067.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Designer Mousepad`.
    temp3-productid = `HT-1068`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1068.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Universal card reader`.
    temp3-productid = `HT-1069`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1069.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Proctra X`.
    temp3-productid = `HT-1070`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1070.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Gladiator MX`.
    temp3-productid = `HT-1071`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1071.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Hurricane GX`.
    temp3-productid = `HT-1072`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1072.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Hurricane GX/LN`.
    temp3-productid = `HT-1073`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1073.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Photo Scan`.
    temp3-productid = `HT-1080`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1080.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Power Scan`.
    temp3-productid = `HT-1081`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1081.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Jet Scan Professional`.
    temp3-productid = `HT-1082`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1082.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Jet Scan Professional`.
    temp3-productid = `HT-1083`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1083.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Copymaster`.
    temp3-productid = `HT-1085`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1085.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Surround Sound`.
    temp3-productid = `HT-1090`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1090.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Blaster Extreme`.
    temp3-productid = `HT-1091`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1091.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Sound Booster`.
    temp3-productid = `HT-1092`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1092.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Lovely Sound 5.1 Wireless`.
    temp3-productid = `HT-1095`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1095.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Lovely Sound 5.1`.
    temp3-productid = `HT-1096`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1096.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Lovely Sound Stereo`.
    temp3-productid = `HT-1097`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1097.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Smart Office`.
    temp3-productid = `HT-1100`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1100.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Smart Design`.
    temp3-productid = `HT-1101`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1101.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Smart Network`.
    temp3-productid = `HT-1102`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1102.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Smart Multimedia`.
    temp3-productid = `HT-1103`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1103.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Smart Games`.
    temp3-productid = `HT-1104`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1104.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Smart Internet Antivirus`.
    temp3-productid = `HT-1105`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1105.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Smart Firewall`.
    temp3-productid = `HT-1106`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1106.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Smart Money`.
    temp3-productid = `HT-1107`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1107.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `PC Lock`.
    temp3-productid = `HT-1110`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1110.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Notebook Lock`.
    temp3-productid = `HT-1111`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1111.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Web cam reality`.
    temp3-productid = `HT-1112`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1112.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Screen clean`.
    temp3-productid = `HT-1113`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1113.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Fabric bag professional`.
    temp3-productid = `HT-1114`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1114.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Wireless DSL Router`.
    temp3-productid = `HT-1115`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1115.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Wireless DSL Router / Repeater`.
    temp3-productid = `HT-1116`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1116.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Wireless DSL Router / Repeater and Print Server`.
    temp3-productid = `HT-1117`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1117.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `USB Stick`.
    temp3-productid = `HT-1118`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1118.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Travel Adapter`.
    temp3-productid = `HT-1119`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1119.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Cordless Bluetooth Keyboard, english international`.
    temp3-productid = `HT-1120`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1120.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Flat XXL`.
    temp3-productid = `HT-1137`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1137.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Pocket Mouse`.
    temp3-productid = `HT-1138`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1138.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `PC Power Station`.
    temp3-productid = `HT-1210`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1210.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Astro Laptop 1516`.
    temp3-productid = `HT-1251`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1251.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Astro Phone 6`.
    temp3-productid = `HT-1252`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1252.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Benda Laptop 1408`.
    temp3-productid = `HT-1253`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1253.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Bending Screen 21HD`.
    temp3-productid = `HT-1254`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1254.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Broad Screen 22HD`.
    temp3-productid = `HT-1255`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1255.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Cerdik Phone 7`.
    temp3-productid = `HT-1256`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1256.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Cepat Tablet 10.5`.
    temp3-productid = `HT-1257`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1257.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Cepat Tablet 8`.
    temp3-productid = `HT-1258`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1258.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Server Basic`.
    temp3-productid = `HT-1500`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1500.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Server Professional`.
    temp3-productid = `HT-1501`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1501.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Server Power Pro`.
    temp3-productid = `HT-1502`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1502.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Family PC Basic`.
    temp3-productid = `HT-1600`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1600.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Family PC Pro`.
    temp3-productid = `HT-1601`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1601.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Gaming Monster`.
    temp3-productid = `HT-1602`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1602.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Gaming Monster Pro`.
    temp3-productid = `HT-1603`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1603.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `7" Widescreen Portable DVD Player w MP3`.
    temp3-productid = `HT-2000`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2000.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `10" Portable DVD player`.
    temp3-productid = `HT-2001`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2001.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Portable DVD Player with 9" LCD Monitor`.
    temp3-productid = `HT-2002`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2002.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `CD/DVD case: 264 sleeves`.
    temp3-productid = `HT-2025`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2025.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Audio/Video Cable Kit - 4m`.
    temp3-productid = `HT-2026`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2026.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Removable CD/DVD Laser Labels`.
    temp3-productid = `HT-2027`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2027.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Beam Breaker B-1`.
    temp3-productid = `HT-6100`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6100.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Beam Breaker B-2`.
    temp3-productid = `HT-6101`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6101.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Beam Breaker B-3`.
    temp3-productid = `HT-6102`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6102.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Play Movie`.
    temp3-productid = `HT-6110`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6110.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Record Movie`.
    temp3-productid = `HT-6111`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6111.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `ITelo MusicStick`.
    temp3-productid = `HT-6120`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6120.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `ITelo Jog-Mate`.
    temp3-productid = `HT-6121`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6121.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Power Pro Player 40`.
    temp3-productid = `HT-6122`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6122.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Power Pro Player 80`.
    temp3-productid = `HT-6123`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6123.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Flat Watch HD32`.
    temp3-productid = `HT-6130`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6130.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Flat Watch HD37`.
    temp3-productid = `HT-6131`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6131.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Flat Watch HD41`.
    temp3-productid = `HT-6132`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6132.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Copperberry`.
    temp3-productid = `HT-7000`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7000.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Silverberry`.
    temp3-productid = `HT-7010`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7010.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Goldberry`.
    temp3-productid = `HT-7020`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7020.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Platinberry`.
    temp3-productid = `HT-7030`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7030.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `ITelO FlexTop I4000`.
    temp3-productid = `HT-8000`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8000.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `ITelO FlexTop I6300c`.
    temp3-productid = `HT-8001`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8001.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `ITelO FlexTop I9100`.
    temp3-productid = `HT-8002`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8002.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `ITelO FlexTop I9800`.
    temp3-productid = `HT-8003`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8003.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Smartphone Leather Case`.
    temp3-productid = `HT-9991`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9991.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Smartphone Alpha`.
    temp3-productid = `HT-9992`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9992.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Mini Tablet`.
    temp3-productid = `HT-9993`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9993.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Camcorder View`.
    temp3-productid = `HT-9994`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9994.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Tablet Pouch`.
    temp3-productid = `HT-9995`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9995.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Tablet Pouch`.
    temp3-productid = `HT-9996`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9996.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `e-Book Reader ReadMe`.
    temp3-productid = `HT-9997`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9997.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Smartphone Beta`.
    temp3-productid = `HT-9998`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9998.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Maxi Tablet`.
    temp3-productid = `HT-9999`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9999.jpg`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Flyer`.
    temp3-productid = `PF-1000`.
    temp3-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/PF-1000.jpg`.
    INSERT temp3 INTO TABLE temp2.
    t_products = temp2.

  ENDMETHOD.

ENDCLASS.
