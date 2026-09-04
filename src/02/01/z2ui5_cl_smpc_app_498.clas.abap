" @keywords list sap.m listactions overflowtoolbar title toolbarspacer text slider standardlistitem listitemaction
" @summary This example demonstrates how to add custom actions to list items. Dedicated 'Delete' and 'Edit' types can be used to add predefined actions to the list items. The 'Custom' type can be used to add custom actions to the list items.
CLASS z2ui5_cl_smpc_app_498 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             name          TYPE string,
             productid     TYPE string,
             productpicurl TYPE string,
             quantity      TYPE i,
           END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

    DATA t_products   TYPE ty_t_product.
    DATA action_count TYPE i VALUE 2.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_498 IMPLEMENTATION.

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
    INSERT `${$parameters>/action}.getText() || ${$parameters>/action}.getType()` INTO TABLE temp1.
    INSERT `${$parameters>/listItem}.getTitle()` INTO TABLE temp1.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( `List`
            )->a( n = `id`              v = `list`
            )->a( n = `items`           v = client->_bind( t_products )
            )->a( n = `mode`            v = `MultiSelect`
            " onSliderChange calls list.setItemActionCount( value ) - the Slider value
            " and the count are the same two-way bound field here
            )->a( n = `itemActionCount` v = client->_bind( action_count )
            " onItemActionPress toasts the action's text (or its type) and the product
            " of the row - both travel with the event
            )->a( n = `itemActionPress` v = client->_event( val   = `ITEM_ACTION`
                                                            t_arg = temp1 )

            )->ele( `headerToolbar`
                )->ele( `OverflowToolbar`

                    )->tag( `Title`
                        )->a( n = `text`  v = `Products`
                        )->a( n = `level` v = `H2`
                    )->tag( `ToolbarSpacer`
                    )->tag( `Text`
                        )->a( n = `text` v = `Item Action Count: `
                    )->tag( `Slider`
                        )->a( n = `min`             v = `0`
                        )->a( n = `max`             v = `2`
                        )->a( n = `value`           v = client->_bind( action_count )
                        )->a( n = `width`           v = `150px`
                        )->a( n = `enableTickmarks` v = `true`

                )->end(
            )->end(

            )->ele( `StandardListItem`
                )->a( n = `title`       v = `{NAME}`
                )->a( n = `description` v = `{PRODUCTID}`
                )->a( n = `icon`        v = `{PRODUCTPICURL}`
                )->a( n = `counter`     v = `{QUANTITY}`
                )->a( n = `type`        v = `Navigation`

                )->tag( `ListItemAction`
                    )->a( n = `text` v = `Add to Cart`
                    )->a( n = `icon` v = `sap-icon://cart`
                )->tag( `ListItemAction`
                    )->a( n = `text` v = `Bookmark`
                    )->a( n = `icon` v = `sap-icon://bookmark`
                )->tag( `ListItemAction`
                    )->a( n = `type` v = `Edit`
                )->tag( `ListItemAction`
                    )->a( n = `type` v = `Delete` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `ITEM_ACTION`.
      client->message_toast_display( |{ client->get_event_arg( ) } action is pressed for the Product { client->get_event_arg( 2 ) }| ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " full mock /ProductCollection of ui5/mock/products.json (the bound fields)
    DATA temp3 TYPE z2ui5_cl_smpc_app_498=>ty_t_product.
    DATA temp4 LIKE LINE OF temp3.
    CLEAR temp3.
    
    temp4-name = `Notebook Basic 15`.
    temp4-productid = `HT-1000`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg`.
    temp4-quantity = 10.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Basic 17`.
    temp4-productid = `HT-1001`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1001.jpg`.
    temp4-quantity = 20.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Basic 18`.
    temp4-productid = `HT-1002`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1002.jpg`.
    temp4-quantity = 10.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Basic 19`.
    temp4-productid = `HT-1003`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1003.jpg`.
    temp4-quantity = 15.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO Vault`.
    temp4-productid = `HT-1007`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1007.jpg`.
    temp4-quantity = 15.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Professional 15`.
    temp4-productid = `HT-1010`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg`.
    temp4-quantity = 16.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Professional 17`.
    temp4-productid = `HT-1011`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1011.jpg`.
    temp4-quantity = 17.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO Vault Net`.
    temp4-productid = `HT-1020`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1020.jpg`.
    temp4-quantity = 14.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO Vault SAT`.
    temp4-productid = `HT-1021`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1021.jpg`.
    temp4-quantity = 50.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Comfort Easy`.
    temp4-productid = `HT-1022`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1022.jpg`.
    temp4-quantity = 30.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Comfort Senior`.
    temp4-productid = `HT-1023`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1023.jpg`.
    temp4-quantity = 24.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergo Screen E-I`.
    temp4-productid = `HT-1030`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1030.jpg`.
    temp4-quantity = 14.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergo Screen E-II`.
    temp4-productid = `HT-1031`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1031.jpg`.
    temp4-quantity = 24.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergo Screen E-III`.
    temp4-productid = `HT-1032`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1032.jpg`.
    temp4-quantity = 50.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Basic`.
    temp4-productid = `HT-1035`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1035.jpg`.
    temp4-quantity = 23.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Future`.
    temp4-productid = `HT-1036`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1036.jpg`.
    temp4-quantity = 22.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat XL`.
    temp4-productid = `HT-1037`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1037.jpg`.
    temp4-quantity = 23.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Laser Professional Eco`.
    temp4-productid = `HT-1040`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1040.jpg`.
    temp4-quantity = 21.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Laser Basic`.
    temp4-productid = `HT-1041`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1041.jpg`.
    temp4-quantity = 8.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Laser Allround`.
    temp4-productid = `HT-1042`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1042.jpg`.
    temp4-quantity = 9.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ultra Jet Super Color`.
    temp4-productid = `HT-1050`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1050.jpg`.
    temp4-quantity = 17.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ultra Jet Mobile`.
    temp4-productid = `HT-1051`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1051.jpg`.
    temp4-quantity = 18.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ultra Jet Super Highspeed`.
    temp4-productid = `HT-1052`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1052.jpg`.
    temp4-quantity = 25.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Multi Print`.
    temp4-productid = `HT-1055`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1055.jpg`.
    temp4-quantity = 16.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Multi Color`.
    temp4-productid = `HT-1056`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1056.jpg`.
    temp4-quantity = 5.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cordless Mouse`.
    temp4-productid = `HT-1060`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1060.jpg`.
    temp4-quantity = 25.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Speed Mouse`.
    temp4-productid = `HT-1061`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1061.jpg`.
    temp4-quantity = 12.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Track Mouse`.
    temp4-productid = `HT-1062`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1062.jpg`.
    temp4-quantity = 12.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergonomic Keyboard`.
    temp4-productid = `HT-1063`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1063.jpg`.
    temp4-quantity = 50.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Internet Keyboard`.
    temp4-productid = `HT-1064`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1064.jpg`.
    temp4-quantity = 35.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Media Keyboard`.
    temp4-productid = `HT-1065`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1065.jpg`.
    temp4-quantity = 26.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Mousepad`.
    temp4-productid = `HT-1066`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1066.jpg`.
    temp4-quantity = 12.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergo Mousepad`.
    temp4-productid = `HT-1067`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1067.jpg`.
    temp4-quantity = 16.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Designer Mousepad`.
    temp4-productid = `HT-1068`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1068.jpg`.
    temp4-quantity = 26.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Universal card reader`.
    temp4-productid = `HT-1069`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1069.jpg`.
    temp4-quantity = 22.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Proctra X`.
    temp4-productid = `HT-1070`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1070.jpg`.
    temp4-quantity = 15.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Gladiator MX`.
    temp4-productid = `HT-1071`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1071.jpg`.
    temp4-quantity = 16.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Hurricane GX`.
    temp4-productid = `HT-1072`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1072.jpg`.
    temp4-quantity = 13.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Hurricane GX/LN`.
    temp4-productid = `HT-1073`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1073.jpg`.
    temp4-quantity = 5.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Photo Scan`.
    temp4-productid = `HT-1080`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1080.jpg`.
    temp4-quantity = 8.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Power Scan`.
    temp4-productid = `HT-1081`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1081.jpg`.
    temp4-quantity = 11.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Jet Scan Professional`.
    temp4-productid = `HT-1082`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1082.jpg`.
    temp4-quantity = 13.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Jet Scan Professional`.
    temp4-productid = `HT-1083`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1083.jpg`.
    temp4-quantity = 10.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Copymaster`.
    temp4-productid = `HT-1085`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1085.jpg`.
    temp4-quantity = 10.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Surround Sound`.
    temp4-productid = `HT-1090`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1090.jpg`.
    temp4-quantity = 20.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Blaster Extreme`.
    temp4-productid = `HT-1091`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1091.jpg`.
    temp4-quantity = 15.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Sound Booster`.
    temp4-productid = `HT-1092`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1092.jpg`.
    temp4-quantity = 50.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Lovely Sound 5.1 Wireless`.
    temp4-productid = `HT-1095`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1095.jpg`.
    temp4-quantity = 12.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Lovely Sound 5.1`.
    temp4-productid = `HT-1096`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1096.jpg`.
    temp4-quantity = 18.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Lovely Sound Stereo`.
    temp4-productid = `HT-1097`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1097.jpg`.
    temp4-quantity = 21.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Office`.
    temp4-productid = `HT-1100`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1100.jpg`.
    temp4-quantity = 25.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Design`.
    temp4-productid = `HT-1101`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1101.jpg`.
    temp4-quantity = 26.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Network`.
    temp4-productid = `HT-1102`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1102.jpg`.
    temp4-quantity = 28.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Multimedia`.
    temp4-productid = `HT-1103`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1103.jpg`.
    temp4-quantity = 9.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Games`.
    temp4-productid = `HT-1104`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1104.jpg`.
    temp4-quantity = 13.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Internet Antivirus`.
    temp4-productid = `HT-1105`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1105.jpg`.
    temp4-quantity = 17.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Firewall`.
    temp4-productid = `HT-1106`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1106.jpg`.
    temp4-quantity = 19.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Money`.
    temp4-productid = `HT-1107`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1107.jpg`.
    temp4-quantity = 18.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `PC Lock`.
    temp4-productid = `HT-1110`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1110.jpg`.
    temp4-quantity = 14.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Lock`.
    temp4-productid = `HT-1111`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1111.jpg`.
    temp4-quantity = 20.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Web cam reality`.
    temp4-productid = `HT-1112`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1112.jpg`.
    temp4-quantity = 27.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Screen clean`.
    temp4-productid = `HT-1113`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1113.jpg`.
    temp4-quantity = 17.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Fabric bag professional`.
    temp4-productid = `HT-1114`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1114.jpg`.
    temp4-quantity = 14.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Wireless DSL Router`.
    temp4-productid = `HT-1115`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1115.jpg`.
    temp4-quantity = 16.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Wireless DSL Router / Repeater`.
    temp4-productid = `HT-1116`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1116.jpg`.
    temp4-quantity = 12.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Wireless DSL Router / Repeater and Print Server`.
    temp4-productid = `HT-1117`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1117.jpg`.
    temp4-quantity = 12.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `USB Stick`.
    temp4-productid = `HT-1118`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1118.jpg`.
    temp4-quantity = 14.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Travel Adapter`.
    temp4-productid = `HT-1119`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1119.jpg`.
    temp4-quantity = 10.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cordless Bluetooth Keyboard, english international`.
    temp4-productid = `HT-1120`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1120.jpg`.
    temp4-quantity = 13.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat XXL`.
    temp4-productid = `HT-1137`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1137.jpg`.
    temp4-quantity = 10.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Pocket Mouse`.
    temp4-productid = `HT-1138`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1138.jpg`.
    temp4-quantity = 20.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `PC Power Station`.
    temp4-productid = `HT-1210`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1210.jpg`.
    temp4-quantity = 22.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Astro Laptop 1516`.
    temp4-productid = `HT-1251`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1251.jpg`.
    temp4-quantity = 23.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Astro Phone 6`.
    temp4-productid = `HT-1252`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1252.jpg`.
    temp4-quantity = 28.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Benda Laptop 1408`.
    temp4-productid = `HT-1253`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1253.jpg`.
    temp4-quantity = 27.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Bending Screen 21HD`.
    temp4-productid = `HT-1254`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1254.jpg`.
    temp4-quantity = 23.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Broad Screen 22HD`.
    temp4-productid = `HT-1255`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1255.jpg`.
    temp4-quantity = 5.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cerdik Phone 7`.
    temp4-productid = `HT-1256`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1256.jpg`.
    temp4-quantity = 19.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cepat Tablet 10.5`.
    temp4-productid = `HT-1257`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1257.jpg`.
    temp4-quantity = 17.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cepat Tablet 8`.
    temp4-productid = `HT-1258`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1258.jpg`.
    temp4-quantity = 24.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Server Basic`.
    temp4-productid = `HT-1500`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1500.jpg`.
    temp4-quantity = 24.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Server Professional`.
    temp4-productid = `HT-1501`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1501.jpg`.
    temp4-quantity = 26.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Server Power Pro`.
    temp4-productid = `HT-1502`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1502.jpg`.
    temp4-quantity = 34.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Family PC Basic`.
    temp4-productid = `HT-1600`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1600.jpg`.
    temp4-quantity = 10.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Family PC Pro`.
    temp4-productid = `HT-1601`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1601.jpg`.
    temp4-quantity = 20.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Gaming Monster`.
    temp4-productid = `HT-1602`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1602.jpg`.
    temp4-quantity = 24.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Gaming Monster Pro`.
    temp4-productid = `HT-1603`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1603.jpg`.
    temp4-quantity = 25.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `7" Widescreen Portable DVD Player w MP3`.
    temp4-productid = `HT-2000`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2000.jpg`.
    temp4-quantity = 20.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `10" Portable DVD player`.
    temp4-productid = `HT-2001`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2001.jpg`.
    temp4-quantity = 21.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Portable DVD Player with 9" LCD Monitor`.
    temp4-productid = `HT-2002`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2002.jpg`.
    temp4-quantity = 50.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `CD/DVD case: 264 sleeves`.
    temp4-productid = `HT-2025`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2025.jpg`.
    temp4-quantity = 26.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Audio/Video Cable Kit - 4m`.
    temp4-productid = `HT-2026`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2026.jpg`.
    temp4-quantity = 16.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Removable CD/DVD Laser Labels`.
    temp4-productid = `HT-2027`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2027.jpg`.
    temp4-quantity = 25.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Beam Breaker B-1`.
    temp4-productid = `HT-6100`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6100.jpg`.
    temp4-quantity = 32.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Beam Breaker B-2`.
    temp4-productid = `HT-6101`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6101.jpg`.
    temp4-quantity = 18.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Beam Breaker B-3`.
    temp4-productid = `HT-6102`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6102.jpg`.
    temp4-quantity = 16.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Play Movie`.
    temp4-productid = `HT-6110`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6110.jpg`.
    temp4-quantity = 15.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Record Movie`.
    temp4-productid = `HT-6111`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6111.jpg`.
    temp4-quantity = 24.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelo MusicStick`.
    temp4-productid = `HT-6120`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6120.jpg`.
    temp4-quantity = 15.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelo Jog-Mate`.
    temp4-productid = `HT-6121`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6121.jpg`.
    temp4-quantity = 24.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Power Pro Player 40`.
    temp4-productid = `HT-6122`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6122.jpg`.
    temp4-quantity = 23.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Power Pro Player 80`.
    temp4-productid = `HT-6123`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6123.jpg`.
    temp4-quantity = 13.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Watch HD32`.
    temp4-productid = `HT-6130`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6130.jpg`.
    temp4-quantity = 16.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Watch HD37`.
    temp4-productid = `HT-6131`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6131.jpg`.
    temp4-quantity = 14.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Watch HD41`.
    temp4-productid = `HT-6132`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6132.jpg`.
    temp4-quantity = 13.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Copperberry`.
    temp4-productid = `HT-7000`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7000.jpg`.
    temp4-quantity = 5.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Silverberry`.
    temp4-productid = `HT-7010`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7010.jpg`.
    temp4-quantity = 9.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Goldberry`.
    temp4-productid = `HT-7020`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7020.jpg`.
    temp4-quantity = 11.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Platinberry`.
    temp4-productid = `HT-7030`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7030.jpg`.
    temp4-quantity = 12.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO FlexTop I4000`.
    temp4-productid = `HT-8000`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8000.jpg`.
    temp4-quantity = 11.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO FlexTop I6300c`.
    temp4-productid = `HT-8001`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8001.jpg`.
    temp4-quantity = 20.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO FlexTop I9100`.
    temp4-productid = `HT-8002`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8002.jpg`.
    temp4-quantity = 20.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO FlexTop I9800`.
    temp4-productid = `HT-8003`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8003.jpg`.
    temp4-quantity = 22.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smartphone Leather Case`.
    temp4-productid = `HT-9991`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9991.jpg`.
    temp4-quantity = 12.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smartphone Alpha`.
    temp4-productid = `HT-9992`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9992.jpg`.
    temp4-quantity = 13.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Mini Tablet`.
    temp4-productid = `HT-9993`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9993.jpg`.
    temp4-quantity = 10.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Camcorder View`.
    temp4-productid = `HT-9994`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9994.jpg`.
    temp4-quantity = 50.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Tablet Pouch`.
    temp4-productid = `HT-9995`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9995.jpg`.
    temp4-quantity = 34.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Tablet Pouch`.
    temp4-productid = `HT-9996`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9996.jpg`.
    temp4-quantity = 34.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `e-Book Reader ReadMe`.
    temp4-productid = `HT-9997`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9997.jpg`.
    temp4-quantity = 23.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smartphone Beta`.
    temp4-productid = `HT-9998`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9998.jpg`.
    temp4-quantity = 21.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Maxi Tablet`.
    temp4-productid = `HT-9999`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9999.jpg`.
    temp4-quantity = 20.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flyer`.
    temp4-productid = `PF-1000`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/PF-1000.jpg`.
    temp4-quantity = 33.
    INSERT temp4 INTO TABLE temp3.
    t_products = temp3.

  ENDMETHOD.

ENDCLASS.
