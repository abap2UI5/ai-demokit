" @keywords busydialog busy dialog sap.m busydialoglight verticallayout button
" @summary This is a 'light' version of the standard Busy Dialog; it also blocks the user interface until the currently running operation has been finished. It has no UI components, so you must close it programmatically when appropriate.
CLASS z2ui5_cl_smpc_app_251 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_251 IMPLEMENTATION.

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
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns`      v = `sap.m`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->ele( n = `dependents` ns = `l`
                " BusyDialog.fragment.xml inlined (the core:Fragment reference
                " element is dropped, declared)
                )->tag( `BusyDialog`
                    )->a( n = `id` v = `BusyDialog`

            )->end(
            )->tag( `Button`
                )->a( n = `text`  v = `Show Light Busy Dialog`
                )->a( n = `press` v = client->_event( `SHOW_BUSY` )
                )->a( n = `class` v = `sapUiSmallMarginBottom` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA temp1 TYPE string_table.
        DATA temp3 TYPE string_table.
        DATA temp5 TYPE string_table.

    " handlePress: oDialog.open() + setTimeout(close, 3000) - the 147 idiom
    " (control_by_id open + START_TIMER, the timer round-trip closes)
    CASE client->get_event( ).

      WHEN `SHOW_BUSY`.
        
        CLEAR temp1.
        INSERT `BusyDialog` INTO TABLE temp1.
        INSERT `open` INTO TABLE temp1.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = temp1 ).
        
        CLEAR temp3.
        INSERT `CLOSE_BUSY` INTO TABLE temp3.
        INSERT `3000` INTO TABLE temp3.
        client->follow_up_action( val   = client->cs_event-start_timer
                                  t_arg = temp3 ).

      WHEN `CLOSE_BUSY`.
        
        CLEAR temp5.
        INSERT `BusyDialog` INTO TABLE temp5.
        INSERT `close` INTO TABLE temp5.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = temp5 ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
