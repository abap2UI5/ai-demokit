" @keywords numericcontent numeric content sap.m colors generictile tilecontent
" @summary Shows NumericContent including numbers, units of measurement, and status arrows indicating a trend. The numbers can be colored according to their meaning.
CLASS z2ui5_cl_smpc_app_156 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_156 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    DATA temp2 TYPE string_table.
    DATA temp3 TYPE string_table.
    DATA temp4 TYPE string_table.
    DATA temp5 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " press -> MessageToast 'The numeric content is pressed.' (original)
    
    CLEAR temp1.
    INSERT `MESSAGE_TOAST` INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    INSERT `The numeric content is pressed.` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `MESSAGE_TOAST` INTO TABLE temp2.
    INSERT `show` INTO TABLE temp2.
    INSERT `The numeric content is pressed.` INTO TABLE temp2.
    
    CLEAR temp3.
    INSERT `MESSAGE_TOAST` INTO TABLE temp3.
    INSERT `show` INTO TABLE temp3.
    INSERT `The numeric content is pressed.` INTO TABLE temp3.
    
    CLEAR temp4.
    INSERT `MESSAGE_TOAST` INTO TABLE temp4.
    INSERT `show` INTO TABLE temp4.
    INSERT `The numeric content is pressed.` INTO TABLE temp4.
    
    CLEAR temp5.
    INSERT `MESSAGE_TOAST` INTO TABLE temp5.
    INSERT `show` INTO TABLE temp5.
    INSERT `The numeric content is pressed.` INTO TABLE temp5.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->tag( `NumericContent`
            )->a( n = `value`          v = `888.8`
            )->a( n = `scale`          v = `MM`
            )->a( n = `class`          v = `sapUiSmallMargin`
            )->a( n = `press`          v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp1 )
            )->a( n = `truncateValueTo` v = `4`
        )->tag( `NumericContent`
            )->a( n = `value`      v = `65.5`
            )->a( n = `scale`      v = `MM`
            )->a( n = `valueColor` v = `Good`
            )->a( n = `indicator`  v = `Up`
            )->a( n = `class`      v = `sapUiSmallMargin`
            )->a( n = `press`      v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp2 )
        )->tag( `NumericContent`
            )->a( n = `value`      v = `6666`
            )->a( n = `scale`      v = `MM`
            )->a( n = `valueColor` v = `Critical`
            )->a( n = `indicator`  v = `Up`
            )->a( n = `class`      v = `sapUiSmallMargin`
            )->a( n = `press`      v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp3 )
        )->tag( `NumericContent`
            )->a( n = `value`      v = `65.5`
            )->a( n = `scale`      v = `MMill`
            )->a( n = `valueColor` v = `Error`
            )->a( n = `indicator`  v = `Down`
            )->a( n = `class`      v = `sapUiSmallMargin`
            )->a( n = `press`      v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp4 )

        )->ele( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Country-Specific Profit Margin`
            )->a( n = `subheader` v = `Expenses`
            )->a( n = `press`     v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp5 )
            )->ele( `TileContent`
                )->a( n = `unit`   v = `EUR`
                )->a( n = `footer` v = `Current Quarter`
                )->tag( `NumericContent`
                    )->a( n = `scale`      v = `M`
                    )->a( n = `value`      v = `1.96`
                    )->a( n = `valueColor` v = `Error`
                    )->a( n = `indicator`  v = `Up`
                    )->a( n = `withMargin` v = `false` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
