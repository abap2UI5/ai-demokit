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
             additionalcategoriesselection TYPE STANDARD TABLE OF ty_s_token WITH DEFAULT KEY,
           END OF ty_s_product.
    TYPES temp1_5e6a41074b TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.
DATA productcollection TYPE temp1_5e6a41074b.
    TYPES temp2_5e6a41074b TYPE STANDARD TABLE OF ty_s_named WITH DEFAULT KEY.
DATA suppliers         TYPE temp2_5e6a41074b.
    TYPES temp3_5e6a41074b TYPE STANDARD TABLE OF ty_s_named WITH DEFAULT KEY.
DATA categories        TYPE temp3_5e6a41074b.

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
    DATA temp2 TYPE string_table.
    DATA temp3 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " the full sample: all THIRTEEN columns over the shared demo mock, with the
    " Suppliers/Categories arrays the controller derives from it. The two
    " Available formatters are computed in ABAP (thin-frontend rule) into
    " AVAILABLESTATE / AVAILABLEICON, and the DatePicker binding keeps its type
    " but takes an ISO source pattern instead of the original timestamp - the
    " model carries a date STRING, not a JS epoch number (CAPABILITIES date row)
    
    CLEAR temp1.
    INSERT `MESSAGE_TOAST` INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    INSERT `Pasted Data: {0}` INTO TABLE temp1.
    INSERT `${$parameters>/data}` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `MESSAGE_TOAST` INTO TABLE temp2.
    INSERT `show` INTO TABLE temp2.
    INSERT `Details for product with id {0}` INTO TABLE temp2.
    INSERT `${PRODUCTID}` INTO TABLE temp2.
    
    CLEAR temp3.
    INSERT `${$parameters>/type}` INTO TABLE temp3.
    INSERT `${$parameters>/removedTokens}[0] ? ${$parameters>/removedTokens}[0].getKey() : ''` INTO TABLE temp3.
    INSERT `$event.oSource.getBindingContext().getPath()` INTO TABLE temp3.
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
                              t_arg = temp1 )
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
                                    )->a( n = `items` v = |\{ path: '{ client->_bind_path( suppliers ) }', templateShareable: false \}|

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
                                              t_arg = temp2 )

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
                                    )->a( n = `items`       v = |\{ path: '{ client->_bind_path( categories ) }', templateShareable: false \}|

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
                                    " key and the row path travel, ABAP removes the entry.
                                    " The removedTokens guard is required: an ADD fires the
                                    " same event with removedTokens = [], and an unguarded
                                    " [0].getKey() throws before the round-trip even starts
                                    )->a( n = `tokenUpdate`      v = client->_event(
                                              val   = `TOKEN_UPDATE`
                                              t_arg = temp3 )
                                    )->a( n = `value`            v = `{ADDITIONALCATEGORY}`
                                    )->a( n = `tokens`           v = |\{ path: 'ADDITIONALCATEGORIESSELECTION', templateShareable: false \}|
                                    )->a( n = `suggestionItems`  v = |\{ path: '{ client->_bind_path( categories ) }', templateShareable: false, sorter: \{ path: 'NAME' \} \}|
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
      DATA update_type TYPE string.
      DATA removed_key TYPE string.
      DATA row_path TYPE string.
      DATA temp3 TYPE i.
      DATA row_index LIKE temp3.
      DATA row_no TYPE i.
        FIELD-SYMBOLS <product> TYPE z2ui5_cl_smpc_app_115=>ty_s_product.

    IF client->get_event( ) = `TOKEN_UPDATE`.
      " the update type, the removed token key and the row it belongs to (its
      " binding context path ends in the row index, as in app 094). The
      " original filters the row's token list by the removed KEYS, which is
      " reproduced verbatim - an empty key matches the empty-key tokens, the
      " same set the original's filter drops
      
      update_type = client->get_event_arg( ).
      
      removed_key = client->get_event_arg( 2 ).
      
      row_path = client->get_event_arg( 3 ).
      
      temp3 = substring_after( val = row_path sub = `/` occ = -1 ).
      
      row_index = temp3.
      " the row is addressed through a field symbol, not a table expression:
      " abaplint's downport leaves an itab[ ] TARGET of INSERT/DELETE in
      " place, and the 702 parser rejects it
      
      row_no = row_index + 1.
      IF update_type = `removed`.
        
        READ TABLE productcollection INDEX row_no ASSIGNING <product>.
        IF sy-subrc = 0.
          DELETE <product>-additionalcategoriesselection WHERE key = removed_key.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " sap/ui/demo/mock/products.json, all 123 rows verbatim (ui5/mock/products.json)
    DATA temp4 LIKE productcollection.
    DATA temp5 LIKE LINE OF temp4.
    DATA temp6 LIKE LINE OF productcollection.
    DATA product LIKE REF TO temp6.
      DATA temp7 TYPE d.
      DATA temp15 TYPE d.
      DATA delivery LIKE temp7.
      DATA temp1 TYPE xsdboolean.
      DATA temp8 TYPE z2ui5_cl_smpc_app_115=>ty_s_product-availablestate.
      DATA temp9 TYPE z2ui5_cl_smpc_app_115=>ty_s_product-availableicon.
      DATA temp10 TYPE z2ui5_cl_smpc_app_115=>ty_s_product-heavy.
      DATA temp11 LIKE sy-subrc.
        DATA temp12 TYPE z2ui5_cl_smpc_app_115=>ty_s_named.
      DATA temp13 LIKE sy-subrc.
        DATA temp14 TYPE z2ui5_cl_smpc_app_115=>ty_s_named.
    CLEAR temp4.
    
    temp5-productid = `HT-1000`.
    temp5-name = `Notebook Basic 15`.
    temp5-quantity = 10.
    temp5-status = `Available`.
    temp5-price = '956'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Very Best Screens`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg`.
    temp5-category = `Laptops`.
    temp5-weightmeasure = '4.2'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1001`.
    temp5-name = `Notebook Basic 17`.
    temp5-quantity = 20.
    temp5-status = `Available`.
    temp5-price = '1249'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Very Best Screens`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1001.jpg`.
    temp5-category = `Laptops`.
    temp5-weightmeasure = '4.5'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1002`.
    temp5-name = `Notebook Basic 18`.
    temp5-quantity = 10.
    temp5-status = `Available`.
    temp5-price = '1570'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Very Best Screens`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1002.jpg`.
    temp5-category = `Laptops`.
    temp5-weightmeasure = '4.2'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1003`.
    temp5-name = `Notebook Basic 19`.
    temp5-quantity = 15.
    temp5-status = `Out of Stock`.
    temp5-price = '1650'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Smartcards`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1003.jpg`.
    temp5-category = `Laptops`.
    temp5-weightmeasure = '4.2'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1007`.
    temp5-name = `ITelO Vault`.
    temp5-quantity = 15.
    temp5-status = `Out of Stock`.
    temp5-price = '299'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Technocom`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1007.jpg`.
    temp5-category = `Accessories`.
    temp5-weightmeasure = '0.2'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1010`.
    temp5-name = `Notebook Professional 15`.
    temp5-quantity = 16.
    temp5-status = `Out of Stock`.
    temp5-price = '1999'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Very Best Screens`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg`.
    temp5-category = `Accessories`.
    temp5-weightmeasure = '4.3'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1011`.
    temp5-name = `Notebook Professional 17`.
    temp5-quantity = 17.
    temp5-status = `Out of Stock`.
    temp5-price = '2299'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Very Best Screens`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1011.jpg`.
    temp5-category = `Laptops`.
    temp5-weightmeasure = '4.1'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1020`.
    temp5-name = `ITelO Vault Net`.
    temp5-quantity = 14.
    temp5-status = `Discontinued`.
    temp5-price = '459'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Technocom`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1020.jpg`.
    temp5-category = `Accessories`.
    temp5-weightmeasure = '0.16'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1021`.
    temp5-name = `ITelO Vault SAT`.
    temp5-quantity = 50.
    temp5-status = `Available`.
    temp5-price = '149'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Technocom`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1021.jpg`.
    temp5-category = `Accessories`.
    temp5-weightmeasure = '0.18'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1022`.
    temp5-name = `Comfort Easy`.
    temp5-quantity = 30.
    temp5-status = `Out of Stock`.
    temp5-price = '1679'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Technocom`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1022.jpg`.
    temp5-category = `Accessories`.
    temp5-weightmeasure = '0.2'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1023`.
    temp5-name = `Comfort Senior`.
    temp5-quantity = 24.
    temp5-status = `Available`.
    temp5-price = '512'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Technocom`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1023.jpg`.
    temp5-category = `Accessories`.
    temp5-weightmeasure = '0.8'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1030`.
    temp5-name = `Ergo Screen E-I`.
    temp5-quantity = 14.
    temp5-status = `Available`.
    temp5-price = '230'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Very Best Screens`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1030.jpg`.
    temp5-category = `Flat Screen Monitors`.
    temp5-weightmeasure = '21'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1031`.
    temp5-name = `Ergo Screen E-II`.
    temp5-quantity = 24.
    temp5-status = `Available`.
    temp5-price = '285'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Very Best Screens`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1031.jpg`.
    temp5-category = `Flat Screen Monitors`.
    temp5-weightmeasure = '21'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1032`.
    temp5-name = `Ergo Screen E-III`.
    temp5-quantity = 50.
    temp5-status = `Out of Stock`.
    temp5-price = '345'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Very Best Screens`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1032.jpg`.
    temp5-category = `Flat Screen Monitors`.
    temp5-weightmeasure = '21'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1035`.
    temp5-name = `Flat Basic`.
    temp5-quantity = 23.
    temp5-status = `Available`.
    temp5-price = '399'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Very Best Screens`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1035.jpg`.
    temp5-category = `Flat Screen Monitors`.
    temp5-weightmeasure = '14'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1036`.
    temp5-name = `Flat Future`.
    temp5-quantity = 22.
    temp5-status = `Available`.
    temp5-price = '430'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Very Best Screens`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1036.jpg`.
    temp5-category = `Flat Screen Monitors`.
    temp5-weightmeasure = '15'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1037`.
    temp5-name = `Flat XL`.
    temp5-quantity = 23.
    temp5-status = `Available`.
    temp5-price = '1230'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Very Best Screens`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1037.jpg`.
    temp5-category = `Flat Screen Monitors`.
    temp5-weightmeasure = '17'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1040`.
    temp5-name = `Laser Professional Eco`.
    temp5-quantity = 21.
    temp5-status = `Available`.
    temp5-price = '830'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Alpha Printers`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1040.jpg`.
    temp5-category = `Printers`.
    temp5-weightmeasure = '32'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1041`.
    temp5-name = `Laser Basic`.
    temp5-quantity = 8.
    temp5-status = `Available`.
    temp5-price = '490'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Alpha Printers`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1041.jpg`.
    temp5-category = `Printers`.
    temp5-weightmeasure = '23'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1042`.
    temp5-name = `Laser Allround`.
    temp5-quantity = 9.
    temp5-status = `Available`.
    temp5-price = '349'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Alpha Printers`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1042.jpg`.
    temp5-category = `Printers`.
    temp5-weightmeasure = '17'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1050`.
    temp5-name = `Ultra Jet Super Color`.
    temp5-quantity = 17.
    temp5-status = `Discontinued`.
    temp5-price = '139'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Alpha Printers`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1050.jpg`.
    temp5-category = `Printers`.
    temp5-weightmeasure = '3'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1051`.
    temp5-name = `Ultra Jet Mobile`.
    temp5-quantity = 18.
    temp5-status = `Discontinued`.
    temp5-price = '99'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Printer for All`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1051.jpg`.
    temp5-category = `Printers`.
    temp5-weightmeasure = '1.9'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1052`.
    temp5-name = `Ultra Jet Super Highspeed`.
    temp5-quantity = 25.
    temp5-status = `Available`.
    temp5-price = '170'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Printer for All`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1052.jpg`.
    temp5-category = `Printers`.
    temp5-weightmeasure = '18'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1055`.
    temp5-name = `Multi Print`.
    temp5-quantity = 16.
    temp5-status = `Available`.
    temp5-price = '99'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Printer for All`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1055.jpg`.
    temp5-category = `Multifunction Printers`.
    temp5-weightmeasure = '6.3'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1056`.
    temp5-name = `Multi Color`.
    temp5-quantity = 5.
    temp5-status = `Available`.
    temp5-price = '119'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Printer for All`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1056.jpg`.
    temp5-category = `Multifunction Printers`.
    temp5-weightmeasure = '4.3'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1060`.
    temp5-name = `Cordless Mouse`.
    temp5-quantity = 25.
    temp5-status = `Available`.
    temp5-price = '9'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Oxynum`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1060.jpg`.
    temp5-category = `Mice`.
    temp5-weightmeasure = '0.09'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1061`.
    temp5-name = `Speed Mouse`.
    temp5-quantity = 12.
    temp5-status = `Available`.
    temp5-price = '7'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Oxynum`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1061.jpg`.
    temp5-category = `Mice`.
    temp5-weightmeasure = '0.09'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1062`.
    temp5-name = `Track Mouse`.
    temp5-quantity = 12.
    temp5-status = `Discontinued`.
    temp5-price = '11'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Oxynum`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1062.jpg`.
    temp5-category = `Mice`.
    temp5-weightmeasure = '0.03'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1063`.
    temp5-name = `Ergonomic Keyboard`.
    temp5-quantity = 50.
    temp5-status = `Available`.
    temp5-price = '14'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Oxynum`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1063.jpg`.
    temp5-category = `Keyboards`.
    temp5-weightmeasure = '2.1'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1064`.
    temp5-name = `Internet Keyboard`.
    temp5-quantity = 35.
    temp5-status = `Out of Stock`.
    temp5-price = '16'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Oxynum`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1064.jpg`.
    temp5-category = `Keyboards`.
    temp5-weightmeasure = '1.8'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1065`.
    temp5-name = `Media Keyboard`.
    temp5-quantity = 26.
    temp5-status = `Available`.
    temp5-price = '26'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Oxynum`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1065.jpg`.
    temp5-category = `Keyboards`.
    temp5-weightmeasure = '2.3'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1066`.
    temp5-name = `Mousepad`.
    temp5-quantity = 12.
    temp5-status = `Available`.
    temp5-price = '6.99'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Oxynum`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1066.jpg`.
    temp5-category = `Mousepads`.
    temp5-weightmeasure = '80'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1067`.
    temp5-name = `Ergo Mousepad`.
    temp5-quantity = 16.
    temp5-status = `Out of Stock`.
    temp5-price = '8.99'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Oxynum`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1067.jpg`.
    temp5-category = `Mousepads`.
    temp5-weightmeasure = '80'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1068`.
    temp5-name = `Designer Mousepad`.
    temp5-quantity = 26.
    temp5-status = `Available`.
    temp5-price = '12.99'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Fasttech`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1068.jpg`.
    temp5-category = `Mousepads`.
    temp5-weightmeasure = '90'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1069`.
    temp5-name = `Universal card reader`.
    temp5-quantity = 22.
    temp5-status = `Available`.
    temp5-price = '14'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Fasttech`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1069.jpg`.
    temp5-category = `Computer System Accessories`.
    temp5-weightmeasure = '45'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1070`.
    temp5-name = `Proctra X`.
    temp5-quantity = 15.
    temp5-status = `Out of Stock`.
    temp5-price = '70.9'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1070.jpg`.
    temp5-category = `Graphic Cards`.
    temp5-weightmeasure = '0.255'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1071`.
    temp5-name = `Gladiator MX`.
    temp5-quantity = 16.
    temp5-status = `Discontinued`.
    temp5-price = '81.7'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1071.jpg`.
    temp5-category = `Graphic Cards`.
    temp5-weightmeasure = '0.3'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1072`.
    temp5-name = `Hurricane GX`.
    temp5-quantity = 13.
    temp5-status = `Available`.
    temp5-price = '101.2'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1072.jpg`.
    temp5-category = `Graphic Cards`.
    temp5-weightmeasure = '0.4'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1073`.
    temp5-name = `Hurricane GX/LN`.
    temp5-quantity = 5.
    temp5-status = `Out of Stock`.
    temp5-price = '139.99'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Smartcards`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1073.jpg`.
    temp5-category = `Graphic Cards`.
    temp5-weightmeasure = '0.4'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1080`.
    temp5-name = `Photo Scan`.
    temp5-quantity = 8.
    temp5-status = `Out of Stock`.
    temp5-price = '129'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Printer for All`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1080.jpg`.
    temp5-category = `Scanners`.
    temp5-weightmeasure = '2.3'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1081`.
    temp5-name = `Power Scan`.
    temp5-quantity = 11.
    temp5-status = `Out of Stock`.
    temp5-price = '89'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Printer for All`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1081.jpg`.
    temp5-category = `Scanners`.
    temp5-weightmeasure = '2.4'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1082`.
    temp5-name = `Jet Scan Professional`.
    temp5-quantity = 13.
    temp5-status = `Out of Stock`.
    temp5-price = '169'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Printer for All`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1082.jpg`.
    temp5-category = `Scanners`.
    temp5-weightmeasure = '3.2'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1083`.
    temp5-name = `Jet Scan Professional`.
    temp5-quantity = 10.
    temp5-status = `Available`.
    temp5-price = '189'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Printer for All`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1083.jpg`.
    temp5-category = `Scanners`.
    temp5-weightmeasure = '3.2'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1085`.
    temp5-name = `Copymaster`.
    temp5-quantity = 10.
    temp5-status = `Available`.
    temp5-price = '1499'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Alpha Printers`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1085.jpg`.
    temp5-category = `Multifunction Printers`.
    temp5-weightmeasure = '23.2'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1090`.
    temp5-name = `Surround Sound`.
    temp5-quantity = 20.
    temp5-status = `Available`.
    temp5-price = '39'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Speaker Experts`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1090.jpg`.
    temp5-category = `Speakers`.
    temp5-weightmeasure = '3'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1091`.
    temp5-name = `Blaster Extreme`.
    temp5-quantity = 15.
    temp5-status = `Available`.
    temp5-price = '26'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Speaker Experts`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1091.jpg`.
    temp5-category = `Speakers`.
    temp5-weightmeasure = '1.4'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1092`.
    temp5-name = `Sound Booster`.
    temp5-quantity = 50.
    temp5-status = `Discontinued`.
    temp5-price = '45'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Speaker Experts`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1092.jpg`.
    temp5-category = `Speakers`.
    temp5-weightmeasure = '2.1'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1095`.
    temp5-name = `Lovely Sound 5.1 Wireless`.
    temp5-quantity = 12.
    temp5-status = `Available`.
    temp5-price = '49'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Fasttech`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1095.jpg`.
    temp5-category = `Accessories`.
    temp5-weightmeasure = '80'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1096`.
    temp5-name = `Lovely Sound 5.1`.
    temp5-quantity = 18.
    temp5-status = `Available`.
    temp5-price = '39'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Fasttech`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1096.jpg`.
    temp5-category = `Accessories`.
    temp5-weightmeasure = '130'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1097`.
    temp5-name = `Lovely Sound Stereo`.
    temp5-quantity = 21.
    temp5-status = `Out of Stock`.
    temp5-price = '29'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Fasttech`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1097.jpg`.
    temp5-category = `Accessories`.
    temp5-weightmeasure = '60'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1100`.
    temp5-name = `Smart Office`.
    temp5-quantity = 25.
    temp5-status = `Out of Stock`.
    temp5-price = '89.9'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Technocom`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1100.jpg`.
    temp5-category = `Software`.
    temp5-weightmeasure = '1.2'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1101`.
    temp5-name = `Smart Design`.
    temp5-quantity = 26.
    temp5-status = `Available`.
    temp5-price = '79.9'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Technocom`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1101.jpg`.
    temp5-category = `Software`.
    temp5-weightmeasure = '0.8'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1102`.
    temp5-name = `Smart Network`.
    temp5-quantity = 28.
    temp5-status = `Available`.
    temp5-price = '69'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Technocom`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1102.jpg`.
    temp5-category = `Software`.
    temp5-weightmeasure = '0.8'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1103`.
    temp5-name = `Smart Multimedia`.
    temp5-quantity = 9.
    temp5-status = `Available`.
    temp5-price = '77'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Technocom`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1103.jpg`.
    temp5-category = `Software`.
    temp5-weightmeasure = '0.8'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1104`.
    temp5-name = `Smart Games`.
    temp5-quantity = 13.
    temp5-status = `Available`.
    temp5-price = '55'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Technocom`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1104.jpg`.
    temp5-category = `Software`.
    temp5-weightmeasure = '1.1'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1105`.
    temp5-name = `Smart Internet Antivirus`.
    temp5-quantity = 17.
    temp5-status = `Available`.
    temp5-price = '29'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Brainsoft`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1105.jpg`.
    temp5-category = `Software`.
    temp5-weightmeasure = '0.7'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1106`.
    temp5-name = `Smart Firewall`.
    temp5-quantity = 19.
    temp5-status = `Discontinued`.
    temp5-price = '34'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Brainsoft`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1106.jpg`.
    temp5-category = `Software`.
    temp5-weightmeasure = '0.9'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1107`.
    temp5-name = `Smart Money`.
    temp5-quantity = 18.
    temp5-status = `Out of Stock`.
    temp5-price = '29.9'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Brainsoft`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1107.jpg`.
    temp5-category = `Software`.
    temp5-weightmeasure = '0.5'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1110`.
    temp5-name = `PC Lock`.
    temp5-quantity = 14.
    temp5-status = `Available`.
    temp5-price = '8.9'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Red Point Stores`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1110.jpg`.
    temp5-category = `Computer System Accessories`.
    temp5-weightmeasure = '0.03'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1111`.
    temp5-name = `Notebook Lock`.
    temp5-quantity = 20.
    temp5-status = `Available`.
    temp5-price = '6.9'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Red Point Stores`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1111.jpg`.
    temp5-category = `Computer System Accessories`.
    temp5-weightmeasure = '0.02'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1112`.
    temp5-name = `Web cam reality`.
    temp5-quantity = 27.
    temp5-status = `Out of Stock`.
    temp5-price = '39'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Red Point Stores`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1112.jpg`.
    temp5-category = `Computer System Accessories`.
    temp5-weightmeasure = '0.075'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1113`.
    temp5-name = `Screen clean`.
    temp5-quantity = 17.
    temp5-status = `Available`.
    temp5-price = '2.3'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Red Point Stores`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1113.jpg`.
    temp5-category = `Computer System Accessories`.
    temp5-weightmeasure = '0.05'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1114`.
    temp5-name = `Fabric bag professional`.
    temp5-quantity = 14.
    temp5-status = `Available`.
    temp5-price = '31'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Red Point Stores`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1114.jpg`.
    temp5-category = `Computer System Accessories`.
    temp5-weightmeasure = '1.8'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1115`.
    temp5-name = `Wireless DSL Router`.
    temp5-quantity = 16.
    temp5-status = `Available`.
    temp5-price = '49'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Red Point Stores`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1115.jpg`.
    temp5-category = `Telecommunications`.
    temp5-weightmeasure = '0.45'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1116`.
    temp5-name = `Wireless DSL Router / Repeater`.
    temp5-quantity = 12.
    temp5-status = `Out of Stock`.
    temp5-price = '59'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Red Point Stores`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1116.jpg`.
    temp5-category = `Telecommunications`.
    temp5-weightmeasure = '0.45'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1117`.
    temp5-name = `Wireless DSL Router / Repeater and Print Server`.
    temp5-quantity = 12.
    temp5-status = `Available`.
    temp5-price = '69'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Technocom`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1117.jpg`.
    temp5-category = `Telecommunications`.
    temp5-weightmeasure = '0.45'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1118`.
    temp5-name = `USB Stick`.
    temp5-quantity = 14.
    temp5-status = `Available`.
    temp5-price = '35'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Technocom`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1118.jpg`.
    temp5-category = `Computer System Accessories`.
    temp5-weightmeasure = '0.015'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1119`.
    temp5-name = `Travel Adapter`.
    temp5-quantity = 10.
    temp5-status = `Discontinued`.
    temp5-price = '79'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Titanium`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1119.jpg`.
    temp5-category = `Accessories`.
    temp5-weightmeasure = '88'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1120`.
    temp5-name = `Cordless Bluetooth Keyboard, english international`.
    temp5-quantity = 13.
    temp5-status = `Out of Stock`.
    temp5-price = '29'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Technocom`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1120.jpg`.
    temp5-category = `Keyboards`.
    temp5-weightmeasure = '1'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1137`.
    temp5-name = `Flat XXL`.
    temp5-quantity = 10.
    temp5-status = `Discontinued`.
    temp5-price = '1430'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Technocom`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1137.jpg`.
    temp5-category = `Flat Screen Monitors`.
    temp5-weightmeasure = '18'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1138`.
    temp5-name = `Pocket Mouse`.
    temp5-quantity = 20.
    temp5-status = `Available`.
    temp5-price = '23'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Technocom`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1138.jpg`.
    temp5-category = `Mice`.
    temp5-weightmeasure = '0.02'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1210`.
    temp5-name = `PC Power Station`.
    temp5-quantity = 22.
    temp5-status = `Available`.
    temp5-price = '2399'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Technocom`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1210.jpg`.
    temp5-category = `PCs`.
    temp5-weightmeasure = '2.3'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1251`.
    temp5-name = `Astro Laptop 1516`.
    temp5-quantity = 23.
    temp5-status = `Available`.
    temp5-price = '989'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1251.jpg`.
    temp5-category = `Laptops`.
    temp5-weightmeasure = '4.2'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1252`.
    temp5-name = `Astro Phone 6`.
    temp5-quantity = 28.
    temp5-status = `Available`.
    temp5-price = '649'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1252.jpg`.
    temp5-category = `Smartphones and Tablets`.
    temp5-weightmeasure = '0.75'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1253`.
    temp5-name = `Benda Laptop 1408`.
    temp5-quantity = 27.
    temp5-status = `Discontinued`.
    temp5-price = '976'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1253.jpg`.
    temp5-category = `Laptops`.
    temp5-weightmeasure = '4.2'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1254`.
    temp5-name = `Bending Screen 21HD`.
    temp5-quantity = 23.
    temp5-status = `Available`.
    temp5-price = '250'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1254.jpg`.
    temp5-category = `Flat Screens`.
    temp5-weightmeasure = '15'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1255`.
    temp5-name = `Broad Screen 22HD`.
    temp5-quantity = 5.
    temp5-status = `Discontinued`.
    temp5-price = '270'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1255.jpg`.
    temp5-category = `Flat Screens`.
    temp5-weightmeasure = '16'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1256`.
    temp5-name = `Cerdik Phone 7`.
    temp5-quantity = 19.
    temp5-status = `Discontinued`.
    temp5-price = '549'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1256.jpg`.
    temp5-category = `Smartphones and Tablets`.
    temp5-weightmeasure = '0.75'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1257`.
    temp5-name = `Cepat Tablet 10.5`.
    temp5-quantity = 17.
    temp5-status = `Available`.
    temp5-price = '549'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1257.jpg`.
    temp5-category = `Smartphones and Tablets`.
    temp5-weightmeasure = '2.8'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1258`.
    temp5-name = `Cepat Tablet 8`.
    temp5-quantity = 24.
    temp5-status = `Available`.
    temp5-price = '529'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1258.jpg`.
    temp5-category = `Smartphones and Tablets`.
    temp5-weightmeasure = '2.5'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1500`.
    temp5-name = `Server Basic`.
    temp5-quantity = 24.
    temp5-status = `Available`.
    temp5-price = '5000'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Technocom`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1500.jpg`.
    temp5-category = `Servers`.
    temp5-weightmeasure = '18'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1501`.
    temp5-name = `Server Professional`.
    temp5-quantity = 26.
    temp5-status = `Out of Stock`.
    temp5-price = '15000'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Technocom`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1501.jpg`.
    temp5-category = `Servers`.
    temp5-weightmeasure = '25'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1502`.
    temp5-name = `Server Power Pro`.
    temp5-quantity = 34.
    temp5-status = `Available`.
    temp5-price = '25000'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Technocom`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1502.jpg`.
    temp5-category = `Servers`.
    temp5-weightmeasure = '35'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1600`.
    temp5-name = `Family PC Basic`.
    temp5-quantity = 10.
    temp5-status = `Available`.
    temp5-price = '600'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Titanium`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1600.jpg`.
    temp5-category = `Desktop Computers`.
    temp5-weightmeasure = '4.8'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1601`.
    temp5-name = `Family PC Pro`.
    temp5-quantity = 20.
    temp5-status = `Available`.
    temp5-price = '900'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Titanium`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1601.jpg`.
    temp5-category = `Desktop Computers`.
    temp5-weightmeasure = '5.3'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1602`.
    temp5-name = `Gaming Monster`.
    temp5-quantity = 24.
    temp5-status = `Available`.
    temp5-price = '1200'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Titanium`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1602.jpg`.
    temp5-category = `Desktop Computers`.
    temp5-weightmeasure = '5.9'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-1603`.
    temp5-name = `Gaming Monster Pro`.
    temp5-quantity = 25.
    temp5-status = `Discontinued`.
    temp5-price = '1700'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Titanium`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1603.jpg`.
    temp5-category = `Desktop Computers`.
    temp5-weightmeasure = '6.8'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-2000`.
    temp5-name = `7" Widescreen Portable DVD Player w MP3`.
    temp5-quantity = 20.
    temp5-status = `Available`.
    temp5-price = '249.99'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Titanium`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2000.jpg`.
    temp5-category = `Accessories`.
    temp5-weightmeasure = '0.79'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-2001`.
    temp5-name = `10" Portable DVD player`.
    temp5-quantity = 21.
    temp5-status = `Available`.
    temp5-price = '449.99'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Titanium`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2001.jpg`.
    temp5-category = `Accessories`.
    temp5-weightmeasure = '0.84'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-2002`.
    temp5-name = `Portable DVD Player with 9" LCD Monitor`.
    temp5-quantity = 50.
    temp5-status = `Available`.
    temp5-price = '853.99'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Technocom`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2002.jpg`.
    temp5-category = `Accessories`.
    temp5-weightmeasure = '0.72'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-2025`.
    temp5-name = `CD/DVD case: 264 sleeves`.
    temp5-quantity = 26.
    temp5-status = `Discontinued`.
    temp5-price = '44.99'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Titanium`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2025.jpg`.
    temp5-category = `Accessories`.
    temp5-weightmeasure = '0.65'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-2026`.
    temp5-name = `Audio/Video Cable Kit - 4m`.
    temp5-quantity = 16.
    temp5-status = `Available`.
    temp5-price = '29.99'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Titanium`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2026.jpg`.
    temp5-category = `Accessories`.
    temp5-weightmeasure = '0.2'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-2027`.
    temp5-name = `Removable CD/DVD Laser Labels`.
    temp5-quantity = 25.
    temp5-status = `Discontinued`.
    temp5-price = '8.99'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Titanium`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2027.jpg`.
    temp5-category = `Accessories`.
    temp5-weightmeasure = '0.15'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-6100`.
    temp5-name = `Beam Breaker B-1`.
    temp5-quantity = 32.
    temp5-status = `Out of Stock`.
    temp5-price = '469'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Titanium`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6100.jpg`.
    temp5-category = `Accessories`.
    temp5-weightmeasure = '1.7'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-6101`.
    temp5-name = `Beam Breaker B-2`.
    temp5-quantity = 18.
    temp5-status = `Available`.
    temp5-price = '679'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Technocom`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6101.jpg`.
    temp5-category = `Accessories`.
    temp5-weightmeasure = '2'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-6102`.
    temp5-name = `Beam Breaker B-3`.
    temp5-quantity = 16.
    temp5-status = `Out of Stock`.
    temp5-price = '889'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Technocom`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6102.jpg`.
    temp5-category = `Accessories`.
    temp5-weightmeasure = '2.5'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-6110`.
    temp5-name = `Play Movie`.
    temp5-quantity = 15.
    temp5-status = `Available`.
    temp5-price = '130'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Fasttech`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6110.jpg`.
    temp5-category = `Accessories`.
    temp5-weightmeasure = '2.4'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-6111`.
    temp5-name = `Record Movie`.
    temp5-quantity = 24.
    temp5-status = `Discontinued`.
    temp5-price = '288'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Fasttech`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6111.jpg`.
    temp5-category = `Accessories`.
    temp5-weightmeasure = '3.1'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-6120`.
    temp5-name = `ITelo MusicStick`.
    temp5-quantity = 15.
    temp5-status = `Available`.
    temp5-price = '45'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Fasttech`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6120.jpg`.
    temp5-category = `Accessories`.
    temp5-weightmeasure = '134'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-6121`.
    temp5-name = `ITelo Jog-Mate`.
    temp5-quantity = 24.
    temp5-status = `Available`.
    temp5-price = '63'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Fasttech`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6121.jpg`.
    temp5-category = `Accessories`.
    temp5-weightmeasure = '134'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-6122`.
    temp5-name = `Power Pro Player 40`.
    temp5-quantity = 23.
    temp5-status = `Available`.
    temp5-price = '167'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Fasttech`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6122.jpg`.
    temp5-category = `Accessories`.
    temp5-weightmeasure = '266'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-6123`.
    temp5-name = `Power Pro Player 80`.
    temp5-quantity = 13.
    temp5-status = `Available`.
    temp5-price = '299'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Fasttech`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6123.jpg`.
    temp5-category = `Accessories`.
    temp5-weightmeasure = '267'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-6130`.
    temp5-name = `Flat Watch HD32`.
    temp5-quantity = 16.
    temp5-status = `Available`.
    temp5-price = '1459'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Very Best Screens`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6130.jpg`.
    temp5-category = `Flat Screen TVs`.
    temp5-weightmeasure = '2.6'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-6131`.
    temp5-name = `Flat Watch HD37`.
    temp5-quantity = 14.
    temp5-status = `Available`.
    temp5-price = '1199'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Very Best Screens`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6131.jpg`.
    temp5-category = `Flat Screen TVs`.
    temp5-weightmeasure = '2.2'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-6132`.
    temp5-name = `Flat Watch HD41`.
    temp5-quantity = 13.
    temp5-status = `Discontinued`.
    temp5-price = '899'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Very Best Screens`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6132.jpg`.
    temp5-category = `Flat Screen TVs`.
    temp5-weightmeasure = '1.8'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-7000`.
    temp5-name = `Copperberry`.
    temp5-quantity = 5.
    temp5-status = `Discontinued`.
    temp5-price = '549'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Fasttech`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7000.jpg`.
    temp5-category = `Accessories`.
    temp5-weightmeasure = '0.5'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-7010`.
    temp5-name = `Silverberry`.
    temp5-quantity = 9.
    temp5-status = `Discontinued`.
    temp5-price = '549'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Fasttech`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7010.jpg`.
    temp5-category = `Accessories`.
    temp5-weightmeasure = '0.5'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-7020`.
    temp5-name = `Goldberry`.
    temp5-quantity = 11.
    temp5-status = `Available`.
    temp5-price = '549'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Fasttech`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7020.jpg`.
    temp5-category = `Accessories`.
    temp5-weightmeasure = '0.5'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-7030`.
    temp5-name = `Platinberry`.
    temp5-quantity = 12.
    temp5-status = `Available`.
    temp5-price = '549'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Fasttech`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7030.jpg`.
    temp5-category = `Accessories`.
    temp5-weightmeasure = '0.5'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-8000`.
    temp5-name = `ITelO FlexTop I4000`.
    temp5-quantity = 11.
    temp5-status = `Available`.
    temp5-price = '799'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Titanium`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8000.jpg`.
    temp5-category = `Laptops`.
    temp5-weightmeasure = '4'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-8001`.
    temp5-name = `ITelO FlexTop I6300c`.
    temp5-quantity = 20.
    temp5-status = `Discontinued`.
    temp5-price = '799'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Titanium`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8001.jpg`.
    temp5-category = `Laptops`.
    temp5-weightmeasure = '4.2'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-8002`.
    temp5-name = `ITelO FlexTop I9100`.
    temp5-quantity = 20.
    temp5-status = `Available`.
    temp5-price = '1199'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Titanium`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8002.jpg`.
    temp5-category = `Laptops`.
    temp5-weightmeasure = '3.5'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-8003`.
    temp5-name = `ITelO FlexTop I9800`.
    temp5-quantity = 22.
    temp5-status = `Available`.
    temp5-price = '1388'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Titanium`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8003.jpg`.
    temp5-category = `Laptops`.
    temp5-weightmeasure = '3.8'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-9991`.
    temp5-name = `Smartphone Leather Case`.
    temp5-quantity = 12.
    temp5-status = `Available`.
    temp5-price = '25'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9991.jpg`.
    temp5-category = `Accessories`.
    temp5-weightmeasure = '0.02'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-9992`.
    temp5-name = `Smartphone Alpha`.
    temp5-quantity = 13.
    temp5-status = `Out of Stock`.
    temp5-price = '599'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9992.jpg`.
    temp5-category = `Smartphones and Tablets`.
    temp5-weightmeasure = '0.75'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-9993`.
    temp5-name = `Mini Tablet`.
    temp5-quantity = 10.
    temp5-status = `Available`.
    temp5-price = '833'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9993.jpg`.
    temp5-category = `Smartphones and Tablets`.
    temp5-weightmeasure = '3.8'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-9994`.
    temp5-name = `Camcorder View`.
    temp5-quantity = 50.
    temp5-status = `Out of Stock`.
    temp5-price = '1388'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9994.jpg`.
    temp5-category = `Accessories`.
    temp5-weightmeasure = '3.8'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-9995`.
    temp5-name = `Tablet Pouch`.
    temp5-quantity = 34.
    temp5-status = `Available`.
    temp5-price = '20'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Titanium`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9995.jpg`.
    temp5-category = `Accessories`.
    temp5-weightmeasure = '0.03'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-9996`.
    temp5-name = `Tablet Pouch`.
    temp5-quantity = 34.
    temp5-status = `Available`.
    temp5-price = '20'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Titanium`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9996.jpg`.
    temp5-category = `Accessories`.
    temp5-weightmeasure = '0.03'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-9997`.
    temp5-name = `e-Book Reader ReadMe`.
    temp5-quantity = 23.
    temp5-status = `Available`.
    temp5-price = '33'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Titanium`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9997.jpg`.
    temp5-category = `Smartphones and Tablets`.
    temp5-weightmeasure = '3.8'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-9998`.
    temp5-name = `Smartphone Beta`.
    temp5-quantity = 21.
    temp5-status = `Available`.
    temp5-price = '30'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Titanium`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9998.jpg`.
    temp5-category = `Smartphones and Tablets`.
    temp5-weightmeasure = '0.75'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `HT-9999`.
    temp5-name = `Maxi Tablet`.
    temp5-quantity = 20.
    temp5-status = `Available`.
    temp5-price = '749'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Titanium`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9999.jpg`.
    temp5-category = `Tablets`.
    temp5-weightmeasure = '3.8'.
    INSERT temp5 INTO TABLE temp4.
    temp5-productid = `PF-1000`.
    temp5-name = `Flyer`.
    temp5-quantity = 33.
    temp5-status = `Out of Stock`.
    temp5-price = '0'.
    temp5-currencycode = `EUR`.
    temp5-suppliername = `Titanium`.
    temp5-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/PF-1000.jpg`.
    temp5-category = `Accessories`.
    temp5-weightmeasure = '0.01'.
    INSERT temp5 INTO TABLE temp4.
    productcollection = temp4.

    " initSampleDataModel derives four things per row and two arrays from them
    
    
    LOOP AT productcollection REFERENCE INTO product.
      " Date.now() - (i % 10 * 4 days): a moving value, so it is anchored on a
      " FIXED base here (the corpus rule for now/random values, apps 164/181/289)
      " the arithmetic has to land in a TYPE d field before it is formatted: a
      " date operand inside an expression is converted to its DAY NUMBER, so
      " CONV string( CONV d( ... ) - n ) yields 739618, not 20260101, and the
      " offsets then cut that into '7.39-61-80'. Measured 2026-08-21 - every
      " row carried a nonsense date the DatePicker's yyyy-MM-dd binding could
      " not parse, and nothing failed loudly enough for a gate to see it.
      
      
      temp15 = `20260101`.
      temp7 = temp15 - ( ( sy-tabix - 1 ) MOD 10 ) * 4.
      
      delivery = temp7.
      product->deliverydate   = |{ delivery(4) }-{ delivery+4(2) }-{ delivery+6(2) }|.
      
      temp1 = boolc( product->status = `Available` ).
      product->available      = temp1.
      
      IF product->available = abap_true.
        temp8 = `Success`.
      ELSE.
        temp8 = `Error`.
      ENDIF.
      product->availablestate = temp8.
      
      IF product->available = abap_true.
        temp9 = `sap-icon://accept`.
      ELSE.
        temp9 = `sap-icon://decline`.
      ENDIF.
      product->availableicon  = temp9.
      
      IF product->weightmeasure > 1000.
        temp10 = `true`.
      ELSE.
        temp10 = `false`.
      ENDIF.
      product->heavy          = temp10.

      
      READ TABLE suppliers WITH KEY name = product->suppliername TRANSPORTING NO FIELDS.
      temp11 = sy-subrc.
      IF product->suppliername IS NOT INITIAL AND NOT temp11 = 0.
        
        CLEAR temp12.
        temp12-name = product->suppliername.
        INSERT temp12 INTO TABLE suppliers.
      ENDIF.
      
      READ TABLE categories WITH KEY name = product->category TRANSPORTING NO FIELDS.
      temp13 = sy-subrc.
      IF product->category IS NOT INITIAL AND NOT temp13 = 0.
        
        CLEAR temp14.
        temp14-name = product->category.
        INSERT temp14 INTO TABLE categories.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
