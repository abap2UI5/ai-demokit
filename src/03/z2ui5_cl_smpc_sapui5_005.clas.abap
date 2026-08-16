"! <p class="shorttext">sap.suite.ui.microchart - HarveyBallMicroChart</p>
"!
"! SAPUI5-only control: it ships with SAPUI5, not with OpenUI5, so there is no
"! demo kit original in this repo's sample universe and no 1:1 port (AGENTS section 3).
"! Collected here as orientation - how the control is expressed in abap2UI5.
"!
"! SAPUI5 demo kit: https://ui5.sap.com/#/entity/sap.suite.ui.microchart.HarveyBallMicroChart
CLASS z2ui5_cl_smpc_sapui5_005 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_smpc_sapui5_005 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `displayBlock`  v = `true`
        )->a( n = `height`        v = `100%`
        )->a( n = `xmlns`         v = `sap.m`
        )->a( n = `xmlns:mvc`     v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core`    v = `sap.ui.core`
        )->a( n = `xmlns:mchart`  v = `sap.suite.ui.microchart`

        )->ele( `Shell`
            )->ele( `Page`
                )->a( n = `title`          v = `Harvey Chart`
                )->a( n = `navButtonPress` v = client->_event_nav_app_leave( )
                )->a( n = `showNavButton`  b = client->check_app_prev_stack( )

                )->ele( n = `HarveyBallMicroChart` ns = `mchart`
                    )->a( n = `size`          v = `L`
                    )->a( n = `total`         v = `10`
                    )->a( n = `totalLabel`    v = `11`
                    )->a( n = `totalScale`    v = `true`
                    )->a( n = `showFractions` b = abap_true
                    )->a( n = `showTotal`     b = abap_true

                    )->tag( n = `HarveyBallMicroChartItem` ns = `mchart`
                        )->a( n = `color`         v = `Good`
                        )->a( n = `fraction`      v = `8`
                        )->a( n = `fractionScale` v = `Mrd` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
