CLASS z2ui5_cl_smpc_app_306 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA selected_from TYPE string.
    DATA selected_to   TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_306 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      selected_from = `No Date Selected`.
      selected_to   = `No Date Selected`.
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:u`   v = `sap.ui.unified`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `class`     v = `viewPadding`

        )->ele( n = `VerticalLayout` ns = `l`

            )->tag( n = `Calendar` ns = `u`
                )->a( n = `id`                v = `calendar`
                " both ends of the picked interval are read out of the event as UI5
                " EXPRESSIONS - indexed access and chained calls resolve there (app 139
                " idiom). The LOCAL date parts travel, not toISOString( ), which would
                " shift the day east of Greenwich
                )->a( n = `select`            v = client->_event( val   = `CAL_SELECT`
                                                                  t_arg = VALUE #(
                                                                    ( `$event.oSource.getSelectedDates().length > 0 && $event.oSource.getSelectedDates()[0].getStartDate() ? $event.oSource.getSelectedDates()[0].getStartDate().getFullYear() : 0` )
                                                                    ( `$event.oSource.getSelectedDates().length > 0 && $event.oSource.getSelectedDates()[0].getStartDate() ? $event.oSource.getSelectedDates()[0].getStartDate().getMonth() + 1 : 0` )
                                                                    ( `$event.oSource.getSelectedDates().length > 0 && $event.oSource.getSelectedDates()[0].getStartDate() ? $event.oSource.getSelectedDates()[0].getStartDate().getDate() : 0` )
                                                                    ( `$event.oSource.getSelectedDates().length > 0 && $event.oSource.getSelectedDates()[0].getEndDate() ? $event.oSource.getSelectedDates()[0].getEndDate().getFullYear() : 0` )
                                                                    ( `$event.oSource.getSelectedDates().length > 0 && $event.oSource.getSelectedDates()[0].getEndDate() ? $event.oSource.getSelectedDates()[0].getEndDate().getMonth() + 1 : 0` )
                                                                    ( `$event.oSource.getSelectedDates().length > 0 && $event.oSource.getSelectedDates()[0].getEndDate() ? $event.oSource.getSelectedDates()[0].getEndDate().getDate() : 0` ) ) )
                )->a( n = `intervalSelection` v = `true`
                " weekNumberSelect is @since 1.60 - the weekDays DateRange and the
                " week number travel as expression args
                )->a( n = `weekNumberSelect`  v = client->_event( val   = `WEEK_SELECT`
                                                                  t_arg = VALUE #(
                                                                    ( `${$parameters>/weekNumber}` )
                                                                    ( `${$parameters>/weekDays}.getStartDate() ? ${$parameters>/weekDays}.getStartDate().getFullYear() : 0` )
                                                                    ( `${$parameters>/weekDays}.getStartDate() ? ${$parameters>/weekDays}.getStartDate().getMonth() + 1 : 0` )
                                                                    ( `${$parameters>/weekDays}.getStartDate() ? ${$parameters>/weekDays}.getStartDate().getDate() : 0` )
                                                                    ( `${$parameters>/weekDays}.getEndDate() ? ${$parameters>/weekDays}.getEndDate().getFullYear() : 0` )
                                                                    ( `${$parameters>/weekDays}.getEndDate() ? ${$parameters>/weekDays}.getEndDate().getMonth() + 1 : 0` )
                                                                    ( `${$parameters>/weekDays}.getEndDate() ? ${$parameters>/weekDays}.getEndDate().getDate() : 0` ) ) )

            )->ele( n = `HorizontalLayout` ns = `l`
                )->tag( `Label`
                    )->a( n = `text`  v = `Selected From (yyyy-mm-dd):`
                    )->a( n = `class` v = `labelMarginLeft`
                )->tag( `Text`
                    )->a( n = `id`    v = `selectedDateFrom`
                    )->a( n = `text`  v = client->_bind( selected_from )
                    )->a( n = `class` v = `labelMarginLeft`

            )->end(
            )->ele( n = `HorizontalLayout` ns = `l`
                )->tag( `Label`
                    )->a( n = `text`  v = `Selected To (yyyy-mm-dd):`
                    )->a( n = `class` v = `labelMarginLeft`
                )->tag( `Text`
                    )->a( n = `id`    v = `selectedDateTo`
                    )->a( n = `text`  v = client->_bind( selected_to )
                    )->a( n = `class` v = `labelMarginLeft` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `CAL_SELECT`.
        " _updateText: the interval's start and end formatted yyyy-MM-dd, or
        " 'No Date Selected' where the DateRange has no such end
        selected_from = COND #( WHEN client->get_event_arg( ) = `0` OR client->get_event_arg( ) IS INITIAL
                                THEN `No Date Selected`
                                ELSE |{ client->get_event_arg( ) }-{ CONV i( client->get_event_arg( 2 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
                                     |-{ CONV i( client->get_event_arg( 3 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }| ).
        selected_to   = COND #( WHEN client->get_event_arg( 4 ) = `0` OR client->get_event_arg( 4 ) IS INITIAL
                                THEN `No Date Selected`
                                ELSE |{ client->get_event_arg( 4 ) }-{ CONV i( client->get_event_arg( 5 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
                                     |-{ CONV i( client->get_event_arg( 6 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }| ).

      WHEN `WEEK_SELECT`.
        " handleWeekNumberSelect: every fifth calendar week is refused with a
        " toast, any other week fills the two labels from its weekDays DateRange
        DATA(week) = CONV i( client->get_event_arg( ) ).
        IF week MOD 5 = 0.
          client->message_toast_display( `You are not allowed to select this calendar week!` ).
        ELSE.
          selected_from = COND #( WHEN client->get_event_arg( 2 ) = `0` OR client->get_event_arg( 2 ) IS INITIAL
                                  THEN `No Date Selected`
                                  ELSE |{ client->get_event_arg( 2 ) }-{ CONV i( client->get_event_arg( 3 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
                                       |-{ CONV i( client->get_event_arg( 4 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }| ).
          selected_to   = COND #( WHEN client->get_event_arg( 5 ) = `0` OR client->get_event_arg( 5 ) IS INITIAL
                                  THEN `No Date Selected`
                                  ELSE |{ client->get_event_arg( 5 ) }-{ CONV i( client->get_event_arg( 6 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
                                       |-{ CONV i( client->get_event_arg( 7 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }| ).
        ENDIF.

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
