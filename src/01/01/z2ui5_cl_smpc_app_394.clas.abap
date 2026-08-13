CLASS z2ui5_cl_smpc_app_394 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_394 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->open( `Panel`
            )->a( n = `headerText` v = `Horizontally opposing flex items`

            )->open( `FlexBox`
                )->a( n = `alignItems`     v = `Start`
                )->a( n = `justifyContent` v = `SpaceBetween`

                )->leaf( `Button`
                    )->a( n = `text` v = `1`
                    )->a( n = `type` v = `Accept`
                )->leaf( `Button`
                    )->a( n = `text` v = `2`
                    )->a( n = `type` v = `Reject` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
