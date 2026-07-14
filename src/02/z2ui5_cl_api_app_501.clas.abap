"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.ui.core.Icon - Icon
"! https://sdk.openui5.org/entity/sap.ui.core.Icon/sample/sap.ui.core.sample.Icon
CLASS z2ui5_cl_api_app_501 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_501 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_event( `STETHOSCOPE` ).
      client->message_toast_display( `Over budget!` ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( ).

    " The font sizes of the sample's CSS classes (size1-size5) are set via the size property - custom CSS is not available here
    page->hbox( class = `sapUiSmallMargin`
        )->icon(
            src   = `sap-icon://syringe`
            size  = `1.5rem`
            color = `#031E48` )->get(
            )->layout_data(
                )->flex_item_data( growfactor = `1` )->get_parent( )->get_parent(
        )->icon(
            src   = `sap-icon://pharmacy`
            size  = `2.5rem`
            color = `#64E4CE` )->get(
            )->layout_data(
                )->flex_item_data( growfactor = `1` )->get_parent( )->get_parent(
        )->icon(
            src   = `sap-icon://electrocardiogram`
            size  = `5rem`
            color = `#E69A17` )->get(
            )->layout_data(
                )->flex_item_data( growfactor = `1` )->get_parent( )->get_parent(
        )->icon(
            src   = `sap-icon://doctor`
            size  = `7.5rem`
            color = `#1C4C98` )->get(
            )->layout_data(
                )->flex_item_data( growfactor = `1` )->get_parent( )->get_parent(
        )->icon(
            src   = `sap-icon://stethoscope`
            size  = `10rem`
            color = `#8875E7`
            press = client->_event( `STETHOSCOPE` ) )->get(
            )->layout_data(
                )->flex_item_data( growfactor = `1` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
