CLASS z2ui5_cl_smpc_app_543 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_appointment,
             start_at    TYPE string,
             end_at      TYPE string,
             title       TYPE string,
             info        TYPE string,
             description TYPE string,
             type        TYPE string,
             pic         TYPE string,
             tentative   TYPE abap_bool,
           END OF ty_s_appointment.
    TYPES ty_t_appointment TYPE STANDARD TABLE OF ty_s_appointment WITH EMPTY KEY.
    TYPES: BEGIN OF ty_s_header,
             start_at    TYPE string,
             end_at      TYPE string,
             title       TYPE string,
             text        TYPE string,
             description TYPE string,
             type        TYPE string,
             pic         TYPE string,
           END OF ty_s_header.
    TYPES ty_t_header TYPE STANDARD TABLE OF ty_s_header WITH EMPTY KEY.
    TYPES: BEGIN OF ty_s_person,
             pic            TYPE string,
             name           TYPE string,
             role           TYPE string,
             t_appointments TYPE ty_t_appointment,
             t_headers      TYPE ty_t_header,
           END OF ty_s_person.
    DATA t_people TYPE STANDARD TABLE OF ty_s_person WITH EMPTY KEY.

    DATA start_date         TYPE string.
    DATA appointment_height TYPE string.
    DATA round_width        TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_543 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " the calendar date properties are typed "object" and demand a real JS Date;
    " the model keeps ISO strings and Formatter.DateCreateObject converts them
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:core`    v = `sap.ui.core`
        )->a( n = `xmlns:mvc`     v = `sap.ui.core.mvc`
        )->a( n = `xmlns:unified` v = `sap.ui.unified`
        )->a( n = `xmlns`         v = `sap.m`
        )->a( n = `core:require`  v = `{Formatter: 'z2ui5/model/formatter'}`

        )->ele( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->ele( `HBox`

                )->ele( `VBox`
                    )->a( n = `class` v = `sapUiSmallMarginEnd`

                    )->tag( `Label`
                        )->a( n = `text` v = `Appointment Size:`
                    " handleAppointmentHeightChange calls setAppointmentHeight; the
                    " property is bindable, so the Select shares its key with the
                    " calendar and the change handler is dropped
                    )->ele( `Select`
                        )->a( n = `selectedKey` v = client->_bind( appointment_height )
                        )->a( n = `width`       v = `230px`

                        )->ele( `items`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `Regular`
                                )->a( n = `text` v = `Regular`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `HalfSize`
                                )->a( n = `text` v = `Half-Size`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `Large`
                                )->a( n = `text` v = `Large`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `Automatic`
                                )->a( n = `text` v = `Automatic`

                        )->end(
                    )->end(
                )->end(

                )->ele( `VBox`
                    )->a( n = `class` v = `sapUiSmallMarginEnd`

                    )->tag( `Label`
                        )->a( n = `text` v = `Appointment Sort:`
                    )->ele( `Select`
                        )->a( n = `change` v = client->_event(
                                  val   = `SORT_CHANGE`
                                  t_arg = VALUE #( ( `${$parameters>/selectedItem}.getKey()` ) ) )
                        )->a( n = `width`  v = `230px`

                        )->ele( `items`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `default`
                                )->a( n = `text` v = `Default Appointments Sort`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `custom`
                                )->a( n = `text` v = `Alphabetical Appointments Sort`

                        )->end(
                    )->end(
                )->end(

                )->ele( `VBox`
                    )->a( n = `class` v = `sapUiSmallMarginEnd`

                    )->tag( `Label`
                        )->a( n = `text` v = `Appointment Row Rounding:`
                    " handleAppointmentRoundingChange calls setAppointmentRoundWidth;
                    " the property is bindable, so the Select shares its key too
                    )->ele( `Select`
                        )->a( n = `selectedKey` v = client->_bind( round_width )
                        )->a( n = `width`       v = `230px`

                        )->ele( `items`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `None`
                                )->a( n = `text` v = `None`
                            )->tag( n = `Item` ns = `core`
                                )->a( n = `key`  v = `HalfColumn`
                                )->a( n = `text` v = `Half Column`

                        )->end(
                    )->end(
                )->end(
            )->end(

            )->ele( `PlanningCalendar`
                )->a( n = `id`                        v = `PC1`
                )->a( n = `showIntervalHeaders`       v = `false`
                )->a( n = `startDate`                 v = |\{ path: '{ client->_bind( val = start_date path = abap_true ) }', formatter: 'Formatter.DateCreateObject' \}|
                )->a( n = `rows`                      v = client->_bind( t_people )
                )->a( n = `appointmentsVisualization` v = `Filled`
                )->a( n = `appointmentHeight`         v = client->_bind( appointment_height )
                )->a( n = `appointmentRoundWidth`     v = client->_bind( round_width )

                )->ele( `rows`
                    )->ele( `PlanningCalendarRow`
                        )->a( n = `icon`            v = `{PIC}`
                        )->a( n = `title`           v = `{NAME}`
                        )->a( n = `text`            v = `{ROLE}`
                        )->a( n = `appointments`    v = `{path: 'T_APPOINTMENTS', templateShareable: false}`
                        )->a( n = `intervalHeaders` v = `{path: 'T_HEADERS', templateShareable: false}`

                        )->ele( `appointments`
                            )->tag( n = `CalendarAppointment` ns = `unified`
                                )->a( n = `startDate`   v = `{ path: 'START_AT', formatter: 'Formatter.DateCreateObject' }`
                                )->a( n = `endDate`     v = `{ path: 'END_AT', formatter: 'Formatter.DateCreateObject' }`
                                )->a( n = `icon`        v = `{PIC}`
                                )->a( n = `title`       v = `{TITLE}`
                                )->a( n = `text`        v = `{INFO}`
                                )->a( n = `description` v = `{DESCRIPTION}`
                                )->a( n = `type`        v = `{TYPE}`
                                )->a( n = `tentative`   v = `{TENTATIVE}`

                        )->end(
                        )->ele( `intervalHeaders`
                            )->tag( n = `CalendarAppointment` ns = `unified`
                                )->a( n = `startDate`   v = `{ path: 'START_AT', formatter: 'Formatter.DateCreateObject' }`
                                )->a( n = `endDate`     v = `{ path: 'END_AT', formatter: 'Formatter.DateCreateObject' }`
                                )->a( n = `icon`        v = `{PIC}`
                                )->a( n = `title`       v = `{TITLE}`
                                )->a( n = `text`        v = `{TEXT}`
                                )->a( n = `description` v = `{DESCRIPTION}`
                                )->a( n = `type`        v = `{TYPE}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `SORT_CHANGE`.
      " handleSortChange hands the calendar a JS comparator; ABAP sorts the
      " rows themselves instead (see sidecar)
      IF client->get_event_arg( ) = `custom`.
        LOOP AT t_people ASSIGNING FIELD-SYMBOL(<row>).
          SORT <row>-t_appointments BY title AS TEXT.
        ENDLOOP.
      ELSE.
        model_init( ).
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    start_date         = `2017-03-08T08:00:00`.
    appointment_height = `Regular`.
    round_width        = `None`.

    t_people = VALUE #(
      ( pic = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/John_Miller.png` name = `John Miller` role = `team member`
        t_appointments = VALUE #(
          ( start_at = `2017-03-07T18:00:00` end_at = `2017-03-07T19:10:00` title = `Discussion of the plan` info = `Online meeting` type = `Type04` tentative = abap_false )
          ( start_at = `2017-03-07T14:00:00` end_at = `2017-03-07T15:15:00` title = `Department meeting` type = `Type04` tentative = abap_false )
          ( start_at = `2017-03-03T10:00:00` end_at = `2017-03-07T12:00:00` title = `Workshop out of the country` type = `Type07` pic = `sap-icon://sap-ui5` tentative = abap_false )
          ( start_at = `2017-03-08T09:00:00` end_at = `2017-03-08T11:00:00` title = `Team meeting` info = `room 105` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false )
          ( start_at = `2017-03-08T09:30:00` end_at = `2017-03-08T11:30:00` title = `Meeting with Max` type = `Type02` pic = `sap-icon://sap-ui5` tentative = abap_false )
          ( start_at = `2017-03-08T11:00:00` end_at = `2017-03-08T13:00:00` title = `Lunch` info = `info` description = `description` type = `Type03` tentative = abap_true )
          ( start_at = `2017-03-08T11:00:00` end_at = `2017-03-08T13:00:00` title = `Meeting with the crew` type = `Type04` tentative = abap_false )
          ( start_at = `2017-03-09T09:00:00` end_at = `2017-03-09T16:00:00` title = `Busy` type = `Type08` tentative = abap_false )
          ( start_at = `2017-03-10T09:00:00` end_at = `2017-03-10T11:00:00` title = `Team meeting` info = `room 105` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false )
          ( start_at = `2017-03-10T09:30:00` end_at = `2017-03-10T16:30:00` title = `Meeting with Max` type = `Type02` tentative = abap_false )
          ( start_at = `2017-03-11T00:00:00` end_at = `2017-03-13T23:59:00` title = `Vacation` info = `out of office` type = `Type04` tentative = abap_false )
          ( start_at = `2017-03-16T00:30:00` end_at = `2017-03-16T23:30:00` title = `New Colleague` info = `room 115` type = `Type10` tentative = abap_true )
          ( start_at = `2017-10-11T00:00:00` end_at = `2017-11-13T23:59:00` title = `Vacation` info = `out of office` type = `Type04` tentative = abap_false )
          ( start_at = `2017-03-08T14:00:00` end_at = `2017-03-08T15:00:00` title = `Reminder` type = `Type06` )
        )
        t_headers = VALUE #(
        )  )
      ( pic = `sap-icon://employee` name = `Max Mustermann` role = `team member`
        t_appointments = VALUE #(
          ( start_at = `2016-12-01T00:30:00` end_at = `2017-01-31T23:30:00` title = `New product release` info = `room 105` type = `Type03` tentative = abap_true )
          ( start_at = `2017-03-02T08:00:00` end_at = `2017-03-02T17:00:00` title = `Education` type = `Type05` tentative = abap_false )
          ( start_at = `2017-03-03T09:00:00` end_at = `2017-03-03T10:00:00` title = `New Product` info = `room 105` type = `Type03` tentative = abap_true )
          ( start_at = `2017-03-08T08:00:00` end_at = `2017-03-08T13:00:00` title = `Meet Donna` type = `Type06` tentative = abap_false )
          ( start_at = `2017-03-08T13:00:00` end_at = `2017-03-09T11:00:00` title = `Team meeting` info = `room 1` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false )
          ( start_at = `2017-03-08T13:00:00` end_at = `2017-03-08T14:59:00` title = `Team meeting2` info = `room 2` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false )
          ( start_at = `2017-03-09T00:00:00` end_at = `2017-03-09T23:59:00` title = `Department meeting` type = `Type04` tentative = abap_false )
          ( start_at = `2017-03-12T00:00:00` end_at = `2017-03-12T12:00:00` title = `Meeting with John` type = `Type02` tentative = abap_false )
          ( start_at = `2017-03-12T12:00:00` end_at = `2017-03-12T23:59:00` title = `Team Building` info = `out of office` type = `Type10` pic = `sap-icon://sap-ui5` tentative = abap_false )
          ( start_at = `2017-03-13T00:00:00` end_at = `2017-03-13T12:00:00` title = `New Product` info = `room 325` type = `Type07` tentative = abap_true )
          ( start_at = `2017-03-13T12:00:00` end_at = `2017-03-13T23:30:00` title = `New Product` info = `room 105` type = `Type03` tentative = abap_true )
          ( start_at = `2017-03-14T00:00:00` end_at = `2017-03-14T12:00:00` title = `Vacation` info = `out of office` type = `Type04` tentative = abap_false )
          ( start_at = `2017-03-14T12:00:00` end_at = `2017-03-14T23:30:00` title = `New product release` info = `room 105` type = `Type03` tentative = abap_true )
        )
        t_headers = VALUE #(
          ( start_at = `2017-03-08T08:00:00` end_at = `2017-03-08T10:00:00` title = `Development of UI5` type = `Type07` pic = `sap-icon://sap-ui5` )
          ( start_at = `2017-05-01T00:00:00` end_at = `2017-08-30T23:59:00` title = `New quarter` type = `Type10` )
        )  ) ).

  ENDMETHOD.

ENDCLASS.
