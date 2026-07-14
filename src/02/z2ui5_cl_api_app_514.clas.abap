"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.ui.layout.FixFlex - FixFlexHorizontal
"! https://sdk.openui5.org/entity/sap.ui.layout.FixFlex/sample/sap.ui.layout.sample.FixFlexHorizontal
CLASS z2ui5_cl_api_app_514 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_514 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( ).

    " the original adds background colors for the fix and flex parts via custom CSS - omitted here
    DATA(layout) = page->fix_flex(
        ns    = `layout`
        class = `fixFlexHorizontal` ).
    " the wrapper fix_flex method does not support the vertical property - generic property used
    layout->_generic_property( VALUE #( n = `vertical` v = `false` ) ).

    " the original binds the image against the demo kit mock model - here the mock image URL is used directly
    layout->fix_content( `layout`
        )->image(
            src          = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7777-large.jpg`
            densityaware = abap_true )->get_parent(
    )->flex_content( `layout`
        )->text(
            class = `column1`
            text  = `This container is flexible and it will adapts its size to fill the remaining size in the FixFlex control` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
