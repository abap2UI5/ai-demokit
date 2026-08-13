"! <p class="shorttext">sap.suite.ui.microchart - HarveyBallMicroChart</p>
"!
"! SAPUI5-only control: it ships with SAPUI5, not with OpenUI5, so there is no
"! demo kit original in this repo's sample universe and no 1:1 port (AGENTS §3).
"! Collected here as orientation - how the control is expressed in abap2UI5.
"!
"! SAPUI5 demo kit: https://ui5.sap.com/#/entity/sap.suite.ui.microchart.HarveyBallMicroChart
CLASS z2ui5_cl_smpc_sapui5_005 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_smpc_sapui5_005 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      DATA(view) = z2ui5_cl_xml_view=>factory( ).
      DATA(page) = view->shell(
          )->page( title          = `Harvey Chart`
                   navbuttonpress = client->_event_nav_app_leave( )
                   shownavbutton  = client->check_app_prev_stack( ) ).

      page->harvey_ball_micro_chart(
                                     size          = `L`
                                     total         = `10`
                                     totallabel    = `11`
                                     showfractions = abap_true
                                     showtotal     = abap_true
                                     totalscale    = abap_true
        )->harveyballmicrochartitem(
                                   color         = `Good`
                                   fraction      = `8`
                                   fractionscale = `Mrd`
        ).

      client->view_display( view->stringify( ) ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
