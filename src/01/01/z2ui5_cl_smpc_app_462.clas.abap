" @keywords input sap.m inputvalueupdate simpleform label switch text
" @summary Since 1.24 the value property of sap.m.Input is not updated on every keystroke, but first when the user presses Enter or leaves the input. The change was necessary to fully support the standard UI5 data binding with formatters and types.
CLASS z2ui5_cl_smpc_app_462 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA value_live_update TYPE abap_bool.
    DATA input_value       TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_462 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:form` v = `sap.ui.layout.form`

        )->ele( n = `SimpleForm` ns = `form`
            )->a( n = `editable` v = `true`
            )->a( n = `layout`   v = `ResponsiveGridLayout`

            )->tag( `Label`
                )->a( n = `text` v = `ValueLiveUpdate`
            )->tag( `Switch`
                )->a( n = `state` v = client->_bind( value_live_update )
            )->tag( `Label`
                )->a( n = `text` v = `Type here`
            " onLiveChange writes the value into the Text below - the only leg of the
            " sample that cannot be a binding, since it must show what getValue( )
            " returns even while valueLiveUpdate keeps the model value behind.
            " It needs no round-trip either: setText on the Text by id, with the
            " keystroke value as the argument, is the same write done on the client
            )->tag( `Input`
                )->a( n = `value`            v = client->_bind( input_value )
                )->a( n = `valueLiveUpdate`  v = client->_bind( value_live_update )
                )->a( n = `liveChange`       v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                           t_arg = VALUE #( ( `getValue` ) ( `setText` ) ( `${$parameters>/value}` ) ) )
            )->tag( `Label`
                )->a( n = `text` v = `oInput.getValue()`
            " no text of its own, exactly as the original: the Text is written
            " by the liveChange wire alone
            )->tag( `Text`
                )->a( n = `id`   v = `getValue`
            )->tag( `Label`
                )->a( n = `text` v = `oModel.getProperty()`
            )->tag( `Text`
                )->a( n = `text` v = client->_bind( input_value ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
