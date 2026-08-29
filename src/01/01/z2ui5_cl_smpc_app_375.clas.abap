" @keywords stepinput step input sap.m stepinputvaluestate flexbox vbox label
" @summary This example shows different StepInput value states.
CLASS z2ui5_cl_smpc_app_375 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_model_data,
        label      TYPE string,
        valuestate TYPE string,
      END OF ty_s_model_data.
    DATA t_model_data TYPE STANDARD TABLE OF ty_s_model_data WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_375 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( `FlexBox`
            )->a( n = `items`     v = |\{ path: '{ client->_bind_path( t_model_data ) }' \}|
            )->a( n = `direction` v = `Column`

            )->ele( `VBox`
                )->a( n = `class` v = `sapUiTinyMargin`

                )->tag( `Label`
                    )->a( n = `text`     v = `{LABEL}`
                    )->a( n = `labelFor` v = `SI`
                )->tag( `StepInput`
                    )->a( n = `id`         v = `SI`
                    )->a( n = `width`      v = `100%`
                    )->a( n = `value`      v = `5`
                    )->a( n = `valueState` v = `{VALUESTATE}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " Data of the inline JSON model defined in the original sample controller
    " (the label prefix is the controller's sText variable)
    t_model_data = VALUE #(
      ( label = `StepInput with valueState None`        valuestate = `None` )
      ( label = `StepInput with valueState Information` valuestate = `Information` )
      ( label = `StepInput with valueState Success`     valuestate = `Success` )
      ( label = `StepInput with valueState Warning`     valuestate = `Warning` )
      ( label = `StepInput with valueState Error`       valuestate = `Error` ) ).

  ENDMETHOD.

ENDCLASS.
