CLASS z2ui5_cl_ai_app_546 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_546 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->leaf( `FeedContent`
            )->a( n = `contentText` v = `@@notify Great outcome of the Presentation today. The new functionality and the new design was well received.`
            )->a( n = `subheader`   v = `about 1 minute ago in Computer Market`
            )->a( n = `class`       v = `sapUiSmallMargin`
            )->a( n = `press`       v = client->_event( `PRESS` )
        )->leaf( `FeedContent`
            )->a( n = `contentText` v = `@@notify Great outcome of the Presentation today. The new functionality and the new design was well received.`
            )->a( n = `subheader`   v = `about 1 minute ago in Computer Market`
            )->a( n = `value`       v = `999`
            )->a( n = `class`       v = `sapUiSmallMargin`
            )->a( n = `press`       v = client->_event( `PRESS` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `PRESS`.
        client->message_toast_display( `The feed content is pressed.` ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
