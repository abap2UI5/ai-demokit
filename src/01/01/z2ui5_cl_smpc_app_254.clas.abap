" @keywords daterangeselection date range selection sap.m daterangeselectionvaluestate flexbox vbox label
" @summary This example shows different DateRangeSelection value states.
CLASS z2ui5_cl_smpc_app_254 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_row,
        label          TYPE string,
        valuestate     TYPE string,
        valuestatetext TYPE string,
      END OF ty_s_row.
    DATA modeldata TYPE STANDARD TABLE OF ty_s_row WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_254 IMPLEMENTATION.

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
            )->a( n = `items`     v = |\{ path: '{ client->_bind( val = modeldata path = abap_true ) }' \}|
            )->a( n = `direction` v = `Column`

            )->ele( `VBox`
                )->a( n = `class` v = `sapUiTinyMargin`
                )->tag( `Label`
                    )->a( n = `text` v = `{LABEL}`
                )->tag( `DateRangeSelection`
                    )->a( n = `delimiter`      v = `–`
                    )->a( n = `width`          v = `100%`
                    )->a( n = `valueState`     v = `{VALUESTATE}`
                    )->a( n = `valueStateText` v = `{VALUESTATETEXT}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " onInit's aData 1:1 - every row carries a valueState (no absent-enum
    " trap); the rows without a valueStateText keep the empty default
    modeldata = VALUE #(
      ( label = `DateRangeSelection with valueState None`        valuestate = `None` )
      ( label = `DateRangeSelection with valueState Information` valuestate = `Information` )
      ( label = `DateRangeSelection with valueState Success`     valuestate = `Success` )
      ( label = `DateRangeSelection with valueState Warning and long valueStateText` valuestate = `Warning`
        valuestatetext = `Warning message. This is an extra long text used as a warning message. It illustrates how the text wraps into two or more lines without truncation to show the full length of the message.` )
      ( label = `DateRangeSelection with valueState Error` valuestate = `Error` ) ).

  ENDMETHOD.

ENDCLASS.
