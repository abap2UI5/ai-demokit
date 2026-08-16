"! <p class="shorttext">sap.suite.ui.microchart - InteractiveLineChart</p>
"!
"! SAPUI5-only control: it ships with SAPUI5, not with OpenUI5, so there is no
"! demo kit original in this repo's sample universe and no 1:1 port (AGENTS section 3).
"! Collected here as orientation - how the control is expressed in abap2UI5.
"!
"! SAPUI5 demo kit: https://ui5.sap.com/#/entity/sap.suite.ui.microchart.InteractiveLineChart/sample/sap.suite.ui.microchart.sample.InteractiveLineChart
CLASS z2ui5_cl_smpc_sapui5_002 DEFINITION PUBLIC.

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

CLASS z2ui5_cl_smpc_sapui5_002 IMPLEMENTATION.

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
                        )->a( n = `text`     v = `Line Chart`
                        )->a( n = `selected` v = client->_bind( tab_line_active )

                        )->ele( n = `Grid` ns = `layout`
                            )->a( n = `defaultSpan` v = `XL6 L6 M6 S12`

                            )->tag( `Link`
                                )->a( n = `text`   v = `Go to the SAP Demos for Interactive Line Charts here...`
                                )->a( n = `target` v = `_blank`
                                )->a( n = `href`   v = `https://ui5.sap.com/#/entity/sap.suite.ui.microchart.InteractiveLineChart/sample/sap.suite.ui.microchart.sample.InteractiveLineChart`

                            )->ele( `Text`
                                )->a( n = `text`  v = `Absolute and Percentage values`
                                )->a( n = `class` v = `sapUiSmallMargin`

                                )->ele( `layoutData`
                                    )->tag( n = `GridData` ns = `layout`
                                        )->a( n = `span` v = `XL12 L12 M12 S12`

                                )->end(
                            )->end(

                            )->ele( `FlexBox`
                                )->a( n = `width`      v = `22rem`
                                )->a( n = `height`     v = `13rem`
                                )->a( n = `alignItems` v = `Center`
                                )->a( n = `class`      v = `sapUiSmallMargin`

                                )->ele( `items`
                                    )->ele( n = `InteractiveLineChart` ns = `mchart`
                                        )->a( n = `selectionChanged` v = client->_event( `LINE_CHANGED` )
                                        )->a( n = `precedingPoint`   v = `15`
                                        )->a( n = `succeedingPoint`  v = `89`

                                        )->ele( n = `points` ns = `mchart`
                                            )->tag( n = `InteractiveLineChartPoint` ns = `mchart`
                                                )->a( n = `selected`       v = client->_bind( sel7 )
                                                )->a( n = `label`          v = `May`
                                                )->a( n = `value`          v = `33.1`
                                                )->a( n = `secondaryLabel` v = `Q2`

                                            )->tag( n = `InteractiveLineChartPoint` ns = `mchart`
                                                )->a( n = `selected`       v = client->_bind( sel8 )
                                                )->a( n = `label`          v = `June`
                                                )->a( n = `value`          v = `12`

                                            )->tag( n = `InteractiveLineChartPoint` ns = `mchart`
                                                )->a( n = `selected`       v = client->_bind( sel9 )
                                                )->a( n = `label`          v = `July`
                                                )->a( n = `value`          v = `51.4`
                                                )->a( n = `secondaryLabel` v = `Q3`

                                            )->tag( n = `InteractiveLineChartPoint` ns = `mchart`
                                                )->a( n = `selected`       v = client->_bind( sel10 )
                                                )->a( n = `label`          v = `Aug`
                                                )->a( n = `value`          v = `52`

                                            )->tag( n = `InteractiveLineChartPoint` ns = `mchart`
                                                )->a( n = `selected`       v = client->_bind( sel11 )
                                                )->a( n = `label`          v = `Sep`
                                                )->a( n = `value`          v = `69.9`

                                            )->tag( n = `InteractiveLineChartPoint` ns = `mchart`
                                                )->a( n = `selected`       v = client->_bind( sel12 )
                                                )->a( n = `label`          v = `Oct`
                                                )->a( n = `value`          v = `0.9`
                                                )->a( n = `secondaryLabel` v = `Q4`

                                        )->end(
                                    )->end(
                                )->end(
                            )->end(

                            )->ele( `FlexBox`
                                )->a( n = `width`      v = `22rem`
                                )->a( n = `height`     v = `13rem`
                                )->a( n = `alignItems` v = `Start`
                                )->a( n = `class`      v = `SpaceBetween`

                                )->ele( `items`
                                    )->ele( n = `InteractiveLineChart` ns = `mchart`
                                        )->a( n = `selectionChanged` v = client->_event( `LINE_CHANGED` )
                                        )->a( n = `press`            v = client->_event( `LINE_PRESS` )
                                        )->a( n = `precedingPoint`   v = `-20`

                                        )->ele( n = `points` ns = `mchart`
                                            )->tag( n = `InteractiveLineChartPoint` ns = `mchart`
                                                )->a( n = `label`          v = `May`
                                                )->a( n = `value`          v = `33.1`
                                                )->a( n = `displayedValue` v = `33.1%`
                                                )->a( n = `secondaryLabel` v = `2015`

                                            )->tag( n = `InteractiveLineChartPoint` ns = `mchart`
                                                )->a( n = `label`          v = `June`
                                                )->a( n = `value`          v = `2.2`
                                                )->a( n = `displayedValue` v = `2.2%`
                                                )->a( n = `secondaryLabel` v = `2015`

                                            )->tag( n = `InteractiveLineChartPoint` ns = `mchart`
                                                )->a( n = `label`          v = `July`
                                                )->a( n = `value`          v = `51.4`
                                                )->a( n = `displayedValue` v = `51.4%`
                                                )->a( n = `secondaryLabel` v = `2015`

                                            )->tag( n = `InteractiveLineChartPoint` ns = `mchart`
                                                )->a( n = `label`          v = `Aug`
                                                )->a( n = `value`          v = `19.9`
                                                )->a( n = `displayedValue` v = `19.9%`

                                            )->tag( n = `InteractiveLineChartPoint` ns = `mchart`
                                                )->a( n = `label`          v = `Sep`
                                                )->a( n = `value`          v = `69.9`
                                                )->a( n = `displayedValue` v = `69.9%`

                                            )->tag( n = `InteractiveLineChartPoint` ns = `mchart`
                                                )->a( n = `label`          v = `Oct`
                                                )->a( n = `value`          v = `0.9`
                                                )->a( n = `displayedValue` v = `9.9%`

                                        )->end(
                                    )->end(
                                )->end(
                            )->end(

                            )->ele( n = `VerticalLayout` ns = `layout`
                                )->ele( n = `layoutData` ns = `layout`
                                    )->tag( n = `GridData` ns = `layout`
                                        )->a( n = `span` v = `XL12 L12 M12 S12`

                                )->end(

                                )->tag( `Text`
                                    )->a( n = `text`  v = `Preselected values`
                                    )->a( n = `class` v = `sapUiSmallMargin`

                                )->ele( `FlexBox`
                                    )->a( n = `width`      v = `22rem`
                                    )->a( n = `height`     v = `13rem`
                                    )->a( n = `alignItems` v = `Start`
                                    )->a( n = `class`      v = `sapUiSmallMargin`

                                    )->ele( `items`
                                        )->ele( n = `InteractiveLineChart` ns = `mchart`
                                            )->a( n = `selectionChanged` v = client->_event( `LINE_CHANGED` )
                                            )->a( n = `press`            v = client->_event( `LINE_PRESS` )

                                            )->ele( n = `points` ns = `mchart`
                                                )->tag( n = `InteractiveLineChartPoint` ns = `mchart`
                                                    )->a( n = `label`          v = `May`
                                                    )->a( n = `value`          v = `33.1`
                                                    )->a( n = `displayedValue` v = `33.1%`
                                                    )->a( n = `selected`       b = abap_true

                                                )->tag( n = `InteractiveLineChartPoint` ns = `mchart`
                                                    )->a( n = `label`          v = `June`
                                                    )->a( n = `value`          v = `2.2`
                                                    )->a( n = `displayedValue` v = `2.2%`

                                                )->tag( n = `InteractiveLineChartPoint` ns = `mchart`
                                                    )->a( n = `label`          v = `July`
                                                    )->a( n = `value`          v = `51.4`
                                                    )->a( n = `displayedValue` v = `51.4%`

                                                )->tag( n = `InteractiveLineChartPoint` ns = `mchart`
                                                    )->a( n = `label`          v = `Aug`
                                                    )->a( n = `value`          v = `19.9`
                                                    )->a( n = `displayedValue` v = `19.9%`
                                                    )->a( n = `selected`       b = abap_true

                                                )->tag( n = `InteractiveLineChartPoint` ns = `mchart`
                                                    )->a( n = `label`          v = `Sep`
                                                    )->a( n = `value`          v = `69.9`
                                                    )->a( n = `displayedValue` v = `69.9%`

                                                )->tag( n = `InteractiveLineChartPoint` ns = `mchart`
                                                    )->a( n = `label`          v = `Oct`
                                                    )->a( n = `value`          v = `0.9`
                                                    )->a( n = `displayedValue` v = `9.9%`

                                            )->end(
                                        )->end(
                                    )->end(
                                )->end( ).

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

      WHEN `LINE_PRESS`.
        client->message_toast_display( `press - a point of the line chart was clicked` ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
