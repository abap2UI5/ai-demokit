" @keywords flexbox flex box sap.m flexboxbasicalignment vbox panel button
" @summary Flex Box items can be placed in different areas using the justifyContent and alignItem properties.
CLASS z2ui5_cl_smpc_app_392 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_392 IMPLEMENTATION.

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

        )->ele( `VBox`
            )->ele( `Panel`
                )->a( n = `headerText` v = `Upper left`

                )->ele( `FlexBox`
                    )->a( n = `height`         v = `100px`
                    )->a( n = `alignItems`     v = `Start`
                    )->a( n = `justifyContent` v = `Start`

                    )->tag( `Button`
                        )->a( n = `text`  v = `1`
                        )->a( n = `type`  v = `Emphasized`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`
                    )->tag( `Button`
                        )->a( n = `text`  v = `2`
                        )->a( n = `type`  v = `Reject`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`
                    )->tag( `Button`
                        )->a( n = `text` v = `3`
                        )->a( n = `type` v = `Accept`

                )->end(
            )->end(

            )->ele( `Panel`
                )->a( n = `headerText` v = `Upper center`

                )->ele( `FlexBox`
                    )->a( n = `height`         v = `100px`
                    )->a( n = `alignItems`     v = `Start`
                    )->a( n = `justifyContent` v = `Center`

                    )->tag( `Button`
                        )->a( n = `text`  v = `1`
                        )->a( n = `type`  v = `Emphasized`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`
                    )->tag( `Button`
                        )->a( n = `text`  v = `2`
                        )->a( n = `type`  v = `Reject`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`
                    )->tag( `Button`
                        )->a( n = `text` v = `3`
                        )->a( n = `type` v = `Accept`

                )->end(
            )->end(

            )->ele( `Panel`
                )->a( n = `headerText` v = `Upper right`

                )->ele( `FlexBox`
                    )->a( n = `height`         v = `100px`
                    )->a( n = `alignItems`     v = `Start`
                    )->a( n = `justifyContent` v = `End`

                    )->tag( `Button`
                        )->a( n = `text`  v = `1`
                        )->a( n = `type`  v = `Emphasized`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`
                    )->tag( `Button`
                        )->a( n = `text`  v = `2`
                        )->a( n = `type`  v = `Reject`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`
                    )->tag( `Button`
                        )->a( n = `text` v = `3`
                        )->a( n = `type` v = `Accept`

                )->end(
            )->end(

            )->ele( `Panel`
                )->a( n = `headerText` v = `Middle left`

                )->ele( `FlexBox`
                    )->a( n = `height`         v = `100px`
                    )->a( n = `alignItems`     v = `Center`
                    )->a( n = `justifyContent` v = `Start`

                    )->tag( `Button`
                        )->a( n = `text`  v = `1`
                        )->a( n = `type`  v = `Emphasized`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`
                    )->tag( `Button`
                        )->a( n = `text`  v = `2`
                        )->a( n = `type`  v = `Reject`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`
                    )->tag( `Button`
                        )->a( n = `text` v = `3`
                        )->a( n = `type` v = `Accept`

                )->end(
            )->end(

            )->ele( `Panel`
                )->a( n = `headerText` v = `Middle center`

                )->ele( `FlexBox`
                    )->a( n = `height`         v = `100px`
                    )->a( n = `alignItems`     v = `Center`
                    )->a( n = `justifyContent` v = `Center`

                    )->tag( `Button`
                        )->a( n = `text`  v = `1`
                        )->a( n = `type`  v = `Emphasized`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`
                    )->tag( `Button`
                        )->a( n = `text`  v = `2`
                        )->a( n = `type`  v = `Reject`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`
                    )->tag( `Button`
                        )->a( n = `text` v = `3`
                        )->a( n = `type` v = `Accept`

                )->end(
            )->end(

            )->ele( `Panel`
                )->a( n = `headerText` v = `Middle right`

                )->ele( `FlexBox`
                    )->a( n = `height`         v = `100px`
                    )->a( n = `alignItems`     v = `Center`
                    )->a( n = `justifyContent` v = `End`

                    )->tag( `Button`
                        )->a( n = `text`  v = `1`
                        )->a( n = `type`  v = `Emphasized`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`
                    )->tag( `Button`
                        )->a( n = `text`  v = `2`
                        )->a( n = `type`  v = `Reject`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`
                    )->tag( `Button`
                        )->a( n = `text` v = `3`
                        )->a( n = `type` v = `Accept`

                )->end(
            )->end(

            )->ele( `Panel`
                )->a( n = `headerText` v = `Lower left`

                )->ele( `FlexBox`
                    )->a( n = `height`         v = `100px`
                    )->a( n = `alignItems`     v = `End`
                    )->a( n = `justifyContent` v = `Start`

                    )->tag( `Button`
                        )->a( n = `text`  v = `1`
                        )->a( n = `type`  v = `Emphasized`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`
                    )->tag( `Button`
                        )->a( n = `text`  v = `2`
                        )->a( n = `type`  v = `Reject`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`
                    )->tag( `Button`
                        )->a( n = `text` v = `3`
                        )->a( n = `type` v = `Accept`

                )->end(
            )->end(

            )->ele( `Panel`
                )->a( n = `headerText` v = `Lower center`

                )->ele( `FlexBox`
                    )->a( n = `height`         v = `100px`
                    )->a( n = `alignItems`     v = `End`
                    )->a( n = `justifyContent` v = `Center`

                    )->tag( `Button`
                        )->a( n = `text`  v = `1`
                        )->a( n = `type`  v = `Emphasized`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`
                    )->tag( `Button`
                        )->a( n = `text`  v = `2`
                        )->a( n = `type`  v = `Reject`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`
                    )->tag( `Button`
                        )->a( n = `text` v = `3`
                        )->a( n = `type` v = `Accept`

                )->end(
            )->end(

            )->ele( `Panel`
                )->a( n = `headerText` v = `Lower right`

                )->ele( `FlexBox`
                    )->a( n = `height`         v = `100px`
                    )->a( n = `alignItems`     v = `End`
                    )->a( n = `justifyContent` v = `End`

                    )->tag( `Button`
                        )->a( n = `text`  v = `1`
                        )->a( n = `type`  v = `Emphasized`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`
                    )->tag( `Button`
                        )->a( n = `text`  v = `2`
                        )->a( n = `type`  v = `Reject`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`
                    )->tag( `Button`
                        )->a( n = `text` v = `3`
                        )->a( n = `type` v = `Accept`

                )->end(
            )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
