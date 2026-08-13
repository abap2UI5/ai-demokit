CLASS z2ui5_cl_smpc_app_247 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             name          TYPE string,
             category      TYPE string,
             productpicurl TYPE string,
             quantity      TYPE i,
             deliverydate  TYPE p LENGTH 8 DECIMALS 0,
           END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

    " Column widths - the sample's ui>/widths/{name,category,image,quantity,date}
    " single config object, folded to the one default model as five top-level
    " fields bound via _bind (named-model prefix-drop idiom); the member name
    " equals the original leaf so structural-diff matches.
    DATA name     TYPE string.
    DATA category TYPE string.
    DATA image    TYPE string.
    DATA quantity TYPE string.
    DATA date     TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS set_widths IMPORTING mode TYPE string.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_247 IMPLEMENTATION.

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
        )->a( n = `xmlns`     v = `sap.ui.table`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:u`   v = `sap.ui.unified`
        )->a( n = `xmlns:c`   v = `sap.ui.core`
        )->a( n = `xmlns:m`   v = `sap.m`
        )->a( n = `height`    v = `100%`

        )->open( n = `Page` ns = `m`
            )->a( n = `showHeader` v = `false`
            )->a( n = `class`      v = `sapUiContentPadding`

            )->open( n = `content` ns = `m`

                )->open( `Table`
                    )->a( n = `id`            v = `table`
                    )->a( n = `selectionMode` v = `MultiToggle`
                    )->a( n = `rows`          v = client->_bind( t_products )
                    " onColumnResize 1:1 since 2026-08-05: the delivery-date
                    " column cannot be resized (the original's preventDefault
                    " branch), every other column reports its LABEL and the new
                    " width. The veto is per COLUMN, so it rides on the wire as
                    " an expression - the flag form would freeze the whole table
                    )->a( n = `columnResize`  v = client->_event(
                              val    = `COLUMN_RESIZE`
                              t_arg  = VALUE #( ( `${$parameters>/column}.getId()` )
                                                ( `${$parameters>/column}.getLabel().getText()` )
                                                ( `${$parameters>/width}` ) )
                              s_ctrl = VALUE #(
                                prevent_default_expr = `${$parameters>/column}.getId().indexOf('deliverydate') >= 0` ) )
                    )->a( n = `ariaLabelledBy` v = `title`

                    )->open( `extension`
                        )->open( n = `OverflowToolbar` ns = `m`
                            )->a( n = `style` v = `Clear`
                            )->leaf( n = `Title` ns = `m`
                                )->a( n = `id`   v = `title`
                                )->a( n = `text` v = `Products`

                    )->shut(
                    )->shut(
                    )->open( `columns`

                        )->open( `Column`
                            )->a( n = `width`          v = client->_bind( name )
                            )->a( n = `filterProperty` v = `Name`
                            )->a( n = `resizable`      v = `true`
                            )->a( n = `autoResizable`  v = `true`
                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text` v = `Product Name`

                            )->open( `template`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{NAME}`
                                    )->a( n = `wrapping` v = `false`

                        )->shut(
                        )->shut(
                        )->open( `Column`
                            )->a( n = `width`          v = client->_bind( category )
                            )->a( n = `resizable`      v = `true`
                            )->a( n = `filterProperty` v = `Category`
                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text` v = `Category`

                            )->open( `template`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{CATEGORY}`
                                    )->a( n = `wrapping` v = `false`

                        )->shut(
                        )->shut(
                        )->open( `Column`
                            )->a( n = `width`     v = client->_bind( image )
                            )->a( n = `resizable` v = `false`
                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text` v = `Image`

                            )->open( `template`
                                )->leaf( n = `Link` ns = `m`
                                    )->a( n = `text`   v = `Show Image`
                                    )->a( n = `href`   v = `{PRODUCTPICURL}`
                                    )->a( n = `target` v = `_blank`

                        )->shut(
                        )->shut(
                        )->open( `Column`
                            )->a( n = `width`     v = client->_bind( quantity )
                            )->a( n = `resizable` v = `false`
                            )->a( n = `hAlign`    v = `End`
                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text` v = `Quantity`

                            )->open( `template`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = |\{ path: 'QUANTITY', type: 'sap.ui.model.type.Integer' \}|

                        )->shut(
                        )->shut(
                        )->open( `Column`
                            )->a( n = `id`    v = `deliverydate`
                            )->a( n = `width` v = client->_bind( date )
                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text` v = `Delivery Date`

                            )->open( `template`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text`     v = |\{ path: 'DELIVERYDATE', type: 'sap.ui.model.type.Date', formatOptions: \{ source: \{ pattern: 'timestamp' \} \} \}|
                                    )->a( n = `wrapping` v = `false`

                        )->shut(
                        )->shut(
                    )->shut(
                    )->open( `footer`
                        )->open( n = `OverflowToolbar` ns = `m`
                            )->a( n = `id` v = `infobar`
                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text`     v = `Column Widths:`
                                )->a( n = `labelFor` v = `columnWidths`
                            )->open( n = `SegmentedButton` ns = `m`
                                )->a( n = `id`              v = `columnWidths`
                                )->a( n = `selectedKey`     v = `Static`
                                )->a( n = `selectionChange` v = client->_event( val = `WIDTHS_CHANGE` t_arg = VALUE #( ( `${$parameters>/item}.getKey()` ) ) )

                                )->open( n = `items` ns = `m`
                                    )->leaf( n = `SegmentedButtonItem` ns = `m`
                                        )->a( n = `icon`    v = `sap-icon://color-fill`
                                        )->a( n = `key`     v = `Static`
                                        )->a( n = `tooltip` v = `Static`
                                    )->leaf( n = `SegmentedButtonItem` ns = `m`
                                        )->a( n = `icon`    v = `sap-icon://overlay`
                                        )->a( n = `key`     v = `Flexible`
                                        )->a( n = `tooltip` v = `Flexible`
                                    )->leaf( n = `SegmentedButtonItem` ns = `m`
                                        )->a( n = `icon`    v = `sap-icon://business-objects-mobile`
                                        )->a( n = `key`     v = `Mixed`
                                        )->a( n = `tooltip` v = `Mixed`

                    )->shut(
                    )->shut(
                    )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `WIDTHS_CHANGE`.
        set_widths( client->get_event_arg( ) ).

      WHEN `COLUMN_RESIZE`.
        " the client already vetoed the delivery-date column before the
        " roundtrip; the event arrives either way, so the if/else of the
        " original's handler is reproduced here - the vetoed column reports
        " nothing, every other one gets the sample's own message text
        DATA(column_id) = client->get_event_arg( ).
        IF column_id NS `deliverydate`.
          client->message_toast_display( |Column '{ client->get_event_arg( 2 ) }' was resized to { client->get_event_arg( 3 ) }.| ).
        ENDIF.
    ENDCASE.

  ENDMETHOD.


  METHOD set_widths.

    IF mode = `Flexible`.
      name     = `25%`.
      category = `25%`.
      image    = `15%`.
      quantity = `10%`.
      date     = `25%`.
    ELSEIF mode = `Mixed`.
      name     = `20%`.
      category = `11rem`.
      image    = `7rem`.
      quantity = `6rem`.
      date     = `9rem`.
    ELSE.
      name     = `13rem`.
      category = `11rem`.
      image    = `7rem`.
      quantity = `6rem`.
      date     = `9rem`.
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    set_widths( `Static` ).

    t_products = VALUE #(
      ( name = `Notebook Basic 15` category = `Laptops` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg` quantity = 10 deliverydate = `1784937600000` )
      ( name = `Notebook Basic 17` category = `Laptops` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1001.jpg` quantity = 20 deliverydate = `1784592000000` )
      ( name = `Notebook Basic 18` category = `Laptops` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1002.jpg` quantity = 10 deliverydate = `1784246400000` )
      ( name = `Notebook Basic 19` category = `Laptops` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1003.jpg` quantity = 15 deliverydate = `1783900800000` )
      ( name = `ITelO Vault` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1007.jpg` quantity = 15 deliverydate = `1783555200000` )
      ( name = `Notebook Professional 15` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg` quantity = 16 deliverydate = `1783209600000` )
      ( name = `Notebook Professional 17` category = `Laptops` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1011.jpg` quantity = 17 deliverydate = `1782864000000` )
      ( name = `ITelO Vault Net` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1020.jpg` quantity = 14 deliverydate = `1782518400000` )
      ( name = `ITelO Vault SAT` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1021.jpg` quantity = 50 deliverydate = `1782172800000` )
      ( name = `Comfort Easy` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1022.jpg` quantity = 30 deliverydate = `1781827200000` )
      ( name = `Comfort Senior` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1023.jpg` quantity = 24 deliverydate = `1784937600000` )
      ( name = `Ergo Screen E-I` category = `Flat Screen Monitors` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1030.jpg` quantity = 14 deliverydate = `1784592000000` )
      ( name = `Ergo Screen E-II` category = `Flat Screen Monitors` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1031.jpg` quantity = 24 deliverydate = `1784246400000` )
      ( name = `Ergo Screen E-III` category = `Flat Screen Monitors` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1032.jpg` quantity = 50 deliverydate = `1783900800000` )
      ( name = `Flat Basic` category = `Flat Screen Monitors` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1035.jpg` quantity = 23 deliverydate = `1783555200000` )
      ( name = `Flat Future` category = `Flat Screen Monitors` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1036.jpg` quantity = 22 deliverydate = `1783209600000` )
      ( name = `Flat XL` category = `Flat Screen Monitors` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1037.jpg` quantity = 23 deliverydate = `1782864000000` )
      ( name = `Laser Professional Eco` category = `Printers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1040.jpg` quantity = 21 deliverydate = `1782518400000` )
      ( name = `Laser Basic` category = `Printers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1041.jpg` quantity = 8 deliverydate = `1782172800000` )
      ( name = `Laser Allround` category = `Printers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1042.jpg` quantity = 9 deliverydate = `1781827200000` )
      ( name = `Ultra Jet Super Color` category = `Printers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1050.jpg` quantity = 17 deliverydate = `1784937600000` )
      ( name = `Ultra Jet Mobile` category = `Printers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1051.jpg` quantity = 18 deliverydate = `1784592000000` )
      ( name = `Ultra Jet Super Highspeed` category = `Printers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1052.jpg` quantity = 25 deliverydate = `1784246400000` )
      ( name = `Multi Print` category = `Multifunction Printers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1055.jpg` quantity = 16 deliverydate = `1783900800000` )
      ( name = `Multi Color` category = `Multifunction Printers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1056.jpg` quantity = 5 deliverydate = `1783555200000` )
      ( name = `Cordless Mouse` category = `Mice` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1060.jpg` quantity = 25 deliverydate = `1783209600000` )
      ( name = `Speed Mouse` category = `Mice` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1061.jpg` quantity = 12 deliverydate = `1782864000000` )
      ( name = `Track Mouse` category = `Mice` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1062.jpg` quantity = 12 deliverydate = `1782518400000` )
      ( name = `Ergonomic Keyboard` category = `Keyboards` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1063.jpg` quantity = 50 deliverydate = `1782172800000` )
      ( name = `Internet Keyboard` category = `Keyboards` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1064.jpg` quantity = 35 deliverydate = `1781827200000` )
      ( name = `Media Keyboard` category = `Keyboards` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1065.jpg` quantity = 26 deliverydate = `1784937600000` )
      ( name = `Mousepad` category = `Mousepads` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1066.jpg` quantity = 12 deliverydate = `1784592000000` )
      ( name = `Ergo Mousepad` category = `Mousepads` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1067.jpg` quantity = 16 deliverydate = `1784246400000` )
      ( name = `Designer Mousepad` category = `Mousepads` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1068.jpg` quantity = 26 deliverydate = `1783900800000` )
      ( name = `Universal card reader` category = `Computer System Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1069.jpg` quantity = 22 deliverydate = `1783555200000` )
      ( name = `Proctra X` category = `Graphic Cards` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1070.jpg` quantity = 15 deliverydate = `1783209600000` )
      ( name = `Gladiator MX` category = `Graphic Cards` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1071.jpg` quantity = 16 deliverydate = `1782864000000` )
      ( name = `Hurricane GX` category = `Graphic Cards` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1072.jpg` quantity = 13 deliverydate = `1782518400000` )
      ( name = `Hurricane GX/LN` category = `Graphic Cards` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1073.jpg` quantity = 5 deliverydate = `1782172800000` )
      ( name = `Photo Scan` category = `Scanners` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1080.jpg` quantity = 8 deliverydate = `1781827200000` )
      ( name = `Power Scan` category = `Scanners` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1081.jpg` quantity = 11 deliverydate = `1784937600000` )
      ( name = `Jet Scan Professional` category = `Scanners` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1082.jpg` quantity = 13 deliverydate = `1784592000000` )
      ( name = `Jet Scan Professional` category = `Scanners` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1083.jpg` quantity = 10 deliverydate = `1784246400000` )
      ( name = `Copymaster` category = `Multifunction Printers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1085.jpg` quantity = 10 deliverydate = `1783900800000` )
      ( name = `Surround Sound` category = `Speakers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1090.jpg` quantity = 20 deliverydate = `1783555200000` )
      ( name = `Blaster Extreme` category = `Speakers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1091.jpg` quantity = 15 deliverydate = `1783209600000` )
      ( name = `Sound Booster` category = `Speakers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1092.jpg` quantity = 50 deliverydate = `1782864000000` )
      ( name = `Lovely Sound 5.1 Wireless` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1095.jpg` quantity = 12 deliverydate = `1782518400000` )
      ( name = `Lovely Sound 5.1` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1096.jpg` quantity = 18 deliverydate = `1782172800000` )
      ( name = `Lovely Sound Stereo` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1097.jpg` quantity = 21 deliverydate = `1781827200000` )
      ( name = `Smart Office` category = `Software` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1100.jpg` quantity = 25 deliverydate = `1784937600000` )
      ( name = `Smart Design` category = `Software` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1101.jpg` quantity = 26 deliverydate = `1784592000000` )
      ( name = `Smart Network` category = `Software` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1102.jpg` quantity = 28 deliverydate = `1784246400000` )
      ( name = `Smart Multimedia` category = `Software` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1103.jpg` quantity = 9 deliverydate = `1783900800000` )
      ( name = `Smart Games` category = `Software` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1104.jpg` quantity = 13 deliverydate = `1783555200000` )
      ( name = `Smart Internet Antivirus` category = `Software` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1105.jpg` quantity = 17 deliverydate = `1783209600000` )
      ( name = `Smart Firewall` category = `Software` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1106.jpg` quantity = 19 deliverydate = `1782864000000` )
      ( name = `Smart Money` category = `Software` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1107.jpg` quantity = 18 deliverydate = `1782518400000` )
      ( name = `PC Lock` category = `Computer System Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1110.jpg` quantity = 14 deliverydate = `1782172800000` )
      ( name = `Notebook Lock` category = `Computer System Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1111.jpg` quantity = 20 deliverydate = `1781827200000` )
      ( name = `Web cam reality` category = `Computer System Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1112.jpg` quantity = 27 deliverydate = `1784937600000` )
      ( name = `Screen clean` category = `Computer System Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1113.jpg` quantity = 17 deliverydate = `1784592000000` )
      ( name = `Fabric bag professional` category = `Computer System Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1114.jpg` quantity = 14 deliverydate = `1784246400000` )
      ( name = `Wireless DSL Router` category = `Telecommunications` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1115.jpg` quantity = 16 deliverydate = `1783900800000` )
      ( name = `Wireless DSL Router / Repeater` category = `Telecommunications` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1116.jpg` quantity = 12 deliverydate = `1783555200000` )
      ( name = `Wireless DSL Router / Repeater and Print Server` category = `Telecommunications` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1117.jpg` quantity = 12 deliverydate = `1783209600000` )
      ( name = `USB Stick` category = `Computer System Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1118.jpg` quantity = 14 deliverydate = `1782864000000` )
      ( name = `Travel Adapter` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1119.jpg` quantity = 10 deliverydate = `1782518400000` )
      ( name = `Cordless Bluetooth Keyboard, english international` category = `Keyboards` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1120.jpg` quantity = 13 deliverydate = `1782172800000` )
      ( name = `Flat XXL` category = `Flat Screen Monitors` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1137.jpg` quantity = 10 deliverydate = `1781827200000` )
      ( name = `Pocket Mouse` category = `Mice` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1138.jpg` quantity = 20 deliverydate = `1784937600000` )
      ( name = `PC Power Station` category = `PCs` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1210.jpg` quantity = 22 deliverydate = `1784592000000` )
      ( name = `Astro Laptop 1516` category = `Laptops` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1251.jpg` quantity = 23 deliverydate = `1784246400000` )
      ( name = `Astro Phone 6` category = `Smartphones and Tablets` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1252.jpg` quantity = 28 deliverydate = `1783900800000` )
      ( name = `Benda Laptop 1408` category = `Laptops` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1253.jpg` quantity = 27 deliverydate = `1783555200000` )
      ( name = `Bending Screen 21HD` category = `Flat Screens` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1254.jpg` quantity = 23 deliverydate = `1783209600000` )
      ( name = `Broad Screen 22HD` category = `Flat Screens` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1255.jpg` quantity = 5 deliverydate = `1782864000000` )
      ( name = `Cerdik Phone 7` category = `Smartphones and Tablets` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1256.jpg` quantity = 19 deliverydate = `1782518400000` )
      ( name = `Cepat Tablet 10.5` category = `Smartphones and Tablets` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1257.jpg` quantity = 17 deliverydate = `1782172800000` )
      ( name = `Cepat Tablet 8` category = `Smartphones and Tablets` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1258.jpg` quantity = 24 deliverydate = `1781827200000` )
      ( name = `Server Basic` category = `Servers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1500.jpg` quantity = 24 deliverydate = `1784937600000` )
      ( name = `Server Professional` category = `Servers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1501.jpg` quantity = 26 deliverydate = `1784592000000` )
      ( name = `Server Power Pro` category = `Servers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1502.jpg` quantity = 34 deliverydate = `1784246400000` )
      ( name = `Family PC Basic` category = `Desktop Computers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1600.jpg` quantity = 10 deliverydate = `1783900800000` )
      ( name = `Family PC Pro` category = `Desktop Computers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1601.jpg` quantity = 20 deliverydate = `1783555200000` )
      ( name = `Gaming Monster` category = `Desktop Computers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1602.jpg` quantity = 24 deliverydate = `1783209600000` )
      ( name = `Gaming Monster Pro` category = `Desktop Computers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1603.jpg` quantity = 25 deliverydate = `1782864000000` )
      ( name = `7" Widescreen Portable DVD Player w MP3` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2000.jpg` quantity = 20 deliverydate = `1782518400000` )
      ( name = `10" Portable DVD player` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2001.jpg` quantity = 21 deliverydate = `1782172800000` )
      ( name = `Portable DVD Player with 9" LCD Monitor` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2002.jpg` quantity = 50 deliverydate = `1781827200000` )
      ( name = `CD/DVD case: 264 sleeves` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2025.jpg` quantity = 26 deliverydate = `1784937600000` )
      ( name = `Audio/Video Cable Kit - 4m` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2026.jpg` quantity = 16 deliverydate = `1784592000000` )
      ( name = `Removable CD/DVD Laser Labels` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2027.jpg` quantity = 25 deliverydate = `1784246400000` )
      ( name = `Beam Breaker B-1` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6100.jpg` quantity = 32 deliverydate = `1783900800000` )
      ( name = `Beam Breaker B-2` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6101.jpg` quantity = 18 deliverydate = `1783555200000` )
      ( name = `Beam Breaker B-3` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6102.jpg` quantity = 16 deliverydate = `1783209600000` )
      ( name = `Play Movie` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6110.jpg` quantity = 15 deliverydate = `1782864000000` )
      ( name = `Record Movie` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6111.jpg` quantity = 24 deliverydate = `1782518400000` )
      ( name = `ITelo MusicStick` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6120.jpg` quantity = 15 deliverydate = `1782172800000` )
      ( name = `ITelo Jog-Mate` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6121.jpg` quantity = 24 deliverydate = `1781827200000` )
      ( name = `Power Pro Player 40` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6122.jpg` quantity = 23 deliverydate = `1784937600000` )
      ( name = `Power Pro Player 80` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6123.jpg` quantity = 13 deliverydate = `1784592000000` )
      ( name = `Flat Watch HD32` category = `Flat Screen TVs` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6130.jpg` quantity = 16 deliverydate = `1784246400000` )
      ( name = `Flat Watch HD37` category = `Flat Screen TVs` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6131.jpg` quantity = 14 deliverydate = `1783900800000` )
      ( name = `Flat Watch HD41` category = `Flat Screen TVs` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6132.jpg` quantity = 13 deliverydate = `1783555200000` )
      ( name = `Copperberry` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7000.jpg` quantity = 5 deliverydate = `1783209600000` )
      ( name = `Silverberry` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7010.jpg` quantity = 9 deliverydate = `1782864000000` )
      ( name = `Goldberry` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7020.jpg` quantity = 11 deliverydate = `1782518400000` )
      ( name = `Platinberry` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7030.jpg` quantity = 12 deliverydate = `1782172800000` )
      ( name = `ITelO FlexTop I4000` category = `Laptops` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8000.jpg` quantity = 11 deliverydate = `1781827200000` )
      ( name = `ITelO FlexTop I6300c` category = `Laptops` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8001.jpg` quantity = 20 deliverydate = `1784937600000` )
      ( name = `ITelO FlexTop I9100` category = `Laptops` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8002.jpg` quantity = 20 deliverydate = `1784592000000` )
      ( name = `ITelO FlexTop I9800` category = `Laptops` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8003.jpg` quantity = 22 deliverydate = `1784246400000` )
      ( name = `Smartphone Leather Case` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9991.jpg` quantity = 12 deliverydate = `1783900800000` )
      ( name = `Smartphone Alpha` category = `Smartphones and Tablets` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9992.jpg` quantity = 13 deliverydate = `1783555200000` )
      ( name = `Mini Tablet` category = `Smartphones and Tablets` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9993.jpg` quantity = 10 deliverydate = `1783209600000` )
      ( name = `Camcorder View` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9994.jpg` quantity = 50 deliverydate = `1782864000000` )
      ( name = `Tablet Pouch` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9995.jpg` quantity = 34 deliverydate = `1782518400000` )
      ( name = `Tablet Pouch` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9996.jpg` quantity = 34 deliverydate = `1782172800000` )
      ( name = `e-Book Reader ReadMe` category = `Smartphones and Tablets` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9997.jpg` quantity = 23 deliverydate = `1781827200000` )
      ( name = `Smartphone Beta` category = `Smartphones and Tablets` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9998.jpg` quantity = 21 deliverydate = `1784937600000` )
      ( name = `Maxi Tablet` category = `Tablets` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9999.jpg` quantity = 20 deliverydate = `1784592000000` )
      ( name = `Flyer` category = `Accessories` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/PF-1000.jpg` quantity = 33 deliverydate = `1784246400000` )
      ).

  ENDMETHOD.

ENDCLASS.
