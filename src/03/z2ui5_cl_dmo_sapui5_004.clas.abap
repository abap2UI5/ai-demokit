"! <p class="shorttext">sap.suite.ui.microchart - RadialMicroChart</p>
"!
"! SAPUI5-only control: it ships with SAPUI5, not with OpenUI5, so there is no
"! demo kit original in this repo's sample universe and no 1:1 port (AGENTS §3).
"! Collected here as orientation - how the control is expressed in abap2UI5.
"!
"! SAPUI5 demo kit: https://ui5.sap.com/#/entity/sap.suite.ui.microchart.RadialMicroChart/sample/sap.suite.ui.microchart.sample.RadialMicroChart
"!
"! DEPRECATED as of UI5 1.135 - kept as a record of the control, not as a
"! recommendation. Check the demo kit for its successor before using it.
CLASS z2ui5_cl_dmo_sapui5_004 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA tab_radial_active TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_dmo_sapui5_004 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `RADIAL_PRESS`.
        client->message_toast_display( `press - a radial chart was clicked` ).

    ENDCASE.

  ENDMETHOD.

  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(container) = view->shell(
        )->page(
            title          = `abap2UI5 - Visualization`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( )
        )->tab_container( ).

    DATA(grid) = container->tab(
            text     = `Radial Chart`
            selected = client->_bind( tab_radial_active )
        )->grid( `XL12 L12 M12 S12` ).

    grid->link(
        text   = `Go to the SAP Demos for Radial Charts here...`
        target = `_blank`
        href   = `https://sapui5.hana.ondemand.com/#/entity/sap.suite.ui.microchart.RadialMicroChart/sample/sap.suite.ui.microchart.sample.RadialMicroChart` ).

    grid->vertical_layout(
        )->horizontal_layout(
            )->radial_micro_chart(
                size       = `M`
                percentage = `45`
                press      = client->_event( `RADIAL_PRESS` )
            )->radial_micro_chart(
                size       = `S`
                percentage = `45`
                press      = client->_event( `RADIAL_PRESS` )
        )->get_parent(
        )->horizontal_layout(
            )->radial_micro_chart(
                size       = `M`
                percentage = `99.9`
                press      = client->_event( `RADIAL_PRESS` )
                valuecolor = `Good`
            )->radial_micro_chart(
                size       = `S`
                percentage = `99.9`
                press      = client->_event( `RADIAL_PRESS` )
                valuecolor = `Good`
        )->get_parent(
        )->horizontal_layout(
            )->radial_micro_chart(
                size       = `M`
                percentage = `0`
                press      = client->_event( `RADIAL_PRESS` )
                valuecolor = `Error`
            )->radial_micro_chart(
                size       = `S`
                percentage = `0`
                press      = client->_event( `RADIAL_PRESS` )
                valuecolor = `Error`
        )->get_parent(
        )->horizontal_layout(
            )->radial_micro_chart(
                size       = `M`
                percentage = `0.1`
                press      = client->_event( `RADIAL_PRESS` )
                valuecolor = `Critical`
            )->radial_micro_chart(
                size       = `S`
                percentage = `0.1`
                press      = client->_event( `RADIAL_PRESS` )
                valuecolor = `Critical` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
