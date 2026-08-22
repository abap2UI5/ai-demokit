" @keywords flexbox flex box sap.m flexboxsizeadjustments vbox panel button flexitemdata
" @summary Automatic size adjustments can be achieved for Flex Items with the use of Flex Item Data settings on the contained controls.
CLASS z2ui5_cl_smpc_app_514 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_514 IMPLEMENTATION.

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
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        " the sample's style.css, injected via a core:HTML content attribute (see
        " CAPABILITIES.md) - the dashed flex-item frame and the zero-width variant.
        " Literal braces are escaped \{ \} in a backtick literal
        )->tag( n = `HTML` ns = `core`
            )->a( n = `content` v = `<style>` &&
                                    `.sapUiDemoFlexBoxSizeAdjustments .sapMFlexItem\{border:1px dashed #000; margin:0.1875rem; padding:0.1875rem\}` &&
                                    `.sapUiDemoFlexBoxSizeAdjustmentsZeroWidthItems .sapMFlexItem\{width:0\}` &&
                                    `</style>`

        )->ele( `VBox`

            )->ele( `Panel`
                )->a( n = `headerText` v = `Equal flexibility and content`
                )->a( n = `class`      v = `sapUiDemoFlexBoxSizeAdjustments`

                )->ele( `FlexBox`
                    )->a( n = `alignItems` v = `Start`

                    )->ele( `Button`
                        )->a( n = `text`  v = `1`
                        )->a( n = `width` v = `100%`
                        )->a( n = `type`  v = `Emphasized`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`

                        )->ele( `layoutData`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                        )->end(
                    )->end(

                    )->ele( `Button`
                        )->a( n = `text`  v = `2`
                        )->a( n = `width` v = `100%`
                        )->a( n = `type`  v = `Reject`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`

                        )->ele( `layoutData`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                        )->end(
                    )->end(

                    )->ele( `Button`
                        )->a( n = `text`  v = `3`
                        )->a( n = `width` v = `100%`
                        )->a( n = `type`  v = `Accept`

                        )->ele( `layoutData`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                        )->end(
                    )->end(
                )->end(
            )->end(

            )->ele( `Panel`
                )->a( n = `headerText` v = `Different flexibility, equal content`
                )->a( n = `class`      v = `sapUiDemoFlexBoxSizeAdjustments`

                )->ele( `FlexBox`
                    )->a( n = `alignItems` v = `Start`

                    )->ele( `Button`
                        )->a( n = `text`  v = `1`
                        )->a( n = `width` v = `100%`
                        )->a( n = `type`  v = `Emphasized`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`

                        )->ele( `layoutData`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                        )->end(
                    )->end(

                    )->ele( `Button`
                        )->a( n = `text`  v = `2`
                        )->a( n = `width` v = `100%`
                        )->a( n = `type`  v = `Reject`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`

                        )->ele( `layoutData`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `2`

                        )->end(
                    )->end(

                    )->ele( `Button`
                        )->a( n = `text`  v = `3`
                        )->a( n = `width` v = `100%`
                        )->a( n = `type`  v = `Accept`

                        )->ele( `layoutData`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `3`

                        )->end(
                    )->end(
                )->end(
            )->end(

            )->ele( `Panel`
                )->a( n = `headerText` v = `Equal flexibility, different content`
                )->a( n = `class`      v = `sapUiDemoFlexBoxSizeAdjustments`

                )->ele( `FlexBox`
                    )->a( n = `alignItems` v = `Start`

                    )->ele( `Button`
                        )->a( n = `text`  v = `1`
                        )->a( n = `width` v = `50px`
                        )->a( n = `type`  v = `Emphasized`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`

                        )->ele( `layoutData`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                        )->end(
                    )->end(

                    )->ele( `Button`
                        )->a( n = `text`  v = `2`
                        )->a( n = `width` v = `100px`
                        )->a( n = `type`  v = `Reject`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`

                        )->ele( `layoutData`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                        )->end(
                    )->end(

                    )->ele( `Button`
                        )->a( n = `text`  v = `3`
                        )->a( n = `width` v = `150px`
                        )->a( n = `type`  v = `Accept`

                        )->ele( `layoutData`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                        )->end(
                    )->end(
                )->end(
            )->end(

            )->ele( `Panel`
                )->a( n = `headerText` v = `Equal flexibility, different content, width 0`
                )->a( n = `class`      v = `sapUiDemoFlexBoxSizeAdjustments`

                )->ele( `FlexBox`
                    )->a( n = `alignItems` v = `Start`
                    )->a( n = `class`      v = `sapUiDemoFlexBoxSizeAdjustmentsZeroWidthItems`

                    )->ele( `Button`
                        )->a( n = `text`  v = `1`
                        )->a( n = `width` v = `100%`
                        )->a( n = `type`  v = `Emphasized`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`

                        )->ele( `layoutData`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                        )->end(
                    )->end(

                    )->ele( `Button`
                        )->a( n = `text`  v = `2`
                        )->a( n = `width` v = `100%`
                        )->a( n = `type`  v = `Reject`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`

                        )->ele( `layoutData`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                        )->end(
                    )->end(

                    )->ele( `Button`
                        )->a( n = `text`  v = `3`
                        )->a( n = `width` v = `100%`
                        )->a( n = `type`  v = `Accept`

                        )->ele( `layoutData`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                        )->end(
                    )->end(
                )->end(
            )->end(

            )->ele( `Panel`
                )->a( n = `headerText` v = `Different flexibility and content, width 0`
                )->a( n = `class`      v = `sapUiDemoFlexBoxSizeAdjustments`

                )->ele( `FlexBox`
                    )->a( n = `alignItems` v = `Start`
                    )->a( n = `class`      v = `sapUiDemoFlexBoxSizeAdjustmentsZeroWidthItems`

                    )->ele( `Button`
                        )->a( n = `text`  v = `1`
                        )->a( n = `width` v = `50px`
                        )->a( n = `type`  v = `Emphasized`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`

                        )->ele( `layoutData`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                        )->end(
                    )->end(

                    )->ele( `Button`
                        )->a( n = `text`  v = `2`
                        )->a( n = `width` v = `100px`
                        )->a( n = `type`  v = `Reject`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`

                        )->ele( `layoutData`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                        )->end(
                    )->end(

                    )->ele( `Button`
                        )->a( n = `text`  v = `3`
                        )->a( n = `width` v = `150px`
                        )->a( n = `type`  v = `Accept`

                        )->ele( `layoutData`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                        )->end(
                    )->end(
 ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
