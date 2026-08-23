" @keywords blocklayout block layout sap.ui.layout blocklayoutcustombackgroundpercell html blocklayoutrow blocklayoutcell vbox label select item
" @summary Block Layout in which all cells use different background color set and different shade.
CLASS z2ui5_cl_smpc_app_343 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    " the controller's _modelData: one record per cell, each bound as the
    " cell's own context (binding="{/cellN}") so the two Selects inside the
    " cell write straight into it
    TYPES:
      BEGIN OF ty_s_cell,
        colorset   TYPE string,
        colorshade TYPE string,
      END OF ty_s_cell.
    DATA cell1 TYPE ty_s_cell.
    DATA cell2 TYPE ty_s_cell.
    DATA cell3 TYPE ty_s_cell.
    DATA cell4 TYPE ty_s_cell.
    DATA cell5 TYPE ty_s_cell.
    DATA cell6 TYPE ty_s_cell.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_343 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " the sample's six BlockLayoutRows. Each cell carries its OWN context
    " (binding="{/cellN}") and the ColorSelect fragment is inlined into every
    " one of them - abap2UI5 serves one view, so a core:Fragment reference has
    " no file to resolve; the relative {COLORSET}/{COLORSHADE} bindings then
    " resolve against the cell's context exactly like in the original.
    " resources/sample.css is injected through a core:HTML <style> (CSS braces
    " escaped \{ \} so the XMLView parser does not read them as bindings).
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:f`    v = `sap.ui.layout.form`

        )->tag( n = `HTML` ns = `core`
            )->a( n = `content` v = `<style>.customCellImageBackground\{color:#fff;` &&
                                    `background-image:url("https://sdk.openui5.org/test-resources/sap/ui/layout/demokit/sample/BlockLayoutCustomBackgroundPerCell/resources/Night_sky.jpg");` &&
                                    `background-size:100% auto;background-position:0 80%\}` &&
                                    `.customCellImageBackground .sapUiBlockCellContent,` &&
                                    `.customCellImageBackground .sapUiBlockCellContent .sapMText\{color:#fff\}</style>`

        )->ele( n = `BlockLayout` ns = `l`
            )->a( n = `id` v = `blockLayout`

            )->ele( n = `BlockLayoutRow` ns = `l`
                )->ele( n = `BlockLayoutCell` ns = `l`
                    )->a( n = `id`                   v = `cell-1`
                    )->a( n = `binding`              v = |\{{ client->_bind( val = cell1 path = abap_true ) }\}|
                    )->a( n = `title`                v = `Select Cells' Custom Color`
                    )->a( n = `backgroundColorSet`   v = `{COLORSET}`
                    )->a( n = `backgroundColorShade` v = `{COLORSHADE}`

                    )->ele( `VBox`
                        )->tag( `Label`
                            )->a( n = `text` v = `Cell Color Set`
                        )->ele( `Select`
                            )->a( n = `selectedKey` v = `{COLORSET}`

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
                        )->tag( `Label`
                            )->a( n = `text` v = `Cell Color Shade`
                        )->ele( `Select`
                            )->a( n = `selectedKey` v = `{COLORSHADE}`

                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `ShadeA`
                                )->a( n = `text` v = `ShadeA`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `ShadeB`
                                )->a( n = `text` v = `ShadeB`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `ShadeC`
                                )->a( n = `text` v = `ShadeC`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `ShadeD`
                                )->a( n = `text` v = `ShadeD`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `ShadeE`
                                )->a( n = `text` v = `ShadeE (only available for SAP Quartz and Horizon themes)`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `ShadeF`
                                )->a( n = `text` v = `ShadeF (only available for SAP Quartz and Horizon themes)`

                        )->end(
                    )->end(
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
                    )->a( n = `id`                   v = `cell-2`
                    )->a( n = `binding`              v = |\{{ client->_bind( val = cell2 path = abap_true ) }\}|
                    )->a( n = `title`                v = `An Icon`
                    )->a( n = `backgroundColorSet`   v = `{COLORSET}`
                    )->a( n = `backgroundColorShade` v = `{COLORSHADE}`

                    )->ele( `VBox`
                        )->tag( `Label`
                            )->a( n = `text` v = `Cell Color Set`
                        )->ele( `Select`
                            )->a( n = `selectedKey` v = `{COLORSET}`

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
                        )->tag( `Label`
                            )->a( n = `text` v = `Cell Color Shade`
                        )->ele( `Select`
                            )->a( n = `selectedKey` v = `{COLORSHADE}`

                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `ShadeA`
                                )->a( n = `text` v = `ShadeA`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `ShadeB`
                                )->a( n = `text` v = `ShadeB`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `ShadeC`
                                )->a( n = `text` v = `ShadeC`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `ShadeD`
                                )->a( n = `text` v = `ShadeD`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `ShadeE`
                                )->a( n = `text` v = `ShadeE (only available for SAP Quartz and Horizon themes)`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `ShadeF`
                                )->a( n = `text` v = `ShadeF (only available for SAP Quartz and Horizon themes)`

                        )->end(
                    )->end(
                    )->tag( n = `Icon` ns = `core`
                        )->a( n = `src` v = `sap-icon://add-activity`

                )->end(
            )->end(
            )->ele( n = `BlockLayoutRow` ns = `l`
                )->ele( n = `BlockLayoutCell` ns = `l`
                    )->a( n = `id`                   v = `cell-3`
                    )->a( n = `binding`              v = |\{{ client->_bind( val = cell3 path = abap_true ) }\}|
                    )->a( n = `title`                v = `Simple Form`
                    )->a( n = `backgroundColorSet`   v = `{COLORSET}`
                    )->a( n = `backgroundColorShade` v = `{COLORSHADE}`

                    )->ele( `VBox`
                        )->ele( `VBox`
                            )->tag( `Label`
                                )->a( n = `text` v = `Cell Color Set`
                            )->ele( `Select`
                                )->a( n = `selectedKey` v = `{COLORSET}`

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
                            )->tag( `Label`
                                )->a( n = `text` v = `Cell Color Shade`
                            )->ele( `Select`
                                )->a( n = `selectedKey` v = `{COLORSHADE}`

                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `key`  v = `ShadeA`
                                    )->a( n = `text` v = `ShadeA`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `key`  v = `ShadeB`
                                    )->a( n = `text` v = `ShadeB`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `key`  v = `ShadeC`
                                    )->a( n = `text` v = `ShadeC`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `key`  v = `ShadeD`
                                    )->a( n = `text` v = `ShadeD`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `key`  v = `ShadeE`
                                    )->a( n = `text` v = `ShadeE (only available for SAP Quartz and Horizon themes)`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `key`  v = `ShadeF`
                                    )->a( n = `text` v = `ShadeF (only available for SAP Quartz and Horizon themes)`

                            )->end(
                        )->end(
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
                                )->a( n = `text` v = `Donec bibendum diam nibh, sit amet ornare ante fermentum sed. Ut vulputate justo at orci sollicitudin, in gravida lectus aliquam. Vivamus tortor lorem, semper et diam ac, faucibus suscipit metus. ` &&
                                                     `Curabitur eget aliquet purus, id vestibulum sapien. Cras vitae imperdiet felis. Fusce placerat velit orci, at tempor nisl aliquam laoreet. Aliquam in sapien sit amet tortor laoreet feugiat id ` &&
                                                     `in ligula.`

                        )->end(
                    )->end(
                )->end(
            )->end(
            )->ele( n = `BlockLayoutRow` ns = `l`
                )->ele( n = `BlockLayoutCell` ns = `l`
                    )->a( n = `id`                   v = `cell-4`
                    )->a( n = `binding`              v = |\{{ client->_bind( val = cell4 path = abap_true ) }\}|
                    )->a( n = `title`                v = `Right Aligned Title`
                    )->a( n = `titleAlignment`       v = `Right`
                    )->a( n = `backgroundColorSet`   v = `{COLORSET}`
                    )->a( n = `backgroundColorShade` v = `{COLORSHADE}`

                    )->ele( `VBox`
                        )->tag( `Label`
                            )->a( n = `text` v = `Cell Color Set`
                        )->ele( `Select`
                            )->a( n = `selectedKey` v = `{COLORSET}`

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
                        )->tag( `Label`
                            )->a( n = `text` v = `Cell Color Shade`
                        )->ele( `Select`
                            )->a( n = `selectedKey` v = `{COLORSHADE}`

                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `ShadeA`
                                )->a( n = `text` v = `ShadeA`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `ShadeB`
                                )->a( n = `text` v = `ShadeB`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `ShadeC`
                                )->a( n = `text` v = `ShadeC`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `ShadeD`
                                )->a( n = `text` v = `ShadeD`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `ShadeE`
                                )->a( n = `text` v = `ShadeE (only available for SAP Quartz and Horizon themes)`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `ShadeF`
                                )->a( n = `text` v = `ShadeF (only available for SAP Quartz and Horizon themes)`

                        )->end(
                    )->end(
                    )->tag( `Text`
                        )->a( n = `text` v = `Morbi id ullamcorper lorem, vestibulum facilisis velit. Ut elementum aliquam nisl a pretium. Donec auctor mattis convallis. Aenean sodales tortor nec facilisis fringilla. Nam feugiat nulla at diam ` &&
                                             `sollicitudin pretium. Sed at lacus volutpat, finibus arcu ultricies, convallis elit. Aliquam sollicitudin tortor sit amet mi consequat fringilla. Fusce nisl leo, tempor et nulla id, pellentesque ` &&
                                             `suscipit augue. Morbi cursus molestie tellus. Ut volutpat orci interdum, condimentum risus sed, iaculis tellus. Proin nisi eros, tristique nec tortor quis, suscipit sodales dui.`

                )->end(
            )->end(
            )->ele( n = `BlockLayoutRow` ns = `l`
                )->ele( n = `BlockLayoutCell` ns = `l`
                    )->a( n = `id`                   v = `cell-5`
                    )->a( n = `binding`              v = |\{{ client->_bind( val = cell5 path = abap_true ) }\}|
                    )->a( n = `title`                v = `Left Aligned Title`
                    )->a( n = `titleAlignment`       v = `Left`
                    )->a( n = `backgroundColorSet`   v = `{COLORSET}`
                    )->a( n = `backgroundColorShade` v = `{COLORSHADE}`

                    )->ele( `VBox`
                        )->tag( `Label`
                            )->a( n = `text` v = `Cell Color Set`
                        )->ele( `Select`
                            )->a( n = `selectedKey` v = `{COLORSET}`

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
                        )->tag( `Label`
                            )->a( n = `text` v = `Cell Color Shade`
                        )->ele( `Select`
                            )->a( n = `selectedKey` v = `{COLORSHADE}`

                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `ShadeA`
                                )->a( n = `text` v = `ShadeA`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `ShadeB`
                                )->a( n = `text` v = `ShadeB`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `ShadeC`
                                )->a( n = `text` v = `ShadeC`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `ShadeD`
                                )->a( n = `text` v = `ShadeD`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `ShadeE`
                                )->a( n = `text` v = `ShadeE (only available for SAP Quartz and Horizon themes)`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `ShadeF`
                                )->a( n = `text` v = `ShadeF (only available for SAP Quartz and Horizon themes)`

                        )->end(
                    )->end(
                    )->tag( `Text`
                        )->a( n = `text` v = `Morbi id ullamcorper lorem, vestibulum facilisis velit. Ut elementum aliquam nisl a pretium. Donec auctor mattis convallis. Aenean sodales tortor nec facilisis fringilla. Nam feugiat nulla at diam ` &&
                                             `sollicitudin pretium. Sed at lacus volutpat, finibus arcu ultricies, convallis elit. Aliquam sollicitudin tortor sit amet mi consequat fringilla. Fusce nisl leo, tempor et nulla id, pellentesque ` &&
                                             `suscipit augue. Morbi cursus molestie tellus. Ut volutpat orci interdum, condimentum risus sed, iaculis tellus. Proin nisi eros, tristique nec tortor quis, suscipit sodales dui.`

                )->end(
            )->end(
            )->ele( n = `BlockLayoutRow` ns = `l`
                )->ele( n = `BlockLayoutCell` ns = `l`
                    )->a( n = `id`                   v = `cell-6`
                    )->a( n = `binding`              v = |\{{ client->_bind( val = cell6 path = abap_true ) }\}|
                    )->a( n = `title`                v = `Default Aligned Title`
                    )->a( n = `backgroundColorSet`   v = `{COLORSET}`
                    )->a( n = `backgroundColorShade` v = `{COLORSHADE}`

                    )->ele( `VBox`
                        )->tag( `Label`
                            )->a( n = `text` v = `Cell Color Set`
                        )->ele( `Select`
                            )->a( n = `selectedKey` v = `{COLORSET}`

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
                        )->tag( `Label`
                            )->a( n = `text` v = `Cell Color Shade`
                        )->ele( `Select`
                            )->a( n = `selectedKey` v = `{COLORSHADE}`

                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `ShadeA`
                                )->a( n = `text` v = `ShadeA`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `ShadeB`
                                )->a( n = `text` v = `ShadeB`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `ShadeC`
                                )->a( n = `text` v = `ShadeC`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `ShadeD`
                                )->a( n = `text` v = `ShadeD`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `ShadeE`
                                )->a( n = `text` v = `ShadeE (only available for SAP Quartz and Horizon themes)`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `ShadeF`
                                )->a( n = `text` v = `ShadeF (only available for SAP Quartz and Horizon themes)`

                        )->end(
                    )->end(
                    )->tag( `Text`
                        )->a( n = `text` v = `Morbi id ullamcorper lorem, vestibulum facilisis velit. Ut elementum aliquam nisl a pretium. Donec auctor mattis convallis. Aenean sodales tortor nec facilisis fringilla. Nam feugiat nulla at diam ` &&
                                             `sollicitudin pretium. Sed at lacus volutpat, finibus arcu ultricies, convallis elit. Aliquam sollicitudin tortor sit amet mi consequat fringilla. Fusce nisl leo, tempor et nulla id, pellentesque ` &&
                                             `suscipit augue. Morbi cursus molestie tellus. Ut volutpat orci interdum, condimentum risus sed, iaculis tellus. Proin nisi eros, tristique nec tortor quis, suscipit sodales dui.`

                )->end(
            )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " the controller's _modelData verbatim - every cell starts on ColorSet6,
    " with shades A..F one per cell
    cell1 = VALUE #( colorset = `ColorSet6` colorshade = `ShadeA` ).
    cell2 = VALUE #( colorset = `ColorSet6` colorshade = `ShadeB` ).
    cell3 = VALUE #( colorset = `ColorSet6` colorshade = `ShadeC` ).
    cell4 = VALUE #( colorset = `ColorSet6` colorshade = `ShadeD` ).
    cell5 = VALUE #( colorset = `ColorSet6` colorshade = `ShadeE` ).
    cell6 = VALUE #( colorset = `ColorSet6` colorshade = `ShadeF` ).

  ENDMETHOD.

ENDCLASS.
