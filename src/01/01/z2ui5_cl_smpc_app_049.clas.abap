" @keywords stepinput step input sap.m allows user change st list customlistitem hbox vbox
" @summary The StepInput allows the user to change stepwise a value by a predefined step and also to set additional description, such as units of measurement and currencies after the input field.
CLASS z2ui5_cl_smpc_app_049 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_row,
        label                 TYPE string,
        value                 TYPE p LENGTH 9 DECIMALS 4,
        min                   TYPE p LENGTH 9 DECIMALS 4,
        max                   TYPE p LENGTH 9 DECIMALS 4,
        step                  TYPE p LENGTH 9 DECIMALS 4,
        largerstep            TYPE p LENGTH 9 DECIMALS 4,
        displayvalueprecision TYPE i,
        width                 TYPE string,
        fieldwidth            TYPE string,
        description           TYPE string,
        textalign             TYPE string,
        stepmode              TYPE string,
        validationmode        TYPE string,
        valuestate            TYPE string,
        enabled               TYPE abap_bool,
        editable              TYPE abap_bool,
      END OF ty_s_row.
    DATA modeldata TYPE STANDARD TABLE OF ty_s_row WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_049 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    DATA temp2 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " one bound CustomListItem template over /modelData, like the original.
    " It only works because the rows are bound with omit_initial_paths: every row
    " fills a DIFFERENT subset of the StepInput properties, and an initial ABAP
    " field would otherwise arrive as `` and override the control's own default
    " (an enum-typed property rejects it outright). The omission is SCOPED to
    " those columns, because the two booleans must send their explicit false
    
    CLEAR temp1.
    INSERT `VALUE` INTO TABLE temp1.
    INSERT `MIN` INTO TABLE temp1.
    INSERT `MAX` INTO TABLE temp1.
    INSERT `STEP` INTO TABLE temp1.
    INSERT `LARGERSTEP` INTO TABLE temp1.
    INSERT `DISPLAYVALUEPRECISION` INTO TABLE temp1.
    INSERT `WIDTH` INTO TABLE temp1.
    INSERT `FIELDWIDTH` INTO TABLE temp1.
    INSERT `DESCRIPTION` INTO TABLE temp1.
    INSERT `TEXTALIGN` INTO TABLE temp1.
    INSERT `STEPMODE` INTO TABLE temp1.
    INSERT `VALIDATIONMODE` INTO TABLE temp1.
    INSERT `VALUESTATE` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `MESSAGE_TOAST` INTO TABLE temp2.
    INSERT `show` INTO TABLE temp2.
    INSERT `Value changed to '{0}'` INTO TABLE temp2.
    INSERT `${$parameters>/value}` INTO TABLE temp2.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->ele( `List`
            )->a( n = `id`    v = `idTable`
            )->a( n = `items` v = client->_bind(
                                      val                = modeldata
                                      " scoped to the columns that may vanish: an
                                      " abap_false MUST reach the client (the disabled
                                      " and the read-only row), and false is itself
                                      " initial - the blanket flag would drop it
                                      omit_initial_paths = temp1 )

            )->ele( `CustomListItem`
                )->ele( `HBox`
                    )->a( n = `class`          v = `sapUiTinyMargin`
                    )->a( n = `justifyContent` v = `SpaceBetween`
                    )->a( n = `alignItems`     v = `Center`

                    )->ele( `VBox`
                        )->a( n = `class` v = `sapUiSmallMarginEnd`

                        )->tag( `Label`
                            )->a( n = `text`     v = `{LABEL}`
                            )->a( n = `wrapping` v = `true`

                    )->end(
                    )->ele( `VBox`

                        )->tag( `StepInput`
                            )->a( n = `value`                 v = `{VALUE}`
                            )->a( n = `displayValuePrecision` v = `{DISPLAYVALUEPRECISION}`
                            )->a( n = `min`                   v = `{MIN}`
                            )->a( n = `max`                   v = `{MAX}`
                            )->a( n = `width`                 v = `{WIDTH}`
                            )->a( n = `step`                  v = `{STEP}`
                            )->a( n = `largerStep`            v = `{LARGERSTEP}`
                            )->a( n = `stepMode`              v = `{STEPMODE}`
                            )->a( n = `valueState`            v = `{VALUESTATE}`
                            )->a( n = `enabled`               v = `{ENABLED}`
                            )->a( n = `editable`              v = `{EDITABLE}`
                            )->a( n = `description`           v = `{DESCRIPTION}`
                            )->a( n = `fieldWidth`            v = `{FIELDWIDTH}`
                            )->a( n = `textAlign`             v = `{TEXTALIGN}`
                            )->a( n = `validationMode`        v = `{VALIDATIONMODE}`
                            )->a( n = `change`                v = client->follow_up_action( val   = client->cs_event-control_global
                                                                                            t_arg = temp2 ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " the controller's aData, row for row - a property a row does not set stays
    " INITIAL here and omit_initial_paths keeps it out of the model, so the
    " StepInput falls back to its own default exactly as in the original. The two
    " BOOLEAN columns are outside that list and therefore always travel: the rows
    " that the sample leaves untouched send the control default (true) explicitly,
    " and the disabled / read-only row sends its false - which the blanket
    " omit_initial would have swallowed
    DATA temp3 LIKE modeldata.
    DATA temp4 LIKE LINE OF temp3.
    CLEAR temp3.
    
    temp4-label = `Step = 1 (default); value = 6, min = 5, max = 15, width = 120px`.
    temp4-value = 6.
    temp4-min = 5.
    temp4-max = 15.
    temp4-width = `120px`.
    temp4-enabled = abap_true.
    temp4-editable = abap_true.
    INSERT temp4 INTO TABLE temp3.
    temp4-label = `Step = 1 (default); value = 6, min = 5, max = 15, width = 120px, with validation on LiveChange`.
    temp4-value = 6.
    temp4-min = 5.
    temp4-max = 15.
    temp4-width = `120px`.
    temp4-validationmode = `LiveChange`.
    temp4-enabled = abap_true.
    temp4-editable = abap_true.
    INSERT temp4 INTO TABLE temp3.
    temp4-label = `Step = 5, no value, no min, no max, width = 120px`.
    temp4-step = 5.
    temp4-width = `120px`.
    temp4-enabled = abap_true.
    temp4-editable = abap_true.
    INSERT temp4 INTO TABLE temp3.
    temp4-label = `Step = 5, no value, no min, no max, width = 120px, largerStep = 3`.
    temp4-step = 5.
    temp4-width = `120px`.
    temp4-largerstep = 3.
    temp4-enabled = abap_true.
    temp4-editable = abap_true.
    INSERT temp4 INTO TABLE temp3.
    temp4-label = `Step = 1.1, no value, displayValuePrecision = 1, min = -6, max = 23.5, width = 120px`.
    temp4-step = '1.1'.
    temp4-min = -6.
    temp4-max = '23.5'.
    temp4-width = `120px`.
    temp4-displayvalueprecision = 1.
    temp4-enabled = abap_true.
    temp4-editable = abap_true.
    INSERT temp4 INTO TABLE temp3.
    temp4-label = `Disabled, value = 12.3, displayValuePrecision = 1, width = 120px`.
    temp4-value = '12.3'.
    temp4-enabled = abap_false.
    temp4-editable = abap_true.
    temp4-width = `120px`.
    temp4-displayvalueprecision = 1.
    INSERT temp4 INTO TABLE temp3.
    temp4-label = `Read only, value = 123, default width of 100%`.
    temp4-editable = abap_false.
    temp4-enabled = abap_true.
    temp4-value = 123.
    INSERT temp4 INTO TABLE temp3.
    temp4-label = `Step = 0.05; value = 1.32, displayValuePrecision = 3, min = -5, max = 15`.
    temp4-value = '1.32'.
    temp4-step = '0.05'.
    temp4-min = -5.
    temp4-max = 15.
    temp4-displayvalueprecision = 3.
    temp4-enabled = abap_true.
    temp4-editable = abap_true.
    INSERT temp4 INTO TABLE temp3.
    temp4-label = `Step = 1.05; value = 1.5675, displayValuePrecision = 2, no Min and Max`.
    temp4-value = '1.5675'.
    temp4-step = '1.05'.
    temp4-displayvalueprecision = 2.
    temp4-enabled = abap_true.
    temp4-editable = abap_true.
    INSERT temp4 INTO TABLE temp3.
    temp4-label = `Step = -1 (which becomes 1), value = 20, width = 120px`.
    temp4-value = 20.
    temp4-step = -1.
    temp4-width = `120px`.
    temp4-enabled = abap_true.
    temp4-editable = abap_true.
    INSERT temp4 INTO TABLE temp3.
    temp4-label = `Step = 1 (default); value = 6, min = 5, max = 15, width = 240px, with added description and default fieldWidth 50%`.
    temp4-value = 6.
    temp4-min = 5.
    temp4-max = 15.
    temp4-width = `240px`.
    temp4-description = `EUR`.
    temp4-enabled = abap_true.
    temp4-editable = abap_true.
    INSERT temp4 INTO TABLE temp3.
    temp4-label = `Step = 1 (default); value = 160, with added description and fieldWidth set to 70%`.
    temp4-value = 160.
    temp4-fieldwidth = `70%`.
    temp4-description = `EUR`.
    temp4-enabled = abap_true.
    temp4-editable = abap_true.
    INSERT temp4 INTO TABLE temp3.
    temp4-label = `Step = 1 (default); value = 160, align:Center`.
    temp4-value = 160.
    temp4-textalign = `Center`.
    temp4-enabled = abap_true.
    temp4-editable = abap_true.
    INSERT temp4 INTO TABLE temp3.
    temp4-label = `Step = 5, stepMode = Multiple, min = -40, max = 100, value = 10,`.
    temp4-value = 10.
    temp4-step = 5.
    temp4-max = 100.
    temp4-min = -40.
    temp4-stepmode = `Multiple`.
    temp4-enabled = abap_true.
    temp4-editable = abap_true.
    INSERT temp4 INTO TABLE temp3.
    modeldata = temp3.

  ENDMETHOD.

ENDCLASS.
