CLASS z2ui5_cl_dmo_app_392 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_dmo_app_392 IMPLEMENTATION.

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

        )->open( `VBox`
            )->open( `Panel`
                )->a( n = `headerText` v = `Upper left`

                )->open( `FlexBox`
                    )->a( n = `height`         v = `100px`
                    )->a( n = `alignItems`     v = `Start`
                    )->a( n = `justifyContent` v = `Start`

                    )->leaf( `Button`
                        )->a( n = `text`  v = `1`
                        )->a( n = `type`  v = `Emphasized`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`
                    )->leaf( `Button`
                        )->a( n = `text`  v = `2`
                        )->a( n = `type`  v = `Reject`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`
                    )->leaf( `Button`
                        )->a( n = `text` v = `3`
                        )->a( n = `type` v = `Accept`

                )->shut(
            )->shut(

            )->open( `Panel`
                )->a( n = `headerText` v = `Upper center`

                )->open( `FlexBox`
                    )->a( n = `height`         v = `100px`
                    )->a( n = `alignItems`     v = `Start`
                    )->a( n = `justifyContent` v = `Center`

                    )->leaf( `Button`
                        )->a( n = `text`  v = `1`
                        )->a( n = `type`  v = `Emphasized`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`
                    )->leaf( `Button`
                        )->a( n = `text`  v = `2`
                        )->a( n = `type`  v = `Reject`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`
                    )->leaf( `Button`
                        )->a( n = `text` v = `3`
                        )->a( n = `type` v = `Accept`

                )->shut(
            )->shut(

            )->open( `Panel`
                )->a( n = `headerText` v = `Upper right`

                )->open( `FlexBox`
                    )->a( n = `height`         v = `100px`
                    )->a( n = `alignItems`     v = `Start`
                    )->a( n = `justifyContent` v = `End`

                    )->leaf( `Button`
                        )->a( n = `text`  v = `1`
                        )->a( n = `type`  v = `Emphasized`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`
                    )->leaf( `Button`
                        )->a( n = `text`  v = `2`
                        )->a( n = `type`  v = `Reject`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`
                    )->leaf( `Button`
                        )->a( n = `text` v = `3`
                        )->a( n = `type` v = `Accept`

                )->shut(
            )->shut(

            )->open( `Panel`
                )->a( n = `headerText` v = `Middle left`

                )->open( `FlexBox`
                    )->a( n = `height`         v = `100px`
                    )->a( n = `alignItems`     v = `Center`
                    )->a( n = `justifyContent` v = `Start`

                    )->leaf( `Button`
                        )->a( n = `text`  v = `1`
                        )->a( n = `type`  v = `Emphasized`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`
                    )->leaf( `Button`
                        )->a( n = `text`  v = `2`
                        )->a( n = `type`  v = `Reject`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`
                    )->leaf( `Button`
                        )->a( n = `text` v = `3`
                        )->a( n = `type` v = `Accept`

                )->shut(
            )->shut(

            )->open( `Panel`
                )->a( n = `headerText` v = `Middle center`

                )->open( `FlexBox`
                    )->a( n = `height`         v = `100px`
                    )->a( n = `alignItems`     v = `Center`
                    )->a( n = `justifyContent` v = `Center`

                    )->leaf( `Button`
                        )->a( n = `text`  v = `1`
                        )->a( n = `type`  v = `Emphasized`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`
                    )->leaf( `Button`
                        )->a( n = `text`  v = `2`
                        )->a( n = `type`  v = `Reject`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`
                    )->leaf( `Button`
                        )->a( n = `text` v = `3`
                        )->a( n = `type` v = `Accept`

                )->shut(
            )->shut(

            )->open( `Panel`
                )->a( n = `headerText` v = `Middle right`

                )->open( `FlexBox`
                    )->a( n = `height`         v = `100px`
                    )->a( n = `alignItems`     v = `Center`
                    )->a( n = `justifyContent` v = `End`

                    )->leaf( `Button`
                        )->a( n = `text`  v = `1`
                        )->a( n = `type`  v = `Emphasized`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`
                    )->leaf( `Button`
                        )->a( n = `text`  v = `2`
                        )->a( n = `type`  v = `Reject`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`
                    )->leaf( `Button`
                        )->a( n = `text` v = `3`
                        )->a( n = `type` v = `Accept`

                )->shut(
            )->shut(

            )->open( `Panel`
                )->a( n = `headerText` v = `Lower left`

                )->open( `FlexBox`
                    )->a( n = `height`         v = `100px`
                    )->a( n = `alignItems`     v = `End`
                    )->a( n = `justifyContent` v = `Start`

                    )->leaf( `Button`
                        )->a( n = `text`  v = `1`
                        )->a( n = `type`  v = `Emphasized`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`
                    )->leaf( `Button`
                        )->a( n = `text`  v = `2`
                        )->a( n = `type`  v = `Reject`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`
                    )->leaf( `Button`
                        )->a( n = `text` v = `3`
                        )->a( n = `type` v = `Accept`

                )->shut(
            )->shut(

            )->open( `Panel`
                )->a( n = `headerText` v = `Lower center`

                )->open( `FlexBox`
                    )->a( n = `height`         v = `100px`
                    )->a( n = `alignItems`     v = `End`
                    )->a( n = `justifyContent` v = `Center`

                    )->leaf( `Button`
                        )->a( n = `text`  v = `1`
                        )->a( n = `type`  v = `Emphasized`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`
                    )->leaf( `Button`
                        )->a( n = `text`  v = `2`
                        )->a( n = `type`  v = `Reject`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`
                    )->leaf( `Button`
                        )->a( n = `text` v = `3`
                        )->a( n = `type` v = `Accept`

                )->shut(
            )->shut(

            )->open( `Panel`
                )->a( n = `headerText` v = `Lower right`

                )->open( `FlexBox`
                    )->a( n = `height`         v = `100px`
                    )->a( n = `alignItems`     v = `End`
                    )->a( n = `justifyContent` v = `End`

                    )->leaf( `Button`
                        )->a( n = `text`  v = `1`
                        )->a( n = `type`  v = `Emphasized`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`
                    )->leaf( `Button`
                        )->a( n = `text`  v = `2`
                        )->a( n = `type`  v = `Reject`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`
                    )->leaf( `Button`
                        )->a( n = `text` v = `3`
                        )->a( n = `type` v = `Accept`

                )->shut(
            )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
