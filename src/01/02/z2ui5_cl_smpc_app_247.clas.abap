" @keywords table sap.ui.table columnresizing overflowtoolbar title column label text link segmentedbutton segmentedbuttonitem
" @summary Example for column resizing
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
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

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
    DATA temp2 TYPE z2ui5_if_client=>ty_s_event_control.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `${$parameters>/column}.getId()` INTO TABLE temp1.
    INSERT `${$parameters>/column}.getLabel().getText()` INTO TABLE temp1.
    INSERT `${$parameters>/width}` INTO TABLE temp1.
    
    CLEAR temp2.
    temp2-prevent_default_expr = `${$parameters>/column}.getId().indexOf('deliverydate') >= 0`.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.ui.table`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:u`   v = `sap.ui.unified`
        )->a( n = `xmlns:c`   v = `sap.ui.core`
        )->a( n = `xmlns:m`   v = `sap.m`
        )->a( n = `height`    v = `100%`

        )->ele( n = `Page` ns = `m`
            )->a( n = `showHeader` v = `false`
            )->a( n = `class`      v = `sapUiContentPadding`

            )->ele( n = `content` ns = `m`

                )->ele( `Table`
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
                              t_arg  = temp1
                              s_ctrl = temp2 )
                    )->a( n = `ariaLabelledBy` v = `title`

                    )->ele( `extension`
                        )->ele( n = `OverflowToolbar` ns = `m`
                            )->a( n = `style` v = `Clear`
                            )->tag( n = `Title` ns = `m`
                                )->a( n = `id`   v = `title`
                                )->a( n = `text` v = `Products`

                        )->end(
                    )->end(
                    )->ele( `columns`

                        )->ele( `Column`
                            )->a( n = `width`          v = client->_bind( name )
                            )->a( n = `filterProperty` v = `NAME`
                            )->a( n = `resizable`      v = `true`
                            )->a( n = `autoResizable`  v = `true`
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Product Name`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{NAME}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `width`          v = client->_bind( category )
                            )->a( n = `resizable`      v = `true`
                            )->a( n = `filterProperty` v = `CATEGORY`
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Category`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{CATEGORY}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `width`     v = client->_bind( image )
                            )->a( n = `resizable` v = `false`
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
                            )->a( n = `width`     v = client->_bind( quantity )
                            )->a( n = `resizable` v = `false`
                            )->a( n = `hAlign`    v = `End`
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Quantity`

                            )->ele( `template`
                                )->tag( n = `Label` ns = `m`
                                    )->a( n = `text` v = |\{ path: 'QUANTITY', type: 'sap.ui.model.type.Integer' \}|

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `id`    v = `deliverydate`
                            )->a( n = `width` v = client->_bind( date )
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Delivery Date`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = |\{ path: 'DELIVERYDATE', type: 'sap.ui.model.type.Date', formatOptions: \{ source: \{ pattern: 'timestamp' \} \} \}|
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                    )->end(
                    )->ele( `footer`
                        )->ele( n = `OverflowToolbar` ns = `m`
                            )->a( n = `id` v = `infobar`
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text`     v = `Column Widths:`
                                )->a( n = `labelFor` v = `columnWidths`
                            )->ele( n = `SegmentedButton` ns = `m`
                                )->a( n = `id`              v = `columnWidths`
                                )->a( n = `selectedKey`     v = `Static`
                                )->a( n = `selectionChange` v = client->_event( val = `WIDTHS_CHANGE` arg = `${$parameters>/item}.getKey()` )

                                )->ele( n = `items` ns = `m`
                                    )->tag( n = `SegmentedButtonItem` ns = `m`
                                        )->a( n = `icon`    v = `sap-icon://color-fill`
                                        )->a( n = `key`     v = `Static`
                                        )->a( n = `tooltip` v = `Static`
                                    )->tag( n = `SegmentedButtonItem` ns = `m`
                                        )->a( n = `icon`    v = `sap-icon://overlay`
                                        )->a( n = `key`     v = `Flexible`
                                        )->a( n = `tooltip` v = `Flexible`
                                    )->tag( n = `SegmentedButtonItem` ns = `m`
                                        )->a( n = `icon`    v = `sap-icon://business-objects-mobile`
                                        )->a( n = `key`     v = `Mixed`
                                        )->a( n = `tooltip` v = `Mixed`

                                )->end(
                            )->end(
                        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA column_id TYPE string.

    CASE client->get_event( ).
      WHEN `WIDTHS_CHANGE`.
        set_widths( client->get_event_arg( ) ).

      WHEN `COLUMN_RESIZE`.
        " the client already vetoed the delivery-date column before the
        " roundtrip; the event arrives either way, so the if/else of the
        " original's handler is reproduced here - the vetoed column reports
        " nothing, every other one gets the sample's own message text
        
        column_id = client->get_event_arg( ).
        IF column_id NS `deliverydate`.
          client->message_toast_display( |Column '{ client->get_event_arg( 2 ) }' was resized to { client->get_event_arg( 3 ) }.| ).
        ENDIF.
    ENDCASE.

  ENDMETHOD.


  METHOD set_widths.

    CASE mode.

      WHEN `Flexible`.
        name     = `25%`.
        category = `25%`.
        image    = `15%`.
        quantity = `10%`.
        date     = `25%`.

      WHEN `Mixed`.
        name     = `20%`.
        category = `11rem`.
        image    = `7rem`.
        quantity = `6rem`.
        date     = `9rem`.

      WHEN OTHERS.
        name     = `13rem`.
        category = `11rem`.
        image    = `7rem`.
        quantity = `6rem`.
        date     = `9rem`.

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.
    DATA temp3 LIKE t_products.
    DATA temp4 LIKE LINE OF temp3.

    set_widths( `Static` ).

    
    CLEAR temp3.
    
    temp4-name = `Notebook Basic 15`.
    temp4-category = `Laptops`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg`.
    temp4-quantity = 10.
    temp4-deliverydate = `1784937600000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Basic 17`.
    temp4-category = `Laptops`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1001.jpg`.
    temp4-quantity = 20.
    temp4-deliverydate = `1784592000000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Basic 18`.
    temp4-category = `Laptops`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1002.jpg`.
    temp4-quantity = 10.
    temp4-deliverydate = `1784246400000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Basic 19`.
    temp4-category = `Laptops`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1003.jpg`.
    temp4-quantity = 15.
    temp4-deliverydate = `1783900800000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO Vault`.
    temp4-category = `Accessories`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1007.jpg`.
    temp4-quantity = 15.
    temp4-deliverydate = `1783555200000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Professional 15`.
    temp4-category = `Accessories`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg`.
    temp4-quantity = 16.
    temp4-deliverydate = `1783209600000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Professional 17`.
    temp4-category = `Laptops`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1011.jpg`.
    temp4-quantity = 17.
    temp4-deliverydate = `1782864000000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO Vault Net`.
    temp4-category = `Accessories`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1020.jpg`.
    temp4-quantity = 14.
    temp4-deliverydate = `1782518400000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO Vault SAT`.
    temp4-category = `Accessories`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1021.jpg`.
    temp4-quantity = 50.
    temp4-deliverydate = `1782172800000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Comfort Easy`.
    temp4-category = `Accessories`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1022.jpg`.
    temp4-quantity = 30.
    temp4-deliverydate = `1781827200000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Comfort Senior`.
    temp4-category = `Accessories`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1023.jpg`.
    temp4-quantity = 24.
    temp4-deliverydate = `1784937600000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergo Screen E-I`.
    temp4-category = `Flat Screen Monitors`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1030.jpg`.
    temp4-quantity = 14.
    temp4-deliverydate = `1784592000000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergo Screen E-II`.
    temp4-category = `Flat Screen Monitors`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1031.jpg`.
    temp4-quantity = 24.
    temp4-deliverydate = `1784246400000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergo Screen E-III`.
    temp4-category = `Flat Screen Monitors`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1032.jpg`.
    temp4-quantity = 50.
    temp4-deliverydate = `1783900800000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Basic`.
    temp4-category = `Flat Screen Monitors`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1035.jpg`.
    temp4-quantity = 23.
    temp4-deliverydate = `1783555200000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Future`.
    temp4-category = `Flat Screen Monitors`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1036.jpg`.
    temp4-quantity = 22.
    temp4-deliverydate = `1783209600000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat XL`.
    temp4-category = `Flat Screen Monitors`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1037.jpg`.
    temp4-quantity = 23.
    temp4-deliverydate = `1782864000000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Laser Professional Eco`.
    temp4-category = `Printers`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1040.jpg`.
    temp4-quantity = 21.
    temp4-deliverydate = `1782518400000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Laser Basic`.
    temp4-category = `Printers`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1041.jpg`.
    temp4-quantity = 8.
    temp4-deliverydate = `1782172800000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Laser Allround`.
    temp4-category = `Printers`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1042.jpg`.
    temp4-quantity = 9.
    temp4-deliverydate = `1781827200000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ultra Jet Super Color`.
    temp4-category = `Printers`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1050.jpg`.
    temp4-quantity = 17.
    temp4-deliverydate = `1784937600000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ultra Jet Mobile`.
    temp4-category = `Printers`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1051.jpg`.
    temp4-quantity = 18.
    temp4-deliverydate = `1784592000000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ultra Jet Super Highspeed`.
    temp4-category = `Printers`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1052.jpg`.
    temp4-quantity = 25.
    temp4-deliverydate = `1784246400000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Multi Print`.
    temp4-category = `Multifunction Printers`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1055.jpg`.
    temp4-quantity = 16.
    temp4-deliverydate = `1783900800000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Multi Color`.
    temp4-category = `Multifunction Printers`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1056.jpg`.
    temp4-quantity = 5.
    temp4-deliverydate = `1783555200000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cordless Mouse`.
    temp4-category = `Mice`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1060.jpg`.
    temp4-quantity = 25.
    temp4-deliverydate = `1783209600000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Speed Mouse`.
    temp4-category = `Mice`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1061.jpg`.
    temp4-quantity = 12.
    temp4-deliverydate = `1782864000000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Track Mouse`.
    temp4-category = `Mice`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1062.jpg`.
    temp4-quantity = 12.
    temp4-deliverydate = `1782518400000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergonomic Keyboard`.
    temp4-category = `Keyboards`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1063.jpg`.
    temp4-quantity = 50.
    temp4-deliverydate = `1782172800000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Internet Keyboard`.
    temp4-category = `Keyboards`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1064.jpg`.
    temp4-quantity = 35.
    temp4-deliverydate = `1781827200000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Media Keyboard`.
    temp4-category = `Keyboards`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1065.jpg`.
    temp4-quantity = 26.
    temp4-deliverydate = `1784937600000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Mousepad`.
    temp4-category = `Mousepads`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1066.jpg`.
    temp4-quantity = 12.
    temp4-deliverydate = `1784592000000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergo Mousepad`.
    temp4-category = `Mousepads`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1067.jpg`.
    temp4-quantity = 16.
    temp4-deliverydate = `1784246400000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Designer Mousepad`.
    temp4-category = `Mousepads`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1068.jpg`.
    temp4-quantity = 26.
    temp4-deliverydate = `1783900800000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Universal card reader`.
    temp4-category = `Computer System Accessories`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1069.jpg`.
    temp4-quantity = 22.
    temp4-deliverydate = `1783555200000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Proctra X`.
    temp4-category = `Graphic Cards`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1070.jpg`.
    temp4-quantity = 15.
    temp4-deliverydate = `1783209600000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Gladiator MX`.
    temp4-category = `Graphic Cards`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1071.jpg`.
    temp4-quantity = 16.
    temp4-deliverydate = `1782864000000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Hurricane GX`.
    temp4-category = `Graphic Cards`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1072.jpg`.
    temp4-quantity = 13.
    temp4-deliverydate = `1782518400000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Hurricane GX/LN`.
    temp4-category = `Graphic Cards`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1073.jpg`.
    temp4-quantity = 5.
    temp4-deliverydate = `1782172800000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Photo Scan`.
    temp4-category = `Scanners`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1080.jpg`.
    temp4-quantity = 8.
    temp4-deliverydate = `1781827200000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Power Scan`.
    temp4-category = `Scanners`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1081.jpg`.
    temp4-quantity = 11.
    temp4-deliverydate = `1784937600000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Jet Scan Professional`.
    temp4-category = `Scanners`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1082.jpg`.
    temp4-quantity = 13.
    temp4-deliverydate = `1784592000000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Jet Scan Professional`.
    temp4-category = `Scanners`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1083.jpg`.
    temp4-quantity = 10.
    temp4-deliverydate = `1784246400000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Copymaster`.
    temp4-category = `Multifunction Printers`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1085.jpg`.
    temp4-quantity = 10.
    temp4-deliverydate = `1783900800000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Surround Sound`.
    temp4-category = `Speakers`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1090.jpg`.
    temp4-quantity = 20.
    temp4-deliverydate = `1783555200000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Blaster Extreme`.
    temp4-category = `Speakers`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1091.jpg`.
    temp4-quantity = 15.
    temp4-deliverydate = `1783209600000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Sound Booster`.
    temp4-category = `Speakers`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1092.jpg`.
    temp4-quantity = 50.
    temp4-deliverydate = `1782864000000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Lovely Sound 5.1 Wireless`.
    temp4-category = `Accessories`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1095.jpg`.
    temp4-quantity = 12.
    temp4-deliverydate = `1782518400000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Lovely Sound 5.1`.
    temp4-category = `Accessories`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1096.jpg`.
    temp4-quantity = 18.
    temp4-deliverydate = `1782172800000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Lovely Sound Stereo`.
    temp4-category = `Accessories`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1097.jpg`.
    temp4-quantity = 21.
    temp4-deliverydate = `1781827200000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Office`.
    temp4-category = `Software`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1100.jpg`.
    temp4-quantity = 25.
    temp4-deliverydate = `1784937600000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Design`.
    temp4-category = `Software`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1101.jpg`.
    temp4-quantity = 26.
    temp4-deliverydate = `1784592000000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Network`.
    temp4-category = `Software`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1102.jpg`.
    temp4-quantity = 28.
    temp4-deliverydate = `1784246400000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Multimedia`.
    temp4-category = `Software`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1103.jpg`.
    temp4-quantity = 9.
    temp4-deliverydate = `1783900800000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Games`.
    temp4-category = `Software`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1104.jpg`.
    temp4-quantity = 13.
    temp4-deliverydate = `1783555200000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Internet Antivirus`.
    temp4-category = `Software`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1105.jpg`.
    temp4-quantity = 17.
    temp4-deliverydate = `1783209600000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Firewall`.
    temp4-category = `Software`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1106.jpg`.
    temp4-quantity = 19.
    temp4-deliverydate = `1782864000000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Money`.
    temp4-category = `Software`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1107.jpg`.
    temp4-quantity = 18.
    temp4-deliverydate = `1782518400000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `PC Lock`.
    temp4-category = `Computer System Accessories`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1110.jpg`.
    temp4-quantity = 14.
    temp4-deliverydate = `1782172800000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Lock`.
    temp4-category = `Computer System Accessories`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1111.jpg`.
    temp4-quantity = 20.
    temp4-deliverydate = `1781827200000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Web cam reality`.
    temp4-category = `Computer System Accessories`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1112.jpg`.
    temp4-quantity = 27.
    temp4-deliverydate = `1784937600000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Screen clean`.
    temp4-category = `Computer System Accessories`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1113.jpg`.
    temp4-quantity = 17.
    temp4-deliverydate = `1784592000000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Fabric bag professional`.
    temp4-category = `Computer System Accessories`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1114.jpg`.
    temp4-quantity = 14.
    temp4-deliverydate = `1784246400000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Wireless DSL Router`.
    temp4-category = `Telecommunications`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1115.jpg`.
    temp4-quantity = 16.
    temp4-deliverydate = `1783900800000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Wireless DSL Router / Repeater`.
    temp4-category = `Telecommunications`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1116.jpg`.
    temp4-quantity = 12.
    temp4-deliverydate = `1783555200000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Wireless DSL Router / Repeater and Print Server`.
    temp4-category = `Telecommunications`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1117.jpg`.
    temp4-quantity = 12.
    temp4-deliverydate = `1783209600000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `USB Stick`.
    temp4-category = `Computer System Accessories`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1118.jpg`.
    temp4-quantity = 14.
    temp4-deliverydate = `1782864000000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Travel Adapter`.
    temp4-category = `Accessories`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1119.jpg`.
    temp4-quantity = 10.
    temp4-deliverydate = `1782518400000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cordless Bluetooth Keyboard, english international`.
    temp4-category = `Keyboards`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1120.jpg`.
    temp4-quantity = 13.
    temp4-deliverydate = `1782172800000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat XXL`.
    temp4-category = `Flat Screen Monitors`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1137.jpg`.
    temp4-quantity = 10.
    temp4-deliverydate = `1781827200000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Pocket Mouse`.
    temp4-category = `Mice`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1138.jpg`.
    temp4-quantity = 20.
    temp4-deliverydate = `1784937600000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `PC Power Station`.
    temp4-category = `PCs`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1210.jpg`.
    temp4-quantity = 22.
    temp4-deliverydate = `1784592000000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Astro Laptop 1516`.
    temp4-category = `Laptops`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1251.jpg`.
    temp4-quantity = 23.
    temp4-deliverydate = `1784246400000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Astro Phone 6`.
    temp4-category = `Smartphones and Tablets`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1252.jpg`.
    temp4-quantity = 28.
    temp4-deliverydate = `1783900800000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Benda Laptop 1408`.
    temp4-category = `Laptops`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1253.jpg`.
    temp4-quantity = 27.
    temp4-deliverydate = `1783555200000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Bending Screen 21HD`.
    temp4-category = `Flat Screens`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1254.jpg`.
    temp4-quantity = 23.
    temp4-deliverydate = `1783209600000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Broad Screen 22HD`.
    temp4-category = `Flat Screens`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1255.jpg`.
    temp4-quantity = 5.
    temp4-deliverydate = `1782864000000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cerdik Phone 7`.
    temp4-category = `Smartphones and Tablets`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1256.jpg`.
    temp4-quantity = 19.
    temp4-deliverydate = `1782518400000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cepat Tablet 10.5`.
    temp4-category = `Smartphones and Tablets`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1257.jpg`.
    temp4-quantity = 17.
    temp4-deliverydate = `1782172800000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cepat Tablet 8`.
    temp4-category = `Smartphones and Tablets`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1258.jpg`.
    temp4-quantity = 24.
    temp4-deliverydate = `1781827200000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Server Basic`.
    temp4-category = `Servers`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1500.jpg`.
    temp4-quantity = 24.
    temp4-deliverydate = `1784937600000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Server Professional`.
    temp4-category = `Servers`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1501.jpg`.
    temp4-quantity = 26.
    temp4-deliverydate = `1784592000000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Server Power Pro`.
    temp4-category = `Servers`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1502.jpg`.
    temp4-quantity = 34.
    temp4-deliverydate = `1784246400000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Family PC Basic`.
    temp4-category = `Desktop Computers`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1600.jpg`.
    temp4-quantity = 10.
    temp4-deliverydate = `1783900800000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Family PC Pro`.
    temp4-category = `Desktop Computers`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1601.jpg`.
    temp4-quantity = 20.
    temp4-deliverydate = `1783555200000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Gaming Monster`.
    temp4-category = `Desktop Computers`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1602.jpg`.
    temp4-quantity = 24.
    temp4-deliverydate = `1783209600000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Gaming Monster Pro`.
    temp4-category = `Desktop Computers`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1603.jpg`.
    temp4-quantity = 25.
    temp4-deliverydate = `1782864000000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `7" Widescreen Portable DVD Player w MP3`.
    temp4-category = `Accessories`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2000.jpg`.
    temp4-quantity = 20.
    temp4-deliverydate = `1782518400000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `10" Portable DVD player`.
    temp4-category = `Accessories`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2001.jpg`.
    temp4-quantity = 21.
    temp4-deliverydate = `1782172800000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Portable DVD Player with 9" LCD Monitor`.
    temp4-category = `Accessories`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2002.jpg`.
    temp4-quantity = 50.
    temp4-deliverydate = `1781827200000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `CD/DVD case: 264 sleeves`.
    temp4-category = `Accessories`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2025.jpg`.
    temp4-quantity = 26.
    temp4-deliverydate = `1784937600000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Audio/Video Cable Kit - 4m`.
    temp4-category = `Accessories`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2026.jpg`.
    temp4-quantity = 16.
    temp4-deliverydate = `1784592000000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Removable CD/DVD Laser Labels`.
    temp4-category = `Accessories`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2027.jpg`.
    temp4-quantity = 25.
    temp4-deliverydate = `1784246400000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Beam Breaker B-1`.
    temp4-category = `Accessories`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6100.jpg`.
    temp4-quantity = 32.
    temp4-deliverydate = `1783900800000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Beam Breaker B-2`.
    temp4-category = `Accessories`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6101.jpg`.
    temp4-quantity = 18.
    temp4-deliverydate = `1783555200000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Beam Breaker B-3`.
    temp4-category = `Accessories`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6102.jpg`.
    temp4-quantity = 16.
    temp4-deliverydate = `1783209600000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Play Movie`.
    temp4-category = `Accessories`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6110.jpg`.
    temp4-quantity = 15.
    temp4-deliverydate = `1782864000000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Record Movie`.
    temp4-category = `Accessories`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6111.jpg`.
    temp4-quantity = 24.
    temp4-deliverydate = `1782518400000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelo MusicStick`.
    temp4-category = `Accessories`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6120.jpg`.
    temp4-quantity = 15.
    temp4-deliverydate = `1782172800000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelo Jog-Mate`.
    temp4-category = `Accessories`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6121.jpg`.
    temp4-quantity = 24.
    temp4-deliverydate = `1781827200000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Power Pro Player 40`.
    temp4-category = `Accessories`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6122.jpg`.
    temp4-quantity = 23.
    temp4-deliverydate = `1784937600000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Power Pro Player 80`.
    temp4-category = `Accessories`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6123.jpg`.
    temp4-quantity = 13.
    temp4-deliverydate = `1784592000000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Watch HD32`.
    temp4-category = `Flat Screen TVs`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6130.jpg`.
    temp4-quantity = 16.
    temp4-deliverydate = `1784246400000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Watch HD37`.
    temp4-category = `Flat Screen TVs`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6131.jpg`.
    temp4-quantity = 14.
    temp4-deliverydate = `1783900800000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Watch HD41`.
    temp4-category = `Flat Screen TVs`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6132.jpg`.
    temp4-quantity = 13.
    temp4-deliverydate = `1783555200000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Copperberry`.
    temp4-category = `Accessories`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7000.jpg`.
    temp4-quantity = 5.
    temp4-deliverydate = `1783209600000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Silverberry`.
    temp4-category = `Accessories`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7010.jpg`.
    temp4-quantity = 9.
    temp4-deliverydate = `1782864000000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Goldberry`.
    temp4-category = `Accessories`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7020.jpg`.
    temp4-quantity = 11.
    temp4-deliverydate = `1782518400000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Platinberry`.
    temp4-category = `Accessories`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7030.jpg`.
    temp4-quantity = 12.
    temp4-deliverydate = `1782172800000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO FlexTop I4000`.
    temp4-category = `Laptops`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8000.jpg`.
    temp4-quantity = 11.
    temp4-deliverydate = `1781827200000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO FlexTop I6300c`.
    temp4-category = `Laptops`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8001.jpg`.
    temp4-quantity = 20.
    temp4-deliverydate = `1784937600000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO FlexTop I9100`.
    temp4-category = `Laptops`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8002.jpg`.
    temp4-quantity = 20.
    temp4-deliverydate = `1784592000000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO FlexTop I9800`.
    temp4-category = `Laptops`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8003.jpg`.
    temp4-quantity = 22.
    temp4-deliverydate = `1784246400000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smartphone Leather Case`.
    temp4-category = `Accessories`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9991.jpg`.
    temp4-quantity = 12.
    temp4-deliverydate = `1783900800000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smartphone Alpha`.
    temp4-category = `Smartphones and Tablets`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9992.jpg`.
    temp4-quantity = 13.
    temp4-deliverydate = `1783555200000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Mini Tablet`.
    temp4-category = `Smartphones and Tablets`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9993.jpg`.
    temp4-quantity = 10.
    temp4-deliverydate = `1783209600000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Camcorder View`.
    temp4-category = `Accessories`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9994.jpg`.
    temp4-quantity = 50.
    temp4-deliverydate = `1782864000000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Tablet Pouch`.
    temp4-category = `Accessories`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9995.jpg`.
    temp4-quantity = 34.
    temp4-deliverydate = `1782518400000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Tablet Pouch`.
    temp4-category = `Accessories`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9996.jpg`.
    temp4-quantity = 34.
    temp4-deliverydate = `1782172800000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `e-Book Reader ReadMe`.
    temp4-category = `Smartphones and Tablets`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9997.jpg`.
    temp4-quantity = 23.
    temp4-deliverydate = `1781827200000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smartphone Beta`.
    temp4-category = `Smartphones and Tablets`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9998.jpg`.
    temp4-quantity = 21.
    temp4-deliverydate = `1784937600000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Maxi Tablet`.
    temp4-category = `Tablets`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9999.jpg`.
    temp4-quantity = 20.
    temp4-deliverydate = `1784592000000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flyer`.
    temp4-category = `Accessories`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/PF-1000.jpg`.
    temp4-quantity = 33.
    temp4-deliverydate = `1784246400000`.
    INSERT temp4 INTO TABLE temp3.
    t_products = temp3.

  ENDMETHOD.

ENDCLASS.
