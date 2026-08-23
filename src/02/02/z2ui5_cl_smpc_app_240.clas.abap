" @keywords calendarlegend calendar legend sap.ui.unified calendarlegendnavigation html verticallayout datetyperange calendarlegenditem
" @summary An example of adding navigatable legend to the calendar.
CLASS z2ui5_cl_smpc_app_240 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_legend,
             type TYPE string,
             text TYPE string,
           END OF ty_s_legend.
    TYPES ty_t_legend TYPE STANDARD TABLE OF ty_s_legend WITH EMPTY KEY.
    TYPES: BEGIN OF ty_s_special,
             start_date TYPE string,
             type       TYPE string,
             tooltip    TYPE string,
           END OF ty_s_special.
    TYPES ty_t_special TYPE STANDARD TABLE OF ty_s_special WITH EMPTY KEY.

    DATA t_legend  TYPE ty_t_legend.
    DATA t_special TYPE ty_t_special.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_240 IMPLEMENTATION.

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

    " DateTypeRange.startDate is typed "object" and demands a real JS Date; the
    " model keeps ABAP DATS strings and Formatter.DateAbapDateToDateObject converts them at the
    " point of use (needs UI5 >= 1.74)
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`      v = `sap.ui.layout`
        )->a( n = `xmlns:u`      v = `sap.ui.unified`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core`   v = `sap.ui.core`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `class`        v = `viewPadding`
        )->a( n = `core:require` v = `{Formatter: 'z2ui5/model/formatter'}`


        " the sample's own ../style.css (shared by the sap.ui.unified samples and
        " listed in this sample's manifest) - the view carries the class and the
        " rule behind it has to come with it. \{ \} escaped: the XMLView parser
        " reads an unescaped brace as a binding
        )->tag( n = `HTML` ns = `core`
            )->a( n = `content` v = `<style>.viewPadding\{padding:1rem\}` &&
                                    `.sap-phone .viewPadding\{padding:0rem\}</style>`
        )->ele( n = `VerticalLayout` ns = `l`

            )->ele( n = `Calendar` ns = `u`
                )->a( n = `id`                v = `calendar`
                )->a( n = `legend`            v = `legend`
                )->a( n = `intervalSelection` v = `true`
                )->a( n = `specialDates`      v = client->_bind( t_special )

                )->ele( n = `specialDates` ns = `u`
                    )->tag( n = `DateTypeRange` ns = `u`
                        )->a( n = `startDate` v = `{ path: 'START_DATE', formatter: 'Formatter.DateAbapDateToDateObject' }`
                        )->a( n = `type`      v = `{TYPE}`
                        )->a( n = `tooltip`   v = `{TOOLTIP}`

                )->end(
            )->end(

            )->ele( n = `CalendarLegend` ns = `u`
                )->a( n = `id`    v = `legend`
                )->a( n = `items` v = client->_bind( t_legend )

                )->ele( n = `items` ns = `u`
                    )->tag( n = `CalendarLegendItem` ns = `u`
                        )->a( n = `type` v = `{TYPE}`
                        )->a( n = `text` v = `{TEXT}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " original onInit adds 10 legend items and, per type, two special dates
    " (day i and day i+12 of the current month) - reproduced server-side so the
    " special dates track the current month exactly like the original UI5Date logic
    DATA lv_day TYPE i.
    " The special dates are ABAP DATS strings read through
    " Formatter.DateAbapDateToDateObject, which builds the Date from the parsed
    " parts - LOCAL midnight, which is what sap.ui.unified reads back
    " (CalendarDate.fromLocalJSDate). They were ISO date-only strings through
    " Formatter.DateCreateObject until 2026-08-21, and `new Date('yyyy-mm-dd')`
    " is UTC midnight, so west of Greenwich every marked day landed one day
    " early. Same defect and same fix as apps 220 and 017.
    DATA(lv_prefix) = |{ sy-datum+0(4) }{ sy-datum+4(2) }|.

    DO 10 TIMES.
      DATA(lv_i)    = sy-index.
      DATA(lv_type) = |Type{ lv_i WIDTH = 2 ALIGN = RIGHT PAD = '0' }|.
      DATA(lv_text) = |Placeholder { lv_i }|.

      t_legend = VALUE #( BASE t_legend ( type = lv_type text = lv_text ) ).

      lv_day = lv_i.
      DATA(lv_date1) = |{ lv_prefix }{ lv_day WIDTH = 2 ALIGN = RIGHT PAD = '0' }|.
      lv_day = lv_i + 12.
      DATA(lv_date2) = |{ lv_prefix }{ lv_day WIDTH = 2 ALIGN = RIGHT PAD = '0' }|.

      t_special = VALUE #( BASE t_special
        ( start_date = lv_date1 type = lv_type tooltip = lv_text )
        ( start_date = lv_date2 type = lv_type tooltip = lv_text ) ).
    ENDDO.

  ENDMETHOD.

ENDCLASS.
