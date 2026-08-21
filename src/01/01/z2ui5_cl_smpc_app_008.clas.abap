" @keywords colorpalette color palette sap.m standalone contai toolbar title label
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
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

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
                                                                      t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Color Selected: value - {0}, `
                                                                                                                        && |\n|
                                                                                                                        && ` defaultAction - {1}` ) ( `${$parameters>/value}` ) ( `${$parameters>/defaultAction}` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
