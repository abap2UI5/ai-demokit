" @keywords table sap.ui.table rowhighlights overflowtoolbar title toolbarspacer label select item togglebutton rowsettings column
" @summary Shows how row highlights and alternating row colors can be used.
CLASS z2ui5_cl_smpc_app_174 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        status       TYPE string,
        statustext   TYPE string,
        name         TYPE string,
        productid    TYPE string,
        quantity     TYPE i,
        price        TYPE p LENGTH 13 DECIMALS 2,
        currencycode TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

    " The original drives three Table properties imperatively from the toolbar
    " controllers (setSelectionMode / setAlternateRowColors / the highlight
    " rowSettingsTemplate toggle). abap2UI5 is a thin frontend, so these become
    " two-way bound fields on the one default model, shared with the Select /
    " ToggleButtons - no round-trip (AGENTS section 5, app 128/007 precedent).
    DATA selection_mode       TYPE string.
    DATA show_highlights      TYPE abap_bool.
    DATA alternate_row_colors TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_174 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " sap.ui.table grid Table (RowHighlights sample). The row highlight bar
    " reads the status the backend classifies per row in model_init. The
    " toolbar Select and ToggleButtons two-way bind the selection mode, the
    " alternate row colors and the highlight-visibility flag directly.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`         v = `sap.ui.table`
        )->a( n = `xmlns:mvc`     v = `sap.ui.core.mvc`
        )->a( n = `xmlns:unified` v = `sap.ui.unified`
        )->a( n = `xmlns:core`    v = `sap.ui.core`
        )->a( n = `xmlns:m`       v = `sap.m`
        )->a( n = `height`        v = `100%`

        )->ele( n = `Page` ns = `m`
            )->a( n = `showHeader`      v = `false`
            )->a( n = `enableScrolling` v = `false`
            )->a( n = `class`           v = `sapUiContentPadding`

            )->ele( n = `content` ns = `m`
                )->ele( `Table`
                    )->a( n = `id`                 v = `table`
                    )->a( n = `rows`               v = client->_bind( t_products )
                    )->a( n = `selectionMode`      v = client->_bind( selection_mode )
                    )->a( n = `alternateRowColors` v = client->_bind( alternate_row_colors )
                    )->a( n = `ariaLabelledBy`     v = `title`

                    )->ele( `extension`
                        )->ele( n = `OverflowToolbar` ns = `m`
                            )->a( n = `style` v = `Clear`
                            )->tag( n = `Title` ns = `m`
                                )->a( n = `id`   v = `title`
                                )->a( n = `text` v = `Products`
                            )->tag( n = `ToolbarSpacer` ns = `m`
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `SelectionMode:`
                            )->ele( n = `Select` ns = `m`
                                )->a( n = `id`          v = `select`
                                )->a( n = `selectedKey` v = client->_bind( selection_mode )
                                )->ele( n = `items` ns = `m`
                                    )->tag( n = `Item` ns = `core`
                                        )->a( n = `key`  v = `MultiToggle`
                                        )->a( n = `text` v = `MultiToggle`
                                    )->tag( n = `Item` ns = `core`
                                        )->a( n = `key`  v = `Single`
                                        )->a( n = `text` v = `Single`
                                    )->tag( n = `Item` ns = `core`
                                        )->a( n = `key`  v = `None`
                                        )->a( n = `text` v = `None`

                                )->end(
                            )->end(
                            )->tag( n = `ToggleButton` ns = `m`
                                )->a( n = `text`    v = `Toggle Highlights`
                                )->a( n = `pressed` v = client->_bind( show_highlights )
                            )->tag( n = `ToggleButton` ns = `m`
                                )->a( n = `text`    v = `Toggle Alternate Row Colors`
                                )->a( n = `pressed` v = client->_bind( alternate_row_colors )

                        )->end(
                    )->end(

                    )->ele( `rowSettingsTemplate`
                        )->tag( `RowSettings`
                            )->a( n = `highlight`     v = |\{= ${ client->_bind( show_highlights ) } ? $\{STATUS\} : 'None' \}|
                            )->a( n = `highlightText` v = `{STATUSTEXT}`

                    )->end(

                    )->ele( `columns`
                        )->ele( `Column`
                            )->a( n = `sortProperty`   v = `STATUS`
                            )->a( n = `filterProperty` v = `STATUS`
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Status`
                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{STATUS}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(

                        )->ele( `Column`
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Product Name`
                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{NAME}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(

                        )->ele( `Column`
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Product Id`
                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{PRODUCTID}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(

                        )->ele( `Column`
                            )->a( n = `hAlign` v = `End`
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Quantity`
                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{QUANTITY}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(

                        )->ele( `Column`
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Price`
                            )->ele( `template`
                                )->tag( n = `Currency` ns = `unified`
                                    )->a( n = `value`    v = `{PRICE}`
                                    )->a( n = `currency` v = `{CURRENCYCODE}`

                            )->end(
                        )->end(
                    )->end(
                )->end(
            )->end(
        )->end(
    )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.
    DATA temp1 LIKE t_products.
    DATA temp2 LIKE LINE OF temp1.
    FIELD-SYMBOLS <product> LIKE LINE OF t_products.

    " initial toolbar state - the original starts with MultiToggle selection,
    " highlights on (ToggleButton pressed=true) and alternate colors off
    selection_mode       = `MultiToggle`.
    show_highlights      = abap_true.
    alternate_row_colors = abap_false.

    " the shared 123-row demo ProductCollection (sap/ui/demo/mock/products.json)
    " inlined with the columns the sample binds (Name, ProductId, Quantity,
    " Price, CurrencyCode); Price is packed for the numeric u:Currency value
    
    CLEAR temp1.
    
    temp2-name = `Notebook Basic 15`.
    temp2-productid = `HT-1000`.
    temp2-quantity = 10.
    temp2-price = `956`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Basic 17`.
    temp2-productid = `HT-1001`.
    temp2-quantity = 20.
    temp2-price = `1249`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Basic 18`.
    temp2-productid = `HT-1002`.
    temp2-quantity = 10.
    temp2-price = `1570`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Basic 19`.
    temp2-productid = `HT-1003`.
    temp2-quantity = 15.
    temp2-price = `1650`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO Vault`.
    temp2-productid = `HT-1007`.
    temp2-quantity = 15.
    temp2-price = `299`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Professional 15`.
    temp2-productid = `HT-1010`.
    temp2-quantity = 16.
    temp2-price = `1999`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Professional 17`.
    temp2-productid = `HT-1011`.
    temp2-quantity = 17.
    temp2-price = `2299`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO Vault Net`.
    temp2-productid = `HT-1020`.
    temp2-quantity = 14.
    temp2-price = `459`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO Vault SAT`.
    temp2-productid = `HT-1021`.
    temp2-quantity = 50.
    temp2-price = `149`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Comfort Easy`.
    temp2-productid = `HT-1022`.
    temp2-quantity = 30.
    temp2-price = `1679`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Comfort Senior`.
    temp2-productid = `HT-1023`.
    temp2-quantity = 24.
    temp2-price = `512`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ergo Screen E-I`.
    temp2-productid = `HT-1030`.
    temp2-quantity = 14.
    temp2-price = `230`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ergo Screen E-II`.
    temp2-productid = `HT-1031`.
    temp2-quantity = 24.
    temp2-price = `285`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ergo Screen E-III`.
    temp2-productid = `HT-1032`.
    temp2-quantity = 50.
    temp2-price = `345`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat Basic`.
    temp2-productid = `HT-1035`.
    temp2-quantity = 23.
    temp2-price = `399`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat Future`.
    temp2-productid = `HT-1036`.
    temp2-quantity = 22.
    temp2-price = `430`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat XL`.
    temp2-productid = `HT-1037`.
    temp2-quantity = 23.
    temp2-price = `1230`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Laser Professional Eco`.
    temp2-productid = `HT-1040`.
    temp2-quantity = 21.
    temp2-price = `830`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Laser Basic`.
    temp2-productid = `HT-1041`.
    temp2-quantity = 8.
    temp2-price = `490`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Laser Allround`.
    temp2-productid = `HT-1042`.
    temp2-quantity = 9.
    temp2-price = `349`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ultra Jet Super Color`.
    temp2-productid = `HT-1050`.
    temp2-quantity = 17.
    temp2-price = `139`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ultra Jet Mobile`.
    temp2-productid = `HT-1051`.
    temp2-quantity = 18.
    temp2-price = `99`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ultra Jet Super Highspeed`.
    temp2-productid = `HT-1052`.
    temp2-quantity = 25.
    temp2-price = `170`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Multi Print`.
    temp2-productid = `HT-1055`.
    temp2-quantity = 16.
    temp2-price = `99`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Multi Color`.
    temp2-productid = `HT-1056`.
    temp2-quantity = 5.
    temp2-price = `119`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Cordless Mouse`.
    temp2-productid = `HT-1060`.
    temp2-quantity = 25.
    temp2-price = `9`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Speed Mouse`.
    temp2-productid = `HT-1061`.
    temp2-quantity = 12.
    temp2-price = `7`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Track Mouse`.
    temp2-productid = `HT-1062`.
    temp2-quantity = 12.
    temp2-price = `11`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ergonomic Keyboard`.
    temp2-productid = `HT-1063`.
    temp2-quantity = 50.
    temp2-price = `14`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Internet Keyboard`.
    temp2-productid = `HT-1064`.
    temp2-quantity = 35.
    temp2-price = `16`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Media Keyboard`.
    temp2-productid = `HT-1065`.
    temp2-quantity = 26.
    temp2-price = `26`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Mousepad`.
    temp2-productid = `HT-1066`.
    temp2-quantity = 12.
    temp2-price = `6.99`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ergo Mousepad`.
    temp2-productid = `HT-1067`.
    temp2-quantity = 16.
    temp2-price = `8.99`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Designer Mousepad`.
    temp2-productid = `HT-1068`.
    temp2-quantity = 26.
    temp2-price = `12.99`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Universal card reader`.
    temp2-productid = `HT-1069`.
    temp2-quantity = 22.
    temp2-price = `14`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Proctra X`.
    temp2-productid = `HT-1070`.
    temp2-quantity = 15.
    temp2-price = `70.9`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Gladiator MX`.
    temp2-productid = `HT-1071`.
    temp2-quantity = 16.
    temp2-price = `81.7`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Hurricane GX`.
    temp2-productid = `HT-1072`.
    temp2-quantity = 13.
    temp2-price = `101.2`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Hurricane GX/LN`.
    temp2-productid = `HT-1073`.
    temp2-quantity = 5.
    temp2-price = `139.99`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Photo Scan`.
    temp2-productid = `HT-1080`.
    temp2-quantity = 8.
    temp2-price = `129`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Power Scan`.
    temp2-productid = `HT-1081`.
    temp2-quantity = 11.
    temp2-price = `89`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Jet Scan Professional`.
    temp2-productid = `HT-1082`.
    temp2-quantity = 13.
    temp2-price = `169`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Jet Scan Professional`.
    temp2-productid = `HT-1083`.
    temp2-quantity = 10.
    temp2-price = `189`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Copymaster`.
    temp2-productid = `HT-1085`.
    temp2-quantity = 10.
    temp2-price = `1499`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Surround Sound`.
    temp2-productid = `HT-1090`.
    temp2-quantity = 20.
    temp2-price = `39`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Blaster Extreme`.
    temp2-productid = `HT-1091`.
    temp2-quantity = 15.
    temp2-price = `26`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Sound Booster`.
    temp2-productid = `HT-1092`.
    temp2-quantity = 50.
    temp2-price = `45`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Lovely Sound 5.1 Wireless`.
    temp2-productid = `HT-1095`.
    temp2-quantity = 12.
    temp2-price = `49`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Lovely Sound 5.1`.
    temp2-productid = `HT-1096`.
    temp2-quantity = 18.
    temp2-price = `39`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Lovely Sound Stereo`.
    temp2-productid = `HT-1097`.
    temp2-quantity = 21.
    temp2-price = `29`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Office`.
    temp2-productid = `HT-1100`.
    temp2-quantity = 25.
    temp2-price = `89.9`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Design`.
    temp2-productid = `HT-1101`.
    temp2-quantity = 26.
    temp2-price = `79.9`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Network`.
    temp2-productid = `HT-1102`.
    temp2-quantity = 28.
    temp2-price = `69`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Multimedia`.
    temp2-productid = `HT-1103`.
    temp2-quantity = 9.
    temp2-price = `77`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Games`.
    temp2-productid = `HT-1104`.
    temp2-quantity = 13.
    temp2-price = `55`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Internet Antivirus`.
    temp2-productid = `HT-1105`.
    temp2-quantity = 17.
    temp2-price = `29`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Firewall`.
    temp2-productid = `HT-1106`.
    temp2-quantity = 19.
    temp2-price = `34`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Money`.
    temp2-productid = `HT-1107`.
    temp2-quantity = 18.
    temp2-price = `29.9`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `PC Lock`.
    temp2-productid = `HT-1110`.
    temp2-quantity = 14.
    temp2-price = `8.9`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Lock`.
    temp2-productid = `HT-1111`.
    temp2-quantity = 20.
    temp2-price = `6.9`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Web cam reality`.
    temp2-productid = `HT-1112`.
    temp2-quantity = 27.
    temp2-price = `39`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Screen clean`.
    temp2-productid = `HT-1113`.
    temp2-quantity = 17.
    temp2-price = `2.3`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Fabric bag professional`.
    temp2-productid = `HT-1114`.
    temp2-quantity = 14.
    temp2-price = `31`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Wireless DSL Router`.
    temp2-productid = `HT-1115`.
    temp2-quantity = 16.
    temp2-price = `49`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Wireless DSL Router / Repeater`.
    temp2-productid = `HT-1116`.
    temp2-quantity = 12.
    temp2-price = `59`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Wireless DSL Router / Repeater and Print Server`.
    temp2-productid = `HT-1117`.
    temp2-quantity = 12.
    temp2-price = `69`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `USB Stick`.
    temp2-productid = `HT-1118`.
    temp2-quantity = 14.
    temp2-price = `35`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Travel Adapter`.
    temp2-productid = `HT-1119`.
    temp2-quantity = 10.
    temp2-price = `79`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Cordless Bluetooth Keyboard, english international`.
    temp2-productid = `HT-1120`.
    temp2-quantity = 13.
    temp2-price = `29`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat XXL`.
    temp2-productid = `HT-1137`.
    temp2-quantity = 10.
    temp2-price = `1430`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Pocket Mouse`.
    temp2-productid = `HT-1138`.
    temp2-quantity = 20.
    temp2-price = `23`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `PC Power Station`.
    temp2-productid = `HT-1210`.
    temp2-quantity = 22.
    temp2-price = `2399`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Astro Laptop 1516`.
    temp2-productid = `HT-1251`.
    temp2-quantity = 23.
    temp2-price = `989`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Astro Phone 6`.
    temp2-productid = `HT-1252`.
    temp2-quantity = 28.
    temp2-price = `649`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Benda Laptop 1408`.
    temp2-productid = `HT-1253`.
    temp2-quantity = 27.
    temp2-price = `976`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Bending Screen 21HD`.
    temp2-productid = `HT-1254`.
    temp2-quantity = 23.
    temp2-price = `250`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Broad Screen 22HD`.
    temp2-productid = `HT-1255`.
    temp2-quantity = 5.
    temp2-price = `270`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Cerdik Phone 7`.
    temp2-productid = `HT-1256`.
    temp2-quantity = 19.
    temp2-price = `549`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Cepat Tablet 10.5`.
    temp2-productid = `HT-1257`.
    temp2-quantity = 17.
    temp2-price = `549`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Cepat Tablet 8`.
    temp2-productid = `HT-1258`.
    temp2-quantity = 24.
    temp2-price = `529`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Server Basic`.
    temp2-productid = `HT-1500`.
    temp2-quantity = 24.
    temp2-price = `5000`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Server Professional`.
    temp2-productid = `HT-1501`.
    temp2-quantity = 26.
    temp2-price = `15000`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Server Power Pro`.
    temp2-productid = `HT-1502`.
    temp2-quantity = 34.
    temp2-price = `25000`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Family PC Basic`.
    temp2-productid = `HT-1600`.
    temp2-quantity = 10.
    temp2-price = `600`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Family PC Pro`.
    temp2-productid = `HT-1601`.
    temp2-quantity = 20.
    temp2-price = `900`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Gaming Monster`.
    temp2-productid = `HT-1602`.
    temp2-quantity = 24.
    temp2-price = `1200`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Gaming Monster Pro`.
    temp2-productid = `HT-1603`.
    temp2-quantity = 25.
    temp2-price = `1700`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `7" Widescreen Portable DVD Player w MP3`.
    temp2-productid = `HT-2000`.
    temp2-quantity = 20.
    temp2-price = `249.99`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `10" Portable DVD player`.
    temp2-productid = `HT-2001`.
    temp2-quantity = 21.
    temp2-price = `449.99`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Portable DVD Player with 9" LCD Monitor`.
    temp2-productid = `HT-2002`.
    temp2-quantity = 50.
    temp2-price = `853.99`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `CD/DVD case: 264 sleeves`.
    temp2-productid = `HT-2025`.
    temp2-quantity = 26.
    temp2-price = `44.99`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Audio/Video Cable Kit - 4m`.
    temp2-productid = `HT-2026`.
    temp2-quantity = 16.
    temp2-price = `29.99`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Removable CD/DVD Laser Labels`.
    temp2-productid = `HT-2027`.
    temp2-quantity = 25.
    temp2-price = `8.99`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Beam Breaker B-1`.
    temp2-productid = `HT-6100`.
    temp2-quantity = 32.
    temp2-price = `469`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Beam Breaker B-2`.
    temp2-productid = `HT-6101`.
    temp2-quantity = 18.
    temp2-price = `679`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Beam Breaker B-3`.
    temp2-productid = `HT-6102`.
    temp2-quantity = 16.
    temp2-price = `889`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Play Movie`.
    temp2-productid = `HT-6110`.
    temp2-quantity = 15.
    temp2-price = `130`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Record Movie`.
    temp2-productid = `HT-6111`.
    temp2-quantity = 24.
    temp2-price = `288`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelo MusicStick`.
    temp2-productid = `HT-6120`.
    temp2-quantity = 15.
    temp2-price = `45`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelo Jog-Mate`.
    temp2-productid = `HT-6121`.
    temp2-quantity = 24.
    temp2-price = `63`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Power Pro Player 40`.
    temp2-productid = `HT-6122`.
    temp2-quantity = 23.
    temp2-price = `167`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Power Pro Player 80`.
    temp2-productid = `HT-6123`.
    temp2-quantity = 13.
    temp2-price = `299`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat Watch HD32`.
    temp2-productid = `HT-6130`.
    temp2-quantity = 16.
    temp2-price = `1459`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat Watch HD37`.
    temp2-productid = `HT-6131`.
    temp2-quantity = 14.
    temp2-price = `1199`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat Watch HD41`.
    temp2-productid = `HT-6132`.
    temp2-quantity = 13.
    temp2-price = `899`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Copperberry`.
    temp2-productid = `HT-7000`.
    temp2-quantity = 5.
    temp2-price = `549`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Silverberry`.
    temp2-productid = `HT-7010`.
    temp2-quantity = 9.
    temp2-price = `549`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Goldberry`.
    temp2-productid = `HT-7020`.
    temp2-quantity = 11.
    temp2-price = `549`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Platinberry`.
    temp2-productid = `HT-7030`.
    temp2-quantity = 12.
    temp2-price = `549`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO FlexTop I4000`.
    temp2-productid = `HT-8000`.
    temp2-quantity = 11.
    temp2-price = `799`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO FlexTop I6300c`.
    temp2-productid = `HT-8001`.
    temp2-quantity = 20.
    temp2-price = `799`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO FlexTop I9100`.
    temp2-productid = `HT-8002`.
    temp2-quantity = 20.
    temp2-price = `1199`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO FlexTop I9800`.
    temp2-productid = `HT-8003`.
    temp2-quantity = 22.
    temp2-price = `1388`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smartphone Leather Case`.
    temp2-productid = `HT-9991`.
    temp2-quantity = 12.
    temp2-price = `25`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smartphone Alpha`.
    temp2-productid = `HT-9992`.
    temp2-quantity = 13.
    temp2-price = `599`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Mini Tablet`.
    temp2-productid = `HT-9993`.
    temp2-quantity = 10.
    temp2-price = `833`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Camcorder View`.
    temp2-productid = `HT-9994`.
    temp2-quantity = 50.
    temp2-price = `1388`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Tablet Pouch`.
    temp2-productid = `HT-9995`.
    temp2-quantity = 34.
    temp2-price = `20`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Tablet Pouch`.
    temp2-productid = `HT-9996`.
    temp2-quantity = 34.
    temp2-price = `20`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `e-Book Reader ReadMe`.
    temp2-productid = `HT-9997`.
    temp2-quantity = 23.
    temp2-price = `33`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smartphone Beta`.
    temp2-productid = `HT-9998`.
    temp2-quantity = 21.
    temp2-price = `30`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Maxi Tablet`.
    temp2-productid = `HT-9999`.
    temp2-quantity = 20.
    temp2-price = `749`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flyer`.
    temp2-productid = `PF-1000`.
    temp2-quantity = 33.
    temp2-price = `0`.
    temp2-currencycode = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    t_products = temp1.

    " classify each row exactly as the sample controller does: the first five
    " rows carry fixed highlight states, the rest are derived from the Price
    " thresholds (thin-frontend - the original computes this in the controller)
    
    LOOP AT t_products ASSIGNING <product>.
      CASE sy-tabix.
        WHEN 1.
          <product>-status = `Success`.
        WHEN 2.
          <product>-status = `Warning`.
        WHEN 3.
          <product>-status = `Error`.
        WHEN 4.
          <product>-status = `Information`.
        WHEN 5.
          <product>-status = `None`.
        WHEN OTHERS.
          IF <product>-price < 300.
            <product>-status     = `Success`.
            <product>-statustext = `Custom success highlight text`.
          ELSEIF <product>-price < 600.
            <product>-status     = `Warning`.
            <product>-statustext = `Custom warning highlight text`.
          ELSEIF <product>-price < 900.
            <product>-status     = `Error`.
            <product>-statustext = `Custom error highlight text`.
          ELSEIF <product>-price < 1200.
            <product>-status     = `Information`.
            <product>-statustext = `Custom information highlight text`.
          ELSEIF <product>-price < 1500.
            <product>-status     = `Indication01`.
            <product>-statustext = `Custom indication highlight text`.
          ELSE.
            <product>-status = `None`.
          ENDIF.
      ENDCASE.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
