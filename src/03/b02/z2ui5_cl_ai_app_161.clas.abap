CLASS z2ui5_cl_ai_app_161 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_161 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " Wall-break: the original blocks aggregation holds a custom BlockBase
    " control (sap.uxap.sample.SharedBlocks.BlockBlue). A BlockBase is only a
    " lazy-loading wrapper around a view; its Expanded content here is a single
    " coloured div. Since ObjectPageSubSection.blocks accepts any
    " sap.ui.core.Control, we inline that content directly as core:HTML -
    " no custom JS control needed, thin frontend preserved.
    view->open( n = `View` ns = `mvc`
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns`      v = `sap.uxap`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->open( `ObjectPageLayout`
            )->a( n = `id` v = `ObjectPageLayout`

            )->open( `headerTitle`
                )->leaf( `ObjectPageHeader`
                    )->a( n = `objectTitle` v = `Single View`

            )->shut(

            )->open( `sections`
                )->open( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `example`
                    )->open( `subSections`
                        )->open( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Example`
                            )->a( n = `titleUppercase` v = `false`
                            )->open( `blocks`
                                )->leaf( n = `HTML` ns = `core`
                                    )->a( n = `content` v = `<div style="height:4em; background-color: #A9EAFF ;"></div>` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
