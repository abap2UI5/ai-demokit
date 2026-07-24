CLASS z2ui5_cl_ai_app_158 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_158 IMPLEMENTATION.

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
                )->a( n = `headerText` v = `Gap`
                )->open( `FlexBox`
                    )->a( n = `alignItems` v = `Start`
                    )->a( n = `gap` v = `30px`
                    )->a( n = `width`      v = `170px`
                    )->a( n = `wrap`       v = `Wrap`
                    )->leaf( `Button`
                        )->a( n = `text` v = `1`
                        )->a( n = `type` v = `Emphasized`
                    )->leaf( `Button`
                        )->a( n = `text` v = `2`
                        )->a( n = `type` v = `Reject`
                    )->leaf( `Button`
                        )->a( n = `text` v = `3`
                        )->a( n = `type` v = `Accept`
                    )->leaf( `Button`
                        )->a( n = `text` v = `4`
                        )->a( n = `type` v = `Emphasized`
                    )->leaf( `Button`
                        )->a( n = `text` v = `5`
                        )->a( n = `type` v = `Reject`
                    )->leaf( `Button`
                        )->a( n = `text` v = `6`
                        )->a( n = `type` v = `Accept`
                    )->leaf( `Button`
                        )->a( n = `text` v = `7`
                        )->a( n = `type` v = `Emphasized`
                    )->leaf( `Button`
                        )->a( n = `text` v = `8`
                        )->a( n = `type` v = `Reject`
                    )->leaf( `Button`
                        )->a( n = `text` v = `9`
                        )->a( n = `type` v = `Accept`

                )->shut(
            )->shut(
            )->open( `Panel`
                )->a( n = `headerText` v = `Column gap`
                )->open( `FlexBox`
                    )->a( n = `alignItems` v = `Start`
                    )->a( n = `columnGap` v = `30px`
                    )->a( n = `width`      v = `170px`
                    )->a( n = `wrap`       v = `Wrap`
                    )->leaf( `Button`
                        )->a( n = `text` v = `1`
                        )->a( n = `type` v = `Emphasized`
                    )->leaf( `Button`
                        )->a( n = `text` v = `2`
                        )->a( n = `type` v = `Reject`
                    )->leaf( `Button`
                        )->a( n = `text` v = `3`
                        )->a( n = `type` v = `Accept`
                    )->leaf( `Button`
                        )->a( n = `text` v = `4`
                        )->a( n = `type` v = `Emphasized`
                    )->leaf( `Button`
                        )->a( n = `text` v = `5`
                        )->a( n = `type` v = `Reject`
                    )->leaf( `Button`
                        )->a( n = `text` v = `6`
                        )->a( n = `type` v = `Accept`
                    )->leaf( `Button`
                        )->a( n = `text` v = `7`
                        )->a( n = `type` v = `Emphasized`
                    )->leaf( `Button`
                        )->a( n = `text` v = `8`
                        )->a( n = `type` v = `Reject`
                    )->leaf( `Button`
                        )->a( n = `text` v = `9`
                        )->a( n = `type` v = `Accept`

                )->shut(
            )->shut(
            )->open( `Panel`
                )->a( n = `headerText` v = `Row gap`
                )->open( `FlexBox`
                    )->a( n = `alignItems` v = `Start`
                    )->a( n = `rowGap` v = `30px`
                    )->a( n = `width`      v = `100px`
                    )->a( n = `wrap`       v = `Wrap`
                    )->leaf( `Button`
                        )->a( n = `text` v = `1`
                        )->a( n = `type` v = `Emphasized`
                    )->leaf( `Button`
                        )->a( n = `text` v = `2`
                        )->a( n = `type` v = `Reject`
                    )->leaf( `Button`
                        )->a( n = `text` v = `3`
                        )->a( n = `type` v = `Accept`
                    )->leaf( `Button`
                        )->a( n = `text` v = `4`
                        )->a( n = `type` v = `Emphasized`
                    )->leaf( `Button`
                        )->a( n = `text` v = `5`
                        )->a( n = `type` v = `Reject`
                    )->leaf( `Button`
                        )->a( n = `text` v = `6`
                        )->a( n = `type` v = `Accept`
                    )->leaf( `Button`
                        )->a( n = `text` v = `7`
                        )->a( n = `type` v = `Emphasized`
                    )->leaf( `Button`
                        )->a( n = `text` v = `8`
                        )->a( n = `type` v = `Reject`
                    )->leaf( `Button`
                        )->a( n = `text` v = `9`
                        )->a( n = `type` v = `Accept`
 ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
