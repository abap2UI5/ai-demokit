" @keywords objectpagesubsection object sub section sap.uxap objectpagesubsectionmultiview objectpagelayout objectpageheader objectpagesection
" @summary This example shows how blocks can be laid out automatically by the Object Page when their size is not specified.
CLASS z2ui5_cl_smpc_app_598 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_598 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) OR client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " Block->content inlining (app 401/416 precedent): the twenty-one blocks are
    " all one BlockBase, sample:BlockEmpty, around an EMPTY SimpleForm - the
    " sample lays out 1..6 of them per subsection to show the automatic layout
    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`      v = `100%`
        )->a( n = `xmlns`       v = `sap.uxap`
        )->a( n = `xmlns:mvc`   v = `sap.ui.core.mvc`
        )->a( n = `xmlns:forms` v = `sap.ui.layout.form`

        )->ele( `ObjectPageLayout`
            )->a( n = `id`                 v = `ObjectPageLayout`
            )->a( n = `upperCaseAnchorBar` v = `false`

            )->ele( `headerTitle`
                )->tag( `ObjectPageHeader`
                    )->a( n = `objectTitle`    v = `Automatic layout of blocks`
                    )->a( n = `objectSubtitle` v = `This example shows how blocks can be laid out automatically by the Object Page when their size is not specified`
            )->end(

            )->ele( `sections`
                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `showTitle`      v = `false`
                    )->ele( `subSections`

                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `1 block`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:BlockEmpty inlined - an empty SimpleForm
                                )->tag( n = `SimpleForm` ns = `forms`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `title`            v = ` `
                                    )->a( n = `editable`         v = `false`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`

                            )->end(
                        )->end(

                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `2 blocks`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:BlockEmpty inlined - an empty SimpleForm
                                )->tag( n = `SimpleForm` ns = `forms`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `title`            v = ` `
                                    )->a( n = `editable`         v = `false`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`

                                " sample:BlockEmpty inlined - an empty SimpleForm
                                )->tag( n = `SimpleForm` ns = `forms`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `title`            v = ` `
                                    )->a( n = `editable`         v = `false`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`

                            )->end(
                        )->end(

                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `3 blocks`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:BlockEmpty inlined - an empty SimpleForm
                                )->tag( n = `SimpleForm` ns = `forms`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `title`            v = ` `
                                    )->a( n = `editable`         v = `false`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`

                                " sample:BlockEmpty inlined - an empty SimpleForm
                                )->tag( n = `SimpleForm` ns = `forms`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `title`            v = ` `
                                    )->a( n = `editable`         v = `false`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`

                                " sample:BlockEmpty inlined - an empty SimpleForm
                                )->tag( n = `SimpleForm` ns = `forms`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `title`            v = ` `
                                    )->a( n = `editable`         v = `false`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`

                            )->end(
                        )->end(

                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `4 blocks`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:BlockEmpty inlined - an empty SimpleForm
                                )->tag( n = `SimpleForm` ns = `forms`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `title`            v = ` `
                                    )->a( n = `editable`         v = `false`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`

                                " sample:BlockEmpty inlined - an empty SimpleForm
                                )->tag( n = `SimpleForm` ns = `forms`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `title`            v = ` `
                                    )->a( n = `editable`         v = `false`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`

                                " sample:BlockEmpty inlined - an empty SimpleForm
                                )->tag( n = `SimpleForm` ns = `forms`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `title`            v = ` `
                                    )->a( n = `editable`         v = `false`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`

                                " sample:BlockEmpty inlined - an empty SimpleForm
                                )->tag( n = `SimpleForm` ns = `forms`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `title`            v = ` `
                                    )->a( n = `editable`         v = `false`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`

                            )->end(
                        )->end(

                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `5 blocks`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:BlockEmpty inlined - an empty SimpleForm
                                )->tag( n = `SimpleForm` ns = `forms`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `title`            v = ` `
                                    )->a( n = `editable`         v = `false`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`

                                " sample:BlockEmpty inlined - an empty SimpleForm
                                )->tag( n = `SimpleForm` ns = `forms`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `title`            v = ` `
                                    )->a( n = `editable`         v = `false`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`

                                " sample:BlockEmpty inlined - an empty SimpleForm
                                )->tag( n = `SimpleForm` ns = `forms`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `title`            v = ` `
                                    )->a( n = `editable`         v = `false`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`

                                " sample:BlockEmpty inlined - an empty SimpleForm
                                )->tag( n = `SimpleForm` ns = `forms`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `title`            v = ` `
                                    )->a( n = `editable`         v = `false`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`

                                " sample:BlockEmpty inlined - an empty SimpleForm
                                )->tag( n = `SimpleForm` ns = `forms`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `title`            v = ` `
                                    )->a( n = `editable`         v = `false`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`

                            )->end(
                        )->end(

                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `6 blocks`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:BlockEmpty inlined - an empty SimpleForm
                                )->tag( n = `SimpleForm` ns = `forms`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `title`            v = ` `
                                    )->a( n = `editable`         v = `false`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`

                                " sample:BlockEmpty inlined - an empty SimpleForm
                                )->tag( n = `SimpleForm` ns = `forms`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `title`            v = ` `
                                    )->a( n = `editable`         v = `false`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`

                                " sample:BlockEmpty inlined - an empty SimpleForm
                                )->tag( n = `SimpleForm` ns = `forms`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `title`            v = ` `
                                    )->a( n = `editable`         v = `false`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`

                                " sample:BlockEmpty inlined - an empty SimpleForm
                                )->tag( n = `SimpleForm` ns = `forms`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `title`            v = ` `
                                    )->a( n = `editable`         v = `false`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`

                                " sample:BlockEmpty inlined - an empty SimpleForm
                                )->tag( n = `SimpleForm` ns = `forms`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `title`            v = ` `
                                    )->a( n = `editable`         v = `false`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`

                                " sample:BlockEmpty inlined - an empty SimpleForm
                                )->tag( n = `SimpleForm` ns = `forms`
                                    )->a( n = `maxContainerCols` v = `2`
                                    )->a( n = `title`            v = ` `
                                    )->a( n = `editable`         v = `false`
                                    )->a( n = `layout`           v = `ResponsiveGridLayout`

                            )->end(
                        )->end(
                    )->end(
                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
