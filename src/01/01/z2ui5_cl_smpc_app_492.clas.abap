" @keywords list sap.m listgrouping overflowtoolbar title toolbarspacer togglebutton menu menuitem
" @summary Grouping your items makes it easier for the user to browse and find the desired content. This example also shows the context menu for the items in the List control.
CLASS z2ui5_cl_smpc_app_492 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             name          TYPE string,
             productid     TYPE string,
             suppliername  TYPE string,
             productpicurl TYPE string,
           END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

    DATA t_products TYPE ty_t_product.
    DATA menu_on    TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_492 IMPLEMENTATION.

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

    DATA(list) = view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        " the grouping sorter is kept 1:1; groupHeaderFactory returns a control and
        " has no backend equivalent, so the default group header renders instead
        )->ele( `List`
            )->a( n = `id`    v = `idList`
            )->a( n = `items` v = |\{ path: '{ client->_bind( val = t_products path = abap_true ) }', sorter: \{ path: 'SUPPLIERNAME', descending: false, group: true \} \}| ).

    list->ele( `headerToolbar`
        )->ele( `OverflowToolbar`

            )->tag( `Title`
                )->a( n = `text` v = `Products`
            )->tag( `ToolbarSpacer`
            " onToggleContextMenu builds a sap.m.Menu on press and destroys it again -
            " the pressed state travels to the backend, which emits the contextMenu
            " subtree below or leaves it out (app 436 precedent)
            )->tag( `ToggleButton`
                )->a( n = `icon`    v = `sap-icon://menu`
                )->a( n = `tooltip` v = `Enable / Disable Custom Context Menu`
                " NOT `b = <field>`: that parameter writes the LITERAL 'true' or
                " 'false' into the attribute at render time (view_builder->a),
                " so a field the event handler changes never reaches the
                " control - none of these apps re-renders after an event
                " (e2e-caught on app 505, 2026-08-22)
                )->a( n = `pressed` v = client->_bind( menu_on )
                )->a( n = `press`   v = client->_event( val   = `TOGGLE_CONTEXT_MENU`
                                                        t_arg = VALUE #( ( `${$parameters>/pressed}` ) ) ) ).

    IF menu_on = abap_true.
      list->ele( `contextMenu`
          )->ele( `Menu`
              )->tag( `MenuItem`
                  )->a( n = `text` v = `{NAME}`
              )->tag( `MenuItem`
                  )->a( n = `text` v = `{PRODUCTID}` ).
    ENDIF.

    list->tag( `StandardListItem`
        )->a( n = `title`            v = `{NAME}`
        )->a( n = `description`      v = `{PRODUCTID}`
        )->a( n = `icon`             v = `{PRODUCTPICURL}`
        )->a( n = `iconDensityAware` v = `false`
        )->a( n = `iconInset`        v = `false` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `TOGGLE_CONTEXT_MENU`.
      menu_on = client->get_event_arg( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " full mock /ProductCollection of ui5/mock/products.json (the bound fields)
    t_products = VALUE #(
        ( name = `Notebook Basic 15`                                  productid = `HT-1000` suppliername = `Very Best Screens` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg` )
        ( name = `Notebook Basic 17`                                  productid = `HT-1001` suppliername = `Very Best Screens` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1001.jpg` )
        ( name = `Notebook Basic 18`                                  productid = `HT-1002` suppliername = `Very Best Screens` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1002.jpg` )
        ( name = `Notebook Basic 19`                                  productid = `HT-1003` suppliername = `Smartcards`        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1003.jpg` )
        ( name = `ITelO Vault`                                        productid = `HT-1007` suppliername = `Technocom`         productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1007.jpg` )
        ( name = `Notebook Professional 15`                           productid = `HT-1010` suppliername = `Very Best Screens` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg` )
        ( name = `Notebook Professional 17`                           productid = `HT-1011` suppliername = `Very Best Screens` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1011.jpg` )
        ( name = `ITelO Vault Net`                                    productid = `HT-1020` suppliername = `Technocom`         productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1020.jpg` )
        ( name = `ITelO Vault SAT`                                    productid = `HT-1021` suppliername = `Technocom`         productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1021.jpg` )
        ( name = `Comfort Easy`                                       productid = `HT-1022` suppliername = `Technocom`         productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1022.jpg` )
        ( name = `Comfort Senior`                                     productid = `HT-1023` suppliername = `Technocom`         productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1023.jpg` )
        ( name = `Ergo Screen E-I`                                    productid = `HT-1030` suppliername = `Very Best Screens` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1030.jpg` )
        ( name = `Ergo Screen E-II`                                   productid = `HT-1031` suppliername = `Very Best Screens` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1031.jpg` )
        ( name = `Ergo Screen E-III`                                  productid = `HT-1032` suppliername = `Very Best Screens` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1032.jpg` )
        ( name = `Flat Basic`                                         productid = `HT-1035` suppliername = `Very Best Screens` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1035.jpg` )
        ( name = `Flat Future`                                        productid = `HT-1036` suppliername = `Very Best Screens` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1036.jpg` )
        ( name = `Flat XL`                                            productid = `HT-1037` suppliername = `Very Best Screens` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1037.jpg` )
        ( name = `Laser Professional Eco`                             productid = `HT-1040` suppliername = `Alpha Printers`    productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1040.jpg` )
        ( name = `Laser Basic`                                        productid = `HT-1041` suppliername = `Alpha Printers`    productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1041.jpg` )
        ( name = `Laser Allround`                                     productid = `HT-1042` suppliername = `Alpha Printers`    productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1042.jpg` )
        ( name = `Ultra Jet Super Color`                              productid = `HT-1050` suppliername = `Alpha Printers`    productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1050.jpg` )
        ( name = `Ultra Jet Mobile`                                   productid = `HT-1051` suppliername = `Printer for All`   productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1051.jpg` )
        ( name = `Ultra Jet Super Highspeed`                          productid = `HT-1052` suppliername = `Printer for All`   productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1052.jpg` )
        ( name = `Multi Print`                                        productid = `HT-1055` suppliername = `Printer for All`   productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1055.jpg` )
        ( name = `Multi Color`                                        productid = `HT-1056` suppliername = `Printer for All`   productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1056.jpg` )
        ( name = `Cordless Mouse`                                     productid = `HT-1060` suppliername = `Oxynum`            productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1060.jpg` )
        ( name = `Speed Mouse`                                        productid = `HT-1061` suppliername = `Oxynum`            productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1061.jpg` )
        ( name = `Track Mouse`                                        productid = `HT-1062` suppliername = `Oxynum`            productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1062.jpg` )
        ( name = `Ergonomic Keyboard`                                 productid = `HT-1063` suppliername = `Oxynum`            productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1063.jpg` )
        ( name = `Internet Keyboard`                                  productid = `HT-1064` suppliername = `Oxynum`            productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1064.jpg` )
        ( name = `Media Keyboard`                                     productid = `HT-1065` suppliername = `Oxynum`            productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1065.jpg` )
        ( name = `Mousepad`                                           productid = `HT-1066` suppliername = `Oxynum`            productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1066.jpg` )
        ( name = `Ergo Mousepad`                                      productid = `HT-1067` suppliername = `Oxynum`            productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1067.jpg` )
        ( name = `Designer Mousepad`                                  productid = `HT-1068` suppliername = `Fasttech`          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1068.jpg` )
        ( name = `Universal card reader`                              productid = `HT-1069` suppliername = `Fasttech`          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1069.jpg` )
        ( name = `Proctra X`                                          productid = `HT-1070` suppliername = `Ultrasonic United` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1070.jpg` )
        ( name = `Gladiator MX`                                       productid = `HT-1071` suppliername = `Ultrasonic United` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1071.jpg` )
        ( name = `Hurricane GX`                                       productid = `HT-1072` suppliername = `Ultrasonic United` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1072.jpg` )
        ( name = `Hurricane GX/LN`                                    productid = `HT-1073` suppliername = `Smartcards`        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1073.jpg` )
        ( name = `Photo Scan`                                         productid = `HT-1080` suppliername = `Printer for All`   productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1080.jpg` )
        ( name = `Power Scan`                                         productid = `HT-1081` suppliername = `Printer for All`   productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1081.jpg` )
        ( name = `Jet Scan Professional`                              productid = `HT-1082` suppliername = `Printer for All`   productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1082.jpg` )
        ( name = `Jet Scan Professional`                              productid = `HT-1083` suppliername = `Printer for All`   productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1083.jpg` )
        ( name = `Copymaster`                                         productid = `HT-1085` suppliername = `Alpha Printers`    productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1085.jpg` )
        ( name = `Surround Sound`                                     productid = `HT-1090` suppliername = `Speaker Experts`   productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1090.jpg` )
        ( name = `Blaster Extreme`                                    productid = `HT-1091` suppliername = `Speaker Experts`   productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1091.jpg` )
        ( name = `Sound Booster`                                      productid = `HT-1092` suppliername = `Speaker Experts`   productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1092.jpg` )
        ( name = `Lovely Sound 5.1 Wireless`                          productid = `HT-1095` suppliername = `Fasttech`          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1095.jpg` )
        ( name = `Lovely Sound 5.1`                                   productid = `HT-1096` suppliername = `Fasttech`          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1096.jpg` )
        ( name = `Lovely Sound Stereo`                                productid = `HT-1097` suppliername = `Fasttech`          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1097.jpg` )
        ( name = `Smart Office`                                       productid = `HT-1100` suppliername = `Technocom`         productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1100.jpg` )
        ( name = `Smart Design`                                       productid = `HT-1101` suppliername = `Technocom`         productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1101.jpg` )
        ( name = `Smart Network`                                      productid = `HT-1102` suppliername = `Technocom`         productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1102.jpg` )
        ( name = `Smart Multimedia`                                   productid = `HT-1103` suppliername = `Technocom`         productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1103.jpg` )
        ( name = `Smart Games`                                        productid = `HT-1104` suppliername = `Technocom`         productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1104.jpg` )
        ( name = `Smart Internet Antivirus`                           productid = `HT-1105` suppliername = `Brainsoft`         productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1105.jpg` )
        ( name = `Smart Firewall`                                     productid = `HT-1106` suppliername = `Brainsoft`         productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1106.jpg` )
        ( name = `Smart Money`                                        productid = `HT-1107` suppliername = `Brainsoft`         productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1107.jpg` )
        ( name = `PC Lock`                                            productid = `HT-1110` suppliername = `Red Point Stores`  productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1110.jpg` )
        ( name = `Notebook Lock`                                      productid = `HT-1111` suppliername = `Red Point Stores`  productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1111.jpg` )
        ( name = `Web cam reality`                                    productid = `HT-1112` suppliername = `Red Point Stores`  productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1112.jpg` )
        ( name = `Screen clean`                                       productid = `HT-1113` suppliername = `Red Point Stores`  productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1113.jpg` )
        ( name = `Fabric bag professional`                            productid = `HT-1114` suppliername = `Red Point Stores`  productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1114.jpg` )
        ( name = `Wireless DSL Router`                                productid = `HT-1115` suppliername = `Red Point Stores`  productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1115.jpg` )
        ( name = `Wireless DSL Router / Repeater`                     productid = `HT-1116` suppliername = `Red Point Stores`  productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1116.jpg` )
        ( name = `Wireless DSL Router / Repeater and Print Server`    productid = `HT-1117` suppliername = `Technocom`         productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1117.jpg` )
        ( name = `USB Stick`                                          productid = `HT-1118` suppliername = `Technocom`         productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1118.jpg` )
        ( name = `Travel Adapter`                                     productid = `HT-1119` suppliername = `Titanium`          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1119.jpg` )
        ( name = `Cordless Bluetooth Keyboard, english international` productid = `HT-1120` suppliername = `Technocom`         productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1120.jpg` )
        ( name = `Flat XXL`                                           productid = `HT-1137` suppliername = `Technocom`         productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1137.jpg` )
        ( name = `Pocket Mouse`                                       productid = `HT-1138` suppliername = `Technocom`         productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1138.jpg` )
        ( name = `PC Power Station`                                   productid = `HT-1210` suppliername = `Technocom`         productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1210.jpg` )
        ( name = `Astro Laptop 1516`                                  productid = `HT-1251` suppliername = `Ultrasonic United` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1251.jpg` )
        ( name = `Astro Phone 6`                                      productid = `HT-1252` suppliername = `Ultrasonic United` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1252.jpg` )
        ( name = `Benda Laptop 1408`                                  productid = `HT-1253` suppliername = `Ultrasonic United` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1253.jpg` )
        ( name = `Bending Screen 21HD`                                productid = `HT-1254` suppliername = `Ultrasonic United` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1254.jpg` )
        ( name = `Broad Screen 22HD`                                  productid = `HT-1255` suppliername = `Ultrasonic United` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1255.jpg` )
        ( name = `Cerdik Phone 7`                                     productid = `HT-1256` suppliername = `Ultrasonic United` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1256.jpg` )
        ( name = `Cepat Tablet 10.5`                                  productid = `HT-1257` suppliername = `Ultrasonic United` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1257.jpg` )
        ( name = `Cepat Tablet 8`                                     productid = `HT-1258` suppliername = `Ultrasonic United` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1258.jpg` )
        ( name = `Server Basic`                                       productid = `HT-1500` suppliername = `Technocom`         productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1500.jpg` )
        ( name = `Server Professional`                                productid = `HT-1501` suppliername = `Technocom`         productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1501.jpg` )
        ( name = `Server Power Pro`                                   productid = `HT-1502` suppliername = `Technocom`         productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1502.jpg` )
        ( name = `Family PC Basic`                                    productid = `HT-1600` suppliername = `Titanium`          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1600.jpg` )
        ( name = `Family PC Pro`                                      productid = `HT-1601` suppliername = `Titanium`          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1601.jpg` )
        ( name = `Gaming Monster`                                     productid = `HT-1602` suppliername = `Titanium`          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1602.jpg` )
        ( name = `Gaming Monster Pro`                                 productid = `HT-1603` suppliername = `Titanium`          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1603.jpg` )
        ( name = `7" Widescreen Portable DVD Player w MP3`            productid = `HT-2000` suppliername = `Titanium`          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2000.jpg` )
        ( name = `10" Portable DVD player`                            productid = `HT-2001` suppliername = `Titanium`          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2001.jpg` )
        ( name = `Portable DVD Player with 9" LCD Monitor`            productid = `HT-2002` suppliername = `Technocom`         productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2002.jpg` )
        ( name = `CD/DVD case: 264 sleeves`                           productid = `HT-2025` suppliername = `Titanium`          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2025.jpg` )
        ( name = `Audio/Video Cable Kit - 4m`                         productid = `HT-2026` suppliername = `Titanium`          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2026.jpg` )
        ( name = `Removable CD/DVD Laser Labels`                      productid = `HT-2027` suppliername = `Titanium`          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2027.jpg` )
        ( name = `Beam Breaker B-1`                                   productid = `HT-6100` suppliername = `Titanium`          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6100.jpg` )
        ( name = `Beam Breaker B-2`                                   productid = `HT-6101` suppliername = `Technocom`         productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6101.jpg` )
        ( name = `Beam Breaker B-3`                                   productid = `HT-6102` suppliername = `Technocom`         productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6102.jpg` )
        ( name = `Play Movie`                                         productid = `HT-6110` suppliername = `Fasttech`          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6110.jpg` )
        ( name = `Record Movie`                                       productid = `HT-6111` suppliername = `Fasttech`          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6111.jpg` )
        ( name = `ITelo MusicStick`                                   productid = `HT-6120` suppliername = `Fasttech`          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6120.jpg` )
        ( name = `ITelo Jog-Mate`                                     productid = `HT-6121` suppliername = `Fasttech`          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6121.jpg` )
        ( name = `Power Pro Player 40`                                productid = `HT-6122` suppliername = `Fasttech`          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6122.jpg` )
        ( name = `Power Pro Player 80`                                productid = `HT-6123` suppliername = `Fasttech`          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6123.jpg` )
        ( name = `Flat Watch HD32`                                    productid = `HT-6130` suppliername = `Very Best Screens` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6130.jpg` )
        ( name = `Flat Watch HD37`                                    productid = `HT-6131` suppliername = `Very Best Screens` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6131.jpg` )
        ( name = `Flat Watch HD41`                                    productid = `HT-6132` suppliername = `Very Best Screens` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6132.jpg` )
        ( name = `Copperberry`                                        productid = `HT-7000` suppliername = `Fasttech`          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7000.jpg` )
        ( name = `Silverberry`                                        productid = `HT-7010` suppliername = `Fasttech`          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7010.jpg` )
        ( name = `Goldberry`                                          productid = `HT-7020` suppliername = `Fasttech`          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7020.jpg` )
        ( name = `Platinberry`                                        productid = `HT-7030` suppliername = `Fasttech`          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7030.jpg` )
        ( name = `ITelO FlexTop I4000`                                productid = `HT-8000` suppliername = `Titanium`          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8000.jpg` )
        ( name = `ITelO FlexTop I6300c`                               productid = `HT-8001` suppliername = `Titanium`          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8001.jpg` )
        ( name = `ITelO FlexTop I9100`                                productid = `HT-8002` suppliername = `Titanium`          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8002.jpg` )
        ( name = `ITelO FlexTop I9800`                                productid = `HT-8003` suppliername = `Titanium`          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8003.jpg` )
        ( name = `Smartphone Leather Case`                            productid = `HT-9991` suppliername = `Ultrasonic United` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9991.jpg` )
        ( name = `Smartphone Alpha`                                   productid = `HT-9992` suppliername = `Ultrasonic United` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9992.jpg` )
        ( name = `Mini Tablet`                                        productid = `HT-9993` suppliername = `Ultrasonic United` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9993.jpg` )
        ( name = `Camcorder View`                                     productid = `HT-9994` suppliername = `Ultrasonic United` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9994.jpg` )
        ( name = `Tablet Pouch`                                       productid = `HT-9995` suppliername = `Titanium`          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9995.jpg` )
        ( name = `Tablet Pouch`                                       productid = `HT-9996` suppliername = `Titanium`          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9996.jpg` )
        ( name = `e-Book Reader ReadMe`                               productid = `HT-9997` suppliername = `Titanium`          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9997.jpg` )
        ( name = `Smartphone Beta`                                    productid = `HT-9998` suppliername = `Titanium`          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9998.jpg` )
        ( name = `Maxi Tablet`                                        productid = `HT-9999` suppliername = `Titanium`          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9999.jpg` )
        ( name = `Flyer`                                              productid = `PF-1000` suppliername = `Titanium`          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/PF-1000.jpg` ) ).

  ENDMETHOD.

ENDCLASS.
