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
    IF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

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

    " handlePress: oDialog.open() + setTimeout(close, 3000) - the 147 idiom
    " (control_by_id open + START_TIMER, the timer round-trip closes)
    CASE client->get_event( ).

      WHEN `SHOW_BUSY`.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( `BusyDialog` ) ( `open` ) ) ).
        client->follow_up_action( val   = client->cs_event-start_timer
                                  t_arg = VALUE #( ( `CLOSE_BUSY` ) ( `3000` ) ) ).

      WHEN `CLOSE_BUSY`.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( `BusyDialog` ) ( `close` ) ) ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
