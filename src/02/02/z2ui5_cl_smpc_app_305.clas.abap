CLASS z2ui5_cl_smpc_app_305 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA selected_date TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    " the last picked day (yyyy-MM-dd) - handleCalendarSelect compares against it
    " to recognise the second click on the same day. Not bound, so it stays out
    " of the round-trip model scan
    DATA last_selected TYPE string.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_305 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      selected_date = `No Date Selected`.
      view_display( ).
    ELSEIF client->check_on_navigated( ).
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
                )->a( n = `id`                    v = `calendar`
                " showCurrentDateButton is @since 1.95 - kept 1:1 (POST_171)
                )->a( n = `showCurrentDateButton` v = `true`
                " the picked day is read out of the event as a UI5 EXPRESSION - indexed
                " access and chained calls resolve there (app 139 idiom). The LOCAL date
                " parts travel, not toISOString( ), which would shift the day east of
                " Greenwich
                )->a( n = `select`                v = client->_event( val   = `CAL_SELECT`
                                                                      t_arg = VALUE #(
                                                                        ( `$event.oSource.getSelectedDates().length > 0 ? $event.oSource.getSelectedDates()[0].getStartDate().getFullYear() : 0` )
                                                                        ( `$event.oSource.getSelectedDates().length > 0 ? $event.oSource.getSelectedDates()[0].getStartDate().getMonth() + 1 : 0` )
                                                                        ( `$event.oSource.getSelectedDates().length > 0 ? $event.oSource.getSelectedDates()[0].getStartDate().getDate() : 0` ) ) )

            )->ele( n = `HorizontalLayout` ns = `l`
                )->tag( `Label`
                    )->a( n = `text`  v = `Selected Date (yyyy-mm-dd):`
                    )->a( n = `class` v = `labelMarginLeft`
                )->tag( `Text`
                    )->a( n = `id`    v = `selectedDate`
                    )->a( n = `text`  v = client->_bind( selected_date )
                    )->a( n = `class` v = `labelMarginLeft` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `CAL_SELECT`.
      " handleCalendarSelect: a second click on the SAME day clears the
      " selection (removeSelectedDate), any other day becomes the new one;
      " _updateText then formats it yyyy-MM-dd
      DATA(year) = client->get_event_arg( ).
      IF year IS INITIAL OR year = `0`.
        selected_date = `No Date Selected`.
        CLEAR last_selected.
      ELSE.
        DATA(picked) = |{ year }-{ CONV i( client->get_event_arg( 2 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }| &&
                       |-{ CONV i( client->get_event_arg( 3 ) ) WIDTH = 2 ALIGN = RIGHT PAD = '0' }|.
        IF picked = last_selected.
          selected_date = `No Date Selected`.
          CLEAR last_selected.
        ELSE.
          selected_date = picked.
          last_selected = picked.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
