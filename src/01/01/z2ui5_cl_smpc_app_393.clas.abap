" @keywords flexbox flex box sap.m flexboxdirectionorder vbox panel button flexitemdata
" @summary You can influence the direction and order of elements in horizontal and vertical Flex Box controls with the direction property.
CLASS z2ui5_cl_smpc_app_393 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_393 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`

        )->ele( `VBox`
            )->ele( `Panel`
                )->a( n = `headerText` v = `Reverse, horizontal`

                )->ele( `FlexBox`
                    )->a( n = `direction`  v = `RowReverse`
                    )->a( n = `alignItems` v = `Start`

                    )->tag( `Button`
                        )->a( n = `text` v = `1`
                        )->a( n = `type` v = `Emphasized`
                    )->tag( `Button`
                        )->a( n = `text` v = `2`
                        )->a( n = `type` v = `Reject`
                    )->tag( `Button`
                        )->a( n = `text` v = `3`
                        )->a( n = `type` v = `Accept`

                )->end(
            )->end(

            )->ele( `Panel`
                )->a( n = `headerText` v = `Top to bottom, vertical`

                )->ele( `FlexBox`
                    )->a( n = `direction`  v = `Column`
                    )->a( n = `alignItems` v = `Start`

                    )->tag( `Button`
                        )->a( n = `text` v = `1`
                        )->a( n = `type` v = `Emphasized`
                    )->tag( `Button`
                        )->a( n = `text` v = `2`
                        )->a( n = `type` v = `Reject`
                    )->tag( `Button`
                        )->a( n = `text` v = `3`
                        )->a( n = `type` v = `Accept`

                )->end(
            )->end(

            )->ele( `Panel`
                )->a( n = `headerText` v = `Bottom to top, reverse vertical`

                )->ele( `FlexBox`
                    )->a( n = `direction`  v = `ColumnReverse`
                    )->a( n = `alignItems` v = `Start`

                    )->tag( `Button`
                        )->a( n = `text` v = `1`
                        )->a( n = `type` v = `Emphasized`
                    )->tag( `Button`
                        )->a( n = `text` v = `2`
                        )->a( n = `type` v = `Reject`
                    )->tag( `Button`
                        )->a( n = `text` v = `3`
                        )->a( n = `type` v = `Accept`

                )->end(
            )->end(

            )->ele( `Panel`
                )->a( n = `headerText` v = `Arbitrary flex item order`

                )->ele( `FlexBox`
                    )->a( n = `alignItems` v = `Start`

                    )->ele( `Button`
                        )->a( n = `text`  v = `1`
                        )->a( n = `type`  v = `Emphasized`
                        )->a( n = `class` v = `sapUiTinyMarginEnd`

                        )->ele( `layoutData`
                            )->tag( `FlexItemData`
                                )->a( n = `order` v = `2`

                        )->end(
                    )->end(
                    )->ele( `Button`
                        )->a( n = `text`  v = `2`
                        )->a( n = `type`  v = `Reject`
                        )->a( n = `class` v = `sapUiTinyMarginEnd`

                        )->ele( `layoutData`
                            )->tag( `FlexItemData`
                                )->a( n = `order` v = `3`

                        )->end(
                    )->end(
                    )->ele( `Button`
                        )->a( n = `text`  v = `3`
                        )->a( n = `type`  v = `Accept`
                        )->a( n = `class` v = `sapUiTinyMarginEnd`

                        )->ele( `layoutData`
                            )->tag( `FlexItemData`
                                )->a( n = `order` v = `1` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
