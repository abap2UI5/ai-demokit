" @keywords numericcontent numeric content sap.m numericcontentwithoutmargin label
" @summary This is an example of the NumericContent that contains no margins, so the control is aligned to the left and to the top without any margins.
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
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->tag( `Label`
            )->a( n = `text` v = `Numeric content with margins`
        )->tag( `NumericContent`
            )->a( n = `value`      v = `65.5`
            )->a( n = `scale`      v = `MM`
            )->a( n = `class`      v = `sapUiSmallMargin`
            )->a( n = `withMargin` v = `true`
        )->tag( `NumericContent`
            )->a( n = `value`      v = `65.5`
            )->a( n = `scale`      v = `MM`
            )->a( n = `valueColor` v = `Good`
            )->a( n = `indicator`  v = `Up`
            )->a( n = `class`      v = `sapUiSmallMargin`
            )->a( n = `withMargin` v = `true`
        )->tag( `NumericContent`
            )->a( n = `value`      v = `6666`
            )->a( n = `scale`      v = `MM`
            )->a( n = `valueColor` v = `Critical`
            )->a( n = `indicator`  v = `Up`
            )->a( n = `class`      v = `sapUiSmallMargin`
            )->a( n = `withMargin` v = `true`
        )->tag( `NumericContent`
            )->a( n = `value`      v = `65.5`
            )->a( n = `scale`      v = `MM`
            )->a( n = `valueColor` v = `Error`
            )->a( n = `indicator`  v = `Down`
            )->a( n = `class`      v = `sapUiSmallMargin`
            )->a( n = `withMargin` v = `true`

        )->tag( `Label`
            )->a( n = `text` v = `Numeric content without margins`
        )->tag( `NumericContent`
            )->a( n = `value`      v = `65.5`
            )->a( n = `scale`      v = `MM`
            )->a( n = `class`      v = `sapUiSmallMargin`
            )->a( n = `withMargin` v = `false`
        )->tag( `NumericContent`
            )->a( n = `value`      v = `65.5`
            )->a( n = `scale`      v = `MM`
            )->a( n = `valueColor` v = `Good`
            )->a( n = `indicator`  v = `Up`
            )->a( n = `class`      v = `sapUiSmallMargin`
            )->a( n = `withMargin` v = `false`
        )->tag( `NumericContent`
            )->a( n = `value`      v = `6666`
            )->a( n = `scale`      v = `MM`
            )->a( n = `valueColor` v = `Critical`
            )->a( n = `indicator`  v = `Up`
            )->a( n = `class`      v = `sapUiSmallMargin`
            )->a( n = `withMargin` v = `false`
        )->tag( `NumericContent`
            )->a( n = `value`      v = `65.5`
            )->a( n = `scale`      v = `MM`
            )->a( n = `valueColor` v = `Error`
            )->a( n = `indicator`  v = `Down`
            )->a( n = `class`      v = `sapUiSmallMargin`
            )->a( n = `withMargin` v = `false` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
