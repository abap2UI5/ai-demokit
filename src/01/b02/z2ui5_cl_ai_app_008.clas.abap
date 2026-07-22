CLASS z2ui5_cl_ai_app_008 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_008 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:form` v = `sap.ui.layout.form`

        )->open( n = `SimpleForm` ns = `form`
            )->a( n = `editable`                v = `true`
            )->a( n = `backgroundDesign`        v = `Transparent`
            )->a( n = `singleContainerFullSize` v = `true`
            )->a( n = `layout`                  v = `ResponsiveGridLayout`

            )->open( n = `toolbar` ns = `form`
                )->open( `Toolbar`
                    )->leaf( `Title`
                        )->a( n = `text` v = `Color Palette in a Form`

                )->shut(
            )->shut(

            )->leaf( `Label`
                )->a( n = `text` v = `Choose Color`
            )->leaf( `ColorPalette`
                )->a( n = `colorSelect` v = client->_event_client( val   = client->cs_event-control_global
                                                                   t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Color Selected: value - {0}, \n defaultAction - {1}` ) ( `${$parameters>/value}` ) ( `${$parameters>/defaultAction}` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
