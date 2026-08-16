CLASS z2ui5_cl_smpc_app_304 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA selected_date TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_304 IMPLEMENTATION.

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

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:u`   v = `sap.ui.unified`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `class`     v = `viewPadding`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`

            )->tag( n = `Calendar` ns = `u`
                )->a( n = `id`     v = `calendar`
                )->a( n = `months` v = `2`
                " the picked day is read out of the event as a UI5 EXPRESSION - indexed
                " access and chained calls resolve there (app 139 idiom). The LOCAL date
                " parts travel, not toISOString( ), which would shift the day east of
                " Greenwich
                )->a( n = `select` v = client->_event( val   = `CAL_SELECT`
                                                       t_arg = VALUE #(
                                                         ( `$event.oSource.getSelectedDates().length > 0 ? $event.oSource.getSelectedDates()[0].getStartDate().getFullYear() : 0` )
                                                         ( `$event.oSource.getSelectedDates().length > 0 ? $event.oSource.getSelectedDates()[0].getStartDate().getMonth() + 1 : 0` )
                                                         ( `$event.oSource.getSelectedDates().length > 0 ? $event.oSource.getSelectedDates()[0].getStartDate().getDate() : 0` ) ) )

            )->ele( n = `HorizontalLayout` ns = `l`
                )->a( n = `allowWrapping` v = `true`

                )->tag( `Button`
                    )->a( n = `press` v = client->_event( `SELECT_TODAY` )
                    )->a( n = `text`  v = `Select Today`
                    )->a( n = `class` v = `sapUiSmallMarginEnd`
                )->tag( `Label`
                    )->a( n = `text`  v = `Selected Date (yyyy-mm-dd):`
                    )->a( n = `class` v = `sapUiSmallMarginEnd`
                )->tag( `Text`
                    )->a( n = `id`   v = `selectedDate`
                    )->a( n = `text` v = client->_bind( selected_date ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `CAL_SELECT`.
        " _updateText: format getSelectedDates()[0] as yyyy-MM-dd. The day arrives
        " as its three LOCAL parts (see the wire in view_display)
        DATA(year) = client->get_event_arg( ).
        IF year IS INITIAL OR year = `0`.
          selected_date = `No Date Selected`.
        ELSE.
          selected_date = |{ year }-{ CONV i( client->get_event_arg( 2 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
                          |-{ CONV i( client->get_event_arg( 3 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }|.
        ENDIF.

      WHEN `SELECT_TODAY`.
        " handleSelectToday removes every selected date, adds a DateRange(today)
        " and reformats - the server date IS today, so the text is 1:1; only the
        " calendar's own highlight of that day is not moved (addSelectedDate takes
        " a DateRange CONTROL, which no wire can construct)
        selected_date = |{ sy-datum+0(4) }-{ sy-datum+4(2) }-{ sy-datum+6(2) }|.

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
