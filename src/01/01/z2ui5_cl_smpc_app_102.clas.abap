" @keywords inputmodelupdate input model update sap.m late binding app vbox text button
" @summary The sample demonstrates how to rebind a control to a different data source after a certain delay.
CLASS z2ui5_cl_smpc_app_102 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA current_value TYPE string VALUE `Martin`.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    DATA initial_value TYPE string VALUE `Martin`.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_102 IMPLEMENTATION.

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
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:f`    v = `sap.ui.layout.form`

        )->ele( `App`
            )->ele( `Page`
                )->a( n = `title` v = `Late binding of Input (oData v2)`

                )->ele( `VBox`
                    )->tag( `Text`
                        )->a( n = `class` v = `sapUiSmallMarginBottom`
                        )->a( n = `text`  v = `For more details about this sample code and its intended use case, please refer to the description and comments provided within the code.`
                    )->tag( `Input`
                        )->a( n = `id`         v = `inputArtistName`
                        )->a( n = `value`      v = client->_bind( current_value )
                        )->a( n = `liveChange` v = client->_event( `LIVE_CHANGE` )
                    )->tag( `Button`
                        )->a( n = `press` v = client->_event( `REBIND` )
                        )->a( n = `text`  v = `Bind Input in 3 seconds` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `REBIND`.
        " original fnRebind: after ~3s (the OData dataReceived) late-bind the input
        client->follow_up_action( val   = client->cs_event-start_timer
                                  t_arg = VALUE #( ( `REBIND_DONE` ) ( `3000` ) ) ).

      WHEN `REBIND_DONE`.
        " original dataReceived: if the input is still untouched, bind it to Employees(1)/FirstName
        IF current_value = initial_value.
          current_value = `Nancy`.
        ENDIF.

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
