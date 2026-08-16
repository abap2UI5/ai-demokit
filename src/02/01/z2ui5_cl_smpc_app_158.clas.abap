" @keywords flexbox flex box sap.m gap vbox panel button
" @summary You can add gap between rows and columns.
CLASS z2ui5_cl_smpc_app_158 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_158 IMPLEMENTATION.

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

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`

        )->ele( `VBox`
            )->ele( `Panel`
                )->a( n = `headerText` v = `Gap`
                )->ele( `FlexBox`
                    )->a( n = `alignItems` v = `Start`
                    " gap is @since 1.134 - kept 1:1 (POST_171)
                    )->a( n = `gap` v = `30px`
                    )->a( n = `width`      v = `170px`
                    )->a( n = `wrap`       v = `Wrap`
                    )->tag( `Button`
                        )->a( n = `text` v = `1`
                        )->a( n = `type` v = `Emphasized`
                    )->tag( `Button`
                        )->a( n = `text` v = `2`
                        )->a( n = `type` v = `Reject`
                    )->tag( `Button`
                        )->a( n = `text` v = `3`
                        )->a( n = `type` v = `Accept`
                    )->tag( `Button`
                        )->a( n = `text` v = `4`
                        )->a( n = `type` v = `Emphasized`
                    )->tag( `Button`
                        )->a( n = `text` v = `5`
                        )->a( n = `type` v = `Reject`
                    )->tag( `Button`
                        )->a( n = `text` v = `6`
                        )->a( n = `type` v = `Accept`
                    )->tag( `Button`
                        )->a( n = `text` v = `7`
                        )->a( n = `type` v = `Emphasized`
                    )->tag( `Button`
                        )->a( n = `text` v = `8`
                        )->a( n = `type` v = `Reject`
                    )->tag( `Button`
                        )->a( n = `text` v = `9`
                        )->a( n = `type` v = `Accept`

                )->end(
            )->end(
            )->ele( `Panel`
                )->a( n = `headerText` v = `Column gap`
                )->ele( `FlexBox`
                    )->a( n = `alignItems` v = `Start`
                    " columnGap is @since 1.134 - kept 1:1 (POST_171)
                    )->a( n = `columnGap` v = `30px`
                    )->a( n = `width`      v = `170px`
                    )->a( n = `wrap`       v = `Wrap`
                    )->tag( `Button`
                        )->a( n = `text` v = `1`
                        )->a( n = `type` v = `Emphasized`
                    )->tag( `Button`
                        )->a( n = `text` v = `2`
                        )->a( n = `type` v = `Reject`
                    )->tag( `Button`
                        )->a( n = `text` v = `3`
                        )->a( n = `type` v = `Accept`
                    )->tag( `Button`
                        )->a( n = `text` v = `4`
                        )->a( n = `type` v = `Emphasized`
                    )->tag( `Button`
                        )->a( n = `text` v = `5`
                        )->a( n = `type` v = `Reject`
                    )->tag( `Button`
                        )->a( n = `text` v = `6`
                        )->a( n = `type` v = `Accept`
                    )->tag( `Button`
                        )->a( n = `text` v = `7`
                        )->a( n = `type` v = `Emphasized`
                    )->tag( `Button`
                        )->a( n = `text` v = `8`
                        )->a( n = `type` v = `Reject`
                    )->tag( `Button`
                        )->a( n = `text` v = `9`
                        )->a( n = `type` v = `Accept`

                )->end(
            )->end(
            )->ele( `Panel`
                )->a( n = `headerText` v = `Row gap`
                )->ele( `FlexBox`
                    )->a( n = `alignItems` v = `Start`
                    " rowGap is @since 1.134 - kept 1:1 (POST_171)
                    )->a( n = `rowGap` v = `30px`
                    )->a( n = `width`      v = `100px`
                    )->a( n = `wrap`       v = `Wrap`
                    )->tag( `Button`
                        )->a( n = `text` v = `1`
                        )->a( n = `type` v = `Emphasized`
                    )->tag( `Button`
                        )->a( n = `text` v = `2`
                        )->a( n = `type` v = `Reject`
                    )->tag( `Button`
                        )->a( n = `text` v = `3`
                        )->a( n = `type` v = `Accept`
                    )->tag( `Button`
                        )->a( n = `text` v = `4`
                        )->a( n = `type` v = `Emphasized`
                    )->tag( `Button`
                        )->a( n = `text` v = `5`
                        )->a( n = `type` v = `Reject`
                    )->tag( `Button`
                        )->a( n = `text` v = `6`
                        )->a( n = `type` v = `Accept`
                    )->tag( `Button`
                        )->a( n = `text` v = `7`
                        )->a( n = `type` v = `Emphasized`
                    )->tag( `Button`
                        )->a( n = `text` v = `8`
                        )->a( n = `type` v = `Reject`
                    )->tag( `Button`
                        )->a( n = `text` v = `9`
                        )->a( n = `type` v = `Accept`
 ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
