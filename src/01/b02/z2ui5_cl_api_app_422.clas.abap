CLASS z2ui5_cl_api_app_422 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_422 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_api_xml.
    DATA temp1 TYPE string_table.
    view = z2ui5_cl_api_xml=>factory( ).

    
    CLEAR temp1.
    INSERT `${$parameters>/value}` INTO TABLE temp1.
    INSERT `${$parameters>/defaultAction}` INTO TABLE temp1.
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
                )->a( n = `colorSelect` v = client->_event( val   = `COLOR_SELECT`
                                                            t_arg = temp1 ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA temp3 TYPE string.
        DATA default_action LIKE temp3.

    CASE client->get( )-event.

      WHEN `COLOR_SELECT`.
        " the boolean defaultAction parameter arrives as abap_bool (X/space) -
        " render it as true/false, like the original controller's string output
        
        IF client->get_event_arg( 2 ) = abap_true.
          temp3 = `true`.
        ELSE.
          temp3 = `false`.
        ENDIF.
        
        default_action = temp3.
        client->message_toast_display( |Color Selected: value - { client->get_event_arg( ) }, \n defaultAction - { default_action }| ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
