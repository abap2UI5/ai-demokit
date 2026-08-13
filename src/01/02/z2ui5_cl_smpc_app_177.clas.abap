CLASS z2ui5_cl_smpc_app_177 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA selected_date TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_177 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      selected_date = `No Date Selected`.
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:u`   v = `sap.ui.unified`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `class`     v = `viewPadding`

        )->open( n = `VerticalLayout` ns = `l`
            )->leaf( n = `CalendarDateInterval` ns = `u`
                )->a( n = `id`     v = `calendar`
                )->a( n = `width`  v = `320px`
                " the picked day is read out of the event as a UI5 EXPRESSION - indexed
                " access and chained calls resolve there (measured with
                " scripts/probes/event-arg-expression-probe.mjs). The LOCAL date parts
                " travel, not toISOString( ), which would shift the day east of
                " Greenwich; the length guard reproduces the deselect case
                )->a( n = `select` v = client->_event( val   = `CAL_SELECT`
                                                       t_arg = VALUE #(
                                                         ( `$event.oSource.getSelectedDates().length > 0 ? $event.oSource.getSelectedDates()[0].getStartDate().getFullYear() : 0` )
                                                         ( `$event.oSource.getSelectedDates().length > 0 ? $event.oSource.getSelectedDates()[0].getStartDate().getMonth() + 1 : 0` )
                                                         ( `$event.oSource.getSelectedDates().length > 0 ? $event.oSource.getSelectedDates()[0].getStartDate().getDate() : 0` ) ) )

            )->open( n = `VerticalLayout` ns = `l`
                )->leaf( `Button`
                    )->a( n = `press` v = client->_event( `SELECT_TODAY` )
                    )->a( n = `text`  v = `Select Today`

                )->open( n = `HorizontalLayout` ns = `l`
                    )->leaf( `Label`
                        )->a( n = `text`     v = `Selected Date:`
                        )->a( n = `labelFor` v = `selectedDate`
                        )->a( n = `class`    v = `labelMarginLeft`
                    )->leaf( `Text`
                        )->a( n = `id`    v = `selectedDate`
                        )->a( n = `text`  v = client->_bind( selected_date )
                        )->a( n = `class` v = `labelMarginLeft` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `CAL_SELECT`.
        " handleCalendarSelect: format getSelectedDates()[0] as yyyy-MM-dd, and
        " show 'No Date Selected' when the re-click removed the day again - the
        " original's if/else over the selection length, reproduced 1:1 because
        " the length guard travels in the wire (year 0 = nothing selected)
        DATA(year) = client->get_event_arg( ).
        IF year IS INITIAL OR year = `0`.
          selected_date = `No Date Selected`.
        ELSE.
          selected_date = |{ year }-{ CONV i( client->get_event_arg( 2 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
                          |-{ CONV i( client->get_event_arg( 3 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }|.
        ENDIF.

      WHEN `SELECT_TODAY`.
        " handleSelectToday adds a DateRange(today) and reformats - the server
        " date IS today, so the text matches; only the calendar's own highlight
        " is not moved (addSelectedDate takes a DateRange CONTROL)
        selected_date = |{ sy-datum+0(4) }-{ sy-datum+4(2) }-{ sy-datum+6(2) }|.

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
