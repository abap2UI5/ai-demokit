" @keywords calendar sap.ui.unified calendarsingleintervalselection html verticallayout horizontallayout label text
" @summary Calendar where the user can select an interval or entire week (either by selecting its week number or by using SHIFT + Space).
CLASS z2ui5_cl_smpc_app_306 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA selected_from TYPE string.
    DATA selected_to   TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_306 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      selected_from = `No Date Selected`.
      selected_to   = `No Date Selected`.
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    DATA temp2 TYPE string_table.
    DATA temp3 TYPE z2ui5_if_client=>ty_s_event_control.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `$event.oSource.getSelectedDates().length > 0 && $event.oSource.getSelectedDates()[0].getStartDate() ? $event.oSource.getSelectedDates()[0].getStartDate().getFullYear() : 0` INTO TABLE temp1.
    INSERT `$event.oSource.getSelectedDates().length > 0 && $event.oSource.getSelectedDates()[0].getStartDate() ? $event.oSource.getSelectedDates()[0].getStartDate().getMonth() + 1 : 0` INTO TABLE temp1.
    INSERT `$event.oSource.getSelectedDates().length > 0 && $event.oSource.getSelectedDates()[0].getStartDate() ? $event.oSource.getSelectedDates()[0].getStartDate().getDate() : 0` INTO TABLE temp1.
    INSERT `$event.oSource.getSelectedDates().length > 0 && $event.oSource.getSelectedDates()[0].getEndDate() ? $event.oSource.getSelectedDates()[0].getEndDate().getFullYear() : 0` INTO TABLE temp1.
    INSERT `$event.oSource.getSelectedDates().length > 0 && $event.oSource.getSelectedDates()[0].getEndDate() ? $event.oSource.getSelectedDates()[0].getEndDate().getMonth() + 1 : 0` INTO TABLE temp1.
    INSERT `$event.oSource.getSelectedDates().length > 0 && $event.oSource.getSelectedDates()[0].getEndDate() ? $event.oSource.getSelectedDates()[0].getEndDate().getDate() : 0` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `${$parameters>/weekNumber}` INTO TABLE temp2.
    INSERT `${$parameters>/weekDays} && ${$parameters>/weekDays}.getStartDate() ? ${$parameters>/weekDays}.getStartDate().getFullYear() : 0` INTO TABLE temp2.
    INSERT `${$parameters>/weekDays} && ${$parameters>/weekDays}.getStartDate() ? ${$parameters>/weekDays}.getStartDate().getMonth() + 1 : 0` INTO TABLE temp2.
    INSERT `${$parameters>/weekDays} && ${$parameters>/weekDays}.getStartDate() ? ${$parameters>/weekDays}.getStartDate().getDate() : 0` INTO TABLE temp2.
    INSERT `${$parameters>/weekDays} && ${$parameters>/weekDays}.getEndDate() ? ${$parameters>/weekDays}.getEndDate().getFullYear() : 0` INTO TABLE temp2.
    INSERT `${$parameters>/weekDays} && ${$parameters>/weekDays}.getEndDate() ? ${$parameters>/weekDays}.getEndDate().getMonth() + 1 : 0` INTO TABLE temp2.
    INSERT `${$parameters>/weekDays} && ${$parameters>/weekDays}.getEndDate() ? ${$parameters>/weekDays}.getEndDate().getDate() : 0` INTO TABLE temp2.
    
    CLEAR temp3.
    temp3-prevent_default_expr = `${$parameters>/weekNumber} % 5 === 0`.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:u`   v = `sap.ui.unified`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `class`     v = `viewPadding`

        )->a( n = `xmlns:core` v = `sap.ui.core`

        " the sample's own ../style.css (shared by the sap.ui.unified samples and
        " listed in this sample's manifest) - the view carries the class and the
        " rule behind it has to come with it. \{ \} escaped: the XMLView parser
        " reads an unescaped brace as a binding
        )->tag( n = `HTML` ns = `core`
            )->a( n = `content` v = `<style>.viewPadding\{padding:1rem\}` &&
                                    `.sap-phone .viewPadding\{padding:0rem\}` &&
                                    `.sap-phone .sapUiCal\{position:relative\}` &&
                                    `.labelMarginLeft\{margin:1rem\}</style>`
        )->ele( n = `VerticalLayout` ns = `l`

            )->tag( n = `Calendar` ns = `u`
                )->a( n = `id`                v = `calendar`
                " both ends of the picked interval are read out of the event as UI5
                " EXPRESSIONS - indexed access and chained calls resolve there (app 139
                " idiom). The LOCAL date parts travel, not toISOString( ), which would
                " shift the day east of Greenwich
                )->a( n = `select`            v = client->_event( val   = `CAL_SELECT`
                                                                  t_arg = temp1 )
                )->a( n = `intervalSelection` v = `true`
                " weekNumberSelect is @since 1.56 on Calendar (1.60 is the Month
                " event of the same name) - the weekDays DateRange and the week
                " number travel as expression args. Every date arg is guarded on
                " weekDays ITSELF, not only on getStartDate( ): UI5 documents the
                " parameter as null when the week is being DESELECTED, and with
                " singleSelection + intervalSelection - this sample's wiring -
                " _handleWeekSelectionBySingleInterval really passes null. An
                " unguarded null.getStartDate( ) throws inside the expression, and
                " EventHandlerResolver rethrows: no round trip, no label update,
                " and the control's own deselect never runs either
                )->a( n = `weekNumberSelect`  v = client->_event( val   = `WEEK_SELECT`
                                                                  t_arg = temp2
                                                                  " handleWeekNumberSelect calls oEvent.preventDefault( )
                                                                  " for a week divisible by five, so the forbidden week
                                                                  " is not selected at all. The veto is CONDITIONAL, and
                                                                  " the boolean check_prevent_default is baked per wire -
                                                                  " which is why this carried an IMPROVISED deviation
                                                                  " until 2026-08-21 saying the refusal could only be a
                                                                  " toast. prevent_default_expr evaluates per firing (app
                                                                  " 247's columnResize, app 354's column filter), and the
                                                                  " condition here is a plain expression over an event
                                                                  " parameter.
                                                                  s_ctrl = temp3 )

            )->ele( n = `HorizontalLayout` ns = `l`
                )->tag( `Label`
                    )->a( n = `text`  v = `Selected From (yyyy-mm-dd):`
                    )->a( n = `class` v = `labelMarginLeft`
                )->tag( `Text`
                    )->a( n = `id`    v = `selectedDateFrom`
                    )->a( n = `text`  v = client->_bind( selected_from )
                    )->a( n = `class` v = `labelMarginLeft`

            )->end(
            )->ele( n = `HorizontalLayout` ns = `l`
                )->tag( `Label`
                    )->a( n = `text`  v = `Selected To (yyyy-mm-dd):`
                    )->a( n = `class` v = `labelMarginLeft`
                )->tag( `Text`
                    )->a( n = `id`    v = `selectedDateTo`
                    )->a( n = `text`  v = client->_bind( selected_to )
                    )->a( n = `class` v = `labelMarginLeft` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA temp3 TYPE i.
        DATA temp8 TYPE i.
        DATA temp12 TYPE string.
        DATA temp4 TYPE i.
        DATA temp9 TYPE i.
        DATA temp13 TYPE string.
        DATA temp5 TYPE i.
        DATA week LIKE temp5.
          DATA temp6 TYPE i.
          DATA temp10 TYPE i.
          DATA temp14 TYPE string.
          DATA temp7 TYPE i.
          DATA temp11 TYPE i.
          DATA temp15 TYPE string.

    CASE client->get_event( ).

      WHEN `CAL_SELECT`.
        " _updateText: the interval's start and end formatted yyyy-MM-dd, or
        " 'No Date Selected' where the DateRange has no such end
        
        temp3 = client->get_event_arg( 2 ).
        
        temp8 = client->get_event_arg( 3 ).
        
        IF client->get_event_arg( ) = `0` OR client->get_event_arg( ) IS INITIAL.
          temp12 = `No Date Selected`.
        ELSE.
          temp12 = |{ client->get_event_arg( ) }-{ temp3 WIDTH = 2 ALIGN = RIGHT PAD = '0' }| && |-{ temp8 WIDTH = 2 ALIGN = RIGHT PAD = '0' }|.
        ENDIF.
        selected_from = temp12.
        
        temp4 = client->get_event_arg( 5 ).
        
        temp9 = client->get_event_arg( 6 ).
        
        IF client->get_event_arg( 4 ) = `0` OR client->get_event_arg( 4 ) IS INITIAL.
          temp13 = `No Date Selected`.
        ELSE.
          temp13 = |{ client->get_event_arg( 4 ) }-{ temp4 WIDTH = 2 ALIGN = RIGHT PAD = '0' }| && |-{ temp9 WIDTH = 2 ALIGN = RIGHT PAD = '0' }|.
        ENDIF.
        selected_to   = temp13.

      WHEN `WEEK_SELECT`.
        " handleWeekNumberSelect: every fifth calendar week is refused with a
        " toast AND with the prevented default on the wire above, so the week is
        " not selected either; any other week fills the two labels from its
        " weekDays DateRange
        
        temp5 = client->get_event_arg( ).
        
        week = temp5.
        IF week MOD 5 = 0.
          client->message_toast_display( `You are not allowed to select this calendar week!` ).
        ELSE.
          
          temp6 = client->get_event_arg( 3 ).
          
          temp10 = client->get_event_arg( 4 ).
          
          IF client->get_event_arg( 2 ) = `0` OR client->get_event_arg( 2 ) IS INITIAL.
            temp14 = `No Date Selected`.
          ELSE.
            temp14 = |{ client->get_event_arg( 2 ) }-{ temp6 WIDTH = 2 ALIGN = RIGHT PAD = '0' }| && |-{ temp10 WIDTH = 2 ALIGN = RIGHT PAD = '0' }|.
          ENDIF.
          selected_from = temp14.
          
          temp7 = client->get_event_arg( 6 ).
          
          temp11 = client->get_event_arg( 7 ).
          
          IF client->get_event_arg( 5 ) = `0` OR client->get_event_arg( 5 ) IS INITIAL.
            temp15 = `No Date Selected`.
          ELSE.
            temp15 = |{ client->get_event_arg( 5 ) }-{ temp7 WIDTH = 2 ALIGN = RIGHT PAD = '0' }| && |-{ temp11 WIDTH = 2 ALIGN = RIGHT PAD = '0' }|.
          ENDIF.
          selected_to   = temp15.
        ENDIF.

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
