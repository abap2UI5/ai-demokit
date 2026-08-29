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
    DATA t_products       TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

    " the original's `ui>` model: the three selection modes and the picked one
    DATA t_selectionmodes TYPE STANDARD TABLE OF ty_s_mode WITH EMPTY KEY.
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
      DATA(lv_pasted) = client->get_event_arg( ).
      REPLACE ALL OCCURRENCES OF `"` IN lv_pasted WITH ``.
      REPLACE ALL OCCURRENCES OF `[` IN lv_pasted WITH ``.
      REPLACE ALL OCCURRENCES OF `]` IN lv_pasted WITH ``.
      client->message_toast_display( |Pasted Data (on Table Level):\n\n{ lv_pasted }| ).
    ENDIF.


  ENDMETHOD.


  METHOD model_init.

    " the `ui>` model the controller sets: three selection modes, MultiToggle
    " preselected
    t_selectionmodes = VALUE #( ( mode = `MultiToggle` ) ( mode = `Single` ) ( mode = `None` ) ).
    selection_mode   = `MultiToggle`.

    " the OData ProductSet the sample serves from a MockServer, inlined with
    " the columns the six table columns bind - all 115 rows of ProductSet.json
    t_products = VALUE #(
      ( name = `Flyer` productid = `AD-1000` category = `Computer system accessories` suppliername = `Robert Brown Entertainment` price = `0.0` currencycode = `CAD` width = `0.46` height = `0.03` depth = `0.3` dimunit = `M` )
      ( name = `Notebook Basic 15` productid = `HT-1000` category = `Notebooks` suppliername = `SAP` price = `956.0` currencycode = `EUR` width = `0.3` height = `0.03` depth = `0.18` dimunit = `M` )
      ( name = `Notebook Basic 17` productid = `HT-1001` category = `Notebooks` suppliername = `Becker Berlin` price = `1249.0` currencycode = `EUR` width = `0.29` height = `0.03` depth = `0.17` dimunit = `M` )
      ( name = `Notebook Basic 18` productid = `HT-1002` category = `Notebooks` suppliername = `DelBont Industries` price = `1570.0` currencycode = `USD` width = `0.28` height = `0.03` depth = `0.19` dimunit = `M` )
      ( name = `Notebook Basic 19` productid = `HT-1003` category = `Notebooks` suppliername = `Talpa` price = `1650.0` currencycode = `EUR` width = `0.32` height = `0.04` depth = `0.21` dimunit = `M` )
      ( name = `ITelO Vault` productid = `HT-1007` category = `PDAs/Organizers` suppliername = `Panorama Studios` price = `299.0` currencycode = `USD` width = `0.32` height = `0.03` depth = `0.22` dimunit = `M` )
      ( name = `Notebook Professional 15` productid = `HT-1010` category = `Notebooks` suppliername = `TECUM` price = `1999.0` currencycode = `EUR` width = `0.33` height = `0.03` depth = `0.2` dimunit = `M` )
      ( name = `Notebook Professional 17` productid = `HT-1011` category = `Notebooks` suppliername = `Asia High tech` price = `2299.0` currencycode = `JPY` width = `0.33` height = `0.02` depth = `0.23` dimunit = `M` )
      ( name = `ITelO Vault Net` productid = `HT-1020` category = `PDAs/Organizers` suppliername = `Laurent` price = `459.0` currencycode = `EUR` width = `0.1` height = `0.17` depth = `0.02` dimunit = `M` )
      ( name = `ITelO Vault SAT` productid = `HT-1021` category = `PDAs/Organizers` suppliername = `AVANTEL` price = `149.0` currencycode = `MXN` width = `0.11` height = `0.18` depth = `0.02` dimunit = `M` )
      ( name = `Comfort Easy` productid = `HT-1022` category = `PDAs/Organizers` suppliername = `Telecomunicaciones Star` price = `1679.0` currencycode = `ARS` width = `0.84` height = `0.14` depth = `0.02` dimunit = `M` )
      ( name = `Comfort Senior` productid = `HT-1023` category = `PDAs/Organizers` suppliername = `Pear Computing Services` price = `512.0` currencycode = `USD` width = `0.8` height = `0.13` depth = `0.02` dimunit = `M` )
      ( name = `Ergo Screen E-I` productid = `HT-1030` category = `Flat screens` suppliername = `Alpine Systems` price = `230.0` currencycode = `EUR` width = `0.37` height = `0.36` depth = `0.12` dimunit = `M` )
      ( name = `Ergo Screen E-II` productid = `HT-1031` category = `Flat screens` suppliername = `New Line Design` price = `285.0` currencycode = `GBP` width = `0.41` height = `0.43` depth = `0.19` dimunit = `M` )
      ( name = `Ergo Screen E-III` productid = `HT-1032` category = `Flat screens` suppliername = `HEPA Tec` price = `345.0` currencycode = `EUR` width = `0.41` height = `0.43` depth = `0.19` dimunit = `M` )
      ( name = `Flat Basic` productid = `HT-1035` category = `Flat screens` suppliername = `Anav Ideon` price = `399.0` currencycode = `USD` width = `0.39` height = `0.41` depth = `0.2` dimunit = `M` )
      ( name = `Flat Future` productid = `HT-1036` category = `Flat screens` suppliername = `Robert Brown Entertainment` price = `430.0` currencycode = `CAD` width = `0.45` height = `0.46` depth = `0.26` dimunit = `M` )
      ( name = `Flat XL` productid = `HT-1037` category = `Flat screens` suppliername = `Mexican Oil Trading Company` price = `1230.0` currencycode = `MXN` width = `0.55` height = `0.39` depth = `0.22` dimunit = `M` )
      ( name = `Laser Professional Eco` productid = `HT-1040` category = `Laser printers` suppliername = `Meliva` price = `830.0` currencycode = `EUR` width = `0.51` height = `0.3` depth = `0.46` dimunit = `M` )
      ( name = `Laser Basic` productid = `HT-1041` category = `Laser printers` suppliername = `Compostela` price = `490.0` currencycode = `ARS` width = `0.48` height = `0.26` depth = `0.42` dimunit = `M` )
      ( name = `Laser Allround` productid = `HT-1042` category = `Laser printers` suppliername = `Pateu` price = `349.0` currencycode = `EUR` width = `0.53` height = `0.65` depth = `0.5` dimunit = `M` )
      ( name = `Ultra Jet Super Color` productid = `HT-1050` category = `Ink jet printers` suppliername = `Russian Electronic Trading Company` price = `139.0` currencycode = `RUB` width = `0.41` height = `0.28` depth = `0.41` dimunit = `M` )
      ( name = `Ultra Jet Mobile` productid = `HT-1051` category = `Ink jet printers` suppliername = `Florida Holiday Company` price = `99.0` currencycode = `USD` width = `0.46` height = `0.25` depth = `0.32` dimunit = `M` )
      ( name = `Ultra Jet Super Highspeed` productid = `HT-1052` category = `Ink jet printers` suppliername = `Quimica Madrilenos` price = `170.0` currencycode = `EUR` width = `0.41` height = `0.28` depth = `0.41` dimunit = `M` )
      ( name = `Multi Print` productid = `HT-1055` category = `Multifunction printers` suppliername = `Getränkegroßhandel Janssen` price = `99.0` currencycode = `EUR` width = `0.55` height = `0.29` depth = `0.45` dimunit = `M` )
      ( name = `Multi Color` productid = `HT-1056` category = `Multifunction printers` suppliername = `JaTeCo` price = `119.0` currencycode = `JPY` width = `0.51` height = `0.22` depth = `0.41` dimunit = `M` )
      ( name = `Cordless Mouse` productid = `HT-1060` category = `Mice` suppliername = `Tessile Casa Di Roma` price = `9.0` currencycode = `EUR` width = `0.06` height = `0.04` depth = `0.15` dimunit = `M` )
      ( name = `Speed Mouse` productid = `HT-1061` category = `Mice` suppliername = `Vente Et Réparation de Ordinateur` price = `7.0` currencycode = `EUR` width = `0.07` height = `0.03` depth = `0.15` dimunit = `M` )
      ( name = `Track Mouse` productid = `HT-1062` category = `Mice` suppliername = `Developement Para O Governo` price = `11.0` currencycode = `ARS` width = `0.0` height = `0.04` depth = `0.01` dimunit = `M` )
      ( name = `Ergonomic Keyboard` productid = `HT-1063` category = `Keyboards` suppliername = `Brazil Technologies` price = `14.0` currencycode = `BRL` width = `0.5` height = `0.04` depth = `0.21` dimunit = `M` )
      ( name = `Internet Keyboard` productid = `HT-1064` category = `Keyboards` suppliername = `C.R.T.U.` price = `16.0` currencycode = `CAD` width = `0.52` height = `0.03` depth = `0.25` dimunit = `M` )
      ( name = `Media Keyboard` productid = `HT-1065` category = `Keyboards` suppliername = `Jologa` price = `26.0` currencycode = `CHF` width = `0.51` height = `0.04` depth = `0.23` dimunit = `M` )
      ( name = `Mousepad` productid = `HT-1066` category = `Mousepads` suppliername = `Baleda` price = `6.99` currencycode = `USD` width = `0.15` height = `0.0` depth = `0.06` dimunit = `M` )
      ( name = `Ergo Mousepad` productid = `HT-1067` category = `Mousepads` suppliername = `Angeré` price = `8.99` currencycode = `EUR` width = `0.15` height = `0.0` depth = `0.06` dimunit = `M` )
      ( name = `Designer Mousepad` productid = `HT-1068` category = `Mousepads` suppliername = `PC Gym Tec` price = `12.99` currencycode = `USD` width = `0.24` height = `0.01` depth = `0.24` dimunit = `M` )
      ( name = `Universal card reader` productid = `HT-1069` category = `Computer system accessories` suppliername = `Japan Insurance Partner` price = `14.0` currencycode = `JPY` width = `0.01` height = `0.0` depth = `0.01` dimunit = `M` )
      ( name = `Proctra X` productid = `HT-1070` category = `Graphic cards` suppliername = `Entertainment Argentinia` price = `70.9` currencycode = `ARS` width = `0.22` height = `0.17` depth = `0.35` dimunit = `M` )
      ( name = `Gladiator MX` productid = `HT-1071` category = `Graphic cards` suppliername = `African Gold And Diamond Corporation` price = `81.7` currencycode = `ZAR` width = `0.22` height = `0.17` depth = `0.35` dimunit = `M` )
      ( name = `Hurricane GX` productid = `HT-1072` category = `Graphic cards` suppliername = `PicoBit` price = `101.2` currencycode = `USD` width = `0.22` height = `0.17` depth = `0.35` dimunit = `M` )
      ( name = `Hurricane GX/LN` productid = `HT-1073` category = `Graphic cards` suppliername = `Bionic Research Lab` price = `139.99` currencycode = `EUR` width = `0.22` height = `0.17` depth = `0.35` dimunit = `M` )
      ( name = `Photo Scan` productid = `HT-1080` category = `Scanners` suppliername = `Indian IT Trading Company` price = `129.0` currencycode = `INR` width = `0.34` height = `0.05` depth = `0.48` dimunit = `M` )
      ( name = `Power Scan` productid = `HT-1081` category = `Scanners` suppliername = `Chemia A Technicznie Fabryka` price = `89.0` currencycode = `PLN` width = `0.31` height = `0.07` depth = `0.43` dimunit = `M` )
      ( name = `Jet Scan Professional` productid = `HT-1082` category = `Scanners` suppliername = `South American IT Company` price = `169.0` currencycode = `ARS` width = `0.33` height = `0.12` depth = `0.41` dimunit = `M` )
      ( name = `Jet Scan Professional` productid = `HT-1083` category = `Scanners` suppliername = `Siwusha` price = `189.0` currencycode = `CNY` width = `0.35` height = `0.1` depth = `0.4` dimunit = `M` )
      ( name = `Copymaster` productid = `HT-1085` category = `Multifunction printers` suppliername = `Danish Fish Trading Company` price = `1499.0` currencycode = `DKK` width = `0.45` height = `0.22` depth = `0.42` dimunit = `M` )
      ( name = `Surround Sound` productid = `HT-1090` category = `Speakers` suppliername = `Sorali` price = `39.0` currencycode = `EUR` width = `0.12` height = `0.16` depth = `0.1` dimunit = `M` )
      ( name = `Blaster Extreme` productid = `HT-1091` category = `Speakers` suppliername = `SAP` price = `26.0` currencycode = `EUR` width = `0.13` height = `0.18` depth = `0.11` dimunit = `M` )
      ( name = `Sound Booster` productid = `HT-1092` category = `Speakers` suppliername = `Becker Berlin` price = `45.0` currencycode = `EUR` width = `0.12` height = `0.18` depth = `0.1` dimunit = `M` )
      ( name = `Lovely Sound 5.1 Wireless` productid = `HT-1095` category = `Headsets` suppliername = `PC Gym Tec` price = `49.0` currencycode = `USD` width = `0.24` height = `0.23` depth = `0.02` dimunit = `M` )
      ( name = `Lovely Sound 5.1` productid = `HT-1096` category = `Headsets` suppliername = `Japan Insurance Partner` price = `39.0` currencycode = `JPY` width = `0.25` height = `0.19` depth = `0.02` dimunit = `M` )
      ( name = `Lovely Sound Stereo` productid = `HT-1097` category = `Headsets` suppliername = `Entertainment Argentinia` price = `29.0` currencycode = `ARS` width = `0.21` height = `0.2` depth = `0.02` dimunit = `M` )
      ( name = `Smart Office` productid = `HT-1100` category = `Software` suppliername = `DelBont Industries` price = `89.9` currencycode = `USD` width = `0.15` height = `0.21` depth = `0.07` dimunit = `M` )
      ( name = `Smart Design` productid = `HT-1101` category = `Software` suppliername = `Talpa` price = `79.9` currencycode = `EUR` width = `0.14` height = `0.24` depth = `0.07` dimunit = `M` )
      ( name = `Smart Network` productid = `HT-1102` category = `Software` suppliername = `Panorama Studios` price = `69.0` currencycode = `USD` width = `0.16` height = `0.27` depth = `0.06` dimunit = `M` )
      ( name = `Smart Multimedia` productid = `HT-1103` category = `Software` suppliername = `TECUM` price = `77.0` currencycode = `EUR` width = `0.11` height = `0.22` depth = `0.03` dimunit = `M` )
      ( name = `Smart Games` productid = `HT-1104` category = `Software` suppliername = `Asia High tech` price = `55.0` currencycode = `JPY` width = `0.1` height = `0.3` depth = `0.03` dimunit = `M` )
      ( name = `Smart Internet Antivirus` productid = `HT-1105` category = `Software` suppliername = `Laurent` price = `29.0` currencycode = `EUR` width = `0.16` height = `0.21` depth = `0.04` dimunit = `M` )
      ( name = `Smart Firewall` productid = `HT-1106` category = `Software` suppliername = `AVANTEL` price = `34.0` currencycode = `MXN` width = `0.18` height = `0.23` depth = `0.04` dimunit = `M` )
      ( name = `Smart Money` productid = `HT-1107` category = `Software` suppliername = `Telecomunicaciones Star` price = `29.9` currencycode = `ARS` width = `0.12` height = `0.19` depth = `0.02` dimunit = `M` )
      ( name = `PC Lock` productid = `HT-1110` category = `Computer system accessories` suppliername = `Pear Computing Services` price = `8.9` currencycode = `USD` width = `0.2` height = `0.04` depth = `0.08` dimunit = `M` )
      ( name = `Notebook Lock` productid = `HT-1111` category = `Computer system accessories` suppliername = `Alpine Systems` price = `6.9` currencycode = `EUR` width = `0.31` height = `0.07` depth = `0.09` dimunit = `M` )
      ( name = `Web cam reality` productid = `HT-1112` category = `Computer system accessories` suppliername = `New Line Design` price = `39.0` currencycode = `GBP` width = `0.09` height = `0.01` depth = `0.08` dimunit = `M` )
      ( name = `Screen clean` productid = `HT-1113` category = `Computer system accessories` suppliername = `HEPA Tec` price = `2.3` currencycode = `EUR` width = `0.02` height = `0.0` depth = `0.02` dimunit = `M` )
      ( name = `Fabric bag professional` productid = `HT-1114` category = `Computer system accessories` suppliername = `Anav Ideon` price = `31.0` currencycode = `USD` width = `0.42` height = `0.07` depth = `0.32` dimunit = `M` )
      ( name = `Wireless DSL Router` productid = `HT-1115` category = `Telecommunication` suppliername = `Robert Brown Entertainment` price = `49.0` currencycode = `CAD` width = `0.19` height = `0.05` depth = `0.18` dimunit = `M` )
      ( name = `Wireless DSL Router / Repeater` productid = `HT-1116` category = `Telecommunication` suppliername = `Mexican Oil Trading Company` price = `59.0` currencycode = `MXN` width = `0.19` height = `0.05` depth = `0.18` dimunit = `M` )
      ( name = `Wireless DSL Router / Repeater and Print Server` productid = `HT-1117` category = `Telecommunication` suppliername = `Meliva` price = `69.0` currencycode = `EUR` width = `0.19` height = `0.05` depth = `0.18` dimunit = `M` )
      ( name = `USB Stick` productid = `HT-1118` category = `Computer system accessories` suppliername = `Compostela` price = `35.0` currencycode = `ARS` width = `0.02` height = `0.01` depth = `0.09` dimunit = `M` )
      ( name = `Travel Adapter` productid = `HT-1119` category = `Computer system accessories` suppliername = `Pear Computing Services` price = `79.0` currencycode = `USD` width = `0.02` height = `0.04` depth = `0.03` dimunit = `M` )
      ( name = `Cordless Bluetooth Keyboard, english international` productid = `HT-1120` category = `Keyboards` suppliername = `Pateu` price = `29.0` currencycode = `EUR` width = `0.51` height = `0.04` depth = `0.23` dimunit = `M` )
      ( name = `Flat XXL` productid = `HT-1137` category = `Flat screens` suppliername = `Russian Electronic Trading Company` price = `1430.0` currencycode = `RUB` width = `0.54` height = `0.38` depth = `0.22` dimunit = `M` )
      ( name = `Pocket Mouse` productid = `HT-1138` category = `Mice` suppliername = `Florida Holiday Company` price = `23.0` currencycode = `USD` width = `0.0` height = `0.01` depth = `0.01` dimunit = `M` )
      ( name = `PC Power Station` productid = `HT-1210` category = `PCs` suppliername = `Quimica Madrilenos` price = `2399.0` currencycode = `EUR` width = `0.28` height = `0.43` depth = `0.31` dimunit = `M` )
      ( name = `Server Basic` productid = `HT-1500` category = `Servers` suppliername = `Getränkegroßhandel Janssen` price = `5000.0` currencycode = `EUR` width = `0.34` height = `0.23` depth = `0.35` dimunit = `M` )
      ( name = `Server Professional` productid = `HT-1501` category = `Servers` suppliername = `JaTeCo` price = `15000.0` currencycode = `JPY` width = `0.29` height = `0.27` depth = `0.3` dimunit = `M` )
      ( name = `Server Power Pro` productid = `HT-1502` category = `Servers` suppliername = `Tessile Casa Di Roma` price = `25000.0` currencycode = `EUR` width = `0.22` height = `0.37` depth = `0.27` dimunit = `M` )
      ( name = `Family PC Basic` productid = `HT-1600` category = `PCs` suppliername = `Telecomunicaciones Star` price = `600.0` currencycode = `ARS` width = `0.21` height = `0.38` depth = `0.29` dimunit = `M` )
      ( name = `Family PC Pro` productid = `HT-1601` category = `PCs` suppliername = `AVANTEL` price = `900.0` currencycode = `MXN` width = `0.25` height = `0.4` depth = `0.32` dimunit = `M` )
      ( name = `Gaming Monster` productid = `HT-1602` category = `PCs` suppliername = `Laurent` price = `1200.0` currencycode = `EUR` width = `0.27` height = `0.47` depth = `0.34` dimunit = `M` )
      ( name = `Gaming Monster Pro` productid = `HT-1603` category = `PCs` suppliername = `Asia High tech` price = `1700.0` currencycode = `JPY` width = `0.27` height = `0.42` depth = `0.28` dimunit = `M` )
      ( name = `7" Widescreen Portable DVD Player w MP3` productid = `HT-2000` category = `Portable Players` suppliername = `TECUM` price = `249.99` currencycode = `EUR` width = `0.21` height = `0.28` depth = `0.19` dimunit = `M` )
      ( name = `10" Portable DVD player` productid = `HT-2001` category = `Portable Players` suppliername = `Panorama Studios` price = `449.99` currencycode = `USD` width = `0.24` height = `0.29` depth = `0.2` dimunit = `M` )
      ( name = `Portable DVD Player with 9" LCD Monitor` productid = `HT-2002` category = `Portable Players` suppliername = `Sorali` price = `853.99` currencycode = `EUR` width = `0.21` height = `0.14` depth = `0.17` dimunit = `M` )
      ( name = `CD/DVD case: 264 sleeves` productid = `HT-2025` category = `Computer system accessories` suppliername = `Talpa` price = `44.99` currencycode = `EUR` width = `0.13` height = `0.2` depth = `0.13` dimunit = `M` )
      ( name = `Audio/Video Cable Kit - 4m` productid = `HT-2026` category = `Computer system accessories` suppliername = `DelBont Industries` price = `29.99` currencycode = `USD` width = `0.21` height = `0.13` depth = `0.1` dimunit = `M` )
      ( name = `Removable CD/DVD Laser Labels` productid = `HT-2027` category = `Computer system accessories` suppliername = `Becker Berlin` price = `8.99` currencycode = `EUR` width = `0.06` height = `0.02` depth = `0.02` dimunit = `M` )
      ( name = `Beam Breaker B-1` productid = `HT-6100` category = `Beamers` suppliername = `SAP` price = `469.0` currencycode = `EUR` width = `0.3` height = `0.23` depth = `0.23` dimunit = `M` )
      ( name = `Beam Breaker B-2` productid = `HT-6101` category = `Beamers` suppliername = `Danish Fish Trading Company` price = `679.0` currencycode = `DKK` width = `0.3` height = `0.23` depth = `0.23` dimunit = `M` )
      ( name = `Beam Breaker B-3` productid = `HT-6102` category = `Beamers` suppliername = `Siwusha` price = `889.0` currencycode = `CNY` width = `0.3` height = `0.23` depth = `0.23` dimunit = `M` )
      ( name = `Play Movie` productid = `HT-6110` category = `Portable Players` suppliername = `South American IT Company` price = `130.0` currencycode = `ARS` width = `0.37` height = `0.06` depth = `0.24` dimunit = `M` )
      ( name = `Record Movie` productid = `HT-6111` category = `Portable Players` suppliername = `Chemia A Technicznie Fabryka` price = `288.0` currencycode = `PLN` width = `0.38` height = `0.06` depth = `0.26` dimunit = `M` )
      ( name = `ITelo MusickStick` productid = `HT-6120` category = `MP3-Players` suppliername = `Indian IT Trading Company` price = `45.0` currencycode = `INR` width = `0.02` height = `0.01` depth = `0.06` dimunit = `M` )
      ( name = `ITelo Jog-Mate` productid = `HT-6121` category = `MP3-Players` suppliername = `Bionic Research Lab` price = `63.0` currencycode = `EUR` width = `0.05` height = `0.09` depth = `0.08` dimunit = `M` )
      ( name = `Power Pro Player 40` productid = `HT-6122` category = `MP3-Players` suppliername = `PicoBit` price = `167.0` currencycode = `USD` width = `0.05` height = `0.09` depth = `0.08` dimunit = `M` )
      ( name = `Power Pro Player 80` productid = `HT-6123` category = `MP3-Players` suppliername = `African Gold And Diamond Corporation` price = `299.0` currencycode = `ZAR` width = `0.04` height = `0.01` depth = `0.06` dimunit = `M` )
      ( name = `Flat Watch HD32` productid = `HT-6130` category = `TV flat screens` suppliername = `Vente Et Réparation de Ordinateur` price = `1459.0` currencycode = `EUR` width = `0.78` height = `0.55` depth = `0.22` dimunit = `M` )
      ( name = `Flat Watch HD37` productid = `HT-6131` category = `TV flat screens` suppliername = `Developement Para O Governo` price = `1199.0` currencycode = `ARS` width = `0.99` height = `0.61` depth = `0.26` dimunit = `M` )
      ( name = `Flat Watch HD41` productid = `HT-6132` category = `TV flat screens` suppliername = `Brazil Technologies` price = `899.0` currencycode = `BRL` width = `1.28` height = `0.79` depth = `0.23` dimunit = `M` )
      ( name = `Copperberry` productid = `HT-7000` category = `PDAs/Organizers` suppliername = `Angeré` price = `549.0` currencycode = `EUR` width = `0.08` height = `0.12` depth = `0.13` dimunit = `M` )
      ( name = `Silverberry` productid = `HT-7010` category = `PDAs/Organizers` suppliername = `Baleda` price = `549.0` currencycode = `USD` width = `0.08` height = `0.12` depth = `0.13` dimunit = `M` )
      ( name = `Goldberry` productid = `HT-7020` category = `PDAs/Organizers` suppliername = `Jologa` price = `549.0` currencycode = `CHF` width = `0.08` height = `0.12` depth = `0.13` dimunit = `M` )
      ( name = `Platinberry` productid = `HT-7030` category = `PDAs/Organizers` suppliername = `C.R.T.U.` price = `549.0` currencycode = `CAD` width = `0.08` height = `0.12` depth = `0.13` dimunit = `M` )
      ( name = `ITelO FlexTop I4000` productid = `HT-8000` category = `Notebooks` suppliername = `Alpine Systems` price = `799.0` currencycode = `EUR` width = `0.31` height = `0.03` depth = `0.19` dimunit = `M` )
      ( name = `ITelO FlexTop I6300c` productid = `HT-8001` category = `Notebooks` suppliername = `New Line Design` price = `999.0` currencycode = `GBP` width = `0.32` height = `0.03` depth = `0.2` dimunit = `M` )
      ( name = `ITelO FlexTop I9100` productid = `HT-8002` category = `Notebooks` suppliername = `HEPA Tec` price = `1199.0` currencycode = `EUR` width = `0.38` height = `0.04` depth = `0.21` dimunit = `M` )
      ( name = `ITelO FlexTop I9800` productid = `HT-8003` category = `Notebooks` suppliername = `Anav Ideon` price = `1388.0` currencycode = `USD` width = `0.48` height = `0.05` depth = `0.31` dimunit = `M` )
      ( name = `Smartphone Leather Case` productid = `HT-9991` category = `Accessories` suppliername = `JaTeCo` price = `25.0` currencycode = `JPY` width = `0.48` height = `0.05` depth = `0.31` dimunit = `M` )
      ( name = `Smartphone Alpha` productid = `HT-9992` category = `Smartphones` suppliername = `Getränkegroßhandel Janssen` price = `599.0` currencycode = `EUR` width = `0.48` height = `0.05` depth = `0.31` dimunit = `M` )
      ( name = `Mini Tablet` productid = `HT-9993` category = `Tablets` suppliername = `Quimica Madrilenos` price = `833.0` currencycode = `EUR` width = `0.48` height = `0.05` depth = `0.31` dimunit = `M` )
      ( name = `Camcorder View` productid = `HT-9994` category = `Camcorders` suppliername = `Florida Holiday Company` price = `1388.0` currencycode = `USD` width = `0.48` height = `0.27` depth = `0.31` dimunit = `M` )
      ( name = `Smartphone Cover` productid = `HT-9995` category = `Accessories` suppliername = `Russian Electronic Trading Company` price = `15.0` currencycode = `RUB` width = `0.48` height = `0.05` depth = `0.31` dimunit = `M` )
      ( name = `Tablet Pouch` productid = `HT-9996` category = `Accessories` suppliername = `Pateu` price = `20.0` currencycode = `EUR` width = `0.25` height = `0.05` depth = `0.4` dimunit = `M` )
      ( name = `e-Book Reader ReadMe` productid = `HT-9997` category = `Tablets` suppliername = `Compostela` price = `633.0` currencycode = `ARS` width = `0.48` height = `0.05` depth = `0.31` dimunit = `M` )
      ( name = `Smartphone Beta` productid = `HT-9998` category = `Smartphones` suppliername = `Meliva` price = `699.0` currencycode = `EUR` width = `0.48` height = `0.05` depth = `0.31` dimunit = `M` )
      ( name = `Maxi Tablet` productid = `HT-9999` category = `Tablets` suppliername = `Mexican Oil Trading Company` price = `749.0` currencycode = `MXN` width = `0.48` height = `0.05` depth = `0.31` dimunit = `M` )
      ).

  ENDMETHOD.

ENDCLASS.
