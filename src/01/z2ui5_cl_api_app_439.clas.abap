"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.m.Input - InputValueState
"! https://sdk.openui5.org/entity/sap.m.Input/sample/sap.m.sample.InputValueState
CLASS z2ui5_cl_api_app_439 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_439 IMPLEMENTATION.

  " NOTES (generation):
  " - 1.71: Input property showClearIcon (since UI5 1.94) dropped from three inputs.
  " - 1.71: the two formattedValueStateText aggregations (a FormattedText carrying
  "   Links, since UI5 1.78) omitted; valueState/valueStateText still render the state.

  METHOD view_display.

    DATA(warning_text) = `Warning message. Extra long text used as a warning message. Extra long text used as a warning message - 2. ` &&
                         `Extra long text used as a warning message - 3. Extra long text used as a warning message - 4. ` &&
                         `Extra long text used as a warning message - 5.`.

    DATA(view) = z2ui5_cl_api_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->attr( n = `xmlns`     v = `sap.m`
        )->attr( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->open( `VBox`
            )->attr( n = `class` v = `sapUiSmallMargin`

            )->leaf( `Input`
                )->attr( n = `value` v = `Value state None`
                )->attr( n = `class` v = `sapUiSmallMarginTopBottom`

            " showClearIcon="true" omitted - Input property only available since UI5 1.94
            )->leaf( `Input`
                )->attr( n = `valueState` v = `Success`
                )->attr( n = `value`      v = `Value state Success`
                )->attr( n = `class`      v = `sapUiSmallMarginTopBottom`

            )->leaf( `Input`
                )->attr( n = `valueState`     v = `Warning`
                )->attr( n = `valueStateText` v = warning_text
                )->attr( n = `value`          v = `Value state Warning.`
                )->attr( n = `class`          v = `sapUiSmallMarginTopBottom`

            " formattedValueStateText (FormattedText with a Link) omitted - only available since UI5 1.78
            )->leaf( `Input`
                )->attr( n = `valueState` v = `Warning`
                )->attr( n = `value`      v = `Value state Warning with message containing a link.`
                )->attr( n = `class`      v = `sapUiSmallMarginTopBottom`

            )->leaf( `Input`
                )->attr( n = `valueState` v = `Error`
                )->attr( n = `value`      v = `Value state Error`
                )->attr( n = `class`      v = `sapUiSmallMarginTopBottom`

            )->leaf( `Input`
                )->attr( n = `valueState` v = `Information`
                )->attr( n = `value`      v = `Value state Information`
                )->attr( n = `class`      v = `sapUiSmallMarginTopBottom`

            " formattedValueStateText (FormattedText with multiple Links) omitted - only available since UI5 1.78
            )->leaf( `Input`
                )->attr( n = `valueState` v = `Information`
                )->attr( n = `value`      v = `Value state Information with message containing multiple links.`
                )->attr( n = `class`      v = `sapUiSmallMarginTopBottom` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
