" @keywords objectpagelayout object layout sap.uxap anchorbar objectpagedynamicheadertitle title objectpagesection objectpagesubsection simpleform label text
" @summary AnchorBar has a different behavior based on the device
CLASS z2ui5_cl_smpc_app_586 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_586 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " Block->content inlining (app 217/401/402/416 precedent): every blocks
    " aggregation holds one sample:mySimpleBlock, a BlockBase wrapper around the
    " static mySimpleBlock.view.xml - its SimpleForm is inlined 1:1 below
    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`       v = `100%`
        )->a( n = `xmlns`        v = `sap.uxap`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:m`      v = `sap.m`
        )->a( n = `xmlns:forms`  v = `sap.ui.layout.form`

        )->ele( `ObjectPageLayout`
            )->a( n = `id`                 v = `ObjectPageLayout`
            )->a( n = `upperCaseAnchorBar` v = `false`

            )->ele( `headerTitle`
                )->ele( `ObjectPageDynamicHeaderTitle`
                    )->ele( `heading`
                        )->tag( n = `Title` ns = `m`
                            )->a( n = `text`     v = `AnchorBar sample`
                            )->a( n = `wrapping` v = `true`
                    )->end(
                    )->ele( `snappedTitleOnMobile`
                        )->tag( n = `Title` ns = `m`
                            )->a( n = `text` v = `AnchorBar sample`
                    )->end(
                )->end(
            )->end(

            )->ele( `headerContent`
                )->tag( n = `Title` ns = `m`
                    )->a( n = `text`       v = `This example explains how the Anchor Bar is built based on page content`
                    )->a( n = `titleStyle` v = `H6`
            )->end(

            )->ele( `sections`
                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `id`             v = `section1`
                    )->a( n = `title`          v = `Section 1`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `id`             v = `section1_SS1`
                            )->a( n = `title`          v = `Subsection 1.1 `
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`
                                    )->a( n = `editable`         v = `false`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Content`
                                    )->tag( n = `Text`  ns = `m`
                                        )->a( n = `text` v = `some content goes here...`
                                )->end(
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `id`             v = `section1_SS2`
                            )->a( n = `title`          v = `Subsection 1.2 `
                            )->ele( `blocks`
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`
                                    )->a( n = `editable`         v = `false`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Content`
                                    )->tag( n = `Text`  ns = `m`
                                        )->a( n = `text` v = `some content goes here...`
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(
                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `id`             v = `section2`
                    )->a( n = `title`          v = `Section 2`
                )->end(
                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `id`             v = `section3`
                    )->a( n = `title`          v = `Section 3`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `id`             v = `section3_SS1`
                            )->a( n = `title`          v = ` `
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`
                                    )->a( n = `editable`         v = `false`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Content`
                                    )->tag( n = `Text`  ns = `m`
                                        )->a( n = `text` v = `some content goes here...`
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(
                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `id`             v = `section4`
                    )->a( n = `title`          v = `Section 4`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `id`             v = `section4_SS1`
                            )->a( n = `title`          v = `Subsection 4.1 `
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`
                                    )->a( n = `editable`         v = `false`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Content`
                                    )->tag( n = `Text`  ns = `m`
                                        )->a( n = `text` v = `some content goes here...`
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(
                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `id`             v = `section5`
                    )->a( n = `title`          v = `Section 5`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `id`             v = `section5_SS1`
                            )->a( n = `title`          v = ` `
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`
                                    )->a( n = `editable`         v = `false`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Content`
                                    )->tag( n = `Text`  ns = `m`
                                        )->a( n = `text` v = `some content goes here...`
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(
                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `id`             v = `section6`
                    )->a( n = `title`          v = `Section 6`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `id`             v = `section6_SS1`
                            )->a( n = `title`          v = ` `
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`
                                    )->a( n = `editable`         v = `false`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Content`
                                    )->tag( n = `Text`  ns = `m`
                                        )->a( n = `text` v = `some content goes here...`
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(
                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `id`             v = `section7`
                    )->a( n = `title`          v = `Section 7`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `id`             v = `section7_SS1`
                            )->a( n = `title`          v = ` `
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`
                                    )->a( n = `editable`         v = `false`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Content`
                                    )->tag( n = `Text`  ns = `m`
                                        )->a( n = `text` v = `some content goes here...`
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(
                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `Section 8`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = ` `
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`
                                    )->a( n = `editable`         v = `false`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Content`
                                    )->tag( n = `Text`  ns = `m`
                                        )->a( n = `text` v = `some content goes here...`
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(
                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `Section 9`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = ` `
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`
                                    )->a( n = `editable`         v = `false`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Content`
                                    )->tag( n = `Text`  ns = `m`
                                        )->a( n = `text` v = `some content goes here...`
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(
                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `Section 10`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = ` `
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`
                                    )->a( n = `editable`         v = `false`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Content`
                                    )->tag( n = `Text`  ns = `m`
                                        )->a( n = `text` v = `some content goes here...`
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(
                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `Section 11`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = ` `
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`
                                    )->a( n = `editable`         v = `false`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Content`
                                    )->tag( n = `Text`  ns = `m`
                                        )->a( n = `text` v = `some content goes here...`
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(
                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `Section 12`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = ` `
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`
                                    )->a( n = `editable`         v = `false`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Content`
                                    )->tag( n = `Text`  ns = `m`
                                        )->a( n = `text` v = `some content goes here...`
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(
                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `Section 13`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = ` `
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`
                                    )->a( n = `editable`         v = `false`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Content`
                                    )->tag( n = `Text`  ns = `m`
                                        )->a( n = `text` v = `some content goes here...`
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(
                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `Section 14`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = ` `
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`
                                    )->a( n = `editable`         v = `false`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Content`
                                    )->tag( n = `Text`  ns = `m`
                                        )->a( n = `text` v = `some content goes here...`
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(
                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `Section 15`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = ` `
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`
                                    )->a( n = `editable`         v = `false`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Content`
                                    )->tag( n = `Text`  ns = `m`
                                        )->a( n = `text` v = `some content goes here...`
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
