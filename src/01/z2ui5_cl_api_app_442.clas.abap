"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.m.List - ListFooter
"! https://sdk.openui5.org/entity/sap.m.List/sample/sap.m.sample.ListFooter
CLASS z2ui5_cl_api_app_442 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_442 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( ).

    " The iconDensityAware property of the original sample is not available in the view API and is omitted here
    page->list(
           headertext = `Products`
           footertext = `This is the footer text`
           )->items(
               )->standard_list_item(
                   title       = `Notebook Basic 15`
                   description = `HT-1000`
                   icon        = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg`
                   iconinset   = abap_false ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
