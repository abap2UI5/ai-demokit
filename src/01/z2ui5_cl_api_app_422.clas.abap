"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.m.ColorPalette - ColorPalette
"! https://sdk.openui5.org/entity/sap.m.ColorPalette/sample/sap.m.sample.ColorPalette
CLASS z2ui5_cl_api_app_422 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_422 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( ).

    page->simple_form(
        editable                = abap_true
        backgrounddesign        = `Transparent`
        singlecontainerfullsize = abap_true
        layout                  = `ResponsiveGridLayout`
        )->toolbar( ns = `form`
            )->toolbar(
                )->title( `Color Palette in a Form`
            )->get_parent(
        )->get_parent(
        )->content( `form`
            )->label( `Choose Color`
            )->color_palette( colorselect = client->_event( val   = `COLOR_SELECT`
                                                            t_arg = VALUE #( ( `${$parameters>/value}` ) ( `${$parameters>/defaultAction}` ) ) ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->check_on_event( `COLOR_SELECT` ).
      client->message_toast_display( |Color Selected: value - { client->get_event_arg( 1 ) }, \n defaultAction - { client->get_event_arg( 2 ) }| ).
    ENDIF.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.

ENDCLASS.
