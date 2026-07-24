CLASS z2ui5_cl_ai_app_184 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_184 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " Block->content inlining (app 178/161 precedent, CAPABILITIES 'Custom BlockBase
    " blocks in a sap.uxap.ObjectPageLayout'): the original blocks aggregations each
    " hold a custom BlockBase control blockcolor:BlockBlueT1..T5 (from the sample's
    " SharedBlocks JS). A BlockBase is only a lazy-loading wrapper around a view; each
    " block's content is a single coloured div. Since ObjectPageSubSection.blocks
    " accepts any sap.ui.core.Control, each block is inlined here as a core:HTML leaf
    " carrying that div - thin frontend preserved, no custom JS control needed.
    view->open( n = `View` ns = `mvc`
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns`      v = `sap.uxap`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:m`    v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->open( `ObjectPageLayout`
            )->a( n = `id`                 v = `ObjectPageLayout`
            )->a( n = `upperCaseAnchorBar` v = `false`

            )->open( `headerTitle`
                )->leaf( `ObjectPageHeader`
                    )->a( n = `objectTitle` v = `Section sample`

            )->shut(

            )->open( `headerContent`
                )->leaf( n = `ObjectAttribute` ns = `m`
                    )->a( n = `title` v = ``
                    )->a( n = `text`  v = `This example explains the rules for the rendering of sections`

            )->shut(

            )->open( `sections`
                )->open( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `Section 1`

                    )->open( `subSections`
                        )->open( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Subsection 1.1`
                            )->a( n = `titleUppercase` v = `false`

                            )->open( `blocks`
                                )->leaf( n = `HTML` ns = `core`
                                    )->a( n = `content` v = `<div style="height:auto;min-height:4em; background-color: #A9EAFF ;line-height: 4em;">The title of the first section is not shown in the page but it is` &&
                                        ` shown in the AnchorBar. Subsection titles are displayed.</div>`

                            )->shut(
                        )->shut(

                        )->open( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Subsection 1.2`
                            )->a( n = `titleUppercase` v = `false`

                            )->open( `blocks`
                                )->leaf( n = `HTML` ns = `core`
                                    )->a( n = `content` v = `<div style="height:auto;min-height:4em; background-color: #A9EAFF ;line-height: 4em;">If there are several Subsections in a section, the subsection names are` &&
                                        ` displayed in a popup when clicking the section name in the AnchorBar.</div>`

                            )->shut(
                        )->shut(
                    )->shut(
                )->shut(

                )->leaf( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `Section 2`

                )->open( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `Section 3`

                    )->open( `subSections`
                        )->open( `ObjectPageSubSection`
                            )->a( n = `titleUppercase` v = `false`

                            )->open( `blocks`
                                )->leaf( n = `HTML` ns = `core`
                                    )->a( n = `content` v = `<div style="height:auto;min-height:4em; background-color: #A9EAFF ;line-height: 4em;">Section 2 is empty and is not displayed between section 1 and section 3.</div>`

                            )->shut(
                        )->shut(
                    )->shut(
                )->shut(

                )->open( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `Section 4`

                    )->open( `subSections`
                        )->open( `ObjectPageSubSection`
                            )->a( n = `titleUppercase` v = `false`

                            )->open( `blocks`
                                )->leaf( n = `HTML` ns = `core`
                                    )->a( n = `content` v = `<div style="height:auto;min-height:4em; background-color: #A9EAFF ;line-height: 4em;">Single Subsections are promoted to section.</div>`

                            )->shut(
                        )->shut(
                    )->shut(
                )->shut(

                )->open( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `Section 5`

                    )->open( `subSections`
                        )->open( `ObjectPageSubSection`
                            )->a( n = `titleUppercase` v = `false`

                            )->open( `blocks`
                                )->leaf( n = `HTML` ns = `core`
                                    )->a( n = `content` v = `<div style="height:auto;min-height:4em; background-color: #A9EAFF ;line-height: 4em;">Single Subsections are promoted to section. When they do not have a name, the section name is used.</div>`

        )->shut(
        )->shut(
        )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
