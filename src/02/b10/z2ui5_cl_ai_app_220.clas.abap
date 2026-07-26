CLASS z2ui5_cl_ai_app_220 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_disabled,
             start TYPE string,
             end   TYPE string,
           END OF ty_s_disabled.
    TYPES ty_t_disabled TYPE STANDARD TABLE OF ty_s_disabled WITH EMPTY KEY.

    DATA min_date          TYPE string.
    DATA max_date          TYPE string.
    DATA t_disabled        TYPE ty_t_disabled.
    DATA show_week_numbers TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_220 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " Calendar min/max/disabled dates are typed "object" and demand real JS Date
    " objects; the model keeps ISO strings and Formatter.DateCreateObject from the
    " curated module converts them at the point of use (needs UI5 >= 1.74). The
    " original's imperative Switch handler (setShowWeekNumbers) is replaced by a
    " two-way binding shared between the Switch state and Calendar showWeekNumbers
    " (thin frontend); its select handler (formats the picked day into a Text) has
    " no bindable equivalent and is dropped.
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`      v = `sap.ui.layout`
        )->a( n = `xmlns:u`      v = `sap.ui.unified`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core`   v = `sap.ui.core`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `class`        v = `viewPadding`
        )->a( n = `core:require` v = `{Formatter: 'z2ui5/model/formatter'}`

        )->open( n = `VerticalLayout` ns = `l`

            )->open( n = `Calendar` ns = `u`
                )->a( n = `id`              v = `calendar`
                )->a( n = `minDate`         v = |\{ path: '{ client->_bind( val = min_date path = abap_true ) }', formatter: 'Formatter.DateCreateObject' \}|
                )->a( n = `maxDate`         v = |\{ path: '{ client->_bind( val = max_date path = abap_true ) }', formatter: 'Formatter.DateCreateObject' \}|
                )->a( n = `disabledDates`   v = client->_bind( t_disabled )
                )->a( n = `showWeekNumbers` v = client->_bind( show_week_numbers )

                )->open( n = `disabledDates` ns = `u`
                    )->leaf( n = `DateRange` ns = `u`
                        )->a( n = `startDate` v = |\{ path: 'START', formatter: 'Formatter.DateCreateObject' \}|
                        )->a( n = `endDate`   v = |\{ path: 'END', formatter: 'Formatter.DateCreateObject' \}|

                )->shut(
            )->shut(
            )->open( n = `HorizontalLayout` ns = `l`

                )->leaf( `Label`
                    )->a( n = `text` v = `Selected Date:`
                )->leaf( `Text`
                    )->a( n = `id`   v = `selectedDate`
                    )->a( n = `text` v = `No Date Selected`

            )->shut(
            )->open( n = `HorizontalLayout` ns = `l`

                )->open( `FlexBox`
                    )->a( n = `height`         v = `100px`
                    )->a( n = `alignItems`     v = `Center`
                    )->a( n = `justifyContent` v = `Start`

                    )->leaf( `Label`
                        )->a( n = `text` v = `Toggle week numbers:`
                    )->leaf( `Switch`
                        )->a( n = `state` v = client->_bind( show_week_numbers )

                )->shut(
            )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " original values are UI5Date.getInstance(year, month0, day) - month is
    " 0-based, normalized to ISO 1:1 (min 2000-01-01, max 2050-12-31)
    min_date          = `2000-01-01`.
    max_date          = `2050-12-31`.
    show_week_numbers = abap_true.
    t_disabled        = VALUE #(
      ( start = `2016-01-04` end = `2016-01-10` )
      ( start = `2016-01-15` end = `` ) ).

  ENDMETHOD.

ENDCLASS.
