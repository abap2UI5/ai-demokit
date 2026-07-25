CLASS z2ui5_cl_ai_app_190 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_190 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->open( `VBox`
            )->open( `Panel`
                )->a( n = `headerText` v = `Render Type - Div`

                )->open( `FlexBox`
                    )->a( n = `renderType` v = `Div`

                    )->open( `Button`
                        )->a( n = `text`  v = `Some text`
                        )->a( n = `type`  v = `Emphasized`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`

                        )->open( `layoutData`
                            )->leaf( `FlexItemData`
                                )->a( n = `growFactor` v = `3`

                        )->shut(
                    )->shut(
                    )->open( `Input`
                        )->a( n = `value` v = `Some value`
                        )->a( n = `width` v = `auto`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`

                        )->open( `layoutData`
                            )->leaf( `FlexItemData`
                                )->a( n = `growFactor` v = `2`

                        )->shut(
                    )->shut(
                    )->open( `Button`
                        )->a( n = `icon` v = `sap-icon://download`

                        )->open( `layoutData`
                            )->leaf( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                        )->shut(
                    )->shut(
                )->shut(
            )->shut(
            )->open( `Panel`
                )->a( n = `headerText` v = `Render Type - Bare`

                )->open( `FlexBox`
                    )->a( n = `renderType` v = `Bare`

                    )->open( `Button`
                        )->a( n = `text`  v = `Some text`
                        )->a( n = `type`  v = `Emphasized`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`

                        )->open( `layoutData`
                            )->leaf( `FlexItemData`
                                )->a( n = `growFactor` v = `3`

                        )->shut(
                    )->shut(
                    )->open( `Input`
                        )->a( n = `value` v = `Some value`
                        )->a( n = `width` v = `auto`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`

                        )->open( `layoutData`
                            )->leaf( `FlexItemData`
                                )->a( n = `growFactor` v = `2`

                        )->shut(
                    )->shut(
                    )->open( `Button`
                        )->a( n = `icon` v = `sap-icon://download`

                        )->open( `layoutData`
                            )->leaf( `FlexItemData`
                                )->a( n = `growFactor` v = `1`

                        )->shut(
                    )->shut(
                )->shut(
            )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
