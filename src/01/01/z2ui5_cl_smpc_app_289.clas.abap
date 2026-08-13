CLASS z2ui5_cl_smpc_app_289 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA strip_visible TYPE abap_bool.
    DATA strip_text    TYPE string.
    " MessageStrip.type is an enum: an empty string is rejected by
    " validateProperty, so the field carries the control's own default
    DATA strip_type    TYPE string VALUE `Information`.
    DATA show_icon     TYPE abap_bool.
    DATA show_close    TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    " how often the button was pressed - drives the rotation that replaces the
    " original's Math.random( ); not bound, so it stays out of the model
    DATA press_count TYPE i.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_289 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " the original builds the MessageStrip in the controller and adds it to the
    " VerticalLayout (destroying the previous one first). Here it is part of the
    " view and its four varying properties are bound; visible keeps it out of
    " the layout until the button was pressed once
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->open( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `id`    v = `oVerticalContent`
            )->a( n = `width` v = `100%`

            )->open( n = `content` ns = `l`
                )->leaf( `Button`
                    )->a( n = `text`  v = `Generate MessageStrip`
                    )->a( n = `class` v = `sapUiSmallMarginBottom`
                    )->a( n = `press` v = client->_event( `GENERATE` )
                    )->a( n = `width` v = `250px`

                )->leaf( `MessageStrip`
                    )->a( n = `id`              v = `msgStrip`
                    )->a( n = `visible`         v = client->_bind( strip_visible )
                    )->a( n = `text`            v = client->_bind( strip_text )
                    )->a( n = `type`            v = client->_bind( strip_type )
                    )->a( n = `showIcon`        v = client->_bind( show_icon )
                    )->a( n = `showCloseButton` v = client->_bind( show_close ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `GENERATE`.
        " _generateMsgStrip picks type, showIcon and showCloseButton at random.
        " Randomness is a decision, so it is taken in ABAP - and taken
        " DETERMINISTICALLY: the press counter rotates through the four types
        " and through the two flag combinations, so every press still changes
        " the strip and the port stays reproducible
        press_count   = press_count + 1.
        strip_visible = abap_true.
        strip_text    = `Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua ut enim ` &&
                        `ad minim veniam, quis nostrud exercitation ullamco.`.
        strip_type    = SWITCH string( press_count MOD 4
                                       WHEN 1 THEN `Information`
                                       WHEN 2 THEN `Warning`
                                       WHEN 3 THEN `Error`
                                       WHEN 0 THEN `Success` ).
        show_icon     = xsdbool( press_count MOD 2 = 1 ).
        show_close    = xsdbool( press_count MOD 3 <> 0 ).

        " onInit takes an InvisibleMessage instance and _generateMsgStrip
        " announces the new strip assertively. InvisibleMessage is a singleton
        " with no control id, so the announcement goes through the global
        " target added for it (pr/invisible-message-announce)
        client->follow_up_action( val   = client->cs_event-control_global
                                  t_arg = VALUE #( ( `INVISIBLE_MESSAGE` )
                                                   ( `announce` )
                                                   ( |New Information Bar of type { strip_type }| )
                                                   ( `Assertive` ) ) ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
