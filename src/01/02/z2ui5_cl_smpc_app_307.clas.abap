" @keywords calendar sap.ui.unified calendarmultipledayselection html verticallayout button list standardlistitem
" @summary Calendar where the user can select multiple days, entire weeks (either by selecting its week number or by using SHIFT + Space) and ranges (using SHIFT + ENTER/Left mouse click).
CLASS z2ui5_cl_smpc_app_307 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_date,
             date TYPE string,
           END OF ty_s_date.
    DATA selecteddates TYPE STANDARD TABLE OF ty_s_date WITH DEFAULT KEY.

  PROTECTED SECTION.
    " one entry per DateRange the frontend marshalled out of the LIVE
    " selectedDates aggregation - startDate arrives as an ISO LOCAL timestamp
    " (no Z), so its first ten characters are the day the user picked
    TYPES: BEGIN OF ty_s_event_range,
             startdate TYPE string,
           END OF ty_s_event_range.
    TYPES ty_t_event_range TYPE STANDARD TABLE OF ty_s_event_range WITH DEFAULT KEY.

    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS event_ranges
      IMPORTING
        val           TYPE string
      RETURNING
        VALUE(result) TYPE ty_t_event_range.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_307 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

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
                " the WHOLE selectedDates aggregation travels in one arg: the
                " frontend marshals each DateRange into its public properties
                " (Lib.normalizeEventArgs), which is the loop the client
                " expression grammar does not have
                )->a( n = `select`            v = client->_event( val = `CAL_SELECT` arg = `$event.oSource.getSelectedDates()` )
                )->a( n = `intervalSelection` v = `false`
                )->a( n = `singleSelection`   v = `false`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `REMOVE_SELECTION` )
                )->a( n = `text`  v = `Remove All Selected Dates`

            )->ele( `List`
                )->a( n = `id`         v = `selectedDatesList`
                )->a( n = `class`      v = `labelMarginLeft`
                )->a( n = `noDataText` v = `No Dates Selected`
                )->a( n = `headerText` v = `Selected Dates (yyyy-mm-dd)`
                )->a( n = `items`      v = |\{path: '{ client->_bind_path( selecteddates ) }'\}|

                )->tag( `StandardListItem`
                    )->a( n = `title` v = `{DATE}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA ranges TYPE z2ui5_cl_smpc_app_307=>ty_t_event_range.
        DATA temp1 LIKE LINE OF ranges.
        DATA lr_range LIKE REF TO temp1.
          DATA temp2 TYPE z2ui5_cl_smpc_app_307=>ty_s_date.
        DATA temp3 TYPE string_table.

    CASE client->get_event( ).

      WHEN `CAL_SELECT`.
        " handleCalendarSelect: rebuild the model from EVERY selected date,
        " each formatted yyyy-MM-dd - the day is the first ten characters of
        " the ISO local timestamp the marshalled DateRange carries
        CLEAR selecteddates.
        
        ranges = event_ranges( client->get_event_arg( ) ).
        
        
        LOOP AT ranges REFERENCE INTO lr_range.
          IF strlen( lr_range->startdate ) < 10.
            CONTINUE.
          ENDIF.
          
          CLEAR temp2.
          temp2-date = lr_range->startdate(10).
          INSERT temp2 INTO TABLE selecteddates.
        ENDLOOP.

      WHEN `REMOVE_SELECTION`.
        " handleRemoveSelection: removeAllSelectedDates( ) + clear the model.
        " selectedDates is written by the control itself, so the aggregation
        " has to be emptied on the control - the model half alone would leave
        " the days highlighted
        CLEAR selecteddates.
        
        CLEAR temp3.
        INSERT `calendar` INTO TABLE temp3.
        INSERT `removeAllSelectedDates` INTO TABLE temp3.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = temp3 ).

    ENDCASE.

  ENDMETHOD.


  METHOD event_ranges.

    DATA lv_json TYPE string.
    lv_json = condense( val ).
    IF lv_json IS INITIAL.
      RETURN.
    ENDIF.

    IF lv_json(1) <> `[`.
      lv_json = |[{ lv_json }]|.
    ENDIF.

    TRY.
        " a marshalled DateRange carries ALL its public properties (ID,
        " startDate, endDate), so only the one field this port models is
        " mapped - a plain to_abap( ) fails on the first extra one
        "
        " z2ui5_cl_ajson is the framework's VENDORED ajson copy and lives
        " outside the released API (src/02), so it may be renamed or
        " restructured without notice - the linter says so, and it is right.
        " There is no released JSON reader to use instead, the same reasoning
        " as apps 103 and 298; declared as a deviation in the sidecar
        " abap2ui5lint-disable-next-line non-released-api -- no released JSON reader exists; see the comment above and the sidecar deviation
        z2ui5_cl_ajson=>parse( lv_json
          )->to_abap_corresponding_only(
          )->to_abap( IMPORTING ev_container = result ).
        " abap2ui5lint-disable-next-line non-released-api -- the exception of the call above
      CATCH z2ui5_cx_ajson_error.
        CLEAR result.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
