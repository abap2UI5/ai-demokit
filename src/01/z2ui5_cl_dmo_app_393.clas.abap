CLASS z2ui5_cl_dmo_app_393 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_dmo_app_393 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`

        )->open( `VBox`
            )->open( `Panel`
                )->a( n = `headerText` v = `Reverse, horizontal`

                )->open( `FlexBox`
                    )->a( n = `direction`  v = `RowReverse`
                    )->a( n = `alignItems` v = `Start`

                    )->leaf( `Button`
                        )->a( n = `text` v = `1`
                        )->a( n = `type` v = `Emphasized`
                    )->leaf( `Button`
                        )->a( n = `text` v = `2`
                        )->a( n = `type` v = `Reject`
                    )->leaf( `Button`
                        )->a( n = `text` v = `3`
                        )->a( n = `type` v = `Accept`

                )->shut(
            )->shut(

            )->open( `Panel`
                )->a( n = `headerText` v = `Top to bottom, vertical`

                )->open( `FlexBox`
                    )->a( n = `direction`  v = `Column`
                    )->a( n = `alignItems` v = `Start`

                    )->leaf( `Button`
                        )->a( n = `text` v = `1`
                        )->a( n = `type` v = `Emphasized`
                    )->leaf( `Button`
                        )->a( n = `text` v = `2`
                        )->a( n = `type` v = `Reject`
                    )->leaf( `Button`
                        )->a( n = `text` v = `3`
                        )->a( n = `type` v = `Accept`

                )->shut(
            )->shut(

            )->open( `Panel`
                )->a( n = `headerText` v = `Bottom to top, reverse vertical`

                )->open( `FlexBox`
                    )->a( n = `direction`  v = `ColumnReverse`
                    )->a( n = `alignItems` v = `Start`

                    )->leaf( `Button`
                        )->a( n = `text` v = `1`
                        )->a( n = `type` v = `Emphasized`
                    )->leaf( `Button`
                        )->a( n = `text` v = `2`
                        )->a( n = `type` v = `Reject`
                    )->leaf( `Button`
                        )->a( n = `text` v = `3`
                        )->a( n = `type` v = `Accept`

                )->shut(
            )->shut(

            )->open( `Panel`
                )->a( n = `headerText` v = `Arbitrary flex item order`

                )->open( `FlexBox`
                    )->a( n = `alignItems` v = `Start`

                    )->open( `Button`
                        )->a( n = `text`  v = `1`
                        )->a( n = `type`  v = `Emphasized`
                        )->a( n = `class` v = `sapUiTinyMarginEnd`

                        )->open( `layoutData`
                            )->leaf( `FlexItemData`
                                )->a( n = `order` v = `2`

                        )->shut(
                    )->shut(
                    )->open( `Button`
                        )->a( n = `text`  v = `2`
                        )->a( n = `type`  v = `Reject`
                        )->a( n = `class` v = `sapUiTinyMarginEnd`

                        )->open( `layoutData`
                            )->leaf( `FlexItemData`
                                )->a( n = `order` v = `3`

                        )->shut(
                    )->shut(
                    )->open( `Button`
                        )->a( n = `text`  v = `3`
                        )->a( n = `type`  v = `Accept`
                        )->a( n = `class` v = `sapUiTinyMarginEnd`

                        )->open( `layoutData`
                            )->leaf( `FlexItemData`
                                )->a( n = `order` v = `1` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
