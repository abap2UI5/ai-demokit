" @keywords objectpagesection object section sap.uxap objectpagelayout objectpageheader objectattribute objectpagesubsection html
" @summary This example explains the rules for the rendering of sections
CLASS z2ui5_cl_smpc_app_184 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_184 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " Block->content inlining (app 178/161 precedent, CAPABILITIES 'Custom BlockBase
    " blocks in a sap.uxap.ObjectPageLayout'): the original blocks aggregations each
    " hold a custom BlockBase control blockcolor:BlockBlueT1..T5 (from the sample's
    " SharedBlocks JS). A BlockBase is only a lazy-loading wrapper around a view; each
    " block's content is a single coloured div. Since ObjectPageSubSection.blocks
    " accepts any sap.ui.core.Control, each block is inlined here as a core:HTML leaf
    " carrying that div - thin frontend preserved, no custom JS control needed.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns`      v = `sap.uxap`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:m`    v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->ele( `ObjectPageLayout`
            )->a( n = `id`                 v = `ObjectPageLayout`
            )->a( n = `upperCaseAnchorBar` v = `false`

            )->ele( `headerTitle`
                )->tag( `ObjectPageHeader`
                    )->a( n = `objectTitle` v = `Section sample`

            )->end(

            )->ele( `headerContent`
                )->tag( n = `ObjectAttribute` ns = `m`
                    )->a( n = `title` v = ``
                    )->a( n = `text`  v = `This example explains the rules for the rendering of sections`

            )->end(

            )->ele( `sections`
                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `Section 1`

                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Subsection 1.1`
                            )->a( n = `titleUppercase` v = `false`

                            )->ele( `blocks`
                                )->tag( n = `HTML` ns = `core`
                                    )->a( n = `content` v = `<div style="height:auto;min-height:4em; background-color: #A9EAFF ;line-height: 4em;">The title of the first section is not shown in the page but it is` &&
                                        ` shown in the AnchorBar. Subsection titles are displayed.</div>`

                            )->end(
                        )->end(

                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Subsection 1.2`
                            )->a( n = `titleUppercase` v = `false`

                            )->ele( `blocks`
                                )->tag( n = `HTML` ns = `core`
                                    )->a( n = `content` v = `<div style="height:auto;min-height:4em; background-color: #A9EAFF ;line-height: 4em;">If there are several Subsections in a section, the subsection names are` &&
                                        ` displayed in a popup when clicking the section name in the AnchorBar.</div>`

                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->tag( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `Section 2`

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `Section 3`

                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `titleUppercase` v = `false`

                            )->ele( `blocks`
                                )->tag( n = `HTML` ns = `core`
                                    )->a( n = `content` v = `<div style="height:auto;min-height:4em; background-color: #A9EAFF ;line-height: 4em;">Section 2 is empty and is not displayed between section 1 and section 3.</div>`

                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `Section 4`

                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `titleUppercase` v = `false`

                            )->ele( `blocks`
                                )->tag( n = `HTML` ns = `core`
                                    )->a( n = `content` v = `<div style="height:auto;min-height:4em; background-color: #A9EAFF ;line-height: 4em;">Single Subsections are promoted to section.</div>`

                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `Section 5`

                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `titleUppercase` v = `false`

                            )->ele( `blocks`
                                )->tag( n = `HTML` ns = `core`
                                    )->a( n = `content` v = `<div style="height:auto;min-height:4em; background-color: #A9EAFF ;line-height: 4em;">Single Subsections are promoted to section. When they do not have a name, the section name is used.</div>`

                            )->end(
                        )->end(
                    )->end(
                )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
