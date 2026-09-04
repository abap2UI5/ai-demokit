" @keywords objectpagelayout object layout sap.uxap objectpageheader objectpagesection objectpagesubsection simpleform label text
" @summary This example shows subsections in expanded and collapsed mode.
CLASS z2ui5_cl_smpc_app_116 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_116 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " The ten blocks (across blocks AND moreBlocks) are sample:MultiViewBlock instances - a BlockBase is only a
    " lazy-loading wrapper around a view, and ObjectPageSubSection.blocks takes any
    " control, so each block's view CONTENT is inlined (CAPABILITIES 'Custom
    " BlockBase blocks', apps 161/178/188). MultiViewBlock ships two views and picks
    " by the block MODE: Collapsed (Country/Subsidiary) and Expanded (+ Building/
    " Room). abap2UI5 has no BlockBase mode, so each block is inlined in the variant
    " its subsection asks for - mode='Expanded' gets the expanded form, the
    " default-mode subsection the collapsed one, which is what the sample renders on
    " load. Written out per block rather than through a helper method: the view has
    " to stay statically reconstructable for the structural diff.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`       v = `sap.uxap`
        )->a( n = `xmlns:mvc`   v = `sap.ui.core.mvc`
        )->a( n = `xmlns:m`     v = `sap.m`
        )->a( n = `xmlns:forms` v = `sap.ui.layout.form`
        )->a( n = `height`      v = `100%`

        )->ele( `ObjectPageLayout`
            )->a( n = `id`                 v = `ObjectPageLayout`
            )->a( n = `upperCaseAnchorBar` v = `false`

            )->ele( `headerTitle`
                )->tag( `ObjectPageHeader`
                    )->a( n = `objectTitle` v = `Expand/Collapse sample`

            )->end(
            )->ele( `sections`
                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `All examples`

                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `No Expand/Collapse`
                            )->a( n = `mode`           v = `Expanded`
                            )->a( n = `titleUppercase` v = `false`

                            )->ele( `blocks`
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `title`    v = `Location`
                                    )->a( n = `editable` v = `false`
                                    )->a( n = `layout`   v = `ColumnLayout`

                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Country`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `France`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Subsidiary`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `SAP France`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Building`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `LVL B`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Room`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `AppHaus`

                                )->end(
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `title`    v = `Location`
                                    )->a( n = `editable` v = `false`
                                    )->a( n = `layout`   v = `ColumnLayout`

                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Country`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `France`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Subsidiary`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `SAP France`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Building`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `LVL B`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Room`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `AppHaus`

                                )->end(
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Collapsed by default`
                            )->a( n = `titleUppercase` v = `false`

                            )->ele( `blocks`
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `title`    v = `Location`
                                    )->a( n = `editable` v = `false`
                                    )->a( n = `layout`   v = `ColumnLayout`

                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Country`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `France`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Subsidiary`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `SAP France`

                                )->end(
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `title`    v = `Location`
                                    )->a( n = `editable` v = `false`
                                    )->a( n = `layout`   v = `ColumnLayout`

                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Country`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `France`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Subsidiary`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `SAP France`

                                )->end(
                            )->end(
                            )->ele( `moreBlocks`
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `title`    v = `Location`
                                    )->a( n = `editable` v = `false`
                                    )->a( n = `layout`   v = `ColumnLayout`

                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Country`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `France`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Subsidiary`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `SAP France`

                                )->end(
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `title`    v = `Location`
                                    )->a( n = `editable` v = `false`
                                    )->a( n = `layout`   v = `ColumnLayout`

                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Country`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `France`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Subsidiary`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `SAP France`

                                )->end(
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Expanded by default`
                            )->a( n = `mode`           v = `Expanded`
                            )->a( n = `titleUppercase` v = `false`

                            )->ele( `blocks`
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `title`    v = `Location`
                                    )->a( n = `editable` v = `false`
                                    )->a( n = `layout`   v = `ColumnLayout`

                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Country`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `France`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Subsidiary`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `SAP France`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Building`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `LVL B`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Room`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `AppHaus`

                                )->end(
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `title`    v = `Location`
                                    )->a( n = `editable` v = `false`
                                    )->a( n = `layout`   v = `ColumnLayout`

                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Country`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `France`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Subsidiary`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `SAP France`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Building`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `LVL B`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Room`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `AppHaus`

                                )->end(
                            )->end(
                            )->ele( `moreBlocks`
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `title`    v = `Location`
                                    )->a( n = `editable` v = `false`
                                    )->a( n = `layout`   v = `ColumnLayout`

                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Country`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `France`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Subsidiary`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `SAP France`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Building`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `LVL B`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Room`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `AppHaus`

                                )->end(
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `title`    v = `Location`
                                    )->a( n = `editable` v = `false`
                                    )->a( n = `layout`   v = `ColumnLayout`

                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Country`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `France`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Subsidiary`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `SAP France`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Building`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `LVL B`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Room`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `AppHaus`

                                )->end(
                            )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
