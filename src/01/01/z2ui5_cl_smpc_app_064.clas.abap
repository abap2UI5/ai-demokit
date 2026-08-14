CLASS z2ui5_cl_smpc_app_064 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_064 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->tag( `NumericContent`
            )->a( n = `value`      v = `65`
            )->a( n = `scale`      v = `MM`
            )->a( n = `valueColor` v = `Error`
            )->a( n = `indicator`  v = `Down`
            )->a( n = `icon`       v = `sap-icon://travel-expense`
            )->a( n = `class`      v = `sapUiSmallMargin`
            )->a( n = `press`      v = client->follow_up_action( val   = client->cs_event-control_global
                                                                 t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `The numeric content is pressed.` ) ) )
        )->tag( `NumericContent`
            )->a( n = `value`      v = `11`
            )->a( n = `scale`      v = `MM`
            )->a( n = `valueColor` v = `Critical`
            )->a( n = `indicator`  v = `Up`
            " original demokit test-resources image path kept 1:1 - not served by abap2UI5 (see sidecar)
            )->a( n = `icon`       v = `test-resources/sap/m/demokit/sample/NumericContentIcon/images/grass.jpg`
            )->a( n = `class`      v = `sapUiSmallMargin`
            )->a( n = `press`      v = client->follow_up_action( val   = client->cs_event-control_global
                                                                 t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `The numeric content is pressed.` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
