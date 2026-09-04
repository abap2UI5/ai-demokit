" @keywords busyindicator busy indicator sap.ui.core global panel text button
" @summary A busy indicator can be used to block the entire screen until an operation has finished.
CLASS z2ui5_cl_smpc_app_147 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_147 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`

        )->ele( `Page`
            )->a( n = `class`      v = `sapUiFioriObjectPage`
            )->a( n = `showHeader` v = `false`

            )->ele( `content`
                )->ele( `Panel`
                    )->tag( `Text`
                        )->a( n = `text` v = `Press a button to show the global BusyIndicator`

                )->end(

                )->ele( `Panel`
                    )->a( n = `headerText` v = `Open BusyIndicator for four seconds (default delay, which is 1 second)`
                    )->ele( `content`
                        )->tag( `Button`
                            )->a( n = `text`  v = `Show BusyIndicator`
                            )->a( n = `press` v = client->_event( `SHOW_4000` )

                    )->end(
                )->end(

                )->ele( `Panel`
                    )->a( n = `headerText` v = `Open BusyIndicator for four seconds (zero delay)`
                    )->ele( `content`
                        )->tag( `Button`
                            )->a( n = `text`  v = `Show BusyIndicator`
                            )->a( n = `press` v = client->_event( `SHOW_4000_0` )

                    )->end(
                )->end(

                )->ele( `Panel`
                    )->a( n = `headerText` v = `Open BusyIndicator for one second (two seconds delay, so it should never appear at all)`
                    )->ele( `content`
                        )->tag( `Button`
                            )->a( n = `text`  v = `Show BusyIndicator`
                            )->a( n = `press` v = client->_event( `SHOW_1000_2000` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA temp1 TYPE string_table.
        DATA temp3 TYPE string_table.
        DATA temp5 TYPE string_table.
        DATA temp7 TYPE string_table.
        DATA temp9 TYPE string_table.
        DATA temp11 TYPE string_table.
        DATA temp13 TYPE string_table.

    " original showBusyIndicator(iDuration, iDelay): BusyIndicator.show(iDelay)
    " plus a setTimeout that hides it after iDuration - reproduced with the
    " BUSY_INDICATOR global target and START_TIMER (a new timer replaces the
    " previous one, matching the original's clearTimeout of _sTimeoutId)
    CASE client->get_event( ).

      WHEN `SHOW_4000`.
        " show4000: default delay (1 second), hide after 4 seconds
        
        CLEAR temp1.
        INSERT `BUSY_INDICATOR` INTO TABLE temp1.
        INSERT `show` INTO TABLE temp1.
        client->follow_up_action( val   = client->cs_event-control_global
                                  t_arg = temp1 ).
        
        CLEAR temp3.
        INSERT `HIDE_BUSY` INTO TABLE temp3.
        INSERT `4000` INTO TABLE temp3.
        client->follow_up_action( val   = client->cs_event-start_timer
                                  t_arg = temp3 ).

      WHEN `SHOW_4000_0`.
        " show4000_0: zero delay, hide after 4 seconds
        
        CLEAR temp5.
        INSERT `BUSY_INDICATOR` INTO TABLE temp5.
        INSERT `show` INTO TABLE temp5.
        INSERT `0` INTO TABLE temp5.
        client->follow_up_action( val   = client->cs_event-control_global
                                  t_arg = temp5 ).
        
        CLEAR temp7.
        INSERT `HIDE_BUSY` INTO TABLE temp7.
        INSERT `4000` INTO TABLE temp7.
        client->follow_up_action( val   = client->cs_event-start_timer
                                  t_arg = temp7 ).

      WHEN `SHOW_1000_2000`.
        " show1000_2000: two seconds delay, hide after one second - the
        " indicator should never appear at all
        
        CLEAR temp9.
        INSERT `BUSY_INDICATOR` INTO TABLE temp9.
        INSERT `show` INTO TABLE temp9.
        INSERT `2000` INTO TABLE temp9.
        client->follow_up_action( val   = client->cs_event-control_global
                                  t_arg = temp9 ).
        
        CLEAR temp11.
        INSERT `HIDE_BUSY` INTO TABLE temp11.
        INSERT `1000` INTO TABLE temp11.
        client->follow_up_action( val   = client->cs_event-start_timer
                                  t_arg = temp11 ).

      WHEN `HIDE_BUSY`.
        " the timer callback - hideBusyIndicator
        
        CLEAR temp13.
        INSERT `BUSY_INDICATOR` INTO TABLE temp13.
        INSERT `hide` INTO TABLE temp13.
        client->follow_up_action( val   = client->cs_event-control_global
                                  t_arg = temp13 ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
