" @keywords flexbox flex box sap.m flexboxrendertype vbox panel button flexitemdata input
" @summary Flex items can be rendered differently. By default, they are wrapped in a div element. Optionally, the bare controls can be rendered directly. This can affect the resulting layout.
CLASS z2ui5_cl_smpc_app_190 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_190 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( `VBox`
            )->ele( `Panel`
                )->a( n = `headerText` v = `Render Type - Div`

                )->ele( `FlexBox`
                    )->a( n = `renderType` v = `Div`

                    )->ele( `Button`
                        )->a( n = `text`  v = `Some text`
                        )->a( n = `type`  v = `Emphasized`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`

                        )->ele( `layoutData`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `3`

                        )->end(
                    )->end(
                    )->ele( `Input`
                        )->a( n = `value` v = `Some value`
                        )->a( n = `width` v = `auto`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`

                        )->ele( `layoutData`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `2`

                        )->end(
                    )->end(
                    )->ele( `Button`
                        )->a( n = `icon` v = `sap-icon://download`

                        )->ele( `layoutData`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                        )->end(
                    )->end(
                )->end(
            )->end(
            )->ele( `Panel`
                )->a( n = `headerText` v = `Render Type - Bare`

                )->ele( `FlexBox`
                    )->a( n = `renderType` v = `Bare`

                    )->ele( `Button`
                        )->a( n = `text`  v = `Some text`
                        )->a( n = `type`  v = `Emphasized`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`

                        )->ele( `layoutData`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `3`

                        )->end(
                    )->end(
                    )->ele( `Input`
                        )->a( n = `value` v = `Some value`
                        )->a( n = `width` v = `auto`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`

                        )->ele( `layoutData`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `2`

                        )->end(
                    )->end(
                    )->ele( `Button`
                        )->a( n = `icon` v = `sap-icon://download`

                        )->ele( `layoutData`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                        )->end(
                    )->end(
                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
