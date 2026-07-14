"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.ui.layout.HorizontalLayout - HorizontalLayout
"! https://sdk.openui5.org/entity/sap.ui.layout.HorizontalLayout/sample/sap.ui.layout.sample.HorizontalLayout
CLASS z2ui5_cl_api_app_519 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_519 IMPLEMENTATION.

  METHOD view_display.

    " the original binds the images against the demo kit mock model - here the mock image URL is used directly
    DATA(image_url) = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7777-large.jpg`.

    DATA(page) = z2ui5_cl_xml_view=>factory( ).

    " the original sets the image widths depending on the device type - here the desktop widths are used
    page->horizontal_layout( class = `sapUiContentPadding`
        )->image(
            src          = image_url
            densityaware = abap_true
            width        = `5em`
        )->image(
            src          = image_url
            densityaware = abap_true
            width        = `10em`
        )->image(
            src          = image_url
            densityaware = abap_true
            width        = `15em` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
