CLASS z2ui5_cl_smpc_app_390 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_390 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->leaf( `Label`
            )->a( n = `text` v = `Numeric content with margins`
        )->leaf( `NumericContent`
            )->a( n = `value`      v = `65.5`
            )->a( n = `scale`      v = `MM`
            )->a( n = `class`      v = `sapUiSmallMargin`
            )->a( n = `withMargin` v = `true`
        )->leaf( `NumericContent`
            )->a( n = `value`      v = `65.5`
            )->a( n = `scale`      v = `MM`
            )->a( n = `valueColor` v = `Good`
            )->a( n = `indicator`  v = `Up`
            )->a( n = `class`      v = `sapUiSmallMargin`
            )->a( n = `withMargin` v = `true`
        )->leaf( `NumericContent`
            )->a( n = `value`      v = `6666`
            )->a( n = `scale`      v = `MM`
            )->a( n = `valueColor` v = `Critical`
            )->a( n = `indicator`  v = `Up`
            )->a( n = `class`      v = `sapUiSmallMargin`
            )->a( n = `withMargin` v = `true`
        )->leaf( `NumericContent`
            )->a( n = `value`      v = `65.5`
            )->a( n = `scale`      v = `MM`
            )->a( n = `valueColor` v = `Error`
            )->a( n = `indicator`  v = `Down`
            )->a( n = `class`      v = `sapUiSmallMargin`
            )->a( n = `withMargin` v = `true`

        )->leaf( `Label`
            )->a( n = `text` v = `Numeric content without margins`
        )->leaf( `NumericContent`
            )->a( n = `value`      v = `65.5`
            )->a( n = `scale`      v = `MM`
            )->a( n = `class`      v = `sapUiSmallMargin`
            )->a( n = `withMargin` v = `false`
        )->leaf( `NumericContent`
            )->a( n = `value`      v = `65.5`
            )->a( n = `scale`      v = `MM`
            )->a( n = `valueColor` v = `Good`
            )->a( n = `indicator`  v = `Up`
            )->a( n = `class`      v = `sapUiSmallMargin`
            )->a( n = `withMargin` v = `false`
        )->leaf( `NumericContent`
            )->a( n = `value`      v = `6666`
            )->a( n = `scale`      v = `MM`
            )->a( n = `valueColor` v = `Critical`
            )->a( n = `indicator`  v = `Up`
            )->a( n = `class`      v = `sapUiSmallMargin`
            )->a( n = `withMargin` v = `false`
        )->leaf( `NumericContent`
            )->a( n = `value`      v = `65.5`
            )->a( n = `scale`      v = `MM`
            )->a( n = `valueColor` v = `Error`
            )->a( n = `indicator`  v = `Down`
            )->a( n = `class`      v = `sapUiSmallMargin`
            )->a( n = `withMargin` v = `false` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
