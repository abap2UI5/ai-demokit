CLASS z2ui5_cl_dmo_app_147 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_dmo_app_147 IMPLEMENTATION.

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

    view->open( n = `View` ns = `mvc`
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`

        )->open( `Page`
            )->a( n = `class`      v = `sapUiFioriObjectPage`
            )->a( n = `showHeader` v = `false`

            )->open( `content`
                )->open( `Panel`
                    )->leaf( `Text`
                        )->a( n = `text` v = `Press a button to show the global BusyIndicator`

                )->shut(

                )->open( `Panel`
                    )->a( n = `headerText` v = `Open BusyIndicator for four seconds (default delay, which is 1 second)`
                    )->open( `content`
                        )->leaf( `Button`
                            )->a( n = `text`  v = `Show BusyIndicator`
                            )->a( n = `press` v = client->_event( `SHOW_4000` )

                    )->shut(
                )->shut(

                )->open( `Panel`
                    )->a( n = `headerText` v = `Open BusyIndicator for four seconds (zero delay)`
                    )->open( `content`
                        )->leaf( `Button`
                            )->a( n = `text`  v = `Show BusyIndicator`
                            )->a( n = `press` v = client->_event( `SHOW_4000_0` )

                    )->shut(
                )->shut(

                )->open( `Panel`
                    )->a( n = `headerText` v = `Open BusyIndicator for one second (two seconds delay, so it should never appear at all)`
                    )->open( `content`
                        )->leaf( `Button`
                            )->a( n = `text`  v = `Show BusyIndicator`
                            )->a( n = `press` v = client->_event( `SHOW_1000_2000` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    " original showBusyIndicator(iDuration, iDelay): BusyIndicator.show(iDelay)
    " plus a setTimeout that hides it after iDuration - reproduced with the
    " BUSY_INDICATOR global target and START_TIMER (a new timer replaces the
    " previous one, matching the original's clearTimeout of _sTimeoutId)
    CASE client->get( )-event.

      WHEN `SHOW_4000`.
        " show4000: default delay (1 second), hide after 4 seconds
        client->follow_up_action( val   = client->cs_event-control_global
                                  t_arg = VALUE #( ( `BUSY_INDICATOR` ) ( `show` ) ) ).
        client->follow_up_action( val   = client->cs_event-start_timer
                                  t_arg = VALUE #( ( `HIDE_BUSY` ) ( `4000` ) ) ).

      WHEN `SHOW_4000_0`.
        " show4000_0: zero delay, hide after 4 seconds
        client->follow_up_action( val   = client->cs_event-control_global
                                  t_arg = VALUE #( ( `BUSY_INDICATOR` ) ( `show` ) ( `0` ) ) ).
        client->follow_up_action( val   = client->cs_event-start_timer
                                  t_arg = VALUE #( ( `HIDE_BUSY` ) ( `4000` ) ) ).

      WHEN `SHOW_1000_2000`.
        " show1000_2000: two seconds delay, hide after one second - the
        " indicator should never appear at all
        client->follow_up_action( val   = client->cs_event-control_global
                                  t_arg = VALUE #( ( `BUSY_INDICATOR` ) ( `show` ) ( `2000` ) ) ).
        client->follow_up_action( val   = client->cs_event-start_timer
                                  t_arg = VALUE #( ( `HIDE_BUSY` ) ( `1000` ) ) ).

      WHEN `HIDE_BUSY`.
        " the timer callback - hideBusyIndicator
        client->follow_up_action( val   = client->cs_event-control_global
                                  t_arg = VALUE #( ( `BUSY_INDICATOR` ) ( `hide` ) ) ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
