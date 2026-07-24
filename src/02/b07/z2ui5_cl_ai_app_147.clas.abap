CLASS z2ui5_cl_ai_app_147 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_147 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " the four button presses trigger the global BusyIndicator with varying
    " duration/delay in the original; here each opens a client MessageToast
    " (the global BusyIndicator show/hide + setTimeout are not reproduced).
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
                            )->a( n = `press` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `BusyIndicator (default delay) for 4s` ) ) )

                    )->shut(
                )->shut(

                )->open( `Panel`
                    )->a( n = `headerText` v = `Open BusyIndicator for four seconds (zero delay)`
                    )->open( `content`
                        )->leaf( `Button`
                            )->a( n = `text`  v = `Show BusyIndicator`
                            )->a( n = `press` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `BusyIndicator (zero delay) for 4s` ) ) )

                    )->shut(
                )->shut(

                )->open( `Panel`
                    )->a( n = `headerText` v = `Open BusyIndicator for one second (two seconds delay, so it should never appear at all)`
                    )->open( `content`
                        )->leaf( `Button`
                            )->a( n = `text`  v = `Show BusyIndicator`
                            )->a( n = `press` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `BusyIndicator (2s delay, 1s duration)` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
