" @keywords datetimepicker date time picker sap.m datetimepickervaluestate flexbox vbox label
" @summary This example shows different DateTimePicker value states.
CLASS z2ui5_cl_smpc_app_255 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_row,
        label          TYPE string,
        valuestate     TYPE string,
        valuestatetext TYPE string,
      END OF ty_s_row.
    DATA modeldata TYPE STANDARD TABLE OF ty_s_row WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_255 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( `FlexBox`
            )->a( n = `items`     v = |\{ path: '{ client->_bind_path( modeldata ) }' \}|
            )->a( n = `direction` v = `Column`

            )->ele( `VBox`
                )->a( n = `class` v = `sapUiTinyMargin`
                )->tag( `Label`
                    )->a( n = `text` v = `{LABEL}`
                    )->a( n = `labelFor` v = `DTP`
                )->tag( `DateTimePicker`
                    )->a( n = `id`             v = `DTP`
                    )->a( n = `width`          v = `100%`
                    )->a( n = `valueState`     v = `{VALUESTATE}`
                    )->a( n = `valueStateText` v = `{VALUESTATETEXT}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " onInit's aData 1:1 - every row carries a valueState (no absent-enum
    " trap); the rows without a valueStateText keep the empty default
    DATA temp1 LIKE modeldata.
    DATA temp2 LIKE LINE OF temp1.
    CLEAR temp1.
    
    temp2-label = `DateTimePicker with valueState None`.
    temp2-valuestate = `None`.
    INSERT temp2 INTO TABLE temp1.
    temp2-label = `DateTimePicker with valueState Information`.
    temp2-valuestate = `Information`.
    INSERT temp2 INTO TABLE temp1.
    temp2-label = `DateTimePicker with valueState Success`.
    temp2-valuestate = `Success`.
    INSERT temp2 INTO TABLE temp1.
    temp2-label = `DateTimePicker with valueState Warning and long valueStateText`.
    temp2-valuestate = `Warning`.
    temp2-valuestatetext = `Warning message. This is an extra long text used as a warning message. It illustrates how the text wraps into two or more lines without truncation to show the full length of the message.`.
    INSERT temp2 INTO TABLE temp1.
    temp2-label = `DateTimePicker with valueState Error`.
    temp2-valuestate = `Error`.
    INSERT temp2 INTO TABLE temp1.
    modeldata = temp1.

  ENDMETHOD.

ENDCLASS.
