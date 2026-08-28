" @keywords timepickersliders time picker sliders sap.m pick vbox button text dialog
" @summary TimePickerSliders used in a Dialog.
CLASS z2ui5_cl_smpc_app_095 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_smpc_app_095 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `height`    v = `100%`

        )->ele( `Page`
            )->a( n = `showHeader` v = `false`

            )->ele( `VBox`
                )->tag( `Button`
                    )->a( n = `press` v = client->_event( `OPEN_DIALOG` )
                    )->a( n = `text`  v = `Open Dialog`
                    )->a( n = `class` v = `sapUiSmallMargin`
                )->tag( `Text`
                    )->a( n = `id`    v = `T1`
                    )->a( n = `text`  v = client->_bind( result_text )
                    )->a( n = `class` v = `sapUiSmallMargin` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `OPEN_DIALOG`.
        " capture the current value on open (the original's attachAfterOpen)
        time_value_old = time_value.
        popup_display( ).

      WHEN `OK_PRESS`.
        " the static id 'TPS2' stands in for the original's runtime oTP.getId()
        result_text = |TimePickerSliders TPS2: { time_value }|.
        client->popup_destroy( ).

      WHEN `CANCEL_PRESS`.
        time_value = time_value_old.
        client->popup_destroy( ).

    ENDCASE.

  ENDMETHOD.


  METHOD popup_display.

    DATA(popup) = z2ui5_cl_ui5_view_builder=>factory( ).

    popup->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->ele( `Dialog`
            )->a( n = `id`    v = `selectTimeDialog`
            )->a( n = `title` v = `Select New Time`

            )->tag( `TimePickerSliders`
                )->a( n = `id`            v = `TPS2`
                )->a( n = `valueFormat`   v = `hh:mm a`
                )->a( n = `displayFormat` v = `hh:mm a`
                )->a( n = `height`        v = `400px`
                " value two-way bound to transport the picked time (original reads oTP.getValue())
                )->a( n = `value`         v = client->_bind( time_value )

            )->ele( `buttons`
                )->tag( `Button`
                    )->a( n = `text`  v = `OK`
                    )->a( n = `press` v = client->_event( `OK_PRESS` )
                    )->a( n = `type`  v = `Emphasized`
                )->tag( `Button`
                    )->a( n = `text`  v = `Cancel`
                    )->a( n = `press` v = client->_event( `CANCEL_PRESS` ) ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
