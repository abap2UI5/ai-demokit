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
    IF client->check_on_init( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_api_xml.
    DATA temp1 TYPE z2ui5_cl_api_xml=>ty_t_attr.
    DATA temp2 TYPE z2ui5_cl_api_xml=>ty_t_attr.
    DATA temp3 TYPE z2ui5_cl_api_xml=>ty_t_attr.
    DATA temp4 TYPE z2ui5_cl_api_xml=>ty_t_attr.
    DATA temp5 TYPE z2ui5_cl_api_xml=>ty_t_attr.
    DATA temp6 TYPE z2ui5_cl_api_xml=>ty_t_attr.
    DATA temp7 TYPE z2ui5_cl_api_xml=>ty_t_attr.
    DATA temp8 TYPE z2ui5_cl_api_xml=>ty_t_attr.
    DATA temp9 TYPE z2ui5_cl_api_xml=>ty_t_attr.
    DATA temp10 TYPE z2ui5_cl_api_xml=>ty_t_attr.
    DATA temp11 TYPE z2ui5_cl_api_xml=>ty_t_attr.
    DATA temp12 TYPE z2ui5_cl_api_xml=>ty_t_attr.
    DATA temp13 TYPE z2ui5_cl_api_xml=>ty_t_attr.
    DATA temp14 TYPE z2ui5_cl_api_xml=>ty_t_attr.
    DATA temp15 TYPE z2ui5_cl_api_xml=>ty_t_attr.
    DATA temp16 TYPE z2ui5_cl_api_xml=>ty_t_attr.
    DATA temp17 TYPE z2ui5_cl_api_xml=>ty_t_attr.
    DATA temp18 TYPE z2ui5_cl_api_xml=>ty_t_attr.
    DATA temp19 TYPE z2ui5_cl_api_xml=>ty_t_attr.
    DATA temp20 TYPE z2ui5_cl_api_xml=>ty_t_attr.
    DATA temp21 TYPE z2ui5_cl_api_xml=>ty_t_attr.
    DATA temp22 TYPE z2ui5_cl_api_xml=>ty_t_attr.
    DATA temp23 TYPE z2ui5_cl_api_xml=>ty_t_attr.
    DATA temp24 TYPE z2ui5_cl_api_xml=>ty_t_attr.
    view = z2ui5_cl_api_xml=>factory( ).

    
    CLEAR temp1.
    INSERT `state=true` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `growFactor=1` INTO TABLE temp2.
    
    CLEAR temp3.
    INSERT `state=false` INTO TABLE temp3.
    
    CLEAR temp4.
    INSERT `growFactor=1` INTO TABLE temp4.
    
    CLEAR temp5.
    INSERT `state=true` INTO TABLE temp5.
    INSERT `enabled=false` INTO TABLE temp5.
    
    CLEAR temp6.
    INSERT `growFactor=1` INTO TABLE temp6.
    
    CLEAR temp7.
    INSERT `state=true` INTO TABLE temp7.
    INSERT `customTextOn=Yes` INTO TABLE temp7.
    INSERT `customTextOff=No` INTO TABLE temp7.
    
    CLEAR temp8.
    INSERT `growFactor=1` INTO TABLE temp8.
    
    CLEAR temp9.
    INSERT `state=false` INTO TABLE temp9.
    INSERT `customTextOn=Yes` INTO TABLE temp9.
    INSERT `customTextOff=No` INTO TABLE temp9.
    
    CLEAR temp10.
    INSERT `growFactor=1` INTO TABLE temp10.
    
    CLEAR temp11.
    INSERT `state=true` INTO TABLE temp11.
    INSERT `customTextOn=Yes` INTO TABLE temp11.
    INSERT `customTextOff=No` INTO TABLE temp11.
    INSERT `enabled=false` INTO TABLE temp11.
    
    CLEAR temp12.
    INSERT `growFactor=1` INTO TABLE temp12.
    
    CLEAR temp13.
    INSERT `state=true` INTO TABLE temp13.
    INSERT `customTextOn= ` INTO TABLE temp13.
    INSERT `customTextOff= ` INTO TABLE temp13.
    
    CLEAR temp14.
    INSERT `growFactor=1` INTO TABLE temp14.
    
    CLEAR temp15.
    INSERT `state=false` INTO TABLE temp15.
    INSERT `customTextOn= ` INTO TABLE temp15.
    INSERT `customTextOff= ` INTO TABLE temp15.
    
    CLEAR temp16.
    INSERT `growFactor=1` INTO TABLE temp16.
    
    CLEAR temp17.
    INSERT `state=true` INTO TABLE temp17.
    INSERT `customTextOn= ` INTO TABLE temp17.
    INSERT `customTextOff= ` INTO TABLE temp17.
    INSERT `enabled=false` INTO TABLE temp17.
    
    CLEAR temp18.
    INSERT `growFactor=1` INTO TABLE temp18.
    
    CLEAR temp19.
    INSERT `type=AcceptReject` INTO TABLE temp19.
    INSERT `state=true` INTO TABLE temp19.
    
    CLEAR temp20.
    INSERT `growFactor=1` INTO TABLE temp20.
    
    CLEAR temp21.
    INSERT `type=AcceptReject` INTO TABLE temp21.
    INSERT `state=false` INTO TABLE temp21.
    
    CLEAR temp22.
    INSERT `growFactor=1` INTO TABLE temp22.
    
    CLEAR temp23.
    INSERT `type=AcceptReject` INTO TABLE temp23.
    INSERT `state=true` INTO TABLE temp23.
    INSERT `enabled=false` INTO TABLE temp23.
    
    CLEAR temp24.
    INSERT `growFactor=1` INTO TABLE temp24.
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->open( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->open( `HBox`
                )->open( n = `Switch` a = temp1
                    )->open( `layoutData`
                        )->leaf( n = `FlexItemData` a = temp2

                    )->shut(
                )->shut(
                )->open( n = `Switch` a = temp3
                    )->open( `layoutData`
                        )->leaf( n = `FlexItemData` a = temp4

                    )->shut(
                )->shut(
                )->open( n = `Switch` a = temp5
                    )->open( `layoutData`
                        )->leaf( n = `FlexItemData` a = temp6

                    )->shut(
                )->shut(
            )->shut(

            )->open( `HBox`
                )->open( n = `Switch` a = temp7
                    )->open( `layoutData`
                        )->leaf( n = `FlexItemData` a = temp8

                    )->shut(
                )->shut(
                )->open( n = `Switch` a = temp9
                    )->open( `layoutData`
                        )->leaf( n = `FlexItemData` a = temp10

                    )->shut(
                )->shut(
                )->open( n = `Switch` a = temp11
                    )->open( `layoutData`
                        )->leaf( n = `FlexItemData` a = temp12

                    )->shut(
                )->shut(
            )->shut(

            )->open( `HBox`
                )->open( n = `Switch` a = temp13
                    )->open( `layoutData`
                        )->leaf( n = `FlexItemData` a = temp14

                    )->shut(
                )->shut(
                )->open( n = `Switch` a = temp15
                    )->open( `layoutData`
                        )->leaf( n = `FlexItemData` a = temp16

                    )->shut(
                )->shut(
                )->open( n = `Switch` a = temp17
                    )->open( `layoutData`
                        )->leaf( n = `FlexItemData` a = temp18

                    )->shut(
                )->shut(
            )->shut(

            )->open( `HBox`
                )->open( n = `Switch` a = temp19
                    )->open( `layoutData`
                        )->leaf( n = `FlexItemData` a = temp20

                    )->shut(
                )->shut(
                )->open( n = `Switch` a = temp21
                    )->open( `layoutData`
                        )->leaf( n = `FlexItemData` a = temp22

                    )->shut(
                )->shut(
                )->open( n = `Switch` a = temp23
                    )->open( `layoutData`
                        )->leaf( n = `FlexItemData` a = temp24

                    )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
