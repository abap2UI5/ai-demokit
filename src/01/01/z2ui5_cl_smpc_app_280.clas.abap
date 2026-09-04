" @keywords textarea text area sap.m textareavalueupdate simpleform label switch
" @summary Since 1.30 the value property of sap.m.TextArea is not updated on every keystroke, but first when the user presses Enter or leaves the input. The change was necessary to fully support the standard UI5 data binding with formatters and types.
CLASS z2ui5_cl_smpc_app_280 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA value_live_update TYPE abap_bool.
    DATA input_value       TYPE string.
    DATA get_value         TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_280 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      get_value = ` `.
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
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
            )->tag( `TextArea`
                )->a( n = `id`              v = `TypeHere`
                )->a( n = `value`           v = client->_bind( input_value )
                )->a( n = `valueLiveUpdate` v = client->_bind( value_live_update )
                )->a( n = `liveChange`      v = client->_event( val = `LIVE_CHANGE` arg = `${$parameters>/value}` )

            )->tag( `Label`
                )->a( n = `text` v = `input.getValue()`
            )->tag( `Text`
                )->a( n = `id`   v = `getValue`
                )->a( n = `text` v = client->_bind( get_value )

            )->tag( `Label`
                )->a( n = `text` v = `model.getProperty()`
            )->tag( `Text`
                )->a( n = `id`   v = `getProperty`
                )->a( n = `text` v = client->_bind( input_value ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `LIVE_CHANGE`.
      " the original controller writes the event's value into the getValue Text,
      " deliberately bypassing the model - here it is the backend that holds it
      get_value = client->get_event_arg( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
