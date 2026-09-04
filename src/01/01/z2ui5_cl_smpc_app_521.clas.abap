" @keywords input sap.m inputkeyvalue verticallayout label listitem text selectdialog standardlistitem
" @summary This sample illustrates how the Input works with key and value values, when the data is available via list of suggestions.
CLASS z2ui5_cl_smpc_app_521 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             name          TYPE string,
             productid     TYPE string,
             productpicurl TYPE string,
           END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

    DATA t_products TYPE ty_t_product.
    DATA value        TYPE string.
    DATA selected_key TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popup_value_help_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_521 IMPLEMENTATION.

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

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->tag( `Label`
                )->a( n = `text`     v = `Product`
                )->a( n = `labelFor` v = `productInput`
            " onValueHelpRequest loads ValueHelpDialog.fragment.xml, pre-filters it by
            " the input's value and opens it - the same fragment via popup_display
            )->ele( `Input`
                )->a( n = `id`                     v = `productInput`
                )->a( n = `textFormatMode`         v = `KeyValue`
                " selectedKey is bindable, and a property-binding update calls the
                " control's own setSelectedKey (ManagedObjectBindingSupport), so the
                " KeyValue rendering `(HT-1000) Notebook Basic 15` comes out of the
                " model - and survives a view rebuild, which a control call would not
                )->a( n = `selectedKey`            v = client->_bind( selected_key )
                )->a( n = `placeholder`            v = `Enter product`
                )->a( n = `showSuggestion`         v = `true`
                )->a( n = `showValueHelp`          v = `true`
                )->a( n = `value`                  v = client->_bind( value )
                )->a( n = `valueHelpRequest`       v = client->_event( `VALUE_HELP` )
                )->a( n = `suggestionItems`        v = client->_bind( t_products )
                " onSuggestionItemSelected shows the picked item's key
                )->a( n = `suggestionItemSelected` v = client->_event( val = `ITEM_SELECTED` arg = `${$parameters>/selectedItem}.getKey()` )

                )->ele( `suggestionItems`
                    )->tag( n = `ListItem` ns = `core`
                        )->a( n = `key`            v = `{PRODUCTID}`
                        )->a( n = `text`           v = `{NAME}`
                        )->a( n = `additionalText` v = `{PRODUCTID}`

                )->end(
            )->end(

            )->tag( `Label`
                )->a( n = `text`     v = `Selected Key`
                )->a( n = `labelFor` v = `selectedKey`
            )->tag( `Text`
                )->a( n = `id`   v = `selectedKeyIndicator`
                )->a( n = `text` v = client->_bind( selected_key ) ).

    client->view_display( view->stringify( ) ).

    " onInit: oModel.setSizeLimit(100000) - without it the JSONModel caps a bound
    " aggregation at 100 and the last 23 of the 123 products never reach the
    " suggestion list (the app-252 / app-444 idiom)
    
    CLEAR temp1.
    INSERT `100000` INTO TABLE temp1.
    INSERT client->cs_view-main INTO TABLE temp1.
    client->follow_up_action( val   = client->cs_event-set_size_limit
                              t_arg = temp1 ).

  ENDMETHOD.


  METHOD on_event.
          DATA temp3 TYPE string_table.
        DATA term TYPE string.
        DATA temp5 TYPE string_table.
        DATA picked_key TYPE string.

    CASE client->get_event( ).

      WHEN `VALUE_HELP`.
        popup_value_help_display( ).
        " the original pre-filters the dialog by the input's current value
        IF value IS NOT INITIAL.
          
          CLEAR temp3.
          INSERT `selectDialog` INTO TABLE temp3.
          INSERT `items` INTO TABLE temp3.
          INSERT `filter` INTO TABLE temp3.
          INSERT `NAME` INTO TABLE temp3.
          INSERT `Contains` INTO TABLE temp3.
          INSERT value INTO TABLE temp3.
          client->follow_up_action( val   = client->cs_event-binding_call
                                    t_arg = temp3 ).
        ENDIF.

      WHEN `VALUE_HELP_SEARCH`.
        
        term = client->get_event_arg( ).
        
        CLEAR temp5.
        INSERT `selectDialog` INTO TABLE temp5.
        INSERT `items` INTO TABLE temp5.
        INSERT `filter` INTO TABLE temp5.
        INSERT `NAME` INTO TABLE temp5.
        INSERT `Contains` INTO TABLE temp5.
        INSERT term INTO TABLE temp5.
        client->follow_up_action( val   = client->cs_event-binding_call
                                  t_arg = temp5 ).

      WHEN `ITEM_SELECTED`.
        selected_key = client->get_event_arg( ).

      WHEN `VALUE_HELP_CLOSE`.
        " onValueHelpDialogClose reads the item's DESCRIPTION - the ProductId - and
        " writes it to BOTH setSelectedKey on the Input and setText on the indicator
        
        picked_key = client->get_event_arg( ).
        IF picked_key IS NOT INITIAL.
          " one field drives both: the Input's selectedKey (which renders the
          " `(key) text` form) and the indicator Text - the original sets both to
          " the same description, and a suggestion pick lands on the same value
          selected_key = picked_key.
        ENDIF.
        client->popup_destroy( ).

    ENDCASE.

  ENDMETHOD.


  METHOD popup_value_help_display.

    DATA popup TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp7 TYPE string_table.
    popup = z2ui5_cl_ui5_view_builder=>factory( ).

    popup->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->ele( `SelectDialog`
            )->a( n = `id`      v = `selectDialog`
            )->a( n = `title`   v = `Products`
            )->a( n = `items`   v = client->_bind( t_products )
            )->a( n = `search`  v = client->_event( val = `VALUE_HELP_SEARCH` arg = `${$parameters>/value}` )
            )->a( n = `confirm` v = client->_event( val = `VALUE_HELP_CLOSE` arg = `${$parameters>/selectedItem}.getDescription()` )
            )->a( n = `cancel`  v = client->_event( `VALUE_HELP_CLOSE` )

            )->tag( `StandardListItem`
                )->a( n = `icon`             v = `{PRODUCTPICURL}`
                )->a( n = `iconDensityAware` v = `false`
                )->a( n = `iconInset`        v = `false`
                )->a( n = `title`            v = `{NAME}`
                )->a( n = `description`      v = `{PRODUCTID}` ).

    client->popup_display( popup->stringify( ) ).

    " the popup slot keeps its own model, so the raised limit has to be repeated
    " for it or the dialog itself stops at 100 rows
    
    CLEAR temp7.
    INSERT `100000` INTO TABLE temp7.
    INSERT client->cs_view-popup INTO TABLE temp7.
    client->follow_up_action( val   = client->cs_event-set_size_limit
                              t_arg = temp7 ).

  ENDMETHOD.


  METHOD model_init.

    " full mock /ProductCollection of ui5/mock/products.json (the bound fields);
    " the original raises the model's size limit so every row is offered
    DATA temp9 TYPE z2ui5_cl_smpc_app_521=>ty_t_product.
    DATA temp10 LIKE LINE OF temp9.
    CLEAR temp9.
    
    temp10-name = `Notebook Basic 15`.
    temp10-productid = `HT-1000`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Notebook Basic 17`.
    temp10-productid = `HT-1001`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1001.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Notebook Basic 18`.
    temp10-productid = `HT-1002`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1002.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Notebook Basic 19`.
    temp10-productid = `HT-1003`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1003.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `ITelO Vault`.
    temp10-productid = `HT-1007`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1007.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Notebook Professional 15`.
    temp10-productid = `HT-1010`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Notebook Professional 17`.
    temp10-productid = `HT-1011`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1011.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `ITelO Vault Net`.
    temp10-productid = `HT-1020`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1020.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `ITelO Vault SAT`.
    temp10-productid = `HT-1021`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1021.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Comfort Easy`.
    temp10-productid = `HT-1022`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1022.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Comfort Senior`.
    temp10-productid = `HT-1023`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1023.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Ergo Screen E-I`.
    temp10-productid = `HT-1030`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1030.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Ergo Screen E-II`.
    temp10-productid = `HT-1031`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1031.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Ergo Screen E-III`.
    temp10-productid = `HT-1032`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1032.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Flat Basic`.
    temp10-productid = `HT-1035`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1035.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Flat Future`.
    temp10-productid = `HT-1036`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1036.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Flat XL`.
    temp10-productid = `HT-1037`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1037.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Laser Professional Eco`.
    temp10-productid = `HT-1040`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1040.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Laser Basic`.
    temp10-productid = `HT-1041`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1041.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Laser Allround`.
    temp10-productid = `HT-1042`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1042.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Ultra Jet Super Color`.
    temp10-productid = `HT-1050`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1050.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Ultra Jet Mobile`.
    temp10-productid = `HT-1051`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1051.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Ultra Jet Super Highspeed`.
    temp10-productid = `HT-1052`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1052.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Multi Print`.
    temp10-productid = `HT-1055`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1055.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Multi Color`.
    temp10-productid = `HT-1056`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1056.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Cordless Mouse`.
    temp10-productid = `HT-1060`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1060.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Speed Mouse`.
    temp10-productid = `HT-1061`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1061.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Track Mouse`.
    temp10-productid = `HT-1062`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1062.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Ergonomic Keyboard`.
    temp10-productid = `HT-1063`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1063.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Internet Keyboard`.
    temp10-productid = `HT-1064`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1064.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Media Keyboard`.
    temp10-productid = `HT-1065`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1065.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Mousepad`.
    temp10-productid = `HT-1066`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1066.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Ergo Mousepad`.
    temp10-productid = `HT-1067`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1067.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Designer Mousepad`.
    temp10-productid = `HT-1068`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1068.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Universal card reader`.
    temp10-productid = `HT-1069`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1069.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Proctra X`.
    temp10-productid = `HT-1070`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1070.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Gladiator MX`.
    temp10-productid = `HT-1071`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1071.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Hurricane GX`.
    temp10-productid = `HT-1072`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1072.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Hurricane GX/LN`.
    temp10-productid = `HT-1073`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1073.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Photo Scan`.
    temp10-productid = `HT-1080`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1080.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Power Scan`.
    temp10-productid = `HT-1081`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1081.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Jet Scan Professional`.
    temp10-productid = `HT-1082`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1082.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Jet Scan Professional`.
    temp10-productid = `HT-1083`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1083.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Copymaster`.
    temp10-productid = `HT-1085`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1085.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Surround Sound`.
    temp10-productid = `HT-1090`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1090.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Blaster Extreme`.
    temp10-productid = `HT-1091`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1091.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Sound Booster`.
    temp10-productid = `HT-1092`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1092.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Lovely Sound 5.1 Wireless`.
    temp10-productid = `HT-1095`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1095.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Lovely Sound 5.1`.
    temp10-productid = `HT-1096`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1096.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Lovely Sound Stereo`.
    temp10-productid = `HT-1097`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1097.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Smart Office`.
    temp10-productid = `HT-1100`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1100.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Smart Design`.
    temp10-productid = `HT-1101`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1101.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Smart Network`.
    temp10-productid = `HT-1102`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1102.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Smart Multimedia`.
    temp10-productid = `HT-1103`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1103.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Smart Games`.
    temp10-productid = `HT-1104`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1104.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Smart Internet Antivirus`.
    temp10-productid = `HT-1105`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1105.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Smart Firewall`.
    temp10-productid = `HT-1106`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1106.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Smart Money`.
    temp10-productid = `HT-1107`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1107.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `PC Lock`.
    temp10-productid = `HT-1110`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1110.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Notebook Lock`.
    temp10-productid = `HT-1111`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1111.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Web cam reality`.
    temp10-productid = `HT-1112`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1112.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Screen clean`.
    temp10-productid = `HT-1113`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1113.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Fabric bag professional`.
    temp10-productid = `HT-1114`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1114.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Wireless DSL Router`.
    temp10-productid = `HT-1115`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1115.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Wireless DSL Router / Repeater`.
    temp10-productid = `HT-1116`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1116.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Wireless DSL Router / Repeater and Print Server`.
    temp10-productid = `HT-1117`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1117.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `USB Stick`.
    temp10-productid = `HT-1118`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1118.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Travel Adapter`.
    temp10-productid = `HT-1119`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1119.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Cordless Bluetooth Keyboard, english international`.
    temp10-productid = `HT-1120`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1120.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Flat XXL`.
    temp10-productid = `HT-1137`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1137.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Pocket Mouse`.
    temp10-productid = `HT-1138`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1138.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `PC Power Station`.
    temp10-productid = `HT-1210`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1210.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Astro Laptop 1516`.
    temp10-productid = `HT-1251`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1251.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Astro Phone 6`.
    temp10-productid = `HT-1252`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1252.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Benda Laptop 1408`.
    temp10-productid = `HT-1253`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1253.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Bending Screen 21HD`.
    temp10-productid = `HT-1254`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1254.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Broad Screen 22HD`.
    temp10-productid = `HT-1255`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1255.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Cerdik Phone 7`.
    temp10-productid = `HT-1256`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1256.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Cepat Tablet 10.5`.
    temp10-productid = `HT-1257`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1257.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Cepat Tablet 8`.
    temp10-productid = `HT-1258`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1258.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Server Basic`.
    temp10-productid = `HT-1500`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1500.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Server Professional`.
    temp10-productid = `HT-1501`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1501.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Server Power Pro`.
    temp10-productid = `HT-1502`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1502.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Family PC Basic`.
    temp10-productid = `HT-1600`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1600.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Family PC Pro`.
    temp10-productid = `HT-1601`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1601.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Gaming Monster`.
    temp10-productid = `HT-1602`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1602.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Gaming Monster Pro`.
    temp10-productid = `HT-1603`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1603.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `7" Widescreen Portable DVD Player w MP3`.
    temp10-productid = `HT-2000`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2000.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `10" Portable DVD player`.
    temp10-productid = `HT-2001`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2001.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Portable DVD Player with 9" LCD Monitor`.
    temp10-productid = `HT-2002`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2002.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `CD/DVD case: 264 sleeves`.
    temp10-productid = `HT-2025`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2025.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Audio/Video Cable Kit - 4m`.
    temp10-productid = `HT-2026`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2026.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Removable CD/DVD Laser Labels`.
    temp10-productid = `HT-2027`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2027.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Beam Breaker B-1`.
    temp10-productid = `HT-6100`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6100.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Beam Breaker B-2`.
    temp10-productid = `HT-6101`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6101.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Beam Breaker B-3`.
    temp10-productid = `HT-6102`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6102.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Play Movie`.
    temp10-productid = `HT-6110`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6110.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Record Movie`.
    temp10-productid = `HT-6111`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6111.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `ITelo MusicStick`.
    temp10-productid = `HT-6120`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6120.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `ITelo Jog-Mate`.
    temp10-productid = `HT-6121`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6121.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Power Pro Player 40`.
    temp10-productid = `HT-6122`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6122.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Power Pro Player 80`.
    temp10-productid = `HT-6123`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6123.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Flat Watch HD32`.
    temp10-productid = `HT-6130`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6130.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Flat Watch HD37`.
    temp10-productid = `HT-6131`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6131.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Flat Watch HD41`.
    temp10-productid = `HT-6132`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6132.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Copperberry`.
    temp10-productid = `HT-7000`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7000.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Silverberry`.
    temp10-productid = `HT-7010`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7010.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Goldberry`.
    temp10-productid = `HT-7020`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7020.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Platinberry`.
    temp10-productid = `HT-7030`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7030.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `ITelO FlexTop I4000`.
    temp10-productid = `HT-8000`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8000.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `ITelO FlexTop I6300c`.
    temp10-productid = `HT-8001`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8001.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `ITelO FlexTop I9100`.
    temp10-productid = `HT-8002`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8002.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `ITelO FlexTop I9800`.
    temp10-productid = `HT-8003`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8003.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Smartphone Leather Case`.
    temp10-productid = `HT-9991`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9991.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Smartphone Alpha`.
    temp10-productid = `HT-9992`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9992.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Mini Tablet`.
    temp10-productid = `HT-9993`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9993.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Camcorder View`.
    temp10-productid = `HT-9994`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9994.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Tablet Pouch`.
    temp10-productid = `HT-9995`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9995.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Tablet Pouch`.
    temp10-productid = `HT-9996`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9996.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `e-Book Reader ReadMe`.
    temp10-productid = `HT-9997`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9997.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Smartphone Beta`.
    temp10-productid = `HT-9998`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9998.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Maxi Tablet`.
    temp10-productid = `HT-9999`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9999.jpg`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Flyer`.
    temp10-productid = `PF-1000`.
    temp10-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/PF-1000.jpg`.
    INSERT temp10 INTO TABLE temp9.
    t_products = temp9.

  ENDMETHOD.

ENDCLASS.
