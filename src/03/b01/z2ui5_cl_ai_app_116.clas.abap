CLASS z2ui5_cl_ai_app_116 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_116 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " The eight blocks are sample:MultiViewBlock instances - a BlockBase is only a
    " lazy-loading wrapper around a view, and ObjectPageSubSection.blocks takes any
    " control, so each block's view CONTENT is inlined (CAPABILITIES 'Custom
    " BlockBase blocks', apps 161/178/188). MultiViewBlock ships two views and picks
    " by the block MODE: Collapsed (Country/Subsidiary) and Expanded (+ Building/
    " Room). abap2UI5 has no BlockBase mode, so each block is inlined in the variant
    " its subsection asks for - mode='Expanded' gets the expanded form, the
    " default-mode subsection the collapsed one, which is what the sample renders on
    " load. Written out per block rather than through a helper method: the view has
    " to stay statically reconstructable for the structural diff.
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`       v = `sap.uxap`
        )->a( n = `xmlns:mvc`   v = `sap.ui.core.mvc`
        )->a( n = `xmlns:m`     v = `sap.m`
        )->a( n = `xmlns:forms` v = `sap.ui.layout.form`
        )->a( n = `height`      v = `100%`

        )->open( `ObjectPageLayout`
            )->a( n = `id`                 v = `ObjectPageLayout`
            )->a( n = `upperCaseAnchorBar` v = `false`

            )->open( `headerTitle`
                )->leaf( `ObjectPageHeader`
                    )->a( n = `objectTitle` v = `Expand/Collapse sample`

            )->shut(
            )->open( `sections`
                )->open( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `All examples`

                    )->open( `subSections`
                        )->open( `ObjectPageSubSection`
                            )->a( n = `title`          v = `No Expand/Collapse`
                            )->a( n = `mode`           v = `Expanded`
                            )->a( n = `titleUppercase` v = `false`

                            )->open( `blocks`
                            )->open( n = `SimpleForm` ns = `forms`
                                )->a( n = `title`    v = `Location`
                                )->a( n = `editable` v = `false`
                                )->a( n = `layout`   v = `ColumnLayout`

                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `Country`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = `France`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `Subsidiary`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = `SAP France`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `Building`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = `LVL B`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `Room`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = `AppHaus`

                            )->shut(
                            )->open( n = `SimpleForm` ns = `forms`
                                )->a( n = `title`    v = `Location`
                                )->a( n = `editable` v = `false`
                                )->a( n = `layout`   v = `ColumnLayout`

                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `Country`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = `France`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `Subsidiary`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = `SAP France`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `Building`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = `LVL B`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `Room`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = `AppHaus`

                            )->shut(
                            )->shut(
                        )->shut(
                        )->open( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Collapsed by default`
                            )->a( n = `titleUppercase` v = `false`

                            )->open( `blocks`
                            )->open( n = `SimpleForm` ns = `forms`
                                )->a( n = `title`    v = `Location`
                                )->a( n = `editable` v = `false`
                                )->a( n = `layout`   v = `ColumnLayout`

                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `Country`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = `France`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `Subsidiary`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = `SAP France`

                            )->shut(
                            )->open( n = `SimpleForm` ns = `forms`
                                )->a( n = `title`    v = `Location`
                                )->a( n = `editable` v = `false`
                                )->a( n = `layout`   v = `ColumnLayout`

                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `Country`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = `France`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `Subsidiary`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = `SAP France`

                            )->shut(
                            )->shut(
                            )->open( `moreBlocks`
                            )->open( n = `SimpleForm` ns = `forms`
                                )->a( n = `title`    v = `Location`
                                )->a( n = `editable` v = `false`
                                )->a( n = `layout`   v = `ColumnLayout`

                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `Country`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = `France`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `Subsidiary`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = `SAP France`

                            )->shut(
                            )->open( n = `SimpleForm` ns = `forms`
                                )->a( n = `title`    v = `Location`
                                )->a( n = `editable` v = `false`
                                )->a( n = `layout`   v = `ColumnLayout`

                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `Country`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = `France`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `Subsidiary`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = `SAP France`

                            )->shut(
                            )->shut(
                        )->shut(
                        )->open( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Expanded by default`
                            )->a( n = `mode`           v = `Expanded`
                            )->a( n = `titleUppercase` v = `false`

                            )->open( `blocks`
                            )->open( n = `SimpleForm` ns = `forms`
                                )->a( n = `title`    v = `Location`
                                )->a( n = `editable` v = `false`
                                )->a( n = `layout`   v = `ColumnLayout`

                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `Country`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = `France`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `Subsidiary`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = `SAP France`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `Building`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = `LVL B`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `Room`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = `AppHaus`

                            )->shut(
                            )->open( n = `SimpleForm` ns = `forms`
                                )->a( n = `title`    v = `Location`
                                )->a( n = `editable` v = `false`
                                )->a( n = `layout`   v = `ColumnLayout`

                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `Country`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = `France`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `Subsidiary`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = `SAP France`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `Building`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = `LVL B`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `Room`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = `AppHaus`

                            )->shut(
                            )->shut(
                            )->open( `moreBlocks`
                            )->open( n = `SimpleForm` ns = `forms`
                                )->a( n = `title`    v = `Location`
                                )->a( n = `editable` v = `false`
                                )->a( n = `layout`   v = `ColumnLayout`

                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `Country`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = `France`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `Subsidiary`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = `SAP France`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `Building`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = `LVL B`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `Room`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = `AppHaus`

                            )->shut(
                            )->open( n = `SimpleForm` ns = `forms`
                                )->a( n = `title`    v = `Location`
                                )->a( n = `editable` v = `false`
                                )->a( n = `layout`   v = `ColumnLayout`

                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `Country`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = `France`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `Subsidiary`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = `SAP France`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `Building`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = `LVL B`
                                )->leaf( n = `Label` ns = `m`
                                    )->a( n = `text` v = `Room`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = `AppHaus`

                            )->shut(
                            )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
