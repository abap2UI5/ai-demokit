CLASS z2ui5_cl_smpc_app_308 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_legend,
             type TYPE string,
             text TYPE string,
           END OF ty_s_legend.
    TYPES ty_t_legend TYPE STANDARD TABLE OF ty_s_legend WITH EMPTY KEY.
    TYPES: BEGIN OF ty_s_special,
             start_date     TYPE string,
             end_date       TYPE string,
             type           TYPE string,
             secondary_type TYPE string,
             tooltip        TYPE string,
             color          TYPE string,
           END OF ty_s_special.
    TYPES ty_t_special TYPE STANDARD TABLE OF ty_s_special WITH EMPTY KEY.

    DATA pressed    TYPE abap_bool.
    DATA t_legend1  TYPE ty_t_legend.
    DATA t_legend2  TYPE ty_t_legend.
    DATA t_special1 TYPE ty_t_special.
    DATA t_special2 TYPE ty_t_special.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS special_days_fill.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_308 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " DateTypeRange.startDate/endDate are typed "object" and demand a real JS Date;
    " the model keeps ISO strings and Formatter.DateCreateObject converts them at
    " the point of use (needs UI5 >= 1.74). endDate is optional, so its conversion
    " is guarded - new Date('') is an Invalid Date, which is truthy and kills the
    " whole view
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`      v = `sap.ui.layout`
        )->a( n = `xmlns:u`      v = `sap.ui.unified`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core`   v = `sap.ui.core`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `class`        v = `viewPadding`
        )->a( n = `core:require` v = `{Formatter: 'z2ui5/model/formatter'}`

        )->ele( n = `VerticalLayout` ns = `l`

            )->ele( n = `Calendar` ns = `u`
                )->a( n = `id`                v = `calendar1`
                )->a( n = `legend`            v = `legend1`
                )->a( n = `intervalSelection` v = `true`
                )->a( n = `specialDates`      v = client->_bind(
                                                      val                = t_special1
                                                      omit_initial_paths = VALUE #( ( `COLOR` )
                                                                                    ( `SECONDARY_TYPE` )
                                                                                    ( `TOOLTIP` ) ) )

                )->ele( n = `specialDates` ns = `u`
                    )->tag( n = `DateTypeRange` ns = `u`
                        )->a( n = `startDate`     v = `{ path: 'START_DATE', formatter: 'Formatter.DateCreateObject' }`
                        )->a( n = `endDate`       v = `{= ${END_DATE} ? Formatter.DateCreateObject(${END_DATE}) : null }`
                        )->a( n = `type`          v = `{TYPE}`
                        )->a( n = `secondaryType` v = `{SECONDARY_TYPE}`
                        )->a( n = `tooltip`       v = `{TOOLTIP}`
                        )->a( n = `color`         v = `{COLOR}`

                )->end(
            )->end(

            )->ele( n = `CalendarLegend` ns = `u`
                )->a( n = `id`    v = `legend1`
                )->a( n = `items` v = client->_bind( t_legend1 )

                )->ele( n = `items` ns = `u`
                    )->tag( n = `CalendarLegendItem` ns = `u`
                        )->a( n = `type` v = `{TYPE}`
                        )->a( n = `text` v = `{TEXT}`

                )->end(
            )->end(

            )->ele( n = `Calendar` ns = `u`
                )->a( n = `id`           v = `calendar2`
                )->a( n = `legend`       v = `legend2`
                )->a( n = `specialDates` v = client->_bind(
                                                 val                = t_special2
                                                 omit_initial_paths = VALUE #( ( `COLOR` )
                                                                               ( `SECONDARY_TYPE` )
                                                                               ( `TOOLTIP` ) ) )

                )->ele( n = `specialDates` ns = `u`
                    )->tag( n = `DateTypeRange` ns = `u`
                        )->a( n = `startDate`     v = `{ path: 'START_DATE', formatter: 'Formatter.DateCreateObject' }`
                        )->a( n = `endDate`       v = `{= ${END_DATE} ? Formatter.DateCreateObject(${END_DATE}) : null }`
                        )->a( n = `type`          v = `{TYPE}`
                        )->a( n = `secondaryType` v = `{SECONDARY_TYPE}`
                        )->a( n = `tooltip`       v = `{TOOLTIP}`
                        )->a( n = `color`         v = `{COLOR}`

                )->end(
            )->end(

            )->ele( n = `CalendarLegend` ns = `u`
                )->a( n = `id`            v = `legend2`
                )->a( n = `standardItems` v = `Today`
                )->a( n = `items`         v = client->_bind( t_legend2 )

                )->ele( n = `items` ns = `u`
                    )->tag( n = `CalendarLegendItem` ns = `u`
                        )->a( n = `type` v = `{TYPE}`
                        )->a( n = `text` v = `{TEXT}`

                )->end(
            )->end(

            )->tag( `ToggleButton`
                )->a( n = `text`    v = `Special Days`
                )->a( n = `pressed` v = client->_bind( pressed )
                )->a( n = `press`   v = client->_event( val   = `SHOW_SPECIAL_DAYS`
                                                        t_arg = VALUE #( ( `${$parameters>/pressed}` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `SHOW_SPECIAL_DAYS`.
        " handleShowSpecialDays: the pressed state adds the special dates and the
        " legend items to both calendars, the released state destroys them again -
        " here the four bound tables are filled and cleared instead
        pressed = client->get_event_arg( ).
        IF pressed = abap_true.
          special_days_fill( ).
        ELSE.
          CLEAR t_special1.
          CLEAR t_special2.
          CLEAR t_legend1.
          CLEAR t_legend2.
        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD special_days_fill.

    " the original walks a reference date through the CURRENT month with
    " setDate( n ), so every date below is day n of the current month
    DATA(prefix) = |{ sy-datum+0(4) }-{ sy-datum+4(2) }-|.

    CLEAR t_special1.
    CLEAR t_special2.
    CLEAR t_legend1.
    CLEAR t_legend2.

    DO 10 TIMES.
      DATA(i)    = sy-index.
      DATA(type) = |Type{ i WIDTH = 2 ALIGN = RIGHT PAD = '0' }|.
      DATA(text) = |Placeholder { i }|.
      DATA(day)  = |{ prefix }{ i WIDTH = 2 ALIGN = RIGHT PAD = '0' }|.

      t_special1 = VALUE #( BASE t_special1 ( start_date = day type = type tooltip = text ) ).
      t_special2 = VALUE #( BASE t_special2 ( start_date = day type = type tooltip = text ) ).
      t_legend1  = VALUE #( BASE t_legend1 ( type = type text = text ) ).
      t_legend2  = VALUE #( BASE t_legend2 ( type = type text = text ) ).
    ENDDO.

    t_special1 = VALUE #( BASE t_special1
      ( start_date = |{ prefix }12| type = `Type11` color = `#ff0000` )
      ( start_date = |{ prefix }13| type = `Type11` color = `#ff69b4` )
      ( start_date = |{ prefix }11| end_date = |{ prefix }21| type = `NonWorking` )
      ( start_date = |{ prefix }25| type = `Working` ) ).

    t_special2 = VALUE #( BASE t_special2
      ( start_date = |{ prefix }12| type = `Type11` color = `#ff0000` )
      ( start_date = |{ prefix }13| type = `Type11` color = `#add8e6` )
      ( start_date = |{ prefix }22| type = `Type03` secondary_type = `NonWorking` )
      ( start_date = |{ prefix }24| type = `Working` )
      ( start_date = |{ prefix }24| type = `Type03` ) ).

  ENDMETHOD.

ENDCLASS.
