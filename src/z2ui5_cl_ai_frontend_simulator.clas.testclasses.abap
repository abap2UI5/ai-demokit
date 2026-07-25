CLASS ltcl_frontend_simulator DEFINITION FINAL
  FOR TESTING RISK LEVEL HARMLESS DURATION MEDIUM.

  PRIVATE SECTION.
    METHODS start_renders_view    FOR TESTING.
    METHODS input_and_click       FOR TESTING.
    METHODS fluent_chaining        FOR TESTING.
    METHODS clear_event           FOR TESTING.
    METHODS unknown_app_raises    FOR TESTING.
ENDCLASS.


CLASS ltcl_frontend_simulator IMPLEMENTATION.

  METHOD start_renders_view.

    DATA(lo_sim) = z2ui5_cl_ai_frontend_simulator=>start( `Z2UI5_CL_AI_SIMULATOR_EXAMPLE` ).

    " a draft id was minted (would be sent back on the next request)
    cl_abap_unit_assert=>assert_not_initial( lo_sim->get_id( ) ).

    " the rendered view carries the app's input field and Greet button
    cl_abap_unit_assert=>assert_true( xsdbool( lo_sim->get_view( ) CS `Input` ) ).
    cl_abap_unit_assert=>assert_true( xsdbool( lo_sim->get_view( ) CS `Greet` ) ).

    " no message on a plain start
    cl_abap_unit_assert=>assert_initial( lo_sim->get_message( ) ).

  ENDMETHOD.

  METHOD input_and_click.

    DATA(lo_sim) = z2ui5_cl_ai_frontend_simulator=>start( `Z2UI5_CL_AI_SIMULATOR_EXAMPLE` ).

    lo_sim->set_value( name  = `MV_NAME`
                       value = `World` ).
    lo_sim->click( `GREET` ).

    " the value travelled to the server, the event ran, the toast came back
    cl_abap_unit_assert=>assert_equals( exp = `Hello World!`
                                        act = lo_sim->get_message( ) ).

    " and the recomputed model field is readable
    cl_abap_unit_assert=>assert_equals( exp = `Hello World!`
                                        act = lo_sim->get_value( `MV_GREETING` ) ).

  ENDMETHOD.

  METHOD fluent_chaining.

    DATA(lv_msg) = z2ui5_cl_ai_frontend_simulator=>start( `Z2UI5_CL_AI_SIMULATOR_EXAMPLE`
        )->set_value( name  = `MV_NAME`
                      value = `Bob`
        )->click( `GREET`
        )->get_message( ).

    cl_abap_unit_assert=>assert_equals( exp = `Hello Bob!`
                                        act = lv_msg ).

  ENDMETHOD.

  METHOD clear_event.

    DATA(lo_sim) = z2ui5_cl_ai_frontend_simulator=>start( `Z2UI5_CL_AI_SIMULATOR_EXAMPLE` ).

    lo_sim->set_value( name  = `MV_NAME`
                       value = `World` ).
    lo_sim->click( `GREET` ).
    lo_sim->click( `CLEAR` ).

    " CLEAR reset both bound fields, and the empty model round-tripped back
    cl_abap_unit_assert=>assert_initial( lo_sim->get_value( `MV_NAME` ) ).
    cl_abap_unit_assert=>assert_initial( lo_sim->get_value( `MV_GREETING` ) ).

  ENDMETHOD.

  METHOD unknown_app_raises.

    " a wrong app name must surface as a framework error, not a dump
    TRY.
        z2ui5_cl_ai_frontend_simulator=>start( `Z2UI5_CL_AI_APP_DOES_NOT_EXIST` ).
        cl_abap_unit_assert=>fail( `expected an error for an unknown app` ).
      CATCH z2ui5_cx_a2ui5_error ##NO_HANDLER.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
