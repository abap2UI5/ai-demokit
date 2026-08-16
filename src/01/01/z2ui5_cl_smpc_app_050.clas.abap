" @keywords switch sap.m off switches types custom text vbox hbox flexitemdata
CLASS z2ui5_cl_smpc_app_050 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_050 IMPLEMENTATION.

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
            )->a( n = `class` v = `sapUiSmallMargin`

            )->ele( `HBox`
                )->ele( `Switch`
                    )->a( n = `state` v = `true`

                    )->ele( `layoutData`
                        )->tag( `FlexItemData`
                            )->a( n = `growFactor` v = `1`

                    )->end(
                )->end(
                )->ele( `Switch`
                    )->a( n = `state` v = `false`

                    )->ele( `layoutData`
                        )->tag( `FlexItemData`
                            )->a( n = `growFactor` v = `1`

                    )->end(
                )->end(
                )->ele( `Switch`
                    )->a( n = `state`   v = `true`
                    )->a( n = `enabled` v = `false`

                    )->ele( `layoutData`
                        )->tag( `FlexItemData`
                            )->a( n = `growFactor` v = `1`

                    )->end(
                )->end(
            )->end(

            )->ele( `HBox`
                )->ele( `Switch`
                    )->a( n = `state`         v = `true`
                    )->a( n = `customTextOn`  v = `Yes`
                    )->a( n = `customTextOff` v = `No`

                    )->ele( `layoutData`
                        )->tag( `FlexItemData`
                            )->a( n = `growFactor` v = `1`

                    )->end(
                )->end(
                )->ele( `Switch`
                    )->a( n = `state`         v = `false`
                    )->a( n = `customTextOn`  v = `Yes`
                    )->a( n = `customTextOff` v = `No`

                    )->ele( `layoutData`
                        )->tag( `FlexItemData`
                            )->a( n = `growFactor` v = `1`

                    )->end(
                )->end(
                )->ele( `Switch`
                    )->a( n = `state`         v = `true`
                    )->a( n = `customTextOn`  v = `Yes`
                    )->a( n = `customTextOff` v = `No`
                    )->a( n = `enabled`       v = `false`

                    )->ele( `layoutData`
                        )->tag( `FlexItemData`
                            )->a( n = `growFactor` v = `1`

                    )->end(
                )->end(
            )->end(

            )->ele( `HBox`
                )->ele( `Switch`
                    )->a( n = `state`         v = `true`
                    )->a( n = `customTextOn`  v = ` `
                    )->a( n = `customTextOff` v = ` `

                    )->ele( `layoutData`
                        )->tag( `FlexItemData`
                            )->a( n = `growFactor` v = `1`

                    )->end(
                )->end(
                )->ele( `Switch`
                    )->a( n = `state`         v = `false`
                    )->a( n = `customTextOn`  v = ` `
                    )->a( n = `customTextOff` v = ` `

                    )->ele( `layoutData`
                        )->tag( `FlexItemData`
                            )->a( n = `growFactor` v = `1`

                    )->end(
                )->end(
                )->ele( `Switch`
                    )->a( n = `state`         v = `true`
                    )->a( n = `customTextOn`  v = ` `
                    )->a( n = `customTextOff` v = ` `
                    )->a( n = `enabled`       v = `false`

                    )->ele( `layoutData`
                        )->tag( `FlexItemData`
                            )->a( n = `growFactor` v = `1`

                    )->end(
                )->end(
            )->end(

            )->ele( `HBox`
                )->ele( `Switch`
                    )->a( n = `type`  v = `AcceptReject`
                    )->a( n = `state` v = `true`

                    )->ele( `layoutData`
                        )->tag( `FlexItemData`
                            )->a( n = `growFactor` v = `1`

                    )->end(
                )->end(
                )->ele( `Switch`
                    )->a( n = `type`  v = `AcceptReject`
                    )->a( n = `state` v = `false`

                    )->ele( `layoutData`
                        )->tag( `FlexItemData`
                            )->a( n = `growFactor` v = `1`

                    )->end(
                )->end(
                )->ele( `Switch`
                    )->a( n = `type`    v = `AcceptReject`
                    )->a( n = `state`   v = `true`
                    )->a( n = `enabled` v = `false`

                    )->ele( `layoutData`
                        )->tag( `FlexItemData`
                            )->a( n = `growFactor` v = `1`

                    )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
