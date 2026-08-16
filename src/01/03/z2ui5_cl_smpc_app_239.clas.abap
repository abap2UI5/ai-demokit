" @keywords objectpageheaderactionbutton object header action button sap.uxap objectpageheaderactionbuttons objectpagelayout objectpagedynamicheadertitle objectpagesection objectpagesubsection
" @summary This example demonstrates ObjectPage with ObjectPageHeaderActionButtons and a GenericTag in the header.
CLASS z2ui5_cl_smpc_app_239 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_239 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " sap.uxap.ObjectPageLayout showcasing sap.uxap.ObjectPageHeaderActionButton
    " in the ObjectPageDynamicHeaderTitle actions/navigationActions. Each of the
    " 15 subsections holds a custom BlockBase control (sample:mySimpleBlock, from
    " the AnchorBar SharedBlocks JS): a BlockBase is only a lazy-loading wrapper
    " around a view, so its content (a font-size div wrapping a SimpleForm with a
    " Label + Text) is inlined here directly as the SimpleForm - thin frontend,
    " no custom JS control. The html:div font-size wrapper is dropped (a control
    " cannot wrap another control via core:HTML); the block's default-sap.m
    " Label/Text carry the m: prefix in this single-default-namespace (sap.uxap)
    " view (namespace-representation difference).
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`       v = `sap.uxap`
        )->a( n = `xmlns:mvc`   v = `sap.ui.core.mvc`
        )->a( n = `xmlns:m`     v = `sap.m`
        )->a( n = `xmlns:layout` v = `sap.ui.layout`
        )->a( n = `xmlns:forms` v = `sap.ui.layout.form`
        )->a( n = `height`      v = `100%`

        )->ele( `ObjectPageLayout`
            )->a( n = `id`                     v = `ObjectPageLayout`
            )->a( n = `showTitleInHeaderContent` v = `true`
            )->a( n = `upperCaseAnchorBar`     v = `false`

            )->ele( `headerTitle`
                )->ele( `ObjectPageDynamicHeaderTitle`

                    )->ele( `breadcrumbs`
                        )->ele( n = `Breadcrumbs` ns = `m`
                            )->tag( n = `Link` ns = `m`
                                )->a( n = `text` v = `Page 1`
                            )->tag( n = `Link` ns = `m`
                                )->a( n = `text` v = `Page 2`
                            )->tag( n = `Link` ns = `m`
                                )->a( n = `text` v = `Page 3`
                            )->tag( n = `Link` ns = `m`
                                )->a( n = `text` v = `Page 4`
                            )->tag( n = `Link` ns = `m`
                                )->a( n = `text` v = `Page 5`

                        )->end(
                    )->end(

                    )->ele( `expandedHeading`
                        )->tag( n = `Title` ns = `m`
                            )->a( n = `text`     v = `Denise Smith`
                            )->a( n = `wrapping` v = `true`

                    )->end(

                    )->ele( `snappedHeading`
                        )->tag( n = `Title` ns = `m`
                            )->a( n = `text`     v = `Denise Smith`
                            )->a( n = `wrapping` v = `true`

                    )->end(

                    )->ele( `expandedContent`
                        )->tag( n = `Text` ns = `m`
                            )->a( n = `text` v = `Senior Developer`

                    )->end(

                    )->ele( `snappedContent`
                        )->tag( n = `Text` ns = `m`
                            )->a( n = `text` v = `Senior Developer`

                    )->end(

                    )->ele( `actions`
                        )->tag( `ObjectPageHeaderActionButton`
                            )->a( n = `text`     v = `Edit`
                            )->a( n = `type`     v = `Emphasized`
                            )->a( n = `hideText` v = `false`
                        )->tag( `ObjectPageHeaderActionButton`
                            )->a( n = `type`     v = `Transparent`
                            )->a( n = `text`     v = `Delete`
                            )->a( n = `hideText` v = `false`
                            )->a( n = `hideIcon` v = `true`
                        )->tag( `ObjectPageHeaderActionButton`
                            )->a( n = `type`     v = `Transparent`
                            )->a( n = `text`     v = `Copy`
                            )->a( n = `hideText` v = `false`
                            )->a( n = `hideIcon` v = `true`
                        )->tag( `ObjectPageHeaderActionButton`
                            )->a( n = `type`     v = `Transparent`
                            )->a( n = `text`     v = `Add`
                            )->a( n = `hideText` v = `false`
                            )->a( n = `hideIcon` v = `true`
                        )->tag( `ObjectPageHeaderActionButton`
                            )->a( n = `icon`    v = `sap-icon://action`
                            )->a( n = `type`    v = `Transparent`
                            )->a( n = `text`    v = `Share`
                            )->a( n = `tooltip` v = `action`

                    )->end(

                    )->ele( `navigationActions`
                        )->tag( `ObjectPageHeaderActionButton`
                            )->a( n = `icon`    v = `sap-icon://slim-arrow-up`
                            )->a( n = `type`    v = `Transparent`
                            )->a( n = `tooltip` v = `slim-arrow-up`
                        )->tag( `ObjectPageHeaderActionButton`
                            )->a( n = `icon`    v = `sap-icon://slim-arrow-down`
                            )->a( n = `type`    v = `Transparent`
                            )->a( n = `tooltip` v = `slim-arrow-down`

                    )->end(

                    )->ele( `content`
                        )->tag( n = `GenericTag` ns = `m`
                            )->a( n = `text`   v = `Material Shortage`
                            )->a( n = `status` v = `Warning`

                    )->end(
                )->end(
            )->end(

            )->ele( `headerContent`
                )->ele( n = `HorizontalLayout` ns = `layout`
                    )->a( n = `allowWrapping` v = `true`

                    )->ele( n = `VerticalLayout` ns = `layout`
                        )->a( n = `class` v = `sapUiMediumMarginEnd`
                        )->tag( n = `ObjectAttribute` ns = `m`
                            )->a( n = `title` v = `Location`
                            )->a( n = `text`  v = `Warehouse A`
                        )->tag( n = `ObjectAttribute` ns = `m`
                            )->a( n = `title` v = `Halway`
                            )->a( n = `text`  v = `23L`
                        )->tag( n = `ObjectAttribute` ns = `m`
                            )->a( n = `title` v = `Rack`
                            )->a( n = `text`  v = `34`

                    )->end(

                    )->ele( n = `VerticalLayout` ns = `layout`
                        )->tag( n = `ObjectAttribute` ns = `m`
                            )->a( n = `title` v = `Availability`
                        )->tag( n = `ObjectStatus` ns = `m`
                            )->a( n = `text`  v = `In Stock`
                            )->a( n = `state` v = `Success`

                    )->end(
                )->end(
            )->end(

            )->ele( `sections`

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `id`             v = `section1`
                    )->a( n = `title`          v = `Section 1`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `id`             v = `section1_SS1`
                            )->a( n = `title`          v = `Subsection 1.1`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`
                                    )->a( n = `editable`         v = `false`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Content`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `some content goes here...`

                                )->end(
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `id`             v = `section1_SS2`
                            )->a( n = `title`          v = `Subsection 1.2`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`
                                    )->a( n = `editable`         v = `false`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Content`
                                    )->tag( n = `Text` ns = `m`
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
                                    )->tag( n = `Text` ns = `m`
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
                            )->a( n = `title`          v = `Subsection 4.1`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`
                                    )->a( n = `editable`         v = `false`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Content`
                                    )->tag( n = `Text` ns = `m`
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
                                    )->tag( n = `Text` ns = `m`
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
                                    )->tag( n = `Text` ns = `m`
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
                                    )->tag( n = `Text` ns = `m`
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
                                    )->tag( n = `Text` ns = `m`
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
                                    )->tag( n = `Text` ns = `m`
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
                                    )->tag( n = `Text` ns = `m`
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
                                    )->tag( n = `Text` ns = `m`
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
                                    )->tag( n = `Text` ns = `m`
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
                                    )->tag( n = `Text` ns = `m`
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
                                    )->tag( n = `Text` ns = `m`
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
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `some content goes here...`

                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
