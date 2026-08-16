" @keywords objectpagelayout object layout sap.uxap anchorbarnopopover objectpagedynamicheadertitle objectpagesection objectpagesubsection
" @summary This example shows how to change the default behavior in order to be able to navigate to sections instead of subsections, using the Anchor Bar
CLASS z2ui5_cl_smpc_app_187 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_187 IMPLEMENTATION.

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

    " Block->content inlining (app 178/161 precedent): the original blocks
    " aggregations each hold a custom BlockBase control blockcolor:BlockBlue
    " (from the sample's SharedBlocks JS). A BlockBase is only a lazy-loading
    " wrapper around a view; BlockBlue's content is a single coloured div.
    " Since ObjectPageSubSection.blocks accepts any sap.ui.core.Control, each
    " blockcolor:BlockBlue is inlined here as a core:HTML div - no custom JS
    " control needed, thin frontend preserved.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns`      v = `sap.uxap`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:m`    v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->ele( `ObjectPageLayout`
            )->a( n = `id`                   v = `ObjectPageLayout`
            )->a( n = `showAnchorBarPopover` v = `false`
            )->a( n = `upperCaseAnchorBar`   v = `false`

            )->ele( `headerTitle`
                )->ele( `ObjectPageDynamicHeaderTitle`

                    )->ele( `heading`
                        )->tag( n = `Title` ns = `m`
                            )->a( n = `text` v = `Navigation to sections`

                    )->end(

                    )->ele( `snappedTitleOnMobile`
                        )->tag( n = `Title` ns = `m`
                            )->a( n = `text` v = `Navigation to sections`

                    )->end(

                    )->ele( `actions`
                        )->tag( n = `Button` ns = `m`
                            )->a( n = `text` v = `Edit`
                            )->a( n = `type` v = `Emphasized`
                        )->tag( n = `Button` ns = `m`
                            )->a( n = `type` v = `Transparent`
                            )->a( n = `text` v = `Delete`
                        )->tag( n = `Button` ns = `m`
                            )->a( n = `type` v = `Transparent`
                            )->a( n = `text` v = `Copy`
                        )->tag( n = `OverflowToolbarButton` ns = `m`
                            )->a( n = `icon`    v = `sap-icon://action`
                            )->a( n = `type`    v = `Transparent`
                            )->a( n = `text`    v = `Share`
                            )->a( n = `tooltip` v = `action`

                    )->end(
                )->end(
            )->end(

            )->ele( `headerContent`
                )->tag( n = `Title` ns = `m`
                    )->a( n = `text`       v = `This example shows how to change the default behavior in order to be able to navigate to sections instead of subsections, using the Anchor Bar`
                    )->a( n = `titleStyle` v = `H6`

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
                                    )->a( n = `content` v = `<div style="height:4em; background-color: #A9EAFF ;"></div>`

                            )->end(
                        )->end(

                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Subsection 1.2`
                            )->a( n = `titleUppercase` v = `false`

                            )->ele( `blocks`
                                )->tag( n = `HTML` ns = `core`
                                    )->a( n = `content` v = `<div style="height:4em; background-color: #A9EAFF ;"></div>`

                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `Section 2`

                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Subsection 2.1`
                            )->a( n = `titleUppercase` v = `false`

                            )->ele( `blocks`
                                )->tag( n = `HTML` ns = `core`
                                    )->a( n = `content` v = `<div style="height:4em; background-color: #A9EAFF ;"></div>`

                            )->end(
                        )->end(

                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Subsection 2.2`
                            )->a( n = `titleUppercase` v = `false`

                            )->ele( `blocks`
                                )->tag( n = `HTML` ns = `core`
                                    )->a( n = `content` v = `<div style="height:4em; background-color: #A9EAFF ;"></div>` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
