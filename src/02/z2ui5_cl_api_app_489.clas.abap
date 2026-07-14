"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.ui.core.ContainerPadding - ContainerPaddingAndMargin
"! https://sdk.openui5.org/entity/sap.ui.core.ContainerPadding/sample/sap.m.sample.ContainerPaddingAndMargin
CLASS z2ui5_cl_api_app_489 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_489 IMPLEMENTATION.

  METHOD view_display.

    DATA(strip_text) = `A layout container by default does not add margins or paddings to the content area. ` &&
      `By combining the margin and padding concepts you can flexibly design your application layout ` &&
      `without having to add any custom CSS. This example shows a HorizontalLayout that is layouted ` &&
      `with the standard margin and padding classes provided by UI5.`.

    " the original binds the images against the demo kit mock model - here the mock image URL is used directly
    DATA(image_url) = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7777-large.jpg`.

    DATA(page) = z2ui5_cl_xml_view=>factory( ).

    page->message_strip(
        text  = strip_text
        class = `sapUiTinyMargin` ).

    " the original sets the image widths depending on the device type - here the desktop widths are used
    DATA(layout) = page->scroll_container(
                       )->horizontal_layout( class = `sapUiContentPadding` ).

    layout->image(
        densityaware = abap_false
        src          = image_url
        width        = `5em`
        class        = `sapUiSmallMarginEnd` )->get(
        )->layout_data(
            )->flex_item_data( growfactor = `1` ).

    layout->image(
        densityaware = abap_false
        src          = image_url
        width        = `10em`
        class        = `sapUiSmallMarginEnd` )->get(
        )->layout_data(
            )->flex_item_data( growfactor = `2` ).

    layout->image(
        densityaware = abap_false
        src          = image_url
        width        = `15em` )->get(
        )->layout_data(
            )->flex_item_data( growfactor = `3` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
