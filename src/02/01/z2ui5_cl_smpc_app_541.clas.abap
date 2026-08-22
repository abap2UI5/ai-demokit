CLASS z2ui5_cl_smpc_app_541 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_special,
             start_at      TYPE string,
             end_at        TYPE string,
             type          TYPE string,
             secondarytype TYPE string,
             color         TYPE string,
           END OF ty_s_special.
    TYPES ty_t_special TYPE STANDARD TABLE OF ty_s_special WITH EMPTY KEY.
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
             t_specials     TYPE ty_t_special,
             t_appointments TYPE ty_t_appointment,
             t_headers      TYPE ty_t_header,
           END OF ty_s_person.
    DATA t_people TYPE STANDARD TABLE OF ty_s_person WITH EMPTY KEY.

    TYPES: BEGIN OF ty_s_legend,
             text  TYPE string,
             type  TYPE string,
             color TYPE string,
           END OF ty_s_legend.
    TYPES ty_t_legend TYPE STANDARD TABLE OF ty_s_legend WITH EMPTY KEY.

    DATA t_special_dates     TYPE ty_t_special.
    DATA t_legend_items      TYPE ty_t_legend.
    DATA t_legend_appt_items TYPE ty_t_legend.

    DATA start_date     TYPE string.
    DATA legend_shown   TYPE abap_bool.
    DATA view_key       TYPE string.
    DATA first_day      TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_541 IMPLEMENTATION.

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

    " calendar date properties are typed "object" and demand a real JS Date;
    " the model keeps ISO strings and Formatter.DateCreateObject converts them
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:core`    v = `sap.ui.core`
        )->a( n = `xmlns:mvc`     v = `sap.ui.core.mvc`
        )->a( n = `xmlns:unified` v = `sap.ui.unified`
        )->a( n = `xmlns:l`       v = `sap.ui.layout`
        )->a( n = `xmlns`         v = `sap.m`
        )->a( n = `core:require`  v = `{Formatter: 'z2ui5/model/formatter'}`

        )->ele( n = `DynamicSideContent` ns = `l`
            )->a( n = `id`                   v = `DynamicSideContent`
            )->a( n = `class`                v = `sapUiDSCExplored sapUiContentPadding`
            )->a( n = `sideContentVisibility` v = `AlwaysShow`
            " the original keeps the legend flag in a second named model; abap2UI5
            " keeps one default model, so the flag is a field here
            )->a( n = `showSideContent`      v = client->_bind( legend_shown )
            )->a( n = `containerQuery`       v = `true`

            )->ele( `VBox`

                )->ele( `VBox`
                    )->a( n = `width` v = `180px`

                    )->tag( `Label`
                        )->a( n = `text` v = `Choose first day of week:`
                    " onChange calls setFirstDayOfWeek( Number( key ) ); the property
                    " is bindable, so the Select shares its key with the calendar
                    )->ele( `Select`
                        )->a( n = `selectedKey` v = client->_bind( first_day )

                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `-1`
                            )->a( n = `text` v = `Locale-based`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `1`
                            )->a( n = `text` v = `Monday`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `2`
                            )->a( n = `text` v = `Tuesday`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `3`
                            )->a( n = `text` v = `Wednesday`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `4`
                            )->a( n = `text` v = `Thursday`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `5`
                            )->a( n = `text` v = `Friday`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `6`
                            )->a( n = `text` v = `Saturday`
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `0`
                            )->a( n = `text` v = `Sunday`

                    )->end(
                )->end(

                )->ele( `PlanningCalendar`
                    )->a( n = `id`                        v = `PC1`
                    )->a( n = `class`                     v = `sapMPlanCalSuppressAlternatingRowColors`
                    )->a( n = `startDate`                 v = |\{ path: '{ client->_bind( val = start_date path = abap_true ) }', formatter: 'Formatter.DateCreateObject' \}|
                    )->a( n = `rows`                      v = client->_bind( t_people )
                    )->a( n = `appointmentsVisualization` v = `Filled`
                    )->a( n = `showEmptyIntervalHeaders`  v = `false`
                    " onChange calls setFirstDayOfWeek( Number( key ) ); the property is
                    " an INT and the Select's key is a string, so the expression multiplies
                    " by 1 - the Number( ) the original calls
                    )->a( n = `firstDayOfWeek`            v = |\{= ${ client->_bind( first_day ) } * 1 \}|
                    " handleViewChange only recomputes the legend's standardItems;
                    " viewKey is bindable, so the key is the shared field and the
                    " legend reads it through an expression
                    )->a( n = `viewKey`                   v = client->_bind( view_key )
                    )->a( n = `legend`                    v = `PlanningCalendarLegend`
                    )->a( n = `specialDates`              v = `{path: 'T_SPECIAL_DATES', templateShareable: false}`

                    )->ele( `toolbarContent`
                        )->tag( `ToggleButton`
                            )->a( n = `pressed` v = client->_bind( legend_shown )
                            )->a( n = `icon`    v = `sap-icon://legend`

                    )->end(

                    )->ele( `rows`
                        )->ele( `PlanningCalendarRow`
                            )->a( n = `icon`            v = `{PIC}`
                            )->a( n = `title`           v = `{NAME}`
                            )->a( n = `text`            v = `{ROLE}`
                            )->a( n = `specialDates`    v = `{path: 'T_SPECIALS', templateShareable: false}`
                            )->a( n = `appointments`    v = `{path: 'T_APPOINTMENTS', templateShareable: false}`
                            )->a( n = `intervalHeaders` v = `{path: 'T_HEADERS', templateShareable: false}`

                            )->ele( `specialDates`
                                )->tag( n = `DateTypeRange` ns = `unified`
                                    )->a( n = `startDate`     v = `{ path: 'START_AT', formatter: 'Formatter.DateCreateObject' }`
                                    )->a( n = `endDate`       v = `{ path: 'END_AT', formatter: 'Formatter.DateCreateObject' }`
                                    )->a( n = `type`          v = `{TYPE}`
                                    )->a( n = `secondaryType` v = `{SECONDARYTYPE}`

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

                    )->ele( `specialDates`
                        )->tag( n = `DateTypeRange` ns = `unified`
                            )->a( n = `startDate` v = `{ path: 'START_AT', formatter: 'Formatter.DateCreateObject' }`
                            )->a( n = `endDate`   v = `{ path: 'END_AT', formatter: 'Formatter.DateCreateObject' }`
                            )->a( n = `type`      v = `{TYPE}`
                            )->a( n = `color`     v = `{COLOR}`

                    )->end(
                )->end(
            )->end(

            )->ele( n = `sideContent` ns = `l`
                )->a( n = `width` v = `200px`

                )->ele( `PlanningCalendarLegend`
                    )->a( n = `id`               v = `PlanningCalendarLegend`
                    )->a( n = `items`            v = `{path: 'T_LEGEND_ITEMS', templateShareable: true}`
                    )->a( n = `appointmentItems` v = `{path: 'T_LEGEND_APPT_ITEMS', templateShareable: true}`
                    " changeStandardItemsPerView swaps Selected for WorkingDay off the
                    " OneMonth view; the property is bindable, so the expression over
                    " the shared view key carries the same switch
                    )->a( n = `standardItems`    v = |\{= ${ client->_bind( view_key ) } === 'One Month' ? ['Today','Selected','NonWorkingDay'] : ['Today','WorkingDay','NonWorkingDay'] \}|

                    )->ele( `items`
                        )->tag( n = `CalendarLegendItem` ns = `unified`
                            )->a( n = `text`    v = `{TEXT}`
                            )->a( n = `type`    v = `{TYPE}`
                            )->a( n = `tooltip` v = `{TEXT}`
                            )->a( n = `color`   v = `{COLOR}`

                    )->end(
                    )->ele( `appointmentItems`
                        )->tag( n = `CalendarLegendItem` ns = `unified`
                            )->a( n = `text`    v = `{TEXT}`
                            )->a( n = `type`    v = `{TYPE}`
                            )->a( n = `tooltip` v = `{TEXT}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    start_date   = `2017-01-15T08:00:00`.
    legend_shown = abap_false.
    view_key     = `Hour`.
    first_day    = `-1`.

    t_people = VALUE #(
      ( pic = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/John_Miller.png` name = `John Miller` role = `team member`
        t_specials = VALUE #(
          ( start_at = `2017-01-24T00:00:00` type = `NonWorking` )
          ( start_at = `2017-01-22T00:00:00` type = `Type10` secondarytype = `Working` )
        )
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
        )  )
      ( pic = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/Donna_Moore.jpg` name = `Donna Moore` role = `team member`
        t_specials = VALUE #(
          ( start_at = `2017-01-13T00:00:00` type = `NonWorking` )
        )
        t_appointments = VALUE #(
          ( start_at = `2017-01-10T18:00:00` end_at = `2017-01-10T19:10:00` title = `Discussion of the plan` info = `Online meeting` type = `Type04` tentative = abap_false )
          ( start_at = `2017-01-09T10:00:00` end_at = `2017-01-12T12:00:00` title = `Workshop out of the country` type = `Type07` pic = `sap-icon://sap-ui5` tentative = abap_false )
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
        )  )
      ( pic = `sap-icon://employee` name = `Max Mustermann` role = `team member`
        t_specials = VALUE #(
          ( start_at = `2017-01-16T00:00:00` end_at = `2017-01-18T00:00:00` type = `NonWorking` )
        )
        t_appointments = VALUE #(
          ( start_at = `2017-01-15T08:30:00` end_at = `2017-01-15T09:30:00` title = `Meet John Miller` type = `Type02` tentative = abap_false )
          ( start_at = `2017-01-15T10:00:00` end_at = `2017-01-15T12:00:00` title = `Team meeting` info = `room 1` type = `Type01` pic = `sap-icon://sap-ui5` tentative = abap_false )
          ( start_at = `2017-01-15T13:00:00` end_at = `2017-01-15T16:00:00` title = `Discussion with clients` info = `online` type = `Type02` tentative = abap_false )
          ( start_at = `2017-01-16T00:00:00` end_at = `2017-01-16T23:59:00` title = `Vacation` info = `out of office` type = `Type04` tentative = abap_false )
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
        )  ) ).

    t_special_dates = VALUE #(
      ( start_at = `2017-01-15T00:00:00` end_at = `2017-01-15T00:00:00` type = `Working` )
      ( start_at = `2017-01-16T00:00:00` end_at = `2017-01-18T00:00:00` type = `Type07` )
      ( start_at = `2017-01-19T00:00:00` end_at = `2017-01-19T23:59:00` type = `Type08` )
      ( start_at = `2017-01-21T00:00:00` end_at = `2017-01-21T23:59:00` type = `Type05` color = `#ff69b4` )
      ( start_at = `2017-01-22T00:00:00` end_at = `2017-01-22T23:59:00` type = `Type04` color = `#add8e6` )
      ( start_at = `2017-07-24T00:00:00` end_at = `2017-07-24T23:59:00` type = `Type09` )
      ( start_at = `2017-07-25T00:00:00` end_at = `2017-07-25T23:59:00` type = `Type14` )
    ).

    t_legend_items = VALUE #(
      ( text = `Public holiday` type = `Type07` )
      ( text = `Team building` type = `Type08` )
      ( text = `Work from office 1` type = `Type05` color = `#ff69b4` )
      ( text = `Work from office 2` type = `Type04` color = `#add8e6` )
    ).

    t_legend_appt_items = VALUE #(
      ( text = `Reminder` type = `Type06` )
      ( text = `Client meeting` type = `Type02` )
      ( text = `Team meeting` type = `Type01` )
      ( text = `Planning` type = `Type04` )
      ( text = `Out of office` type = `Type03` )
      ( text = `Customer Initiative` type = `Type07` )
    ).

  ENDMETHOD.

ENDCLASS.
