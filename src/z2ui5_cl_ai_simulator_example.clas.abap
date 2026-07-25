"! Example app for z2ui5_cl_ai_frontend_simulator.
"!
"! A minimal, self-contained abap2UI5 app - one input, one output text and two
"! buttons - that exists purely to be driven by the headless simulator. Its
"! unit tests (in z2ui5_cl_ai_frontend_simulator.clas.testclasses) show how a
"! full user session - type a name, press a button, read the result back - is
"! reproduced on the server without a browser.
"!
"! Bound names an external driver addresses it by:
"!   MV_NAME     - the input value      ( _bind )
"!   MV_GREETING - the output text      ( _bind )
"!   GREET       - build+show greeting  ( _event )
"!   CLEAR       - reset both fields    ( _event )
CLASS z2ui5_cl_ai_simulator_example DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mv_name     TYPE string.
    DATA mv_greeting TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_simulator_example IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      view_display( ).

    ELSEIF client->check_on_event( `GREET` ).
      mv_greeting = |Hello { mv_name }!|.
      client->message_toast_display( mv_greeting ).
      client->view_model_update( ).

    ELSEIF client->check_on_event( `CLEAR` ).
      CLEAR mv_name.
      CLEAR mv_greeting.
      client->view_model_update( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->open( `Page`
            )->a( n = `title` v = `Simulator Example`

            )->open( `content`
                )->open( `VBox`
                    )->a( n = `class` v = `sapUiContentPadding`

                    )->leaf( `Input`
                        )->a( n = `value`       v = client->_bind( mv_name )
                        )->a( n = `placeholder` v = `Enter your name`

                    )->leaf( `Text`
                        )->a( n = `text`  v = client->_bind( mv_greeting )
                        )->a( n = `class` v = `sapUiSmallMarginTop`

                    )->leaf( `Button`
                        )->a( n = `text`  v = `Greet`
                        )->a( n = `press` v = client->_event( `GREET` )

                    )->leaf( `Button`
                        )->a( n = `text`  v = `Clear`
                        )->a( n = `press` v = client->_event( `CLEAR` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
