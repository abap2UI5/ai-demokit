"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.m.ObjectIdentifier - ObjectIdentifier
"! https://sdk.openui5.org/entity/sap.m.ObjectIdentifier/sample/sap.m.sample.ObjectIdentifier
CLASS z2ui5_cl_api_app_466 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_api_app_466 IMPLEMENTATION.

  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    " data of /ProductCollection/0 of the mock model sap/ui/demo/mock/products.json used by the original sample
    view->vertical_layout(
        class = `sapUiContentPadding`
        width = `100%`
        )->object_identifier(
            title       = `Power Projector 4713`
            text        = `A very powerful projector with special features for Internet usability, USB`
            titleactive = abap_true
            titlepress  = client->_event( `TITLE_PRESSED` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->check_on_event( `TITLE_PRESSED` ).
      client->message_box_display( `Title was clicked!` ).
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
