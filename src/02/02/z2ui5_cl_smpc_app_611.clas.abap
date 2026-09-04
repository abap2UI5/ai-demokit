" @keywords calendar sap.ui.unified calendarariahaspopup html verticallayout text datetyperange popover vbox title
" @summary Calendar demonstrating configurable aria-haspopup attribute on individual day cells via DateTypeRange and a global Calendar-level fallback.
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
    TYPES ty_t_special TYPE STANDARD TABLE OF ty_s_special WITH DEFAULT KEY.

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
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

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

        " the sample's own ../style.css (shared by the sap.ui.unified samples and
        " listed in this sample's manifest) - the view carries the class and the
        " rule behind it has to come with it. \{ \} escaped: the XMLView parser
        " reads an unescaped brace as a binding
        )->tag( n = `HTML` ns = `core`
            )->a( n = `content` v = `<style>.viewPadding\{padding:1rem\}` &&
                                    `.sap-phone .viewPadding\{padding:0rem\}` &&
                                    `.sap-phone .sapUiCal\{position:relative\}</style>`
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
                )->a( n = `select`       v = client->_event( val = `DATE_SELECT` arg = `${$source>/selectedDates}[0].getStartDate().getTime()` )

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
    DATA millis TYPE string.
    DATA temp1 TYPE decfloat34.
    DATA temp2 TYPE d.
    DATA range LIKE LINE OF t_special.
      DATA temp3 TYPE d.
      DATA temp5 TYPE d.
      DATA temp6 TYPE d.
      DATA range_end LIKE temp6.
      DATA temp4 TYPE d.
        DATA popover TYPE REF TO z2ui5_cl_ui5_view_builder.
    millis = client->get_event_arg( ).

    IF millis IS INITIAL.
      RETURN.
    ENDIF.

    " the event carries the day as epoch milliseconds; back to an ABAP date.
    " decfloat34, not i: epoch milliseconds are ~1.8e12 and ABAP's i tops out at
    " 2,147,483,647, so CONV i( millis ) raises CX_SY_CONVERSION_OVERFLOW on a
    " real stack (the transpiled backend represents i as a JS number, which is
    " why CI never saw it). The quotient is ~20700 days and fits i
    
    temp1 = millis.
    days     = temp1 / 86400000.
    
    temp2 = '19700101'.
    selected = temp2 + days.

    
    LOOP AT t_special INTO range.
      IF range-ariahaspopup IS INITIAL.
        CONTINUE.
      ENDIF.
      
      temp3 = range-start_date.
      
      temp5 = range-end_date.
      
      IF range-end_date IS INITIAL.
        temp6 = temp3.
      ELSE.
        temp6 = temp5.
      ENDIF.
      
      range_end = temp6.
      
      temp4 = range-start_date.
      IF selected >= temp4 AND selected <= range_end.
        popover_date = range-label.
        popover_type = |Day type: { range-type }|.

        
        popover = z2ui5_cl_ui5_view_builder=>factory( ).
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

        client->popover_display( xml = popover->stringify( ) by_id = `calendar` ).
        RETURN.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD model_init.

    " onInit builds three DateTypeRanges on the CURRENT month: day 5 (Type01),
    " days 10-12 (Type02) and day 20 (None) - all three with ariaHasPopup Dialog
    DATA prefix TYPE string.
    DATA temp5 TYPE z2ui5_cl_smpc_app_611=>ty_t_special.
    DATA temp6 LIKE LINE OF temp5.
    prefix = |{ sy-datum+0(4) }{ sy-datum+4(2) }|.

    
    CLEAR temp5.
    
    temp6-start_date = |{ prefix }05|.
    temp6-type = `Type01`.
    temp6-ariahaspopup = `Dialog`.
    temp6-label = |{ prefix }05|.
    INSERT temp6 INTO TABLE temp5.
    temp6-start_date = |{ prefix }10|.
    temp6-end_date = |{ prefix }12|.
    temp6-type = `Type02`.
    temp6-ariahaspopup = `Dialog`.
    temp6-label = |{ prefix }10 – { prefix }12|.
    INSERT temp6 INTO TABLE temp5.
    temp6-start_date = |{ prefix }20|.
    temp6-type = `None`.
    temp6-ariahaspopup = `Dialog`.
    temp6-label = |{ prefix }20|.
    INSERT temp6 INTO TABLE temp5.
    t_special = temp5.

  ENDMETHOD.

ENDCLASS.
