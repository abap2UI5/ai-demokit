" @keywords flexiblecolumnlayout flexible column layout sap.f flexiblecolumnlayoutlandmarkinfoarrow flexiblecolumnlayoutaccessiblelandmarkinfo button vbox
" @summary Flexible Column Layout where the all the arrows have custom Landmark Info
CLASS z2ui5_cl_smpc_app_450 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA layout TYPE string VALUE `OneColumn`.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_450 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    " the three column views (List/Detail/DetailDetail) are inlined into one view;
    " the original's nested mvc:XMLView reference in beginColumnPages is dropped
    " (app 234 precedent)
    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:f`      v = `sap.f`
        )->a( n = `displayBlock` v = `true`
        )->a( n = `height`       v = `100%`

        " the controller's setLayout( ) calls become one two-way bound layout property
        )->ele( n = `FlexibleColumnLayout` ns = `f`
            )->a( n = `id`     v = `fcl`
            )->a( n = `layout` v = client->_bind( layout )

            )->ele( n = `landmarkInfo` ns = `f`
                )->tag( n = `FlexibleColumnLayoutAccessibleLandmarkInfo` ns = `f`
                    )->a( n = `firstColumnBackArrowLabel`     v = `Custom Label For First Column Back Arrow`
                    )->a( n = `middleColumnForwardArrowLabel` v = `Custom Label For Middle Column Forward Arrow`
                    )->a( n = `middleColumnBackArrowLabel`    v = `Custom Label For Middle Column Back Arrow`
                    )->a( n = `lastColumnForwardArrowLabel`   v = `Custom Label For Last Column Forward Arrow`

            )->end(
            )->ele( n = `beginColumnPages` ns = `f`
                )->ele( `Page`
                    )->a( n = `id`    v = `listPage`
                    )->a( n = `title` v = `First Column`

                    )->tag( `Button`
                        )->a( n = `class` v = `sapUiTinyMargin`
                        )->a( n = `text`  v = `Navigate to Middle Column`
                        )->a( n = `press` v = client->_event( `SET_DETAIL_PAGE` )

                )->end(
            )->end(

            )->ele( n = `midColumnPages` ns = `f`
                )->ele( `Page`
                    )->a( n = `id`               v = `detailPage`
                    )->a( n = `title`            v = `Middle Column`
                    )->a( n = `backgroundDesign` v = `Transparent`

                    )->ele( `VBox`
                        )->tag( `Button`
                            )->a( n = `class` v = `sapUiTinyMargin`
                            )->a( n = `text`  v = `Navigate To First Column`
                            )->a( n = `press` v = client->_event( `SET_LIST_PAGE` )
                        )->tag( `Button`
                            )->a( n = `class` v = `sapUiTinyMargin`
                            )->a( n = `text`  v = `Navigate To Last Column`
                            )->a( n = `press` v = client->_event( `SET_DETAIL_DETAIL_PAGE` )

                    )->end(
                )->end(
            )->end(

            )->ele( n = `endColumnPages` ns = `f`
                )->ele( `Page`
                    )->a( n = `id`               v = `detailDetailPage`
                    )->a( n = `title`            v = `Last Column`
                    )->a( n = `backgroundDesign` v = `Transparent`

                    )->tag( `Button`
                        )->a( n = `class` v = `sapUiTinyMargin`
                        )->a( n = `text`  v = `Navigate to Middle Column`
                        )->a( n = `press` v = client->_event( `SET_DETAIL_PAGE` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `SET_LIST_PAGE`.
        layout = `OneColumn`.

      WHEN `SET_DETAIL_PAGE`.
        layout = `TwoColumnsMidExpanded`.

      WHEN `SET_DETAIL_DETAIL_PAGE`.
        layout = `ThreeColumnsEndExpanded`.

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
