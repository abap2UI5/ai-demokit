"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.ui.core.StandardMargins - StandardMarginsSingleSided
"! https://sdk.openui5.org/entity/sap.ui.core.StandardMargins/sample/sap.m.sample.StandardMarginsSingleSided
CLASS z2ui5_cl_api_app_495 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_495 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( ).

    page->panel(
        width = `auto`
        class = `sapUiLargeMarginBegin sapUiLargeMarginBottom`
        )->content(
            )->text(
                text  = `This panel uses margin classes 'sapUiLargeMarginBegin' and 'sapUiLargeMarginBottom' to clear a 48px (3rem) space to the left and bottom.`
                class = `sapMH4FontSize`
            )->text( `Since panels have a default width of 100%, horizontal margins are not displayed appropriately. Therefore we need to set the panel's 'width' property to 'auto'.` ).

    page->text(
        text  = `To see what happens in Right-To-Left mode open 'Settings' by pressing the cog wheel button next to 'Entities'.`
        class = `sapUiExploredNoMarginInfo` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
