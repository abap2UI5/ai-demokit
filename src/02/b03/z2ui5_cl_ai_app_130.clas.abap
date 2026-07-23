CLASS z2ui5_cl_ai_app_130 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA busy TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_130 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      busy = abap_false.
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`

        )->open( `Page`
            )->a( n = `class`      v = `sapUiFioriObjectPage`
            )->a( n = `showHeader` v = `false`

            )->open( `content`
                )->open( `Toolbar`
                    )->leaf( `Button`
                        )->a( n = `icon`  v = `sap-icon://action`
                        )->a( n = `text`  v = `Toggle Busy State of Both Controls`
                        )->a( n = `press` v = client->_event( `TOGGLE_BUSY` )

                )->shut(

                )->open( `Panel`
                    )->a( n = `id`                 v = `panel1`
                    )->a( n = `busy`               v = client->_bind( busy )
                    )->a( n = `busyIndicatorDelay` v = `0`
                    )->a( n = `headerText`         v = `Default BusyIndicator (No Delay)`

                    )->leaf( `ToolbarSpacer`
                    )->open( `content`
                        )->leaf( `Text`
                            )->a( n = `text` v = `Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et ` &&
                                                 `accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur ` &&
                                                 `sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. Lorem ipsum dolor sit amet, consetetur sadipscing ` &&
                                                 `elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat`

                    )->shut(
                )->shut(

                )->open( `Panel`
                    )->a( n = `id`         v = `panel2`
                    )->a( n = `headerText` v = `Small BusyIndicator (Default Delay)`

                    )->leaf( n = `Icon` ns = `core`
                        )->a( n = `id`    v = `panel2-icon`
                        )->a( n = `busy`  v = client->_bind( busy )
                        )->a( n = `src`   v = `sap-icon://nutrition-activity`
                        )->a( n = `size`  v = `3rem`
                        )->a( n = `color` v = `#DD0000` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `TOGGLE_BUSY`.
        " original onAction: sets both controls busy, then clears after 5s
        " (setTimeout). The client-side auto-reset is simplified to a toggle.
        busy = xsdbool( busy = abap_false ).
        client->view_model_update( ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
