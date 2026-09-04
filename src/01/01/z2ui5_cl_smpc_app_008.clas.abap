" @keywords colorpalette color palette sap.m standalone contai simpleform toolbar title label
" @summary The standalone ColorPalette in a container (sap.ui.layout.SimpleForm).
CLASS z2ui5_cl_smpc_app_008 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_008 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    DATA temp2 LIKE LINE OF temp1.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `MESSAGE_TOAST` INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    
    temp2 = `Color Selected: value - {0}, ` && |\n| && ` defaultAction - {1}`.
    INSERT temp2 INTO TABLE temp1.
    INSERT `${$parameters>/value}` INTO TABLE temp1.
    INSERT `${$parameters>/defaultAction}` INTO TABLE temp1.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:form` v = `sap.ui.layout.form`

        )->ele( n = `SimpleForm` ns = `form`
            )->a( n = `editable`                v = `true`
            )->a( n = `backgroundDesign`        v = `Transparent`
            )->a( n = `singleContainerFullSize` v = `true`
            )->a( n = `layout`                  v = `ResponsiveGridLayout`

            )->ele( n = `toolbar` ns = `form`
                )->ele( `Toolbar`
                    )->tag( `Title`
                        )->a( n = `text` v = `Color Palette in a Form`

                )->end(
            )->end(

            )->tag( `Label`
                )->a( n = `text` v = `Choose Color`
            )->tag( `ColorPalette`
                )->a( n = `colorSelect` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                      t_arg = temp1 ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
