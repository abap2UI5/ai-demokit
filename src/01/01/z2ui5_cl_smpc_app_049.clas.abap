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
    DATA modeldata TYPE STANDARD TABLE OF ty_s_row WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_049 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " one bound CustomListItem template over /modelData, like the original.
    " It only works because the rows are bound with omit_initial_paths: every row
    " fills a DIFFERENT subset of the StepInput properties, and an initial ABAP
    " field would otherwise arrive as `` and override the control's own default
    " (an enum-typed property rejects it outright). The omission is SCOPED to
    " those columns, because the two booleans must send their explicit false
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
                                      omit_initial_paths = VALUE #( ( `VALUE` )
                                                                    ( `MIN` )
                                                                    ( `MAX` )
                                                                    ( `STEP` )
                                                                    ( `LARGERSTEP` )
                                                                    ( `DISPLAYVALUEPRECISION` )
                                                                    ( `WIDTH` )
                                                                    ( `FIELDWIDTH` )
                                                                    ( `DESCRIPTION` )
                                                                    ( `TEXTALIGN` )
                                                                    ( `STEPMODE` )
                                                                    ( `VALIDATIONMODE` )
                                                                    ( `VALUESTATE` ) ) )

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
                                                                                            t_arg = VALUE #( ( `MESSAGE_TOAST` )
                                                                                                             ( `show` )
                                                                                                             ( `Value changed to '{0}'` )
                                                                                                             ( `${$parameters>/value}` ) ) ) ).

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
    modeldata = VALUE #(
        ( label = `Step = 1 (default); value = 6, min = 5, max = 15, width = 120px`
          value = 6 min = 5 max = 15 width = `120px` enabled = abap_true editable = abap_true )
        ( label = `Step = 1 (default); value = 6, min = 5, max = 15, width = 120px, with validation on LiveChange`
          value = 6 min = 5 max = 15 width = `120px` validationmode = `LiveChange` enabled = abap_true editable = abap_true )
        ( label = `Step = 5, no value, no min, no max, width = 120px`
          step = 5 width = `120px` enabled = abap_true editable = abap_true )
        ( label = `Step = 5, no value, no min, no max, width = 120px, largerStep = 3`
          step = 5 width = `120px` largerstep = 3 enabled = abap_true editable = abap_true )
        ( label = `Step = 1.1, no value, displayValuePrecision = 1, min = -6, max = 23.5, width = 120px`
          step = '1.1' min = -6 max = '23.5' width = `120px` displayvalueprecision = 1 enabled = abap_true editable = abap_true )
        ( label = `Disabled, value = 12.3, displayValuePrecision = 1, width = 120px`
          value = '12.3' enabled = abap_false editable = abap_true width = `120px` displayvalueprecision = 1 )
        ( label = `Read only, value = 123, default width of 100%`
          editable = abap_false enabled = abap_true value = 123 )
        ( label = `Step = 0.05; value = 1.32, displayValuePrecision = 3, min = -5, max = 15`
          value = '1.32' step = '0.05' min = -5 max = 15 displayvalueprecision = 3 enabled = abap_true editable = abap_true )
        ( label = `Step = 1.05; value = 1.5675, displayValuePrecision = 2, no Min and Max`
          value = '1.5675' step = '1.05' displayvalueprecision = 2 enabled = abap_true editable = abap_true )
        ( label = `Step = -1 (which becomes 1), value = 20, width = 120px`
          value = 20 step = -1 width = `120px` enabled = abap_true editable = abap_true )
        ( label = `Step = 1 (default); value = 6, min = 5, max = 15, width = 240px, with added description and default fieldWidth 50%`
          value = 6 min = 5 max = 15 width = `240px` description = `EUR` enabled = abap_true editable = abap_true )
        ( label = `Step = 1 (default); value = 160, with added description and fieldWidth set to 70%`
          value = 160 fieldwidth = `70%` description = `EUR` enabled = abap_true editable = abap_true )
        ( label = `Step = 1 (default); value = 160, align:Center`
          value = 160 textalign = `Center` enabled = abap_true editable = abap_true )
        ( label = `Step = 5, stepMode = Multiple, min = -40, max = 100, value = 10,`
          value = 10 step = 5 max = 100 min = -40 stepmode = `Multiple` enabled = abap_true editable = abap_true ) ).

  ENDMETHOD.

ENDCLASS.
