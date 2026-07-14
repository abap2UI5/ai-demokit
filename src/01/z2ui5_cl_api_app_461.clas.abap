"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sdk.openui5.org/entity/sap.m.ObjectHeader/sample/sap.m.sample.ObjectHeaderCondensed
"! The Object Header is shown in condensed mode with title, number, number unit and one attribute.
CLASS z2ui5_cl_api_app_461 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_461 IMPLEMENTATION.

  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    view->object_header(
        title      = `Notebook Basic 15`
        condensed  = abap_true
        number     = `956.00`
        numberunit = `EUR`
        class      = `sapUiResponsivePadding--header`
        )->object_attribute( text = `4.2 KG 30 x 18 x 3 cm` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
