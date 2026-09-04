" @keywords interactivedonutchart shell tabcontainer tab grid link text griddata flexbox interactivedonutchartsegment button
" @summary sap.suite.ui.microchart.InteractiveDonutChart expressed in abap2UI5 - a SAPUI5-only control, so the demo kit original is outside OpenUI5 and this is orientation rather than a 1:1 port.
"! <p class="shorttext">sap.suite.ui.microchart - InteractiveDonutChart</p>
"!
"! SAPUI5-only control: it ships with SAPUI5, not with OpenUI5, so there is no
"! demo kit original in this repo's sample universe and no 1:1 port (AGENTS section 3).
"! Collected here as orientation - how the control is expressed in abap2UI5.
"!
"! SAPUI5 demo kit: https://ui5.sap.com/#/entity/sap.suite.ui.microchart.InteractiveDonutChart/sample/sap.suite.ui.microchart.sample.InteractiveDonutChart
CLASS z2ui5_cl_smpc_sapui5_001 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_chart,
        text    TYPE string,
        percent TYPE p LENGTH 3 DECIMALS 2,
      END OF ty_s_chart.
    DATA counts           TYPE STANDARD TABLE OF ty_s_chart WITH DEFAULT KEY.
    DATA sel4             TYPE abap_bool.
    DATA sel5             TYPE abap_bool.
    DATA sel6             TYPE abap_bool.
    DATA tab_donut_active TYPE abap_bool.
    DATA total_count      TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_smpc_sapui5_001 IMPLEMENTATION.

  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

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
                        )->a( n = `text`     v = `Donut Chart`
                        )->a( n = `selected` v = client->_bind( tab_donut_active )

                        )->ele( n = `Grid` ns = `layout`
                            )->a( n = `defaultSpan` v = `XL6 L6 M6 S12`

                            )->tag( `Link`
                                )->a( n = `text`   v = `Go to the SAP Demos for Interactive Donut Charts here...`
                                )->a( n = `target` v = `_blank`
                                )->a( n = `href`   v = `https://ui5.sap.com/#/entity/sap.suite.ui.microchart.InteractiveDonutChart/sample/sap.suite.ui.microchart.sample.InteractiveDonutChart`

                            )->ele( `Text`
                                )->a( n = `text`  v = `Three segments`
                                )->a( n = `class` v = `sapUiSmallMargin`

                                )->ele( `layoutData`
                                    )->tag( n = `GridData` ns = `layout`
                                        )->a( n = `span` v = `XL12 L12 M12 S12`

                                )->end(
                            )->end(

                            )->ele( `FlexBox`
                                )->a( n = `width`          v = `22rem`
                                )->a( n = `height`         v = `13rem`
                                )->a( n = `alignItems`     v = `Start`
                                )->a( n = `justifyContent` v = `SpaceBetween`

                                )->ele( `items`
                                    )->ele( n = `InteractiveDonutChart` ns = `mchart`
                                        )->a( n = `selectionChanged` v = client->_event( `DONUT_CHANGED` )

                                        )->ele( n = `segments` ns = `mchart`
                                            )->tag( n = `InteractiveDonutChartSegment` ns = `mchart`
                                                )->a( n = `selected`       v = client->_bind( sel4 )
                                                )->a( n = `label`          v = `Impl. Phase`
                                                )->a( n = `value`          v = `40.0`
                                                )->a( n = `displayedValue` v = `40.0%`

                                            )->tag( n = `InteractiveDonutChartSegment` ns = `mchart`
                                                )->a( n = `selected`       v = client->_bind( sel5 )
                                                )->a( n = `label`          v = `Design Phase`
                                                )->a( n = `value`          v = `21.5`
                                                )->a( n = `displayedValue` v = `21.5%`

                                            )->tag( n = `InteractiveDonutChartSegment` ns = `mchart`
                                                )->a( n = `selected`       v = client->_bind( sel6 )
                                                )->a( n = `label`          v = `Test Phase`
                                                )->a( n = `value`          v = `38.5`
                                                )->a( n = `displayedValue` v = `38.5%`

                                        )->end(
                                    )->end(
                                )->end(
                            )->end(

                            )->ele( `Text`
                                )->a( n = `text`  v = `Four segments`
                                )->a( n = `class` v = `sapUiSmallMargin`

                                )->ele( `layoutData`
                                    )->tag( n = `GridData` ns = `layout`
                                        )->a( n = `span` v = `XL12 L12 M12 S12`

                                )->end(
                            )->end(

                            )->ele( `FlexBox`
                                )->a( n = `width`          v = `22rem`
                                )->a( n = `height`         v = `13rem`
                                )->a( n = `alignItems`     v = `Start`
                                )->a( n = `justifyContent` v = `SpaceBetween`

                                )->ele( `items`
                                    )->ele( n = `InteractiveDonutChart` ns = `mchart`
                                        )->a( n = `selectionChanged`  v = client->_event( `DONUT_CHANGED` )
                                        )->a( n = `press`             v = client->_event( `DONUT_PRESS` )
                                        )->a( n = `displayedSegments` v = `4`

                                        )->ele( n = `segments` ns = `mchart`
                                            )->tag( n = `InteractiveDonutChartSegment` ns = `mchart`
                                                )->a( n = `label`          v = `Design Phase`
                                                )->a( n = `value`          v = `32.0`
                                                )->a( n = `displayedValue` v = `32.0%`

                                            )->tag( n = `InteractiveDonutChartSegment` ns = `mchart`
                                                )->a( n = `label`          v = `Implementation Phase`
                                                )->a( n = `value`          v = `28`
                                                )->a( n = `displayedValue` v = `28%`

                                            )->tag( n = `InteractiveDonutChartSegment` ns = `mchart`
                                                )->a( n = `label`          v = `Test Phase`
                                                )->a( n = `value`          v = `25`
                                                )->a( n = `displayedValue` v = `25%`

                                            )->tag( n = `InteractiveDonutChartSegment` ns = `mchart`
                                                )->a( n = `label`          v = `Launch Phase`
                                                )->a( n = `value`          v = `15`
                                                )->a( n = `displayedValue` v = `15%`

                                        )->end(
                                    )->end(
                                )->end(
                            )->end(

                            )->ele( `Text`
                                )->a( n = `text`  v = `Error Messages`
                                )->a( n = `class` v = `sapUiSmallMargin`

                                )->ele( `layoutData`
                                    )->tag( n = `GridData` ns = `layout`
                                        )->a( n = `span` v = `XL12 L12 M12 S12`

                                )->end(
                            )->end(

                            )->ele( `FlexBox`
                                )->a( n = `width`          v = `22rem`
                                )->a( n = `height`         v = `13rem`
                                )->a( n = `alignItems`     v = `Start`
                                )->a( n = `justifyContent` v = `SpaceBetween`

                                )->ele( `items`
                                    )->ele( n = `InteractiveDonutChart` ns = `mchart`
                                        )->a( n = `selectionChanged`  v = client->_event( `DONUT_CHANGED` )
                                        )->a( n = `errorMessageTitle` v = `No data`
                                        )->a( n = `errorMessage`      v = `Currently no data is available`
                                        )->a( n = `showError`         b = abap_true

                                        )->ele( n = `segments` ns = `mchart`
                                            )->tag( n = `InteractiveDonutChartSegment` ns = `mchart`
                                                )->a( n = `label`          v = `Implementation Phase`
                                                )->a( n = `value`          v = `40.0`
                                                )->a( n = `displayedValue` v = `40.0%`

                                            )->tag( n = `InteractiveDonutChartSegment` ns = `mchart`
                                                )->a( n = `label`          v = `Design Phase`
                                                )->a( n = `value`          v = `21.5`
                                                )->a( n = `displayedValue` v = `21.5%`

                                            )->tag( n = `InteractiveDonutChartSegment` ns = `mchart`
                                                )->a( n = `label`          v = `Test Phase`
                                                )->a( n = `value`          v = `38.5`
                                                )->a( n = `displayedValue` v = `38.5%`

                                        )->end(
                                    )->end(
                                )->end(
                            )->end(

                            )->ele( `Text`
                                )->a( n = `text`  v = `Model Update Table Data`
                                )->a( n = `class` v = `sapUiSmallMargin`

                                )->ele( `layoutData`
                                    )->tag( n = `GridData` ns = `layout`
                                        )->a( n = `span` v = `XL12 L12 M12 S12`

                                )->end(
                            )->end(

                            )->tag( `Button`
                                )->a( n = `text`  v = `update chart`
                                )->a( n = `press` v = client->_event( `UPDATE_CHART_DATA` )

                        )->end(

                        )->ele( `FlexBox`
                            )->a( n = `width`          v = `30rem`
                            )->a( n = `height`         v = `18rem`
                            )->a( n = `alignItems`     v = `Start`
                            )->a( n = `justifyContent` v = `SpaceBetween`

                            )->ele( `items`
                                )->ele( n = `InteractiveDonutChart` ns = `mchart`
                                    )->a( n = `displayedSegments` v = client->_bind( total_count )
                                    )->a( n = `segments`          v = client->_bind( counts )

                                    )->tag( n = `InteractiveDonutChartSegment` ns = `mchart`
                                        )->a( n = `label`          v = `{TEXT}`
                                        )->a( n = `value`          v = `{PERCENT}`
                                        )->a( n = `displayedValue` v = `{PERCENT}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

  METHOD z2ui5_if_app~main.
      DATA temp1 LIKE counts.
      DATA temp2 LIKE LINE OF temp1.
      DATA temp3 LIKE counts.
      DATA temp4 LIKE LINE OF temp3.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.

      
      CLEAR temp1.
      
      temp2-text = `1st`.
      temp2-percent = `10.0`.
      INSERT temp2 INTO TABLE temp1.
      temp2-text = `2nd`.
      temp2-percent = `60.0`.
      INSERT temp2 INTO TABLE temp1.
      temp2-text = `3rd`.
      temp2-percent = `30.0`.
      INSERT temp2 INTO TABLE temp1.
      counts = temp1.
      total_count = lines( counts ).

      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).

    ELSEIF client->check_on_event( `UPDATE_CHART_DATA` ) IS NOT INITIAL.
      
      CLEAR temp3.
      
      temp4-text = `1st`.
      temp4-percent = `60.0`.
      INSERT temp4 INTO TABLE temp3.
      temp4-text = `2nd`.
      temp4-percent = `10.0`.
      INSERT temp4 INTO TABLE temp3.
      temp4-text = `3rd`.
      temp4-percent = `15.0`.
      INSERT temp4 INTO TABLE temp3.
      temp4-text = `4th`.
      temp4-percent = `15.0`.
      INSERT temp4 INTO TABLE temp3.
      counts = temp3.
      total_count = lines( counts ).

    ELSEIF client->check_on_event( `DONUT_CHANGED` ) IS NOT INITIAL.
      client->message_toast_display( `Donut selection changed` ).

    ELSEIF client->check_on_event( `DONUT_PRESS` ) IS NOT INITIAL.
      client->message_toast_display( `Donut pressed` ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
