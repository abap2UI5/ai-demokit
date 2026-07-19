CLASS z2ui5_cl_ai_app_528 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_528 IMPLEMENTATION.

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
            )->a( n = `class` v = `sapUiSmallMargin`

            )->open( `HBox`
                )->open( `Switch`
                    )->a( n = `state` v = `true`

                    )->open( `layoutData`
                        )->leaf( `FlexItemData`
                            )->a( n = `growFactor` v = `1`

                    )->shut(
                )->shut(
                )->open( `Switch`
                    )->a( n = `state` v = `false`

                    )->open( `layoutData`
                        )->leaf( `FlexItemData`
                            )->a( n = `growFactor` v = `1`

                    )->shut(
                )->shut(
                )->open( `Switch`
                    )->a( n = `state`   v = `true`
                    )->a( n = `enabled` v = `false`

                    )->open( `layoutData`
                        )->leaf( `FlexItemData`
                            )->a( n = `growFactor` v = `1`

                    )->shut(
                )->shut(
            )->shut(

            )->open( `HBox`
                )->open( `Switch`
                    )->a( n = `state`         v = `true`
                    )->a( n = `customTextOn`  v = `Yes`
                    )->a( n = `customTextOff` v = `No`

                    )->open( `layoutData`
                        )->leaf( `FlexItemData`
                            )->a( n = `growFactor` v = `1`

                    )->shut(
                )->shut(
                )->open( `Switch`
                    )->a( n = `state`         v = `false`
                    )->a( n = `customTextOn`  v = `Yes`
                    )->a( n = `customTextOff` v = `No`

                    )->open( `layoutData`
                        )->leaf( `FlexItemData`
                            )->a( n = `growFactor` v = `1`

                    )->shut(
                )->shut(
                )->open( `Switch`
                    )->a( n = `state`         v = `true`
                    )->a( n = `customTextOn`  v = `Yes`
                    )->a( n = `customTextOff` v = `No`
                    )->a( n = `enabled`       v = `false`

                    )->open( `layoutData`
                        )->leaf( `FlexItemData`
                            )->a( n = `growFactor` v = `1`

                    )->shut(
                )->shut(
            )->shut(

            )->open( `HBox`
                )->open( `Switch`
                    )->a( n = `state`         v = `true`
                    )->a( n = `customTextOn`  v = ` `
                    )->a( n = `customTextOff` v = ` `

                    )->open( `layoutData`
                        )->leaf( `FlexItemData`
                            )->a( n = `growFactor` v = `1`

                    )->shut(
                )->shut(
                )->open( `Switch`
                    )->a( n = `state`         v = `false`
                    )->a( n = `customTextOn`  v = ` `
                    )->a( n = `customTextOff` v = ` `

                    )->open( `layoutData`
                        )->leaf( `FlexItemData`
                            )->a( n = `growFactor` v = `1`

                    )->shut(
                )->shut(
                )->open( `Switch`
                    )->a( n = `state`         v = `true`
                    )->a( n = `customTextOn`  v = ` `
                    )->a( n = `customTextOff` v = ` `
                    )->a( n = `enabled`       v = `false`

                    )->open( `layoutData`
                        )->leaf( `FlexItemData`
                            )->a( n = `growFactor` v = `1`

                    )->shut(
                )->shut(
            )->shut(

            )->open( `HBox`
                )->open( `Switch`
                    )->a( n = `type`  v = `AcceptReject`
                    )->a( n = `state` v = `true`

                    )->open( `layoutData`
                        )->leaf( `FlexItemData`
                            )->a( n = `growFactor` v = `1`

                    )->shut(
                )->shut(
                )->open( `Switch`
                    )->a( n = `type`  v = `AcceptReject`
                    )->a( n = `state` v = `false`

                    )->open( `layoutData`
                        )->leaf( `FlexItemData`
                            )->a( n = `growFactor` v = `1`

                    )->shut(
                )->shut(
                )->open( `Switch`
                    )->a( n = `type`    v = `AcceptReject`
                    )->a( n = `state`   v = `true`
                    )->a( n = `enabled` v = `false`

                    )->open( `layoutData`
                        )->leaf( `FlexItemData`
                            )->a( n = `growFactor` v = `1`

                    )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
