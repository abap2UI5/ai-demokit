" @keywords calendar sap.ui.unified calendarariahaspopup verticallayout text datetyperange popover vbox title
" @summary A Calendar whose three special dates carry ariaHasPopup='dialog': day 5 with a Type01 colour bar, days 10-12 as a Type02 range, and day 20 with type='None' so the attribute reaches the DOM with no visual marking at all; selecting a marked...
CLASS z2ui5_cl_smpc_app_611 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_special,
             start_date   TYPE string,
             end_date     TYPE string,
             type         TYPE string,
             ariahaspopup TYPE string,
             label        TYPE string,
           END OF ty_s_special.
    TYPES ty_t_special TYPE STANDARD TABLE OF ty_s_special WITH EMPTY KEY.

    DATA t_special TYPE ty_t_special.

    DATA popover_date TYPE string.
    DATA popover_type TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popover_show.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_611 IMPLEMENTATION.

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

    " DateTypeRange.startDate is typed "object" and demands a real JS Date; the
    " model keeps ABAP DATS strings and Formatter.DateAbapDateToDateObject
    " converts them at the point of use (app 240 idiom, needs UI5 >= 1.74)
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:l`      v = `sap.ui.layout`
        )->a( n = `xmlns:u`      v = `sap.ui.unified`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `class`        v = `viewPadding`
        )->a( n = `core:require` v = `{Formatter: 'z2ui5/model/formatter'}`
        )->a( n = `xmlns:core`   v = `sap.ui.core`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `width` v = `100%`

            )->tag( `Text`
                )->a( n = `text`  v = `Day 5 — Type01 color bar + aria-haspopup=dialog (special date with visual type).`
                )->a( n = `class` v = `sapUiTinyMarginBottom`
            )->tag( `Text`
                )->a( n = `text`  v = `Days 10–12 — Type02 range + aria-haspopup=dialog (date range with visual type).`
                )->a( n = `class` v = `sapUiTinyMarginBottom`
            )->tag( `Text`
                )->a( n = `text`  v = `Day 20 — type=None, no visual marking, only aria-haspopup=dialog in the DOM.`
                )->a( n = `class` v = `sapUiSmallMarginBottom`

            )->ele( n = `Calendar` ns = `u`
                )->a( n = `id`           v = `calendar`
                " onInit adds the three DateTypeRanges in JavaScript; specialDates
                " IS a bindable aggregation, so the port binds the same three rows
                )->a( n = `specialDates` v = client->_bind( t_special )
                )->a( n = `select`       v = client->_event( val   = `DATE_SELECT`
                                                             t_arg = VALUE #( ( `${$source>/selectedDates}[0].getStartDate().getTime()` ) ) )

                )->ele( n = `specialDates` ns = `u`
                    )->tag( n = `DateTypeRange` ns = `u`
                        )->a( n = `startDate`    v = `{ path: 'START_DATE', formatter: 'Formatter.DateAbapDateToDateObject' }`
                        )->a( n = `endDate`      v = `{ path: 'END_DATE', formatter: 'Formatter.DateAbapDateToDateObject' }`
                        )->a( n = `type`         v = `{TYPE}`
                        )->a( n = `ariaHasPopup` v = `{ARIAHASPOPUP}`
                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `DATE_SELECT`.
      popover_show( ).
    ENDIF.

  ENDMETHOD.


  METHOD popover_show.

    DATA days     TYPE i.
    DATA selected TYPE d.

    " onDateSelect looks the selected day up among the special dates that carry
    " an ariaHasPopup and, if it lands inside one, fills the popover and opens it
    DATA(millis) = client->get_event_arg( ).

    IF millis IS INITIAL.
      RETURN.
    ENDIF.

    " the event carries the day as epoch milliseconds; back to an ABAP date.
    " decfloat34, not i: epoch milliseconds are ~1.8e12 and ABAP's i tops out at
    " 2,147,483,647, so CONV i( millis ) raises CX_SY_CONVERSION_OVERFLOW on a
    " real stack (the transpiled backend represents i as a JS number, which is
    " why CI never saw it). The quotient is ~20700 days and fits i
    days     = CONV decfloat34( millis ) / 86400000.
    selected = CONV d( '19700101' ) + days.

    LOOP AT t_special INTO DATA(range).
      IF range-ariahaspopup IS INITIAL.
        CONTINUE.
      ENDIF.
      DATA(range_end) = COND d( WHEN range-end_date IS INITIAL
                                THEN CONV d( range-start_date )
                                ELSE CONV d( range-end_date ) ).
      IF selected >= CONV d( range-start_date ) AND selected <= range_end.
        popover_date = range-label.
        popover_type = |Day type: { range-type }|.

        DATA(popover) = z2ui5_cl_ui5_view_builder=>factory( ).
        popover->ele( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns:core` v = `sap.ui.core`
            )->a( n = `xmlns`      v = `sap.m`

            )->ele( `Popover`
                )->a( n = `id`              v = `popover`
                )->a( n = `placement`       v = `Bottom`
                )->a( n = `showHeader`      v = `false`
                )->a( n = `contentMinWidth` v = `200px`
                )->ele( `VBox`
                    )->a( n = `class` v = `sapUiSmallMargin`
                    )->tag( `Title`
                        )->a( n = `id`       v = `popoverDate`
                        )->a( n = `text`     v = client->_bind( popover_date )
                        )->a( n = `wrapping` v = `true`
                    )->tag( `Text`
                        )->a( n = `id`   v = `popoverType`
                        )->a( n = `text` v = client->_bind( popover_type ) ).

        client->popover_display( xml   = popover->stringify( )
                                 by_id = `calendar` ).
        RETURN.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD model_init.

    " onInit builds three DateTypeRanges on the CURRENT month: day 5 (Type01),
    " days 10-12 (Type02) and day 20 (None) - all three with ariaHasPopup Dialog
    DATA(prefix) = |{ sy-datum+0(4) }{ sy-datum+4(2) }|.

    t_special = VALUE #(
      ( start_date   = |{ prefix }05|
        type         = `Type01`
        ariahaspopup = `Dialog`
        label        = |{ prefix }05| )
      ( start_date   = |{ prefix }10|
        end_date     = |{ prefix }12|
        type         = `Type02`
        ariahaspopup = `Dialog`
        label        = |{ prefix }10 – { prefix }12| )
      ( start_date   = |{ prefix }20|
        type         = `None`
        ariahaspopup = `Dialog`
        label        = |{ prefix }20| ) ).

  ENDMETHOD.

ENDCLASS.
