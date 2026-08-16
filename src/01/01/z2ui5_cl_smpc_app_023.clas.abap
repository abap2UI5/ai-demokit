CLASS z2ui5_cl_smpc_app_023 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_023 IMPLEMENTATION.

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

        )->tag( `FeedContent`
            )->a( n = `contentText` v = `@@notify Great outcome of the Presentation today. The new functionality and the new design was well received.`
            )->a( n = `subheader`   v = `about 1 minute ago in Computer Market`
            )->a( n = `class`       v = `sapUiSmallMargin`
            )->a( n = `press`       v = client->follow_up_action( val   = client->cs_event-control_global
                                                                  t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `The feed content is pressed.` ) ) )
        )->tag( `FeedContent`
            )->a( n = `contentText` v = `@@notify Great outcome of the Presentation today. The new functionality and the new design was well received.`
            )->a( n = `subheader`   v = `about 1 minute ago in Computer Market`
            )->a( n = `value`       v = `999`
            )->a( n = `class`       v = `sapUiSmallMargin`
            )->a( n = `press`       v = client->follow_up_action( val   = client->cs_event-control_global
                                                                  t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `The feed content is pressed.` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
