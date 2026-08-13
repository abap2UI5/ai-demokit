CLASS z2ui5_cl_smpc_app_293 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_293 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " this view turns the usual namespace assignment around: sap.uxap is the
    " DEFAULT namespace and sap.m carries the m: prefix. structural-diff
    " compares the qualified control name, so every sap.m control here is
    " written with ns = `m` and the uxap ones with none
    view->open( n = `View` ns = `mvc`
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:m`   v = `sap.m`
        )->a( n = `xmlns`     v = `sap.uxap`

        )->open( `ObjectPageLayout`
            )->a( n = `id`                  v = `ObjectPageLayout`
            )->a( n = `upperCaseAnchorBar`  v = `false`

            )->open( `headerTitle`
                )->leaf( `ObjectPageHeader`
                    )->a( n = `objectTitle` v = `Subsection background transparency`

            )->shut(

            )->open( `sections`

                )->open( `ObjectPageSection`
                    )->a( n = `showTitle` v = `false`

                    )->open( `subSections`

                        )->open( `ObjectPageSubSection`
                            )->a( n = `title` v = `Subsection with transparent background:`
                            )->a( n = `class` v = `sapUxAPObjectPageSubSectionTransparentBackground`

                            )->open( `blocks`
                                )->open( n = `List` ns = `m`
                                    )->leaf( n = `StandardListItem` ns = `m`
                                        )->a( n = `title` v = `subsection content`

                                )->shut(
                            )->shut(
                        )->shut(

                        )->open( `ObjectPageSubSection`
                            )->a( n = `title` v = `Subsection with regular background:`

                            )->open( `blocks`
                                )->open( n = `List` ns = `m`
                                    )->leaf( n = `StandardListItem` ns = `m`
                                        )->a( n = `title` v = `subsection content` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
