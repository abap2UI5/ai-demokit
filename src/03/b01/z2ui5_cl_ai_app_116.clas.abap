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

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.uxap`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:m`   v = `sap.m`
        )->a( n = `height`    v = `100%`

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
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = `Block content — the original uses custom JS view blocks (MultiViewBlock)`

                        )->shut(
                        )->shut(
                        )->open( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Collapsed by default`
                            )->a( n = `titleUppercase` v = `false`

                            )->open( `blocks`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text` v = `Second subsection block content`

                        )->shut(
                        )->shut(
                    )->shut(
                )->shut(
            )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
