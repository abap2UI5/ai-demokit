" @keywords planningcalendar planning calendar sap.m planningcalendarrelativeviews vbox title planningcalendarview planningcalendarrow
" @summary PlanningCalendar with relative views. The relative periods are not directly related to dates, but periods with pre-defined duration.
CLASS z2ui5_cl_smpc_app_545 DEFINITION PUBLIC.

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
             pic      TYPE string,
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

    DATA start_date TYPE string.
    DATA min_date   TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_545 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
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

            )->ele( `PlanningCalendar`
                )->a( n = `id`                        v = `PC12`
                )->a( n = `startDate`                 v = |\{ path: '{ client->_bind( val = start_date path = abap_true ) }', formatter: 'Formatter.DateCreateObject' \}|
                )->a( n = `minDate`                   v = |\{ path: '{ client->_bind( val = min_date path = abap_true ) }', formatter: 'Formatter.DateCreateObject' \}|
                )->a( n = `rows`                      v = client->_bind( t_people )
                )->a( n = `appointmentsVisualization` v = `Filled`
                )->a( n = `builtInViews`              v = `Hour,Day`

                )->ele( `toolbarContent`
                    )->tag( `Title`
                        )->a( n = `text`       v = `RelativeViews`
                        )->a( n = `titleStyle` v = `H4`

                )->end(

                )->ele( `views`
                    )->tag( `PlanningCalendarView`
                        )->a( n = `key`          v = `A`
                        )->a( n = `intervalType` v = `Day`
                        )->a( n = `description`  v = `Weeks in Project`
                        )->a( n = `intervalsS`   v = `4`
                        )->a( n = `intervalsM`   v = `8`
                        )->a( n = `intervalsL`   v = `13`
                        )->a( n = `intervalSize` v = `7`
                        )->a( n = `relative`     v = `true`
                    )->tag( `PlanningCalendarView`
                        )->a( n = `key`          v = `D`
                        )->a( n = `intervalType` v = `Day`
                        )->a( n = `description`  v = `Shift`
                        )->a( n = `intervalsS`   v = `3`
                        )->a( n = `intervalsM`   v = `7`
                        )->a( n = `intervalsL`   v = `12`
                        )->a( n = `intervalSize` v = `2`
                        )->a( n = `relative`     v = `true`

                )->end(

                )->ele( `rows`
                    )->ele( `PlanningCalendarRow`
                        )->a( n = `icon`            v = `{PIC}`
                        )->a( n = `title`           v = `{NAME}`
                        )->a( n = `text`            v = `{ROLE}`
                        )->a( n = `appointments`    v = `{path: 'T_APPOINTMENTS', templateShareable: false}`
                        )->a( n = `intervalHeaders` v = `{path: 'T_HEADERS', templateShareable: false}`

                        )->ele( `customData`
                            )->tag( n = `CustomData` ns = `core`
                                )->a( n = `key`        v = `emp-name`
                                )->a( n = `value`      v = `{NAME}`
                                )->a( n = `writeToDom` v = `true`

                        )->end(
                        )->ele( `appointments`
                            )->tag( n = `CalendarAppointment` ns = `unified`
                                )->a( n = `startDate` v = `{ path: 'START_AT', formatter: 'Formatter.DateCreateObject' }`
                                )->a( n = `endDate`   v = `{ path: 'END_AT', formatter: 'Formatter.DateCreateObject' }`
                                )->a( n = `icon`      v = `{PIC}`
                                )->a( n = `title`     v = `{TITLE}`
                                )->a( n = `text`      v = `{INFO}`
                                )->a( n = `type`      v = `{TYPE}`
                                )->a( n = `tentative` v = `{TENTATIVE}`

                        )->end(
                        )->ele( `intervalHeaders`
                            )->tag( n = `CalendarAppointment` ns = `unified`
                                )->a( n = `startDate` v = `{ path: 'START_AT', formatter: 'Formatter.DateCreateObject' }`
                                )->a( n = `endDate`   v = `{ path: 'END_AT', formatter: 'Formatter.DateCreateObject' }`
                                )->a( n = `icon`      v = `{PIC}`
                                )->a( n = `title`     v = `{TITLE}`
                                )->a( n = `type`      v = `{TYPE}`

                        )->end(
                    )->end(
                )->end(
            )->end(
 ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    start_date = `2017-01-15T08:00:00`.
    min_date   = `2017-01-15T08:00:00`.

    t_people = VALUE #(
      ( pic = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/John_Miller.png` name = `John Miller` role = `team member`
        t_appointments = VALUE #(
          ( start_at = `2017-01-08T08:30:00` end_at = `2017-01-08T09:30:00` title = `Meet Max Mustermann` type = `Type02` tentative = abap_false )
          ( start_at = `2017-01-11T10:00:00` end_at = `2017-01-11T12:00:00` title = `Team meeting` info = `room 1` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false )
          ( start_at = `2017-01-12T11:30:00` end_at = `2017-01-12T13:30:00` title = `Lunch` info = `canteen` type = `Type03` tentative = abap_true )
          ( start_at = `2017-01-15T08:30:00` end_at = `2017-01-15T09:30:00` title = `Meet Max Mustermann` type = `Type02` tentative = abap_false )
          ( start_at = `2017-01-15T10:00:00` end_at = `2017-01-15T12:00:00` title = `Team meeting` info = `room 1` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false )
          ( start_at = `2017-01-15T11:30:00` end_at = `2017-01-15T13:30:00` title = `Lunch` info = `canteen` type = `Type03` tentative = abap_true )
          ( start_at = `2017-01-15T13:30:00` end_at = `2017-01-15T17:30:00` title = `Discussion with clients` info = `online meeting` type = `Type02` tentative = abap_false )
          ( start_at = `2017-01-16T04:00:00` end_at = `2017-01-16T22:30:00` title = `Discussion of the plan` info = `Online meeting` type = `Type04` tentative = abap_false )
          ( start_at = `2017-01-18T08:30:00` end_at = `2017-01-18T09:30:00` title = `Meeting with the manager` type = `Type02` tentative = abap_false )
          ( start_at = `2017-01-18T11:30:00` end_at = `2017-01-18T13:30:00` title = `Lunch` info = `canteen` type = `Type03` tentative = abap_true )
          ( start_at = `2017-01-18T01:00:00` end_at = `2017-01-18T22:00:00` title = `Team meeting` info = `regular` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false )
          ( start_at = `2017-01-21T00:30:00` end_at = `2017-01-21T23:30:00` title = `New Product` info = `room 105` type = `Type03` tentative = abap_true )
          ( start_at = `2017-01-25T11:30:00` end_at = `2017-01-25T13:30:00` title = `Lunch` type = `Type03` tentative = abap_true )
          ( start_at = `2017-01-29T10:00:00` end_at = `2017-01-29T12:00:00` title = `Team meeting` info = `room 1` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false )
          ( start_at = `2017-01-30T08:30:00` end_at = `2017-01-30T09:30:00` title = `Meet Max Mustermann` type = `Type02` tentative = abap_false )
          ( start_at = `2017-01-30T10:00:00` end_at = `2017-01-30T12:00:00` title = `Team meeting` info = `room 1` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false )
          ( start_at = `2017-01-30T11:30:00` end_at = `2017-01-30T13:30:00` title = `Lunch` type = `Type03` tentative = abap_true )
          ( start_at = `2017-01-30T13:30:00` end_at = `2017-01-30T17:30:00` title = `Discussion with clients` type = `Type02` tentative = abap_false )
          ( start_at = `2017-01-31T10:00:00` end_at = `2017-01-31T11:30:00` title = `Discussion of the plan` info = `Online meeting` type = `Type04` tentative = abap_false )
          ( start_at = `2017-02-03T08:30:00` end_at = `2017-02-13T09:30:00` title = `Meeting with the manager` type = `Type02` tentative = abap_false )
          ( start_at = `2017-02-04T10:00:00` end_at = `2017-02-04T12:00:00` title = `Team meeting` info = `room 1` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false )
          ( start_at = `2017-03-30T10:00:00` end_at = `2017-06-02T12:00:00` title = `Working out of the building` type = `Type07` pic = `sap-icon://sap-ui5` tentative = abap_false )
        )
        t_headers = VALUE #(
          ( start_at = `2017-01-15T08:00:00` end_at = `2017-01-15T10:00:00` title = `Reminder` type = `Type06` )
          ( start_at = `2017-01-15T17:00:00` end_at = `2017-01-15T19:00:00` title = `Reminder` type = `Type06` )
          ( start_at = `2017-09-01T00:00:00` end_at = `2017-11-30T23:59:00` title = `New quarter` type = `Type10` )
          ( start_at = `2018-02-01T00:00:00` end_at = `2018-04-30T23:59:00` title = `New quarter` type = `Type10` )
        )
      )
      ( pic = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/Donna_Moore.jpg` name = `Donna Moore` role = `team member`
        t_appointments = VALUE #(
          ( start_at = `2017-01-10T18:00:00` end_at = `2017-01-10T19:10:00` title = `Discussion of the plan` info = `Online meeting` type = `Type04` tentative = abap_false )
          ( start_at = `2017-01-09T10:00:00` end_at = `2017-01-13T12:00:00` title = `Workshop out of the country` type = `Type07` pic = `sap-icon://sap-ui5` tentative = abap_false )
          ( start_at = `2017-01-15T08:00:00` end_at = `2017-01-15T09:30:00` title = `Discussion of the plan` info = `Online meeting` type = `Type04` tentative = abap_false )
          ( start_at = `2017-01-15T10:00:00` end_at = `2017-01-15T12:00:00` title = `Team meeting` info = `room 1` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false )
          ( start_at = `2017-01-15T18:00:00` end_at = `2017-01-15T19:10:00` title = `Discussion of the plan` info = `Online meeting` type = `Type04` tentative = abap_false )
          ( start_at = `2017-01-16T10:00:00` end_at = `2017-01-31T12:00:00` title = `Workshop out of the country` type = `Type07` pic = `sap-icon://sap-ui5` tentative = abap_false )
          ( start_at = `2018-01-01T00:00:00` end_at = `2018-03-31T23:59:00` title = `New quarter` type = `Type10` tentative = abap_false )
          ( start_at = `2017-02-11T10:00:00` end_at = `2017-03-20T12:00:00` title = `Team collaboration` info = `room 1` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false )
          ( start_at = `2017-04-01T10:00:00` end_at = `2017-05-01T12:00:00` title = `Workshop out of the country` type = `Type07` pic = `sap-icon://sap-ui5` tentative = abap_false )
          ( start_at = `2017-05-01T10:00:00` end_at = `2017-05-31T12:00:00` title = `Out of the office` type = `Type08` tentative = abap_false )
          ( start_at = `2017-08-01T00:00:00` end_at = `2017-08-31T23:59:00` title = `Vacation` info = `out of office` type = `Type04` tentative = abap_false )
        )
        t_headers = VALUE #(
          ( start_at = `2017-01-15T09:00:00` end_at = `2017-01-15T10:00:00` title = `Payment reminder` type = `Type06` )
          ( start_at = `2017-01-15T16:30:00` end_at = `2017-01-15T18:00:00` title = `Private appointment` type = `Type06` )
        )
      )
      ( pic = `sap-icon://employee` name = `Max Mustermann` role = `team member`
        t_appointments = VALUE #(
          ( start_at = `2017-01-15T08:30:00` end_at = `2017-01-15T09:30:00` title = `Meet John Miller` type = `Type02` tentative = abap_false )
          ( start_at = `2017-01-15T10:00:00` end_at = `2017-01-15T12:00:00` title = `Team meeting` info = `room 1` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false )
          ( start_at = `2017-01-15T13:00:00` end_at = `2017-01-15T16:00:00` title = `Discussion with clients` info = `online` type = `Type02` tentative = abap_false )
          ( start_at = `2017-01-16T00:00:00` end_at = `2017-01-16T23:59:00` title = `Vacation` info = `out of office` type = `Type04` tentative = abap_false )
          ( start_at = `2017-01-17T01:00:00` end_at = `2017-01-18T22:00:00` title = `Workshop` info = `regular` type = `Type07` pic = `sap-icon://sap-ui5` tentative = abap_false )
          ( start_at = `2017-01-19T08:30:00` end_at = `2017-01-19T18:30:00` title = `Meet John Doe` type = `Type02` tentative = abap_false )
          ( start_at = `2017-01-19T10:00:00` end_at = `2017-01-19T16:00:00` title = `Team meeting` info = `room 1` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false )
          ( start_at = `2017-01-19T07:00:00` end_at = `2017-01-19T17:30:00` title = `Discussion with clients` type = `Type02` tentative = abap_false )
          ( start_at = `2017-01-20T00:00:00` end_at = `2017-01-20T23:59:00` title = `Vacation` info = `out of office` type = `Type04` tentative = abap_false )
          ( start_at = `2017-01-22T07:00:00` end_at = `2017-01-27T17:30:00` title = `Discussion with clients` info = `out of office` type = `Type02` tentative = abap_false )
          ( start_at = `2017-03-13T09:00:00` end_at = `2017-03-17T10:00:00` title = `Payment week` type = `Type06` )
          ( start_at = `2017-04-10T00:00:00` end_at = `2017-06-16T23:59:00` title = `Vacation` info = `out of office` type = `Type04` tentative = abap_false )
          ( start_at = `2017-08-01T00:00:00` end_at = `2017-10-31T23:59:00` title = `New quarter` type = `Type10` tentative = abap_false )
        )
        t_headers = VALUE #(
          ( start_at = `2017-01-16T00:00:00` end_at = `2017-01-16T23:59:00` title = `Private` type = `Type05` )
        )
      ) ).

  ENDMETHOD.

ENDCLASS.
