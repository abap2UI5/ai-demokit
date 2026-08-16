" @keywords timepicker time picker sap.m timepickervaluestate flexbox vbox label
CLASS z2ui5_cl_smpc_app_404 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_data,
        label          TYPE string,
        valuestate     TYPE string,
        valuestatetext TYPE string,
      END OF ty_s_data.
    DATA t_model_data TYPE STANDARD TABLE OF ty_s_data WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_404 IMPLEMENTATION.

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
            )->a( n = `items`     v = client->_bind( t_model_data )
            )->a( n = `direction` v = `Column`

            )->ele( `VBox`
                )->a( n = `class` v = `sapUiTinyMargin`

                )->tag( `Label`
                    )->a( n = `text` v = `{LABEL}`
                )->tag( `TimePicker`
                    )->a( n = `width`          v = `100%`
                    )->a( n = `valueState`     v = `{VALUESTATE}`
                    )->a( n = `valueStateText` v = `{VALUESTATETEXT}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " /modelData of the sample controller - the label prefix "TimePicker with valueState "
    " is a controller-side variable (sText) and is inlined into every row here
    t_model_data = VALUE #(
      ( label = `TimePicker with valueState None`
        valuestate = `None` )
      ( label = `TimePicker with valueState Information`
        valuestate = `Information` )
      ( label = `TimePicker with valueState Success`
        valuestate = `Success` )
      ( label = `TimePicker with valueState Warning and long valueStateText`
        valuestate = `Warning`
        valuestatetext = `Warning message. This is an extra long text used as a warning message. It illustrates how the text wraps into two or more lines without ` &&
                         `truncation to show the full length of the message.` )
      ( label = `TimePicker with valueState Error`
        valuestate = `Error` ) ).

  ENDMETHOD.

ENDCLASS.
