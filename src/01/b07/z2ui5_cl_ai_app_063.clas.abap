CLASS z2ui5_cl_ai_app_063 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_063 IMPLEMENTATION.

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

        )->open( `TileContent`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->open( `content`
                )->leaf( `NewsContent`
                    )->a( n = `contentText` v = `SAP Unveils Powerful New Player Comparison Tool Exclusively on NFL.com`
                    )->a( n = `subheader`   v = `August 21, 2013`
                    )->a( n = `press`       v = client->_event( `PRESS` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `PRESS`.
        client->message_toast_display( `The news content is pressed.` ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
