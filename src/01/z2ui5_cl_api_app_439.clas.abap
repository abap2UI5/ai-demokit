"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.m.Input - InputValueState
"! https://sdk.openui5.org/entity/sap.m.Input/sample/sap.m.sample.InputValueState
CLASS z2ui5_cl_api_app_439 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_439 IMPLEMENTATION.

  METHOD view_display.

    DATA(warning_text) = `Warning message. Extra long text used as a warning message. Extra long text used as a warning message - 2. ` &&
                         `Extra long text used as a warning message - 3. Extra long text used as a warning message - 4. ` &&
                         `Extra long text used as a warning message - 5.`.

    DATA(page) = z2ui5_cl_xml_view=>factory( ).

    DATA(box) = page->vbox( `sapUiSmallMargin` ).

    box->input( value = `Value state None`
                class = `sapUiSmallMarginTopBottom` ).

    " property showClearIcon="true" omitted - only available since UI5 1.94
    box->input( valuestate = `Success`
                value      = `Value state Success`
                class      = `sapUiSmallMarginTopBottom` ).

    box->input( valuestate     = `Warning`
                valuestatetext = warning_text
                value          = `Value state Warning.`
                class          = `sapUiSmallMarginTopBottom` ).

    " aggregation formattedValueStateText with a link omitted - only available since UI5 1.78
    box->input( valuestate = `Warning`
                value      = `Value state Warning with message containing a link.`
                class      = `sapUiSmallMarginTopBottom` ).

    box->input( valuestate = `Error`
                value      = `Value state Error`
                class      = `sapUiSmallMarginTopBottom` ).

    box->input( valuestate = `Information`
                value      = `Value state Information`
                class      = `sapUiSmallMarginTopBottom` ).

    " aggregation formattedValueStateText with multiple links omitted - only available since UI5 1.78
    box->input( valuestate = `Information`
                value      = `Value state Information with message containing multiple links.`
                class      = `sapUiSmallMarginTopBottom` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
