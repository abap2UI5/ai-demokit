"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.m.Switch - Switch
"! https://sdk.openui5.org/entity/sap.m.Switch/sample/sap.m.sample.Switch
CLASS z2ui5_cl_api_app_528 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_528 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_api_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->open( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->open( `HBox`
                )->open( n = `Switch` a = VALUE #( ( `state=true` ) )
                    )->open( `layoutData`
                        )->leaf( n = `FlexItemData` a = VALUE #( ( `growFactor=1` ) )
                    )->shut(
                )->shut(
                )->open( n = `Switch` a = VALUE #( ( `state=false` ) )
                    )->open( `layoutData`
                        )->leaf( n = `FlexItemData` a = VALUE #( ( `growFactor=1` ) )
                    )->shut(
                )->shut(
                )->open( n = `Switch` a = VALUE #( ( `state=true` ) ( `enabled=false` ) )
                    )->open( `layoutData`
                        )->leaf( n = `FlexItemData` a = VALUE #( ( `growFactor=1` ) )
                    )->shut(
                )->shut(
            )->shut(

            )->open( `HBox`
                )->open( n = `Switch` a = VALUE #( ( `state=true` ) ( `customTextOn=Yes` ) ( `customTextOff=No` ) )
                    )->open( `layoutData`
                        )->leaf( n = `FlexItemData` a = VALUE #( ( `growFactor=1` ) )
                    )->shut(
                )->shut(
                )->open( n = `Switch` a = VALUE #( ( `state=false` ) ( `customTextOn=Yes` ) ( `customTextOff=No` ) )
                    )->open( `layoutData`
                        )->leaf( n = `FlexItemData` a = VALUE #( ( `growFactor=1` ) )
                    )->shut(
                )->shut(
                )->open( n = `Switch` a = VALUE #( ( `state=true` ) ( `customTextOn=Yes` ) ( `customTextOff=No` ) ( `enabled=false` ) )
                    )->open( `layoutData`
                        )->leaf( n = `FlexItemData` a = VALUE #( ( `growFactor=1` ) )
                    )->shut(
                )->shut(
            )->shut(

            )->open( `HBox`
                )->open( n = `Switch` a = VALUE #( ( `state=true` ) ( `customTextOn= ` ) ( `customTextOff= ` ) )
                    )->open( `layoutData`
                        )->leaf( n = `FlexItemData` a = VALUE #( ( `growFactor=1` ) )
                    )->shut(
                )->shut(
                )->open( n = `Switch` a = VALUE #( ( `state=false` ) ( `customTextOn= ` ) ( `customTextOff= ` ) )
                    )->open( `layoutData`
                        )->leaf( n = `FlexItemData` a = VALUE #( ( `growFactor=1` ) )
                    )->shut(
                )->shut(
                )->open( n = `Switch` a = VALUE #( ( `state=true` ) ( `customTextOn= ` ) ( `customTextOff= ` ) ( `enabled=false` ) )
                    )->open( `layoutData`
                        )->leaf( n = `FlexItemData` a = VALUE #( ( `growFactor=1` ) )
                    )->shut(
                )->shut(
            )->shut(

            )->open( `HBox`
                )->open( n = `Switch` a = VALUE #( ( `type=AcceptReject` ) ( `state=true` ) )
                    )->open( `layoutData`
                        )->leaf( n = `FlexItemData` a = VALUE #( ( `growFactor=1` ) )
                    )->shut(
                )->shut(
                )->open( n = `Switch` a = VALUE #( ( `type=AcceptReject` ) ( `state=false` ) )
                    )->open( `layoutData`
                        )->leaf( n = `FlexItemData` a = VALUE #( ( `growFactor=1` ) )
                    )->shut(
                )->shut(
                )->open( n = `Switch` a = VALUE #( ( `type=AcceptReject` ) ( `state=true` ) ( `enabled=false` ) )
                    )->open( `layoutData`
                        )->leaf( n = `FlexItemData` a = VALUE #( ( `growFactor=1` ) )
                    )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
