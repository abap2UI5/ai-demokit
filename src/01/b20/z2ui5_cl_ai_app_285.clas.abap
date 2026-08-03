CLASS z2ui5_cl_ai_app_285 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name          TYPE string,
        productid     TYPE string,
        productpicurl TYPE string,
      END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

    DATA t_products TYPE ty_t_product.

    " the record the original reaches with bindElement( '/ProductCollection/0' )
    " on every popover, seeded at the model root
    DATA name          TYPE string.
    DATA productpicurl TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popover_image_display.
    METHODS popover_list_display.
    METHODS popover_inner_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_285 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->open( n = `HorizontalLayout` ns = `l`
            )->a( n = `class` v = `sapUiMediumMargin`

            )->leaf( `Button`
                )->a( n = `text`         v = `Show Popover With Image`
                )->a( n = `press`        v = client->_event( val = `POPOVER_IMAGE` t_arg = VALUE #( ( `$event.oSource.sId` ) ) )
                )->a( n = `class`        v = `sapUiLargeMargin`
                )->a( n = `ariaHasPopup` v = `Dialog`

            )->open( `VBox`
                )->a( n = `id`               v = `withinArea`
                )->a( n = `backgroundDesign` v = `Solid`
                )->a( n = `height`           v = `30rem`
                )->a( n = `width`            v = `60rem`
                )->a( n = `alignItems`       v = `Center`
                )->a( n = `justifyContent`   v = `Center`

                )->leaf( `Button`
                    )->a( n = `text`         v = `Show Inside Popover`
                    )->a( n = `press`        v = client->_event( val = `POPOVER_INNER` t_arg = VALUE #( ( `$event.oSource.sId` ) ) )
                    )->a( n = `ariaHasPopup` v = `Dialog`

                )->open( `layoutData`
                    )->leaf( `FlexItemData`
                        )->a( n = `backgroundDesign` v = `Solid`

                )->shut(
            )->shut(

            )->open( `FlexBox`
                )->a( n = `direction`      v = `Column`
                )->a( n = `alignItems`     v = `End`
                )->a( n = `justifyContent` v = `End`
                )->a( n = `height`         v = `30rem`

                )->leaf( `Button`
                    )->a( n = `text`         v = `Show Popover with List`
                    )->a( n = `press`        v = client->_event( val = `POPOVER_LIST` t_arg = VALUE #( ( `$event.oSource.sId` ) ) )
                    )->a( n = `ariaHasPopup` v = `Dialog`
                    )->a( n = `class`        v = `sapUiLargeMargin` ).

    client->view_display( view->stringify( ) ).

    " Popup.setWithinArea confines every popup to the grey VBox instead of the
    " viewport - the sample's point. The original re-sets it in each press
    " handler and releases it in afterClose; here it is set once with the view,
    " because a follow-up action runs AFTER the popover of the same round-trip
    " has opened. This app opens no other popup, so the effect is the same.
    client->follow_up_action( val   = client->cs_event-control_global
                              t_arg = VALUE #( ( `POPUP` ) ( `setWithinArea` ) ( `withinArea` ) ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `POPOVER_IMAGE`.
        popover_image_display( ).

      WHEN `POPOVER_INNER`.
        popover_inner_display( ).

      WHEN `POPOVER_LIST`.
        popover_list_display( ).

    ENDCASE.

  ENDMETHOD.


  METHOD popover_image_display.

    DATA(popover) = z2ui5_cl_ai_xml=>factory( ).

    " the fragment's relative {Name}/{ProductPicUrl} come from the popover's
    " bindElement( '/ProductCollection/0' ); that record is seeded at the model
    " root here, so both bind absolutely
    popover->open( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->open( `Popover`
            )->a( n = `id`            v = `myPopover`
            )->a( n = `title`         v = client->_bind( name )
            )->a( n = `contentHeight` v = `20em`
            )->a( n = `placement`     v = `Right`

            )->leaf( `Image`
                )->a( n = `src`          v = client->_bind( productpicurl )
                )->a( n = `width`        v = `18em`
                )->a( n = `densityAware` v = `false` ).

    client->popover_display( xml   = popover->stringify( )
                             by_id = client->get_event_arg( ) ).

  ENDMETHOD.


  METHOD popover_list_display.

    DATA(popover) = z2ui5_cl_ai_xml=>factory( ).

    popover->open( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->open( `Popover`
            )->a( n = `id`        v = `myListPopover`
            )->a( n = `title`     v = `Products`
            )->a( n = `placement` v = `Left`

            )->open( `List`
                )->a( n = `id`    v = `list`
                )->a( n = `items` v = client->_bind( t_products )

                )->open( `items`
                    )->leaf( `StandardListItem`
                        )->a( n = `title`            v = `{NAME}`
                        )->a( n = `description`      v = `{PRODUCTID}`
                        )->a( n = `type`             v = `Active`
                        )->a( n = `icon`             v = `{PRODUCTPICURL}`
                        )->a( n = `iconDensityAware` v = `false`
                        )->a( n = `iconInset`        v = `false` ).

    client->popover_display( xml   = popover->stringify( )
                             by_id = client->get_event_arg( ) ).

  ENDMETHOD.


  METHOD popover_inner_display.

    DATA(popover) = z2ui5_cl_ai_xml=>factory( ).

    popover->open( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->open( `Popover`
            )->a( n = `id`        v = `myInnerPopover`
            )->a( n = `placement` v = `Left`

            )->open( `List`
                )->a( n = `id`    v = `inner-List`
                )->a( n = `items` v = client->_bind( t_products )

                )->open( `items`
                    )->leaf( `StandardListItem`
                        )->a( n = `title`            v = `{NAME}`
                        )->a( n = `description`      v = `{PRODUCTID}`
                        )->a( n = `type`             v = `Active`
                        )->a( n = `icon`             v = `{PRODUCTPICURL}`
                        )->a( n = `iconDensityAware` v = `false`
                        )->a( n = `iconInset`        v = `false` ).

    client->popover_display( xml   = popover->stringify( )
                             by_id = client->get_event_arg( ) ).

  ENDMETHOD.


  METHOD model_init.

    " the popovers' bindElement( '/ProductCollection/0' ) record, seeded at the
    " model root (sap/ui/demo/mock/products.json, first row)
    name          = `Notebook Basic 15`.
    productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg`.

    t_products = VALUE #(
      ( name = `Notebook Basic 15` productid = `HT-1000` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg` )
      ( name = `Notebook Basic 17` productid = `HT-1001` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1001.jpg` )
      ( name = `Notebook Basic 18` productid = `HT-1002` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1002.jpg` )
      ( name = `Notebook Basic 19` productid = `HT-1003` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1003.jpg` )
      ( name = `ITelO Vault` productid = `HT-1007` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1007.jpg` )
      ( name = `Notebook Professional 15` productid = `HT-1010` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg` )
      ( name = `Notebook Professional 17` productid = `HT-1011` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1011.jpg` )
      ( name = `ITelO Vault Net` productid = `HT-1020` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1020.jpg` )
      ( name = `ITelO Vault SAT` productid = `HT-1021` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1021.jpg` )
      ( name = `Comfort Easy` productid = `HT-1022` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1022.jpg` )
      ( name = `Comfort Senior` productid = `HT-1023` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1023.jpg` )
      ( name = `Ergo Screen E-I` productid = `HT-1030` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1030.jpg` )
      ( name = `Ergo Screen E-II` productid = `HT-1031` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1031.jpg` )
      ( name = `Ergo Screen E-III` productid = `HT-1032` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1032.jpg` )
      ( name = `Flat Basic` productid = `HT-1035` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1035.jpg` )
      ( name = `Flat Future` productid = `HT-1036` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1036.jpg` )
      ( name = `Flat XL` productid = `HT-1037` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1037.jpg` )
      ( name = `Laser Professional Eco` productid = `HT-1040` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1040.jpg` )
      ( name = `Laser Basic` productid = `HT-1041` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1041.jpg` )
      ( name = `Laser Allround` productid = `HT-1042` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1042.jpg` )
      ( name = `Ultra Jet Super Color` productid = `HT-1050` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1050.jpg` )
      ( name = `Ultra Jet Mobile` productid = `HT-1051` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1051.jpg` )
      ( name = `Ultra Jet Super Highspeed` productid = `HT-1052` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1052.jpg` )
      ( name = `Multi Print` productid = `HT-1055` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1055.jpg` )
      ( name = `Multi Color` productid = `HT-1056` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1056.jpg` )
      ( name = `Cordless Mouse` productid = `HT-1060` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1060.jpg` )
      ( name = `Speed Mouse` productid = `HT-1061` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1061.jpg` )
      ( name = `Track Mouse` productid = `HT-1062` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1062.jpg` )
      ( name = `Ergonomic Keyboard` productid = `HT-1063` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1063.jpg` )
      ( name = `Internet Keyboard` productid = `HT-1064` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1064.jpg` )
      ( name = `Media Keyboard` productid = `HT-1065` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1065.jpg` )
      ( name = `Mousepad` productid = `HT-1066` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1066.jpg` )
      ( name = `Ergo Mousepad` productid = `HT-1067` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1067.jpg` )
      ( name = `Designer Mousepad` productid = `HT-1068` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1068.jpg` )
      ( name = `Universal card reader` productid = `HT-1069` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1069.jpg` )
      ( name = `Proctra X` productid = `HT-1070` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1070.jpg` )
      ( name = `Gladiator MX` productid = `HT-1071` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1071.jpg` )
      ( name = `Hurricane GX` productid = `HT-1072` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1072.jpg` )
      ( name = `Hurricane GX/LN` productid = `HT-1073` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1073.jpg` )
      ( name = `Photo Scan` productid = `HT-1080` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1080.jpg` )
      ( name = `Power Scan` productid = `HT-1081` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1081.jpg` )
      ( name = `Jet Scan Professional` productid = `HT-1082` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1082.jpg` )
      ( name = `Jet Scan Professional` productid = `HT-1083` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1083.jpg` )
      ( name = `Copymaster` productid = `HT-1085` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1085.jpg` )
      ( name = `Surround Sound` productid = `HT-1090` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1090.jpg` )
      ( name = `Blaster Extreme` productid = `HT-1091` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1091.jpg` )
      ( name = `Sound Booster` productid = `HT-1092` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1092.jpg` )
      ( name = `Lovely Sound 5.1 Wireless` productid = `HT-1095` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1095.jpg` )
      ( name = `Lovely Sound 5.1` productid = `HT-1096` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1096.jpg` )
      ( name = `Lovely Sound Stereo` productid = `HT-1097` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1097.jpg` )
      ( name = `Smart Office` productid = `HT-1100` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1100.jpg` )
      ( name = `Smart Design` productid = `HT-1101` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1101.jpg` )
      ( name = `Smart Network` productid = `HT-1102` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1102.jpg` )
      ( name = `Smart Multimedia` productid = `HT-1103` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1103.jpg` )
      ( name = `Smart Games` productid = `HT-1104` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1104.jpg` )
      ( name = `Smart Internet Antivirus` productid = `HT-1105` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1105.jpg` )
      ( name = `Smart Firewall` productid = `HT-1106` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1106.jpg` )
      ( name = `Smart Money` productid = `HT-1107` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1107.jpg` )
      ( name = `PC Lock` productid = `HT-1110` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1110.jpg` )
      ( name = `Notebook Lock` productid = `HT-1111` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1111.jpg` )
      ( name = `Web cam reality` productid = `HT-1112` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1112.jpg` )
      ( name = `Screen clean` productid = `HT-1113` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1113.jpg` )
      ( name = `Fabric bag professional` productid = `HT-1114` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1114.jpg` )
      ( name = `Wireless DSL Router` productid = `HT-1115` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1115.jpg` )
      ( name = `Wireless DSL Router / Repeater` productid = `HT-1116` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1116.jpg` )
      ( name = `Wireless DSL Router / Repeater and Print Server` productid = `HT-1117` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1117.jpg` )
      ( name = `USB Stick` productid = `HT-1118` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1118.jpg` )
      ( name = `Travel Adapter` productid = `HT-1119` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1119.jpg` )
      ( name = `Cordless Bluetooth Keyboard, english international` productid = `HT-1120` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1120.jpg` )
      ( name = `Flat XXL` productid = `HT-1137` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1137.jpg` )
      ( name = `Pocket Mouse` productid = `HT-1138` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1138.jpg` )
      ( name = `PC Power Station` productid = `HT-1210` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1210.jpg` )
      ( name = `Astro Laptop 1516` productid = `HT-1251` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1251.jpg` )
      ( name = `Astro Phone 6` productid = `HT-1252` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1252.jpg` )
      ( name = `Benda Laptop 1408` productid = `HT-1253` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1253.jpg` )
      ( name = `Bending Screen 21HD` productid = `HT-1254` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1254.jpg` )
      ( name = `Broad Screen 22HD` productid = `HT-1255` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1255.jpg` )
      ( name = `Cerdik Phone 7` productid = `HT-1256` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1256.jpg` )
      ( name = `Cepat Tablet 10.5` productid = `HT-1257` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1257.jpg` )
      ( name = `Cepat Tablet 8` productid = `HT-1258` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1258.jpg` )
      ( name = `Server Basic` productid = `HT-1500` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1500.jpg` )
      ( name = `Server Professional` productid = `HT-1501` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1501.jpg` )
      ( name = `Server Power Pro` productid = `HT-1502` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1502.jpg` )
      ( name = `Family PC Basic` productid = `HT-1600` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1600.jpg` )
      ( name = `Family PC Pro` productid = `HT-1601` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1601.jpg` )
      ( name = `Gaming Monster` productid = `HT-1602` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1602.jpg` )
      ( name = `Gaming Monster Pro` productid = `HT-1603` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1603.jpg` )
      ( name = `7" Widescreen Portable DVD Player w MP3` productid = `HT-2000` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2000.jpg` )
      ( name = `10" Portable DVD player` productid = `HT-2001` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2001.jpg` )
      ( name = `Portable DVD Player with 9" LCD Monitor` productid = `HT-2002` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2002.jpg` )
      ( name = `CD/DVD case: 264 sleeves` productid = `HT-2025` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2025.jpg` )
      ( name = `Audio/Video Cable Kit - 4m` productid = `HT-2026` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2026.jpg` )
      ( name = `Removable CD/DVD Laser Labels` productid = `HT-2027` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2027.jpg` )
      ( name = `Beam Breaker B-1` productid = `HT-6100` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6100.jpg` )
      ( name = `Beam Breaker B-2` productid = `HT-6101` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6101.jpg` )
      ( name = `Beam Breaker B-3` productid = `HT-6102` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6102.jpg` )
      ( name = `Play Movie` productid = `HT-6110` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6110.jpg` )
      ( name = `Record Movie` productid = `HT-6111` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6111.jpg` )
      ( name = `ITelo MusicStick` productid = `HT-6120` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6120.jpg` )
      ( name = `ITelo Jog-Mate` productid = `HT-6121` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6121.jpg` )
      ( name = `Power Pro Player 40` productid = `HT-6122` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6122.jpg` )
      ( name = `Power Pro Player 80` productid = `HT-6123` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6123.jpg` )
      ( name = `Flat Watch HD32` productid = `HT-6130` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6130.jpg` )
      ( name = `Flat Watch HD37` productid = `HT-6131` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6131.jpg` )
      ( name = `Flat Watch HD41` productid = `HT-6132` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6132.jpg` )
      ( name = `Copperberry` productid = `HT-7000` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7000.jpg` )
      ( name = `Silverberry` productid = `HT-7010` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7010.jpg` )
      ( name = `Goldberry` productid = `HT-7020` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7020.jpg` )
      ( name = `Platinberry` productid = `HT-7030` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7030.jpg` )
      ( name = `ITelO FlexTop I4000` productid = `HT-8000` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8000.jpg` )
      ( name = `ITelO FlexTop I6300c` productid = `HT-8001` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8001.jpg` )
      ( name = `ITelO FlexTop I9100` productid = `HT-8002` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8002.jpg` )
      ( name = `ITelO FlexTop I9800` productid = `HT-8003` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8003.jpg` )
      ( name = `Smartphone Leather Case` productid = `HT-9991` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9991.jpg` )
      ( name = `Smartphone Alpha` productid = `HT-9992` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9992.jpg` )
      ( name = `Mini Tablet` productid = `HT-9993` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9993.jpg` )
      ( name = `Camcorder View` productid = `HT-9994` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9994.jpg` )
      ( name = `Tablet Pouch` productid = `HT-9995` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9995.jpg` )
      ( name = `Tablet Pouch` productid = `HT-9996` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9996.jpg` )
      ( name = `e-Book Reader ReadMe` productid = `HT-9997` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9997.jpg` )
      ( name = `Smartphone Beta` productid = `HT-9998` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9998.jpg` )
      ( name = `Maxi Tablet` productid = `HT-9999` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9999.jpg` )
      ( name = `Flyer` productid = `PF-1000` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/PF-1000.jpg` )
    ).

  ENDMETHOD.

ENDCLASS.
