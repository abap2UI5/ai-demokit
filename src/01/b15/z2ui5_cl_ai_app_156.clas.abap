CLASS z2ui5_cl_ai_app_156 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_156 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " press -> MessageToast 'The numeric content is pressed.' (original)
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->leaf( `NumericContent`
            )->a( n = `value`          v = `888.8`
            )->a( n = `scale`          v = `MM`
            )->a( n = `class`          v = `sapUiSmallMargin`
            )->a( n = `press`          v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `The numeric content is pressed.` ) ) )
            )->a( n = `truncateValueTo` v = `4`
        )->leaf( `NumericContent`
            )->a( n = `value`      v = `65.5`
            )->a( n = `scale`      v = `MM`
            )->a( n = `valueColor` v = `Good`
            )->a( n = `indicator`  v = `Up`
            )->a( n = `class`      v = `sapUiSmallMargin`
            )->a( n = `press`      v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `The numeric content is pressed.` ) ) )
        )->leaf( `NumericContent`
            )->a( n = `value`      v = `6666`
            )->a( n = `scale`      v = `MM`
            )->a( n = `valueColor` v = `Critical`
            )->a( n = `indicator`  v = `Up`
            )->a( n = `class`      v = `sapUiSmallMargin`
            )->a( n = `press`      v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `The numeric content is pressed.` ) ) )
        )->leaf( `NumericContent`
            )->a( n = `value`      v = `65.5`
            )->a( n = `scale`      v = `MMill`
            )->a( n = `valueColor` v = `Error`
            )->a( n = `indicator`  v = `Down`
            )->a( n = `class`      v = `sapUiSmallMargin`
            )->a( n = `press`      v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `The numeric content is pressed.` ) ) )

        )->open( `GenericTile`
            )->a( n = `class`     v = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
            )->a( n = `header`    v = `Country-Specific Profit Margin`
            )->a( n = `subheader` v = `Expenses`
            )->a( n = `press`     v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `The numeric content is pressed.` ) ) )
            )->open( `TileContent`
                )->a( n = `unit`   v = `EUR`
                )->a( n = `footer` v = `Current Quarter`
                )->leaf( `NumericContent`
                    )->a( n = `scale`      v = `M`
                    )->a( n = `value`      v = `1.96`
                    )->a( n = `valueColor` v = `Error`
                    )->a( n = `indicator`  v = `Up`
                    )->a( n = `withMargin` v = `false` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
