"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.ui.core.StandardMargins - StandardMarginsCollapse
"! https://sdk.openui5.org/entity/sap.ui.core.StandardMargins/sample/sap.m.sample.StandardMarginsCollapse
CLASS z2ui5_cl_api_app_492 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_492 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( ).

    page->panel( class = `sapUiSmallMarginBottom`
        )->content(
            )->text( `This panel has a 16px (1rem) bottom margin.` ).

    page->panel(
        width = `auto`
        class = `sapUiSmallMargin`
        )->content(
            )->text( `This panel has a 16px margin all around. As you can see, the margins do not add to the margins of the bottom or top panel.` ).

    page->panel( class = `sapUiSmallMarginTop`
        )->content(
            )->text( `This panel has a 16px top margin.` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
