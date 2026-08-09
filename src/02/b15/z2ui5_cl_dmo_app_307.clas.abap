CLASS z2ui5_cl_dmo_app_307 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_date,
             date TYPE string,
           END OF ty_s_date.
    DATA selecteddates TYPE STANDARD TABLE OF ty_s_date WITH EMPTY KEY.

  PROTECTED SECTION.
    CONSTANTS c_max_dates TYPE i VALUE 31.

    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_dmo_app_307 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    " one expression arg per selectable slot: each one formats the day at that
    " index of the LIVE selectedDates aggregation as yyyy-MM-dd on the client
    " (local parts, not toISOString( ), which would shift the day east of
    " Greenwich) and yields an empty string once the index is past the end
    DATA(date_args) = VALUE string_table(
      FOR i = 0 UNTIL i >= c_max_dates
      ( |$event.oSource.getSelectedDates().length > { i } ? | &&
        |$event.oSource.getSelectedDates()[{ i }].getStartDate().getFullYear() + '-' + | &&
        |($event.oSource.getSelectedDates()[{ i }].getStartDate().getMonth() + 1 < 10 ? '0' : '') + | &&
        |($event.oSource.getSelectedDates()[{ i }].getStartDate().getMonth() + 1) + '-' + | &&
        |($event.oSource.getSelectedDates()[{ i }].getStartDate().getDate() < 10 ? '0' : '') + | &&
        |$event.oSource.getSelectedDates()[{ i }].getStartDate().getDate() : ''| ) ).

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:u`   v = `sap.ui.unified`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `class`     v = `viewPadding`

        )->open( n = `VerticalLayout` ns = `l`

            )->leaf( n = `Calendar` ns = `u`
                )->a( n = `id`                v = `calendar`
                )->a( n = `select`            v = client->_event( val   = `CAL_SELECT`
                                                                  t_arg = date_args )
                )->a( n = `intervalSelection` v = `false`
                )->a( n = `singleSelection`   v = `false`
            )->leaf( `Button`
                )->a( n = `press` v = client->_event( `REMOVE_SELECTION` )
                )->a( n = `text`  v = `Remove All Selected Dates`

            )->open( `List`
                )->a( n = `id`         v = `selectedDatesList`
                )->a( n = `class`      v = `labelMarginLeft`
                )->a( n = `noDataText` v = `No Dates Selected`
                )->a( n = `headerText` v = `Selected Dates (yyyy-mm-dd)`
                )->a( n = `items`      v = |\{path: '{ client->_bind( val = selecteddates path = abap_true ) }'\}|

                )->leaf( `StandardListItem`
                    )->a( n = `title` v = `{DATE}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `CAL_SELECT`.
        " handleCalendarSelect: rebuild the model from every selected date,
        " each formatted yyyy-MM-dd - here they arrive pre-formatted, one per arg
        CLEAR selecteddates.
        DO c_max_dates TIMES.
          DATA(day) = client->get_event_arg( sy-index ).
          IF day IS INITIAL.
            EXIT.
          ENDIF.
          INSERT VALUE #( date = day ) INTO TABLE selecteddates.
        ENDDO.
        client->view_model_update( ).

      WHEN `REMOVE_SELECTION`.
        " handleRemoveSelection: removeAllSelectedDates( ) + clear the model.
        " Only the model part is reproducible - see the declared deviation
        CLEAR selecteddates.
        client->view_model_update( ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
