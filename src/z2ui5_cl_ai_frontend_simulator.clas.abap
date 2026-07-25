"! Headless browser simulator for abap2UI5 apps.
"!
"! Drives an app through the same request/response JSON protocol the UI5
"! frontend uses (see abap2UI5 app/webapp/core/Server.js), but entirely on the
"! server - no browser required. Each call to start( )/click( ) is one
"! roundtrip: the request struct is filled, z2ui5_cl_core_handler runs the
"! app, and the response (view XML, model, messages) is parsed and kept.
"!
"! Typical use in an ABAP Unit test:
"!   DATA(sim) = z2ui5_cl_ai_frontend_simulator=>start( `Z2UI5_CL_AI_SIMULATOR_EXAMPLE` ).
"!   sim->set_value( name = `MV_NAME` value = `World` ).
"!   sim->click( `GREET` ).
"!   cl_abap_unit_assert=>assert_equals( exp = `Hello World!`
"!                                       act = sim->get_message( ) ).
"!
"! set_value / click / get_value address the app by the names the app author
"! already coded: the bound attribute name ( client->_bind( mv_name ) -> model
"! path /MV_NAME ) and the event id ( client->_event( `GREET` ) ). No view XML
"! parsing is involved - the XML is available via get_view( ) for inspection or
"! assertions. See z2ui5_cl_ai_simulator_example for a worked example.
CLASS z2ui5_cl_ai_frontend_simulator DEFINITION PUBLIC FINAL CREATE PRIVATE.

  PUBLIC SECTION.

    "! Start an app - one roundtrip without an id, mirroring the browser's
    "! first POST with ?app_start=<class name>.
    "! @parameter app    | Global class name of the app to start (e.g. `Z2UI5_CL_AI_SIMULATOR_EXAMPLE`).
    "! @parameter result | The simulator instance, holding the first response.
    CLASS-METHODS start
      IMPORTING
        app           TYPE clike
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_ai_frontend_simulator.

    "! Set a value into the model delta of the NEXT roundtrip - the equivalent
    "! of typing into a bound input. No roundtrip happens yet; the value is sent
    "! on the following click( ).
    "! @parameter name   | Bound attribute / model path (e.g. `MV_NAME` or `/MS_DATA/FIELD`).
    "! @parameter value  | The value to send.
    "! @parameter result | The simulator instance (for fluent chaining).
    METHODS set_value
      IMPORTING
        name          TYPE clike
        value         TYPE clike
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_ai_frontend_simulator.

    "! Fire an event - the equivalent of clicking a button. Sends the pending
    "! model delta together with the event and parses the response.
    "! @parameter event  | Event id as registered via client->_event( ).
    "! @parameter t_arg  | Optional event arguments (client->get_event_arg( )).
    "! @parameter result | The simulator instance (for fluent chaining).
    METHODS click
      IMPORTING
        event         TYPE clike
        t_arg         TYPE string_table OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_ai_frontend_simulator.

    "! The current view XML (last non-empty S_VIEW/XML from the server).
    METHODS get_view
      RETURNING
        VALUE(result) TYPE string.

    "! Read a value from the last server model. Reflects the model as of the
    "! last roundtrip that updated the view - it is not an echo of set_value( ).
    "! @parameter name | Bound attribute / model path (e.g. `MV_NAME`).
    METHODS get_value
      IMPORTING
        name          TYPE clike
      RETURNING
        VALUE(result) TYPE string.

    "! Text of the last message toast or message box of the last response
    "! (empty if the last roundtrip produced none).
    METHODS get_message
      RETURNING
        VALUE(result) TYPE string.

    "! Current draft id - the id the frontend would send with the next request.
    METHODS get_id
      RETURNING
        VALUE(result) TYPE string.

    "! Raw response JSON of the last roundtrip (for debugging / assertions).
    METHODS get_response_json
      RETURNING
        VALUE(result) TYPE string.

  PROTECTED SECTION.

  PRIVATE SECTION.

    DATA mo_handler   TYPE REF TO z2ui5_cl_core_handler.
    DATA mo_pending   TYPE REF TO z2ui5_if_ajson.
    DATA mo_model     TYPE REF TO z2ui5_if_ajson.
    DATA mv_id        TYPE string.
    DATA mv_view_xml  TYPE string.
    DATA mv_message   TYPE string.
    DATA mv_resp_json TYPE string.

    METHODS roundtrip
      IMPORTING
        event  TYPE clike        OPTIONAL
        search TYPE clike        OPTIONAL
        t_arg  TYPE string_table OPTIONAL.

    METHODS build_request
      IMPORTING
        event         TYPE clike        OPTIONAL
        search        TYPE clike        OPTIONAL
        t_arg         TYPE string_table OPTIONAL
      RETURNING
        VALUE(result) TYPE string.

    METHODS parse_response
      IMPORTING
        json TYPE string.

    METHODS conv_name_to_path
      IMPORTING
        name          TYPE clike
      RETURNING
        VALUE(result) TYPE string.

ENDCLASS.


