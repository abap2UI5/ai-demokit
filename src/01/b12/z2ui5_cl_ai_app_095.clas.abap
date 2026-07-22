CLASS z2ui5_cl_ai_app_095 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA result_text TYPE string VALUE `change event result`.
    DATA time_value TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    DATA time_value_old TYPE string.

    METHODS view_display.
    METHODS on_event.
    METHODS popup_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_095 IMPLEMENTATION.

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
        )->a( n = `height`    v = `100%`

        )->open( `Page`
            )->a( n = `showHeader` v = `false`

            )->open( `VBox`
                )->leaf( `Button`
                    )->a( n = `press` v = client->_event( `OPEN_DIALOG` )
                    )->a( n = `text`  v = `Open Dialog`
                    )->a( n = `class` v = `sapUiSmallMargin`
                )->leaf( `Text`
                    )->a( n = `id`    v = `T1`
                    )->a( n = `text`  v = client->_bind( result_text )
                    )->a( n = `class` v = `sapUiSmallMargin` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `OPEN_DIALOG`.
        " capture the current value on open (the original's attachAfterOpen)
        time_value_old = time_value.
        popup_display( ).

      WHEN `OK_PRESS`.
        " the static id 'TPS2' stands in for the original's runtime oTP.getId()
        result_text = |TimePickerSliders TPS2: { time_value }|.
        client->popup_destroy( ).
        client->view_model_update( ).

      WHEN `CANCEL_PRESS`.
        time_value = time_value_old.
        client->popup_destroy( ).
        client->view_model_update( ).

    ENDCASE.

  ENDMETHOD.


  METHOD popup_display.

    DATA(popup) = z2ui5_cl_ai_xml=>factory( ).

    popup->open( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->open( `Dialog`
            )->a( n = `id`    v = `selectTimeDialog`
            )->a( n = `title` v = `Select New Time`

            )->leaf( `TimePickerSliders`
                )->a( n = `id`            v = `TPS2`
                )->a( n = `valueFormat`   v = `hh:mm a`
                )->a( n = `displayFormat` v = `hh:mm a`
                )->a( n = `height`        v = `400px`
                " value two-way bound to transport the picked time (original reads oTP.getValue())
                )->a( n = `value`         v = client->_bind( time_value )

            )->open( `buttons`
                )->leaf( `Button`
                    )->a( n = `text`  v = `OK`
                    )->a( n = `press` v = client->_event( `OK_PRESS` )
                    )->a( n = `type`  v = `Emphasized`
                )->leaf( `Button`
                    )->a( n = `text`  v = `Cancel`
                    )->a( n = `press` v = client->_event( `CANCEL_PRESS` ) ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
