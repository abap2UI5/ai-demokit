" @keywords radialmicrochart shell link
"! <p class="shorttext">sap.suite.ui.microchart - RadialMicroChart</p>
"!
"! SAPUI5-only control: it ships with SAPUI5, not with OpenUI5, so there is no
"! demo kit original in this repo's sample universe and no 1:1 port (AGENTS section 3).
"! Collected here as orientation - how the control is expressed in abap2UI5.
"!
"! SAPUI5 demo kit: https://ui5.sap.com/#/entity/sap.suite.ui.microchart.RadialMicroChart/sample/sap.suite.ui.microchart.sample.RadialMicroChart
"!
"! DEPRECATED as of UI5 1.135 - kept as a record of the control, not as a
"! recommendation. Check the demo kit for its successor before using it.
CLASS z2ui5_cl_smpc_sapui5_004 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA tab_radial_active TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_smpc_sapui5_004 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `RADIAL_PRESS`.
      client->message_toast_display( `press - a radial chart was clicked` ).
    ENDIF.

  ENDMETHOD.

  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `displayBlock`  v = `true`
        )->a( n = `height`        v = `100%`
        )->a( n = `xmlns`         v = `sap.m`
        )->a( n = `xmlns:mvc`     v = `sap.ui.core.mvc`
        )->a( n = `xmlns:webc`    v = `sap.ui.webc.main`
        )->a( n = `xmlns:layout`  v = `sap.ui.layout`
        )->a( n = `xmlns:mchart`  v = `sap.suite.ui.microchart`

        )->ele( `Shell`
            )->ele( `Page`
                )->a( n = `title`          v = `abap2UI5 - Visualization`
                )->a( n = `navButtonPress` v = client->_event_nav_app_leave( )
                )->a( n = `showNavButton`  b = client->check_app_prev_stack( )

                )->ele( n = `TabContainer` ns = `webc`
                    )->ele( n = `Tab` ns = `webc`
                        )->a( n = `text`     v = `Radial Chart`
                        )->a( n = `selected` v = client->_bind( tab_radial_active )

                        )->ele( n = `Grid` ns = `layout`
                            )->a( n = `defaultSpan` v = `XL12 L12 M12 S12`

                            )->tag( `Link`
                                )->a( n = `text`   v = `Go to the SAP Demos for Radial Charts here...`
                                )->a( n = `target` v = `_blank`
                                )->a( n = `href`   v = `https://ui5.sap.com/#/entity/sap.suite.ui.microchart.RadialMicroChart/sample/sap.suite.ui.microchart.sample.RadialMicroChart`

                            )->ele( n = `VerticalLayout` ns = `layout`
                                )->ele( n = `HorizontalLayout` ns = `layout`
                                    )->tag( n = `RadialMicroChart` ns = `mchart`
                                        )->a( n = `size`       v = `M`
                                        )->a( n = `percentage` v = `45`
                                        )->a( n = `press`      v = client->_event( `RADIAL_PRESS` )
                                    )->tag( n = `RadialMicroChart` ns = `mchart`
                                        )->a( n = `size`       v = `S`
                                        )->a( n = `percentage` v = `45`
                                        )->a( n = `press`      v = client->_event( `RADIAL_PRESS` )
                                )->end(

                                )->ele( n = `HorizontalLayout` ns = `layout`
                                    )->tag( n = `RadialMicroChart` ns = `mchart`
                                        )->a( n = `size`       v = `M`
                                        )->a( n = `percentage` v = `99.9`
                                        )->a( n = `press`      v = client->_event( `RADIAL_PRESS` )
                                        )->a( n = `valueColor` v = `Good`
                                    )->tag( n = `RadialMicroChart` ns = `mchart`
                                        )->a( n = `size`       v = `S`
                                        )->a( n = `percentage` v = `99.9`
                                        )->a( n = `press`      v = client->_event( `RADIAL_PRESS` )
                                        )->a( n = `valueColor` v = `Good`
                                )->end(

                                )->ele( n = `HorizontalLayout` ns = `layout`
                                    )->tag( n = `RadialMicroChart` ns = `mchart`
                                        )->a( n = `size`       v = `M`
                                        )->a( n = `percentage` v = `0`
                                        )->a( n = `press`      v = client->_event( `RADIAL_PRESS` )
                                        )->a( n = `valueColor` v = `Error`
                                    )->tag( n = `RadialMicroChart` ns = `mchart`
                                        )->a( n = `size`       v = `S`
                                        )->a( n = `percentage` v = `0`
                                        )->a( n = `press`      v = client->_event( `RADIAL_PRESS` )
                                        )->a( n = `valueColor` v = `Error`
                                )->end(

                                )->ele( n = `HorizontalLayout` ns = `layout`
                                    )->tag( n = `RadialMicroChart` ns = `mchart`
                                        )->a( n = `size`       v = `M`
                                        )->a( n = `percentage` v = `0.1`
                                        )->a( n = `press`      v = client->_event( `RADIAL_PRESS` )
                                        )->a( n = `valueColor` v = `Critical`
                                    )->tag( n = `RadialMicroChart` ns = `mchart`
                                        )->a( n = `size`       v = `S`
                                        )->a( n = `percentage` v = `0.1`
                                        )->a( n = `press`      v = client->_event( `RADIAL_PRESS` )
                                        )->a( n = `valueColor` v = `Critical` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
