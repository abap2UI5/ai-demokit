"! <p class="shorttext">sap.suite.ui.microchart - InteractiveLineChart</p>
"!
"! SAPUI5-only control: it ships with SAPUI5, not with OpenUI5, so there is no
"! demo kit original in this repo's sample universe and no 1:1 port (AGENTS §3).
"! Collected here as orientation - how the control is expressed in abap2UI5.
"!
"! SAPUI5 demo kit: https://ui5.sap.com/#/entity/sap.suite.ui.microchart.InteractiveLineChart/sample/sap.suite.ui.microchart.sample.InteractiveLineChart
CLASS z2ui5_cl_dmo_sapui5_002 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA sel7            TYPE abap_bool.
    DATA sel8            TYPE abap_bool.
    DATA sel9            TYPE abap_bool.
    DATA sel10           TYPE abap_bool.
    DATA sel11           TYPE abap_bool.
    DATA sel12           TYPE abap_bool.
    DATA tab_line_active TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_dmo_sapui5_002 IMPLEMENTATION.

  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(container) = view->shell(
        )->page(
            title          = `abap2UI5 - Visualization`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( )
        )->tab_container( ).

    DATA(tab) = container->tab(
            text     = `Line Chart`
            selected = client->_bind( tab_line_active ) ).
    DATA(grid) = tab->grid( `XL6 L6 M6 S12` ).

    grid->link(
        text   = `Go to the SAP Demos for Interactive Line Charts here...`
        target = `_blank`
        href   = `https://sapui5.hana.ondemand.com/#/entity/sap.suite.ui.microchart.InteractiveLineChart/sample/sap.suite.ui.microchart.sample.InteractiveLineChart` ).

    grid->text(
            text  = `Absolute and Percentage values`
            class = `sapUiSmallMargin`
        )->get(
            )->layout_data(
                )->grid_data( `XL12 L12 M12 S12` ).

    DATA(point) = grid->flex_box(
        width      = `22rem`
        height     = `13rem`
        alignitems = `Center`
        class      = `sapUiSmallMargin`
      )->items( )->interact_line_chart(
            selectionchanged = client->_event( `LINE_CHANGED` )
            precedingpoint   = `15`
            succeedingpoint  = `89`
        )->points( ).
    point->interact_line_chart_point(
        selected       = client->_bind( sel7 )
        label          = `May`
        value          = `33.1`
        secondarylabel = `Q2` ).
    point->interact_line_chart_point(
        selected = client->_bind( sel8 )
        label    = `June`
        value    = `12` ).
    point->interact_line_chart_point(
        selected       = client->_bind( sel9 )
        label          = `July`
        value          = `51.4`
        secondarylabel = `Q3` ).
    point->interact_line_chart_point(
        selected = client->_bind( sel10 )
        label    = `Aug`
        value    = `52` ).
    point->interact_line_chart_point(
        selected = client->_bind( sel11 )
        label    = `Sep`
        value    = `69.9` ).
    point->interact_line_chart_point(
        selected       = client->_bind( sel12 )
        label          = `Oct`
        value          = `0.9`
        secondarylabel = `Q4` ).

    point = grid->flex_box(
            width      = `22rem`
            height     = `13rem`
            alignitems = `Start`
            class      = `SpaceBetween`
        )->items(
             )->interact_line_chart(
                    selectionchanged = client->_event( `LINE_CHANGED` )
                    press            = client->_event( `LINE_PRESS` )
                    precedingpoint   = `-20`
             )->points( ).
    point->interact_line_chart_point(
        label          = `May`
        value          = `33.1`
        displayedvalue = `33.1%`
        secondarylabel = `2015` ).
    point->interact_line_chart_point(
        label          = `June`
        value          = `2.2`
        displayedvalue = `2.2%`
        secondarylabel = `2015` ).
    point->interact_line_chart_point(
        label          = `July`
        value          = `51.4`
        displayedvalue = `51.4%`
        secondarylabel = `2015` ).
    point->interact_line_chart_point(
        label          = `Aug`
        value          = `19.9`
        displayedvalue = `19.9%` ).
    point->interact_line_chart_point(
        label          = `Sep`
        value          = `69.9`
        displayedvalue = `69.9%` ).
    point->interact_line_chart_point(
        label          = `Oct`
        value          = `0.9`
        displayedvalue = `9.9%` ).

    point = grid->vertical_layout(
        )->layout_data( `layout`
            )->grid_data( `XL12 L12 M12 S12`
        )->get_parent(
        )->text(
            text  = `Preselected values`
            class = `sapUiSmallMargin`
        )->flex_box(
            width      = `22rem`
            height     = `13rem`
            alignitems = `Start`
            class      = `sapUiSmallMargin`
            )->items(
                )->interact_line_chart(
                    selectionchanged = client->_event( `LINE_CHANGED` )
                    press            = client->_event( `LINE_PRESS` )
                )->points( ).
    point->interact_line_chart_point(
        label          = `May`
        value          = `33.1`
        displayedvalue = `33.1%`
        selected       = abap_true ).
    point->interact_line_chart_point(
        label          = `June`
        value          = `2.2`
        displayedvalue = `2.2%` ).
    point->interact_line_chart_point(
        label          = `July`
        value          = `51.4`
        displayedvalue = `51.4%` ).
    point->interact_line_chart_point(
        label          = `Aug`
        value          = `19.9`
        displayedvalue = `19.9%`
        selected       = abap_true ).
    point->interact_line_chart_point(
        label          = `Sep`
        value          = `69.9`
        displayedvalue = `69.9%` ).
    point->interact_line_chart_point(
        label          = `Oct`
        value          = `0.9`
        displayedvalue = `9.9%` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

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

      WHEN `LINE_CHANGED`.
        " the chart's points are two-way bound, so the new selection is already
        " in the model when this fires - nothing has to be read off the event
        " counted per flag - a VALUE string_table over abap_bool fields does not
        " survive the transpiler's downported INSERT (types not compatible)
        DATA(selected) = 0.
        IF sel7 = abap_true.
          selected = selected + 1.
        ENDIF.
        IF sel8 = abap_true.
          selected = selected + 1.
        ENDIF.
        IF sel9 = abap_true.
          selected = selected + 1.
        ENDIF.
        IF sel10 = abap_true.
          selected = selected + 1.
        ENDIF.
        IF sel11 = abap_true.
          selected = selected + 1.
        ENDIF.
        IF sel12 = abap_true.
          selected = selected + 1.
        ENDIF.
        client->message_toast_display( |selectionChanged - { selected } of 6 selected| ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
