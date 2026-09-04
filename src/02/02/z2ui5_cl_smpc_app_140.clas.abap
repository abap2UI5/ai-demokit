" @keywords blocklayout block layout sap.ui.layout backgrounds html vbox hbox label select item blocklayoutrow
" @summary Block Layout in which all cells use the same background color set and different color shade.
CLASS z2ui5_cl_smpc_app_140 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA colorset TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_140 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      colorset = `ColorSet5`.
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:f`    v = `sap.ui.layout.form`
        )->a( n = `xmlns`      v = `sap.m`


        " the sample's own resources/sample.css - the view carries
        " customCellImageBackground and the rule behind it has to come with it.
        " Its background-image is relative in the original; absolutized to the
        " OpenUI5 host per the asset-URL rule. \{ \} escaped: the XMLView parser
        " reads an unescaped brace as a binding
        )->tag( n = `HTML` ns = `core`
            )->a( n = `content` v = `<style>.customCellImageBackground\{color:#fff;` &&
                                    `background-image:url("https://sdk.openui5.org/test-resources/sap/ui/layout/demokit/sample/BlockLayoutCustomBackground/resources/Night_sky.jpg");` &&
                                    `background-size:100% auto;background-position:0 80%\}` &&
                                    `.customCellImageBackground .sapUiBlockCellContent,` &&
                                    `.customCellImageBackground .sapUiBlockCellContent .sapMText\{color:#fff\}</style>`
        )->ele( `VBox`
            )->ele( `HBox`
                )->a( n = `alignItems` v = `Center`
                )->a( n = `class`      v = `sapUiContentPadding`
                )->tag( `Label`
                    )->a( n = `text`      v = `Color set for all cells`
                    )->a( n = `showColon` v = `true`
                    )->a( n = `class`     v = `sapUiTinyMarginEnd`
                )->ele( `Select`
                    )->a( n = `selectedKey` v = client->_bind( colorset )
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `ColorSet1`
                        )->a( n = `text` v = `ColorSet1`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `ColorSet2`
                        )->a( n = `text` v = `ColorSet2`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `ColorSet3`
                        )->a( n = `text` v = `ColorSet3`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `ColorSet4`
                        )->a( n = `text` v = `ColorSet4`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `ColorSet5`
                        )->a( n = `text` v = `ColorSet5`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `ColorSet6`
                        )->a( n = `text` v = `ColorSet6`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `ColorSet7`
                        )->a( n = `text` v = `ColorSet7`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `ColorSet8`
                        )->a( n = `text` v = `ColorSet8`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `ColorSet9`
                        )->a( n = `text` v = `ColorSet9`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `ColorSet10`
                        )->a( n = `text` v = `ColorSet10`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `ColorSet11`
                        )->a( n = `text` v = `ColorSet11 (transparent in SAP Horizon theme)`

                )->end(
            )->end(

            )->ele( n = `BlockLayout` ns = `l`
                )->a( n = `id` v = `blockLayout`

                )->ele( n = `BlockLayoutRow` ns = `l`
                    )->ele( n = `BlockLayoutCell` ns = `l`
                        )->a( n = `title`                v = `Cells with Custom Color (Shade A)`
                        )->a( n = `backgroundColorSet`   v = client->_bind( colorset )
                        )->a( n = `backgroundColorShade` v = `ShadeA`

                    )->end(
                )->end(

                )->ele( n = `BlockLayoutRow` ns = `l`
                    )->ele( n = `BlockLayoutCell` ns = `l`
                        )->a( n = `title`          v = `The Title`
                        )->a( n = `titleAlignment` v = `Center`
                        )->a( n = `class`          v = `customCellImageBackground`
                        )->tag( `Text`
                            )->a( n = `text` v = `Donec bibendum diam nibh, sit amet ornare ante fermentum sed. Ut vulputate justo at orci sollicitudin.`

                    )->end(
                    )->ele( n = `BlockLayoutCell` ns = `l`
                        )->a( n = `title`                v = `An Icon (Shade B)`
                        )->a( n = `backgroundColorSet`   v = client->_bind( colorset )
                        )->a( n = `backgroundColorShade` v = `ShadeB`
                        )->tag( n = `Icon` ns = `core`
                            )->a( n = `src` v = `sap-icon://add-activity`

                    )->end(
                )->end(

                )->ele( n = `BlockLayoutRow` ns = `l`
                    )->ele( n = `BlockLayoutCell` ns = `l`
                        )->a( n = `title`                v = `Simple Form (Shade C)`
                        )->a( n = `backgroundColorSet`   v = client->_bind( colorset )
                        )->a( n = `backgroundColorShade` v = `ShadeC`
                        )->ele( n = `SimpleForm` ns = `f`
                            )->a( n = `editable`         v = `true`
                            )->a( n = `backgroundDesign` v = `Transparent`
                            )->a( n = `layout`           v = `ResponsiveGridLayout`
                            )->tag( `Label`
                                )->a( n = `text` v = `sap.m.Input`
                            )->tag( `Input`
                                )->a( n = `type`        v = `Text`
                                )->a( n = `placeholder` v = `Enter Name ...`
                            )->tag( `Label`
                                )->a( n = `text` v = `sap.m.TextArea`
                            )->tag( `TextArea`
                                )->a( n = `placeholder` v = `Please add your comment...`
                                )->a( n = `rows`        v = `6`
                                )->a( n = `maxLength`   v = `255`
                                )->a( n = `width`       v = `100%`
                            )->tag( `Label`
                                )->a( n = `text` v = `sap.m.Text`
                            )->tag( `Text`
                                )->a( n = `text` v = `Donec bibendum diam nibh, sit amet ornare ante fermentum sed. Ut vulputate justo at orci sollicitudin, in gravida lectus aliquam. Vivamus tortor lorem, semper et diam ac, ` &&
                                             `faucibus suscipit metus. Curabitur eget aliquet purus, id vestibulum sapien. Cras vitae imperdiet felis. Fusce placerat velit orci, at tempor nisl aliquam laoreet. ` &&
                                             `Aliquam in sapien sit amet tortor laoreet feugiat id in ligula.`

                        )->end(
                    )->end(
                )->end(

                )->ele( n = `BlockLayoutRow` ns = `l`
                    )->ele( n = `BlockLayoutCell` ns = `l`
                        )->a( n = `title`                v = `Right Aligned Title (Shade D)`
                        )->a( n = `titleAlignment`       v = `Right`
                        )->a( n = `backgroundColorSet`   v = client->_bind( colorset )
                        )->a( n = `backgroundColorShade` v = `ShadeD`
                        )->tag( `Text`
                            )->a( n = `text` v = `Morbi id ullamcorper lorem, vestibulum facilisis velit. Ut elementum aliquam nisl a pretium. Donec auctor mattis convallis. Aenean sodales tortor nec facilisis fringilla. ` &&
                                             `Nam feugiat nulla at diam sollicitudin pretium. Sed at lacus volutpat, finibus arcu ultricies, convallis elit. Aliquam sollicitudin tortor sit amet mi consequat ` &&
                                             `fringilla. Fusce nisl leo, tempor et nulla id, pellentesque suscipit augue. Morbi cursus molestie tellus. Ut volutpat orci interdum, condimentum risus sed, iaculis ` &&
                                             `tellus. Proin nisi eros, tristique nec tortor quis, suscipit sodales dui.`

                    )->end(
                )->end(

                )->ele( n = `BlockLayoutRow` ns = `l`
                    )->ele( n = `BlockLayoutCell` ns = `l`
                        )->a( n = `title`                v = `Left Aligned Title (Shade E - Only Available for SAP Quartz and Horizon Themes)`
                        )->a( n = `titleAlignment`       v = `Left`
                        )->a( n = `backgroundColorSet`   v = client->_bind( colorset )
                        )->a( n = `backgroundColorShade` v = `ShadeE`
                        )->tag( `Text`
                            )->a( n = `text` v = `Morbi id ullamcorper lorem, vestibulum facilisis velit. Ut elementum aliquam nisl a pretium. Donec auctor mattis convallis. Aenean sodales tortor nec facilisis fringilla. ` &&
                                             `Nam feugiat nulla at diam sollicitudin pretium. Sed at lacus volutpat, finibus arcu ultricies, convallis elit. Aliquam sollicitudin tortor sit amet mi consequat ` &&
                                             `fringilla. Fusce nisl leo, tempor et nulla id, pellentesque suscipit augue. Morbi cursus molestie tellus. Ut volutpat orci interdum, condimentum risus sed, iaculis ` &&
                                             `tellus. Proin nisi eros, tristique nec tortor quis, suscipit sodales dui.`

                    )->end(
                )->end(

                )->ele( n = `BlockLayoutRow` ns = `l`
                    )->ele( n = `BlockLayoutCell` ns = `l`
                        )->a( n = `title`                v = `Default Aligned Title (Shade F - Only Available for SAP Quartz and Horizon Themes)`
                        )->a( n = `backgroundColorSet`   v = client->_bind( colorset )
                        )->a( n = `backgroundColorShade` v = `ShadeF`
                        )->tag( `Text`
                            )->a( n = `text` v = `Morbi id ullamcorper lorem, vestibulum facilisis velit. Ut elementum aliquam nisl a pretium. Donec auctor mattis convallis. Aenean sodales tortor nec facilisis fringilla. ` &&
                                             `Nam feugiat nulla at diam sollicitudin pretium. Sed at lacus volutpat, finibus arcu ultricies, convallis elit. Aliquam sollicitudin tortor sit amet mi consequat ` &&
                                             `fringilla. Fusce nisl leo, tempor et nulla id, pellentesque suscipit augue. Morbi cursus molestie tellus. Ut volutpat orci interdum, condimentum risus sed, iaculis ` &&
                                             `tellus. Proin nisi eros, tristique nec tortor quis, suscipit sodales dui.` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
