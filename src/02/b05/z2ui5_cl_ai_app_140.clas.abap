CLASS z2ui5_cl_ai_app_140 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA colorset TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_140 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      colorset = `ColorSet5`.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:f`    v = `sap.ui.layout.form`
        )->a( n = `xmlns`      v = `sap.m`

        )->open( `VBox`
            )->open( `HBox`
                )->a( n = `alignItems` v = `Center`
                )->a( n = `class`      v = `sapUiContentPadding`
                )->leaf( `Label`
                    )->a( n = `text`      v = `Color set for all cells`
                    )->a( n = `showColon` v = `true`
                    )->a( n = `class`     v = `sapUiTinyMarginEnd`
                )->open( `Select`
                    )->a( n = `selectedKey` v = client->_bind( colorset )
                    )->leaf( n = `Item` ns = `core`
                        )->a( n = `key`  v = `ColorSet1`
                        )->a( n = `text` v = `ColorSet1`
                    )->leaf( n = `Item` ns = `core`
                        )->a( n = `key`  v = `ColorSet2`
                        )->a( n = `text` v = `ColorSet2`
                    )->leaf( n = `Item` ns = `core`
                        )->a( n = `key`  v = `ColorSet3`
                        )->a( n = `text` v = `ColorSet3`
                    )->leaf( n = `Item` ns = `core`
                        )->a( n = `key`  v = `ColorSet4`
                        )->a( n = `text` v = `ColorSet4`
                    )->leaf( n = `Item` ns = `core`
                        )->a( n = `key`  v = `ColorSet5`
                        )->a( n = `text` v = `ColorSet5`
                    )->leaf( n = `Item` ns = `core`
                        )->a( n = `key`  v = `ColorSet6`
                        )->a( n = `text` v = `ColorSet6`
                    )->leaf( n = `Item` ns = `core`
                        )->a( n = `key`  v = `ColorSet7`
                        )->a( n = `text` v = `ColorSet7`
                    )->leaf( n = `Item` ns = `core`
                        )->a( n = `key`  v = `ColorSet8`
                        )->a( n = `text` v = `ColorSet8`
                    )->leaf( n = `Item` ns = `core`
                        )->a( n = `key`  v = `ColorSet9`
                        )->a( n = `text` v = `ColorSet9`
                    )->leaf( n = `Item` ns = `core`
                        )->a( n = `key`  v = `ColorSet10`
                        )->a( n = `text` v = `ColorSet10`
                    )->leaf( n = `Item` ns = `core`
                        )->a( n = `key`  v = `ColorSet11`
                        )->a( n = `text` v = `ColorSet11 (transparent in SAP Horizon theme)`

                )->shut(
            )->shut(

            )->open( n = `BlockLayout` ns = `l`
                )->a( n = `id` v = `blockLayout`

                )->open( n = `BlockLayoutRow` ns = `l`
                    )->open( n = `BlockLayoutCell` ns = `l`
                        )->a( n = `title`             v = `Cells with Custom Color (Shade A)`
                        )->a( n = `backgroundColorSet`v = client->_bind( colorset )
                        )->a( n = `backgroundColorShade`v = `ShadeA`

                )->shut(
                )->shut(

                )->open( n = `BlockLayoutRow` ns = `l`
                    )->open( n = `BlockLayoutCell` ns = `l`
                        )->a( n = `title`             v = `The Title`
                        )->a( n = `titleAlignment`    v = `Center`
                        )->a( n = `class`             v = `customCellImageBackground`
                        )->leaf( `Text`
                        )->a( n = `text` v = `Donec bibendum diam nibh, sit amet ornare ante fermentum sed. Ut vulputate justo at orci sollicitudin.`

                )->shut(
                    )->open( n = `BlockLayoutCell` ns = `l`
                        )->a( n = `title`             v = `An Icon (Shade B)`
                        )->a( n = `backgroundColorSet`v = client->_bind( colorset )
                        )->a( n = `backgroundColorShade`v = `ShadeB`
                    )->leaf( n = `Icon` ns = `core`
                        )->a( n = `src` v = `sap-icon://add-activity`

                )->shut(
                )->shut(

                )->open( n = `BlockLayoutRow` ns = `l`
                    )->open( n = `BlockLayoutCell` ns = `l`
                        )->a( n = `title`             v = `Simple Form (Shade C)`
                        )->a( n = `backgroundColorSet`v = client->_bind( colorset )
                        )->a( n = `backgroundColorShade`v = `ShadeC`
                    )->open( n = `SimpleForm` ns = `f`
                        )->a( n = `editable`         v = `true`
                        )->a( n = `backgroundDesign` v = `Transparent`
                        )->a( n = `layout`           v = `ResponsiveGridLayout`
                        )->leaf( `Label`
                            )->a( n = `text` v = `sap.m.Input`
                        )->leaf( `Input`
                            )->a( n = `type`        v = `Text`
                            )->a( n = `placeholder` v = `Enter Name ...`
                        )->leaf( `Label`
                            )->a( n = `text` v = `sap.m.TextArea`
                        )->leaf( `TextArea`
                            )->a( n = `placeholder` v = `Please add your comment...`
                            )->a( n = `rows`        v = `6`
                            )->a( n = `maxLength`   v = `255`
                            )->a( n = `width`       v = `100%`
                        )->leaf( `Label`
                            )->a( n = `text` v = `sap.m.Text`
                        )->leaf( `Text`
                        )->a( n = `text` v = `Donec bibendum diam nibh, sit amet ornare ante fermentum sed. Ut vulputate justo at orci sollicitudin, in gravida lectus aliquam. Vivamus tortor lorem, semper et diam ac, ` &&
                                             `faucibus suscipit metus. Curabitur eget aliquet purus, id vestibulum sapien. Cras vitae imperdiet felis. Fusce placerat velit orci, at tempor nisl aliquam laoreet. ` &&
                                             `Aliquam in sapien sit amet tortor laoreet feugiat id in ligula.`

                    )->shut(
                )->shut(
                )->shut(

                )->open( n = `BlockLayoutRow` ns = `l`
                    )->open( n = `BlockLayoutCell` ns = `l`
                        )->a( n = `title`             v = `Right Aligned Title (Shade D)`
                        )->a( n = `titleAlignment`    v = `Right`
                        )->a( n = `backgroundColorSet`v = client->_bind( colorset )
                        )->a( n = `backgroundColorShade`v = `ShadeD`
                        )->leaf( `Text`
                        )->a( n = `text` v = `Morbi id ullamcorper lorem, vestibulum facilisis velit. Ut elementum aliquam nisl a pretium. Donec auctor mattis convallis. Aenean sodales tortor nec facilisis fringilla. ` &&
                                             `Nam feugiat nulla at diam sollicitudin pretium. Sed at lacus volutpat, finibus arcu ultricies, convallis elit. Aliquam sollicitudin tortor sit amet mi consequat ` &&
                                             `fringilla. Fusce nisl leo, tempor et nulla id, pellentesque suscipit augue. Morbi cursus molestie tellus. Ut volutpat orci interdum, condimentum risus sed, iaculis ` &&
                                             `tellus. Proin nisi eros, tristique nec tortor quis, suscipit sodales dui.`

                )->shut(
                )->shut(

                )->open( n = `BlockLayoutRow` ns = `l`
                    )->open( n = `BlockLayoutCell` ns = `l`
                        )->a( n = `title`             v = `Left Aligned Title (Shade E - Only Available for SAP Quartz and Horizon Themes)`
                        )->a( n = `titleAlignment`    v = `Left`
                        )->a( n = `backgroundColorSet`v = client->_bind( colorset )
                        )->a( n = `backgroundColorShade`v = `ShadeE`
                        )->leaf( `Text`
                        )->a( n = `text` v = `Morbi id ullamcorper lorem, vestibulum facilisis velit. Ut elementum aliquam nisl a pretium. Donec auctor mattis convallis. Aenean sodales tortor nec facilisis fringilla. ` &&
                                             `Nam feugiat nulla at diam sollicitudin pretium. Sed at lacus volutpat, finibus arcu ultricies, convallis elit. Aliquam sollicitudin tortor sit amet mi consequat ` &&
                                             `fringilla. Fusce nisl leo, tempor et nulla id, pellentesque suscipit augue. Morbi cursus molestie tellus. Ut volutpat orci interdum, condimentum risus sed, iaculis ` &&
                                             `tellus. Proin nisi eros, tristique nec tortor quis, suscipit sodales dui.`

                )->shut(
                )->shut(

                )->open( n = `BlockLayoutRow` ns = `l`
                    )->open( n = `BlockLayoutCell` ns = `l`
                        )->a( n = `title`             v = `Default Aligned Title (Shade F - Only Available for SAP Quartz and Horizon Themes)`
                        )->a( n = `backgroundColorSet`v = client->_bind( colorset )
                        )->a( n = `backgroundColorShade`v = `ShadeF`
                        )->leaf( `Text`
                        )->a( n = `text` v = `Morbi id ullamcorper lorem, vestibulum facilisis velit. Ut elementum aliquam nisl a pretium. Donec auctor mattis convallis. Aenean sodales tortor nec facilisis fringilla. ` &&
                                             `Nam feugiat nulla at diam sollicitudin pretium. Sed at lacus volutpat, finibus arcu ultricies, convallis elit. Aliquam sollicitudin tortor sit amet mi consequat ` &&
                                             `fringilla. Fusce nisl leo, tempor et nulla id, pellentesque suscipit augue. Morbi cursus molestie tellus. Ut volutpat orci interdum, condimentum risus sed, iaculis ` &&
                                             `tellus. Proin nisi eros, tristique nec tortor quis, suscipit sodales dui.` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
