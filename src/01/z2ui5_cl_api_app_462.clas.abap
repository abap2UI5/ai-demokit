"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.m.ObjectHeader - ObjectHeaderImage
"! https://sdk.openui5.org/entity/sap.m.ObjectHeader/sample/sap.m.sample.ObjectHeaderImage
CLASS z2ui5_cl_api_app_462 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_462 IMPLEMENTATION.

  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(header) = view->object_header(
        icon             = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg`
        icondensityaware = abap_false
        iconalt          = `Notebook Professional 15`
        title            = `Notebook Professional 15`
        number           = `1,999.00`
        numberunit       = `EUR`
        class            = `sapUiResponsivePadding--header` ).

    header->_generic( `statuses`
        )->object_status(
            text  = `In Stock`
            state = `Success` ).

    header->object_attribute( text = `4.3 KG`
        )->object_attribute( text = `33 x 20 x 3 cm`
        )->object_attribute( text = `Notebook Professional 15 with 2,80 GHz quad core, 15" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
