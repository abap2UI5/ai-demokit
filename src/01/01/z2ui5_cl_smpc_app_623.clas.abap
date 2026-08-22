" @keywords input sap.m inputstates label selectdialog standardlistitem
" @summary This example demonstrates the different input field states, e.g. disabled, editable, with value help and value help only.
CLASS z2ui5_cl_smpc_app_623 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             name      TYPE string,
             productid TYPE string,
             picurl    TYPE string,
           END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

    DATA t_products TYPE ty_t_product.
    DATA value_help TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    " PROTECTED, not PRIVATE: the app's state is serialized into the draft with
    " CALL TRANSFORMATION id, and the transpiled runtime's re-implementation of
    " it walks the attributes with a dynamic ASSIGN obj->(name), which cannot
    " reach a PRIVATE one - it asserts, and every roundtrip 500s with
    " ASSERTION_FAILED (e2e-caught 2026-08-22)
    DATA t_all TYPE ty_t_product.

    METHODS view_display.
    METHODS on_event.
    METHODS popup_valuehelp_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_623 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->ele( n = `content` ns = `l`

                )->tag( `Label`
                    )->a( n = `text`     v = `Product not editable`
                    )->a( n = `labelFor` v = `InputNoEdit`
                )->tag( `Input`
                    )->a( n = `id`          v = `InputNoEdit`
                    )->a( n = `class`       v = `sapUiSmallMarginBottom`
                    )->a( n = `type`        v = `Text`
                    )->a( n = `placeholder` v = `Product`
                    )->a( n = `enabled`     v = `true`
                    )->a( n = `editable`    v = `false`

                )->tag( `Label`
                    )->a( n = `text`     v = `Product not enabled`
                    )->a( n = `labelFor` v = `InputDisabled`
                )->tag( `Input`
                    )->a( n = `id`          v = `InputDisabled`
                    )->a( n = `class`       v = `sapUiSmallMarginBottom`
                    )->a( n = `type`        v = `Text`
                    )->a( n = `placeholder` v = `Product`
                    )->a( n = `enabled`     v = `false`

                )->tag( `Label`
                    )->a( n = `text`     v = `Product editable`
                    )->a( n = `labelFor` v = `InputEdit`
                )->tag( `Input`
                    )->a( n = `id`          v = `InputEdit`
                    )->a( n = `class`       v = `sapUiSmallMarginBottom`
                    )->a( n = `type`        v = `Text`
                    )->a( n = `placeholder` v = `Enter product`
                    )->a( n = `enabled`     v = `true`
                    )->a( n = `editable`    v = `true`

                )->tag( `Label`
                    )->a( n = `text`     v = `Product with Value Help`
                    )->a( n = `labelFor` v = `InputValueHelp`
                " handleValueHelp opens the SelectDialog fragment; the picked
                " product's title goes back into THIS input (see sidecar)
                )->tag( `Input`
                    )->a( n = `id`               v = `InputValueHelp`
                    )->a( n = `class`            v = `sapUiSmallMarginBottom`
                    )->a( n = `type`             v = `Text`
                    )->a( n = `placeholder`      v = `Enter product`
                    )->a( n = `enabled`          v = `true`
                    )->a( n = `editable`         v = `true`
                    )->a( n = `showValueHelp`    v = `true`
                    )->a( n = `value`            v = client->_bind( value_help )
                    )->a( n = `valueHelpRequest` v = client->_event( `VALUE_HELP` )

            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `VALUE_HELP`.
        popup_valuehelp_display( ).

      WHEN `VH_SEARCH`.
        " _handleValueHelpSearch: a Name Contains filter on the dialog's items
        DATA(query) = client->get_event_arg( ).
        t_products = t_all.
        IF query IS NOT INITIAL.
          DELETE t_products WHERE name NS query.
        ENDIF.
        popup_valuehelp_display( ).

      WHEN `VH_CONFIRM`.
        " _handleValueHelpClose: the picked title goes into the input, and the
        " dialog's filter is cleared for the next open
        value_help = client->get_event_arg( ).
        t_products = t_all.
        client->popup_destroy( ).

      WHEN `VH_CANCEL`.
        t_products = t_all.
        client->popup_destroy( ).

    ENDCASE.

  ENDMETHOD.


  METHOD popup_valuehelp_display.

    " Dialog.fragment.xml, loaded once and kept as a view dependent upstream;
    " expressed as a core:FragmentDefinition shown through popup_display
    DATA(popup) = z2ui5_cl_ui5_view_builder=>factory( ).

    popup->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns`      v = `sap.m`

        )->ele( `SelectDialog`
            )->a( n = `title`   v = `Products`
            )->a( n = `items`   v = client->_bind( t_products )
            )->a( n = `search`  v = client->_event( val   = `VH_SEARCH`
                                                     t_arg = VALUE #( ( `${$parameters>/value}` ) ) )
            )->a( n = `confirm` v = client->_event( val   = `VH_CONFIRM`
                                                     t_arg = VALUE #( ( `${$parameters>/selectedItem}.getTitle()` ) ) )
            )->a( n = `cancel`  v = client->_event( `VH_CANCEL` )

            )->ele( `items`
                )->tag( `StandardListItem`
                    )->a( n = `icon`             v = `{PICURL}`
                    )->a( n = `iconDensityAware` v = `false`
                    )->a( n = `iconInset`        v = `false`
                    )->a( n = `title`            v = `{NAME}`
                    )->a( n = `description`      v = `{PRODUCTID}` ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " sap/ui/demo/mock/products.json /ProductCollection - the dialog's list
    t_all = VALUE #(
      ( name = `Notebook Basic 15` productid = `HT-1000`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg` )
      ( name = `Notebook Basic 17` productid = `HT-1001`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1001.jpg` )
      ( name = `Notebook Basic 18` productid = `HT-1002`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1002.jpg` )
      ( name = `Notebook Basic 19` productid = `HT-1003`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1003.jpg` )
      ( name = `ITelO Vault` productid = `HT-1007`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1007.jpg` )
      ( name = `Notebook Professional 15` productid = `HT-1010`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg` )
      ( name = `Notebook Professional 17` productid = `HT-1011`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1011.jpg` )
      ( name = `ITelO Vault Net` productid = `HT-1020`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1020.jpg` )
      ( name = `ITelO Vault SAT` productid = `HT-1021`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1021.jpg` )
      ( name = `Comfort Easy` productid = `HT-1022`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1022.jpg` )
      ( name = `Comfort Senior` productid = `HT-1023`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1023.jpg` )
      ( name = `Ergo Screen E-I` productid = `HT-1030`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1030.jpg` )
      ( name = `Ergo Screen E-II` productid = `HT-1031`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1031.jpg` )
      ( name = `Ergo Screen E-III` productid = `HT-1032`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1032.jpg` )
      ( name = `Flat Basic` productid = `HT-1035`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1035.jpg` )
      ( name = `Flat Future` productid = `HT-1036`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1036.jpg` )
      ( name = `Flat XL` productid = `HT-1037`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1037.jpg` )
      ( name = `Laser Professional Eco` productid = `HT-1040`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1040.jpg` )
      ( name = `Laser Basic` productid = `HT-1041`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1041.jpg` )
      ( name = `Laser Allround` productid = `HT-1042`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1042.jpg` )
      ( name = `Ultra Jet Super Color` productid = `HT-1050`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1050.jpg` )
      ( name = `Ultra Jet Mobile` productid = `HT-1051`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1051.jpg` )
      ( name = `Ultra Jet Super Highspeed` productid = `HT-1052`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1052.jpg` )
      ( name = `Multi Print` productid = `HT-1055`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1055.jpg` )
      ( name = `Multi Color` productid = `HT-1056`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1056.jpg` )
      ( name = `Cordless Mouse` productid = `HT-1060`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1060.jpg` )
      ( name = `Speed Mouse` productid = `HT-1061`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1061.jpg` )
      ( name = `Track Mouse` productid = `HT-1062`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1062.jpg` )
      ( name = `Ergonomic Keyboard` productid = `HT-1063`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1063.jpg` )
      ( name = `Internet Keyboard` productid = `HT-1064`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1064.jpg` )
      ( name = `Media Keyboard` productid = `HT-1065`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1065.jpg` )
      ( name = `Mousepad` productid = `HT-1066`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1066.jpg` )
      ( name = `Ergo Mousepad` productid = `HT-1067`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1067.jpg` )
      ( name = `Designer Mousepad` productid = `HT-1068`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1068.jpg` )
      ( name = `Universal card reader` productid = `HT-1069`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1069.jpg` )
      ( name = `Proctra X` productid = `HT-1070`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1070.jpg` )
      ( name = `Gladiator MX` productid = `HT-1071`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1071.jpg` )
      ( name = `Hurricane GX` productid = `HT-1072`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1072.jpg` )
      ( name = `Hurricane GX/LN` productid = `HT-1073`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1073.jpg` )
      ( name = `Photo Scan` productid = `HT-1080`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1080.jpg` )
      ( name = `Power Scan` productid = `HT-1081`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1081.jpg` )
      ( name = `Jet Scan Professional` productid = `HT-1082`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1082.jpg` )
      ( name = `Jet Scan Professional` productid = `HT-1083`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1083.jpg` )
      ( name = `Copymaster` productid = `HT-1085`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1085.jpg` )
      ( name = `Surround Sound` productid = `HT-1090`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1090.jpg` )
      ( name = `Blaster Extreme` productid = `HT-1091`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1091.jpg` )
      ( name = `Sound Booster` productid = `HT-1092`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1092.jpg` )
      ( name = `Lovely Sound 5.1 Wireless` productid = `HT-1095`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1095.jpg` )
      ( name = `Lovely Sound 5.1` productid = `HT-1096`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1096.jpg` )
      ( name = `Lovely Sound Stereo` productid = `HT-1097`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1097.jpg` )
      ( name = `Smart Office` productid = `HT-1100`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1100.jpg` )
      ( name = `Smart Design` productid = `HT-1101`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1101.jpg` )
      ( name = `Smart Network` productid = `HT-1102`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1102.jpg` )
      ( name = `Smart Multimedia` productid = `HT-1103`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1103.jpg` )
      ( name = `Smart Games` productid = `HT-1104`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1104.jpg` )
      ( name = `Smart Internet Antivirus` productid = `HT-1105`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1105.jpg` )
      ( name = `Smart Firewall` productid = `HT-1106`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1106.jpg` )
      ( name = `Smart Money` productid = `HT-1107`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1107.jpg` )
      ( name = `PC Lock` productid = `HT-1110`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1110.jpg` )
      ( name = `Notebook Lock` productid = `HT-1111`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1111.jpg` )
      ( name = `Web cam reality` productid = `HT-1112`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1112.jpg` )
      ( name = `Screen clean` productid = `HT-1113`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1113.jpg` )
      ( name = `Fabric bag professional` productid = `HT-1114`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1114.jpg` )
      ( name = `Wireless DSL Router` productid = `HT-1115`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1115.jpg` )
      ( name = `Wireless DSL Router / Repeater` productid = `HT-1116`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1116.jpg` )
      ( name = `Wireless DSL Router / Repeater and Print Server` productid = `HT-1117`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1117.jpg` )
      ( name = `USB Stick` productid = `HT-1118`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1118.jpg` )
      ( name = `Travel Adapter` productid = `HT-1119`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1119.jpg` )
      ( name = `Cordless Bluetooth Keyboard, english international` productid = `HT-1120`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1120.jpg` )
      ( name = `Flat XXL` productid = `HT-1137`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1137.jpg` )
      ( name = `Pocket Mouse` productid = `HT-1138`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1138.jpg` )
      ( name = `PC Power Station` productid = `HT-1210`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1210.jpg` )
      ( name = `Astro Laptop 1516` productid = `HT-1251`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1251.jpg` )
      ( name = `Astro Phone 6` productid = `HT-1252`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1252.jpg` )
      ( name = `Benda Laptop 1408` productid = `HT-1253`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1253.jpg` )
      ( name = `Bending Screen 21HD` productid = `HT-1254`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1254.jpg` )
      ( name = `Broad Screen 22HD` productid = `HT-1255`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1255.jpg` )
      ( name = `Cerdik Phone 7` productid = `HT-1256`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1256.jpg` )
      ( name = `Cepat Tablet 10.5` productid = `HT-1257`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1257.jpg` )
      ( name = `Cepat Tablet 8` productid = `HT-1258`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1258.jpg` )
      ( name = `Server Basic` productid = `HT-1500`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1500.jpg` )
      ( name = `Server Professional` productid = `HT-1501`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1501.jpg` )
      ( name = `Server Power Pro` productid = `HT-1502`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1502.jpg` )
      ( name = `Family PC Basic` productid = `HT-1600`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1600.jpg` )
      ( name = `Family PC Pro` productid = `HT-1601`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1601.jpg` )
      ( name = `Gaming Monster` productid = `HT-1602`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1602.jpg` )
      ( name = `Gaming Monster Pro` productid = `HT-1603`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1603.jpg` )
      ( name = `7" Widescreen Portable DVD Player w MP3` productid = `HT-2000`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2000.jpg` )
      ( name = `10" Portable DVD player` productid = `HT-2001`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2001.jpg` )
      ( name = `Portable DVD Player with 9" LCD Monitor` productid = `HT-2002`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2002.jpg` )
      ( name = `CD/DVD case: 264 sleeves` productid = `HT-2025`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2025.jpg` )
      ( name = `Audio/Video Cable Kit - 4m` productid = `HT-2026`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2026.jpg` )
      ( name = `Removable CD/DVD Laser Labels` productid = `HT-2027`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2027.jpg` )
      ( name = `Beam Breaker B-1` productid = `HT-6100`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6100.jpg` )
      ( name = `Beam Breaker B-2` productid = `HT-6101`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6101.jpg` )
      ( name = `Beam Breaker B-3` productid = `HT-6102`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6102.jpg` )
      ( name = `Play Movie` productid = `HT-6110`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6110.jpg` )
      ( name = `Record Movie` productid = `HT-6111`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6111.jpg` )
      ( name = `ITelo MusicStick` productid = `HT-6120`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6120.jpg` )
      ( name = `ITelo Jog-Mate` productid = `HT-6121`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6121.jpg` )
      ( name = `Power Pro Player 40` productid = `HT-6122`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6122.jpg` )
      ( name = `Power Pro Player 80` productid = `HT-6123`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6123.jpg` )
      ( name = `Flat Watch HD32` productid = `HT-6130`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6130.jpg` )
      ( name = `Flat Watch HD37` productid = `HT-6131`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6131.jpg` )
      ( name = `Flat Watch HD41` productid = `HT-6132`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6132.jpg` )
      ( name = `Copperberry` productid = `HT-7000`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7000.jpg` )
      ( name = `Silverberry` productid = `HT-7010`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7010.jpg` )
      ( name = `Goldberry` productid = `HT-7020`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7020.jpg` )
      ( name = `Platinberry` productid = `HT-7030`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7030.jpg` )
      ( name = `ITelO FlexTop I4000` productid = `HT-8000`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8000.jpg` )
      ( name = `ITelO FlexTop I6300c` productid = `HT-8001`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8001.jpg` )
      ( name = `ITelO FlexTop I9100` productid = `HT-8002`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8002.jpg` )
      ( name = `ITelO FlexTop I9800` productid = `HT-8003`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8003.jpg` )
      ( name = `Smartphone Leather Case` productid = `HT-9991`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9991.jpg` )
      ( name = `Smartphone Alpha` productid = `HT-9992`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9992.jpg` )
      ( name = `Mini Tablet` productid = `HT-9993`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9993.jpg` )
      ( name = `Camcorder View` productid = `HT-9994`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9994.jpg` )
      ( name = `Tablet Pouch` productid = `HT-9995`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9995.jpg` )
      ( name = `Tablet Pouch` productid = `HT-9996`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9996.jpg` )
      ( name = `e-Book Reader ReadMe` productid = `HT-9997`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9997.jpg` )
      ( name = `Smartphone Beta` productid = `HT-9998`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9998.jpg` )
      ( name = `Maxi Tablet` productid = `HT-9999`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9999.jpg` )
      ( name = `Flyer` productid = `PF-1000`
        picurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/PF-1000.jpg` )
    ).

    t_products = t_all.

  ENDMETHOD.

ENDCLASS.
