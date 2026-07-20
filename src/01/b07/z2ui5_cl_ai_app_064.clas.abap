CLASS z2ui5_cl_ai_app_064 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_064 IMPLEMENTATION.

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

        )->leaf( `NumericContent`
            )->a( n = `value`      v = `65`
            )->a( n = `scale`      v = `MM`
            )->a( n = `valueColor` v = `Error`
            )->a( n = `indicator`  v = `Down`
            )->a( n = `icon`       v = `sap-icon://travel-expense`
            )->a( n = `class`      v = `sapUiSmallMargin`
            )->a( n = `press`      v = client->_event( `PRESS` )
        )->leaf( `NumericContent`
            )->a( n = `value`      v = `11`
            )->a( n = `scale`      v = `MM`
            )->a( n = `valueColor` v = `Critical`
            )->a( n = `indicator`  v = `Up`
            )->a( n = `icon`       v = `test-resources/sap/m/demokit/sample/NumericContentIcon/images/grass.jpg`
            )->a( n = `class`      v = `sapUiSmallMargin`
            )->a( n = `press`      v = client->_event( `PRESS` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `PRESS`.
        client->message_toast_display( `The numeric content is pressed.` ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
