CLASS z2ui5_cl_ai_app_178 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_178 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " Wall-break: the original blocks aggregation holds a custom BlockBase
    " control (blockcolor:BlockBlue from the sample's SharedBlocks JS). A
    " BlockBase is only a lazy-loading wrapper around a view; BlockBlue's
    " content is a single coloured div. Since ObjectPageSubSection.blocks
    " accepts any sap.ui.core.Control, that content is inlined here as
    " core:HTML - no custom JS control needed, thin frontend preserved.
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
                    )->a( n = `objectTitle` v = `Action buttons sample`

            )->shut(

            )->open( `sections`
                )->open( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `examples`

                    )->open( `subSections`
                        )->open( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Subsection with action buttons`
                            )->a( n = `titleUppercase` v = `false`

                            )->open( `blocks`
                                )->leaf( n = `HTML` ns = `core`
                                    )->a( n = `content` v = `<div style="height:4em; background-color: #A9EAFF ;"></div>`

                            )->shut(

                            )->open( `actions`
                                )->leaf( n = `Button` ns = `m`
                                    )->a( n = `icon` v = `sap-icon://synchronize`
                                )->leaf( n = `Button` ns = `m`
                                    )->a( n = `icon` v = `sap-icon://expand`

                            )->shut(
                        )->shut(

                        )->open( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Subsection without action buttons`
                            )->a( n = `titleUppercase` v = `false`

                            )->open( `blocks`
                                )->leaf( n = `HTML` ns = `core`
                                    )->a( n = `content` v = `<div style="height:4em; background-color: #A9EAFF ;"></div>`

                            )->shut(
                        )->shut(
                    )->shut(
                )->shut(

                )->open( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `examples 2`

                    )->open( `subSections`
                        )->open( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Single subsection with action buttons`
                            )->a( n = `titleUppercase` v = `false`

                            )->open( `blocks`
                                )->leaf( n = `HTML` ns = `core`
                                    )->a( n = `content` v = `<div style="height:4em; background-color: #A9EAFF ;"></div>`

                            )->shut(

                            )->open( `actions`
                                )->leaf( n = `Button` ns = `m`
                                    )->a( n = `icon` v = `sap-icon://synchronize`
                                )->leaf( n = `Button` ns = `m`
                                    )->a( n = `icon` v = `sap-icon://expand` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
