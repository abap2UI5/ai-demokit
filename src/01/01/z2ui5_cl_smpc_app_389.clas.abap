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
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " the controller's only handler is MessageToast.show('The GenericTile is
    " pressed.') - a constant text, so every press is the roundtrip-free
    " client toast (app 005/275 idiom) and the app stays init-only
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        " the sample's style.css, injected via a core:HTML content attribute
        " (app 275 precedent); the literal braces are escaped \{ \}
        )->leaf( n = `HTML` ns = `core`
            )->a( n = `content` v = `<style>.tileLayout \{float: left;\}</style>`

        )->open( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Cumulative Totals`
            )->a( n = `subheader` v = `Expenses`
            )->a( n = `press`     v = client->follow_up_action( val   = client->cs_event-control_global
                                                                t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `The GenericTile is pressed.` ) ) )

            )->open( `TileContent`
                )->a( n = `unit`   v = `Unit`
                )->a( n = `footer` v = `Footer Text`

                )->leaf( `NumericContent`
                    )->a( n = `value`      v = `1762`
                    )->a( n = `icon`       v = `sap-icon://line-charts`
                    )->a( n = `withMargin` v = `false`

        )->shut(
        )->shut(

        )->open( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Cumulative Totals`
            )->a( n = `subheader` v = `Expenses`
            )->a( n = `press`     v = client->follow_up_action( val   = client->cs_event-control_global
                                                                t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `The GenericTile is pressed.` ) ) )

            )->open( `TileContent`
                )->a( n = `unit`   v = `Unit`
                )->a( n = `footer` v = `Footer Text`

                )->leaf( `NumericContent`
                    )->a( n = `value`      v = `12`
                    )->a( n = `withMargin` v = `false` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
