CLASS z2ui5_cl_smpc_app_258 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_258 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " Block->content inlining (app 161/187 precedent): every blocks aggregation
    " of the original holds the sample's own BlockBase control
    " sample:mySimpleBlock (sap.uxap.sample.AnchorBar.view.blocks). A BlockBase
    " is only a lazy-loading wrapper around a view; mySimpleBlock's view is an
    " html:div (font-size: 0.875rem) around a SimpleForm with one Label/Text
    " pair. Since ObjectPageSubSection.blocks accepts any sap.ui.core.Control,
    " that SimpleForm is inlined here directly - the html:div font-size wrapper
    " is dropped (see the sidecar).
    view->open( n = `View` ns = `mvc`
        )->a( n = `height`       v = `100%`
        )->a( n = `xmlns`        v = `sap.uxap`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:m`      v = `sap.m`
        )->a( n = `xmlns:layout` v = `sap.ui.layout`
        )->a( n = `xmlns:forms`  v = `sap.ui.layout.form`

        )->open( `ObjectPageLayout`
            )->a( n = `id`                        v = `ObjectPageLayout`
            )->a( n = `showTitleInHeaderContent`  v = `true`
            )->a( n = `upperCaseAnchorBar`        v = `false`
            )->a( n = `backgroundDesignAnchorBar` v = `Translucent`

            )->open( `headerTitle`
                )->open( `ObjectPageDynamicHeaderTitle`
                    )->a( n = `backgroundDesign` v = `Solid`

                    )->open( `breadcrumbs`
                        )->open( n = `Breadcrumbs` ns = `m`
                            )->leaf( n = `Link` ns = `m`
                                )->a( n = `text` v = `Page 1`
                            )->leaf( n = `Link` ns = `m`
                                )->a( n = `text` v = `Page 2`
                            )->leaf( n = `Link` ns = `m`
                                )->a( n = `text` v = `Page 3`
                            )->leaf( n = `Link` ns = `m`
                                )->a( n = `text` v = `Page 4`
                            )->leaf( n = `Link` ns = `m`
                                )->a( n = `text` v = `Page 5`

                        )->shut(
                    )->shut(

                    )->open( `expandedHeading`
                        )->leaf( n = `Title` ns = `m`
                            )->a( n = `text`     v = `Denise Smith`
                            )->a( n = `wrapping` v = `true`
                            )->a( n = `class`    v = `sapUiTinyMarginTop`

                    )->shut(

                    )->open( `snappedHeading`
                        )->leaf( n = `Title` ns = `m`
                            )->a( n = `text`     v = `Denise Smith`
                            )->a( n = `wrapping` v = `true`
                            )->a( n = `class`    v = `sapUiTinyMarginTop`

                    )->shut(

                    )->open( `expandedContent`
                        )->leaf( n = `Text` ns = `m`
                            )->a( n = `text` v = `Senior Developer`

                    )->shut(

                    )->open( `snappedContent`
                        )->leaf( n = `Text` ns = `m`
                            )->a( n = `text` v = `Senior Developer`

                    )->shut(
                )->shut(
            )->shut(

            )->open( `headerContent`
                )->open( n = `HorizontalLayout` ns = `layout`
                    )->a( n = `allowWrapping` v = `true`

                    )->open( n = `VerticalLayout` ns = `layout`
                        )->a( n = `class` v = `sapUiMediumMarginEnd`

                        )->leaf( n = `ObjectAttribute` ns = `m`
                            )->a( n = `title` v = `Location`
                            )->a( n = `text`  v = `Warehouse A`
                        )->leaf( n = `ObjectAttribute` ns = `m`
                            )->a( n = `title` v = `Halway`
                            )->a( n = `text`  v = `23L`
                        )->leaf( n = `ObjectAttribute` ns = `m`
                            )->a( n = `title` v = `Rack`
                            )->a( n = `text`  v = `34`

                    )->shut(

                    )->open( n = `VerticalLayout` ns = `layout`
                        )->leaf( n = `ObjectAttribute` ns = `m`
                            )->a( n = `title` v = `Availability`
                        )->leaf( n = `ObjectStatus` ns = `m`
                            )->a( n = `text`  v = `In Stock`
                            )->a( n = `state` v = `Success`

                    )->shut(
                )->shut(
            )->shut(

            )->open( `sections`
                )->open( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `id`             v = `section1`
                    )->a( n = `title`          v = `Section 1`

                    )->open( `subSections`
                        )->open( `ObjectPageSubSection`
                            )->a( n = `id`             v = `section1_SS1`
                            )->a( n = `title`          v = `Subsection 1.1`
                            )->a( n = `titleUppercase` v = `false`

                            )->open( `blocks`
                                )->open( n = `SimpleForm` ns = `forms`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`
                                    )->a( n = `editable`         v = `false`

                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Content`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `some content goes here...`

                                )->shut(
                            )->shut(
                        )->shut(

                        )->open( `ObjectPageSubSection`
                            )->a( n = `id`             v = `section1_SS2`
                            )->a( n = `title`          v = `Subsection 1.2`
                            )->a( n = `titleUppercase` v = `false`

                            )->open( `blocks`
                                )->open( n = `SimpleForm` ns = `forms`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`
                                    )->a( n = `editable`         v = `false`

                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Content`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `some content goes here...`

                                )->shut(
                            )->shut(
                        )->shut(
                    )->shut(
                )->shut(

                )->open( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `id`             v = `section2`
                    )->a( n = `title`          v = `Section 2`

                )->shut(

                )->open( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `id`             v = `section3`
                    )->a( n = `title`          v = `Section 3`

                    )->open( `subSections`
                        )->open( `ObjectPageSubSection`
                            )->a( n = `id`             v = `section3_SS1`
                            )->a( n = `titleUppercase` v = `false`

                            )->open( `blocks`
                                )->open( n = `SimpleForm` ns = `forms`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`
                                    )->a( n = `editable`         v = `false`

                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Content`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `some content goes here...`

                                )->shut(
                            )->shut(
                        )->shut(
                    )->shut(
                )->shut(

                )->open( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `id`             v = `section4`
                    )->a( n = `title`          v = `Section 4`

                    )->open( `subSections`
                        )->open( `ObjectPageSubSection`
                            )->a( n = `id`             v = `section4_SS1`
                            )->a( n = `title`          v = `Subsection 4.1`
                            )->a( n = `titleUppercase` v = `false`

                            )->open( `blocks`
                                )->open( n = `SimpleForm` ns = `forms`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`
                                    )->a( n = `editable`         v = `false`

                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Content`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `some content goes here...`

                                )->shut(
                            )->shut(
                        )->shut(
                    )->shut(
                )->shut(

                )->open( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `id`             v = `section5`
                    )->a( n = `title`          v = `Section 5`

                    )->open( `subSections`
                        )->open( `ObjectPageSubSection`
                            )->a( n = `id`             v = `section5_SS1`
                            )->a( n = `titleUppercase` v = `false`

                            )->open( `blocks`
                                )->open( n = `SimpleForm` ns = `forms`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`
                                    )->a( n = `editable`         v = `false`

                                    )->leaf( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Content`
                                    )->leaf( n = `Text` ns = `m`
                                        )->a( n = `text` v = `some content goes here...`

                                ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
