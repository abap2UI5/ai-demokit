" @keywords sap.ui.core busyindicator toolbar button panel toolbarspacer text
CLASS z2ui5_cl_smpc_app_130 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA busy TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_130 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      busy = abap_false.
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`

        )->ele( `Page`
            )->a( n = `class`      v = `sapUiFioriObjectPage`
            )->a( n = `showHeader` v = `false`

            )->ele( `content`
                )->ele( `Toolbar`
                    )->tag( `Button`
                        )->a( n = `icon`  v = `sap-icon://action`
                        )->a( n = `text`  v = `Toggle Busy State of Both Controls`
                        )->a( n = `press` v = client->_event( `TOGGLE_BUSY` )

                )->end(

                )->ele( `Panel`
                    )->a( n = `id`                 v = `panel1`
                    )->a( n = `busy`               v = client->_bind( busy )
                    )->a( n = `busyIndicatorDelay` v = `0`
                    )->a( n = `headerText`         v = `Default BusyIndicator (No Delay)`

                    )->tag( `ToolbarSpacer`
                    )->ele( `content`
                        )->tag( `Text`
                            )->a( n = `text` v = `Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et ` &&
                                                 `accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur ` &&
                                                 `sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. Lorem ipsum dolor sit amet, consetetur sadipscing ` &&
                                                 `elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat`

                    )->end(
                )->end(

                )->ele( `Panel`
                    )->a( n = `id`         v = `panel2`
                    )->a( n = `headerText` v = `Small BusyIndicator (Default Delay)`

                    )->tag( n = `Icon` ns = `core`
                        )->a( n = `id`    v = `panel2-icon`
                        )->a( n = `busy`  v = client->_bind( busy )
                        )->a( n = `src`   v = `sap-icon://nutrition-activity`
                        )->a( n = `size`  v = `3rem`
                        )->a( n = `color` v = `#DD0000` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `TOGGLE_BUSY`.
      " original onAction: sets both controls busy, then clears after 5s
      " (setTimeout). The client-side auto-reset is simplified to a toggle.
      busy = xsdbool( busy = abap_false ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
