CLASS z2ui5_cl_smpc_app_063 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_063 IMPLEMENTATION.

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

        )->ele( `TileContent`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->ele( `content`
                )->tag( `NewsContent`
                    )->a( n = `contentText` v = `SAP Unveils Powerful New Player Comparison Tool Exclusively on NFL.com`
                    )->a( n = `subheader`   v = `August 21, 2013`
                    )->a( n = `press`       v = client->follow_up_action( val   = client->cs_event-control_global
                                                                          t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `The news content is pressed.` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
