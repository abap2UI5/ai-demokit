" @keywords objectpagesubsection object sub section sap.uxap objectpagesubsectionbackground objectpagelayout objectpageheader objectpagesection list standardlistitem
" @summary This example uses the 'sapUxAPObjectPageSubSectionTransparentBackground' CSS class to set transparent background.
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
    IF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " this view turns the usual namespace assignment around: sap.uxap is the
    " DEFAULT namespace and sap.m carries the m: prefix. structural-diff
    " compares the qualified control name, so every sap.m control here is
    " written with ns = `m` and the uxap ones with none
    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:m`   v = `sap.m`
        )->a( n = `xmlns`     v = `sap.uxap`

        )->ele( `ObjectPageLayout`
            )->a( n = `id`                  v = `ObjectPageLayout`
            )->a( n = `upperCaseAnchorBar`  v = `false`

            )->ele( `headerTitle`
                )->tag( `ObjectPageHeader`
                    )->a( n = `objectTitle` v = `Subsection background transparency`

            )->end(

            )->ele( `sections`

                )->ele( `ObjectPageSection`
                    )->a( n = `showTitle` v = `false`

                    )->ele( `subSections`

                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title` v = `Subsection with transparent background:`
                            )->a( n = `class` v = `sapUxAPObjectPageSubSectionTransparentBackground`

                            )->ele( `blocks`
                                )->ele( n = `List` ns = `m`
                                    )->tag( n = `StandardListItem` ns = `m`
                                        )->a( n = `title` v = `subsection content`

                                )->end(
                            )->end(
                        )->end(

                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title` v = `Subsection with regular background:`

                            )->ele( `blocks`
                                )->ele( n = `List` ns = `m`
                                    )->tag( n = `StandardListItem` ns = `m`
                                        )->a( n = `title` v = `subsection content` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
