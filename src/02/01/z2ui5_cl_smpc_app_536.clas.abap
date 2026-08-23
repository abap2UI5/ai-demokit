" @keywords planningcalendar planning calendar sap.m vbox title select item planningcalendarrow customdata calendarappointment label
" @summary PlanningCalendar with single row selection that illustrates the built-in views.
CLASS z2ui5_cl_smpc_app_536 DEFINITION PUBLIC.

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

    DATA start_date     TYPE string.
    DATA primary_type   TYPE string.
    DATA secondary_type TYPE string.
    DATA t_built_in     TYPE string_table.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_536 IMPLEMENTATION.

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

    " calendar date properties (startDate/endDate) are typed "object" and demand a
    " real JS Date; the model keeps ISO strings and Formatter.DateCreateObject from
    " the curated module converts them at the point of use (needs UI5 >= 1.74)
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:core`    v = `sap.ui.core`
        )->a( n = `xmlns:mvc`     v = `sap.ui.core.mvc`
        )->a( n = `xmlns:unified` v = `sap.ui.unified`
        )->a( n = `xmlns`         v = `sap.m`
        )->a( n = `core:require`  v = `{Formatter: 'z2ui5/model/formatter'}`

        )->ele( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->ele( `PlanningCalendar`
                )->a( n = `id`                        v = `PC1`
                )->a( n = `startDate`                 v = |\{ path: '{ client->_bind( val = start_date path = abap_true ) }', formatter: 'Formatter.DateCreateObject' \}|
                )->a( n = `rows`                      v = client->_bind( t_people )
                )->a( n = `appointmentsVisualization` v = `Filled`
                " handleAppointmentSelect: MessageBox with the appointment title, its
                " new selected state and the number of selected appointments - or, when
                " the interval selection hit no appointment, the count of them. Every
                " value is client-readable, so it travels and ABAP composes both branches
                )->a( n = `appointmentSelect`         v = client->_event(
                          val   = `APPT_SELECT`
                          t_arg = VALUE #(
                            ( `${$parameters>/appointment} ? ${$parameters>/appointment}.getTitle() : ''` )
                            ( `${$parameters>/appointment} ? ${$parameters>/appointment}.getSelected() : false` )
                            ( `$event.oSource.getSelectedAppointments().length` )
                            ( `${$parameters>/appointments} ? ${$parameters>/appointments}.length : 0` ) ) )
                " handleRowHeaderPress names the pressed row's id in a MessageBox
                )->a( n = `rowHeaderPress`            v = client->_event(
                          val   = `ROW_HEADER_PRESS`
                          t_arg = VALUE #( ( `${$parameters>/row}.getId()` ) ) )
                )->a( n = `showEmptyIntervalHeaders`  v = `false`
                )->a( n = `showWeekNumbers`           v = `true`
                " onCalendarTypeSelect / onCalendarSecondaryTypeSelect call the two
                " setters; both properties are bindable, so the two Selects share
                " their key with the calendar and the handlers are dropped
                )->a( n = `primaryCalendarType`       v = client->_bind( primary_type )
                " the secondary Select's None entry means "no secondary type" -
                " the original passes undefined, which the expression reproduces
                )->a( n = `secondaryCalendarType`     v = |\{= ${ client->_bind( secondary_type ) } === 'None' ? undefined : ${ client->_bind( secondary_type ) } \}|
                " handleSelectionFinish hands the MultiComboBox's selected keys to
                " setBuiltInViews - a bindable string[] property, bound here
                )->a( n = `builtInViews`              v = client->_bind( t_built_in )

                )->ele( `toolbarContent`
                    )->tag( `Title`
                        )->a( n = `text`       v = `Title`
                        )->a( n = `titleStyle` v = `H4`

                    )->ele( `Select`
                        )->a( n = `id`          v = `primaryCalendarTypeSelect`
                        )->a( n = `selectedKey` v = client->_bind( primary_type )

                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `Gregorian`
                            )->a( n = `text` v = `Gregorian`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `Islamic`
                            )->a( n = `text` v = `Islamic`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `Japanese`
                            )->a( n = `text` v = `Japanese`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `Persian`
                            )->a( n = `text` v = `Persian`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `Buddhist`
                            )->a( n = `text` v = `Buddhist`

                    )->end(
                    )->ele( `Select`
                        )->a( n = `id`          v = `secondaryCalendarTypeSelect`
                        )->a( n = `selectedKey` v = client->_bind( secondary_type )

                        )->tag( n = `Item` ns = `core`
                            )->a( n = `text` v = `Select secondary calendar type`
                            )->a( n = `key`  v = `None`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `Gregorian`
                            )->a( n = `text` v = `Gregorian`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `Islamic`
                            )->a( n = `text` v = `Islamic`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `Japanese`
                            )->a( n = `text` v = `Japanese`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `Persian`
                            )->a( n = `text` v = `Persian`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `Buddhist`
                            )->a( n = `text` v = `Buddhist`

                    )->end(
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
                                )->a( n = `startDate`    v = `{ path: 'START_AT', formatter: 'Formatter.DateCreateObject' }`
                                )->a( n = `endDate`      v = `{ path: 'END_AT', formatter: 'Formatter.DateCreateObject' }`
                                )->a( n = `icon`         v = `{PIC}`
                                )->a( n = `title`        v = `{TITLE}`
                                )->a( n = `text`         v = `{INFO}`
                                )->a( n = `type`         v = `{TYPE}`
                                )->a( n = `tentative`    v = `{TENTATIVE}`
                                )->a( n = `ariaHasPopup` v = `{ARIA}`

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

            )->tag( `Label`
                )->a( n = `text` v = `Add available built-in views to the example:`

            )->ele( `MultiComboBox`
                )->a( n = `selectionFinish` v = client->_event(
                          val   = `BUILT_IN_VIEWS`
                          t_arg = VALUE #( ( `$event.oSource.getSelectedKeys().join(',')` ) ) )
                )->a( n = `width`           v = `230px`
                )->a( n = `placeholder`     v = `Choose built-in views`

                )->ele( `items`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `Hour`
                        )->a( n = `text` v = `Hour`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `Day`
                        )->a( n = `text` v = `Day`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `Month`
                        )->a( n = `text` v = `Month`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `Week`
                        )->a( n = `text` v = `1 week`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `One Month`
                        )->a( n = `text` v = `1 month` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `APPT_SELECT`.
        DATA(appt_title) = client->get_event_arg( ).
        IF appt_title IS NOT INITIAL.
          DATA(selected) = COND string( WHEN client->get_event_arg( 2 ) = abap_true
                                        THEN `selected`
                                        ELSE `deselected` ).
          client->message_box_display(
              text = |'{ appt_title }' { selected }. \n Selected appointments: { client->get_event_arg( 3 ) }|
              type = `show` ).
        ELSE.
          client->message_box_display( text = |{ client->get_event_arg( 4 ) } Appointments selected|
                                       type = `show` ).
        ENDIF.

      WHEN `ROW_HEADER_PRESS`.
        client->message_box_display( text = |rowHeaderPressed on row: { client->get_event_arg( ) }|
                                     type = `show` ).

      WHEN `BUILT_IN_VIEWS`.
        " handleSelectionFinish: the picked keys become the calendar's built-in views
        CLEAR t_built_in.
        IF client->get_event_arg( ) IS NOT INITIAL.
          SPLIT client->get_event_arg( ) AT `,` INTO TABLE t_built_in.
        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    start_date   = `2017-01-15T08:00:00`.
    " onInit reads the calendar's own primary type back into the Select; the
    " default is Gregorian, and the secondary Select starts on its None entry
    primary_type   = `Gregorian`.
    secondary_type = `None`.

    t_people = VALUE #(
      ( pic = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/John_Miller.png` name = `John Miller` role = `team member`
        t_appointments = VALUE #(
          ( start_at = `2017-01-08T08:30:00` end_at = `2017-01-08T09:30:00` title = `Meet Max Mustermann` type = `Type02` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-11T10:00:00` end_at = `2017-01-11T12:00:00` title = `Team meeting` info = `room 1` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-12T11:30:00` end_at = `2017-01-12T13:30:00` title = `Lunch` info = `canteen` type = `Type03` tentative = abap_true aria = `Dialog` )
          ( start_at = `2017-01-15T08:30:00` end_at = `2017-01-15T09:30:00` title = `Meet Max Mustermann` type = `Type02` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-15T10:00:00` end_at = `2017-01-15T12:00:00` title = `Team meeting` info = `room 1` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false )
          ( start_at = `2017-01-15T11:30:00` end_at = `2017-01-15T13:30:00` title = `Lunch` info = `canteen` type = `Type03` tentative = abap_true aria = `Dialog` )
          ( start_at = `2017-01-15T13:30:00` end_at = `2017-01-15T17:30:00` title = `Discussion with clients` info = `online meeting` type = `Type02` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-16T04:00:00` end_at = `2017-01-16T22:30:00` title = `Discussion of the plan` info = `Online meeting` type = `Type04` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-18T08:30:00` end_at = `2017-01-18T09:30:00` title = `Meeting with the manager` type = `Type02` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-18T11:30:00` end_at = `2017-01-18T13:30:00` title = `Lunch` info = `canteen` type = `Type03` tentative = abap_true aria = `Dialog` )
          ( start_at = `2017-01-18T01:00:00` end_at = `2017-01-18T22:00:00` title = `Team meeting` info = `regular` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-21T00:30:00` end_at = `2017-01-21T23:30:00` title = `New Product` info = `room 105` type = `Type03` tentative = abap_true aria = `Dialog` )
          ( start_at = `2017-01-25T11:30:00` end_at = `2017-01-25T13:30:00` title = `Lunch` type = `Type03` tentative = abap_true aria = `Dialog` )
          ( start_at = `2017-01-29T10:00:00` end_at = `2017-01-29T12:00:00` title = `Team meeting` info = `room 1` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-30T08:30:00` end_at = `2017-01-30T09:30:00` title = `Meet Max Mustermann` type = `Type02` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-30T10:00:00` end_at = `2017-01-30T12:00:00` title = `Team meeting` info = `room 1` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-30T11:30:00` end_at = `2017-01-30T13:30:00` title = `Lunch` type = `Type03` tentative = abap_true aria = `Dialog` )
          ( start_at = `2017-01-30T13:30:00` end_at = `2017-01-30T17:30:00` title = `Discussion with clients` type = `Type02` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-31T10:00:00` end_at = `2017-01-31T11:30:00` title = `Discussion of the plan` info = `Online meeting` type = `Type04` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-02-03T08:30:00` end_at = `2017-02-13T09:30:00` title = `Meeting with the manager` type = `Type02` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-02-04T10:00:00` end_at = `2017-02-04T12:00:00` title = `Team meeting` info = `room 1` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-03-30T10:00:00` end_at = `2017-06-02T12:00:00` title = `Working out of the building` type = `Type07` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
        )
        t_headers = VALUE #(
          ( start_at = `2017-01-15T08:00:00` end_at = `2017-01-15T10:00:00` title = `Reminder` type = `Type06` )
          ( start_at = `2017-01-15T17:00:00` end_at = `2017-01-15T19:00:00` title = `Reminder` type = `Type06` )
          ( start_at = `2017-09-01T00:00:00` end_at = `2017-11-30T23:59:00` title = `New quarter` type = `Type10` )
          ( start_at = `2018-02-01T00:00:00` end_at = `2018-04-30T23:59:00` title = `New quarter` type = `Type10` )
        ) )
      ( pic = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/Donna_Moore.jpg` name = `Donna Moore` role = `team member`
        t_appointments = VALUE #(
          ( start_at = `2017-01-10T18:00:00` end_at = `2017-01-10T19:10:00` title = `Discussion of the plan` info = `Online meeting` type = `Type04` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-09T10:00:00` end_at = `2017-01-13T12:00:00` title = `Workshop out of the country` type = `Type07` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-15T08:00:00` end_at = `2017-01-15T09:30:00` title = `Discussion of the plan` info = `Online meeting` type = `Type04` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-15T10:00:00` end_at = `2017-01-15T12:00:00` title = `Team meeting` info = `room 1` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-15T18:00:00` end_at = `2017-01-15T19:10:00` title = `Discussion of the plan` info = `Online meeting` type = `Type04` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-16T10:00:00` end_at = `2017-01-31T12:00:00` title = `Workshop out of the country` type = `Type07` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2018-01-01T00:00:00` end_at = `2018-03-31T23:59:00` title = `New quarter` type = `Type10` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-02-11T10:00:00` end_at = `2017-03-20T12:00:00` title = `Team collaboration` info = `room 1` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-04-01T10:00:00` end_at = `2017-05-01T12:00:00` title = `Workshop out of the country` type = `Type07` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-05-01T10:00:00` end_at = `2017-05-31T12:00:00` title = `Out of the office` type = `Type08` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-08-01T00:00:00` end_at = `2017-08-31T23:59:00` title = `Vacation` info = `out of office` type = `Type04` tentative = abap_false aria = `Dialog` )
        )
        t_headers = VALUE #(
          ( start_at = `2017-01-15T09:00:00` end_at = `2017-01-15T10:00:00` title = `Payment reminder` type = `Type06` )
          ( start_at = `2017-01-15T16:30:00` end_at = `2017-01-15T18:00:00` title = `Private appointment` type = `Type06` )
        ) )
      ( pic = `sap-icon://employee` name = `Max Mustermann` role = `team member`
        t_appointments = VALUE #(
          ( start_at = `2017-01-15T08:30:00` end_at = `2017-01-15T09:30:00` title = `Meet John Miller` type = `Type02` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-15T10:00:00` end_at = `2017-01-15T12:00:00` title = `Team meeting` info = `room 1` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-15T13:00:00` end_at = `2017-01-15T16:00:00` title = `Discussion with clients` info = `online` type = `Type02` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-16T00:00:00` end_at = `2017-01-16T23:59:00` title = `Vacation` info = `out of office` type = `Type04` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-17T01:00:00` end_at = `2017-01-18T22:00:00` title = `Workshop` info = `regular` type = `Type07` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-19T08:30:00` end_at = `2017-01-19T18:30:00` title = `Meet John Doe` type = `Type02` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-19T10:00:00` end_at = `2017-01-19T16:00:00` title = `Team meeting` info = `room 1` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-19T07:00:00` end_at = `2017-01-19T17:30:00` title = `Discussion with clients` type = `Type02` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-20T00:00:00` end_at = `2017-01-20T23:59:00` title = `Vacation` info = `out of office` type = `Type04` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-01-22T07:00:00` end_at = `2017-01-27T17:30:00` title = `Discussion with clients` info = `out of office` type = `Type02` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-03-13T09:00:00` end_at = `2017-03-17T10:00:00` title = `Payment week` type = `Type06` aria = `Dialog` )
          ( start_at = `2017-04-10T00:00:00` end_at = `2017-06-16T23:59:00` title = `Vacation` info = `out of office` type = `Type04` tentative = abap_false aria = `Dialog` )
          ( start_at = `2017-08-01T00:00:00` end_at = `2017-10-31T23:59:00` title = `New quarter` type = `Type10` tentative = abap_false aria = `Dialog` )
        )
        t_headers = VALUE #(
          ( start_at = `2017-01-16T00:00:00` end_at = `2017-01-16T23:59:00` title = `Private` type = `Type05` )
        ) ) ).

  ENDMETHOD.

ENDCLASS.
