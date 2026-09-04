" @keywords objectlistitem object list item sap.m objectlistitemmarkers objectstatus objectattribute objectmarker
" @summary This sample shows the different states of an Object List Item, which can be set using the markers aggregation.
CLASS z2ui5_cl_smpc_app_198 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_198 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    DATA temp2 TYPE string_table.
    DATA temp3 TYPE string_table.
    DATA temp4 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `MESSAGE_TOAST` INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    INSERT `Pressed : {0}` INTO TABLE temp1.
    INSERT `${$source>/title}` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `MESSAGE_TOAST` INTO TABLE temp2.
    INSERT `show` INTO TABLE temp2.
    INSERT `Pressed : {0}` INTO TABLE temp2.
    INSERT `${$source>/title}` INTO TABLE temp2.
    
    CLEAR temp3.
    INSERT `MESSAGE_TOAST` INTO TABLE temp3.
    INSERT `show` INTO TABLE temp3.
    INSERT `Pressed : {0}` INTO TABLE temp3.
    INSERT `${$source>/title}` INTO TABLE temp3.
    
    CLEAR temp4.
    INSERT `MESSAGE_TOAST` INTO TABLE temp4.
    INSERT `show` INTO TABLE temp4.
    INSERT `Pressed : {0}` INTO TABLE temp4.
    INSERT `${$source>/title}` INTO TABLE temp4.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->ele( `List`
            )->a( n = `headerText` v = `Products`

            )->ele( `ObjectListItem`
                )->a( n = `title`      v = `Gladiator MX`
                )->a( n = `type`       v = `Active`
                " the controller's MessageToast.show("Pressed : " + getSource().getTitle()) is composed roundtrip-free on the client
                )->a( n = `press`      v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp1 )
                )->a( n = `number`     v = `87.50`
                )->a( n = `numberUnit` v = `EUR`

                )->ele( `firstStatus`
                    )->tag( `ObjectStatus`
                        )->a( n = `text`  v = `Available`
                        )->a( n = `state` v = `Success`

                )->end(
                )->tag( `ObjectAttribute`
                    )->a( n = `text` v = `125 g`
                )->tag( `ObjectAttribute`
                    )->a( n = `text` v = `145 x 140 x 360 cm`

                )->ele( `markers`
                    )->tag( `ObjectMarker`
                        )->a( n = `type` v = `Favorite`
                    )->tag( `ObjectMarker`
                        )->a( n = `type` v = `Flagged`

                )->end(
            )->end(
            )->ele( `ObjectListItem`
                )->a( n = `title`      v = `Hurricane GX`
                )->a( n = `type`       v = `Active`
                )->a( n = `press`      v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp2 )
                )->a( n = `number`     v = `235`
                )->a( n = `numberUnit` v = `EUR`

                )->ele( `firstStatus`
                    )->tag( `ObjectStatus`
                        )->a( n = `text`  v = `Out of stock`
                        )->a( n = `state` v = `Warning`

                )->end(
                )->tag( `ObjectAttribute`
                    )->a( n = `text` v = `34 g`
                )->tag( `ObjectAttribute`
                    )->a( n = `text` v = `45 x 14 x 36 cm`

                )->ele( `markers`
                    )->tag( `ObjectMarker`
                        )->a( n = `type` v = `Flagged`
                    )->tag( `ObjectMarker`
                        )->a( n = `type` v = `Locked`

                )->end(
            )->end(
            )->ele( `ObjectListItem`
                )->a( n = `title`      v = `Power Projector 4713`
                )->a( n = `type`       v = `Active`
                )->a( n = `press`      v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp3 )
                )->a( n = `number`     v = `135`
                )->a( n = `numberUnit` v = `EUR`

                )->ele( `firstStatus`
                    )->tag( `ObjectStatus`
                        )->a( n = `text`  v = `Discontinued`
                        )->a( n = `state` v = `Error`

                )->end(
                )->tag( `ObjectAttribute`
                    )->a( n = `text` v = `67 g`
                )->tag( `ObjectAttribute`
                    )->a( n = `text` v = `425 x 35 x 30 cm`

                )->ele( `markers`
                    )->tag( `ObjectMarker`
                        )->a( n = `type` v = `Favorite`
                    )->tag( `ObjectMarker`
                        )->a( n = `type` v = `Locked`
                    )->tag( `ObjectMarker`
                        )->a( n = `type` v = `Draft`

                )->end(
            )->end(
            )->ele( `ObjectListItem`
                )->a( n = `title`      v = `Webcam`
                )->a( n = `type`       v = `Active`
                )->a( n = `press`      v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp4 )
                )->a( n = `number`     v = `15`
                )->a( n = `numberUnit` v = `EUR`

                )->ele( `firstStatus`
                    )->tag( `ObjectStatus`
                        )->a( n = `text` v = `New`

                )->end(
                )->tag( `ObjectAttribute`
                    )->a( n = `text` v = `67 g`
                )->tag( `ObjectAttribute`
                    )->a( n = `text` v = `15 x 15 x 10 cm`

                )->ele( `markers`
                    )->tag( `ObjectMarker`
                        )->a( n = `type` v = `Unsaved` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
