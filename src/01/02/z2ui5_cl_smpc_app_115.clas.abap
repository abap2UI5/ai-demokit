" @keywords table sap.ui.table grid overflowtoolbar title column label text input objectstatus currency combobox
" @summary Basic example showing most controls which are intended to be used inside a table.
CLASS z2ui5_cl_smpc_app_115 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_token,
             key  TYPE string,
             name TYPE string,
           END OF ty_s_token.
    TYPES: BEGIN OF ty_s_named,
             name TYPE string,
           END OF ty_s_named.
    TYPES: BEGIN OF ty_s_product,
             productid                     TYPE string,
             name                          TYPE string,
             quantity                      TYPE i,
             status                        TYPE string,
             price                         TYPE p LENGTH 9 DECIMALS 2,
             currencycode                  TYPE string,
             suppliername                  TYPE string,
             productpicurl                 TYPE string,
             category                      TYPE string,
             weightmeasure                 TYPE p LENGTH 9 DECIMALS 3,
             " derived in initSampleDataModel, reproduced in model_init
             available                     TYPE abap_bool,
             availablestate                TYPE string,
             availableicon                 TYPE string,
             heavy                         TYPE string,
             deliverydate                  TYPE string,
             " the MultiInput column: the sample's rows carry neither key, so both
             " start empty and the token table grows through the tokenUpdate wire
             additionalcategory            TYPE string,
             additionalcategoriesselection TYPE STANDARD TABLE OF ty_s_token WITH EMPTY KEY,
           END OF ty_s_product.
    DATA productcollection TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.
    DATA suppliers         TYPE STANDARD TABLE OF ty_s_named WITH EMPTY KEY.
    DATA categories        TYPE STANDARD TABLE OF ty_s_named WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_115 IMPLEMENTATION.

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

    " the full sample: all THIRTEEN columns over the shared demo mock, with the
    " Suppliers/Categories arrays the controller derives from it. The two
    " Available formatters are computed in ABAP (thin-frontend rule) into
    " AVAILABLESTATE / AVAILABLEICON, and the DatePicker binding keeps its type
    " but takes an ISO source pattern instead of the original timestamp - the
    " model carries a date STRING, not a JS epoch number (CAPABILITIES date row)
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.ui.table`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:u`   v = `sap.ui.unified`
        )->a( n = `xmlns:c`   v = `sap.ui.core`
        )->a( n = `xmlns:m`   v = `sap.m`
        )->a( n = `height`    v = `100%`

        )->ele( n = `Page` ns = `m`
            )->a( n = `showHeader`       v = `false`
            )->a( n = `enableScrolling`  v = `false`
            )->a( n = `class`            v = `sapUiContentPadding`

            )->ele( n = `content` ns = `m`
                )->ele( `Table`
                    )->a( n = `rows`           v = client->_bind( productcollection )
                    )->a( n = `selectionMode`  v = `MultiToggle`
                    " onPaste toasts the pasted data - composed on the client
                    )->a( n = `paste`          v = client->follow_up_action(
                              val   = client->cs_event-control_global
                              t_arg = VALUE #( ( `MESSAGE_TOAST` )
                                               ( `show` )
                                               ( `Pasted Data: {0}` )
                                               ( `${$parameters>/data}` ) ) )
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
                            )->a( n = `width` v = `11rem`
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Product Name`
                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{NAME}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `width` v = `11rem`
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Product Id`
                            )->ele( `template`
                                )->tag( n = `Input` ns = `m`
                                    )->a( n = `value` v = `{PRODUCTID}`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `width` v = `6rem`
                            )->a( n = `hAlign` v = `End`
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Quantity`
                            )->ele( `template`
                                )->tag( n = `Label` ns = `m`
                                    )->a( n = `text` v = `{QUANTITY}`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `width` v = `9rem`
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Status`
                            )->ele( `template`
                                )->tag( n = `ObjectStatus` ns = `m`
                                    )->a( n = `text`  v = `{STATUS}`
                                    )->a( n = `state` v = `{AVAILABLESTATE}`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `width` v = `9rem`
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Price`
                            )->ele( `template`
                                )->tag( n = `Currency` ns = `u`
                                    )->a( n = `value`    v = `{PRICE}`
                                    )->a( n = `currency` v = `{CURRENCYCODE}`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `width` v = `12rem`
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Supplier`
                            )->ele( `template`
                                )->ele( n = `ComboBox` ns = `m`
                                    )->a( n = `value` v = `{SUPPLIERNAME}`
                                    )->a( n = `items` v = |\{ path: '{ client->_bind( val = suppliers path = abap_true ) }', templateShareable: false \}|

                                    )->ele( n = `items` ns = `m`
                                        )->tag( n = `Item` ns = `c`
                                            )->a( n = `text` v = `{NAME}`

                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                        )->ele( `Column`
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
                            )->a( n = `width` v = `9rem`
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Details`
                            )->ele( `template`
                                " handleDetailsPress toasts the row's ProductId - the row
                                " field resolves on the client, so no round-trip
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `text`  v = `Show Details`
                                    )->a( n = `press` v = client->follow_up_action(
                                              val   = client->cs_event-control_global
                                              t_arg = VALUE #( ( `MESSAGE_TOAST` )
                                                               ( `show` )
                                                               ( `Details for product with id {0}` )
                                                               ( `${PRODUCTID}` ) ) )

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `width` v = `7rem`
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Heavy Weight`
                            )->ele( `template`
                                )->tag( n = `CheckBox` ns = `m`
                                    )->a( n = `selected` v = |\{ path: 'HEAVY', type: 'sap.ui.model.type.String' \}|

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `width` v = `12rem`
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Main Category`
                            )->ele( `template`
                                )->ele( n = `Select` ns = `m`
                                    )->a( n = `selectedKey` v = `{CATEGORY}`
                                    )->a( n = `items`       v = |\{ path: '{ client->_bind( val = categories path = abap_true ) }', templateShareable: false \}|

                                    )->ele( n = `items` ns = `m`
                                        )->tag( n = `Item` ns = `c`
                                            )->a( n = `text` v = `{NAME}`
                                            )->a( n = `key`  v = `{NAME}`

                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `width` v = `12rem`
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Additional Categories`
                            )->ele( `template`
                                )->ele( n = `MultiInput` ns = `m`
                                    " updateMultipleSelection rewrites the row's token
                                    " table after a delete - the update type, the removed
                                    " key and the row path travel, ABAP removes the entry
                                    )->a( n = `tokenUpdate`      v = client->_event(
                                              val   = `TOKEN_UPDATE`
                                              t_arg = VALUE #( ( `${$parameters>/type}` )
                                                               ( `${$parameters>/removedTokens}[0].getKey()` )
                                                               ( `$event.oSource.getBindingContext().getPath()` ) ) )
                                    )->a( n = `value`            v = `{ADDITIONALCATEGORY}`
                                    )->a( n = `tokens`           v = |\{ path: 'ADDITIONALCATEGORIESSELECTION', templateShareable: false \}|
                                    )->a( n = `suggestionItems`  v = |\{ path: '{ client->_bind( val = categories path = abap_true ) }', templateShareable: false, sorter: \{ path: 'NAME' \} \}|
                                    )->a( n = `showValueHelp`    v = `false`

                                    )->ele( n = `tokens` ns = `m`
                                        )->tag( n = `Token` ns = `m`
                                            )->a( n = `key`  v = `{KEY}`
                                            )->a( n = `text` v = `{NAME}`

                                    )->end(
                                    )->ele( n = `suggestionItems` ns = `m`
                                        )->tag( n = `Item` ns = `c`
                                            " the ORIGINAL writes key="{ProductId}" on a template bound
                                            " over /Categories, whose rows only have a Name - its own quirk,
                                            " ported verbatim (sidecar NOTE)
                                            " abap2ui5lint-disable-next-line unknown-binding-path -- the sample's own quirk
                                            )->a( n = `key`  v = `{PRODUCTID}`
                                            )->a( n = `text` v = `{NAME}`

                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `width`  v = `6rem`
                            )->a( n = `hAlign` v = `Center`
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Status`
                            )->ele( `template`
                                )->tag( n = `Icon` ns = `c`
                                    )->a( n = `src` v = `{AVAILABLEICON}`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `width`  v = `11rem`
                            )->a( n = `hAlign` v = `Center`
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Delivery Date`
                            )->ele( `template`
                                )->tag( n = `DatePicker` ns = `m`
                                    )->a( n = `value` v = |\{ path: 'DELIVERYDATE', type: 'sap.ui.model.type.Date', formatOptions: \{ source: \{ pattern: 'yyyy-MM-dd' \} \} \}| ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `TOKEN_UPDATE`.
      " the update type, the removed token key and the row it belongs to (its
      " binding context path ends in the row index, as in app 094). The
      " original filters the row's token list by the removed KEYS, which is
      " reproduced verbatim - an empty key matches the empty-key tokens, the
      " same set the original's filter drops
      DATA(update_type) = client->get_event_arg( ).
      DATA(removed_key) = client->get_event_arg( 2 ).
      DATA(row_path) = client->get_event_arg( 3 ).
      DATA(row_index) = CONV i( substring_after( val = row_path
                                                 sub = `/`
                                                 occ = -1 ) ).
      " the row is addressed through a field symbol, not a table expression:
      " abaplint's downport leaves an itab[ ] TARGET of INSERT/DELETE in
      " place, and the 702 parser rejects it
      DATA(row_no) = row_index + 1.
      IF update_type = `removed`.
        READ TABLE productcollection INDEX row_no ASSIGNING FIELD-SYMBOL(<product>).
        IF sy-subrc = 0.
          DELETE <product>-additionalcategoriesselection WHERE key = removed_key.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " sap/ui/demo/mock/products.json, all 123 rows verbatim (ui5/mock/products.json)
    productcollection = VALUE #(
      ( productid = `HT-1000` name = `Notebook Basic 15` quantity = 10 status = `Available` price = '956' currencycode = `EUR` suppliername = `Very Best Screens`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg` category = `Laptops` weightmeasure = '4.2' )
      ( productid = `HT-1001` name = `Notebook Basic 17` quantity = 20 status = `Available` price = '1249' currencycode = `EUR` suppliername = `Very Best Screens`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1001.jpg` category = `Laptops` weightmeasure = '4.5' )
      ( productid = `HT-1002` name = `Notebook Basic 18` quantity = 10 status = `Available` price = '1570' currencycode = `EUR` suppliername = `Very Best Screens`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1002.jpg` category = `Laptops` weightmeasure = '4.2' )
      ( productid = `HT-1003` name = `Notebook Basic 19` quantity = 15 status = `Out of Stock` price = '1650' currencycode = `EUR` suppliername = `Smartcards`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1003.jpg` category = `Laptops` weightmeasure = '4.2' )
      ( productid = `HT-1007` name = `ITelO Vault` quantity = 15 status = `Out of Stock` price = '299' currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1007.jpg` category = `Accessories` weightmeasure = '0.2' )
      ( productid = `HT-1010` name = `Notebook Professional 15` quantity = 16 status = `Out of Stock` price = '1999' currencycode = `EUR` suppliername = `Very Best Screens`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg` category = `Accessories` weightmeasure = '4.3' )
      ( productid = `HT-1011` name = `Notebook Professional 17` quantity = 17 status = `Out of Stock` price = '2299' currencycode = `EUR` suppliername = `Very Best Screens`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1011.jpg` category = `Laptops` weightmeasure = '4.1' )
      ( productid = `HT-1020` name = `ITelO Vault Net` quantity = 14 status = `Discontinued` price = '459' currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1020.jpg` category = `Accessories` weightmeasure = '0.16' )
      ( productid = `HT-1021` name = `ITelO Vault SAT` quantity = 50 status = `Available` price = '149' currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1021.jpg` category = `Accessories` weightmeasure = '0.18' )
      ( productid = `HT-1022` name = `Comfort Easy` quantity = 30 status = `Out of Stock` price = '1679' currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1022.jpg` category = `Accessories` weightmeasure = '0.2' )
      ( productid = `HT-1023` name = `Comfort Senior` quantity = 24 status = `Available` price = '512' currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1023.jpg` category = `Accessories` weightmeasure = '0.8' )
      ( productid = `HT-1030` name = `Ergo Screen E-I` quantity = 14 status = `Available` price = '230' currencycode = `EUR` suppliername = `Very Best Screens`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1030.jpg` category = `Flat Screen Monitors` weightmeasure = '21' )
      ( productid = `HT-1031` name = `Ergo Screen E-II` quantity = 24 status = `Available` price = '285' currencycode = `EUR` suppliername = `Very Best Screens`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1031.jpg` category = `Flat Screen Monitors` weightmeasure = '21' )
      ( productid = `HT-1032` name = `Ergo Screen E-III` quantity = 50 status = `Out of Stock` price = '345' currencycode = `EUR` suppliername = `Very Best Screens`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1032.jpg` category = `Flat Screen Monitors` weightmeasure = '21' )
      ( productid = `HT-1035` name = `Flat Basic` quantity = 23 status = `Available` price = '399' currencycode = `EUR` suppliername = `Very Best Screens`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1035.jpg` category = `Flat Screen Monitors` weightmeasure = '14' )
      ( productid = `HT-1036` name = `Flat Future` quantity = 22 status = `Available` price = '430' currencycode = `EUR` suppliername = `Very Best Screens`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1036.jpg` category = `Flat Screen Monitors` weightmeasure = '15' )
      ( productid = `HT-1037` name = `Flat XL` quantity = 23 status = `Available` price = '1230' currencycode = `EUR` suppliername = `Very Best Screens`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1037.jpg` category = `Flat Screen Monitors` weightmeasure = '17' )
      ( productid = `HT-1040` name = `Laser Professional Eco` quantity = 21 status = `Available` price = '830' currencycode = `EUR` suppliername = `Alpha Printers`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1040.jpg` category = `Printers` weightmeasure = '32' )
      ( productid = `HT-1041` name = `Laser Basic` quantity = 8 status = `Available` price = '490' currencycode = `EUR` suppliername = `Alpha Printers`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1041.jpg` category = `Printers` weightmeasure = '23' )
      ( productid = `HT-1042` name = `Laser Allround` quantity = 9 status = `Available` price = '349' currencycode = `EUR` suppliername = `Alpha Printers`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1042.jpg` category = `Printers` weightmeasure = '17' )
      ( productid = `HT-1050` name = `Ultra Jet Super Color` quantity = 17 status = `Discontinued` price = '139' currencycode = `EUR` suppliername = `Alpha Printers`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1050.jpg` category = `Printers` weightmeasure = '3' )
      ( productid = `HT-1051` name = `Ultra Jet Mobile` quantity = 18 status = `Discontinued` price = '99' currencycode = `EUR` suppliername = `Printer for All`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1051.jpg` category = `Printers` weightmeasure = '1.9' )
      ( productid = `HT-1052` name = `Ultra Jet Super Highspeed` quantity = 25 status = `Available` price = '170' currencycode = `EUR` suppliername = `Printer for All`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1052.jpg` category = `Printers` weightmeasure = '18' )
      ( productid = `HT-1055` name = `Multi Print` quantity = 16 status = `Available` price = '99' currencycode = `EUR` suppliername = `Printer for All`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1055.jpg` category = `Multifunction Printers` weightmeasure = '6.3' )
      ( productid = `HT-1056` name = `Multi Color` quantity = 5 status = `Available` price = '119' currencycode = `EUR` suppliername = `Printer for All`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1056.jpg` category = `Multifunction Printers` weightmeasure = '4.3' )
      ( productid = `HT-1060` name = `Cordless Mouse` quantity = 25 status = `Available` price = '9' currencycode = `EUR` suppliername = `Oxynum`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1060.jpg` category = `Mice` weightmeasure = '0.09' )
      ( productid = `HT-1061` name = `Speed Mouse` quantity = 12 status = `Available` price = '7' currencycode = `EUR` suppliername = `Oxynum`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1061.jpg` category = `Mice` weightmeasure = '0.09' )
      ( productid = `HT-1062` name = `Track Mouse` quantity = 12 status = `Discontinued` price = '11' currencycode = `EUR` suppliername = `Oxynum`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1062.jpg` category = `Mice` weightmeasure = '0.03' )
      ( productid = `HT-1063` name = `Ergonomic Keyboard` quantity = 50 status = `Available` price = '14' currencycode = `EUR` suppliername = `Oxynum`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1063.jpg` category = `Keyboards` weightmeasure = '2.1' )
      ( productid = `HT-1064` name = `Internet Keyboard` quantity = 35 status = `Out of Stock` price = '16' currencycode = `EUR` suppliername = `Oxynum`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1064.jpg` category = `Keyboards` weightmeasure = '1.8' )
      ( productid = `HT-1065` name = `Media Keyboard` quantity = 26 status = `Available` price = '26' currencycode = `EUR` suppliername = `Oxynum`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1065.jpg` category = `Keyboards` weightmeasure = '2.3' )
      ( productid = `HT-1066` name = `Mousepad` quantity = 12 status = `Available` price = '6.99' currencycode = `EUR` suppliername = `Oxynum`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1066.jpg` category = `Mousepads` weightmeasure = '80' )
      ( productid = `HT-1067` name = `Ergo Mousepad` quantity = 16 status = `Out of Stock` price = '8.99' currencycode = `EUR` suppliername = `Oxynum`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1067.jpg` category = `Mousepads` weightmeasure = '80' )
      ( productid = `HT-1068` name = `Designer Mousepad` quantity = 26 status = `Available` price = '12.99' currencycode = `EUR` suppliername = `Fasttech`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1068.jpg` category = `Mousepads` weightmeasure = '90' )
      ( productid = `HT-1069` name = `Universal card reader` quantity = 22 status = `Available` price = '14' currencycode = `EUR` suppliername = `Fasttech`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1069.jpg` category = `Computer System Accessories` weightmeasure = '45' )
      ( productid = `HT-1070` name = `Proctra X` quantity = 15 status = `Out of Stock` price = '70.9' currencycode = `EUR` suppliername = `Ultrasonic United`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1070.jpg` category = `Graphic Cards` weightmeasure = '0.255' )
      ( productid = `HT-1071` name = `Gladiator MX` quantity = 16 status = `Discontinued` price = '81.7' currencycode = `EUR` suppliername = `Ultrasonic United`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1071.jpg` category = `Graphic Cards` weightmeasure = '0.3' )
      ( productid = `HT-1072` name = `Hurricane GX` quantity = 13 status = `Available` price = '101.2' currencycode = `EUR` suppliername = `Ultrasonic United`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1072.jpg` category = `Graphic Cards` weightmeasure = '0.4' )
      ( productid = `HT-1073` name = `Hurricane GX/LN` quantity = 5 status = `Out of Stock` price = '139.99' currencycode = `EUR` suppliername = `Smartcards`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1073.jpg` category = `Graphic Cards` weightmeasure = '0.4' )
      ( productid = `HT-1080` name = `Photo Scan` quantity = 8 status = `Out of Stock` price = '129' currencycode = `EUR` suppliername = `Printer for All`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1080.jpg` category = `Scanners` weightmeasure = '2.3' )
      ( productid = `HT-1081` name = `Power Scan` quantity = 11 status = `Out of Stock` price = '89' currencycode = `EUR` suppliername = `Printer for All`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1081.jpg` category = `Scanners` weightmeasure = '2.4' )
      ( productid = `HT-1082` name = `Jet Scan Professional` quantity = 13 status = `Out of Stock` price = '169' currencycode = `EUR` suppliername = `Printer for All`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1082.jpg` category = `Scanners` weightmeasure = '3.2' )
      ( productid = `HT-1083` name = `Jet Scan Professional` quantity = 10 status = `Available` price = '189' currencycode = `EUR` suppliername = `Printer for All`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1083.jpg` category = `Scanners` weightmeasure = '3.2' )
      ( productid = `HT-1085` name = `Copymaster` quantity = 10 status = `Available` price = '1499' currencycode = `EUR` suppliername = `Alpha Printers`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1085.jpg` category = `Multifunction Printers` weightmeasure = '23.2' )
      ( productid = `HT-1090` name = `Surround Sound` quantity = 20 status = `Available` price = '39' currencycode = `EUR` suppliername = `Speaker Experts`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1090.jpg` category = `Speakers` weightmeasure = '3' )
      ( productid = `HT-1091` name = `Blaster Extreme` quantity = 15 status = `Available` price = '26' currencycode = `EUR` suppliername = `Speaker Experts`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1091.jpg` category = `Speakers` weightmeasure = '1.4' )
      ( productid = `HT-1092` name = `Sound Booster` quantity = 50 status = `Discontinued` price = '45' currencycode = `EUR` suppliername = `Speaker Experts`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1092.jpg` category = `Speakers` weightmeasure = '2.1' )
      ( productid = `HT-1095` name = `Lovely Sound 5.1 Wireless` quantity = 12 status = `Available` price = '49' currencycode = `EUR` suppliername = `Fasttech`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1095.jpg` category = `Accessories` weightmeasure = '80' )
      ( productid = `HT-1096` name = `Lovely Sound 5.1` quantity = 18 status = `Available` price = '39' currencycode = `EUR` suppliername = `Fasttech`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1096.jpg` category = `Accessories` weightmeasure = '130' )
      ( productid = `HT-1097` name = `Lovely Sound Stereo` quantity = 21 status = `Out of Stock` price = '29' currencycode = `EUR` suppliername = `Fasttech`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1097.jpg` category = `Accessories` weightmeasure = '60' )
      ( productid = `HT-1100` name = `Smart Office` quantity = 25 status = `Out of Stock` price = '89.9' currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1100.jpg` category = `Software` weightmeasure = '1.2' )
      ( productid = `HT-1101` name = `Smart Design` quantity = 26 status = `Available` price = '79.9' currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1101.jpg` category = `Software` weightmeasure = '0.8' )
      ( productid = `HT-1102` name = `Smart Network` quantity = 28 status = `Available` price = '69' currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1102.jpg` category = `Software` weightmeasure = '0.8' )
      ( productid = `HT-1103` name = `Smart Multimedia` quantity = 9 status = `Available` price = '77' currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1103.jpg` category = `Software` weightmeasure = '0.8' )
      ( productid = `HT-1104` name = `Smart Games` quantity = 13 status = `Available` price = '55' currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1104.jpg` category = `Software` weightmeasure = '1.1' )
      ( productid = `HT-1105` name = `Smart Internet Antivirus` quantity = 17 status = `Available` price = '29' currencycode = `EUR` suppliername = `Brainsoft`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1105.jpg` category = `Software` weightmeasure = '0.7' )
      ( productid = `HT-1106` name = `Smart Firewall` quantity = 19 status = `Discontinued` price = '34' currencycode = `EUR` suppliername = `Brainsoft`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1106.jpg` category = `Software` weightmeasure = '0.9' )
      ( productid = `HT-1107` name = `Smart Money` quantity = 18 status = `Out of Stock` price = '29.9' currencycode = `EUR` suppliername = `Brainsoft`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1107.jpg` category = `Software` weightmeasure = '0.5' )
      ( productid = `HT-1110` name = `PC Lock` quantity = 14 status = `Available` price = '8.9' currencycode = `EUR` suppliername = `Red Point Stores`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1110.jpg` category = `Computer System Accessories` weightmeasure = '0.03' )
      ( productid = `HT-1111` name = `Notebook Lock` quantity = 20 status = `Available` price = '6.9' currencycode = `EUR` suppliername = `Red Point Stores`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1111.jpg` category = `Computer System Accessories` weightmeasure = '0.02' )
      ( productid = `HT-1112` name = `Web cam reality` quantity = 27 status = `Out of Stock` price = '39' currencycode = `EUR` suppliername = `Red Point Stores`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1112.jpg` category = `Computer System Accessories` weightmeasure = '0.075' )
      ( productid = `HT-1113` name = `Screen clean` quantity = 17 status = `Available` price = '2.3' currencycode = `EUR` suppliername = `Red Point Stores`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1113.jpg` category = `Computer System Accessories` weightmeasure = '0.05' )
      ( productid = `HT-1114` name = `Fabric bag professional` quantity = 14 status = `Available` price = '31' currencycode = `EUR` suppliername = `Red Point Stores`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1114.jpg` category = `Computer System Accessories` weightmeasure = '1.8' )
      ( productid = `HT-1115` name = `Wireless DSL Router` quantity = 16 status = `Available` price = '49' currencycode = `EUR` suppliername = `Red Point Stores`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1115.jpg` category = `Telecommunications` weightmeasure = '0.45' )
      ( productid = `HT-1116` name = `Wireless DSL Router / Repeater` quantity = 12 status = `Out of Stock` price = '59' currencycode = `EUR` suppliername = `Red Point Stores`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1116.jpg` category = `Telecommunications` weightmeasure = '0.45' )
      ( productid = `HT-1117` name = `Wireless DSL Router / Repeater and Print Server` quantity = 12 status = `Available` price = '69' currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1117.jpg` category = `Telecommunications` weightmeasure = '0.45' )
      ( productid = `HT-1118` name = `USB Stick` quantity = 14 status = `Available` price = '35' currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1118.jpg` category = `Computer System Accessories` weightmeasure = '0.015' )
      ( productid = `HT-1119` name = `Travel Adapter` quantity = 10 status = `Discontinued` price = '79' currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1119.jpg` category = `Accessories` weightmeasure = '88' )
      ( productid = `HT-1120` name = `Cordless Bluetooth Keyboard, english international` quantity = 13 status = `Out of Stock` price = '29' currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1120.jpg` category = `Keyboards` weightmeasure = '1' )
      ( productid = `HT-1137` name = `Flat XXL` quantity = 10 status = `Discontinued` price = '1430' currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1137.jpg` category = `Flat Screen Monitors` weightmeasure = '18' )
      ( productid = `HT-1138` name = `Pocket Mouse` quantity = 20 status = `Available` price = '23' currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1138.jpg` category = `Mice` weightmeasure = '0.02' )
      ( productid = `HT-1210` name = `PC Power Station` quantity = 22 status = `Available` price = '2399' currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1210.jpg` category = `PCs` weightmeasure = '2.3' )
      ( productid = `HT-1251` name = `Astro Laptop 1516` quantity = 23 status = `Available` price = '989' currencycode = `EUR` suppliername = `Ultrasonic United`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1251.jpg` category = `Laptops` weightmeasure = '4.2' )
      ( productid = `HT-1252` name = `Astro Phone 6` quantity = 28 status = `Available` price = '649' currencycode = `EUR` suppliername = `Ultrasonic United`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1252.jpg` category = `Smartphones and Tablets` weightmeasure = '0.75' )
      ( productid = `HT-1253` name = `Benda Laptop 1408` quantity = 27 status = `Discontinued` price = '976' currencycode = `EUR` suppliername = `Ultrasonic United`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1253.jpg` category = `Laptops` weightmeasure = '4.2' )
      ( productid = `HT-1254` name = `Bending Screen 21HD` quantity = 23 status = `Available` price = '250' currencycode = `EUR` suppliername = `Ultrasonic United`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1254.jpg` category = `Flat Screens` weightmeasure = '15' )
      ( productid = `HT-1255` name = `Broad Screen 22HD` quantity = 5 status = `Discontinued` price = '270' currencycode = `EUR` suppliername = `Ultrasonic United`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1255.jpg` category = `Flat Screens` weightmeasure = '16' )
      ( productid = `HT-1256` name = `Cerdik Phone 7` quantity = 19 status = `Discontinued` price = '549' currencycode = `EUR` suppliername = `Ultrasonic United`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1256.jpg` category = `Smartphones and Tablets` weightmeasure = '0.75' )
      ( productid = `HT-1257` name = `Cepat Tablet 10.5` quantity = 17 status = `Available` price = '549' currencycode = `EUR` suppliername = `Ultrasonic United`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1257.jpg` category = `Smartphones and Tablets` weightmeasure = '2.8' )
      ( productid = `HT-1258` name = `Cepat Tablet 8` quantity = 24 status = `Available` price = '529' currencycode = `EUR` suppliername = `Ultrasonic United`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1258.jpg` category = `Smartphones and Tablets` weightmeasure = '2.5' )
      ( productid = `HT-1500` name = `Server Basic` quantity = 24 status = `Available` price = '5000' currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1500.jpg` category = `Servers` weightmeasure = '18' )
      ( productid = `HT-1501` name = `Server Professional` quantity = 26 status = `Out of Stock` price = '15000' currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1501.jpg` category = `Servers` weightmeasure = '25' )
      ( productid = `HT-1502` name = `Server Power Pro` quantity = 34 status = `Available` price = '25000' currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1502.jpg` category = `Servers` weightmeasure = '35' )
      ( productid = `HT-1600` name = `Family PC Basic` quantity = 10 status = `Available` price = '600' currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1600.jpg` category = `Desktop Computers` weightmeasure = '4.8' )
      ( productid = `HT-1601` name = `Family PC Pro` quantity = 20 status = `Available` price = '900' currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1601.jpg` category = `Desktop Computers` weightmeasure = '5.3' )
      ( productid = `HT-1602` name = `Gaming Monster` quantity = 24 status = `Available` price = '1200' currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1602.jpg` category = `Desktop Computers` weightmeasure = '5.9' )
      ( productid = `HT-1603` name = `Gaming Monster Pro` quantity = 25 status = `Discontinued` price = '1700' currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1603.jpg` category = `Desktop Computers` weightmeasure = '6.8' )
      ( productid = `HT-2000` name = `7" Widescreen Portable DVD Player w MP3` quantity = 20 status = `Available` price = '249.99' currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2000.jpg` category = `Accessories` weightmeasure = '0.79' )
      ( productid = `HT-2001` name = `10" Portable DVD player` quantity = 21 status = `Available` price = '449.99' currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2001.jpg` category = `Accessories` weightmeasure = '0.84' )
      ( productid = `HT-2002` name = `Portable DVD Player with 9" LCD Monitor` quantity = 50 status = `Available` price = '853.99' currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2002.jpg` category = `Accessories` weightmeasure = '0.72' )
      ( productid = `HT-2025` name = `CD/DVD case: 264 sleeves` quantity = 26 status = `Discontinued` price = '44.99' currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2025.jpg` category = `Accessories` weightmeasure = '0.65' )
      ( productid = `HT-2026` name = `Audio/Video Cable Kit - 4m` quantity = 16 status = `Available` price = '29.99' currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2026.jpg` category = `Accessories` weightmeasure = '0.2' )
      ( productid = `HT-2027` name = `Removable CD/DVD Laser Labels` quantity = 25 status = `Discontinued` price = '8.99' currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2027.jpg` category = `Accessories` weightmeasure = '0.15' )
      ( productid = `HT-6100` name = `Beam Breaker B-1` quantity = 32 status = `Out of Stock` price = '469' currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6100.jpg` category = `Accessories` weightmeasure = '1.7' )
      ( productid = `HT-6101` name = `Beam Breaker B-2` quantity = 18 status = `Available` price = '679' currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6101.jpg` category = `Accessories` weightmeasure = '2' )
      ( productid = `HT-6102` name = `Beam Breaker B-3` quantity = 16 status = `Out of Stock` price = '889' currencycode = `EUR` suppliername = `Technocom`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6102.jpg` category = `Accessories` weightmeasure = '2.5' )
      ( productid = `HT-6110` name = `Play Movie` quantity = 15 status = `Available` price = '130' currencycode = `EUR` suppliername = `Fasttech`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6110.jpg` category = `Accessories` weightmeasure = '2.4' )
      ( productid = `HT-6111` name = `Record Movie` quantity = 24 status = `Discontinued` price = '288' currencycode = `EUR` suppliername = `Fasttech`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6111.jpg` category = `Accessories` weightmeasure = '3.1' )
      ( productid = `HT-6120` name = `ITelo MusicStick` quantity = 15 status = `Available` price = '45' currencycode = `EUR` suppliername = `Fasttech`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6120.jpg` category = `Accessories` weightmeasure = '134' )
      ( productid = `HT-6121` name = `ITelo Jog-Mate` quantity = 24 status = `Available` price = '63' currencycode = `EUR` suppliername = `Fasttech`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6121.jpg` category = `Accessories` weightmeasure = '134' )
      ( productid = `HT-6122` name = `Power Pro Player 40` quantity = 23 status = `Available` price = '167' currencycode = `EUR` suppliername = `Fasttech`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6122.jpg` category = `Accessories` weightmeasure = '266' )
      ( productid = `HT-6123` name = `Power Pro Player 80` quantity = 13 status = `Available` price = '299' currencycode = `EUR` suppliername = `Fasttech`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6123.jpg` category = `Accessories` weightmeasure = '267' )
      ( productid = `HT-6130` name = `Flat Watch HD32` quantity = 16 status = `Available` price = '1459' currencycode = `EUR` suppliername = `Very Best Screens`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6130.jpg` category = `Flat Screen TVs` weightmeasure = '2.6' )
      ( productid = `HT-6131` name = `Flat Watch HD37` quantity = 14 status = `Available` price = '1199' currencycode = `EUR` suppliername = `Very Best Screens`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6131.jpg` category = `Flat Screen TVs` weightmeasure = '2.2' )
      ( productid = `HT-6132` name = `Flat Watch HD41` quantity = 13 status = `Discontinued` price = '899' currencycode = `EUR` suppliername = `Very Best Screens`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6132.jpg` category = `Flat Screen TVs` weightmeasure = '1.8' )
      ( productid = `HT-7000` name = `Copperberry` quantity = 5 status = `Discontinued` price = '549' currencycode = `EUR` suppliername = `Fasttech`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7000.jpg` category = `Accessories` weightmeasure = '0.5' )
      ( productid = `HT-7010` name = `Silverberry` quantity = 9 status = `Discontinued` price = '549' currencycode = `EUR` suppliername = `Fasttech`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7010.jpg` category = `Accessories` weightmeasure = '0.5' )
      ( productid = `HT-7020` name = `Goldberry` quantity = 11 status = `Available` price = '549' currencycode = `EUR` suppliername = `Fasttech`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7020.jpg` category = `Accessories` weightmeasure = '0.5' )
      ( productid = `HT-7030` name = `Platinberry` quantity = 12 status = `Available` price = '549' currencycode = `EUR` suppliername = `Fasttech`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7030.jpg` category = `Accessories` weightmeasure = '0.5' )
      ( productid = `HT-8000` name = `ITelO FlexTop I4000` quantity = 11 status = `Available` price = '799' currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8000.jpg` category = `Laptops` weightmeasure = '4' )
      ( productid = `HT-8001` name = `ITelO FlexTop I6300c` quantity = 20 status = `Discontinued` price = '799' currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8001.jpg` category = `Laptops` weightmeasure = '4.2' )
      ( productid = `HT-8002` name = `ITelO FlexTop I9100` quantity = 20 status = `Available` price = '1199' currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8002.jpg` category = `Laptops` weightmeasure = '3.5' )
      ( productid = `HT-8003` name = `ITelO FlexTop I9800` quantity = 22 status = `Available` price = '1388' currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8003.jpg` category = `Laptops` weightmeasure = '3.8' )
      ( productid = `HT-9991` name = `Smartphone Leather Case` quantity = 12 status = `Available` price = '25' currencycode = `EUR` suppliername = `Ultrasonic United`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9991.jpg` category = `Accessories` weightmeasure = '0.02' )
      ( productid = `HT-9992` name = `Smartphone Alpha` quantity = 13 status = `Out of Stock` price = '599' currencycode = `EUR` suppliername = `Ultrasonic United`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9992.jpg` category = `Smartphones and Tablets` weightmeasure = '0.75' )
      ( productid = `HT-9993` name = `Mini Tablet` quantity = 10 status = `Available` price = '833' currencycode = `EUR` suppliername = `Ultrasonic United`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9993.jpg` category = `Smartphones and Tablets` weightmeasure = '3.8' )
      ( productid = `HT-9994` name = `Camcorder View` quantity = 50 status = `Out of Stock` price = '1388' currencycode = `EUR` suppliername = `Ultrasonic United`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9994.jpg` category = `Accessories` weightmeasure = '3.8' )
      ( productid = `HT-9995` name = `Tablet Pouch` quantity = 34 status = `Available` price = '20' currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9995.jpg` category = `Accessories` weightmeasure = '0.03' )
      ( productid = `HT-9996` name = `Tablet Pouch` quantity = 34 status = `Available` price = '20' currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9996.jpg` category = `Accessories` weightmeasure = '0.03' )
      ( productid = `HT-9997` name = `e-Book Reader ReadMe` quantity = 23 status = `Available` price = '33' currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9997.jpg` category = `Smartphones and Tablets` weightmeasure = '3.8' )
      ( productid = `HT-9998` name = `Smartphone Beta` quantity = 21 status = `Available` price = '30' currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9998.jpg` category = `Smartphones and Tablets` weightmeasure = '0.75' )
      ( productid = `HT-9999` name = `Maxi Tablet` quantity = 20 status = `Available` price = '749' currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9999.jpg` category = `Tablets` weightmeasure = '3.8' )
      ( productid = `PF-1000` name = `Flyer` quantity = 33 status = `Out of Stock` price = '0' currencycode = `EUR` suppliername = `Titanium`
        productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/PF-1000.jpg` category = `Accessories` weightmeasure = '0.01' )
    ).

    " initSampleDataModel derives four things per row and two arrays from them
    LOOP AT productcollection REFERENCE INTO DATA(product).
      " Date.now() - (i % 10 * 4 days): a moving value, so it is anchored on a
      " FIXED base here (the corpus rule for now/random values, apps 164/181/289)
      " the arithmetic has to land in a TYPE d field before it is formatted: a
      " date operand inside an expression is converted to its DAY NUMBER, so
      " CONV string( CONV d( ... ) - n ) yields 739618, not 20260101, and the
      " offsets then cut that into '7.39-61-80'. Measured 2026-08-21 - every
      " row carried a nonsense date the DatePicker's yyyy-MM-dd binding could
      " not parse, and nothing failed loudly enough for a gate to see it.
      DATA(delivery) = CONV d( CONV d( `20260101` ) - ( ( sy-tabix - 1 ) MOD 10 ) * 4 ).
      product->deliverydate   = |{ delivery(4) }-{ delivery+4(2) }-{ delivery+6(2) }|.
      product->available      = xsdbool( product->status = `Available` ).
      product->availablestate = COND #( WHEN product->available = abap_true THEN `Success` ELSE `Error` ).
      product->availableicon  = COND #( WHEN product->available = abap_true
                                        THEN `sap-icon://accept`
                                        ELSE `sap-icon://decline` ).
      product->heavy          = COND #( WHEN product->weightmeasure > 1000 THEN `true` ELSE `false` ).

      IF product->suppliername IS NOT INITIAL AND NOT line_exists( suppliers[ name = product->suppliername ] ).
        INSERT VALUE #( name = product->suppliername ) INTO TABLE suppliers.
      ENDIF.
      IF product->category IS NOT INITIAL AND NOT line_exists( categories[ name = product->category ] ).
        INSERT VALUE #( name = product->category ) INTO TABLE categories.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
