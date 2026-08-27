" @keywords table sap.ui.table menus menu menuitem overflowtoolbar title toolbarspacer togglebutton column label text
" @summary Example which focuses the handling of the table related Menus
CLASS z2ui5_cl_smpc_app_355 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name          TYPE string,
        productid     TYPE string,
        productpicurl TYPE string,
        quantity      TYPE i,
        deliverydate  TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

    " the original's `ui>` model, folded onto the one default model; each flag
    " is shared by its ToggleButton and the Table property it drives, so both
    " toggles work without a round-trip
    DATA show_freeze_menu_entry TYPE abap_bool.
    DATA enable_cell_filter     TYPE abap_bool.
    " onToggleContextMenu's pressed state - the view carries the contextMenu
    " subtree only while it is on, which is setContextMenu / destroyContextMenu
    DATA custom_context_menu    TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_355 IMPLEMENTATION.

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

    " the column-menu demo. The two menu-entry toggles are two-way bound and
    " the Table's enableColumnFreeze / enableCellFilter bind the same fields,
    " so both work entirely on the client - which is what the original's
    " {ui>/...} two-way bindings already do.
    DATA(table) = view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.ui.table`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:u`   v = `sap.ui.unified`
        )->a( n = `xmlns:m`   v = `sap.m`
        )->a( n = `height`    v = `100%`

        )->ele( n = `Page` ns = `m`
            )->a( n = `showHeader`      v = `false`
            )->a( n = `enableScrolling` v = `false`
            )->a( n = `class`           v = `sapUiContentPadding`

            )->ele( n = `content` ns = `m`
                )->ele( `Table`
                    )->a( n = `id`                 v = `table`
                    )->a( n = `selectionMode`      v = `MultiToggle`
                    )->a( n = `rows`               v = client->_bind( t_products )
                    )->a( n = `enableColumnFreeze` v = client->_bind( show_freeze_menu_entry )
                    )->a( n = `enableCellFilter`   v = client->_bind( enable_cell_filter )
                    )->a( n = `ariaLabelledBy`     v = `title` ).

    " onToggleContextMenu: setContextMenu( new sap.m.Menu with two bound
    " MenuItems ) while the toggle is pressed, destroyContextMenu( ) when it is
    " released - the backend emits the subtree or leaves it out (app 436 idiom)
    IF custom_context_menu = abap_true.
      table->ele( `contextMenu`
          )->ele( n = `Menu` ns = `m`
              )->tag( n = `MenuItem` ns = `m`
                  " abap2ui5lint-disable-next-line relative-binding-without-context -- the table sets the menu's context to the clicked row
                  )->a( n = `text` v = `{NAME}`
              )->tag( n = `MenuItem` ns = `m`
                  " abap2ui5lint-disable-next-line relative-binding-without-context -- same row context, the original binds {ProductId}
                  )->a( n = `text` v = `{PRODUCTID}` ).
    ENDIF.

    table->ele( `extension`
        )->ele( n = `OverflowToolbar` ns = `m`
            )->a( n = `style` v = `Clear`

            )->tag( n = `Title` ns = `m`
                )->a( n = `id`   v = `title`
                )->a( n = `text` v = `Products`

            )->tag( n = `ToolbarSpacer` ns = `m`

            )->tag( n = `ToggleButton` ns = `m`
                )->a( n = `icon`    v = `sap-icon://resize-horizontal`
                )->a( n = `tooltip` v = `Enable / Disable Freezing Menu Entries`
                )->a( n = `pressed` v = client->_bind( show_freeze_menu_entry )

            )->tag( n = `ToggleButton` ns = `m`
                )->a( n = `icon`    v = `sap-icon://filter`
                )->a( n = `tooltip` v = `Enable / Disable Cell Filter`
                )->a( n = `pressed` v = client->_bind( enable_cell_filter )

            " NOT `b = <field>`: that parameter writes the LITERAL
            " 'true'/'false' at render time, so a field the event
            " handler changes would never reach the control
            )->tag( n = `ToggleButton` ns = `m`
                )->a( n = `icon`    v = `sap-icon://menu`
                )->a( n = `tooltip` v = `Enable / Disable Custom Context Menu`
                )->a( n = `pressed` v = client->_bind( custom_context_menu )
                )->a( n = `press`   v = client->_event( val   = `TOGGLE_CONTEXT_MENU`
                                                        t_arg = VALUE #( ( `${$parameters>/pressed}` ) ) )

        )->end( ).

    table->ele( `columns`
        )->ele( `Column`
            )->a( n = `id`                  v = `name`
            )->a( n = `width`               v = `11rem`
            )->a( n = `sortProperty`        v = `NAME`
            )->a( n = `filterProperty`      v = `NAME`
            )->a( n = `showFilterMenuEntry` v = `true`
            )->a( n = `showSortMenuEntry`   v = `true`

            )->tag( n = `Label` ns = `m`
                )->a( n = `text` v = `Product Name`

            )->ele( `template`
                )->tag( n = `Text` ns = `m`
                    )->a( n = `text`     v = `{NAME}`
                    )->a( n = `wrapping` v = `false`

            )->end(
        )->end(
        )->ele( `Column`
            )->a( n = `id`             v = `productId`
            )->a( n = `filterProperty` v = `PRODUCTID`
            )->a( n = `sortProperty`   v = `PRODUCTID`
            )->a( n = `width`          v = `11rem`

            )->tag( n = `Label` ns = `m`
                )->a( n = `text` v = `Product Id`

            )->ele( `template`
                )->tag( n = `Text` ns = `m`
                    )->a( n = `text`     v = `{PRODUCTID}`
                    )->a( n = `wrapping` v = `false`

            )->end(
        )->end(
        )->ele( `Column`
            )->a( n = `id`    v = `image`
            )->a( n = `width` v = `9rem`

            )->tag( n = `Label` ns = `m`
                )->a( n = `text` v = `Image`

            )->ele( `template`
                )->tag( n = `Link` ns = `m`
                    )->a( n = `text`   v = `Show Image`
                    )->a( n = `href`   v = `{PRODUCTPICURL}`
                    )->a( n = `target` v = `_blank`

            )->end(
        )->end(
        )->ele( `Column`
            )->a( n = `id`           v = `quantity`
            )->a( n = `width`        v = `6rem`
            )->a( n = `hAlign`       v = `End`
            )->a( n = `sortProperty` v = `QUANTITY`

            )->tag( n = `Label` ns = `m`
                )->a( n = `text` v = `Quantity`

            )->ele( `template`
                )->tag( n = `Label` ns = `m`
                    )->a( n = `text` v = |\{ path: 'QUANTITY', type: 'sap.ui.model.type.Integer' \}|

            )->end(
        )->end(
        )->ele( `Column`
            )->a( n = `width` v = `9rem`

            )->tag( n = `Label` ns = `m`
                )->a( n = `text` v = `Delivery Date`

            )->ele( `template`
                )->tag( n = `Text` ns = `m`
                    )->a( n = `text`     v = |\{ path: 'DELIVERYDATE', type: 'sap.ui.model.type.Date', formatOptions: \{ source: \{ pattern: 'timestamp' \} \} \}|
                    )->a( n = `wrapping` v = `false`

            )->end(
        )->end(
    )->end( ).

    table->ele( `footer`
        )->tag( n = `OverflowToolbar` ns = `m`
            )->a( n = `id` v = `infobar` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    " onToggleContextMenu: the pressed state decides whether the table carries
    " the custom context menu at all
    IF client->get_event( ) = `TOGGLE_CONTEXT_MENU`.
      custom_context_menu = client->get_event_arg( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " the shared 123-row demo ProductCollection (sap/ui/demo/mock/products.json)
    " with the five columns the sample binds. DeliveryDate is Date.now()-derived
    " in the original (i mod 10 offset in 4-day steps); a fixed base (2026-07-23)
    " is used here so the port is deterministic - the corpus convention of app
    " 164. ProductPicUrl values point at the OpenUI5 host per the asset-URL rule
    t_products = VALUE #(
      ( name = `Notebook Basic 15` productid = `HT-1000` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg` quantity = 10 deliverydate = 1784764800000 )
      ( name = `Notebook Basic 17` productid = `HT-1001` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1001.jpg` quantity = 20 deliverydate = 1784419200000 )
      ( name = `Notebook Basic 18` productid = `HT-1002` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1002.jpg` quantity = 10 deliverydate = 1784073600000 )
      ( name = `Notebook Basic 19` productid = `HT-1003` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1003.jpg` quantity = 15 deliverydate = 1783728000000 )
      ( name = `ITelO Vault` productid = `HT-1007` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1007.jpg` quantity = 15 deliverydate = 1783382400000 )
      ( name = `Notebook Professional 15` productid = `HT-1010` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg` quantity = 16 deliverydate = 1783036800000 )
      ( name = `Notebook Professional 17` productid = `HT-1011` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1011.jpg` quantity = 17 deliverydate = 1782691200000 )
      ( name = `ITelO Vault Net` productid = `HT-1020` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1020.jpg` quantity = 14 deliverydate = 1782345600000 )
      ( name = `ITelO Vault SAT` productid = `HT-1021` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1021.jpg` quantity = 50 deliverydate = 1782000000000 )
      ( name = `Comfort Easy` productid = `HT-1022` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1022.jpg` quantity = 30 deliverydate = 1781654400000 )
      ( name = `Comfort Senior` productid = `HT-1023` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1023.jpg` quantity = 24 deliverydate = 1784764800000 )
      ( name = `Ergo Screen E-I` productid = `HT-1030` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1030.jpg` quantity = 14 deliverydate = 1784419200000 )
      ( name = `Ergo Screen E-II` productid = `HT-1031` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1031.jpg` quantity = 24 deliverydate = 1784073600000 )
      ( name = `Ergo Screen E-III` productid = `HT-1032` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1032.jpg` quantity = 50 deliverydate = 1783728000000 )
      ( name = `Flat Basic` productid = `HT-1035` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1035.jpg` quantity = 23 deliverydate = 1783382400000 )
      ( name = `Flat Future` productid = `HT-1036` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1036.jpg` quantity = 22 deliverydate = 1783036800000 )
      ( name = `Flat XL` productid = `HT-1037` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1037.jpg` quantity = 23 deliverydate = 1782691200000 )
      ( name = `Laser Professional Eco` productid = `HT-1040` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1040.jpg` quantity = 21 deliverydate = 1782345600000 )
      ( name = `Laser Basic` productid = `HT-1041` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1041.jpg` quantity = 8 deliverydate = 1782000000000 )
      ( name = `Laser Allround` productid = `HT-1042` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1042.jpg` quantity = 9 deliverydate = 1781654400000 )
      ( name = `Ultra Jet Super Color` productid = `HT-1050` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1050.jpg` quantity = 17 deliverydate = 1784764800000 )
      ( name = `Ultra Jet Mobile` productid = `HT-1051` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1051.jpg` quantity = 18 deliverydate = 1784419200000 )
      ( name = `Ultra Jet Super Highspeed` productid = `HT-1052` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1052.jpg` quantity = 25 deliverydate = 1784073600000 )
      ( name = `Multi Print` productid = `HT-1055` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1055.jpg` quantity = 16 deliverydate = 1783728000000 )
      ( name = `Multi Color` productid = `HT-1056` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1056.jpg` quantity = 5 deliverydate = 1783382400000 )
      ( name = `Cordless Mouse` productid = `HT-1060` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1060.jpg` quantity = 25 deliverydate = 1783036800000 )
      ( name = `Speed Mouse` productid = `HT-1061` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1061.jpg` quantity = 12 deliverydate = 1782691200000 )
      ( name = `Track Mouse` productid = `HT-1062` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1062.jpg` quantity = 12 deliverydate = 1782345600000 )
      ( name = `Ergonomic Keyboard` productid = `HT-1063` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1063.jpg` quantity = 50 deliverydate = 1782000000000 )
      ( name = `Internet Keyboard` productid = `HT-1064` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1064.jpg` quantity = 35 deliverydate = 1781654400000 )
      ( name = `Media Keyboard` productid = `HT-1065` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1065.jpg` quantity = 26 deliverydate = 1784764800000 )
      ( name = `Mousepad` productid = `HT-1066` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1066.jpg` quantity = 12 deliverydate = 1784419200000 )
      ( name = `Ergo Mousepad` productid = `HT-1067` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1067.jpg` quantity = 16 deliverydate = 1784073600000 )
      ( name = `Designer Mousepad` productid = `HT-1068` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1068.jpg` quantity = 26 deliverydate = 1783728000000 )
      ( name = `Universal card reader` productid = `HT-1069` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1069.jpg` quantity = 22 deliverydate = 1783382400000 )
      ( name = `Proctra X` productid = `HT-1070` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1070.jpg` quantity = 15 deliverydate = 1783036800000 )
      ( name = `Gladiator MX` productid = `HT-1071` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1071.jpg` quantity = 16 deliverydate = 1782691200000 )
      ( name = `Hurricane GX` productid = `HT-1072` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1072.jpg` quantity = 13 deliverydate = 1782345600000 )
      ( name = `Hurricane GX/LN` productid = `HT-1073` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1073.jpg` quantity = 5 deliverydate = 1782000000000 )
      ( name = `Photo Scan` productid = `HT-1080` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1080.jpg` quantity = 8 deliverydate = 1781654400000 )
      ( name = `Power Scan` productid = `HT-1081` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1081.jpg` quantity = 11 deliverydate = 1784764800000 )
      ( name = `Jet Scan Professional` productid = `HT-1082` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1082.jpg` quantity = 13 deliverydate = 1784419200000 )
      ( name = `Jet Scan Professional` productid = `HT-1083` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1083.jpg` quantity = 10 deliverydate = 1784073600000 )
      ( name = `Copymaster` productid = `HT-1085` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1085.jpg` quantity = 10 deliverydate = 1783728000000 )
      ( name = `Surround Sound` productid = `HT-1090` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1090.jpg` quantity = 20 deliverydate = 1783382400000 )
      ( name = `Blaster Extreme` productid = `HT-1091` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1091.jpg` quantity = 15 deliverydate = 1783036800000 )
      ( name = `Sound Booster` productid = `HT-1092` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1092.jpg` quantity = 50 deliverydate = 1782691200000 )
      ( name = `Lovely Sound 5.1 Wireless` productid = `HT-1095` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1095.jpg` quantity = 12 deliverydate = 1782345600000 )
      ( name = `Lovely Sound 5.1` productid = `HT-1096` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1096.jpg` quantity = 18 deliverydate = 1782000000000 )
      ( name = `Lovely Sound Stereo` productid = `HT-1097` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1097.jpg` quantity = 21 deliverydate = 1781654400000 )
      ( name = `Smart Office` productid = `HT-1100` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1100.jpg` quantity = 25 deliverydate = 1784764800000 )
      ( name = `Smart Design` productid = `HT-1101` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1101.jpg` quantity = 26 deliverydate = 1784419200000 )
      ( name = `Smart Network` productid = `HT-1102` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1102.jpg` quantity = 28 deliverydate = 1784073600000 )
      ( name = `Smart Multimedia` productid = `HT-1103` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1103.jpg` quantity = 9 deliverydate = 1783728000000 )
      ( name = `Smart Games` productid = `HT-1104` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1104.jpg` quantity = 13 deliverydate = 1783382400000 )
      ( name = `Smart Internet Antivirus` productid = `HT-1105` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1105.jpg` quantity = 17 deliverydate = 1783036800000 )
      ( name = `Smart Firewall` productid = `HT-1106` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1106.jpg` quantity = 19 deliverydate = 1782691200000 )
      ( name = `Smart Money` productid = `HT-1107` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1107.jpg` quantity = 18 deliverydate = 1782345600000 )
      ( name = `PC Lock` productid = `HT-1110` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1110.jpg` quantity = 14 deliverydate = 1782000000000 )
      ( name = `Notebook Lock` productid = `HT-1111` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1111.jpg` quantity = 20 deliverydate = 1781654400000 )
      ( name = `Web cam reality` productid = `HT-1112` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1112.jpg` quantity = 27 deliverydate = 1784764800000 )
      ( name = `Screen clean` productid = `HT-1113` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1113.jpg` quantity = 17 deliverydate = 1784419200000 )
      ( name = `Fabric bag professional` productid = `HT-1114` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1114.jpg` quantity = 14 deliverydate = 1784073600000 )
      ( name = `Wireless DSL Router` productid = `HT-1115` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1115.jpg` quantity = 16 deliverydate = 1783728000000 )
      ( name = `Wireless DSL Router / Repeater` productid = `HT-1116` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1116.jpg` quantity = 12 deliverydate = 1783382400000 )
      ( name = `Wireless DSL Router / Repeater and Print Server` productid = `HT-1117` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1117.jpg` quantity = 12 deliverydate = 1783036800000 )
      ( name = `USB Stick` productid = `HT-1118` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1118.jpg` quantity = 14 deliverydate = 1782691200000 )
      ( name = `Travel Adapter` productid = `HT-1119` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1119.jpg` quantity = 10 deliverydate = 1782345600000 )
      ( name = `Cordless Bluetooth Keyboard, english international` productid = `HT-1120` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1120.jpg` quantity = 13 deliverydate = 1782000000000 )
      ( name = `Flat XXL` productid = `HT-1137` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1137.jpg` quantity = 10 deliverydate = 1781654400000 )
      ( name = `Pocket Mouse` productid = `HT-1138` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1138.jpg` quantity = 20 deliverydate = 1784764800000 )
      ( name = `PC Power Station` productid = `HT-1210` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1210.jpg` quantity = 22 deliverydate = 1784419200000 )
      ( name = `Astro Laptop 1516` productid = `HT-1251` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1251.jpg` quantity = 23 deliverydate = 1784073600000 )
      ( name = `Astro Phone 6` productid = `HT-1252` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1252.jpg` quantity = 28 deliverydate = 1783728000000 )
      ( name = `Benda Laptop 1408` productid = `HT-1253` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1253.jpg` quantity = 27 deliverydate = 1783382400000 )
      ( name = `Bending Screen 21HD` productid = `HT-1254` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1254.jpg` quantity = 23 deliverydate = 1783036800000 )
      ( name = `Broad Screen 22HD` productid = `HT-1255` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1255.jpg` quantity = 5 deliverydate = 1782691200000 )
      ( name = `Cerdik Phone 7` productid = `HT-1256` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1256.jpg` quantity = 19 deliverydate = 1782345600000 )
      ( name = `Cepat Tablet 10.5` productid = `HT-1257` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1257.jpg` quantity = 17 deliverydate = 1782000000000 )
      ( name = `Cepat Tablet 8` productid = `HT-1258` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1258.jpg` quantity = 24 deliverydate = 1781654400000 )
      ( name = `Server Basic` productid = `HT-1500` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1500.jpg` quantity = 24 deliverydate = 1784764800000 )
      ( name = `Server Professional` productid = `HT-1501` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1501.jpg` quantity = 26 deliverydate = 1784419200000 )
      ( name = `Server Power Pro` productid = `HT-1502` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1502.jpg` quantity = 34 deliverydate = 1784073600000 )
      ( name = `Family PC Basic` productid = `HT-1600` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1600.jpg` quantity = 10 deliverydate = 1783728000000 )
      ( name = `Family PC Pro` productid = `HT-1601` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1601.jpg` quantity = 20 deliverydate = 1783382400000 )
      ( name = `Gaming Monster` productid = `HT-1602` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1602.jpg` quantity = 24 deliverydate = 1783036800000 )
      ( name = `Gaming Monster Pro` productid = `HT-1603` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1603.jpg` quantity = 25 deliverydate = 1782691200000 )
      ( name = `7" Widescreen Portable DVD Player w MP3` productid = `HT-2000` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2000.jpg` quantity = 20 deliverydate = 1782345600000 )
      ( name = `10" Portable DVD player` productid = `HT-2001` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2001.jpg` quantity = 21 deliverydate = 1782000000000 )
      ( name = `Portable DVD Player with 9" LCD Monitor` productid = `HT-2002` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2002.jpg` quantity = 50 deliverydate = 1781654400000 )
      ( name = `CD/DVD case: 264 sleeves` productid = `HT-2025` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2025.jpg` quantity = 26 deliverydate = 1784764800000 )
      ( name = `Audio/Video Cable Kit - 4m` productid = `HT-2026` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2026.jpg` quantity = 16 deliverydate = 1784419200000 )
      ( name = `Removable CD/DVD Laser Labels` productid = `HT-2027` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2027.jpg` quantity = 25 deliverydate = 1784073600000 )
      ( name = `Beam Breaker B-1` productid = `HT-6100` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6100.jpg` quantity = 32 deliverydate = 1783728000000 )
      ( name = `Beam Breaker B-2` productid = `HT-6101` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6101.jpg` quantity = 18 deliverydate = 1783382400000 )
      ( name = `Beam Breaker B-3` productid = `HT-6102` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6102.jpg` quantity = 16 deliverydate = 1783036800000 )
      ( name = `Play Movie` productid = `HT-6110` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6110.jpg` quantity = 15 deliverydate = 1782691200000 )
      ( name = `Record Movie` productid = `HT-6111` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6111.jpg` quantity = 24 deliverydate = 1782345600000 )
      ( name = `ITelo MusicStick` productid = `HT-6120` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6120.jpg` quantity = 15 deliverydate = 1782000000000 )
      ( name = `ITelo Jog-Mate` productid = `HT-6121` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6121.jpg` quantity = 24 deliverydate = 1781654400000 )
      ( name = `Power Pro Player 40` productid = `HT-6122` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6122.jpg` quantity = 23 deliverydate = 1784764800000 )
      ( name = `Power Pro Player 80` productid = `HT-6123` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6123.jpg` quantity = 13 deliverydate = 1784419200000 )
      ( name = `Flat Watch HD32` productid = `HT-6130` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6130.jpg` quantity = 16 deliverydate = 1784073600000 )
      ( name = `Flat Watch HD37` productid = `HT-6131` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6131.jpg` quantity = 14 deliverydate = 1783728000000 )
      ( name = `Flat Watch HD41` productid = `HT-6132` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6132.jpg` quantity = 13 deliverydate = 1783382400000 )
      ( name = `Copperberry` productid = `HT-7000` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7000.jpg` quantity = 5 deliverydate = 1783036800000 )
      ( name = `Silverberry` productid = `HT-7010` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7010.jpg` quantity = 9 deliverydate = 1782691200000 )
      ( name = `Goldberry` productid = `HT-7020` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7020.jpg` quantity = 11 deliverydate = 1782345600000 )
      ( name = `Platinberry` productid = `HT-7030` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7030.jpg` quantity = 12 deliverydate = 1782000000000 )
      ( name = `ITelO FlexTop I4000` productid = `HT-8000` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8000.jpg` quantity = 11 deliverydate = 1781654400000 )
      ( name = `ITelO FlexTop I6300c` productid = `HT-8001` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8001.jpg` quantity = 20 deliverydate = 1784764800000 )
      ( name = `ITelO FlexTop I9100` productid = `HT-8002` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8002.jpg` quantity = 20 deliverydate = 1784419200000 )
      ( name = `ITelO FlexTop I9800` productid = `HT-8003` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8003.jpg` quantity = 22 deliverydate = 1784073600000 )
      ( name = `Smartphone Leather Case` productid = `HT-9991` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9991.jpg` quantity = 12 deliverydate = 1783728000000 )
      ( name = `Smartphone Alpha` productid = `HT-9992` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9992.jpg` quantity = 13 deliverydate = 1783382400000 )
      ( name = `Mini Tablet` productid = `HT-9993` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9993.jpg` quantity = 10 deliverydate = 1783036800000 )
      ( name = `Camcorder View` productid = `HT-9994` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9994.jpg` quantity = 50 deliverydate = 1782691200000 )
      ( name = `Tablet Pouch` productid = `HT-9995` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9995.jpg` quantity = 34 deliverydate = 1782345600000 )
      ( name = `Tablet Pouch` productid = `HT-9996` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9996.jpg` quantity = 34 deliverydate = 1782000000000 )
      ( name = `e-Book Reader ReadMe` productid = `HT-9997` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9997.jpg` quantity = 23 deliverydate = 1781654400000 )
      ( name = `Smartphone Beta` productid = `HT-9998` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9998.jpg` quantity = 21 deliverydate = 1784764800000 )
      ( name = `Maxi Tablet` productid = `HT-9999` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9999.jpg` quantity = 20 deliverydate = 1784419200000 )
      ( name = `Flyer` productid = `PF-1000` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/PF-1000.jpg` quantity = 33 deliverydate = 1784073600000 )
      ).

  ENDMETHOD.

ENDCLASS.