CLASS z2ui5_cl_ai_frontend_simulator IMPLEMENTATION.

  METHOD start.

    result = NEW #( ).
    result->roundtrip( search = |?app_start={ app }| ).

  ENDMETHOD.

  METHOD set_value.

    IF mo_pending IS NOT BOUND.
      mo_pending = CAST z2ui5_if_ajson( z2ui5_cl_ajson=>create_empty( ) ).
    ENDIF.

    TRY.
        mo_pending->set( iv_path         = conv_name_to_path( name )
                         iv_val          = value
                         iv_ignore_empty = abap_false ).
      CATCH cx_root INTO DATA(lx).
        RAISE EXCEPTION TYPE z2ui5_cx_a2ui5_error EXPORTING val = lx.
    ENDTRY.

    result = me.

  ENDMETHOD.

  METHOD click.

    roundtrip( event = event
               t_arg = t_arg ).
    result = me.

  ENDMETHOD.

  METHOD roundtrip.

    DATA(lv_request) = build_request( event  = event
                                      search = search
                                      t_arg  = t_arg ).

    " Reuse the handler for sticky apps, create a fresh one otherwise -
    " the same distinction z2ui5_cl_http_handler=>_http_post makes. Draft
    " based apps chain their state through the persisted id in the request.
    IF mo_handler IS BOUND.
      mo_handler->mv_request_json = lv_request.
    ELSE.
      mo_handler = NEW z2ui5_cl_core_handler( lv_request ).
    ENDIF.

    TRY.
        DATA(ls_response) = mo_handler->main( ).
      CATCH cx_root INTO DATA(lx).
        " core_handler does not catch app exceptions itself (that is the job
        " of _main in the http handler) - surface the real text to the test
        RAISE EXCEPTION TYPE z2ui5_cx_a2ui5_error EXPORTING val = lx.
    ENDTRY.

    TRY.
        IF CAST z2ui5_if_app( mo_handler->mo_action->mo_app->mo_app )->check_sticky = abap_false.
          CLEAR mo_handler.
        ENDIF.
      CATCH cx_root.
        CLEAR mo_handler.
    ENDTRY.

    parse_response( ls_response-body ).
    CLEAR mo_pending.

  ENDMETHOD.

  METHOD build_request.

    TRY.
        DATA(lo_req) = CAST z2ui5_if_ajson( z2ui5_cl_ajson=>create_empty( ) ).

        IF mv_id IS NOT INITIAL.
          lo_req->set( iv_path = `/value/S_FRONT/ID`
                       iv_val  = mv_id ).
        ENDIF.

        IF event IS NOT INITIAL.
          lo_req->set( iv_path = `/value/S_FRONT/EVENT`
                       iv_val  = event ).
        ENDIF.

        lo_req->set( iv_path = `/value/S_FRONT/ORIGIN`
                     iv_val  = `SIMULATOR` ).
        lo_req->set( iv_path = `/value/S_FRONT/PATHNAME`
                     iv_val  = `/sim` ).

        IF search IS NOT INITIAL.
          lo_req->set( iv_path = `/value/S_FRONT/SEARCH`
                       iv_val  = search ).
        ENDIF.

        IF t_arg IS NOT INITIAL.
          lo_req->set( iv_path = `/value/S_FRONT/T_EVENT_ARG`
                       iv_val  = t_arg ).
        ENDIF.

        IF mo_pending IS BOUND AND mo_pending->is_empty( ) = abap_false.
          lo_req->set( iv_path = `/value/MODEL`
                       iv_val  = mo_pending ).
        ENDIF.

        result = lo_req->stringify( ).

      CATCH cx_root INTO DATA(lx).
        RAISE EXCEPTION TYPE z2ui5_cx_a2ui5_error EXPORTING val = lx.
    ENDTRY.

  ENDMETHOD.

  METHOD parse_response.

    mv_resp_json = json.
    CLEAR mv_message.

    TRY.
        DATA(lo_resp) = CAST z2ui5_if_ajson( z2ui5_cl_ajson=>parse( json ) ).
      CATCH cx_root INTO DATA(lx).
        RAISE EXCEPTION TYPE z2ui5_cx_a2ui5_error EXPORTING val = lx.
    ENDTRY.

    IF lo_resp->exists( `/S_FRONT/ID` ).
      mv_id = lo_resp->get_string( `/S_FRONT/ID` ).
    ENDIF.

    " the view XML is only sent when the view changed - keep the last one
    IF lo_resp->exists( `/S_FRONT/PARAMS/S_VIEW/XML` ).
      DATA(lv_xml) = lo_resp->get_string( `/S_FRONT/PARAMS/S_VIEW/XML` ).
      IF lv_xml IS NOT INITIAL.
        mv_view_xml = lv_xml.
      ENDIF.
    ENDIF.

    IF lo_resp->exists( `/S_FRONT/PARAMS/S_MSG_TOAST/TEXT` ).
      mv_message = lo_resp->get_string( `/S_FRONT/PARAMS/S_MSG_TOAST/TEXT` ).
    ELSEIF lo_resp->exists( `/S_FRONT/PARAMS/S_MSG_BOX/TEXT` ).
      mv_message = lo_resp->get_string( `/S_FRONT/PARAMS/S_MSG_BOX/TEXT` ).
    ENDIF.

    " the full model is only sent when the view updated, `{}` otherwise -
    " keep the last populated one so get_value stays meaningful
    IF lo_resp->exists( `/MODEL` ).
      DATA(lo_model) = lo_resp->slice( `/MODEL` ).
      IF lo_model IS BOUND AND lo_model->is_empty( ) = abap_false.
        mo_model = lo_model.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD get_view.
    result = mv_view_xml.
  ENDMETHOD.

  METHOD get_value.

    DATA(lv_path) = conv_name_to_path( name ).
    IF mo_model IS BOUND AND mo_model->exists( lv_path ).
      result = mo_model->get_string( lv_path ).
    ENDIF.

  ENDMETHOD.

  METHOD get_message.
    result = mv_message.
  ENDMETHOD.

  METHOD get_id.
    result = mv_id.
  ENDMETHOD.

  METHOD get_response_json.
    result = mv_resp_json.
  ENDMETHOD.

  METHOD conv_name_to_path.

    result = to_upper( condense( name ) ).
    IF result IS INITIAL OR result(1) <> `/`.
      result = |/{ result }|.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
