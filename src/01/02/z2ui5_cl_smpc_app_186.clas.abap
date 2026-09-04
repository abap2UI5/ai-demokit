" @keywords responsivesplitter responsive splitter sap.ui.layout panecontainer splitpane splitterlayoutdata panel text list standardlistitem vbox
" @summary ResponsiveSplitter is used to visually divide the content of its parent. It consists of PaneContainers that further agregate other PaneContainers and SplitPanes.
CLASS z2ui5_cl_smpc_app_186 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_product,
        productid TYPE string,
        name      TYPE string,
        quantity  TYPE i,
      END OF ty_product.
    DATA productcollection TYPE STANDARD TABLE OF ty_product WITH DEFAULT KEY.

    " The original keeps the three pane sizes in a separate 'sizes' JSON model
    " ({sizes>/pane1..3}); with abap2UI5's single default model they live flat
    " here and the SplitterLayoutData.size / the Text labels bind them directly.
    DATA pane1 TYPE string.
    DATA pane2 TYPE string.
    DATA pane3 TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_186 IMPLEMENTATION.

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
    DATA temp1 TYPE string_table.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp3 TYPE string_table.
    DATA temp4 LIKE LINE OF temp3.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " sap.ui.layout.ResponsiveSplitter. The original binds the pane sizes from a
    " separate 'sizes' JSON model ({sizes>/paneN}) and the product list/select
    " from the default model ({/ProductCollection}); abap2UI5 has one default
    " model, so the sizes are folded into it (the 'sizes>' prefix is dropped -
    " last path segment identical, which structural-diff matches). The two
    " PaneContainer 'resize' handlers show an informational MessageToast of the
    " old/new pane sizes. Reproduced roundtrip-free since 2026-08-05: an event
    " arg is a full UI5 expression and .join( ',' ) over an ARRAY parameter
    " resolves (measured with scripts/probes/event-arg-expression-probe.mjs),
    " so both size arrays travel into the client-composed toast 1:1.
    
    CLEAR temp1.
    INSERT `MESSAGE_TOAST` INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    
    temp2 = `Root container is resized.{0}` && |\n| && `New panes sizes = [{1}]`.
    INSERT temp2 INTO TABLE temp1.
    INSERT `${$parameters>/oldSizes} && ${$parameters>/oldSizes}.length ? '\nOld panes sizes = [' + ${$parameters>/oldSizes}.join(',') + ']' : ''` INTO TABLE temp1.
    INSERT `${$parameters>/newSizes} ? ${$parameters>/newSizes}.join(',') : ''` INTO TABLE temp1.
    
    CLEAR temp3.
    INSERT `MESSAGE_TOAST` INTO TABLE temp3.
    INSERT `show` INTO TABLE temp3.
    
    temp4 = `Inner container is resized.{0}` && |\n| && `New panes sizes = [{1}]`.
    INSERT temp4 INTO TABLE temp3.
    INSERT `${$parameters>/oldSizes} && ${$parameters>/oldSizes}.length ? '\nOld panes sizes = [' + ${$parameters>/oldSizes}.join(',') + ']' : ''` INTO TABLE temp3.
    INSERT `${$parameters>/newSizes} ? ${$parameters>/newSizes}.join(',') : ''` INTO TABLE temp3.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `height`     v = `100%`

        )->ele( n = `ResponsiveSplitter` ns = `l`
            )->a( n = `defaultPane` v = `default`

            )->ele( n = `PaneContainer` ns = `l`
                )->a( n = `resize` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                 t_arg = temp1 )

                )->ele( n = `SplitPane` ns = `l`
                    )->a( n = `requiredParentWidth` v = `400`
                    )->a( n = `id`                  v = `default`

                    )->ele( n = `layoutData` ns = `l`
                        )->tag( n = `SplitterLayoutData` ns = `l`
                            )->a( n = `size` v = client->_bind( pane1 )

                    )->end(

                    )->ele( `Panel`
                        )->a( n = `headerText` v = `Minimum parent width 400`
                        )->a( n = `height`     v = `100%`

                        )->tag( `Text`
                            )->a( n = `text` v = |LayoutData.size={ client->_bind( pane1 ) }|

                        )->ele( `List`
                            )->a( n = `headerText` v = `Products`
                            )->a( n = `items`      v = client->_bind( productcollection )

                            )->tag( `StandardListItem`
                                )->a( n = `title`   v = `{NAME}`
                                )->a( n = `counter` v = `{QUANTITY}`

                        )->end(
                    )->end(
                )->end(

                )->ele( n = `PaneContainer` ns = `l`
                    )->a( n = `orientation` v = `Vertical`
                    )->a( n = `resize`      v = client->follow_up_action( val   = client->cs_event-control_global
                                                                          t_arg = temp3 )

                    )->ele( n = `SplitPane` ns = `l`
                        )->a( n = `requiredParentWidth` v = `600`

                        )->ele( n = `layoutData` ns = `l`
                            )->tag( n = `SplitterLayoutData` ns = `l`
                                )->a( n = `size` v = client->_bind( pane2 )

                        )->end(

                        )->ele( `Panel`
                            )->a( n = `headerText` v = `Minimum parent width 600`

                            )->ele( `VBox`
                                )->tag( `Text`
                                    )->a( n = `text` v = |LayoutData.size={ client->_bind( pane2 ) }|

                                )->ele( `Select`
                                    )->a( n = `forceSelection` v = `false`
                                    )->a( n = `selectedKey`    v = `1239102`
                                    )->a( n = `items`          v = |\{ path: '{ client->_bind_path( productcollection ) }', sorter: \{ path: 'NAME' \} \}|

                                    )->tag( n = `Item` ns = `core`
                                        )->a( n = `key`  v = `{PRODUCTID}`
                                        )->a( n = `text` v = `{NAME}`

                                )->end(
                            )->end(
                        )->end(
                    )->end(

                    )->ele( n = `SplitPane` ns = `l`
                        )->a( n = `requiredParentWidth` v = `800`

                        )->ele( n = `layoutData` ns = `l`
                            )->tag( n = `SplitterLayoutData` ns = `l`
                                )->a( n = `size` v = client->_bind( pane3 )

                        )->end(

                        )->ele( `Page`
                            )->a( n = `title` v = `Minimum parent width 800`

                            )->tag( `Text`
                                )->a( n = `text` v = |LayoutData.size={ client->_bind( pane3 ) }|

                            )->ele( `footer`
                                )->ele( `OverflowToolbar`
                                    )->a( n = `id` v = `otb3`

                                    )->tag( `Label`
                                        )->a( n = `text` v = `Buttons:`
                                    )->tag( `ToolbarSpacer`
                                    )->tag( `Button`
                                        )->a( n = `text` v = `New`
                                        )->a( n = `type` v = `Transparent`
                                    )->tag( `Button`
                                        )->a( n = `text` v = `Open`
                                        )->a( n = `type` v = `Transparent`
                                    )->tag( `Button`
                                        )->a( n = `text` v = `Save`
                                        )->a( n = `type` v = `Transparent`
                                    )->tag( `Button`
                                        )->a( n = `text` v = `Save as`
                                        )->a( n = `type` v = `Transparent`
                                    )->tag( `Button`
                                        )->a( n = `text` v = `Cut`
                                        )->a( n = `type` v = `Transparent`
                                    )->tag( `Button`
                                        )->a( n = `text` v = `Copy`
                                        )->a( n = `type` v = `Transparent`
                                    )->tag( `Button`
                                        )->a( n = `text` v = `Paste`
                                        )->a( n = `type` v = `Transparent`
                                    )->tag( `Button`
                                        )->a( n = `text` v = `Undo`
                                        )->a( n = `type` v = `Transparent` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.
    DATA temp3 LIKE productcollection.
    DATA temp4 LIKE LINE OF temp3.

    " the original pane sizes model starts every pane at 'auto'
    pane1 = `auto`.
    pane2 = `auto`.
    pane3 = `auto`.

    " the shared 123-row demo ProductCollection (sap/ui/demo/mock/products.json),
    " inlined with the three columns the sample binds (ProductId, Name, Quantity)
    
    CLEAR temp3.
    
    temp4-productid = `HT-1000`.
    temp4-name = `Notebook Basic 15`.
    temp4-quantity = 10.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1001`.
    temp4-name = `Notebook Basic 17`.
    temp4-quantity = 20.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1002`.
    temp4-name = `Notebook Basic 18`.
    temp4-quantity = 10.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1003`.
    temp4-name = `Notebook Basic 19`.
    temp4-quantity = 15.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1007`.
    temp4-name = `ITelO Vault`.
    temp4-quantity = 15.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1010`.
    temp4-name = `Notebook Professional 15`.
    temp4-quantity = 16.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1011`.
    temp4-name = `Notebook Professional 17`.
    temp4-quantity = 17.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1020`.
    temp4-name = `ITelO Vault Net`.
    temp4-quantity = 14.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1021`.
    temp4-name = `ITelO Vault SAT`.
    temp4-quantity = 50.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1022`.
    temp4-name = `Comfort Easy`.
    temp4-quantity = 30.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1023`.
    temp4-name = `Comfort Senior`.
    temp4-quantity = 24.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1030`.
    temp4-name = `Ergo Screen E-I`.
    temp4-quantity = 14.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1031`.
    temp4-name = `Ergo Screen E-II`.
    temp4-quantity = 24.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1032`.
    temp4-name = `Ergo Screen E-III`.
    temp4-quantity = 50.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1035`.
    temp4-name = `Flat Basic`.
    temp4-quantity = 23.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1036`.
    temp4-name = `Flat Future`.
    temp4-quantity = 22.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1037`.
    temp4-name = `Flat XL`.
    temp4-quantity = 23.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1040`.
    temp4-name = `Laser Professional Eco`.
    temp4-quantity = 21.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1041`.
    temp4-name = `Laser Basic`.
    temp4-quantity = 8.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1042`.
    temp4-name = `Laser Allround`.
    temp4-quantity = 9.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1050`.
    temp4-name = `Ultra Jet Super Color`.
    temp4-quantity = 17.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1051`.
    temp4-name = `Ultra Jet Mobile`.
    temp4-quantity = 18.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1052`.
    temp4-name = `Ultra Jet Super Highspeed`.
    temp4-quantity = 25.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1055`.
    temp4-name = `Multi Print`.
    temp4-quantity = 16.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1056`.
    temp4-name = `Multi Color`.
    temp4-quantity = 5.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1060`.
    temp4-name = `Cordless Mouse`.
    temp4-quantity = 25.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1061`.
    temp4-name = `Speed Mouse`.
    temp4-quantity = 12.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1062`.
    temp4-name = `Track Mouse`.
    temp4-quantity = 12.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1063`.
    temp4-name = `Ergonomic Keyboard`.
    temp4-quantity = 50.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1064`.
    temp4-name = `Internet Keyboard`.
    temp4-quantity = 35.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1065`.
    temp4-name = `Media Keyboard`.
    temp4-quantity = 26.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1066`.
    temp4-name = `Mousepad`.
    temp4-quantity = 12.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1067`.
    temp4-name = `Ergo Mousepad`.
    temp4-quantity = 16.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1068`.
    temp4-name = `Designer Mousepad`.
    temp4-quantity = 26.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1069`.
    temp4-name = `Universal card reader`.
    temp4-quantity = 22.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1070`.
    temp4-name = `Proctra X`.
    temp4-quantity = 15.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1071`.
    temp4-name = `Gladiator MX`.
    temp4-quantity = 16.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1072`.
    temp4-name = `Hurricane GX`.
    temp4-quantity = 13.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1073`.
    temp4-name = `Hurricane GX/LN`.
    temp4-quantity = 5.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1080`.
    temp4-name = `Photo Scan`.
    temp4-quantity = 8.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1081`.
    temp4-name = `Power Scan`.
    temp4-quantity = 11.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1082`.
    temp4-name = `Jet Scan Professional`.
    temp4-quantity = 13.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1083`.
    temp4-name = `Jet Scan Professional`.
    temp4-quantity = 10.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1085`.
    temp4-name = `Copymaster`.
    temp4-quantity = 10.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1090`.
    temp4-name = `Surround Sound`.
    temp4-quantity = 20.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1091`.
    temp4-name = `Blaster Extreme`.
    temp4-quantity = 15.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1092`.
    temp4-name = `Sound Booster`.
    temp4-quantity = 50.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1095`.
    temp4-name = `Lovely Sound 5.1 Wireless`.
    temp4-quantity = 12.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1096`.
    temp4-name = `Lovely Sound 5.1`.
    temp4-quantity = 18.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1097`.
    temp4-name = `Lovely Sound Stereo`.
    temp4-quantity = 21.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1100`.
    temp4-name = `Smart Office`.
    temp4-quantity = 25.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1101`.
    temp4-name = `Smart Design`.
    temp4-quantity = 26.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1102`.
    temp4-name = `Smart Network`.
    temp4-quantity = 28.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1103`.
    temp4-name = `Smart Multimedia`.
    temp4-quantity = 9.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1104`.
    temp4-name = `Smart Games`.
    temp4-quantity = 13.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1105`.
    temp4-name = `Smart Internet Antivirus`.
    temp4-quantity = 17.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1106`.
    temp4-name = `Smart Firewall`.
    temp4-quantity = 19.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1107`.
    temp4-name = `Smart Money`.
    temp4-quantity = 18.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1110`.
    temp4-name = `PC Lock`.
    temp4-quantity = 14.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1111`.
    temp4-name = `Notebook Lock`.
    temp4-quantity = 20.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1112`.
    temp4-name = `Web cam reality`.
    temp4-quantity = 27.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1113`.
    temp4-name = `Screen clean`.
    temp4-quantity = 17.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1114`.
    temp4-name = `Fabric bag professional`.
    temp4-quantity = 14.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1115`.
    temp4-name = `Wireless DSL Router`.
    temp4-quantity = 16.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1116`.
    temp4-name = `Wireless DSL Router / Repeater`.
    temp4-quantity = 12.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1117`.
    temp4-name = `Wireless DSL Router / Repeater and Print Server`.
    temp4-quantity = 12.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1118`.
    temp4-name = `USB Stick`.
    temp4-quantity = 14.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1119`.
    temp4-name = `Travel Adapter`.
    temp4-quantity = 10.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1120`.
    temp4-name = `Cordless Bluetooth Keyboard, english international`.
    temp4-quantity = 13.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1137`.
    temp4-name = `Flat XXL`.
    temp4-quantity = 10.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1138`.
    temp4-name = `Pocket Mouse`.
    temp4-quantity = 20.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1210`.
    temp4-name = `PC Power Station`.
    temp4-quantity = 22.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1251`.
    temp4-name = `Astro Laptop 1516`.
    temp4-quantity = 23.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1252`.
    temp4-name = `Astro Phone 6`.
    temp4-quantity = 28.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1253`.
    temp4-name = `Benda Laptop 1408`.
    temp4-quantity = 27.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1254`.
    temp4-name = `Bending Screen 21HD`.
    temp4-quantity = 23.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1255`.
    temp4-name = `Broad Screen 22HD`.
    temp4-quantity = 5.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1256`.
    temp4-name = `Cerdik Phone 7`.
    temp4-quantity = 19.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1257`.
    temp4-name = `Cepat Tablet 10.5`.
    temp4-quantity = 17.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1258`.
    temp4-name = `Cepat Tablet 8`.
    temp4-quantity = 24.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1500`.
    temp4-name = `Server Basic`.
    temp4-quantity = 24.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1501`.
    temp4-name = `Server Professional`.
    temp4-quantity = 26.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1502`.
    temp4-name = `Server Power Pro`.
    temp4-quantity = 34.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1600`.
    temp4-name = `Family PC Basic`.
    temp4-quantity = 10.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1601`.
    temp4-name = `Family PC Pro`.
    temp4-quantity = 20.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1602`.
    temp4-name = `Gaming Monster`.
    temp4-quantity = 24.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1603`.
    temp4-name = `Gaming Monster Pro`.
    temp4-quantity = 25.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-2000`.
    temp4-name = `7" Widescreen Portable DVD Player w MP3`.
    temp4-quantity = 20.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-2001`.
    temp4-name = `10" Portable DVD player`.
    temp4-quantity = 21.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-2002`.
    temp4-name = `Portable DVD Player with 9" LCD Monitor`.
    temp4-quantity = 50.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-2025`.
    temp4-name = `CD/DVD case: 264 sleeves`.
    temp4-quantity = 26.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-2026`.
    temp4-name = `Audio/Video Cable Kit - 4m`.
    temp4-quantity = 16.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-2027`.
    temp4-name = `Removable CD/DVD Laser Labels`.
    temp4-quantity = 25.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-6100`.
    temp4-name = `Beam Breaker B-1`.
    temp4-quantity = 32.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-6101`.
    temp4-name = `Beam Breaker B-2`.
    temp4-quantity = 18.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-6102`.
    temp4-name = `Beam Breaker B-3`.
    temp4-quantity = 16.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-6110`.
    temp4-name = `Play Movie`.
    temp4-quantity = 15.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-6111`.
    temp4-name = `Record Movie`.
    temp4-quantity = 24.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-6120`.
    temp4-name = `ITelo MusicStick`.
    temp4-quantity = 15.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-6121`.
    temp4-name = `ITelo Jog-Mate`.
    temp4-quantity = 24.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-6122`.
    temp4-name = `Power Pro Player 40`.
    temp4-quantity = 23.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-6123`.
    temp4-name = `Power Pro Player 80`.
    temp4-quantity = 13.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-6130`.
    temp4-name = `Flat Watch HD32`.
    temp4-quantity = 16.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-6131`.
    temp4-name = `Flat Watch HD37`.
    temp4-quantity = 14.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-6132`.
    temp4-name = `Flat Watch HD41`.
    temp4-quantity = 13.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-7000`.
    temp4-name = `Copperberry`.
    temp4-quantity = 5.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-7010`.
    temp4-name = `Silverberry`.
    temp4-quantity = 9.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-7020`.
    temp4-name = `Goldberry`.
    temp4-quantity = 11.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-7030`.
    temp4-name = `Platinberry`.
    temp4-quantity = 12.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-8000`.
    temp4-name = `ITelO FlexTop I4000`.
    temp4-quantity = 11.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-8001`.
    temp4-name = `ITelO FlexTop I6300c`.
    temp4-quantity = 20.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-8002`.
    temp4-name = `ITelO FlexTop I9100`.
    temp4-quantity = 20.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-8003`.
    temp4-name = `ITelO FlexTop I9800`.
    temp4-quantity = 22.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-9991`.
    temp4-name = `Smartphone Leather Case`.
    temp4-quantity = 12.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-9992`.
    temp4-name = `Smartphone Alpha`.
    temp4-quantity = 13.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-9993`.
    temp4-name = `Mini Tablet`.
    temp4-quantity = 10.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-9994`.
    temp4-name = `Camcorder View`.
    temp4-quantity = 50.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-9995`.
    temp4-name = `Tablet Pouch`.
    temp4-quantity = 34.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-9996`.
    temp4-name = `Tablet Pouch`.
    temp4-quantity = 34.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-9997`.
    temp4-name = `e-Book Reader ReadMe`.
    temp4-quantity = 23.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-9998`.
    temp4-name = `Smartphone Beta`.
    temp4-quantity = 21.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-9999`.
    temp4-name = `Maxi Tablet`.
    temp4-quantity = 20.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `PF-1000`.
    temp4-name = `Flyer`.
    temp4-quantity = 33.
    INSERT temp4 INTO TABLE temp3.
    productcollection = temp3.

  ENDMETHOD.

ENDCLASS.
