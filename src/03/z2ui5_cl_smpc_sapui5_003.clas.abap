" @keywords interactivebarchart shell tabcontainer tab grid link text griddata flexbox interactivebarchartbar verticallayout
" @summary sap.suite.ui.microchart.InteractiveBarChart expressed in abap2UI5 - a SAPUI5-only control, so the demo kit original is outside OpenUI5 and this is orientation rather than a 1:1 port.
"! <p class="shorttext">sap.suite.ui.microchart - InteractiveBarChart</p>
"!
"! SAPUI5-only control: it ships with SAPUI5, not with OpenUI5, so there is no
"! demo kit original in this repo's sample universe and no 1:1 port (AGENTS section 3).
"! Collected here as orientation - how the control is expressed in abap2UI5.
"!
"! SAPUI5 demo kit: https://ui5.sap.com/#/entity/sap.suite.ui.microchart.InteractiveBarChart/sample/sap.suite.ui.microchart.sample.InteractiveBarChart
CLASS z2ui5_cl_smpc_sapui5_003 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA sel1           TYPE abap_bool.
    DATA sel2           TYPE abap_bool.
    DATA sel3           TYPE abap_bool.
    DATA tab_bar_active TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_smpc_sapui5_003 IMPLEMENTATION.

  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE xsdboolean.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    temp1 = boolc( client->get( )-check_launchpad_active = abap_false ).
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
                )->a( n = `showHeader`     b = temp1

                )->ele( n = `TabContainer` ns = `webc`
                    )->ele( n = `Tab` ns = `webc`
                        )->a( n = `text`     v = `Bar Chart`
                        )->a( n = `selected` v = client->_bind( tab_bar_active )

                        )->ele( n = `Grid` ns = `layout`
                            )->a( n = `defaultSpan` v = `XL6 L6 M6 S12`

                            )->tag( `Link`
                                )->a( n = `text`   v = `Go to the SAP Demos for Interactive bar Charts here...`
                                )->a( n = `target` v = `_blank`
                                )->a( n = `href`   v = `https://ui5.sap.com/#/entity/sap.suite.ui.microchart.InteractiveBarChart/sample/sap.suite.ui.microchart.sample.InteractiveBarChart`

                            )->ele( `Text`
                                )->a( n = `text`  v = `Absolute and Percentage value`
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
                                    )->ele( n = `InteractiveBarChart` ns = `mchart`
                                        )->a( n = `selectionChanged` v = client->_event( `BAR_CHANGED` )
                                        )->a( n = `press`            v = client->_event( `BAR_CHANGED` )
                                        )->a( n = `labelWidth`       v = `25%`
                                        )->a( n = `displayedBars`    v = `4`

                                        )->ele( n = `bars` ns = `mchart`
                                            )->tag( n = `InteractiveBarChartBar` ns = `mchart`
                                                )->a( n = `selected`       v = client->_bind( sel1 )
                                                )->a( n = `label`          v = `Product 1`
                                                )->a( n = `value`          v = `10`

                                            )->tag( n = `InteractiveBarChartBar` ns = `mchart`
                                                )->a( n = `selected`       v = client->_bind( sel2 )
                                                )->a( n = `label`          v = `Product 2`
                                                )->a( n = `value`          v = `20`

                                            )->tag( n = `InteractiveBarChartBar` ns = `mchart`
                                                )->a( n = `selected`       v = client->_bind( sel3 )
                                                )->a( n = `label`          v = `Product 3`
                                                )->a( n = `value`          v = `70`

                                        )->end(
                                    )->end(
                                )->end(
                            )->end(

                            )->ele( `FlexBox`
                                )->a( n = `width`      v = `22rem`
                                )->a( n = `height`     v = `13rem`
                                )->a( n = `alignItems` v = `Center`
                                )->a( n = `class`      v = `sapUiSmallMargin`

                                )->ele( `items`
                                    )->ele( n = `InteractiveBarChart` ns = `mchart`
                                        )->a( n = `selectionChanged` v = client->_event( `BAR_CHANGED` )

                                        )->ele( n = `bars` ns = `mchart`
                                            )->tag( n = `InteractiveBarChartBar` ns = `mchart`
                                                )->a( n = `label`          v = `Product 1`
                                                )->a( n = `value`          v = `10`
                                                )->a( n = `displayedValue` v = `10%`

                                            )->tag( n = `InteractiveBarChartBar` ns = `mchart`
                                                )->a( n = `label`          v = `Product 2`
                                                )->a( n = `value`          v = `20`
                                                )->a( n = `displayedValue` v = `20%`

                                            )->tag( n = `InteractiveBarChartBar` ns = `mchart`
                                                )->a( n = `label`          v = `Product 3`
                                                )->a( n = `value`          v = `70`
                                                )->a( n = `displayedValue` v = `70%`

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
                                    )->a( n = `text`  v = `Positive and Negative values`
                                    )->a( n = `class` v = `sapUiSmallMargin`

                                )->ele( `FlexBox`
                                    )->a( n = `width`      v = `20rem`
                                    )->a( n = `height`     v = `10rem`
                                    )->a( n = `alignItems` v = `Center`
                                    )->a( n = `class`      v = `sapUiSmallMargin`

                                    )->ele( `items`
                                        )->ele( n = `InteractiveBarChart` ns = `mchart`
                                            )->a( n = `selectionChanged` v = client->_event( `BAR_CHANGED` )
                                            )->a( n = `press`            v = client->_event( `BAR_PRESS` )
                                            )->a( n = `labelWidth`       v = `25%`

                                            )->ele( n = `bars` ns = `mchart`
                                                )->tag( n = `InteractiveBarChartBar` ns = `mchart`
                                                    )->a( n = `label`          v = `Product 1`
                                                    )->a( n = `value`          v = `25`

                                                )->tag( n = `InteractiveBarChartBar` ns = `mchart`
                                                    )->a( n = `label`          v = `Product 2`
                                                    )->a( n = `value`          v = `-50`

                                                )->tag( n = `InteractiveBarChartBar` ns = `mchart`
                                                    )->a( n = `label`          v = `Product 3`
                                                    )->a( n = `value`          v = `-100`

                                            )->end(
                                        )->end(
                                    )->end(
                                 ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.
        DATA selected TYPE i.

    CASE client->get_event( ).

      WHEN `BAR_CHANGED`.
        " the chart's points are two-way bound, so the new selection is already
        " in the model when this fires - nothing has to be read off the event
        " counted per flag - a VALUE string_table over abap_bool fields does not
        " survive the transpiler's downported INSERT (types not compatible)
        
        selected = 0.
        IF sel1 = abap_true.
          selected = selected + 1.
        ENDIF.
        IF sel2 = abap_true.
          selected = selected + 1.
        ENDIF.
        IF sel3 = abap_true.
          selected = selected + 1.
        ENDIF.
        client->message_toast_display( |selectionChanged - { selected } of 3 selected| ).

      WHEN `BAR_PRESS`.
        client->message_toast_display( `press - the bar chart was clicked` ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
