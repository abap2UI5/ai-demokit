" @keywords busydialog busy dialog sap.m indicate verticallayout button
" @summary A Busy Dialog blocks the user interface until the currently running operation has been finished. No other activities can be started in parallel.
CLASS z2ui5_cl_smpc_app_004 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    " the original's clearTimeout guard: a timer that outlives a cancel is ignored
    DATA check_busy TYPE abap_bool.

    METHODS view_display.
    METHODS on_event.
    METHODS popup_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_004 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->tag( `Button`
                )->a( n = `text`  v = `Show Busy Dialog`
                )->a( n = `press` v = client->_event( `OPEN_DIALOG` )
                )->a( n = `class` v = `sapUiSmallMarginBottom` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    DATA cancel_pressed TYPE abap_bool.
        DATA temp1 TYPE string_table.
          DATA temp3 TYPE string_table.

    CASE client->get_event( ).

      WHEN `OPEN_DIALOG`.
        check_busy = abap_true.
        popup_display( ).
        " the original's simulateServerRequest - close the dialog after 3000ms
        
        CLEAR temp1.
        INSERT `TIMER_FINISHED` INTO TABLE temp1.
        INSERT `3000` INTO TABLE temp1.
        client->follow_up_action( val   = client->cs_event-start_timer
                                  t_arg = temp1 ).

      WHEN `TIMER_FINISHED`.
        IF check_busy = abap_true.
          
          CLEAR temp3.
          INSERT `busyDialog` INTO TABLE temp3.
          INSERT `close` INTO TABLE temp3.
          client->follow_up_action( val   = client->cs_event-control_by_id
                                    view  = client->cs_view-popup
                                    t_arg = temp3 ).
        ENDIF.

      WHEN `DIALOG_CLOSED`.
        check_busy = abap_false.
        cancel_pressed = client->get_event_arg( ).
        IF cancel_pressed = abap_true.
          client->message_toast_display( `The operation has been cancelled` ).
        ELSE.
          client->message_toast_display( `The operation has been completed` ).
        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD popup_display.

    DATA popup TYPE REF TO z2ui5_cl_ui5_view_builder.
    popup = z2ui5_cl_ui5_view_builder=>factory( ).

    popup->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        " id added so the backend timer event can close the dialog via control_by_id
        )->tag( `BusyDialog`
            )->a( n = `id`               v = `busyDialog`
            )->a( n = `title`            v = `Loading Data`
            )->a( n = `text`             v = `... now loading the data from a far away server`
            )->a( n = `showCancelButton` v = `true`
            )->a( n = `close`            v = client->_event( val = `DIALOG_CLOSED` arg = `${$parameters>/cancelPressed}` ) ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
