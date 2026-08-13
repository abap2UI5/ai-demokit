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
    IF client->check_on_init( ).
      get_value = ` `.
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:form` v = `sap.ui.layout.form`

        )->open( n = `SimpleForm` ns = `form`
            )->a( n = `editable` v = `true`
            )->a( n = `layout`   v = `ResponsiveGridLayout`

            )->leaf( `Label`
                )->a( n = `text` v = `ValueLiveUpdate`
            )->leaf( `Switch`
                )->a( n = `state` v = client->_bind( value_live_update )

            )->leaf( `Label`
                )->a( n = `text` v = `Type here`
            )->leaf( `TextArea`
                )->a( n = `id`              v = `TypeHere`
                )->a( n = `value`           v = client->_bind( input_value )
                )->a( n = `valueLiveUpdate` v = client->_bind( value_live_update )
                )->a( n = `liveChange`      v = client->_event( val = `LIVE_CHANGE` t_arg = VALUE #( ( `${$parameters>/value}` ) ) )

            )->leaf( `Label`
                )->a( n = `text` v = `input.getValue()`
            )->leaf( `Text`
                )->a( n = `id`   v = `getValue`
                )->a( n = `text` v = client->_bind( get_value )

            )->leaf( `Label`
                )->a( n = `text` v = `model.getProperty()`
            )->leaf( `Text`
                )->a( n = `id`   v = `getProperty`
                )->a( n = `text` v = client->_bind( input_value ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `LIVE_CHANGE`.

        " the original controller writes the event's value into the getValue Text,
        " deliberately bypassing the model - here it is the backend that holds it
        get_value = client->get_event_arg( ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
