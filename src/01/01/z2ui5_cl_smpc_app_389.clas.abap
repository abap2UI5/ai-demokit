" @keywords generictile generic tile sap.m generictileasmonitortile html tilecontent numericcontent
" @summary Shows Monitor Tile samples that can contain header, subheader, icon, key value, unit, and a footer.
CLASS z2ui5_cl_smpc_app_389 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_389 IMPLEMENTATION.

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
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " the controller's only handler is MessageToast.show('The GenericTile is
    " pressed.') - a constant text, so every press is the roundtrip-free
    " client toast (app 005/275 idiom) and the app stays init-only
    
    CLEAR temp1.
    INSERT `MESSAGE_TOAST` INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    INSERT `The GenericTile is pressed.` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `MESSAGE_TOAST` INTO TABLE temp2.
    INSERT `show` INTO TABLE temp2.
    INSERT `The GenericTile is pressed.` INTO TABLE temp2.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        " the sample's style.css, injected via a core:HTML content attribute
        " (app 275 precedent); the literal braces are escaped \{ \}
        )->tag( n = `HTML` ns = `core`
            )->a( n = `content` v = `<style>.tileLayout \{float: left;\}</style>`

        )->ele( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Cumulative Totals`
            )->a( n = `subheader` v = `Expenses`
            )->a( n = `press`     v = client->follow_up_action( val   = client->cs_event-control_global
                                                                t_arg = temp1 )

            )->ele( `TileContent`
                )->a( n = `unit`   v = `Unit`
                )->a( n = `footer` v = `Footer Text`

                )->tag( `NumericContent`
                    )->a( n = `value`      v = `1762`
                    )->a( n = `icon`       v = `sap-icon://line-charts`
                    )->a( n = `withMargin` v = `false`

            )->end(
        )->end(

        )->ele( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Cumulative Totals`
            )->a( n = `subheader` v = `Expenses`
            )->a( n = `press`     v = client->follow_up_action( val   = client->cs_event-control_global
                                                                t_arg = temp2 )

            )->ele( `TileContent`
                )->a( n = `unit`   v = `Unit`
                )->a( n = `footer` v = `Footer Text`

                )->tag( `NumericContent`
                    )->a( n = `value`      v = `12`
                    )->a( n = `withMargin` v = `false` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
