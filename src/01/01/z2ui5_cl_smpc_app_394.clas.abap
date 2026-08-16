" @keywords flexbox flex box sap.m flexboxopposingalignment panel button
" @summary In this Flex Box the items are aligned at opposing ends of the container with justifyContent set to 'SpaceBetween'.
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
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( `Panel`
            )->a( n = `headerText` v = `Horizontally opposing flex items`

            )->ele( `FlexBox`
                )->a( n = `alignItems`     v = `Start`
                )->a( n = `justifyContent` v = `SpaceBetween`

                )->tag( `Button`
                    )->a( n = `text` v = `1`
                    )->a( n = `type` v = `Accept`
                )->tag( `Button`
                    )->a( n = `text` v = `2`
                    )->a( n = `type` v = `Reject` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
