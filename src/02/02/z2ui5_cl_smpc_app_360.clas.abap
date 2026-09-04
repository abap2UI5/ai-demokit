" @keywords table sap.ui.table selectcopypaste multiselectionplugin fixed busyindicator overflowtoolbar title toolbarspacer select item button
" @summary Shows cell selection, copy and paste interaction in the table.
CLASS z2ui5_cl_smpc_app_360 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name         TYPE string,
        productid    TYPE string,
        category     TYPE string,
        suppliername TYPE string,
        price        TYPE string,
        currencycode TYPE string,
        width        TYPE string,
        height       TYPE string,
        depth        TYPE string,
        dimunit      TYPE string,
      END OF ty_s_product,
      BEGIN OF ty_s_mode,
        mode TYPE string,
      END OF ty_s_mode.
    DATA t_products       TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

    " the original's `ui>` model: the three selection modes and the picked one
    DATA t_selectionmodes TYPE STANDARD TABLE OF ty_s_mode WITH DEFAULT KEY.
    DATA selection_mode   TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_360 IMPLEMENTATION.

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
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " the select / copy / paste demo. The selection-mode Select and the
    " MultiSelectionPlugin bind the same field, so onSelectChange disappears;
    " the paste event carries the pasted data to the backend, which reports it.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.ui.table`
        )->a( n = `xmlns:trm` v = `sap.ui.table.rowmodes`
        )->a( n = `xmlns:tp`  v = `sap.ui.table.plugins`
        )->a( n = `xmlns:mp`  v = `sap.m.plugins`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:u`   v = `sap.ui.unified`
        )->a( n = `xmlns:c`   v = `sap.ui.core`
        )->a( n = `xmlns:m`   v = `sap.m`
        )->a( n = `height`    v = `100%`

        )->ele( n = `Page` ns = `m`
            )->a( n = `showHeader`      v = `false`
            )->a( n = `enableScrolling` v = `false`
            )->a( n = `class`           v = `sapUiContentPadding`

            )->ele( n = `content` ns = `m`
                )->ele( `Table`
                    )->a( n = `id`                  v = `table`
                    )->a( n = `enableSelectAll`     v = `false`
                    )->a( n = `rows`                v = client->_bind( t_products )
                    )->a( n = `threshold`           v = `15`
                    )->a( n = `enableBusyIndicator` v = `true`
                    )->a( n = `ariaLabelledBy`      v = `title`
                    )->a( n = `paste`               v = client->_event( val = `PASTE` arg = `${$parameters>/data}` )

                    )->ele( `dependents`
                        )->tag( n = `MultiSelectionPlugin` ns = `tp`
                            )->a( n = `limit`              v = `100`
                            )->a( n = `enableNotification` v = `true`
                            )->a( n = `selectionMode`      v = client->_bind( selection_mode )

                    )->end(
                    )->ele( `rowMode`
                        )->tag( n = `Fixed` ns = `trm`
                            )->a( n = `rowCount` v = `7`

                    )->end(
                    )->ele( `noData`
                        )->tag( n = `BusyIndicator` ns = `m`
                            )->a( n = `class` v = `sapUiMediumMargin`

                    )->end(
                    )->ele( `extension`
                        )->ele( n = `OverflowToolbar` ns = `m`
                            )->a( n = `id`    v = `toolbar`
                            )->a( n = `style` v = `Clear`

                            )->tag( n = `Title` ns = `m`
                                )->a( n = `id`   v = `title`
                                )->a( n = `text` v = `Products`

                            )->tag( n = `ToolbarSpacer` ns = `m`

                            )->ele( n = `Select` ns = `m`
                                )->a( n = `items`       v = client->_bind( t_selectionmodes )
                                )->a( n = `selectedKey` v = client->_bind( selection_mode )

                                )->tag( n = `Item` ns = `c`
                                    )->a( n = `key`  v = `{MODE}`
                                    )->a( n = `text` v = `{MODE}`

                            )->end(
                            )->ele( n = `Button` ns = `m`
                                )->ele( n = `dependents` ns = `m`
                                    )->tag( n = `PasteProvider` ns = `mp`
                                        )->a( n = `pasteFor` v = `table`

                                )->end(
                            )->end(
                        )->end(
                    )->end(
                    )->ele( `columns`
                        )->ele( `Column`
                            )->a( n = `sortProperty`   v = `NAME`
                            )->a( n = `filterProperty` v = `NAME`
                            )->a( n = `autoResizable`  v = `true`
                            )->a( n = `width`          v = `11rem`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Product Name`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{NAME}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `sortProperty`   v = `PRODUCTID`
                            )->a( n = `filterProperty` v = `PRODUCTID`
                            )->a( n = `autoResizable`  v = `true`
                            )->a( n = `width`          v = `6rem`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Product ID`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{PRODUCTID}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `sortProperty`   v = `CATEGORY`
                            )->a( n = `filterProperty` v = `CATEGORY`
                            )->a( n = `autoResizable`  v = `true`
                            )->a( n = `width`          v = `11rem`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Prod. Cat.`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{CATEGORY}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `sortProperty`   v = `SUPPLIERNAME`
                            )->a( n = `filterProperty` v = `SUPPLIERNAME`
                            )->a( n = `autoResizable`  v = `true`
                            )->a( n = `width`          v = `12rem`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Company Name`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{SUPPLIERNAME}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `filterProperty` v = `PRICE`
                            )->a( n = `width`          v = `9rem`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Unit Price`

                            )->ele( `template`
                                )->tag( n = `Currency` ns = `u`
                                    )->a( n = `value`    v = |\{ path: 'PRICE', type: 'sap.ui.model.type.String' \}|
                                    )->a( n = `currency` v = `{CURRENCYCODE}`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `hAlign`        v = `End`
                            )->a( n = `autoResizable` v = `true`
                            )->a( n = `width`         v = `9rem`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Dimensions`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{WIDTH}x{HEIGHT}x{DEPTH} {DIMUNIT}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                    )->end(
                )->end(
            )->end(
        )->end(
    )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
      DATA lv_pasted TYPE string.

    IF client->get_event( ) = `PASTE`.
      " onPaste: report what arrived. The original first asks whether to
      " paste at the selected cell range; the CellSelector that provides that
      " range is added in the controller and has no counterpart here, so the
      " table-level branch of the same handler is what remains
      " the paste parameter is string[][], so it arrives as serialized JSON -
      " [["Pasted Name","Pasted Id"]]. The original concatenates the ARRAY into
      " the message, and JS coerces it to Pasted Name,Pasted Id. Toasting the
      " raw JSON (until 2026-08-24) showed the brackets and quotes the user
      " never sees upstream; stripping them reproduces the coercion, the same
      " way the sibling port 361 declares it for its index array.
      
      lv_pasted = client->get_event_arg( ).
      REPLACE ALL OCCURRENCES OF `"` IN lv_pasted WITH ``.
      REPLACE ALL OCCURRENCES OF `[` IN lv_pasted WITH ``.
      REPLACE ALL OCCURRENCES OF `]` IN lv_pasted WITH ``.
      client->message_toast_display( |Pasted Data (on Table Level):\n\n{ lv_pasted }| ).
    ENDIF.


  ENDMETHOD.


  METHOD model_init.

    " the `ui>` model the controller sets: three selection modes, MultiToggle
    " preselected
    DATA temp1 LIKE t_selectionmodes.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp3 LIKE t_products.
    DATA temp4 LIKE LINE OF temp3.
    CLEAR temp1.
    
    temp2-mode = `MultiToggle`.
    INSERT temp2 INTO TABLE temp1.
    temp2-mode = `Single`.
    INSERT temp2 INTO TABLE temp1.
    temp2-mode = `None`.
    INSERT temp2 INTO TABLE temp1.
    t_selectionmodes = temp1.
    selection_mode   = `MultiToggle`.

    " the OData ProductSet the sample serves from a MockServer, inlined with
    " the columns the six table columns bind - all 115 rows of ProductSet.json
    
    CLEAR temp3.
    
    temp4-name = `Flyer`.
    temp4-productid = `AD-1000`.
    temp4-category = `Computer system accessories`.
    temp4-suppliername = `Robert Brown Entertainment`.
    temp4-price = `0.0`.
    temp4-currencycode = `CAD`.
    temp4-width = `0.46`.
    temp4-height = `0.03`.
    temp4-depth = `0.3`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Basic 15`.
    temp4-productid = `HT-1000`.
    temp4-category = `Notebooks`.
    temp4-suppliername = `SAP`.
    temp4-price = `956.0`.
    temp4-currencycode = `EUR`.
    temp4-width = `0.3`.
    temp4-height = `0.03`.
    temp4-depth = `0.18`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Basic 17`.
    temp4-productid = `HT-1001`.
    temp4-category = `Notebooks`.
    temp4-suppliername = `Becker Berlin`.
    temp4-price = `1249.0`.
    temp4-currencycode = `EUR`.
    temp4-width = `0.29`.
    temp4-height = `0.03`.
    temp4-depth = `0.17`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Basic 18`.
    temp4-productid = `HT-1002`.
    temp4-category = `Notebooks`.
    temp4-suppliername = `DelBont Industries`.
    temp4-price = `1570.0`.
    temp4-currencycode = `USD`.
    temp4-width = `0.28`.
    temp4-height = `0.03`.
    temp4-depth = `0.19`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Basic 19`.
    temp4-productid = `HT-1003`.
    temp4-category = `Notebooks`.
    temp4-suppliername = `Talpa`.
    temp4-price = `1650.0`.
    temp4-currencycode = `EUR`.
    temp4-width = `0.32`.
    temp4-height = `0.04`.
    temp4-depth = `0.21`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO Vault`.
    temp4-productid = `HT-1007`.
    temp4-category = `PDAs/Organizers`.
    temp4-suppliername = `Panorama Studios`.
    temp4-price = `299.0`.
    temp4-currencycode = `USD`.
    temp4-width = `0.32`.
    temp4-height = `0.03`.
    temp4-depth = `0.22`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Professional 15`.
    temp4-productid = `HT-1010`.
    temp4-category = `Notebooks`.
    temp4-suppliername = `TECUM`.
    temp4-price = `1999.0`.
    temp4-currencycode = `EUR`.
    temp4-width = `0.33`.
    temp4-height = `0.03`.
    temp4-depth = `0.2`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Professional 17`.
    temp4-productid = `HT-1011`.
    temp4-category = `Notebooks`.
    temp4-suppliername = `Asia High tech`.
    temp4-price = `2299.0`.
    temp4-currencycode = `JPY`.
    temp4-width = `0.33`.
    temp4-height = `0.02`.
    temp4-depth = `0.23`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO Vault Net`.
    temp4-productid = `HT-1020`.
    temp4-category = `PDAs/Organizers`.
    temp4-suppliername = `Laurent`.
    temp4-price = `459.0`.
    temp4-currencycode = `EUR`.
    temp4-width = `0.1`.
    temp4-height = `0.17`.
    temp4-depth = `0.02`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO Vault SAT`.
    temp4-productid = `HT-1021`.
    temp4-category = `PDAs/Organizers`.
    temp4-suppliername = `AVANTEL`.
    temp4-price = `149.0`.
    temp4-currencycode = `MXN`.
    temp4-width = `0.11`.
    temp4-height = `0.18`.
    temp4-depth = `0.02`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Comfort Easy`.
    temp4-productid = `HT-1022`.
    temp4-category = `PDAs/Organizers`.
    temp4-suppliername = `Telecomunicaciones Star`.
    temp4-price = `1679.0`.
    temp4-currencycode = `ARS`.
    temp4-width = `0.84`.
    temp4-height = `0.14`.
    temp4-depth = `0.02`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Comfort Senior`.
    temp4-productid = `HT-1023`.
    temp4-category = `PDAs/Organizers`.
    temp4-suppliername = `Pear Computing Services`.
    temp4-price = `512.0`.
    temp4-currencycode = `USD`.
    temp4-width = `0.8`.
    temp4-height = `0.13`.
    temp4-depth = `0.02`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergo Screen E-I`.
    temp4-productid = `HT-1030`.
    temp4-category = `Flat screens`.
    temp4-suppliername = `Alpine Systems`.
    temp4-price = `230.0`.
    temp4-currencycode = `EUR`.
    temp4-width = `0.37`.
    temp4-height = `0.36`.
    temp4-depth = `0.12`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergo Screen E-II`.
    temp4-productid = `HT-1031`.
    temp4-category = `Flat screens`.
    temp4-suppliername = `New Line Design`.
    temp4-price = `285.0`.
    temp4-currencycode = `GBP`.
    temp4-width = `0.41`.
    temp4-height = `0.43`.
    temp4-depth = `0.19`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergo Screen E-III`.
    temp4-productid = `HT-1032`.
    temp4-category = `Flat screens`.
    temp4-suppliername = `HEPA Tec`.
    temp4-price = `345.0`.
    temp4-currencycode = `EUR`.
    temp4-width = `0.41`.
    temp4-height = `0.43`.
    temp4-depth = `0.19`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Basic`.
    temp4-productid = `HT-1035`.
    temp4-category = `Flat screens`.
    temp4-suppliername = `Anav Ideon`.
    temp4-price = `399.0`.
    temp4-currencycode = `USD`.
    temp4-width = `0.39`.
    temp4-height = `0.41`.
    temp4-depth = `0.2`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Future`.
    temp4-productid = `HT-1036`.
    temp4-category = `Flat screens`.
    temp4-suppliername = `Robert Brown Entertainment`.
    temp4-price = `430.0`.
    temp4-currencycode = `CAD`.
    temp4-width = `0.45`.
    temp4-height = `0.46`.
    temp4-depth = `0.26`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat XL`.
    temp4-productid = `HT-1037`.
    temp4-category = `Flat screens`.
    temp4-suppliername = `Mexican Oil Trading Company`.
    temp4-price = `1230.0`.
    temp4-currencycode = `MXN`.
    temp4-width = `0.55`.
    temp4-height = `0.39`.
    temp4-depth = `0.22`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Laser Professional Eco`.
    temp4-productid = `HT-1040`.
    temp4-category = `Laser printers`.
    temp4-suppliername = `Meliva`.
    temp4-price = `830.0`.
    temp4-currencycode = `EUR`.
    temp4-width = `0.51`.
    temp4-height = `0.3`.
    temp4-depth = `0.46`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Laser Basic`.
    temp4-productid = `HT-1041`.
    temp4-category = `Laser printers`.
    temp4-suppliername = `Compostela`.
    temp4-price = `490.0`.
    temp4-currencycode = `ARS`.
    temp4-width = `0.48`.
    temp4-height = `0.26`.
    temp4-depth = `0.42`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Laser Allround`.
    temp4-productid = `HT-1042`.
    temp4-category = `Laser printers`.
    temp4-suppliername = `Pateu`.
    temp4-price = `349.0`.
    temp4-currencycode = `EUR`.
    temp4-width = `0.53`.
    temp4-height = `0.65`.
    temp4-depth = `0.5`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ultra Jet Super Color`.
    temp4-productid = `HT-1050`.
    temp4-category = `Ink jet printers`.
    temp4-suppliername = `Russian Electronic Trading Company`.
    temp4-price = `139.0`.
    temp4-currencycode = `RUB`.
    temp4-width = `0.41`.
    temp4-height = `0.28`.
    temp4-depth = `0.41`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ultra Jet Mobile`.
    temp4-productid = `HT-1051`.
    temp4-category = `Ink jet printers`.
    temp4-suppliername = `Florida Holiday Company`.
    temp4-price = `99.0`.
    temp4-currencycode = `USD`.
    temp4-width = `0.46`.
    temp4-height = `0.25`.
    temp4-depth = `0.32`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ultra Jet Super Highspeed`.
    temp4-productid = `HT-1052`.
    temp4-category = `Ink jet printers`.
    temp4-suppliername = `Quimica Madrilenos`.
    temp4-price = `170.0`.
    temp4-currencycode = `EUR`.
    temp4-width = `0.41`.
    temp4-height = `0.28`.
    temp4-depth = `0.41`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Multi Print`.
    temp4-productid = `HT-1055`.
    temp4-category = `Multifunction printers`.
    temp4-suppliername = `Getränkegroßhandel Janssen`.
    temp4-price = `99.0`.
    temp4-currencycode = `EUR`.
    temp4-width = `0.55`.
    temp4-height = `0.29`.
    temp4-depth = `0.45`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Multi Color`.
    temp4-productid = `HT-1056`.
    temp4-category = `Multifunction printers`.
    temp4-suppliername = `JaTeCo`.
    temp4-price = `119.0`.
    temp4-currencycode = `JPY`.
    temp4-width = `0.51`.
    temp4-height = `0.22`.
    temp4-depth = `0.41`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cordless Mouse`.
    temp4-productid = `HT-1060`.
    temp4-category = `Mice`.
    temp4-suppliername = `Tessile Casa Di Roma`.
    temp4-price = `9.0`.
    temp4-currencycode = `EUR`.
    temp4-width = `0.06`.
    temp4-height = `0.04`.
    temp4-depth = `0.15`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Speed Mouse`.
    temp4-productid = `HT-1061`.
    temp4-category = `Mice`.
    temp4-suppliername = `Vente Et Réparation de Ordinateur`.
    temp4-price = `7.0`.
    temp4-currencycode = `EUR`.
    temp4-width = `0.07`.
    temp4-height = `0.03`.
    temp4-depth = `0.15`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Track Mouse`.
    temp4-productid = `HT-1062`.
    temp4-category = `Mice`.
    temp4-suppliername = `Developement Para O Governo`.
    temp4-price = `11.0`.
    temp4-currencycode = `ARS`.
    temp4-width = `0.0`.
    temp4-height = `0.04`.
    temp4-depth = `0.01`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergonomic Keyboard`.
    temp4-productid = `HT-1063`.
    temp4-category = `Keyboards`.
    temp4-suppliername = `Brazil Technologies`.
    temp4-price = `14.0`.
    temp4-currencycode = `BRL`.
    temp4-width = `0.5`.
    temp4-height = `0.04`.
    temp4-depth = `0.21`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Internet Keyboard`.
    temp4-productid = `HT-1064`.
    temp4-category = `Keyboards`.
    temp4-suppliername = `C.R.T.U.`.
    temp4-price = `16.0`.
    temp4-currencycode = `CAD`.
    temp4-width = `0.52`.
    temp4-height = `0.03`.
    temp4-depth = `0.25`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Media Keyboard`.
    temp4-productid = `HT-1065`.
    temp4-category = `Keyboards`.
    temp4-suppliername = `Jologa`.
    temp4-price = `26.0`.
    temp4-currencycode = `CHF`.
    temp4-width = `0.51`.
    temp4-height = `0.04`.
    temp4-depth = `0.23`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Mousepad`.
    temp4-productid = `HT-1066`.
    temp4-category = `Mousepads`.
    temp4-suppliername = `Baleda`.
    temp4-price = `6.99`.
    temp4-currencycode = `USD`.
    temp4-width = `0.15`.
    temp4-height = `0.0`.
    temp4-depth = `0.06`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergo Mousepad`.
    temp4-productid = `HT-1067`.
    temp4-category = `Mousepads`.
    temp4-suppliername = `Angeré`.
    temp4-price = `8.99`.
    temp4-currencycode = `EUR`.
    temp4-width = `0.15`.
    temp4-height = `0.0`.
    temp4-depth = `0.06`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Designer Mousepad`.
    temp4-productid = `HT-1068`.
    temp4-category = `Mousepads`.
    temp4-suppliername = `PC Gym Tec`.
    temp4-price = `12.99`.
    temp4-currencycode = `USD`.
    temp4-width = `0.24`.
    temp4-height = `0.01`.
    temp4-depth = `0.24`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Universal card reader`.
    temp4-productid = `HT-1069`.
    temp4-category = `Computer system accessories`.
    temp4-suppliername = `Japan Insurance Partner`.
    temp4-price = `14.0`.
    temp4-currencycode = `JPY`.
    temp4-width = `0.01`.
    temp4-height = `0.0`.
    temp4-depth = `0.01`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Proctra X`.
    temp4-productid = `HT-1070`.
    temp4-category = `Graphic cards`.
    temp4-suppliername = `Entertainment Argentinia`.
    temp4-price = `70.9`.
    temp4-currencycode = `ARS`.
    temp4-width = `0.22`.
    temp4-height = `0.17`.
    temp4-depth = `0.35`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Gladiator MX`.
    temp4-productid = `HT-1071`.
    temp4-category = `Graphic cards`.
    temp4-suppliername = `African Gold And Diamond Corporation`.
    temp4-price = `81.7`.
    temp4-currencycode = `ZAR`.
    temp4-width = `0.22`.
    temp4-height = `0.17`.
    temp4-depth = `0.35`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Hurricane GX`.
    temp4-productid = `HT-1072`.
    temp4-category = `Graphic cards`.
    temp4-suppliername = `PicoBit`.
    temp4-price = `101.2`.
    temp4-currencycode = `USD`.
    temp4-width = `0.22`.
    temp4-height = `0.17`.
    temp4-depth = `0.35`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Hurricane GX/LN`.
    temp4-productid = `HT-1073`.
    temp4-category = `Graphic cards`.
    temp4-suppliername = `Bionic Research Lab`.
    temp4-price = `139.99`.
    temp4-currencycode = `EUR`.
    temp4-width = `0.22`.
    temp4-height = `0.17`.
    temp4-depth = `0.35`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Photo Scan`.
    temp4-productid = `HT-1080`.
    temp4-category = `Scanners`.
    temp4-suppliername = `Indian IT Trading Company`.
    temp4-price = `129.0`.
    temp4-currencycode = `INR`.
    temp4-width = `0.34`.
    temp4-height = `0.05`.
    temp4-depth = `0.48`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Power Scan`.
    temp4-productid = `HT-1081`.
    temp4-category = `Scanners`.
    temp4-suppliername = `Chemia A Technicznie Fabryka`.
    temp4-price = `89.0`.
    temp4-currencycode = `PLN`.
    temp4-width = `0.31`.
    temp4-height = `0.07`.
    temp4-depth = `0.43`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Jet Scan Professional`.
    temp4-productid = `HT-1082`.
    temp4-category = `Scanners`.
    temp4-suppliername = `South American IT Company`.
    temp4-price = `169.0`.
    temp4-currencycode = `ARS`.
    temp4-width = `0.33`.
    temp4-height = `0.12`.
    temp4-depth = `0.41`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Jet Scan Professional`.
    temp4-productid = `HT-1083`.
    temp4-category = `Scanners`.
    temp4-suppliername = `Siwusha`.
    temp4-price = `189.0`.
    temp4-currencycode = `CNY`.
    temp4-width = `0.35`.
    temp4-height = `0.1`.
    temp4-depth = `0.4`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Copymaster`.
    temp4-productid = `HT-1085`.
    temp4-category = `Multifunction printers`.
    temp4-suppliername = `Danish Fish Trading Company`.
    temp4-price = `1499.0`.
    temp4-currencycode = `DKK`.
    temp4-width = `0.45`.
    temp4-height = `0.22`.
    temp4-depth = `0.42`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Surround Sound`.
    temp4-productid = `HT-1090`.
    temp4-category = `Speakers`.
    temp4-suppliername = `Sorali`.
    temp4-price = `39.0`.
    temp4-currencycode = `EUR`.
    temp4-width = `0.12`.
    temp4-height = `0.16`.
    temp4-depth = `0.1`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Blaster Extreme`.
    temp4-productid = `HT-1091`.
    temp4-category = `Speakers`.
    temp4-suppliername = `SAP`.
    temp4-price = `26.0`.
    temp4-currencycode = `EUR`.
    temp4-width = `0.13`.
    temp4-height = `0.18`.
    temp4-depth = `0.11`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Sound Booster`.
    temp4-productid = `HT-1092`.
    temp4-category = `Speakers`.
    temp4-suppliername = `Becker Berlin`.
    temp4-price = `45.0`.
    temp4-currencycode = `EUR`.
    temp4-width = `0.12`.
    temp4-height = `0.18`.
    temp4-depth = `0.1`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Lovely Sound 5.1 Wireless`.
    temp4-productid = `HT-1095`.
    temp4-category = `Headsets`.
    temp4-suppliername = `PC Gym Tec`.
    temp4-price = `49.0`.
    temp4-currencycode = `USD`.
    temp4-width = `0.24`.
    temp4-height = `0.23`.
    temp4-depth = `0.02`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Lovely Sound 5.1`.
    temp4-productid = `HT-1096`.
    temp4-category = `Headsets`.
    temp4-suppliername = `Japan Insurance Partner`.
    temp4-price = `39.0`.
    temp4-currencycode = `JPY`.
    temp4-width = `0.25`.
    temp4-height = `0.19`.
    temp4-depth = `0.02`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Lovely Sound Stereo`.
    temp4-productid = `HT-1097`.
    temp4-category = `Headsets`.
    temp4-suppliername = `Entertainment Argentinia`.
    temp4-price = `29.0`.
    temp4-currencycode = `ARS`.
    temp4-width = `0.21`.
    temp4-height = `0.2`.
    temp4-depth = `0.02`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Office`.
    temp4-productid = `HT-1100`.
    temp4-category = `Software`.
    temp4-suppliername = `DelBont Industries`.
    temp4-price = `89.9`.
    temp4-currencycode = `USD`.
    temp4-width = `0.15`.
    temp4-height = `0.21`.
    temp4-depth = `0.07`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Design`.
    temp4-productid = `HT-1101`.
    temp4-category = `Software`.
    temp4-suppliername = `Talpa`.
    temp4-price = `79.9`.
    temp4-currencycode = `EUR`.
    temp4-width = `0.14`.
    temp4-height = `0.24`.
    temp4-depth = `0.07`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Network`.
    temp4-productid = `HT-1102`.
    temp4-category = `Software`.
    temp4-suppliername = `Panorama Studios`.
    temp4-price = `69.0`.
    temp4-currencycode = `USD`.
    temp4-width = `0.16`.
    temp4-height = `0.27`.
    temp4-depth = `0.06`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Multimedia`.
    temp4-productid = `HT-1103`.
    temp4-category = `Software`.
    temp4-suppliername = `TECUM`.
    temp4-price = `77.0`.
    temp4-currencycode = `EUR`.
    temp4-width = `0.11`.
    temp4-height = `0.22`.
    temp4-depth = `0.03`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Games`.
    temp4-productid = `HT-1104`.
    temp4-category = `Software`.
    temp4-suppliername = `Asia High tech`.
    temp4-price = `55.0`.
    temp4-currencycode = `JPY`.
    temp4-width = `0.1`.
    temp4-height = `0.3`.
    temp4-depth = `0.03`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Internet Antivirus`.
    temp4-productid = `HT-1105`.
    temp4-category = `Software`.
    temp4-suppliername = `Laurent`.
    temp4-price = `29.0`.
    temp4-currencycode = `EUR`.
    temp4-width = `0.16`.
    temp4-height = `0.21`.
    temp4-depth = `0.04`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Firewall`.
    temp4-productid = `HT-1106`.
    temp4-category = `Software`.
    temp4-suppliername = `AVANTEL`.
    temp4-price = `34.0`.
    temp4-currencycode = `MXN`.
    temp4-width = `0.18`.
    temp4-height = `0.23`.
    temp4-depth = `0.04`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Money`.
    temp4-productid = `HT-1107`.
    temp4-category = `Software`.
    temp4-suppliername = `Telecomunicaciones Star`.
    temp4-price = `29.9`.
    temp4-currencycode = `ARS`.
    temp4-width = `0.12`.
    temp4-height = `0.19`.
    temp4-depth = `0.02`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `PC Lock`.
    temp4-productid = `HT-1110`.
    temp4-category = `Computer system accessories`.
    temp4-suppliername = `Pear Computing Services`.
    temp4-price = `8.9`.
    temp4-currencycode = `USD`.
    temp4-width = `0.2`.
    temp4-height = `0.04`.
    temp4-depth = `0.08`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Lock`.
    temp4-productid = `HT-1111`.
    temp4-category = `Computer system accessories`.
    temp4-suppliername = `Alpine Systems`.
    temp4-price = `6.9`.
    temp4-currencycode = `EUR`.
    temp4-width = `0.31`.
    temp4-height = `0.07`.
    temp4-depth = `0.09`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Web cam reality`.
    temp4-productid = `HT-1112`.
    temp4-category = `Computer system accessories`.
    temp4-suppliername = `New Line Design`.
    temp4-price = `39.0`.
    temp4-currencycode = `GBP`.
    temp4-width = `0.09`.
    temp4-height = `0.01`.
    temp4-depth = `0.08`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Screen clean`.
    temp4-productid = `HT-1113`.
    temp4-category = `Computer system accessories`.
    temp4-suppliername = `HEPA Tec`.
    temp4-price = `2.3`.
    temp4-currencycode = `EUR`.
    temp4-width = `0.02`.
    temp4-height = `0.0`.
    temp4-depth = `0.02`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Fabric bag professional`.
    temp4-productid = `HT-1114`.
    temp4-category = `Computer system accessories`.
    temp4-suppliername = `Anav Ideon`.
    temp4-price = `31.0`.
    temp4-currencycode = `USD`.
    temp4-width = `0.42`.
    temp4-height = `0.07`.
    temp4-depth = `0.32`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Wireless DSL Router`.
    temp4-productid = `HT-1115`.
    temp4-category = `Telecommunication`.
    temp4-suppliername = `Robert Brown Entertainment`.
    temp4-price = `49.0`.
    temp4-currencycode = `CAD`.
    temp4-width = `0.19`.
    temp4-height = `0.05`.
    temp4-depth = `0.18`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Wireless DSL Router / Repeater`.
    temp4-productid = `HT-1116`.
    temp4-category = `Telecommunication`.
    temp4-suppliername = `Mexican Oil Trading Company`.
    temp4-price = `59.0`.
    temp4-currencycode = `MXN`.
    temp4-width = `0.19`.
    temp4-height = `0.05`.
    temp4-depth = `0.18`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Wireless DSL Router / Repeater and Print Server`.
    temp4-productid = `HT-1117`.
    temp4-category = `Telecommunication`.
    temp4-suppliername = `Meliva`.
    temp4-price = `69.0`.
    temp4-currencycode = `EUR`.
    temp4-width = `0.19`.
    temp4-height = `0.05`.
    temp4-depth = `0.18`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `USB Stick`.
    temp4-productid = `HT-1118`.
    temp4-category = `Computer system accessories`.
    temp4-suppliername = `Compostela`.
    temp4-price = `35.0`.
    temp4-currencycode = `ARS`.
    temp4-width = `0.02`.
    temp4-height = `0.01`.
    temp4-depth = `0.09`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Travel Adapter`.
    temp4-productid = `HT-1119`.
    temp4-category = `Computer system accessories`.
    temp4-suppliername = `Pear Computing Services`.
    temp4-price = `79.0`.
    temp4-currencycode = `USD`.
    temp4-width = `0.02`.
    temp4-height = `0.04`.
    temp4-depth = `0.03`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cordless Bluetooth Keyboard, english international`.
    temp4-productid = `HT-1120`.
    temp4-category = `Keyboards`.
    temp4-suppliername = `Pateu`.
    temp4-price = `29.0`.
    temp4-currencycode = `EUR`.
    temp4-width = `0.51`.
    temp4-height = `0.04`.
    temp4-depth = `0.23`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat XXL`.
    temp4-productid = `HT-1137`.
    temp4-category = `Flat screens`.
    temp4-suppliername = `Russian Electronic Trading Company`.
    temp4-price = `1430.0`.
    temp4-currencycode = `RUB`.
    temp4-width = `0.54`.
    temp4-height = `0.38`.
    temp4-depth = `0.22`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Pocket Mouse`.
    temp4-productid = `HT-1138`.
    temp4-category = `Mice`.
    temp4-suppliername = `Florida Holiday Company`.
    temp4-price = `23.0`.
    temp4-currencycode = `USD`.
    temp4-width = `0.0`.
    temp4-height = `0.01`.
    temp4-depth = `0.01`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `PC Power Station`.
    temp4-productid = `HT-1210`.
    temp4-category = `PCs`.
    temp4-suppliername = `Quimica Madrilenos`.
    temp4-price = `2399.0`.
    temp4-currencycode = `EUR`.
    temp4-width = `0.28`.
    temp4-height = `0.43`.
    temp4-depth = `0.31`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Server Basic`.
    temp4-productid = `HT-1500`.
    temp4-category = `Servers`.
    temp4-suppliername = `Getränkegroßhandel Janssen`.
    temp4-price = `5000.0`.
    temp4-currencycode = `EUR`.
    temp4-width = `0.34`.
    temp4-height = `0.23`.
    temp4-depth = `0.35`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Server Professional`.
    temp4-productid = `HT-1501`.
    temp4-category = `Servers`.
    temp4-suppliername = `JaTeCo`.
    temp4-price = `15000.0`.
    temp4-currencycode = `JPY`.
    temp4-width = `0.29`.
    temp4-height = `0.27`.
    temp4-depth = `0.3`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Server Power Pro`.
    temp4-productid = `HT-1502`.
    temp4-category = `Servers`.
    temp4-suppliername = `Tessile Casa Di Roma`.
    temp4-price = `25000.0`.
    temp4-currencycode = `EUR`.
    temp4-width = `0.22`.
    temp4-height = `0.37`.
    temp4-depth = `0.27`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Family PC Basic`.
    temp4-productid = `HT-1600`.
    temp4-category = `PCs`.
    temp4-suppliername = `Telecomunicaciones Star`.
    temp4-price = `600.0`.
    temp4-currencycode = `ARS`.
    temp4-width = `0.21`.
    temp4-height = `0.38`.
    temp4-depth = `0.29`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Family PC Pro`.
    temp4-productid = `HT-1601`.
    temp4-category = `PCs`.
    temp4-suppliername = `AVANTEL`.
    temp4-price = `900.0`.
    temp4-currencycode = `MXN`.
    temp4-width = `0.25`.
    temp4-height = `0.4`.
    temp4-depth = `0.32`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Gaming Monster`.
    temp4-productid = `HT-1602`.
    temp4-category = `PCs`.
    temp4-suppliername = `Laurent`.
    temp4-price = `1200.0`.
    temp4-currencycode = `EUR`.
    temp4-width = `0.27`.
    temp4-height = `0.47`.
    temp4-depth = `0.34`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Gaming Monster Pro`.
    temp4-productid = `HT-1603`.
    temp4-category = `PCs`.
    temp4-suppliername = `Asia High tech`.
    temp4-price = `1700.0`.
    temp4-currencycode = `JPY`.
    temp4-width = `0.27`.
    temp4-height = `0.42`.
    temp4-depth = `0.28`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `7" Widescreen Portable DVD Player w MP3`.
    temp4-productid = `HT-2000`.
    temp4-category = `Portable Players`.
    temp4-suppliername = `TECUM`.
    temp4-price = `249.99`.
    temp4-currencycode = `EUR`.
    temp4-width = `0.21`.
    temp4-height = `0.28`.
    temp4-depth = `0.19`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `10" Portable DVD player`.
    temp4-productid = `HT-2001`.
    temp4-category = `Portable Players`.
    temp4-suppliername = `Panorama Studios`.
    temp4-price = `449.99`.
    temp4-currencycode = `USD`.
    temp4-width = `0.24`.
    temp4-height = `0.29`.
    temp4-depth = `0.2`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Portable DVD Player with 9" LCD Monitor`.
    temp4-productid = `HT-2002`.
    temp4-category = `Portable Players`.
    temp4-suppliername = `Sorali`.
    temp4-price = `853.99`.
    temp4-currencycode = `EUR`.
    temp4-width = `0.21`.
    temp4-height = `0.14`.
    temp4-depth = `0.17`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `CD/DVD case: 264 sleeves`.
    temp4-productid = `HT-2025`.
    temp4-category = `Computer system accessories`.
    temp4-suppliername = `Talpa`.
    temp4-price = `44.99`.
    temp4-currencycode = `EUR`.
    temp4-width = `0.13`.
    temp4-height = `0.2`.
    temp4-depth = `0.13`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Audio/Video Cable Kit - 4m`.
    temp4-productid = `HT-2026`.
    temp4-category = `Computer system accessories`.
    temp4-suppliername = `DelBont Industries`.
    temp4-price = `29.99`.
    temp4-currencycode = `USD`.
    temp4-width = `0.21`.
    temp4-height = `0.13`.
    temp4-depth = `0.1`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Removable CD/DVD Laser Labels`.
    temp4-productid = `HT-2027`.
    temp4-category = `Computer system accessories`.
    temp4-suppliername = `Becker Berlin`.
    temp4-price = `8.99`.
    temp4-currencycode = `EUR`.
    temp4-width = `0.06`.
    temp4-height = `0.02`.
    temp4-depth = `0.02`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Beam Breaker B-1`.
    temp4-productid = `HT-6100`.
    temp4-category = `Beamers`.
    temp4-suppliername = `SAP`.
    temp4-price = `469.0`.
    temp4-currencycode = `EUR`.
    temp4-width = `0.3`.
    temp4-height = `0.23`.
    temp4-depth = `0.23`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Beam Breaker B-2`.
    temp4-productid = `HT-6101`.
    temp4-category = `Beamers`.
    temp4-suppliername = `Danish Fish Trading Company`.
    temp4-price = `679.0`.
    temp4-currencycode = `DKK`.
    temp4-width = `0.3`.
    temp4-height = `0.23`.
    temp4-depth = `0.23`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Beam Breaker B-3`.
    temp4-productid = `HT-6102`.
    temp4-category = `Beamers`.
    temp4-suppliername = `Siwusha`.
    temp4-price = `889.0`.
    temp4-currencycode = `CNY`.
    temp4-width = `0.3`.
    temp4-height = `0.23`.
    temp4-depth = `0.23`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Play Movie`.
    temp4-productid = `HT-6110`.
    temp4-category = `Portable Players`.
    temp4-suppliername = `South American IT Company`.
    temp4-price = `130.0`.
    temp4-currencycode = `ARS`.
    temp4-width = `0.37`.
    temp4-height = `0.06`.
    temp4-depth = `0.24`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Record Movie`.
    temp4-productid = `HT-6111`.
    temp4-category = `Portable Players`.
    temp4-suppliername = `Chemia A Technicznie Fabryka`.
    temp4-price = `288.0`.
    temp4-currencycode = `PLN`.
    temp4-width = `0.38`.
    temp4-height = `0.06`.
    temp4-depth = `0.26`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelo MusickStick`.
    temp4-productid = `HT-6120`.
    temp4-category = `MP3-Players`.
    temp4-suppliername = `Indian IT Trading Company`.
    temp4-price = `45.0`.
    temp4-currencycode = `INR`.
    temp4-width = `0.02`.
    temp4-height = `0.01`.
    temp4-depth = `0.06`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelo Jog-Mate`.
    temp4-productid = `HT-6121`.
    temp4-category = `MP3-Players`.
    temp4-suppliername = `Bionic Research Lab`.
    temp4-price = `63.0`.
    temp4-currencycode = `EUR`.
    temp4-width = `0.05`.
    temp4-height = `0.09`.
    temp4-depth = `0.08`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Power Pro Player 40`.
    temp4-productid = `HT-6122`.
    temp4-category = `MP3-Players`.
    temp4-suppliername = `PicoBit`.
    temp4-price = `167.0`.
    temp4-currencycode = `USD`.
    temp4-width = `0.05`.
    temp4-height = `0.09`.
    temp4-depth = `0.08`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Power Pro Player 80`.
    temp4-productid = `HT-6123`.
    temp4-category = `MP3-Players`.
    temp4-suppliername = `African Gold And Diamond Corporation`.
    temp4-price = `299.0`.
    temp4-currencycode = `ZAR`.
    temp4-width = `0.04`.
    temp4-height = `0.01`.
    temp4-depth = `0.06`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Watch HD32`.
    temp4-productid = `HT-6130`.
    temp4-category = `TV flat screens`.
    temp4-suppliername = `Vente Et Réparation de Ordinateur`.
    temp4-price = `1459.0`.
    temp4-currencycode = `EUR`.
    temp4-width = `0.78`.
    temp4-height = `0.55`.
    temp4-depth = `0.22`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Watch HD37`.
    temp4-productid = `HT-6131`.
    temp4-category = `TV flat screens`.
    temp4-suppliername = `Developement Para O Governo`.
    temp4-price = `1199.0`.
    temp4-currencycode = `ARS`.
    temp4-width = `0.99`.
    temp4-height = `0.61`.
    temp4-depth = `0.26`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Watch HD41`.
    temp4-productid = `HT-6132`.
    temp4-category = `TV flat screens`.
    temp4-suppliername = `Brazil Technologies`.
    temp4-price = `899.0`.
    temp4-currencycode = `BRL`.
    temp4-width = `1.28`.
    temp4-height = `0.79`.
    temp4-depth = `0.23`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Copperberry`.
    temp4-productid = `HT-7000`.
    temp4-category = `PDAs/Organizers`.
    temp4-suppliername = `Angeré`.
    temp4-price = `549.0`.
    temp4-currencycode = `EUR`.
    temp4-width = `0.08`.
    temp4-height = `0.12`.
    temp4-depth = `0.13`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Silverberry`.
    temp4-productid = `HT-7010`.
    temp4-category = `PDAs/Organizers`.
    temp4-suppliername = `Baleda`.
    temp4-price = `549.0`.
    temp4-currencycode = `USD`.
    temp4-width = `0.08`.
    temp4-height = `0.12`.
    temp4-depth = `0.13`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Goldberry`.
    temp4-productid = `HT-7020`.
    temp4-category = `PDAs/Organizers`.
    temp4-suppliername = `Jologa`.
    temp4-price = `549.0`.
    temp4-currencycode = `CHF`.
    temp4-width = `0.08`.
    temp4-height = `0.12`.
    temp4-depth = `0.13`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Platinberry`.
    temp4-productid = `HT-7030`.
    temp4-category = `PDAs/Organizers`.
    temp4-suppliername = `C.R.T.U.`.
    temp4-price = `549.0`.
    temp4-currencycode = `CAD`.
    temp4-width = `0.08`.
    temp4-height = `0.12`.
    temp4-depth = `0.13`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO FlexTop I4000`.
    temp4-productid = `HT-8000`.
    temp4-category = `Notebooks`.
    temp4-suppliername = `Alpine Systems`.
    temp4-price = `799.0`.
    temp4-currencycode = `EUR`.
    temp4-width = `0.31`.
    temp4-height = `0.03`.
    temp4-depth = `0.19`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO FlexTop I6300c`.
    temp4-productid = `HT-8001`.
    temp4-category = `Notebooks`.
    temp4-suppliername = `New Line Design`.
    temp4-price = `999.0`.
    temp4-currencycode = `GBP`.
    temp4-width = `0.32`.
    temp4-height = `0.03`.
    temp4-depth = `0.2`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO FlexTop I9100`.
    temp4-productid = `HT-8002`.
    temp4-category = `Notebooks`.
    temp4-suppliername = `HEPA Tec`.
    temp4-price = `1199.0`.
    temp4-currencycode = `EUR`.
    temp4-width = `0.38`.
    temp4-height = `0.04`.
    temp4-depth = `0.21`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO FlexTop I9800`.
    temp4-productid = `HT-8003`.
    temp4-category = `Notebooks`.
    temp4-suppliername = `Anav Ideon`.
    temp4-price = `1388.0`.
    temp4-currencycode = `USD`.
    temp4-width = `0.48`.
    temp4-height = `0.05`.
    temp4-depth = `0.31`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smartphone Leather Case`.
    temp4-productid = `HT-9991`.
    temp4-category = `Accessories`.
    temp4-suppliername = `JaTeCo`.
    temp4-price = `25.0`.
    temp4-currencycode = `JPY`.
    temp4-width = `0.48`.
    temp4-height = `0.05`.
    temp4-depth = `0.31`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smartphone Alpha`.
    temp4-productid = `HT-9992`.
    temp4-category = `Smartphones`.
    temp4-suppliername = `Getränkegroßhandel Janssen`.
    temp4-price = `599.0`.
    temp4-currencycode = `EUR`.
    temp4-width = `0.48`.
    temp4-height = `0.05`.
    temp4-depth = `0.31`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Mini Tablet`.
    temp4-productid = `HT-9993`.
    temp4-category = `Tablets`.
    temp4-suppliername = `Quimica Madrilenos`.
    temp4-price = `833.0`.
    temp4-currencycode = `EUR`.
    temp4-width = `0.48`.
    temp4-height = `0.05`.
    temp4-depth = `0.31`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Camcorder View`.
    temp4-productid = `HT-9994`.
    temp4-category = `Camcorders`.
    temp4-suppliername = `Florida Holiday Company`.
    temp4-price = `1388.0`.
    temp4-currencycode = `USD`.
    temp4-width = `0.48`.
    temp4-height = `0.27`.
    temp4-depth = `0.31`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smartphone Cover`.
    temp4-productid = `HT-9995`.
    temp4-category = `Accessories`.
    temp4-suppliername = `Russian Electronic Trading Company`.
    temp4-price = `15.0`.
    temp4-currencycode = `RUB`.
    temp4-width = `0.48`.
    temp4-height = `0.05`.
    temp4-depth = `0.31`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Tablet Pouch`.
    temp4-productid = `HT-9996`.
    temp4-category = `Accessories`.
    temp4-suppliername = `Pateu`.
    temp4-price = `20.0`.
    temp4-currencycode = `EUR`.
    temp4-width = `0.25`.
    temp4-height = `0.05`.
    temp4-depth = `0.4`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `e-Book Reader ReadMe`.
    temp4-productid = `HT-9997`.
    temp4-category = `Tablets`.
    temp4-suppliername = `Compostela`.
    temp4-price = `633.0`.
    temp4-currencycode = `ARS`.
    temp4-width = `0.48`.
    temp4-height = `0.05`.
    temp4-depth = `0.31`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smartphone Beta`.
    temp4-productid = `HT-9998`.
    temp4-category = `Smartphones`.
    temp4-suppliername = `Meliva`.
    temp4-price = `699.0`.
    temp4-currencycode = `EUR`.
    temp4-width = `0.48`.
    temp4-height = `0.05`.
    temp4-depth = `0.31`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Maxi Tablet`.
    temp4-productid = `HT-9999`.
    temp4-category = `Tablets`.
    temp4-suppliername = `Mexican Oil Trading Company`.
    temp4-price = `749.0`.
    temp4-currencycode = `MXN`.
    temp4-width = `0.48`.
    temp4-height = `0.05`.
    temp4-depth = `0.31`.
    temp4-dimunit = `M`.
    INSERT temp4 INTO TABLE temp3.
    t_products = temp3.

  ENDMETHOD.

ENDCLASS.
