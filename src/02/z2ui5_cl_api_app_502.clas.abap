"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.ui.core.theming - BasicThemeParameters
"! https://sdk.openui5.org/entity/sap.ui.core.theming/sample/sap.ui.core.sample.BasicThemeParameters
CLASS z2ui5_cl_api_app_502 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_502 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      DATA(page) = z2ui5_cl_xml_view=>factory( ).

      page->vertical_layout(
          class = `sapUiContentPadding`
          width = `100%`
          )->content( `layout`
              )->message_strip(
                  text     = `This sample is replaced with the Theme Parameter Toolbox. You can easily search, preview, and filter semantic theme parameters.`
                  type     = `Information`
                  showicon = abap_true
                  class    = `sapUiMediumMarginBottom`
              )->link(
                  text   = `Click here to open the Theme Parameter Toolbox`
                  target = `_blank`
                  href   = `https://sdk.openui5.org/test-resources/sap/m/demokit/theming/webapp/index.html` ).

      client->view_display( page->stringify( ) ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
