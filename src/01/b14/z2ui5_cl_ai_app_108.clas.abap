CLASS z2ui5_cl_ai_app_108 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_appointment,
             start_at  TYPE string,
             end_at    TYPE string,
             title     TYPE string,
             info      TYPE string,
             type      TYPE string,
             pic       TYPE string,
             tentative TYPE abap_bool,
             aria      TYPE string,
           END OF ty_s_appointment.
    TYPES ty_t_appointment TYPE STANDARD TABLE OF ty_s_appointment WITH EMPTY KEY.
    TYPES: BEGIN OF ty_s_header,
             start_at TYPE string,
             end_at   TYPE string,
             title    TYPE string,
             type     TYPE string,
           END OF ty_s_header.
    TYPES ty_t_header TYPE STANDARD TABLE OF ty_s_header WITH EMPTY KEY.
    TYPES: BEGIN OF ty_s_person,
             t_appointments TYPE ty_t_appointment,
             t_headers      TYPE ty_t_header,
           END OF ty_s_person.
    DATA t_people TYPE STANDARD TABLE OF ty_s_person WITH EMPTY KEY.
    DATA start_date TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_108 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " calendar date properties (startDate/endDate) are typed "object" and demand a
    " real JS Date; the model keeps ISO strings and Formatter.DateCreateObject from
    " the curated module converts them at the point of use (needs UI5 >= 1.74)
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc`     v = `sap.ui.core.mvc`
        )->a( n = `xmlns:unified` v = `sap.ui.unified`
        )->a( n = `xmlns:core`    v = `sap.ui.core`
        )->a( n = `xmlns`         v = `sap.m`
        )->a( n = `core:require`  v = `{Formatter: 'z2ui5/model/formatter'}`

        )->open( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->open( `PlanningCalendar`
                )->a( n = `id`                        v = `PC1`
                )->a( n = `showRowHeaders`            v = `false`
                )->a( n = `startDate`                 v = |\{ path: '{ client->_bind( val = start_date path = abap_true ) }', formatter: 'Formatter.DateCreateObject' \}|
                )->a( n = `viewKey`                   v = `Day`
                )->a( n = `rows`                      v = client->_bind( t_people )
                )->a( n = `appointmentsVisualization` v = `Filled`
                )->a( n = `appointmentSelect`         v = client->_event( `APPT_SELECT` )
                )->a( n = `intervalSelect`            v = client->_event( `INTERVAL_SELECT` )
                )->a( n = `showEmptyIntervalHeaders`  v = `false`

                )->open( `toolbarContent`
                    )->leaf( `Title`
                        )->a( n = `text`       v = `Title`
                        )->a( n = `titleStyle` v = `H4`
                    )->leaf( `ToggleButton`
                        )->a( n = `icon`    v = `sap-icon://decrease-line-height`
                        )->a( n = `tooltip` v = `Toggle Day Names Line`
                        )->a( n = `press`   v = client->_event( `TOGGLE` )

                )->shut(
                )->open( `rows`
                    )->open( `PlanningCalendarRow`
                        )->a( n = `appointments`    v = `{path: 'T_APPOINTMENTS', templateShareable: false}`
                        )->a( n = `intervalHeaders` v = `{path: 'T_HEADERS', templateShareable: false}`

                        )->open( `appointments`
                            )->leaf( n = `CalendarAppointment` ns = `unified`
                                )->a( n = `startDate`    v = `{ path: 'START_AT', formatter: 'Formatter.DateCreateObject' }`
                                )->a( n = `endDate`      v = `{ path: 'END_AT', formatter: 'Formatter.DateCreateObject' }`
                                )->a( n = `icon`         v = `{PIC}`
                                )->a( n = `title`        v = `{TITLE}`
                                )->a( n = `text`         v = `{INFO}`
                                )->a( n = `type`         v = `{TYPE}`
                                )->a( n = `tentative`    v = `{TENTATIVE}`
                                )->a( n = `ariaHasPopup` v = `{ARIA}`

                        )->shut(
                        )->open( `intervalHeaders`
                            )->leaf( n = `CalendarAppointment` ns = `unified`
                                )->a( n = `startDate` v = `{ path: 'START_AT', formatter: 'Formatter.DateCreateObject' }`
                                )->a( n = `endDate`   v = `{ path: 'END_AT', formatter: 'Formatter.DateCreateObject' }`
                                )->a( n = `icon`      v = `{PIC}`
                                )->a( n = `title`     v = `{TITLE}`
                                )->a( n = `type`      v = `{TYPE}`

                        )->shut(
                    )->shut(
                )->shut(
            )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `APPT_SELECT`.
        client->message_toast_display( `Appointment selected` ).

      WHEN `INTERVAL_SELECT`.
        client->message_toast_display( `Interval selected` ).

      WHEN `TOGGLE`.
        client->message_toast_display( `Day names line toggled` ).

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    start_date = `2017-01-08T08:00:00`.
    t_people = VALUE #(
      ( t_appointments = VALUE #(
          ( start_at = `2016-11-15T10:00:00` end_at = `2016-12-25T12:00:00` title = `Team collaboration` info = `room 1` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2016-10-13T09:00:00` end_at = `2016-02-09T10:00:00` title = `Reminder` info = `` type = `Type06` pic = `` tentative = abap_false aria = `None` )
          ( start_at = `2016-08-10T00:00:00` end_at = `2016-10-16T23:59:00` title = `Vacation` info = `out of office` type = `Type04` pic = `` tentative = abap_false aria = `Dialog` )
          ( start_at = `2016-08-01T00:00:00` end_at = `2016-10-31T23:59:00` title = `New quarter` info = `` type = `Type10` pic = `` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-03T00:01:00` end_at = `2017-01-04T23:59:00` title = `Workshop` info = `regular` type = `Type07` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-05T08:30:00` end_at = `2017-01-05T09:30:00` title = `Meet Donna Moore` info = `` type = `Type02` pic = `` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-08T10:00:00` end_at = `2017-01-08T12:00:00` title = `Team meeting` info = `room 1` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-09T00:00:00` end_at = `2017-01-09T23:59:00` title = `Vacation` info = `out of office` type = `Type02` pic = `` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-11T00:00:00` end_at = `2017-01-12T23:59:00` title = `Education` info = `` type = `Type03` pic = `` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-16T00:30:00` end_at = `2017-01-16T23:30:00` title = `New Product` info = `room 105` type = `Type04` pic = `` tentative = abap_true aria = `Dialog` )
          ( start_at = `2017-01-18T11:30:00` end_at = `2017-01-18T13:30:00` title = `Lunch` info = `canteen` type = `Type03` pic = `` tentative = abap_true aria = `Dialog` )
          ( start_at = `2017-01-20T11:30:00` end_at = `2017-01-20T13:30:00` title = `Lunch` info = `canteen` type = `Type03` pic = `` tentative = abap_true aria = `Dialog` )
          ( start_at = `2017-01-18T00:01:00` end_at = `2017-01-19T23:59:00` title = `Working out of the building` info = `` type = `Type07` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-23T08:00:00` end_at = `2017-01-24T18:30:00` title = `Discussion of the plan` info = `Online meeting` type = `Type04` pic = `` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-25T00:01:00` end_at = `2017-01-26T23:59:00` title = `Workshop` info = `regular` type = `Type07` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-03-30T10:00:00` end_at = `2017-06-02T12:00:00` title = `Working out of the building` info = `` type = `Type07` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-09-01T00:30:00` end_at = `2017-11-15T23:30:00` title = `Development of a new Product` info = `room 207` type = `Type03` pic = `` tentative = abap_true aria = `Dialog` )
          ( start_at = `2017-02-15T10:00:00` end_at = `2017-03-25T12:00:00` title = `Team collaboration` info = `room 1` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-03-13T09:00:00` end_at = `2017-04-09T10:00:00` title = `Reminder` info = `` type = `Type06` pic = `` tentative = abap_false aria = `None` )
          ( start_at = `2017-04-10T00:00:00` end_at = `2017-06-16T23:59:00` title = `Vacation` info = `out of office` type = `Type04` pic = `` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-08-01T00:00:00` end_at = `2017-10-31T23:59:00` title = `New quarter` info = `` type = `Type10` pic = `` tentative = abap_false aria = `Dialog` ) )
        t_headers = VALUE #(
          ( start_at = `2017-01-08T00:00:00` end_at = `2017-01-08T23:59:00` title = `National holiday` type = `Type04` )
          ( start_at = `2017-01-10T00:00:00` end_at = `2017-01-10T23:59:00` title = `Birthday` type = `Type06` )
          ( start_at = `2017-01-17T00:00:00` end_at = `2017-01-17T23:59:00` title = `Reminder` type = `Type06` ) ) ) ).

  ENDMETHOD.

ENDCLASS.
